<?php
/**
 * Created by PhpStorm.
 * User: wenhan
 * Date: 2022/12/22
 * Time: 下午9:22
 */

namespace app\dealer\controller\app\store;
use app\Request;
use think\Controller;
use think\Db;
use app\common\JsonService;
use think\db\Where;

class Data extends Controller
{
    protected $dealer_id;
    public function initialize(){
        $userInfo=Request::userInfo();
        $this->dealer_id=array_key_exists('dealer_id',$userInfo)?$userInfo['dealer_id']:$userInfo['id'];
    }
    public function getOrderAnalysisData(Request $request){
        $params=$request->get();
        $x_unit=get_weeks();//最近七天
        $data1=$data2=$data3=[];
        foreach ($x_unit as $key=>$value) {
            //门店一周订单数
            $order=Db::name('dealer_store_shop_order')
                ->whereBetweenTime('create_time', $value)
                ->where('dealer_id', $this->dealer_id)
                ->where('store_id',$params['store_id'])
                ->count();
            //门店一周成交额
            $money=Db::name('dealer_store_shop_order')
                ->whereBetweenTime('create_time', $value)
                ->where('dealer_id', $this->dealer_id)
                ->where('store_id',$params['store_id'])
                ->sum('total_price');
            //门店成交人数
            $pay_person=Db::name('dealer_store_shop_order')
                ->whereBetweenTime('create_time', $value)
                ->where('dealer_id', $this->dealer_id)
                ->where('store_id',$params['store_id'])
                ->where('status',2)
                ->count();
            array_push($data1,$order);
            array_push($data2,$money);
            array_push($data3,$pay_person);
        }
        $data=[
            'lineChartData'=>[
                'data1'=>$data1,
                'data2'=>$data2,
                'data3'=>$data3,
                'xData'=>$x_unit
            ]
        ];
        return JsonService::successful('查询成功',$data);
    }
    public function getOrderStatisticsData(Request $request){
        $params=$request->get();
        $list=Db::name('dealer_store')
            ->where('dealer_id', $this->dealer_id)
            ->where('store_name','like','%'.$params['store_name'].'%')
            ->page($params['pageNum'])
            ->limit($params['pageSize'])
            ->select();
        foreach ($list as $key=>$value){
            $list[$key]['order_num']=Db::name('dealer_store_shop_order')
                ->where('dealer_id', $this->dealer_id)
                ->where('store_id',$value['id'])
                ->count();
            $list[$key]['turnover']=Db::name('dealer_store_shop_order')
                ->where('dealer_id', $this->dealer_id)
                ->where('store_id',$value['id'])
                ->where('status',2)
                ->sum('total_price');
            $list[$key]['person_quantity']=Db::name('dealer_store_shop_order')
                ->where('dealer_id', $this->dealer_id)
                ->where('store_id',$value['id'])
                ->where('status',2)
                ->count();
        }
        $total=Db::name('dealer_store')
            ->where('dealer_id', $this->dealer_id)
            ->where('store_name','like','%'.$params['store_name'].'%')
            ->count();
        $res=[
            'code'=>200,
            'msg'=>'查询成功',
            'data'=>$list,
            'total'=>$total
        ];
        return json($res);
    }
    public function getProductAnalysisData(Request $request){
        $params=$request->get();
        $condition=[];
        if($params['startTime']){
            $condition['a.create_time']=['between time',[$params['startTime'],$params['endTime']]];
        }
        $list=Db::name('dealer_store_app_goods')
            ->alias('a')
            ->join('dealer_product b','a.product_id=b.id')
            ->where('a.dealer_id', $this->dealer_id)
            ->where('a.store_id',$params['store_id']?:'not null')
            ->page($params['pageNum'])
            ->limit($params['pageSize'])
            ->field('a.*,b.product_name')
            ->select();
        $order=Db::name('dealer_store_shop_order')
            ->where(new Where($condition))
            ->where('dealer_id',$this->dealer_id)
            ->where('store_id',$params['store_id']?:'not null')
            ->where('status',2)
            ->select();
        foreach ($list as $key=>$value){
            //下单人数 成交件数 成交金额
            $person=$deal_num=$money=0;
            foreach ($order as $k=>$val){
                if($val['pay_mode']!='cart'){
                    $goods_info=json_decode($val['order_goods_info'],true);
                    if($goods_info['id']==$value['product_id']){
                        $deal_num++;
                        $person++;
                        $money=bcadd($money,$goods_info['sale_price'],2);
                    }
                }else{
                    $goods_info=json_decode($val['order_goods_info'],true);
                    foreach ($goods_info as $kk=>$vv){
                        if($vv['product_id']==$value['product_id']){
                            $deal_num+=(int)$vv['goods_num'];
                            $person++;
                            $money=bcadd($money,bcmul($vv['goods_num'],$vv['sale_price'],2),2);
                        }
                    }
                }
            }
            $list[$key]['deal_num']=$deal_num;
            $list[$key]['person']=$person;
            $list[$key]['money']=$money;
        }
        $total=Db::name('dealer_store_app_goods')
            ->where(new Where($condition))
            ->where('dealer_id', $this->dealer_id)
            ->where('store_id',$params['store_id']?:'not null')
            ->count();
        $res=[
            'code'=>200,
            'msg'=>'查询成功',
            'data'=>$list,
            'total'=>$total
        ];
        return json($res);
    }
    public function getProductPanelAnalysisData(Request $request){
        //昨日成交商品
        $order=Db::name('dealer_store_shop_order')
            ->where('dealer_id',$this->dealer_id)
            ->whereTime('create_time', 'yesterday')
            ->where('status',2)
            ->select();
        $goods_num=$number=$goods_sum=$money_sum=0;
        foreach ($order as $key=>$value){
            $number++;
            if($value['pay_mode']!='cart'){
                $goods_num++;
            }else{
                $goods_info=json_decode($value['order_goods_info'],true);
                foreach ($goods_info as $kk=>$vv){
                    $goods_num+=(int)$vv['goods_num'];
                }
            }
        }
        $sum_order=Db::name('dealer_store_shop_order')
            ->where('dealer_id',$this->dealer_id)
            ->where('status',2)
            ->select();
        foreach ($sum_order as $key=>$value){
            $goods_sum++;
            if($value['pay_mode']!='cart'){
                $goods_info=json_decode($value['order_goods_info'],true);
                $money_sum=bcadd($money_sum,$goods_info['sale_price'],2);
            }else{
                $goods_info=json_decode($value['order_goods_info'],true);
                foreach ($goods_info as $kk=>$vv){
                    if($vv['product_id']==$value['product_id']){
                        $money_sum=bcadd($money_sum,bcmul($vv['goods_num'],$vv['sale_price'],2),2);
                    }
                }
            }
        }
        $res=[
            'code'=>200,
            'msg'=>'查询成功',
            'data'=>[$goods_num,$number,$goods_sum,$money_sum]
        ];
        return json($res);
    }
    public function getSurveyData(Request $request){
        try {
            Db::execute("SET @@sql_mode='';");
        } catch (\Exception $e) {
        }
        $x_unit=get_weeks();//最近七天
        $data1=$data2=$data3=[];
        //已成交订单数
        $order=Db::name('dealer_store_shop_order')
            ->where('dealer_id',$this->dealer_id)
            ->where('status',2)
            ->select();
        $goods_num=0;
        //已成交商品数
        foreach ($order as $key=>$value){
            if($value['pay_mode']!='cart'){
                $goods_num++;
            }else{
                $goods_info=json_decode($value['order_goods_info'],true);
                foreach ($goods_info as $kk=>$vv){
                    $goods_num+=(int)$vv['goods_num'];
                }
            }
        }
        //已成交客户数
        $customer=Db::name('dealer_store_shop_order')
            ->where('dealer_id',$this->dealer_id)
            ->where('status',2)
            ->group('openid')
            ->select();
        foreach ($x_unit as $key=>$value) {
            //一周成交订单数
            $week_order=Db::name('dealer_store_shop_order')
                ->whereBetweenTime('create_time', $value)
                ->where('dealer_id', $this->dealer_id)
                ->where('status',0)
                ->count();
            //成交商品数
            $day_order=Db::name('dealer_store_shop_order')
                ->whereBetweenTime('create_time', $value)
                ->where('dealer_id',$this->dealer_id)
                ->where('status',2)
                ->select();
            $chart_goods_num=0;
            //已成交商品数
            foreach ($day_order as $k=>$v){
                if($v['pay_mode']!='cart'){
                    $chart_goods_num++;
                }else{
                    $goods_info=json_decode($v['order_goods_info'],true);
                    foreach ($goods_info as $kk=>$vv){
                        $chart_goods_num+=(int)$vv['goods_num'];
                    }
                }
            }
            //成交客户
            $person=Db::name('dealer_store_shop_order')
                ->whereBetweenTime('create_time', $value)
                ->where('dealer_id',$this->dealer_id)
                ->where('status',2)
                ->group('openid')
                ->count();
            array_push($data1,$week_order);
            array_push($data2,$chart_goods_num);
            array_push($data3,$person);
        }
        $res=[
            'code'=>200,
            'msg'=>'查询成功',
            'data'=>[
                'baseInfo'=>[count($order),$goods_num,count($customer)],
                'lineChartData'=>[
                    'data1'=>$data1,
                    'data2'=>$data2,
                    'data3'=>$data3,
                    'xData'=>$x_unit
                ]
            ]
        ];
        return json($res);
    }
}