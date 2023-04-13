<?php
/**
 * Created by PhpStorm.
 * User: wenhan
 * Date: 2022/12/14
 * Time: 下午2:37
 */

namespace app\dealer\controller\order;
use app\Request;
use think\Controller;
use think\Db;
use app\common\JsonService;
use think\db\Where;

class Address extends Controller
{
    protected $dealer_id;
    public function initialize(){
        $userInfo=Request::userInfo();
        $this->dealer_id=array_key_exists('dealer_id',$userInfo)?$userInfo['dealer_id']:$userInfo['id'];
    }
    public function getAddressInfo(Request $request){
        $params=$request->get();
        $info=Db::name('dealer_member_address')
            ->where('dealer_id',$this->dealer_id)
            ->where('id',$params['user_address_id'])
            ->find();
        return JsonService::successful('查询成功',$info);
    }
}