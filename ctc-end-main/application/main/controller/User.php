<?php
/**
 * Created by PhpStorm.
 * Role: wenhan
 * Date: 2021/10/7
 * Time: 上午12:35
 */

namespace app\main\controller;
use think\Controller;
use think\Db;
use app\Request;
use think\facade\Hook;

class User extends Controller
{
    public function listUser(Request $request){
        $params=$request->get();
        $list=Db::name('user')
            ->where('username','like','%'.$params['userName'].'%')
            ->where('phone','like','%'.$params['phonenumber'].'%')
            ->where('status','like','%'.$params['status'].'%')
            ->order('create_time','asc')
            ->page($params['pageNum'])
            ->limit($params['pageSize'])
            ->select();
        $total=Db::name('user')
            ->where('username','like','%'.$params['userName'].'%')
            ->where('phone','like','%'.$params['phonenumber'].'%')
            ->where('status','like','%'.$params['status'].'%')
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
        $uid=$request->param('uid');
        $roles=Db::name('role')
            ->where('admin',0)
            ->where('status','0')
            ->select();
        if($uid){
            $data=Db::name('user')
                ->where('uid',$uid)
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
        $uid=array_key_exists('uid',$data);
        $data['roleIds']=implode(",",$data['roleIds']);
        if($uid){
            unset($data['password']);
            Db::name('user')
                ->update($data);
            $log=[
                'module_name'=>'系统管理',
                'operator'=>$request->userInfo()['account'],
                'ip'=>$request->ip(),
                'address'=>$address[2].$address[3],
                'operate_type'=>'2',
                'operate_event'=>'修改管理员'
            ];
            Hook::listen('op_log',$log);
            $info=[
                'code'=>200,
                'msg'=>'更新成功'
            ];
        }else{
            $data['password']=md5($data['password']);
            $code=Db::name('user')
                ->insert($data);
            if($code){
                $log=[
                    'module_name'=>'系统管理',
                    'operator'=>$request->userInfo()['account'],
                    'ip'=>$request->ip(),
                    'address'=>$address[2].$address[3],
                    'operate_type'=>'1',
                    'operate_event'=>'新增管理员'
                ];
                Hook::listen('op_log',$log);
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
        $ids=explode(",",$ids['ids']);
        $res=Db::name('user')->delete($ids);
        if($res){
            $log=[
                'module_name'=>'系统管理',
                'operator'=>$request->userInfo()['account'],
                'ip'=>$request->ip(),
                'address'=>$address[2].$address[3],
                'operate_type'=>'3',
                'operate_event'=>'删除管理员'
            ];
            Hook::listen('op_log',$log);
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
        $code=Db::name('user')
            ->update($params);
        if($code){
            $log=[
                'module_name'=>'系统管理',
                'operator'=>$request->userInfo()['account'],
                'ip'=>$request->ip(),
                'address'=>$address[2].$address[3],
                'operate_type'=>'2',
                'operate_event'=>'更新管理员状态'
            ];
            Hook::listen('op_log',$log);
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
        $code=Db::name('user')
            ->where('uid',$params['uid'])
            ->update([
               'password'=>md5($params['password'])
            ]);
        $log=[
            'module_name'=>'系统管理',
            'operator'=>$request->userInfo()['account'],
            'ip'=>$request->ip(),
            'address'=>$address[2].$address[3],
            'operate_type'=>'2',
            'operate_event'=>'重置管理员密码'
        ];
        Hook::listen('op_log',$log);
        $info=[
            'code'=>200,
            'msg'=>'更新成功'
        ];
        return json($info);
    }
}