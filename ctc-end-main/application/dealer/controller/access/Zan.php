<?php
/**
 * Created by PhpStorm.
 * User: wenhan
 * Date: 2021/11/19
 * Time: 下午6:01
 */

namespace app\dealer\controller\access;
use app\Request;
use think\Controller;
use think\Db;
class Zan extends Controller
{
    protected $dealer_id;
    public function initialize(){
        $userInfo=Request::userInfo();
        $this->dealer_id=array_key_exists('dealer_id',$userInfo)?$userInfo['dealer_id']:$userInfo['id'];
    }
    public function getAuthInfo(){
        $info=Db::name('dealer_zan')
            ->where('dealer_id',$this->dealer_id)
            ->find();
        $res=[
            'code'=>200,
            'msg'=>'查询成功',
            'data'=>$info,
        ];
        return json($res);
    }
    public function saveAuthInfo(Request $request){
        $data=$request->post();
        if(array_key_exists('id',$data)){
            $res=Db::name('dealer_zan')
                ->update($data);
        }else{
            $data['dealer_id']=$this->dealer_id;
            $res=Db::name('dealer_zan')
                ->insert($data);
        }
        if($res||$res==0){
            $info=[
                'code'=>200,
                'msg'=>'保存成功'
            ];
        }else{
            $info=[
                'code'=>201,
                'msg'=>'系统异常'
            ];
        }
        return json($info);
    }
}