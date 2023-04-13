<?php
/**
 * Created by PhpStorm.
 * Role: wenhan
 * Date: 2021/11/13
 * Time: 下午2:47
 */

namespace app\dealer\controller;
use think\Controller;
use think\Db;
use app\Request;
use app\common\ImgUpload;
use app\common\Qiniu;

class Upload extends Controller
{
    public function uploadLogo(Request $request){
        $Qiniu=new Qiniu();
        $file = request()->file('img');
        $res=$Qiniu->uploadImg($file);
        return json([
            'filePath'=>$res['imgPath'],
            'key'=>$res['key']
        ]);
    }
    //上传营业执照与商标证书
    public function uploadLicense(Request $request){
        $Qiniu=new Qiniu();
        $file = request()->file('img');
        $res=$Qiniu->uploadImg($file);
        return json([
            'filePath'=>$res['imgPath'],
            'key'=>$res['key']
        ]);
    }
    //上传支付证书与秘钥
    public function uploadKey(Request $request){
        $fileName=$request->file('key');
        $upload=new ImgUpload();
        $url=$upload->addPay($fileName);
        return $url;
    }
    public function uploadCert(Request $request){
        $fileName=$request->file('cert');
        $upload=new ImgUpload();
        $url=$upload->addPay($fileName);
        return $url;
    }
    //上传图片素材
    public function uploadImgMaterial(Request $request){
        $Qiniu=new Qiniu();
        $file=$request->file('img');
        $res=$Qiniu->uploadImg($file);
        return json([
            'filePath'=>$res['imgPath'],
            'key'=>$res['key']
        ]);
    }
    //批量导入
    public function uploadFile(Request $request){
        $Qiniu=new Qiniu();
        $file = request()->file('file');
        $res=$Qiniu->uploadImg($file);
        return json([
            'filePath'=>$res['imgPath'],
            'key'=>$res['key']
        ]);
    }
}