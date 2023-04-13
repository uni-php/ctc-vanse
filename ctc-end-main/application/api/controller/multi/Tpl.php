<?php
/**
 * Created by PhpStorm.
 * User: wenhan
 * Date: 2022/11/18
 * Time: 下午3:44
 */

namespace app\api\controller\multi;
use app\Request;
use think\Controller;
use app\lib\helper;
use think\Db;
use app\common\JsonService;

class Tpl extends Controller
{
    public function getTpl(Request $request){
        $params=$request->get();
        $code=$params['qrcode'];
        $dealer_id=$params['dealer_id'];
        $batch=$params['batch'];
        $address=$request->address();
        //解密查询序列号
        $batch_info=Db::name('code_manage')
            ->where('dealer_id',$dealer_id)
            ->where('scene','like','%'.'3'.'%')//查询营销码码
            ->where('batch',$batch)
            ->where('enable',1)
            ->find();
        if(!$batch_info) return JsonService::returnData(500,'该导购码无效');
        $secret_key=json_decode($batch_info['secret_key'],true);
        if(count($secret_key)==0) {
            //不存在组套关系 单独导购码
            $key=explode(',',$batch_info['key']);//秘钥形式（n,d,e)
            if(strlen($code)!=$batch_info['code_length']) return JsonService::returnData(500,'该营销码无效');
            $decrypt_code=bcpowmod($code,$key[1],$key[0],0);//流水号
            if($batch_info['order_begin']<=$decrypt_code&&$decrypt_code<=$batch_info['order_end']){
                //码正常 下一步去查询红包活动
                $activity=Db::name('dealer_guide_activity')
                    ->where('dealer_id',$dealer_id)
                    ->where('status','<>',3)
                    ->where('code_batch_data','like','%'.$batch.'%')
                    ->select();
                if(count($activity)==0) JsonService::returnData(500,'该数码未参与活动营销');
                $i=-1;
                $j=-1;
                foreach ($activity as $key=>$value){
                    $define_data=json_decode($value['code_batch_data'],true);
                    foreach ($define_data as $k=>$val){
                        if((int)$decrypt_code>=(int)$val['order_begin']&&(int)$val['order_end']>=(int)$decrypt_code){
                            $j=$k;
                            $i=$key;
                            break 2;//终止本次循环
                        }
                    }
                }
                if($i==-1) return JsonService::returnData(500,'该数码未参与活动营销');
                //返回活动数据
                if($activity[$i]['status']==0) return JsonService::returnData(500,'活动未启用');
                //返回正常活动数据
                //查询是否限制导购员扫码
                $guide_info=Db::name('dealer_guide')
                    ->where('dealer_id',$dealer_id)
                    ->where('openid',$params['openid'])
                    ->where('status',1)
                    ->find();
                if(!$guide_info) return  JsonService::returnData(500,$activity[$i]['isnot_guide_tips']);
                if($activity[$i]['is_user_limit']==1){
                    $limt_group=json_decode($activity[$i]['guide_gruop'],true);
                    if(!in_array($guide_info['group_id'],$limt_group)) return JsonService::returnData(500,$activity[$i]['unexpected_user_tips']);
                }
                //查询扫码模板
                $tpl=Db::name('dealer_guide_tpl')
                    ->where('dealer_id',$dealer_id)
                    ->where('id',$activity[$i]['tpl_id'])
                    ->find();
                $tpl['welcom_page']=json_decode($tpl['welcom_page'],true);
                $tpl['activity_page']=json_decode($tpl['activity_page'],true);
                $tpl['xuanchuan_page']=json_decode($tpl['xuanchuan_page'],true);
                $activity[$i]['tpl_info']=$tpl;
                //导购码查询记录
                $has=Db::name('dealer_guide_query_bill')
                    ->where('dealer_id',$dealer_id)
                    ->where('batch',$batch)
                    ->where('serial_number',$decrypt_code)
                    ->where('is_first',1)
                    ->find();
                Db::name('dealer_guide_query_bill')
                    ->insert([
                        'code'=>$code,
                        'batch'=>$batch,
                        'serial_number'=>$decrypt_code,
                        'dealer_id'=>$dealer_id,
                        'openid'=>$params['openid'],
                        'is_first'=>$has?2:1,
                        'scan_type'=>1,
                        'ip'=>$request->ip(),
                        'sources'=>3,//来源超级导购
                        'province'=>$address[2],
                        'city'=>$address[3]
                    ]);
                $activity[$i]['serial_number']=$decrypt_code;
                return JsonService::returnData(200,'查询成功',$activity[$i]);
            }else{
                return JsonService::returnData(500,'该营销码无效');
            }
        }
    }
}