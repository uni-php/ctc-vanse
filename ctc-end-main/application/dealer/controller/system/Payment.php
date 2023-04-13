<?php
/**
 * Created by PhpStorm.
 * User: wenhan
 * Date: 2021/11/15
 * Time: 下午10:12
 */

namespace app\dealer\controller\system;
use think\Controller;
use think\Db;
use app\Request;
use think\facade\Hook;

class Payment extends Controller
{
    public function getPayInfo(Request $request){
        $userInfo=$request->userInfo();
        $dealer_id=array_key_exists('dealer_id',$userInfo)?$userInfo['dealer_id']:$userInfo['id'];
        $res=Db::name('dealer_payment')
            ->where('dealer_id',$dealer_id)
            ->find();
        $info=[
            'code'=>200,
            'msg'=>'查询成功',
            'data'=>$res
        ];
        return json($info);
    }
    public function savePayInfo(Request $request){
        $userInfo=$request->userInfo();
        $address = $request->address();
        $dealer_id=array_key_exists('dealer_id',$userInfo)?$userInfo['dealer_id']:$userInfo['id'];
        $data=$request->post();
        $data['dealer_id']=$dealer_id;
        if(array_key_exists('id',$data)){
            $res=Db::name('dealer_payment')
                ->update($data);
        }else{
            $res=Db::name('dealer_payment')
                ->insert($data);
        }
        if($res||$res==0){
            $log=[
                'module_name'=>'系统管理',
                'operator'=>$request->userInfo()['account'],
                'ip'=>$request->ip(),
                'address'=>$address[2].$address[3],
                'operate_type'=>'2',
                'operate_event'=>'更新支付信息',
                'dealer_id'=>$dealer_id
            ];
            Hook::listen('dealer_op_log',$log);
            $info=[
                'code'=>200,
                'msg'=>'保存成功',
            ];
        }else{
            $info=[
                'code'=>201,
                'msg'=>'系统异常',
            ];
        }
        return json($info);
    }
}