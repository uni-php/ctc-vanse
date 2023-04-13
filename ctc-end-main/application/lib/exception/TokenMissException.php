<?php
/**
 * Created by PhpStorm.
 * Role: wenhan
 * Date: 2021/10/4
 * Time: 下午9:39
 */

namespace app\lib\exception;


class TokenMissException extends BaseException
{
    public $code = 404;
    public $msg = '您当前未登陆';
    public $error_code = 40000;
}