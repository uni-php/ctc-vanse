<?php
/**
 * Created by PhpStorm.
 * User: wenhan
 * Date: 2021/11/19
 * Time: 下午8:27
 */

namespace app\dealer\controller\access;
use app\Request;
use think\Controller;
use think\Db;

class Monitor extends Controller
{
    protected $dealer_id;
    public function initialize(){
        $userInfo=Request::userInfo();
        $this->dealer_id=array_key_exists('dealer_id',$userInfo)?$userInfo['dealer_id']:$userInfo['id'];
    }
    public function getMonitorList(Request $request){
        $params=$request->get();
        $list=Db::name('dealer_monitor')
            ->where('dealer_id',$this->dealer_id)
            ->where('equ_name','like','%'.$params['equ_name'].'%')
            ->page($params['pageNum'])
            ->limit($params['pageSize'])
            ->select();
        $total=Db::name('dealer_monitor')
            ->where('dealer_id',$this->dealer_id)
            ->where('equ_name','like','%'.$params['equ_name'].'%')
            ->count();
        $res=[
            'code'=>200,
            'msg'=>'查询成功',
            'data'=>$list,
            'total'=>$total
        ];
        return json($res);
    }
    public function saveMonitorList(Request $request){
        $data=$request->post();
        if(array_key_exists('id',$data)){
            $res=Db::name('dealer_monitor')->update($data);
        }else{
            $data['dealer_id']=$this->dealer_id;
            $res=Db::name('dealer_monitor')->insert($data);
        }
        if($res||$res==0){
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
    public function queryMonitor(Request $request){
        $info=Db::name('dealer_monitor')
            ->where('id',$request->param('id'))
            ->find();
        $res=[
            'code'=>200,
            'msg'=>'查询成功',
            'data'=>$info
        ];
        return json($res);
    }
    public function deleMonitor(Request $request){
        $res=Db::name('dealer_monitor')->delete($request->param('id'));
        if($res){
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
    public function getSetInfo(Request $request){
        $info=Db::name('dealer_dingding_set')
            ->where('dealer_id',$this->dealer_id)
            ->find();
        $res=[
            'code'=>200,
            'msg'=>'查询成功',
            'data'=>$info,
        ];
        return json($res);
    }
    public function saveSetInfo(Request $request){
        $data=$request->post();
        if(array_key_exists('id',$data)){
            $res=Db::name('dealer_dingding_set')
                ->update($data);
        }else{
            $data['dealer_id']=$this->dealer_id;
            $res=Db::name('dealer_dingding_set')
                ->insert($data);
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
}