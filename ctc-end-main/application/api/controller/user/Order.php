<?php
/**
 * Created by PhpStorm.
 * User: wenhan
 * Date: 2022/12/14
 * Time: 下午11:37
 */

namespace app\api\controller\user;
use app\Request;
use think\Controller;
use think\Db;
use app\common\JsonService;
use think\db\Where;

class Order extends Controller
{
    public function getMarketingOrderList(Request $request){
        $params=$request->get();
        if($params['status']=='-3'){
            $condition['a.valid_day']=['<=', time()];
        }else{
            $condition['a.status']=[$params['status']==-2?'not null':$params['status']];
        }
        $list=Db::name('dealer_qrcode_marketing_order')
            ->alias('a')
            ->join('dealer_member b','a.openid=b.openid and a.dealer_id=b.dealer_id')
            ->where(new Where($condition))
            ->where('a.dealer_id',$params['dealer_id'])
            ->where('a.openid',$params['openid'])
            ->order('a.create_time','desc')
            ->field('a.*,b.nickname')
            ->select();
        return JsonService::returnData(200,'查询成功',$list);
    }
    public function registerOrderAddress(Request $request){
        $params=$request->post();
        $res=Db::name('dealer_qrcode_marketing_order')
            ->where('id',$params['id'])
            ->where('dealer_id',$params['dealer_id'])
            ->update([
               'user_address_id'=>$params['user_address_id']
            ]);
        if($res){
            return JsonService::returnData(200,'登记成功');
        }else{
            return JsonService::returnData(500,'请联系管理员');
        }
    }
    public function getOrderDesById(Request $request){
        $params=$request->get();
        $info=Db::name('dealer_qrcode_marketing_order')
            ->where('id',$params['order_id'])
            ->where('dealer_id',$params['dealer_id'])
            ->find();
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
    public function receiving(Request $request){
        $params=$request->get();
        $res=Db::name('dealer_qrcode_marketing_order')
            ->where('openid',$params['openid'])
            ->where('dealer_id',$params['dealer_id'])
            ->where('id',$params['order_id'])
            ->update([
                'status'=>2,
                'is_get'=>1
            ]);
        if($res){
            return JsonService::returnData(200,'收货成功');
        }else{
            return JsonService::returnData(500,'请联系管理员');
        }
    }
}