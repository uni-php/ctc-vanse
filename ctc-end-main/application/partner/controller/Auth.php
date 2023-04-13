<?php
/**
 * Created by PhpStorm.
 * Role: wenhan
 * Date: 2021/10/19
 * Time: 下午11:08
 */

namespace app\partner\controller;
use app\Request;
use app\common\JsonService;
use app\common\UserToken;
use think\Db;
use think\Controller;

class Auth extends JsonService
{
    public function login(Request $request)
    {
        $user = Db::name('partner')->where('account', $request->param('account'))->find();
        if ($user) {
            if ($user['password'] !== md5($request->param('password')))
                return $this->fail('账号或密码错误');
        } else {
            return $this->fail('账号或密码错误');
        }
        if ($user['status'] == 1)
            return $this->fail('已被禁止，请联系管理员');
        $user['uid']=$user['id'];
        $user['identity']='partner';//合伙人
        $token = UserToken::createToken($user, $request->ip());
        if ($token) {
            return $this->success('登录成功', ['token' => $token['token'], 'expires_time' => $token['expires_time']]);
        } else {
            return $this->fail('登录失败');
        }
    }
    public function logout(Request $request){
        $token = trim(ltrim($request->header('Authori-zation'), 'Bearer'));
        if(!$token)  $token = trim(ltrim($request->header('Authorization'), 'Bearer'));
        $uid=Db::name('partner_token')->where('token',$token)->value('uid');
        $res=Db::name('partner_token')
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
        $treeMenu=new \app\main\controller\Menu();
        //查询可用路由
        $menu=Db::name('partner_menu')
            ->where('menuType','<>','F')
            ->where('status',0)
            ->where('visible',0)
            ->order('orderNum','asc')
            ->field('menuId as id,menuName as label,parentId,component,path,icon,menuName,isCache,isFrame')
            ->select();
        //匹配菜单生成路由
        foreach ($menu as $key =>$value){
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
    //合伙人无权限机制
    public function getUserInfo(Request $request){
        $userInfo=$request->userInfo();
        //获取用户权限
        if($userInfo){
            $res=[
                'code'=>200,
                'data'=>$userInfo,
            ];
        }else{
            $res=[
                'code'=>404,
                'msg'=>'查询失败'
            ];
        }
        return json($res);
    }

    /**
     * @param Request $request
     * 合伙人级别
     */
    public function listLevel(Request $request){
        $params=$request->get();
        $list=Db::name('partner_level')
            ->where('level_name','like','%'.$params['level_name'].'%')
            ->page($params['pageNum'])
            ->limit($params['pageSize'])
            ->select();
        $total=Db::name('partner_level')
            ->where('level_name','like','%'.$params['level_name'].'%')
            ->count();
        $res=[
            'code'=>200,
            'msg'=>'查询成功',
            'data'=>$list,
            'total'=>$total,
        ];
        return json($res);
    }
}