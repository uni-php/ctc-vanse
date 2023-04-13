<?php
/**
 * Created by PhpStorm.
 * User: wenhan
 * Date: 2022/8/21
 * Time: 上午12:18
 */

namespace app\api\controller\points;
use app\Request;
use think\Controller;
use think\Db;
use app\common\JsonService;
use think\facade\Env;
use EasyWeChat\Foundation\Application;
use EasyWeChat\Payment\Order;


class Pay extends Controller
{
    public function settlement(Request $request){
        $params=$request->post();
        Db::startTrans();
        try{
            $params['order_id']=getOrderNum();
            if($params['total_price']==0){
                //扣积分
                Db::name('dealer_member')->where('openid',$params['openid'])->setDec('points', number_format($params['total_points'],2));
                //删除购物车id
                if($params['pay_mode']=='cart'){
                    foreach (explode(',',$params['cart_ids']) as $key=>$value){
                        Db::name('dealer_points_cart')
                            ->where('id',$value)
                            ->update([
                                'is_delete'=>1
                            ]);
                    }
                    //更改兑换数量
                    foreach ($params['order_gift_info'] as $key =>$value){
                        Db::name('dealer_points_gifts')
                            ->where('id',$value['points_gift_id'])
                            ->setInc('exchanged_num', $value['gift_num']);
                    }
                }else{
                    Db::name('dealer_points_gifts')
                        ->where('id',$params['order_gift_info']['points_gift_id'])
                        ->setInc('exchanged_num', 1);
                }
                $params['order_gift_info']=json_encode($params['order_gift_info'],true);
                //直接兑换
                Db::name('dealer_points_order')->insert($params);
                Db::commit();
                return JsonService::returnData(200,'兑换成功');
            }else{
                //支付
            }
        }catch (\Exception $e){
            Db::rollback();
            return JsonService::returnData(500,'请联系管理员');
        }
    }

    /**
     * @param Request $request
     * 统一下单
     */
    public function createOrder(Request $request){
        $data=$request->post();
        $path=str_replace('jifen','pps',config('public_dir'));
        $config=Db::name('dealer_payment')->where('dealer_id',$data['dealer_id'])->find();
        if($config){
            //自定义配置支付
            $options=[
                'debug'  => true,
                'app_id' => $config['appid'],
                'log' => [
                    'level' => 'debug',
                    'file'  => Env::get('runtime_path') . 'log/'.date('Ymd').'/wechat_debug.log', // XXX: 绝对路径！！！！
                ],
                'payment'=>[
                    'merchant_id'        => $config['mchid'],
                    'key'                => $config['appsecret'],
                    'cert_path'          => $path.'cert/'.$config['cert'],
                    'key_path'           => $path.'cert/'.$config['key'],
                ]
            ];
        }else{
            //总后台支付
            $options=config('zht_wechat');
        }
        Db::startTrans();
        try{
            $app = new Application($options);
            $payment = $app->payment;
            $attributes=[
                'trade_type'       => 'JSAPI',
                'body'             => '积分兑换',
                'detail'           => '积分兑换',
                'out_trade_no'     => getOrderNum(),
                'total_fee'        => $data['total_fee'], // 单位：分
                'notify_url'       => 'https://pay.weixin.qq.com/wxpay/pay.action', // 支付结果通知网址，如果不设置则会使用配置里的默认地址
                'openid'           => $data['openid'], // trade_type=JSAPI，此参数必传，用户在商户appid下的唯一标识，
            ];
            $order = new Order($attributes);
            $result = $payment->prepare($order);
            if ($result->return_code == 'SUCCESS' && $result->result_code == 'SUCCESS'){
                $result['timestamp']=time();
                Db::name('dealer_member')->where('openid',$data['openid'])->setDec('points', number_format($data['total_points'],2));
                $data['order_id']=$attributes['out_trade_no'];//订单
                $result['order_id']=$attributes['out_trade_no'];
                //写订单 删除购物车ID
                if($data['pay_mode']=='cart'){
                    foreach (explode(',',$data['cart_ids']) as $key=>$value){
                        Db::name('dealer_points_cart')
                            ->where('id',$value)
                            ->update([
                                'is_delete'=>1
                            ]);
                    }
                    //更改兑换数量  15分钟不支付 自动取消订单 定时任务
                    foreach ($data['order_gift_info'] as $key =>$value){
                        Db::name('dealer_points_gifts')
                            ->where('id',$value['points_gift_id'])
                            ->setInc('exchanged_num', $value['gift_num']);
                    }
                }else{
                    Db::name('dealer_points_gifts')
                        ->where('id',$data['order_gift_info']['points_gift_id'])
                        ->setInc('exchanged_num', 1);
                }
                $data['order_gift_info']=json_encode($data['order_gift_info'],true);
                $prepayId = $result->prepay_id;
                $config=$payment->configForJSSDKPayment($prepayId);
                $result['config']=$config;
                Db::name('dealer_points_order')->strict(false)->insert($data);
                Db::commit();
                return JsonService::returnData(200,'下单成功',$result);
            }
        }catch (\Exception $e){
            Db::rollback();
            return JsonService::returnData(500,'请联系管理员');
        }
    }
    public function payOrder(Request $request){
        $params=$request->post();
        $orderInfo=Db::name('dealer_points_order')
            ->where('openid',$params['openid'])
            ->where('dealer_id',$params['dealer_id'])
            ->where('order_id',$params['order_id'])
            ->find();
        $path=str_replace('jifen','pps',config('public_dir'));
        $config=Db::name('dealer_payment')->where('dealer_id',$params['dealer_id'])->find();
        if($config){
            //自定义配置支付
            $options=[
                'debug'  => true,
                'app_id' => $config['appid'],
                'log' => [
                    'level' => 'debug',
                    'file'  => Env::get('runtime_path') . 'log/'.date('Ymd').'/wechat_debug.log', // XXX: 绝对路径！！！！
                ],
                'payment'=>[
                    'merchant_id'        => $config['mchid'],
                    'key'                => $config['appsecret'],
                    'cert_path'          => $path.'cert/'.$config['cert'],
                    'key_path'           => $path.'cert/'.$config['key'],
                ]
            ];
        }else{
            //总后台支付
            $options=config('zht_wechat');
        }
        Db::startTrans();
        try{
            $app = new Application($options);
            $payment = $app->payment;
            $attributes=[
                'trade_type'       => 'JSAPI',
                'body'             => '积分兑换',
                'detail'           => '积分兑换',
                'out_trade_no'     => $params['order_id'],
                'total_fee'        => $orderInfo['total_price'] * 100, // 单位：分
                'notify_url'       => 'https://pay.weixin.qq.com/wxpay/pay.action', // 支付结果通知网址，如果不设置则会使用配置里的默认地址
                'openid'           => $params['openid'], // trade_type=JSAPI，此参数必传，用户在商户appid下的唯一标识，
            ];
            $order = new Order($attributes);
            $result = $payment->prepare($order);
            if ($result->return_code == 'SUCCESS' && $result->result_code == 'SUCCESS'){
                $prepayId = $result->prepay_id;
                $config=$payment->configForJSSDKPayment($prepayId);
                $result['config']=$config;
                $result['order_id']=$params['order_id'];
                Db::commit();
                return JsonService::returnData(200,'下单成功',$result);
            }
        }catch (\Exception $e){
            Db::rollback();
            return JsonService::returnData(500,'请联系管理员');
        }
    }

    /**
     * @param Request $request
     * 更改订单状态
     */
    public function checkOrder(Request $request){
        $params=$request->get();
        if($params['status']==-1){
            $res=Db::name('dealer_points_order')
                ->where('openid',$params['openid'])
                ->where('dealer_id',$params['dealer_id'])
                ->where('order_id',$params['order_id'])
                ->update([
                    'status'=>-1
                ]);
        }else{
            $res=Db::name('dealer_points_order')
                ->where('openid',$params['openid'])
                ->where('dealer_id',$params['dealer_id'])
                ->where('order_id',$params['order_id'])
                ->update([
                    'status'=>0,
                    'pay_time'=>date("Y-m-d H:i:s",time())
                ]);
        }
        if($res){
            return JsonService::returnData(200,'设置成功');
        }else{
            return JsonService::returnData(500,'请联系管理员');
        }
    }
    public function receiving(Request $request){
        $params=$request->get();
        $res=Db::name('dealer_points_order')
            ->where('openid',$params['openid'])
            ->where('dealer_id',$params['dealer_id'])
            ->where('order_id',$params['order_id'])
            ->update([
                'status'=>2,
            ]);
        if($res){
            return JsonService::returnData(200,'收货成功');
        }else{
            return JsonService::returnData(500,'请联系管理员');
        }
    }
}