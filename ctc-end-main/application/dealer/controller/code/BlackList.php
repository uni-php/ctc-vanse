<?php
/**
 * Created by PhpStorm.
 * User: wenhan
 * Date: 2021/12/22
 * Time: 下午8:46
 */

namespace app\dealer\controller\code;
use app\Request;
use think\Controller;
use think\Db;
use app\common\JsonService;

class BlackList extends Controller
{
    protected $dealer_id;
    public function initialize(){
        $userInfo=Request::userInfo();
        $this->dealer_id=array_key_exists('dealer_id',$userInfo)?$userInfo['dealer_id']:$userInfo['id'];
    }
    public function saveBlackListSet(Request $request){
        $data=$request->post();
        $data['dealer_id']=$this->dealer_id;
        if(array_key_exists('id',$data)){
            $res=Db::name('qrcode_blacklist_set')->update($data);
        }else{
            $res=Db::name('qrcode_blacklist_set')->insert($data);
        }
        if($res||$res==0){
            return JsonService::successful('保存成功');
        }else{
            return JsonService::fail('请联系管理员');
        }
    }
    public function getBlackListSet(Request $request){
        $res=Db::name('qrcode_blacklist_set')
            ->where('dealer_id',$this->dealer_id)
            ->find();
        return JsonService::successful('查询成功',$res);
    }
    public function getBlackList(Request $request){
        $params=$request->get();
        if($params['startTime']){
            $list=Db::name('qrcode_blacklist')
                ->where('dealer_id',$this->dealer_id)
                ->where('create_time','between time',[$params['startTime'],$params['endTime']])
                ->where('keywords','like','%'.$params['openid'].'%')
                ->where('keywords','like','%'.$params['member_id'].'%')
                ->where('validity','like','%'.$params['validity'].'%')
                ->page($params['pageNum'])
                ->limit($params['pageSize'])
                ->order('create_time','desc')
                ->select();
            $total=Db::name('qrcode_blacklist')
                ->where('dealer_id',$this->dealer_id)
                ->where('create_time','between time',[$params['startTime'],$params['endTime']])
                ->where('keywords','like','%'.$params['openid'].'%')
                ->where('keywords','like','%'.$params['member_id'].'%')
                ->where('validity','like','%'.$params['validity'].'%')
                ->count();
        }else{
            $list=Db::name('qrcode_blacklist')
                ->where('dealer_id',$this->dealer_id)
                ->where('keywords','like','%'.$params['openid'].'%')
                ->where('keywords','like','%'.$params['member_id'].'%')
                ->where('validity','like','%'.$params['validity'].'%')
                ->page($params['pageNum'])
                ->limit($params['pageSize'])
                ->order('create_time','desc')
                ->select();
            $total=Db::name('qrcode_blacklist')
                ->where('dealer_id',$this->dealer_id)
                ->where('keywords','like','%'.$params['openid'].'%')
                ->where('keywords','like','%'.$params['member_id'].'%')
                ->where('validity','like','%'.$params['validity'].'%')
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
    public function revokeBlackList(Request $request){
        $res=Db::name('qrcode_blacklist')->delete($request->param('id'));
        if($res){
            return JsonService::successful('撤销成功');
        }else{
            return JsonService::fail('请联系管理员');
        }
    }
    public function saveBlackList(Request $request){
        $data=$request->post();
        $data['dealer_id']=$this->dealer_id;
        $res=Db::name('qrcode_blacklist')->insert($data);
        if($res){
            return JsonService::successful('拉黑成功');
        }else{
            return JsonService::fail('请联系管理员');
        }
    }
}