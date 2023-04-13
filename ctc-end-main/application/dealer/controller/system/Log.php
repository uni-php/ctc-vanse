<?php
/**
 * Created by PhpStorm.
 * User: wenhan
 * Date: 2021/11/14
 * Time: 下午1:07
 */

namespace app\dealer\controller\system;
use think\Controller;
use think\Db;
use app\Request;

class Log extends Controller
{
    public function operationList(Request $request){
        $params=$request->get();
        $userInfo=$request->userInfo();
        $dealer_id=array_key_exists('dealer_id',$userInfo)?$userInfo['dealer_id']:$userInfo['id'];
        if($params['beginTime']){
            $list=Db::name('dealer_oper_log')
                ->where('module_name','like','%'.$params['module_name'].'%')
                ->where('operate_type','like','%'.$params['operate_type'].'%')
                ->where('operator','like','%'.$params['operator'].'%')
                ->where('create_time','between time', [$params['beginTime'], $params['endTime']])
                ->where('dealer_id',$dealer_id)
                ->page($params['pageNum'])
                ->order('create_time','desc')
                ->limit($params['pageSize'])
                ->select();
            $total=Db::name('dealer_oper_log')
                ->where('module_name','like','%'.$params['module_name'].'%')
                ->where('operate_type','like','%'.$params['operate_type'].'%')
                ->where('operator','like','%'.$params['operator'].'%')
                ->where('dealer_id',$dealer_id)
                ->where('create_time','between time', [$params['beginTime'], $params['endTime']])
                ->count();
        }else{
            $list=Db::name('dealer_oper_log')
                ->where('module_name','like','%'.$params['module_name'].'%')
                ->where('operate_type','like','%'.$params['operate_type'].'%')
                ->where('operator','like','%'.$params['operator'].'%')
                ->where('dealer_id',$dealer_id)
                ->page($params['pageNum'])
                ->order('create_time','desc')
                ->limit($params['pageSize'])
                ->select();
            $total=Db::name('dealer_oper_log')
                ->where('module_name','like','%'.$params['module_name'].'%')
                ->where('operate_type','like','%'.$params['operate_type'].'%')
                ->where('operator','like','%'.$params['operator'].'%')
                ->where('dealer_id',$dealer_id)
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