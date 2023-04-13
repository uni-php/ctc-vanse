<?php
/**
 * Created by PhpStorm.
 * Role: wenhan
 * Date: 2021/11/12
 * Time: 下午11:53
 */

namespace app\dealer\controller\system;

use app\Request;
use think\Controller;
use think\Db;
use think\facade\Hook;

class Account extends Controller
{
    public function getDealerInfo(Request $request){
        $userInfo=$request->userInfo();
        $dealer_id=array_key_exists('dealer_id',$userInfo)?$userInfo['dealer_id']:$userInfo['id'];
        $info=Db::name('dealer')->where('id',$dealer_id)->find();
        $keys = ['dealer_name' , 'company', 'concact_name','phone','address','website','industry','email','telephone','logo','province','city','district'];
        $result =  array_filter($info, function ($val, $key) use ($keys) {
            if (in_array($key, $keys)) {
                return true;
            }
        }, ARRAY_FILTER_USE_BOTH);
        return json([
            'data'=>$result,
            'code'=>200
        ]);
    }
    public function saveDealerInfo(Request $request){
        $data=$request->post();
        $userInfo=$request->userInfo();
        $data['id']=array_key_exists('dealer_id',$userInfo)?$userInfo['dealer_id']:$userInfo['id'];
        $res=Db::name('dealer')
            ->update($data);
        if($res||$res==0){
            $log=[
                'module_name'=>'账户管理',
                'operator'=>$request->userInfo()['account'],
                'ip'=>$request->ip(),
                'address'=>$data['id'],
                'operate_type'=>'2',
                'operate_event'=>'更新账户信息',
                'dealer_id'=>$data['id']
            ];
            Hook::listen('dealer_op_log',$log);
            $info=[
                'code'=>200,
                'msg'=>'更新成功',
            ];
        }else{
            $info=[
                'code'=>201,
                'msg'=>'系统异常'
            ];
        }
        return json($info);
    }
    public function getAuthData(Request $request){
        $userInfo=$request->userInfo();
        $id=array_key_exists('dealer_id',$userInfo)?$userInfo['dealer_id']:$userInfo['id'];
        $license=Db::name('dealer_business_license')
            ->where('dealer_id',$id)
            ->find();
        if(!$license) $license['status']=0;
        $license['type']=1;//营业执照
        $license['name']='企业营业执照';
        $license['tips']='认证后的品牌商资料将作为品牌商的通用名片，可在版权、防伪查询等地方进行应用。';
        $trademark=Db::name('dealer_trademark')
            ->where('dealer_id',$id)
            ->find();
        if(!$trademark) $trademark['status']=0;
        $trademark['type']=2;//商标
        $trademark['name']='中国商标权证书';
        $trademark['tips']='认证后的品牌商可以提升品牌的知名度和交易信任级别，认证后品牌商名称可以在查询页显示。';
        $arr=[
            $license,$trademark
        ];
        $info=[
            'code'=>200,
            'msg'=>'查询成功',
            'data'=>$arr
        ];
        return json($info);
    }
    public function checkTrademark(Request $request){
        $data=$request->post();
        $userInfo=$request->userInfo();
        $address = $request->address();
        $data['dealer_id']=array_key_exists('dealer_id',$userInfo)?$userInfo['dealer_id']:$userInfo['id'];
        if(array_key_exists('id',$data)){
            $data['status']=3;//更新中
            $code=Db::name('dealer_trademark')
                ->update($data);
        }else{
            $code=Db::name('dealer_trademark')
                ->insert($data);
        }
        if($code||$code==0){
            $log=[
                'module_name'=>'账户管理',
                'operator'=>$request->userInfo()['account'],
                'ip'=>$request->ip(),
                'address'=>$address[2].$address[3],
                'operate_type'=>'2',
                'operate_event'=>'更新商标权证书',
                'dealer_id'=>$data['dealer_id']
            ];
            Hook::listen('dealer_op_log',$log);
            $info=[
                'code'=>200,
                'msg'=>'更新成功',
            ];
        }else{
            $info=[
                'code'=>201,
                'msg'=>'请联系管理员',
            ];
        }
        return json($info);
    }
    public function checkLicense(Request $request){
        $data=$request->post();
        $address = $request->address();
        $userInfo=$request->userInfo();
        $data['dealer_id']=array_key_exists('dealer_id',$userInfo)?$userInfo['dealer_id']:$userInfo['id'];
        if(array_key_exists('id',$data)){
            $data['status']=3;//更新中
            $code=Db::name('dealer_business_license')
                ->update($data);
        }else{
            $code=Db::name('dealer_business_license')
                ->insert($data);
        }
        if($code||$code==0){
            $log=[
                'module_name'=>'账户管理',
                'operator'=>$request->userInfo()['account'],
                'ip'=>$request->ip(),
                'dealer_id'=>$data['dealer_id'],
                'address'=>$address[2].$address[3],
                'operate_type'=>'2',
                'operate_event'=>'更新营业执照'
            ];
            Hook::listen('dealer_op_log',$log);
            $info=[
                'code'=>200,
                'msg'=>'更新成功',
            ];
        }else{
            $info=[
                'code'=>201,
                'msg'=>'请联系管理员',
            ];
        }
        return json($info);
    }
}