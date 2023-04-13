<?php
/**
 * Created by PhpStorm.
 * User: wenhan
 * Date: 2022/3/26
 * Time: 下午10:22
 */

namespace app\pda\controller;
use app\Request;
use think\Controller;
use think\Db;
use app\common\JsonService;
use think\db\Where;
use think\facade\Hook;

class RKManage extends Controller
{
//    protected $dealer_id;
//    public function initialize(){
//        $userInfo=Request::userInfo();
//        $this->dealer_id=array_key_exists('dealer_id',$userInfo)?$userInfo['dealer_id']:$userInfo['id'];
//    }
    protected $parent=[];//父级包装
    protected $child=[];//子包装码
    public function getRkOrderInfo(Request $request){
        $params=$request->get();
        $info=Db::name('dealer_logistics_rk_order')->where('rk_order',$params['rk_order'])->find();
        if($info){
            return JsonService::returnData(200,'查询成功',$info);
        }else{
            return JsonService::returnData(500,'单号不存在');
        }
    }
    public function getRkOrderList(Request $request){
        $params=$request->get();
        $list=Db::name('dealer_logistics_rk_order')
            ->whereColumn('quantity','>','rk_num')
            ->where('rk_order','like','%'.$params['rk_order'].'%')
            ->where('dealer_id',$params['dealer_id'])
            ->page($params['page'])
            ->limit($params['pageSize'])
            ->order('create_order_time','desc')
            ->select();
        $sum=Db::name('dealer_logistics_rk_order')
            ->whereColumn('quantity','>','rk_num')
            ->where('rk_order','like','%'.$params['rk_order'].'%')
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
    public function getWarehouseList(Request $request){
        $params=$request->get();
        $list=Db::name('dealer_logistics_warehouse')
            ->where('dealer_id',$params['dealer_id'])
            ->where('code|warehouse_name|address|person','like','%'.$params['keywords'].'%')
            ->page($params['pageNum'])
            ->limit($params['pageSize'])
            ->select();
        return JsonService::returnData(200,'查询成功',$list);
    }

    /**
     * @param Request $request
     * 扫码入库(按单入库)
     */
    public function saveRkOrder(Request $request){
//        return JsonService::returnData(500,'该物流码无效');
        $data=$request->post();
        if($data['scan_type']==1){
            //单码扫描
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
                //判断是否属于所在区间
                if($code_batch['order_begin']<=$decrypt_code&&$decrypt_code<=$code_batch['order_end']){
                    //验重
                    $rk_order_status=Db::name('dealer_logistics_rk_code')
                        ->where('dealer_id',$data['dealer_id'])
                        ->select();
                    if(count($rk_order_status)>0){
                        $origin_rk_arr=[];
                        foreach ($rk_order_status as $key=>$value){
                            array_push($origin_rk_arr,[(int)$value['order_start'],(int)$value['order_end']]);
                        }
                        $miss_rk_code=get_no_belong_section([(int)$decrypt_code,(int)$decrypt_code],$origin_rk_arr);
                        if(count($miss_rk_code)<1) JsonService::returnData(500,'流水号存在入库序列');
                    }
                    //入库
                    Db::startTrans();//开启事务
                    try{
                        $order_info=Db::name('dealer_logistics_rk_order')->where('rk_order',$data['rk_order'])->find();
                        if($order_info['quantity']==$order_info['rk_num']) JsonService::returnData(500,'超过最大入库数量');
                        Db::name('dealer_logistics_rk_code')->insert([
                            'dealer_id'=>$data['dealer_id'],
                            'code'=>$data['code'],
                            'batch'=>$data['batch'],
                            'rk_num'=>1,//入库数量
                            'code_type'=>2,//数码类型 单个码 小标对待
                            'serial_number'=>$decrypt_code,
                            'order_start'=>$decrypt_code,//为了检索 将单个码的起始序列号存入
                            'order_end'=>$decrypt_code,
                            'product_id'=>$order_info['product_id'],
                            'product_name'=>$order_info['product_name'],
                            'product_code'=>$order_info['product_code'],
                            'specifications'=>$order_info['specifications'],
                            'unit'=>$order_info['unit'],
                            'barcode'=>$order_info['barcode'],
                            'scan_type'=>1,
                            'rk_order'=>$data['rk_order']
                        ]);
                        //入库数量加一
                        Db::name('dealer_logistics_rk_order')
                            ->where('rk_order', $data['rk_order'])
                            ->setInc('rk_num');
                        $log=[
                            'code'=>$data['code'],
                            'batch'=>$data['batch'],
                            'op_type'=>'单码扫描入库',
                            'op_des'=>'入库单'.$data['rk_order'].'物流码扫描入库',
                            'dealer_id'=>$data['dealer_id'],
                        ];
                        Hook::listen('pda_op_log',$log);
                        Db::commit();
                        return JsonService::returnData(200,'入库成功');
                    }catch (\Exception $e){
                        Db::rollback();
                        return JsonService::returnData(500,'请联系管理员');
                    }
                }else{
                    return JsonService::returnData(500,'该物流码无效');
                }
            }else{
                //存在组套关系 组套码长度不能相同
                foreach ($secret_key as $k=>$val){
                    if($val['length']==strlen($data['code'])){
                        //解密
                        $new_key=explode(',',$val['key']);
                        $order=explode('--',$val['order']);
                        $decrypt_code=bcpowmod($data['code'],$new_key[1],$new_key[0],0);
                        if($order[0]<=$decrypt_code&&$decrypt_code<=$order[1]){
                            //验重
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
                                $miss_rk_code=get_no_belong_section([(int)$decrypt_code,(int)$decrypt_code],$origin_rk_arr);
                                if(count($miss_rk_code)<1) return JsonService::returnData(500,'物流码已入库');;
                                //判断父级包装是否入库
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
                                            $p_miss_rk_code=get_no_belong_section([$pv,$pv],$origin_rk_arr);
                                            if(count($p_miss_rk_code)<1) return JsonService::returnData(500,'外包装已入库');
                                        }
                                    }
                                }
                            }
                            //查询码关系与入库数量
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
                                    $rk_num=(int)end(array_reverse($this->child)[0])-(int)current(array_reverse($this->child)[0])+1;
                                }
                            }
                            Db::startTrans();//开启事务
                            try{
                                $order_info=Db::name('dealer_logistics_rk_order')->where('rk_order',$data['rk_order'])->find();
                                if($order_info['quantity']<$order_info['rk_num']+$rk_num) return JsonService::returnData(500,'超过最大入库数量');
                                Db::name('dealer_logistics_rk_code')->insert([
                                    'dealer_id'=>$data['dealer_id'],
                                    'code'=>$data['code'],
                                    'batch'=>$data['batch'],
                                    'serial_number'=>$decrypt_code,
                                    'rk_num'=>$rk_num,//入库数量
                                    'code_type'=>$code_type,//数码类型 单个码 小标对待
                                    'order_start'=>$decrypt_code,
                                    'order_end'=>$decrypt_code,
                                    'product_id'=>$order_info['product_id'],
                                    'product_name'=>$order_info['product_name'],
                                    'product_code'=>$order_info['product_code'],
                                    'specifications'=>$order_info['specifications'],
                                    'unit'=>$order_info['unit'],
                                    'barcode'=>$order_info['barcode'],
                                    'scan_type'=>1,
                                ]);
                                //更新入库数量
                                Db::name('dealer_logistics_rk_order')
                                    ->where('rk_order', $data['rk_order'])
                                    ->setInc('rk_num',$rk_num);
                                $log=[
                                    'code'=>$data['code'],
                                    'batch'=>$data['batch'],
                                    'op_type'=>'单码扫描入库',
                                    'op_des'=>'入库单'.$data['rk_order'].'物流码扫描入库',
                                    'dealer_id'=>$data['dealer_id'],
                                ];
                                Hook::listen('pda_op_log',$log);
                                Db::commit();
                                return JsonService::returnData(200,'入库成功');
                            }catch (\Exception $e){
                                Db::rollback();
                                return JsonService::returnData(500,'请联系管理员');
                            }
//                                    return JsonService::fail('入库',$decrypt_code);
                            break;
                        }else{
                            return JsonService::returnData(500,'该物流码无效');
                            break;
                        }
                    }
                }
                return JsonService::returnData(500,'该物流码无效');
            }
        }else{
            //区间入库
            $rk_order_status=Db::name('dealer_logistics_rk_code')
                ->where('dealer_id',$data['dealer_id'])
                ->select();
            if(count($rk_order_status)>0){
                $origin_rk_arr=[];
                foreach ($rk_order_status as $key=>$value){
                    array_push($origin_rk_arr,[(int)$value['order_start'],(int)$value['order_end']]);
                }
                $miss_rk_code=get_no_belong_section([(int)$data['order_start'],(int)$data['order_end']],$origin_rk_arr);
                if(count($miss_rk_code)<((int)$data['order_end']-(int)$data['order_start']+1)) return JsonService::returnData(500,'流水号存在入库序列');
            }
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
//                        return JsonService::fail('fuck',$between);
                if(!$between) return JsonService::returnData(500,'流水号区间不在同一批次');
                if($between['logistics_level']){
                    //存在组套关系
                    $level=json_decode($between['logistics_level_item'],true);
                    $secret_key_arr=json_decode($between['secret_key'],true);
                    $index=-1;
                    foreach ($secret_key_arr as $skey=>$sval){
                        $order=explode('--',$sval['order']);
                        if((int)$data['order_start']>=(int)$order[0]&&(int)$order[1]>=(int)$data['order_end']){
                            $index=$skey;
                            break;//终止本次循环
                        }
                    }
                    if($index==-1) return JsonService::returnData(500,'流水号区间不在同一级别！');
                    $code_type=1;
                    $num=1;
                    if($index!=0) $code_type=2;//小码
                    //重点 判断区间的级别 大码还是小码
                    for($i=$index;$i<count($level);$i++){
                        $num*=(int)$level[$i]['num'];
                    }
                    $rk_num=((int)$data['order_end']-(int)$data['order_start']+1)*$num;
                }else{
                    $code_type=2;
                    $rk_num=(int)$data['order_end']-(int)$data['order_start']+1;
                }
                Db::startTrans();//开启事务
                try{
                    $order_info=Db::name('dealer_logistics_rk_order')->where('rk_order',$data['rk_order'])->find();
                    if($order_info['quantity']<$order_info['rk_num']+$rk_num) return JsonService::returnData(500,'超过最大入库数量');
                    Db::name('dealer_logistics_rk_code')->insert([
                        'dealer_id'=>$data['dealer_id'],
                        'product_batch'=>$order_info['product_batch'],
                        'order_start'=>$data['order_start'],
                        'order_end'=>$data['order_end'],
                        'code_type'=>$code_type,
                        'rk_num'=>$rk_num,
                        'product_id'=>$order_info['product_id'],
                        'product_code'=>$order_info['product_code'],
                        'product_name'=>$order_info['product_name'],
                        'specifications'=>$order_info['specifications'],
                        'unit'=>$order_info['unit'],
                        'barcode'=>$order_info['barcode'],
                        'scan_type'=>2,
                        'rk_order'=>$data['rk_order']
                    ]);
                   // 更新入库数量
                    Db::name('dealer_logistics_rk_order')
                        ->where('rk_order', $data['rk_order'])
                        ->setInc('rk_num',$rk_num);
                    Db::commit();
                    $log=[
                        'order_start'=>$data['order_start'],
                        'order_end'=>$data['order_end'],
                        'batch'=>$data['batch'],
                        'op_type'=>'序列号区间入库',
                        'op_des'=>'区间'.$data['order_start'].'~'.$data['order_end'].'入库',
                        'dealer_id'=>$data['dealer_id']
                    ];
                    Hook::listen('pda_op_log',$log);
                    return JsonService::returnData(200,'入库成功');
                }catch (\Exception $e){
                    Db::rollback();
                    return JsonService::returnData(500,'请联系管理员');
                }
//                        return JsonService::successful('入库');
            }else{
                return JsonService::returnData(500,'物流码不存在',$miss_code);
            }

        }

    }

    /**
     * @param Request $request
     * 直接入库
     */
    public function  saveDirectRkOrder(Request $request){
        $data=$request->post();
//        return JsonService::returnData(500,'该物流码无效',$data);
        //单码扫描
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
                //验重
                $rk_order_status=Db::name('dealer_logistics_rk_code')
                    ->where('dealer_id',$data['dealer_id'])
                    ->select();
                if(count($rk_order_status)>0){
                    $origin_rk_arr=[];
                    foreach ($rk_order_status as $key=>$value){
                        array_push($origin_rk_arr,[(int)$value['order_start'],(int)$value['order_end']]);
                    }
                    $miss_rk_code=get_no_belong_section([(int)$decrypt_code,(int)$decrypt_code],$origin_rk_arr);
                    if(count($miss_rk_code)<1) JsonService::returnData(500,'流水号存在入库序列');
                }
                //入库
                Db::startTrans();//开启事务
                try{
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
                    $log=[
                        'code'=>$data['code'],
                        'batch'=>$data['batch'],
                        'op_type'=>'直接入库',
                        'op_des'=>'入库单'.$data['rk_order'].'物流码扫描入库',
                        'dealer_id'=>$data['dealer_id'],
                    ];
                    Hook::listen('pda_op_log',$log);
                    return JsonService::returnData(200,'入库成功',1);
                }catch (\Exception $e){
                    Db::rollback();
                    return JsonService::returnData(500,'请联系管理员');
                }
            }else{
                return JsonService::returnData(500,'该物流码无效');
            }
        }else{
            //存在组套关系 组套码长度不能相同
            foreach ($secret_key as $k=>$val){
                if($val['length']==strlen($data['code'])){
                    //解密
                    $new_key=explode(',',$val['key']);
                    $order=explode('--',$val['order']);
                    $decrypt_code=bcpowmod($data['code'],$new_key[1],$new_key[0],0);
                    if($order[0]<=$decrypt_code&&$decrypt_code<=$order[1]){
                        //验重
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
                            $miss_rk_code=get_no_belong_section([(int)$decrypt_code,(int)$decrypt_code],$origin_rk_arr);
                            if(count($miss_rk_code)<1) return JsonService::returnData(500,'物流码已入库');
                            //判断父级包装是否入库
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
                                        $p_miss_rk_code=get_no_belong_section([$pv,$pv],$origin_rk_arr);
                                        if(count($p_miss_rk_code)<1) return JsonService::returnData(500,'外包装已入库');
                                    }
                                }
                            }
                        }
                        //查询码关系与入库数量
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
                                $rk_num=(int)end(array_reverse($this->child)[0])-(int)current(array_reverse($this->child)[0])+1;
                            }
                        }
                        Db::startTrans();//开启事务
                        try{
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
                                'serial_number'=>$decrypt_code,
                                'rk_num'=>$rk_num,//入库数量
                                'code_type'=>$code_type,//数码类型 单个码 小标对待
                                'order_start'=>$decrypt_code,
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
                            //更新入库数量
                            Db::name('dealer_logistics_rk_order')
                                ->where('rk_order', $data['rk_order'])
                                ->setInc('rk_num',$rk_num);
                            Db::name('dealer_logistics_rk_order')
                                ->where('rk_order', $data['rk_order'])
                                ->setInc('quantity',$rk_num);
                            $log=[
                                'code'=>$data['code'],
                                'batch'=>$data['batch'],
                                'op_type'=>'直接入库',
                                'op_des'=>'入库单'.$data['rk_order'].'物流码扫描入库',
                                'dealer_id'=>$data['dealer_id'],
                            ];
                            Hook::listen('pda_op_log',$log);
                            Db::commit();
                            return JsonService::returnData(200,'入库成功',$rk_num);
                        }catch (\Exception $e){
                            Db::rollback();
                            return JsonService::returnData(500,'请联系管理员');
                        }

                    }
                }
            }
            return JsonService::returnData(500,'该物流码无效');
        }
    }
    /**
     * @param Request $request
     * 物流码明细
     */
    public function getCodeList(Request $request){
        $params=$request->get();
        $list=Db::name('dealer_logistics_rk_code')
            ->where('dealer_id',$params['dealer_id'])
            ->where('rk_order',$params['rk_order'])
            ->page($params['pageNum'])
            ->limit($params['pageSize'])
            ->select();
        return JsonService::returnData(200,'查询成功',$list);
    }
    //生成入库单号
    public function createRkOrder(Request $request){
        $code='RK'.date('Ymd') . substr(implode('', array_map('ord', str_split(substr(uniqid(), 7, 13), 1))), 0, 8);
        return JsonService::returnData(200,'单号生成成功',$code);
    }
    public function getRkNotes(Request $request){
        $params=$request->get();
        if($params['start_time']&&$params['end_time']){
            $condition['create_order_time']=['between time',[$params['start_time'],$params['end_time']]];
        }
        $condition['rk_order']=['like','%'.$params['rk_order'].'%'];
        $list=Db::name('dealer_logistics_rk_order')
            ->where(new Where($condition))
            ->where('dealer_id',$params['dealer_id'])
            ->where('status',0)
            ->page($params['page'])
            ->limit($params['pageSize'])
            ->order('create_order_time','desc')
            ->select();
        $sum=Db::name('dealer_logistics_rk_order')
            ->where(new Where($condition))
            ->where('dealer_id',$params['dealer_id'])
            ->where('status',0)
            ->count();
        $rk_sum=Db::name('dealer_logistics_rk_order')
                ->where(new Where($condition))
                ->where('dealer_id',$params['dealer_id'])
                ->where('status',0)
                ->sum('rk_num');
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