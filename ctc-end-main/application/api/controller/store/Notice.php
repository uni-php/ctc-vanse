<?php
/**
 * Created by PhpStorm.
 * User: wenhan
 * Date: 2022/12/12
 * Time: 下午3:49
 */

namespace app\api\controller\store;
use app\Request;
use think\Controller;
use think\Db;
use app\common\JsonService;

class Notice extends Controller
{
    public function getNoticeList(Request $request){
        $params=$request->get();
        $list=Db::name('dealer_customer_notice')
            ->where('dealer_id',$params['dealer_id'])
            ->where('status',0)
            ->page($params['page'])
            ->limit($params['pageSize'])
            ->order('create_time','desc')
            ->select();
        $sum=Db::name('dealer_customer_notice')
            ->where('dealer_id',$params['dealer_id'])
            ->where('status',0)
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
    public function getNoticeInfo(Request $request){
        $id=$request->param('notice_id');
        $res=Db::name('dealer_customer_notice')
            ->where('id',$id)
            ->find();
        return JsonService::returnData(200,'查询成功',$res);
    }
}