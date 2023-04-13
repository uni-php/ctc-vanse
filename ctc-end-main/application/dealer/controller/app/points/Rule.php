<?php
/**
 * Created by PhpStorm.
 * User: wenhan
 * Date: 2022/3/12
 * Time: 下午9:40
 */

namespace app\dealer\controller\app\points;
use app\Request;
use think\Controller;
use think\Db;
use app\common\JsonService;
use think\db\Where;

class Rule extends Controller
{
    protected $dealer_id;
    public function initialize(){
        $userInfo=Request::userInfo();
        $this->dealer_id=array_key_exists('dealer_id',$userInfo)?$userInfo['dealer_id']:$userInfo['id'];
    }
    public function getPointsRule(Request $request){
        $info=Db::name('dealer_points_rule')
            ->where('dealer_id',$this->dealer_id)
            ->find();
        return JsonService::successful('查询成功',$info);
    }
    public function savePointsRule(Request $request){
        $data=$request->post();
        if(array_key_exists('id',$data)){
            $res=Db::name('dealer_points_rule')->update($data);
        }else{
            $data['dealer_id']=$this->dealer_id;
            $res=Db::name('dealer_points_rule')->insert($data);
        }
        if($res||$res==0){
            return JsonService::successful('保存成功');
        }else{
            return JsonService::fail('请联系管理员');
        }
    }
}