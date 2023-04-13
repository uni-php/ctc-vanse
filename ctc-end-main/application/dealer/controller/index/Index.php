<?php
/**
 * Created by PhpStorm.
 * User: wenhan
 * Date: 2022/4/15
 * Time: 下午1:21
 */

namespace app\dealer\controller\index;
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
    /**
     * @param Request $request
     * 品牌商首页数据
     */
    public function getPageData(Request $request){
        //日生码量与总生码量
        $day_code_num=Db::name('code_manage')
            ->where('dealer_id',$this->dealer_id)
            ->where('enable',1)
            ->where('is_del',0)
            ->whereTime('create_time', 'today')
            ->sum('count');
        $sum_code_num=Db::name('code_manage')
            ->where('dealer_id',$this->dealer_id)
            ->where('enable',1)
            ->where('is_del',0)
            ->sum('count');
        //会员日注册与总注册量
        $day_customer_num=Db::name('dealer_member')
            ->where('dealer_id',$this->dealer_id)
            ->whereTime('create_time', 'today')
            ->count();
        $sum_customer_num=Db::name('dealer_member')
            ->where('dealer_id',$this->dealer_id)
            ->count();
        //门店注册量
        $day_store_num=Db::name('dealer_store')
            ->where('dealer_id',$this->dealer_id)
            ->where('status','<>',3)
            ->whereTime('create_time', 'today')
            ->count();
        $sum_store_num=Db::name('dealer_store')
            ->where('dealer_id',$this->dealer_id)
            ->where('status','<>',3)
            ->count();
        //经销商注册量
        $day_distributor_num=Db::name('dealer_distributor')
            ->where('dealer_id',$this->dealer_id)
            ->where('status',0)
            ->whereTime('create_time', 'today')
            ->count();
        $sum_distributor_num=Db::name('dealer_distributor')
            ->where('dealer_id',$this->dealer_id)
            ->where('status',0)
            ->count();
        //会员趋势
        $x_unit=get_weeks();//近一周日期
        $weeksCk=[];
        foreach ($x_unit as $key=>$value){
            $dayCk=Db::name('dealer_member')
                ->where('dealer_id',$this->dealer_id)
                ->whereBetweenTime('create_time', $value)
                ->count();
            array_push($weeksCk,$dayCk);
        }
        $data=[
          'code'=>[$day_code_num,$sum_code_num],
          'customer'=>[$day_customer_num,$sum_customer_num],
          'store'=>[$day_store_num,$sum_store_num],
          'distributor'=>[$day_distributor_num,$sum_distributor_num],
            'memberEchart'=>[
                'xData'=>$x_unit,
                'data1'=>$weeksCk
            ],
        ];
        return JsonService::successful('查询成功',$data);
    }
}