<?php
/**
 * Created by PhpStorm.
 * User: wenhan
 * Date: 2022/1/6
 * Time: 下午9:45
 */

namespace app\dealer\controller\customer;
namespace app\dealer\controller\customer;
use app\Request;
use think\Controller;
use think\Db;
use app\common\JsonService;
use think\db\Where;

class Salesman extends Controller
{
    protected $dealer_id;
    public function initialize(){
        $userInfo=Request::userInfo();
        $this->dealer_id=array_key_exists('dealer_id',$userInfo)?$userInfo['dealer_id']:$userInfo['id'];
    }
    public function getSalesmanTypeList(Request $request){
        $params=$request->get();
        try{
            Db::execute("SET @@sql_mode='';");
        }catch (\Exception $e){

        }
        $list=Db::name('dealer_salesman_type')
            ->alias('a')
            ->leftJoin('dealer_salesman b','a.id=b.type')
            ->where('a.dealer_id',$this->dealer_id)
            ->where('a.status',0)
            ->field('a.id,a.class_name,a.create_time,a.remark,count(b.salesman_code) as num')
            ->order('a.create_time','desc')
            ->page($params['pageNum'])
            ->limit($params['pageSize'])
            ->group('a.id')
            ->select();
        $total=Db::name('dealer_salesman_type')
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
    public function saveSalesmanType(Request $request){
        $data=$request->post();
        $data['dealer_id']=$this->dealer_id;
        if(array_key_exists('id',$data)){
            $res=Db::name('dealer_salesman_type')->update($data);
        }else{
            $res=Db::name('dealer_salesman_type')->insert($data);
        }
        if($res||$res==0){
            return JsonService::successful('保存成功');
        }else{
            return JsonService::fail('请联系管理员');
        }
    }
    public function querySalesmanTypeInfo(Request $request){
        $id=$request->param('id');
        $res=Db::name('dealer_salesman_type')->where('id',$id)->find();
        return JsonService::successful('查询成功',$res);
    }
    public function deleSalesmanType(Request $request){
        $id=$request->param('id');
        $res=Db::name('dealer_salesman_type')
            ->where('id',$id)
            ->update([
                'status'=>1
            ]);
        if($res){
            return JsonService::successful('删除成功');
        }else{
            return JsonService::fail('请联系管理员');
        }
    }
    public function getSalesmanList(Request $request){
        $params=$request->get();
        $condition['salesman_code']=['like','%'.$params['salesman_code'].'%'];
        $condition['username']=['like','%'.$params['username'].'%'];
        $condition['phone']=['like','%'.$params['phone'].'%'];
        $condition['remark']=['like','%'.$params['remark'].'%'];
        $condition['status']=['like','%'.$params['status'].'%'];
        $list=Db::name('dealer_salesman')
            ->where(new Where($condition))
            ->where('dealer_id',$this->dealer_id)
            ->where('type',$params['type']?$params['type']:'not null')
            ->where('zone',$params['zone']?$params['zone']:'not null')
            ->where('status','<>',3)
            ->page($params['pageNum'])
            ->limit($params['pageSize'])
            ->order('create_time','desc')
            ->select();
        $total=Db::name('dealer_salesman')
            ->where(new Where($condition))
            ->where('dealer_id',$this->dealer_id)
            ->where('type',$params['type']?$params['type']:'not null')
            ->where('status','<>',3)
            ->count();
        $res=[
            'code'=>200,
            'msg'=>'查询成功',
            'data'=>$list,
            'total'=>$total
        ];
        return json($res);
    }
    public function deleSalesman(Request $request){
        $id=$request->param('id');
        $res=Db::name('dealer_salesman')
            ->where('id',$id)
            ->update([
                'status'=>3
            ]);
        if($res){
            return JsonService::successful('删除成功');
        }else{
            return JsonService::fail('请联系管理员');
        }
    }
    public function cutSalesman(Request $request){
        $params=$request->get();
        $status=$params['status']==1?2:1;
        $res=Db::name('dealer_salesman')
            ->where('id',$params['id'])
            ->update([
                'status'=>$status
            ]);
        if($res){
            return JsonService::successful('操作成功');
        }else{
            return JsonService::fail('请联系管理员');
        }
    }
    public function getSalesmanInfo(Request $request){
        $id=$request->param('id');
        $res=Db::name('dealer_salesman')
            ->where('id',$id)
            ->find();
        return JsonService::successful('查询成功',$res);
    }
    public function saveSalesman(Request $request){
        $data=$request->post();
        $data['dealer_id']=$this->dealer_id;
        if(array_key_exists('id',$data)){
            $res=Db::name('dealer_salesman')->update($data);
        }else{
            $res=Db::name('dealer_salesman')->insert($data);
        }
        if($res||$res==0){
            return JsonService::successful('保存成功');
        }else{
            return JsonService::fail('请联系管理员');
        }
    }
}