<?php
/**
 * Created by PhpStorm.
 * User: wenhan
 * Date: 2022/12/12
 * Time: 下午5:28
 */

namespace app\api\controller\store;
use app\Request;
use think\Controller;
use think\Db;
use app\common\JsonService;

class Goods extends Controller
{
    public function getStoreGoodsClass(Request $request){
        $params=$request->get();
        $list=Db::name('dealer_store_goods_class')
            ->where('dealer_id',$params['dealer_id'])
            ->page($params['pageNum'])
            ->limit($params['pageSize'])
            ->select();
        $tree=tree($list,0);
        return JsonService::returnData(200,'查询成功',$tree);
    }
    public function getStoreGoods(Request $request){
        $params=$request->get();
        $list=Db::name('dealer_store_self_goods')
            ->alias('a')
            ->join('dealer_product b','a.product_id=b.id')
            ->where('a.dealer_id',$params['dealer_id'])
            ->where('a.class_one',$params['class_one']?:'not null')
            ->where('a.class_two',$params['class_two']?:'not null')
            ->where('a.status',0)
            ->order('a.create_time','desc')
            ->field('b.cover,b.code,b.product_name,a.class_one,a.class_two,a.create_time,a.product_id,a.id,b.price,a.price_small,a.price_big')
            ->select();
        $app_goods=Db::name('dealer_store_app_goods')
            ->where('dealer_id',$params['dealer_id'])
            ->where('store_id',$params['store_id'])
            ->field('self_product_id,sale_price')
            ->select();//已上架商品
        return JsonService::returnData(200,'查询成功',[$list,$app_goods]);
    }
    public function getStoreGoodsInfo(Request $request){
        $params=$request->get();
        $is_app_goods=Db::name('dealer_store_app_goods')
            ->where('dealer_id',$params['dealer_id'])
            ->where('id',$params['app_goods_id'])
            ->find();
        $info=Db::name('dealer_store_self_goods')
            ->alias('a')
            ->join('dealer_product b','a.product_id=b.id')
            ->where('a.dealer_id',$params['dealer_id'])
            ->where('a.id',$params['self_product_id'])
            ->field('b.cover,b.code,b.product_name,a.class_one,a.class_two,a.product_id,a.id,b.price,a.price_small,a.price_big')
            ->find();
        if($is_app_goods){
            $info['price']=$is_app_goods['sale_price'];
        }

        return JsonService::returnData(200,'查询成功',$info);
    }
    public function saveStoreGoods(Request $request){
        $params=$request->get();
        $is_app_goods=Db::name('dealer_store_app_goods')
            ->where('dealer_id',$params['dealer_id'])
            ->where('self_product_id',$params['id'])
            ->find();
        if(!$is_app_goods){
            $res=Db::name('dealer_store_app_goods')
                ->insert([
                   'dealer_id'=> $params['dealer_id'],
                    'store_id'=>$params['store_id'],
                    'product_id'=>$params['product_id'],
                    'self_product_id'=>$params['id'],
                    'sale_price'=>$params['sale_price']
                ]);
        }else{
            $res=Db::name('dealer_store_app_goods')
                ->where('self_product_id',$params['id'])
                ->where('dealer_id',$params['dealer_id'])
                ->update([
                    'sale_price'=>$params['sale_price']
                ]);
        }
        if($res||$res==0){
            return JsonService::returnData(200,'保存成功');
        }else{
            return JsonService::returnData(500,'请联系管路员');
        }
    }
    public function getSelfGoods(Request $request){
        $params=$request->get();
        $list=Db::name('dealer_store_app_goods')
            ->alias('a')
            ->join('dealer_product b','a.product_id=b.id')
            ->where('a.dealer_id',$params['dealer_id'])
            ->where('a.store_id',$params['store_id'])
            ->where('a.is_cut',$params['status'])
            ->page($params['page'])
            ->limit($params['pageSize'])
            ->field('a.product_id,a.sales,a.sale_price,b.product_name,b.cover,a.id,a.self_product_id')
            ->select();
        $sum=Db::name('dealer_store_app_goods')
            ->alias('a')
            ->join('dealer_product b','a.product_id=b.id')
            ->where('a.dealer_id',$params['dealer_id'])
            ->where('a.store_id',$params['store_id'])
            ->where('a.is_cut',$params['status'])
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
    public function cutSelfGoods(Request $request){
        $params=$request->get();
        $res=Db::name('dealer_store_app_goods')
            ->where('dealer_id',$params['dealer_id'])
            ->where('store_id',$params['store_id'])
            ->where('id',$params['id'])
            ->update([
                'is_cut'=>$params['status']
            ]);
        if($res){
            return JsonService::returnData(200,'操作成功');
        }else{
            return JsonService::returnData(500,'请联系管理员');
        }
    }
    public function deleSelfGoods(Request $request){
        $params=$request->get();
        $res=Db::name('dealer_store_app_goods')
            ->where('dealer_id',$params['dealer_id'])
            ->where('store_id',$params['store_id'])
            ->where('id',$params['id'])
            ->delete();
        if($res){
            return JsonService::returnData(200,'删除成功');
        }else{
            return JsonService::returnData(500,'请联系管理员');
        }
    }
}