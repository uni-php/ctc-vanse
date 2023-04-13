<?php
/**
 * Created by PhpStorm.
 * User: wenhan
 * Date: 2022/4/2
 * Time: 下午2:30
 */

namespace app\dealer\controller\app\logistics;
use app\Request;
use think\Controller;
use think\Db;
use app\common\JsonService;
use think\db\Where;

class THManage extends Controller
{
    protected $dealer_id;
    public function initialize(){
        $userInfo=Request::userInfo();
        $this->dealer_id=array_key_exists('dealer_id',$userInfo)?$userInfo['dealer_id']:$userInfo['id'];
    }
    public function getThOrderList(Request $request){
        $params=$request->get();
        if($params['startTime']){
            $condition['a.create_order_time']=['between time',[$params['startTime'],$params['endTime']]];
        }
        $condition['th_order']=['like','%'.$params['order'].'%'];
        $condition['return_products']=['like','%'.$params['product_name'].'%'];
        $condition['return_products']=['like','%'.$params['code'].'%'];
        if($params['batch']){
            $condition['product_batch']=['like','%'.$params['batch'].'%'];
        }
        $condition['customer_name']=['like','%'.$params['customer_name'].'%'];
        $list=Db::name('dealer_logistics_th_order')
            ->where(new Where($condition))
            ->where('dealer_id',$this->dealer_id)
            ->where('return_warehouse_id',$params['warehouse_id']?:'not null')
            ->where('is_fleeing_goods',$params['is_fleeing_goods']?:'not null')
            ->where('is_gift',($params['is_gift']||is_numeric($params['is_gift']))?$params['is_gift']:'not null')
            ->where('check_status',($params['check_status']||is_numeric($params['check_status']))?$params['check_status']:'not null')
            ->page($params['pageNum'])
            ->limit($params['pageSize'])
            ->order('return_time','desc')
            ->select();
        foreach ($list as $key=>$val){
            $arr=json_decode($val['return_products'],true);
            foreach ($arr as $k=>$v){
                $arr[$k]['id']=$k.$key.'product';
            }
            $list[$key]['children']=$arr;
        }
        $total=Db::name('dealer_logistics_th_order')
            ->where(new Where($condition))
            ->where('dealer_id',$this->dealer_id)
            ->where('return_warehouse_id',$params['warehouse_id']?:'not null')
            ->where('is_fleeing_goods',$params['is_fleeing_goods']?:'not null')
            ->where('is_gift',$params['is_gift']?:'not null')
            ->where('check_status',$params['check_status']?:'not null')
            ->count();
        $res=[
            'code'=>200,
            'msg'=>'查询成功',
            'data'=>$list,
            'total'=>$total
        ];
        return json($res);
    }
    public function getThOrderInfo(Request $request){
        $id=$request->param('id');
        $info=Db::name('dealer_logistics_th_order')
            ->where('id',$id)
            ->find();
        $info['printData']=json_decode($info['return_products'],true);
        return JsonService::successful('查询成功',$info);
    }
    public function saveExpressOrder(Request $request){
        $data=$request->post();
        $res=Db::name('dealer_logistics_th_order')->update($data);
        if($res||$res==0){
            return JsonService::successful('保存成功');
        }else{
            return JsonService::fail('请联系管理员');
        }
    }
    public function checkThOrder(Request $request){
        $data=$request->post();
        Db::startTrans();//开启事务
        try{
            Db::name('dealer_logistics_th_order')->update($data);
            if($data['check_status']==1){
                //更改出库表码出库状态
                $code=Db::name('dealer_logistics_th_order')
                    ->alias('a')
                    ->join('dealer_logistics_th_code b','a.th_order=b.th_order')
                    ->where('a.id',$data['id'])
                    ->where('a.dealer_id',$this->dealer_id)
                    ->column('b.code');
                foreach ($code as $key=>$value){
                    Db::name('dealer_logistics_ck_code')
                        ->where('code',$value)
                        ->where('dealer_id',$this->dealer_id)
                        ->update([
                        'is_return'=>1
                    ]);
                }
            }
            Db::commit();
            return JsonService::successful('操作成功');
        }catch (\Exception $e){
            Db::rollback();
            return JsonService::fail('请联系管理员');
        }
    }
    //删除退货单 硬删除
    public function deleThOrder(Request $request){
        $data=$request->get();
        Db::startTrans();//开启事务
        try{
            Db::name('dealer_logistics_th_order')->where('th_order',$data['th_order'])->delete();
            Db::name('dealer_logistics_th_code')->where('th_order',$data['th_order'])->delete();
            Db::commit();
            return JsonService::successful('删除成功');
        }catch (\Exception $e){
            Db::rollback();
            return JsonService::fail('请联系管理员');
        }
    }
    public function getThCodeList(Request $request){
        $params=$request->get();
        $list=Db::name('dealer_logistics_th_code')
            ->alias('a')
            ->join('dealer_product b','a.product_id=b.id')
            ->where('a.dealer_id',$this->dealer_id)
            ->where('a.th_order',$params['th_order'])
            ->field('a.*,b.product_name,b.code as product_code')
            ->page($params['pageNum'])
            ->limit($params['pageSize'])
            ->select();
        $total=Db::name('dealer_logistics_th_code')
            ->where('dealer_id',$this->dealer_id)
            ->where('th_order',$params['th_order'])
            ->count();
        $res=[
            'code'=>200,
            'msg'=>'查询成功',
            'data'=>$list,
            'total'=>$total
        ];
        return json($res);
    }
}