<?php
/**
 * Created by PhpStorm.
 * User: wenhan
 * Date: 2021/11/18
 * Time: 下午5:51
 */

namespace app\dealer\controller\access;
use app\Request;
use think\Controller;
use think\Db;
use app\dealer\controller\wechat\Base;
use app\dealer\controller\wechat\Open;

class Material extends Controller
{
    protected $dealer_id;
    public function initialize(){
        $userInfo=Request::userInfo();
        $this->dealer_id=array_key_exists('dealer_id',$userInfo)?$userInfo['dealer_id']:$userInfo['id'];
    }
    public function getGroupList(Request $request){
        $list=Db::name('dealer_material_group')
            ->where('dealer_id',$this->dealer_id)
            ->select();
        $res=[
            'code'=>200,
            'msg'=>'查询成功',
            'data'=>$list,
        ];
        return json($res);
    }
    public function queryGroup(Request $request){
        $res=Db::name('dealer_material_group')
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
        $res=Db::name('dealer_material_group')->delete($request->param('id'));
        if($res){
            $info=[
                'code'=>200,
                'msg'=>'删除成功',
            ];
        }else{
            $info=[
                'code'=>201,
                'msg'=>'系统异常',
            ];
        }
        return json($info);
    }
    public function saveGroup(Request $request){
        $data=$request->post();
        $data['dealer_id']=$this->dealer_id;
        if(array_key_exists('id',$data)){
            $res=Db::name('dealer_material_group')->update($data);
        }else{
            $res=Db::name('dealer_material_group')->insert($data);
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
    public function uploadImgMaterial(Request $request){
        $data=$request->post();
        $img_url=config('public_dir').'mainImgs/'.$data['img_url'];//绝对地址
        $auth_info=Db::name('wxopen_authorization_info')->where('dealer_id',$this->dealer_id)->find();
        $wechat=new Open($auth_info['authorizer_appid'],$auth_info['authorizer_refresh_token']);
        $data['media_id']=$wechat->uploadImg($img_url)['media_id'];
        $data['dealer_id']=$this->dealer_id;
        $res=Db::name('dealer_img_material')
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
    public function getImgMaterial(Request $request){
        $params=$request->get();
        if($params['group_id']==0){
            $list=Db::name('dealer_img_material')
                ->where('dealer_id',$this->dealer_id)
                ->page($params['pageNum'])
                ->limit($params['pageSize'])
                ->select();
            $total=Db::name('dealer_img_material')
                ->where('dealer_id',$this->dealer_id)
                ->count();
        }else{
            $list=Db::name('dealer_img_material')
                ->where('dealer_id',$this->dealer_id)
                ->where('material_group',$params['group_id'])
                ->page($params['pageNum'])
                ->limit($params['pageSize'])
                ->select();
            $total=Db::name('dealer_img_material')
                ->where('dealer_id',$this->dealer_id)
                ->where('material_group',$params['group_id'])
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
    public function saveArticle(Request $request){
        $data=$request->post();
        $auth_info=Db::name('wxopen_authorization_info')->where('dealer_id',$this->dealer_id)->find();
        $wechat=new Open($auth_info['authorizer_appid'],$auth_info['authorizer_refresh_token']);
        $article=[
          'title'=>$data['title'],
          'thumb_media_id'=>$data['thumb_media_id'],
          'author'=>$data['author'],
          'digest'=>$data['digest'],
          'content'=>$data['content']
        ];
        if(array_key_exists('media_id',$data)){
            //更新图文
            $article['media_id']=$data['media_id'];
            $result=$wechat->updateArticle($data['media_id'],$article);
            if($result['errcode']==0){
                $res=Db::name('dealer_material_article')->update($data);
            }else{
                $info=[
                    'code'=>201,
                    'msg'=>'更新失败'
                ];
                return json($info);
            }
        }else{
            $data['media_id']=$wechat->uploadArticle($article)['media_id'];
            $data['dealer_id']=$this->dealer_id;
            $res=Db::name('dealer_material_article')->insert($data);
        }
        if($res||$res==0){
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
    public function getArticleList(Request $request){
        $params=$request->get();
        $list=Db::name('dealer_material_article')
            ->where('dealer_id',$this->dealer_id)
            ->where('is_del',0)
            ->page($params['pageNum'])
            ->limit($params['pageSize'])
            ->select();
        $total=Db::name('dealer_material_article')
            ->where('is_del',0)
            ->where('dealer_id',$this->dealer_id)
            ->count();
        $res=[
            'code'=>200,
            'msg'=>'查询成功',
            'data'=>$list,
            'total'=>$total
        ];
        return json($res);
    }
    public function deleArticle(Request $request){
        $wechat=new Base();
        $params=$request->get();
        $res=Db::name('dealer_material_article')
            ->where('id',$params['id'])
            ->update([
               'is_del'=>1
            ]);
        if($res){
            $wechat->deleteArticle($params['media_id']);
            $info=[
                'code'=>200,
                'msg'=>'删除成功',
            ];
        }else{
            $info=[
                'code'=>201,
                'msg'=>'系统异常',
            ];
        }
        return json($info);
    }
    public function getArticleInfo(Request $request){
        $info=Db::name('dealer_material_article')
            ->where('id',$request->param('id'))
            ->find();
        $res=[
            'code'=>200,
            'msg'=>'查询成功',
            'data'=>$info
        ];
        return json($res);
    }
}