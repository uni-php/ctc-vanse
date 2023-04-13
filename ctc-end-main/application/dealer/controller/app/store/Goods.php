<?php
/**
 * Created by PhpStorm.
 * User: wenhan
 * Date: 2022/12/10
 * Time: 下午10:14
 */

namespace app\dealer\controller\app\store;
use app\Request;
use think\Controller;
use think\Db;
use app\common\JsonService;
use think\db\Where;

class Goods extends Controller
{
    protected $dealer_id;
    public function initialize(){
        $userInfo=Request::userInfo();
        $this->dealer_id=array_key_exists('dealer_id',$userInfo)?$userInfo['dealer_id']:$userInfo['id'];
    }
    public function getStoreGoodsClass(Request $request){
        $params=$request->get();
        $list=Db::name('dealer_store_goods_class')
            ->where('dealer_id',$this->dealer_id)
            ->page($params['pageNum'])
            ->limit($params['pageSize'])
            ->select();
        $tree=tree($list,0);
        $res=[
            'code'=>200,
            'msg'=>'查询成功',
            'data'=>$tree
        ];
        return json($res);
    }
    public function saveStoreGoodsClass(Request $request){
        $data=$request->post();
        if(array_key_exists('id',$data)){
            $res=Db::name('dealer_store_goods_class')->update($data);
        }else{
            $data['dealer_id']=$this->dealer_id;
            $res=Db::name('dealer_store_goods_class')->insert($data);
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
    public function queryStoreGoodsClass(Request $request){
        $res=Db::name('dealer_store_goods_class')
            ->where('id',$request->param('id'))
            ->find();
        return json([
            'code'=>200,
            'data'=>$res
        ]);
    }
    public function deleStoreGoodsClass(Request $request){
        $params=$request->get();
        if($params['parent_id']==0){
            //分类下存在产品 无法删除
            $has=Db::name('dealer_store_self_goods')
                ->where('dealer_id',$this->dealer_id)
                ->where('class_one',$params['id'])
                ->where('status',0)
                ->count();
            if($has==0){
                $res=Db::name('dealer_store_goods_class')->delete($params['id']);
            }else{
                $info=[
                    'code'=>201,
                    'msg'=>'该分类下存在产品'
                ];
                return json($info);
            }
        }else{
            $has=Db::name('dealer_store_self_goods')
                ->where('dealer_id',$this->dealer_id)
                ->where('class_two',$params['id'])
                ->where('status',0)
                ->count();
            if($has==0){
                $res=Db::name('dealer_store_goods_class')->delete($params['id']);
            }else{
                $info=[
                    'code'=>201,
                    'msg'=>'该分类下存在产品'
                ];
                return json($info);
            }
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
    public function saveSelfGoods(Request $request){
        $data=$request->post();
        if(array_key_exists('id',$data)){
            $res=Db::name('dealer_store_self_goods')
                ->strict(false)
                ->update($data);
        }else{
            $data['dealer_id']=$this->dealer_id;
            $res=Db::name('dealer_store_self_goods')->strict(false)->insert($data);
        }
        if($res||$res==0){
            return JsonService::successful('保存成功');
        }else{
            return JsonService::fail('请联系管路员');
        }
    }
    public function getSelfGoodsList(Request $request){
        $params=$request->get();
        if($params['startTime']){
            $condition['a.create_time']=['between time',[$params['startTime'],$params['endTime']]];
        }
        $condition['b.code']=['like','%'.$params['product_code'].'%'];
        $condition['b.product_name']=['like','%'.$params['product_name'].'%'];
        $list=Db::name('dealer_store_self_goods')
            ->alias('a')
            ->join('dealer_product b','a.product_id=b.id')
            ->where(new Where($condition))
            ->where('a.dealer_id',$this->dealer_id)
            ->where('a.class_one',$params['class_one']?:'not null')
            ->where('a.class_two',$params['class_two']?:'not null')
            ->where('a.status',0)
            ->page($params['pageNum'])
            ->limit($params['pageSize'])
            ->order('a.create_time','desc')
            ->field('b.cover,b.code,b.product_name,a.class_one,a.class_two,a.create_time,a.product_id,a.id')
            ->select();
        $total=Db::name('dealer_store_self_goods')
            ->alias('a')
            ->join('dealer_product b','a.product_id=b.id')
            ->where(new Where($condition))
            ->where('a.dealer_id',$this->dealer_id)
            ->where('a.class_one',$params['class_one']?:'not null')
            ->where('a.class_two',$params['class_two']?:'not null')
            ->where('a.status',0)
            ->count();
        $res=[
            'code'=>200,
            'msg'=>'查询成功',
            'data'=>$list,
            'total'=>$total
        ];
        return json($res);
    }
    public function deleSelfGoods(Request $request){
        $id=$request->param('id');
        $res=Db::name('dealer_store_self_goods')
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
    public function querySelfGoodsInfo(Request $request){
        $id=$request->param('id');
        $info=Db::name('dealer_store_self_goods')
            ->alias('a')
            ->join('dealer_product b','a.product_id=b.id')
            ->where('a.id',$id)
            ->field('b.product_name,a.*')
            ->find();
        return JsonService::successful('查询成功',$info);
    }
}