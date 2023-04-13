<?php
/**
 * Created by PhpStorm.
 * User: wenhan
 * Date: 2022/8/13
 * Time: 下午6:49
 */

namespace app\api\controller\points;
use app\Request;
use think\Controller;
use think\Db;
use app\common\JsonService;

class UserCenter extends Controller
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