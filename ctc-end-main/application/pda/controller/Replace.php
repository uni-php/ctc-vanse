<?php
/**
 * Created by PhpStorm.
 * User: wenhan
 * Date: 2022/4/6
 * Time: 下午10:24
 */

namespace app\pda\controller;
use app\Request;
use think\Controller;
use think\Db;
use app\common\JsonService;
use think\db\Where;

class Replace extends Controller
{
    protected $parent=[];//父级包装
    /**
     * @param Request $request
     * 数码替换
     * 物流码存在=>替换标签不能入库
     * 替换原理=>查询时触发替换
     */
    public function replaceCode(Request $request){
        $params=$request->get();
        $ori_batch_info=Db::name('code_manage')
            ->where('dealer_id',$params['dealer_id'])
            ->where('scene','like','%'.'4'.'%')//查询物流码
            ->where('batch',$params['origin_batch'])
            ->where('enable',1)
            ->find();
        $cur_batch_info=Db::name('code_manage')
            ->where('dealer_id',$params['dealer_id'])
            ->where('scene','like','%'.'4'.'%')//查询物流码
            ->where('batch',$params['cur_batch'])
            ->where('enable',1)
            ->find();
        if(!$ori_batch_info) return JsonService::returnData(500,'原物流码无效');
        if(!$cur_batch_info) return JsonService::returnData(500,'替换物流码无效');
        //判断替换物流码是否入库
        $secret_key=json_decode($cur_batch_info['secret_key'],true);
        if(count($secret_key)==0){
            //不存在组套关系
            $key=explode(',',$cur_batch_info['key']);//秘钥形式（n,d,e)
            if(strlen($params['cur_code'])!=$cur_batch_info['code_length']) return JsonService::returnData(500,'替换物流码无效');
            $decrypt_code=bcpowmod($params['cur_code'],$key[1],$key[0],0);
            if($cur_batch_info['order_begin']<=$decrypt_code&&$decrypt_code<=$cur_batch_info['order_end']){
                //再判断是否已入库
                $rk_order_status=Db::name('dealer_logistics_rk_code')
                    ->where('dealer_id',$params['dealer_id'])
                    ->select();
                if(count($rk_order_status)>0){
                    $origin_rk_arr=[];
                    foreach ($rk_order_status as $key=>$value){
                        array_push($origin_rk_arr,[(int)$value['order_start'],(int)$value['order_end']]);
                    }
                    $miss_rk_code=get_no_belong_section([(int)$decrypt_code,(int)$decrypt_code],$origin_rk_arr);
                    if(count($miss_rk_code)<1) return JsonService::returnData(500,'物流码已入库');
                }
                //开始替换
                $has=Db::name('dealer_logistics_replace_code')
                    ->where('dealer_id',$params['dealer_id'])
                    ->where('origin_code',$params['origin_code'])
                    ->where('origin_batch',$params['origin_batch'])
                    ->find();
                if($has){
                    $res=Db::name('dealer_logistics_replace_code')
                        ->where('dealer_id',$params['dealer_id'])
                        ->where('origin_code',$params['origin_code'])
                        ->where('origin_batch',$params['origin_batch'])
                        ->update([
                           'cur_code'=>$params['cur_code'],
                           'cur_batch'=>$params['cur_batch']
                        ]);
                }else{
                    $res=Db::name('dealer_logistics_replace_code')->insert($params);
                }
                if($res||$res==0){
                    return JsonService::returnData(200,'替换成功');
                }else{
                    return JsonService::returnData(500,'请联系管理员');
                }
            }
        }else{
            foreach ($secret_key as $k=>$val){
                if($val['length']==strlen($params['cur_code'])){
                    //解密
                    $new_key=explode(',',$val['key']);
                    $order=explode('--',$val['order']);
                    $decrypt_code=bcpowmod($params['cur_code'],$new_key[1],$new_key[0],0);
                    if($order[0]<=$decrypt_code&&$decrypt_code<=$order[1]){
                        $rk_order_status=Db::name('dealer_logistics_rk_code')
                            ->where('dealer_id',$params['dealer_id'])
                            ->select();
                        if(count($rk_order_status)>0){
                            $origin_rk_arr=[];
                            foreach ($rk_order_status as $key=>$value){
                                array_push($origin_rk_arr,[(int)$value['order_start'],(int)$value['order_end']]);
                            }
                            $miss_rk_code=get_no_belong_section([(int)$decrypt_code,(int)$decrypt_code],$origin_rk_arr);
                            if(count($miss_rk_code)<1) return JsonService::returnData(500,'物流码已入库');
                            if($cur_batch_info['logistics_level']&&$cur_batch_info['logistics_level']>1){
                                $logistics_level_item=json_decode($cur_batch_info['logistics_level_item'],true);
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
                                $has=Db::name('dealer_logistics_replace_code')
                                    ->where('dealer_id',$params['dealer_id'])
                                    ->where('origin_code',$params['origin_code'])
                                    ->where('origin_batch',$params['origin_batch'])
                                    ->find();
                                if($has){
                                    $res=Db::name('dealer_logistics_replace_code')
                                        ->where('dealer_id',$params['dealer_id'])
                                        ->where('origin_code',$params['origin_code'])
                                        ->where('origin_batch',$params['origin_batch'])
                                        ->update([
                                            'cur_code'=>$params['cur_code'],
                                            'cur_batch'=>$params['cur_batch']
                                        ]);
                                }else{
                                    $res=Db::name('dealer_logistics_replace_code')->insert($params);
                                }
                                if($res||$res==0){
                                    return JsonService::returnData(200,'替换成功');
                                }else{
                                    return JsonService::returnData(500,'请联系管理员');
                                }
                            }
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
}