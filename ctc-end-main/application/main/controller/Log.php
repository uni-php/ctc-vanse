<?php
/**
 * Created by PhpStorm.
 * Role: wenhan
 * Date: 2021/10/17
 * Time: 下午6:18
 */

namespace app\main\controller;
use think\Controller;
use think\Db;
use app\Request;

class Log extends Controller
{
    public function getLoginList(Request $request){
        $params=$request->get();
        if($params['beginTime']){
            $list=Db::name('login_log')
                ->where('address','like','%'.$params['address'].'%')
                ->where('account','like','%'.$params['account'].'%')
                ->where('create_time','between time', [$params['beginTime'], $params['endTime']])
                ->page($params['pageNum'])
                ->limit($params['pageSize'])
                ->order('create_time','desc')
                ->select();
            $total=Db::name('login_log')
                ->where('address','like','%'.$params['address'].'%')
                ->where('account','like','%'.$params['account'].'%')
                ->where('create_time','between time', [$params['beginTime'], $params['endTime']])
                ->count();
        }else{
            $list=Db::name('login_log')
                ->where('address','like','%'.$params['address'].'%')
                ->where('account','like','%'.$params['account'].'%')
                ->page($params['pageNum'])
                ->order('create_time','desc')
                ->limit($params['pageSize'])
                ->select();
            $total=Db::name('login_log')
                ->where('address','like','%'.$params['address'].'%')
                ->where('account','like','%'.$params['account'].'%')
                ->count();
        }
        $res=[
            'code'=>200,
            'msg'=>'查询成功',
            'data'=>$list,
            'total'=>$total
        ];
        return json($res);
    }
    public function operationList(Request $request){
        $params=$request->get();
        if($params['beginTime']){
            $list=Db::name('oper_log')
                ->where('module_name','like','%'.$params['module_name'].'%')
                ->where('operate_type','like','%'.$params['operate_type'].'%')
                ->where('operator','like','%'.$params['operator'].'%')
                ->where('create_time','between time', [$params['beginTime'], $params['endTime']])
                ->page($params['pageNum'])
                ->order('create_time','desc')
                ->limit($params['pageSize'])
                ->select();
            $total=Db::name('oper_log')
                ->where('module_name','like','%'.$params['module_name'].'%')
                ->where('operate_type','like','%'.$params['operate_type'].'%')
                ->where('operator','like','%'.$params['operator'].'%')
                ->where('create_time','between time', [$params['beginTime'], $params['endTime']])
                ->count();
        }else{
            $list=Db::name('oper_log')
                ->where('module_name','like','%'.$params['module_name'].'%')
                ->where('operate_type','like','%'.$params['operate_type'].'%')
                ->where('operator','like','%'.$params['operator'].'%')
                ->page($params['pageNum'])
                ->order('create_time','desc')
                ->limit($params['pageSize'])
                ->select();
            $total=Db::name('oper_log')
                ->where('module_name','like','%'.$params['module_name'].'%')
                ->where('operate_type','like','%'.$params['operate_type'].'%')
                ->where('operator','like','%'.$params['operator'].'%')
                ->count();
        }
        $res=[
            'code'=>200,
            'msg'=>'查询成功',
            'data'=>$list,
            'total'=>$total
        ];
        return json($res);
    }
}