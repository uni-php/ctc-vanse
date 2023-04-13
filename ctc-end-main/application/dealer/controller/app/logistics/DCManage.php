<?php
/**
 * Created by PhpStorm.
 * User: wenhan
 * Date: 2022/4/5
 * Time: 上午12:53
 */

namespace app\dealer\controller\app\logistics;
use app\Request;
use think\Controller;
use think\Db;
use app\common\JsonService;
use think\db\Where;

class DCManage extends Controller
{
    protected $dealer_id;
    public function initialize(){
        $userInfo=Request::userInfo();
        $this->dealer_id=array_key_exists('dealer_id',$userInfo)?$userInfo['dealer_id']:$userInfo['id'];
    }
    //生成入库单号
    public function createDcCode(Request $request){
        $code='DC'.date('Ymd') . substr(implode('', array_map('ord', str_split(substr(uniqid(), 7, 13), 1))), 0, 8);
        return JsonService::returnData(200,'单号生成成功',$code);
    }
    public function saveDcOrder(Request $request){
        $data=$request->post();
        //订单数量
        $order_num=0;
        $transfer_num=0;
        $data['create_by']=$request->userInfo()['account'];
        foreach ($data['dc_products'] as $key=>$value){
            $order_num+=(int)$value['order_num'];
            $transfer_num+=$value['dc_num'];
        }
        $data['order_num']=$order_num;
        $data['transfer_num']=$transfer_num;
        $data['dc_products']=json_encode($data['dc_products']);
        if(array_key_exists('id',$data)){
            $res=Db::name('dealer_logistics_dc_order')->update($data);
        }else{
            $data['dealer_id']=$this->dealer_id;
            $res=Db::name('dealer_logistics_dc_order')->insert($data);
        }
        if($res||$res==0){
            return JsonService::successful('保存成功');
        }else{
            return JsonService::fail('请联系管理员');
        }
    }
    public function getDcOrderList(Request $request){
        $params=$request->get();
        if($params['startTime']){
            $condition['careta_time']=['between time',[$params['startTime'],$params['endTime']]];
        }
        $condition['dc_order']=['like','%'.$params['order'].'%'];
        $list=Db::name('dealer_logistics_dc_order')
            ->where(new Where($condition))
            ->where('dealer_id',$this->dealer_id)
            ->where('in_warehouse_id',$params['in_warehouse_id']?:'not null')
            ->where('out_warehouse_id',$params['out_warehouse_id']?:'not null')
            ->where('status',$params['status']?:'not null')
            ->where('is_del',0)
            ->page($params['pageNum'])
            ->limit($params['pageSize'])
            ->order('create_time','desc')
            ->select();
        $total=Db::name('dealer_logistics_dc_order')
            ->where(new Where($condition))
            ->where('dealer_id',$this->dealer_id)
            ->where('in_warehouse_id',$params['in_warehouse_id']?:'not null')
            ->where('out_warehouse_id',$params['out_warehouse_id']?:'not null')
            ->where('status',$params['status']?:'not null')
            ->where('is_del',0)
            ->count();
        $res=[
            'code'=>200,
            'msg'=>'查询成功',
            'data'=>$list,
            'total'=>$total
        ];
        return json($res);
    }
    public function getDcOrderInfo(Request $request){
        $id=$request->param('id');
        $info=Db::name('dealer_logistics_dc_order')
            ->where('id',$id)
            ->find();
        $info['printData']=json_decode($info['dc_products'],true);
        return JsonService::successful('查询成功',$info);
    }
    public function deleDcOrder(Request $request){
        $params=$request->get();
        $res=Db::name('dealer_logistics_dc_order')
            ->where('dc_order',$params['dc_order'])
            ->update([
                'is_del'=>1
            ]);
        if($res){
            return JsonService::successful('删除成功');
        }else{
            return JsonService::fail('请联系管理员');
        }
    }
}