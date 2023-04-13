<?php
/**
 * Created by PhpStorm.
 * Role: wenhan
 * Date: 2021/10/4
 * Time: 下午11:57
 */

namespace app\main\controller;
use think\Controller;
use app\main\controller\Menu;
use app\common\JsonService;
use app\common\UserToken;
use think\Db;
use app\Request;
use Jenssegers\Agent\Agent;
use Ip2Region;

class Auth extends JsonService
{
    //系统登录
    public function login(Request $request){
        $agent = new Agent();
        $ip2region = new Ip2Region();
        $address = $ip2region->btreeSearch($request->ip());
        $address=explode("|",$address['region']);
        $user=Db::name('user')->where('account',$request->param('account'))->find();
        if($user){
            if ($user['password'] !== md5($request->param('password')))
                return $this->fail('账号或密码错误');
        }else{
            return $this->fail('账号或密码错误');
        }
        if ($user['status']==1)
            return $this->fail('已被禁止，请联系管理员');
        $user['identity']='user';//总后台管理员
        $token=UserToken::createToken($user,$request->ip());
        if($token){
            //写日志
            Db::name('login_log')
                ->insert([
                    'username'=>$user['username'],
                    'account'=>$user['account'],
                    'ip_address'=>$request->ip(),
                    'browser'=>$agent->browser(),
                    'operating_system'=>$agent->platform(),
                    'status'=>0,
                    'address'=>$address[2].$address[3]
                ]);
            return $this->success('登录成功', ['token' => $token['token'], 'expires_time' => $token['expires_time']]);
        }else{
            Db::name('login_log')
                ->insert([
                    'username'=>$user['username'],
                    'account'=>$user['account'],
                    'ip_address'=>$request->ip(),
                    'browser'=>$agent->browser(),
                    'operating_system'=>$agent->platform(),
                    'status'=>1,
                    'address'=>$address[2].$address[3]
                ]);
            return $this->fail('登录失败');
        }

    }
    //退出系统
    public function logout(Request $request){
        $token = trim(ltrim($request->header('Authori-zation'), 'Bearer'));
        if(!$token)  $token = trim(ltrim($request->header('Authorization'), 'Bearer'));
        $uid=Db::name('user_token')->where('token',$token)->value('uid');
        $res=Db::name('user_token')
            ->where('uid',$uid)
            ->delete();
        if($res){
            $res=[
                'code'=>200,
                'msg'=>'退出成功'
            ];
        }else{
            $res=[
                'code'=>404,
                'msg'=>'退出失败'
            ];
        }
        return json($res);
    }
    //获取路由
    public function getRoute(Request $request){
        $treeMenu=new Menu();
        //获取用户角色id
        $roleIds=$request->userInfo()['roleIds'];//单选 唯一
        //获取menuids
        $menuIds=Db::name('role')->where('roleId',$roleIds)->value('menuIds');
        //查询可用路由
        $menu=Db::name('menu')
            ->where('menuType','<>','F')
            ->where('status',0)
            ->where('visible',0)
            ->field('menuId as id,menuName as label,parentId,component,path,icon,menuName,isCache,isFrame')
            ->select();
        //匹配菜单生成路由
        foreach ($menu as $key =>$value){
            if(in_array($value['id'],explode(",",$menuIds))){
                if($value['parentId']==0){
                    $menu[$key]['component']='Layout';
                    $menu[$key]['path']='/'.$value['path'];
                    $menu[$key]['redirect']='noRedirect';
                    $menu[$key]['alwaysShow']=true;
                }
                if($value['parentId']!=0&&!$value['component']){
                    $menu[$key]['component']='ParentView';
                    $menu[$key]['redirect']='noRedirect';
                }
                $menu[$key]['name']=ucfirst($value['path']);
                $menu[$key]['hidden']=false;
                $menu[$key]['meta']['icon']=$value['icon'];
                $menu[$key]['meta']['title']=$value['menuName'];
                $menu[$key]['meta']['link']=$value['isFrame']==1?null:$value['path'];
                $menu[$key]['meta']['noCache']=$value['isCache']==0?false:true;

            }else{
                unset($menu[$key]);
            }
        }
        //格式化路由
        $route=$treeMenu->tree($menu,0);
        $res=[
            'code'=>200,
            'data'=>$route,
            'msg'=>'查询成功'
        ];
        return json($res);
    }
    //获取用户信息
    public function getUserInfo(Request $request){
        $uid=$request->userInfo()['uid'];
        $userInfo=Db::name('user')->where('uid',$uid)->find();
        $role=Db::name('role')->select();
        $rolesIds=explode(",",$userInfo['roleIds']);
        $roles=[];//用户角色标识 每个用户只有一个角色
        foreach ($rolesIds as $key=>$value){
            foreach ($role as $k=>$v){
                if($value==$v['roleId'])
                {
                    array_push($roles,$v['roleKey']);
                }
            }
        }
        //查找用户的权限
        $menuIds=Db::name('role')->where('roleId',$rolesIds[0])->value('menuIds');
        $permissions=Db::name('menu')
            ->where('menuId','in',$menuIds)
            ->where('menuType','F')
            ->column('perms');
        //获取用户权限
        if($userInfo){
            $res=[
              'code'=>200,
              'data'=>$userInfo,
              'permissions'=>$permissions,
              'roles'=>$roles,
              'msg'=>'查询成功'
            ];
        }else{
            $res=[
                'code'=>404,
                'msg'=>'查询失败'
            ];
        }
        return json($res);
    }
}