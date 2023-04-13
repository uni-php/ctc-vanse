<?php
/**
 * Created by PhpStorm.
 * User: wenhan
 * Date: 2022/11/15
 * Time: 下午9:22
 */

namespace app\dealer\controller\app\guide;
use app\Request;
use think\Controller;
use think\Db;
use app\common\JsonService;
use think\db\Where;

class ScanBill extends Controller
{
    protected $dealer_id;
    public function initialize(){
        $userInfo=Request::userInfo();
        $this->dealer_id=array_key_exists('dealer_id',$userInfo)?$userInfo['dealer_id']:$userInfo['id'];
    }
    /**
     * @param Request $request
     * 扫码明细
     */
    public function getScanBill(Request $request){
        $params=$request->get();
        try {
            Db::execute("SET @@sql_mode='';");
        } catch (\Exception $e) {
        }
        if($params['startTime']){
            $condition['a.create_time']=['between time',[$params['startTime'],$params['endTime']]];
        }
        if($params['phone']){
            $condition['b.phone']=['like','%'.$params['phone'].'%'];
        }
        $condition['a.batch']=['like','%'.$params['code_batch'].'%'];
        $condition['a.ip']=['like','%'.$params['ip'].'%'];
        $condition['a.code']=['like','%'.$params['code'].'%'];
        $condition['b.name']=['like','%'.$params['name'].'%'];
        $condition['a.openid']=['like','%'.$params['openid'].'%'];
        $list=Db::name('dealer_guide_query_bill')
            ->alias('a')
            ->join('dealer_guide b','a.openid=b.openid')
            ->join('dealer_member c','a.openid=c.openid')
            ->where(new Where($condition))
            ->where('a.dealer_id',$this->dealer_id)
            ->where('a.is_first',$params['res_status']?:'not null')
            ->where('b.group_id',$params['group']?:'not null')
            ->page($params['pageNum'])
            ->limit($params['pageSize'])
            ->group('a.id')
            ->field('a.*,c.id as uid,b.name,c.headimgurl')
            ->order('a.create_time','desc')
            ->select();
        $total=Db::name('dealer_guide_query_bill')
            ->alias('a')
            ->join('dealer_guide b','a.openid=b.openid')
            ->where(new Where($condition))
            ->where('a.dealer_id',$this->dealer_id)
            ->where('a.is_first',$params['res_status']?:'not null')
            ->where('b.group_id',$params['group']?:'not null')
            ->group('a.id')
            ->count();
        $res=[
            'code'=>200,
            'msg'=>'查询成功',
            'data'=>$list,
            'total'=>$total
        ];
        return json($res);
    }
    public function getPrizeLog(Request $request){
        $params=$request->get();
        if($params['startTime']){
            $condition['a.create_time']=['between time',[$params['startTime'],$params['endTime']]];
        }
        $condition['a.batch']=['like','%'.$params['code_batch'].'%'];
        $condition['a.code']=['like','%'.$params['code'].'%'];
        $condition['d.name']=['like','%'.$params['name'].'%'];
        $condition['a.openid']=['like','%'.$params['openid'].'%'];
        $condition['d.phone']=['like','%'.$params['phone'].'%'];
        $condition['c.activity_name']=['like','%'.$params['activity_name'].'%'];
        $list=Db::name('dealer_guide_prize_bill')
            ->alias('a')
            ->join('dealer_member b','a.openid=b.openid')
            ->join('dealer_guide_activity c','a.activity_id=c.id')
            ->join('dealer_guide d','a.openid=d.openid')
            ->where(new Where($condition))
            ->where('a.dealer_id',$this->dealer_id)
            ->where('d.group_id',$params['group']?:'not null')
            ->page($params['pageNum'])
            ->limit($params['pageSize'])
            ->field('a.*,b.id as uid,d.name,b.headimgurl,c.activity_name')
            ->order('a.create_time','desc')
            ->select();
        foreach ($list as $key =>$value){
            $list[$key]['user_info_field']=json_decode($value['user_info_field'],true);
        }
        $total=Db::name('dealer_guide_prize_bill')
            ->alias('a')
            ->join('dealer_member b','a.openid=b.openid and a.dealer_id=b.dealer_id')
            ->join('dealer_guide d','b.openid=d.openid and a.dealer_id=d.dealer_id')
            ->join('dealer_guide_activity c','a.activity_id=c.id')
            ->where(new Where($condition))
            ->where('a.dealer_id',$this->dealer_id)
            ->where('d.group_id',$params['group']?:'not null')
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