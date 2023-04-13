<?php
/**
 * Created by PhpStorm.
 * User: wenhan
 * Date: 2022/12/23
 * Time: 下午10:41
 */

namespace app\api\controller\store;
use app\Request;
use think\Controller;
use think\Db;
use app\common\JsonService;

class Order extends Controller
{
    public function getMyOrder(Request $request){
        $params=$request->get();
        $list=Db::name('dealer_store_shop_order')
            ->where('store_id',$params['store_id'])
            ->where('dealer_id',$params['dealer_id'])
            ->where('status',$params['status']==-2?'not null':$params['status'])
            ->where('is_del',0)
            ->select();
        foreach ($list as $key =>$value){
            $list[$key]['order_goods_info']= json_decode($value['order_goods_info']);
        }
        return JsonService::returnData(200,'查询成功',$list);
    }
    public function getOrderDesById(Request $request){
        $params=$request->get();
        $info=Db::name('dealer_store_shop_order')->where('order_id',$params['order_id'])->find();
        $info['order_goods_info']=json_decode($info['order_goods_info']);
        return JsonService::returnData(200,'查询成功',$info);
    }
    public function getUserInfo(Request $request){
        $params=$request->get();
        $userInfo=Db::name('dealer_member')
            ->where('openid',$params['openid'])
            ->where('dealer_id',$params['dealer_id'])
            ->find();
        $address=Db::name('dealer_member_address')
            ->where('dealer_id',$params['dealer_id'])
            ->where('is_dele',0)
            ->where('openid',$params['openid'])
            ->select();
        $userInfo['address']= empty($address)?[]:$address[0];
        foreach ($address as $key=>$value){
            if($value['is_default']==2){
                $userInfo['address']=$value;
            }
        }
        return JsonService::returnData(200,'查询成功',$userInfo);
    }
}