<?php
/**
 * Created by PhpStorm.
 * Role: wenhan
 * Date: 2021/10/6
 * Time: 下午9:35
 */

namespace app\main\controller;
use think\Controller;
use think\Db;
use app\Request;
use think\facade\Hook;

class Role extends Controller
{
    public function listRole(Request $request){
        $params=$request->get();
        $list=Db::name('role')
            ->where('roleName','like','%'.$params['roleName'].'%')
            ->where('roleKey','like','%',$params['roleKey'].'%')
            ->where('status','like','%'.$params['status'].'%')
            ->page($params['pageNum'])
            ->limit($params['pageSize'])
            ->select();
        $total=Db::name('role')
            ->where('roleName','like','%'.$params['roleName'].'%')
            ->where('roleKey','like','%',$params['roleKey'].'%')
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
    //新增角色
    public function addRole(Request $request){
        $data=$request->get();
        $address = $request->address();
        if(count($data['menuIds'])>0){
            $data['menuIds']=implode(",",$data['menuIds']);
        }else{
            $data['menuIds']='';
        }
        $roleId=array_key_exists('roleId',$data);
        if($roleId){
            Db::name('role')
                ->update($data);
            $log=[
                'module_name'=>'系统管理',
                'operator'=>$request->userInfo()['account'],
                'ip'=>$request->ip(),
                'address'=>$address[2].$address[3],
                'operate_type'=>'2',
                'operate_event'=>'更新用户角色'
            ];
            Hook::listen('op_log',$log);
            $info=[
                'code'=>200,
                'msg'=>'更新成功'
            ];
        }else{
            $code=Db::name('role')
                ->insert($data);
            if($code){
                $log=[
                    'module_name'=>'系统管理',
                    'operator'=>$request->userInfo()['account'],
                    'ip'=>$request->ip(),
                    'address'=>$address[2].$address[3],
                    'operate_type'=>'1',
                    'operate_event'=>'新增用户角色'
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
    public function getRole(Request $request){
        $info=Db::name('role')
            ->where('roleId',$request->param('roleId'))
            ->find();
        if($info){
            $res=[
                'code'=>200,
                'msg'=>'查询成功',
                'data'=>$info
            ];
        }else{
            $res=[
                'code'=>201,
                'msg'=>'系统异常'
            ];
        }
        return json($res);
    }
    public function deleRole(Request $request){
        $ids=$request->get('roleIds');
        $address = $request->address();
        $res=Db::name('role')->delete($ids);
        if($res){
            $log=[
                'module_name'=>'系统管理',
                'operator'=>$request->userInfo()['account'],
                'ip'=>$request->ip(),
                'address'=>$address[2].$address[3],
                'operate_type'=>'2',
                'operate_event'=>'删除角色'
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
    //改变状态
    public function changeStatus(Request $request){
        $params=$request->get();
        $address = $request->address();
        $code=Db::name('role')
            ->update($params);
        if($code){
            $log=[
                'module_name'=>'系统管理',
                'operator'=>$request->userInfo()['account'],
                'ip'=>$request->ip(),
                'address'=>$address[2].$address[3],
                'operate_type'=>'2',
                'operate_event'=>'更新用户角色状态'
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
}