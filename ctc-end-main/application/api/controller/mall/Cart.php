<?php
/**
 * Created by PhpStorm.
 * User: wenhan
 * Date: 2022/12/3
 * Time: 上午12:36
 */

namespace app\api\controller\mall;
use app\Request;
use think\Controller;
use think\Db;
use app\common\JsonService;

class Cart extends Controller
{
    public function addCart(Request $request){
        $params=$request->get();
        // 相同规格 相同商品id  存在时累计加1
        $has=Db::name('dealer_mall_cart')
            ->where('goods_sku_id',$params['goods_sku_id'])
            ->where('dealer_id',$params['dealer_id'])
            ->where('mall_goods_id',$params['mall_goods_id'])
            ->where('openid',$params['openid'])
            ->where('is_delete',0)
            ->find();
        if($has){
            $res=Db::name('dealer_mall_cart')->where('id',$has['id'])->setInc('goods_num');
        }else{
            $res=Db::name('dealer_mall_cart')->insert($params);
        }
        if($res){
            return JsonService::returnData(200,'加入购物车成功');
        }else{
            return JsonService::returnData(500,'请联系管理员');
        }
    }
    public function getCartList(Request $request){
        $params=$request->get();
        $list=Db::name('dealer_mall_cart')
            ->where('dealer_id',$params['dealer_id'])
            ->where('openid',$params['openid'])
            ->where('is_delete',0)
            ->select();
        foreach ($list as $key=>$value){
            $gift_info=Db::name('dealer_mall_goods')
                ->alias('a')
                ->join('dealer_product b','a.product_id=b.id')
                ->where('a.id',$value['mall_goods_id'])
                ->field('b.cover,b.product_name,b.id,a.sale_price')
                ->find();
            $list[$key]['goods_info']=$gift_info;
            $list[$key]['goods_info']['cover']=json_decode($list[$key]['goods_info']['cover']);
            $list[$key]['is_selected']=[$value['id']];//默认选中
        }
        $sum=Db::name('dealer_mall_cart')
            ->where('dealer_id',$params['dealer_id'])
            ->where('openid',$params['openid'])
            ->where('is_delete',0)
            ->sum('goods_num');
        return JsonService::returnData(200,'查询成功',['list'=>$list,'cartTotal'=>$sum]);
    }
    public function updateCart(Request $request){
        $params=$request->get();
        $res=Db::name('dealer_mall_cart')
            ->where('goods_sku_id',$params['goods_sku_id'])
            ->where('dealer_id',$params['dealer_id'])
            ->where('mall_goods_id',$params['mall_goods_id'])
            ->where('openid',$params['openid'])
            ->update([
                'goods_num'=>$params['goods_num']
            ]);
        if($res){
            return JsonService::returnData(200,'更新成功');
        }else{
            return JsonService::returnData(500,'请联系管理员');
        }
    }
    public function clearCart(Request $request){
        $params=$request->post();
        Db::startTrans();
        try{
            foreach ($params['cart_ids'] as $key=>$value){
                Db::name('dealer_mall_cart')
                    ->where('dealer_id',$params['dealer_id'])
                    ->where('openid',$params['openid'])
                    ->where('id',$value)
                    ->update([
                        'is_delete'=>1
                    ]);
            }
            Db::commit();
            return JsonService::returnData(200,'删除成功');
        }catch (\Exception $e){
            Db::rollback();
            return JsonService::returnData(500,'请联系管理员');
        }
    }
}