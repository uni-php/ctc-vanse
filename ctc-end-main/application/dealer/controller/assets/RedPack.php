<?php
/**
 * Created by PhpStorm.
 * User: wenhan
 * Date: 2021/12/8
 * Time: 上午12:23
 */

namespace app\dealer\controller\assets;
use app\Request;
use think\Controller;
use think\Db;
use think\db\Where;

class RedPack extends Controller
{
    protected $dealer_id;
    public function initialize(){
        $userInfo=Request::userInfo();
        $this->dealer_id=array_key_exists('dealer_id',$userInfo)?$userInfo['dealer_id']:$userInfo['id'];
    }
    public function getRedPackList(Request $request){
        $params=$request->get();
        $list=Db::name('dealer_redpack')
            ->where('issuer|id|instructions|remark','like','%'.$params['keywords'].'%')
            ->where('status','like','%'.$params['status'].'%')
            ->where('type','like','%'.$params['type'].'%')
            ->where('dealer_id',$this->dealer_id)
            ->order('create_time','desc')
            ->where('is_random','like','%'.$params['moneyType'].'%')
            ->page($params['pageNum'])
            ->limit($params['pageSize'])
            ->select();
        $total=Db::name('dealer_redpack')
            ->where('issuer|id|instructions|remark','like','%'.$params['keywords'].'%')
            ->where('status','like','%'.$params['status'].'%')
            ->where('dealer_id',$this->dealer_id)
            ->where('type','like','%'.$params['type'].'%')
            ->where('is_random','like','%'.$params['moneyType'].'%')
            ->count();
        $res=[
            'code'=>200,
            'msg'=>'查询成功',
            'data'=>$list,
            'total'=>$total
        ];
        return json($res);
    }
    public function queryRedPackInfo(Request $request)
    {
        $res=Db::name('dealer_redpack')
        ->where('id',$request->param('id'))
        ->find();
        $info=[
            'code'=>200,
            'data'=>$res,
            'msg'=>'查询成功'
        ];
        return json($info);
    }
    public function addRedPack(Request $request){
        $data=$request->post();
        $data['create_by']=$request->userInfo()['account'];
        if(array_key_exists('id',$data)){
            $res=Db::name('dealer_redpack')->update($data);
        }else{
            $data['dealer_id']=$this->dealer_id;
            $res=Db::name('dealer_redpack')->insert($data);
        }
        if($res||$res==0){
            $info=[
                'code'=>200,
                'msg'=>'保存成功'
            ];
        }else{
            $info=[
                'code'=>201,
                'msg'=>'系统异常'
            ];
        }
        return json($info);
    }
    public function setRedPackStatus(Request $request){
        $data=$request->get();
        $res=Db::name('dealer_redpack')
            ->where('id',$data['id'])
            ->update([
                'status'=>$data['status']*-1+1
            ]);
        if($res){
            $info=[
                'code'=>200,
                'msg'=>'设置成功'
            ];
        }else{
            $info=[
                'code'=>201,
                'msg'=>'系统异常'
            ];
        }
        return json($info);
    }

    /**
     * @param Request $request
     * 红包池信息
     */
    public function getRedpackPoolInfo(Request $request){
        //累计充值金额
        $recharge_sum=Db::name('redpool_recharge_record')
            ->where('dealer_id',$this->dealer_id)
            ->sum('money');
        //代发红包池余额
        $balance=Db::name('dealer')
            ->where('id',$this->dealer_id)
            ->value('behalf_balance');
        //已发放金额
        $grant=bcsub($recharge_sum,$balance,2);
        $info=[
            'code'=>200,
            'data'=>[
                'recharge_sum'=>$recharge_sum,
                'balance'=>$balance,
                'grant'=>$grant
            ]
        ];
        return json($info);
    }

    /**
     * @param Request $request
     * 红包发放历史
     */
    public function getRedpackGrantList(Request $request){
        $params=$request->get();
        if($params['startTime']){
            $data=Db::name('redpool_issue_record')
                ->where('dealer_id',$this->dealer_id)
                ->where('openid','like','%'.$params['openid'].'%')
                ->where('redpack_id',$params['redpack_id']?$params['redpack_id']:'not null')
                ->where('activity_id',$params['activity_id']?$params['activity_id']:'not null')
                ->where('scene',$params['scene']?$params['scene']:'not null')
                ->where('create_time', 'between time', [$params['startTime'],$params['endTime']])
                ->page($params['pageNum'])
                ->limit($params['pageSize'])
                ->order('create_time','desc')
                ->select();
            $total=Db::name('redpool_issue_record')
                ->where('dealer_id',$this->dealer_id)
                ->where('openid','like','%'.$params['openid'].'%')
                ->where('redpack_id',$params['redpack_id']?$params['redpack_id']:'not null')
                ->where('activity_id',$params['activity_id']?$params['activity_id']:'not null')
                ->where('scene',$params['scene']?$params['scene']:'not null')
                ->where('create_time', 'between time', [$params['startTime'],$params['endTime']])
                ->count();
        }else{
            $data=Db::name('redpool_issue_record')
                ->where('dealer_id',$this->dealer_id)
                ->where('openid','like','%'.$params['openid'].'%')
                ->where('redpack_id',$params['redpack_id']?$params['redpack_id']:'not null')
                ->where('activity_id',$params['activity_id']?$params['activity_id']:'not null')
                ->where('scene',$params['scene']?$params['scene']:'not null')
                ->page($params['pageNum'])
                ->order('create_time','desc')
                ->limit($params['pageSize'])
                ->select();
            $total=Db::name('redpool_issue_record')
                ->where('dealer_id',$this->dealer_id)
                ->where('openid','like','%'.$params['openid'].'%')
                ->where('redpack_id',$params['redpack_id']?$params['redpack_id']:'not null')
                ->where('activity_id',$params['activity_id']?$params['activity_id']:'not null')
                ->where('scene',$params['scene']?$params['scene']:'not null')
                ->count();
        }
        $info=[
            'code'=>200,
            'msg'=>'查询成功',
            'data'=>$data,
            'total'=>$total
        ];
        return json($info);
    }

    /**
     * @param Request $request
     * 红包发放明细 包括失败的
     */
    public function getRedpackGrantBill(Request $request){
        $params=$request->get();
        if($params['startTime']){
            $condition['a.create_time']=['between time',[$params['startTime'],$params['endTime']]];
        }
        $condition['a.redpack_id']=['like','%'.$params['redpack_id'].'%'];
        $condition['a.redpack_type']=['like','%'.$params['redpack_type'].'%'];
        $condition['a.app_id']=['like','%'.$params['app_id'].'%'];
        $condition['a.remark']=['like','%'.$params['remark'].'%'];
        $condition['a.mch_billno']=['like','%'.$params['billno'].'%'];
        $condition['a.status']=['like','%'.$params['status'].'%'];
        $condition['a.role']=['like','%'.$params['role'].'%'];
        if($params['type']==1&&$params['keywords']){
            $condition['b.id']=['=',$params['keywords']];
        }
        if($params['type']==2&&$params['keywords']){
            $condition['b.phone']=['=',$params['keywords']];
        }
        if($params['type']==3&&$params['keywords']){
            $condition['b.openid']=['=',$params['keywords']];
        }
        $list=Db::name('dealer_redpack_bill')
            ->alias('a')
            ->join('dealer_member b','a.openid=b.openid')
            ->where(new Where($condition))
            ->where('a.dealer_id',$this->dealer_id)
            ->page($params['pageNum'])
            ->limit($params['pageSize'])
            ->field('a.*')
            ->order('a.create_time','desc')
            ->select();
        $total=Db::name('dealer_redpack_bill')
            ->alias('a')
            ->join('dealer_member b','a.openid=b.openid')
            ->where(new Where($condition))
            ->where('a.dealer_id',$this->dealer_id)
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