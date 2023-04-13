<?php
/**
 * Created by PhpStorm.
 * User: wenhan
 * Date: 2022/3/14
 * Time: 下午9:50
 */

namespace app\lib\wxMsgCrypt;
include_once "wxBizMsgCrypt.php";
use think\Controller;
use think\Log;
class Sample extends Controller
{
    private $encodingAesKey;
    private $token;
    private $appId;
    private $component_appsecret;
    public function initialize()
    {
        $this->encodingAesKey='fdoi9435i3o5io43u5i43o5uio4u35i4u35iu43iu54';
        $this->token='rekjr34985r4rhfjewrjewrjk';
        $this->appId='wxb69be9ce11dbfbb6';//第三方平台appid
        $this->component_appsecret='391f68f2753fe9f1f88ad68a19a15179';//第三方平台secret
    }

    /**
     * @param string $msg
     * 解密
     */
    public function decryptMsg($msg='',$timeStamp,$nonce,$msg_signature){
        $pc = new \WXBizMsgCrypt($this->token, $this->encodingAesKey, $this->appId,$this->component_appsecret);
        $from_xml = $msg;
        $from_xml = str_replace('AppId', 'ToUserName', $from_xml);
        // 第三方收到公众号平台发送的消息
        $arr = [];
        $msg = '';
        $errCode = $pc->decryptMsg($msg_signature, $timeStamp, $nonce, $from_xml, $msg);
        trace($msg,'error');
        if ($errCode == 0) {
//            print("解密后: " . $msg . "\n");
            //日志记录
            $xml = new \DOMDocument();
            $xml->loadXML($msg);
            $array_e = $xml->getElementsByTagName('ComponentVerifyTicket');
            $component_verify_ticket = $array_e->item(0)->nodeValue;
            $wechat_verifyticket = [
                'component_verify_ticket'   => $component_verify_ticket,
                'uptime'                    => time()
            ];
            return $wechat_verifyticket;
        } else {
//            print($errCode . "\n");
            return $errCode;
        }
    }
    /**
     * @param string $msg
     * 用户发送给公众号/小程序的消息解密
     */
    public function decryptCommonMsg($msg='',$timeStamp,$nonce,$msg_signature){
        $pc = new \WXBizMsgCrypt($this->token, $this->encodingAesKey, $this->appId,$this->component_appsecret);
        $from_xml = $msg;
        $from_xml = str_replace('AppId', 'ToUserName', $from_xml);
        // 第三方收到公众号平台发送的消息
        $arr = [];
        $msg = '';
        $errCode = $pc->decryptMsg($msg_signature, $timeStamp, $nonce, $from_xml, $msg);
        if ($errCode == 0) {
            $msg=simplexml_load_string($msg,'SimpleXMLElement',LIBXML_NOCDATA);
            return $msg;
        } else {
//            print($errCode . "\n");
            return $errCode;
        }
    }

    /**
     * 回复文本
     */
    public function responseText($postObj,$content){
        $template ="<xml>
          <ToUserName><![CDATA[%s]]></ToUserName>
          <FromUserName><![CDATA[%s]]></FromUserName>
          <CreateTime>%s</CreateTime>
          <MsgType><![CDATA[%s]]></MsgType>
          <Content><![CDATA[%s]]></Content>
        </xml>";
        $fromUser = $postObj ->ToUserName;
        $toUser = $postObj -> FromUserName;
        $time = time();
        $msgType = 'text';
        $res =sprintf($template,$toUser,$fromUser,$time,$msgType,$content);
        $pc = new \WXBizMsgCrypt ($this->token, $this->encodingAesKey, $this->appId,$this->component_appsecret );
        $encryptMsg = '';
        $errCode =$pc->encryptMsg($res,$_GET ['timestamp'], $_GET ['nonce'], $encryptMsg);
        if($errCode ==0){
            $res = $encryptMsg;
        }
        echo $res;
    }

    /**
     * 获取令牌
     */
    public function getComponentAccessToken(){
        $pc = new \WXBizMsgCrypt($this->token, $this->encodingAesKey, $this->appId,$this->component_appsecret);
        $res=$pc->getComponentAccessToken();
        return $res;
    }
}