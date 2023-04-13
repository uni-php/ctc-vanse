<?php
/**
 * Created by PhpStorm.
 * User: wenhan
 * Date: 2021/11/21
 * Time: 下午2:41
 */

namespace app\dealer\controller\assets;
use app\Request;
use think\Controller;
use app\common\Qiniu;
use app\common\QrcodeService;
use think\Db;

class Sms extends Controller
{
    protected $dealer_id;
    public function initialize(){
        $userInfo=Request::userInfo();
        $this->dealer_id=array_key_exists('dealer_id',$userInfo)?$userInfo['dealer_id']:$userInfo['id'];
    }
    public function getLogList(Request $request){
        $params=$request->get();
        $condition=[];
        if($params['startTime']){
            $condition['a.create_time']=['>time',$params['startTime']];
            $condition['a.create_time']=['<time',$params['endTime']];
        }
        if(count($condition)>0){
            $list=Db::name('dealer_sms_log')
                ->where('phone','like','%'.$params['phone'].'%')
                ->where('type','like','%'.$params['type'].'%')
                ->where($condition)
                ->where('dealer_id',$this->dealer_id)
                ->page($params['pageNum'])
                ->limit($params['pageSize'])
                ->select();
            $total=Db::name('dealer_sms_log')
                ->where('phone','like','%'.$params['phone'].'%')
                ->where('type','like','%'.$params['type'].'%')
                ->where('dealer_id',$this->dealer_id)
                ->where($condition)
               ->count();
        }else{
            $list=Db::name('dealer_sms_log')
                ->where('phone','like','%'.$params['phone'].'%')
                ->where('type','like','%'.$params['type'].'%')
                ->where('dealer_id',$this->dealer_id)
                ->page($params['pageNum'])
                ->limit($params['pageSize'])
                ->select();
            $total=Db::name('dealer_sms_log')
                ->where('phone','like','%'.$params['phone'].'%')
                ->where('type','like','%'.$params['type'].'%')
                ->where('dealer_id',$this->dealer_id)
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
    public function getSmsPrice(Request $request){
        $list=Db::name('sms')
            ->select();
        foreach ($list as $key=>$value){
            $list[$key]['sum_price']=bcmul($value['sms_count'],$value['sms_retail'],2);
        }
        $res=[
            'code'=>200,
            'msg'=>'查询成功',
            'data'=>$list
        ];
        return json($res);
    }
    public function smsPay(Request $request){
        $data=$request->post();
        $sms=new \app\main\controller\Sms();
        $qrcode=new QrcodeService();
        $out_trade_no=date('Ymd').substr(implode(NULL, array_map('ord', str_split(substr(uniqid(), 7, 13), 1))), 0, 8);
        //请求主系统模块 拉取支付码
        $attributes = [
            'trade_type'       => 'NATIVE', // JSAPI，NATIVE，APP...
            'body'             => '短信服务充值',
            'detail'           => '短信服务充值',
            'out_trade_no'     => $out_trade_no,
            'total_fee'        => $data['sum_price']*100, // 单位：元
            'notify_url'       => 'https://pps.uni-2id.com/index.php/main/sms/orderNotify', // 支付结果通知网址，如果不设置则会使用配置里的默认地址
            'openid'           => '', // trade_type=JSAPI，此参数必传，用户在商户appid下的唯一标识，
            // ...
        ];
        Db::startTrans();//开启事务
        try{
            $res=$sms->pay($attributes);
            $code_url=$qrcode->createQrcode($res['code_url']);
            //生成支付订单
            Db::name('sms_order')
                ->insert([
                   'dealer_id'=>$this->dealer_id,
                   'order'=>$out_trade_no,
                    'money'=>$data['sum_price'],
                    'num'=>$data['sms_count'],
                    'create_by'=>$request->userInfo()['account']
                ]);
            $info=[
                'res'=>$res,
                'code_url'=>$code_url,
                'out_trade_no'=>$out_trade_no
            ];
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
    public function getPayLog(Request $request){
        $params=$request->get();
        $list=Db::name('sms_order')
            ->where('dealer_id',$this->dealer_id)
            ->where('status',1)
            ->page($params['pageNum'])
            ->limit($params['pageSize'])
            ->select();
        $total=Db::name('sms_order')
            ->where('dealer_id',$this->dealer_id)
            ->where('status',1)
            ->count();
        $res=[
            'code'=>200,
            'msg'=>'查询成功',
            'data'=>$list,
            'total'=>$total
        ];
        return json($res);
    }
    public function queryPayStatus(Request $request){
        $res=Db::name('sms_order')
            ->where('order',$request->param('order'))
            ->value('status');
        if($res==1){
            $info=[
                'code'=>200,
                'msg'=>'支付成功'
            ];
        }else{
            $info=[
                'code'=>201,
                'msg'=>'支付异常'
            ];
        }
        return json($info);
    }
    public function saveSmsWarning(Request $request){
        $data=$request->post();
        if(array_key_exists('id',$data)){
            $res=Db::name('dealer_sms_early_warning')->update($data);
        }else{
            $data['dealer_id']=$this->dealer_id;
            $res=Db::name('dealer_sms_early_warning')->insert($data);
        }
        if($res||$res==0){
            $info=[
                'code'=>200,
                'msg'=>'保存成功'
            ];
        }else{
            $info=[
                'code'=>201,
                'msg'=>'系统异常'
            ];
        }
        return json($info);
    }
    /**
     * @param Request $request
     * 获取短信剩余条数与总数
     */
    public function getSmsInfo(Request $request){
        //短信条数
        $sum=Db::name('sms_order')
            ->where('dealer_id',$this->dealer_id)
            ->where('status',1)
            ->sum('num');
        //发送数
        $send_num=Db::name('dealer_sms_log')
            ->where('dealer_id',$this->dealer_id)
            ->count();
        //剩余条数
        $surplus_num=bcsub($sum,$send_num);
        $early_warning=Db::name('dealer_sms_early_warning')
            ->where('dealer_id',$this->dealer_id)
            ->find();
        return json([
           'send_num'=>$send_num,
           'surplus_num'=>$surplus_num,
            'warning'=>$early_warning
        ]);
    }
}