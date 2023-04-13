<?php
/**
 * Created by PhpStorm.
 * User: wenhan
 * Date: 2022/3/28
 * Time: 上午12:58
 */

namespace app\pda\controller;
use app\Request;
use think\Controller;
use think\Db;
use app\common\JsonService;
use think\db\Where;

class Product extends Controller
{
    public function getProductList(Request $request){
        $params=$request->get();
        $list=$list=Db::name('dealer_product')
            ->where('code|product_name','like','%'.$params['keywords'].'%')
            ->where('dealer_id',$params['dealer_id'])
            ->where('is_del',0)
            ->order('create_time','desc')
            ->page($params['page'])
            ->limit($params['pageSize'])
            ->select();
        $sum=Db::name('dealer_product')
            ->where('code|product_name','like','%'.$params['keywords'].'%')
            ->where('dealer_id',$params['dealer_id'])
            ->where('is_del',0)
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