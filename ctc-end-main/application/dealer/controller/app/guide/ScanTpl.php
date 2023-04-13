<?php
/**
 * Created by PhpStorm.
 * User: wenhan
 * Date: 2022/11/15
 * Time: 下午4:11
 */

namespace app\dealer\controller\app\guide;
use app\Request;
use think\Controller;
use think\Db;
use app\common\JsonService;
use think\db\Where;

class ScanTpl extends Controller
{
    protected $dealer_id;
    public function initialize(){
        $userInfo=Request::userInfo();
        $this->dealer_id=array_key_exists('dealer_id',$userInfo)?$userInfo['dealer_id']:$userInfo['id'];
    }
    public function saveScanTpl(Request $request){
        $data=$request->post();
        $data['welcom_page']=json_encode($data['welcom_page']);
        $data['activity_page']=json_encode($data['activity_page']);
        $data['xuanchuan_page']=json_encode($data['xuanchuan_page']);
        $data['create_by']=Request::userInfo()['account'];
        $data['dealer_id']=$this->dealer_id;
        if(array_key_exists('id',$data)){
            $res=Db::name('dealer_guide_tpl')->update($data);
        }else{
            $res=Db::name('dealer_guide_tpl')->insert($data);
        }
        if($res||$res==0){
            return JsonService::successful('保存成功');
        }else{
            return JsonService::fail('请联系管理员');
        }
    }
    public function getTplList(Request $request){
        $params=$request->get();
        if($params['startTime']){
            $condition['create_time']=['between time',[$params['startTime'],$params['endTime']]];
        }
        $condition['tpl_name']=['like','%'.$params['tpl_name'].'%'];
        $list=Db::name('dealer_guide_tpl')
            ->where(new Where($condition))
            ->where('dealer_id',$this->dealer_id)
            ->page($params['pageNum'])
            ->limit($params['pageSize'])
            ->select();
        foreach ($list as $key=>$value){
            $list[$key]['welcom_page']=json_decode($value['welcom_page']);
            $list[$key]['activity_page']=json_decode($value['activity_page']);
            $list[$key]['xuanchuan_page']=json_decode($value['xuanchuan_page']);
        }
        $total=Db::name('dealer_guide_tpl')
            ->where(new Where($condition))
            ->where('dealer_id',$this->dealer_id)
            ->count();
        $res=[
            'code'=>200,
            'msg'=>'查询成功',
            'total'=>$total,
            'data'=>$list,
        ];
        return json($res);
    }
    public function getTplInfo(Request $request){
        $id=$request->param('id');
        $res=Db::name('dealer_guide_tpl')
            ->where('id',$id)
            ->find();
        $res['welcom_page']=json_decode($res['welcom_page'],true);
        $res['activity_page']=json_decode($res['activity_page'],true);
        $res['xuanchuan_page']=json_decode($res['xuanchuan_page'],true);
        return JsonService::successful('查询成功',$res);
    }
}