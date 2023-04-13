<?php

namespace app\http\middleware;
use app\Request;
use app\lib\exception\TokenMissException;
use app\lib\exception\AuthException;
use app\common\UserRepository;
use Ip2Region;
use think\Controller;

class AuthTokenMiddleware extends Controller
{
    public function handle($request, \Closure $next)
    {
        //解析ip地址
        $ip2region = new Ip2Region();
        $address = $ip2region->btreeSearch($request->ip());
        $address=explode("|",$address['region']);
        $authInfo = null;
        $token = trim(ltrim($request->header('Authori-zation'), 'Bearer'));
        if(!$token)  $token = trim(ltrim($request->header('Authorization'), 'Bearer'));
        if(!$token){
            throw new TokenMissException();
        }
        try{
            $authInfo=UserRepository::parseToken($token);
        }catch (AuthException $e){
            throw new AuthException();
        }
        Request::macro('userInfo', function () use (&$authInfo) {
            return is_null($authInfo) ? 0 : $authInfo['user'];
        });
        Request::macro('address', function () use (&$address) {
            return is_null($address) ? 0 : $address;
        });
        return $next($request);
    }
}
