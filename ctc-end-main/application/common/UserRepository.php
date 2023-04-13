<?php
/**
 * Created by PhpStorm.
 * Role: wenhan
 * Date: 2021/10/4
 * Time: 下午11:25
 */

namespace app\common;
use think\Controller;
use think\Db;
use think\Request;
use app\common\JsonService;

use app\lib\exception\AuthException;

class UserRepository extends Controller
{
//    获取授权信息
    public static function parseToken($token){
        //验证token是否在有效期
        $res=Db::name('user_token')
            ->where('token',$token)
            ->whereBetweenTimeField('create_time','expires_time')
            ->find();
        if($res){
            $authInfo['user']=Db::name('user')->field('password',true)->where('uid',$res['uid'])->find();
            return $authInfo;
        }else{
//            return JsonService::fail('token已过期');
            throw new AuthException();
        }
    }

    public static function partnerParseToken($token){
        //验证token是否在有效期
        $res=Db::name('partner_token')
            ->where('token',$token)
            ->whereBetweenTimeField('create_time','expires_time')
            ->find();
        if($res){
            $authInfo['user']=Db::name('partner')->field('password',true)->where('id',$res['uid'])->find();
            return $authInfo;
        }else{
            throw new AuthException();
        }
    }

    public static function dealerParseToken($token){
        //验证token是否在有效期
        $res=Db::name('dealer_token')
            ->where('token',$token)
            ->whereBetweenTimeField('create_time','expires_time')
            ->find();
        if($res){
            if(!$res['dealer_id']){
                $authInfo['user']=Db::name('dealer')->field('password',true)->where('id',$res['uid'])->find();
            }else{
                $authInfo['user']=Db::name('dealer_user')->field('password',true)->where('id',$res['uid'])->find();
            }
            return $authInfo;
        }else{
            throw new AuthException();
        }
    }
    public static function pdaParseToken($token){
        //验证token是否在有效期
        $res=Db::name('dealer_pda_token')
            ->where('token',$token)
            ->whereBetweenTimeField('create_time','expires_time')
            ->find();
        if($res){
            if(!$res['dealer_id']){
                $authInfo['user']=Db::name('dealer')->field('password',true)->where('id',$res['uid'])->find();
            }else{
                $authInfo['user']=Db::name('dealer_user')->field('password',true)->where('id',$res['uid'])->find();
            }
            return $authInfo;
        }else{
            throw new AuthException();
        }
    }
}