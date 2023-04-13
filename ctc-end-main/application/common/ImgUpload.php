<?php
/**
 * Created by PhpStorm.
 * Role: wenhan
 * Date: 2021/10/8
 * Time: 上午11:27
 */

namespace app\common;
use think\Controller;
use think\Request;
use think\Db;
use think\facade\Env;

class ImgUpload
{
    public function addImg($file){
        if($file){
            $info = $file->validate(['size'=>52428800,'ext'=>'jpg,png,gif,jpeg'])->move(config('public_dir') . 'mainImgs');
            if($info){
                $pic_name= $info->getSaveName();
            }
        }
        return $pic_name;
    }
    public function addIco($file){
        if($file){
            $info = $file->validate(['size'=>52428800,'ext'=>'ico'])->move(config('public_dir') . 'mainImgs');
            if($info){
                $pic_name= $info->getSaveName();
            }
        }
        return $pic_name;
    }
    //上传附件
    public function addFile($file){
        if($file){
            $info = $file->validate(['size'=>52428800,'ext'=>'jpg,jpeg,png,doc,docx,xls,xlsx,ppt,pptx,txt,pdf'])->move(config('public_dir') . 'mainImgs');
            if($info){
                $pic_name= $info->getSaveName();
            }
        }
        return $pic_name;
    }
    //上传支付证书信息
    public function addPay($file){
        if($file){
            $info = $file->validate(['size'=>52428800,'ext'=>'pem'])->move(config('public_dir') . 'cert');
            if($info){
                $pic_name= $info->getSaveName();
            }
        }
        return $pic_name;
    }
}