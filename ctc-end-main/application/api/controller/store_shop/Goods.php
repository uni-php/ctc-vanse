<?php
/**
 * Created by PhpStorm.
 * User: wenhan
 * Date: 2022/12/17
 * Time: 下午11:24
 */

namespace app\api\controller\store_shop;
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
        if($params['filter_idx']==2||$params['filter_idx']==1){
            $app_goods=Db::name('dealer_store_app_goods')
                ->alias('a')
                ->join('dealer_product b','a.product_id=b.id')
                ->join('dealer_store_self_goods c','a.self_product_id=c.id')
                ->where('a.dealer_id',$params['dealer_id'])
                ->where('a.store_id',$params['store_id'])
                ->where('c.class_one',$params['class_one']?:'not null')
                ->where('c.class_two',$params['class_two']?:'not null')
                ->where('b.product_name','like','%'.$params['keywords'].'%')
                ->where('a.is_cut',0)
                ->field('b.cover,b.code,b.product_name,a.id,a.sale_price,b.stock,b.id as product_id,a.sales')
                ->order('a.create_time',$params['status']==0?'desc':'asc')
                ->select();//已上架商品
        }
        if($params['filter_idx']==3){
            $app_goods=Db::name('dealer_store_app_goods')
                ->alias('a')
                ->join('dealer_product b','a.product_id=b.id')
                ->join('dealer_store_self_goods c','a.self_product_id=c.id')
                ->where('a.dealer_id',$params['dealer_id'])
                ->where('a.store_id',$params['store_id'])
                ->where('c.class_one',$params['class_one']?:'not null')
                ->where('c.class_two',$params['class_two']?:'not null')
                ->where('b.product_name','like','%'.$params['keywords'].'%')
                ->where('a.is_cut',0)
                ->field('b.cover,b.code,b.product_name,a.id,a.sale_price,b.stock,b.id as product_id,a.sales')
                ->order('a.sales',$params['status']==0?'desc':'asc')
                ->select();//已上架商品
        }
        if($params['filter_idx']==4){
            $app_goods=Db::name('dealer_store_app_goods')
                ->alias('a')
                ->join('dealer_product b','a.product_id=b.id')
                ->join('dealer_store_self_goods c','a.self_product_id=c.id')
                ->where('a.dealer_id',$params['dealer_id'])
                ->where('a.store_id',$params['store_id'])
                ->where('c.class_one',$params['class_one']?:'not null')
                ->where('c.class_two',$params['class_two']?:'not null')
                ->where('b.product_name','like','%'.$params['keywords'].'%')
                ->where('a.is_cut',0)
                ->field('b.cover,b.code,b.product_name,a.id,a.sale_price,b.stock,b.id as product_id,a.sales')
                ->order('a.sale_price',$params['status']==0?'desc':'asc')
                ->select();//已上架商品
        }
        return JsonService::returnData(200,'查询成功',$app_goods);
    }
    public function getGoodsInfo(Request $request){
        $params=$request->get();
        $goods_info=Db::name('dealer_store_app_goods')
            ->alias('a')
            ->join('dealer_product b','a.product_id=b.id')
            ->where('a.id',$params['app_goods_id'])
            ->where('a.dealer_id',$params['dealer_id'])
            ->field('b.*,a.id as app_goods_id,a.sale_price,a.sales')
            ->find();
        $goods_info['cover']=json_decode( $goods_info['cover'],true);
        return JsonService::returnData(200,'查询成功',$goods_info);
    }
    public function getOrderInfo(Request $request){
        $cartIds=$request->get('cartIds');
        $good_info=[];
        foreach (explode(',',$cartIds) as $key=>$value){
            $info=Db::name('dealer_store_shop_cart')
                ->alias('a')
                ->join('dealer_store_app_goods c','a.app_goods_id=c.id')
                ->join('dealer_product b','c.product_id=b.id')
                ->where('a.id',$value)
                ->field('a.*,c.sale_price,b.cover,b.product_name,c.product_id')
                ->find();
            $info['cover']=json_decode( $info['cover'],true);
            array_push($good_info,$info);
        }
        return JsonService::returnData(200,'查询成功',$good_info);
    }
}