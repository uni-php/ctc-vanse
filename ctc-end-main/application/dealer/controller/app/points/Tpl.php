<?php
/**
 * Created by PhpStorm.
 * User: wenhan
 * Date: 2022/3/12
 * Time: 上午12:10
 */

namespace app\dealer\controller\app\points;
use app\Request;
use think\Controller;
use think\Db;
use app\common\JsonService;
use think\db\Where;

class Tpl extends Controller
{
    protected $dealer_id;
    public function initialize(){
        $userInfo=Request::userInfo();
        $this->dealer_id=array_key_exists('dealer_id',$userInfo)?$userInfo['dealer_id']:$userInfo['id'];
    }
    public function savePointsTpl(Request $request){
        $data=$request->post();
        $data['page_content']=json_encode($data['page_content']);
        $has=Db::name('dealer_points_template')
            ->where('dealer_id',$this->dealer_id)
            ->find();
        if($has){
            $res=Db::name('dealer_points_template')
                ->where('dealer_id',$this->dealer_id)
                ->update($data);
        }else{
            $data['dealer_id']=$this->dealer_id;
            $res=Db::name('dealer_points_template')
                ->insert($data);
        }
        if($res||$res==0){
            return JsonService::successful('保存成功');
        }else{
            return JsonService::fail('请联系管理员');
        }
    }
    public function getTplInfo(Request $request){
        $info=Db::name('dealer_points_template')
            ->where('dealer_id',$this->dealer_id)
            ->find();
        if($info) $info['page_content']=json_decode($info['page_content'],true);
        return JsonService::successful('查询成功',$info?:null);
    }
}