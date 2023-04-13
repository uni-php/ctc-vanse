<?php
/**
 * Created by PhpStorm.
 * User: wenhan
 * Date: 2022/4/3
 * Time: 下午5:46
 */

namespace app\dealer\controller\app\logistics;
use app\Request;
use think\Controller;
use think\Db;
use app\common\JsonService;
use think\db\Where;

class Statistics extends Controller
{
    protected $dealer_id;
    public function initialize(){
        $userInfo=Request::userInfo();
        $this->dealer_id=array_key_exists('dealer_id',$userInfo)?$userInfo['dealer_id']:$userInfo['id'];
    }

    /**
     * @param Request $request
     * @return \think\response\Json
     * @throws \think\db\exception\DataNotFoundException
     * @throws \think\db\exception\ModelNotFoundException
     * @throws \think\exception\DbException
     * 聚合查询统计窜货总数量
     */
    public function getChOrderList(Request $request){
        $params=$request->get();
        $condition['a.bch_distributor_name']=['like','%'.$params['customer_name'].'%'];
        try{
            Db::execute("SET @@sql_mode='';");
        }catch (\Exception $e){

        }
        $list=Db::name('dealer_logistics_ch_order')
            ->alias('a')
            ->leftJoin('dealer_distributor b','a.bch_distributor_id=b.id')
            ->where(new Where($condition))
            ->where('a.dealer_id',$this->dealer_id)
            ->where('b.distributor_level',$params['distributor_level']?$params['distributor_level']:'not null')
            ->field('a.*,b.distributor_level,sum(a.ch_num) as sum')
            ->group('a.bch_distributor_id')
            ->page($params['pageNum'])
            ->limit($params['pageSize'])
            ->order('a.create_time','desc')
            ->select();
        $total=Db::name('dealer_logistics_ch_order')
            ->alias('a')
            ->leftJoin('dealer_distributor b','a.bch_distributor_id=b.id')
            ->where(new Where($condition))
            ->where('a.dealer_id',$this->dealer_id)
            ->where('b.distributor_level',$params['distributor_level']?$params['distributor_level']:'not null')
            ->field('a.*,b.distributor_level,sum(a.ch_num) as sum')
            ->group('a.bch_distributor_id')
            ->count();
        $res=[
            'code'=>200,
            'msg'=>'查询成功',
            'data'=>$list,
            'total'=>$total
        ];
        return json($res);
    }

    /**
     * @param Request $request
     * @return \think\response\Json
     * @throws \think\db\exception\DataNotFoundException
     * @throws \think\db\exception\ModelNotFoundException
     * @throws \think\exception\DbException
     * 窜货统计明细
     */
    public function getChOrderBill(Request $request){
        $params=$request->get();
        if($params['startTime']){
            $condition['a.create_time']=['between time',[$params['startTime'],$params['endTime']]];
        }
        $condition['a.bch_distributor_name']=['like','%'.$params['bch_distributor_name'].'%'];
        $condition['a.remark']=['like','%'.$params['remark'].'%'];
        $list=Db::name('dealer_logistics_ch_order')
            ->alias('a')
            ->join('dealer_distributor b','a.bch_distributor_id=b.id')
            ->where(new Where($condition))
            ->where('a.dealer_id',$this->dealer_id)
            ->where('a.bch_distributor_id',$params['bch_distributor_id'])
            ->where('a.from_type',$params['from']?:'not null')
            ->field('a.*,b.distributor_code,b.distributor_name,b.sale_area')
            ->page($params['pageNum'])
            ->limit($params['pageSize'])
            ->order('a.create_time','desc')
            ->select();
        $total=Db::name('dealer_logistics_ch_order')
            ->alias('a')
            ->join('dealer_distributor b','a.bch_distributor_id=b.id')
            ->where(new Where($condition))
            ->where('a.dealer_id',$this->dealer_id)
            ->where('a.bch_distributor_id',$params['bch_distributor_id'])
            ->where('a.from_type',$params['from']?:'not null')
            ->count();
        $res=[
            'code'=>200,
            'msg'=>'查询成功',
            'data'=>$list,
            'total'=>$total
        ];
        return json($res);
    }

    /**
     * @param Request $request
     * 明细详情
     */
    public function getBillDes(Request $request){
        $params=$request->get();
        $baseInfo=Db::name('dealer_logistics_ck_code')
            ->where('dealer_id',$this->dealer_id)
//            ->where('ck_order',$params['ck_order'])
            ->where('order_start','<=',$params['serial_number'])
            ->where('order_end','>=',$params['serial_number'])
            ->find();
        $chInfo=Db::name('dealer_logistics_ch_order')
            ->alias('a')
            ->join('dealer_distributor b','a.bch_distributor_id=b.id')
            ->where('a.id',$params['id'])
            ->field('a.*,b.sale_area')
            ->find();
        return JsonService::successful('查询成功',['baseInfo'=>$baseInfo,'chInfo'=>$chInfo]);
    }
}