<?php
/**
 * Created by PhpStorm.
 * Role: wenhan
 * Date: 2021/10/11
 * Time: 上午5:07
 */

namespace app\main\controller;
use think\Controller;
use think\Db;
use app\Request;
use think\facade\Hook;

class Finance extends Controller
{
    public function listAccount(Request $request){
        $params=$request->get();
        $list=Db::name('partner')
            ->where('company','like','%'.$params['partner'].'%')
            ->where('level_id','like','%'.$params['level_id'].'%')
            ->page($params['pageNum'])
            ->limit($params['pageSize'])
            ->select();
        $total=Db::name('partner')
            ->where('company','like','%'.$params['partner'].'%')
            ->where('level_id','like','%'.$params['level_id'].'%')
            ->count();
        $res=[
            'code'=>200,
            'msg'=>'查询成功',
            'data'=>$list,
            'total'=>$total
        ];
        return json($res);
    }
    public function recharge(Request $request){
        $params=$request->get();
        $address = $request->address();
        if($params['type']==1){
            //余额充值
            $code=Db::name('partner')
                ->where('id',$params['id'])
                ->setInc('balance', $params['money']);
            $balance=Db::name('partner')
                ->where('id',$params['id'])
                ->value('balance');
        }else{
            //预存款充值
            $code=Db::name('partner')
                ->where('id',$params['id'])
                ->setInc('deposit', $params['money']);
            $balance=Db::name('partner')
                ->where('id',$params['id'])
                ->value('deposit');
        }
        if($code){
            Db::name('partner_recharge_record')
                ->insert([
                    'partner_id'=>$params['id'],
                    'remark'=>$params['remark'],
                    'money'=>$params['money'],
                    'balance'=>$balance,
                    'recharge_type'=>$params['type'],
                    'create_by'=>$request->userInfo()['account']
                ]);
            //客户收支明细
            Db::name('finance_bill')
                ->insert([
                    'serial_number'=>date('Ymd') . time(),//年月日加时间戳,
                    'transaction_type'=>1,//充值
                    'remark'=>'合伙人'.($params['type']==1?'余额':'预存款').'充值',
                    'subject'=>1,
                    'account_type'=>$params['type'],
                    'balance'=>$balance,
                    'payments_type'=>0,//收入
                    'bill'=>$params['money'],
                    'subject_id'=>$params['id']
                ]);
            //操作记录
            $log=[
                'module_name'=>'财务管理',
                'operator'=>$request->userInfo()['account'],
                'ip'=>$request->ip(),
                'address'=>$address[2].$address[3],
                'operate_type'=>'2',
                'operate_event'=>'合伙人'.($params['type']==1?'余额':'预存款').'充值'
            ];
            Hook::listen('op_log',$log);
            $info=[
                'code'=>200,
                'msg'=>'充值成功',
            ];

        }else{
            $info=[
                'code'=>201,
                'msg'=>'请联系管理员',
            ];
        }
        return json($info);
    }
    public function rechargeLog(Request $request){
        $params=$request->get();
        if($params['beginTime']){
            $list=Db::name('partner_recharge_record')
                ->alias('a')
                ->join('partner b','a.partner_id=b.id')
                ->where('a.partner_id',$params['partner_id'])
                ->where('b.company','like','%'.$params['company'].'%')
                ->where('a.recharge_type','like','%'.$params['type'].'%')
                ->where('a.create_time','between time', [$params['beginTime'], $params['endTime']])
                ->page($params['pageNum'])
                ->limit($params['pageSize'])
                ->order('create_time','desc')
                ->field('a.*,b.id as code,b.company,b.account')
                ->select();
            $total=Db::name('partner_recharge_record')
                ->alias('a')
                ->join('partner b','a.partner_id=b.id')
                ->where('a.partner_id',$params['partner_id'])
                ->where('b.company','like','%'.$params['company'].'%')
                ->where('a.recharge_type','like','%'.$params['type'].'%')
                ->where('a.create_time','between time', [$params['beginTime'], $params['endTime']])
                ->count();
        }else{
            $list=Db::name('partner_recharge_record')
                ->alias('a')
                ->join('partner b','a.partner_id=b.id')
                ->where('a.partner_id',$params['partner_id'])
                ->where('b.company','like','%'.$params['company'].'%')
                ->where('a.recharge_type','like','%'.$params['type'].'%')
                ->page($params['pageNum'])
                ->order('create_time','desc')
                ->limit($params['pageSize'])
                ->field('a.*,b.id as code,b.company,b.account')
                ->select();
            $total=Db::name('partner_recharge_record')
                ->alias('a')
                ->join('partner b','a.partner_id=b.id')
                ->where('a.partner_id',$params['partner_id'])
                ->where('b.company','like','%'.$params['company'].'%')
                ->where('a.recharge_type','like','%'.$params['type'].'%')
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
    public function allRechargeLog(Request $request){
        $params=$request->get();
        if($params['beginTime']){
            $list=Db::name('partner_recharge_record')
                ->alias('a')
                ->join('partner b','a.partner_id=b.id')
                ->where('b.company','like','%'.$params['company'].'%')
                ->where('a.recharge_type','like','%'.$params['type'].'%')
                ->where('a.create_time','between time', [$params['beginTime'], $params['endTime']])
                ->page($params['pageNum'])
                ->order('create_time','desc')
                ->limit($params['pageSize'])
                ->field('a.*,b.id as code,b.company,b.account')
                ->select();
            $total=Db::name('partner_recharge_record')
                ->alias('a')
                ->join('partner b','a.partner_id=b.id')
                ->where('b.company','like','%'.$params['company'].'%')
                ->where('a.recharge_type','like','%'.$params['type'].'%')
                ->where('a.create_time','between time', [$params['beginTime'], $params['endTime']])
                ->count();
        }else{
            $list=Db::name('partner_recharge_record')
                ->alias('a')
                ->join('partner b','a.partner_id=b.id')
                ->where('b.company','like','%'.$params['company'].'%')
                ->where('a.recharge_type','like','%'.$params['type'].'%')
                ->page($params['pageNum'])
                ->order('create_time','desc')
                ->limit($params['pageSize'])
                ->field('a.*,b.id as code,b.company,b.account')
                ->select();
            $total=Db::name('partner_recharge_record')
                ->alias('a')
                ->join('partner b','a.partner_id=b.id')
                ->where('b.company','like','%'.$params['company'].'%')
                ->where('a.recharge_type','like','%'.$params['type'].'%')
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
    //客户收支明细
    public function listFinanceBill(Request $request){
        $params=$request->get();
        if($params['subject']==1){
            //合伙人
            if($params['beginTime']){
                $list=Db::name('finance_bill')
                    ->alias('a')
                    ->join('partner b','a.subject_id=b.id')
                    ->where('b.company','like','%'.$params['company'].'%')
                    ->where('a.account_type','like','%'.$params['type'].'%')
                    ->where('a.subject',1)
                    ->where('transaction_type','like','%'.$params['transaction_type'].'%')
                    ->where('a.create_time','between time', [$params['beginTime'], $params['endTime']])
                    ->page($params['pageNum'])
                    ->order('create_time desc')
                    ->limit($params['pageSize'])
                    ->field('a.*,b.company,b.id as code')
                    ->select();
                $total=Db::name('finance_bill')
                    ->alias('a')
                    ->join('partner b','a.subject_id=b.id')
                    ->where('a.subject',1)
                    ->where('b.company','like','%'.$params['company'].'%')
                    ->where('a.account_type','like','%'.$params['type'].'%')
                    ->where('transaction_type','like','%'.$params['transaction_type'].'%')
                    ->where('a.create_time','between time', [$params['beginTime'], $params['endTime']])
                    ->count();
            }else{
                $list=Db::name('finance_bill')
                    ->alias('a')
                    ->join('partner b','a.subject_id=b.id')
                    ->where('a.subject',1)
                    ->where('b.company','like','%'.$params['company'].'%')
                    ->where('a.account_type','like','%'.$params['type'].'%')
                    ->where('transaction_type','like','%'.$params['transaction_type'].'%')
                    ->page($params['pageNum'])
                    ->order('create_time desc')
                    ->limit($params['pageSize'])
                    ->field('a.*,b.company,b.id as code')
                    ->select();
                $total=Db::name('finance_bill')
                    ->alias('a')
                    ->join('partner b','a.subject_id=b.id')
                    ->where('a.subject',1)
                    ->where('b.company','like','%'.$params['company'].'%')
                    ->where('a.account_type','like','%'.$params['type'].'%')
                    ->where('transaction_type','like','%'.$params['transaction_type'].'%')
                    ->count();
        }
        }else{
            //品牌商
            if($params['beginTime']){
                $list=Db::name('finance_bill')
                    ->alias('a')
                    ->join('dealer b','a.subject_id=b.id')
                    ->where('a.subject',2)
                    ->where('b.dealer_name','like','%'.$params['company'].'%')
                    ->where('a.account_type','like','%'.$params['type'].'%')
                    ->where('transaction_type','like','%'.$params['transaction_type'].'%')
                    ->where('a.create_time','between time', [$params['beginTime'], $params['endTime']])
                    ->page($params['pageNum'])
                    ->order('create_time desc')
                    ->limit($params['pageSize'])
                    ->field('a.*,b.dealer_name,b.id as code')
                    ->select();
                $total=Db::name('finance_bill')
                    ->alias('a')
                    ->join('dealer b','a.subject_id=b.id')
                    ->where('a.subject',2)
                    ->where('b.dealer_name','like','%'.$params['company'].'%')
                    ->where('a.account_type','like','%'.$params['type'].'%')
                    ->where('transaction_type','like','%'.$params['transaction_type'].'%')
                    ->where('a.create_time','between time', [$params['beginTime'], $params['endTime']])
                    ->count();

            }else{
                $list=Db::name('finance_bill')
                    ->alias('a')
                    ->join('dealer b','a.subject_id=b.id')
                    ->where('a.subject',2)
                    ->where('b.dealer_name','like','%'.$params['company'].'%')
                    ->where('a.account_type','like','%'.$params['type'].'%')
                    ->where('transaction_type','like','%'.$params['transaction_type'].'%')
                    ->page($params['pageNum'])
                    ->order('create_time desc')
                    ->limit($params['pageSize'])
                    ->field('a.*,b.dealer_name,b.id as code')
                    ->select();
                $total=Db::name('finance_bill')
                    ->alias('a')
                    ->join('dealer b','a.subject_id=b.id')
                    ->where('a.subject',2)
                    ->where('b.dealer_name','like','%'.$params['company'].'%')
                    ->where('a.account_type','like','%'.$params['type'].'%')
                    ->where('transaction_type','like','%'.$params['transaction_type'].'%')
                    ->count();
            }
        }
        $res=[
            'code'=>200,
            'msg'=>'查询成功',
            'data'=>$list,
            'total'=>$total
        ];
        return json($res);
    }
    //提现列表
    public function cashList(Request $request){
        $params=$request->get();
        if($params['beginTime']){
            $list=Db::name('partner_cash_bill')
                ->alias('a')
                ->join('partner b','a.partner_id=b.id')
                ->where('b.company','like','%'.$params['company'].'%')
                ->where('a.status','<>',2)
                ->where('a.create_time','between time', [$params['beginTime'], $params['endTime']])
                ->field('a.*,b.company,b.account,b.id as partner_id')
                ->page($params['pageNum'])
                ->limit($params['pageSize'])
                ->order('create_time','desc')
                ->select();
            $total=Db::name('partner_cash_bill')
                ->alias('a')
                ->join('partner b','a.partner_id=b.id')
                ->where('a.create_time','between time', [$params['beginTime'], $params['endTime']])
                ->where('b.company','like','%'.$params['company'].'%')
                ->where('a.status',0)
                ->count();
        }else{
            $list=Db::name('partner_cash_bill')
                ->alias('a')
                ->join('partner b','a.partner_id=b.id')
                ->where('b.company','like','%'.$params['company'].'%')
                ->where('a.status','<>',2)
                ->field('a.*,b.company,b.account,b.id as partner_id')
                ->page($params['pageNum'])
                ->order('create_time','desc')
                ->limit($params['pageSize'])
                ->select();
            $total=Db::name('partner_cash_bill')
                ->alias('a')
                ->join('partner b','a.partner_id=b.id')
                ->where('b.company','like','%'.$params['company'].'%')
                ->where('a.status',0)
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
    //打款
    public function cashPayment(Request $request){
        //改变订单状态
        $params=$request->get();
        $address = $request->address();
        $code=Db::name('partner_cash_bill')
            ->where('id',$params['id'])
            ->update([
                'status'=>1
            ]);
        if($code){
            $log=[
                'module_name'=>'财务管理',
                'operator'=>$request->userInfo()['account'],
                'ip'=>$request->ip(),
                'address'=>$address[2].$address[3],
                'operate_type'=>'2',
                'operate_event'=>'提现订单打款'
            ];
            Hook::listen('op_log',$log);
            $info=[
                'code'=>200,
                'msg'=>'操作成功',
            ];
        }else{
            $info=[
                'code'=>201,
                'msg'=>'系统异常',
            ];
        }
        return json($info);
    }

    public function cashReject(Request $request){
        //改变订单状态 将钱退回合伙人余额
        $params=$request->get();
        $address = $request->address();
        Db::startTrans();//开启事务
        try{
            Db::name('partner_cash_bill')
                ->where('id',$params['id'])
                ->update([
                    'status'=>2
                ]);
            Db::name('partner')
                ->where('id',$params['partner_id'])
                ->setInc('balance', $params['money']);
            $balance=Db::name('partner')
                ->where('id',$params['partner_id'])
                ->value('balance');
            $bill=Db::name('finance_bill')
                ->insert([
                    'serial_number'=>$params['cash_order'],
                    'transaction_type'=>8,//提现申请被驳回
                    'remark'=>'提现驳回资金返回',
                    'subject'=>1,
                    'account_type'=>1,
                    'balance'=>$balance,
                    'payments_type'=>0,
                    'bill'=>$params['money'],
                    'subject_id'=>$params['partner_id']
                ]);
            $log=[
                'module_name'=>'财务管理',
                'operator'=>$request->userInfo()['account'],
                'ip'=>$request->ip(),
                'address'=>$address[2].$address[3],
                'operate_type'=>'2',
                'operate_event'=>'提现申请驳回'
            ];
            Hook::listen('op_log',$log);
            if($bill){
                $info=[
                    'code'=>200,
                    'msg'=>'成功驳回'
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
    public function getCashRule(Request $request){
        $list=Db::name('cash_rule')
            ->where('id',1)
            ->find();
        $info=[
            'data'=>$list,
            'msg'=>'查询成功'
        ];
        return json($info);
    }
    public function saveCashRule(Request $request){
        $data=$request->get();
        $address = $request->address();
        $code=Db::name('cash_rule')
            ->update($data);
        if($code||$code==0){
            $log=[
                'module_name'=>'财务管理',
                'operator'=>$request->userInfo()['account'],
                'ip'=>$request->ip(),
                'address'=>$address[2].$address[3],
                'operate_type'=>'2',
                'operate_event'=>'修改提现规则'
            ];
            Hook::listen('op_log',$log);
            $info=[
                'code'=>200,
                'msg'=>'更新成功'
            ];
        }else{
            $info=[
                'code'=>201,
                'msg'=>'请联系管理员'
            ];
        }
        return json($info);
    }
}