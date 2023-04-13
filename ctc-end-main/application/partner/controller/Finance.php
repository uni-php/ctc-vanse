<?php
/**
 * Created by PhpStorm.
 * Role: wenhan
 * Date: 2021/10/27
 * Time: 上午3:12
 */

namespace app\partner\controller;
use think\Controller;
use think\Db;
use app\Request;

class Finance extends Controller
{
    public function listFinanceBill(Request $request){
        $params=$request->get();
        $partner_id=$request->userInfo()['id'];//合伙人id
        if($params['beginTime']){
            $list=Db::name('finance_bill')
                ->where('account_type','like','%'.$params['type'].'%')
                ->where('subject',1)
                ->where('transaction_type','like','%'.$params['transaction_type'].'%')
                ->where('create_time','between time', [$params['beginTime'], $params['endTime']])
                ->where('subject_id',$partner_id)
                ->page($params['pageNum'])
                ->order('create_time desc')
                ->limit($params['pageSize'])
                ->select();
            $total=Db::name('finance_bill')
                ->where('subject',1)
                ->where('subject_id',$partner_id)
                ->where('account_type','like','%'.$params['type'].'%')
                ->where('transaction_type','like','%'.$params['transaction_type'].'%')
                ->where('create_time','between time', [$params['beginTime'], $params['endTime']])
                ->count();
        }else{
            $list=Db::name('finance_bill')
                ->where('subject',1)
                ->where('account_type','like','%'.$params['type'].'%')
                ->where('transaction_type','like','%'.$params['transaction_type'].'%')
                ->where('subject_id',$partner_id)
                ->page($params['pageNum'])
                ->order('create_time desc')
                ->limit($params['pageSize'])
                ->select();
            $total=Db::name('finance_bill')
                ->where('subject',1)
                ->where('subject_id',$partner_id)
                ->where('account_type','like','%'.$params['type'].'%')
                ->where('transaction_type','like','%'.$params['transaction_type'].'%')
                ->count();
        }
        $res=[
            'code'=>200,
            'msg'=>'查询成功',
            'data'=>$list,
            'total'=>$total
        ];
        return json($res);
    }
    public function listFinanceDealerBill(Request $request){
        $params=$request->get();
        $partner_id=$request->userInfo()['id'];//合伙人id
        if($params['beginTime']){
            $list=Db::name('finance_bill')
                ->alias('a')
                ->join('dealer b','a.subject_id=b.id')
                ->where('a.subject',2)
                ->where('a.account_type','like','%'.$params['type'].'%')
                ->where('a.create_time','between time', [$params['beginTime'], $params['endTime']])
                ->where('b.dealer_name','like','%'.$params['dealer_name'].'%')
                ->where('b.partner_id',$partner_id)
                ->page($params['pageNum'])
                ->order('create_time desc')
                ->limit($params['pageSize'])
                ->field('a.*,b.id as dealer_id')
                ->select();
            $total=Db::name('finance_bill')
                ->alias('a')
                ->join('dealer b','a.subject_id=b.id')
                ->where('a.subject',2)
                ->where('a.account_type','like','%'.$params['type'].'%')
                ->where('a.create_time','between time', [$params['beginTime'], $params['endTime']])
                ->where('b.dealer_name','like','%'.$params['dealer_name'].'%')
                ->where('b.id',$partner_id)
                ->count();
        }else{
            $list=Db::name('finance_bill')
                ->alias('a')
                ->join('dealer b','a.subject_id=b.id')
                ->where('a.subject',2)
                ->where('a.account_type','like','%'.$params['type'].'%')
                ->where('b.dealer_name','like','%'.$params['dealer_name'].'%')
                ->where('b.partner_id',$partner_id)
                ->page($params['pageNum'])
                ->order('create_time desc')
                ->field('a.*,b.id as dealer_id,b.dealer_name,b.account')
                ->limit($params['pageSize'])
                ->select();
            $total=Db::name('finance_bill')
                ->alias('a')
                ->join('dealer b','a.subject_id=b.id')
                ->where('a.subject',2)
                ->where('a.account_type','like','%'.$params['type'].'%')
                ->where('b.dealer_name','like','%'.$params['dealer_name'].'%')
                ->where('b.id',$partner_id)
                ->count();
        }
        $res=[
            'code'=>200,
            'msg'=>'查询成功',
            'data'=>$list,
            'total'=>$total
        ];
        return json($res);
    }
    public function getCashRule(Request $request){
        $rule=Db::name('cash_rule')
            ->where('id',1)
            ->find();
        $info=[
            'data'=>$rule,
            'code'=>200,
            'msg'=>'查询成功'
        ];
        return json($info);
    }
    public function getCashLimitTimes(Request $request){
        $partner_id=$request->userInfo()['id'];//合伙人id
        $times=Db::name('cash_rule')
            ->where('id',1)
            ->value('limit_times');
        $used_times=Db::name('partner_cash_bill')
            ->where('partner_id',$partner_id)
            ->where('status','<>',2)
            ->whereTime('create_time', 'm')
            ->select();
        $surplus=bcsub($times,count($used_times));
        $info=[
            'data'=>$surplus,
            'code'=>200,
            'msg'=>'查询成功'
        ];
        return json($info);
    }
    public function cash(Request $request){
        $partner_id=$request->userInfo()['id'];//合伙人id
        $data=$request->post();
        $data['partner_id']=$partner_id;
        $balance=Db::name('partner')
            ->where('id',$partner_id)
            ->value('balance');
        if($balance<$data['money']){
            $info=[
                'code'=>201,
                'msg'=>'余额不足！'
            ];
            return json($info);
        }
        $data['cash_order']=date('Ymd') . time();//年月日加时间戳
        Db::startTrans();//开启事务
        try{
           //扣款
            Db::name('partner')
                ->where('id',$partner_id)
                ->setDec('balance', $data['money']);//减去提现金额
            Db::name('partner_cash_bill')
                ->insert($data);
            $balance=Db::name('partner')
                ->where('id',$partner_id)
                ->value('balance');
            $bill=Db::name('finance_bill')
                ->insert([
                    'serial_number' => $data['cash_order'],
                    'transaction_type' => 7,//申请提现
                    'remark' => '合伙人申请提现',
                    'subject' => 1,//合伙人
                    'account_type' => 1,//余额
                    'balance' => $balance,
                    'payments_type' => 1,
                    'bill' => $data['money'],
                    'subject_id' => $partner_id
                ]);
            if($bill){
                $info=[
                    'code'=>200,
                    'msg'=>'提交成功'
                ];
            }
            Db::commit();
        }catch (\Exception $e){
            Db::rollback();
            $info=[
                'code'=>201,
                'msg'=>'请联系管理员'
            ];
        }
        return json($info);
    }
    public function cashList(Request $request){
        $params=$request->get();
        $partner_id=$request->userInfo()['id'];//合伙人id
        if($params['beginTime']){
            $list=Db::name('partner_cash_bill')
                ->where('create_time','between time', [$params['beginTime'], $params['endTime']])
                ->where('partner_id',$partner_id)
                ->page($params['pageNum'])
                ->limit($params['pageSize'])
                ->order('create_time','desc')
                ->select();
            $total=Db::name('partner_cash_bill')
                ->where('create_time','between time', [$params['beginTime'], $params['endTime']])
                ->where('partner_id',$partner_id)
                ->count();
        }else{
            $list=Db::name('partner_cash_bill')
                ->where('partner_id',$partner_id)
                ->page($params['pageNum'])
                ->limit($params['pageSize'])
                ->order('create_time','desc')
                ->select();
            $total=Db::name('partner_cash_bill')
                ->where('partner_id',$partner_id)
                ->count();
        }
        $res=[
            'code'=>200,
            'msg'=>'查询成功',
            'data'=>$list,
            'total'=>$total
        ];
        return json($res);
    }
}