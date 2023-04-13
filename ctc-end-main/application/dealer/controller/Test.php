<?php
/**
 * Created by PhpStorm.
 * User: wenhan
 * Date: 2022/3/15
 * Time: 下午3:20
 */

namespace app\dealer\controller;
use think\Controller;

class Test extends Controller
{
    public function index(){
        cache('name', 'dsadisadoioasd', 30);
    }
    public function test(){
        dump(cache('name'));
    }
}