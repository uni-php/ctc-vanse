<?php
/**
 * Created by PhpStorm.
 * User: wenhan
 * Date: 2022/11/18
 * Time: 下午3:45
 */

namespace app\api\controller\multi;
use app\Request;
use think\Controller;
use app\lib\helper;
use think\Db;
use app\common\JsonService;
use app\dealer\controller\wechat\Open;
use app\dealer\controller\wechat\Pay;
use app\common\Qiniu;

class Prize extends Controller
{
    /**
     * @param Request $request
     * 领奖 已经校验过
     */
    public function getPrize(Request $request){
        $params=$request->post();
        //检查导购场景
        $batch_info=Db::name('code_manage')
            ->where('dealer_id',$params['dealer_id'])
            ->where('scene','like','%'.'3'.'%')//查询营销码
            ->where('batch',$params['batch'])
            ->where('enable',1)
            ->find();
        //首先进行策略限制查询
        $activity_info=Db::name('dealer_guide_activity')
            ->where('dealer_id',$params['dealer_id'])
            ->where('id',$params['activity_id'])
            ->where('status','<>',3)
            ->whereBetweenTimeField('begin_time','end_time')
            ->find();
        //活动是否在有效期
        if(!$activity_info) return JsonService::returnData(500,'活动已过期');
        //是否用户地区限制
        if($activity_info['is_address_limit']==1){
            $limit_address=json_decode($activity_info['select_limit_address'],true);
            $index=-1;
            foreach ($limit_address as $key=>$value){
                $has=explode($params['address']['province'].'-'.$params['address']['city'].'-'.$params['address']['district'],$value);
                if(count($has)>1){
                    $index=$key;
                    break;
                }
            }
            if($index==-1) return JsonService::returnData(500,$activity_info['out_address_tips']);
        }

        //活动参与限制
        if($activity_info['is_join_limit']==1){
            $times=Db::name('dealer_guide_prize_bill')
                ->where('dealer_id',$params['dealer_id'])
                ->where('openid',$params['openid'])
                ->where('activity_id',$params['activity_id'])
                ->whereTime('create_time', 'today')
                ->select();
            if(count($times)>=3) return JsonService::returnData(500,$activity_info['limit_times_tips']);
        }
            //开始领奖
        if($activity_info['join_condition']==2){
            //直接领奖 判断是否被人领取过
            $has_get=Db::name('dealer_guide_prize_bill')
                ->where('dealer_id',$params['dealer_id'])
                ->where('batch',$params['batch'])
                ->where('activity_id',$params['activity_id'])
                ->where('serial_number',$params['serial_number'])
                ->find();
            if($has_get){
                if($has_get['openid']==$params['openid']){
                    return JsonService::returnData(201,'扫码成功',[$activity_info['repeat_tips'],$has_get['create_time']]);
                }else{
                    return JsonService::returnData(201,'扫码成功',[$activity_info['invalid_tips'],$has_get['create_time']]);
                }
            }else{
                //开始抽奖
                //获取奖项设置
                $prize_data=json_decode($activity_info['prize_data'],true);
                $code_batch_data=json_decode($activity_info['code_batch_data'],true);
                //统计无奖的数量
                //计算剩余有效码数量
                $used_code=Db::name('dealer_guide_prize_bill')
                    ->where('dealer_id',$params['dealer_id'])
                    ->where('batch',$params['batch'])
                    ->where('activity_id',$params['activity_id'])
                    ->count();
                $sum_code=0;
                $sum_prize=0;//可中奖的数量
                $new_prize=array();//格式化奖项结构 便于计算
                foreach ($code_batch_data as $key=>$value){
                    $sum_code+=(int)$value['quantity'];
                }
                $available_code_num=$sum_code-$used_code;//有效码数量 在这个区域抽奖
                foreach ($prize_data as $key=>$value){
                    $new_prize[$key+1]=$value['prize_number']-$value['win_num'];
                    $sum_prize+=$value['prize_number']-$value['win_num'];
                }
                if($available_code_num-$sum_prize>0){
                    //空奖放在最后
                    $new_prize['-1']=$available_code_num-$sum_prize;//空奖的数量
                }
                if(!array_sum($new_prize)) return JsonService::returnData(500,'奖池已空');
                //导购员先激活
                if($batch_info['prize_order']==2){
                    $has=Db::name('dealer_guide_register')
                        ->where('dealer_id',$params['dealer_id'])
                        ->where('serial_number',$params['serial_number'])
                        ->where('activity_id',$params['activity_id'])
                        ->where('batch',$params['batch'])
                        ->where('openid',$params['openid'])
                        ->find();
                    if(!$has){
                        Db::name('dealer_guide_register')
                            ->insert([
                                'dealer_id'=>$params['dealer_id'],
                                'openid'=>$params['openid'],
                                'serial_number'=>$params['serial_number'],
                                'code'=>$params['qrcode'],
                                'batch'=>$params['batch'],
                                'activity_id'=>$params['activity_id'],
                            ]);
                        return JsonService::returnData(203,'恭喜您，信息登记成功！',['status'=>0]);
                    }else if($has['is_get']==1){
                        return JsonService::returnData(203,'奖励已发放',['status'=>1]);
                    }else{
                        return JsonService::returnData(203,'恭喜您，信息登记成功！',['status'=>0]);
                    }
                }
                //不限先后 判断消费者是否已领取过 1、未领取 导购登记 2、已领取 导购直接领奖
                if($batch_info['prize_order']==1){
                    $has_get=Db::name('dealer_guide_prize_bill')
                        ->where('dealer_id',$params['dealer_id'])
                        ->where('batch',$params['batch'])
                        ->where('activity_id',$params['activity_id'])
                        ->where('serial_number',$params['serial_number'])
                        ->find();
                    if(!$has_get){
                        Db::name('dealer_guide_register')
                            ->insert([
                                'dealer_id'=>$params['dealer_id'],
                                'openid'=>$params['openid'],
                                'serial_number'=>$params['serial_number'],
                                'code'=>$params['qrcode'],
                                'batch'=>$params['batch'],
                                'activity_id'=>$params['activity_id'],
                            ]);
                        return JsonService::returnData(203,'恭喜您，信息登记成功！',['status'=>0]);
                    }
                }
                //开始抽奖
                Db::startTrans();//开启事务
                try{
                    $prize_level=$this->getPrice($new_prize);
                    $points='';
                    $gift='';
                    $money='';
                    $prize_type=null;
                    if($prize_level!=-1){
                        $prize_type=$prize_data[(int)$prize_level-1]['prize_type'];
                    }
                    if($prize_level!=-1&&$prize_data[(int)$prize_level-1]['prize_type']==1){
                        //抽现金红包
                        //红包详情
                        $red_info=Db::name('dealer_redpack')
                            ->where('dealer_id',$params['dealer_id'])
                            ->where('id',$prize_data[(int)$prize_level-1]['red_envelopes_id'])
                            ->find();
                        if($red_info['is_random']==1){
                            //固定金额
                            $money=$red_info['money'];
                        }else{
                            //随机金额
                            $money=(float)randomFloat($red_info['random_min_money'],$red_info['random_max_money']);
                        }
                        if($red_info['type']==1){
                            //现金红包
                            $pay=new Pay($params['dealer_id'],1);
                            $data=[
                                'mch_billno'       => getOrderNum(),
                                'send_name'        => '超级导购',
                                're_openid'        => $params['openid'],
                                'total_num'        => 1,  //固定为1，可不传
                                'total_amount'     => (int)($money*100),  //单位为分，不小于100
                                'wishing'          => '恭喜您获得红包',
                                'scene_id'         => $money>200||$money<1?'PRODUCT_1':'',
                                'client_ip'        => $request->ip(),  //可不传，不传则由 SDK 取当前客户端 IP
                                'act_name'         => $activity_info['activity_name'],//活动名称
                                'remark'           => $red_info['remark'],
                                // ...
                            ];
                            $result=$pay->sendNormal($data);
                        }
                        if($red_info['type']==2){
                            //企业零钱红包
                            $pay=new Pay($params['dealer_id'],1);
                            $data=[
                                'partner_trade_no' => getOrderNum(),
                                'openid'           => $params['openid'],
                                'check_name'       => 'NO_CHECK',
                                're_user_name'     => $params['openid'],
                                'amount'           => (int)($money*100),
                                'desc'             => $activity_info['activity_name'],//活动名称
                                'spbill_create_ip' => $request->ip(),
                                // ...
                            ];
                            $result=$pay->merchantPay($data);
                        }
                        if($red_info['type']==3){
                            //代发红包 需要更新代发红包池
                            $balance=Db::name('dealer')
                                ->where('id',$params['dealer_id'])
                                ->value('behalf_balance');//代发余额
                            if($balance<$money) return JsonService::returnData(500,'代发余额不足');
                            //插入代发记录表
                            Db::name('redpool_issue_record')
                                ->insert([
                                    'dealer_id'=>$params['dealer_id'],
                                    'money'=>$money,
                                    'balance'=>bcsub($balance,$money,2),
                                    'openid'=>$params['openid'],
                                    'scene'=>3,//超级导购
                                    'redpack_id'=>$red_info['id'],
                                    'activity_id'=>$params['activity_id']
                                ]);
                            Db::name('dealer')
                                ->where('id',$params['dealer_id'])
                                ->setDec('behalf_balance', $money);
                            //发放红包
                            $pay=new Pay($params['dealer_id'],2);
                            $data=[
                                'partner_trade_no' => getOrderNum(),
                                'openid'           => $params['openid'],
                                'check_name'       => 'NO_CHECK',
                                're_user_name'     => $params['openid'],
                                'amount'           => (int)($money*100),
                                'desc'             => $activity_info['activity_name'],//活动名称
                                'spbill_create_ip' => $request->ip()
                                // ...
                            ];
                            $result=$pay->merchantPay($data);
                        }
                        //判断红包发放结果
                        if($result['return_code']=='SUCCESS'&&$result['result_code']=='SUCCESS'){
                            //发放成功
                            Db::name('dealer_redpack_bill')
                                ->insert([
                                    'openid'=>$params['openid'],
                                    'redpack_type'=>$red_info['type'],
                                    'redpack_id'=>$red_info['id'],
                                    'status'=>1,
                                    'app_id'=>3,
                                    'remark'=>'发放成功',
                                    'money'=>$money,
                                    'mch_billno'=>$result['partner_trade_no']?:$result['mch_billno'],
                                    'role'=>1,
                                    'dealer_id'=>$params['dealer_id']
                                ]);
                        }else{
                            //发放失败
                            //更新红包明细表
                            Db::name('dealer_redpack_bill')
                                ->insert([
                                    'openid'=>$params['openid'],
                                    'redpack_type'=>$red_info['type'],
                                    'redpack_id'=>$red_info['id'],
                                    'status'=>2,
                                    'app_id'=>3,
                                    'remark'=>$result['err_code_des'],
                                    'money'=>$money,
                                    'mch_billno'=>$result['partner_trade_no']?:$result['mch_billno'],
                                    'role'=>1,
                                    'dealer_id'=>$params['dealer_id']
                                ]);
                            return JsonService::returnData(500,$result['err_code_des']);
                        }
                    }
                    if($prize_level!=-1&&$prize_data[(int)$prize_level-1]['prize_type']==2){
                        $points=$prize_data[(int)$prize_level-1]['points'];
                        //更新用户积分表
                        Db::name('dealer_member')
                            ->where('dealer_id',$params['dealer_id'])
                            ->where('openid',$params['openid'])
                            ->setInc('points', (int)$points);
                    }
                    if($prize_level!=-1&&$prize_data[(int)$prize_level-1]['prize_type']==3){
                        $get_gift=$prize_data[(int)$prize_level-1]['gift'];
                        $get_gift['get_prize_mode']=$prize_data[(int)$prize_level-1]['get_prize_mode'];
                        $get_gift['valid_day']=$prize_data[(int)$prize_level-1]['valid_day'];
                        $gift=json_encode($get_gift);
                        //实物生成营销订单
                        Db::name('dealer_qrcode_marketing_order')
                            ->insert([
                                'dealer_id'=>$params['dealer_id'],
                                'member_id'=>'',
                                'openid'=>$params['openid'],
                                'order'=>getOrderNum(),
                                'gift'=>$gift,
                                'get_prize_mode'=>$prize_data[(int)$prize_level-1]['get_prize_mode'],
                                'valid_day'=>date('Y-m-d H:i:s',strtotime(date("Y-m-d H:i:s") . '+'.$get_gift['valid_day'].' day')),
                                'code'=>$params['qrcode'],
                                'serial_number'=>$params['serial_number'],
                                'batch'=>$params['batch'],
                                'activity_id'=>$params['activity_id'],
                            ]);
                    }
                    //将抽奖数码插表
                    Db::name('dealer_guide_prize_bill')->insert([
                        'dealer_id'=>$params['dealer_id'],
                        'code'=>$params['qrcode'],
                        'serial_number'=>$params['serial_number'],
                        'openid'=>$params['openid'],
                        'batch'=>$params['batch'],
                        'activity_id'=>$params['activity_id'],
                        'prize_name'=>$prize_level==-1?'未中奖':$prize_data[(int)$prize_level-1]['prize_name'],
                        'prize_content'=>$prize_level==-1?'未中奖':$prize_data[(int)$prize_level-1]['prize_content'],
                        'scan_type'=>1,
                        'province'=>$params['address']['province'],
                        'city'=>$params['address']['city'],
                        'district'=>$params['address']['district'],
                        'points'=>$points,
                        'gift'=>$gift,
                        'money'=>$money,
                        'prize_type'=>$prize_type,
                        'is_user_info'=>$params['is_user_info'],
                        'user_info_field'=>array_key_exists('user_info_field',$params)?json_encode($params['user_info_field']):''
                    ]);
                    //更新奖项表 中奖数量更新
                    if($prize_level!=-1){
                        $prize_data[(int)$prize_level-1]['win_num']++;
                        Db::name('dealer_guide_activity')
                            ->where('dealer_id',$params['dealer_id'])
                            ->where('id',$params['activity_id'])
                            ->update([
                                'prize_data'=>json_encode($prize_data)
                            ]);
                    }
                    //中积分
                    Db::commit();
                    if($prize_level==-1) return JsonService::returnData(200,'扫码成功',$activity_info['empty_tips']);//未中奖
                    if($prize_data[(int)$prize_level-1]['prize_type']==2) return JsonService::returnData(200,'扫码成功','恭喜您获得'.$points.'积分');
                    if($prize_data[(int)$prize_level-1]['prize_type']==3) return JsonService::returnData(204,'扫码成功',['gift'=>json_decode($gift,true)]);
                    return JsonService::returnData(200,'扫码成功','恭喜您获得'.$money.'元红包');
                }catch (\Exception $e){
                    Db::rollback();
                    return JsonService::returnData(500,'请联系管理员');
                }
            }
        }else{

        }
    }
    /**
     * @param $priceInfo
     * @return int|string
     * 抽奖算法
     */
    public function getPrice(&$priceInfo){
        if (!array_sum($priceInfo)) {
            return 0; //奖池已空
        }
        $randId = rand(1, array_sum($priceInfo));

        $i = 0;
        foreach ($priceInfo as $id => $num) {
            $i += $num;
            if ($i >= $randId) {
                $priceInfo[$id]--;
                return $id;
            }
        }
    }
}