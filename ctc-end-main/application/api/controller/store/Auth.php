<?php
/**
 * Created by PhpStorm.
 * User: wenhan
 * Date: 2022/12/5
 * Time: 下午1:53
 */

namespace app\api\controller\store;
use app\Request;
use think\Controller;
use think\Db;
use app\lib\helper;
use app\common\JsonService;
use app\lib\wxMsgCrypt\Sample;
use app\dealer\controller\wechat\Open;

class Auth extends Controller
{
    public function getJsConfig(Request $request){
        $dealer_id=$request->param('dealer_id');
        $auth_info=Db::name('wxopen_authorization_info')->where('dealer_id',$dealer_id)->find();
        $wechat=new Open($auth_info['authorizer_appid'],$auth_info['authorizer_refresh_token']);
        $url=$request->param('url');
        $config=$wechat->getJsConfig($url);
        return JsonService::returnData(200,'查询成功',json_decode($config,true));
    }
}