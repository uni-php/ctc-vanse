<?php
/**
 * Created by PhpStorm.
 * Role: wenhan
 * Date: 2021/10/11
 * Time: 上午7:28
 */

namespace app\main\controller;
use think\Controller;
use think\Db;
use app\Request;
use think\facade\Hook;

class Demand extends Controller
{
    public function getAllModule(Request $request){
        $list=Db::name('product_module')
            ->select();
        $res=[
            'code'=>200,
            'msg'=>'查询成功',
            'data'=>$list,
        ];
        return json($res);
    }
    public function getDemands(Request $request){
        $params=$request->get();
        if($params['beginTime']){
            $list=Db::name('demand')
                ->alias('a')
                ->join('product_module b','a.module_id=b.id')
                ->join('partner c','a.partner_id=c.id')
                ->join('dealer d','a.dealer_id=d.id')
                ->where('a.title','like','%'.$params['title'].'%')
                ->where('a.priority','like','%'.$params['priority'].'%')
                ->where('a.module_id','like','%'.$params['module'].'%')
                ->where('a.status','like','%'.$params['status'].'%')
                ->where('c.company','like','%'.$params['company'].'%')
                ->where('a.create_time', 'between time', [$params['beginTime'],$params['endTime']])
                ->where('d.dealer_name','like','%'.$params['dealer_name'].'%')
                ->field('a.*,b.module_name,c.company,d.dealer_name')
                ->page($params['pageNum'])
                ->limit($params['pageSize'])
                ->select();
            $total=Db::name('demand')
                ->alias('a')
                ->join('product_module b','a.module_id=b.id')
                ->join('partner c','a.partner_id=c.id')
                ->join('dealer d','a.dealer_id=d.id')
                ->where('a.title','like','%'.$params['title'].'%')
                ->where('a.priority','like','%'.$params['priority'].'%')
                ->where('a.module_id','like','%'.$params['module'].'%')
                ->where('a.status','like','%'.$params['status'].'%')
                ->where('a.create_time', 'between time', [$params['beginTime'],$params['endTime']])
                ->where('c.company','like','%'.$params['company'].'%')
                ->where('d.dealer_name','like','%'.$params['dealer_name'].'%')
                ->count();

        }else{
            $list=Db::name('demand')
                ->alias('a')
                ->join('product_module b','a.module_id=b.id')
                ->join('partner c','a.partner_id=c.id')
                ->join('dealer d','a.dealer_id=d.id')
                ->where('a.title','like','%'.$params['title'].'%')
                ->where('a.priority','like','%'.$params['priority'].'%')
                ->where('a.module_id','like','%'.$params['module'].'%')
                ->where('a.status','like','%'.$params['status'].'%')
                ->where('c.company','like','%'.$params['company'].'%')
                ->where('d.dealer_name','like','%'.$params['dealer_name'].'%')
                ->field('a.*,b.module_name,c.company,d.dealer_name')
                ->page($params['pageNum'])
                ->limit($params['pageSize'])
                ->select();
            $total=Db::name('demand')
                ->alias('a')
                ->join('product_module b','a.module_id=b.id')
                ->join('partner c','a.partner_id=c.id')
                ->join('dealer d','a.dealer_id=d.id')
                ->where('a.title','like','%'.$params['title'].'%')
                ->where('a.priority','like','%'.$params['priority'].'%')
                ->where('a.module_id','like','%'.$params['module'].'%')
                ->where('a.status','like','%'.$params['status'].'%')
                ->where('c.company','like','%'.$params['company'].'%')
                ->where('d.dealer_name','like','%'.$params['dealer_name'].'%')
                ->count();
        }
        $info=[
            'code'=>200,
            'msg'=>'查询成功',
            'data'=>$list,
            'total'=>$total
        ];
        return json($info);
    }
    public function checkDemand(Request $request){
        $data=$request->get();
        $address = $request->address();
        $res=Db::name('demand')
            ->update($data);
        if($res||$res==0){
            $log=[
                'module_name'=>'需求管理',
                'operator'=>$request->userInfo()['account'],
                'ip'=>$request->ip(),
                'address'=>$address[2].$address[3],
                'operate_type'=>'2',
                'operate_event'=>'审核需求'
            ];
            Hook::listen('op_log',$log);
            $info=[
                'code'=>200,
                'msg'=>'操作成功',
            ];
        }else{
            $info=[
                'code'=>201,
                'msg'=>'系统异常',
            ];
        }
        return json($info);
    }
}