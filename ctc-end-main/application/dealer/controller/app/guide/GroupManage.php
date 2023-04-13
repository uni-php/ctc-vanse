<?php
/**
 * Created by PhpStorm.
 * User: wenhan
 * Date: 2022/9/18
 * Time: 下午5:32
 */

namespace app\dealer\controller\app\guide;
use think\Db;
use app\common\JsonService;
use app\Request;
use think\Controller;

class GroupManage extends Controller
{
    protected $dealer_id;
    public function initialize(){
        $userInfo=Request::userInfo();
        $this->dealer_id=array_key_exists('dealer_id',$userInfo)?$userInfo['dealer_id']:$userInfo['id'];
    }
    public function getGuideGroupList(Request $request){
        $params=$request->get();
        $list=Db::name('dealer_guide_group')
            ->where('dealer_id',$this->dealer_id)
            ->where('is_del',0)
            ->page($params['pageNum'])
            ->limit($params['pageSize'])
            ->select();
        $total=Db::name('dealer_guide_group')
            ->where('dealer_id',$this->dealer_id)
            ->where('is_del',0)
            ->count();
        $res=[
            'code'=>200,
            'msg'=>'查询成功',
            'total'=>$total,
            'data'=>$list,
        ];
        return json($res);
    }
    public function saveGuideGroup(Request $request){
        $data=$request->post();
        $data['dealer_id']=$this->dealer_id;
        $data['rank_type']= json_encode($data['rank_type']);
        $data['prize_rank_time']= json_encode($data['prize_rank_time']);
        $data['red_rank_time']= json_encode($data['red_rank_time']);
        if(array_key_exists('id',$data)){
            $res=Db::name('dealer_guide_group')
                ->update($data);
        }else{
            $res=Db::name('dealer_guide_group')->insert($data);
        }
        if($res||$res==0){
            return JsonService::successful('保存成功');
        }else{
            return JsonService::fail('请联系管理员');
        }
    }
    public function getGuideGroupInfo(Request $request){
        $id=$request->param('id');
        $res=Db::name('dealer_guide_group')
            ->where('id',$id)
            ->find();
        $res['rank_type']=json_decode($res['rank_type'],true);
        $res['prize_rank_time']=json_decode($res['prize_rank_time'],true);
        $res['red_rank_time']=json_decode($res['red_rank_time'],true);
        return JsonService::successful('查询成功',$res);
    }
    public function deleGuideGroup(Request $request){
        $id=$request->get('id');
        $res=Db::name('dealer_guide_group')
            ->where('id',$id)
            ->where('dealer_id',$this->dealer_id)
            ->update([
               'is_del'=>1
            ]);
        if($res){
            JsonService::successful('删除成功');
        }else{
            JsonService::fail('请联系管理员');
        }
    }
}