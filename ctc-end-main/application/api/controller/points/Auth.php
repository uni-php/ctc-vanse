<?php
/**
 * Created by PhpStorm.
 * User: wenhan
 * Date: 2022/8/22
 * Time: 下午10:56
 */

namespace app\api\controller\points;
use app\Request;
use think\Controller;
use think\Db;
use app\lib\helper;
use app\common\JsonService;
use app\lib\wxMsgCrypt\Sample;
use app\dealer\controller\wechat\Open;
use app\dealer\controller\wechat\Wechat;

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
        $appid='wx58527ef9c27a4606';
        $secret='5a1e6c22b936c2d716ee7917176e5963';
        $token_url='https://api.weixin.qq.com/sns/oauth2/access_token?appid='.$appid.'&secret='.$secret.'&code='.$params['code'].'&grant_type=authorization_code';
        $result =curl_get($token_url);
        $response = helper::jsonDecode($result);
        if (array_key_exists('errcode', $response)) {
            return JsonService::fail(400,"access_token获取失败，错误信息：{$result}");
        }
        $user_url='https://api.weixin.qq.com/sns/userinfo?access_token='.$response['access_token'].'&openid='.$response['openid'].'&lang=zh_CN';
        $userInfo=helper::jsonDecode(curl_get($user_url));
        $has_register=Db::name('dealer_member')
            ->where('dealer_id',$params['dealer_id'])
            ->where('openid',$userInfo['openid'])
            ->find();
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
        $wechat=new Wechat();
        $url=$request->param('url');
        $config=$wechat->getJsConfig($url);
        return JsonService::returnData(200,'查询成功',json_decode($config,true));
    }
}