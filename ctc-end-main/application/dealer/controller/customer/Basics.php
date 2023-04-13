<?php
/**
 * Created by PhpStorm.
 * User: wenhan
 * Date: 2021/12/28
 * Time: 下午9:11
 */

namespace app\dealer\controller\customer;
use app\Request;
use think\Controller;
use think\Db;
use app\common\JsonService;

class Basics extends Controller
{
    protected $dealer_id;
    public function initialize(){
        $userInfo=Request::userInfo();
        $this->dealer_id=array_key_exists('dealer_id',$userInfo)?$userInfo['dealer_id']:$userInfo['id'];
    }
    public function getCustomerAreaList(Request $request){
        $list=Db::name('dealer_customer_zone')
            ->where('dealer_id',$this->dealer_id)
            ->order('order','desc')
            ->select();
        return JsonService::successful('查询成功',$list);
    }
    public function saveCustomerArea(Request $request){
        $data=$request->post();
        $data['dealer_id']=$this->dealer_id;
        if(array_key_exists('id',$data)){
            $res=Db::name('dealer_customer_zone')->update($data);
        }else{
            $res=Db::name('dealer_customer_zone')->insert($data);
        }
        if($res||$res==0){
            return JsonService::successful('保存成功');
        }else{
            return JsonService::fail('请联系管理员');
        }
    }
    public function deleCustomerArea(Request $request){
        $id=$request->param('id');
        $res=Db::name('dealer_customer_zone')->delete($id);
        if($res){
           return JsonService::successful('删除成功');
        }else{
            return JsonService::fail('请联系管理员');
        }
    }
    public function queryCustomerArea(Request $request){
        $id=$request->param('id');
        $res=Db::name('dealer_customer_zone')
            ->where('id',$id)
            ->find();
        return JsonService::successful('查询成功',$res);
    }
    public function queryBasicSetInfo(Request $request){
        $res=Db::name('dealer_customer_basic_set')
            ->where('dealer_id',$this->dealer_id)
            ->find();
        return JsonService::successful('查询成功',$res);
    }
    public function saveBasicSetInfo(Request $request){
        $data=$request->post();
        $data['dealer_id']=$this->dealer_id;
        if(array_key_exists('id',$data)){
            $res=Db::name('dealer_customer_basic_set')->update($data);
        }else{
            $res=Db::name('dealer_customer_basic_set')->insert($data);
        }
        if($res||$res==0){
            return JsonService::successful('保存成功');
        }else{
            return JsonService::fail('请联系管理员');
        }
    }
    public function queryUserSetInfo(Request $request){
        $res=Db::name('dealer_customer_userinfo_page')
            ->where('dealer_id',$this->dealer_id)
            ->find();
        return JsonService::successful('查询成功',$res);
    }
    public function saveUserSetInfo(Request $request){
        $data=$request->post();
        $data['dealer_id']=$this->dealer_id;
        if(array_key_exists('id',$data)){
            $res=Db::name('dealer_customer_userinfo_page')->update($data);
        }else{
            $res=Db::name('dealer_customer_userinfo_page')->insert($data);
        }
        if($res||$res==0){
            return JsonService::successful('保存成功');
        }else{
            return JsonService::fail('请联系管理员');
        }
    }
}