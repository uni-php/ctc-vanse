<?php
/**
 * Created by PhpStorm.
 * User: wenhan
 * Date: 2021/12/17
 * Time: 下午11:44
 */

namespace app\dealer\controller\code;
use app\Request;
use think\Controller;
use think\Db;
use app\common\JsonService;

class Qrcode extends Controller
{
    protected $dealer_id;
    public function initialize(){
        $userInfo=Request::userInfo();
        $this->dealer_id=array_key_exists('dealer_id',$userInfo)?$userInfo['dealer_id']:$userInfo['id'];
    }
    public function listCode(Request $request){
        $params=$request->get();
        $list=Db::name('code_manage')
            ->alias('a')
            ->leftJoin('dealer_product b','a.rel_product_id=b.id')//左表连接
            ->where('a.remark','like','%'.$params['mark'].'%')
            ->where('a.code_type','like','%'.$params['type'].'%')
            ->where('a.scene','like','%'.$params['scene'].'%')
            ->where('a.is_del',0)
            ->where('a.enable',1)
            ->where('a.dealer_id',$this->dealer_id)
            ->page($params['pageNum'])
            ->limit($params['pageSize'])
            ->order('a.create_time','desc')
            ->field('a.*,b.product_name as rel_product_name')
            ->select();
        foreach ($list as $k=>$val){
            $list[$k]['secret_key']=json_decode($val['secret_key'],true);
        }
        $sum=Db::name('code_manage')
            ->where('remark','like','%'.$params['mark'].'%')
            ->where('code_type','like','%'.$params['type'].'%')
            ->where('scene','like','%'.$params['scene'].'%')
            ->where('dealer_id',$this->dealer_id)
            ->where('enable',1)
            ->where('is_del',0)
            ->sum('count');
        $total=Db::name('code_manage')
            ->where('remark','like','%'.$params['mark'].'%')
            ->where('code_type','like','%'.$params['type'].'%')
            ->where('scene','like','%'.$params['scene'].'%')
            ->where('dealer_id',$this->dealer_id)
            ->where('enable',1)
            ->where('is_del',0)
            ->count();
        $res=[
            'code'=>200,
            'msg'=>'查询成功',
            'data'=>$list,
            'sum'=>$sum,
            'total'=>$total
        ];
        return json($res);
    }
    public function saveEnableStatus(Request $request){
        $params=$request->post();
        $res=Db::name('code_manage')->update($params);
        if($res||$res==0){
            $info=[
                'code'=>200,
                'msg'=>'保存成功',
            ];
        }else{
            $info=[
                'code'=>201,
                'msg'=>'请联系管理员',
            ];
        }
        return json($info);
    }
    public function getEnableCodes(Request $request){
        $params=$request->get();
        $dealer_id=$this->dealer_id;
        $list=Db::name('code_enable')
            ->where('batch',$params['batch'])//批次唯一
            ->where('dealer_id',$dealer_id)
            ->page($params['pageNum'])
            ->limit($params['pageSize'])
            ->select();
        $total=Db::name('code_enable')
            ->where('batch',$params['batch'])//批次唯一
            ->where('dealer_id',$dealer_id)
            ->count();
        $res=[
            'code'=>200,
            'msg'=>'查询成功',
            'data'=>$list,
            'total'=>$total
        ];
        return json($res);
    }
    public function deleEnableLog(Request $request){
        $data=$request->get();
        Db::startTrans();
        try{
            Db::name('code_enable')->delete($data['id']);
            $res=Db::name('code_manage')
                ->where('batch',$data['batch'])
                ->setDec('used_num', $data['quantity']);
            if($res){
                $info=[
                    'code'=>200,
                    'msg'=>'保存成功',
                ];
            }
            Db::commit();
        }catch(\Exception $e){
            Db::rollback();
            $info=[
                'code'=>201,
                'msg'=>'请联系管理员'
            ];
        }
        return json($info);
    }
    public function addEnableLog(Request $request){
        $data=$request->post();
        //检查激活的区间范围是否合理
        $interval=Db::name('code_enable')
            ->where('batch',$data['batch'])
            ->select();
        $has_interval=Db::name('code_manage')
            ->where('batch',$data['batch'])
            ->find();
        if((int)preg_replace('/^0+/','',$data['start_code'])>=(int)preg_replace('/^0+/','',$data['end_code'])){
            return JsonService::fail('请检查激活区间！');
        }
        foreach($interval as $key=>$value){
            if(!$this->is_enable_interval($value['start_code'],$value['end_code'],$data['start_code'],$data['end_code'])){
                return JsonService::fail('激活区间存在重叠，请重新填写！');
            }
        }
        //判断激活区间是否在码段覆盖区间内
        if(!$this->is_contain_interval($data['start_code'],$data['end_code'],$has_interval['order_begin'],$has_interval['order_end'])){
            return JsonService::fail('激活区间不在生码区间，请重新填写！');
        }
        Db::startTrans();
        try{
            Db::name('code_enable')->strict(false)->insert($data);
            if($data['status']!=1){
                //部分启用
                Db::name('code_manage')
                    ->where('batch',$data['batch'])
                    ->update([
                        'status'=>2
                    ]);
            }
            $res=Db::name('code_manage')
                ->where('batch',$data['batch'])
                ->setInc('used_num', $data['quantity']);
            if($res){
                $info=[
                    'code'=>200,
                    'msg'=>'保存成功',
                ];
            }
            Db::commit();
        }catch(\Exception $e){
            Db::rollback();
            $info=[
                'code'=>201,
                'msg'=>'请联系管理员'
            ];
        }
        return json($info);
    }
    public function getRelProduct(Request $request){
        $params=$request->get();
        $list=Db::name('code_rel_product')
            ->alias('a')
            ->join('dealer_product b','a.product_id=b.id')
            ->where('a.dealer_id',$this->dealer_id)
            ->where('a.batch',$params['batch'])
            ->field('a.*,b.product_name')
            ->page($params['pageNum'])
            ->limit($params['pageSize'])
            ->select();
        $rel_count=Db::name('code_rel_product')
            ->where('dealer_id',$params['dealer_id'])
            ->where('batch',$params['batch'])
            ->where('partner_id',$params['partner_id'])
            ->sum('quantity');//已关联总数
        $total=Db::name('code_rel_product')
            ->where('dealer_id',$params['dealer_id'])
            ->where('batch',$params['batch'])
            ->where('partner_id',$params['partner_id'])
            ->count();
        $res=[
            'code'=>200,
            'msg'=>'查询成功',
            'rel_count'=>$rel_count,
            'data'=>$list,
            'total'=>$total
        ];
        return json($res);
    }
    public function getProduct(Request $request){
        $params=$request->get();
        $list=Db::name('dealer_product')
            ->where('dealer_id',$this->dealer_id)
            ->where('product_name','like','%'.$params['product_name'].'%')
            ->where('is_del',0)
            ->page($params['pageNum'])
            ->limit($params['pageSize'])
            ->select();
        $total=Db::name('dealer_product')
            ->where('dealer_id',$this->dealer_id)
            ->where('product_name','like','%'.$params['product_name'].'%')
            ->where('is_del',0)
            ->count();
        return JsonService::successful('查询成功',[$list,$total]);
    }
    /**
     * 删除全部关联
     */
    public function removeProductRel(Request $request){
        $batch=$request->param('batch');
        Db::startTrans();
        try{
            Db::name('code_manage')->where('batch',$batch)->update([
                'is_rel'=>0
            ]);
            Db::name('code_rel_product')->where('batch',$batch)->delete();
            $info=[
                'code'=>200,
                'msg'=>'清除成功',
            ];
            Db::commit();
        }catch(\Exception $e){
            Db::rollback();
            $info=[
                'code'=>201,
                'msg'=>'请联系管理员'
            ];
        }
        return json($info);
    }
    public function addRelLog(Request $request){
        $data=$request->post();
        //码段验重
        //检查关联的区间范围是否合理
        $interval=Db::name('code_rel_product')
            ->where('batch',$data['batch'])
            ->where('is_rel_all',0)
            ->select();
        $has_interval=Db::name('code_manage')
            ->where('batch',$data['batch'])
            ->find();
        if($data['tab']=='part'){
            $data['is_rel_all']=0;//部分关联
            if((int)preg_replace('/^0+/','',$data['start_code'])>=(int)preg_replace('/^0+/','',$data['end_code'])){
                return JsonService::fail('请检查关联区间！');
            }
            foreach($interval as $key=>$value){
                if(!$this->is_enable_interval($value['start_code'],$value['end_code'],$data['start_code'],$data['end_code'])){
                    return JsonService::fail('关联区间存在重叠，请重新填写！');
                }
            }
            if(!$this->is_contain_interval($data['start_code'],$data['end_code'],$has_interval['order_begin'],$has_interval['order_end'])){
                return JsonService::fail('关联区间不在生码区间，请重新填写！');
            }
        }else{
            //全部关联
            $data['is_rel_all']=1;
            $data['start_code']=$data['order_begin'];
            $data['end_code']=$data['order_end'];
        }
        Db::startTrans();
        try{
            unset($data['order_begin']);
            unset($data['order_end']);
            unset($data['product_name']);
            unset($data['tab']);
            if($data['is_rel_all']==1){
                //全部关联 码管理表插入单个产品id
                Db::name('code_manage')->where('batch',$data['batch'])->update([
                    'rel_product_id'=>$data['product_id']
                ]);
                //删除单个关联批次
                Db::name('code_rel_product')->where('batch',$data['batch'])->delete();
            }else{
                //将码管理表单个产品清除
                Db::name('code_manage')->where('batch',$data['batch'])->update([
                    'rel_product_id'=>null
                ]);
                Db::name('code_rel_product')->where('batch',$data['batch'])->where('is_rel_all',1)->delete();
            }
            Db::name('code_manage')->where('batch',$data['batch'])->update([
                'is_rel'=>1
            ]);
            $res=Db::name('code_rel_product')->insert($data);
            if($res){
                $info=[
                    'code'=>200,
                    'msg'=>'保存成功',
                ];
            }
            Db::commit();
        }catch(\Exception $e){
            Db::rollback();
            $info=[
                'code'=>201,
                'msg'=>'请联系管理员'
            ];
        }
        return json($info);
    }
    public function deleRelLog(Request $request){
        $params=$request->get();
        $res=Db::name('code_rel_product')->delete($params['id']);
        if($res){
            return JsonService::successful('删除成功');
        }else{
            return JsonService::fail('请联系管理员');
        }
    }
    public function getCodeBatch(Request $request){
        $list=Db::name('code_manage')
            ->where('dealer_id',$this->dealer_id)
            ->field('id,batch,remark,order_begin,order_end')
            ->select();
        return JsonService::successful('查询成功',$list);
    }

    /**
     * @param Request $request
     * @throws \think\db\exception\DataNotFoundException
     * @throws \think\db\exception\ModelNotFoundException
     * @throws \think\exception\DbException
     * 溯源码批次
     */
    public function getTraceCodeBatch(Request $request){
        $list=Db::name('code_manage')
            ->where('dealer_id',$this->dealer_id)
            ->where('scene','like','%2%')
            ->field('id,batch,remark,order_begin,order_end')
            ->select();
        return JsonService::successful('查询成功',$list);
    }

    /**
     * @param Request $request
     * @throws \think\db\exception\DataNotFoundException
     * @throws \think\db\exception\ModelNotFoundException
     * @throws \think\exception\DbException
     * 营销码批次
     */
    public function getMarketCodeBatch(Request $request){
        $list=Db::name('code_manage')
            ->where('dealer_id',$this->dealer_id)
            ->where('scene','like','%1%')
            ->where('is_del','<>',1)
            ->where('enable',1)
            ->field('id,batch,remark,order_begin,order_end')
            ->select();
        return JsonService::successful('查询成功',$list);
    }

    /**
     * @param Request $request
     * 导购码生码批次
     */
    public function getGuideCodeBatch(Request $request){
        $list=Db::name('code_manage')
            ->where('dealer_id',$this->dealer_id)
            ->where('scene','like','%3%')
            ->where('is_del','<>',1)
            ->where('enable',1)
            ->field('id,batch,remark,order_begin,order_end')
            ->select();
        return JsonService::successful('查询成功',$list);
    }


    public function getInvalidCodeList(Request $request){
        $params=$request->get();
        if($params['startTime']){
            $list=Db::name('code_disable')
                ->alias('a')
                ->join('code_manage b','a.batch=b.batch')
                ->where('a.batch','like','%'.$params['batch'].'%')
                ->where('a.remark','like','%'.$params['remark'].'%')
                ->where('b.code_type','like','%'.$params['type'].'%')
                ->where('a.create_time','between time',[$params['startTime'],$params['endTime']])
                ->page($params['pageNum'])
                ->limit($params['pageSize'])
                ->order('a.create_time','desc')
                ->field('a.*,b.code_type')
                ->select();
            $total=Db::name('code_disable')
                ->alias('a')
                ->join('code_manage b','a.batch=b.batch')
                ->where('a.batch','like','%'.$params['batch'].'%')
                ->where('a.remark','like','%'.$params['remark'].'%')
                ->where('b.code_type','like','%'.$params['type'].'%')
                ->where('a.create_time','between time',[$params['startTime'],$params['endTime']])
                ->count();
        }else{
            $list=Db::name('code_disable')
                ->alias('a')
                ->join('code_manage b','a.batch=b.batch')
                ->where('a.batch','like','%'.$params['batch'].'%')
                ->where('a.remark','like','%'.$params['remark'].'%')
                ->where('b.code_type','like','%'.$params['type'].'%')
                ->page($params['pageNum'])
                ->limit($params['pageSize'])
                ->order('a.create_time','desc')
                ->field('a.*,b.code_type')
                ->select();
            $total=Db::name('code_disable')
                ->alias('a')
                ->join('code_manage b','a.batch=b.batch')
                ->where('a.batch','like','%'.$params['batch'].'%')
                ->where('a.remark','like','%'.$params['remark'].'%')
                ->where('b.code_type','like','%'.$params['type'].'%')
                ->count();
        }
        $res=[
            'code'=>200,
            'msg'=>'查询成功',
            'data'=>$list,
            'total'=>$total
        ];
        return json($res);
    }
    public function saveInvalidCode(Request $request){
        $data=$request->post();
        $data['dealer_id']=$this->dealer_id;
        //检查作废码段
        $batchInfo=Db::name('code_manage')
            ->where('dealer_id',$this->dealer_id)
            ->where('batch',$data['batch'])
            ->find();
        $interval=Db::name('code_disable')
            ->where('batch',$data['batch'])
            ->select();
        if((int)preg_replace('/^0+/','',$data['order_begin'])>=(int)preg_replace('/^0+/','',$data['order_end'])){
            return JsonService::fail('请检查作废区间！');
        }
        foreach($interval as $key=>$value){
            if(!$this->is_enable_interval($value['order_begin'],$value['order_end'],$data['order_begin'],$data['order_end'])){
                return JsonService::fail('作废区间存在重叠，请重新填写！');
            }
        }
        if(!$this->is_contain_interval($data['order_begin'],$data['order_end'],$batchInfo['order_begin'],$batchInfo['order_end'])){
            return JsonService::fail('作废区间不在批次码段区间，请重新填写！');
        }
        $res=Db::name('code_disable')
            ->insert($data);
        if($res){
            return JsonService::successful('作废成功');
        }else{
            return JsonService::fail('请联系管理员');
        }
    }
    public function recoverInvalidCode(Request $request){
        $res=Db::name('code_disable')->delete($request->param('id'));
        if($res){
            return JsonService::successful('恢复成功');
        }else{
            return JsonService::fail('请联系管理员');
        }
    }
    /**
     * @param $a1
     * @param $a2
     * @param $b1
     * @param $b2
     * @return bool
     * [a1,a2][b1,b2] 检测区间是否冲突
     */
    public static function is_enable_interval($a1,$a2,$b1,$b2){
        $a1=(int)preg_replace('/^0+/','',$a1);//去零转整
        $a2=(int)preg_replace('/^0+/','',$a2);
        $b1=(int)preg_replace('/^0+/','',$b1);
        $b2=(int)preg_replace('/^0+/','',$b2);
        if($a2<$b1||$b2<$a1){
            return true;
        }else{
            return false;
        }
    }

    /**
     * @param $a1
     * @param $a2
     * @param $b1
     * @param $b2
     * @return bool
     * [a1,a2][b1,b2] 检测区间a是否是b的子集
     */
    public static function is_contain_interval($a1,$a2,$b1,$b2){
        $a1=(int)preg_replace('/^0+/','',$a1);//去零转整
        $a2=(int)preg_replace('/^0+/','',$a2);
        $b1=(int)preg_replace('/^0+/','',$b1);
        $b2=(int)preg_replace('/^0+/','',$b2);
        if($a1>=$b1&&$a2<=$b2){
            return true;
        }else{
            return false;
        }
    }
}