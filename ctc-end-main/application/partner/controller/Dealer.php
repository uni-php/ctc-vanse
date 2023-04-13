<?php
/**
 * Created by PhpStorm.
 * Role: wenhan
 * Date: 2021/10/24
 * Time: 下午8:46
 */

namespace app\partner\controller;
use think\Controller;
use think\Db;
use app\Request;
use app\common\ImgUpload;
use app\common\Qiniu;

class Dealer extends Controller
{
    public function getDealerList(Request $request){
        $params=$request->get();
        $partner_id=$request->userInfo()['id'];//合伙人id
        $condition=[];
        if($params['startTime']){
            $condition['a.create_time']=['>time',$params['startTime']];
            $condition['a.create_time']=['<time',$params['endTime']];
        }
        //已过期
        if($params['status']==3){
            $condition['a.validity_end']=['<=time',time()];
        }
        if(count($condition)>0){
            if($params['status']!=3){
                $list=Db::name('dealer')
                    ->alias('a')
                    ->leftJoin(['ctc_dealer_business_license'=>'c'],'a.id=c.dealer_id')
                    ->leftJoin(['ctc_dealer_trademark'=>'d'],'a.id=d.dealer_id')
                    ->where('a.dealer_name','like','%'.$params['dealer_name'].'%')
                    ->where('a.status','like','%'.$params['status'].'%')
                    ->where('a.is_del',0)
                    ->where('a.partner_id',$partner_id)
                    ->where($condition)
                    ->page($params['pageNum'])
                    ->limit($params['pageSize'])
                    ->field('a.*,c.status as license_status,d.status as trademark_status')
                    ->select();
                $total=Db::name('dealer')
                    ->where('dealer_name','like','%'.$params['dealer_name'].'%')
                    ->where('status','like','%'.$params['status'].'%')
                    ->where($condition)
                    ->where('partner_id',$partner_id)
                    ->count();
            }else{
                $list=Db::name('dealer')
                    ->alias('a')
                    ->leftJoin(['ctc_dealer_business_license'=>'c'],'a.id=c.dealer_id')
                    ->leftJoin(['ctc_dealer_trademark'=>'d'],'a.id=d.dealer_id')
                    ->where('a.dealer_name','like','%'.$params['dealer_name'].'%')
                    ->where('a.is_del',0)
                    ->where($condition)
                    ->where('a.partner_id',$partner_id)
                    ->page($params['pageNum'])
                    ->limit($params['pageSize'])
                    ->field('a.*,c.status as license_status,d.status as trademark_status')
                    ->select();
                $total=Db::name('dealer')
                    ->where('dealer_name','like','%'.$params['dealer_name'].'%')
                    ->where('partner_id',$partner_id)
                    ->where($condition)
                    ->count();
            }
        }else{
            $list=Db::name('dealer')
                ->alias('a')
                ->leftJoin(['ctc_dealer_business_license'=>'c'],'a.id=c.dealer_id')
                ->leftJoin(['ctc_dealer_trademark'=>'d'],'a.id=d.dealer_id')
                ->where('a.dealer_name','like','%'.$params['dealer_name'].'%')
                ->where('a.status','like','%'.$params['status'].'%')
                ->where('a.is_del',0)
                ->where('a.partner_id',$partner_id)
                ->page($params['pageNum'])
                ->limit($params['pageSize'])
                ->field('a.*,c.status as license_status,d.status as trademark_status')
                ->select();
            $total=Db::name('dealer')
                ->where('dealer_name','like','%'.$params['dealer_name'].'%')
                ->where('status','like','%'.$params['status'].'%')
                ->where('partner_id',$partner_id)
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
    public function getDealerMoreInfo(Request $request){
        $id=$request->param('id');
        $data=Db::name('dealer')
            ->alias('a')
            ->leftJoin(['ctc_dealer_business_license'=>'b'],'a.id=b.dealer_id')
            ->leftJoin(['ctc_dealer_trademark'=>'c'],'a.id=c.dealer_id')
            ->field('a.*,a.status as dealer_status,b.*,b.status as license_status,c.*,c.status as trademark_status ')
            ->where('a.id',$id)
            ->find();
        $server=Db::name('partner_product_service')
            ->where('id',$data['service_level'])
            ->find();
        $info=[
            'code'=>200,
            'msg'=>'查询成功',
            'data'=>$data,
            'serverInfo'=>$server,
            'modules'=>json_decode($data['module'],true)
        ];
        return json($info);
    }
    public function getDealerPrice(Request $request){
        $id=$request->param('id');
        $partner_id=$request->userInfo()['id'];//合伙人id
        $data=Db::name('dealer')
            ->alias('a')
            ->leftJoin(['ctc_dealer_business_license'=>'b'],'a.id=b.dealer_id')
            ->leftJoin(['ctc_dealer_trademark'=>'c'],'a.id=c.dealer_id')
            ->field('a.*,a.status as dealer_status,b.*,b.status as license_status,c.*,c.status as trademark_status ')
            ->where('a.id',$id)
            ->find();
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
        //查询服务费
        $partner_ser=Db::name('partner_product_service')
            ->where('partner_id',$partner_id)
            ->select();
        $dealer_ser=$data['service_price']?json_decode($data['service_price'],true):[];
        if(count($dealer_ser)>0){
            foreach ($dealer_ser as $key=>$value){
                foreach ($partner_ser as $k=>$val){
                    if($value['id']==$val['id']){
                        $partner_ser[$k]['service_cost']=$value['service_cost'];
                    }
                }
            }
        }
        $info=[
            'code'=>200,
            'msg'=>'查询成功',
            'service_data'=>$partner_ser,
            'code_data'=>$partner_code,
            'modules'=>json_decode($data['module'],true)
        ];
        return json($info);
    }
    public function rechargeLog(Request $request){
        $params=$request->get();
        $data=Db::name('redpool_recharge_record')
            ->where('dealer_id',$params['id'])
            ->page($params['pageNum'])
            ->limit($params['pageSize'])
            ->select();
        $total=Db::name('redpool_recharge_record')
            ->where('dealer_id',$params['id'])
            ->count();
        $info=[
            'code'=>200,
            'msg'=>'查询成功',
            'data'=>$data,
            'total'=>$total
        ];
        return json($info);
    }
    public function redPackIssueLog(Request $request){
        $params=$request->get();
        if($params['beginTime']){
            $data=Db::name('redpool_issue_record')
                ->where('dealer_id',$params['id'])
                ->where('openid','like','%'.$params['openid'].'%')
                ->where('create_time', 'between time', [$params['beginTime'],$params['endTime']])
                ->page($params['pageNum'])
                ->limit($params['pageSize'])
                ->select();
            $total=Db::name('redpool_issue_record')
                ->where('dealer_id',$params['id'])
                ->where('create_time', 'between time', [$params['beginTime'],$params['endTime']])
                ->where('openid','like','%'.$params['openid'].'%')
                ->count();
        }else{
            $data=Db::name('redpool_issue_record')
                ->where('dealer_id',$params['id'])
                ->where('openid','like','%'.$params['openid'].'%')
                ->page($params['pageNum'])
                ->limit($params['pageSize'])
                ->select();
            $total=Db::name('redpool_issue_record')
                ->where('dealer_id',$params['id'])
                ->where('openid','like','%'.$params['openid'].'%')
                ->count();
        }
        $info=[
            'code'=>200,
            'msg'=>'查询成功',
            'data'=>$data,
            'total'=>$total
        ];
        return json($info);
    }
    public function calculateLiftSerPrice(Request $request){
        $data=$request->post();
        $cur_price=Db::name('partner_product_service')
            ->where('id',$data['service_level'])
            ->value('service_cost');
        $new_price=Db::name('partner_product_service')
            ->where('id',$data['ser_id'])
            ->value('service_cost');
        $info=[
            'code'=>200,
            'msg'=>'查询成功',
            'ser_price'=>$cur_price>$new_price?0:bcsub($new_price,$cur_price),
            ];
        return json($info);
    }
    public function calculateLiftPrice(Request $request){
        $data=$request->post();
        $module_cost=$module_sale=0;
        $cur_module_cost=$cur_module_sale=0;//当前拥有模块的价格
        $cur_dealer_module=Db::name('dealer')->where('id',$data['dealer_id'])->value('module');
        $cur_dealer_module=json_decode($cur_dealer_module,true);
        $partner_id=$request->userInfo()['id'];//合伙人id
        $module=Db::name('product_module')
            ->select();
        $partner_module=Db::name('partner_product_module')
            ->where('partner_id',$partner_id)
            ->select();
        //查询该等级下的 开户折扣
        $discount=Db::name('partner_level')
            ->where('level',$request->userInfo()['level_id'])
            ->value('account_discount');
        $discount=($discount*10)/100;
        foreach ($module as $key=>$value){
            $module[$key]['module_cost']=bcmul($value['module_cost'],$discount);
            //查询零售价 优先选取品牌商设置的零售价
            foreach ($partner_module as $k=>$val){
                if($val['module_id']==$value['id']){
                    $module[$key]['module_retail']=$val['retail_price'];
                }
            }
        }
        //选取后的总价
        foreach ($data['module_ids'] as $key=>$value){
            foreach ($module as $k=>$val){
                if($value==$val['id']){
                    $module_cost+=$val['module_cost'];
                    $module_sale+=$val['module_retail'];
                }
            }
        }
        //查询当前模块的价格
        foreach ($cur_dealer_module as $key=>$value){
            foreach($module as $k=>$val){
                if($value['module_id']==$val['id']){
                    $cur_module_cost+=$val['module_cost'];
                    $cur_module_sale+=$val['module_retail'];
                }
            }
        }
        $info=[
            'code'=>200,
            'msg'=>'查询成功',
            'cost'=>$cur_module_cost>$module_cost?0:bcsub($module_cost,$cur_module_cost),
            'sale'=>$cur_module_sale>$module_sale?0:bcsub($module_sale,$cur_module_sale)
        ];
        return json($info);
    }
    public function calculateModulePrice(Request $request){
        $partner_id=$request->userInfo()['id'];//合伙人id
        $module_id=$request->param('module_id');
        $module_cost=$module_sale=0;
        $module_ids=explode(',',$module_id);
        //计算价格
        //查询主系统模块
        $module=Db::name('product_module')
            ->select();
        $partner_module=Db::name('partner_product_module')
            ->where('partner_id',$partner_id)
            ->select();
        //查询该等级下的 开户折扣
        $discount=Db::name('partner_level')
            ->where('level',$request->userInfo()['level_id'])
            ->value('account_discount');
        $discount=($discount*10)/100;
        foreach ($module as $key=>$value){
            $module[$key]['module_cost']=bcmul($value['module_cost'],$discount);
            //查询零售价 优先选取品牌商设置的零售价
            foreach ($partner_module as $k=>$val){
                if($val['module_id']==$value['id']){
                    $module[$key]['module_retail']=$val['retail_price'];
                }
            }
        }
        foreach ($module_ids as $key=>$value){
            foreach ($module as $k=>$val){
                if($value==$val['id']){
                    $module_cost+=$val['module_cost'];
                    $module_sale+=$val['module_retail'];
                }
            }
        }
        $info=[
            'code'=>200,
            'msg'=>'查询成功',
            'module_cost'=>$module_cost,
            'module_sale'=>$module_sale,
            'module_price'=>$module
        ];
        return json($info);
    }
    public function addDealer(Request $request){
        $data=$request->post();
        $partner_id=$request->userInfo()['id'];
        $data['validity_begin']=date('Y-m-d');
        $data['validity_end']=date("Y-m-d",strtotime("+1 year",strtotime($data['validity_begin'])));
        $data['partner_id']=$request->userInfo()['id'];//合伙人id
        $data['module']=json_encode($data['module']);
        $data['password']=md5($data['password']);//加密
        if($data['sum_price']>$request->userInfo()['deposit']){
            $info=[
                'code'=>201,
                'msg'=>'您的预存款账户余额不足'
            ];
            return json($info);
        }
        Db::startTrans();//开启事务
        try{
            $res=Db::name('dealer')->strict(false)->insert($data);//开户
            if($res){
                Db::name('partner')->where('id',$partner_id)->setDec('deposit', $data['sum_price']);
                $balance = Db::name('partner')->where('id', $partner_id)->value(['deposit']);//余额
                $bill=Db::name('finance_bill')
                    ->insert([
                        'serial_number' => date('Ymd') . time(),//年月日加时间戳
                        'transaction_type' => 2,//开户
                        'remark' => '品牌商开户',
                        'subject' => 1,//合伙人
                        'account_type' => 2,//预存款
                        'balance' => $balance,
                        'payments_type' => 1,
                        'bill' => $data['sum_price'],
                        'subject_id' => $partner_id
                    ]);
                if($bill){
                    $info=[
                        'code'=>200,
                        'msg'=>'新增成功'
                    ];
                }else{
                    throw new \Exception('申请失败，请联系管理员');
                }
            }
            Db::commit();
        }catch (\Exception $e){
            Db::rollback();
            $info=[
                'code'=>201,
                'msg'=>'开户失败，请联系管理员'
            ];
        }
        return json($info);
    }
    public function cutDealer(Request $request){
        $params=$request->get();
        if($params['status']==0){
            $status=1;
            $txt='授权成功';
        }
        if($params['status']==1){
            $status=2;
            $txt='禁用成功';
        }
        if($params['status']==3){
            $status=0;
            $txt='已恢复';
        }
        if($params['status']==2){
            $status=1;
            $txt='已恢复';
        }
        $code=Db::name('dealer')
            ->where('id',$params['id'])
            ->update([
                'status'=>$status
            ]);
        if($code){
            $info=[
                'code'=>200,
                'msg'=>$txt
            ];
        }else{
            $info=[
                'code'=>201,
                'msg'=>'请联系管理员'
            ];
        }
        return json($info);
    }
    public function getDealerInfo(Request $request){
        $id=$request->param('id');
        $data=Db::name('dealer')
            ->where('id',$id)
            ->field('module',true)
            ->find();
        $info=[
            'code'=>200,
            'msg'=>'查询成功',
            'data'=>$data
        ];
        return json($info);
    }
    public function updateDealer(Request $request){
        $data=$request->post();
        if(array_key_exists('password',$data)){
            $data['password']=md5($data['password']);
        }
        $res=Db::name('dealer')
            ->update($data);
        if($res||$res==0){
            $info=[
                'code'=>200,
                'msg'=>'更新成功'
            ];
        }else{
            $info=[
                'code'=>201,
                'msg'=>'系统异常'
            ];
        }
        return json($info);
    }
    public function getDealerModule(Request $request){
       $id=$request->param('id');
       $res=Db::name('dealer')
           ->where('id',$id)
           ->value('module');
       $info=[
           'data'=>json_decode($res,true),
           'code'=>200,
           'msg'=>'查询成功'
       ];
       return json($info);
    }
    public function saveIncrement(Request $request){
        $data=$request->post();
        $data['partner_id']=$request->userInfo()['id'];//合伙人id
        if(array_key_exists('id',$data)){
            $res=Db::name('increment_service_order')
                ->update($data);
        }else{
            $data['order_num']=date('Ymd') . time();
            $res=Db::name('increment_service_order')
                ->strict(false)
                ->insert($data);
        }
        if($res||$res==0){
            $info=[
                'code'=>200,
                'msg'=>'提交成功'
            ];
        }else{
            $info=[
                'code'=>201,
                'msg'=>'系统异常'
            ];
        }
        return json($info);
    }
    //查询续费模块 续费时 成本价格按主系统续费折扣算  零售价格先选取合伙人自由设置的价格 若无 则去主系统选取
    public function getRenewModule(Request $request){
        $dealer_id=$request->param('id');//品牌商id
        $partner_id=$request->userInfo()['id'];//合伙人id
        $module_cost=$module_sale=0;
        //查询续费折扣
        $discount=Db::name('partner_level')
            ->where('level',$request->userInfo()['level_id'])
            ->value('renewal_discount');
        $discount=($discount*10)/100;
        //查询主系统模块
        $module=Db::name('product_module')
            ->select();
        $partner_module=Db::name('partner_product_module')
            ->where('partner_id',$partner_id)
            ->select();
        $renew_modules=Db::name('dealer')
            ->where('id',$dealer_id)
            ->value('module');
        $renew_modules=json_decode($renew_modules,true);
        foreach ($module as $key=>$value){
            $module[$key]['module_cost']=bcmul($value['module_cost'],$discount);
            //查询零售价 优先选取品牌商设置的零售价
            foreach ($partner_module as $k=>$val){
                if($val['module_id']==$value['id']){
                    $module[$key]['module_retail']=$val['retail_price'];
                }
            }
        }
        foreach ($renew_modules as $key=>$value){
            foreach ($module as $k=>$val){
                if($value['module_id']==$val['id']){
                    $renew_modules[$key]['module_cost']=$module[$k]['module_cost'];
                    $renew_modules[$key]['module_retail']=$module[$k]['module_retail'];
                    $module_cost+=$val['module_cost'];
                    $module_sale+=$val['module_retail'];
                }
            }
        }
        $data=Db::name('dealer')
            ->where('id',$dealer_id)
            ->find();
        $server=Db::name('partner_product_service')
            ->where('id',$data['service_level'])
            ->find();
        $deposit=Db::name('partner')->where('id',$partner_id)->value('deposit');
        $info=[
            'code'=>200,
            'msg'=>'查询成功',
            'validity_end'=>$data['validity_end'],
            'serverInfo'=>$server,
            'deposit'=>$deposit,
            'module_cost'=>$module_cost,
            'module_sale'=>$module_sale,
            'module_price'=>$renew_modules
        ];
        return json($info);
    }
    public function renew(Request $request){
        $data=$request->get();
        $partner_id=$request->userInfo()['id'];//合伙人id
        $term=$data['year'];
        $balance=Db::name('partner')
            ->where('id',$partner_id)
            ->value(['deposit']);//预存款余额
        if($balance<$data['cost']){
            $info = [
                'code' => 201,
                'msg' => '预存款余额不足'
            ];
        }else {
            //开启事务
            $end = Db::name('dealer')
                ->where('id', $data['dealer_id'])
                ->value('validity_end');
            $end = date("Y-m-d", strtotime("+$term year", strtotime($end)));
            Db::startTrans();//开启事务
            try {
                Db::name('dealer')
                    ->where('id', $data['dealer_id'])
                    ->update([
                        'validity_end' => $end
                    ]);
                Db::name('partner')
                    ->where('id', $partner_id)
                    ->setDec('deposit', $data['cost']);
                $balance = Db::name('partner')
                    ->where('id', $partner_id)
                    ->value(['deposit']);//余额
                $serial_number=date('Ymd') . time();
                $bill = Db::name('finance_bill')
                    ->insert([
                        'serial_number' => $serial_number,//年月日加时间戳
                        'transaction_type' => 6,//续费
                        'remark' => '品牌商续费',
                        'subject' => 1,//合伙人
                        'account_type' => 2,//预存款
                        'balance' => $balance,
                        'payments_type' => 1,
                        'bill' => $data['cost'],
                        'subject_id' => $partner_id
                    ]);
                $bills = Db::name('finance_bill')
                    ->insert([
                        'serial_number' => $serial_number,//年月日加时间戳
                        'transaction_type' => 6,//续费
                        'remark' => '品牌商续费',
                        'subject' => 2,//品牌商
                        'account_type' => 2,//预存款
                        'balance' => $balance,
                        'payments_type' => 1,
                        'bill' => $data['sale'],
                        'subject_id' => $data['dealer_id']
                    ]);
                if ($bill&&$bills) {
                    $info = [
                        'code' => 200,
                        'msg' => '续费成功'
                    ];
                }
                Db::commit();
            } catch (\Exception $e) {
                Db::rollback();
                $info = [
                    'code' => 201,
                    'msg' => '请联系管理员'
                ];
            }
        }
        return json($info);
    }
    public function liftingService(Request $request){
        $data=$request->post();
        $partner_id=$request->userInfo()['id'];//合伙人id
        $deposit=$request->userInfo()['deposit'];
        if($data['cost']>$deposit){
            $info=[
              'code'=>201,
              'msg'=>'您的预存款不足'
            ];
            return json($info);
        }
        Db::startTrans();//开启事务
        try{
            Db::name('dealer')
                ->where('id',$data['dealer_id'])
                ->update([
                    'service_level'=>$data['service_level'],
                    'module'=>json_encode($data['module'])
                ]);
            Db::name('partner')
                ->where('id',$partner_id)
                ->setDec('deposit', $data['cost']);
            $balance = Db::name('partner')
                ->where('id', $partner_id)
                ->value(['deposit']);//余额
            $serial_number=date('Ymd') . time();
            $bill=Db::name('finance_bill')
                ->insert([
                    'serial_number' => $serial_number,//年月日加时间戳
                    'transaction_type' => 5,//升降
                    'remark' => '品牌商模块升降服务',
                    'subject' => 1,//合伙人
                    'account_type' => 2,//预存款
                    'balance' => $balance,
                    'payments_type' => 1,
                    'bill' => $data['cost'],
                    'subject_id' => $partner_id
                ]);
            $bills=Db::name('finance_bill')
                ->insert([
                    'serial_number' => $serial_number,//年月日加时间戳
                    'transaction_type' => 5,//升降
                    'remark' => '品牌商模块升降服务',
                    'subject' => 2,//品牌商
                    'account_type' => 2,//预存款
                    'balance' => $balance,
                    'payments_type' => 1,
                    'bill' => $data['sale'],
                    'subject_id' => $data['dealer_id']
                ]);
            if($bill&&$bills){
                $info = [
                    'code' => 200,
                    'msg' => '升降成功'
                ];
            }
            Db::commit();
        }catch (\Exception $e){
            Db::rollback();
            $info=[
                'code'=>201,
                'msg'=>'请联系管理员'
            ];
        }
        return json($info);
    }
    public function saveDealerModulePrice(Request $request){
        $data=$request->get();
        $module=Db::name('dealer')
            ->where('id',$data['dealer_id'])
            ->value('module');
        $module=json_decode($module,true);
        foreach ($module as $key=>$value){
            if($value['module_id']==$data['module_id']){
                $module[$key]['module_retail']=$data['module_retail'];
            }
        }
        $res=Db::name('dealer')
            ->where('id',$data['dealer_id'])
            ->update([
                'module'=>json_encode($module)
            ]);
        if($res||$res==0){
            $info = [
                'code' => 200,
                'msg' => '设置成功'
            ];
        }else{
            $info = [
                'code' => 201,
                'msg' => '系统异常'
            ];
        }
        return json($info);
    }
    public function saveDealerCodePrice(Request $request){
        $data=$request->get();
        $partner_id=$request->userInfo()['id'];//合伙人id
        $dealer_code=Db::name('dealer')
            ->where('id',$data['dealer_id'])
            ->value('code_ladder');
        $partner_code=Db::name('partner_product_code')
            ->where('partner_id',$partner_id)
            ->select();//合伙人设置的码费
        $has=0;
        if(!$dealer_code){
            $dealer_code[0]['id']=$data['id'];
            $dealer_code[0]['code_retail']=$data['code_retail'];
        }else{
            $dealer_code=json_decode($dealer_code,true);
            foreach ($dealer_code as $key=>$value){
                if($value['id']==$data['id']){
                    $dealer_code[$key]['code_retail']=$data['code_retail'];
                }else{
                    $has++;
                }
            }
            if($has==count($dealer_code)){
                //插值
                $dealer_code[$has]['id']=$data['id'];
                $dealer_code[$has]['code_retail']=$data['code_retail'];
            }
        }
        $res=Db::name('dealer')
            ->where('id',$data['dealer_id'])
            ->update([
                'code_ladder'=>json_encode($dealer_code)
            ]);
        if($res||$res==0){
            $info = [
                'code' => 200,
                'msg' => '设置成功'
            ];
        }else{
            $info = [
                'code' => 201,
                'msg' => '系统异常'
            ];
        }
        return json($info);
    }
    public function saveDealerSerPrice(Request $request){
        $data=$request->get();
        $partner_id=$request->userInfo()['id'];
        $dealer_ser=Db::name('dealer')
            ->where('id',$data['dealer_id'])
            ->value('service_price');
        $has=0;
        if(!$dealer_ser){
            $dealer_ser[0]['id']=$data['id'];
            $dealer_ser[0]['service_cost']=$data['service_cost'];
        }else{
            $dealer_ser=json_decode($dealer_ser,true);
            foreach ($dealer_ser as $key=>$value){
                if($value['id']==$data['id']){
                    $dealer_ser[$key]['service_cost']=$data['service_cost'];
                }else{
                    $has++;
                }
            }
            if($has==count($dealer_ser)){
                //插值
                $dealer_ser[$has]['id']=$data['id'];
                $dealer_ser[$has]['service_cost']=$data['service_cost'];
            }
        }
        $res=Db::name('dealer')
            ->where('id',$data['dealer_id'])
            ->update([
                'service_price'=>json_encode($dealer_ser)
            ]);
        if($res||$res==0){
            $info = [
                'code' => 200,
                'msg' => '设置成功'
            ];
        }else{
            $info = [
                'code' => 201,
                'msg' => '系统异常'
            ];
        }
        return json($info);
    }
    public function getAuthData(Request $request){
        $id=$request->param('id');
        $license=Db::name('dealer_business_license')
            ->where('dealer_id',$id)
            ->find();
        if(!$license) $license['status']=0;
        $license['type']=1;//营业执照
        $license['name']='企业营业执照';
        $license['tips']='认证后的品牌商资料将作为品牌商的通用名片，可在版权、防伪查询等地方进行应用。';
        $trademark=Db::name('dealer_trademark')
            ->where('dealer_id',$id)
            ->find();
        if(!$trademark) $trademark['status']=0;
        $trademark['type']=2;//商标
        $trademark['name']='中国商标权证书';
        $trademark['tips']='认证后的品牌商可以提升品牌的知名度和交易信任级别，认证后品牌商名称可以在查询页显示。';
        $arr=[
            $license,$trademark
        ];
        $info=[
            'code'=>200,
            'msg'=>'查询成功',
            'data'=>$arr
        ];
        return json($info);
    }
    public function checkTrademark(Request $request){
        $data=$request->get();
        if(array_key_exists('id',$data)){
            $data['status']=3;//更新中
            $code=Db::name('dealer_trademark')
                ->update($data);
        }else{
            $data['status']=0;//待认证
            $code=Db::name('dealer_trademark')
                ->insert($data);
        }
        if($code||$code==0){
            $info=[
                'code'=>200,
                'msg'=>'提交成功',
            ];
        }else{
            $info=[
                'code'=>201,
                'msg'=>'请联系管理员',
            ];
        }
        return json($info);
    }
    public function checkLicense(Request $request){
        $data=$request->get();
        if(array_key_exists('id',$data)){
            //更新
            $data['status']=3;//更新中
            $code=Db::name('dealer_business_license')
                ->update($data);

        }else{
            //插入
            $data['status']=0;//待认证
            $code=Db::name('dealer_business_license')
                ->insert($data);
        }
        if($code||$code==0){
            $info=[
                'code'=>200,
                'msg'=>'提交成功',
            ];
        }else{
            $info=[
                'code'=>201,
                'msg'=>'请联系管理员',
            ];
        }
        return json($info);
    }
    //上传营业执照与商标证书
    public function uploadLicense(Request $request){
        $Qiniu=new Qiniu();
        $file = request()->file('img');
        $res=$Qiniu->uploadImg($file);
        return json([
            'filePath'=>$res['imgPath'],
            'key'=>$res['key']
        ]);
    }

}