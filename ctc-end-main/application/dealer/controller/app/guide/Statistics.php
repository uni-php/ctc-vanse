<?php
/**
 * Created by PhpStorm.
 * User: wenhan
 * Date: 2022/11/15
 * Time: 下午10:22
 */

namespace app\dealer\controller\app\guide;
use app\Request;
use think\Controller;
use think\Db;
use app\common\JsonService;
use think\db\Where;

class Statistics extends Controller
{
    protected $dealer_id;
    public function initialize(){
        $userInfo=Request::userInfo();
        $this->dealer_id=array_key_exists('dealer_id',$userInfo)?$userInfo['dealer_id']:$userInfo['id'];
    }
    /**
     * @param Request $request
     * 近七天扫码量统计
     */
    public function getScanNum(Request $request){
        $x_unit=get_weeks();
        $scan_num=[];
        $baseInfo=[];
        foreach ($x_unit as $key=>$value){
            $num=Db::name('dealer_guide_query_bill')
                ->where('dealer_id',$this->dealer_id)
                ->whereBetweenTime('create_time', $value)
                ->count();
            $scan_person=Db::name('dealer_guide_query_bill')
                ->where('dealer_id',$this->dealer_id)
                ->whereBetweenTime('create_time', $value)
                ->distinct(true)
                ->field('openid')
                ->select();
            $activity_num=Db::name('dealer_guide_prize_bill')
                ->where('dealer_id',$this->dealer_id)
                ->whereBetweenTime('create_time', $value)
                ->count();
            $new_member=Db::name('dealer_member')
                ->where('dealer_id',$this->dealer_id)
                ->whereBetweenTime('create_time', $value)
                ->where('sources',1)
                ->count();
            $old_member=count($scan_person)-$new_member;
            array_push($baseInfo,[
                'date'=>$value,
                'scan_num'=>$num,
                'scan_person'=>count($scan_person),
                'join_num'=>$activity_num,
                'new_member'=>$new_member,
                'old_member'=>$old_member
            ]);
            array_push($scan_num,$num);
        }
        $data=[
            'baseInfo'=>$baseInfo,
            'lineChartData'=>[
                'data'=>$scan_num,
                'xData'=>$x_unit
            ]
        ];
        return JsonService::successful('查询成功',$data);
    }

    /**
     * @param Request $request
     * 一周奖品发放量
     */
    public function getGiftsNum(Request $request){
        $x_unit=get_weeks();
        $scan_num=[];
        foreach ($x_unit as $key=>$value){
            $num=Db::name('dealer_guide_prize_bill')
                ->where('dealer_id',$this->dealer_id)
                ->whereBetweenTime('create_time', $value)
                ->where('prize_type',3)
                ->count();
            array_push($scan_num,$num);
        }
        $data=[
            'lineChartData'=>[
                'data'=>$scan_num,
                'xData'=>$x_unit
            ]
        ];
        return JsonService::successful('查询成功',$data);
    }
    /**
     * @param Request $request
     * 扫码地区统计
     */
    public function getScanArea(Request $request){
        $params=$request->get();
        try{
            Db::execute("SET @@sql_mode='';");
        }catch (\Exception $e){

        }
        $condition=[];
        if($params['startTime']){
            $condition['create_time']=['between time',[$params['startTime'],$params['endTime']]];
        }
        $data=Db::name('dealer_guide_query_bill')
            ->where('a.dealer_id',$this->dealer_id)
            ->where(new Where($condition))
            ->field('province as name,count(id) as value')
            ->group('province')
            ->select();
        foreach ($data as $key=>$value){
            if(strpos($value['name'],'省')){
                $data[$key]['name']=substr($value['name'],0,strrpos($value['name'],'省'));
            }
            if(strpos($value['name'],'市')){
                $data[$key]['name']=substr($value['name'],0,strrpos($value['name'],'市'));
            }
        }
        return JsonService::successful('查询成功',$data);
    }
    public function getScanRank(Request $request){
        $params=$request->get();
        try{
            Db::execute("SET @@sql_mode='';");
        }catch (\Exception $e){

        }
        $condition=[];
        if($params['startTime']){
            $condition['create_time']=['between time',[$params['startTime'],$params['endTime']]];
        }
        if($params['status']=='first'){
            $data=Db::name('dealer_guide_prize_bill')
                ->where('a.dealer_id',$this->dealer_id)
                ->where(new Where($condition))
                ->field('member_id as member_id,count(id) as value')
                ->group('openid')
                ->select();
        }else{
            $data=Db::name('dealer_guide_prize_bill')
                ->where('a.dealer_id',$this->dealer_id)
                ->where(new Where($condition))
                ->order('money')
                ->field('member_id as member_id,sum(money) as money')
                ->group('openid')
                ->select();
        }
        return JsonService::successful('查询成功',$data);
    }
    public function getPageData(Request $request){
        $sum_guide=Db::name('dealer_guide')
            ->where('dealer_id',$this->dealer_id)
            ->where('status',1)
            ->count();
        //活动参与总量
        $sum_activity=Db::name('dealer_guide_prize_bill')
            ->where('dealer_id',$this->dealer_id)
            ->count();
        $sum_red_money=Db::name('dealer_guide_prize_bill')
            ->where('dealer_id',$this->dealer_id)
            ->where('prize_type',1)
            ->sum('money');
        $scan_sum=Db::name('dealer_guide_query_bill')
            ->where('dealer_id',$this->dealer_id)
            ->count();
        return JsonService::successful('查询成功',[$sum_guide,$sum_activity,$sum_red_money,$scan_sum]);
    }
}