<?php
/**
 * Created by PhpStorm.
 * Role: wenhan
 * Date: 2021/10/4
 * Time: 下午6:09
 */

namespace app\lib\exception;
use Exception;
use think\exception\Handle;
use think\facade\Log;

class ExceptionHandler extends Handle
{
    private $code;
    private $msg;
    private $error_code;
    public function render(Exception $e){ // 重写render方法
        if ($e instanceof BaseException) {
            $this->code = $e->code;
            $this->msg = $e->msg;
            $this->error_code = $e->error_code;
        } else {
            if(config('app_debug')){
                // 其他错误交给系统处理
                return parent::render($e);
            }
            $this->code = 500;
            $this->msg = '服务器内部异常';
            $this->error_code = 999;
        }
        $request = request();
        $result = [
            'msg' => $this->msg,
            'error_code' => $this->error_code,
            'request_url' => $request->url()
        ];
        Log::record($e->getMessage(),'error');
        return json($result, $this->code);
    }
}