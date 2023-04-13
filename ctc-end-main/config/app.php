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
// | 应用设置
// +----------------------------------------------------------------------

return [
    // 应用名称
    'app_name'               => '',
    // 应用地址
    'app_host'               => '',
    // 应用调试模式
    'app_debug'              => true,
    // 应用Trace
    'app_trace'              => false,
    // 是否支持多模块
    'app_multi_module'       => true,
    // 入口自动绑定模块
    'auto_bind_module'       => false,
    // 注册的根命名空间public_dir
    'root_namespace'         => [],
    // 默认输出类型
    'default_return_type'    => 'html',
    // 默认AJAX 数据返回格式,可选json xml ...
    'default_ajax_return'    => 'json',
    // 默认JSONP格式返回的处理方法
    'default_jsonp_handler'  => 'jsonpReturn',
    // 默认JSONP处理方法
    'var_jsonp_handler'      => 'callback',
    // 默认时区
    'default_timezone'       => 'Asia/Shanghai',
    // 是否开启多语言
    'lang_switch_on'         => false,
    // 默认全局过滤方法 用逗号分隔多个
    'default_filter'         => '',
    // 默认语言
    'default_lang'           => 'zh-cn',
    // 应用类库后缀
    'class_suffix'           => false,
    // 控制器类后缀
    'controller_suffix'      => false,

    // +----------------------------------------------------------------------
    // | 模块设置
    // +----------------------------------------------------------------------

    // 默认模块名
    'default_module'         => 'index',
    // 禁止访问模块
    'deny_module_list'       => ['common'],
    // 默认控制器名
    'default_controller'     => 'Index',
    // 默认操作名
    'default_action'         => 'index',
    // 默认验证器
    'default_validate'       => '',
    // 默认的空模块名
    'empty_module'           => '',
    // 默认的空控制器名
    'empty_controller'       => 'Error',
    // 操作方法前缀
    'use_action_prefix'      => false,
    // 操作方法后缀
    'action_suffix'          => '',
    // 自动搜索控制器
    'controller_auto_search' => false,

    // +----------------------------------------------------------------------
    // | URL设置
    // +----------------------------------------------------------------------

    // PATHINFO变量名 用于兼容模式
    'var_pathinfo'           => 's',
    // 兼容PATH_INFO获取
    'pathinfo_fetch'         => ['ORIG_PATH_INFO', 'REDIRECT_PATH_INFO', 'REDIRECT_URL'],
    // pathinfo分隔符
    'pathinfo_depr'          => '/',
    // HTTPS代理标识
    'https_agent_name'       => '',
    // IP代理获取标识
    'http_agent_ip'          => 'X-REAL-IP',
    // URL伪静态后缀
    'url_html_suffix'        => 'html',
    // URL普通方式参数 用于自动生成
    'url_common_param'       => false,
    // URL参数方式 0 按名称成对解析 1 按顺序解析
    'url_param_type'         => 0,
    // 是否开启路由延迟解析
    'url_lazy_route'         => false,
    // 是否强制使用路由
    'url_route_must'         => false,
    // 合并路由规则
    'route_rule_merge'       => false,
    // 路由是否完全匹配
    'route_complete_match'   => false,
    // 使用注解路由
    'route_annotation'       => true,
    // 域名根，如thinkphp.cn
    'url_domain_root'        => '',
    // 是否自动转换URL中的控制器和操作名
    'url_convert'            => true,
    // 默认的访问控制器层
    'url_controller_layer'   => 'controller',
    // 表单请求类型伪装变量
    'var_method'             => '_method',
    // 表单ajax伪装变量
    'var_ajax'               => '_ajax',
    // 表单pjax伪装变量
    'var_pjax'               => '_pjax',
    // 是否开启请求缓存 true自动缓存 支持设置请求缓存规则
    'request_cache'          => false,
    // 请求缓存有效期
    'request_cache_expire'   => null,
    // 全局请求缓存排除规则
    'request_cache_except'   => [],
    // 是否开启路由缓存
    'route_check_cache'      => false,
    // 路由缓存的Key自定义设置（闭包），默认为当前URL和请求类型的md5
    'route_check_cache_key'  => '',
    // 路由缓存类型及参数
    'route_cache_option'     => [],

    // 默认跳转页面对应的模板文件
    'dispatch_success_tmpl'  => Env::get('think_path') . 'tpl/dispatch_jump.tpl',
    'dispatch_error_tmpl'    => Env::get('think_path') . 'tpl/dispatch_jump.tpl',

    // 异常页面的模板文件
    'exception_tmpl'         => Env::get('think_path') . 'tpl/think_exception.tpl',

    // 错误显示信息,非调试模式有效
    'error_message'          => '页面错误！请稍后再试～',
    // 显示错误信息
    'show_error_msg'         => false,
    // 异常处理handle类 留空使用 \think\exception\Handle
    'exception_handle'       => '\app\lib\exception\ExceptionHandler',

    // +----------------------------------------------------------------------
    // | 系统常量设置
    // +----------------------------------------------------------------------
    'public_dir'  => Env::get('ROOT_PATH') . 'public/statics/',//静态文件目录
    'public_code_dir'  => Env::get('ROOT_PATH') . 'public/code/',//码包文件目录
    // +----------------------------------------------------------------------
    // | 微信公众号配置 品牌商
    // +----------------------------------------------------------------------
    'wechat'=>[
        'debug'  => true,
        'app_id' => 'wx58527ef9c27a4606',
        'secret' => '5a1e6c22b936c2d716ee7917176e5963',
        'token'  => 'wenhan123',
        'aes_key' => 'gSUDzfjBzeWZmGgF73K4MVyh46WT4UEGRN5KFhXD5jj', // 可选
        'log' => [
            'level' => 'debug',
            'file'  => Env::get('runtime_path') . 'log/'.date('Ymd').'/wechat_debug.log', // XXX: 绝对路径！！！！
        ],
        // payment
        'payment' => [
            'merchant_id'        => '1626250234',
            'key'                => 'fskdhfkjdfdfs414dsadoisaodioasdi',
            'cert_path'          => 'path/to/your/cert.pem', // XXX: 绝对路径！！！！
            'key_path'           => 'path/to/your/key',      // XXX: 绝对路径！！！！
            'notify_url'         => '默认的订单回调地址333',       // 你也可以在下单时单独设置来想覆盖它
            // 'device_info'     => '013467007045764',
            // 'sub_app_id'      => '',
            // 'sub_merchant_id' => '',
            // ...
        ],
    ],
    'zht_wechat'=>[
        'debug'  => true,
        'app_id' => 'wx5ce210829bff659d',
        'log' => [
            'level' => 'debug',
            'file'  => Env::get('runtime_path') . 'log/'.date('Ymd').'/wechat_debug.log', // XXX: 绝对路径！！！！
        ],
        // payment
        'payment' => [
            'merchant_id'        => '1368179202',
            'key'                => '3F8FFDA19F9248E5BCD56E3F44308350',
            'cert_path'          => Env::get('ROOT_PATH') . 'public/statics/'.'main_cert/'.'apiclient_cert.pem', // XXX: 绝对路径！！！！
            'key_path'           => Env::get('ROOT_PATH') . 'public/statics/'.'main_cert/'.'apiclient_key.pem',      // XXX: 绝对路径！！！！
        ],
    ],
    // +----------------------------------------------------------------------
    // | 微信开放平台配置信息 托管第三方用
    // +----------------------------------------------------------------------
    'openPlatform'=>[
        'app_id'   => 'wxb69be9ce11dbfbb6',
        'secret'   => '391f68f2753fe9f1f88ad68a19a15179',
        'token'    => 'rekjr34985r4rhfjewrjewrjk',
        'aes_key'  => 'fdoi9435i3o5io43u5i43o5uio4u35i4u35iu43iu54'
    ],
    'app_wechat'=>[
        'debug'  => true,
        'app_id' => 'wx5ce210829bff659d',
        'secret' => '82be149c264cf33388d73869486dcf35',
        'token'  => 'wenhan123',
        'aes_key' => 'gSUDzfjBzeWZmGgF73K4MVyh46WT4UEGRN5KFhXD5jj', // 可选
        'log' => [
            'level' => 'debug',
            'file'  => Env::get('runtime_path') . 'log/'.date('Ymd').'/wechat_debug.log', // XXX: 绝对路径！！！！
        ],
        // payment
        'payment' => [
            'merchant_id'        => '1368179202',
            'key'                => '3F8FFDA19F9248E5BCD56E3F44308350',
            'cert_path'          => 'path/to/your/cert.pem', // XXX: 绝对路径！！！！
            'key_path'           => 'path/to/your/key',      // XXX: 绝对路径！！！！
            'notify_url'         => '默认的订单回调地址333',       // 你也可以在下单时单独设置来想覆盖它
            // 'device_info'     => '013467007045764',
            // 'sub_app_id'      => '',
            // 'sub_merchant_id' => '',
            // ...
        ],
    ],
    // +----------------------------------------------------------------------
    // | 七牛云配置
    // +----------------------------------------------------------------------
    'qiniu' => [
        'accessKey' => 'DwgCPUsPkmoWpbzHJy0k_YYxCM6D5HroQxX6O1sJ',
        'secretKey' => 'xIImdNbt4Wa50FuIe8LtBwWauyeK4JjsQvpK3a9z',
        'domain' => 'cdn.uni-2id.com',//域名地址
        'bucket' => 'hailue',//空间名称
        'zone'=> 'east_china'//区域
    ],


];
