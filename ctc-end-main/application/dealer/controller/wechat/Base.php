<?php
/**
 * Created by PhpStorm.
 * User: wenhan
 * Date: 2021/11/17
 * Time: 上午11:55
 */

namespace app\dealer\controller\wechat;
use app\Request;
use think\Controller;
use think\Db;
use think\facade\Env;
use EasyWeChat\Foundation\Application;
use EasyWeChat\Message\Article;

class Base extends Controller
{
    public function __construct()
    {
        parent::__construct();
        $options = config('wechat');
        $this->app = new Application($options);
    }
    /**
     * @throws
     * 服务端验证
     */
    public function index(){
        //消息处理
        $server=$this->app->server;
        $server->setMessageHandler(function ($message) {
            switch ($message['MsgType']) {
                case 'event':
                    $returnInfo = $this->eventHandler($message['Event'],$message['EventKey'],$message['FromUserName']);
                    return $returnInfo;
                    break;
                case 'text':
                    return '实时拉你';
                    break;
                default:
                    return '收到其它消息';
                    break;
            }
        });
        $response = $this->app->server->serve();
        $response->send();
    }

    /**
     * @param $messageEvent,$messageEventKey,$fromUserName
     * @return string
     */
    private function eventHandler($messageEvent,$messageEventKey,$fromUserName)
    {
        switch ($messageEvent) {
            case 'subscribe':
                return $this->getReplyWords($messageEventKey,$fromUserName);
                break;
            case 'SCAN':
                return $this->getReplyWords($messageEventKey,$fromUserName);
                break;
            default:
                return 'event 事件' . $messageEvent;
                break;
        }
    }

    /**
     * @param $id
     * @param $fromUserName
     * @return mixed|string
     */
    public function getReplyWords($id,$fromUserName){
        if(!$id) return '欢迎订阅';
        //打标签
        $res=Db::name('dealer_params_qrcode')
            ->where('id',$id)
            ->find();
        if($res['status']==1){
            $tagIds=explode(',',$res['tags']);
            $openIds = [$fromUserName];
            $tag = $this->app->user_tag; // $user['user_tag']
            foreach ($tagIds as $key=>$value){
                $tag->batchTagUsers($openIds, $value);
            }
            return $res['reply'];
        }else{
            return '欢迎订阅';
        }
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
     * 获取用户标签列表
     */
    public function getUserTags(){
        $tag = $this->app->user_tag; // $user['user_tag']
        $tags=$tag->lists();
        return $tags->tags;
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
     * @param $media_id
     * @return array
     * 删除永久图文素材
     */
    public function deleteArticle($media_id){
        $material = $this->app->material;
        $result=$material->delete($media_id);
        return ['errcode'=>$result['errcode']];
    }
}