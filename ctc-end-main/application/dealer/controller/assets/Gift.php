<?php
/**
 * Created by PhpStorm.
 * User: wenhan
 * Date: 2021/11/25
 * Time: 下午4:04
 */

namespace app\dealer\controller\assets;
use app\Request;
use think\Controller;
use think\Db;

class Gift extends Controller
{
    protected $dealer_id;
    public function initialize(){
        $userInfo=Request::userInfo();
        $this->dealer_id=array_key_exists('dealer_id',$userInfo)?$userInfo['dealer_id']:$userInfo['id'];
    }
    public function getGroupList(Request $request){
        $params=$request->get();
        try{
            Db::execute("SET @@sql_mode='';");
        }catch (\Exception $e){

        }
        //group 统计数量
        $list=Db::name('dealer_gift_group')
            ->alias('a')
            ->leftJoin('dealer_gift b','a.id=b.group_id')
            ->where('a.dealer_id',$this->dealer_id)
            ->page($params['pageNum'])
            ->limit($params['pageSize'])
            ->field('a.id,a.group_name,a.create_time,count(b.gift_name) as num')
            ->order('a.create_time','desc')
            ->group('a.id')
            ->select();
        $total=Db::name('dealer_gift_group')
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
    public function queryGroup(Request $request){
        $res=Db::name('dealer_gift_group')
            ->where('id',$request->param('id'))
            ->find();
        $res=[
            'code'=>200,
            'msg'=>'查询成功',
            'data'=>$res
        ];
        return json($res);
    }
    public function deleGroup(Request $request){
            $res=Db::name('dealer_gift_group')
                ->delete($request->param('id'));
            if($res){
                $info=[
                    'code'=>200,
                    'msg'=>'删除成功'
                ];
            }else{
                $info=[
                    'code'=>201,
                    'msg'=>'请联系管理员'
                ];
            }
        return json($info);
    }
    public function saveGroup(Request $request){
        $data=$request->post();
        $data['dealer_id']=$this->dealer_id;
        if(array_key_exists('id',$data)){
            $res=Db::name('dealer_gift_group')->update($data);
        }else{
            $res=Db::name('dealer_gift_group')->insert($data);
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
    public function getGiftList(Request $request){
        $params=$request->get();
        $condition=[];
        if($params['gift_group']){
            $condition['group_id']=['=',$params['gift_group']];
        }
        $list=Db::name('dealer_gift')
            ->where($condition)
            ->where('code','like','%'.$params['code'].'%')
            ->where('gift_name','like','%'.$params['gift_name'].'%')
            ->order('create_time','desc')
            ->where('is_del',$params['is_del'])
            ->page($params['pageNum'])
            ->limit($params['pageSize'])
            ->select();
//        foreach ($list as $key=>$value){
//            $list[$key]['cover']=json_decode($value['cover']);
//        }
        $total=Db::name('dealer_gift')
            ->where($condition)
            ->where('code','like','%'.$params['code'].'%')
            ->where('gift_name','like','%'.$params['gift_name'].'%')
            ->where('is_del',$params['is_del'])
            ->count();
        $res=[
            'code'=>200,
            'msg'=>'查询成功',
            'data'=>$list,
            'total'=>$total
        ];
        return json($res);
    }
    public function queryGiftInfo(Request $request){
        $res=Db::name('dealer_gift')
            ->where('id',$request->param('id'))
            ->find();
        $info=[
            'code'=>200,
            'data'=>$res,
            'msg'=>'查询成功'
        ];
        return json($info);
    }
    public function deleGift(Request $request){
        $id=$request->param('id');
        $des=Db::name('dealer_gift')->where('id',$id)->find();
        if($des['is_del']==0){
            $res=Db::name('dealer_gift')->where('id',$id)->update(['is_del'=>1]);
        }else{
            $res=Db::name('dealer_gift')->delete($id);
        }
        if($res){
            $info=[
                'code'=>200,
                'msg'=>'删除成功'
            ];
        }else{
            $info=[
                'code'=>201,
                'msg'=>'系统异常'
            ];
        }
        return json($info);
    }
    public function saveGift(Request $request){
        $data=$request->post();
        if(array_key_exists('id',$data)){
            $res=Db::name('dealer_gift')->update($data);
        }else{
            $data['dealer_id']=$this->dealer_id;
            $res=Db::name('dealer_gift')->insert($data);
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
    public function reductionGift(Request $request){
        $res=Db::name('dealer_gift')
            ->where('id',$request->param('id'))
            ->update([
                'is_del'=>0
            ]);
        if($res){
            $info=[
                'code'=>200,
                'msg'=>'恢复成功'
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