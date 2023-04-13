<?php
/**
 * Created by PhpStorm.
 * User: wenhan
 * Date: 2022/4/8
 * Time: 上午12:08
 */

namespace app\dealer\controller\app\logistics;
use app\Request;
use think\Controller;
use think\Db;
use app\common\JsonService;
use think\db\Where;

class Board extends Controller
{
    protected $dealer_id;
    public function initialize(){
        $userInfo=Request::userInfo();
        $this->dealer_id=array_key_exists('dealer_id',$userInfo)?$userInfo['dealer_id']:$userInfo['id'];
    }

    /**
     * @param Request $request
     * 物流主页数据
     */
    public function getPageData(Request $request){
        //求经销商总量
        $distributor_sum=Db::name('dealer_distributor')
            ->where('dealer_id',$this->dealer_id)
            ->where('status',0)
            ->count();
        //直属门店数
        $store_sum=Db::name('dealer_store')
            ->where('is_self',0)
            ->where('status','<>',3)
            ->count();
        //出货总数
        $ck_num=Db::name('dealer_logistics_ck_code')
            ->where('dealer_id',$this->dealer_id)
            ->where('is_return',0)
            ->sum('ck_num');
        //窜货次数
        $ch_num=Db::name('dealer_logistics_ch_order')
            ->where('dealer_id',$this->dealer_id)
            ->sum('ch_num');

        $trace_data=$this->getTraceTimes('week');
        return JsonService::successful('查询成功',[[$distributor_sum,$store_sum,$ck_num,$ch_num],$trace_data]);
    }
    public function getTraceTimes($type='week'){
        $expectedData=[];
        if($type=='week'){
            $x_unit=get_weeks();
            foreach ($x_unit as $key=>$value){
                $trace_query_times=Db::name('dealer_logistics_ck_code')
                    ->where('dealer_id',$this->dealer_id)
                    ->whereBetweenTime('create_time', $value)
                    ->sum('ck_num');
                array_push($expectedData,$trace_query_times);
            }
        }
        if($type='month'){

        }
        return [$x_unit,$expectedData];
    }
}