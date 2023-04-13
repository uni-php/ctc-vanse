<?php
/**
 * Created by PhpStorm.
 * User: wenhan
 * Date: 2022/12/31
 * Time: 下午9:41
 */

namespace app\dealer\controller\wechat;
use app\Request;
use think\Controller;
use think\Db;
use think\facade\Env;
use EasyWeChat\Foundation\Application;
use EasyWeChat\Message\Article;

class Wechat extends Controller
{
    public function __construct()
    {
        parent::__construct();
        $options = config('wechat');
        $this->app = new Application($options);
    }
    public function getJsConfig($url=''){
        $js=$this->app->js;
        $js->setUrl($url);
        return $js->config(array('onMenuShareQQ', 'onMenuShareWeibo','getLocation','chooseWXPay','scanQRCode'), $debug = true, $beta = false, $json = true);
    }
    public function getUserTags(){
        $tag = $this->app->user_tag; // $user['user_tag']
        $tags=$tag->lists();
        return $tags->tags;
    }
}