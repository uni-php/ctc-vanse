<?php
/**
 * Created by PhpStorm.
 * User: wenhan
 * Date: 2022/1/14
 * Time: 下午9:02
 */

namespace app\dealer\controller\app\trace;
use app\Request;
use think\Controller;
use think\Db;
use app\common\JsonService;
use think\db\Where;

class CodeBatch extends Controller
{
    protected $dealer_id;
    public function initialize(){
        $userInfo=Request::userInfo();
        $this->dealer_id=array_key_exists('dealer_id',$userInfo)?$userInfo['dealer_id']:$userInfo['id'];
    }
    public function getCodeBatchList(Request $request){
        $params=$request->get();
        if($params['startTime']){
            $condition['a.create_time']=['between time',[$params['startTime'],$params['endTime']]];
        }
        $condition['a.product_batch']=['like','%'.$params['product_batch'].'%'];
        $condition['a.code_batch']=['like','%'.$params['code_batch'].'%'];
        $condition['c.product_name']=['like','%'.$params['product_name'].'%'];
        $condition['a.status']=0;
        $condition['b.status']=0;
        $list=Db::name('dealer_trace_code_batch')
            ->alias('a')
            ->join('dealer_trace_product_batch b','a.product_batch=b.product_batch')
            ->join('dealer_product c','b.product_id=c.id')
            ->where(new Where($condition))
            ->where('a.dealer_id',$this->dealer_id)
            ->field('a.*,c.product_name')
            ->page($params['pageNum'])
            ->limit($params['pageSize'])
            ->order('a.create_time','desc')
            ->select();
        $total=Db::name('dealer_trace_code_batch')
            ->alias('a')
            ->join('dealer_trace_product_batch b','a.product_batch=b.product_batch')
            ->join('dealer_product c','b.product_id=c.id')
            ->where(new Where($condition))
            ->where('a.dealer_id',$this->dealer_id)
            ->count();
        $res=[
            'code'=>200,
            'msg'=>'查询成功',
            'data'=>$list,
            'total'=>$total
        ];
        return json($res);
    }
    public function saveCodebBatch(Request $request){
        $data=$request->post();
        $data['dealer_id']=$this->dealer_id;
        if($data['is_serial_number']){
            //检测赋码区间是否合理
            $interval=Db::name('dealer_trace_code_batch')
                ->alias('a')
                ->join('dealer_trace_product_batch b','a.product_batch=b.product_batch')
                ->where('a.code_batch',$data['code_batch'])
                ->where('a.is_serial_number',1)
                ->where('a.status',0)
                ->where('b.status',0)
                ->field('a.*')
                ->select();
            foreach($interval as $key=>$value){
                if(!$this->is_enable_interval($value['order_begin'],$value['order_end'],$data['order_begin'],$data['order_end'])){
                    return JsonService::fail('赋码区间存在重叠，请重新填写！');
                }
            }
        }else{
            //检测是否已赋值该码批次
            $has=Db::name('dealer_trace_code_batch')
                ->where('code_batch',$data['code_batch'])
                ->where('is_serial_number',0)
                ->where('status',0)
                ->find();
            if($has){
                return JsonService::fail('该码批次已被占用！');
            }
        }
        if(array_key_exists('id',$data)){
            $res=Db::name('dealer_trace_code_batch')->update($data);
        }else{
            $res=Db::name('dealer_trace_code_batch')->insert($data);
        }
        if($res||$res==0){
            return JsonService::successful('保存成功');
        }else{
            return JsonService::fail('请联系管理员');
        }
    }
    public function deleCodeBatch(Request $request){
        $id=$request->param('id');
        $res=Db::name('dealer_trace_code_batch')->where('id',$id)->update([
            'status'=>1
        ]);
        if($res){
            return JsonService::successful('删除成功');
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
}