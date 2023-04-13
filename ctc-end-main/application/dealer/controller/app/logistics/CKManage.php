<?php
/**
 * Created by PhpStorm.
 * User: wenhan
 * Date: 2022/3/18
 * Time: 下午4:32
 */

namespace app\dealer\controller\app\logistics;
use app\Request;
use think\Controller;
use think\Db;
use app\common\JsonService;
use think\db\Where;


class CKManage extends Controller
{
    protected $parent=[];//父级包装
    protected $child=[];//子包装码
    protected $dealer_id;
    public function initialize(){
        $userInfo=Request::userInfo();
        $this->dealer_id=array_key_exists('dealer_id',$userInfo)?$userInfo['dealer_id']:$userInfo['id'];
    }
    //生成入库单号
    public function createCkCode(Request $request){
        $type='CH';
        if(array_key_exists('type',$request->get())) $type='CK';
        $code=$type.date('Ymd') . substr(implode('', array_map('ord', str_split(substr(uniqid(), 7, 13), 1))), 0, 8);
        return JsonService::returnData(200,'单号生成成功',$code);
    }
    public function saveCkOrder(Request $request){
        $data=$request->post();
        //生成发货数量
        $deliver_sum=0;
        $send_sum=0;
        foreach ($data['outwarehouse_products'] as $key=>$value){
            $deliver_sum+=(int)$value['order_num'];
            $send_sum+=$value['out_num'];
        }
        $data['deliver_sum']=$deliver_sum;
        $data['send_sum']=$send_sum;
        $data['ck_type']=1;//按单出货
        $data['outwarehouse_products']=json_encode($data['outwarehouse_products']);
        if(array_key_exists('id',$data)){
            $res=Db::name('dealer_logistics_ck_order')->update($data);
        }else{
            $data['dealer_id']=$this->dealer_id;
            $res=Db::name('dealer_logistics_ck_order')->insert($data);
        }
        if($res||$res==0){
            return JsonService::successful('保存成功');
        }else{
            return JsonService::fail('请联系管理员');
        }
    }
    public function getCkOrderList(Request $request){
        $params=$request->get();
        if($params['startTime']){
            $condition['careta_time']=['between time',[$params['startTime'],$params['endTime']]];
        }
        if($params['batch']){
            $condition['product_batch']=['like','%'.$params['batch'].'%'];
        }
        $condition['ck_order']=['like','%'.$params['order'].'%'];
        $condition['customer_name']=['like','%'.$params['customer_name'].'%'];
        $condition['outwarehouse_products']=['like','%'.$params['product_name'].'%'];
        $condition['outwarehouse_products']=['like','%'.$params['code'].'%'];
        $list=Db::name('dealer_logistics_ck_order')
            ->where(new Where($condition))
            ->where('dealer_id',$this->dealer_id)
            ->where('warehouse_id',$params['warehouse_id']?:'not null')
            ->where('status',$params['status']?:'not null')
            ->where('is_gift',$params['is_gift']?:'not null')
            ->where('order_type',$params['order_type']?:'not null')
            ->where('is_del',0)
            ->page($params['pageNum'])
            ->limit($params['pageSize'])
            ->order('create_time','desc')
            ->select();
        foreach ($list as $key=>$val){
            $arr=json_decode($val['outwarehouse_products'],true);
            foreach ($arr as $k=>$v){
                $arr[$k]['id']=$k.$key.'product';
            }
            $list[$key]['children']=$arr;
        }
        $total=Db::name('dealer_logistics_ck_order')
            ->where(new Where($condition))
            ->where('dealer_id',$this->dealer_id)
            ->where('warehouse_id',$params['warehouse_id']?:'not null')
            ->where('status',$params['status']?:'not null')
            ->where('is_gift',$params['is_gift']?:'not null')
            ->where('order_type',$params['order_type']?:'not null')
            ->where('is_del',0)
           ->count();
        $res=[
            'code'=>200,
            'msg'=>'查询成功',
            'data'=>$list,
            'total'=>$total
        ];
        return json($res);
    }
    public function getCkOrderInfo(Request $request){
        $id=$request->param('id');
        $info=Db::name('dealer_logistics_ck_order')
            ->where('id',$id)
            ->find();
        $info['printData']=json_decode($info['outwarehouse_products'],true);
        foreach ($info['printData'] as $key=>$val){
            $info['printData'][$key]['customer_name']=$info['customer_name'];
        }
        return JsonService::successful('查询成功',$info);
    }

    /**
     * @param Request $request
     * 保存出库扫描信息
     */
    public function saveScanRkOrder(Request $request){
        $data=$request->post();
        $data['dealer_id']=$this->dealer_id;
        $data['ck_type']=2;//快速出货
        //判断码是否可用（物流码不可用）=>物流码是否入库(已入库不能再用，可一键出库)该物流码已入库=>判断是否出库(该物流码已经出库)=>发货成功，同时间同步生成入库单
        if($data['scan_type']==1){
            //单码扫描
            //①判断码是否合理
            $res=$this->is_code_available($data['code'],$data['batch'],$this->dealer_id);
            Db::startTrans();//开启事务
            try{
                //写入库单 同一入库单
                $has=Db::name('dealer_logistics_rk_order')
                    ->where('dealer_id',$this->dealer_id)
                    ->where('rk_order',$data['rk_order'])
                    ->find();
                if(!$has){
                    Db::name('dealer_logistics_rk_order')->strict(false)->insert($data);
                }
                Db::name('dealer_logistics_rk_code')->insert([
                    'dealer_id'=>$this->dealer_id,
                    'code'=>$data['code'],
                    'batch'=>$data['batch'],
                    'product_batch'=>$data['product_batch'],
                    'serial_number'=>$res[0],
                    'rk_num'=>$res[1],//入库数量
                    'code_type'=>$res[2],//数码类型 单个码 小标对待
                    'order_start'=>$res[0],
                    'order_end'=>$res[0],
                    'product_id'=>$data['product_id'],
                    'scan_type'=>1,
                    'rk_order'=>$data['rk_order']
                ]);
                //入库数量加一
                Db::name('dealer_logistics_rk_order')
                    ->where('rk_order', $data['rk_order'])
                    ->setInc('rk_num',$res[1]);
                Db::name('dealer_logistics_rk_order')
                    ->where('rk_order', $data['rk_order'])
                    ->setInc('quantity',$res[1]);
                //写出库单
                $has_ck=Db::name('dealer_logistics_ck_order')
                    ->where('dealer_id',$this->dealer_id)
                    ->where('ck_order',$data['ck_order'])
                    ->find();
                //更新商品数量
                $data['outwarehouse_products'][0]['order_num']=$res[1];
                $data['outwarehouse_products'][0]['out_num']=$res[1];
                if(!$has_ck){
                    $data['outwarehouse_products']=json_encode($data['outwarehouse_products']);
                    $data['status']=1;
                    Db::name('dealer_logistics_ck_order')->strict(false)->insert($data);
                    Db::name('dealer_logistics_ck_order')
                        ->where('ck_order',$data['ck_order'])
                        ->setInc('send_sum',$res[1]);
                    Db::name('dealer_logistics_ck_order')
                        ->where('ck_order',$data['ck_order'])
                        ->setInc('deliver_sum',$res[1]);
                    Db::name('dealer_logistics_ck_code')->insert([
                        'dealer_id'=>$this->dealer_id,
                        'code'=>$data['code'],
                        'batch'=>$data['batch'],
                        'product_batch'=>$data['product_batch'],
                        'serial_number'=>$res[0],
                        'ck_num'=>$res[1],//入库数量
                        'code_type'=>$res[2],//数码类型 单个码 小标对待
                        'order_start'=>$res[0],
                        'order_end'=>$res[0],
                        'product_id'=>$data['product_id'],
                        'product_code'=>$data['product_code'],
                        'product_name'=>$data['product_name'],
                        'barcode'=>$data['barcode'],
                        'unit'=>$data['unit'],
                        'manufacture_time'=>$data['manufacture_time'],
                        'validity_time'=>$data['validity_time'],
                        'specifications'=>$data['specifications'],
                        'scan_type'=>1,
                        'ck_order'=>$data['ck_order']
                    ]);
                }else{
                    //更新出库单 需判断出货客户与已有出货单是否一致
                    if($data['customer_id']!=$has_ck['customer_id']) return JsonService::fail('出货客户与已有出货单不一致');
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
                        $product=array_merge($product,$data['outwarehouse_products']);
                    }else{
                        $product[$index]['order_num']+=$res[1];
                        $product[$index]['out_num']+=$res[1];
                    }
                    Db::name('dealer_logistics_ck_order')
                        ->where('ck_order',$data['ck_order'])
                        ->setInc('send_sum',$res[1]);
                    Db::name('dealer_logistics_ck_order')
                        ->where('ck_order',$data['ck_order'])
                        ->setInc('deliver_sum',$res[1]);
                    Db::name('dealer_logistics_ck_order')->where('ck_order',$data['ck_order'])->update([
                       'outwarehouse_products'=>json_encode($product)
                    ]);
                    Db::name('dealer_logistics_ck_code')->insert([
                        'dealer_id'=>$this->dealer_id,
                        'code'=>$data['code'],
                        'batch'=>$data['batch'],
                        'product_batch'=>$data['product_batch'],
                        'serial_number'=>$res[0],
                        'ck_num'=>$res[1],//入库数量
                        'code_type'=>$res[2],//数码类型 单个码 小标对待
                        'order_start'=>$res[0],
                        'order_end'=>$res[0],
                        'product_id'=>$data['product_id'],
                        'product_code'=>$data['product_code'],
                        'product_name'=>$data['product_name'],
                        'barcode'=>$data['barcode'],
                        'unit'=>$data['unit'],
                        'manufacture_time'=>$data['manufacture_time'],
                        'validity_time'=>$data['validity_time'],
                        'specifications'=>$data['specifications'],
                        'scan_type'=>1,
                        'ck_order'=>$data['ck_order']
                    ]);
                }
                Db::commit();
                return JsonService::successful('出库成功');
            }catch (\Exception $e){
                Db::rollback();
                return JsonService::fail('请联系管理员');
            }

        }else{
            //判断码是否可用=>码是否入库 是否出库

        }
    }

    /**
     * @param $code /数码
     * @param $batch /批次
     * @param $dealer_id /用户
     * 判断物流码是否可用
     * return array[$decrypt_code,$ck_num,$code_type] /数码流水号，出库数量，数码类别
     */
    public function is_code_available($code,$batch,$dealer_id){
        $batch_info=Db::name('code_manage')
            ->where('dealer_id',$dealer_id)
            ->where('scene','like','%'.'4'.'%')//查询物流码
            ->where('batch',$batch)
            ->where('enable',1)
            ->find();
        if(!$batch_info) return JsonService::fail('该物流码无效');
        $secret_key=json_decode($batch_info['secret_key'],true);
        if(count($secret_key)==0){
            //不存在组套关系
            $key=explode(',',$batch_info['key']);//秘钥形式（n,d,e)
            if(strlen($code)!=$batch_info['code_length']) return JsonService::fail('该物流码无效');
            $decrypt_code=bcpowmod($code,$key[1],$key[0],0);
            //判断是否属于所在区间
            if($batch_info['order_begin']<=$decrypt_code&&$decrypt_code<=$batch_info['order_end']){
                //验重 先判断是否已经出库
                $ck_order_status=Db::name('dealer_logistics_ck_code')
                    ->where('dealer_id',$this->dealer_id)
                    ->select();
                if(count($ck_order_status)>0){
                    $origin_ck_arr=[];
                    foreach ($ck_order_status as $key=>$value){
                        array_push($origin_ck_arr,[(int)$value['order_start'],(int)$value['order_end']]);
                    }
                    $miss_ck_code=get_no_belong_section([(int)$decrypt_code,(int)$decrypt_code],$origin_ck_arr);
                    if(count($miss_ck_code)<1) return JsonService::fail('物流码已出库');
                }
                //再判断是否已入库
                $rk_order_status=Db::name('dealer_logistics_rk_code')
                    ->where('dealer_id',$this->dealer_id)
                    ->select();
                if(count($rk_order_status)>0){
                    $origin_rk_arr=[];
                    foreach ($rk_order_status as $key=>$value){
                        array_push($origin_rk_arr,[(int)$value['order_start'],(int)$value['order_end']]);
                    }
                    $miss_rk_code=get_no_belong_section([(int)$decrypt_code,(int)$decrypt_code],$origin_rk_arr);
                    if(count($miss_rk_code)<1) return JsonService::fail('物流码已入库');
                }else{
                    return [$decrypt_code,1,2];//可用 可直接出库(单码当小标对待)
                }
            }else{
                return JsonService::fail('该物流码无效');
            }
        }else{
//            //存在组套关系 判断父级码是否出库 入库 符合出库条件 再计算比例数量
            foreach ($secret_key as $k=>$val){
                if($val['length']==strlen($code)){
                    //解密
                    $new_key=explode(',',$val['key']);
                    $order=explode('--',$val['order']);
                    $decrypt_code=bcpowmod($code,$new_key[1],$new_key[0],0);
                    if($order[0]<=$decrypt_code&&$decrypt_code<=$order[1]){
                        //验重
                        $ck_order_status=Db::name('dealer_logistics_ck_code')
                            ->where('dealer_id',$dealer_id)
                            ->select();
                        $rk_order_status=Db::name('dealer_logistics_rk_code')
                            ->where('dealer_id',$dealer_id)
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
                            if(count($miss_ck_code)<1) return JsonService::fail('物流码已出库');
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
                                        if(count($p_miss_rk_code)<1) return JsonService::fail('外包装已出库！');
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
                            if(count($miss_rk_code)<1) return JsonService::fail('物流码已入库');
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
                                        if(count($p_miss_rk_code)<1) return JsonService::fail('外包装已入库！');
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
                        return [$decrypt_code,$ck_num,$code_type];
                    }else{
                        return JsonService::fail('该物流码无效',$decrypt_code);
                        break;
                    }
                }
            }
            return JsonService::fail('该物流码无效');
        }
    }

    /**
     * @param Request $request
     * 物流码详情
     */
    public function getCkCodeList(Request $request){
        $params=$request->get();
        $list=Db::name('dealer_logistics_ck_code')
            ->alias('a')
            ->join('dealer_product b','a.product_id=b.id')
            ->where('a.dealer_id',$this->dealer_id)
            ->where('a.ck_order',$params['ck_order'])
            ->field('a.*,b.product_name,b.code as product_code')
            ->page($params['pageNum'])
            ->limit($params['pageSize'])
            ->select();
        $total=Db::name('dealer_logistics_ck_code')
            ->where('dealer_id',$this->dealer_id)
            ->where('ck_order',$params['ck_order'])
            ->count();
        $res=[
            'code'=>200,
            'msg'=>'查询成功',
            'data'=>$list,
            'total'=>$total
        ];
        return json($res);
    }
    public function deleCkOrder(Request $request){
        $params=$request->get();
        $is_ava=Db::name('dealer_logistics_ck_code')
            ->where('ck_order',$params['ck_order'])
            ->select();
        if($is_ava&&$is_ava!=0) return JsonService::fail('出库物流码明细已存在，不可删除！');
        $res=Db::name('dealer_logistics_ck_order')
            ->where('ck_order',$params['ck_order'])
            ->update([
                'is_del'=>1
            ]);
        if($res){
            return JsonService::successful('删除成功');
        }else{
            return JsonService::fail('请联系管理员');
        }
    }

    /**
     * @param Request $request
     * 提前结单
     */
    public function finishCkOrder(Request $request){
        $ck_order=$request->param('ck_order');
        $res=Db::name('dealer_logistics_ck_order')
            ->where('ck_order',$ck_order)
            ->update([
                'status'=>3
            ]);
        if($res){
            return JsonService::successful('删除成功');
        }else{
            return JsonService::fail('请联系管理员');
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