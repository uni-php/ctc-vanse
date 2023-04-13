<?php
/**
 * Created by PhpStorm.
 * User: wenhan
 * Date: 2022/3/10
 * Time: 下午12:58
 */

namespace app\dealer\controller\app\mall;
use app\Request;
use think\Controller;
use think\Db;
use app\common\JsonService;
use think\db\Where;

class Judge extends Controller
{
    protected $dealer_id;
    public function initialize(){
        $userInfo=Request::userInfo();
        $this->dealer_id=array_key_exists('dealer_id',$userInfo)?$userInfo['dealer_id']:$userInfo['id'];
    }
    public function getGoodsJudge(Request $request){
        $params=$request->get();
        $list=Db::name('dealer_mall_judge')
            ->alias('a')
            ->join('dealer_mall_goods b','a.goods_id=b.id')
            ->join('dealer_member c','a.member_id=c.id')
            ->where('a.status',$params['status'])
            ->where('a.dealer_id',$this->dealer_id)
            ->field('a.id,a.replay_content,a.content,a.pic,a.create_time,a.update_time,b.goods_name,b.cover,c.nickname')
            ->page($params['pageNum'])
            ->limit($params['pageSize'])
            ->select();
        foreach ($list as $key=>$value){
            $list[$key]['pic']=json_decode($value['pic'],true);
            $list[$key]['cover']=json_decode($value['cover'],true);
        }
        $total=Db::name('dealer_mall_judge')
            ->alias('a')
            ->join('dealer_mall_goods b','a.goods_id=b.id')
            ->join('dealer_member c','a.member_id=c.id')
            ->where('a.dealer_id',$this->dealer_id)
            ->where('a.status',$params['status'])
            ->count();
        $res=[
            'code'=>200,
            'msg'=>'查询成功',
            'data'=>$list,
            'total'=>$total
        ];
        return json($res);
    }
    public function deleJudge(Request $request){
        $id=$request->param('id');
        $res=Db::name('dealer_mall_judge')
            ->delete($id);
        if($res){
            return JsonService::successful('删除成功');
        }else{
            return JsonService::fail('请联系管理员');
        }
    }
    public function saveJudge(Request $request){
        $data=$request->post();
        $res=Db::name('dealer_mall_judge')
            ->where('id',$data['id'])
            ->update([
                'replay_content'=>$data['replay_content'],
                'status'=>1,
                'update_time'=>date("Y-m-d H:i:s")
            ]);
        if($res){
            return JsonService::successful('回复成功');
        }else{
            return JsonService::fail('请联系管理员');
        }
    }
}