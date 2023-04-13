<?php
/**
 * Created by PhpStorm.
 * Role: wenhan
 * Date: 2021/10/27
 * Time: 上午5:42
 */

namespace app\partner\controller;
use think\Controller;
use think\facade\Env;
use think\Db;
use app\Request;
use app\common\JsonService;
use ZipStream;

class SecurityCode extends Controller
{
    public function listCode(Request $request){
        $params=$request->get();
        $partner_id=$request->userInfo()['id'];//合伙人id
//        if(!$params['scene']){
//            $scene='1,2,3,4';
//        }else{
//            $scene=$params['scene'];
//        }
        $list=Db::name('code_manage')
            ->alias('a')
            ->join('dealer c','a.dealer_id=c.id')
            ->leftJoin('dealer_product b','a.rel_product_id=b.id')//左表连接
            ->where('c.dealer_name','like','%'.$params['dealer'].'%')
            ->where('a.remark','like','%'.$params['mark'].'%')
            ->where('a.code_type','like','%'.$params['type'].'%')
            ->where('a.scene','like','%'.$params['scene'].'%')
            ->where('a.is_del',0)
            ->where('a.partner_id',$partner_id)
            ->page($params['pageNum'])
            ->limit($params['pageSize'])
            ->order('a.create_time','desc')
            ->field('a.*,c.dealer_name,c.account,b.product_name as rel_product_name')
            ->select();
        foreach ($list as $k=>$val){
            $list[$k]['secret_key']=json_decode($val['secret_key'],true);
        }
        $sum=Db::name('code_manage')
            ->alias('a')
            ->join('dealer c','a.dealer_id=c.id')
            ->where('c.dealer_name','like','%'.$params['dealer'].'%')
            ->where('a.remark','like','%'.$params['mark'].'%')
            ->where('a.code_type','like','%'.$params['type'].'%')
            ->where('a.scene','like','%'.$params['scene'].'%')
            ->where('a.partner_id',$partner_id)
            ->where('a.is_del',0)
            ->sum('a.count');
        $total=Db::name('code_manage')
            ->alias('a')
            ->join('dealer c','a.dealer_id=c.id')
            ->where('c.dealer_name','like','%'.$params['dealer'].'%')
            ->where('a.remark','like','%'.$params['mark'].'%')
            ->where('a.code_type','like','%'.$params['type'].'%')
            ->where('a.scene','like','%'.$params['scene'].'%')
            ->where('a.partner_id',$partner_id)
            ->where('a.is_del',0)
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
    public function createCodes(Request $request){
        $partner_id=$request->userInfo()['id'];//合伙人id
        $data=$request->post();
        $data['batch']=date('Ymd') . time();//年月日加时间戳
        $data['partner_id']=$partner_id;
        $data['verification_code']=$data['verification_code']?5:0;//验证码
        $data['rel_guide_code']=$data['rel_guide_code']?1:0;//关联导购码
        //判断是否关联产品
        if($data['rel_product_name']){
            $data['is_rel']=1;
        }
        $res=Db::name('code_manage')
            ->insert($data);
        if($res){
            $info=[
                'code'=>200,
                'msg'=>'生码成功',
            ];
        }else{
            $info=[
                'code'=>201,
                'msg'=>'请联系管理员',
            ];
        }
        return json($info);
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
     * @param Request $request
     * @return \think\response\Json
     * 生码
     */
    public function createCode(Request $request){
        set_time_limit(0);
        $info=$request->post();
        $partner_id=$request->userInfo()['id'];//合伙人id
        $balance=$request->userInfo()['balance'];
        $info['batch']=date('Ymd');//年月日加时间戳
        if(!$info['count']){
            //物流码生码数量单数计算
            $info['count']=bcsub($info['order_end'],$info['order_begin'])+1;
        }
        $info['partner_id']=$partner_id;
        $star=$info['order_begin'];
        $end=$info['order_end'];
        $codeLen=$info['code_length'];
        $info['verification_code']=$info['verification_code']?1:0;//验证码
        $info['rel_guide_code']=$info['rel_guide_code']?1:0;//
        //判断是否关联产品
        if($info['rel_product_name']){
            $info['is_rel']=1;
        }
        $filename = "./code/" . $info['batch']. ".zip";//码包名称只保留批次信息
        $zip = new \ZipArchive();
        //不存在创建
        if(!is_dir('./code'))
        {
            mkdir("./code");
        }
        // 使用本类，linux需开启zlib，windows需取消php_zip.dll前的注释
        if (file_exists($filename)) {
            // 存在时覆盖
            $zipr = $zip->open($filename, \ZipArchive::OVERWRITE);
        } else {
            // 不存在时创建
            $zipr = $zip->open($filename, \ZipArchive::CREATE);
        }
        //单独生导购码 是否生成附带二维码（？待确定）
        if(count($info['secret_key'])!=0){
            $prefix='http://wl.uni-2id.com?dealer_id='.$info['dealer_id'].'&batch='.$info['batch'].'&code=';
            //将数码分批生成 并打包listCode
            foreach ($info['secret_key'] as $k=>$value){
                $key=explode(',',$value['key']);//秘钥形式（n,d,e)
                $length=(int)$value['length'];
                $securityCode='';
                $order=explode('--',$value['order']);//码包起始序号
                for($i=(int)$order[0];$i<=(int)$order[1];$i++){
                    $curCode=bcpowmod($i,$key[2],$key[0],0);
                    $curCode=$this->appendString($curCode,$length-strlen($curCode),'0');//转字符串 统计长度
                    $serial_number=$this->appendString($i,$length-strlen($i),'0');
                    $securityCode.=$serial_number.','.$prefix.$curCode."\n";//添加前缀
                }
                $zip->addFromString(($k+1).'级包装'.'('.$order[0].'--'.(int)$order[1].')'.'.txt', $securityCode);//=>1级包装（5--10）.text
            }
            $zip->close();
        }else
//            if(strpos($info['scene'],'1')!== false){
            if($info['scene']=='1'){
            $prefix='http://yx.uni-2id.com/?dealer_id='.$info['dealer_id'].'&batch='.$info['batch'].'&qrcode=';
            //查询该长度的秘钥
            $key=explode(',',$info['key']);//秘钥形式（n,d,e）
            //开始生码 //异步生码
            $securityCode='';
            for($i=$star;$i<=$end;$i++){
                $curCode=bcpowmod($i,$key[2],$key[0],0);
                $curCode=$this->appendString($curCode,$codeLen-strlen($curCode),'0');//转字符串 统计长度
                $serial_number=$this->appendString($i,10-strlen($i),'0');
                $securityCode.=$serial_number.','.$prefix.$curCode."\n";//添加前缀
            }
            //压缩
            $zip->addFromString('('.$star.'--'.$end.')'.'.txt', $securityCode);//=>（5--10）.text
        }else if($info['scene']=='3'){
            //只生成导购码
            $prefix='https://www.ybwxg.com/dg/?dealer_id='.$info['dealer_id'].'&batch='.$info['batch'].'&qrcode=';
            //查询该长度的秘钥
            $key=explode(',',$info['key']);//秘钥形式（n,d,e）
            //开始生码 //异步生码
            $securityCode='';
            for($i=$star;$i<=$end;$i++){
                $curCode=bcpowmod($i,$key[2],$key[0],0);
                $curCode=$this->appendString($curCode,$codeLen-strlen($curCode),'0');//转字符串 统计长度
                $serial_number=$this->appendString($i,10-strlen($i),'0');
                $securityCode.=$serial_number.','.$prefix.$curCode."\n";//添加前缀
            }
            //压缩
            $zip->addFromString('('.$star.'--'.$end.')'.'.txt', $securityCode);//=>（5--10）.text
        }else if(strpos($info['scene'],'1')!== false&&strpos($info['scene'],'3')!== false){
            //导购与营销码 二码合一
                $prefix='https://www.ybwxg.com/multi/?dealer_id='.$info['dealer_id'].'&batch='.$info['batch'].'&qrcode=';
                //查询该长度的秘钥
                $key=explode(',',$info['key']);//秘钥形式（n,d,e）
                //开始生码 //异步生码
                $securityCode='';
                for($i=$star;$i<=$end;$i++){
                    $curCode=bcpowmod($i,$key[2],$key[0],0);
                    $curCode=$this->appendString($curCode,$codeLen-strlen($curCode),'0');//转字符串 统计长度
                    $serial_number=$this->appendString($i,10-strlen($i),'0');
                    $securityCode.=$serial_number.','.$prefix.$curCode.','.$serial_number."\n";//添加前缀
                }
                //压缩
                $zip->addFromString('('.$star.'--'.$end.')'.'.txt', $securityCode);//=>（5--10）.text
            }else {
            //查询该长度的秘钥
            $key=explode(',',$info['key']);//秘钥形式（n,d,e）
            //开始生码 //异步生码
            $securityCode='';
            for($i=$star;$i<=$end;$i++){
                $curCode=bcpowmod($i,$key[2],$key[0],0);
                $curCode=$this->appendString($curCode,$codeLen-strlen($curCode),'0');//转字符串 统计长度
                $securityCode.=$curCode."\n";//添加前缀
            }
            //压缩
            $zip->addFromString('('.$star.'--'.$end.')'.'.txt', $securityCode);//=>（5--10）.text
        }
        Db::startTrans();//开启事务
        try{
            unset($info['dealer_name']);
            $info['secret_key']=json_encode($info['secret_key']);
            $res=Db::name('code_manage')
            ->insert($info);
            if($info['rel_product_name']){
                Db::name('code_rel_product')->insert([
                    'batch'=>$info['batch'],
                    'start_code'=>$star,
                    'end_code'=>$end,
                    'quantity'=>$info['count'],
                    'product_id'=>$info['rel_product_id'],
                    'remark'=>$info['remark'],
                    'is_rel_all'=>1,
                    'partner_id'=>$partner_id,
                    'dealer_id'=>$info['dealer_id']
                ]);
            }
            //扣费
            if($info['pay_type']==0){
                if($info['total_cost_fee']>$balance){
                    $info=[
                        'code'=>201,
                        'msg'=>'您的余额不足'
                    ];
                    return json($info);
                }else{
                    Db::name('partner')
                        ->where('id',$partner_id)
                        ->setDec('balance',$info['total_cost_fee']);
                    $new_balance = Db::name('partner')
                        ->where('id', $partner_id)
                        ->value('balance');
                    $serial_number=date('Ymd') . time();
                    Db::name('finance_bill')
                        ->insert([
                            'serial_number' => $serial_number,//年月日加时间戳
                            'transaction_type' => 3,//生码
                            'remark' => '品牌商生码',
                            'subject' => 1,//合伙人
                            'account_type' => 1,//余额
                            'balance' => $new_balance,
                            'payments_type' => 1,
                            'bill' => $info['total_cost_fee'],
                            'subject_id' => $partner_id
                        ]);
                    Db::name('finance_bill')
                        ->insert([
                            'serial_number' => $serial_number,//年月日加时间戳
                            'transaction_type' => 3,//生码
                            'remark' => '品牌商生码',
                            'subject' => 2,//品牌商
                            'account_type' => 1,//余额
                            'balance' => $new_balance,
                            'payments_type' => 1,
                            'bill' => $info['total_fee'],
                            'subject_id' => $info['dealer_id']
                        ]);
                }
            }
            if($res){
                $info=[
                    'code'=>200,
//                    'securityCode'=>$securityCode,
                    'msg'=>'提交成功，待审核',
                ];
            }
            Db::commit();
        }catch(\Exception $e){
            Db::rollback();
            $info=[
                'code'=>201,
                'msg'=>$e->getMessage()
            ];
        }
        return json($info);
    }

    /**
     * 查询生码价格
     * @param Request $request
     */
    public function getCreateCodePrice(Request $request){
        $params=$request->get();
        $partner_id=$request->userInfo()['id'];//合伙人id
        $sum_fee=0;//品牌商生码零售总价
        $sum_cost_fee=0;//合伙人生码总成本价
        $code_retail=0;//品牌商单价
        $cost=0;//成本单价
        $flag=false;
        $flag_cost=false;
        $data=Db::name('dealer')
            ->alias('a')
            ->leftJoin(['ctc_dealer_business_license'=>'b'],'a.id=b.dealer_id')
            ->leftJoin(['ctc_dealer_trademark'=>'c'],'a.id=c.dealer_id')
            ->field('a.*,a.status as dealer_status,b.*,b.status as license_status,c.*,c.status as trademark_status ')
            ->where('a.id',$params['dealer_id'])
            ->find();
        //总部码成本价
        $main_code_list=Db::name('product_code')
            ->select();
        //查询码费
        $partner_code=Db::name('partner_product_code')
            ->where('partner_id',$partner_id)
            ->select();//合伙人设置的码费
        $dealer_code=$data['code_ladder']?json_decode($data['code_ladder'],true):[];
        if(count($dealer_code)>0){
            foreach ($dealer_code as $key=>$value){
                foreach ($partner_code as $k=>$val){
                    if($value['id']==$val['id']){
                        $partner_code[$k]['code_retail']=$value['code_retail'];
                    }
                }
            }
        }
        foreach ($main_code_list as $key=>$value){
            if($value['code_order_begin']<=$params['count']&&$params['count']<=$value['code_order_end']){
                $cost=$value['code_cost'];
                $sum_cost_fee=bcmul($params['count'],$cost,2);
                $flag_cost=true;
                break;
            }
        }
        if(!$flag_cost){
            $cost=$main_code_list[count($main_code_list)-1]['code_cost'];
            $sum_cost_fee=bcmul($params['count'],$cost,2);
        }
        foreach ($partner_code as $key=>$value){
            if($value['code_order_begin']<=$params['count']&&$params['count']<=$value['code_order_end']){
                $sum_fee=bcmul($params['count'],$value['code_retail'],2);
                $code_retail=$value['code_retail'];
                $flag=true;
                break;
            }
        }
        //未匹配到 从最大额度计费
        if(!$flag){
            $sum_fee=bcmul($params['count'],$partner_code[count($partner_code)-1]['code_retail'],2);
            $code_retail=$partner_code[count($partner_code)-1]['code_retail'];
        }
        $info=[
            'code'=>200,
            'msg'=>'查询成功',
            'sum_fee'=>$sum_fee,
            'sum_cost_fee'=>$sum_cost_fee,
            'code_retail'=>$code_retail,
            'code_cost'=>$cost
        ];
        return json($info);
    }
    /**
     * 查询启用码段
     * 全部启用优先级>部分启用
     */
    public function getEnableCodes(Request $request)
    {
        $params=$request->get();
        $partner_id=$request->userInfo()['id'];//合伙人id
        $list=Db::name('code_enable')
            ->where('batch',$params['batch'])//批次唯一
            ->where('partner_id',$partner_id)
            ->page($params['pageNum'])
            ->limit($params['pageSize'])
            ->select();
        $total=Db::name('code_enable')
            ->where('batch',$params['batch'])//批次唯一
            ->where('partner_id',$partner_id)
            ->count();
        $res=[
            'code'=>200,
            'msg'=>'查询成功',
            'data'=>$list,
            'total'=>$total
        ];
        return json($res);
    }
    public function saveEnableStatus(Request $request)
    {
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
    public function addEnableLog(Request $request){
        $data=$request->post();
        $interval=Db::name('code_enable')
            ->where('batch',$data['batch'])
            ->select();
        $has_interval=Db::name('code_manage')
            ->where('batch',$data['batch'])
            ->find();
        //检查激活的区间范围是否合理
        if((int)preg_replace('/^0+/','',$data['start_code'])>=(int)preg_replace('/^0+/','',$data['end_code'])){
            return JsonService::fail('请检查激活区间！');
        }
        //判断激活区间是否与已激活的码区间存在重叠
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
    public function getProduct(Request $request){
        $params=$request->get();
        $list=Db::name('dealer_product')
            ->where('dealer_id',$params['dealer_id'])
            ->where('product_name','like','%'.$params['product_name'].'%')
            ->where('is_del',0)
            ->page($params['pageNum'])
            ->limit($params['pageSize'])
            ->select();
        $total=Db::name('dealer_product')
            ->where('dealer_id',$params['dealer_id'])
            ->where('product_name','like','%'.$params['product_name'].'%')
            ->where('is_del',0)
            ->count();
        return JsonService::successful('查询成功',[$list,$total]);
    }
    public function getRelProduct(Request $request){
        $params=$request->get();
        $list=Db::name('code_rel_product')
            ->alias('a')
            ->join('dealer_product b','a.product_id=b.id')
            ->where('a.dealer_id',$params['dealer_id'])
            ->where('a.batch',$params['batch'])
            ->where('a.partner_id',$params['partner_id'])
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
    public function addRelLog(Request $request){
        $data=$request->post();
        //码段验重
        //检查关联的区间范围是否合理 只限部分关联
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
//            foreach($interval as $key=>$value){
//                if(!$this->is_enable_interval($value['start_code'],$value['end_code'],$data['order_begin'],$data['order_end'])){
//                    return JsonService::fail('该产品已关联，请勿重复关联！');
//                }
//            }
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

    /**
     * @param Request $request
     * 查询品牌商关联批次
     */
    public function queryDealerCodeBatch(Request $request){
        $params=$request->get();
        $list=Db::name('code_manage')
            ->alias('a')
            ->leftJoin('dealer_product b','a.rel_product_id=b.id')//左表连接
            ->where('a.dealer_id',$params['dealer_id'])
            ->where('a.is_del',0)
            ->order('a.create_time','desc')
            ->field('a.*,b.product_name')
            ->select();
        return JsonService::successful('查询成功',$list);
    }
    /**
     * 查询生码起始序列号
     */
    public function getCodeBeginOrder(Request $request){
        $dealer_id=$request->param('id');
        $max_order=Db::name('code_manage')
            ->where('dealer_id',$dealer_id)
            ->where('is_del',0)
            ->max('order_end',false);
        return JsonService::successful('查询成功',(int)$max_order+1);
    }
    /**
     * @param Request $request
     * 下载码包
     */
    public function downLoad(Request $request){
        $batch=$request->param('batch');
        $download =  new \think\response\Download(config('public_code_dir').$batch.'.zip');
        return $download->name('code.zip');
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