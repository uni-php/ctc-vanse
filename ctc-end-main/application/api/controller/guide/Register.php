<?php
/**
 * Created by PhpStorm.
 * User: wenhan
 * Date: 2022/10/3
 * Time: 上午12:03
 */

namespace app\api\controller\guide;
use app\Request;
use think\Controller;
use think\Db;
use app\common\JsonService;

class Register extends Controller
{
    public function getStoreList(Request $request){
        $params=$request->get();
        $list=Db::name('dealer_store')
            ->where('status',1)
            ->where('dealer_id',$params['dealer_id'])
            ->field('store_name,id')
            ->select();
        return JsonService::returnData(200,'查询成功',$list);
    }
    public function getGuideGroupList(Request $request){
        $params=$request->get();
        $list=Db::name('dealer_guide_group')
            ->where('is_del',0)
            ->where('dealer_id',$params['dealer_id'])
            ->select();
        return JsonService::returnData(200,'查询成功',$list);
    }

    /**
     * @param Request $request
     * @return string
     * @throws \think\db\exception\DataNotFoundException
     * @throws \think\db\exception\ModelNotFoundException
     * @throws \think\exception\DbException
     * 判断是否存在待激活数据
     */
    public function saveRegisterInfo(Request $request){
        $data=$request->post();
        Db::startTrans();//开启事务
        try{
            $has=Db::name('dealer_guide')
                ->where('openid',$data['openid'])
                ->where('dealer_id',$data['dealer_id'])
                ->where('status',1)
                ->find();
            if($has) return JsonService::returnData(500,'请勿重复注册');
            $is_waiting_active=Db::name('dealer_guide')
                ->where('dealer_id',$data['dealer_id'])
                ->where('phone',$data['phone'])
                ->find();
            if($is_waiting_active){
                $data['active_name']='first';
                $data['status']=1;
                Db::name('dealer_guide')
                    ->where('dealer_id',$data['dealer_id'])
                    ->where('phone',$data['phone'])
                    ->strict(false)
                    ->update($data);
            }else{
                $data['active_name']='second';
                $data['status']=-1;
                Db::name('dealer_guide')
                    ->strict(false)
                    ->insert($data);
            }
            Db::commit();
            return JsonService::returnData(200,'提交成功',['check_status'=>$is_waiting_active?1:-1]);
        }catch (\Exception $e){
            Db::rollback();
            return JsonService::returnData(500,$e->getMessage());
        }
    }
}