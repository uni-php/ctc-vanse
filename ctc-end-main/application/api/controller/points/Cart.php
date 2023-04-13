<?php
/**
 * Created by PhpStorm.
 * User: wenhan
 * Date: 2022/8/17
 * Time: 上午12:33
 */

namespace app\api\controller\points;
use app\Request;
use function PHPSTORM_META\type;
use think\Controller;
use think\Db;
use app\common\JsonService;

class Cart extends Controller
{
    public function addCart(Request $request){
        $params=$request->get();
        // 相同规格 相同礼品id  存在时累计加1
        $has=Db::name('dealer_points_cart')
            ->where('gift_sku_id',$params['gift_sku_id'])
            ->where('dealer_id',$params['dealer_id'])
            ->where('points_gift_id',$params['points_gift_id'])
            ->where('openid',$params['openid'])
            ->where('is_delete',0)
            ->find();
        if($has){
            $res=Db::name('dealer_points_cart')->where('id',$has['id'])->setInc('gift_num');
        }else{
            $res=Db::name('dealer_points_cart')->insert($params);
        }
        if($res){
            return JsonService::returnData(200,'加入购物车成功');
        }else{
            return JsonService::returnData(500,'请联系管理员');
        }
    }
    public function updateCart(Request $request){
        $params=$request->get();
        $res=Db::name('dealer_points_cart')
            ->where('gift_sku_id',$params['gift_sku_id'])
            ->where('dealer_id',$params['dealer_id'])
            ->where('points_gift_id',$params['points_gift_id'])
            ->where('openid',$params['openid'])
            ->update([
               'gift_num'=>$params['gift_num']
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
                Db::name('dealer_points_cart')
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

    /**
     * 购物车列表
     * @param Request $request
     */
    public function getCartList(Request $request){
        $params=$request->get();
        $list=Db::name('dealer_points_cart')
            ->where('dealer_id',$params['dealer_id'])
            ->where('openid',$params['openid'])
            ->where('is_delete',0)
            ->select();
        foreach ($list as $key=>$value){
            $gift_info=Db::name('dealer_points_gifts')
                ->alias('a')
                ->join('dealer_gift b','a.gift_id=b.id')
                ->where('a.id',$value['points_gift_id'])
                ->field('b.cover,b.gift_name,a.exchanged_num,b.id,a.type,a.points_num,a.money')
                ->find();
            $list[$key]['gift_info']=$gift_info;
            $list[$key]['gift_info']['cover']=json_decode($list[$key]['gift_info']['cover']);
            $list[$key]['is_selected']=[$value['id']];//默认选中
        }
        $sum=Db::name('dealer_points_cart')
            ->where('dealer_id',$params['dealer_id'])
            ->where('openid',$params['openid'])
            ->where('is_delete',0)
            ->sum('gift_num');
        return JsonService::returnData(200,'查询成功',['list'=>$list,'cartTotal'=>$sum]);
    }
}