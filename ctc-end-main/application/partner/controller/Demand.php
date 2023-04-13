<?php
/**
 * Created by PhpStorm.
 * Role: wenhan
 * Date: 2021/10/22
 * Time: 上午12:47
 */

namespace app\partner\controller;
use think\Controller;
use think\Db;
use app\common\ImgUpload;
use app\Request;


class Demand extends Controller
{
    public function getAllModule(Request $request){
        $list=Db::name('product_module')
            ->select();
        $res=[
            'code'=>200,
            'msg'=>'查询成功',
            'data'=>$list,
        ];
        return json($res);
    }
    public function getDemands(Request $request){
        $params=$request->get();
        $partner_id=$request->userInfo()['id'];//合伙人id
        if($params['beginTime']){
            $list=Db::name('demand')
                ->alias('a')
                ->join('product_module b','a.module_id=b.id')
                ->join('dealer d','a.dealer_id=d.id')
                ->where('a.title','like','%'.$params['title'].'%')
                ->where('a.priority','like','%'.$params['priority'].'%')
                ->where('a.module_id','like','%'.$params['module'].'%')
                ->where('a.status','like','%'.$params['status'].'%')
                ->where('a.partner_id',$partner_id)
                ->where('a.create_time', 'between time', [$params['beginTime'],$params['endTime']])
                ->where('d.dealer_name','like','%'.$params['dealer_name'].'%')
                ->field('a.*,b.module_name,d.dealer_name')
                ->page($params['pageNum'])
                ->limit($params['pageSize'])
                ->select();
            $total=Db::name('demand')
                ->alias('a')
                ->join('product_module b','a.module_id=b.id')
                ->join('dealer d','a.dealer_id=d.id')
                ->where('a.title','like','%'.$params['title'].'%')
                ->where('a.priority','like','%'.$params['priority'].'%')
                ->where('a.module_id','like','%'.$params['module'].'%')
                ->where('a.status','like','%'.$params['status'].'%')
                ->where('a.create_time', 'between time', [$params['beginTime'],$params['endTime']])
                ->where('a.partner_id',$partner_id)
                ->where('d.dealer_name','like','%'.$params['dealer_name'].'%')
                ->count();

        }else{
            $list=Db::name('demand')
                ->alias('a')
                ->join('product_module b','a.module_id=b.id')
                ->join('dealer d','a.dealer_id=d.id')
                ->where('a.title','like','%'.$params['title'].'%')
                ->where('a.priority','like','%'.$params['priority'].'%')
                ->where('a.module_id','like','%'.$params['module'].'%')
                ->where('a.status','like','%'.$params['status'].'%')
                ->where('a.partner_id',$partner_id)
                ->where('d.dealer_name','like','%'.$params['dealer_name'].'%')
                ->field('a.*,b.module_name,d.dealer_name')
                ->page($params['pageNum'])
                ->limit($params['pageSize'])
                ->select();
            $total=Db::name('demand')
                ->alias('a')
                ->join('product_module b','a.module_id=b.id')
                ->join('dealer d','a.dealer_id=d.id')
                ->where('a.title','like','%'.$params['title'].'%')
                ->where('a.priority','like','%'.$params['priority'].'%')
                ->where('a.module_id','like','%'.$params['module'].'%')
                ->where('a.status','like','%'.$params['status'].'%')
                ->where('a.partner_id',$partner_id)
                ->where('d.dealer_name','like','%'.$params['dealer_name'].'%')
                ->count();
        }
        $info=[
            'code'=>200,
            'msg'=>'查询成功',
            'data'=>$list,
            'total'=>$total
        ];
        return json($info);
    }
    //查询品牌商
    public function getDealer(Request $request){
        $params=$request->get();
        $partner_id=$request->userInfo()['id'];//合伙人id
        $list=Db::name('dealer')
            ->where('dealer_name','like','%'.$params['dealer_name'].'%')
            ->where('account','like','%'.$params['account'].'%')
            ->where('partner_id',$partner_id)
            ->page($params['pageNum'])
            ->limit($params['pageSize'])
            ->select();
        $total=Db::name('dealer')
            ->where('dealer_name','like','%'.$params['dealer_name'].'%')
            ->where('account','like','%'.$params['account'].'%')
            ->where('partner_id',$partner_id)
            ->count();
        $info=[
            'code'=>200,
            'msg'=>'查询成功',
            'data'=>$list,
            'total'=>$total
        ];
        return json($info);
    }
    public function addDemands(Request $request){
        $data=$request->post();
        $res=Db::name('demand')
            ->insert($data);
        if($res){
            $info=[
                'code'=>200,
                'msg'=>'提交成功'
            ];
        }else{
            $info=[
                'code'=>201,
                'msg'=>'系统异常'
            ];
        }
        return json($info);
    }
    //上传图片
    public function uploadImg(Request $request){
        $fileName=$request->file('img');
        $upload=new ImgUpload();
        $url=$upload->addImg($fileName);
        if($url){
            $info=[
              'url'=>$url,
              'code'=>200,
              'msg'=>'上传成功'
            ];
        }else{
            $info=[
                'code'=>201,
                'msg'=>'上传失败'
            ];
        }
        return json($info);
    }
    //上传附件
    public function uploadFile(Request $request){
        $fileName=$request->file('file');
        $upload=new ImgUpload();
        $url=$upload->addFile($fileName);
        return $url;
    }
}