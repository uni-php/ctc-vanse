<?php
/**
 * Created by PhpStorm.
 * User: wenhan
 * Date: 2022/4/1
 * Time: 下午9:13
 */

namespace app\pda\controller;
use app\Request;
use think\Controller;
use think\Db;
use app\common\JsonService;
use think\db\Where;

class THManage extends Controller
{
    protected $parent=[];//父级包装
    protected $child=[];//子包装码
    public function createThOrder(Request $request){
        $code='TH'.date('Ymd') . substr(implode('', array_map('ord', str_split(substr(uniqid(), 7, 13), 1))), 0, 8);
        return JsonService::returnData(200,'单号生成成功',$code);
    }

    /**
     * @param Request $request
     * 退货
     * 物流码存在与否(物流码不存在)=>物流码是否出库(不用判断入库)=>退货单审核中（物流码已退货）--- 审核不过（退货单已审核无法退货））=>发货客户与退货客户不一致（串货）=>物流码已退货 未出库=》成功退货
     */
    public function returnGoods(Request $request){
//        return JsonService::returnData(500,'该物流码无效');
        $data=$request->post();
        $data['return_warehouse_id']=$data['warehouse_id'];
        //单码扫描退货
        if($data['type']==0){
            $code_batch=Db::name('code_manage')
                ->where('dealer_id',$data['dealer_id'])
                ->where('scene','like','%'.'4'.'%')//查询物流码
                ->where('batch',$data['batch'])
                ->where('enable',1)
                ->find();
            if(!$code_batch) return JsonService::returnData(500,'该物流码无效');
            //判断码是否存在
            $secret_key=json_decode($code_batch['secret_key'],true);
            if(count($secret_key)==0){
                //无组套关系
                $key=explode(',',$code_batch['key']);//秘钥形式（n,d,e)
                if(strlen($data['code'])!=$code_batch['code_length']) return JsonService::returnData(500,'该物流码无效');
                //解密
                $decrypt_code=bcpowmod($data['code'],$key[1],$key[0],0);
                if($code_batch['order_begin']<=$decrypt_code&&$decrypt_code<=$code_batch['order_end']){
                    //判断物流码是否出库
                    $ck_order_status=Db::name('dealer_logistics_ck_code')
                        ->where('dealer_id',$data['dealer_id'])
                        ->select();
                    if(count($ck_order_status)<=0) return JsonService::returnData(500,'该物流码未出库');
                    $origin_ck_arr=[];
                    foreach ($ck_order_status as $key=>$value){
                        array_push($origin_ck_arr,[(int)$value['order_start'],(int)$value['order_end']]);
                    }
                    $miss_ck_code=get_no_belong_section([(int)$decrypt_code,(int)$decrypt_code],$origin_ck_arr);
                    if(count($miss_ck_code)>=1) return JsonService::returnData(500,'该物流码未出库');
                    //查询是否存在未审核的退货单
                    $has_await_check=Db::name('dealer_logistics_th_code')
                        ->alias('a')
                        ->join('dealer_logistics_th_order b','a.th_order=b.th_order')
                        ->where('a.code',$data['code'])
                        ->where('b.check_status',0)
                        ->find();
                    if($has_await_check) return JsonService::returnData(500,'该物流码已退货');
                    //查询是否存在未同意的退货单
                    $has_refuse_check=Db::name('dealer_logistics_th_code')
                        ->alias('a')
                        ->join('dealer_logistics_th_order b','a.th_order=b.th_order')
                        ->where('a.code',$data['code'])
                        ->where('b.check_status',2)
                        ->find();
                    if($has_refuse_check) return JsonService::returnData(500,'退货单已审核无法退货');
                    //判断发货客户与退货客户是否一致
                    $ck_info=Db::name('dealer_logistics_ck_code')
                        ->alias('a')
                        ->join('dealer_logistics_ck_order b','a.ck_order=b.ck_order')
                        ->join('dealer_product c','a.product_id=c.id')
                        ->where('a.code',$data['code'])
                        ->field('a.ck_num,a.ck_order,b.customer_id,b.customer_type,b.customer_name,b.customer_code,c.id as product_id,c.code as product_code,c.product_name,c.barcode,c.unit,c.specifications')
                        ->find();
                    $is_return=Db::name('dealer_logistics_ck_code')->where('code',$data['code'])->value('is_return');
                    if($is_return==1) return JsonService::returnData(500,'该物流码已退货');
                    if(($ck_info['customer_id']!=$data['customer_id']||$ck_info['customer_type']!=$data['customer_type'])&&$data['is_ch_record']==0) return JsonService::returnData(400,'选择的客户不是该物流码的发货客户，该客户已经产生窜货行为，确定记录吗？');//（后续等客户操作 再退货）
                    //开始退货 写退货单
                    Db::startTrans();//开启事务
                    try{
                        $has=Db::name('dealer_logistics_th_order')->where('dealer_id',$data['dealer_id'])->where('th_order',$data['th_order'])->find();
                        if(!$has){
                            $product=[
                                [
                                    'product_id'=>$ck_info['product_id'],
                                    'product_code'=>$ck_info['product_code'],
                                    'product_name'=>$ck_info['product_name'],
                                    'barcode'=>$ck_info['barcode'],
                                    'unit'=>$ck_info['unit'],
                                    'specifications'=>$ck_info['specifications'],
                                    'return_num'=>$ck_info['ck_num']
                                ]
                            ];
                            $data['th_sum']=$ck_info['ck_num'];//退货总数数量
                            $data['is_gift']=$ck_info['is_gift'];
                            $data['return_products']=json_encode($product);
                            Db::name('dealer_logistics_th_order')->strict(false)->insert($data);
                        }else{
                            $product=json_decode($has['return_products'],true);
                            $index=-1;
                            foreach ($product as $key=>$val){
                                if($val['product_id']==$ck_info['product_id']) {
                                    $index=$key;
                                    break;
                                }
                            }
                            if($index==-1){
                                $outwarehouse_products=[
                                    [
                                        'product_id'=>$ck_info['product_id'],
                                        'product_code'=>$ck_info['product_code'],
                                        'product_name'=>$ck_info['product_name'],
                                        'barcode'=>$ck_info['barcode'],
                                        'unit'=>$ck_info['unit'],
                                        'specifications'=>$ck_info['specifications'],
                                        'return_num'=>$ck_info['ck_num'],
                                    ]
                                ];
                                $product=array_merge($product,$outwarehouse_products);
                            }else{
                                $product[$index]['return_num']+=$ck_info['ck_num'];
                            }
                            Db::name('dealer_logistics_th_order')->where('th_order',$data['th_order'])->update([
                                'return_products'=>json_encode($product)
                            ]);
                            Db::name('dealer_logistics_th_order')
                                ->where('th_order',$data['th_order'])
                                ->setInc('th_sum',$ck_info['ck_num']);
                        }
                        //写入退货码表
                        Db::name('dealer_logistics_th_code')
                            ->insert([
                                'code'=>$data['code'],
                                'serial_number'=> $decrypt_code,
                                'batch'=>$data['batch'],
                                'code_type'=>2,//小标对待
                                'th_num'=>$ck_info['ck_num'],
                                'th_order'=>$data['th_order'],
                                'product_id'=>$ck_info['product_id'],
                                'dealer_id'=>$data['dealer_id'],
                                'order_start'=>$decrypt_code,
                                'order_end'=>$decrypt_code
                            ]);
                        //写串货记录
                        if($data['is_ch_record']==1){
                            //触发窜货
                            Db::name('dealer_logistics_ch_order')
                                ->insert([
                                    'serial_number'=> $decrypt_code,
                                    'dealer_id'=>$data['dealer_id'],
                                    'ch_distributor_id'=>$data['customer_id'],
                                    'ch_num'=>$ck_info['ck_num'],
                                    'bch_distributor_id'=>$ck_info['customer_id'],
                                    'bch_distributor_name'=>$ck_info['customer_name'],
                                    'bch_distributor_code'=>$ck_info['customer_code'],
                                    'from_type'=>1,//退货触发
                                    'th_order'=>$data['th_order'],
                                    'ck_order'=>$ck_info['ck_order'],
                                    'code'=>$data['code'],
                                    'code_type'=>2,//小标对待
                                    'remark'=>'退货'
                                ]);
                        }
                        Db::commit();
                        return JsonService::returnData(200,'退货成功');
                    }catch (\Exception $e){
                        Db::rollback();
                        return JsonService::returnData(500,'请联系管理员');
                    }

                }else{
                    return JsonService::returnData(500,'该物流码无效');
                }
            }else{
                //存在组套关系
                foreach ($secret_key as $k=>$val){
                    if($val['length']==strlen($data['code'])){
                        //解密
                        $new_key=explode(',',$val['key']);
                        $order=explode('--',$val['order']);
                        $decrypt_code=bcpowmod($data['code'],$new_key[1],$new_key[0],0);
                        if($order[0]<=$decrypt_code&&$decrypt_code<=$order[1]){
                            $code_type=2;//默认小标
                            $ck_num=1;//默认
                            if($code_batch['logistics_level']&&$code_batch['logistics_level']>1){
                                $logistics_level_item=json_decode($code_batch['logistics_level_item'],true);
                                $scale=[1];
                                $section=[];
                                foreach ($logistics_level_item as $ks=>$vs){
                                    array_push($scale,(int)$vs['num']);//=>[1,5,10]转化成数组比例
                                }
                                foreach ($secret_key as $kss=>$vss){
                                    array_push($section,[(int)explode('--',$vss['order'])[0],(int)explode('--',$vss['order'])[1]]);
                                }
                                $this->getChildCode($scale,$section,$k,(int)$decrypt_code);//查询子包装码
                                if(count($this->child)>0){
                                    if($code_batch['logistics_level']==2){
                                        //二级包装
                                        $code_type=1;
                                    }else if(count($this->child)==2) {
                                        $code_type=1;//大标
                                    }else{
                                        $code_type=2; //中级包装小标对待
                                    }
                                    $ck_num=(int)end(array_reverse($this->child)[0])-(int)current(array_reverse($this->child)[0])+1;
                                }
                            }
                            //判断物流码是否出库
                            $ck_order_status=Db::name('dealer_logistics_ck_code')
                                ->where('dealer_id',$data['dealer_id'])
                                ->select();
                            if(count($ck_order_status)>0){
                                //自身验证是否出过库
                                $origin_ck_arr=[];
                                foreach ($ck_order_status as $key=>$value){
                                    array_push($origin_ck_arr,[(int)$value['order_start'],(int)$value['order_end']]);
                                }
                                $miss_ck_code=get_no_belong_section([(int)$decrypt_code,(int)$decrypt_code],$origin_ck_arr);
                                if(count($miss_ck_code)<1){
                                    //本身已出库
                                    //查询是否存在未审核的退货单
                                    $has_await_check=Db::name('dealer_logistics_th_code')
                                        ->alias('a')
                                        ->join('dealer_logistics_th_order b','a.th_order=b.th_order')
                                        ->where('a.code',$data['code'])
                                        ->where('b.check_status',0)
                                        ->find();
                                    if($has_await_check) return JsonService::returnData(500,'该物流码已退货');
                                    //查询是否存在未同意的退货单
                                    $has_refuse_check=Db::name('dealer_logistics_th_code')
                                        ->alias('a')
                                        ->join('dealer_logistics_th_order b','a.th_order=b.th_order')
                                        ->where('a.code',$data['code'])
                                        ->where('b.check_status',2)
                                        ->find();
                                    if($has_refuse_check) return JsonService::returnData(500,'退货单已审核无法退货');
                                    //判断发货客户与退货客户是否一致
                                    $ck_info=Db::name('dealer_logistics_ck_code')
                                        ->alias('a')
                                        ->join('dealer_logistics_ck_order b','a.ck_order=b.ck_order')
                                        ->join('dealer_product c','a.product_id=c.id')
                                        ->where('a.code',$data['code'])
                                        ->field('a.ck_num,a.ck_order,a.code_type,b.customer_id,b.customer_name,b.customer_code,b.is_gift,b.customer_type,c.id as product_id,c.code as product_code,c.product_name,c.barcode,c.unit,c.specifications')
                                        ->find();
//                                    return JsonService::returnData(500,'该物流码已退货',$ck_info);
                                    //判断退货码是否再次出库
                                    $is_return=Db::name('dealer_logistics_ck_code')->where('code',$data['code'])->value('is_return');
                                    if($is_return==1) return JsonService::returnData(500,'该物流码已退货');
                                    if(($ck_info['customer_id']!=$data['customer_id']||$ck_info['customer_type']!=$data['customer_type'])&&$data['is_ch_record']==0) return JsonService::returnData(400,'选择的客户不是该物流码的发货客户，该客户已经产生窜货行为，确定记录吗？');//（后续等客户操作 再退货）
                                    //开始退货 写退货单
                                    Db::startTrans();//开启事务
                                    try{
                                        $has=Db::name('dealer_logistics_th_order')->where('dealer_id',$data['dealer_id'])->where('th_order',$data['th_order'])->find();
                                        if(!$has){
                                            $product=[
                                                [
                                                    'product_id'=>$ck_info['product_id'],
                                                    'product_code'=>$ck_info['product_code'],
                                                    'product_name'=>$ck_info['product_name'],
                                                    'barcode'=>$ck_info['barcode'],
                                                    'unit'=>$ck_info['unit'],
                                                    'specifications'=>$ck_info['specifications'],
                                                    'return_num'=>$ck_info['ck_num']
                                                ]
                                            ];
                                            $data['is_gift']=$ck_info['is_gift'];
                                            $data['th_sum']=$ck_info['ck_num'];//退货总数数量
                                            $data['return_products']=json_encode($product);
                                            Db::name('dealer_logistics_th_order')->strict(false)->insert($data);
                                        }else{
                                            $product=json_decode($has['return_products'],true);
                                            $index=-1;
                                            foreach ($product as $key=>$val){
                                                if($val['product_id']==$ck_info['product_id']) {
                                                    $index=$key;
                                                    break;
                                                }
                                            }
                                            if($index==-1){
                                                $outwarehouse_products=[
                                                    [
                                                        'product_id'=>$ck_info['product_id'],
                                                        'product_code'=>$ck_info['product_code'],
                                                        'product_name'=>$ck_info['product_name'],
                                                        'barcode'=>$ck_info['barcode'],
                                                        'unit'=>$ck_info['unit'],
                                                        'specifications'=>$ck_info['specifications'],
                                                        'return_num'=>$ck_info['ck_num'],
                                                    ]
                                                ];
                                                $product=array_merge($product,$outwarehouse_products);
                                            }else{
                                                $product[$index]['return_num']+=$ck_info['ck_num'];
                                            }
                                            Db::name('dealer_logistics_th_order')->where('th_order',$data['th_order'])->update([
                                                'return_products'=>json_encode($product)
                                            ]);
                                            Db::name('dealer_logistics_th_order')
                                                ->where('th_order',$data['th_order'])
                                                ->setInc('th_sum',$ck_info['ck_num']);
                                        }
                                        //写入退货码表
                                        Db::name('dealer_logistics_th_code')
                                            ->insert([
                                                'code'=>$data['code'],
                                                'serial_number'=> $decrypt_code,
                                                'batch'=>$data['batch'],
                                                'code_type'=>$ck_info['code_type'],//小标对待
                                                'th_num'=>$ck_info['ck_num'],
                                                'th_order'=>$data['th_order'],
                                                'product_id'=>$ck_info['product_id'],
                                                'dealer_id'=>$data['dealer_id'],
                                                'order_start'=>$decrypt_code,
                                                'order_end'=>$decrypt_code
                                            ]);
                                        //写串货记录
                                        if($data['is_ch_record']==1){
                                            //触发窜货
                                            Db::name('dealer_logistics_ch_order')
                                                ->insert([
                                                    'serial_number'=> $decrypt_code,
                                                    'dealer_id'=>$data['dealer_id'],
                                                    'ch_distributor_id'=>$data['customer_id'],
                                                    'ch_num'=>$ck_info['ck_num'],
                                                    'bch_distributor_id'=>$ck_info['customer_id'],
                                                    'bch_distributor_name'=>$ck_info['customer_name'],
                                                    'bch_distributor_code'=>$ck_info['customer_code'],
                                                    'from_type'=>1,//退货触发
                                                    'th_order'=>$data['th_order'],
                                                    'ck_order'=>$ck_info['ck_order'],
                                                    'code'=>$data['code'],
                                                    'code_type'=>$ck_info['code_type'],//小标对待
                                                    'remark'=>'退货'
                                                ]);
                                        }
                                        Db::commit();
                                        return JsonService::returnData(200,'退货成功');
                                    }catch (\Exception $e){
                                        Db::rollback();
                                        return JsonService::returnData(500,'请联系管理员');
                                    }
                                }
                                //判断父级包装是否出库
                                if($code_batch['logistics_level']&&$code_batch['logistics_level']>1){
                                    $logistics_level_item=json_decode($code_batch['logistics_level_item'],true);
                                    $scale=[1];
                                    $section=[];
                                    foreach ($logistics_level_item as $ks=>$vs){
                                        array_push($scale,(int)$vs['num']);//=>[1,5,10]转化成数组比例
                                    }
                                    foreach ($secret_key as $kss=>$vss){
                                        array_push($section,[(int)explode('--',$vss['order'])[0],(int)explode('--',$vss['order'])[1]]);
                                    }
                                    $this->getParentCode($scale,$section,$k,(int)$decrypt_code);//查询父级包装码
                                    $parent_order=array_reverse($this->parent);//父级包装[22,44]
                                    if(count($parent_order)>0){
                                        //存在父级码
                                        foreach ($parent_order as $pk=>$pv){
                                            $p_miss_rk_code=get_no_belong_section([$pv,$pv],$origin_ck_arr);
                                            if(count($p_miss_rk_code)<1){
                                                //查询是否存在未审核的退货单
                                                $has_await_check=Db::name('dealer_logistics_th_code')
                                                    ->alias('a')
                                                    ->join('dealer_logistics_th_order b','a.th_order=b.th_order')
                                                    ->where('a.serial_number',$pv)
                                                    ->where('b.check_status',0)
                                                    ->find();
                                                if($has_await_check) return JsonService::returnData(500,'该物流码外包装码已退货');
                                                //查询是否存在未同意的退货单
                                                $has_refuse_check=Db::name('dealer_logistics_th_code')
                                                    ->alias('a')
                                                    ->join('dealer_logistics_th_order b','a.th_order=b.th_order')
                                                    ->where('a.serial_number',$pv)
                                                    ->where('b.check_status',2)
                                                    ->find();
                                                if($has_refuse_check) return JsonService::returnData(500,'外包装退货单已审核无法退货');
                                                //判断发货客户与退货客户是否一致
                                                $ck_info=Db::name('dealer_logistics_ck_code')
                                                    ->alias('a')
                                                    ->join('dealer_logistics_ck_order b','a.ck_order=b.ck_order')
                                                    ->join('dealer_product c','a.product_id=c.id')
                                                    ->where('a.serial_number',$pv)
                                                    ->field('a.ck_num,a.code_type,b.is_gift,b.customer_id,b.customer_name,b.customer_code,b.customer_type,c.id as product_id,c.code as product_code,c.product_name,c.barcode,c.unit,c.specifications')
                                                    ->find();
                                                $is_return=Db::name('dealer_logistics_ck_code')
                                                    ->where('serial_number',$pv)
                                                    ->where('dealer_id',$data['dealer_id'])
                                                    ->value('is_return');
                                                if($is_return==1) return JsonService::returnData(500,'该物流码外包装码已退货');
                                                if(($ck_info['customer_id']!=$data['customer_id']||$ck_info['customer_type']!=$data['customer_type'])&&$data['is_ch_record']==0) return JsonService::returnData(400,'选择的客户不是该物流码的发货客户，该客户已经产生窜货行为，确定记录吗？');//（后续等客户操作 再退货）
                                                //开始退货 写退货单
                                                //开始退货 写退货单
                                                Db::startTrans();//开启事务
                                                try{
                                                    $has=Db::name('dealer_logistics_th_order')->where('dealer_id',$data['dealer_id'])->where('th_order',$data['th_order'])->find();
                                                    if(!$has){
                                                        $product=[
                                                            [
                                                                'product_id'=>$ck_info['product_id'],
                                                                'product_code'=>$ck_info['product_code'],
                                                                'product_name'=>$ck_info['product_name'],
                                                                'barcode'=>$ck_info['barcode'],
                                                                'unit'=>$ck_info['unit'],
                                                                'specifications'=>$ck_info['specifications'],
                                                                'return_num'=>$ck_info['ck_num']
                                                            ]
                                                        ];
                                                        $data['is_gift']=$ck_info['is_gift'];
                                                        $data['th_sum']=$ck_info['ck_num'];//退货总数数量
                                                        $data['return_products']=json_encode($product);
                                                        Db::name('dealer_logistics_th_order')->strict(false)->insert($data);
                                                    }else{
                                                        $product=json_decode($has['return_products'],true);
                                                        $index=-1;
                                                        foreach ($product as $key=>$val){
                                                            if($val['product_id']==$ck_info['product_id']) {
                                                                $index=$key;
                                                                break;
                                                            }
                                                        }
                                                        if($index==-1){
                                                            $outwarehouse_products=[
                                                                [
                                                                    'product_id'=>$ck_info['product_id'],
                                                                    'product_code'=>$ck_info['product_code'],
                                                                    'product_name'=>$ck_info['product_name'],
                                                                    'barcode'=>$ck_info['barcode'],
                                                                    'unit'=>$ck_info['unit'],
                                                                    'specifications'=>$ck_info['specifications'],
                                                                    'return_num'=>$ck_info['ck_num'],
                                                                ]
                                                            ];
                                                            $product=array_merge($product,$outwarehouse_products);
                                                        }else{
                                                            $product[$index]['return_num']+=$ck_info['ck_num'];
                                                        }
                                                        Db::name('dealer_logistics_th_order')->where('th_order',$data['th_order'])->update([
                                                            'return_products'=>json_encode($product)
                                                        ]);
                                                        Db::name('dealer_logistics_th_order')
                                                            ->where('th_order',$data['th_order'])
                                                            ->setInc('th_sum',$ck_info['ck_num']);
                                                    }
                                                    //写入退货码表
                                                    Db::name('dealer_logistics_th_code')
                                                        ->insert([
                                                            'code'=>$data['code'],
                                                            'serial_number'=> $decrypt_code,
                                                            'batch'=>$data['batch'],
                                                            'code_type'=>$ck_info['code_type'],
                                                            'th_num'=>$ck_info['ck_num'],
                                                            'th_order'=>$data['th_order'],
                                                            'product_id'=>$ck_info['product_id'],
                                                            'dealer_id'=>$data['dealer_id'],
                                                            'order_start'=>$decrypt_code,
                                                            'order_end'=>$decrypt_code
                                                        ]);
                                                    //写串货记录
                                                    if($data['is_ch_record']==1){
                                                        //触发窜货
                                                        Db::name('dealer_logistics_ch_order')
                                                            ->insert([
                                                                'serial_number'=> $decrypt_code,
                                                                'dealer_id'=>$data['dealer_id'],
                                                                'ch_distributor_id'=>$data['customer_id'],
                                                                'ch_num'=>$ck_info['ck_num'],
                                                                'bch_distributor_id'=>$ck_info['customer_id'],
                                                                'bch_distributor_name'=>$ck_info['customer_name'],
                                                                'bch_distributor_code'=>$ck_info['customer_code'],
                                                                'from_type'=>1,//退货触发
                                                                'th_order'=>$data['th_order'],
                                                                'ck_order'=>$ck_info['ck_order'],
                                                                'code'=>$data['code'],
                                                                'code_type'=>$ck_info['code_type'],//小标对待
                                                                'remark'=>'退货'
                                                            ]);
                                                    }
                                                    Db::commit();
                                                    return JsonService::returnData(200,'退货成功');
                                                }catch (\Exception $e){
                                                    Db::rollback();
                                                    return JsonService::returnData(500,'请联系管理员');
                                                }
                                            }
                                        }
                                    }
                                }
                                return JsonService::returnData(500,'该物流码未出库');
                            }else{
                                return JsonService::returnData(500,'该物流码未出库');
                            }
                        }else{
                            return JsonService::returnData(500,'该物流码无效',$decrypt_code);
                            break;
                        }
                    }
                }
                return JsonService::returnData(500,'该物流码无效');
            }
        }else{
//
            //流水号退货 巨麻烦  是否合理有待验证？？？？？  条件:流水号必须一个序列段序列批次
            //判断物流码是否存在
            $order_array=Db::name('code_manage')
                ->where('dealer_id',$data['dealer_id'])
                ->where('scene','like','%'.'4'.'%')//查询物流码
                ->where('enable',1)
                ->field('order_begin,order_end')
                ->select();//所有区间
            $origin_arr=[];
            foreach ($order_array as $key=>$value){
                array_push($origin_arr,[(int)$value['order_begin'],(int)$value['order_end']]);
            }
            $miss_code=get_no_belong_section([(int)$data['order_start'],(int)$data['order_end']],$origin_arr);
            if(count($miss_code)==0){
                $between=Db::name('code_manage')
                    ->where('dealer_id',$data['dealer_id'])
                    ->where('scene','like','%'.'4'.'%')//查询物流码
                    ->where('enable',1)
                    ->where('order_begin','<=',$data['order_start'])
                    ->where('order_end','>=',$data['order_end'])
                    ->find();
                if(!$between) return JsonService::returnData(500,'流水号区间不在同一批次');
                $ck_order_status=Db::name('dealer_logistics_ck_code')
                    ->where('dealer_id',$data['dealer_id'])
                    ->select();
                if(count($ck_order_status)<=0) return JsonService::returnData(500,'该序列区间未出库');
                $secret_key=json_decode($between['secret_key'],true);
                if(count($secret_key)==0){
                    //不存在组套关系 =>先判断是否出库
                    $origin_ck_arr=[];
                    foreach ($ck_order_status as $key=>$value){
                        array_push($origin_ck_arr,[(int)$value['order_start'],(int)$value['order_end']]);
                    }
                    $miss_ck_code=get_no_belong_section([(int)$data['order_start'],(int)$data['order_end']],$origin_ck_arr);
                    if(count($miss_ck_code)>=1) return JsonService::returnData(500,'该物流码未出库');
                    //查询是否存在未审核的退货单
                    $has_await_check=Db::name('dealer_logistics_th_code')
                        ->alias('a')
                        ->join('dealer_logistics_th_order b','a.th_order=b.th_order')
                        ->where('a.order_start',$data['order_start'])
                        ->where('a.order_end',$data['order_end'])
                        ->where('b.check_status',0)
                        ->find();
                    if($has_await_check) return JsonService::returnData(500,'该物流码已退货');
                    //查询是否存在未同意的退货单
                    $has_refuse_check=Db::name('dealer_logistics_th_code')
                        ->alias('a')
                        ->join('dealer_logistics_th_order b','a.th_order=b.th_order')
                        ->where('a.order_start',$data['order_start'])
                        ->where('a.order_end',$data['order_end'])
                        ->where('b.check_status',2)
                        ->find();
                    if($has_refuse_check) return JsonService::returnData(500,'退货单已审核无法退货');
                    //判断发货客户与退货客户是否一致
                    $ck_info=Db::name('dealer_logistics_ck_code')
                        ->alias('a')
                        ->join('dealer_logistics_ck_order b','a.ck_order=b.ck_order')
                        ->join('dealer_product c','a.product_id=c.id')
                        ->where('a.order_start',$data['order_start'])
                        ->where('a.order_end',$data['order_end'])
                        ->field('a.ck_num,a.ck_order,b.is_gift,b.customer_id,b.customer_type,b.customer_name,b.customer_code,c.id as product_id,c.code as product_code,c.product_name,c.barcode,c.unit,c.specifications')
                        ->find();
                    $is_return=Db::name('dealer_logistics_ck_code')
                        ->where('order_start',$data['order_start'])
                        ->where('order_end',$data['order_end'])
                        ->value('is_return');
                    if($is_return==1) return JsonService::returnData(500,'该物流码已退货');
                    if(($ck_info['customer_id']!=$data['customer_id']||$ck_info['customer_type']!=$data['customer_type'])&&$data['is_ch_record']==0) return JsonService::returnData(400,'选择的客户不是该物流码的发货客户，该客户已经产生窜货行为，确定记录吗？');//（后续等客户操作 再退货）
                    //开始退货 写退货单
                    Db::startTrans();//开启事务
                    try{
                        $has=Db::name('dealer_logistics_th_order')->where('dealer_id',$data['dealer_id'])->where('th_order',$data['th_order'])->find();
                        if(!$has){
                            $product=[
                                [
                                    'product_id'=>$ck_info['product_id'],
                                    'product_code'=>$ck_info['product_code'],
                                    'product_name'=>$ck_info['product_name'],
                                    'barcode'=>$ck_info['barcode'],
                                    'unit'=>$ck_info['unit'],
                                    'specifications'=>$ck_info['specifications'],
                                    'return_num'=>$ck_info['ck_num']
                                ]
                            ];
                            $data['th_sum']=$ck_info['ck_num'];//退货总数数量
                            $data['is_gift']=$ck_info['is_gift'];
                            $data['return_products']=json_encode($product);
                            Db::name('dealer_logistics_th_order')->strict(false)->insert($data);
                        }else{
                            $product=json_decode($has['return_products'],true);
                            $index=-1;
                            foreach ($product as $key=>$val){
                                if($val['product_id']==$ck_info['product_id']) {
                                    $index=$key;
                                    break;
                                }
                            }
                            if($index==-1){
                                $outwarehouse_products=[
                                    [
                                        'product_id'=>$ck_info['product_id'],
                                        'product_code'=>$ck_info['product_code'],
                                        'product_name'=>$ck_info['product_name'],
                                        'barcode'=>$ck_info['barcode'],
                                        'unit'=>$ck_info['unit'],
                                        'specifications'=>$ck_info['specifications'],
                                        'return_num'=>$ck_info['ck_num'],
                                    ]
                                ];
                                $product=array_merge($product,$outwarehouse_products);
                            }else{
                                $product[$index]['return_num']+=$ck_info['ck_num'];
                            }
                            Db::name('dealer_logistics_th_order')->where('th_order',$data['th_order'])->update([
                                'return_products'=>json_encode($product)
                            ]);
                            Db::name('dealer_logistics_th_order')
                                ->where('th_order',$data['th_order'])
                                ->setInc('th_sum',$ck_info['ck_num']);
                        }
                        //写入退货码表
                        Db::name('dealer_logistics_th_code')
                            ->insert([
                                'code_type'=>2,//小标对待
                                'th_num'=>$ck_info['ck_num'],
                                'th_order'=>$data['th_order'],
                                'product_id'=>$ck_info['product_id'],
                                'dealer_id'=>$data['dealer_id'],
                                'order_start'=>$data['order_start'],
                                'order_end'=>$data['order_end']
                            ]);
                        //写串货记录
                        if($data['is_ch_record']==1){
                            //触发窜货
                            Db::name('dealer_logistics_ch_order')
                                ->insert([
                                    'dealer_id'=>$data['dealer_id'],
                                    'ch_distributor_id'=>$data['customer_id'],
                                    'ch_num'=>$ck_info['ck_num'],
                                    'bch_distributor_id'=>$ck_info['customer_id'],
                                    'bch_distributor_name'=>$ck_info['customer_name'],
                                    'bch_distributor_code'=>$ck_info['customer_code'],
                                    'from_type'=>1,//退货触发
                                    'th_order'=>$data['th_order'],
                                    'ck_order'=>$ck_info['ck_order'],
                                    'order_start'=>$data['order_start'],
                                    'order_end'=>$data['order_end'],
                                    'code_type'=>$ck_info['code_type'],
                                    'remark'=>'退货'
                                ]);
                        }
                        Db::commit();
                        return JsonService::returnData(200,'退货成功');
                    }catch (\Exception $e){
                        Db::rollback();
                        return JsonService::returnData(500,'请联系管理员');
                    }
                }else{
                    //存在组套关系
                    foreach ($secret_key as $k=>$val){
                        //自身验证是否出过库  区间退货不验证父级！！！！！
                        $origin_ck_arr=[];
                        foreach ($ck_order_status as $key=>$value){
                            array_push($origin_ck_arr,[(int)$value['order_start'],(int)$value['order_end']]);
                        }
                        $miss_ck_code=get_no_belong_section([(int)$data['order_start'],(int)$data['order_end']],$origin_ck_arr);
                        if(count($miss_ck_code)<1){
                            //自身出库
                            $has_await_check=Db::name('dealer_logistics_th_code')
                                ->alias('a')
                                ->join('dealer_logistics_th_order b','a.th_order=b.th_order')
                                ->where('a.order_start',$data['order_start'])
                                ->where('a.order_end',$data['order_end'])
                                ->where('b.check_status',0)
                                ->find();
                            if($has_await_check) return JsonService::returnData(500,'该物流码已退货');
                            //查询是否存在未同意的退货单
                            $has_refuse_check=Db::name('dealer_logistics_th_code')
                                ->alias('a')
                                ->join('dealer_logistics_th_order b','a.th_order=b.th_order')
                                ->where('a.order_start',$data['order_start'])
                                ->where('a.order_end',$data['order_end'])
                                ->where('b.check_status',2)
                                ->find();
                            if($has_refuse_check) return JsonService::returnData(500,'退货单已审核无法退货');
                            //判断发货客户与退货客户是否一致
                            $ck_info=Db::name('dealer_logistics_ck_code')
                                ->alias('a')
                                ->join('dealer_logistics_ck_order b','a.ck_order=b.ck_order')
                                ->join('dealer_product c','a.product_id=c.id')
                                ->where('a.order_start',$data['order_start'])
                                ->where('a.order_end',$data['order_end'])
                                ->field('a.ck_num,a.ck_order,a.code_type,b.is_gift,b.customer_id,b.customer_type,b.customer_name,b.customer_code,c.id as product_id,c.code as product_code,c.product_name,c.barcode,c.unit,c.specifications')
                                ->find();
                            $is_return=Db::name('dealer_logistics_ck_code')
                                ->where('order_start',$data['order_start'])
                                ->where('order_end',$data['order_end'])
                                ->value('is_return');
                            if($is_return==1) return JsonService::returnData(500,'该物流码已退货');
                            if(($ck_info['customer_id']!=$data['customer_id']||$ck_info['customer_type']!=$data['customer_type'])&&$data['is_ch_record']==0) return JsonService::returnData(400,'选择的客户不是该物流码的发货客户，该客户已经产生窜货行为，确定记录吗？');//（后续等客户操作 再退货）
                            Db::startTrans();//开启事务
                            try{
                                $has=Db::name('dealer_logistics_th_order')->where('dealer_id',$data['dealer_id'])->where('th_order',$data['th_order'])->find();
                                if(!$has){
                                    $product=[
                                        [
                                            'product_id'=>$ck_info['product_id'],
                                            'product_code'=>$ck_info['product_code'],
                                            'product_name'=>$ck_info['product_name'],
                                            'barcode'=>$ck_info['barcode'],
                                            'unit'=>$ck_info['unit'],
                                            'specifications'=>$ck_info['specifications'],
                                            'return_num'=>$ck_info['ck_num']
                                        ]
                                    ];
                                    $data['th_sum']=$ck_info['ck_num'];//退货总数数量
                                    $data['is_gift']=$ck_info['is_gift'];
                                    $data['return_products']=json_encode($product);
                                    Db::name('dealer_logistics_th_order')->strict(false)->insert($data);
                                }else{
                                    $product=json_decode($has['return_products'],true);
                                    $index=-1;
                                    foreach ($product as $key=>$vall){
                                        if($vall['product_id']==$ck_info['product_id']) {
                                            $index=$key;
                                            break;
                                        }
                                    }
                                    if($index==-1){
                                        $outwarehouse_products=[
                                            [
                                                'product_id'=>$ck_info['product_id'],
                                                'product_code'=>$ck_info['product_code'],
                                                'product_name'=>$ck_info['product_name'],
                                                'barcode'=>$ck_info['barcode'],
                                                'unit'=>$ck_info['unit'],
                                                'specifications'=>$ck_info['specifications'],
                                                'return_num'=>$ck_info['ck_num'],
                                            ]
                                        ];
                                        $product=array_merge($product,$outwarehouse_products);
                                    }else{
                                        $product[$index]['return_num']+=$ck_info['ck_num'];
                                    }
                                    Db::name('dealer_logistics_th_order')->where('th_order',$data['th_order'])->update([
                                        'return_products'=>json_encode($product)
                                    ]);
                                    Db::name('dealer_logistics_th_order')
                                        ->where('th_order',$data['th_order'])
                                        ->setInc('th_sum',$ck_info['ck_num']);
                                }
                                //写入退货码表
                                Db::name('dealer_logistics_th_code')
                                    ->insert([
                                        'code_type'=>$ck_info['code_type'],
                                        'th_num'=>$ck_info['ck_num'],
                                        'th_order'=>$data['th_order'],
                                        'product_id'=>$ck_info['product_id'],
                                        'dealer_id'=>$data['dealer_id'],
                                        'order_start'=>$data['order_start'],
                                        'order_end'=>$data['order_end']
                                    ]);
                                if($data['is_ch_record']==1){
                                    //触发窜货
                                    Db::name('dealer_logistics_ch_order')
                                        ->insert([
                                            'dealer_id'=>$data['dealer_id'],
                                            'ch_distributor_id'=>$data['customer_id'],
                                            'ch_num'=>$ck_info['ck_num'],
                                            'bch_distributor_id'=>$ck_info['customer_id'],
                                            'bch_distributor_name'=>$ck_info['customer_name'],
                                            'bch_distributor_code'=>$ck_info['customer_code'],
                                            'from_type'=>1,//退货触发
                                            'th_order'=>$data['th_order'],
                                            'ck_order'=>$ck_info['ck_order'],
                                            'order_start'=>$data['order_start'],
                                            'order_end'=>$data['order_end'],
                                            'code_type'=>$ck_info['code_type'],
                                            'remark'=>'退货'
                                        ]);
                                }
                                Db::commit();
                                return JsonService::returnData(200,'退货成功');
                            }catch (\Exception $e){
                                Db::rollback();
                                return JsonService::returnData(500,'请联系管理员');
                            }
                        }

                    }
                    return JsonService::returnData(500,'该物流码无效');
                }

            }else{
                return JsonService::returnData(500,'流水号不存在',$miss_code);
            }

        }
    }
    public function getThProductList(Request $request){
        $params=$request->get();
        $product=Db::name('dealer_logistics_th_order')
            ->where('th_order',$params['th_order'])
            ->find();
        if($product){
            return JsonService::returnData(200,'查询成功',json_decode($product['return_products'],true));
        }else{
            return JsonService::returnData(500,'暂无退货明细');
        }
    }
    public function getCodeList(Request $request){
        $params=$request->get();
        $list=Db::name('dealer_logistics_th_code')
            ->where('dealer_id',$params['dealer_id'])
            ->where('th_order',$params['th_order'])
            ->where('product_id',$params['product_id'])
            ->page($params['pageNum'])
            ->limit($params['pageSize'])
            ->select();
        return JsonService::returnData(200,'查询成功',$list);
    }
    public function getThNotes(Request $request){
        $params=$request->get();
        if($params['start_time']&&$params['end_time']){
            $condition['return_time']=['between time',[$params['start_time'],$params['end_time']]];
        }
        $condition['th_order']=['like','%'.$params['th_order'].'%'];
        $condition['customer_name']=['like','%'.$params['customer_name'].'%'];
        $list=Db::name('dealer_logistics_th_order')
            ->where(new Where($condition))
            ->where('dealer_id',$params['dealer_id'])
            ->where('is_del',0)
            ->page($params['page'])
            ->limit($params['pageSize'])
            ->order('return_time','desc')
            ->select();
        $sum=Db::name('dealer_logistics_th_order')
            ->where(new Where($condition))
            ->where('dealer_id',$params['dealer_id'])
            ->where('is_del',0)
            ->count();
        $th_sum=Db::name('dealer_logistics_th_order')
            ->where(new Where($condition))
            ->where('dealer_id',$params['dealer_id'])
            ->where('is_del',0)
            ->sum('th_sum');
        $data=[
            'list'=>[
                'current_page'=>$params['page'],
                'total'=>$sum,
                'th_sum'=>$th_sum,
                'per_page'=>$params['pageSize'],
                'data'=>$list
            ]
        ];
        return JsonService::returnData(200,'查询成功',$data);
    }
    /**
     * @param $scale //比例关系[1,12,13]1拖12拖13
     * @param $section//码段区间数列
     * @param $index //查询数码所在上述区间
     * @param $order //查询数码
     * @return array
     * 根据子包装推导外侧包装物流码序号[a,b,c...]abc依次为一二级包装序号 依次类推
     */
    public function getParentCode($scale,$section,$index,$order){
        if($index==0) return $this->parent;
        $start=floor(($order-$section[$index][0])/$scale[$index]);
        array_push($this->parent,$section[$index-1][0]+$start);
        $index--;
        if($index>0){
            $this->getParentCode($scale,$section,$index,$this->parent[count($this->parent)-1]);
        }
    }
    /**
     * @param $scale
     * @param $section
     * @param $index
     * @param $order
     * @return array
     * 查询外包装对应子包装的物流码5=>[[4,6],[44,55]...]元素为首位字段
     */
    public function getChildCode($scale,$section,$index,$order){
        if($index==count($scale)-1) return $this->child;
        $star=($order-$section[$index][0])*$scale[$index+1];
        array_push($this->child,[($star+$section[$index+1][0]),($star+$section[$index+1][0]+$scale[$index+1]-1)]);
        $index++;
        if($index<count($scale)-1){
            $this->getChildCode($scale,$section,$index,$this->child[count($this->child)-1][0]);
            $this->getChildCode($scale,$section,$index,$this->child[count($this->child)-2][1]);
            $this->child=[$this->child[0],array_merge($this->child[count($this->child)-2],$this->child[count($this->child)-1])];
        }
    }
}