<?php
/**
 * Created by PhpStorm.
 * User: wenhan
 * Date: 2022/3/14
 * Time: 下午11:46
 */

namespace app\wxopen\controller;
use app\common\JsonService;
use app\Request;
use think\Controller;
use app\lib\wxMsgCrypt\Sample;
use app\lib\helper;
use think\Db;
use EasyWeChat\Foundation\Application;

class Verify extends Controller
{
    public function __construct()
    {
        parent::__construct();
        $options = config('wechat');
        $this->app = new Application($options);
    }
    /**
     * @param Request $request
     * @return string
     * 验证票据
     * 接收保存最近的component_verify_ticket 12小时有效期
     * 微信服务器每隔 10 分钟以 POST 的方式推送 component_verify_ticket
     */
    public function index(Request $request){
        $timestamp=$request->param('timestamp');
        $nonce=$request->param('nonce');
        $msg_signature=$request->param('msg_signature');
        $msg=file_get_contents("php://input");
        $decrypt=new Sample();
        $component_verify_ticket=$decrypt->decryptMsg($msg,$timestamp,$nonce,$msg_signature);
        cache('component_verify_ticket',$component_verify_ticket['component_verify_ticket'],3600);//缓存一小时
        $has=Db::name('wxopen_component_verify_ticket')->where('id',1)->find();
        if($has){
            Db::name('wxopen_component_verify_ticket')->where('id',1)->update([
               'component_verify_ticket'=> $component_verify_ticket['component_verify_ticket']
            ]);
        }else{
            Db::name('wxopen_component_verify_ticket')->insert([
                'component_verify_ticket'=> $component_verify_ticket['component_verify_ticket']
            ]);
        }
        //将票据存数据库
        return 'success';
    }
    public function Verify(Request $request){
        $response = $this->app->server->serve();
        $response->send();
    }

    /**
     * @param Request $request
     * 获取令牌token
     * 每个令牌的有效期为 2 小时
     */
    public function getComponentAccessToken(){
        $decrypt=new Sample();
        $component_access_token=$decrypt->getComponentAccessToken()['component_access_token'];
//        if(cache('component_access_token')) {
//            $component_access_token=cache('component_access_token');
//        }else{
//            $component_access_token=$decrypt->getComponentAccessToken()['component_access_token'];
//            cache('component_access_token',$component_access_token,3600);//缓存令牌一小时
//        }
        return $component_access_token;

    }

    /**
     *
     * 获取预授权码
     */
    public function getPreAuthCode(){
        $token=$this->getComponentAccessToken();//令牌
        $url='https://api.weixin.qq.com/cgi-bin/component/api_create_preauthcode?component_access_token='.$token;
        $data=[
          'component_appid'=>'wxb69be9ce11dbfbb6'
        ];
        $result = helper::jsonDecode(curl_post($url, json_encode($data)));
        return $result;
    }

    /**
     * 构建授权链接
     * $dealer_id 授权链接加参数
     */
    public function qrCode(){
        $component_appid='wxb69be9ce11dbfbb6';
        $pre_auth_code=$this->getPreAuthCode()['pre_auth_code'];
        $redirect_uri=urlencode('https://pps.uni-2id.com//#/access/officialAccount/officialAuth');//用户授权后回调页面  这里写成前端授权页面（重要！！！）
        $auth_type=1;
        $url='https://mp.weixin.qq.com/cgi-bin/componentloginpage?component_appid='.$component_appid.'&pre_auth_code='.$pre_auth_code.'&redirect_uri='.$redirect_uri.'&auth_type='.$auth_type;
        return $url;
    }

    /**
     * @param Request $request
     * 使用授权码获取授权信息
     * 保存业务数据库 为后续调用客户公众号api做准备
     * 本接口为测试用*******
     */
    public function getAuthorizerInfo(Request $request){
        $component_access_token=$this->getComponentAccessToken();
        $dealer_id=$request->param('dealer_id');
        $url='https://api.weixin.qq.com/cgi-bin/component/api_query_auth?component_access_token='.$component_access_token;
        $data=[
            'component_appid'=>'wxb69be9ce11dbfbb6',
            'authorization_code'=>$request->param('auth_code')
        ];
        $result = helper::jsonDecode(curl_post($url, json_encode($data)));
        $exp=strtotime('+ 2hour');//12小时后token过期
        $data=[
            'authorizer_appid'=>$result['authorization_info']['authorizer_appid'],
            'authorizer_access_token'=>$result['authorization_info']['authorizer_access_token'],//令牌会2小时过期
            'expires_time'=> date('Y-m-d H:i:s', $exp),
            'authorizer_refresh_token'=>$result['authorization_info']['authorizer_refresh_token'],//刷新token令牌
            'func_info'=>json_encode($result['authorization_info']['func_info']),
            'dealer_id'=>$dealer_id
        ];
        $has_auth=Db::name('wxopen_authorization_info')->where('dealer_id',$dealer_id)->find();
        if($has_auth){
            $res=Db::name('wxopen_authorization_info')->where('dealer_id',$dealer_id)->update($data);
        }else{
            $res=Db::name('wxopen_authorization_info')->insert($data);
        }
        if($res||$res==0){

        }else{
            exit();
        }
    }
    /**
     * @param Request $request
     * 使用授权码获取授权信息
     * 保存业务数据库 为后续调用客户公众号api做准备
     */
    public function saveAuthorizerInfo($auth_code,$dealer_id){
        $component_access_token=$this->getComponentAccessToken();
        $url='https://api.weixin.qq.com/cgi-bin/component/api_query_auth?component_access_token='.$component_access_token;
        $data=[
            'component_appid'=>'wxb69be9ce11dbfbb6',
            'authorization_code'=>$auth_code
        ];
        $result = helper::jsonDecode(curl_post($url, json_encode($data)));
        $exp=strtotime('+ 2hour');//12小时后token过期
        $data=[
            'authorizer_appid'=>$result['authorization_info']['authorizer_appid'],
            'authorizer_access_token'=>$result['authorization_info']['authorizer_access_token'],//令牌会2小时过期
            'expires_time'=> date('Y-m-d H:i:s', $exp),
            'authorizer_refresh_token'=>$result['authorization_info']['authorizer_refresh_token'],//刷新token令牌
            'func_info'=>json_encode($result['authorization_info']['func_info']),
            'dealer_id'=>$dealer_id
        ];
        $has_auth=Db::name('wxopen_authorization_info')->where('dealer_id',$dealer_id)->find();
        if($has_auth){
            $res=Db::name('wxopen_authorization_info')->where('dealer_id',$dealer_id)->update($data);
        }else{
            $res=Db::name('wxopen_authorization_info')->insert($data);
        }
        return $res;
    }

    /**
     * 获取授权账号信息
     * return authorization_info object
     * return authorizer_info object
     */
    public function getAuthorizerAccountInfo($authorizer_appid){
        $component_access_token=$this->getComponentAccessToken();
        $data=[
            'component_appid'=>'wxb69be9ce11dbfbb6',//第三方平台 appid
            'authorizer_appid'=>$authorizer_appid//授权方 appid
        ];
        $url='https://api.weixin.qq.com/cgi-bin/component/api_get_authorizer_info?component_access_token='.$component_access_token;
        $result = helper::jsonDecode(curl_post($url, json_encode($data)));
        return $result;
    }
    public function test(){
        $key='ticket@@@NPJr6mwA4bXdt4zCFe2NEByASfHLGhKeeStlWvvlEtUOIpoQbe9OLFGF0g1gvIagoCFi7GdwoLN8IIwZztZ_ug';
        cache('component_verify_ticket',$key,3600);//缓存一小时
    }

}