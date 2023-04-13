<?php
/**
 * Created by PhpStorm.
 * User: wenhan
 * Date: 2022/11/21
 * Time: 下午2:58
 */

namespace app\api\controller\guide;
use app\Request;
use think\Controller;
use app\lib\helper;
use think\Db;
use app\common\JsonService;
use think\db\Where;

class UserCenter extends Controller
{
    public function getUserCenterPage(Request $request){
        $params=$request->get();
        $pageSet=Db::name('dealer_guide_userinfo_page')
            ->where('dealer_id',$params['dealer_id'])
            ->find();
        $guide_group=Db::name('dealer_guide')
            ->alias('a')
            ->join('dealer_guide_group b','a.group_id=b.id')
            ->where('a.openid',$params['openid'])
            ->where('a.dealer_id',$params['dealer_id'])
            ->field('b.*')
            ->find();
        $pageSet['guide_group']=$guide_group;
        return JsonService::returnData(200,'查询成功',$pageSet);
    }
    public function getGuideGroupInfo(Request $request){
        $params=$request->get();
        $guide_group=Db::name('dealer_guide')
            ->alias('a')
            ->join('dealer_guide_group b','a.group_id=b.id')
            ->where('a.openid',$params['openid'])
            ->where('a.dealer_id',$params['dealer_id'])
            ->field('b.*')
            ->find();
        $guide_group['rank_type']=json_decode($guide_group['rank_type'],true);
        $guide_group['prize_rank_time']=json_decode($guide_group['prize_rank_time'],true);
        $guide_group['red_rank_time']=json_decode($guide_group['red_rank_time'],true);
        return JsonService::returnData(200,'查询成功',$guide_group);
    }
    public function getScanRecords(Request $request)
    {
        $params = $request->get();
        if ($params['current'] == 0) {
            $list = Db::name('dealer_guide_query_bill')
                ->where('openid', $params['openid'])
                ->where('dealer_id', $params['dealer_id'])
                ->whereTime('create_time', 'd')
                ->page($params['page'])
                ->limit($params['pageSize'])
                ->select();
            $sum = Db::name('dealer_guide_query_bill')
                ->where('openid', $params['openid'])
                ->where('dealer_id', $params['dealer_id'])
                ->whereTime('create_time', 'd')
                ->count();
            $times = Db::name('dealer_guide_query_bill')
                ->where('openid', $params['openid'])
                ->where('dealer_id', $params['dealer_id'])
                ->whereTime('create_time', 'd')
                ->count('DISTINCT serial_number');
        } else {
            $list = Db::name('dealer_guide_query_bill')
                ->where('openid', $params['openid'])
                ->where('dealer_id', $params['dealer_id'])
                ->whereTime('create_time', 'w')
                ->page($params['page'])
                ->limit($params['pageSize'])
                ->select();
            $sum = Db::name('dealer_guide_query_bill')
                ->where('openid', $params['openid'])
                ->where('dealer_id', $params['dealer_id'])
                ->whereTime('create_time', 'w')
                ->count();
            $times = Db::name('dealer_guide_query_bill')
                ->where('openid', $params['openid'])
                ->where('dealer_id', $params['dealer_id'])
                ->whereTime('create_time', 'w')
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
            ->where('openid',$params['openid'])
            ->where('dealer_id',$params['dealer_id'])
            ->page($params['page'])
            ->limit($params['pageSize'])
            ->select();
        foreach ($list as $key=>$value){
            if($value['prize_type']==3){
                $list[$key]['gift']= json_encode($value['gift'],true);
            }
        }
        $sum=Db::name('dealer_guide_prize_bill')
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
    public function getGuideUserInfo(Request $request){
        $params=$request->get();
        $info=Db::name('dealer_guide')
            ->alias('a')
            ->join('dealer_store b','a.store_id=b.id')
            ->join('dealer_guide_group c','a.group_id=c.id')
            ->where('a.openid',$params['openid'])
            ->where('a.dealer_id',$params['dealer_id'])
            ->field('a.*,b.store_name,c.group_name')
            ->find();
        $info['address']=$info['province'].$info['city'].$info['district'].$info['address'];
        return JsonService::returnData(200, '查询成功', $info);
    }
    public function getRankList(Request $request){
        $params=$request->get();
        try{
            Db::execute("SET @@sql_mode='';");
        }catch (\Exception $e){

        }
        $time='1970-10-1';
        if($params['current_tab_name']=='week'){
            $time='w';
        }
        if($params['current_tab_name']=='month'){
            $time='m';
        }
        if($params['current_tab_name']=='year'){
            $time='y';
        }
        if($params['current_name']=='prize'){
            //扫码领奖排行榜
            $list=Db::name('dealer_guide_prize_bill')
                ->alias('a')
                ->join('dealer_member b','a.openid=b.openid and a.dealer_id=b.dealer_id')
                ->join('dealer_guide c','a.openid=c.openid and a.dealer_id=c.dealer_id')
                ->where('a.openid',$params['openid'])
                ->where('a.dealer_id',$params['dealer_id'])
                ->whereTime('a.create_time',$time)
                ->limit($params['limit'])
                ->field('c.name,b.headimgurl,count(a.openid) as num')
                ->group('a.openid')
                ->select();
        }else{
            //红包排行榜
            $list=Db::name('dealer_guide_prize_bill')
                ->alias('a')
                ->join('dealer_member b','a.openid=b.openid and a.dealer_id=b.dealer_id')
                ->join('dealer_guide c','a.openid=c.openid and a.dealer_id=c.dealer_id')
                ->where('a.openid',$params['openid'])
                ->where('a.dealer_id',$params['dealer_id'])
                ->whereTime('a.create_time',$time)
                ->where('a.prize_type',1)
                ->limit($params['limit'])
                ->field('c.name,b.headimgurl,count(a.openid) as num')
                ->group('a.openid')
                ->select();
        }
        return JsonService::returnData(200, '查询成功', $list);
    }
}