<?php
/**
 * Created by PhpStorm.
 * User: wenhan
 * Date: 2022/12/18
 * Time: 上午12:16
 */

namespace app\api\controller\store_shop;
use app\Request;
use think\Controller;
use think\Db;
use app\common\JsonService;

class Store extends Controller
{
    public function getStoreInfo(Request $request){
        $params=$request->get();
        $info=Db::name('dealer_store')
            ->where('dealer_id',$params['dealer_id'])
            ->where('id',$params['store_id'])
            ->find();
        return JsonService::returnData(200,'查询成功',$info);
    }
}