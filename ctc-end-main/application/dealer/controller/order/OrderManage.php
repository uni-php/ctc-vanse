<?php
/**
 * Created by PhpStorm.
 * User: wenhan
 * Date: 2022/8/28
 * Time: 上午2:09
 */

namespace app\dealer\controller\order;
use app\Request;
use think\Controller;
use think\Db;
use app\common\JsonService;
use think\db\Where;

class OrderManage extends Controller

{
    protected $dealer_id;
    public function initialize(){
        $userInfo=Request::userInfo();
        $this->dealer_id=array_key_exists('dealer_id',$userInfo)?$userInfo['dealer_id']:$userInfo['id'];
    }
    public function getPointsOrderList(Request $request){
        $params=$request->get();
        try {
            Db::execute("SET @@sql_mode='';");
        } catch (\Exception $e) {
        }
        if($params['startTime']){
            $condition['a.create_time']=['between time',[$params['startTime'],$params['endTime']]];
        }
        $condition['b.nickname']=['like','%'.$params['nickname'].'%'];
        $condition['a.order_id']=[$params['order']?:'not null'];
        if($params['status']=='-3'){
            $condition['a.is_del']=[1];
        }else{
            $condition['a.status']=[$params['status']==-2?'not null':$params['status']];
        }
        $list=Db::name('dealer_points_order')
            ->alias('a')
            ->join('dealer_member b','a.openid=b.openid')
            ->where(new Where($condition))
            ->where('a.dealer_id',$this->dealer_id)
            ->page($params['pageNum'])
            ->limit($params['pageSize'])
            ->order('a.create_time','desc')
            ->field('a.*,b.nickname')
            ->group('a.order_id')
            ->select();
        foreach ($list as $key=>$value){
            if($value['pay_mode']=='cart'){
                $goods_info=json_decode($value['order_gift_info'],true);//数组或者对象
                foreach ($goods_info as $k=>$v){
                    $list[$key]['children']=[];
                    array_push($list[$key]['children'],[
                        'id'=>  'index'.$key.$v['id'],
                        'gift_name'=>  $v['gift_name'],
                        'money'=>$v['money'],
                        'points_num'=> $v['points_num'],
                        'gift_num'=>$v['gift_num'],
                        'cover'=>$v['cover'][0]['url']
                    ]);
                }
            }else{
                $goods_info=json_decode($value['order_gift_info']);//数组或者对象
                $list[$key]['children']=[[
                    'id'=>  'idx'.$key.$goods_info->id,
                    'gift_name'=>  $goods_info->gift_name,
                    'money'=>$goods_info->money,
                    'points_num'=>  $goods_info->points_num,
                    'gift_num'=>1,
                    'cover'=>($goods_info->cover)[0]->url
                ]];
            }
        }
        $total=Db::name('dealer_points_order')
            ->alias('a')
            ->join('dealer_member b','a.openid=b.openid')
            ->where(new Where($condition))
            ->where('a.dealer_id',$this->dealer_id)
            ->group('a.order_id')
            ->count();
        $res=[
            'code'=>200,
            'msg'=>'查询成功',
            'data'=>$list,
            'total'=>$total
        ];
        return json($res);
    }
    public function getMallOrderList(Request $request){
        $params=$request->get();
        try {
            Db::execute("SET @@sql_mode='';");
        } catch (\Exception $e) {
        }
        if($params['startTime']){
            $condition['a.create_time']=['between time',[$params['startTime'],$params['endTime']]];
        }
        $condition['b.nickname']=['like','%'.$params['nickname'].'%'];
        $condition['a.order_id']=[$params['order']?:'not null'];
        if($params['status']=='-3'){
            $condition['a.is_del']=[1];
        }else{
            $condition['a.status']=[$params['status']==-2?'not null':$params['status']];
        }
        $list=Db::name('dealer_mall_order')
            ->alias('a')
            ->join('dealer_member b','a.openid=b.openid')
            ->where(new Where($condition))
            ->where('a.dealer_id',$this->dealer_id)
            ->page($params['pageNum'])
            ->limit($params['pageSize'])
            ->order('a.create_time','desc')
            ->field('a.*,b.nickname')
            ->group('a.order_id')
            ->select();
        foreach ($list as $key=>$value){
            $goods_info=json_decode($value['order_goods_info'],true);//数组或者对象
            if($value['pay_mode']=='cart'){
                foreach ($goods_info as $k=>$v){
                    $list[$key]['children']=[];
                    array_push($list[$key]['children'],[
                        'id'=>  'index'.$key.$v['id'],
                        'product_name'=>  $v['product_name'],
                        'sale_price'=>$v['sale_price'],
                        'goods_num'=>$v['goods_num'],
                        'cover'=>$v['cover'][0]['url']
                    ]);
                }
            }else{
                $goods_info=json_decode($value['order_goods_info']);//数组或者对象
                $list[$key]['children']=[[
                    'id'=>  'idx'.$key.$goods_info->id,
                    'product_name'=>  $goods_info->product_name,
                    'sale_price'=>$goods_info->sale_price,
                    'gift_num'=>1,
                    'cover'=>($goods_info->cover)[0]->url
                ]];
            }
        }
        $total=Db::name('dealer_mall_order')
            ->alias('a')
            ->join('dealer_member b','a.openid=b.openid')
            ->where(new Where($condition))
            ->where('a.dealer_id',$this->dealer_id)
            ->group('a.order_id')
            ->count();
        $res=[
            'code'=>200,
            'msg'=>'查询成功',
            'data'=>$list,
            'total'=>$total
        ];
        return json($res);
    }
    //营销订单
    public function getMarketingOrderList(Request $request){
        $params=$request->get();
        if($params['startTime']){
            $condition['a.create_time']=['between time',[$params['startTime'],$params['endTime']]];
        }
        $condition['a.order']=[$params['order']?:'not null'];
        if(is_numeric($params['get_prize_mode'])){
            $condition['a.get_prize_mode']=['=',$params['get_prize_mode']];
        }
        if($params['status']=='-3'){
            $condition['a.valid_day']=['<=', time()];
        }else{
            $condition['a.status']=[$params['status']==-2?'not null':$params['status']];
        }
        $list=Db::name('dealer_qrcode_marketing_order')
            ->alias('a')
            ->join('dealer_member b','a.openid=b.openid and a.dealer_id=b.dealer_id')
            ->where(new Where($condition))
            ->where('a.dealer_id',$this->dealer_id)
            ->page($params['pageNum'])
            ->limit($params['pageSize'])
            ->order('a.create_time','desc')
            ->field('a.*,b.nickname')
            ->select();
        $total=Db::name('dealer_qrcode_marketing_order')
            ->alias('a')
            ->join('dealer_member b','a.openid=b.openid and a.dealer_id=b.dealer_id')
            ->where(new Where($condition))
            ->where('a.dealer_id',$this->dealer_id)
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
     * 标记发货
     */
    public function markShipment(Request $request){
        $params=$request->post();
        $params['status']=1;
        $res=Db::name('dealer_points_order')
            ->where('order_id',$params['order_id'])
            ->update($params);
        if($res){
            return JsonService::success('发货成功');
        }else{
            return JsonService::fail('请联系管理员');
        }
    }
    public function markMallShipment(Request $request){
        $params=$request->post();
        $params['status']=1;
        $res=Db::name('dealer_mall_order')
            ->where('order_id',$params['order_id'])
            ->update($params);
        if($res){
            return JsonService::success('发货成功');
        }else{
            return JsonService::fail('请联系管理员');
        }
    }
    public function markQrcodeShipment(Request $request){
        $params=$request->post();
        $params['status']=1;
        $res=Db::name('dealer_qrcode_marketing_order')
            ->where('order',$params['order'])
            ->update($params);
        if($res){
            return JsonService::success('发货成功');
        }else{
            return JsonService::fail('请联系管理员');
        }
    }
}