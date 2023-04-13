<?php
/**
 * Created by PhpStorm.
 * User: wenhan
 * Date: 2022/4/7
 * Time: 下午9:58
 */

namespace app\behavior;
use think\Controller;
use think\Db;

class PdaLog extends Controller
{
    //写入PDA日志
    public function run($params=[]){
        $res=Db::name('dealer_logistics_op_log')
            ->insert($params);
        return $res;
    }
}