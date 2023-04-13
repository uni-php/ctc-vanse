<?php
/**
 * Created by PhpStorm.
 * Role: wenhan
 * Date: 2021/11/13
 * Time: 下午4:48
 */

namespace app\behavior;
use think\Controller;
use think\Db;

class DealerLog extends Controller
{
    //写入日志
    public function run($params=[]){
        $res=Db::name('dealer_oper_log')
            ->insert($params);
        return $res;
    }
}