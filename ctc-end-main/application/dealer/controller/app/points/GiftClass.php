<?php
/**
 * Created by PhpStorm.
 * User: wenhan
 * Date: 2022/3/12
 * Time: 下午9:56
 */

namespace app\dealer\controller\app\points;
use app\Request;
use think\Controller;
use think\Db;
use app\common\JsonService;
use think\db\Where;

class GiftClass extends Controller
{
    protected $dealer_id;
    public function initialize(){
        $userInfo=Request::userInfo();
        $this->dealer_id=array_key_exists('dealer_id',$userInfo)?$userInfo['dealer_id']:$userInfo['id'];
    }
    public function getClassList(Request $request){
        $params=$request->get();
        $list=Db::name('dealer_points_gift_class')
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
    public function getClassLists(Request $request){
        $params=$request->get();
        $list=Db::name('dealer_points_gift_class')
            ->where('dealer_id',$this->dealer_id)
            ->page($params['pageNum'])
            ->limit($params['pageSize'])
            ->select();
        $res=[
            'code'=>200,
            'msg'=>'查询成功',
            'data'=>$list
        ];
        return json($res);
    }
    public function savePointsClass(Request $request){
        $data=$request->post();
        if(array_key_exists('id',$data)){
            $res=Db::name('dealer_points_gift_class')->update($data);
        }else{
            $data['dealer_id']=$this->dealer_id;
            $res=Db::name('dealer_points_gift_class')->insert($data);
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
    public function delePointsClass(Request $request){
        $params=$request->get();
        if($params['parent_id']==0){
            //分类下存在产品 无法删除
            $has=Db::name('dealer_product')
                ->where('dealer_id',$this->dealer_id)
                ->where('class_one',$params['id'])
                ->count();
            if($has==0){
                $res=Db::name('dealer_product_class')->delete($params['id']);
            }else{
                $info=[
                    'code'=>201,
                    'msg'=>'该分类下存在产品'
                ];
                return json($info);
            }
        }else{
            $has=Db::name('dealer_product')
                ->where('dealer_id',$this->dealer_id)
                ->where('class_two',$params['id'])
                ->count();
            if($has==0){
                $res=Db::name('dealer_points_gift_class')->delete($params['id']);
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
    public function queryPointsClass(Request $request){
        $res=Db::name('dealer_points_gift_class')
            ->where('id',$request->param('id'))
            ->find();
        return json([
            'code'=>200,
            'data'=>$res
        ]);
    }
}