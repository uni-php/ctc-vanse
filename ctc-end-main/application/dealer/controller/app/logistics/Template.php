<?php
/**
 * Created by PhpStorm.
 * User: wenhan
 * Date: 2022/4/7
 * Time: 上午2:40
 */

namespace app\dealer\controller\app\logistics;
use app\Request;
use think\Controller;
use think\Db;
use app\common\JsonService;
use think\db\Where;

class Template extends Controller
{
    protected $dealer_id;
    public function initialize(){
        $userInfo=Request::userInfo();
        $this->dealer_id=array_key_exists('dealer_id',$userInfo)?$userInfo['dealer_id']:$userInfo['id'];
    }
    public function getTplInfo(Request $request){
        $res=Db::name('dealer_logistics_template')
            ->where('dealer_id',$this->dealer_id)
            ->find();
        $res['tab']=json_decode($res['tab'],true);
        $res['banner_img']=json_decode($res['banner_img'],true);
        $res['activity_img']=json_decode($res['activity_img'],true);
        return JsonService::successful('查询成功',$res);
    }
    public function saveTraceTpl(Request $request){
        $data=$request->post();
        $data['dealer_id']=$this->dealer_id;
        $data['activity_img']=json_encode($data['activity_img']);
        $data['tab']=json_encode($data['tab']);
        $data['banner_img']=json_encode($data['banner_img']);
        //生成唯一模板编号
        if(!array_key_exists('template_code',$data)){
            $data['template_code']=date('Ymd') . time();
        }
        if(array_key_exists('id',$data)){
            $res=Db::name('dealer_logistics_template')->update($data);
        }else{
            $res=Db::name('dealer_logistics_template')->insert($data);
        }
        if($res||$res==0){
            return JsonService::successful('保存成功');
        }else{
            return JsonService::fail('请联系管理员');
        }
    }
}