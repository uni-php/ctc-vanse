<?php
/**
 * Created by PhpStorm.
 * User: wenhan
 * Date: 2021/12/23
 * Time: 下午11:22
 */

namespace app\dealer\controller\customer;
use app\Request;
use think\Controller;
use think\Db;
use app\common\JsonService;
use app\dealer\controller\wechat\Base;
use app\dealer\controller\wechat\Open;
use think\db\Where;

class Member extends Controller
{
    protected $dealer_id;
    public function initialize(){
        $userInfo=Request::userInfo();
        $this->dealer_id=array_key_exists('dealer_id',$userInfo)?$userInfo['dealer_id']:$userInfo['id'];
    }
    public function getMemberList(Request $request){
        $params=$request->get();
        if($params['keyType']==1){
            $condition['nickname']=['like','%'.$params['keywords'].'%'];
        }
        if($params['keyType']==2){
            $condition['id']=['like','%'.$params['keywords'].'%'];
        }
        if($params['keyType']==3){
            $condition['openid']=['like','%'.$params['keywords'].'%'];
        }
        if($params['keyType']==4){
            $condition['phone']= ['like','%'.$params['keywords'].'%'];
        }
        $condition['follow_status']=['like','%'.$params['wechat_status'].'%'];
        $condition['phone_status']=['like','%'.$params['phone_status'].'%'];
        $condition['status']=['like','%'.$params['black_status'].'%'];
        $condition['address']=['like','%'.$params['address'].'%'];
        if($params['startTime']){
            $condition['create_time']=['between time',[$params['startTime'],$params['endTime']]];
        }
        if($params['tag_id']){
            if($params['order']==1||!$params['order']){
                $list=Db::name('dealer_member')
                    ->where(new Where($condition))
                    ->where('dealer_id',$this->dealer_id)
                    ->where('find_in_set(:tag_id,tags)',['tag_id'=>$params['tag_id']])
                    ->page($params['pageNum'])
                    ->limit($params['pageSize'])
                    ->order('create_time')
                    ->select();
            }
            if($params['order']==2)
            {
                $list=Db::name('dealer_member')
                    ->where(new Where($condition))
                    ->where('dealer_id',$this->dealer_id)
                    ->page($params['pageNum'])
                    ->where('find_in_set(:tag_id,tags)',['tag_id'=>$params['tag_id']])
                    ->limit($params['pageSize'])
                    ->order('create_time','desc')
                    ->select();
            }
            if($params['order']==3){
                $list=Db::name('dealer_member')
                    ->where(new Where($condition))
                    ->where('dealer_id',$this->dealer_id)
                    ->where('find_in_set(:tag_id,tags)',['tag_id'=>$params['tag_id']])
                    ->page($params['pageNum'])
                    ->limit($params['pageSize'])
                    ->order('points','desc')
                    ->select();
            }
            $total=Db::name('dealer_member')
                ->where(new Where($condition))
                ->where('find_in_set(:tag_id,tags)',['tag_id'=>$params['tag_id']])
                ->where('dealer_id',$this->dealer_id)
                ->count();

        }else{
            if($params['order']==1||!$params['order']){
                $list=Db::name('dealer_member')
                    ->where(new Where($condition))
                    ->where('dealer_id',$this->dealer_id)
                    ->page($params['pageNum'])
                    ->limit($params['pageSize'])
                    ->order('create_time')
                    ->select();
            }
            if($params['order']==2)
            {
                $list=Db::name('dealer_member')
                    ->where(new Where($condition))
                    ->where('dealer_id',$this->dealer_id)
                    ->page($params['pageNum'])
                    ->limit($params['pageSize'])
                    ->order('create_time','desc')
                    ->select();
            }
            if($params['order']==3){
                $list=Db::name('dealer_member')
                    ->where(new Where($condition))
                    ->where('dealer_id',$this->dealer_id)
                    ->page($params['pageNum'])
                    ->limit($params['pageSize'])
                    ->order('points','desc')
                    ->select();
            }
            $total=Db::name('dealer_member')
                ->where(new Where($condition))
                ->where('dealer_id',$this->dealer_id)
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
    public function saveMemberTag(Request $request){
        $auth_info=Db::name('wxopen_authorization_info')->where('dealer_id',$this->dealer_id)->find();
        $wechat=new Open($auth_info['authorizer_appid'],$auth_info['authorizer_refresh_token']);
        $data=$request->post();
        $data['dealer_id']=$this->dealer_id;
        $has=Db::name('dealer_member_tag')->where('tag_name',trim($data['tag_name']))->find();
        if($has){
            return json([
                'code'=>201,
                'msg'=>'不能和其他标签重名',
            ]);
        }
        Db::startTrans();
        try{
            if(array_key_exists('id',$data)){
                //更新
                $res=$wechat->updateTag($data['wechat_id'],$data['tag_name']);
                if($res['errcode']==0&&$res['errmsg']=='ok'){
                    Db::name('dealer_member_tag')->update($data);
                    $info=[
                        'code'=>200,
                        'msg'=>'修改成功',
                    ];
                }else{
                    $info=[
                        'code'=>201,
                        'msg'=>'请联系管理员'
                    ];
                }
            }else{
                //新增
                $res=$wechat->createTags($data['tag_name']);
                $data['wechat_id']=$res['tag']['id'];
                Db::name('dealer_member_tag')->insert($data);
                $info=[
                    'code'=>200,
                    'msg'=>'创建成功',
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
    public function deleteTag(Request $request){
        $params=$request->get();
        $auth_info=Db::name('wxopen_authorization_info')->where('dealer_id',$this->dealer_id)->find();
        $wechat=new Open($auth_info['authorizer_appid'],$auth_info['authorizer_refresh_token']);
        Db::startTrans();
        try{
            $res=$wechat->deleteTag($params['wechat_id']);
            if($res['errcode']==0&&$res['errmsg']=='ok'){
                Db::name('dealer_member_tag')->delete($params['id']);
                $info=[
                    'code'=>200,
                    'msg'=>'删除成功',
                ];
            }else{
                $info=[
                    'code'=>201,
                    'msg'=>'请联系管理员'
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
    public function queryTagInfo(Request $request){
        $id=$request->param('id');
        $info=Db::name('dealer_member_tag')->where('id',$id)->find();
        return JsonService::successful('查询成功',$info);
    }
    public function getMemberTagList(Request $request){
        $auth_info=Db::name('wxopen_authorization_info')->where('dealer_id',$this->dealer_id)->find();
        $wechat=new Open($auth_info['authorizer_appid'],$auth_info['authorizer_refresh_token']);
        $tags=$wechat->getUserTags();
        $params=$request->get();
        $list=Db::name('dealer_member_tag')
            ->where('tag_name','like','%'.$params['tag_name'].'%')
            ->where('remark','like','%'.$params['remark'].'%')
            ->where('dealer_id',$this->dealer_id)
            ->page($params['pageNum'])
            ->limit($params['pageSize'])
            ->select();
        foreach ($list as $key=>$value){
            foreach ($tags as $k=>$val){
                if($value['wechat_id']==$val['id']){
                    $list[$key]['count']=$val['count'];
                }
            }
        }
        $total=Db::name('dealer_member_tag')
            ->where('tag_name','like','%'.$params['tag_name'].'%')
            ->where('remark','like','%'.$params['remark'].'%')
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

    /**
     * @param Request $request
     * 为客户打标签
     */
    public function batchTagging(Request $request){
        $params=$request->get();
        $auth_info=Db::name('wxopen_authorization_info')->where('dealer_id',$this->dealer_id)->find();
        $wechat=new Open($auth_info['authorizer_appid'],$auth_info['authorizer_refresh_token']);
        Db::startTrans();
        try{
            $res=$wechat->batchTagging([$params['openid']],$params['tag_id']);
            if($res['errcode']==0&&$res['errmsg']=='ok'){
                Db::name('dealer_member')->where('openid',$params['openid'])->update([
                   'tags'=>$params['tags']
                ]);
                $info=[
                    'code'=>200,
                    'msg'=>'添加成功',
                ];
            }else{
                $info=[
                    'code'=>201,
                    'msg'=>'请联系管理员'
                ];
            }
            Db::commit();
        }catch (\Exception $e){
            Db::rollback();
            $info=[
                'code'=>201,
                'msg'=>$e->getMessage()
            ];
        }
        return json($info);
    }
    public function batchUnTagging(Request $request){
        $params=$request->get();
        $auth_info=Db::name('wxopen_authorization_info')->where('dealer_id',$this->dealer_id)->find();
        $wechat=new Open($auth_info['authorizer_appid'],$auth_info['authorizer_refresh_token']);
        Db::startTrans();
        try{
            $res=$wechat->batchUnTagging([$params['openid']],$params['tag_id']);
            if($res['errcode']==0&&$res['errmsg']=='ok'){
                Db::name('dealer_member')->where('openid',$params['openid'])->update([
                    'tags'=>$params['tags']
                ]);
                $info=[
                    'code'=>200,
                    'msg'=>'去除成功',
                ];
            }else{
                $info=[
                    'code'=>201,
                    'msg'=>'请联系管理员'
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
    /**
     * 添加积分
     */
    public function addPoints(Request $request){
        $params=$request->get();
        Db::startTrans();
        try{
            if($params['score']<0){
                Db::name('dealer_member')->where('id',$params['member_id'])->setDec('points', $params['score']*-1);
                Db::name('dealer_member_bill')->insert([
                    'pm'=>2,//消耗
                    'app_id'=>1,//直接发放
                    'number'=>$params['score']*-1,
                    'role'=>1,//总部
                    'type'=>3,//资产类型 积分
                    'remark'=>$params['remark'],
                    'dealer_id'=>$this->dealer_id,
                    'member_id'=>$params['member_id']
                ]);
                $info=[
                    'code'=>200,
                    'msg'=>'设置成功',
                ];
            }else{
                Db::name('dealer_member')->where('id',$params['member_id'])->setInc('points', $params['score']);
                //写积分明细日志
                Db::name('dealer_member_bill')->insert([
                    'pm'=>1,//获得
                    'app_id'=>1,//直接发放
                    'type'=>3,//资产类型 积分
                    'number'=>$params['score'],
                    'role'=>1,//总部
                    'remark'=>$params['remark'],
                    'dealer_id'=>$this->dealer_id,
                    'member_id'=>$params['member_id']
                ]);
                $info=[
                    'code'=>200,
                    'msg'=>'设置成功',
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
    /**
     * 会员资产记录列表
     */
    public function getAssetsList(Request $request){
        $params=$request->get();
        if($params['startTime']){
            $list=Db::name('dealer_member_bill')
                ->alias('a')
                ->join('ctc_dealer_member b','a.member_id=b.id')
                ->where('a.create_time', 'between time', [$params['startTime'],$params['endTime']])
                ->where('a.app_id',$params['assets_source']?$params['assets_source']:'not null')
                ->where('a.dealer_id',$this->dealer_id)
                ->where('a.member_id',$params['member_id'])
                ->where('a.type',$params['assets_type']?$params['assets_type']:'not null')
                ->field('a.*,b.headimgurl,b.openid,b.nickname,b.username,b.phone,b.status')
                ->page($params['pageNum'])
                ->limit($params['pageSize'])
                ->select();
            $total=Db::name('dealer_member_bill')
                ->alias('a')
                ->join('ctc_dealer_member b','a.member_id=b.id')
                ->where('a.create_time', 'between time', [$params['startTime'],$params['endTime']])
                ->where('a.app_id',$params['assets_source']?$params['assets_source']:'not null')
                ->where('a.dealer_id',$this->dealer_id)
                ->where('a.member_id',$params['member_id'])
                ->where('a.type',$params['assets_type']?$params['assets_type']:'not null')
                ->count();
        }else{
            $list=Db::name('dealer_member_bill')
                ->alias('a')
                ->join('ctc_dealer_member b','a.member_id=b.id')
                ->where('a.app_id',$params['assets_source']?$params['assets_source']:'not null')
                ->where('a.dealer_id',$this->dealer_id)
                ->where('a.member_id',$params['member_id'])
                ->where('a.type',$params['assets_type']?$params['assets_type']:'not null')
                ->field('a.*,b.headimgurl,b.openid,b.nickname,b.username,b.phone,b.status')
                ->page($params['pageNum'])
                ->limit($params['pageSize'])
                ->select();
            $total=Db::name('dealer_member_bill')
                ->alias('a')
                ->join('ctc_dealer_member b','a.member_id=b.id')
                ->where('a.app_id',$params['assets_source']?$params['assets_source']:'not null')
                ->where('a.dealer_id',$this->dealer_id)
                ->where('a.member_id',$params['member_id'])
                ->where('a.type',$params['assets_type']?$params['assets_type']:'not null')
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
     * 自定义字段列表
     */
    public function getFieldList(Request $request)
    {
        $params=$request->get();
        $list=Db::name('dealer_customize_field')
            ->where('field_name','like','%'.$params['field_name'].'%')
            ->where('status','like','%'.$params['status'].'%')
            ->where('dealer_id',$this->dealer_id)
            ->order('order','desc')
            ->page($params['pageNum'])
            ->limit($params['pageSize'])
            ->select();
        $total=Db::name('dealer_customize_field')
            ->where('field_name','like','%'.$params['field_name'].'%')
            ->where('status','like','%'.$params['status'].'%')
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
    public function deleField(Request $request){
        $id=$request->param('id');
        $res=Db::name('dealer_customize_field')->delete($id);
        if($res){
            return JsonService::successful('删除成功');
        }else{
            return JsonService::fail('请联系管理员');
        }
    }
    public function changeFieldStatus(Request $request){
        $params=$request->get();
        $text=$params['status']==1?'禁用':'启用';
        $status=$params['status']==1?2:1;
        $res=Db::name('dealer_customize_field')
            ->where('id',$params['id'])
            ->update([
               'status'=>$status
            ]);
        if($res){
            return JsonService::successful($text);
        }else{
            return JsonService::fail('请联系管理员');
        }
    }
    /**
     * @param Request $request
     */
    public function queryFieldInfo(Request $request){
        $id=$request->param('id');
        $res=Db::name('dealer_customize_field')->where('id',$id)->find();
        return JsonService::successful('查询成功',$res);
    }
    public function saveFiled(Request $request){
        $data=$request->post();
        $data['dealer_id']=$this->dealer_id;
        if(array_key_exists('id',$data)){
            $res=Db::name('dealer_customize_field')->update($data);
        }else{
            $res=Db::name('dealer_customize_field')->insert($data);
        }
        if($res||$res==0){
            return JsonService::successful('保存成功');
        }else{
            return JsonService::fail('请联系管理员');
        }
    }
}