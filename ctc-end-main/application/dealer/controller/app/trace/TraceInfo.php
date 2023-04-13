<?php
/**
 * Created by PhpStorm.
 * User: wenhan
 * Date: 2022/1/14
 * Time: 下午11:41
 */

namespace app\dealer\controller\app\trace;
use app\Request;
use think\Controller;
use think\Db;
use app\common\JsonService;
use think\db\Where;

class TraceInfo extends Controller
{
    protected $dealer_id;
    public function initialize(){
        $userInfo=Request::userInfo();
        $this->dealer_id=array_key_exists('dealer_id',$userInfo)?$userInfo['dealer_id']:$userInfo['id'];
    }
    public function queryTraceInfo(Request $request){
        $params=$request->get();
        if($params['type']==2){
            //直接查询生产批次
            $info=Db::name('dealer_trace_product_batch')
                ->alias('a')
                ->join('dealer_product b','a.product_id=b.id')
                ->where('a.dealer_id',$this->dealer_id)
                ->where('product_batch',$params['content'])
                ->field('a.*,b.code,b.product_name,b.cover,b.details')
                ->find();
            if(!$info) return JsonService::successful('该生产批次号不存在。',null);
            return JsonService::successful('查询成功',$info);
        }else{
            //查看溯源码批次是否激活
            $batch_info=Db::name('code_manage')->where('batch',$params['code_batch'])->find();
            $number=(int)preg_replace('/^0+/','',$params['content']);
            if($batch_info['status']==0) return JsonService::successful('此码批次号未启用。',null);
            if($batch_info['status']==2){
                //部分启用 查询是否在启用区间
                $is_active=Db::name('code_enable')
                    ->where('batch',$params['code_batch'])
                    ->where('start_code','<=',$number)
                    ->where('end_code','>=',$number)
                    ->find();
                if(!$is_active) return JsonService::successful('此码不属于该批次。',null);
            }
            //查询是否有匹配到溯源码批次
            $is_not_serial_batch=Db::name('dealer_trace_code_batch')
                ->where('code_batch',$params['code_batch'])
                ->where('is_serial_number',0)
                ->where('status',0)
                ->find();
            $is_serial_batch=Db::name('dealer_trace_code_batch')
                ->where('code_batch',$params['code_batch'])
                ->where('is_serial_number',1)
                ->where('status',0)
                ->select();
            if(!$is_not_serial_batch&&count($is_serial_batch)==0){
                return JsonService::successful('此码批次号或流水号暂无赋码记录。',null);
            }else if(count($is_serial_batch)==0){
                //按批次设置
                $info=Db::name('dealer_trace_product_batch')
                    ->alias('a')
                    ->join('dealer_product b','a.product_id=b.id')
                    ->where('a.dealer_id',$this->dealer_id)
                    ->where('a.status',0)
                    ->where('product_batch',$is_not_serial_batch['product_batch'])
                    ->field('a.*,b.code,b.product_name,b.cover,b.details')
                    ->find();
                if(!$info) return JsonService::successful('此码批次号或流水号暂无赋码记录',$info);
                return JsonService::successful('查询成功',$info);
            }else{
                //按流水设置
                $batch=Db::name('dealer_trace_code_batch')
                    ->alias('a')
                    ->join('dealer_trace_product_batch b','a.product_batch=b.product_batch')
                    ->where('a.code_batch',$params['code_batch'])
                    ->where('a.status',0)
                    ->where('b.status',0)
                    ->where('a.order_begin','<=',$number)
                    ->where('a.order_end','>=',$number)
                    ->field('a.*')
                    ->find();
                if(!$batch) return JsonService::successful('此码批次号或流水号暂无赋码记录。',null);
                $info=Db::name('dealer_trace_product_batch')
                    ->alias('a')
                    ->join('dealer_product b','a.product_id=b.id')
                    ->where('a.dealer_id',$this->dealer_id)
                    ->where('product_batch',$batch['product_batch'])
                    ->where('a.status',0)
                    ->field('a.*,b.code,b.product_name,b.cover,b.details')
                    ->find();
                if(!$info) return JsonService::successful('此码批次号或流水号暂无赋码记录','');
                return JsonService::successful('查询成功',$info);
            }
        }
    }
    public function getTraceQueryDetail(Request $request){
        $params=$request->get();
        if($params['startTime']){
            $condition['a.create_time']=['between time',[$params['startTime'],$params['endTime']]];
        }
        $condition['a.product_batch']=['like','%'.$params['product_batch'].'%'];
        $condition['a.product_name']=['like','%'.$params['product_name'].'%'];
        $condition['b.nickname']=['like','%'.$params['nickname'].'%'];
        $condition['a.address']=['like','%'.$params['address'].'%'];
        $condition['b.phone']=['like','%'.$params['phone'].'%'];
        $list=Db::name('dealer_trace_query_log')
            ->alias('a')
            ->join('dealer_member b','a.member_id=b.id')
            ->where(new Where($condition))
            ->where('a.serial_number',$params['serial_number']?$params['serial_number']:'not null')
            ->where('a.code_batch',$params['code_batch']?$params['code_batch']:'not null')
//            ->where('a.security',$params['security']?$params['security']:'not null')
            ->where('a.scan_type',$params['scan_type']?$params['scan_type']:'not null')
            ->where('a.is_first',$params['is_first']?$params['is_first']:'not null')
            ->page($params['pageNum'])
            ->limit($params['pageSize'])
            ->order('a.create_time','desc')
            ->field('a.*,b.nickname,b.id as user_id')
            ->select();
        $total=Db::name('dealer_trace_query_log')
            ->alias('a')
            ->join('dealer_member b','a.member_id=b.id')
            ->where(new Where($condition))
            ->where('a.serial_number',$params['serial_number']?$params['serial_number']:'not null')
            ->where('a.code_batch',$params['code_batch']?$params['code_batch']:'not null')
//            ->where('a.security',$params['security']?$params['security']:'not null')
            ->where('a.scan_type',$params['scan_type']?$params['scan_type']:'not null')
            ->where('a.is_first',$params['is_first']?$params['is_first']:'not null')
            ->count();
        $res=[
            'code'=>200,
            'msg'=>'查询成功',
            'data'=>$list,
            'total'=>$total
        ];
        return json($res);
    }
}