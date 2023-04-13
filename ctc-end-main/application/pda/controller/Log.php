<?php
/**
 * Created by PhpStorm.
 * User: wenhan
 * Date: 2022/4/7
 * Time: 下午9:45
 */

namespace app\pda\controller;
use app\Request;
use think\Controller;
use think\Db;
use app\common\JsonService;
use think\db\Where;

class Log extends Controller
{
    public function getOpLogList(Request $request){
        $params=$request->get();
        $condition=[];
        if($params['start_time']&&$params['end_time']){
            $condition['create_time']=['between time',[$params['start_time'],$params['end_time']]];
        }
//        $condition['code']=['like','%'.$params['code'].'%'];
        $list=Db::name('dealer_logistics_op_log')
            ->where(new Where($condition))
            ->where('dealer_id',$params['dealer_id'])
            ->page($params['page'])
            ->limit($params['pageSize'])
            ->order('create_time','desc')
            ->select();
        $sum=Db::name('dealer_logistics_op_log')
            ->where(new Where($condition))
            ->where('dealer_id',$params['dealer_id'])
            ->count();
        $data=[
            'list'=>[
                'current_page'=>$params['page'],
                'total'=>$sum,
                'per_page'=>$params['pageSize'],
                'data'=>$list
            ]
        ];
        return JsonService::returnData(200,'查询成功',$data);
    }
}