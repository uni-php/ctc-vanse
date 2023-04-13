<?php
/**
 * Created by PhpStorm.
 * User: wenhan
 * Date: 2022/11/15
 * Time: 下午2:30
 */

namespace app\dealer\controller\app\guide;
use think\Db;
use app\common\JsonService;
use app\Request;
use think\db\Where;
use think\Controller;

class User extends Controller
{
    protected $dealer_id;
    public function initialize(){
        $userInfo=Request::userInfo();
        $this->dealer_id=array_key_exists('dealer_id',$userInfo)?$userInfo['dealer_id']:$userInfo['id'];
    }
    public function queryUserSetInfo(Request $request){
        $res=Db::name('dealer_guide_userinfo_page')
            ->where('dealer_id',$this->dealer_id)
            ->find();
        return JsonService::successful('查询成功',$res);
    }
    public function saveUserSetInfo(Request $request){
        $data=$request->post();
        $data['dealer_id']=$this->dealer_id;
        if(array_key_exists('id',$data)){
            $res=Db::name('dealer_guide_userinfo_page')->update($data);
        }else{
            $res=Db::name('dealer_guide_userinfo_page')->insert($data);
        }
        if($res||$res==0){
            return JsonService::successful('保存成功');
        }else{
            return JsonService::fail('请联系管理员');
        }
    }
}