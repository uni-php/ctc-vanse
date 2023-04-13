<?php
/**
 * Created by PhpStorm.
 * User: wenhan
 * Date: 2022/11/15
 * Time: 下午5:42
 */

namespace app\dealer\controller\app\guide;
use app\Request;
use think\Controller;
use think\Db;
use app\common\JsonService;
use think\db\Where;

class Activity extends Controller
{
    protected $dealer_id;
    public function initialize(){
        $userInfo=Request::userInfo();
        $this->dealer_id=array_key_exists('dealer_id',$userInfo)?$userInfo['dealer_id']:$userInfo['id'];
    }
    public function saveActivity(Request $request){
        $data=$request->post();
        $data['code_batch_data']=json_encode($data['code_batch_data']);
        $data['prize_data']=json_encode($data['prize_data']);
        $data['user_info_field']=json_encode($data['user_info_field']);
        $data['guide_gruop']=json_encode($data['guide_gruop']);
        $data['dealer_id']=$this->dealer_id;
        $data['create_by']=Request::userInfo()['account'];
        if(array_key_exists('id',$data)){
            $res=Db::name('dealer_guide_activity')->strict(false)->update($data);
        }else{
            $res=Db::name('dealer_guide_activity')->strict(false)->insert($data);
        }
        if($res||$res==0){
            return JsonService::successful('保存成功');
        }else{
            return JsonService::fail('请联系管理员');
        }
    }
    public function getActivityList(Request $request){
        $params=$request->get();
        $list=Db::name('dealer_guide_activity')
            ->where('dealer_id',$this->dealer_id)
            ->where('code_batch_data','like','%'.$params['code_batch'].'%')
            ->where('activity_name|id|remark','like','%'.$params['keywords'].'%')
            ->where('status','<>',3)
            ->page($params['pageNum'])
            ->limit($params['pageSize'])
            ->select();
        $total=Db::name('dealer_guide_activity')
            ->where('dealer_id',$this->dealer_id)
            ->where('code_batch_data','like','%'.$params['code_batch'].'%')
            ->where('activity_name|id|remark','like','%'.$params['keywords'].'%')
            ->where('status','<>',3)
            ->count();
        $res=[
            'code'=>200,
            'msg'=>'查询成功',
            'total'=>$total,
            'data'=>$list,
        ];
        return json($res);
    }
    public function setActivityStatus(Request $request){
        $params=$request->get();
        $res=Db::name('dealer_guide_activity')
            ->where('dealer_id',$this->dealer_id)
            ->where('id',$params['id'])
            ->update([
                'status'=>$params['status']*-1+1
            ]);
        if($res){
            JsonService::successful($params['status']==0?'启用成功':'禁用成功');
        }else{
            JsonService::fail('请联系管理员');
        }
    }
    public function deleActivity(Request $request){
        $params=$request->get();
        $res=Db::name('dealer_guide_activity')
            ->where('dealer_id',$this->dealer_id)
            ->where('id',$params['id'])
            ->update([
                'status'=>3
            ]);
        if($res){
            JsonService::successful('删除成功');
        }else{
            JsonService::fail('请联系管理员');
        }
    }
    public function getActivityInfo(Request $request){
        $id=$request->param('id');
        $res=Db::name('dealer_guide_activity')
            ->where('id',$id)
            ->find();
        $res['code_batch_data']=json_decode($res['code_batch_data'],true);
        $res['user_info_field']=json_decode($res['user_info_field'],true);
        $res['guide_gruop']=json_decode($res['guide_gruop'],true);
        $res['prize_data']=json_decode($res['prize_data'],true);
        return JsonService::successful('查询成功',$res);
    }
}