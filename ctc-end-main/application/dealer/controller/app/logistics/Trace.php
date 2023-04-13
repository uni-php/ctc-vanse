<?php
/**
 * Created by PhpStorm.
 * User: wenhan
 * Date: 2022/4/7
 * Time: 上午12:15
 */

namespace app\dealer\controller\app\logistics;
use app\Request;
use think\Controller;
use think\Db;
use app\common\JsonService;
use think\db\Where;

class Trace extends Controller
{
    protected $dealer_id;
    protected $parent=[];//父级包装
    protected $child=[];//子包装码
    protected $new_child=[];//子包装码
    public function initialize(){
        $userInfo=Request::userInfo();
        $this->dealer_id=array_key_exists('dealer_id',$userInfo)?$userInfo['dealer_id']:$userInfo['id'];
    }

    /**
     * @param Request $request
     * @throws \think\db\exception\DataNotFoundException
     * @throws \think\db\exception\ModelNotFoundException
     * @throws \think\exception\DbException
     * 物流码批次
     */
    public function getLogCodeBatch(Request $request){
        $list=Db::name('code_manage')
            ->where('dealer_id',$this->dealer_id)
            ->where('scene','like','%4%')
            ->field('id,batch,remark,order_begin,order_end')
            ->select();
        return JsonService::successful('查询成功',$list);
    }
    public function queryCodeLink(Request $request){
        $params=$request->get();
        $params['dealer_id']=$this->dealer_id;
        //查询是否有替换码
        $replace=Db::name('dealer_logistics_replace_code')
            ->where('cur_code',$params['code'])
            ->where('cur_batch',$params['batch'])
            ->find();
        if($replace){
            $params['code']=$replace['origin_code'];
            $params['batch']=$replace['origin_batch'];
        }
        //查询数码比例关系
        $batch_info=Db::name('code_manage')
            ->where('dealer_id',$params['dealer_id'])
            ->where('scene','like','%'.'4'.'%')//查询物流码
            ->where('batch',$params['batch'])
            ->where('enable',1)
            ->find();
        if(!$batch_info) return JsonService::fail('该物流码无效');
        $secret_key=json_decode($batch_info['secret_key'],true);
        if(count($secret_key)==0){
            //不存在组套关系
            $key=explode(',',$batch_info['key']);//秘钥形式（n,d,e)
            if(strlen($params['code'])!=$batch_info['code_length']) return JsonService::fail('该物流码无效');
            $decrypt_code=bcpowmod($params['code'],$key[1],$key[0],0);
            //判断是否属于所在区间
            if($batch_info['order_begin']<=$decrypt_code&&$decrypt_code<=$batch_info['order_end']){
                //正常数码
                $codeList=[
                    [$params['code'].'('.$decrypt_code.')']
                ];
                $log=$this->getLogisticsInfo($params['code'],$params['batch'],false,$params['dealer_id'],'');
                $info=[
                    'code_type'=>2,
                    'batch'=>$params['batch'],
                    'scale'=>[1],
                    'rk_num'=>1
                ];
                return JsonService::successful('查询成功',['code'=>$codeList,'log'=>$log,'info'=>$info]);
            }else{
                return JsonService::fail('该物流码无效');
            }
        }else{
            //存在组套关系
            foreach ($secret_key as $k=>$val){
                if($val['length']==strlen($params['code'])){
                    //解密
                    $new_key=explode(',',$val['key']);//n d e
                    $order=explode('--',$val['order']);
                    $decrypt_code=bcpowmod($params['code'],$new_key[1],$new_key[0],0);
                    if($order[0]<=$decrypt_code&&$decrypt_code<=$order[1]){
                        //正常数码
                        $code_type=2;//默认小标
                        $rk_num=1;//默认
                        //查询码关系与入库数量
                        if($batch_info['logistics_level']&&$batch_info['logistics_level']>1){
                            $logistics_level_item=json_decode($batch_info['logistics_level_item'],true);
                            $scale=[1];
                            $section=[];
                            //查询比例关系
                            foreach ($logistics_level_item as $ks=>$vs){
                                array_push($scale,(int)$vs['num']);//=>[1,5,10]转化成数组比例
                            }
                            foreach ($secret_key as $kss=>$vss){
                                array_push($section,[(int)explode('--',$vss['order'])[0],(int)explode('--',$vss['order'])[1]]);
                            }
                            $this->getNewChildCode($scale,$section,$k,(int)$decrypt_code);//查询子包装码
                            if(count($this->new_child)>0){
                                if($batch_info['logistics_level']==2){
                                    //二级包装
                                    $code_type=1;
                                }else if(count($this->new_child)==2) {
                                    $code_type=1;//大标
                                }else{
                                    $code_type=2; //中级包装小标对待
                                }
                                //产品数量
                                $rk_num=(int)end(array_reverse($this->new_child)[0])-(int)current(array_reverse($this->new_child)[0])+1;
                            }
                            //查询父级 由父级反推
                            $this->getParentCode($scale,$section,$k,(int)$decrypt_code);//查询父级包装码
                            $parent_order=array_reverse($this->parent);//父级包装[22,44]
                            $temp=$parent_order;
                            array_push($temp,(int)$decrypt_code);
                            $log=$this->getLogisticsInfo($params['code'],$params['batch'],true,$params['dealer_id'],$temp);
                            if(count($parent_order)==0){
                                //本身是父级
                                $parent_code=$decrypt_code;
                            }else{
                                $parent_code=$parent_order[0];
                            }

                            $this->getChildCode($scale,$section,0,(int)$parent_code);
                            $ser_arr=[];//序号数组
                            foreach ($this->child as $key =>$value){
                                array_push($ser_arr,[current($value),end($value)]);
                            }
                            array_unshift($ser_arr,[(int)$parent_code]);
                            //循环加密
                            $arr=array();
                            $test=array();
                            foreach ($ser_arr as $ks=>$vs){
                                $arr[$ks]=[];
                                for($i=$vs[0];$i<=end($vs);$i++){
                                    $key=explode(',',$secret_key[$ks]['key']);//n d e
                                    $encry_code=bcpowmod($i,$key[2],$key[0],0);
                                    $length=(int)$secret_key[$ks]['length'];
                                    array_push($test,$length-strlen($encry_code));
                                    $curCode=$this->appendString($encry_code,$length-strlen($encry_code),'0');//转字符串 统计长度
                                    array_push($arr[$ks],$curCode.'（流水号'.$i.'）');
                                }
                            }
                            $info=[
                                'code_type'=>$code_type,
                                'batch'=>$params['batch'],
                                'scale'=>$scale,
                                'rk_num'=>$rk_num
                            ];

                            //补零
                            return JsonService::successful('查询成功',['code'=>$arr,'log'=>$log,'test'=>$test,'info'=>$info]);
                        }
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
     * @param $code
     * @param $batch
     * @param $is_scale //是否组套
     * 查询物流信息
     */
    public function getLogisticsInfo($code,$batch,$is_scale,$dealer_id,$parent_order=[]){
        if(!$is_scale){
            //未组套
            //入库信息
            $rk_info=Db::name('dealer_logistics_rk_code')
                ->alias('a')
                ->join('dealer_logistics_rk_order b','a.rk_order=b.rk_order')
                ->where('a.code',$code)
                ->where('a.batch',$batch)
                ->where('a.dealer_id',$dealer_id)
                ->field('a.rk_order,a.create_time,b.create_by,b.warehouse_id,b.product_id,b.product_name,b.product_code,b.barcode,b.specifications,b.manufacture_time,b.validity_time,b.unit')
                ->find();
            //出库信息
            $ck_info=Db::name('dealer_logistics_ck_code')
                ->alias('a')
                ->join('dealer_logistics_ck_order b','a.ck_order=b.ck_order')
                ->where('a.batch',$batch)
                ->where('a.code',$code)
                ->where('a.dealer_id',$dealer_id)
                ->field('a.ck_num,a.is_return,a.create_time,a.ck_order,b.create_by,b.warehouse_id,b.customer_id,b.customer_name,b.is_gift,a.product_name,a.unit,a.specifications')
                ->find();
            //退货信息
            $th_info=Db::name('dealer_logistics_th_code')
                ->alias('a')
                ->join('dealer_logistics_th_order b','a.th_order=b.th_order')
                ->join('dealer_product c','a.product_id=c.id')
                ->where('a.batch',$batch)
                ->where('a.dealer_id',$dealer_id)
                ->where('a.code',$code)
                ->field('a.*,b.customer_name,c.product_name')
                ->select();
            //调仓信息
            $dc_info=Db::name('dealer_logistics_dc_code')
                ->alias('a')
                ->join('dealer_logistics_dc_order b','a.dc_order=b.dc_order')
                ->where('a.batch',$batch)
                ->where('a.dealer_id',$dealer_id)
                ->where('a.code',$code)
                ->field('a.dc_order,a.product_name,b.out_warehouse_id,b.in_warehouse_id')
                ->find();
            $status='暂无信息';
            if($rk_info) $status='已入库';
            if($ck_info&&$ck_info['is_return']==0) $status='已发货';
            if($ck_info&&$ck_info['is_return']==1) $status='已退货';
            return [$rk_info,$ck_info,count($th_info)>0?$th_info[0]:null,$dc_info,$status];
        }else{
            //原则 大码优先级最高
            foreach ($parent_order as $key=>$val){
                $rk_info=Db::name('dealer_logistics_rk_code')
                    ->alias('a')
                    ->join('dealer_logistics_rk_order b','a.rk_order=b.rk_order')
                    ->where('a.serial_number',$val)
                    ->where('a.batch',$batch)
                    ->where('a.dealer_id',$dealer_id)
                    ->field('a.rk_order,a.create_time,b.warehouse_id,b.product_id,b.product_name,b.product_code,b.barcode,b.specifications,b.manufacture_time,b.validity_time,b.unit')
                    ->find();
                if($rk_info) break;//中断循环
            }
            foreach ($parent_order as $key=>$val){
                $ck_info=Db::name('dealer_logistics_ck_code')
                    ->alias('a')
                    ->join('dealer_logistics_ck_order b','a.ck_order=b.ck_order')
                    ->where('a.batch',$batch)
                    ->where('a.serial_number',$val)
                    ->where('a.dealer_id',$dealer_id)
                    ->field('a.ck_num,a.is_return,a.create_time,a.ck_order,b.warehouse_id,b.customer_id,b.customer_name,b.is_gift,a.product_name,a.unit,a.specifications')
                    ->find();
                if($ck_info) break;//中断循环
            }
            foreach ($parent_order as $key=>$val){
                //退货信息
                $th_info=Db::name('dealer_logistics_th_code')
                    ->alias('a')
                    ->join('dealer_logistics_th_order b','a.th_order=b.th_order')
                    ->join('dealer_product c','a.product_id=c.id')
                    ->where('a.batch',$batch)
                    ->where('a.dealer_id',$dealer_id)
                    ->where('a.serial_number',$val)
                    ->field('a.*,b.customer_name,c.product_name')
                    ->order('create_time','desc')
                    ->select();
                if(count($th_info)>0) break;
            }
            foreach ($parent_order as $key=>$val){
                $dc_info=Db::name('dealer_logistics_dc_code')
                    ->alias('a')
                    ->join('dealer_logistics_dc_order b','a.dc_order=b.dc_order')
                    ->join('dealer_product c','a.product_id=c.id')
                    ->where('a.batch',$batch)
                    ->where('a.dealer_id',$dealer_id)
                    ->where('a.serial_number',$val)
                    ->field('a.dc_order,a.create_time,c.product_name,b.out_warehouse_id,b.in_warehouse_id')
                    ->find();
                if($dc_info) break;
            }
            $status='暂无信息';
            if($rk_info) $status='已入库';
            if($ck_info&&$ck_info['is_return']==0) $status='已发货';
            if($ck_info&&$ck_info['is_return']==1) $status='已退货';
            return [$rk_info,$ck_info,count($th_info)>0?$th_info[0]:null,$dc_info,$status];
        }
    }
    private function appendString($str,$len,$append){
        $text=$str;
        if($len==0){
            return $str;
        }
        for($i=0;$i<$len;$i++){
            $text=$append.$text;
        }
        return $text;
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
    public function getNewChildCode($scale,$section,$index,$order){
        if($index==count($scale)-1) return $this->new_child;
        $star=($order-$section[$index][0])*$scale[$index+1];
        array_push($this->new_child,[($star+$section[$index+1][0]),($star+$section[$index+1][0]+$scale[$index+1]-1)]);
        $index++;
        if($index<count($scale)-1){
            $this->getNewChildCode($scale,$section,$index,$this->new_child[count($this->new_child)-1][0]);
            $this->getNewChildCode($scale,$section,$index,$this->new_child[count($this->new_child)-2][1]);
            $this->new_child=[$this->new_child[0],array_merge($this->new_child[count($this->new_child)-2],$this->new_child[count($this->new_child)-1])];
        }
    }
}