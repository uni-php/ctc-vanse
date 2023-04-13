<?php
/**
 * Created by PhpStorm.
 * User: wenhan
 * Date: 2021/11/20
 * Time: 下午6:34
 */

namespace app\dealer\controller\assets;
use app\Request;
use think\Controller;
use app\common\Qiniu;
use think\Db;

class Material extends Controller
{
    protected $dealer_id;
    public function initialize(){
        $userInfo=Request::userInfo();
        $this->dealer_id=array_key_exists('dealer_id',$userInfo)?$userInfo['dealer_id']:$userInfo['id'];
    }
    public function getImgMaterial(Request $request){
        $params=$request->get();
        if(strlen($params['img_group'])==1&&empty($params['img_group'])){
            //未分组
            $list=Db::name('dealer_img_library')
                ->alias('a')
                ->leftJoin('dealer_library_type b','a.img_group=b.id')
                ->where('a.img_name','like','%'.$params['img_name'].'%')
                ->where('a.dealer_id',$this->dealer_id)
                ->where('b.is_del',1)
                ->order('a.create_time','desc')
                ->page($params['pageNum'])
                ->field('a.*')
                ->limit($params['pageSize'])
                ->select();
            $total=Db::name('dealer_img_library')
                ->alias('a')
                ->leftJoin('dealer_library_type b','a.img_group=b.id')
                ->where('a.img_name','like','%'.$params['img_name'].'%')
                ->where('a.dealer_id',$this->dealer_id)
                ->order('a.create_time','desc')
                ->where('b.is_del',1)
                ->count();
        }else{
            $list=Db::name('dealer_img_library')
                ->alias('a')
                ->leftJoin('dealer_library_type b','a.img_group=b.id')
                ->where('a.img_name','like','%'.$params['img_name'].'%')
                ->where('a.img_group',$params['img_group']?$params['img_group']:'not null')
                ->where('a.dealer_id',$this->dealer_id)
                ->order('a.create_time','desc')
                ->field('a.*')
                ->page($params['pageNum'])
                ->limit($params['pageSize'])
                ->select();
            $total=Db::name('dealer_img_library')
                ->alias('a')
                ->leftJoin('dealer_library_type b','a.img_group=b.id')
                ->where('a.img_name','like','%'.$params['img_name'].'%')
                ->where('a.dealer_id',$this->dealer_id)
                ->order('a.create_time','desc')
                ->where('a.img_group',$params['img_group']?$params['img_group']:'not null')
                ->count();
        }
        $res=[
            'code'=>200,
            'msg'=>'查询成功',
            'data'=>$list,
            'total'=>$total
        ];
        return json($res);
    }

    /**
     * @param Request $request
     * @return array|string
     * 素材库图片上传七牛云
     */
    public function uploadImg(Request $request){
        $Qiniu=new Qiniu();
        $file = request()->file('img');
        $res=$Qiniu->uploadImg($file);
        return json([
            'imgPath'=>$res['imgPath'],
            'key'=>$res['key']
        ]);
    }
    public function uploadImgMaterial(Request $request){
        $data=$request->post();
        $data['dealer_id']=$this->dealer_id;
        $res=Db::name('dealer_img_library')
            ->insert($data);
        if($res){
            $info=[
                'code'=>200,
                'msg'=>'上传成功'
            ];
        }else{
            $info=[
                'code'=>201,
                'msg'=>'系统异常'
            ];
        }
        return json($info);
    }
    public function deleImg(Request $request){
        $res=Db::name('dealer_img_library')->delete($request->param('id'));
        if($res){
            $info=[
                'code'=>200,
                'msg'=>'删除成功'
            ];
        }else{
            $info=[
                'code'=>201,
                'msg'=>'系统异常'
            ];
        }
        return json($info);
    }
    public function changeGroup(Request $request){
        $data=$request->post();
        $res=Db::name('dealer_img_library')->update($data);
        if($res||$res==0){
            $info=[
                'code'=>200,
                'msg'=>'修改成功'
            ];
        }else{
            $info=[
                'code'=>201,
                'msg'=>'系统异常'
            ];
        }
        return json($info);
    }
    public function getGroupList(Request $request){
        $params=$request->get();
        $list=Db::name('dealer_library_type')
            ->where('dealer_id',$this->dealer_id)
            ->page($params['pageNum'])
            ->where('is_del','<>',1)
            ->limit($params['pageSize'])
            ->order('create_time','desc')
            ->select();
        $total=Db::name('dealer_library_type')
            ->where('dealer_id',$this->dealer_id)
            ->count();
        $res=[
            'code'=>200,
            'msg'=>'查询成功',
            'total'=>$total,
            'data'=>$list,
        ];
        return json($res);
    }
    public function queryGroup(Request $request){
        $res=Db::name('dealer_library_type')
            ->where('id',$request->param('id'))
            ->find();
        $res=[
            'code'=>200,
            'msg'=>'查询成功',
            'data'=>$res
        ];
        return json($res);
    }
    public function deleGroup(Request $request){
        Db::startTrans();//开启事务
        try{
            $res=Db::name('dealer_library_type')->where('id',$request->param('id'))->update(['is_del'=>1]);
            if($res){
                $info=[
                    'code'=>200,
                    'msg'=>'删除成功'
                ];
            }
            Db::commit();
        }catch (\Exception $e){
            Db::rollback();
            $info=[
                'code'=>201,
                'msg'=>'请联系管理员'
            ];
        }
        return json($info);
    }
    public function saveGroup(Request $request){
        $data=$request->post();
        $data['dealer_id']=$this->dealer_id;
        if(array_key_exists('id',$data)){
            $res=Db::name('dealer_library_type')->update($data);
        }else{
            $res=Db::name('dealer_library_type')->insert($data);
        }
        if($res||$res==0){
            $info=[
                'code'=>200,
                'msg'=>'更新成功'
            ];
        }else{
            $info=[
                'code'=>201,
                'msg'=>'系统异常'
            ];
        }
        return json($info);
    }
}