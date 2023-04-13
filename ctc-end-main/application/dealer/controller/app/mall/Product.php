<?php
/**
 * Created by PhpStorm.
 * User: wenhan
 * Date: 2022/3/9
 * Time: 下午5:21
 */

namespace app\dealer\controller\app\mall;
use app\Request;
use think\Controller;
use think\Db;
use app\common\JsonService;
use think\db\Where;

class Product extends Controller
{
    protected $dealer_id;
    public function initialize(){
        $userInfo=Request::userInfo();
        $this->dealer_id=array_key_exists('dealer_id',$userInfo)?$userInfo['dealer_id']:$userInfo['id'];
    }
    public function saveProductClass(Request $request){
        $data=$request->post();
        if(array_key_exists('id',$data)){
            $res=Db::name('dealer_mall_goods_type')->update($data);
        }else{
            $data['dealer_id']=$this->dealer_id;
            $res=Db::name('dealer_mall_goods_type')->insert($data);
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

    /**
     * @param Request $request
     * @return \think\response\Json
     * @throws \think\db\exception\DataNotFoundException
     * @throws \think\db\exception\ModelNotFoundException
     * @throws \think\exception\DbException
     * 树形结构
     */
    public function getClassList(Request $request){
        $params=$request->get();
        $list=Db::name('dealer_mall_goods_type')
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

    /**
     * @param Request $request
     * @return \think\response\Json
     * @throws \think\db\exception\DataNotFoundException
     * @throws \think\db\exception\ModelNotFoundException
     * @throws \think\exception\DbException
     * 扁平结构
     */
    public function getClassLists(Request $request){
        $params=$request->get();
        $list=Db::name('dealer_mall_goods_type')
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
    public function queryProductClass(Request $request){
        $res=Db::name('dealer_mall_goods_type')
            ->where('id',$request->param('id'))
            ->find();
        return json([
            'code'=>200,
            'data'=>$res
        ]);
    }
    public function deleProductClass(Request $request){
        $params=$request->get();
        if($params['parent_id']==0){
            //分类下存在产品 无法删除
            $has=Db::name('dealer_mall_goods')
                ->where('dealer_id',$this->dealer_id)
                ->where('class_one',$params['id'])
                ->count();
            if($has==0){
                $res=Db::name('dealer_mall_goods_type')->delete($params['id']);
            }else{
                $info=[
                    'code'=>201,
                    'msg'=>'该分类下存在产品'
                ];
                return json($info);
            }
        }else{
            $has=Db::name('dealer_mall_goods')
                ->where('dealer_id',$this->dealer_id)
                ->where('class_two',$params['id'])
                ->count();
            if($has==0){
                $res=Db::name('dealer_mall_goods_type')->delete($params['id']);
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
    public function getGoodsList(Request $request){
        $params=$request->get();
        $list=Db::name('dealer_mall_goods')
            ->where('code','like','%'.$params['code'].'%')
            ->where('goods_name','like','%'.$params['goods_name'].'%')
            ->where('is_cut',$params['status'])
            ->where('dealer_id',$this->dealer_id)
            ->field('details',true)
            ->order('create_time','desc')
            ->page($params['pageNum'])
            ->limit($params['pageSize'])
            ->select();
        foreach ($list as $key=>$value){
            $list[$key]['cover']=json_decode($value['cover'],true);
        }
        $total=Db::name('dealer_mall_goods')
            ->where('code','like','%'.$params['code'].'%')
            ->where('goods_name','like','%'.$params['goods_name'].'%')
            ->where('dealer_id',$this->dealer_id)
            ->where('is_cut',$params['status'])
            ->count();
        $res=[
            'code'=>200,
            'msg'=>'查询成功',
            'data'=>$list,
            'total'=>$total
        ];
        return json($res);
    }
    public function cutGoods(Request $request){
        $id=$request->param('id');
        $res=Db::name('dealer_mall_goods')
            ->where('id',$id)
            ->update([
               'is_cut'=>2
            ]);
        if($res){
            return JsonService::successful('下架成功');
        }else{
            return JsonService::fail('请联系管理员');
        }
    }
    public function upGoods(Request $request){
        $id=$request->param('id');
        $res=Db::name('dealer_mall_goods')
            ->where('id',$id)
            ->update([
                'is_cut'=>1
            ]);
        if($res){
            return JsonService::successful('上架成功');
        }else{
            return JsonService::fail('请联系管理员');
        }
    }
    public function queryGoodsInfo(Request $request){
        $goods_id=$request->param('goods_id');
        $info=Db::name('dealer_mall_goods')
            ->where('id',$goods_id)
            ->find();
        $info['cover']=json_decode($info['cover'],true);
        return JsonService::successful('查询成功',$info);
    }
    public function saveGoods(Request $request){
        $data=$request->post();
        $data['update_time']=date("Y-m-d H:i:s");
        $data['cover']=json_encode($data['cover']);
        if(array_key_exists('id',$data)){
            $res=Db::name('dealer_mall_goods')->update($data);
        }else{
            $data['dealer_id']=$this->dealer_id;
            $res=Db::name('dealer_mall_goods')->insert($data);
        }
        if($res||$res==0){
           return JsonService::successful('保存成功');
        }else{
            return JsonService::fail('请联系管理员');
        }
    }

}