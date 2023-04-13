<?php
/**
 * Created by PhpStorm.
 * User: wenhan
 * Date: 2022/12/3
 * Time: 上午1:20
 */

namespace app\api\controller\mall;
use app\Request;
use think\Controller;
use think\Db;
use app\common\JsonService;

class userCenter extends Controller
{
    public function getUserInfo(Request $request){
    $params=$request->get();
    $userInfo=Db::name('dealer_member')
        ->where('openid',$params['openid'])
        ->where('dealer_id',$params['dealer_id'])
        ->find();
    $address=Db::name('dealer_member_address')
        ->where('dealer_id',$params['dealer_id'])
        ->where('is_dele',0)
        ->where('openid',$params['openid'])
        ->select();
    $userInfo['address']= empty($address)?[]:$address[0];
    foreach ($address as $key=>$value){
        if($value['is_default']==2){
            $userInfo['address']=$value;
        }
    }
    return JsonService::returnData(200,'查询成功',$userInfo);
}
    public function saveUserInfo(Request $request){
        $data=$request->post();
        if(array_key_exists('id',$data)){
            $res=Db::name('dealer_member')
                ->update($data);
        }else{
            $res=Db::name('dealer_member')->insert($data);
        }
        if($res||$res==0){
            return JsonService::returnData(200,'保存成功');
        }else{
            return JsonService::returnData(500,'请联系管理员');
        }
    }
}