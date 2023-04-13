<?php
/**
 * Created by PhpStorm.
 * Role: wenhan
 * Date: 2021/10/4
 * Time: 下午6:25
 */

namespace app\lib\exception;
use Exception;

class BaseException extends Exception
{
    public $code = 400; // HTTP 状态码 404,200...
    public $msg = '参数错误';  // 错误信息具体
    public $error_code = 10000;  // 自定义错误码
    public function __construct($params = [])
    {
        if (!is_array($params)) {
            return;  // 如果没有传入数组，那么就是使用默认的 code、msg 和 errorCode
        }
        if (array_key_exists('code', $params)) {
            $this->code = $params['code'];
        }
        if (array_key_exists('msg', $params)) {
            $this->msg = $params['msg'];
        }
        if (array_key_exists('error_code', $params)) {
            $this->error_code = $params['error_code'];
        }
    }
}