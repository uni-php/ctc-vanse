<?php
/**
 * Created by PhpStorm.
 * User: wenhan
 * Date: 2022/3/29
 * Time: 上午11:46
 */

namespace app\pda\controller;
use app\Request;
use think\Controller;
use think\Db;
use app\common\JsonService;
use think\db\Where;
use think\facade\Hook;

class CKManage extends Controller
{
    protected $parent=[];//父级包装
    protected $child=[];//子包装码
    public function getCkOrderInfo(Request $request){
        $params=$request->get();
        $info=Db::name('dealer_logistics_ck_order')->where('ck_order',$params['ck_order'])->find();
        if($info){
            $info['outwarehouse_products']=json_decode($info['outwarehouse_products'],true);
            return JsonService::returnData(200,'查询成功',$info);
        }else{
            return JsonService::returnData(500,'单号不存在');
        }
    }
    public function getCkOrderList(Request $request){
        $params=$request->get();
        $list=Db::name('dealer_logistics_ck_order')
            ->whereColumn('deliver_sum','>','send_sum')
            ->where('ck_order','like','%'.$params['ck_order'].'%')
            ->where('dealer_id',$params['dealer_id'])
            ->where('is_del',0)
            ->page($params['page'])
            ->limit($params['pageSize'])
            ->order('create_time','desc')
            ->select();
        $sum=Db::name('dealer_logistics_ck_order')
            ->whereColumn('deliver_sum','>','send_sum')
            ->where('ck_order','like','%'.$params['ck_order'].'%')
            ->where('dealer_id',$params['dealer_id'])
            ->where('is_del',0)
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
     * 扫码出库
     * 物流码是否存在=>物流码是否入库=>入库和出库的仓库不一致=>出库产品与入库产品不一致=>大码已经出库=>超出最大出库数量，请选择另一出库单号
     * 更新出库单表send_sum实发数量字段
     */
    public function saveCkOrder(Request $request){
        $data=$request->post();
//        return JsonService::returnData(500,'该物流码无效');
        if($data['scan_type']==1){
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
                        if(count($miss_rk_code)<1){
                            //已入库 未出库 继续判断仓库与产品是否一致
                            $rk_info=Db::name('dealer_logistics_rk_code')
                                ->alias('a')
                                ->join('dealer_logistics_rk_order b','a.rk_order=b.rk_order')
                                ->where('a.code',$data['code'])
                                ->where('dealer_id',$data['dealer_id'])
                                ->field('b.warehouse_id,b.product_id,b.product_name,b.product_code,b.barcode,b.specifications,b.manufacture_time,b.validity_time,b.unit')
                                ->find();
                            $ck_info=Db::name('dealer_logistics_ck_order')
                                ->where('ck_order',$data['ck_order'])
                                ->find();
                            $outwarehouse_products=json_decode($ck_info['outwarehouse_products'],true);
                            if($rk_info['warehouse_id']!=$ck_info['warehouse_id']) return JsonService::returnData(500,'入库和出库的仓库不一致');
                            foreach ($outwarehouse_products as $p_key=>$p_value){
                                if($p_value['product_id']==$rk_info['product_id']){
                                    //商品匹配上 再去判断是否超出最大数量
                                    if($p_value['order_num']<=$p_value['out_num']) return JsonService::returnData(500,'超过最大出库数量，请选择另一出库单号');
                                    //满足条件 😊 开始出库
                                    $outwarehouse_products[$p_key]['out_num']++;
                                    Db::startTrans();//开启事务
                                    try{
                                        //更新出库单
                                        Db::name('dealer_logistics_ck_order')
                                            ->where('ck_order',$data['ck_order'])
                                            ->update([
                                               'outwarehouse_products'=>json_encode($outwarehouse_products),
                                            ]);
                                        Db::name('dealer_logistics_ck_order')
                                            ->where('ck_order',$data['ck_order'])
                                            ->setInc('send_sum');
                                        //更新出库码表
                                        Db::name('dealer_logistics_ck_code')
                                            ->insert([
                                               'code'=>$data['code'],
                                               'serial_number'=> $decrypt_code,
                                               'batch'=>$data['batch'],
                                               'code_type'=>2,//小标对待
                                               'ck_num'=>1,//字段已废弃
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
                                                'ck_type'=>1,//出货方式  按单出货
                                                'order_start'=>$decrypt_code,
                                                'order_end'=>$decrypt_code
                                            ]);
                                        $log=[
                                            'code'=>$data['code'],
                                            'batch'=>$data['batch'],
                                            'op_type'=>'扫码出库',
                                            'op_des'=>'出库单'.$data['ck_order'].'物流码扫描出库',
                                            'dealer_id'=>$data['dealer_id'],
                                        ];
                                        Hook::listen('pda_op_log',$log);
                                        Db::commit();
                                        return JsonService::returnData(200,'出库成功');
                                    }catch (\Exception $e){
                                        Db::rollback();
                                        return JsonService::returnData(500,'请联系管理员');
                                    }

                                }
                            }
                            return JsonService::returnData(500,'入库商品与出库商品不匹配');//该语句须放在循环外侧
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
                //存在组套关系 判断父级码是否出库 入库 符合出库条件 再计算比例数量
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
                            $rk_info=Db::name('dealer_logistics_rk_code')
                                ->alias('a')
                                ->join('dealer_logistics_rk_order b','a.rk_order=b.rk_order')
                                ->where('a.code',$data['code'])
                                ->where('a.dealer_id',$data['dealer_id'])
                                ->field('b.warehouse_id,b.product_id,b.product_name,b.product_code,b.barcode,b.specifications,b.manufacture_time,b.validity_time,b.unit')
                                ->find();//为了取订单初始的商品 必须关联
                            $ck_info=Db::name('dealer_logistics_ck_order')
                                ->where('ck_order',$data['ck_order'])
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
                                    $outwarehouse_products=json_decode($ck_info['outwarehouse_products'],true);
                                    if($rk_info['warehouse_id']!=$ck_info['warehouse_id']) return JsonService::returnData(500,'入库和出库的仓库不一致');
                                    foreach ($outwarehouse_products as $p_key=>$p_value){
                                        if($p_value['product_id']==$rk_info['product_id']){
                                            //商品匹配上 再去判断是否超出最大数量
                                            if($p_value['order_num']<$p_value['out_num']+$ck_num) return JsonService::returnData(500,'超过最大出库数量，请选择另一出库单号');
                                            //满足条件 😊 开始出库
                                            $outwarehouse_products[$p_key]['out_num']+=$ck_num;
                                            Db::startTrans();//开启事务
                                            try{
                                                //更新出库单
                                                Db::name('dealer_logistics_ck_order')
                                                    ->where('ck_order',$data['ck_order'])
                                                    ->update([
                                                        'outwarehouse_products'=>json_encode($outwarehouse_products)
                                                    ]);
                                                Db::name('dealer_logistics_ck_order')
                                                    ->where('ck_order',$data['ck_order'])
                                                    ->setInc('send_sum',$ck_num);
                                                //更新出库码表
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
                                                        'ck_type'=>1,//出货方式  按单出货
                                                        'order_start'=>$decrypt_code,
                                                        'order_end'=>$decrypt_code
                                                    ]);
                                                $log=[
                                                    'code'=>$data['code'],
                                                    'batch'=>$data['batch'],
                                                    'op_type'=>'扫码出库',
                                                    'op_des'=>'出库单'.$data['ck_order'].'物流码扫描出库',
                                                    'dealer_id'=>$data['dealer_id'],
                                                ];
                                                Hook::listen('pda_op_log',$log);
                                                Db::commit();
                                                return JsonService::returnData(200,'出库成功');
                                            }catch (\Exception $e){
                                                Db::rollback();
                                                return JsonService::returnData(500,'请联系管理员');
                                            }

                                        }
                                    }
                                    return JsonService::returnData(500,'入库商品与出库商品不匹配');
                                }
                                //验证父包装
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
                                                //父包装已入库可以出库
                                                $outwarehouse_products=json_decode($ck_info['outwarehouse_products'],true);
                                                if($rk_info['warehouse_id']!=$ck_info['warehouse_id']) return JsonService::returnData(500,'入库和出库的仓库不一致');
                                                foreach ($outwarehouse_products as $p_key=>$p_value){
                                                    if($p_value['product_id']==$rk_info['product_id']){
                                                        //商品匹配上 再去判断是否超出最大数量
                                                        if($p_value['order_num']<$p_value['out_num']+$ck_num) return JsonService::returnData(500,'超过最大出库数量，请选择另一出库单号');
                                                        //满足条件 😊 开始出库
                                                        $outwarehouse_products[$p_key]['out_num']+=$ck_num;
                                                        Db::startTrans();//开启事务
                                                        try{
                                                            //更新出库单
                                                            Db::name('dealer_logistics_ck_order')
                                                                ->where('ck_order',$data['ck_order'])
                                                                ->update([
                                                                    'outwarehouse_products'=>json_encode($outwarehouse_products)
                                                                ]);
                                                            Db::name('dealer_logistics_ck_order')
                                                                ->where('ck_order',$data['ck_order'])
                                                                ->setInc('send_sum',$ck_num);
                                                            //更新出库码表
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
                                                                    'ck_type'=>1,//出货方式  按单出货
                                                                    'order_start'=>$decrypt_code,
                                                                    'order_end'=>$decrypt_code
                                                                ]);
                                                            $log=[
                                                                'code'=>$data['code'],
                                                                'batch'=>$data['batch'],
                                                                'op_type'=>'扫码出库',
                                                                'op_des'=>'出库单'.$data['ck_order'].'物流码扫描出库',
                                                                'dealer_id'=>$data['dealer_id'],
                                                            ];
                                                            Hook::listen('pda_op_log',$log);
                                                            Db::commit();
                                                            return JsonService::returnData(200,'出库成功');
                                                        }catch (\Exception $e){
                                                            Db::rollback();
                                                            return JsonService::returnData(500,'请联系管理员');
                                                        }

                                                    }
                                                }
                                                return JsonService::returnData(500,'入库商品与出库商品不匹配');
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
            //序列号出库  巨麻烦  是否合理有待验证？？？？？ 序列号存在=>须判断是都存在组套关系 序列号必须都入库 =>无序列号出库
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
                $secret_key=json_decode($between['secret_key'],true);
                if(count($secret_key)==0){
                    //不存在组套关系 =>先判断是否出库=>是否入库
                    $ck_order_status=Db::name('dealer_logistics_ck_code')
                        ->where('dealer_id',$data['dealer_id'])
                        ->select();
                    if(count($ck_order_status)>0){
                        $origin_ck_arr=[];
                        foreach ($ck_order_status as $key=>$value){
                            array_push($origin_ck_arr,[(int)$value['order_start'],(int)$value['order_end']]);
                        }
                        $miss_ck_code=get_no_belong_section([(int)$data['order_start'],(int)$data['order_end']],$origin_ck_arr);
                        if(count($miss_ck_code)<1) return JsonService::returnData(500,'物流码已出库');
                    }
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
                            //已入库 未出库 以满足条件 继续判断仓库与产品是否一致
                            //出库序号需与入库序号严格对应
                            $rk_info=Db::name('dealer_logistics_rk_code')
                                ->alias('a')
                                ->join('dealer_logistics_rk_order b','a.rk_order=b.rk_order')
                                ->where('dealer_id',$data['dealer_id'])
                                ->where('a.order_start',$data['order_start'])
                                ->where('a.order_end',$data['order_end'])
                                ->field('b.warehouse_id,b.product_id,b.product_name,b.product_code,b.barcode,b.specifications,b.manufacture_time,b.validity_time,b.unit')
                                ->find();
                            $ck_info=Db::name('dealer_logistics_ck_order')
                                ->where('ck_order',$data['ck_order'])
                                ->find();
                            $outwarehouse_products=json_decode($ck_info['outwarehouse_products'],true);
                            if($rk_info['warehouse_id']!=$ck_info['warehouse_id']) return JsonService::returnData(500,'入库和出库的仓库不一致');
                            foreach ($outwarehouse_products as $p_key=>$p_value){
                                if($p_value['product_id']==$rk_info['product_id']){
                                    //商品匹配上 再去判断是否超出最大数量
                                    $ck_num=$data['order_end']-$data['order_start']+1;
                                    if($p_value['order_num']<($p_value['out_num']+$ck_num)) return JsonService::returnData(500,'超过最大出库数量，请选择另一出库单号');
                                    //满足条件 😊 开始出库
                                    $outwarehouse_products[$p_key]['out_num']+=$ck_num;
                                    Db::startTrans();//开启事务
                                    try{
                                        //更新出库单
                                        Db::name('dealer_logistics_ck_order')
                                            ->where('ck_order',$data['ck_order'])
                                            ->update([
                                                'outwarehouse_products'=>json_encode($outwarehouse_products),
                                            ]);
                                        Db::name('dealer_logistics_ck_order')
                                            ->where('ck_order',$data['ck_order'])
                                            ->setInc('send_sum',$ck_num);
                                        //更新出库码表
                                        Db::name('dealer_logistics_ck_code')
                                            ->insert([
                                                'batch'=>$data['batch'],
                                                'code_type'=>2,//小标对待
                                                'ck_num'=>$ck_num,//字段已废弃
                                                'ck_order'=>$data['ck_order'],
                                                'product_id'=>$rk_info['product_id'],//存储产品详情
                                                'product_code'=>$rk_info['product_code'],
                                                'product_name'=>$rk_info['product_name'],
                                                'barcode'=>$rk_info['barcode'],
                                                'specifications'=>$rk_info['specifications'],
                                                'manufacture_time'=>$rk_info['manufacture_time'],
                                                'validity_time'=>$rk_info['validity_time'],
                                                'unit'=>$rk_info['unit'],
                                                'dealer_id'=>$data['dealer_id'],
                                                'scan_type'=>1,
                                                'ck_type'=>1,//出货方式  按单出货
                                                'order_start'=>$data['order_start'],
                                                'order_end'=>$data['order_end']
                                            ]);
                                        $log=[
                                            'order_start'=>$data['order_start'],
                                            'order_end'=>$data['order_end'],
                                            'batch'=>$data['batch'],
                                            'op_type'=>'序列号区间入库',
                                            'op_des'=>'区间'.$data['order_start'].'~'.$data['order_end'].'入库',
                                            'dealer_id'=>$data['dealer_id']
                                        ];
                                        Hook::listen('pda_op_log',$log);
                                        Db::commit();
                                        return JsonService::returnData(200,'出库成功');
                                    }catch (\Exception $e){
                                        Db::rollback();
                                        return JsonService::returnData(500,'请联系管理员');
                                    }

                                }
                            }
                            return JsonService::returnData(500,'入库商品与出库商品不匹配');//该语句须放在循环外侧

                        }else{
                            return JsonService::returnData(500,'流水号未入库,请先入库再进行出库');
                        }
                    }else{
                        return JsonService::returnData(500,'流水号未入库,请先入库再进行出库');
                    }
                }else{
                    //存在组套关系
                    foreach ($secret_key as $k=>$val){
                        //判断是否出库
                        $order=explode('--',$val['order']);
                        $ck_order_status=Db::name('dealer_logistics_ck_code')
                            ->where('dealer_id',$data['dealer_id'])
                            ->select();
                        $ck_info=Db::name('dealer_logistics_ck_order')
                            ->where('ck_order',$data['ck_order'])
                            ->find();

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
                        $rk_num=1;//默认
                        if(count($rk_order_status)>0){
                            //自身验证是否入过库
                            $origin_rk_arr=[];
                            foreach ($rk_order_status as $key=>$value){
                                array_push($origin_rk_arr,[(int)$value['order_start'],(int)$value['order_end']]);
                            }
                            $miss_rk_code=get_no_belong_section([(int)$data['order_start'],(int)$data['order_end']],$origin_rk_arr);
                            if(count($miss_rk_code)<1){
                                //本身已入库可以出库
                                $rk_info=Db::name('dealer_logistics_rk_code')
                                    ->alias('a')
                                    ->join('dealer_logistics_rk_order b','a.rk_order=b.rk_order')
                                    ->where('a.order_start','<=',$data['order_start'])
                                    ->where('a.order_end','<=',$data['order_end'])
                                    ->where('a.dealer_id',$data['dealer_id'])
                                    ->field('b.warehouse_id,b.product_id,b.product_name,b.product_code,b.barcode,b.specifications,b.manufacture_time,b.validity_time,b.unit')
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
                                $outwarehouse_products=json_decode($ck_info['outwarehouse_products'],true);
                                if($rk_info['warehouse_id']!=$ck_info['warehouse_id']) return JsonService::returnData(500,'入库和出库的仓库不一致');
                                foreach ($outwarehouse_products as $p_key=>$p_value){
                                    if($p_value['product_id']==$rk_info['product_id']){
                                        //商品匹配上 再去判断是否超出最大数量
                                        if($p_value['order_num']<$p_value['out_num']+$ck_num) return JsonService::returnData(500,'超过最大出库数量，请选择另一出库单号');
                                        //满足条件 😊 开始出库
                                        $outwarehouse_products[$p_key]['out_num']+=$ck_num;
                                        Db::startTrans();//开启事务
                                        try{
                                            //更新出库单
                                            Db::name('dealer_logistics_ck_order')
                                                ->where('ck_order',$data['ck_order'])
                                                ->update([
                                                    'outwarehouse_products'=>json_encode($outwarehouse_products)
                                                ]);
                                            Db::name('dealer_logistics_ck_order')
                                                ->where('ck_order',$data['ck_order'])
                                                ->setInc('send_sum',$ck_num);
                                            //更新出库码表
                                            Db::name('dealer_logistics_ck_code')
                                                ->insert([
                                                    'batch'=>$data['batch'],
                                                    'code_type'=>$code_type,
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
                                                    'ck_type'=>1,//出货方式  按单出货
                                                    'order_start'=>$data['order_start'],
                                                    'order_end'=>$data['order_end']
                                                ]);
                                            $log=[
                                                'order_start'=>$data['order_start'],
                                                'order_end'=>$data['order_end'],
                                                'batch'=>$data['batch'],
                                                'op_type'=>'序列号区间入库',
                                                'op_des'=>'区间'.$data['order_start'].'~'.$data['order_end'].'入库',
                                                'dealer_id'=>$data['dealer_id']
                                            ];
                                            Hook::listen('pda_op_log',$log);
                                            Db::commit();
                                            return JsonService::returnData(200,'出库成功');
                                        }catch (\Exception $e){
                                            Db::rollback();
                                            return JsonService::returnData(500,'请联系管理员');
                                        }
                                    }
                                }
                                return JsonService::returnData(500,'入库商品与出库商品不匹配');
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
                                //
                                //父级已入库可以出库
                                $rk_info=Db::name('dealer_logistics_rk_code')
                                    ->alias('a')
                                    ->join('dealer_logistics_rk_order b','a.rk_order=b.rk_order')
                                    ->where('a.order_start','<=',$data['order_start'])
                                    ->where('a.order_end','<=',$data['order_end'])
                                    ->where('a.dealer_id',$data['dealer_id'])
                                    ->field('b.warehouse_id,b.product_id,b.product_name,b.product_code,b.barcode,b.specifications,b.manufacture_time,b.validity_time,b.unit')
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
                                $outwarehouse_products=json_decode($ck_info['outwarehouse_products'],true);
                                if($rk_info['warehouse_id']!=$ck_info['warehouse_id']) return JsonService::returnData(500,'入库和出库的仓库不一致');
                                foreach ($outwarehouse_products as $p_key=>$p_value){
                                    if($p_value['product_id']==$rk_info['product_id']){
                                        //商品匹配上 再去判断是否超出最大数量
                                        if($p_value['order_num']<$p_value['out_num']+$ck_num) return JsonService::returnData(500,'超过最大出库数量，请选择另一出库单号');
                                        //满足条件 😊 开始出库
                                        $outwarehouse_products[$p_key]['out_num']+=$ck_num;
                                        Db::startTrans();//开启事务
                                        try{
                                            //更新出库单
                                            Db::name('dealer_logistics_ck_order')
                                                ->where('ck_order',$data['ck_order'])
                                                ->update([
                                                    'outwarehouse_products'=>json_encode($outwarehouse_products)
                                                ]);
                                            Db::name('dealer_logistics_ck_order')
                                                ->where('ck_order',$data['ck_order'])
                                                ->setInc('send_sum',$ck_num);
                                            //更新出库码表
                                            Db::name('dealer_logistics_ck_code')
                                                ->insert([
                                                    'batch'=>$data['batch'],
                                                    'code_type'=>$code_type,
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
                                                    'ck_type'=>1,//出货方式  按单出货
                                                    'order_start'=>$data['order_start'],
                                                    'order_end'=>$data['order_end']
                                                ]);
                                            $log=[
                                                'order_start'=>$data['order_start'],
                                                'order_end'=>$data['order_end'],
                                                'batch'=>$data['batch'],
                                                'op_type'=>'序列号区间入库',
                                                'op_des'=>'区间'.$data['order_start'].'~'.$data['order_end'].'入库',
                                                'dealer_id'=>$data['dealer_id']
                                            ];
                                            Hook::listen('pda_op_log',$log);
                                            Db::commit();
                                            return JsonService::returnData(200,'出库成功');
                                        }catch (\Exception $e){
                                            Db::rollback();
                                            return JsonService::returnData(500,'请联系管理员');
                                        }
                                    }
                                }
                                return JsonService::returnData(500,'入库商品与出库商品不匹配');

                            }
                            return JsonService::returnData(500,'流水号未入库');

                        }else{
                            return JsonService::returnData(500,'流水号未入库');
                        }
                    }
                    return JsonService::returnData(500,'该物流码无效');
                }
            }else{
                return JsonService::returnData(500,'流水号不存在',$miss_code);
            }
        }
    }
    public function getCodeList(Request $request){
        $params=$request->get();
        $list=Db::name('dealer_logistics_ck_code')
            ->where('dealer_id',$params['dealer_id'])
            ->where('ck_order',$params['ck_order'])
            ->where('product_id',$params['product_id'])
            ->page($params['pageNum'])
            ->limit($params['pageSize'])
            ->select();
        return JsonService::returnData(200,'查询成功',$list);
    }
    public function getCkProductList(Request $request){
        $params=$request->get();
        $product=Db::name('dealer_logistics_ck_order')
            ->where('ck_order',$params['ck_order'])
            ->find();
        if($product){
            return JsonService::returnData(200,'查询成功',json_decode($product['outwarehouse_products'],true));
        }else{
            return JsonService::returnData(500,'暂无出库明细');
        }
    }
    public function getCkNotes(Request $request){
        $params=$request->get();
        if($params['start_time']&&$params['end_time']){
            $condition['create_time']=['between time',[$params['start_time'],$params['end_time']]];
        }
        $condition['ck_order']=['like','%'.$params['ck_order'].'%'];
        $condition['customer_name']=['like','%'.$params['customer_name'].'%'];
        $list=Db::name('dealer_logistics_ck_order')
            ->where(new Where($condition))
            ->where('dealer_id',$params['dealer_id'])
            ->where('is_del',0)
            ->page($params['page'])
            ->limit($params['pageSize'])
            ->order('create_time','desc')
            ->select();
        $sum=Db::name('dealer_logistics_ck_order')
            ->where(new Where($condition))
            ->where('dealer_id',$params['dealer_id'])
            ->where('is_del',0)
            ->count();
        $rk_sum=Db::name('dealer_logistics_ck_order')
            ->where(new Where($condition))
            ->where('dealer_id',$params['dealer_id'])
            ->where('is_del',0)
            ->sum('send_sum');
        $data=[
            'list'=>[
                'current_page'=>$params['page'],
                'total'=>$sum,
                'rk_sum'=>$rk_sum,
                'per_page'=>$params['pageSize'],
                'data'=>$list
            ]
        ];
        return JsonService::returnData(200,'查询成功',$data);
    }
    public function createCkOrder(Request $request){
        $type='CH';
        if(array_key_exists('type',$request->get())) $type='CK';
        $code=$type.date('Ymd') . substr(implode('', array_map('ord', str_split(substr(uniqid(), 7, 13), 1))), 0, 8);
        return JsonService::returnData(200,'单号生成成功',$code);
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