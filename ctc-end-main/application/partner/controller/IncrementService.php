<?php
/**
 * Created by PhpStorm.
 * Role: wenhan
 * Date: 2021/10/25
 * Time: 下午6:59
 */

namespace app\partner\controller;
use think\Controller;
use think\Db;
use app\Request;

class IncrementService extends Controller
{
    public function getList(Request $request){
        $partner_id=$request->userInfo()['id'];//合伙人id
        $main_ser=Db::name('increment_service')
            ->where('status',0)
            ->select();
        $partner_ser=Db::name('partner_increment_service')
            ->where('partner_id',$partner_id)
            ->select();
        foreach ($main_ser as $key=>$value){
            foreach ($partner_ser as $k=>$val){
                if($value['id']==$val['service_id']){
                    $main_ser[$key]['cost_price']=$val['cost_price'];
                    $main_ser[$key]['retail_price']=$val['retail_price'];
                }
            }
        }
        $res=[
            'code'=>200,
            'msg'=>'查询成功',
            'data'=>$main_ser
        ];
        return json($res);
    }
    public function saveServide(Request $request){
        $partner_id=$request->userInfo()['id'];//合伙人id
        $arr=json_decode($request->param('arr'),true);
        foreach ($arr as $key=>$value){
            $has=Db::name('partner_increment_service')
                ->where('partner_id',$partner_id)
                ->where('service_id',$value['id'])
                ->find();
            if($has){
                $res=Db::name('partner_increment_service')
                    ->where('partner_id',$partner_id)
                    ->where('service_id',$value['id'])
                    ->update([
                       'cost_price'=>$value['cost_price'],
                       'retail_price'=>$value['retail_price']
                    ]);
            }else{
                $res=Db::name('partner_increment_service')
                    ->insert([
                       'partner_id'=>$partner_id,
                       'service_id'=>$value['id'],
                       'cost_price'=>$value['cost_price'],
                       'retail_price'=>$value['retail_price']
                    ]);
            }
        }
        $res=[
            'code'=>200,
            'msg'=>'更新成功',
        ];
        return json($res);
    }
    public function getServiceOrder(Request $request){
        $params=$request->get();
        $partner_id=$request->userInfo()['id'];//合伙人id
        $list=Db::name('increment_service_order')
            ->alias('a')
            ->join('dealer b','a.dealer_id=b.id')
            ->where('a.order_num','like','%'.$params['order_num'].'%')
            ->where('b.dealer_name','like','%'.$params['dealer_name'].'%')
            ->where('a.status','like','%'.$params['status'].'%')
            ->where('a.partner_id',$partner_id)
            ->where('a.is_del',0)
            ->field('a.*,b.dealer_name,b.account')
            ->page($params['pageNum'])
            ->order('create_time','desc')
            ->limit($params['pageSize'])
            ->select();
        $total=Db::name('increment_service_order')
            ->alias('a')
            ->join('dealer b','a.dealer_id=b.id')
            ->where('a.order_num','like','%'.$params['order_num'].'%')
            ->where('b.dealer_name','like','%'.$params['dealer_name'].'%')
            ->where('a.status','like','%'.$params['status'].'%')
            ->where('a.partner_id',$partner_id)
            ->where('a.is_del',0)
            ->count();
        $res=[
            'code'=>200,
            'msg'=>'查询成功',
            'data'=>$list,
            'total'=>$total
        ];
        return json($res);
    }
    public function orderInfo(Request $request){
        $id=$request->param('id');
        $order=Db::name('increment_service_order')
            ->where('id',$id)
            ->find();
        $all_server=Db::name('increment_service')
            ->select();
        $ser_ids=explode(',',$order['increment_service_id']);
        foreach ($ser_ids as $key=>$value){
            foreach ($all_server as $k=>$val){
                if($value==$val['id']){
                    $all_server[$k]['is_select']=1;
                    $all_server[$k]['times']=$order['train_times'];
                }
            }
        }
        $data=[
            'code'=>200,
            'data'=>$all_server,
            'msg'=>'查询成功',
            'demand'=>$order['customized_des'],
            'is_customized'=>$order['is_customized']
        ];
        return json($data);
    }
    public function orderDes(Request $request){
        $id=$request->param('order_id');
        $order=Db::name('increment_service_order')
            ->where('id',$id)
            ->find();
        $info=[
          'data'=>$order,
          'code'=>200,
          'msg'=>'查询成功'
        ];
        return json($info);
    }
}