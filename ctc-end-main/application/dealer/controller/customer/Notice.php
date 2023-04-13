<?php
/**
 * Created by PhpStorm.
 * User: wenhan
 * Date: 2021/12/28
 * Time: 下午10:37
 */

namespace app\dealer\controller\customer;
use app\Request;
use think\Controller;
use think\Db;
use think\db\Where;
use app\common\JsonService;

class Notice extends Controller
{
    protected $dealer_id;
    public function initialize(){
        $userInfo=Request::userInfo();
        $this->dealer_id=array_key_exists('dealer_id',$userInfo)?$userInfo['dealer_id']:$userInfo['id'];
    }
    public function getNoticeList(Request $request){
        $params=$request->get();
        $condition=[];
        if($params['startTime']){
            $condition['create_time']=['between time',[$params['startTime'],$params['endTime']]];
        }
        $condition['title']=['like','%'.$params['title'].'%'];
        $list=Db::name('dealer_customer_notice')
            ->where(new Where($condition))
            ->where('dealer_id',$this->dealer_id)
            ->order('create_time','desc')
            ->page($params['pageNum'])
            ->limit($params['pageSize'])
            ->select();
        $total=Db::name('dealer_customer_notice')
            ->where(new Where($condition))
            ->where('dealer_id',$this->dealer_id)
            ->count();
        $res=[
            'code'=>200,
            'msg'=>'查询成功',
            'data'=>$list,
            'total'=>$total
        ];
        return json($res);

    }
    public function saveNotice(Request $request){
        $data=$request->post();
        $data['dealer_id']=$this->dealer_id;
        if(array_key_exists('id',$data)){
            $res=Db::name('dealer_customer_notice')->update($data);
        }else{
            $res=Db::name('dealer_customer_notice')->insert($data);
        }
        if($res||$res==0){
            return JsonService::successful('保存成功');
        }else{
            return JsonService::fail('请联系管理员');
        }
    }
    public function deleNotice(Request $request){
        $id=$request->param('id');
        $res=Db::name('dealer_customer_notice')->delete($id);
        if($res){
            return JsonService::successful('删除成功');
        }else{
            return JsonService::fail('请联系管理员');
        }
    }
    public function queryNoticeInfo(Request $request){
        $id=$request->param('id');
        $res=Db::name('dealer_customer_notice')
            ->where('id',$id)
            ->find();
        return JsonService::successful('查询成功',$res);
    }
}