<?php
/**
 * Created by PhpStorm.
 * User: wenhan
 * Date: 2022/4/7
 * Time: 上午2:02
 */

namespace app\dealer\controller\app\logistics;
use app\Request;
use think\Controller;
use think\Db;
use app\common\JsonService;
use think\db\Where;

class BasicSet extends Controller
{
    protected $dealer_id;
    public function initialize(){
        $userInfo=Request::userInfo();
        $this->dealer_id=array_key_exists('dealer_id',$userInfo)?$userInfo['dealer_id']:$userInfo['id'];
    }
    public function getBasicSetInfo(Request $request){
        $res=Db::name('dealer_logistics_basic_set')
            ->where('dealer_id',$this->dealer_id)
            ->find();
        return JsonService::successful('查询成功',$res);
    }
    public function saveBasicSetInfo(Request $request){
      $data=$request->post();
      $data['dealer_id']=$this->dealer_id;
      if(array_key_exists('id',$data)){
          $res=Db::name('dealer_logistics_basic_set')
              ->update($data);
      }else{
          $res=Db::name('dealer_logistics_basic_set')->insert($data);
      }
      if($res||$res==0){
          return JsonService::successful('保存成功');
      }else{
          return JsonService::fail('请联系管理员');
      }
    }
}