<?php
/**
 * Created by PhpStorm.
 * User: wenhan
 * Date: 2022/8/6
 * Time: 上午12:18
 */

namespace app\api\controller\points;
use app\Request;
use think\Controller;
use think\Db;
use app\common\JsonService;

class Rule extends Controller
{
    public function getPointsRule(Request $request){
        $dealer_id=$request->param('dealer_id');
        $rule=Db::name('dealer_points_rule')
            ->where('dealer_id',$dealer_id)
            ->value('rule_des');
        return JsonService::returnData(200,'查询成功',$rule);
    }
}