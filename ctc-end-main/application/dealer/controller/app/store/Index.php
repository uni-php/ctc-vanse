<?php
/**
 * Created by PhpStorm.
 * User: wenhan
 * Date: 2022/12/10
 * Time: 下午4:03
 */

namespace app\dealer\controller\app\store;
use app\Request;
use think\Controller;
use think\Db;
use app\common\JsonService;
use think\db\Where;

class Index extends Controller
{
    protected $dealer_id;
    public function initialize(){
        $userInfo=Request::userInfo();
        $this->dealer_id=array_key_exists('dealer_id',$userInfo)?$userInfo['dealer_id']:$userInfo['id'];
    }
    public function getStoreList(Request $request){
        $params=$request->get();
        $condition['is_commission']=['like','%'.$params['is_commission'].'%'];
        $condition['is_mall']=['like','%'.$params['is_mall'].'%'];
        $condition['is_goods_self']=['like','%'.$params['is_self'].'%'];
        $condition['store_name']=['like','%'.$params['store_name'].'%'];
        $condition['store_code']=['like','%'.$params['store_code'].'%'];
        $list=Db::name('dealer_store')
            ->where(new Where($condition))
            ->where('dealer_id',$this->dealer_id)
            ->where('check_status',1)
            ->where('status','<>',3)
            ->page($params['pageNum'])
            ->limit($params['pageSize'])
            ->order('create_time','desc')
            ->select();
        $total=Db::name('dealer_store')
            ->where(new Where($condition))
            ->where('is_self',0)
            ->where('check_status',1)
            ->where('status','<>',3)
            ->where('dealer_id',$this->dealer_id)
            ->count();
        $res=[
            'code'=>200,
            'msg'=>'查询成功',
            'data'=>$list,
            'total'=>$total
        ];
        return json($res);
    }
    public function saveStoreAuth(Request $request){
        $params=$request->post();
        $res=Db::name('dealer_store')
            ->where('id',$params['id'])
            ->where('dealer_id',$this->dealer_id)
            ->update($params);
        if($res||$res==0){
            return JsonService::successful('保存成功');
        }else{
            return JsonService::fail('请联系管路员');
        }
    }
    public function getStoreInfo(Request $request){
        $id=$request->param('id');
        $res=Db::name('dealer_store')
            ->where('id',$id)
            ->find();
        return JsonService::successful('查询成功',$res);
    }
}