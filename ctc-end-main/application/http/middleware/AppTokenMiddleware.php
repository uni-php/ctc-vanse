<?php
/**
 * Created by PhpStorm.
 * User: wenhan
 * Date: 2022/2/9
 * Time: 下午8:51
 */

namespace app\http\middleware;
use app\Request;
use app\lib\exception\TokenMissException;
use app\lib\exception\AuthException;
use app\common\UserRepository;
use Ip2Region;
use think\Controller;

class AppTokenMiddleware extends Controller
{
    public function handle($request, \Closure $next){
        $ip2region = new Ip2Region();
        $address = $ip2region->btreeSearch($request->ip());
        $address=explode("|",$address['region']?:'0|0|0|0');
        Request::macro('address', function () use (&$address) {
            return is_null($address) ? 0 : $address;
        });
        return $next($request);
    }
}