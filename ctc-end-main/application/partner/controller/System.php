<?php
/**
 * Created by PhpStorm.
 * Role: wenhan
 * Date: 2021/10/24
 * Time: 上午12:31
 */

namespace app\partner\controller;
use think\Controller;
use think\Db;
use app\Request;

class System extends Controller
{
    public function resetPwd(Request $request){
        $params=$request->get();
        $partner_id=$request->userInfo()['id'];//合伙人id
        $partner=Db::name('partner')
            ->where('id',$partner_id)
            ->find();
        if($partner['password']!=md5($params['password'])){
            $info=[
                'code'=>201,
                'msg'=>'原始密码不正确'
            ];
        }else{
            $res=Db::name('partner')
                ->where('id',$partner_id)
                ->update([
                   'password'=>md5($params['new_pwd'])
                ]);
            if($res||$res==0){
                $info=[
                    'code'=>200,
                    'msg'=>'更改成功'
                ];
            }else{
                $info=[
                    'code'=>201,
                    'msg'=>'请联系管理员'
                ];
            }
        }
        return json($info);
    }
}