<?php
/**
 * Created by PhpStorm.
 * User: wenhan
 * Date: 2022/3/10
 * Time: 下午5:46
 */

namespace app\dealer\controller\app\mall;
use app\Request;
use think\Controller;
use think\Db;
use app\common\JsonService;
use think\db\Where;

class Distribution extends Controller
{
    protected $dealer_id;
    public function initialize(){
        $userInfo=Request::userInfo();
        $this->dealer_id=array_key_exists('dealer_id',$userInfo)?$userInfo['dealer_id']:$userInfo['id'];
    }
    public function saveDistributionSet(Request $request){
        $data=$request->post();
        if(array_key_exists('id',$data)){
            $res=Db::name('dealer_mall_distribution_rule')->where('dealer_id',$this->dealer_id)->update($data);
        }else{
            $data['dealer_id']=$this->dealer_id;
            $res=Db::name('dealer_mall_distribution_rule')->insert($data);
        }
        if($res||$res==0){
            return JsonService::successful('保存成功');
        }else{
            return JsonService::fail('请联系管理员');
        }
    }
    public function getDistributionInfo(Request $request){
        $info=Db::name('dealer_mall_distribution_rule')->where('dealer_id',$this->dealer_id)->find();
        return JsonService::successful('查询成功',$info);
    }
    public function saveDistributionUser(Request $request){
        $data=$request->post();
        if(array_key_exists('id',$data)){
            $res=Db::name('dealer_mall_distributor_page')->where('dealer_id',$this->dealer_id)->update($data);
        }else{
            $data['dealer_id']=$this->dealer_id;
            $res=Db::name('dealer_mall_distribution_user_page')->insert($data);
        }
        if($res||$res==0){
            return JsonService::successful('保存成功');
        }else{
            return JsonService::fail('请联系管理员');
        }
    }
    public function getDistributionUser(Request $request){
        $info=Db::name('dealer_mall_distributor_page')->where('dealer_id',$this->dealer_id)->find();
        return JsonService::successful('查询成功',$info);
    }

    /**
     * @param Request $request
     * 分销员列表
     */
    public function getFenxiaoyuanList(Request $request){
        $params=$request->get();
        $list=Db::name('dealer_mall_fenxiaoyuan')
            ->alias('a')
            ->join('dealer_member b','a.member_id=b.id')
            ->where('a.dealer_id',$this->dealer_id)
            ->field('b.nickname,b.id,b.phone,a.create_time')
            ->page($params['pageNum'])
            ->limit($params['pageSize'])
            ->select();
        $total=Db::name('dealer_mall_fenxiaoyuan')
            ->alias('a')
            ->join('dealer_member b','a.member_id=b.id')
            ->where('a.dealer_id',$this->dealer_id)
            ->count();
        $res=[
            'code'=>200,
            'msg'=>'查询成功',
            'data'=>$list,
            'total'=>$total
        ];
        return json($res);
    }

    /**
     * @param Request $request
     * 分销员下级成员
     */
    public function getFenxiaoyuanChild(Request $request){
        $params=$request->get();
        if($params['status']==1){
            //一级分销
            $level_one=Db::name('dealer_mall_fenxiaoyuan')
                ->alias('a')
                ->join('dealer_member b','a.member_id=b.id')
                ->where('a.parent_id',$params['uid'])
                ->field('b.nickname,b.id,b.phone,a.create_time')
                ->page($params['pageNum'])
                ->limit($params['pageSize'])
                ->select();
            $total=Db::name('dealer_mall_fenxiaoyuan')
                ->alias('a')
                ->join('dealer_member b','a.member_id=b.id')
                ->where('a.parent_id',$params['uid'])
                ->count();
        }else{
            //一级分销
            $level_one=Db::name('dealer_mall_fenxiaoyuan')
                ->alias('a')
                ->join('dealer_member b','a.member_id=b.id')
                ->where('a.grandpa_id',$params['uid'])
                ->field('b.nickname,b.id,b.phone,a.create_time')
                ->page($params['pageNum'])
                ->limit($params['pageSize'])
                ->select();
            $total=Db::name('dealer_mall_fenxiaoyuan')
                ->alias('a')
                ->join('dealer_member b','a.member_id=b.id')
                ->where('a.grandpa_id',$params['uid'])
                ->count();
        }

        $res=[
            'code'=>200,
            'msg'=>'查询成功',
            'data'=>$level_one,
            'total'=>$total
        ];
        return json($res);
    }

    /**
     * @param Request $request
     * 分销订单
     */
    public function getFenxiaoOrderList(Request $request){
        $params=$request->get();
        $condition=[];
        if($params['startTime']){
            $condition['create_time']=['between time',[$params['startTime'],$params['endTime']]];
        }
        $condition['nickname']=['like','%'.$params['nickname'].'%'];
        $condition['order_id']=['like','%'.$params['order_id'].'%'];
        $list=Db::name('dealer_mall_fenxiao_order')
            ->where('dealer_id',$this->dealer_id)
            ->where(new Where($condition))
            ->order('create_time','desc')
            ->page($params['pageNum'])
            ->limit($params['pageSize'])
            ->select();
        $total=Db::name('dealer_mall_fenxiao_order')
            ->where('dealer_id',$this->dealer_id)
            ->where(new Where($condition))
            ->count();
        $res=[
            'code'=>200,
            'msg'=>'查询成功',
            'data'=>$list,
            'total'=>$total
        ];
        return json($res);
    }

    /**
     * @param Request $request
     * 分销汇总
     */
    public function getFenxiaoData(Request $request){
        $orderNum=Db::name('dealer_mall_fenxiao_order')
            ->where('dealer_id',$this->dealer_id)
            ->whereTime('create_time', 'yesterday')
            ->count();
        $orderMoney=Db::name('dealer_mall_fenxiao_order')
            ->where('dealer_id',$this->dealer_id)
            ->whereTime('create_time', 'yesterday')
            ->sum('total_fee');
        $orderYjOne=Db::name('dealer_mall_fenxiao_order')
            ->where('dealer_id',$this->dealer_id)
            ->whereTime('create_time', 'yesterday')
            ->sum('commission_one');
        $orderYjTwo=Db::name('dealer_mall_fenxiao_order')
            ->where('dealer_id',$this->dealer_id)
            ->whereTime('create_time', 'yesterday')
            ->sum('commission_two');
        $orderYJ=bcsub($orderYjOne,$orderYjTwo,2);
        $orderUser=Db::name('dealer_mall_fenxiaoyuan')
            ->where('dealer_id',$this->dealer_id)
            ->whereTime('create_time', 'yesterday')
            ->count();
        $orderSumUser=Db::name('dealer_mall_fenxiaoyuan')
            ->where('dealer_id',$this->dealer_id)
            ->count();
        $x_unit=get_weeks();
        $data1=$data2=$data3=$data4=[];
        foreach ($x_unit as $key=>$value){
            $dayUser=Db::name('dealer_mall_fenxiaoyuan')
                ->where('dealer_id',$this->dealer_id)
                ->whereBetweenTime('create_time', $value)
                ->count();
            $dayOrder=Db::name('dealer_mall_fenxiao_order')
                ->where('dealer_id',$this->dealer_id)
                ->whereBetweenTime('create_time', $value)
                ->count();
            $dayMonry=Db::name('dealer_mall_fenxiao_order')
                ->where('dealer_id',$this->dealer_id)
                ->whereBetweenTime('create_time', $value)
                ->sum('total_fee');
            $day_one=Db::name('dealer_mall_fenxiao_order')
                ->where('dealer_id',$this->dealer_id)
                ->whereBetweenTime('create_time', $value)
                ->sum('commission_one');
            $day_two=Db::name('dealer_mall_fenxiao_order')
                ->where('dealer_id',$this->dealer_id)
                ->whereBetweenTime('create_time', $value)
                ->sum('commission_two');
            $dayYJ=bcsub($day_one,$day_two,2);
            array_push($data1,$dayUser);
            array_push($data2,$dayOrder);
            array_push($data3,$dayMonry);
            array_push($data4,$dayYJ);
        }
        $data=[
            'baseInfo'=>[
                'orderNum'=>$orderNum,
                'orderMoney'=>$orderMoney,
                'orderYJ'=>$orderYJ,
                'orderUser'=>$orderUser,
                'orderSumUser'=>$orderSumUser
            ],
            'lineChartData'=>[
                'data1'=>$data1,
                'data2'=> $data2,
                'data3'=> $data3,
                'data4'=> $data4,
                'xData'=>$x_unit
            ]
        ];
        return JsonService::successful('查询成功',$data);
    }

    /**
     * @param Request $request
     * 提现单号
     */
    public function getFenxiaoCashOrder(Request $request){
        $params=$request->get();
        $condition=[];
        if($params['startTime']){
            $condition['a.create_time']=['between time',[$params['startTime'],$params['endTime']]];
        }
        $list=Db::name('dealer_mall_fenxiao_cash')
            ->alias('a')
            ->join('dealer_member b','a.member_id=b.id')
            ->where('a.dealer_id',$this->dealer_id)
            ->where(new Where($condition))
            ->where('b.phone|b.nickname','like','%'.$params['keywords'].'%')
            ->where('a.status',$params['status']?:'not null')
            ->order('a.create_time','desc')
            ->field('a.id,b.nickname,b.phone,a.cash_fee,a.account,a.status,a.create_time')
            ->page($params['pageNum'])
            ->limit($params['pageSize'])
            ->select();
        $total=Db::name('dealer_mall_fenxiao_cash')
            ->alias('a')
            ->join('dealer_member b','a.member_id=b.id')
            ->where(new Where($condition))
            ->where('b.phone|b.nickname','like','%'.$params['keywords'].'%')
            ->where('a.dealer_id',$this->dealer_id)
            ->where('a.status',$params['status']?:'not null')
            ->count();
        $res=[
            'code'=>200,
            'msg'=>'查询成功',
            'data'=>$list,
            'total'=>$total
        ];
        return json($res);
    }
    public function passCashOrder(Request $request){
        $params=$request->get();
        $res=Db::name('dealer_mall_fenxiao_cash')
            ->where('id',$params['id'])
            ->update([
               'status'=>2
            ]);
        if($res){
            return JsonService::successful('审核通过');
        }else{
            return JsonService::fail('请联系管理员');
        }
    }
    public function refuseCashOrder(Request $request){
        $params=$request->post();
        $params['status']=3;
        $res=Db::name('dealer_mall_fenxiao_cash')
            ->update($params);
        if($res){
            return JsonService::successful('操作成功');
        }else{
            return JsonService::fail('请联系管理员');
        }
    }

}