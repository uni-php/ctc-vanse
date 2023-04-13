<?php
/**
 * Created by PhpStorm.
 * User: wenhan
 * Date: 2022/3/13
 * Time: 上午12:32
 */

namespace app\dealer\controller\app\points;
use app\Request;
use think\Controller;
use think\Db;
use app\common\JsonService;
use think\db\Where;

class Gifts extends Controller
{
    protected $dealer_id;
    public function initialize(){
        $userInfo=Request::userInfo();
        $this->dealer_id=array_key_exists('dealer_id',$userInfo)?$userInfo['dealer_id']:$userInfo['id'];
    }
    public function savePointsGift(Request $request){
        $data=$request->post();
        $data['update_time']=date("Y-m-d H:i:s");
        $data['limit_num_type']=json_encode($data['limit_num_type']);
        if(array_key_exists('id',$data)){
            $res=Db::name('dealer_points_gifts')->update($data);
        }else{
            $data['dealer_id']=$this->dealer_id;
            $res=Db::name('dealer_points_gifts')->insert($data);
        }
        if($res||$res==0){
            return JsonService::successful('保存成功');
        }else{
            return JsonService::fail('请联系管理员');
        }
    }
    public function getPointsGiftList(Request $request){
        $params=$request->get();
        $list=Db::name('dealer_points_gifts')
            ->alias('a')
            ->join('dealer_gift b','a.gift_id=b.id')
            ->where('a.dealer_id',$this->dealer_id)
            ->where('b.gift_name','like','%'.$params['gift_name'].'%')
            ->where('a.type','like','%'.$params['type'].'%')
            ->where('a.status','like','%'.$params['status'].'%')
            ->order('a.create_time','desc')
            ->field('a.*,b.code,b.gift_name')
            ->page($params['pageNum'])
            ->limit($params['pageSize'])
            ->select();
        $total=Db::name('dealer_points_gifts')
            ->alias('a')
            ->join('dealer_gift b','a.gift_id=b.id')
            ->where('a.dealer_id',$this->dealer_id)
            ->where('b.gift_name','like','%'.$params['gift_name'].'%')
            ->where('a.type','like','%'.$params['type'].'%')
            ->where('a.status','like','%'.$params['status'].'%')
            ->count();
        $res=[
            'code'=>200,
            'msg'=>'查询成功',
            'data'=>$list,
            'total'=>$total
        ];
        return json($res);
    }
    public function cutPointsGift(Request $request){
        $params=$request->get();
        $res=Db::name('dealer_points_gifts')
            ->update($params);
        if($res){
            return JsonService::successful('操作成功');
        }else{
            return JsonService::fail('请联系管理员');
        }
    }
    public function queryGiftInfo(Request $request){
        $gift_id=$request->param('gift_id');
        $info=Db::name('dealer_points_gifts')
            ->alias('a')
            ->join('dealer_gift b','a.gift_id=b.id')
            ->where('a.id',$gift_id)
            ->field('a.*,b.code,b.gift_name,b.stock')
            ->find();
        $info['limit_num_type']=json_decode($info['limit_num_type'],true);
        return JsonService::successful('查询成功',$info);
    }
    public function queryPointsMallData(Request $request){
        $x_unit=get_weeks();//最近七天
        $data1=$data2=$data3=$data4=[];
        //积分订单数
        $yes_order=Db::name('dealer_points_order')
            ->where('dealer_id',$this->dealer_id)
            ->whereTime('create_time', 'yesterday')
            ->where('status','in',[0,1,2,3])
            ->count();
        $weeks_order=Db::name('dealer_points_order')
            ->where('dealer_id',$this->dealer_id)
            ->whereTime('create_time', 'between', [$x_unit[0], $x_unit[6]])
            ->where('status','in',[0,1,2,3])
            ->count();
        $sum_order=Db::name('dealer_points_order')
            ->where('dealer_id',$this->dealer_id)
            ->where('status','in',[0,1,2,3])
            ->count();
        //礼品兑换数
        $yes_exchange=Db::name('dealer_points_order')
            ->where('dealer_id', $this->dealer_id)
            ->whereTime('create_time', 'yesterday')
            ->where('status', 'in', [0, 1, 2, 3])
            ->sum('total_num');
        $weeks_exchange=Db::name('dealer_points_order')
            ->where('dealer_id', $this->dealer_id)
            ->whereTime('create_time', 'between', [$x_unit[0], $x_unit[6]])
            ->where('status', 'in', [0, 1, 2, 3])
            ->sum('total_num');
        $sum_exchange=Db::name('dealer_points_order')
            ->where('dealer_id', $this->dealer_id)
            ->where('status', 'in', [0, 1, 2, 3])
            ->sum('total_num');
        //消耗积分
        $yes_points=Db::name('dealer_points_order')
            ->where('dealer_id', $this->dealer_id)
            ->whereTime('create_time', 'yesterday')
            ->where('status', 'in', [0, 1, 2, 3])
            ->sum('total_points');
        $weeks_points=Db::name('dealer_points_order')
            ->where('dealer_id', $this->dealer_id)
            ->whereTime('create_time', 'between', [$x_unit[0], $x_unit[6]])
            ->where('status', 'in', [0, 1, 2, 3])
            ->sum('total_points');
        $sum_points=Db::name('dealer_points_order')
            ->where('dealer_id', $this->dealer_id)
            ->where('status', 'in', [0, 1, 2, 3])
            ->sum('total_points');
        //消耗金额
        $yes_money=Db::name('dealer_points_order')
            ->where('dealer_id', $this->dealer_id)
            ->whereTime('create_time', 'yesterday')
            ->where('status', 'in', [0, 1, 2, 3])
            ->sum('total_price');
        $weeks_money=Db::name('dealer_points_order')
            ->where('dealer_id', $this->dealer_id)
            ->whereTime('create_time', 'between', [$x_unit[0], $x_unit[6]])
            ->where('status', 'in', [0, 1, 2, 3])
            ->sum('total_price');
        $sum_money=Db::name('dealer_points_order')
            ->where('dealer_id', $this->dealer_id)
            ->where('status', 'in', [0, 1, 2, 3])
            ->sum('total_price');

        foreach ($x_unit as $key=>$value) {
            //积分订单
            $order = Db::name('dealer_points_order')
                ->where('dealer_id', $this->dealer_id)
                ->whereBetweenTime('create_time', $value)
                ->where('status', 'in', [0, 1, 2, 3])
                ->count();
            //礼品兑换量(订单商品总数)
            $excharge_num=Db::name('dealer_points_order')
                ->where('dealer_id', $this->dealer_id)
                ->whereBetweenTime('create_time', $value)
                ->where('status', 'in', [0, 1, 2, 3])
                ->sum('total_num');
            //消耗积分
            $points=Db::name('dealer_points_order')
                ->where('dealer_id', $this->dealer_id)
                ->whereBetweenTime('create_time', $value)
                ->where('status', 'in', [0, 1, 2, 3])
                ->sum('total_points');
            //消耗金额
            $money=Db::name('dealer_points_order')
                ->where('dealer_id', $this->dealer_id)
                ->whereBetweenTime('create_time', $value)
                ->where('status', 'in', [0, 1, 2, 3])
                ->sum('total_price');
            array_push($data1,$order);
            array_push($data2,$excharge_num);
            array_push($data3,$points);
            array_push($data4,$money);
        }
        $data=[
            'baseInfo'=>[
                'yes_order'=>$yes_order,
                'yes_exchange'=>$yes_exchange,
                'weeks_order'=>$weeks_order,
                'weeks_exchange'=>$weeks_exchange,
                'sum_order'=>$sum_order,
                'sum_exchange'=>$sum_exchange,
                'yes_points'=>$yes_points,
                'weeks_points'=>$weeks_points,
                'sum_points'=>$sum_points,
                'yes_money'=>$yes_money,
                'weeks_money'=>$weeks_money,
                'sum_money'=>$sum_money
            ],
            'lineChartData'=>[
                'data1'=>$data1,
                'data2'=>$data2,
                'data3'=>$data3,
                'data4'=>$data4,
                'xData'=>$x_unit
            ]
        ];
        return JsonService::successful('查询成功',$data);
    }
}