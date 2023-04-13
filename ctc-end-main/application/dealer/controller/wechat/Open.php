<?php
/**
 * Created by PhpStorm.
 * User: wenhan
 * Date: 2022/3/15
 * Time: 下午9:34
 */

namespace app\dealer\controller\wechat;
use app\Request;
use think\Controller;
use think\Db;
use think\facade\Env;
use EasyWeChat\Foundation\Application;
use EasyWeChat\Message\Article;

class Open
{
    protected $authorizerAppId;
    protected $authorizerRefreshToken;

    public function __construct($authorizerAppId = null, $authorizerRefreshToken = null)
    {
        !empty($authorizerAppId) && $this->authorizerAppId = $authorizerAppId;
        !empty($authorizerRefreshToken) && $this->authorizerRefreshToken = $authorizerRefreshToken;
        $options =[
            'open_platform'=>config('openPlatform')
        ];
        $app = new Application($options);
        $this->app = $app->open_platform->createAuthorizerApplication($this->authorizerAppId,$this->authorizerRefreshToken);
        $this->openPlatform=$app->open_platform->server;
    }

    /**
     * @return array|string
     * 获取jssdk配置
     */
    public function getJsConfig($url=''){
        $js=$this->app->js;
//        $url='http://yx.icloudapi.cn/';
        $js->setUrl($url);
        return $js->config(array('onMenuShareQQ', 'onMenuShareWeibo','getLocation','chooseWXPay','scanQRCode'), $debug = true, $beta = false, $json = true);
    }

    /**
     * 获取用户标签列表
     */
    public function getUserTags(){
        $tag = $this->app->user_tag; // $user['user_tag']
        $tags=$tag->lists();
        return $tags->tags;
    }
    /**
     * 创建标签
     */
    public function createTags($name){
        $tag = $this->app->user_tag;
        $res=$tag->create($name);
        return $res;
    }

    /**
     * 删除标签
     */
    public function deleteTag($tagId){
        $tag = $this->app->user_tag;
        $res=$tag->delete($tagId);
        return $res;
    }

    /**
     * 修改标签
     */
    public function updateTag($tagId, $name){
        $tag = $this->app->user_tag;
        $res=$tag->update($tagId, $name);
        return $res;
    }
    /**
     * @param array $openIds
     * @param $tagId
     * 批量为用户打标签
     */
    public function batchTagging($openIds=[], $tagId){
        $tag = $this->app->user_tag;
        $res=$tag->batchTagUsers($openIds, $tagId);
        return $res;
    }
    /**
     * @param array $openIds
     * @param $tagId
     * 批量为用户取消标签
     */
    public function batchUnTagging($openIds=[], $tagId){
        $tag = $this->app->user_tag;
        $res=$tag->batchUntagUsers($openIds, $tagId);
        return $res;
    }

    /**
     * @param string $openid
     * 根据openid 获取用户标签
     */
    public function getUserTagsByOpenid($openid=''){
        $tag = $this->app->user_tag;
        $userTags = $tag->userTags($openid);
        return $userTags->tagid_list;
    }
    /**
     * @param $url
     * 上传图片素材
     */
    public function uploadImg($url){
        // 永久素材
        $material = $this->app->material;
        $result = $material->uploadImage($url);
        return $result;
    }
    /**
     * @param $article
     * @return array
     * 上传永久图文素材
     */
    public function uploadArticle($article){
        $article = new Article($article);
        $material = $this->app->material;
        $media_id=$material->uploadArticle($article);
        return ['media_id'=>$media_id['media_id']];
    }

    /**
     * @param $media_id
     * @param $article
     * @return array
     * 更新永久图文素材
     */
    public function updateArticle($media_id,$article){
        $material = $this->app->material;
        $result = $material->updateArticle($media_id,$article);
        return ['errcode'=>$result['errcode']];
    }
    /**
     * 生成临时二维码
     */
    public function createQrcode($scene_id){
        $qrcode = $this->app->qrcode;
        $result=$qrcode->temporary($scene_id, 30 * 24 * 3600);//30天
        $ticket = $result->ticket;
        $url = $result->url;
        $urls = $qrcode->url($ticket);//临时二维码网址
        return ['ticket'=>$ticket,'url'=>$url,'urls'=>$urls];
    }
}