<?php
/**
 * Created by PhpStorm.
 * Role: wenhan
 * Date: 2021/10/4
 * Time: 下午11:29
 */

namespace app\lib\exception;


class AuthException extends BaseException
{
    public $code = 200;
    public $msg = '登陆已过期，请重新登陆';
    public $error_code = 40000;
}