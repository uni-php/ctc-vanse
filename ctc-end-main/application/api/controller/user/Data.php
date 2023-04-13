<?php
/**
 * Created by PhpStorm.
 * User: wenhan
 * Date: 2022/11/25
 * Time: 上午1:01
 */

namespace app\api\controller\user;
use app\Request;
use think\Controller;
use app\lib\helper;
use think\Db;
use app\common\JsonService;
use think\db\Where;

class Data extends Controller
{
    public function getRrizeRecords(Request $request){
        $params=$request->get();
        $list=Db::name('dealer_qrcode_marketing_prize_bill')
            ->where('openid',$params['openid'])
            ->where('dealer_id',$params['dealer_id'])
            ->page($params['page'])
            ->limit($params['pageSize'])
            ->select();
        foreach ($list as $key=>$value){
            if($value['prize_type']==3){
                $list[$key]['gift']= json_decode($value['gift'],true);
            }
        }
        $sum=Db::name('dealer_qrcode_marketing_prize_bill')
            ->where('openid',$params['openid'])
            ->where('dealer_id',$params['dealer_id'])
            ->count();
        $data = [
            'list' => [
                'current_page' => $params['page'],
                'total' => $sum,
                'per_page' => $params['pageSize'],
                'data' => $list
            ]
        ];
        return JsonService::returnData(200, '查询成功', $data);
    }
}