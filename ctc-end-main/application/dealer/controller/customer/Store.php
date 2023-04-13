<?php
/**
 * Created by PhpStorm.
 * User: wenhan
 * Date: 2022/1/2
 * Time: 下午9:20
 */

namespace app\dealer\controller\customer;
use app\Request;
use think\Controller;
use think\Db;
use app\common\JsonService;
use think\db\Where;

class Store extends Controller
{
    protected $dealer_id;
    public function initialize(){
        $userInfo=Request::userInfo();
        $this->dealer_id=array_key_exists('dealer_id',$userInfo)?$userInfo['dealer_id']:$userInfo['id'];
    }
    public function getStoreTypeList(Request $request){
        $params=$request->get();
        try{
            Db::execute("SET @@sql_mode='';");
        }catch (\Exception $e){

        }
        $list=Db::name('dealer_store_type')
            ->alias('a')
            ->leftJoin('dealer_store b','a.id=b.type')
            ->where('a.dealer_id',$this->dealer_id)
            ->where('a.status',0)
            ->field('a.id,a.class_name,a.create_time,count(b.store_name) as num')
            ->order('a.create_time','desc')
            ->page($params['pageNum'])
            ->limit($params['pageSize'])
            ->group('a.id')
            ->select();
        $total=Db::name('dealer_store_type')
            ->where('dealer_id',$this->dealer_id)
            ->where('status',0)
            ->count();
        $res=[
            'code'=>200,
            'msg'=>'查询成功',
            'total'=>$total,
            'data'=>$list,
        ];
        return json($res);
    }
    public function saveStoreType(Request $request){
        $data=$request->post();
        $data['dealer_id']=$this->dealer_id;
        if(array_key_exists('id',$data)){
            $res=Db::name('dealer_store_type')->update($data);
        }else{
            $res=Db::name('dealer_store_type')->insert($data);
        }
        if($res||$res==0){
            return JsonService::successful('保存成功');
        }else{
            return JsonService::fail('请联系管理员');
        }
    }
    public function queryStoreTypeInfo(Request $request){
        $id=$request->param('id');
        $res=Db::name('dealer_store_type')->where('id',$id)->find();
        return JsonService::successful('查询成功',$res);
    }
    public function deleStoreType(Request $request){
        $id=$request->param('id');
        $res=Db::name('dealer_store_type')
            ->where('id',$id)
            ->update([
                'status'=>1
            ]);
        if($res){
            return JsonService::successful('删除成功');
        }else{
            return JsonService::fail('请联系管理员');
        }
    }
    public function getStoreList(Request $request){
        $params=$request->get();
        $condition['store_code']=['like','%'.$params['store_code'].'%'];
        $condition['store_name']=['like','%'.$params['store_name'].'%'];
        $condition['zone']=['like','%'.$params['zone'].'%'];
        $condition['status']=['like','%'.$params['status'].'%'];
        if($params['activeName']=='first'){
            $list=Db::name('dealer_store')
                ->where(new Where($condition))
                ->where('dealer_id',$this->dealer_id)
                ->where('type',$params['type']?$params['type']:'not null')
                ->where('is_self',0)
                ->where('check_status',1)
                ->where('status','<>',3)
                ->page($params['pageNum'])
                ->limit($params['pageSize'])
                ->order('create_time','desc')
                ->select();
            $total=Db::name('dealer_store')
                ->where(new Where($condition))
                ->where('is_self',0)
                ->where('check_status',1)
                ->where('status','<>',3)
                ->where('dealer_id',$this->dealer_id)
                ->where('type',$params['type']?$params['type']:'not null')
                ->count();
        }else if($params['activeName']=='second'){
            $list=Db::name('dealer_store')
                ->where(new Where($condition))
                ->where('dealer_id',$this->dealer_id)
                ->where('type',$params['type']?$params['type']:'not null')
                ->where('attribute',$params['attribute']?$params['attribute']:'not null')
                ->where('distributor_id', isset($params['distributor_id'])?$params['distributor_id']:'not null')
                ->where('is_self',1)//非直营
                ->where('check_status',1)
                ->where('status','<>',3)
                ->page($params['pageNum'])
                ->limit($params['pageSize'])
                ->order('create_time','desc')
                ->select();
            $total=Db::name('dealer_store')
                ->where(new Where($condition))
                ->where('dealer_id',$this->dealer_id)
                ->where('type',$params['type']?$params['type']:'not null')
                ->where('attribute',$params['attribute']?$params['attribute']:'not null')
                ->where('distributor_id', isset($params['distributor_id'])?$params['distributor_id']:'not null')
                ->where('is_self',1)//非直营
                ->where('check_status',1)
                ->where('status','<>',3)
                ->count();
        }else{
            $list=Db::name('dealer_store')
                ->where(new Where($condition))
                ->where('dealer_id',$this->dealer_id)
                ->where('type',$params['type']?$params['type']:'not null')
                ->where('check_status','<>',1)
                ->where('status','<>',3)
                ->page($params['pageNum'])
                ->limit($params['pageSize'])
                ->order('create_time','desc')
                ->select();
            $total=Db::name('dealer_store')
                ->where(new Where($condition))
                ->where('dealer_id',$this->dealer_id)
                ->where('type',$params['type']?$params['type']:'not null')
                ->where('check_status','<>',1)
                ->where('status','<>',3)
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
    public function getAvailableStore(Request $request){
        $params=$request->get();
        $condition['store_code']=['like','%'.$params['store_code'].'%'];
        $condition['store_name']=['like','%'.$params['store_name'].'%'];
        $condition['mobile_phone|person']=['like','%'.$params['keywords'].'%'];
        $list=Db::name('dealer_store')
            ->where(new Where($condition))
            ->where('dealer_id',$this->dealer_id)
            ->where('type',$params['type']?$params['type']:'not null')
            ->where('check_status',1)
            ->where('status','<>',3)
            ->page($params['pageNum'])
            ->limit($params['pageSize'])
            ->order('create_time','desc')
            ->select();
        $total=Db::name('dealer_store')
            ->where(new Where($condition))
            ->where('dealer_id',$this->dealer_id)
            ->where('type',$params['type']?$params['type']:'not null')
            ->where('check_status',1)
            ->where('status','<>',3)
            ->count();
        $res=[
            'code'=>200,
            'msg'=>'查询成功',
            'data'=>$list,
            'total'=>$total
        ];
        return json($res);
    }
    public function getStoreById(Request $request){
        $params=$request->get();
        $list=Db::name('dealer_store')
            ->where('id','in',$params['ids'])
            ->page($params['pageNum'])
            ->limit($params['pageSize'])
            ->order('create_time','desc')
            ->select();
        $total=Db::name('dealer_store')
            ->where('id','in',$params['ids'])
            ->count();
        $res=[
            'code'=>200,
            'msg'=>'查询成功',
            'data'=>$list,
            'total'=>$total
        ];
        return json($res);
    }
    public function getStoreInfo(Request $request){
        $id=$request->param('id');
        $res=Db::name('dealer_store')
            ->where('id',$id)
            ->find();
        return JsonService::successful('查询成功',$res);
    }
    public function deleStore(Request $request){
        $id=$request->param('id');
        $res=Db::name('dealer_store')
            ->where('id',$id)
            ->update([
                'status'=>3//删除状态
            ]);
        if($res){
            return JsonService::successful('删除成功');
        }else{
            return JsonService::fail('请联系管理员');
        }
    }
    public function changeStoreStatus(Request $request){
        $params=$request->get();
        $res=Db::name('dealer_store')
            ->where('id',$params['id'])
            ->update([
                'status'=>$params['status']=='1'?'2':'1'
            ]);
        if($res){
            return JsonService::successful('设置成功');
        }else{
            return JsonService::fail('请联系管理员');
        }
    }
    public function saveStore(Request $request){
        $data=$request->post();
        $data['dealer_id']=$this->dealer_id;
        if(array_key_exists('id',$data)){
            $res=Db::name('dealer_store')->update($data);
        }else{
            $res=Db::name('dealer_store')->insert($data);
        }
        if($res||$res==0){
            return JsonService::successful('保存成功');
        }else{
            return JsonService::fail('请联系管理员');
        }
    }

    /**
     * @param Request $request
     * 门店店员
     */
    public function getStoreClerkList(Request $request){
        $params=$request->get();
        $condition['a.clerk_code']=['like','%'.$params['clerk_code'].'%'];
        $condition['a.clerk_name']=['like','%'.$params['clerk_name'].'%'];
        $condition['a.phone']=['like','%'.$params['phone'].'%'];
        $condition['a.remark']=['like','%'.$params['remark'].'%'];
        $condition['b.store_code']=['like','%'.$params['store_code'].'%'];
        $condition['b.store_name']=['like','%'.$params['store_name'].'%'];
        $list=Db::name('dealer_store_clerk')
            ->alias('a')
            ->join('dealer_store b','a.store_id=b.id')
            ->where(new Where($condition))
            ->where('b.dealer_id',$this->dealer_id)
            ->where('a.role_id',$params['role_id']?$params['role_id']:'not null')
            ->where('a.is_self',$params['is_self']?$params['is_self']:'not null')
            ->page($params['pageNum'])
            ->limit($params['pageSize'])
            ->field('a.*,b.store_name')
            ->order('a.create_time','desc')
            ->select();
        $total=Db::name('dealer_store_clerk')
            ->alias('a')
            ->join('dealer_store b','a.store_id=b.id')
            ->where(new Where($condition))
            ->where('b.dealer_id',$this->dealer_id)
            ->where('a.role_id',$params['role_id']?$params['role_id']:'not null')
            ->where('a.is_self',$params['is_self']?$params['is_self']:'not null')
            ->count();
        $res=[
            'code'=>200,
            'msg'=>'查询成功',
            'data'=>$list,
            'total'=>$total
        ];
        return json($res);
    }
    /**
     * 门店资金流动明细
     */
    public function getStoreFinanceBill(Request $request){
        $params=$request->get();
        if($params['startTime']){
            $condition['create_time']=['between time',[$params['startTime'],$params['endTime']]];
        }
        $condition['b.store_code|b.store_name']=['like','%'.$params['keywords'].'%'];
        $list=Db::name('dealer_store_bill')
            ->alias('a')
            ->join('dealer_store b','a.store_id=b.id')
            ->where(new Where($condition))
            ->where('a.bill_type',0)//资金明细
            ->where('b.dealer_id',$this->dealer_id)
            ->where('b.is_self',$params['is_self']>=0?$params['is_self']:'not null')
            ->where('b.type',$params['type']?$params['type']:'not null')
            ->where('a.category',$params['flow_type']?$params['flow_type']:'not null')
            ->page($params['pageNum'])
            ->limit($params['pageSize'])
            ->field('a.*,b.store_name,b.store_code,b.type,b.is_self')
            ->order('a.create_time','desc')
            ->select();
        $total=Db::name('dealer_store_bill')
            ->alias('a')
            ->join('dealer_store b','a.store_id=b.id')
            ->where(new Where($condition))
            ->where('a.bill_type',0)
            ->where('b.dealer_id',$this->dealer_id)
            ->where('b.type',$params['type']?$params['type']:'not null')
            ->where('a.category',$params['flow_type']?$params['flow_type']:'not null')
            ->where('b.is_self',$params['is_self']>=0?$params['is_self']:'not null')
            ->count();
        $res=[
            'code'=>200,
            'msg'=>'查询成功',
            'data'=>$list,
            'total'=>$total
        ];
        return json($res);
    }
    /**
     * 积分变动明细
     */
    public function getPointsLog(Request $request){
        $params=$request->get();
        if($params['startTime']){
            $condition['a.create_time']=['between time',[$params['startTime'],$params['endTime']]];
        }
        $condition['b.store_code|b.store_name|a.remark']=['like','%'.$params['keywords'].'%'];
        $list=Db::name('dealer_store_bill')
            ->alias('a')
            ->join('dealer_store b','a.store_id=b.id')
            ->where(new Where($condition))
            ->where('a.bill_type',1)//积分明细
            ->where('b.dealer_id',$this->dealer_id)
            ->where('b.is_self',$params['is_self']>=0?$params['is_self']:'not null')
            ->where('a.pm',is_numeric($params['pm'])?$params['pm']:'not null')
            ->where('b.type',$params['type']?$params['type']:'not null')
            ->page($params['pageNum'])
            ->limit($params['pageSize'])
            ->field('a.*,b.store_name,b.store_code,b.type,b.is_self')
            ->order('a.create_time','desc')
            ->select();
        $total=Db::name('dealer_store_bill')
            ->alias('a')
            ->join('dealer_store b','a.store_id=b.id')
            ->where(new Where($condition))
            ->where('a.bill_type',1)//积分明细
            ->where('b.dealer_id',$this->dealer_id)
            ->where('b.is_self',$params['is_self']>=0?$params['is_self']:'not null')
            ->where('a.pm',is_numeric($params['pm'])?$params['pm']:'not null')
            ->where('b.type',$params['type']?$params['type']:'not null')
            ->count();
            $res=[
                'code'=>200,
                'msg'=>'查询成功',
                'data'=>$list,
                'total'=>$total
            ];
            return json($res);
    }

    /**
     * @param Request $request
     * 门店提现记录
     * 提现明细表是否与资金明细表合并 待确认！！
     */
    public function getStoreCashBill(Request $request){
        $params=$request->get();
        if($params['startTime']){
            $condition['create_time']=['between time',[$params['startTime'],$params['endTime']]];
        }
        if($params['issueStartTime']){
            $condition['issue_time']=['between time',[$params['issueStartTime'],$params['issueEndTime']]];
        }
        $condition['b.store_code|b.store_name']=['like','%'.$params['keywords'].'%'];
        if($params['log_status']==1){
            $list=Db::name('dealer_store_cash_bill')
                ->alias('a')
                ->join('dealer_store b','a.store_id=b.id')
                ->where(new Where($condition))
                ->where('b.dealer_id',$this->dealer_id)
                ->where('a.type',$params['cash_type']?$params['cash_type']:'not null')
                ->where('a.status',4)
                ->page($params['pageNum'])
                ->limit($params['pageSize'])
                ->field('a.*,b.store_name,b.store_code')
                ->order('a.create_time','desc')
                ->select();
            $total=Db::name('dealer_store_cash_bill')
                ->alias('a')
                ->join('dealer_store b','a.store_id=b.id')
                ->where(new Where($condition))
                ->where('b.dealer_id',$this->dealer_id)
                ->where('a.type',$params['cash_type']?$params['cash_type']:'not null')
                ->where('a.status',4)
                ->count();
        }else{
            $list=Db::name('dealer_store_cash_bill')
                ->alias('a')
                ->join('dealer_store b','a.store_id=b.id')
                ->where(new Where($condition))
                ->where('b.dealer_id',$this->dealer_id)
                ->where('a.type',$params['cash_type']?$params['cash_type']:'not null')
                ->where('a.status',$params['status']?$params['status']:'not null')
                ->page($params['pageNum'])
                ->limit($params['pageSize'])
                ->field('a.*,b.store_name,b.store_code')
                ->order('a.create_time','desc')
                ->select();
            $total=Db::name('dealer_store_cash_bill')
                ->alias('a')
                ->join('dealer_store b','a.store_id=b.id')
                ->where(new Where($condition))
                ->where('b.dealer_id',$this->dealer_id)
                ->where('a.type',$params['cash_type']?$params['cash_type']:'not null')
                ->where('a.status',$params['status']?$params['status']:'not null')
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
    public function cashStore(Request $request){
        $data=$request->post();
        if($data['type']==1){
            Db::startTrans();
            try{
                Db::name('dealer_store_cash_bill')
                    ->where('id',$data['id'])
                    ->update([
                        'issue_time'=>date("Y-m-d H:i:s"),
                        'status'=>4
                    ]);
                Db::name('dealer_store')
                    ->where('id',$data['store_id'])
                    ->setDec('balance',$data['cash_money'] );
                $balance=Db::name('dealer_store')->where('id',$data['store_id'])->value('balance');
                Db::name('dealer_store_bill')
                    ->insert([
                        'store_id'=>$data['store_id'],
                        'pm'=>0,
                        'category'=>3,
                        'number'=>$data['cash_money'],
                        'balance'=>$balance,
                        'remark'=>'提现到账'
                    ]);
                $info=[
                    'code'=>200,
                    'msg'=>'提现成功',
                ];
                Db::commit();
            }catch (\Exception $e){
                Db::rollback();
                $info=[
                    'code'=>201,
                    'msg'=>'请联系管理员'
                ];
            }
            return json($info);
        }else{
            //商户扣除 todo...
        }
    }
    public function refuseCashReply(Request $request){
        $data=$request->post();
        Db::startTrans();
        try{
            Db::name('dealer_store_cash_bill')
                ->where('id',$data['id'])
                ->update([
                   'status'=>3
                ]);
            Db::name('dealer_store')
                ->where('id',$data['store_id'])
                ->setInc('balance',$data['cash_money'] );
            $balance=Db::name('dealer_store')->where('id',$data['store_id'])->value('balance');
            Db::name('dealer_store_bill')
                ->insert([
                    'store_id'=>$data['store_id'],
                    'pm'=>1,
                    'bill_type'=>0,
                    'category'=>5,
                    'number'=>$data['cash_money'],
                    'balance'=>$balance,
                    'remark'=>'提现驳回资金回退'
                ]);
            $info=[
                'code'=>200,
                'msg'=>'驳回成功',
            ];
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
    public function deleCashReply(Request $request){
        $id=$request->param('id');
        $res=Db::name('dealer_store_cash_bill')->delete($id);
        if($res){
            return JsonService::successful('删除成功');
        }else{
            return JsonService::fail('请联系管理员');
        }
    }
    public function getStoreCashSet(Request $request){
        $info=Db::name('dealer_store_cash_rule')
            ->where('dealer_id',$this->dealer_id)
            ->find();
        return JsonService::successful('查询成功',$info);
    }
    public function saveStoreCashSet(Request $request){
        $data=$request->post();
        $data['dealer_id']=$this->dealer_id;
        if(array_key_exists('id',$data)){
            $res=Db::name('dealer_store_cash_rule')->update($data);
        }else{
            $res=Db::name('dealer_store_cash_rule')->insert($data);
        }
        if($res||$res==0){
            return JsonService::successful('保存成功');
        }else{
            return JsonService::fail('请联系管理员');
        }
    }
    /**
     * 增减积分 写积分日志
     */
    public function saveStorePoints(Request $request){
       $data=$request->post();
       Db::startTrans();
       try{
            Db::name('dealer_store')
                ->where('id',$data['id'])
                ->setInc('points_num', $data['points_num']);
            //写积分日志
            $balance=Db::name('dealer_store')->where('id',$data['store_id'])->value('points_num');
            Db::name('dealer_store_bill')
                ->insert([
                    'store_id'=>$data['store_id'],
                    'pm'=>$data['points_num']>0?1:0,
                    'bill_type'=>1,
                    'category'=>'',
                    'number'=>$data['points_num'],
                    'balance'=>$balance,
                    'remark'=>'手动增减积分',
                    'create_by'=>$request->userInfo()['account']
                ]);
                $info=[
                    'code'=>200,
                    'msg'=>'设置成功',
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
}