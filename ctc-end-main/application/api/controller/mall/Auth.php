<?php
/**
 * Created by PhpStorm.
 * User: wenhan
 * Date: 2022/11/29
 * Time: 下午2:59
 */

namespace app\api\controller\mall;
use app\Request;
use think\Controller;
use think\Db;
use app\lib\helper;
use app\common\JsonService;
use app\lib\wxMsgCrypt\Sample;
use app\dealer\controller\wechat\Open;

class Auth extends Controller
{
    public function getAuthInfo(Request $request){
        $dealer_id=$request->param('dealer_id');
        $auth_info=Db::name('wxopen_authorization_info')
            ->where('dealer_id',$dealer_id)
            ->find();
        return JsonService::returnData(200,'查询成功',$auth_info);
    }
    public function getAuthUserInfo(Request $request){
        $params=$request->get();
        $component_appid='wxb69be9ce11dbfbb6';
        $component_access_token=$this->getComponentAccessToken();
        $token_url='https://api.weixin.qq.com/sns/oauth2/component/access_token?appid='.$params['appid'].'&code='.$params['code'].'&grant_type=authorization_code'.'&component_appid='.$component_appid.'&component_access_token='.$component_access_token;
        $result =curl_get($token_url);
        $response = helper::jsonDecode($result);
        if (array_key_exists('errcode', $response)) {
            return JsonService::fail(400,"access_token获取失败，错误信息：{$result}");
        }
        $user_url='https://api.weixin.qq.com/sns/userinfo?access_token='.$response['access_token'].'&openid='.$response['openid'].'&lang=zh_CN';
        $userInfo=helper::jsonDecode(curl_get($user_url));
        $has_register=Db::name('dealer_member')->where('openid',$userInfo['openid'])->where('dealer_id',$params['dealer_id'])->find();
        if(!$has_register){
            Db::name('dealer_member')->insert([
                'openid'=>$userInfo['openid'],
                'nickname'=>$userInfo['nickname'],
                'sex'=>$userInfo['sex'],
                'dealer_id'=>$params['dealer_id'],
                'address'=>$userInfo['province'].','.$userInfo['city'].','.$userInfo['country'],
                'headimgurl'=>$userInfo['headimgurl']
            ]);
            $userInfo['points']=0;
        }
        return JsonService::returnData(200,'查询成功',$has_register?$has_register:$userInfo);
    }
    public function getJsConfig(Request $request){
        $dealer_id=$request->param('dealer_id');
        $auth_info=Db::name('wxopen_authorization_info')->where('dealer_id',$dealer_id)->find();
        $wechat=new Open($auth_info['authorizer_appid'],$auth_info['authorizer_refresh_token']);
        $url=$request->param('url');
        $config=$wechat->getJsConfig($url);
        return JsonService::returnData(200,'查询成功',json_decode($config,true));
    }
    /**
     * @param Request $request
     * 获取令牌token
     * 每个令牌的有效期为 2 小时
     */
    public function getComponentAccessToken(){
        $decrypt=new Sample();
        $component_access_token=$decrypt->getComponentAccessToken()['component_access_token'];
        return $component_access_token;

    }
}