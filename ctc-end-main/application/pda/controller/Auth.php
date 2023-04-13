<?php
/**
 * Created by PhpStorm.
 * User: wenhan
 * Date: 2022/3/26
 * Time: 下午12:45
 */

namespace app\pda\controller;
use app\Request;
use app\common\JsonService;
use app\common\UserToken;
use think\Controller;
use think\Db;

class Auth extends Controller
{
    public function login(Request $request){
        //判断登录用户是否是品牌商的子账号
        $user = Db::name('dealer')->where('account', $request->param('account'))->find();
        if(!$user) {$user = Db::name('dealer_user')->where('account', $request->param('account'))->find();}
        if ($user) {
            if ($user['password'] !== md5($request->param('password')))
                return JsonService::returnData(500,'账号或密码错误');
        } else {
            return JsonService::returnData(500,'账号或密码错误');
        }
        if ($user['status'] == 0)
            return JsonService::returnData(500,'当前账号未授权');
        if($user['status'] == 2||$user['status'] == 3)
            return JsonService::returnData(500,'已被禁用，请联系管理员');
        $user['uid']=$user['id'];
        $user['identity']='pda';//品牌商
        $token = UserToken::createToken($user, $request->ip());
        if ($token) {
            return JsonService::returnData(200,'登录成功',['token' => $token['token'],'userInfo'=>$user,'userId'=>$user['uid'], 'expires_time' => $token['expires_time']]);
        } else {
            return JsonService::returnData(500,'登录失败');
        }
    }
}