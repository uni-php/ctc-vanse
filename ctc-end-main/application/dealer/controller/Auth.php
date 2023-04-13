<?php
/**
 * Created by PhpStorm.
 * Role: wenhan
 * Date: 2021/11/11
 * Time: 下午3:32
 */

namespace app\dealer\controller;
use app\Request;
use app\common\JsonService;
use app\common\UserToken;
use think\Controller;
use think\Db;
class Auth extends JsonService
{
    public function login(Request $request){
        //判断登录用户是否是品牌商的子账号
        $user = Db::name('dealer')->where('account', $request->param('account'))->find();
        if(!$user) {$user = Db::name('dealer_user')->where('account', $request->param('account'))->find();}
        if ($user) {
            if ($user['password'] !== md5($request->param('password')))
                return $this->fail('账号或密码错误');
        } else {
            return $this->fail('账号或密码错误');
        }
        if ($user['status'] == 0)
            return $this->fail('当前账号未授权');
        if($user['status'] == 2||$user['status'] == 3)
            return $this->fail('已被禁用，请联系管理员');
        $user['uid']=$user['id'];
        $user['identity']='dealer';//品牌商
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
        $user=Db::name('dealer_token')->where('token',$token)->find();
        if(!$user['dealer_id']){
            $res=Db::name('dealer_token')
                ->where('uid',$user['uid'])
                ->delete();
        }else{
            $res=Db::name('dealer_token')
                ->where('uid',$user['uid'])
                ->where('dealer_id',$user['dealer_id'])
                ->delete();
        }
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
        //获取用户角色id 主品牌商角色id为空
        $roleIds=array_key_exists('roleIds',$request->userInfo());//单选 唯一
        //获取menuids
        if($roleIds){
            $menuIds=Db::name('dealer_role')->where('roleId',$roleIds)->value('menuIds');
        }
        $menu=Db::name('dealer_menu')
            ->where('menuType','<>','F')
            ->where('status',0)
            ->where('visible',0)
            ->order('orderNum','asc')
            ->field('menuId as id,menuName as label,parentId,component,path,icon,menuName,isCache,isFrame')
            ->select();
        //匹配菜单生成路由
        foreach ($menu as $key =>$value){
            if($roleIds){
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
            }else {
                //查询所有的路由
                //过滤路由
                $module=Db::name('dealer')
                    ->where('id',$request->userInfo()['id'])
                    ->value('module');
                $app_id=Db::name('dealer_menu')
                    ->where('menuName','应用')
                    ->value('menuId');
                $module=json_decode($module,true);
                $module_name=[];
                foreach ($module as $k=>$val){
                    array_push($module_name,$val['module_name']);
                }
                if ($value['parentId'] == 0) {
                    $menu[$key]['component'] = 'Layout';
                    $menu[$key]['path'] = '/' . $value['path'];
                    $menu[$key]['redirect'] = 'noRedirect';
                    $menu[$key]['alwaysShow'] = true;
                }
                if ($value['parentId'] != 0 && !$value['component']) {
                    $menu[$key]['component'] = 'ParentView';
                    $menu[$key]['redirect'] = 'noRedirect';
                }
                $menu[$key]['name'] = ucfirst($value['path']);
                if(in_array($menu[$key]['label'],$module_name)){
                    $menu[$key]['hidden'] = false;
                }else {
                    //隐藏应用中的模块
                    if($menu[$key]['parentId']==$app_id){
                        $menu[$key]['hidden'] = true;
                    }
                }
                $menu[$key]['meta']['icon'] = $value['icon'];
                $menu[$key]['meta']['title'] = $value['menuName'];
                $menu[$key]['meta']['link'] = $value['isFrame'] == 1 ? null : $value['path'];
                $menu[$key]['meta']['noCache'] = $value['isCache'] == 0 ? false : true;
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
    //品牌商用户信息
    public function getUserInfo(Request $request){
        $userInfo=$request->userInfo();
        $dealer_id=array_key_exists('dealer_id',$userInfo)?$userInfo['dealer_id']:$userInfo['id'];
        $role=Db::name('dealer_role')->where('dealerId',$dealer_id)->select();
        $roles=[];//用户角色标识 每个用户只有一个角色
        if(array_key_exists('roleIds',$userInfo)){
            $rolesIds=explode(",",$userInfo['roleIds']);
            foreach ($rolesIds as $key=>$value){
                foreach ($role as $k=>$v){
                    if($value==$v['roleId'])
                    {
                        array_push($roles,$v['roleKey']);
                    }
                }
            }//查找用户的权限
            $menuIds=Db::name('dealer_role')->where('roleId',$rolesIds[0])->value('menuIds');
            $permissions=Db::name('menu')
                ->where('menuId','in',$menuIds)
                ->where('menuType','F')
                ->column('perms');
        }else{
            array_push($roles,'default');//品牌商主账号 默认全部角色
            $permissions=['"*:*:*"'];//默认全部权限
        }
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