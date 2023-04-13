<?php
/**
 * Created by PhpStorm.
 * Role: wenhan
 * Date: 2021/10/4
 * Time: 下午4:00
 */

namespace app\main\controller;
use think\Controller;
use think\Db;
use app\common\JsonService;
use think\Request;


class index extends Controller
{
    public function index(Request $request){
//        return 'it works!';
        dump($request->post());
    }
    public function login(Request $request){
//        dump(444);
//        dump($request);
//        dump(date('Y-m-d H:i:s'));
//        echo $request->host();
        echo md5(123456);
//        return JsonService::fail('账号或密码错误');
//        $a=[
//            'a'=>4
//        ];

    }
    public function test(Request $request){
        dump($request->post());
//        throw new \think\Exception('手动异常', 10006,'\app\lib\exception\ExceptionHandler');
    }
}