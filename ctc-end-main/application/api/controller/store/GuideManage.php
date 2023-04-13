<?php
/**
 * Created by PhpStorm.
 * User: wenhan
 * Date: 2022/12/13
 * Time: 上午11:21
 */

namespace app\api\controller\store;
use app\Request;
use think\Controller;
use think\Db;
use app\common\JsonService;

class GuideManage extends Controller
{
    public function getGuideList(Request $request){
        $params=$request->get();
        $list=Db::name('dealer_guide')
            ->where('dealer_id',$params['dealer_id'])
            ->where('store_id',$params['store_id'])
            ->where('status',$params['status']==0?-1:1)
            ->page($params['page'])
            ->limit($params['pageSize'])
            ->select();
        $sum=Db::name('dealer_guide')
            ->where('dealer_id',$params['dealer_id'])
            ->where('store_id',$params['store_id'])
            ->where('status',$params['status']==0?-1:1)
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
    public function checkGuide(Request $request){
        $params=$request->get();
        $res=Db::name('dealer_guide')
            ->where('dealer_id',$params['dealer_id'])
            ->where('id',$params['guide_id'])
            ->update([
                'status'=>$params['check_status']
            ]);
        if($res){
            return JsonService::returnData(200,'操作成功');
        }else{
            return JsonService::returnData(500,'请联系管理员');
        }
    }
    public function getScanRecords(Request $request){
        $params=$request->get();
        if ($params['current'] == 0) {
            $list = Db::name('dealer_guide_query_bill')
                ->alias('a')
                ->leftJoin('dealer_guide b','a.openid=b.openid')
                ->leftJoin('dealer_store c','b.store_id=c.id')
                ->where('c.id', $params['store_id'])
                ->where('c.dealer_id', $params['dealer_id'])
                ->whereTime('a.create_time', 'd')
                ->page($params['page'])
                ->limit($params['pageSize'])
                ->select();
            $sum = Db::name('dealer_guide_query_bill')
                ->alias('a')
                ->leftJoin('dealer_guide b','a.openid=b.openid')
                ->leftJoin('dealer_store c','b.store_id=c.id')
                ->where('c.id', $params['store_id'])
                ->where('c.dealer_id', $params['dealer_id'])
                ->whereTime('a.create_time', 'd')
                ->count();
            $times = Db::name('dealer_guide_query_bill')
                ->alias('a')
                ->leftJoin('dealer_guide b','a.openid=b.openid')
                ->leftJoin('dealer_store c','b.store_id=c.id')
                ->where('c.id', $params['store_id'])
                ->where('c.dealer_id', $params['dealer_id'])
                ->whereTime('a.create_time', 'd')
                ->count('DISTINCT serial_number');
        } else {
            $list = Db::name('dealer_guide_query_bill')
                ->alias('a')
                ->leftJoin('dealer_guide b','a.openid=b.openid')
                ->leftJoin('dealer_store c','b.store_id=c.id')
                ->where('c.id', $params['store_id'])
                ->where('c.dealer_id', $params['dealer_id'])
                ->whereTime('a.create_time', 'w')
                ->page($params['page'])
                ->limit($params['pageSize'])
                ->select();
            $sum = Db::name('dealer_guide_query_bill')
                ->alias('a')
                ->leftJoin('dealer_guide b','a.openid=b.openid')
                ->leftJoin('dealer_store c','b.store_id=c.id')
                ->where('c.id', $params['store_id'])
                ->where('c.dealer_id', $params['dealer_id'])
                ->whereTime('a.create_time', 'w')
                ->count();
            $times = Db::name('dealer_guide_query_bill')
                ->alias('a')
                ->leftJoin('dealer_guide b','a.openid=b.openid')
                ->leftJoin('dealer_store c','b.store_id=c.id')
                ->where('c.id', $params['store_id'])
                ->where('c.dealer_id', $params['dealer_id'])
                ->whereTime('a.create_time', 'w')
                ->count('DISTINCT serial_number');
        }
        $data = [
            'list' => [
                'current_page' => $params['page'],
                'total' => $sum,//扫码次数
                'times' => $times,//扫码个数
                'per_page' => $params['pageSize'],
                'data' => $list
            ]
        ];
        return JsonService::returnData(200, '查询成功', $data);
    }
    public function getRrizeRecords(Request $request){
        $params=$request->get();
        $list=Db::name('dealer_guide_prize_bill')
            ->alias('a')
            ->leftJoin('dealer_guide b','a.openid=b.openid')
            ->leftJoin('dealer_store c','b.store_id=c.id')
            ->where('c.id', $params['store_id'])
            ->where('c.dealer_id', $params['dealer_id'])
            ->field('a.*')
            ->page($params['page'])
            ->limit($params['pageSize'])
            ->select();
        foreach ($list as $key=>$value){
            if($value['prize_type']==3){
                $list[$key]['gift']= json_encode($value['gift'],true);
            }
        }
        $sum=Db::name('dealer_guide_prize_bill')
            ->alias('a')
            ->leftJoin('dealer_guide b','a.openid=b.openid')
            ->leftJoin('dealer_store c','b.store_id=c.id')
            ->where('c.id', $params['store_id'])
            ->where('c.dealer_id', $params['dealer_id'])
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