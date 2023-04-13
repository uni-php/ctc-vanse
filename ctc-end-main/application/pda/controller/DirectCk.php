<?php
/**
 * Created by PhpStorm.
 * User: wenhan
 * Date: 2022/3/31
 * Time: 下午5:58
 */

namespace app\pda\controller;
use app\Request;
use think\Controller;
use think\Db;
use app\common\JsonService;
use think\db\Where;
use think\facade\Hook;

class DirectCk extends Controller
{
    protected $parent=[];//父级包装
    protected $child=[];//子包装码

    /**
     * @param Request $request
     * 直接出库
     * 物流码存在判断=>物流码是否入库(大小标都要判断)=>物流码是否出库（大小标都要判断）=>物流码入库仓库与出库仓库是否一致
     * 同一入库单可以发不同的商品 即可以扫码不同的出库商品码！！！
     */
    public function saveDirectCkOrder(Request $request){
        $data=$request->post();
//        return JsonService::returnData(500,'该物流码无效');
        if($data['ck_type']==1){
            //已入库商品出货
            $batch_info=Db::name('code_manage')
                ->where('dealer_id',$data['dealer_id'])
                ->where('scene','like','%'.'4'.'%')//查询物流码
                ->where('batch',$data['batch'])
                ->where('enable',1)
                ->find();
            if(!$batch_info) return JsonService::returnData(500,'该物流码无效');
            $secret_key=json_decode($batch_info['secret_key'],true);
            if(count($secret_key)==0){
                //不存在组套关系
                $key=explode(',',$batch_info['key']);//秘钥形式（n,d,e)
                if(strlen($data['code'])!=$batch_info['code_length']) return JsonService::returnData(500,'该物流码无效');
                $decrypt_code=bcpowmod($data['code'],$key[1],$key[0],0);//解密
                //判断是否属于所在区间
                if($batch_info['order_begin']<=$decrypt_code&&$decrypt_code<=$batch_info['order_end']){
                    //验重 先判断是否已经出库
                    $ck_order_status=Db::name('dealer_logistics_ck_code')
                        ->where('dealer_id',$data['dealer_id'])
                        ->select();
                    //判断是否退货
                    $is_return=Db::name('dealer_logistics_ck_code')
                        ->where('batch',$data['batch'])
                        ->where('dealer_id',$data['dealer_id'])
                        ->where('serial_number',$decrypt_code)
                        ->value('is_return');
                    if(count($ck_order_status)>0){
                        $origin_ck_arr=[];
                        foreach ($ck_order_status as $key=>$value){
                            array_push($origin_ck_arr,[(int)$value['order_start'],(int)$value['order_end']]);
                        }
                        $miss_ck_code=get_no_belong_section([(int)$decrypt_code,(int)$decrypt_code],$origin_ck_arr);
                        if(count($miss_ck_code)<1&&$is_return!=1) return JsonService::returnData(500,'物流码已出库');
                    }
                    //再判断是否已入库
                    $rk_order_status=Db::name('dealer_logistics_rk_code')
                        ->where('dealer_id',$data['dealer_id'])
                        ->select();
                    if(count($rk_order_status)>0){
                        $origin_rk_arr=[];
                        foreach ($rk_order_status as $key=>$value){
                            array_push($origin_rk_arr,[(int)$value['order_start'],(int)$value['order_end']]);
                        }
                        $miss_rk_code=get_no_belong_section([(int)$decrypt_code,(int)$decrypt_code],$origin_rk_arr);
                        if(count($miss_rk_code)<1){
                            //已入库 未出库 继续判断仓库与产品是否一致
                            $rk_info=Db::name('dealer_logistics_rk_code')
                                ->alias('a')
                                ->join('dealer_logistics_rk_order b','a.rk_order=b.rk_order')
                                ->where('a.code',$data['code'])
                                ->where('a.dealer_id',$data['dealer_id'])
                                ->field('b.warehouse_id,b.product_id,b.product_code,b.product_name,b.barcode,b.unit,b.specifications,b.manufacture_time,b.validity_time')
                                ->find();
                            if($rk_info['warehouse_id']!=$data['warehouse_id']) return JsonService::returnData(500,'入库和出库的仓库不一致');
                            //开始出库
                            Db::startTrans();//开启事务
                            try{
                                //写出库单 需把入库商品 同步到出库单  有相同商品=>出库量+1 无相同商品 商品数组插到最后
                                $has_ck=Db::name('dealer_logistics_ck_order')
                                    ->where('dealer_id',$data['dealer_id'])
                                    ->where('ck_order',$data['ck_order'])
                                    ->find();
                                if($has_ck){
                                    $product=json_decode($has_ck['outwarehouse_products'],true);
                                    //产品查重
                                    $index=-1;
                                    foreach ($product as $key=>$val){
                                        if($val['product_id']==$rk_info['product_id']) {
                                            $index=$key;
                                            break;
                                        }
                                    }
                                    if($index==-1){
                                        $outwarehouse_products=[
                                          [
                                              'product_id'=>$rk_info['product_id'],
                                              'product_code'=>$rk_info['product_code'],
                                              'product_name'=>$rk_info['product_name'],
                                              'barcode'=>$rk_info['barcode'],
                                              'unit'=>$rk_info['unit'],
                                              'specifications'=>$rk_info['specifications'],
                                              'out_num'=>1,
                                              'order_num'=>1
                                          ]
                                        ];
                                        $product=array_merge($product,$outwarehouse_products);
                                    }else{
                                        $product[$index]['order_num']++;
                                        $product[$index]['out_num']++;//无组套关系 累计加一
                                    }
                                    Db::name('dealer_logistics_ck_order')
                                        ->where('ck_order',$data['ck_order'])
                                        ->setInc('send_sum');
                                    Db::name('dealer_logistics_ck_order')
                                        ->where('ck_order',$data['ck_order'])
                                        ->setInc('deliver_sum');
                                    //更新出库单
                                    Db::name('dealer_logistics_ck_order')->where('ck_order',$data['ck_order'])->update([
                                        'outwarehouse_products'=>json_encode($product)
                                    ]);
                                    $has_code= $is_return=Db::name('dealer_logistics_ck_code')
                                        ->where('batch',$data['batch'])
                                        ->where('dealer_id',$data['dealer_id'])
                                        ->where('serial_number',$decrypt_code)
                                        ->find();
                                    if($has_code){
                                        //更新出库码表
                                        //出库单会重新生成 但是要将原出库单出库量加回来 繁琐哈哈哈哈哈哈
                                        $old_product=Db::name('dealer_logistics_ck_order')
                                            ->where('ck_order',$has_code['ck_order'])
                                            ->where('dealer_id',$data['dealer_id'])
                                            ->value('outwarehouse_products');
                                        $old_product=json_decode($old_product,true);
                                        foreach ($old_product as $okey=>$oval){
                                            if($oval['product_id']==$has_code['product_id']){
                                                unset($old_product[$okey]);//移除退货重发的产品
                                            }
                                        }
                                        $old_product=array_values($old_product);//重置索引
                                        Db::name('dealer_logistics_ck_order')
                                            ->where('ck_order',$has_code['ck_order'])
                                            ->where('dealer_id',$data['dealer_id'])
                                            ->update([
                                               'outwarehouse_products'=>json_encode($old_product)
                                            ]);//更新发货产品
                                        Db::name('dealer_logistics_ck_order')
                                            ->where('ck_order',$has_code['ck_order'])
                                            ->setDec('send_sum',$has_code['ck_num']);//实发量减
                                        Db::name('dealer_logistics_ck_order')
                                            ->where('ck_order',$has_code['ck_order'])
                                            ->setDec('deliver_sum',$has_code['ck_num']);//应发量减
                                        Db::name('dealer_logistics_ck_code')
                                            ->where('batch',$data['batch'])
                                            ->where('dealer_id',$data['dealer_id'])
                                            ->where('serial_number',$decrypt_code)
                                            ->update([
                                                'code_type'=>2,//小标对待
                                                'ck_num'=>1,
                                                'ck_order'=>$data['ck_order'],
                                                'product_id'=>$rk_info['product_id'],
                                                'product_code'=>$rk_info['product_code'],
                                                'product_name'=>$rk_info['product_name'],
                                                'barcode'=>$rk_info['barcode'],
                                                'specifications'=>$rk_info['specifications'],
                                                'manufacture_time'=>$rk_info['manufacture_time'],
                                                'validity_time'=>$rk_info['validity_time'],
                                                'unit'=>$rk_info['unit'],
                                                'dealer_id'=>$data['dealer_id'],
                                                'scan_type'=>1,
                                                'ck_type'=>3,//出货方式  已入库商品出货
                                                'order_start'=>$decrypt_code,
                                                'order_end'=>$decrypt_code,
                                                'update_time'=>date("Y-m-d H:i:s")
                                            ]);
                                    }else{
                                        //插入出库码表
                                        Db::name('dealer_logistics_ck_code')
                                            ->insert([
                                                'code'=>$data['code'],
                                                'serial_number'=> $decrypt_code,
                                                'batch'=>$data['batch'],
                                                'code_type'=>2,//小标对待
                                                'ck_num'=>1,
                                                'ck_order'=>$data['ck_order'],
                                                'product_id'=>$rk_info['product_id'],
                                                'product_code'=>$rk_info['product_code'],
                                                'product_name'=>$rk_info['product_name'],
                                                'barcode'=>$rk_info['barcode'],
                                                'specifications'=>$rk_info['specifications'],
                                                'manufacture_time'=>$rk_info['manufacture_time'],
                                                'validity_time'=>$rk_info['validity_time'],
                                                'unit'=>$rk_info['unit'],
                                                'dealer_id'=>$data['dealer_id'],
                                                'scan_type'=>1,
                                                'ck_type'=>3,//出货方式  已入库商品出货
                                                'order_start'=>$decrypt_code,
                                                'order_end'=>$decrypt_code,
                                                'update_time'=>date("Y-m-d H:i:s")
                                            ]);
                                    }
                                    $log=[
                                        'code'=>$data['code'],
                                        'batch'=>$data['batch'],
                                        'op_type'=>'直接出库',
                                        'op_des'=>'出库单'.$data['ck_order'].'物流码直接出库',
                                        'dealer_id'=>$data['dealer_id'],
                                    ];
                                    Hook::listen('pda_op_log',$log);
                                    Db::commit();
                                    return JsonService::returnData(200,'出库成功',['product_name'=>$rk_info['product_name'],'num'=>1]);

                                }else{
                                    $outwarehouse_products=[
                                        [
                                            'product_id'=>$rk_info['product_id'],
                                            'product_name'=>$rk_info['product_name'],
                                            'barcode'=>$rk_info['barcode'],
                                            'unit'=>$rk_info['unit'],
                                            'product_code'=>$rk_info['product_code'],
                                            'specifications'=>$rk_info['specifications'],
                                            'out_num'=>1,
                                            'order_num'=>1
                                        ]
                                    ];
                                    $data['outwarehouse_products']=json_encode($outwarehouse_products);
                                    $data['ck_type']=3;//已入库商品发货
                                    Db::name('dealer_logistics_ck_order')->strict(false)->insert($data);
                                    Db::name('dealer_logistics_ck_order')
                                        ->where('ck_order',$data['ck_order'])
                                        ->setInc('send_sum');
                                    Db::name('dealer_logistics_ck_order')
                                        ->where('ck_order',$data['ck_order'])
                                        ->setInc('deliver_sum');
                                    $has_code= $is_return=Db::name('dealer_logistics_ck_code')
                                        ->where('batch',$data['batch'])
                                        ->where('dealer_id',$data['dealer_id'])
                                        ->where('serial_number',$decrypt_code)
                                        ->find();
                                    if($has_code){
                                        $old_product=Db::name('dealer_logistics_ck_order')
                                            ->where('ck_order',$has_code['ck_order'])
                                            ->where('dealer_id',$data['dealer_id'])
                                            ->value('outwarehouse_products');
                                        $old_product=json_decode($old_product,true);
                                        foreach ($old_product as $okey=>$oval){
                                            if($oval['product_id']==$has_code['product_id']){
                                                unset($old_product[$okey]);//移除退货重发的产品
                                            }
                                        }
                                        $old_product=array_values($old_product);//重置索引
                                        Db::name('dealer_logistics_ck_order')
                                            ->where('ck_order',$has_code['ck_order'])
                                            ->where('dealer_id',$data['dealer_id'])
                                            ->update([
                                                'outwarehouse_products'=>json_encode($old_product)
                                            ]);//更新发货产品
                                        Db::name('dealer_logistics_ck_order')
                                            ->where('ck_order',$has_code['ck_order'])
                                            ->setDec('send_sum',$has_code['ck_num']);//实发量减
                                        Db::name('dealer_logistics_ck_order')
                                            ->where('ck_order',$has_code['ck_order'])
                                            ->setDec('deliver_sum',$has_code['ck_num']);//应发量减
                                        Db::name('dealer_logistics_ck_code')
                                            ->where('batch',$data['batch'])
                                            ->where('dealer_id',$data['dealer_id'])
                                            ->where('serial_number',$decrypt_code)
                                            ->update([
                                                'code_type'=>2,//小标对待
                                                'ck_num'=>1,
                                                'ck_order'=>$data['ck_order'],
                                                'product_id'=>$rk_info['product_id'],
                                                'product_code'=>$rk_info['product_code'],
                                                'product_name'=>$rk_info['product_name'],
                                                'barcode'=>$rk_info['barcode'],
                                                'specifications'=>$rk_info['specifications'],
                                                'manufacture_time'=>$rk_info['manufacture_time'],
                                                'validity_time'=>$rk_info['validity_time'],
                                                'unit'=>$rk_info['unit'],
                                                'dealer_id'=>$data['dealer_id'],
                                                'scan_type'=>1,
                                                'ck_type'=>3,//出货方式  已入库商品出货
                                                'order_start'=>$decrypt_code,
                                                'order_end'=>$decrypt_code,
                                                'update_time'=>date("Y-m-d H:i:s")
                                            ]);
                                    }else{
                                        Db::name('dealer_logistics_ck_code')
                                            ->insert([
                                                'code'=>$data['code'],
                                                'serial_number'=> $decrypt_code,
                                                'batch'=>$data['batch'],
                                                'code_type'=>2,//小标对待
                                                'ck_num'=>1,
                                                'ck_order'=>$data['ck_order'],
                                                'product_id'=>$rk_info['product_id'],
                                                'product_code'=>$rk_info['product_code'],
                                                'product_name'=>$rk_info['product_name'],
                                                'barcode'=>$rk_info['barcode'],
                                                'specifications'=>$rk_info['specifications'],
                                                'manufacture_time'=>$rk_info['manufacture_time'],
                                                'validity_time'=>$rk_info['validity_time'],
                                                'unit'=>$rk_info['unit'],
                                                'dealer_id'=>$data['dealer_id'],
                                                'scan_type'=>1,
                                                'ck_type'=>3,//出货方式  已入库商品出货
                                                'order_start'=>$decrypt_code,
                                                'order_end'=>$decrypt_code,
                                                'update_time'=>date("Y-m-d H:i:s")
                                            ]);
                                    }
                                    $log=[
                                        'code'=>$data['code'],
                                        'batch'=>$data['batch'],
                                        'op_type'=>'直接出库',
                                        'op_des'=>'出库单'.$data['ck_order'].'物流码直接出库',
                                        'dealer_id'=>$data['dealer_id'],
                                    ];
                                    Hook::listen('pda_op_log',$log);
                                    Db::commit();
                                    return JsonService::returnData(200,'出库成功',['product_name'=>$rk_info['product_name'],'num'=>1]);
                                }

                            }catch (\Exception $e){
                                Db::rollback();
                                return JsonService::returnData(500,'请联系管理员');
                            }
                        }else{
                            return JsonService::returnData(500,'该物流码未入库,请先入库再进行出库');
                        }
                    }else{
                        return JsonService::returnData(500,'该物流码未入库,请先入库再进行出库');
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
                            //判断是否退货
                            $is_return=Db::name('dealer_logistics_ck_code')
                                ->where('batch',$data['batch'])
                                ->where('dealer_id',$data['dealer_id'])
                                ->where('serial_number',$decrypt_code)
                                ->value('is_return');
                            //验重
                            $ck_order_status=Db::name('dealer_logistics_ck_code')
                                ->where('dealer_id',$data['dealer_id'])
                                ->select();
                            $rk_order_status=Db::name('dealer_logistics_rk_code')
                                ->where('dealer_id',$data['dealer_id'])
                                ->select();
                            $code_type=2;//默认小标
                            $ck_num=1;//默认
                            if($batch_info['logistics_level']&&$batch_info['logistics_level']>1){
                                $logistics_level_item=json_decode($batch_info['logistics_level_item'],true);
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
                                    if($batch_info['logistics_level']==2){
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
                            if(count($ck_order_status)>0){
                                //自身验证是否出过库
                                $origin_ck_arr=[];
                                foreach ($ck_order_status as $key=>$value){
                                    array_push($origin_ck_arr,[(int)$value['order_start'],(int)$value['order_end']]);
                                }
                                $miss_ck_code=get_no_belong_section([(int)$decrypt_code,(int)$decrypt_code],$origin_ck_arr);
                                if(count($miss_ck_code)<1&&$is_return!=1) return JsonService::returnData(500,'物流码已出库');
                                //判断父级包装是否出库
                                if($batch_info['logistics_level']&&$batch_info['logistics_level']>1){
                                    $logistics_level_item=json_decode($batch_info['logistics_level_item'],true);
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
                                            $is_return=Db::name('dealer_logistics_ck_code')
                                                ->where('batch',$data['batch'])
                                                ->where('dealer_id',$data['dealer_id'])
                                                ->where('serial_number',$pv)
                                                ->value('is_return');
                                            if(count($p_miss_rk_code)<1&&$is_return!=1) return JsonService::returnData(500,'外包装已出库！');
                                        }
                                    }
                                }
                            }
                            $rk_info=Db::name('dealer_logistics_rk_code')
                                ->alias('a')
                                ->join('dealer_logistics_rk_order b','a.rk_order=b.rk_order')
                                ->where('a.code',$data['code'])
                                ->where('a.batch',$data['batch'])
                                ->where('a.serial_number',$decrypt_code)
                                ->where('a.dealer_id',$data['dealer_id'])
                                ->field('b.warehouse_id,b.product_id,b.manufacture_time,b.validity_time,b.product_code,b.product_name,b.barcode,b.unit,b.specifications')
                                ->find();
                            if(count($rk_order_status)>0){
                                //自身验证是否入过库
                                $origin_rk_arr=[];
                                foreach ($rk_order_status as $key=>$value){
                                    array_push($origin_rk_arr,[(int)$value['order_start'],(int)$value['order_end']]);
                                }
                                $miss_rk_code=get_no_belong_section([(int)$decrypt_code,(int)$decrypt_code],$origin_rk_arr);
                                if(count($miss_rk_code)<1){
                                    //本身入库可以直接出库 否则去判断父级包装
                                    if($rk_info['warehouse_id']!=$data['warehouse_id']) return JsonService::returnData(500,'入库和出库的仓库不一致');
                                    //开始出库
                                    Db::startTrans();//开启事务
                                    try{
                                        //写出库单 需把入库商品 同步到出库单  有相同商品=>出库量+1 无相同商品 商品数组插到最后
                                        $has_ck=Db::name('dealer_logistics_ck_order')
                                            ->where('dealer_id',$data['dealer_id'])
                                            ->where('ck_order',$data['ck_order'])
                                            ->find();
                                        if($has_ck){
                                            $product=json_decode($has_ck['outwarehouse_products'],true);
                                            //产品查重
                                            $index=-1;
                                            foreach ($product as $key=>$vall){
                                                if($vall['product_id']==$rk_info['product_id']) {
                                                    $index=$key;
                                                    break;
                                                }
                                            }
                                            if($index==-1){
                                                $outwarehouse_products=[
                                                    [
                                                        'product_id'=>$rk_info['product_id'],
                                                        'product_code'=>$rk_info['product_code'],
                                                        'product_name'=>$rk_info['product_name'],
                                                        'barcode'=>$rk_info['barcode'],
                                                        'unit'=>$rk_info['unit'],
                                                        'specifications'=>$rk_info['specifications'],
                                                        'out_num'=>$ck_num,
                                                        'order_num'=>$ck_num
                                                    ]
                                                ];
                                                $product=array_merge($product,$outwarehouse_products);
                                            }else{
                                                $product[$index]['order_num']+=$ck_num;
                                                $product[$index]['out_num']+=$ck_num;
                                            }
                                            Db::name('dealer_logistics_ck_order')
                                                ->where('ck_order',$data['ck_order'])
                                                ->setInc('send_sum',$ck_num);
                                            Db::name('dealer_logistics_ck_order')
                                                ->where('ck_order',$data['ck_order'])
                                                ->setInc('deliver_sum',$ck_num);
                                            //更新出库单
                                            Db::name('dealer_logistics_ck_order')->where('ck_order',$data['ck_order'])->update([
                                                'outwarehouse_products'=>json_encode($product)
                                            ]);
                                            $has_code= $is_return=Db::name('dealer_logistics_ck_code')
                                                ->where('batch',$data['batch'])
                                                ->where('dealer_id',$data['dealer_id'])
                                                ->where('serial_number',$decrypt_code)
                                                ->find();
                                            if($has_code){
                                                $old_product=Db::name('dealer_logistics_ck_order')
                                                    ->where('ck_order',$has_code['ck_order'])
                                                    ->where('dealer_id',$data['dealer_id'])
                                                    ->value('outwarehouse_products');
                                                $old_product=json_decode($old_product,true);
                                                foreach ($old_product as $okey=>$oval){
                                                    if($oval['product_id']==$has_code['product_id']){
                                                        unset($old_product[$okey]);//移除退货重发的产品
                                                    }
                                                }
                                                $old_product=array_values($old_product);//重置索引
                                                Db::name('dealer_logistics_ck_order')
                                                    ->where('ck_order',$has_code['ck_order'])
                                                    ->where('dealer_id',$data['dealer_id'])
                                                    ->update([
                                                        'outwarehouse_products'=>json_encode($old_product)
                                                    ]);//更新发货产品
                                                Db::name('dealer_logistics_ck_order')
                                                    ->where('ck_order',$has_code['ck_order'])
                                                    ->setDec('send_sum',$has_code['ck_num']);//实发量减
                                                Db::name('dealer_logistics_ck_order')
                                                    ->where('ck_order',$has_code['ck_order'])
                                                    ->setDec('deliver_sum',$has_code['ck_num']);//应发量减
                                                Db::name('dealer_logistics_ck_code')
                                                    ->where('batch',$data['batch'])
                                                    ->where('dealer_id',$data['dealer_id'])
                                                    ->where('serial_number',$decrypt_code)
                                                    ->update([
                                                        'ck_num'=>$ck_num,
                                                        'ck_order'=>$data['ck_order'],
                                                        'product_id'=>$rk_info['product_id'],
                                                        'product_code'=>$rk_info['product_code'],
                                                        'product_name'=>$rk_info['product_name'],
                                                        'barcode'=>$rk_info['barcode'],
                                                        'specifications'=>$rk_info['specifications'],
                                                        'manufacture_time'=>$rk_info['manufacture_time'],
                                                        'validity_time'=>$rk_info['validity_time'],
                                                        'unit'=>$rk_info['unit'],
                                                        'dealer_id'=>$data['dealer_id'],
                                                        'scan_type'=>1,
                                                        'ck_type'=>3,//出货方式  已入库商品出货
                                                        'order_start'=>$decrypt_code,
                                                        'order_end'=>$decrypt_code,
                                                        'is_return'=>0,//置0 很关键
                                                        'update_time'=>date("Y-m-d H:i:s")
                                                    ]);
                                            }else{
                                                Db::name('dealer_logistics_ck_code')
                                                    ->insert([
                                                        'code'=>$data['code'],
                                                        'serial_number'=> $decrypt_code,
                                                        'batch'=>$data['batch'],
                                                        'code_type'=>$code_type,//小标对待
                                                        'ck_num'=>$ck_num,
                                                        'ck_order'=>$data['ck_order'],
                                                        'product_id'=>$rk_info['product_id'],
                                                        'product_code'=>$rk_info['product_code'],
                                                        'product_name'=>$rk_info['product_name'],
                                                        'barcode'=>$rk_info['barcode'],
                                                        'specifications'=>$rk_info['specifications'],
                                                        'manufacture_time'=>$rk_info['manufacture_time'],
                                                        'validity_time'=>$rk_info['validity_time'],
                                                        'unit'=>$rk_info['unit'],
                                                        'dealer_id'=>$data['dealer_id'],
                                                        'scan_type'=>1,
                                                        'ck_type'=>3,//出货方式  已入库商品出货
                                                        'order_start'=>$decrypt_code,
                                                        'order_end'=>$decrypt_code,
                                                        'update_time'=>date("Y-m-d H:i:s")
                                                    ]);
                                            }
                                            $log=[
                                                'code'=>$data['code'],
                                                'batch'=>$data['batch'],
                                                'op_type'=>'已入库商品出库出库',
                                                'op_des'=>'出库单'.$data['ck_order'].'物流码直接出库',
                                                'dealer_id'=>$data['dealer_id'],
                                            ];
                                            Hook::listen('pda_op_log',$log);
                                            Db::commit();
                                            return JsonService::returnData(200,'出库成功',['product_name'=>$rk_info['product_name'],'num'=>$ck_num]);

                                        }else{
                                            $outwarehouse_products=[
                                                [
                                                    'product_id'=>$rk_info['product_id'],
                                                    'product_name'=>$rk_info['product_name'],
                                                    'barcode'=>$rk_info['barcode'],
                                                    'unit'=>$rk_info['unit'],
                                                    'product_code'=>$rk_info['product_code'],
                                                    'specifications'=>$rk_info['specifications'],
                                                    'out_num'=>$ck_num,
                                                    'order_num'=>$ck_num
                                                ]
                                            ];
                                            $data['outwarehouse_products']=json_encode($outwarehouse_products);
                                            $data['ck_type']=3;//已入库商品发货
                                            Db::name('dealer_logistics_ck_order')->strict(false)->insert($data);
                                            Db::name('dealer_logistics_ck_order')
                                                ->where('ck_order',$data['ck_order'])
                                                ->setInc('send_sum',$ck_num);
                                            Db::name('dealer_logistics_ck_order')
                                                ->where('ck_order',$data['ck_order'])
                                                ->setInc('deliver_sum',$ck_num);
                                            $has_code= $is_return=Db::name('dealer_logistics_ck_code')
                                                ->where('batch',$data['batch'])
                                                ->where('dealer_id',$data['dealer_id'])
                                                ->where('serial_number',$decrypt_code)
                                                ->find();
                                            if($has_code){
                                                $old_product=Db::name('dealer_logistics_ck_order')
                                                    ->where('ck_order',$has_code['ck_order'])
                                                    ->where('dealer_id',$data['dealer_id'])
                                                    ->value('outwarehouse_products');
                                                $old_product=json_decode($old_product,true);
                                                foreach ($old_product as $okey=>$oval){
                                                    if($oval['product_id']==$has_code['product_id']){
                                                        unset($old_product[$okey]);//移除退货重发的产品
                                                    }
                                                }
                                                $old_product=array_values($old_product);//重置索引
                                                Db::name('dealer_logistics_ck_order')
                                                    ->where('ck_order',$has_code['ck_order'])
                                                    ->where('dealer_id',$data['dealer_id'])
                                                    ->update([
                                                        'outwarehouse_products'=>json_encode($old_product)
                                                    ]);//更新发货产品
                                                Db::name('dealer_logistics_ck_order')
                                                    ->where('ck_order',$has_code['ck_order'])
                                                    ->setDec('send_sum',$has_code['ck_num']);//实发量减
                                                Db::name('dealer_logistics_ck_order')
                                                    ->where('ck_order',$has_code['ck_order'])
                                                    ->setDec('deliver_sum',$has_code['ck_num']);//应发量减
                                                Db::name('dealer_logistics_ck_code')
                                                    ->where('batch',$data['batch'])
                                                    ->where('dealer_id',$data['dealer_id'])
                                                    ->where('serial_number',$decrypt_code)
                                                    ->update([
                                                        'code_type'=>$code_type,//小标对待
                                                        'ck_num'=>$ck_num,
                                                        'ck_order'=>$data['ck_order'],
                                                        'product_id'=>$rk_info['product_id'],
                                                        'product_code'=>$rk_info['product_code'],
                                                        'product_name'=>$rk_info['product_name'],
                                                        'barcode'=>$rk_info['barcode'],
                                                        'specifications'=>$rk_info['specifications'],
                                                        'manufacture_time'=>$rk_info['manufacture_time'],
                                                        'validity_time'=>$rk_info['validity_time'],
                                                        'unit'=>$rk_info['unit'],
                                                        'dealer_id'=>$data['dealer_id'],
                                                        'scan_type'=>1,
                                                        'ck_type'=>3,//出货方式  已入库商品出货
                                                        'order_start'=>$decrypt_code,
                                                        'order_end'=>$decrypt_code,
                                                        'is_return'=>0,//置0 很关键
                                                        'update_time'=>date("Y-m-d H:i:s")
                                                    ]);
                                            }else{
                                                Db::name('dealer_logistics_ck_code')
                                                    ->insert([
                                                        'code'=>$data['code'],
                                                        'serial_number'=> $decrypt_code,
                                                        'batch'=>$data['batch'],
                                                        'code_type'=>$code_type,//小标对待
                                                        'ck_num'=>$ck_num,
                                                        'ck_order'=>$data['ck_order'],
                                                        'product_id'=>$rk_info['product_id'],
                                                        'product_code'=>$rk_info['product_code'],
                                                        'product_name'=>$rk_info['product_name'],
                                                        'barcode'=>$rk_info['barcode'],
                                                        'specifications'=>$rk_info['specifications'],
                                                        'manufacture_time'=>$rk_info['manufacture_time'],
                                                        'validity_time'=>$rk_info['validity_time'],
                                                        'unit'=>$rk_info['unit'],
                                                        'dealer_id'=>$data['dealer_id'],
                                                        'scan_type'=>1,
                                                        'ck_type'=>3,//出货方式  已入库商品出货
                                                        'order_start'=>$decrypt_code,
                                                        'order_end'=>$decrypt_code,
                                                        'update_time'=>date("Y-m-d H:i:s")
                                                    ]);
                                            }
                                            $log=[
                                                'code'=>$data['code'],
                                                'batch'=>$data['batch'],
                                                'op_type'=>'已入库商品出库出库',
                                                'op_des'=>'出库单'.$data['ck_order'].'物流码直接出库',
                                                'dealer_id'=>$data['dealer_id'],
                                            ];
                                            Hook::listen('pda_op_log',$log);
                                            Db::commit();
                                            return JsonService::returnData(200,'出库成功',['product_name'=>$rk_info['product_name'],'num'=>$ck_num]);
                                        }

                                    }catch (\Exception $e){
                                        Db::rollback();
                                        return JsonService::returnData(500,'请联系管理员');
                                    }
                                }
                                //验证父包装
                                if($batch_info['logistics_level']&&$batch_info['logistics_level']>1) {
                                    $logistics_level_item = json_decode($batch_info['logistics_level_item'], true);
                                    $scale = [1];
                                    $section = [];
                                    foreach ($logistics_level_item as $ks => $vs) {
                                        array_push($scale, (int)$vs['num']);//=>[1,5,10]转化成数组比例
                                    }
                                    foreach ($secret_key as $kss => $vss) {
                                        array_push($section, [(int)explode('--', $vss['order'])[0], (int)explode('--', $vss['order'])[1]]);
                                    }
                                    $this->getParentCode($scale, $section, $k, (int)$decrypt_code);//查询父级包装码
                                    $parent_order = array_reverse($this->parent);//父级包装[22,44]
                                    if(count($parent_order)>0){
                                        //存在父级码
                                        foreach ($parent_order as $pk=>$pv){
                                            $p_miss_rk_code=get_no_belong_section([$pv,$pv],$origin_rk_arr);
                                            if(count($p_miss_rk_code)<1){
                                                //此处判断大标入库信息！！！！！
                                                $rk_info=Db::name('dealer_logistics_rk_code')
                                                    ->alias('a')
                                                    ->join('dealer_logistics_rk_order b','a.rk_order=b.rk_order')
                                                    ->where('a.serial_number',$pv)
                                                    ->where('a.batch',$data['batch'])
                                                    ->where('a.dealer_id',$data['dealer_id'])
                                                    ->field('b.warehouse_id,b.product_id,b.manufacture_time,b.validity_time,b.product_code,b.product_name,b.barcode,b.unit,b.specifications')
                                                    ->find();
                                                if($rk_info['warehouse_id']!=$data['warehouse_id']) return JsonService::returnData(500,'入库和出库的仓库不一致'); //开始出库
                                                Db::startTrans();//开启事务
                                                try{
                                                    //写出库单 需把入库商品 同步到出库单  有相同商品=>出库量+1 无相同商品 商品数组插到最后
                                                    $has_ck=Db::name('dealer_logistics_ck_order')
                                                        ->where('dealer_id',$data['dealer_id'])
                                                        ->where('ck_order',$data['ck_order'])
                                                        ->find();
                                                    if($has_ck){
                                                        $product=json_decode($has_ck['outwarehouse_products'],true);
                                                        //产品查重
                                                        $index=-1;
                                                        foreach ($product as $key=>$val){
                                                            if($val['product_id']==$rk_info['product_id']) {
                                                                $index=$key;
                                                                break;
                                                            }
                                                        }
                                                        if($index==-1){
                                                            $outwarehouse_products=[
                                                                [
                                                                    'product_id'=>$rk_info['product_id'],
                                                                    'product_code'=>$rk_info['product_code'],
                                                                    'product_name'=>$rk_info['product_name'],
                                                                    'barcode'=>$rk_info['barcode'],
                                                                    'unit'=>$rk_info['unit'],
                                                                    'specifications'=>$rk_info['specifications'],
                                                                    'out_num'=>$ck_num,
                                                                    'order_num'=>$ck_num
                                                                ]
                                                            ];
                                                            $product=array_merge($product,$outwarehouse_products);
                                                        }else{
                                                            $product[$index]['order_num']+=$ck_num;
                                                            $product[$index]['out_num']+=$ck_num;
                                                        }
                                                        $has_code= $is_return=Db::name('dealer_logistics_ck_code')
                                                            ->where('batch',$data['batch'])
                                                            ->where('dealer_id',$data['dealer_id'])
                                                            ->where('serial_number',$decrypt_code)
                                                            ->find();
                                                        Db::name('dealer_logistics_ck_order')
                                                            ->where('ck_order',$data['ck_order'])
                                                            ->setInc('send_sum',$ck_num);
                                                        Db::name('dealer_logistics_ck_order')
                                                            ->where('ck_order',$data['ck_order'])
                                                            ->setInc('deliver_sum',$ck_num);
                                                        //更新出库单
                                                        Db::name('dealer_logistics_ck_order')->where('ck_order',$data['ck_order'])->update([
                                                            'outwarehouse_products'=>json_encode($product)
                                                        ]);
                                                        if($has_code){
                                                            $old_product=Db::name('dealer_logistics_ck_order')
                                                                ->where('ck_order',$has_code['ck_order'])
                                                                ->where('dealer_id',$data['dealer_id'])
                                                                ->value('outwarehouse_products');
                                                            $old_product=json_decode($old_product,true);
                                                            foreach ($old_product as $okey=>$oval){
                                                                if($oval['product_id']==$has_code['product_id']){
                                                                    unset($old_product[$okey]);//移除退货重发的产品
                                                                }
                                                            }
                                                            $old_product=array_values($old_product);//重置索引
                                                            Db::name('dealer_logistics_ck_order')
                                                                ->where('ck_order',$has_code['ck_order'])
                                                                ->where('dealer_id',$data['dealer_id'])
                                                                ->update([
                                                                    'outwarehouse_products'=>json_encode($old_product)
                                                                ]);//更新发货产品
                                                            Db::name('dealer_logistics_ck_order')
                                                                ->where('ck_order',$has_code['ck_order'])
                                                                ->setDec('send_sum',$has_code['ck_num']);//实发量减
                                                            Db::name('dealer_logistics_ck_order')
                                                                ->where('ck_order',$has_code['ck_order'])
                                                                ->setDec('deliver_sum',$has_code['ck_num']);//应发量减
                                                            Db::name('dealer_logistics_ck_code')
                                                                ->where('batch',$data['batch'])
                                                                ->where('dealer_id',$data['dealer_id'])
                                                                ->where('serial_number',$decrypt_code)
                                                                ->update([
                                                                    'code_type'=>$code_type,//小标对待
                                                                    'ck_num'=>$ck_num,
                                                                    'ck_order'=>$data['ck_order'],
                                                                    'product_id'=>$rk_info['product_id'],
                                                                    'product_code'=>$rk_info['product_code'],
                                                                    'product_name'=>$rk_info['product_name'],
                                                                    'barcode'=>$rk_info['barcode'],
                                                                    'specifications'=>$rk_info['specifications'],
                                                                    'manufacture_time'=>$rk_info['manufacture_time'],
                                                                    'validity_time'=>$rk_info['validity_time'],
                                                                    'unit'=>$rk_info['unit'],
                                                                    'dealer_id'=>$data['dealer_id'],
                                                                    'scan_type'=>1,
                                                                    'ck_type'=>3,//出货方式  已入库商品出货
                                                                    'order_start'=>$decrypt_code,
                                                                    'order_end'=>$decrypt_code,
                                                                    'is_return'=>0,//置0 很关键
                                                                    'update_time'=>date("Y-m-d H:i:s")
                                                                ]);
                                                        }else{
                                                            Db::name('dealer_logistics_ck_code')
                                                                ->insert([
                                                                    'code'=>$data['code'],
                                                                    'serial_number'=> $decrypt_code,
                                                                    'batch'=>$data['batch'],
                                                                    'code_type'=>$code_type,//小标对待
                                                                    'ck_num'=>$ck_num,
                                                                    'ck_order'=>$data['ck_order'],
                                                                    'product_id'=>$rk_info['product_id'],
                                                                    'product_code'=>$rk_info['product_code'],
                                                                    'product_name'=>$rk_info['product_name'],
                                                                    'barcode'=>$rk_info['barcode'],
                                                                    'specifications'=>$rk_info['specifications'],
                                                                    'manufacture_time'=>$rk_info['manufacture_time'],
                                                                    'validity_time'=>$rk_info['validity_time'],
                                                                    'unit'=>$rk_info['unit'],
                                                                    'dealer_id'=>$data['dealer_id'],
                                                                    'scan_type'=>1,
                                                                    'ck_type'=>3,//出货方式  已入库商品出货
                                                                    'order_start'=>$decrypt_code,
                                                                    'order_end'=>$decrypt_code,
                                                                    'update_time'=>date("Y-m-d H:i:s")
                                                                ]);
                                                        }
                                                        $log=[
                                                            'code'=>$data['code'],
                                                            'batch'=>$data['batch'],
                                                            'op_type'=>'直接出库',
                                                            'op_des'=>'出库单'.$data['ck_order'].'物流码直接出库',
                                                            'dealer_id'=>$data['dealer_id'],
                                                        ];
                                                        Hook::listen('pda_op_log',$log);
                                                        Db::commit();
                                                        return JsonService::returnData(200,'出库成功',['product_name'=>$rk_info['product_name'],'num'=>$ck_num]);

                                                    }else{
                                                        $outwarehouse_products=[
                                                            [
                                                                'product_id'=>$rk_info['product_id'],
                                                                'product_name'=>$rk_info['product_name'],
                                                                'barcode'=>$rk_info['barcode'],
                                                                'unit'=>$rk_info['unit'],
                                                                'product_code'=>$rk_info['product_code'],
                                                                'specifications'=>$rk_info['specifications'],
                                                                'out_num'=>$ck_num,
                                                                'order_num'=>$ck_num
                                                            ]
                                                        ];
                                                        $data['outwarehouse_products']=json_encode($outwarehouse_products);
                                                        $data['ck_type']=3;//已入库商品发货
                                                        Db::name('dealer_logistics_ck_order')->strict(false)->insert($data);
                                                        Db::name('dealer_logistics_ck_order')
                                                            ->where('ck_order',$data['ck_order'])
                                                            ->setInc('send_sum',$ck_num);
                                                        Db::name('dealer_logistics_ck_order')
                                                            ->where('ck_order',$data['ck_order'])
                                                            ->setInc('deliver_sum',$ck_num);
                                                        $has_code= $is_return=Db::name('dealer_logistics_ck_code')
                                                            ->where('batch',$data['batch'])
                                                            ->where('dealer_id',$data['dealer_id'])
                                                            ->where('serial_number',$decrypt_code)
                                                            ->find();
                                                        if($has_code){
                                                            $old_product=Db::name('dealer_logistics_ck_order')
                                                                ->where('ck_order',$has_code['ck_order'])
                                                                ->where('dealer_id',$data['dealer_id'])
                                                                ->value('outwarehouse_products');
                                                            $old_product=json_decode($old_product,true);
                                                            foreach ($old_product as $okey=>$oval){
                                                                if($oval['product_id']==$has_code['product_id']){
                                                                    unset($old_product[$okey]);//移除退货重发的产品
                                                                }
                                                            }
                                                            $old_product=array_values($old_product);//重置索引
                                                            Db::name('dealer_logistics_ck_order')
                                                                ->where('ck_order',$has_code['ck_order'])
                                                                ->where('dealer_id',$data['dealer_id'])
                                                                ->update([
                                                                    'outwarehouse_products'=>json_encode($old_product)
                                                                ]);//更新发货产品
                                                            Db::name('dealer_logistics_ck_order')
                                                                ->where('ck_order',$has_code['ck_order'])
                                                                ->setDec('send_sum',$has_code['ck_num']);//实发量减
                                                            Db::name('dealer_logistics_ck_order')
                                                                ->where('ck_order',$has_code['ck_order'])
                                                                ->setDec('deliver_sum',$has_code['ck_num']);//应发量减
                                                            Db::name('dealer_logistics_ck_code')
                                                                ->where('batch',$data['batch'])
                                                                ->where('dealer_id',$data['dealer_id'])
                                                                ->where('serial_number',$decrypt_code)
                                                                ->update([
                                                                    'code_type'=>$code_type,//小标对待
                                                                    'ck_num'=>$ck_num,
                                                                    'ck_order'=>$data['ck_order'],
                                                                    'product_id'=>$rk_info['product_id'],
                                                                    'product_code'=>$rk_info['product_code'],
                                                                    'product_name'=>$rk_info['product_name'],
                                                                    'barcode'=>$rk_info['barcode'],
                                                                    'specifications'=>$rk_info['specifications'],
                                                                    'manufacture_time'=>$rk_info['manufacture_time'],
                                                                    'validity_time'=>$rk_info['validity_time'],
                                                                    'unit'=>$rk_info['unit'],
                                                                    'dealer_id'=>$data['dealer_id'],
                                                                    'scan_type'=>1,
                                                                    'ck_type'=>3,//出货方式  已入库商品出货
                                                                    'order_start'=>$decrypt_code,
                                                                    'order_end'=>$decrypt_code,
                                                                    'is_return'=>0,//置0 很关键
                                                                    'update_time'=>date("Y-m-d H:i:s")
                                                                ]);
                                                        }else{
                                                            Db::name('dealer_logistics_ck_code')
                                                                ->insert([
                                                                    'code'=>$data['code'],
                                                                    'serial_number'=> $decrypt_code,
                                                                    'batch'=>$data['batch'],
                                                                    'code_type'=>$code_type,//小标对待
                                                                    'ck_num'=>$ck_num,
                                                                    'ck_order'=>$data['ck_order'],
                                                                    'product_id'=>$rk_info['product_id'],
                                                                    'product_code'=>$rk_info['product_code'],
                                                                    'product_name'=>$rk_info['product_name'],
                                                                    'barcode'=>$rk_info['barcode'],
                                                                    'specifications'=>$rk_info['specifications'],
                                                                    'manufacture_time'=>$rk_info['manufacture_time'],
                                                                    'validity_time'=>$rk_info['validity_time'],
                                                                    'unit'=>$rk_info['unit'],
                                                                    'dealer_id'=>$data['dealer_id'],
                                                                    'scan_type'=>1,
                                                                    'ck_type'=>3,//出货方式  已入库商品出货
                                                                    'order_start'=>$decrypt_code,
                                                                    'order_end'=>$decrypt_code,
                                                                    'update_time'=>date("Y-m-d H:i:s")
                                                                ]);
                                                        }
                                                        $log=[
                                                            'code'=>$data['code'],
                                                            'batch'=>$data['batch'],
                                                            'op_type'=>'直接出库',
                                                            'op_des'=>'出库单'.$data['ck_order'].'物流码直接出库',
                                                            'dealer_id'=>$data['dealer_id'],
                                                        ];
                                                        Hook::listen('pda_op_log',$log);
                                                        Db::commit();
                                                        return JsonService::returnData(200,'出库成功',['product_name'=>$rk_info['product_name'],'num'=>$ck_num]);
                                                    }

                                                }catch (\Exception $e){
                                                    Db::rollback();
                                                    return JsonService::returnData(500,'请联系管理员');
                                                }
                                            }
                                        }
                                    }
                                }
                                return JsonService::returnData(500,'该物流码未入库');//直接return
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
            //快速出货 方式同web端
            $batch_info=Db::name('code_manage')
                ->where('dealer_id',$data['dealer_id'])
                ->where('scene','like','%'.'4'.'%')//查询物流码
                ->where('batch',$data['batch'])
                ->where('enable',1)
                ->find();
            if(!$batch_info) return JsonService::returnData(500,'该物流码无效');
            $secret_key=json_decode($batch_info['secret_key'],true);
            if(count($secret_key)==0){
                //不存在组套关系
                $key=explode(',',$batch_info['key']);//秘钥形式（n,d,e)
                if(strlen($data['code'])!=$batch_info['code_length']) return JsonService::returnData(500,'该物流码无效');
                $decrypt_code=bcpowmod($data['code'],$key[1],$key[0],0);
                //判断是否属于所在区间
                if($batch_info['order_begin']<=$decrypt_code&&$decrypt_code<=$batch_info['order_end']){
                    //验重 先判断是否已经出库
                    $ck_order_status=Db::name('dealer_logistics_ck_code')
                        ->where('dealer_id',$data['dealer_id'])
                        ->select();
                    if(count($ck_order_status)>0){
                        $origin_ck_arr=[];
                        foreach ($ck_order_status as $key=>$value){
                            array_push($origin_ck_arr,[(int)$value['order_start'],(int)$value['order_end']]);
                        }
                        $miss_ck_code=get_no_belong_section([(int)$decrypt_code,(int)$decrypt_code],$origin_ck_arr);
                        if(count($miss_ck_code)<1) return JsonService::returnData(500,'物流码已出库');
                    }
                    //再判断是否已入库
                    $rk_order_status=Db::name('dealer_logistics_rk_code')
                        ->where('dealer_id',$data['dealer_id'])
                        ->select();
                    if(count($rk_order_status)>0){
                        $origin_rk_arr=[];
                        foreach ($rk_order_status as $key=>$value){
                            array_push($origin_rk_arr,[(int)$value['order_start'],(int)$value['order_end']]);
                        }
                        $miss_rk_code=get_no_belong_section([(int)$decrypt_code,(int)$decrypt_code],$origin_rk_arr);
                        if(count($miss_rk_code)<1) return JsonService::returnData(500,'物流码已入库');
                    }
                    //开始出库
                    Db::startTrans();//开启事务
                    try{
                        //写入库单 同一入库单
                        $has=Db::name('dealer_logistics_rk_order')
                            ->where('dealer_id',$data['dealer_id'])
                            ->where('rk_order',$data['rk_order'])
                            ->find();
                        if(!$has){
                            Db::name('dealer_logistics_rk_order')->strict(false)->insert($data);
                        }
                        Db::name('dealer_logistics_rk_code')->insert([
                            'dealer_id'=>$data['dealer_id'],
                            'code'=>$data['code'],
                            'batch'=>$data['batch'],
                            'rk_num'=>1,//入库数量
                            'code_type'=>2,//数码类型 单个码 小标对待
                            'serial_number'=>$decrypt_code,
                            'order_start'=>$decrypt_code,//为了检索 将单个码的起始序列号存入
                            'order_end'=>$decrypt_code,
                            'product_id'=>$data['product_id'],
                            'product_name'=>$data['product_name'],
                            'product_code'=>$data['product_code'],
                            'specifications'=>$data['specifications'],
                            'unit'=>$data['unit'],
                            'barcode'=>$data['barcode'],
                            'scan_type'=>1,
                            'rk_order'=>$data['rk_order']
                        ]);
                        //入库数量加一
                        Db::name('dealer_logistics_rk_order')
                            ->where('rk_order', $data['rk_order'])
                            ->setInc('rk_num');
                        Db::name('dealer_logistics_rk_order')
                            ->where('rk_order', $data['rk_order'])
                            ->setInc('quantity');
                        //写出库单
                        $has_ck=Db::name('dealer_logistics_ck_order')
                            ->where('dealer_id',$data['dealer_id'])
                            ->where('ck_order',$data['ck_order'])
                            ->find();
                        if($has_ck){
                            $product=json_decode($has_ck['outwarehouse_products'],true);
                            //产品查重
                            $index=-1;
                            foreach ($product as $key=>$val){
                                if($val['product_id']==$data['product_id']) {
                                    $index=$key;
                                    break;
                                }
                            }
                            if($index==-1){
                                $outwarehouse_products=[
                                    [
                                        'product_id'=>$data['product_id'],
                                        'product_code'=>$data['product_code'],
                                        'product_name'=>$data['product_name'],
                                        'barcode'=>$data['barcode'],
                                        'manufacture_time'=>$data['manufacture_time'],
                                        'validity_time'=>$data['validity_time'],
                                        'unit'=>$data['unit'],
                                        'specifications'=>$data['specifications'],
                                        'out_num'=>1,
                                        'order_num'=>1
                                    ]
                                ];
                                $product=array_merge($product,$outwarehouse_products);
                            }else{
                                $product[$index]['order_num']++;
                                $product[$index]['out_num']++;
                            }
                            Db::name('dealer_logistics_ck_order')
                                ->where('ck_order',$data['ck_order'])
                                ->setInc('send_sum');
                            Db::name('dealer_logistics_ck_order')
                                ->where('ck_order',$data['ck_order'])
                                ->setInc('deliver_sum');
                            //更新出库单
                            Db::name('dealer_logistics_ck_order')->where('ck_order',$data['ck_order'])->update([
                                'outwarehouse_products'=>json_encode($product)
                            ]);
                            Db::name('dealer_logistics_ck_code')
                                ->insert([
                                    'code'=>$data['code'],
                                    'serial_number'=> $decrypt_code,
                                    'batch'=>$data['batch'],
                                    'code_type'=>2,//小标对待
                                    'ck_num'=>1,
                                    'ck_order'=>$data['ck_order'],
                                    'product_id'=>$data['product_id'],
                                    'product_code'=>$data['product_code'],
                                    'product_name'=>$data['product_name'],
                                    'barcode'=>$data['barcode'],
                                    'manufacture_time'=>$data['manufacture_time'],
                                    'validity_time'=>$data['validity_time'],
                                    'unit'=>$data['unit'],
                                    'specifications'=>$data['specifications'],
                                    'dealer_id'=>$data['dealer_id'],
                                    'scan_type'=>1,
                                    'ck_type'=>2,//出货方式  已入库商品出货
                                    'order_start'=>$decrypt_code,
                                    'order_end'=>$decrypt_code
                                ]);
                            $log=[
                                'code'=>$data['code'],
                                'batch'=>$data['batch'],
                                'op_type'=>'快速出库',
                                'op_des'=>'出库单'.$data['ck_order'].'物流码快速出库',
                                'dealer_id'=>$data['dealer_id'],
                            ];
                            Hook::listen('pda_op_log',$log);
                            Db::commit();
                            return JsonService::returnData(200,'出库成功',['product_name'=>$data['product_name'],'num'=>1]);
                        }else{
                            $outwarehouse_products=[
                                [
                                    'product_id'=>$data['product_id'],
                                    'product_name'=>$data['product_name'],
                                    'barcode'=>$data['barcode'],
                                    'unit'=>$data['unit'],
                                    'manufacture_time'=>$data['manufacture_time'],
                                    'validity_time'=>$data['validity_time'],
                                    'product_code'=>$data['product_code'],
                                    'specifications'=>$data['specifications'],
                                    'out_num'=>1,
                                    'order_num'=>1
                                ]
                            ];
                            $data['outwarehouse_products']=json_encode($outwarehouse_products);
                            $data['ck_type']=2;//已入库商品发货
                            Db::name('dealer_logistics_ck_order')->strict(false)->insert($data);
                            Db::name('dealer_logistics_ck_order')
                                ->where('ck_order',$data['ck_order'])
                                ->setInc('send_sum');
                            Db::name('dealer_logistics_ck_order')
                                ->where('ck_order',$data['ck_order'])
                                ->setInc('deliver_sum');
                            Db::name('dealer_logistics_ck_code')
                                ->insert([
                                    'code'=>$data['code'],
                                    'serial_number'=> $decrypt_code,
                                    'batch'=>$data['batch'],
                                    'code_type'=>2,//小标对待
                                    'ck_num'=>1,
                                    'ck_order'=>$data['ck_order'],
                                    'product_id'=>$data['product_id'],
                                    'product_code'=>$data['product_code'],
                                    'product_name'=>$data['product_name'],
                                    'barcode'=>$data['barcode'],
                                    'manufacture_time'=>$data['manufacture_time'],
                                    'validity_time'=>$data['validity_time'],
                                    'unit'=>$data['unit'],
                                    'specifications'=>$data['specifications'],
                                    'dealer_id'=>$data['dealer_id'],
                                    'scan_type'=>1,
                                    'ck_type'=>2,//出货方式  已入库商品出货
                                    'order_start'=>$decrypt_code,
                                    'order_end'=>$decrypt_code
                                ]);
                            $log=[
                                'code'=>$data['code'],
                                'batch'=>$data['batch'],
                                'op_type'=>'快速出库',
                                'op_des'=>'出库单'.$data['ck_order'].'物流码快速出库',
                                'dealer_id'=>$data['dealer_id'],
                            ];
                            Hook::listen('pda_op_log',$log);
                            Db::commit();
                            return JsonService::returnData(200,'出库成功',['product_name'=>$data['product_name'],'num'=>1]);
                        }
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
                            //验重
                            $ck_order_status=Db::name('dealer_logistics_ck_code')
                                ->where('dealer_id',$data['dealer_id'])
                                ->select();
                            $rk_order_status=Db::name('dealer_logistics_rk_code')
                                ->where('dealer_id',$data['dealer_id'])
                                ->select();
                            $code_type=2;
                            $ck_num=1;//默认
                            if(count($ck_order_status)>0){
                                //自身验证是否出过库
                                $origin_ck_arr=[];
                                foreach ($ck_order_status as $key=>$value){
                                    array_push($origin_ck_arr,[(int)$value['order_start'],(int)$value['order_end']]);
                                }
                                $miss_ck_code=get_no_belong_section([(int)$decrypt_code,(int)$decrypt_code],$origin_ck_arr);
                                if(count($miss_ck_code)<1) return JsonService::returnData(500,'物流码已出库');
                                //判断父级包装是否出库
                                if($batch_info['logistics_level']&&$batch_info['logistics_level']>1){
                                    $logistics_level_item=json_decode($batch_info['logistics_level_item'],true);
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
                                            if(count($p_miss_rk_code)<1) return JsonService::returnData(500,'外包装已出库！');
                                        }
                                    }
                                }
                            }
                            if(count($rk_order_status)>0){
                                //自身验证是否入过库
                                $origin_rk_arr=[];
                                foreach ($rk_order_status as $key=>$value){
                                    array_push($origin_rk_arr,[(int)$value['order_start'],(int)$value['order_end']]);
                                }
                                $miss_rk_code=get_no_belong_section([(int)$decrypt_code,(int)$decrypt_code],$origin_rk_arr);
                                if(count($miss_rk_code)<1) return JsonService::returnData(500,'物流码已入库');
                                //判断父级包装是否入库
                                if($batch_info['logistics_level']&&$batch_info['logistics_level']>1){
                                    $logistics_level_item=json_decode($batch_info['logistics_level_item'],true);
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
                                            $p_miss_rk_code=get_no_belong_section([$pv,$pv],$origin_rk_arr);
                                            if(count($p_miss_rk_code)<1) return JsonService::returnData(500,'外包装已入库！');
                                        }
                                    }
                                }
                            }
                            //查询码关系与入库数量
                            if($batch_info['logistics_level']&&$batch_info['logistics_level']>1){
                                $logistics_level_item=json_decode($batch_info['logistics_level_item'],true);
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
                                    if($batch_info['logistics_level']==2){
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
                            //开始写入库出库单
                            //开始出库
                            Db::startTrans();//开启事务
                            try{
                                //写入库单 同一入库单
                                $has=Db::name('dealer_logistics_rk_order')
                                    ->where('dealer_id',$data['dealer_id'])
                                    ->where('rk_order',$data['rk_order'])
                                    ->find();
                                if(!$has){
                                    Db::name('dealer_logistics_rk_order')->strict(false)->insert($data);
                                }
                                Db::name('dealer_logistics_rk_code')->insert([
                                    'dealer_id'=>$data['dealer_id'],
                                    'code'=>$data['code'],
                                    'batch'=>$data['batch'],
                                    'rk_num'=>$ck_num,//入库数量
                                    'code_type'=>$code_type,//数码类型 单个码 小标对待
                                    'serial_number'=>$decrypt_code,
                                    'order_start'=>$decrypt_code,//为了检索 将单个码的起始序列号存入
                                    'order_end'=>$decrypt_code,
                                    'product_id'=>$data['product_id'],
                                    'product_name'=>$data['product_name'],
                                    'product_code'=>$data['product_code'],
                                    'specifications'=>$data['specifications'],
                                    'unit'=>$data['unit'],
                                    'barcode'=>$data['barcode'],
                                    'scan_type'=>1,
                                    'rk_order'=>$data['rk_order']
                                ]);
                                //入库数量加一
                                Db::name('dealer_logistics_rk_order')
                                    ->where('rk_order', $data['rk_order'])
                                    ->setInc('rk_num',$ck_num);
                                Db::name('dealer_logistics_rk_order')
                                    ->where('rk_order', $data['rk_order'])
                                    ->setInc('quantity',$ck_num);
                                //写出库单
                                $has_ck=Db::name('dealer_logistics_ck_order')
                                    ->where('dealer_id',$data['dealer_id'])
                                    ->where('ck_order',$data['ck_order'])
                                    ->find();
                                if($has_ck){
                                    $product=json_decode($has_ck['outwarehouse_products'],true);
                                    //产品查重
                                    $index=-1;
                                    foreach ($product as $key=>$vall){
                                        if($vall['product_id']==$data['product_id']) {
                                            $index=$key;
                                            break;
                                        }
                                    }
                                    if($index==-1){
                                        $outwarehouse_products=[
                                            [
                                                'product_id'=>$data['product_id'],
                                                'product_code'=>$data['product_code'],
                                                'product_name'=>$data['product_name'],
                                                'barcode'=>$data['barcode'],
                                                'unit'=>$data['unit'],
                                                'manufacture_time'=>$data['manufacture_time'],
                                                'validity_time'=>$data['validity_time'],
                                                'specifications'=>$data['specifications'],
                                                'out_num'=>$ck_num,
                                                'order_num'=>$ck_num
                                            ]
                                        ];
                                        $product=array_merge($product,$outwarehouse_products);
                                    }else{
                                        $product[$index]['order_num']+=$ck_num;
                                        $product[$index]['out_num']+=$ck_num;
                                    }
                                    Db::name('dealer_logistics_ck_order')
                                        ->where('ck_order',$data['ck_order'])
                                        ->setInc('send_sum',$ck_num);
                                    Db::name('dealer_logistics_ck_order')
                                        ->where('ck_order',$data['ck_order'])
                                        ->setInc('deliver_sum',$ck_num);
                                    //更新出库单
                                    Db::name('dealer_logistics_ck_order')->where('ck_order',$data['ck_order'])->update([
                                        'outwarehouse_products'=>json_encode($product)
                                    ]);
                                    Db::name('dealer_logistics_ck_code')
                                        ->insert([
                                            'code'=>$data['code'],
                                            'serial_number'=> $decrypt_code,
                                            'batch'=>$data['batch'],
                                            'code_type'=>$code_type,//小标对待
                                            'ck_num'=>$ck_num,
                                            'ck_order'=>$data['ck_order'],
                                            'product_id'=>$data['product_id'],
                                            'product_code'=>$data['product_code'],
                                            'product_name'=>$data['product_name'],
                                            'barcode'=>$data['barcode'],
                                            'unit'=>$data['unit'],
                                            'manufacture_time'=>$data['manufacture_time'],
                                            'validity_time'=>$data['validity_time'],
                                            'specifications'=>$data['specifications'],
                                            'dealer_id'=>$data['dealer_id'],
                                            'scan_type'=>1,
                                            'ck_type'=>2,//出货方式  快速出货
                                            'order_start'=>$decrypt_code,
                                            'order_end'=>$decrypt_code
                                        ]);
                                    $log=[
                                        'code'=>$data['code'],
                                        'batch'=>$data['batch'],
                                        'op_type'=>'快速出库',
                                        'op_des'=>'出库单'.$data['ck_order'].'物流码快速出库',
                                        'dealer_id'=>$data['dealer_id'],
                                    ];
                                    Hook::listen('pda_op_log',$log);
                                    Db::commit();
                                    return JsonService::returnData(200,'出库成功',['product_name'=>$data['product_name'],'num'=>$ck_num]);
                                }else{
                                    $outwarehouse_products=[
                                        [
                                            'product_id'=>$data['product_id'],
                                            'product_name'=>$data['product_name'],
                                            'barcode'=>$data['barcode'],
                                            'unit'=>$data['unit'],
                                            'manufacture_time'=>$data['manufacture_time'],
                                            'validity_time'=>$data['validity_time'],
                                            'product_code'=>$data['product_code'],
                                            'specifications'=>$data['specifications'],
                                            'out_num'=>$ck_num,
                                            'order_num'=>$ck_num
                                        ]
                                    ];
                                    $data['outwarehouse_products']=json_encode($outwarehouse_products);
                                    $data['ck_type']=2;//快速出货
                                    Db::name('dealer_logistics_ck_order')->strict(false)->insert($data);
                                    Db::name('dealer_logistics_ck_order')
                                        ->where('ck_order',$data['ck_order'])
                                        ->setInc('send_sum',$ck_num);
                                    Db::name('dealer_logistics_ck_order')
                                        ->where('ck_order',$data['ck_order'])
                                        ->setInc('deliver_sum',$ck_num);
                                    Db::name('dealer_logistics_ck_code')
                                        ->insert([
                                            'code'=>$data['code'],
                                            'serial_number'=> $decrypt_code,
                                            'batch'=>$data['batch'],
                                            'code_type'=>$code_type,//小标对待
                                            'ck_num'=>$ck_num,
                                            'ck_order'=>$data['ck_order'],
                                            'product_id'=>$data['product_id'],
                                            'product_code'=>$data['product_code'],
                                            'product_name'=>$data['product_name'],
                                            'barcode'=>$data['barcode'],
                                            'unit'=>$data['unit'],
                                            'manufacture_time'=>$data['manufacture_time'],
                                            'validity_time'=>$data['validity_time'],
                                            'specifications'=>$data['specifications'],
                                            'dealer_id'=>$data['dealer_id'],
                                            'scan_type'=>1,
                                            'ck_type'=>2,//出货方式  已入库商品出货
                                            'order_start'=>$decrypt_code,
                                            'order_end'=>$decrypt_code
                                        ]);
                                    $log=[
                                        'code'=>$data['code'],
                                        'batch'=>$data['batch'],
                                        'op_type'=>'快速出库',
                                        'op_des'=>'出库单'.$data['ck_order'].'物流码快速出库',
                                        'dealer_id'=>$data['dealer_id'],
                                    ];
                                    Hook::listen('pda_op_log',$log);
                                    Db::commit();
                                    return JsonService::returnData(200,'出库成功',['product_name'=>$data['product_name'],'num'=>$ck_num]);
                                }
                            }catch (\Exception $e){
                                Db::rollback();
                                return JsonService::returnData(500,$e->getMessage());
                            }

                        }else{
                            return JsonService::returnData(500,'该物流码无效',$decrypt_code);
                            break;
                        }
                    }
                }
                return JsonService::returnData(500,'该物流码无效');
            }
        }
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