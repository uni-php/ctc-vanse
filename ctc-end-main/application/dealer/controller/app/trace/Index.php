<?php
/**
 * Created by PhpStorm.
 * User: wenhan
 * Date: 2022/2/9
 * Time: 下午10:30
 */

namespace app\dealer\controller\app\trace;
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
   public function getPageData(Request $request){
        //求赋码总量
       $sum=Db::name('dealer_trace_code_batch')
           ->alias('a')
           ->join('dealer_trace_product_batch b','a.product_batch=b.product_batch')
           ->where('a.dealer_id',$this->dealer_id)
           ->where('a.status',0)
           ->where('b.status',0)
           ->sum('a.quantity');
       $isnot_serial_number=Db::name('dealer_trace_code_batch')
           ->alias('a')
           ->join('dealer_trace_product_batch b','a.product_batch=b.product_batch')
           ->where('a.dealer_id',$this->dealer_id)
           ->where('a.is_serial_number',0)
           ->where('a.status',0)
           ->where('b.status',0)
           ->column('a.code_batch');
       $isnot_serial_number_sum=Db::name('dealer_trace_code_batch')
           ->alias('a')
           ->join('dealer_trace_product_batch b','a.product_batch=b.product_batch')
           ->where('a.dealer_id',$this->dealer_id)
           ->where('a.status',0)
           ->where('b.status',0)
           ->where('a.is_serial_number',1)
           ->where('a.code_batch','in',$isnot_serial_number)
           ->sum('a.quantity');
       $code_sum=$sum-$isnot_serial_number_sum;//赋码总量
       //溯源次数
       $trace_times=Db::name('dealer_trace_query_log')
           ->where('dealer_id',$this->dealer_id)
           ->count();
       //防伪验证次数
       $auth_times=Db::name('dealer_security_query_log')
           ->where('dealer_id',$this->dealer_id)
           ->count();
       $trace_data=$this->getTraceTimes('week');
       $map_data=$this->getAllProvinceTraceData($this->dealer_id);
       return JsonService::successful('查询成功',[[$code_sum,$trace_times,$auth_times],$trace_data,$map_data]);
   }
    /**
     * @param int $type
     * 查询溯源与防伪验证次数
     */
   public function getTraceTimes($type='week'){
        $expectedData=[];
        $actualData=[];
        if($type=='week'){
            $x_unit=get_weeks();
            //查询每日的溯源与防伪查询数量
            foreach ($x_unit as $key=>$value){
                $trace_query_times=Db::name('dealer_trace_query_log')
                    ->where('dealer_id',$this->dealer_id)
                    ->whereBetweenTime('create_time', $value)
                    ->count();
                $auth_query_times=Db::name('dealer_security_query_log')
                    ->where('dealer_id',$this->dealer_id)
                    ->whereBetweenTime('create_time', $value)
                    ->count();
                array_push($expectedData,$trace_query_times);
                array_push($actualData,$auth_query_times);
            }
        }
        if($type='month'){

        }
        return [$x_unit,$expectedData,$actualData];
   }

    /**
     * @param string $dealer_id
     * 查询各省份溯源查询数据
     */
   public function getAllProvinceTraceData($dealer_id=''){
       try{
           Db::execute("SET @@sql_mode='';");
       }catch (\Exception $e){

       }
        $list=Db::name('dealer_trace_query_log')
            ->where('dealer_id',$dealer_id)
            ->field('province as name,count(province) as value')
            ->group('province')
            ->select();
        return $list;
   }
}