<?php
/**
 * Created by PhpStorm.
 * User: wenhan
 * Date: 2022/4/28
 * Time: 上午12:29
 */

namespace app\dealer\controller\app\qrcode;
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
            $num=Db::name('dealer_qrcode_marketing_query_bill')
                ->where('dealer_id',$this->dealer_id)
                ->whereBetweenTime('create_time', $value)
                ->count();
            $scan_person=Db::name('dealer_qrcode_marketing_query_bill')
                ->where('dealer_id',$this->dealer_id)
                ->whereBetweenTime('create_time', $value)
                ->distinct(true)
                ->field('openid')
                ->select();
            $activity_num=Db::name('dealer_qrcode_marketing_prize_bill')
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
        $data=Db::name('dealer_qrcode_marketing_query_bill')
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
    public function getScanUser(Request $request){
        $params=$request->param();
        $condition=[];
        if($params['phone']){
            $condition['phone']=['like','%'.$params['phone'].'%'];
        }
        $list=Db::name('dealer_member')
            ->where('dealer_id',$this->dealer_id)
            ->where('nickname','like','%'.$params['nickname'].'%')
            ->where('openid','like','%'.$params['openid'].'%')
            ->page($params['pageNum'])
            ->limit($params['pageSize'])
            ->order('create_time','desc')
            ->select();
        foreach ($list as $key=>$value){
            $list[$key]['scan_times']=Db::name('dealer_qrcode_marketing_query_bill')
                ->where('openid',$value['openid'])
                ->count();
            $list[$key]['join_times']=Db::name('dealer_qrcode_marketing_prize_bill')
                ->where('openid',$value['openid'])
                ->count();
            $list[$key]['red_num']=Db::name('dealer_qrcode_marketing_prize_bill')
                ->where('openid',$value['openid'])
                ->where('prize_type',1)
                ->count();
            $list[$key]['red_money']=Db::name('dealer_qrcode_marketing_prize_bill')
                ->where('openid',$value['openid'])
                ->where('prize_type',1)
                ->sum('money');
            $list[$key]['points']=Db::name('dealer_qrcode_marketing_prize_bill')
                ->where('openid',$value['openid'])
                ->where('prize_type',2)
                ->sum('points');
            $list[$key]['gifts']=Db::name('dealer_qrcode_marketing_prize_bill')
                ->where('openid',$value['openid'])
                ->where('prize_type',3)
                ->count();
        }
        $total=Db::name('dealer_member')
            ->where('dealer_id',$this->dealer_id)
            ->where('nickname','like','%'.$params['nickname'].'%')
            ->where('openid','like','%'.$params['openid'].'%')
            ->count();
        $res=[
            'code'=>200,
            'msg'=>'查询成功',
            'data'=>$list,
            'total'=>$total
        ];
        return json($res);
    }
    public function getPageData(Request $request){
        //活动参与总量
        $sum_activity=Db::name('dealer_qrcode_marketing_prize_bill')
            ->where('dealer_id',$this->dealer_id)
            ->count();
        $sum_red_money=Db::name('dealer_qrcode_marketing_prize_bill')
            ->where('dealer_id',$this->dealer_id)
            ->where('prize_type',1)
            ->sum('money');
        $scan_sum=Db::name('dealer_qrcode_marketing_query_bill')
            ->where('dealer_id',$this->dealer_id)
            ->count();
        return JsonService::successful('查询成功',[$sum_activity,$sum_red_money,$scan_sum]);
    }
}