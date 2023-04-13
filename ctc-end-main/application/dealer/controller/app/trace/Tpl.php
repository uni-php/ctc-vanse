<?php
/**
 * Created by PhpStorm.
 * User: wenhan
 * Date: 2022/1/11
 * Time: 下午10:25
 */

namespace app\dealer\controller\app\trace;
use app\Request;
use think\Controller;
use think\Db;
use app\common\JsonService;
use think\db\Where;

class Tpl extends Controller
{
    protected $dealer_id;
    public function initialize(){
        $userInfo=Request::userInfo();
        $this->dealer_id=array_key_exists('dealer_id',$userInfo)?$userInfo['dealer_id']:$userInfo['id'];
    }
    public function getTplList(Request $request){
        $params=$request->get();
        if($params['startTime']){
            $condition['create_time']=['between time',[$params['startTime'],$params['endTime']]];
        }
        $condition['template_name']=['like','%'.$params['template_name'].'%'];
        try{
            Db::execute("SET @@sql_mode='';");
        }catch (\Exception $e){

        }
        $list=Db::name('dealer_trace_template')
            ->alias('a')
            ->leftJoin('dealer_trace_product_batch b','a.id=b.template_id')
            ->leftJoin('dealer_product c','b.product_id=c.id')
            ->where(new Where($condition))
            ->where('a.dealer_id',$this->dealer_id)
            ->where('a.status',0)
            ->page($params['pageNum'])
            ->limit($params['pageSize'])
            ->field('a.*,c.product_name,c.code,b.product_batch,count(b.product_batch) as num')
            ->order('a.create_time','desc')
            ->group('a.id')
            ->select();
        foreach ($list as $key=>$value){
            $list[$key]['activity_img']=json_decode($value['activity_img'],true);
            $list[$key]['banner_img']=json_decode($value['banner_img'],true);
        }
        $total=Db::name('dealer_trace_template')
            ->where(new Where($condition))
            ->where('dealer_id',$this->dealer_id)
            ->where('status',0)
            ->count();
        $res=[
            'code'=>200,
            'msg'=>'查询成功',
            'total'=>$total,
            'data'=>$list,
        ];
        return json($res);
    }
    public function saveTraceTpl(Request $request){
        $data=$request->post();
        $data['dealer_id']=$this->dealer_id;
        $data['activity_img']=json_encode($data['activity_img']);
        $data['tab']=json_encode($data['tab']);
        $data['banner_img']=json_encode($data['banner_img']);
        //生成唯一模板编号
        if(!array_key_exists('template_code',$data)){
            $data['template_code']=date('Ymd') . time();
        }
        if(array_key_exists('id',$data)){
            $res=Db::name('dealer_trace_template')->update($data);
        }else{
            $res=Db::name('dealer_trace_template')->insert($data);
        }
        if($res||$res==0){
            return JsonService::successful('保存成功');
        }else{
            return JsonService::fail('请联系管理员');
        }
    }
    public function getTplInfo(Request $request){
        $id=$request->param('id');
        $res=Db::name('dealer_trace_template')
            ->where('id',$id)
            ->find();
        $res['tab']=json_decode($res['tab'],true);
        $res['banner_img']=json_decode($res['banner_img'],true);
        $res['activity_img']=json_decode($res['activity_img'],true);
        return JsonService::successful('查询成功',$res);  
    }
    public function deleTpl(Request $request){
        $id=$request->param('id');
        $res=Db::name('dealer_trace_template')->where('id',$id)->update([
            'status'=>1
        ]);
        if($res){
            return JsonService::successful('删除成功');
        }else{
            return JsonService::fail('请联系管理员');
        }
    }
}