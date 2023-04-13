<?php
/**
 * Created by PhpStorm.
 * User: wenhan
 * Date: 2022/3/11
 * Time: 下午10:15
 */

namespace app\dealer\controller\app\mall;
use app\Request;
use think\Controller;
use think\Db;
use app\common\JsonService;
use think\db\Where;

class Index extends Controller
{
    protected $dealer_id;
    public function initialize(){
        $userInfo=Request::userInfo();
        $this->dealer_id=array_key_exists('dealer_id',$userInfo)?$userInfo['dealer_id']:$userInfo['id'];
    }
    public function getMallDashboard(Request $request){
        $x_unit=get_weeks();
        $yes_order=Db::name('dealer_mall_order')
            ->where('dealer_id',$this->dealer_id)
            ->whereTime('create_time', 'yesterday')
            ->where('status','in',[0,1,2,3])
            ->count();
        $yes_fee=Db::name('dealer_mall_order')
            ->where('dealer_id',$this->dealer_id)
            ->whereTime('create_time', 'yesterday')
            ->where('status','in',[0,1,2,3])
            ->sum('pay_price');
        $weeks_order=Db::name('dealer_mall_order')
            ->where('dealer_id',$this->dealer_id)
            ->whereTime('create_time', 'between', [$x_unit[0], $x_unit[6]])
            ->where('status','in',[0,1,2,3])
            ->count();
        $weeks_fee=Db::name('dealer_mall_order')
            ->where('dealer_id',$this->dealer_id)
            ->whereTime('create_time', 'between', [$x_unit[0], $x_unit[6]])
            ->where('status','in',[0,1,2,3])
            ->sum('pay_price');
        $sum_order=Db::name('dealer_mall_order')
            ->where('dealer_id',$this->dealer_id)
            ->where('status','in',[0,1,2,3])
            ->count();
        $sum_fee=Db::name('dealer_mall_order')
            ->where('dealer_id',$this->dealer_id)
            ->where('status','in',[0,1,2,3])
            ->sum('pay_price');
        $data1=$data2=[];
        foreach ($x_unit as $key=>$value){
            $order=Db::name('dealer_mall_order')
                ->where('dealer_id',$this->dealer_id)
                ->whereBetweenTime('create_time', $value)
                ->where('status','in',[0,1,2,3])
                ->count();
            $fee=Db::name('dealer_mall_order')
                ->where('dealer_id',$this->dealer_id)
                ->whereBetweenTime('create_time', $value)
                ->where('status','in',[0,1,2,3])
                ->sum('pay_price');
            array_push($data1,$order);
            array_push($data2,$fee);
        }
        $data=[
          'baseInfo'=>[
           'yes_order'=>$yes_order,
           'yes_fee'=>$yes_fee,
           'weeks_order'=>$weeks_order,
           'weeks_fee'=>$weeks_fee,
           'sum_order'=>$sum_order,
           'sum_fee'=>$sum_fee
          ],
           'lineChartData'=>[
               'data1'=>$data1,
               'data2'=> $data2,
               'xData'=>$x_unit
           ]
        ];
        return JsonService::successful('查询成功',$data);
    }
}