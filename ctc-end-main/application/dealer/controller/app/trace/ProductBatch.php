<?php
/**
 * Created by PhpStorm.
 * User: wenhan
 * Date: 2022/1/12
 * Time: 下午11:58
 */

namespace app\dealer\controller\app\trace;
use app\Request;
use think\Controller;
use think\Db;
use app\common\JsonService;
use think\db\Where;


class ProductBatch extends Controller
{
    protected $dealer_id;
    public function initialize(){
        $userInfo=Request::userInfo();
        $this->dealer_id=array_key_exists('dealer_id',$userInfo)?$userInfo['dealer_id']:$userInfo['id'];
    }
    public function getProductBatchList(Request $request){
        $params=$request->get();
        if($params['startTime']){
            $condition['a.create_time']=['between time',[$params['startTime'],$params['endTime']]];
        }
        $condition['a.product_batch|b.code|a.remark|b.product_name']=['like','%'.$params['keywords'].'%'];
        $condition['a.status']=0;
        $list=Db::name('dealer_trace_product_batch')
            ->alias('a')
            ->join('dealer_product b','a.product_id=b.id')
            ->join('dealer_trace_template c','a.template_id=c.id')
            ->where(new Where($condition))
            ->where('a.dealer_id',$this->dealer_id)
            ->field('a.*,b.code,b.product_name,c.template_name')
            ->page($params['pageNum'])
            ->limit($params['pageSize'])
            ->order('a.create_time','desc')
            ->select();
        $total=Db::name('dealer_trace_product_batch')
            ->alias('a')
            ->join('dealer_product b','a.product_id=b.id')
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
    public function saveProductBatch(Request $request){
        $data=$request->post();
        $data['dealer_id']=$this->dealer_id;
        $data['batch_content']=json_encode($data['batch_content']);
        if(array_key_exists('id',$data)){
            $res=Db::name('dealer_trace_product_batch')->update($data);
        }else{
            $res=Db::name('dealer_trace_product_batch')->insert($data);
        }
        if($res||$res==0){
            return JsonService::successful('保存成功');
        }else{
            return JsonService::fail('请联系管理员');
        }
    }
    public function getBatchInfo(Request $request){
        $batch=$request->param('batch');
        $res=Db::name('dealer_trace_product_batch')
            ->alias('a')
            ->join('dealer_product b','a.product_id=b.id')
            ->join('dealer_trace_template c','a.template_id=c.id')
            ->where('product_batch',$batch)
            ->field('a.*,b.product_name,c.template_name')
            ->find();
        $res['batch_content']=json_decode($res['batch_content'],true);
        return JsonService::successful('查询成功',$res);
    }
    public function deleProductBatch(Request $request){
        $id=$request->param('id');
        $res=Db::name('dealer_trace_product_batch')->where('id',$id)->update([
            'status'=>1
        ]);
        if($res){
            return JsonService::successful('删除成功');
        }else{
            return JsonService::fail('请联系管理员');
        }
    }
}