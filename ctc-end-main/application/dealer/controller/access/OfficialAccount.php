<?php
/**
 * Created by PhpStorm.
 * User: wenhan
 * Date: 2021/11/17
 * Time: 下午5:14
 */

namespace app\dealer\controller\access;
use app\common\JsonService;
use app\Request;
use think\Controller;
use think\Db;
use app\dealer\controller\wechat\Base;
use app\dealer\controller\wechat\Open;
use think\facade\Hook;
use app\wxopen\controller\Verify;
use app\dealer\controller\wechat\Wechat;

class OfficialAccount extends Controller
{
    protected $dealer_id;
    public function initialize(){
        $userInfo=Request::userInfo();
        $this->dealer_id=array_key_exists('dealer_id',$userInfo)?$userInfo['dealer_id']:$userInfo['id'];
    }

    /**
     * @param Request $request
     * @throws \think\db\exception\DataNotFoundException
     * @throws \think\db\exception\ModelNotFoundException
     * @throws \think\exception\DbException
     * 主库查询授权信息
     * 未授权生成授权码
     * 已授权返回授权信息
     */
    public function getAuthConfig(Request $request){
        $is_auth=Db::name('wxopen_authorization_info')
            ->where('dealer_id',$this->dealer_id)
            ->find();
        $Verify=new Verify();
        if($is_auth){
            //返回授权信息
            $data=[
              'create_time'=>$is_auth['create_time'],
              'auth_info'=>$Verify->getAuthorizerAccountInfo($is_auth['authorizer_appid'])['authorizer_info'],
              'auth_url'=>null
            ];
        }else{
            //返回授权链接
            $data=[
                'create_time'=>null,
                'auth_info'=>null,
                'auth_url'=>$Verify->qrCode()
            ];
        }
        return JsonService::successful('查询成功',$data);
    }
    public function saveAuthInfo(Request $request){
        $Verify=new Verify();
        $auth_code=$request->param('auth_code');
        $dealer_id=$this->dealer_id;
        $res=$Verify->saveAuthorizerInfo($auth_code,$dealer_id);
        if($res||$res==1){
            return JsonService::successful('保存成功');
        }else{
            return JsonService::fail('请联系管理员');
        }
    }
    public function saveAuthConfig(Request $request){
        $data=$request->post();
        if(array_key_exists('id',$data)){
            $res=Db::name('dealer_weixin_config')
                ->update($data);
        }else{
            $data['dealer_id']=$this->dealer_id;
            $res=Db::name('dealer_weixin_config')
                ->insert($data);
        }
        if($res||$res==0){
            return JsonService::successful('保存成功');
        }else{
           return JsonService::fail('系统异常');
        }
    }
    public function getQRCodeList(Request $request){
        $params=$request->get();
        $condition=[];
        if($params['status']){
            if($params['status']==3){
                $thirty_day = date('Y-m-d',strtotime("-30 day"));//30天以前的日期
                $condition['a.create_time']=['<time',$thirty_day];
            }else{
                $condition['a.status']=$params['status'];
            }
        }
        if($params['qr_type']){
            $condition['a.qr_type']=$params['qr_type'];
        }
        if(count($condition)>0){
            $list=Db::name('dealer_params_qrcode')
                ->alias('a')
                ->join('dealer_qrcode_type b','a.qr_type=b.id')
                ->where('a.qr_name','like','%'.$params['qr_name'].'%')
                ->where($condition)
                ->where('a.dealer_id',$this->dealer_id)
                ->page($params['pageNum'])
                ->order('create_time','desc')
                ->field('a.*,b.type_name')
                ->limit($params['pageSize'])
                ->select();
            $total=Db::name('dealer_params_qrcode')
                ->alias('a')
                ->join('dealer_qrcode_type b','a.qr_type=b.id')
                ->where('a.qr_name','like','%'.$params['qr_name'].'%')
                ->where('a.dealer_id',$this->dealer_id)
                ->where($condition)
                ->count();
        }else{
            $list=Db::name('dealer_params_qrcode')
                ->alias('a')
                ->join('dealer_qrcode_type b','a.qr_type=b.id')
                ->where('a.qr_name','like','%'.$params['qr_name'].'%')
                ->where('a.dealer_id',$this->dealer_id)
                ->page($params['pageNum'])
                ->order('create_time','desc')
                ->field('a.*,b.type_name')
                ->limit($params['pageSize'])
                ->select();
            $total=Db::name('dealer_params_qrcode')
                ->alias('a')
                ->join('dealer_qrcode_type b','a.qr_type=b.id')
                ->where('a.qr_name','like','%'.$params['qr_name'].'%')
                ->where('a.dealer_id',$this->dealer_id)
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
    public function changeQRcodeStatus(Request $request){
        $data=$request->get();
        $code=Db::name('dealer_params_qrcode')
            ->update($data);
        if($code){
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
    public function queryQRCode(Request $request){
        $id=$request->param('id');
        $res=Db::name('dealer_params_qrcode')
            ->where('id',$id)
            ->find();
        $info=[
            'code'=>200,
            'msg'=>'查询成功',
            'data'=>$res
        ];
        return json($info);
    }
    //删除二维码
    public function deleQRCode(Request $request){
        $res=Db::name('dealer_params_qrcode')->delete($request->param('id'));
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
    //保存二维码
    public function saveQRCode(Request $request){
        $data=$request->post();
        if(array_key_exists('id',$data)){
            $res=Db::name('dealer_params_qrcode')->update($data);
        }else{
            $data['dealer_id']=$this->dealer_id;
            //以自增主键作为scene_id
            $id=Db::name('dealer_params_qrcode')->insertGetId($data);
            $auth_info=Db::name('wxopen_authorization_info')->where('dealer_id',$this->dealer_id)->find();
            $wechat=new Open($auth_info['authorizer_appid'],$auth_info['authorizer_refresh_token']);
            $qrcode=$wechat->createQrcode($id);
            $res=Db::name('dealer_params_qrcode')->where('id',$id)->update([
               'url'=>$qrcode['urls']
            ]);
        }
        if($res||$res==0){
            $info=[
                'code'=>200,
                'msg'=>'保存成功',
            ];
        }else{
            $info=[
                'code'=>201,
                'msg'=>'系统异常',
            ];
        }
        return json($info);
    }
    //获取微信用户标签
    public function getUserTags(){
        $wechat=new Wechat();
        $tags=$wechat->getUserTags();
        if($tags){
            $info=[
                'code'=>200,
                'msg'=>'查询成功',
                'data'=>$tags
            ];
        }else{
            $info=[
                'code'=>201,
                'msg'=>'微信授权失效',
            ];
        }
        return json($info);
    }
    public function getQRCodeType(Request $request){
        $params=$request->get();
        $list=Db::name('dealer_qrcode_type')
            ->page($params['pageNum'])
            ->where('dealer_id',$this->dealer_id)
            ->limit($params['pageSize'])
            ->select();
        $total=Db::name('dealer_qrcode_type')
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
    public function queryQRCodeGroup(Request $request){
        $id=$request->param('id');
        $res=Db::name('dealer_qrcode_type')
            ->where('id',$id)
            ->find();
        $info=[
            'code'=>200,
            'msg'=>'查询成功',
            'data'=>$res
        ];
        return json($info);
    }
    public function saveQRCodeGroup(Request $request){
        $data=$request->post();
        $data['dealer_id']=$this->dealer_id;
        if(array_key_exists('id',$data)){
            $res=Db::name('dealer_qrcode_type')
                ->update($data);
        }else{
            $res=Db::name('dealer_qrcode_type')
                ->insert($data);
        }
        if($res||$res==0){
            $info=[
                'code'=>200,
                'msg'=>'保存成功',
            ];
        }else{
            $info=[
                'code'=>201,
                'msg'=>'系统异常',
            ];
        }
        return json($info);
    }
    public function deleQRCodeGroup(Request $request){
        $id=$request->param('id');
        $has=Db::name('dealer_params_qrcode')
            ->where('qr_type',$id)
            ->find();
        if($has){
            $info=[
              'code'=>201,
              'msg'=>'该分组存在已创建二维码'
            ];
        }else{
            $res=Db::name('dealer_qrcode_type')->delete($id);
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
        }
        return json($info);
    }
}