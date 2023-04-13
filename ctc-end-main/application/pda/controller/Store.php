<?php
/**
 * Created by PhpStorm.
 * User: wenhan
 * Date: 2022/3/31
 * Time: 下午4:08
 */

namespace app\pda\controller;
use app\Request;
use think\Controller;
use think\Db;
use app\common\JsonService;
use think\db\Where;

class Store extends Controller
{
    public function getStoreList(Request $request){
        $params=$request->get();
        $list=Db::name('dealer_store')
            ->where('store_code|store_name','like','%'.$params['keywords'].'%')
            ->where('dealer_id',$params['dealer_id'])
            ->where('check_status',1)
            ->where('status','<>',3)
            ->page($params['page'])
            ->limit($params['pageSize'])
            ->order('create_time','desc')
            ->select();
        $sum=Db::name('dealer_store')
            ->where('store_code|store_name','like','%'.$params['keywords'].'%')
            ->where('dealer_id',$params['dealer_id'])
            ->where('check_status',1)
            ->where('status','<>',3)
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