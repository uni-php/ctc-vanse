<?php
/**
 * Created by PhpStorm.
 * Role: wenhan
 * Date: 2021/10/11
 * Time: 上午1:49
 */

namespace app\main\controller;
use think\Controller;
use think\Db;
use app\Request;
use think\facade\Hook;

class IncrementService extends Controller
{
    public function getList(){
        $list=Db::name('increment_service')
            ->where('status',0)
            ->select();
        $res=[
            'code'=>200,
            'msg'=>'查询成功',
            'data'=>$list
        ];
        return json($res);
    }
    public function saveServide(Request $request){
        $arr=json_decode($request->param('arr'),true);
        $address = $request->address();
        foreach ($arr as $key=>$value){
            Db::name('increment_service')
                ->update($value);
        }
        $log=[
            'module_name'=>'增值服务管理',
            'operator'=>$request->userInfo()['account'],
            'ip'=>$request->ip(),
            'address'=>$address[2].$address[3],
            'operate_type'=>'2',
            'operate_event'=>'设置增值服务费用'
        ];
        Hook::listen('op_log',$log);
        $res=[
            'code'=>200,
            'msg'=>'更新成功',
        ];
        return json($res);
    }
    public function getServiceOrder(Request $request){
        $params=$request->get();
        $list=Db::name('increment_service_order')
            ->alias('a')
            ->join('dealer b','a.dealer_id=b.id')
            ->join('partner c','b.partner_id=c.id')
            ->where('a.order_num','like','%'.$params['order_num'].'%')
            ->where('b.dealer_name','like','%'.$params['dealer_name'].'%')
            ->where('a.status','like','%'.$params['status'].'%')
            ->where('a.is_del',0)
            ->field('a.*,b.dealer_name,b.company,c.company as partner_company')
            ->page($params['pageNum'])
            ->order('create_time','desc')
            ->limit($params['pageSize'])
            ->select();
        $total=Db::name('increment_service_order')
            ->alias('a')
            ->join('dealer b','a.dealer_id=b.id')
            ->join('partner c','b.partner_id=c.id')
            ->where('a.order_num','like','%'.$params['order_num'].'%')
            ->where('b.dealer_name','like','%'.$params['dealer_name'].'%')
            ->where('a.status','like','%'.$params['status'].'%')
            ->where('a.is_del',0)
            ->count();
        $res=[
            'code'=>200,
            'msg'=>'查询成功',
            'data'=>$list,
            'total'=>$total
        ];
        return json($res);
    }
    public function deleOrder(Request $request){
        $id=$request->param('id');
        $address = $request->address();
        $code=Db::name('increment_service_order')
            ->where('id',$id)
            ->update([
                'is_del'=>1
            ]);
        if($code){
            $log=[
                'module_name'=>'增值服务管理',
                'operator'=>$request->userInfo()['account'],
                'ip'=>$request->ip(),
                'address'=>$address[2].$address[3],
                'operate_type'=>'2',
                'operate_event'=>'增值订单删除'
            ];
            Hook::listen('op_log',$log);
            $info=[
                'code'=>200,
                'msg'=>'删除成功'
            ];
        }else{
            $info=[
                'code'=>201,
                'msg'=>'请联系管理员'
            ];
        }
        return json($info);
    }
    public function checkOrder(Request $request){
        $params=$request->get();
        $address = $request->address();
        $status=$params['checkStatus'];
        if($params['pay_type']==0){
            $balance=Db::name('partner')->where('id',$params['partner_id'])->value('balance');
            if(bccomp($balance,$params['cost'],5)==-1){
                $info=[
                    'code'=>201,
                    'msg'=>'余额不足'
                ];
                return json($info);
            }
            Db::startTrans();//开启事务
            try{
                //余额支付 扣款 生成账单明细
                Db::name('increment_service_order')
                    ->where('id',$params['id'])
                    ->update([
                        'status'=>$status
                    ]);
                $log=[
                    'module_name'=>'增值服务管理',
                    'operator'=>$request->userInfo()['account'],
                    'ip'=>$request->ip(),
                    'address'=>$address[2].$address[3],
                    'operate_type'=>'2',
                    'operate_event'=>'增值订单审核'
                ];
                Hook::listen('op_log',$log);
                if($status==1){
                    Db::name('partner')
                        ->where('id',$params['partner_id'])
                        ->setDec('balance',$params['cost'] );
                    $balance=Db::name('partner')->where('id',$params['partner_id'])->value('balance');
                    //写合伙人账单明细
                    $bill=Db::name('finance_bill')
                        ->insert([
                            'serial_number' => date('Ymd') . time(),//年月日加时间戳
                            'transaction_type' => 4,//增值服务
                            'remark' => '品牌商增值服务',
                            'subject' => 1,//合伙人
                            'account_type' => 1,//余额
                            'balance' => $balance,
                            'payments_type' => 1,
                            'bill' => $params['cost'],//成本价
                            'subject_id' => $params['partner_id']
                        ]);
                    //写品牌商账单明细
                    $bills=Db::name('finance_bill')
                        ->insert([
                            'serial_number' => date('Ymd') . time(),//年月日加时间戳
                            'transaction_type' => 4,//增值服务
                            'remark' => '品牌商增值服务',
                            'subject' => 2,//品牌商
                            'account_type' => 1,//余额
                            'balance' => $balance,
                            'payments_type' => 1,
                            'bill' => $params['sale'],//销售价
                            'subject_id' => $params['dealer_id']
                        ]);
                    if($bill&&$bills){
                        $info=[
                            'code'=>200,
                            'msg'=>'审核成功'
                        ];
                    }else{
                        throw new \Exception('审核失败，请联系管理员');
                    }
                }else{
                    $info=[
                        'code'=>200,
                        'msg'=>'审核成功'
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
        }else{
            //线下支付
            $code=Db::name('increment_service_order')
                ->where('id',$params['id'])
                ->update([
                    'status'=>$status
                ]);
            if($code){
                $info=[
                    'code'=>200,
                    'msg'=>'审核成功'
                ];
            }else{
                $info=[
                    'code'=>201,
                    'msg'=>'请联系管理员'
                ];
            }
        }
        return json($info);
    }
    public function orderInfo(Request $request){
        $id=$request->param('id');
        $order=Db::name('increment_service_order')
            ->where('id',$id)
            ->find();
        $all_server=Db::name('increment_service')
            ->select();
        $ser_ids=explode(',',$order['increment_service_id']);
        foreach ($ser_ids as $key=>$value){
            foreach ($all_server as $k=>$val){
                if($value==$val['id']){
                    $all_server[$k]['is_select']=1;
                    $all_server[$k]['times']=$order['train_times'];
                }
            }
        }
        $data=[
            'code'=>200,
            'data'=>$all_server,
            'msg'=>'查询成功',
            'demand'=>$order['customized_des'],
            'is_customized'=>$order['is_customized']
        ];
        return json($data);
    }
}