<?php
/**
 * Created by PhpStorm.
 * Role: wenhan
 * Date: 2021/10/24
 * Time: 上午12:50
 */

namespace app\partner\controller;
use think\Controller;
use think\Db;
use app\Request;

class Product extends Controller
{
    public function getModule(Request $request){
        $params=$request->get();
        $partner_id=$request->userInfo()['id'];//合伙人id
        //查询主系统模块
        $module=Db::name('product_module')
            ->page($params['pageNum'])
            ->limit($params['pageSize'])
            ->select();
        $total=Db::name('product_module')
            ->count();
        $partner_module=Db::name('partner_product_module')
            ->where('partner_id',$partner_id)
            ->select();
        //查询该等级下的 开户折扣
        $discount=Db::name('partner_level')
            ->where('level',$request->userInfo()['level_id'])
            ->value('account_discount');
        $discount=($discount*10)/100;
        foreach ($module as $key=>$value){
            $module[$key]['module_cost']=bcmul($value['module_cost'],$discount);
            //查询零售价 优先选取品牌商设置的零售价
            foreach ($partner_module as $k=>$val){
                if($val['module_id']==$value['id']){
                    $module[$key]['module_retail']=$val['retail_price'];
                }
            }
        }
        $res=[
            'code'=>200,
            'msg'=>'查询成功',
            'data'=>$module,
            'total'=>$total
        ];
        return json($res);
    }
    public function setModulePrice(Request $request){
        $params=$request->get();
        $partner_id=$request->userInfo()['id'];//合伙人id
        $has=Db::name('partner_product_module')
            ->where('partner_id',$partner_id)
            ->where('module_id',$params['id'])
            ->find();
        if($has){
            $res=Db::name('partner_product_module')
                ->where('partner_id',$partner_id)
                ->where('module_id',$params['id'])
                ->update([
                    'retail_price'=>$params['retail_price']
                ]);
        }else{
            $res=Db::name('partner_product_module')
                ->insert([
                    'partner_id'=>$partner_id,
                    'module_id'=>$params['id'],
                    'retail_price'=>$params['retail_price']
                ]);
        }


        if($res||$res==0){
            $info=[
                'code'=>200,
                'msg'=>'设置成功',
            ];
        }else{
            $info=[
                'code'=>201,
                'msg'=>'系统异常',
            ];
        }
        return json($info);
    }
    public function getCodeList(Request $request){
        $partner_id=$request->userInfo()['id'];//合伙人id
        $list=Db::name('product_code')
            ->select();
        $lists=Db::name('partner_product_code')
            ->where('partner_id',$partner_id)
            ->select();
        $res=[
            'code'=>200,
            'msg'=>'查询成功',
            'data'=>array($list,$lists),
        ];
        return json($res);
    }
    public function addCodePrice(Request $request){
        $partner_id=$request->userInfo()['id'];//合伙人id
        $data=$request->get();
        $data['partner_id']=$partner_id;
        if(array_key_exists('id',$data)){
            $res=Db::name('partner_product_code')
                ->update($data);
        }else{
            $res=Db::name('partner_product_code')
                ->insert($data);
        }
        if($res||$res==0){
            $info=[
                'code'=>200,
                'msg'=>'设置成功',
            ];
        }else{
            $info=[
                'code'=>201,
                'msg'=>'系统异常',
            ];
        }
        return json($info);
    }
    public function getServerList(Request $request){
        $partner_id=$request->userInfo()['id'];//合伙人id
        $list=Db::name('partner_product_service')
            ->where('partner_id',$partner_id)
            ->select();
        $res=[
            'code'=>200,
            'msg'=>'查询成功',
            'data'=>$list
        ];
        return json($res);
    }
    public function addServer(Request $request){
        $partner_id=$request->userInfo()['id'];//合伙人id
        $data=$request->get();
        $data['partner_id']=$partner_id;
        if(array_key_exists('id',$data)){
            $res=Db::name('partner_product_service')
                ->update($data);
        }else{
            $res=Db::name('partner_product_service')
                ->insert($data);
        }
        if($res||$res==0){
            $info=[
                'code'=>200,
                'msg'=>array_key_exists('id',$data)?'修改成功':'新增成功',
            ];
        }else{
            $info=[
                'code'=>201,
                'msg'=>'系统异常',
            ];
        }
        return json($info);
    }
}