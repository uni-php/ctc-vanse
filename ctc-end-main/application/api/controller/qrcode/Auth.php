<?php
/**
 * Created by PhpStorm.
 * User: wenhan
 * Date: 2022/4/24
 * Time: 下午12:53
 */

namespace app\api\controller\qrcode;
use app\Request;
use app\api\model\trace\DealerTraceTemplate as PageModel;
use think\config\driver\Json;
use think\Controller;
use app\lib\wxMsgCrypt\Sample;
use app\lib\helper;
use think\Db;
use app\common\JsonService;
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

    /**
     * @param Request $request
     * 获取用户基本信息
     */
    public function getUserInfo(Request $request){
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
        $has_register=Db::name('dealer_member')->where('openid',$userInfo['openid'])->find();
        if(!$has_register){
            Db::name('dealer_member')->insert([
               'openid'=>$userInfo['openid'],
               'nickname'=>$userInfo['nickname'],
               'sex'=>$userInfo['sex'],
               'dealer_id'=>$params['dealer_id'],
               'address'=>$userInfo['province'].','.$userInfo['city'].','.$userInfo['country'],
               'headimgurl'=>$userInfo['headimgurl']
            ]);
        }
        return JsonService::returnData(200,'查询成功',$userInfo);
        //获取用户基本信息
        // 记录日志

    }

    /**
     * @param Request $request
     * 获取用户openid
     * 获取注册状态
     */
    public function getUserOpenid(Request $request){
        $params=$request->get();
        $appid='wx58527ef9c27a4606';
        $secret='5a1e6c22b936c2d716ee7917176e5963';
        $token_url='https://api.weixin.qq.com/sns/oauth2/access_token?appid='.$appid.'&secret='.$secret.'&code='.$params['code'].'&grant_type=authorization_code';
        $result =curl_get($token_url);
        $response = helper::jsonDecode($result);
        if (array_key_exists('errcode', $response)) {
            return JsonService::fail(400,"access_token获取失败，错误信息：{$result}");
        }
        $info=Db::name('dealer_qrcode_marketing_redpack_register')
            ->where('openid',$response['openid'])
            ->where('dealer_id',$params['dealer_id'])
            ->find();
        $response['status']=$info?$info['status']:-1;
        return JsonService::returnData(200,'查询成功',$response);
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