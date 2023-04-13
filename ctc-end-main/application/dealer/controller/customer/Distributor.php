<?php
/**
 * Created by PhpStorm.
 * User: wenhan
 * Date: 2021/12/27
 * Time: 下午10:21
 */

namespace app\dealer\controller\customer;
use app\Request;
use think\Controller;
use think\Db;
use app\common\JsonService;
use think\db\Where;
use PhpOffice\PhpSpreadsheet\Spreadsheet;
use PhpOffice\PhpSpreadsheet\Writer\Xlsx;
use PhpOffice\PhpSpreadsheet\IOFactory;
use Overtrue\Pinyin\Pinyin;

class Distributor extends Controller
{
    protected $dealer_id;
    public function initialize(){
        $userInfo=Request::userInfo();
        $this->dealer_id=array_key_exists('dealer_id',$userInfo)?$userInfo['dealer_id']:$userInfo['id'];
    }
    /**
     * @param Request $request
     * @throws \think\db\exception\DataNotFoundException
     * @throws \think\db\exception\ModelNotFoundException
     * @throws \think\exception\DbException
     * 经销商级别管理
     */
    public function getDistributorLevelList(Request $request){
        try{
            Db::execute("SET @@sql_mode='';");
        }catch (\Exception $e){

        }
        $list=Db::name('dealer_distributor_level')
            ->alias('a')
            ->leftJoin('dealer_distributor b','a.id=b.distributor_level')
            ->where('a.dealer_id',$this->dealer_id)
            ->where('a.status',0)
            ->field('a.id,a.level_order,a.level_name,a.create_time,count(b.distributor_name) as num')
            ->order('a.create_time','desc')
            ->group('a.id')
            ->select();
        return JsonService::successful('查询成功',$list);
    }
    public function queryDistributorLevelInfo(Request $request){
        $id=$request->param('id');
        $res=Db::name('dealer_distributor_level')->where('id',$id)->find();
        return JsonService::successful('查询成功',$res);
    }
    public function deleDistributorLevel(Request $request){
        $id=$request->param('id');
        $res=Db::name('dealer_distributor_level')
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
    public function saveDistributorLevel(Request $request){
        $data=$request->post();
        $data['dealer_id']=$this->dealer_id;
        if(array_key_exists('id',$data)){
            $res=Db::name('dealer_distributor_level')->update($data);
        }else{
            $res=Db::name('dealer_distributor_level')->insert($data);
        }
        if($res||$res==0){
            return JsonService::successful('保存成功');
        }else{
            return JsonService::fail('请联系管理员');
        }
    }

    /**
     * @param Request $request
     * @throws \think\Exception
     * @throws \think\exception\PDOException
     * 保存经销商
     */
    public function saveDistributor(Request $request){
        $data=$request->post();
        $data['dealer_id']=$this->dealer_id;
        if(array_key_exists('id',$data)){
            $res=Db::name('dealer_distributor')->update($data);
        }else{
            $res=Db::name('dealer_distributor')->insert($data);
        }
        if($res||$res==0){
            return JsonService::successful('保存成功');
        }else{
            return JsonService::fail('请联系管理员');
        }
    }

    /**
     * @param Request $request
     * 批量导入经销商
     */
    public function importData(Request $request){
        set_time_limit(60); //限制页面执行时间60s
        $file=$_FILES['excel']['tmp_name'];
        try{
            if (empty($file) or !file_exists($file)) {
                throw new \Exception('文件不存在!');
            }
            $objReader = IOFactory::createReader('Xlsx');
            if (!$objReader->canRead($file)) {
                $objReader = IOFactory::createReader('Xls');
                if (!$objReader->canRead($file)) {
                    throw new \Exception('只支持导入Excel文件！');
                }
            }
            $objReader->setReadDataOnly(true); //忽略任何格式的信息
            $objPHPExcel = $objReader->load($file);
            $countSheet = $objPHPExcel -> getSheetCount();    //获取工作表数量
            $data = [];
            $pinyin = new Pinyin();
            for ($i = 0; $i < $countSheet; $i++){
                $currentSheet = $objPHPExcel -> getSheet($i);   //获取工作表内容
                $dataArray = $currentSheet -> toArray();       //转换为数组
                if(count($dataArray)<=1) return JsonService::fail('请检查表格内容');
                //表头
                $header = $dataArray[0];
                //内容
                for($j = 1; $j < count($dataArray); $j++){
                    for($t=1;$t<9;$t++){
                        if(!$dataArray[$j][$t]) return JsonService::fail('请检查表格必填字段');
                    }
                    //根据经销商名称生成编号
                    $info[$j]['distributor_name'] = $dataArray[$j][1];
                    $info[$j]['distributor_code'] = $this->dealer_id.'_'.$pinyin->abbr($dataArray[$j][1]);//dealer_id_首字母编号
                    $info[$j]['province'] = $dataArray[$j][2];
                    $info[$j]['city'] = $dataArray[$j][3];
                    $info[$j]['district'] = $dataArray[$j][4];
                    $info[$j]['address'] = $dataArray[$j][5];
                    $info[$j]['distributor_level'] = $dataArray[$j][6];
                    $info[$j]['phone'] = $dataArray[$j][7];
                    $info[$j]['person'] = $dataArray[$j][8];
                    $info[$j]['telephone'] = $dataArray[$j][9];
                    $info[$j]['wechat'] = $dataArray[$j][10];
                    $info[$j]['qq'] = $dataArray[$j][11];
                    $info[$j]['email'] = $dataArray[$j][12];
                    $info[$j]['monopoly'] = $dataArray[$j][13];
                    $info[$j]['superior_dis_id'] = 0;
                    $info[$j]['superior_dis_name'] = '总部';
                    $info[$j]['password'] = 123456;
                    $info[$j]['dealer_id'] = $this->dealer_id;
                }
                $res=Db::name('dealer_distributor')->data($info)->limit(100)->insertAll();
            }
            if($res||$res==0){
                return JsonService::successful('导入成功',$res);
            }else{
                return JsonService::fail('数据存在重复字段',$res);
            }
        }catch (\Exception $e){
            return JsonService::fail('请联系管理员');
        }
    }

    /**
     * 下载经销商导入模板
     */
    public function importDistributorTemplate(){
        $download =  new \think\response\Download(config('public_dir').'tpl/'.'distributor_tpl.xls');
        return $download->name('经销商批量导入模板.xls');
    }
    /**
     * @param Request $request
     * @return \think\response\Json
     * @throws \think\db\exception\DataNotFoundException
     * @throws \think\db\exception\ModelNotFoundException
     * @throws \think\exception\DbException
     * 查询经销商列表
     */
    public function getDistributorList(Request $request){
        $params=$request->get();
        $condition['distributor_code']=['like','%'.$params['distributor_code'].'%'];
        $condition['distributor_name']=['like','%'.$params['distributor_name'].'%'];
        if($params['startTime']){
            $condition['create_time']=['between time',[$params['startTime'],$params['endTime']]];
        }
        if($params['zone']){
            $condition['zone']=['like','%'.$params['zone'].'%'];
        }
        $condition['status']=0;
        $list=Db::name('dealer_distributor')
            ->where(new Where($condition))
            ->where('dealer_id',$this->dealer_id)
            ->where('distributor_level',$params['distributor_level']?$params['distributor_level']:'not null')
            ->where('superior_dis_id', isset($params['superior_dis_id'])?$params['superior_dis_id']:'not null')
            ->page($params['pageNum'])
            ->limit($params['pageSize'])
            ->order('create_time','desc')
            ->select();
        $total=Db::name('dealer_distributor')
            ->where(new Where($condition))
            ->where('distributor_level',$params['distributor_level']?$params['distributor_level']:'not null')
            ->where('superior_dis_id',isset($params['superior_dis_id'])?$params['superior_dis_id']:'not null')
            ->where('dealer_id',$this->dealer_id)
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
     * 所有经销商
     */
    public function getAllSuperiorDistributorList(){
        $list=Db::name('dealer_distributor')
            ->where('dealer_id',$this->dealer_id)
            ->where('status',0)
            ->order('create_time','desc')
            ->select();
        return JsonService::successful('查询成功',$list);
    }
    /**
     * @param Request $request
     * 查询上级经销商
     */
    public function getSuperiorDistributorList(Request $request){
        $params=$request->get();
        $condition['distributor_name']=['like','%'.$params['distributor_name'].'%'];
        $condition['status']=0;//没有删除
        $condition['is_disable']=0;//没有禁用
        if($params['level_id']){
            $condition['distributor_level']=['<=',$params['level_id']];
        }
        $list=Db::name('dealer_distributor')
            ->where(new Where($condition))
            ->where('dealer_id',$this->dealer_id)
            ->page($params['pageNum'])
            ->limit($params['pageSize'])
            ->order('create_time','desc')
            ->select();
        $total=Db::name('dealer_distributor')
            ->where(new Where($condition))
            ->where('dealer_id',$this->dealer_id)
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
     * @throws \think\Exception
     * @throws \think\exception\PDOException
     * 删除经销商
     */
    public function deleDistributor(Request $request){
        $id=$request->param('id');
        $res=Db::name('dealer_distributor')
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
    public function cutDistributor(Request $request){
        $params=$request->get();
        $res=Db::name('dealer_distributor')
            ->where('id',$params['id'])
            ->update([
                'is_disable'=>$params['status']*-1+1
            ]);
        if($res){
            return JsonService::successful('操作成功');
        }else{
            return JsonService::fail('请联系管理员');
        }
    }
    public function getDistributorInfo(Request $request){
        $id=$request->param('id');
        $res=Db::name('dealer_distributor')
            ->where('id',$id)
            ->find();
        return JsonService::successful('查询成功',$res);
    }
    public function queryRegisterConfig(){
        $res=Db::name('dealer_distributor_register_config')
            ->where('dealer_id',$this->dealer_id)
            ->find();
        return JsonService::successful('查询成功',$res);
    }
    public function saveRegisterConfig(Request $request){
        $data=$request->post();
        $data['dealer_id']=$this->dealer_id;
        if(array_key_exists('id',$data)){
            $res=Db::name('dealer_distributor_register_config')->update($data);
        }else{
            $res=Db::name('dealer_distributor_register_config')->insert($data);
        }
        if($res||$res==0){
            return JsonService::successful('保存成功');
        }else{
            return JsonService::fail('请联系管理员');
        }
    }
    public function getAvailableDistributor(Request $request){
        $params=$request->get();
        $condition['distributor_code']=['like','%'.$params['distributor_code'].'%'];
        $condition['distributor_name']=['like','%'.$params['distributor_name'].'%'];
        $condition['status']=0;
        $list=Db::name('dealer_distributor')
            ->where(new Where($condition))
            ->where('dealer_id',$this->dealer_id)
            ->where('distributor_level',$params['distributor_level']?$params['distributor_level']:'not null')
            ->page($params['pageNum'])
            ->limit($params['pageSize'])
            ->order('create_time','desc')
            ->select();
        $total=Db::name('dealer_distributor')
            ->where(new Where($condition))
            ->where('dealer_id',$this->dealer_id)
            ->where('distributor_level',$params['distributor_level']?$params['distributor_level']:'not null')
            ->count();
        $res=[
            'code'=>200,
            'msg'=>'查询成功',
            'data'=>$list,
            'total'=>$total
        ];
        return json($res);

    }
    public function getDistributorById(Request $request){
        $params=$request->get();
        $list=Db::name('dealer_distributor')
            ->where('id','in',$params['ids'])
            ->page($params['pageNum'])
            ->limit($params['pageSize'])
            ->order('create_time','desc')
            ->select();
        $total=Db::name('dealer_distributor')
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

    /**
     * @param Request $request
     * 可充值的经销商
     * 直属总部
     */
    public function getRechargeDistributorList(Request $request){
        $params=$request->get();
        $condition['distributor_code|distributor_name|phone|person']=['like','%'.$params['keywords'].'%'];
        $condition['status']=0;
        $condition['superior_dis_id']=0;
        $list=Db::name('dealer_distributor')
            ->where(new Where($condition))
            ->where('dealer_id',$this->dealer_id)
            ->where('distributor_level',$params['distributor_level']?$params['distributor_level']:'not null')
            ->where('is_disable', is_numeric($params['status'])?$params['status']:'not null')
            ->page($params['pageNum'])
            ->limit($params['pageSize'])
            ->order('create_time','desc')
            ->select();
        $total=Db::name('dealer_distributor')
            ->where(new Where($condition))
            ->where('dealer_id',$this->dealer_id)
            ->where('distributor_level',$params['distributor_level']?$params['distributor_level']:'not null')
            ->where('is_disable', is_numeric($params['status'])?$params['status']:'not null')
            ->count();
        $res=[
            'code'=>200,
            'msg'=>'查询成功',
            'data'=>$list,
            'total'=>$total
        ];
        return json($res);
    }
    public function changeDistributorBalance(Request $request){
        $data=$request->post();
        Db::startTrans();
        try{
            Db::name('dealer_distributor')
                ->where('id',$data['id'])
                ->setInc('balance', $data['money_num']);
            $balance=Db::name('dealer_distributor')->where('id',$data['id'])->value('balance');
            Db::name('dealer_distributor_bill')
                ->insert([
                    'distributor_id'=>$data['id'],
                    'pm'=>$data['money_num']>0?1:0,
                    'type'=>1,//人工增减
                    'number'=>$data['money_num'],
                    'balance'=>$balance,
                    'remark'=>'人工增减',
                    'create_by'=>$request->userInfo()['account']
                ]);
            $info=[
                'code'=>200,
                'msg'=>'设置成功',
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
    public function getDistributorBillLog(Request $request){
        $params=$request->get();
        if($params['startTime']){
            $condition['a.create_time']=['between time',[$params['startTime'],$params['endTime']]];
        }
        $condition['b.distributor_code|b.distributor_name|b.person|b.phone']=['like','%'.$params['keywords'].'%'];
        $list=Db::name('dealer_distributor_bill')
            ->alias('a')
            ->join('dealer_distributor b','a.distributor_id=b.id')
            ->where(new Where($condition))
            ->where('b.dealer_id',$this->dealer_id)
            ->where('a.type',$params['type']?$params['type']:'not null')
            ->where('b.distributor_level',$params['distributor_level']?$params['distributor_level']:'not null')
            ->where('b.id',$params['distributor_id']?$params['distributor_id']:'not null')
            ->page($params['pageNum'])
            ->limit($params['pageSize'])
            ->field('a.*,b.distributor_code,b.distributor_name,b.person,b.phone,b.distributor_level')
            ->order('a.create_time','desc')
            ->select();
        $total=Db::name('dealer_distributor_bill')
            ->alias('a')
            ->join('dealer_distributor b','a.distributor_id=b.id')
            ->where(new Where($condition))
            ->where('b.dealer_id',$this->dealer_id)
            ->where('b.id',$params['distributor_id']?$params['distributor_id']:'not null')
            ->where('a.type',$params['type']?$params['type']:'not null')
            ->where('b.distributor_level',$params['distributor_level']?$params['distributor_level']:'not null')
            ->count();
        //余额充值总数
        $recharge_sum=Db::name('dealer_distributor_bill')
            ->alias('a')
            ->join('dealer_distributor b','a.distributor_id=b.id')
            ->where('b.dealer_id',$this->dealer_id)
            ->where('a.pm',1)
            ->sum('number');
        $deduction_sum=Db::name('dealer_distributor_bill')
            ->alias('a')
            ->join('dealer_distributor b','a.distributor_id=b.id')
            ->where('b.dealer_id',$this->dealer_id)
            ->where('a.pm',0)
            ->sum('number');
        $res=[
            'code'=>200,
            'msg'=>'查询成功',
            'data'=>$list,
            'recharge_sum'=>$recharge_sum,
            'deduction_sum'=>$deduction_sum,
            'total'=>$total
        ];
        return json($res);
    }
    public function getDistributorBill(Request $request){
        $params=$request->get();

    }
}