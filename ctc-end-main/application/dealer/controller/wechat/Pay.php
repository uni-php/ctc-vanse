<?php
/**
 * Created by PhpStorm.
 * User: wenhan
 * Date: 2022/4/26
 * Time: 下午10:14
 */

namespace app\dealer\controller\wechat;
use app\Request;
use think\Controller;
use think\Db;
use think\facade\Env;
use EasyWeChat\Foundation\Application;

class Pay
{
    protected $dealer_id;
    protected $pay_type;//红包类型
    public function __construct($dealer_id = null, $pay_type = null)
    {
        !empty($dealer_id) && $this->dealer_id = $dealer_id;
        !empty($pay_type) && $this->pay_type = $pay_type;
        if($pay_type!=2){
            //选取自定义配置
            $path=str_replace('yx','pps',config('public_dir'));
            $config=Db::name('dealer_payment')->where('dealer_id',$dealer_id)->find();
            $options=[
                    'debug'  => true,
                    'app_id' => $config['appid'],
//                    'secret' => '6cfbadcefd90bee71223b5e63e57fdcb',
//                    'token'  => 'wenhan123',
//                    'aes_key' => 'gSUDzfjBzeWZmGgF73K4MVyh46WT4UEGRN5KFhXD5jj', // 可选
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
            $options=config('zht_wechat');
            if($dealer_id==30||$dealer_id==31){
                $options['app_id']='wxa1094e43e56d9e38';
            }
        }
        $app = new Application($options);
        $this->luckyMoney = $app->lucky_money;
        $this->merchantPay = $app->merchant_pay;
    }

    /**
     * @param $data
     * 现金红包
     */
    public function sendNormal($data){
        return $this->luckyMoney->sendNormal($data);
    }

    /**
     * @param $data
     * 企业零钱
     */
    public function merchantPay($data){
        return $this->merchantPay->send($data);
    }
}