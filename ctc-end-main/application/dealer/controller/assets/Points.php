<?php
/**
 * Created by PhpStorm.
 * User: wenhan
 * Date: 2021/12/9
 * Time: 上午11:02
 */

namespace app\dealer\controller\assets;
use app\Request;
use think\Controller;
use think\Db;
use app\common\JsonService;

class Points extends Controller
{
    protected $dealer_id;
    public function initialize(){
        $userInfo=Request::userInfo();
        $this->dealer_id=array_key_exists('dealer_id',$userInfo)?$userInfo['dealer_id']:$userInfo['id'];
    }
    public function getPointsSetInfo(Request $request)
    {
        $info=Db::name('dealer_points_set')
            ->where('dealer_id',$this->dealer_id)
            ->find();
        $res=[
            'code'=>200,
            'msg'=>'查询成功',
            'data'=>$info
        ];
        return json($res);
    }
    public function savePointsSet(Request $request){
        $data=$request->post();
        if($data['id']){
            $res=Db::name('dealer_points_set')->update($data);
        }else{
            $data['dealer_id']=$this->dealer_id;
            $res=Db::name('dealer_points_set')->insert($data);
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
    public function getPointsBill(Request $request){
        $params=$request->get();
        if($params['startTime']){
            $list=Db::name('dealer_member_bill')
                ->alias('a')
                ->join('ctc_dealer_member b','a.member_id=b.id')
                ->where('a.create_time', 'between time', [$params['startTime'],$params['endTime']])
                ->where('a.role',$params['role']?$params['role']:'not null')
                ->where('a.distributor_id',$params['distributor_id']?$params['distributor_id']:'not null')
                ->where('a.pm',$params['attribute']?$params['attribute']:'not null')
                ->where('a.app_id',$params['app_id']?$params['app_id']:'not null')
                ->where('a.remark','like','%'.$params['remark'].'%')
                ->where('a.dealer_id',$this->dealer_id)
                ->where('a.type',3)
                ->where('a.member_id',$params['type']==1?($params['keywords']?$params['keywords']:'not null'):'not null')
                ->where('b.phone',$params['type']==2?($params['keywords']?$params['keywords']:'not null'):'not null')
                ->where('b.openid',$params['type']==3?($params['keywords']?$params['keywords']:'not null'):'not null')
                ->field('a.*,b.headimgurl,b.openid,b.nickname,b.username,b.phone,b.status')
                ->page($params['pageNum'])
                ->limit($params['pageSize'])
                ->select();
            $total=Db::name('dealer_member_bill')
                ->alias('a')
                ->join('ctc_dealer_member b','a.member_id=b.id')
                ->where('a.create_time', 'between time', [$params['startTime'],$params['endTime']])
                ->where('a.role',$params['role']?$params['role']:'not null')
                ->where('a.distributor_id',$params['distributor_id']?$params['distributor_id']:'not null')
                ->where('a.pm',$params['attribute']?$params['attribute']:'not null')
                ->where('a.app_id',$params['app_id']?$params['app_id']:'not null')
                ->where('a.remark','like','%'.$params['remark'].'%')
                ->where('a.dealer_id',$this->dealer_id)
                ->where('a.type',3)
                ->where('a.member_id',$params['type']==1?($params['keywords']?$params['keywords']:'not null'):'not null')
                ->where('b.phone',$params['type']==2?($params['keywords']?$params['keywords']:'not null'):'not null')
                ->where('b.openid',$params['type']==3?($params['keywords']?$params['keywords']:'not null'):'not null')
                ->count();
        }else{
            $list=Db::name('dealer_member_bill')
                ->alias('a')
                ->join('ctc_dealer_member b','a.member_id=b.id')
                ->where('a.role',$params['role']?$params['role']:'not null')
                ->where('a.distributor_id',$params['distributor_id']?$params['distributor_id']:'not null')
                ->where('a.pm',$params['attribute']?$params['attribute']:'not null')
                ->where('a.app_id',$params['app_id']?$params['app_id']:'not null')
                ->where('a.remark','like','%'.$params['remark'].'%')
                ->where('a.dealer_id',$this->dealer_id)
                ->where('a.type',3)
                ->where('a.member_id',$params['type']==1?($params['keywords']?$params['keywords']:'not null'):'not null')
                ->where('b.phone',$params['type']==2?($params['keywords']?$params['keywords']:'not null'):'not null')
                ->where('b.openid',$params['type']==3?($params['keywords']?$params['keywords']:'not null'):'not null')
                ->field('a.*,b.headimgurl,b.openid,b.nickname,b.username,b.phone,b.status')
                ->page($params['pageNum'])
                ->limit($params['pageSize'])
                ->select();
            $total=Db::name('dealer_member_bill')
                ->alias('a')
                ->join('ctc_dealer_member b','a.member_id=b.id')
                ->where('a.role',$params['role']?$params['role']:'not null')
                ->where('a.distributor_id',$params['distributor_id']?$params['distributor_id']:'not null')
                ->where('a.pm',$params['attribute']?$params['attribute']:'not null')
                ->where('a.app_id',$params['app_id']?$params['app_id']:'not null')
                ->where('a.remark','like','%'.$params['remark'].'%')
                ->where('a.dealer_id',$this->dealer_id)
                ->where('a.type',3)
                ->where('a.member_id',$params['type']==1?($params['keywords']?$params['keywords']:'not null'):'not null')
                ->where('b.phone',$params['type']==2?($params['keywords']?$params['keywords']:'not null'):'not null')
                ->where('b.openid',$params['type']==3?($params['keywords']?$params['keywords']:'not null'):'not null')
                ->count();
        }
        $res=[
            'code'=>200,
            'msg'=>'查询成功',
            'data'=>$list,
            'total'=>$total
        ];
        return json($res);
    }
    public function blockMember(Request $request){
        Db::name('dealer_member')
            ->where('id',$request->param('id'))
            ->update([
                'status'=>1
            ]);
        return JsonService::successful('拉黑成功');
    }

    /**
     * @param Request $request
     * 查询会员信息
     */
    public function getMemberInfo(Request $request){
        $member_id=$request->param('id');
        $member_info=Db::name('dealer_member')
            ->where('id',$member_id)
            ->find();
        return JsonService::successful('查询成功',$member_info);
    }
}