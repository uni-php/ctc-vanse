<?php
/**
 * Created by PhpStorm.
 * User: wenhan
 * Date: 2022/4/5
 * Time: 下午2:39
 */

namespace app\pda\controller;
use app\Request;
use think\Controller;
use think\Db;
use app\common\JsonService;
use think\db\Where;

class DCManage extends Controller
{
    protected $parent=[];//父级包装
    protected $child=[];//子包装码
    public function getDcOrderInfo(Request $request){
        $params=$request->get();
        $info=Db::name('dealer_logistics_dc_order')->where('dc_order',$params['dc_order'])->find();
        if($info){
            $info['dc_products']=json_decode($info['dc_products'],true);
            return JsonService::returnData(200,'查询成功',$info);
        }else{
            return JsonService::returnData(500,'单号不存在');
        }
    }
    public function getDcOrderList(Request $request){
        $params=$request->get();
        $list=Db::name('dealer_logistics_dc_order')
            ->whereColumn('order_num','>','transfer_num')
            ->where('dc_order','like','%'.$params['dc_order'].'%')
            ->where('dealer_id',$params['dealer_id'])
            ->where('is_del',0)
            ->page($params['page'])
            ->limit($params['pageSize'])
            ->order('create_time','desc')
            ->select();
        $sum=Db::name('dealer_logistics_dc_order')
            ->whereColumn('order_num','>','transfer_num')
            ->where('dc_order','like','%'.$params['dc_order'].'%')
            ->where('is_del',0)
            ->where('dealer_id',$params['dealer_id'])
            ->count();
        $data=[
            'list'=>[
                'current_page'=>$params['page'],
                'total'=>$sum,
                'per_page'=>$params['pageSize'],
                'data'=>$list
            ]
        ];
        return JsonService::returnData(200,'查询成功',$data);
    }

    /**
     * @param Request $request
     * 调仓算法
     * 大小标判断 是否存在比例关系
     * 物流码存在判断=>物流码是否出库=>调仓出库选择的产品与物流码入库产品不一致=>超过最大出库数量请选择另一调仓单号=>物流码在该调仓单下已入库
     */
    public function saveDcOrder(Request $request){
//        return JsonService::returnData(500,'该物流码无效');
        $data=$request->post();
        //物流码调仓
        if($data['scan_type']==1){
            //判断物流码是否存在
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
                    //先判断是否已经出库(需未出库) 并且没有退货
                    $ck_order_status=Db::name('dealer_logistics_ck_code')
                        ->where('dealer_id',$data['dealer_id'])
                        ->where('is_return',0)
                        ->select();
                    if(count($ck_order_status)>0){
                        $origin_ck_arr=[];
                        foreach ($ck_order_status as $key=>$value){
                            array_push($origin_ck_arr,[(int)$value['order_start'],(int)$value['order_end']]);
                        }
                        $miss_ck_code=get_no_belong_section([(int)$decrypt_code,(int)$decrypt_code],$origin_ck_arr);
                        if(count($miss_ck_code)<1) return JsonService::returnData(500,'物流码已出库');
                    }
                    //再判断是否入库（需入库）
                    $rk_order_status=Db::name('dealer_logistics_rk_code')
                        ->where('dealer_id',$data['dealer_id'])
                        ->select();
                    if(count($rk_order_status)>0){
                        $origin_rk_arr=[];
                        foreach ($rk_order_status as $key=>$value){
                            array_push($origin_rk_arr,[(int)$value['order_start'],(int)$value['order_end']]);
                        }
                        $miss_rk_code=get_no_belong_section([(int)$decrypt_code,(int)$decrypt_code],$origin_rk_arr);
                        if(count($miss_rk_code)>=1) return JsonService::returnData(500,'该物流码未入库');
                    }else{
                        return JsonService::returnData(500,'该物流码未入库');
                    }
                    //符合上述条件 判断产品是否一致
                    $dc_info=Db::name('dealer_logistics_dc_order')
                        ->where('dealer_id',$data['dealer_id'])
                        ->where('dc_order',$data['dc_order'])
                        ->find();
                    $rk_info=Db::name('dealer_logistics_rk_code')
                        ->alias('a')
                        ->join('dealer_logistics_rk_order b','a.rk_order=b.rk_order')
                        ->where('a.code',$data['code'])
                        ->where('a.dealer_id',$data['dealer_id'])
                        ->field('b.warehouse_id,b.product_id,b.product_code,b.product_name,b.barcode,b.unit,b.specifications,b.manufacture_time,b.validity_time,b.product_batch')
                        ->find();
                    $index=-1;
                    $dc_products=json_decode($dc_info['dc_products'],true);
                    foreach ($dc_products as $key=>$val){
                        if($val['product_id']==$rk_info['product_id']) {
                            $index=$key;
                            break;
                        }
                    }
                    if($index==-1) return JsonService::returnData(500,'入库产品与调仓产品不一致');
                    //判断是否超出最大量
                    if($dc_products[$index]['dc_num']>=$dc_products[$index]['order_num']) return JsonService::returnData(500,'该产品超过最大调仓数量请选择另一调仓单号');
                    //判断 物流码在该调仓单下是否已入库
                    $has_dc=Db::name('dealer_logistics_dc_code')
                        ->where('dealer_id',$data['dealer_id'])
                        ->where('batch',$data['batch'])
                        ->where('code',$data['code'])
                        ->find();
                    if($has_dc) return JsonService::returnData(500,'物流码在该调仓单下已入库');
                    //开始调仓 写调仓单 写调仓码表
                    Db::startTrans();//开启事务
                    try{
                        //更新调仓单商品信息
                        $dc_products[$index]['dc_num']++;
                        Db::name('dealer_logistics_dc_order')
                            ->where('dealer_id',$data['dealer_id'])
                            ->where('dc_order',$data['dc_order'])
                            ->update([
                               'dc_products'=>json_encode($dc_products)
                            ]);
                        Db::name('dealer_logistics_dc_order')
                            ->where('dealer_id',$data['dealer_id'])
                            ->where('dc_order',$data['dc_order'])
                            ->setInc('transfer_num');
                        Db::name('dealer_logistics_dc_code')
                            ->insert([
                               'code'=>$data['code'],
                               'serial_number'=>$decrypt_code,
                               'batch'=>$data['batch'],
                               'code_type'=>2,
                               'dc_num'=>1,
                               'dc_order'=>$data['dc_order'],
                               'product_id'=>$rk_info['product_id'],
                               'product_batch'=>$rk_info['product_batch'],
                                'specifications'=>$rk_info['specifications'],
                                'unit'=>$rk_info['unit'],
                                'barcode'=>$rk_info['barcode'],
                                'product_code'=>$rk_info['product_code'],
                                'dealer_id'=>$data['dealer_id']

                            ]);
                        Db::commit();
                        return JsonService::returnData(200,'调仓成功',['num'=>1]);
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
                            $ck_order_status=Db::name('dealer_logistics_ck_code')
                                ->where('dealer_id',$data['dealer_id'])
                                ->where('is_return',0)
                                ->select();
                            $rk_order_status=Db::name('dealer_logistics_rk_code')
                                ->where('dealer_id',$data['dealer_id'])
                                ->select();
                            $code_type=2;//默认小标
                            $ck_num=1;//默认
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
                                if(count($miss_rk_code)<1){
                                    //本身入库 继续判断 判断产品是否一致
                                    $dc_info=Db::name('dealer_logistics_dc_order')
                                        ->where('dealer_id',$data['dealer_id'])
                                        ->where('dc_order',$data['dc_order'])
                                        ->find();
                                    $rk_info=Db::name('dealer_logistics_rk_code')
                                        ->alias('a')
                                        ->join('dealer_logistics_rk_order b','a.rk_order=b.rk_order')
                                        ->where('a.code',$data['code'])
                                        ->where('a.dealer_id',$data['dealer_id'])
                                        ->field('b.warehouse_id,b.product_id,b.product_code,b.product_name,b.barcode,b.unit,b.specifications,b.manufacture_time,b.validity_time,b.product_batch')
                                        ->find();
                                    $index=-1;
                                    $dc_products=json_decode($dc_info['dc_products'],true);
                                    foreach ($dc_products as $key=>$vals){
                                        if($vals['product_id']==$rk_info['product_id']) {
                                            $index=$key;
                                            break;
                                        }
                                    }
                                    if($index==-1) return JsonService::returnData(500,'入库产品与调仓产品不一致');
                                    //判断是否超出最大量
                                    if($dc_products[$index]['dc_num']+$ck_num>$dc_products[$index]['order_num']) return JsonService::returnData(500,'该产品超过最大调仓数量请选择另一调仓单号');
                                    //判断 物流码在该调仓单下是否已入库
                                    $has_dc=Db::name('dealer_logistics_dc_code')
                                        ->where('dealer_id',$data['dealer_id'])
                                        ->where('batch',$data['batch'])
                                        ->where('code',$data['code'])
                                        ->find();
                                    if($has_dc) return JsonService::returnData(500,'物流码在该调仓单下已入库');
                                    //开始调仓 写调仓单 写调仓码表
                                    Db::startTrans();//开启事务
                                    try{
                                        //更新调仓单商品信息
                                        $dc_products[$index]['dc_num']+=$ck_num;
                                        Db::name('dealer_logistics_dc_order')
                                            ->where('dealer_id',$data['dealer_id'])
                                            ->where('dc_order',$data['dc_order'])
                                            ->update([
                                                'dc_products'=>json_encode($dc_products)
                                            ]);
                                        Db::name('dealer_logistics_dc_order')
                                            ->where('dealer_id',$data['dealer_id'])
                                            ->where('dc_order',$data['dc_order'])
                                            ->setInc('transfer_num',$ck_num);
                                        Db::name('dealer_logistics_dc_code')
                                            ->insert([
                                                'code'=>$data['code'],
                                                'serial_number'=>$decrypt_code,
                                                'batch'=>$data['batch'],
                                                'code_type'=>$code_type,
                                                'dc_num'=>$ck_num,
                                                'dc_order'=>$data['dc_order'],
                                                'product_id'=>$rk_info['product_id'],
                                                'product_batch'=>$rk_info['product_batch'],
                                                'specifications'=>$rk_info['specifications'],
                                                'unit'=>$rk_info['unit'],
                                                'barcode'=>$rk_info['barcode'],
                                                'product_code'=>$rk_info['product_code'],
                                                'dealer_id'=>$data['dealer_id']

                                            ]);
                                        Db::commit();
                                        return JsonService::returnData(200,'调仓成功',['num'=>$ck_num]);
                                    }catch (\Exception $e){
                                        Db::rollback();
                                        return JsonService::returnData(500,'请联系管理员');
                                    }
                                }
                                //验证父包装是否入库
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
                                            if(count($p_miss_rk_code)<1){
                                                //父包装已入库
                                                $dc_info=Db::name('dealer_logistics_dc_order')
                                                    ->where('dealer_id',$data['dealer_id'])
                                                    ->where('dc_order',$data['dc_order'])
                                                    ->find();
                                                $rk_info=Db::name('dealer_logistics_rk_code')
                                                    ->alias('a')
                                                    ->join('dealer_logistics_rk_order b','a.rk_order=b.rk_order')
                                                    ->where('a.serial_number',$pv)
                                                    ->where('a.batch',$data['batch'])
                                                    ->where('a.dealer_id',$data['dealer_id'])
                                                    ->field('b.warehouse_id,b.product_id,b.product_code,b.product_name,b.barcode,b.unit,b.specifications,b.manufacture_time,b.validity_time,b.product_batch')
                                                    ->find();
                                                $index=-1;
                                                $dc_products=json_decode($dc_info['dc_products'],true);
                                                foreach ($dc_products as $key=>$vals){
                                                    if($vals['product_id']==$rk_info['product_id']) {
                                                        $index=$key;
                                                        break;
                                                    }
                                                }
                                                if($index==-1) return JsonService::returnData(500,'入库产品与调仓产品不一致');
                                                //判断是否超出最大量
                                                if($dc_products[$index]['dc_num']+$ck_num>$dc_products[$index]['order_num']) return JsonService::returnData(500,'该产品超过最大调仓数量请选择另一调仓单号');
                                                //判断 物流码在该调仓单下是否已入库
                                                $has_dc=Db::name('dealer_logistics_dc_code')
                                                    ->where('dealer_id',$data['dealer_id'])
                                                    ->where('batch',$data['batch'])
                                                    ->where('code',$data['code'])
                                                    ->find();
                                                if($has_dc) return JsonService::returnData(500,'物流码在该调仓单下已入库');
                                                Db::startTrans();//开启事务
                                                try{
                                                    //更新调仓单商品信息
                                                    $dc_products[$index]['dc_num']+=$ck_num;
                                                    Db::name('dealer_logistics_dc_order')
                                                        ->where('dealer_id',$data['dealer_id'])
                                                        ->where('dc_order',$data['dc_order'])
                                                        ->update([
                                                            'dc_products'=>json_encode($dc_products)
                                                        ]);
                                                    Db::name('dealer_logistics_dc_order')
                                                        ->where('dealer_id',$data['dealer_id'])
                                                        ->where('dc_order',$data['dc_order'])
                                                        ->setInc('transfer_num',$ck_num);
                                                    Db::name('dealer_logistics_dc_code')
                                                        ->insert([
                                                            'code'=>$data['code'],
                                                            'serial_number'=>$decrypt_code,
                                                            'batch'=>$data['batch'],
                                                            'code_type'=>$code_type,
                                                            'dc_num'=>$ck_num,
                                                            'dc_order'=>$data['dc_order'],
                                                            'product_id'=>$rk_info['product_id'],
                                                            'product_batch'=>$rk_info['product_batch'],
                                                            'specifications'=>$rk_info['specifications'],
                                                            'unit'=>$rk_info['unit'],
                                                            'barcode'=>$rk_info['barcode'],
                                                            'product_code'=>$rk_info['product_code'],
                                                            'dealer_id'=>$data['dealer_id']

                                                        ]);
                                                    Db::commit();
                                                    return JsonService::returnData(200,'调仓成功',['num'=>$ck_num]);
                                                }catch (\Exception $e){
                                                    Db::rollback();
                                                    return JsonService::returnData(500,'请联系管理员');
                                                }
                                            }
                                        }
                                    }
                                }
                                return JsonService::returnData(500,'该物流码未入库');//直接return
                            }else{
                                return JsonService::returnData(500,'该物流码未入库');
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
            //流水号调仓
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
                $secret_key=json_decode($between['secret_key'],true);
                if(count($secret_key)==0){
                    //不存在组套关系
                    $ck_order_status=Db::name('dealer_logistics_ck_code')
                        ->where('dealer_id',$data['dealer_id'])
                        ->where('is_return',0)
                        ->select();
                    if(count($ck_order_status)>0){
                        $origin_ck_arr=[];
                        foreach ($ck_order_status as $key=>$value){
                            array_push($origin_ck_arr,[(int)$value['order_start'],(int)$value['order_end']]);
                        }
                        $miss_ck_code=get_no_belong_section([(int)$data['order_start'],(int)$data['order_end']],$origin_ck_arr);
                        if(count($miss_ck_code)<1) return JsonService::returnData(500,'物流码已出库');
                    }
                    //再判断是否入库（需入库）
                    $rk_order_status=Db::name('dealer_logistics_rk_code')
                        ->where('dealer_id',$data['dealer_id'])
                        ->select();
                    if(count($rk_order_status)>0){
                        $origin_rk_arr=[];
                        foreach ($rk_order_status as $key=>$value){
                            array_push($origin_rk_arr,[(int)$value['order_start'],(int)$value['order_end']]);
                        }
                        $miss_rk_code=get_no_belong_section([(int)$data['order_start'],(int)$data['order_end']],$origin_rk_arr);
                        if(count($miss_rk_code)<1){
                            //符合上述条件 判断产品是否一致
                            $dc_info=Db::name('dealer_logistics_dc_order')
                                ->where('dealer_id',$data['dealer_id'])
                                ->where('dc_order',$data['dc_order'])
                                ->find();
                            //调仓序号需与入库序号严格对应
                            $rk_info=Db::name('dealer_logistics_rk_code')
                                ->alias('a')
                                ->join('dealer_logistics_rk_order b','a.rk_order=b.rk_order')
                                ->where('a.dealer_id',$data['dealer_id'])
                                ->where('a.order_start',$data['order_start'])
                                ->where('a.order_end',$data['order_end'])
                                ->field('b.warehouse_id,b.product_id,b.product_code,b.product_name,b.barcode,b.unit,b.specifications,b.manufacture_time,b.validity_time,b.product_batch')
                                ->find();
                            $index=-1;
                            $dc_products=json_decode($dc_info['dc_products'],true);
                            foreach ($dc_products as $key=>$val){
                                if($val['product_id']==$rk_info['product_id']) {
                                    $index=$key;
                                    break;
                                }
                            }
                            if($index==-1) return JsonService::returnData(500,'入库产品与调仓产品不一致');
                            //判断是否超出最大量
                            $dc_num=$data['order_end']-$data['order_start']+1;
                            if($dc_products[$index]['dc_num']+$dc_num>$dc_products[$index]['order_num']) return JsonService::returnData(500,'该产品超过最大调仓数量请选择另一调仓单号');
                            //判断 物流码在该调仓单下是否已入库
                            $has_dc=Db::name('dealer_logistics_dc_code')
                                ->where('dealer_id',$data['dealer_id'])
                                ->where('order_start','<=',$data['order_start'])
                                ->where('order_end','>=',$data['order_end'])
                                ->find();
                            if($has_dc) return JsonService::returnData(500,'流水号在该调仓单下已入库');
                            //开始调仓 写调仓单 写调仓码表
                            Db::startTrans();//开启事务
                            try{
                                //更新调仓单商品信息
                                $dc_products[$index]['dc_num']+=$dc_num;
                                Db::name('dealer_logistics_dc_order')
                                    ->where('dealer_id',$data['dealer_id'])
                                    ->where('dc_order',$data['dc_order'])
                                    ->update([
                                        'dc_products'=>json_encode($dc_products)
                                    ]);
                                Db::name('dealer_logistics_dc_order')
                                    ->where('dealer_id',$data['dealer_id'])
                                    ->where('dc_order',$data['dc_order'])
                                    ->setInc('transfer_num',$dc_num);
                                Db::name('dealer_logistics_dc_code')
                                    ->insert([
                                        'batch'=>$data['batch'],
                                        'code_type'=>2,
                                        'dc_num'=>$dc_num,
                                        'dc_order'=>$data['dc_order'],
                                        'product_id'=>$rk_info['product_id'],
                                        'product_batch'=>$rk_info['product_batch'],
                                        'specifications'=>$rk_info['specifications'],
                                        'unit'=>$rk_info['unit'],
                                        'barcode'=>$rk_info['barcode'],
                                        'product_code'=>$rk_info['product_code'],
                                        'dealer_id'=>$data['dealer_id'],
                                        'order_start'=>$data['order_start'],
                                        'order_end'=>$data['order_end']

                                    ]);
                                Db::commit();
                                return JsonService::returnData(200,'调仓成功',['num'=>$dc_num]);
                            }catch (\Exception $e){
                                Db::rollback();
                                return JsonService::returnData(500,'请联系管理员');
                            }

                        }else{
                            return JsonService::returnData(500,'流水号未入库');
                        }

                    }else{
                        return JsonService::returnData(500,'流水号未入库');
                    }
                }else{
                    //存在组套关系
                    foreach ($secret_key as $k=>$val){
                        //判断是否出库
                        $order=explode('--',$val['order']);
                        $ck_order_status=Db::name('dealer_logistics_ck_code')
                            ->where('dealer_id',$data['dealer_id'])
                            ->where('is_return',0)
                            ->select();
                        if(count($ck_order_status)>0){
                            //自身验证是否出过库
                            $origin_ck_arr=[];
                            foreach ($ck_order_status as $key=>$value){
                                array_push($origin_ck_arr,[(int)$value['order_start'],(int)$value['order_end']]);
                            }
                            $miss_ck_code=get_no_belong_section([(int)$data['order_start'],(int)$data['order_end']],$origin_ck_arr);
                            if(count($miss_ck_code)<($data['order_end']-$data['order_start']+1)) return JsonService::returnData(500,'流水号存在出库序列');
                            //验证父级是否出库了
                            if($between['logistics_level']&&$between['logistics_level']>1){
                                $logistics_level_item=json_decode($between['logistics_level_item'],true);
                                $scale=[1];
                                $section=[];
                                foreach ($logistics_level_item as $ks=>$vs){
                                    array_push($scale,(int)$vs['num']);//=>[1,5,10]转化成数组比例
                                }
                                foreach ($secret_key as $kss=>$vss){
                                    array_push($section,[(int)explode('--',$vss['order'])[0],(int)explode('--',$vss['order'])[1]]);
                                }
                                for($i=$data['order_start'];$i<=$data['order_end'];$i++){
                                    $this->getParentCode($scale,$section,$k,(int)$i);//查询父级包装码
                                    $parent_order=array_reverse($this->parent);//父级包装[22,44]
                                    if(count($parent_order)>0){
                                        //存在父级码
                                        foreach ($parent_order as $pk=>$pv){
                                            $p_miss_rk_code=get_no_belong_section([$pv,$pv],$origin_ck_arr);
                                            if(count($p_miss_rk_code)<1) return JsonService::returnData(500,'外包装存在出库流水号');
                                        }
                                    }
                                }
                            }
                        }
                        //验证是否入库
                        $rk_order_status=Db::name('dealer_logistics_rk_code')
                            ->where('dealer_id',$data['dealer_id'])
                            ->select();
                        $code_type=2;
                        $ck_num=1;//默认
                        if(count($rk_order_status)>0){
                            //自身验证是否入过库
                            $origin_rk_arr=[];
                            foreach ($rk_order_status as $key=>$value){
                                array_push($origin_rk_arr,[(int)$value['order_start'],(int)$value['order_end']]);
                            }
                            $miss_rk_code=get_no_belong_section([(int)$data['order_start'],(int)$data['order_end']],$origin_rk_arr);
                            if(count($miss_rk_code)<1){
                                //本身已入库可以继续判断
                                $rk_info=Db::name('dealer_logistics_rk_code')
                                    ->alias('a')
                                    ->join('dealer_logistics_rk_order b','a.rk_order=b.rk_order')
                                    ->where('a.order_start','<=',$data['order_start'])
                                    ->where('a.order_end','<=',$data['order_end'])
                                    ->where('a.dealer_id',$data['dealer_id'])
                                    ->field('b.warehouse_id,b.product_id,b.product_code,b.product_name,b.barcode,b.unit,b.specifications,b.manufacture_time,b.validity_time,b.product_batch')
                                    ->find();
                                $dc_info=Db::name('dealer_logistics_dc_order')
                                    ->where('dealer_id',$data['dealer_id'])
                                    ->where('dc_order',$data['dc_order'])
                                    ->find();
                                //查询码关系与入库数量
                                if($between['logistics_level']&&$between['logistics_level']>1){
                                    $logistics_level_item=json_decode($between['logistics_level_item'],true);
                                    $scale=[1];
                                    $section=[];
                                    foreach ($logistics_level_item as $ks=>$vs){
                                        array_push($scale,(int)$vs['num']);//=>[1,5,10]转化成数组比例
                                    }
                                    foreach ($secret_key as $kss=>$vss){
                                        array_push($section,[(int)explode('--',$vss['order'])[0],(int)explode('--',$vss['order'])[1]]);
                                    }
                                    $ck_num=0;
                                    $this->getChildCode($scale,$section,$k,(int)$data['order_start']);//查询子包装码
                                    if(count($this->child)>0){
                                        if($between['logistics_level']==2){
                                            //二级包装
                                            $code_type=1;
                                        }else if(count($this->child)==2) {
                                            $code_type=1;//大标
                                        }else{
                                            $code_type=2; //中级包装小标对待
                                        }
                                        $ck_num=(int)end(array_reverse($this->child)[0])-(int)current(array_reverse($this->child)[0])+1;
                                        $ck_num=$ck_num*($data['order_end']-$data['order_start']+1);
                                    }
                                }
                                $index=-1;
                                $dc_products=json_decode($dc_info['dc_products'],true);
                                foreach ($dc_products as $key=>$vall){
                                    if($vall['product_id']==$rk_info['product_id']) {
                                        $index=$key;
                                        break;
                                    }
                                }
                                if($index==-1) return JsonService::returnData(500,'入库产品与调仓产品不一致');
                                //判断是否超出最大量
                                if($dc_products[$index]['dc_num']+$ck_num>$dc_products[$index]['order_num']) return JsonService::returnData(500,'该产品超过最大调仓数量请选择另一调仓单号');
                                //判断 物流码在该调仓单下是否已入库
                                $has_dc=Db::name('dealer_logistics_dc_code')
                                    ->where('dealer_id',$data['dealer_id'])
                                    ->where('batch',$data['batch'])
                                    ->where('code',$data['code'])
                                    ->find();
                                if($has_dc) return JsonService::returnData(500,'物流码在该调仓单下已入库');
                                //开始调仓 写调仓单 写调仓码表
                                Db::startTrans();//开启事务
                                try{
                                    //更新调仓单商品信息
                                    $dc_products[$index]['dc_num']+=$ck_num;
                                    Db::name('dealer_logistics_dc_order')
                                        ->where('dealer_id',$data['dealer_id'])
                                        ->where('dc_order',$data['dc_order'])
                                        ->update([
                                            'dc_products'=>json_encode($dc_products)
                                        ]);
                                    Db::name('dealer_logistics_dc_order')
                                        ->where('dealer_id',$data['dealer_id'])
                                        ->where('dc_order',$data['dc_order'])
                                        ->setInc('transfer_num',$ck_num);
                                    Db::name('dealer_logistics_dc_code')
                                        ->insert([
                                            'batch'=>$data['batch'],
                                            'code_type'=>$code_type,
                                            'dc_num'=>$ck_num,
                                            'dc_order'=>$data['dc_order'],
                                            'product_id'=>$rk_info['product_id'],
                                            'product_batch'=>$rk_info['product_batch'],
                                            'specifications'=>$rk_info['specifications'],
                                            'unit'=>$rk_info['unit'],
                                            'barcode'=>$rk_info['barcode'],
                                            'product_code'=>$rk_info['product_code'],
                                            'dealer_id'=>$data['dealer_id'],
                                            'order_start'=>$data['order_start'],
                                            'order_end'=>$data['order_end']

                                        ]);
                                    Db::commit();
                                    return JsonService::returnData(200,'调仓成功',['num'=>$ck_num]);
                                }catch (\Exception $e){
                                    Db::rollback();
                                    return JsonService::returnData(500,'请联系管理员');
                                }
                            }
                            //验证父级
                            if($between['logistics_level']&&$between['logistics_level']>1) {
                                $logistics_level_item = json_decode($between['logistics_level_item'], true);
                                $scale = [1];
                                $section = [];
                                foreach ($logistics_level_item as $ks => $vs) {
                                    array_push($scale, (int)$vs['num']);//=>[1,5,10]转化成数组比例
                                }
                                foreach ($secret_key as $kss => $vss) {
                                    array_push($section, [(int)explode('--', $vss['order'])[0], (int)explode('--', $vss['order'])[1]]);
                                }
                                //关键判断每一个父级元素都必须入库
                                for($i=$data['order_start'];$i<=$data['order_end'];$i++){
                                    $this->getParentCode($scale, $section, $k, (int)$i);//查询父级包装码
                                    $parent_order = array_reverse($this->parent);//父级包装[22,44]
                                    if(count($parent_order)>0){
                                        $miss=0;
                                        foreach ($parent_order as $pk=>$pv) {
                                            $p_miss_rk_code = get_no_belong_section([$pv, $pv], $origin_rk_arr);
                                            $miss+=count($p_miss_rk_code);
                                        }
                                        if($miss==count($parent_order)) return JsonService::returnData(500,'流水号未入库');

                                    }else{
                                        return JsonService::returnData(500,'流水号未入库');//只要存在一个无父级 就代表未入库
                                    }
                                }
                                //父级已入库可以继续判断
                                $rk_info=Db::name('dealer_logistics_rk_code')
                                    ->alias('a')
                                    ->join('dealer_logistics_rk_order b','a.rk_order=b.rk_order')
                                    ->where('a.order_start','<=',$data['order_start'])
                                    ->where('a.order_end','<=',$data['order_end'])
                                    ->where('a.dealer_id',$data['dealer_id'])
                                    ->field('b.warehouse_id,b.product_id,b.product_code,b.product_name,b.barcode,b.unit,b.specifications,b.manufacture_time,b.validity_time,b.product_batch')
                                    ->find();
                                $dc_info=Db::name('dealer_logistics_dc_order')
                                    ->where('dealer_id',$data['dealer_id'])
                                    ->where('dc_order',$data['dc_order'])
                                    ->find();
                                //查询码关系与入库数量
                                if($between['logistics_level']&&$between['logistics_level']>1){
                                    $logistics_level_item=json_decode($between['logistics_level_item'],true);
                                    $scale=[1];
                                    $section=[];
                                    foreach ($logistics_level_item as $ks=>$vs){
                                        array_push($scale,(int)$vs['num']);//=>[1,5,10]转化成数组比例
                                    }
                                    foreach ($secret_key as $kss=>$vss){
                                        array_push($section,[(int)explode('--',$vss['order'])[0],(int)explode('--',$vss['order'])[1]]);
                                    }
                                    $ck_num=0;
                                    $this->getChildCode($scale,$section,$k,(int)$data['order_start']);//查询子包装码
                                    if(count($this->child)>0){
                                        if($between['logistics_level']==2){
                                            //二级包装
                                            $code_type=1;
                                        }else if(count($this->child)==2) {
                                            $code_type=1;//大标
                                        }else{
                                            $code_type=2; //中级包装小标对待
                                        }
                                        $ck_num=(int)end(array_reverse($this->child)[0])-(int)current(array_reverse($this->child)[0])+1;
                                        $ck_num=$ck_num*($data['order_end']-$data['order_start']+1);
                                    }
                                }
                                $index=-1;
                                $dc_products=json_decode($dc_info['dc_products'],true);
                                foreach ($dc_products as $key=>$vall){
                                    if($vall['product_id']==$rk_info['product_id']) {
                                        $index=$key;
                                        break;
                                    }
                                }
                                if($index==-1) return JsonService::returnData(500,'入库产品与调仓产品不一致');
                                //判断是否超出最大量
                                if($dc_products[$index]['dc_num']+$ck_num>$dc_products[$index]['order_num']) return JsonService::returnData(500,'该产品超过最大调仓数量请选择另一调仓单号');
                                //判断 物流码在该调仓单下是否已入库
                                $has_dc=Db::name('dealer_logistics_dc_code')
                                    ->where('dealer_id',$data['dealer_id'])
                                    ->where('order_start','<=',$data['order_start'])
                                    ->where('order_end','>=',$data['order_end'])
                                    ->find();
                                if($has_dc) return JsonService::returnData(500,'流水号在该调仓单下已入库');
                                Db::startTrans();//开启事务
                                try{
                                    //更新调仓单商品信息
                                    $dc_products[$index]['dc_num']+=$ck_num;
                                    Db::name('dealer_logistics_dc_order')
                                        ->where('dealer_id',$data['dealer_id'])
                                        ->where('dc_order',$data['dc_order'])
                                        ->update([
                                            'dc_products'=>json_encode($dc_products)
                                        ]);
                                    Db::name('dealer_logistics_dc_order')
                                        ->where('dealer_id',$data['dealer_id'])
                                        ->where('dc_order',$data['dc_order'])
                                        ->setInc('transfer_num',$ck_num);
                                    Db::name('dealer_logistics_dc_code')
                                        ->insert([
                                            'batch'=>$data['batch'],
                                            'code_type'=>$code_type,
                                            'dc_num'=>$ck_num,
                                            'dc_order'=>$data['dc_order'],
                                            'product_id'=>$rk_info['product_id'],
                                            'product_batch'=>$rk_info['product_batch'],
                                            'specifications'=>$rk_info['specifications'],
                                            'unit'=>$rk_info['unit'],
                                            'barcode'=>$rk_info['barcode'],
                                            'product_code'=>$rk_info['product_code'],
                                            'dealer_id'=>$data['dealer_id'],
                                            'order_start'=>$data['order_start'],
                                            'order_end'=>$data['order_end']

                                        ]);
                                    Db::commit();
                                    return JsonService::returnData(200,'调仓成功',['num'=>$ck_num]);
                                }catch (\Exception $e){
                                    Db::rollback();
                                    return JsonService::returnData(500,'请联系管理员');
                                }

                            }
                            return JsonService::returnData(500,'流水号未入库');
                        }else{
                            return JsonService::returnData(500,'流水号未入库');
                        }
                    }
                    return JsonService::returnData(500,'流水号无效');
                }

            }else{
                return JsonService::returnData(500,'流水号不存在',$miss_code);
            }
        }
    }
    public function getDcNotes(Request $request){
        $params=$request->get();
        if($params['start_time']&&$params['end_time']){
            $condition['create_time']=['between time',[$params['start_time'],$params['end_time']]];
        }
        $condition['dc_order']=['like','%'.$params['dc_order'].'%'];
        $list=Db::name('dealer_logistics_dc_order')
            ->where(new Where($condition))
            ->where('dealer_id',$params['dealer_id'])
            ->where('in_warehouse_id',$params['in_warehouse_id']?:'not null')
            ->where('out_warehouse_id',$params['out_warehouse_id']?:'not null')
            ->where('is_del',0)
            ->page($params['page'])
            ->limit($params['pageSize'])
            ->order('create_time','desc')
            ->select();
        $sum=Db::name('dealer_logistics_dc_order')
            ->where(new Where($condition))
            ->where('in_warehouse_id',$params['in_warehouse_id']?:'not null')
            ->where('out_warehouse_id',$params['out_warehouse_id']?:'not null')
            ->where('dealer_id',$params['dealer_id'])
            ->where('is_del',0)
            ->count();
        $rk_sum=Db::name('dealer_logistics_dc_order')
            ->where(new Where($condition))
            ->where('in_warehouse_id',$params['in_warehouse_id']?:'not null')
            ->where('out_warehouse_id',$params['out_warehouse_id']?:'not null')
            ->where('dealer_id',$params['dealer_id'])
            ->where('is_del',0)
            ->sum('transfer_num');
        $data=[
            'list'=>[
                'current_page'=>$params['page'],
                'total'=>$sum,
                'dc_sum'=>$rk_sum,
                'per_page'=>$params['pageSize'],
                'data'=>$list
            ]
        ];
        return JsonService::returnData(200,'查询成功',$data);
    }
    public function getDcProductList(Request $request){
        $params=$request->get();
        $product=Db::name('dealer_logistics_dc_order')
            ->where('dc_order',$params['dc_order'])
            ->find();
        if($product){
            return JsonService::returnData(200,'查询成功',json_decode($product['dc_products'],true));
        }else{
            return JsonService::returnData(500,'暂无出库明细');
        }
    }
    public function getCodeList(Request $request){
        $params=$request->get();
        $list=Db::name('dealer_logistics_dc_code')
            ->where('dealer_id',$params['dealer_id'])
            ->where('dc_order',$params['dc_order'])
            ->where('product_id',$params['product_id'])
            ->page($params['pageNum'])
            ->limit($params['pageSize'])
            ->select();
        return JsonService::returnData(200,'查询成功',$list);
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