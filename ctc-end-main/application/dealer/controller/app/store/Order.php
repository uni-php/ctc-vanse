<?php
/**
 * Created by PhpStorm.
 * User: wenhan
 * Date: 2022/12/22
 * Time: 下午12:16
 */

namespace app\dealer\controller\app\store;
use app\Request;
use think\Controller;
use think\Db;
use app\common\JsonService;
use think\db\Where;

class Order extends Controller
{
    protected $dealer_id;
    public function initialize(){
        $userInfo=Request::userInfo();
        $this->dealer_id=array_key_exists('dealer_id',$userInfo)?$userInfo['dealer_id']:$userInfo['id'];
    }
    public function getStoreOrderList(Request $request){
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
        $list=Db::name('dealer_store_shop_order')
            ->alias('a')
            ->join('dealer_member b','a.openid=b.openid')
            ->join('dealer_store c','a.store_id=c.id')
            ->where(new Where($condition))
            ->where('a.dealer_id',$this->dealer_id)
            ->page($params['pageNum'])
            ->limit($params['pageSize'])
            ->order('a.create_time','desc')
            ->field('a.*,b.nickname,c.store_name')
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
        $total=Db::name('dealer_store_shop_order')
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
    public function markStoreShipment(Request $request){
        $params=$request->post();
        $params['status']=1;
        $res=Db::name('dealer_store_shop_order')
            ->where('order_id',$params['order_id'])
            ->where('dealer_id',$this->dealer_id)
            ->update($params);
        if($res){
            return JsonService::success('发货成功');
        }else{
            return JsonService::fail('请联系管理员');
        }
    }
}