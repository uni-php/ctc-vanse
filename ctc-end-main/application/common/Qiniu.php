<?php
/**
 * Created by PhpStorm.
 * User: wenhan
 * Date: 2021/11/20
 * Time: 下午11:28
 */

namespace app\common;
use think\facade\Env;
use Qiniu\Auth as Auth;
use think\Db;
use think\Request;
require_once Env::get('vendor_path'). 'qiniu/autoload.php';  //引入自动加载类
use Qiniu\Storage\UploadManager;
use think\Controller; //实例化上传类

class Qiniu extends Controller
{
    //七牛统一上传方法
    public function uploadImg($file){
        $filePath = $file->getRealPath();
        $ext = pathinfo($file->getInfo('name'), PATHINFO_EXTENSION);  //后缀
        // 上传到七牛后保存的文件名
        $key = substr(md5($file->getRealPath()), 0, 5) . date('YmdHis') . rand(0, 9999) . '.' . $ext;
        // 需要填写你的 Access Key 和 Secret Key
        // 构建鉴权对象
        $accessKey = config("qiniu")["accessKey"];
        $secretKey = config("qiniu")["secretKey"];
        $auth = new Auth($accessKey, $secretKey);
        // 要上传的空间
        $bucket = config("qiniu")["bucket"];
        //域名
        $domain = config("qiniu")["domain"];
        $token = $auth->uploadToken($bucket);
        // 初始化 UploadManager 对象并进行文件的上传
        $uploadMgr = new UploadManager();
        // 调用 UploadManager 的 putFile 方法进行文件的上传
        list($ret, $err) = $uploadMgr->putFile($token, $key, $filePath);
        if ($err !== null) {
            return ["err" => 1, "msg" => $err, "data" => ""];
        } else {
            $imgPath ='http://'. $domain . '/' . $key;
            return ['imgPath'=>$imgPath,'key'=>$key];
        }
    }

}