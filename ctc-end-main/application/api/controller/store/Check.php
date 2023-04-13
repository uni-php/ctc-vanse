<?php
/**
 * Created by PhpStorm.
 * User: wenhan
 * Date: 2022/12/15
 * Time: 下午11:23
 */

namespace app\api\controller\store;
use app\Request;
use think\Controller;
use think\Db;
use app\common\JsonService;

class Check extends Controller
{
    public function checkOrderQrcode(Request $request){
        $params=$request->get();
        $res=Db::name('dealer_qrcode_marketing_order')
            ->where('dealer_id',$params['dealer_id'])
            ->where('id',$params['order_id'])
            ->update([
                'status'=>2,
                'store_id'=>$params['store_id'],
                'is_get'=>1,
                'check_time'=>date("Y-m-d H:i:s")
            ]);
        if($res){
            return JsonService::returnData(200,'核销成功');
        }else if($res==0){
            return JsonService::returnData(200,'该二维码已核销核销');
        }else{
            return JsonService::returnData(500,'请联系管理员');
        }
    }
    public function getCheckLog(Request $request){
        $params=$request->get();
        $list=Db::name('dealer_qrcode_marketing_order')
            ->where('store_id',$params['store_id'])
            ->where('dealer_id',$params['dealer_id'])
            ->where('order','like','%'.$params['keywords'].'%')
            ->where('gift','like','%'.$params['keywords'].'%')
            ->where('get_prize_mode',1)
            ->page($params['page'])
            ->limit($params['pageSize'])
            ->order('check_time','desc')
            ->select();
        $sum=Db::name('dealer_qrcode_marketing_order')
            ->where('store_id',$params['store_id'])
            ->where('dealer_id',$params['dealer_id'])
            ->where('order','like','%'.$params['keywords'].'%')
            ->where('gift','like','%'.$params['keywords'].'%')
            ->where('get_prize_mode',1)
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