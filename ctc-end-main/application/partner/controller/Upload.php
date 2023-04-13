<?php
/**
 * Created by PhpStorm.
 * User: wenhan
 * Date: 2022/4/11
 * Time: 下午3:41
 */

namespace app\partner\controller;
use think\Controller;
use think\Db;
use app\Request;
use app\common\ImgUpload;
use app\common\Qiniu;

class Upload extends Controller
{
    /**
     * @param Request $request
     * @return \think\response\Json
     * 七牛云存储
     */
    public function uploadImg(Request $request){
        $Qiniu=new Qiniu();
        $file = request()->file('file');
        $res=$Qiniu->uploadImg($file);
        return json([
            'filePath'=>$res['imgPath'],
            'key'=>$res['key']
        ]);
    }
}