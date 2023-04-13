<?php
/**
 * Created by PhpStorm.
 * User: wenhan
 * Date: 2022/3/14
 * Time: 下午11:52
 */

namespace app\wxopen\controller;
use app\common\JsonService;
use app\Request;
use think\Controller;
use app\dealer\controller\wechat\Open;
use app\wxopen\controller\Verify;
use app\lib\wxMsgCrypt\Sample;
use think\Db;
use think\facade\Hook;

class Message extends Controller
{
    /**
     * @param  string  $appid 数据名称
     * @return mixed
     * @route('message/:appid')
     */
    public function message($appid)
    {
        $timestamp=$_GET['timestamp'];
        $nonce=$_GET['nonce'];
        $msg_signature=$_GET['msg_signature'];
        $msg=file_get_contents("php://input");
        $decrypt=new Sample();
        $msg=$decrypt->decryptCommonMsg($msg,$timestamp,$nonce,$msg_signature);
        switch (strtolower($msg -> MsgType)) {
            case 'event':
                $returnInfo = $this->eventHandler($msg->Event,$msg->EventKey,$msg->FromUserName,$appid,$msg);
                return $returnInfo;
                break;
            case 'text':
                return $decrypt->responseText($msg,'实时拉你');
                break;
            default:
                return '收到其它消息';
                break;
        }
    }
    /**
     * @param $messageEvent,$messageEventKey,$fromUserName
     * @return string
     */
    private function eventHandler($messageEvent,$messageEventKey,$fromUserName,$appid,$msg)
    {
        switch ($messageEvent) {
            case 'subscribe':
                return $this->getReplyWords($messageEventKey,$fromUserName,$appid);
                break;
            case 'SCAN':
                return $this->getReplyWords($messageEventKey,$fromUserName,$appid,$msg);
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
    public function getReplyWords($id,$fromUserName,$appid,$msg){
        if(!$id) return '欢迎订阅';
        $auth_info=Db::name('wxopen_authorization_info')->where('authorizer_appid',$appid)->find();
        $wechat=new Open($auth_info['authorizer_appid'],$auth_info['authorizer_refresh_token']);
        $decrypt=new Sample();
        //打标签
        $res=Db::name('dealer_params_qrcode')
            ->where('id',$id)
            ->find();
        if($res['status']==1){
            $tagIds=explode(',',$res['tags']);
            $openIds = json_decode(json_encode($fromUserName),true);
            $tag = $wechat->app->user_tag; // $user['user_tag']
            foreach ($tagIds as $key=>$value){
                $tag->batchTagUsers($openIds, $value);
                $user=Db::name('dealer_member')->where('openid',$openIds[0])->find();
                if($user&&$user['tags']){
                    if(!in_array($value,explode(',',$user['tags']))){
                        Db::name('dealer_member')->where('openid',$openIds[0])->update([
                            'tags'=>$user['tags'].','.$value
                        ]);
                    }
                }else if($user) {
                    Db::name('dealer_member')->where('openid',$openIds[0])->update([
                        'tags'=>$value
                    ]);
                }

            }
            return $decrypt->responseText($msg,$res['reply']);
        }else{
            return '欢迎订阅';
        }
    }
}