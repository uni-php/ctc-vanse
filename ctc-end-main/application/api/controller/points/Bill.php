<?php
/**
 * Created by PhpStorm.
 * User: wenhan
 * Date: 2022/8/14
 * Time: 上午12:10
 */

namespace app\api\controller\points;
use app\Request;
use think\Controller;
use think\Db;
use app\common\JsonService;

class Bill extends Controller
{
    /**
     * @param Request $request
     * 积分详情
     */
    public function getPointsBill(Request $request){
        $params=$request->get();
        $list=Db::name('dealer_member_bill')
            ->where('dealer_id',$params['dealer_id'])
            ->where('member_id',$params['member_id'])
            ->where('type',3)
            ->page($params['page'])
            ->limit($params['pageSize'])
            ->select();
        $sum=Db::name('dealer_member_bill')
            ->where('dealer_id',$params['dealer_id'])
            ->where('member_id',$params['member_id'])
            ->where('type',3)
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
    public function getPointsType(){
        $list=Db::name('dict_data')
            ->where('dict_type','integral_grant_app')
            ->where('status',0)
            ->select();
        return JsonService::returnData(200,'查询成功',$list);
    }
}