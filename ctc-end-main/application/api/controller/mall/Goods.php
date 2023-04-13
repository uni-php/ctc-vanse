<?php
/**
 * Created by PhpStorm.
 * User: wenhan
 * Date: 2022/12/2
 * Time: 下午10:05
 */

namespace app\api\controller\mall;
use app\Request;
use think\Controller;
use think\Db;
use app\common\JsonService;

class Goods extends Controller
{
    public function getGoodsList(Request $request){
        $params=$request->get();
        if($params['type']==1){
            //默认 时间
            $list=Db::name('dealer_mall_goods')
                ->alias('a')
                ->join('dealer_product b','a.product_id=b.id')
                ->where('a.dealer_id',$params['dealer_id'])
                ->where('b.product_name','like','%'.$params['keywords'].'%')
                ->where('a.is_del',0)
                ->where('a.is_cut',1)
                ->field('b.cover,b.product_name,a.sales,a.sale_price,a.id')
                ->order('a.create_time','desc')
                ->page($params['page'])
                ->limit($params['pageSize'])
                ->select();
            $sum=Db::name('dealer_mall_goods')
                ->alias('a')
                ->join('dealer_product b','a.product_id=b.id')
                ->where('a.dealer_id',$params['dealer_id'])
                ->where('b.product_name','like','%'.$params['keywords'].'%')
                ->where('a.is_del',0)
                ->where('a.is_cut',1)
                ->count();
        }
        if($params['type']==2){
            //销量
            $list=Db::name('dealer_mall_goods')
                ->alias('a')
                ->join('dealer_product b','a.product_id=b.id')
                ->where('a.dealer_id',$params['dealer_id'])
                ->where('b.product_name','like','%'.$params['keywords'].'%')
                ->where('a.is_del',0)
                ->where('a.is_cut',1)
                ->field('b.cover,b.product_name,a.sales,a.sale_price,a.id')
                ->order('a.sales','desc')
                ->page($params['page'])
                ->limit($params['pageSize'])
                ->select();
            $sum=Db::name('dealer_mall_goods')
                ->alias('a')
                ->join('dealer_product b','a.product_id=b.id')
                ->where('a.dealer_id',$params['dealer_id'])
                ->where('b.product_name','like','%'.$params['keywords'].'%')
                ->where('a.is_del',0)
                ->where('a.is_cut',1)
                ->count();
        }
        if($params['type']==3){
            //价格
            $list=Db::name('dealer_mall_goods')
                ->alias('a')
                ->join('dealer_product b','a.product_id=b.id')
                ->where('a.dealer_id',$params['dealer_id'])
                ->where('b.product_name','like','%'.$params['keywords'].'%')
                ->where('a.is_del',0)
                ->where('a.is_cut',1)
                ->field('b.cover,b.product_name,a.sales,a.sale_price,a.id')
                ->order('a.sale_price','desc')
                ->page($params['page'])
                ->limit($params['pageSize'])
                ->select();
            $sum=Db::name('dealer_mall_goods')
                ->alias('a')
                ->join('dealer_product b','a.product_id=b.id')
                ->where('a.dealer_id',$params['dealer_id'])
                ->where('b.product_name','like','%'.$params['keywords'].'%')
                ->where('a.is_del',0)
                ->where('a.is_cut',1)
                ->count();
        }
        if($params['type']==4){
            //分类
            $list=Db::name('dealer_mall_goods')
                ->alias('a')
                ->join('dealer_product b','a.product_id=b.id')
                ->where('a.dealer_id',$params['dealer_id'])
                ->where('a.class_two',$params['classId'])
                ->where('b.product_name','like','%'.$params['keywords'].'%')
                ->where('a.is_del',0)
                ->where('a.is_cut',1)
                ->field('b.cover,b.product_name,a.sales,a.sale_price,a.id')
                ->order('a.sale_price','desc')
                ->page($params['page'])
                ->limit($params['pageSize'])
                ->select();
            $sum=Db::name('dealer_mall_goods')
                ->alias('a')
                ->join('dealer_product b','a.product_id=b.id')
                ->where('a.dealer_id',$params['dealer_id'])
                ->where('a.class_two',$params['classId'])
                ->where('b.product_name','like','%'.$params['keywords'].'%')
                ->where('a.is_del',0)
                ->where('a.is_cut',1)
                ->count();
        }
        foreach ($list as $key =>$value){
            $list[$key]['cover']=json_decode($value['cover']);
        }
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
    public function getGoodsType(Request $request){
        $params=$request->get();
        $list=Db::name('dealer_mall_goods_type')
            ->where('dealer_id',$params['dealer_id'])
            ->select();
        $tree=tree($list,0);
        return JsonService::returnData(200,'查询成功',$tree);
    }
    public function getGoodsInfo(Request $request){
        $params=$request->get();
        $gift_info=Db::name('dealer_product')
            ->alias('a')
            ->join('dealer_mall_goods b','a.id=b.product_id')
            ->where('b.id',$params['goods_id'])
            ->field('a.*,b.original_price,b.sale_price,a.stock,b.id as mall_goods_id')
            ->find();
        $gift_info['cover']=json_decode( $gift_info['cover'],true);
        return JsonService::returnData(200,'查询成功',$gift_info);
    }
    public function getOrderInfo(Request $request){
        $cartIds=$request->get('cartIds');
        $good_info=[];
        foreach (explode(',',$cartIds) as $key=>$value){
            $info=Db::name('dealer_mall_cart')
                ->alias('a')
                ->join('dealer_mall_goods c','a.mall_goods_id=c.id')
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