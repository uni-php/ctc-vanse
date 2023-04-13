<?php
/**
 * Created by PhpStorm.
 * Role: wenhan
 * Date: 2021/10/17
 * Time: 下午10:54
 */

namespace app\behavior;
use think\Controller;
use think\Db;

class Log extends Controller
{
    //写入日志
    public function run($params=[]){
        $res=Db::name('oper_log')
            ->insert($params);
        return $res;
    }
}