<?php
/**
 * Created by PhpStorm.
 * Role: wenhan
 * Date: 2021/10/8
 * Time: 下午11:14
 */

namespace app\main\controller;
use think\Controller;
use think\Db;
use app\Request;
use think\facade\Hook;

class Code extends Controller
{
    public function getCodeList(Request $request){
        $params=$request->get();
        $list=Db::name('product_code')
            ->page($params['pageNum'])
            ->limit($params['pageSize'])
            ->select();
        $total=Db::name('product_code')
            ->count();
        $res=[
            'code'=>200,
            'msg'=>'查询成功',
            'data'=>$list,
            'total'=>$total
        ];
        return json($res);
    }
    public function addCode(Request $request){
        $data=$request->get();
        $address = $request->address();
        $id=array_key_exists('id',$data);
        if($id){
            Db::name('product_code')
                ->update($data);
            $log=[
                'module_name'=>'产品管理',
                'operator'=>$request->userInfo()['account'],
                'ip'=>$request->ip(),
                'address'=>$address[2].$address[3],
                'operate_type'=>'2',
                'operate_event'=>'更新码阶梯'
            ];
            Hook::listen('op_log',$log);
            $info=[
                'code'=>200,
                'msg'=>'更新成功'
            ];
        }else{
            $res=Db::name('product_code')
                ->insert($data);
            if($res){
                $log=[
                    'module_name'=>'产品管理',
                    'operator'=>$request->userInfo()['account'],
                    'ip'=>$request->ip(),
                    'address'=>$address[2].$address[3],
                    'operate_type'=>'3',
                    'operate_event'=>'新增码阶梯'
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
    public function deleCode(Request $request){
        $id=$request->param('id');
        $address = $request->address();
        $res=Db::name('product_code')
            ->delete($id);
        if($res){
            $log=[
                'module_name'=>'产品管理',
                'operator'=>$request->userInfo()['account'],
                'ip'=>$request->ip(),
                'address'=>$address[2].$address[3],
                'operate_type'=>'3',
                'operate_event'=>'删除码阶梯'
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
    public function getCode(Request $request){
        $id=$request->param('id');
        $info=Db::name('product_code')
            ->where('id',$id)
            ->find();
        $res=[
            'code'=>200,
            'msg'=>'查询成功',
            'data'=>$info
        ];
        return json($res);
    }
}