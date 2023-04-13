<?php
/**
 * Created by PhpStorm.
 * Role: wenhan
 * Date: 2021/10/5
 * Time: 上午12:59
 */

namespace app\common;
use think\Db;
use think\Controller;
use think\Request;
use app\common\JsonService;
class UserToken
{
    public static function createToken($user,$ip){
        $str = md5(uniqid(md5(microtime(true)), true)); //创建唯一token
        $str = sha1($str);
        $exp=strtotime('+ 12hour');//12小时后token过期
        $log=[
            'uid'=>$user['uid'],
            'token'=>$str,
            'login_ip'=>$ip,
            'expires_time'=> date('Y-m-d H:i:s', $exp)
        ];
        if($user['identity']=='user'){
            $res=Db::name('user_token')
                ->insert($log);
        }
        if($user['identity']=='partner'){
            $res=Db::name('partner_token')
                ->insert($log);
        }
        if($user['identity']=='dealer'){
            $log['dealer_id']=array_key_exists('dealer_id',$user)?$user['dealer_id']:null;
            $res=Db::name('dealer_token')
                ->insert($log);
        }
        if($user['identity']=='pda'){
            $log['dealer_id']=array_key_exists('dealer_id',$user)?$user['dealer_id']:null;
            $res=Db::name('dealer_pda_token')
                ->insert($log);
        }
        if($res){
            return $log;
        }else{
            return JsonService::fail('token生成失败');
        }
    }
}