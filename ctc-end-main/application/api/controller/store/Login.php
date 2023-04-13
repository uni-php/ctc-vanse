<?php
/**
 * Created by PhpStorm.
 * User: wenhan
 * Date: 2022/12/11
 * Time: 下午10:18
 */

namespace app\api\controller\store;
use app\Request;
use think\Controller;
use think\Db;
use app\api\controller\store\Location;
use app\common\JsonService;

class Login extends Controller
{
    public function login(Request $request){
        $params=$request->get();
        $is_store_user=Db::name('dealer_store')
            ->where('dealer_id',$params['dealer_id'])
            ->where('mobile_phone',$params['account'])
            ->where('password',$params['password'])
            ->where('status','<>',3)
            ->find();
        if(!$is_store_user) return JsonService::returnData(500,'账号或密码错误');
        if($is_store_user['status']==2) return JsonService::returnData(500,'门店被禁用');
        return JsonService::returnData(200,'登录成功',$is_store_user);
    }
}