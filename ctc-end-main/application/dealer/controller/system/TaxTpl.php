<?php
/**
 * Created by PhpStorm.
 * User: wenhan
 * Date: 2021/11/16
 * Time: 下午4:25
 */

namespace app\dealer\controller\system;
use think\Controller;
use think\Db;
use app\Request;
use think\facade\Hook;

class TaxTpl extends Controller
{
    public function taxTplList(Request $request){
        $userInfo=$request->userInfo();
        $params=$request->get();
        $dealer_id=array_key_exists('dealer_id',$userInfo)?$userInfo['dealer_id']:$userInfo['id'];
        $list=Db::name('dealer_tax_template')
            ->where('dealer_id',$dealer_id)
            ->where('delete_time','null')
            ->page($params['pageNum'])
            ->order('create_time','desc')
            ->limit($params['pageSize'])
            ->select();
        $total=Db::name('dealer_tax_template')
            ->where('dealer_id',$dealer_id)
            ->where('delete_time','null')
            ->count();
        $res=[
            'code'=>200,
            'msg'=>'查询成功',
            'data'=>$list,
            'total'=>$total
        ];
        return json($res);
    }
    public function saveTaxTpl(Request $request){
        $data=$request->post();
        $userInfo=$request->userInfo();
        $address = $request->address();
        $dealer_id=array_key_exists('dealer_id',$userInfo)?$userInfo['dealer_id']:$userInfo['id'];
        $data['dealer_id']=$dealer_id;
        if(array_key_exists('id',$data)){
            $res=Db::name('dealer_tax_template')
                ->update($data);
        }else{
            $res=Db::name('dealer_tax_template')->insert($data);
        }
        if($res||$res==0){
            $log=[
                'module_name'=>'系统管理',
                'operator'=>$request->userInfo()['account'],
                'ip'=>$request->ip(),
                'address'=>$address[2].$address[3],
                'operate_type'=>array_key_exists('id',$data)?'2':'1',
                'operate_event'=>array_key_exists('id',$data)?'修改税费模板':'新增税费模板',
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
    public function getTaxTpl(Request $request){
        $res=Db::name('dealer_tax_template')
            ->where('id',$request->param('id'))
            ->find();
        $info=[
            'code'=>200,
            'msg'=>'查询成功',
            'data'=>$res
        ];
        return json($info);
    }
    public function deleTaxTpl(Request $request){
        $id=$request->param('id');
        $userInfo=$request->userInfo();
        $address = $request->address();
        $dealer_id=array_key_exists('dealer_id',$userInfo)?$userInfo['dealer_id']:$userInfo['id'];
        $res=Db::name('dealer_tax_template')
            ->where('id', $id)
            ->useSoftDelete('delete_time',time())
            ->delete();
        if($res){
            $log=[
                'module_name'=>'系统管理',
                'operator'=>$request->userInfo()['account'],
                'ip'=>$request->ip(),
                'address'=>$address[2].$address[3],
                'operate_type'=>'3',
                'operate_event'=>'删除税费模板',
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
    public function changeTaxTplStatus(Request $request){
        $params=$request->get();
        $address = $request->address();
        $userInfo=$request->userInfo();
        $dealer_id=array_key_exists('dealer_id',$userInfo)?$userInfo['dealer_id']:$userInfo['id'];
        $code=Db::name('dealer_tax_template')
            ->update($params);
        if($code){
            $log=[
                'module_name'=>'系统管理',
                'operator'=>$request->userInfo()['account'],
                'ip'=>$request->ip(),
                'address'=>$address[2].$address[3],
                'operate_type'=>'2',
                'operate_event'=>'更新税费模板状态',
                'dealer_id'=>$dealer_id
            ];
            Hook::listen('dealer_op_log',$log);
            $info=[
                'code'=>200,
                'msg'=>'更新成功'
            ];
        }else{
            $info=[
                'code'=>201,
                'msg'=>'系统异常'
            ];
        }
        return json($info);
    }
}