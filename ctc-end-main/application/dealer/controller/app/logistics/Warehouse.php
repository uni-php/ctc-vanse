<?php
/**
 * Created by PhpStorm.
 * User: wenhan
 * Date: 2022/3/17
 * Time: 下午8:06
 */

namespace app\dealer\controller\app\logistics;
use app\Request;
use think\Controller;
use think\Db;
use app\common\JsonService;
use think\db\Where;

class Warehouse extends Controller
{
    protected $dealer_id;
    public function initialize(){
        $userInfo=Request::userInfo();
        $this->dealer_id=array_key_exists('dealer_id',$userInfo)?$userInfo['dealer_id']:$userInfo['id'];
    }
    public function getWarehouseList(Request $request){
        $params=$request->get();
        $list=Db::name('dealer_logistics_warehouse')
            ->where('dealer_id',$this->dealer_id)
            ->where('code|warehouse_name|address|person','like','%'.$params['keywords'].'%')
            ->page($params['pageNum'])
            ->limit($params['pageSize'])
            ->select();
        $total=Db::name('dealer_logistics_warehouse')
            ->where('dealer_id',$this->dealer_id)
            ->where('code|warehouse_name|address|person','like','%'.$params['keywords'].'%')
            ->count();
        $res=[
            'code'=>200,
            'msg'=>'查询成功',
            'data'=>$list,
            'total'=>$total
        ];
        return json($res);
    }
    public function saveWarehouse(Request $request){
        $data=$request->post();
        if(array_key_exists('id',$data)){
            $res=Db::name('dealer_logistics_warehouse')->update($data);
        }else{
            $data['dealer_id']=$this->dealer_id;
            $res=Db::name('dealer_logistics_warehouse')->insert($data);
        }
        if($res||$res==0){
            return JsonService::successful('保存成功');
        }else{
            return JsonService::fail('请联系管理员');
        }
    }
    public function deleWarehouse(Request $request){
        $id=$request->param('id');
        $res=Db::name('dealer_logistics_warehouse')->delete($id);
        if($res){
            return JsonService::successful('删除成功');
        }else{
            return JsonService::fail('请联系管理员');
        }
    }
    public function getWarehouseInfo(Request $request){
        $id=$request->param('id');
        $info=Db::name('dealer_logistics_warehouse')->where('id',$id)->find();
        return JsonService::successful('查询成功',$info);
    }
}