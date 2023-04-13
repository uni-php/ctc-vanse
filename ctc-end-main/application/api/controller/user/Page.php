<?php
/**
 * Created by PhpStorm.
 * User: wenhan
 * Date: 2022/11/25
 * Time: 上午12:13
 */

namespace app\api\controller\user;
use app\Request;
use think\Controller;
use think\Db;
use app\common\JsonService;

class Page extends Controller
{
    public function getUserCenterPage(Request $request){
        $params=$request->get();
        $pageSet=Db::name('dealer_customer_userinfo_page')
            ->where('dealer_id',$params['dealer_id'])
            ->find();
        return JsonService::returnData(200,'查询成功',$pageSet);
    }
}