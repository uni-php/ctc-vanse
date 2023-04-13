<?php
// +----------------------------------------------------------------------
// | ThinkPHP [ WE CAN DO IT JUST THINK ]
// +----------------------------------------------------------------------
// | Copyright (c) 2006~2018 http://thinkphp.cn All rights reserved.
// +----------------------------------------------------------------------
// | Licensed ( http://www.apache.org/licenses/LICENSE-2.0 )
// +----------------------------------------------------------------------
// | Author: liu21st <liu21st@gmail.com>
// +----------------------------------------------------------------------

// +----------------------------------------------------------------------
// | 中间件配置
// +----------------------------------------------------------------------
return [
    // 默认中间件命名空间
    'default_namespace' => 'app\\http\\middleware\\',
    'auth'	=>	app\http\middleware\AuthTokenMiddleware::class,//主后台鉴权中间件
    'partner_auth'	=>	app\http\middleware\PartnerAuthTokenMiddleware::class,//合伙人鉴权中间件
    'dealer_auth'	=>	app\http\middleware\DealerAuthTokenMiddleware::class,//品牌商鉴权中间件
    'api_auth'	=>	app\http\middleware\AppTokenMiddleware::class,//移动端鉴权中间件
    'pda_auth'	=>	app\http\middleware\PdaAuthTokenMiddleware::class,//pda鉴权中间件
    'api_allow_cross_domain'	=>	app\http\middleware\AllowCrossDomain::class,//跨域中间件
];
