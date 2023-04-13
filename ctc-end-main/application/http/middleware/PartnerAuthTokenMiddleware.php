<?php

namespace app\http\middleware;
use app\Request;
use app\lib\exception\TokenMissException;
use app\lib\exception\AuthException;
use app\common\UserRepository;
use think\Controller;

class PartnerAuthTokenMiddleware extends Controller
{
    public function handle($request, \Closure $next)
    {
        $authInfo = null;
        $token = trim(ltrim($request->header('Authori-zation'), 'Bearer'));
        if(!$token)  $token = trim(ltrim($request->header('Authorization'), 'Bearer'));
        if(!$token){
            throw new TokenMissException();
        }
        try{
            $authInfo=UserRepository::partnerParseToken($token);
        }catch (AuthException $e){
            throw new AuthException();
        }
        Request::macro('userInfo', function () use (&$authInfo) {
            return is_null($authInfo) ? 0 : $authInfo['user'];
        });
        return $next($request);
    }
}
