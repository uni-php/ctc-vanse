<?php
/**
 * Created by PhpStorm.
 * User: wenhan
 * Date: 2022/8/6
 * Time: 上午1:40
 */

namespace app\api\controller\points;
use app\Request;
use think\Controller;
use think\Db;
use app\common\JsonService;

class Gift extends Controller
{
    /**
     * @param Request $request
     * 查询礼品列表
     */
    public function getGiftsList(Request $request){
        $params=$request->get();
        if($params['type']==1){
            //默认 时间
            $list=Db::name('dealer_points_gifts')
                ->alias('a')
                ->join('dealer_gift b','a.gift_id=b.id')
                ->where('a.dealer_id',$params['dealer_id'])
                ->where('b.gift_name','like','%'.$params['keywords'].'%')
                ->where('a.status',1)
                ->field('b.cover,b.gift_name,a.exchanged_num,a.type,a.points_num,a.money,a.id')
                ->order('a.create_time','desc')
                ->page($params['page'])
                ->limit($params['pageSize'])
                ->select();
            $sum=Db::name('dealer_points_gifts')
                ->alias('a')
                ->join('dealer_gift b','a.gift_id=b.id')
                ->where('a.dealer_id',$params['dealer_id'])
                ->where('b.gift_name','like','%'.$params['keywords'].'%')
                ->where('a.status',1)
                ->count();
        }
        if($params['type']==2){
            //兑换量
            $list=Db::name('dealer_points_gifts')
                ->alias('a')
                ->join('dealer_gift b','a.gift_id=b.id')
                ->where('a.dealer_id',$params['dealer_id'])
                ->where('b.gift_name','like','%'.$params['keywords'].'%')
                ->where('a.status',1)
                ->order('a.exchanged_num','desc')
                ->field('b.cover,b.gift_name,a.exchanged_num,a.id,a.type,a.points_num,a.money')
                ->page($params['page'])
                ->limit($params['pageSize'])
                ->select();
            $sum=Db::name('dealer_points_gifts')
                ->alias('a')
                ->join('dealer_gift b','a.gift_id=b.id')
                ->where('a.dealer_id',$params['dealer_id'])
                ->where('b.gift_name','like','%'.$params['keywords'].'%')
                ->where('a.status',1)
                ->count();
        }
        if($params['type']==3){
            //积分值
            $list=Db::name('dealer_points_gifts')
                ->alias('a')
                ->join('dealer_gift b','a.gift_id=b.id')
                ->where('a.dealer_id',$params['dealer_id'])
                ->where('b.gift_name','like','%'.$params['keywords'].'%')
                ->where('a.status',1)
                ->order('a.points_num','desc')
                ->field('b.cover,b.gift_name,a.exchanged_num,a.id,a.type,a.points_num,a.money')
                ->page($params['page'])
                ->limit($params['pageSize'])
                ->select();
            $sum=Db::name('dealer_points_gifts')
                ->alias('a')
                ->join('dealer_gift b','a.gift_id=b.id')
                ->where('a.dealer_id',$params['dealer_id'])
                ->where('b.gift_name','like','%'.$params['keywords'].'%')
                ->where('a.status',1)
                ->count();
        }
        if($params['type']==4){
            //我能兑换
            $my_points=Db::name('dealer_member')->where('openid',$params['openid'])->value('points');
            $list=Db::name('dealer_points_gifts')
                ->alias('a')
                ->join('dealer_gift b','a.gift_id=b.id')
                ->where('a.dealer_id',$params['dealer_id'])
                ->where('b.gift_name','like','%'.$params['keywords'].'%')
                ->where('a.status',1)
                ->where('a.points_num','>=',number_format($my_points,2))
                ->field('b.cover,b.gift_name,a.exchanged_num,a.id,a.type,a.points_num,a.money')
                ->order('a.create_time','desc')
                ->page($params['page'])
                ->limit($params['pageSize'])
                ->select();
            $sum=Db::name('dealer_points_gifts')
                ->alias('a')
                ->join('dealer_gift b','a.gift_id=b.id')
                ->where('a.dealer_id',$params['dealer_id'])
                ->where('b.gift_name','like','%'.$params['keywords'].'%')
                ->where('a.status',1)
                ->where('a.points_num','>=',number_format($my_points,2))
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
    public function getGiftsInfo(Request $request){
        $params=$request->get();
        $gift_info=Db::name('dealer_gift')
            ->alias('a')
            ->join('dealer_points_gifts b','a.id=b.gift_id')
            ->where('b.id',$params['goods_id'])
            ->field('a.*,b.money,b.points_num,b.type,b.limit_num,b.id as points_gift_id')
            ->find();
        $gift_info['cover']=json_decode( $gift_info['cover'],true);
        return JsonService::returnData(200,'查询成功',$gift_info);
    }
    public function getOrderInfo(Request $request){
        $cartIds=$request->get('cartIds');
        $good_info=[];
        foreach (explode(',',$cartIds) as $key=>$value){
            $info=Db::name('dealer_points_cart')
                ->alias('a')
                ->join('dealer_points_gifts c','a.points_gift_id=c.id')
                ->join('dealer_gift b','c.gift_id=b.id')
                ->where('a.id',$value)
                ->field('a.*,c.money,c.points_num,c.type,c.limit_num,b.cover,b.gift_name')
                ->find();
            $info['cover']=json_decode( $info['cover'],true);
            array_push($good_info,$info);
        }
        return JsonService::returnData(200,'查询成功',$good_info);
    }
}