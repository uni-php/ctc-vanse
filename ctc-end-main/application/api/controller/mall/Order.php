<?php
/**
 * Created by PhpStorm.
 * User: wenhan
 * Date: 2022/12/3
 * Time: 下午7:56
 */

namespace app\api\controller\mall;
use app\Request;
use think\Controller;
use think\Db;
use app\common\JsonService;

class Order extends Controller
{
    public function getMyOrder(Request $request){
        $params=$request->get();
        $list=Db::name('dealer_mall_order')
            ->where('openid',$params['openid'])
            ->where('dealer_id',$params['dealer_id'])
            ->where('status',$params['status']==-2?'not null':$params['status'])
            ->where('is_del',0)
            ->select();
        foreach ($list as $key =>$value){
            $list[$key]['order_goods_info']= json_decode($value['order_goods_info']);
        }
        return JsonService::returnData(200,'查询成功',$list);
    }
    public function cancelMyOrder(Request $request){
        $params=$request->post();
        Db::startTrans();
        try{
            Db::name('dealer_mall_order')->where('order_id',$params['order_id'])->update([
                'is_del'=>1
            ]);
            if($params['pay_mode']=='cart'){
                foreach ($params['order_gift_info'] as $key =>$value){
                    Db::name('dealer_mall_goods')
                        ->where('id',$value['mall_goods_id'])
                        ->setInc('sales', $value['goods_num']);
                    Db::name('dealer_product')
                        ->where('id',$value['product_id'])
                        ->setDec('stock', $value['goods_num']);
                }
            }else{
                Db::name('dealer_mall_goods')
                    ->where('id',$params['order_goods_info']['mall_goods_id'])
                    ->setInc('sales', 1);
                Db::name('dealer_product')
                    ->where('id',$params['order_goods_info']['id'])
                    ->setDec('stock', 1);
            }
            Db::commit();
            return JsonService::returnData(200,'取消成功');
        }catch (\Exception $e){
            Db::rollback();
            return JsonService::returnData(500,'请联系管理员');
        }
    }
    public function getOrderDesById(Request $request){
        $params=$request->get();
        $info=Db::name('dealer_mall_order')->where('order_id',$params['order_id'])->find();
        $info['order_goods_info']=json_decode($info['order_goods_info']);
        return JsonService::returnData(200,'查询成功',$info);
    }
    public function getLogisticsCompany(Request $request){
        $list=Db::name('dict_data')
            ->where('dict_type','logistics_company')
            ->where('status',0)
            ->field('dict_label,dict_value')
            ->select();
        return JsonService::returnData(200,'查询成功',$list);
    }
}