<?php
/**
 * Created by PhpStorm.
 * User: wenhan
 * Date: 2021/11/15
 * Time: 下午4:26
 */

namespace app\dealer\controller\system;
use think\Controller;
use think\Db;
use app\Request;
use think\facade\Hook;

class Freight extends Controller
{
    public function getTpl(Request $request){
        $userInfo=$request->userInfo();
        $params=$request->get();
        $dealer_id=array_key_exists('dealer_id',$userInfo)?$userInfo['dealer_id']:$userInfo['id'];
        $list=Db::name('dealer_freight_template')
            ->where('dealer_id',$dealer_id)
            ->where('status',0)
            ->page($params['pageNum'])
            ->limit($params['pageSize'])
            ->field('id,tpl_name,create_time')
            ->select();
        $total=Db::name('dealer_freight_template')
            ->where('dealer_id',$dealer_id)
            ->where('status',0)
            ->count();
        $res=[
            'code'=>200,
            'msg'=>'查询成功',
            'data'=>$list,
            'total'=>$total
        ];
        return json($res);
    }
    public function deleTpl(Request $request){
        $id=$request->param('id');
        $address = $request->address();
        $userInfo=$request->userInfo();
        $dealer_id=array_key_exists('dealer_id',$userInfo)?$userInfo['dealer_id']:$userInfo['id'];
        $res=Db::name('dealer_freight_template')
            ->where('id',$id)
            ->update([
                'status'=>1
            ]);
        if($res){
            $log=[
                'module_name'=>'系统管理',
                'operator'=>$request->userInfo()['account'],
                'ip'=>$request->ip(),
                'address'=>$address[2].$address[3],
                'operate_type'=>'3',
                'operate_event'=>'删除运费模板',
                'dealer_id'=>$dealer_id
            ];
            Hook::listen('dealer_op_log',$log);
            $info=[
                'code'=>200,
                'msg'=>'删除成功',
            ];
        }else{
            $info=[
                'code'=>201,
                'msg'=>'系统异常',
            ];
        }
        return json($info);
    }
    public function saveTpl(Request $request){
        $userInfo=$request->userInfo();
        $address = $request->address();
        $dealer_id=array_key_exists('dealer_id',$userInfo)?$userInfo['dealer_id']:$userInfo['id'];
        $data=$request->post();
        $data['area']=$data['area']?json_encode($data['area']):[];
        $data['dealer_id']=$dealer_id;
        if(array_key_exists('id',$data)){
            $res=Db::name('dealer_freight_template')
                ->update($data);
        }else{
            $res=Db::name('dealer_freight_template')
                ->insert($data);
        }
        if($res||$res==0){
            $log=[
                'module_name'=>'系统管理',
                'operator'=>$request->userInfo()['account'],
                'ip'=>$request->ip(),
                'address'=>$address[2].$address[3],
                'operate_type'=>array_key_exists('id',$data)?'2':'1',
                'operate_event'=>array_key_exists('id',$data)?'修改运费模板':'新增运费模板',
                'dealer_id'=>$dealer_id
            ];
            Hook::listen('dealer_op_log',$log);
            $info=[
                'code'=>200,
                'msg'=>'保存成功',
            ];
        }else{
            $info=[
                'code'=>201,
                'msg'=>'系统异常',
            ];
        }
        return json($info);
    }
    public function queryTpl(Request $request){
        $res=Db::name('dealer_freight_template')
            ->where('id',$request->param('id'))
            ->find();
        $res['area']=json_decode($res['area'],true);
        $info=[
            'code'=>200,
            'msg'=>'查询成功',
            'data'=>$res
        ];
        return json($info);
    }

}