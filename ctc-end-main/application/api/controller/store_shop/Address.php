<?php
/**
 * Created by PhpStorm.
 * User: wenhan
 * Date: 2022/12/18
 * Time: 下午2:10
 */

namespace app\api\controller\store_shop;
use app\Request;
use think\Controller;
use think\Db;
use app\common\JsonService;

class Address extends Controller
{
    public function getMemberAddressList(Request $request){
        $params=$request->get();
        $list=Db::name('dealer_member_address')
            ->where('dealer_id',$params['dealer_id'])
            ->where('openid',$params['openid'])
            ->where('is_dele',0)
            ->select();
        return JsonService::returnData(200,'查询成功',$list);
    }
    public function saveMemberAddress(Request $request){
        $data=$request->post();
        if(array_key_exists('id',$data)){
            $res=Db::name('dealer_member_address')
                ->where('id',$data['id'])
                ->update($data);
        }else{
            $res=Db::name('dealer_member_address')->insert($data);
        }
        if($res||$res==0){
            return JsonService::returnData(200,'保存成功');
        }else{
            return JsonService::returnData(500,'请联系管理员');
        }

    }
    public function deleMemberAddress(Request $request){
        $res=Db::name('dealer_member_address')
            ->where('id',$request->param('id'))
            ->update([
                'is_dele'=>1
            ]);
        if($res){
            return JsonService::returnData(200,'删除成功');
        }else{
            return JsonService::returnData(500,'请联系管理员');
        }
    }
    public function queryMemberAddress(Request $request){
        $res=Db::name('dealer_member_address')
            ->where('id',$request->param('id'))
            ->find();
        return JsonService::returnData(200,'查询成功',$res);
    }
    public function setDefaultMemberAddress(Request $request){
        $params=$request->get();
        Db::name('dealer_member_address')
            ->where('dealer_id',$params['dealer_id'])
            ->where('openid',$params['openid'])
            ->update([
                'is_default'=>1
            ]);
        $res=Db::name('dealer_member_address')
            ->where('id',$params['id'])
            ->update([
                'is_default'=>2
            ]);
        if($res){
            return JsonService::returnData(200,'设置成功');
        }else{
            return JsonService::returnData(500,'请联系管理员');
        }
    }
}