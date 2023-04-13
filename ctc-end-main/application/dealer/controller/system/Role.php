<?php
/**
 * Created by PhpStorm.
 * Role: wenhan
 * Date: 2021/11/13
 * Time: 下午5:34
 */

namespace app\dealer\controller\system;
use think\Controller;
use think\Db;
use app\Request;
use think\facade\Hook;

class Role extends Controller
{
    public function roleList(Request $request){
        $params=$request->get();
        $userInfo=$request->userInfo();
        $dealer_id=array_key_exists('dealer_id',$userInfo)?$userInfo['dealer_id']:$userInfo['id'];
        $list=Db::name('dealer_role')
            ->where('roleName','like','%'.$params['roleName'].'%')
            ->where('roleKey','like','%',$params['roleKey'].'%')
            ->where('status','like','%'.$params['status'].'%')
            ->where('dealerId',$dealer_id)
            ->page($params['pageNum'])
            ->limit($params['pageSize'])
            ->select();
        $total=Db::name('dealer_role')
            ->where('roleName','like','%'.$params['roleName'].'%')
            ->where('roleKey','like','%',$params['roleKey'].'%')
            ->where('status','like','%'.$params['status'].'%')
            ->where('dealerId',$dealer_id)
            ->count();
        $res=[
            'code'=>200,
            'msg'=>'查询成功',
            'rows'=>$list,
            'total'=>$total
        ];
        return json($res);
    }
    public function addRole(Request $request){
        $data=$request->get();
        $address = $request->address();
        $userInfo=$request->userInfo();
        $data['dealerId']=array_key_exists('dealer_id',$userInfo)?$userInfo['dealer_id']:$userInfo['id'];
        if(count($data['menuIds'])>0){
            $data['menuIds']=implode(",",$data['menuIds']);
        }else{
            $data['menuIds']='';
        }
        $roleId=array_key_exists('roleId',$data);
        if($roleId){
            Db::name('dealer_role')
                ->update($data);
            $log=[
                'module_name'=>'用户管理',
                'operator'=>$request->userInfo()['account'],
                'ip'=>$request->ip(),
                'address'=>$address[2].$address[3],
                'operate_type'=>'2',
                'operate_event'=>'更新用户角色',
                'dealer_id'=>$data['dealerId']
            ];
            Hook::listen('dealer_op_log',$log);
            $info=[
                'code'=>200,
                'msg'=>'更新成功'
            ];
        }else{
            $code=Db::name('dealer_role')
                ->insert($data);
            if($code){
                $log=[
                    'module_name'=>'用户管理',
                    'operator'=>$request->userInfo()['account'],
                    'ip'=>$request->ip(),
                    'address'=>$address[2].$address[3],
                    'operate_type'=>'1',
                    'operate_event'=>'新增用户角色',
                    'dealer_id'=>$data['dealerId']
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
    public function getRole(Request $request){
        $info=Db::name('dealer_role')
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
        $userInfo=$request->userInfo();
        $dealer_id=array_key_exists('dealer_id',$userInfo)?$userInfo['dealer_id']:$userInfo['id'];
        $address = $request->address();
        $res=Db::name('dealer_role')->delete($ids);
        if($res){
            $log=[
                'module_name'=>'用户管理',
                'operator'=>$request->userInfo()['account'],
                'ip'=>$request->ip(),
                'address'=>$address[2].$address[3],
                'operate_type'=>'2',
                'operate_event'=>'删除角色',
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
        $code=Db::name('dealer_role')
            ->update($params);
        if($code){
            $log=[
                'module_name'=>'用户管理',
                'operator'=>$request->userInfo()['account'],
                'ip'=>$request->ip(),
                'address'=>$address[2].$address[3],
                'operate_type'=>'2',
                'operate_event'=>'更新用户角色状态',
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
}