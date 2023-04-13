<?php
/**
 * Created by PhpStorm.
 * User: wenhan
 * Date: 2021/11/13
 * Time: 下午10:01
 */

namespace app\dealer\controller\system;
use think\Controller;
use think\Db;
use app\Request;
use think\facade\Hook;

class User extends Controller
{
    public function listUser(Request $request){
        $params=$request->get();
        $userInfo=$request->userInfo();
        $dealer_id=array_key_exists('dealer_id',$userInfo)?$userInfo['dealer_id']:$userInfo['id'];
        $list=Db::name('dealer_user')
            ->where('username','like','%'.$params['username'].'%')
            ->where('account','like','%'.$params['account'].'%')
            ->where('status','like','%'.$params['status'].'%')
            ->order('create_time','asc')
            ->where('dealer_id',$dealer_id)
            ->page($params['pageNum'])
            ->limit($params['pageSize'])
            ->select();
        $total=Db::name('dealer_user')
            ->where('username','like','%'.$params['username'].'%')
            ->where('account','like','%'.$params['account'].'%')
            ->where('status','like','%'.$params['status'].'%')
            ->where('dealer_id',$dealer_id)
            ->count();
        $res=[
            'code'=>200,
            'msg'=>'查询成功',
            'rows'=>$list,
            'total'=>$total
        ];
        return json($res);
    }
    public function getUser(Request $request){
        $uid=$request->param('id');
        $userInfo=$request->userInfo();
        $dealer_id=array_key_exists('dealer_id',$userInfo)?$userInfo['dealer_id']:$userInfo['id'];
        $roles=Db::name('dealer_role')
            ->where('dealerId',$dealer_id)
            ->where('status','0')
            ->select();
        if($uid){
            $data=Db::name('dealer_user')
                ->where('id',$uid)
                ->find();
        }
        $res=[
            'code'=>200,
            'msg'=>'查询成功',
            'roles'=>$roles,
            'data'=>$uid?$data:[]
        ];
        return json($res);
    }
    public function addUser(Request $request){
        $data=$request->get();
        $address = $request->address();
        $uid=array_key_exists('id',$data);
        $data['roleIds']=implode(",",$data['roleIds']);
        $userInfo=$request->userInfo();
        $dealer_id=array_key_exists('dealer_id',$userInfo)?$userInfo['dealer_id']:$userInfo['id'];
        $data['dealer_id']=$dealer_id;
        if($uid){
            unset($data['password']);
            Db::name('dealer_user')
                ->update($data);
            $log=[
                'module_name'=>'用户管理',
                'operator'=>$request->userInfo()['account'],
                'ip'=>$request->ip(),
                'address'=>$address[2].$address[3],
                'operate_type'=>'2',
                'operate_event'=>'更新用户',
                'dealer_id'=>$dealer_id
            ];
            Hook::listen('dealer_op_log',$log);
            $info=[
                'code'=>200,
                'msg'=>'更新成功'
            ];
        }else{
            $data['password']=md5($data['password']);
            $code=Db::name('dealer_user')
                ->insert($data);
            if($code){
                $log=[
                    'module_name'=>'用户管理',
                    'operator'=>$request->userInfo()['account'],
                    'ip'=>$request->ip(),
                    'address'=>$address[2].$address[3],
                    'operate_type'=>'1',
                    'operate_event'=>'新增用户',
                    'dealer_id'=>$dealer_id
                ];
                Hook::listen('dealer_op_log',$log);
                $info=[
                    'code'=>200,
                    'msg'=>'新增成功'
                ];
            }else{
                $info=[
                    'code'=>201,
                    'msg'=>'系统异常'
                ];
            }
        }
        return json($info);
    }
    public function deleUser(Request $request){
        $ids=$request->get();
        $address = $request->address();
        $userInfo=$request->userInfo();
        $dealer_id=array_key_exists('dealer_id',$userInfo)?$userInfo['dealer_id']:$userInfo['id'];
        $ids=explode(",",$ids['ids']);
        $res=Db::name('dealer_user')->delete($ids);
        if($res){
            $log=[
                'module_name'=>'用户管理',
                'operator'=>$request->userInfo()['account'],
                'ip'=>$request->ip(),
                'address'=>$address[2].$address[3],
                'operate_type'=>'3',
                'operate_event'=>'删除用户',
                'dealer_id'=>$dealer_id
            ];
            Hook::listen('dealer_op_log',$log);
            $info=[
                'code'=>200,
                'msg'=>'删除成功'
            ];
        }else{
            $info=[
                'code'=>201,
                'msg'=>'删除失败'
            ];
        }
        return json($info);
    }
    public function changeStatus(Request $request){
        $params=$request->get();
        $address = $request->address();
        $userInfo=$request->userInfo();
        $dealer_id=array_key_exists('dealer_id',$userInfo)?$userInfo['dealer_id']:$userInfo['id'];
        $code=Db::name('dealer_user')
            ->update($params);
        if($code){
            $log=[
                'module_name'=>'用户管理',
                'operator'=>$request->userInfo()['account'],
                'ip'=>$request->ip(),
                'address'=>$address[2].$address[3],
                'operate_type'=>'2',
                'operate_event'=>'更新用户状态',
                'dealer_id'=>$dealer_id
            ];
            Hook::listen('dealer_op_log',$log);
            $info=[
                'code'=>200,
                'msg'=>'更新成功'
            ];
        }else{
            $info=[
                'code'=>201,
                'msg'=>'系统异常'
            ];
        }
        return json($info);
    }
    public function resetPwd(Request $request){
        $params=$request->get();
        $address = $request->address();
        $userInfo=$request->userInfo();
        $dealer_id=array_key_exists('dealer_id',$userInfo)?$userInfo['dealer_id']:$userInfo['id'];
        $code=Db::name('dealer_user')
            ->where('id',$params['id'])
            ->update([
                'password'=>md5($params['password'])
            ]);
        $log=[
            'module_name'=>'用户管理',
            'operator'=>$request->userInfo()['account'],
            'ip'=>$request->ip(),
            'address'=>$address[2].$address[3],
            'operate_type'=>'2',
            'operate_event'=>'重置用户密码',
            'dealer_id'=>$dealer_id
        ];
        Hook::listen('dealer_op_log',$log);
        $info=[
            'code'=>200,
            'msg'=>'更新成功'
        ];
        return json($info);
    }
    public function resetPwds(Request $request){
        $params=$request->get();
        $userInfo=$request->userInfo();
        if(array_key_exists('dealer_id',$userInfo)){
            //更新dealer_user表
            $dealer=Db::name('dealer_user')->where('id',$userInfo['id'])->find();
            if($dealer['password']!=trim(md5($params['password']))){
                $info=[
                    'code'=>201,
                    'msg'=>'原始密码不正确'
                ];
            }else{
                $res=Db::name('dealer_user')
                    ->where('id',$userInfo['id'])
                    ->update([
                        'password'=>md5($params['new_pwd'])
                    ]);
                if($res||$res==0){
                    $info=[
                        'code'=>200,
                        'msg'=>'更改成功'
                    ];
                }else{
                    $info=[
                        'code'=>201,
                        'msg'=>'请联系管理员'
                    ];
                }
            }
        }else{
            //更新dealer表
            $dealer=Db::name('dealer')->where('id',$userInfo['id'])->find();
            if($dealer['password']!=trim(md5($params['password']))){
                $info=[
                    'code'=>201,
                    'msg'=>'原始密码不正确'
                ];
            }else{
                $res=Db::name('dealer')
                    ->where('id',$userInfo['id'])
                    ->update([
                        'password'=>md5($params['new_pwd'])
                    ]);
                if($res||$res==0){
                    $info=[
                        'code'=>200,
                        'msg'=>'更改成功'
                    ];
                }else{
                    $info=[
                        'code'=>201,
                        'msg'=>'请联系管理员'
                    ];
                }
            }
        }
        return json($info);
    }
}