<?php
/**
 * Created by PhpStorm.
 * User: wenhan
 * Date: 2022/10/1
 * Time: 下午11:46
 */

namespace app\dealer\controller\app\guide;
use think\Db;
use app\common\JsonService;
use app\Request;
use think\db\Where;
use think\Controller;

class Index extends Controller
{
    protected $dealer_id;
    public function initialize(){
        $userInfo=Request::userInfo();
        $this->dealer_id=array_key_exists('dealer_id',$userInfo)?$userInfo['dealer_id']:$userInfo['id'];
    }
    public function getGuideList(Request $request){
        $params=$request->get();
        $condition['a.name|a.phone']=['like','%'.$params['keywords'].'%'];
        $condition['a.active_name']=['like','%'.$params['activeName'].'%'];
        $condition['a.status']=['like','%'.$params['status'].'%'];
        $condition['b.id']=['like','%'.$params['group'].'%'];
        $list=Db::name('dealer_guide')
            ->alias('a')
            ->join('dealer_guide_group b','a.group_id=b.id')
            ->join('dealer_store c','a.store_id=c.id')
            ->where(new Where($condition))
            ->where('a.dealer_id',$this->dealer_id)
            ->where('a.status','<>',3)
            ->page($params['pageNum'])
            ->limit($params['pageSize'])
            ->field('a.*,b.group_name,c.store_name')
            ->select();
        $total=Db::name('dealer_guide')
            ->alias('a')
            ->join('dealer_guide_group b','a.group_id=b.id')
            ->where(new Where($condition))
            ->where('a.dealer_id',$this->dealer_id)
            ->where('a.status','<>',3)
            ->count();
        $res=[
            'code'=>200,
            'msg'=>'查询成功',
            'data'=>$list,
            'total'=>$total
        ];
        return json($res);
    }
    public function delGuide(Request $request){
        $id=$request->get('id');
        $res=Db::name('dealer_guide')
            ->where('id',$id)
            ->where('dealer_id',$this->dealer_id)
            ->update([
                'status'=>3
            ]);
        if($res){
            return JsonService::successful('删除成功');
        }else{
            return JsonService::fail('请联系管理员');
        }
    }
    public function checkGuide(Request $request){
        $params=$request->get();
        $res=Db::name('dealer_guide')
            ->where('openid',$params['openid'])
            ->where('dealer_id',$this->dealer_id)
            ->update([
                'status'=>$params['status'],
                'active_name'=>'first'
            ]);
        if($res){
            return JsonService::successful('审核成功');
        }else{
            return JsonService::fail('请联系管理员');
        }
    }
    public function getGuideInfo(Request $request){
        $id=$request->param('id');
        $info=Db::name('dealer_guide')
            ->alias('a')
            ->join('dealer_guide_group b','a.group_id=b.id')
            ->join('dealer_store c','a.store_id=c.id')
            ->where('a.id',$id)
            ->field('a.*,b.group_name,c.store_name')
            ->find();
        $info['cover']= json_decode($info['cover'],true);
        return JsonService::successful('查询成功',$info);
    }
    public function saveGuide(Request $request){
        $data=$request->post();
        $data['dealer_id']=$this->dealer_id;
        $data['cover']=json_encode($data['cover']);
        if(array_key_exists('id',$data)){
            $res=Db::name('dealer_guide')
                ->strict(false)
                ->update($data);
        }else{
            $has=Db::name('dealer_guide')
                ->where('dealer_id',$this->dealer_id)
                ->where('phone',$data['phone'])
                ->find();
            if($has) return JsonService::fail('请勿重复注册');
            $data['password']= md5($data['password']);
            $res=Db::name('dealer_guide')->strict(false)->insert($data);
        }
        if($res||$res==0){
            return JsonService::successful('保存成功');
        }else{
            return JsonService::fail('请联系管理员');
        }
    }
}