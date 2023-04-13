<?php
/**
 * Created by PhpStorm.
 * Role: wenhan
 * Date: 2021/10/8
 * Time: 下午10:15
 */

namespace app\main\controller;
use think\Controller;
use think\Db;
use app\Request;
use think\facade\Hook;
use EasyWeChat\Foundation\Application;
use EasyWeChat\Payment\Order;

class Sms extends Controller
{
    public function __construct()
    {
        parent::__construct();
        $options = config('app_wechat');
        $this->app = new Application($options);
    }
    public function getSmsList(Request $request){
        $params=$request->get();
        $list=Db::name('sms')
            ->page($params['pageNum'])
            ->limit($params['pageSize'])
            ->select();
        $total=Db::name('sms')
            ->count();
        $res=[
            'code'=>200,
            'msg'=>'查询成功',
            'data'=>$list,
            'total'=>$total
        ];
        return json($res);
    }
    public function addSms(Request $request){
        $address = $request->address();
        $data=$request->post();
        $id=array_key_exists('id',$data);
        if($id){
            Db::name('sms')
                ->update($data);
            $log=[
                'module_name'=>'产品管理',
                'operator'=>$request->userInfo()['account'],
                'ip'=>$request->ip(),
                'address'=>$address[2].$address[3],
                'operate_type'=>'2',
                'operate_event'=>'更新短信阶梯'
            ];
            Hook::listen('op_log',$log);
            $info=[
                'code'=>200,
                'msg'=>'更新成功'
            ];
        }else{
            $res=Db::name('sms')
                ->insert($data);
            if($res){
                $log=[
                    'module_name'=>'产品管理',
                    'operator'=>$request->userInfo()['account'],
                    'ip'=>$request->ip(),
                    'address'=>$address[2].$address[3],
                    'operate_type'=>'1',
                    'operate_event'=>'新增短信阶梯'
                ];
                Hook::listen('op_log',$log);
                $info=[
                    'code'=>200,
                    'msg'=>'新增成功'
                ];
            }else{
                $info=[
                    'code'=>201,
                    'msg'=>'系统异常'
                ];
            }
        }
        return json($info);
    }
    public function  getSms(Request $request){
        $id=$request->param('id');
        $info=Db::name('sms')
            ->where('id',$id)
            ->find();
        $res=[
            'code'=>200,
            'msg'=>'查询成功',
            'data'=>$info
        ];
        return json($res);
    }
    public function deleSms(Request $request){
        $id=$request->param('id');
        $address = $request->address();
        $res=Db::name('sms')
            ->delete($id);
        if($res){
            $log=[
                'module_name'=>'产品管理',
                'operator'=>$request->userInfo()['account'],
                'ip'=>$request->ip(),
                'address'=>$address[2].$address[3],
                'operate_type'=>'3',
                'operate_event'=>'删除短信阶梯'
            ];
            Hook::listen('op_log',$log);
            $info=[
                'code'=>200,
                'msg'=>'删除成功'
            ];
        }else{
            $info=[
                'code'=>201,
                'msg'=>'删除失败'
            ];
        }
        return json($info);
    }
    /**
     * @param $attributes
     * @return array
     * 短信包 支付码
     */
    public function pay($attributes){
        $payment=$this->app->payment;
        $order = new Order($attributes);
        $result = $payment->prepare($order);
        if ($result->return_code == 'SUCCESS' && $result->result_code == 'SUCCESS'){
            $res=[
                'prepayId'=>$result->prepay_id,
                'code_url'=>$result->code_url
            ];
        }else{
            $res=[
                'code'=>201,
                'msg'=>'系统异常'
            ];
        }
        return $res;
    }
    public function orderNotify(Request $request){
        $response = $this->app->payment->handleNotify(function($notify, $successful){
            $order=Db::name('sms_order')
                ->where('order',$notify->out_trade_no)
                ->find();
            if (!$order) { // 如果订单不存在
                return 'Order not exist.'; // 告诉微信，我已经处理完了，订单没找到，别再通知我了
            }
            if($successful){
                //更新订单状态
                Db::name('sms_order')->where('id',$order['id'])->update(['status'=>1]);
            }else{
                Db::name('sms_order')->where('id',$order['id'])->update(['status'=>2]);
            }
            return true; // 返回处理完成
        });
        $response->send();
    }
}