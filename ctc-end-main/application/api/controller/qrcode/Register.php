<?php
/**
 * Created by PhpStorm.
 * User: wenhan
 * Date: 2022/5/16
 * Time: 上午1:01
 */

namespace app\api\controller\qrcode;
use app\Request;
use think\Controller;
use app\lib\helper;
use think\Db;
use app\common\JsonService;

class Register extends Controller
{
    /**
     * @param Request $request
     * 定向红包注册
     */
    public function saveRegisterInfo(Request $request){
        $data=$request->post();
        $has=Db::name('dealer_qrcode_marketing_redpack_register')
            ->where('openid',$data['openid'])
            ->where('dealer_id',$data['dealer_id'])
            ->find();
        if($has) return JsonService::returnData(500,'请勿重复注册');
        $res=Db::name('dealer_qrcode_marketing_redpack_register')
            ->strict(false)
            ->insert($data);
        if($res){
            return JsonService::returnData(200,'提交成功，请等待审核');
        }else{
            return JsonService::returnData(500,'请联系管理员');
        }
    }
    public function getWorkType(Request $request){
        $list=Db::name('dict_data')
            ->where('dict_type','work_type')
            ->where('status',0)
            ->select();
        return JsonService::returnData(200,'查询成功',$list);
    }
    public function getOperationCenter(Request $request){
        $list=Db::name('dict_data')
            ->where('dict_type','operation_center')
            ->where('status',0)
            ->select();
        return JsonService::returnData(200,'查询成功',$list);
    }

}