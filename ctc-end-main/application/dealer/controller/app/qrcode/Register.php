<?php
/**
 * Created by PhpStorm.
 * User: wenhan
 * Date: 2022/5/16
 * Time: 上午2:10
 */

namespace app\dealer\controller\app\qrcode;
use app\Request;
use think\Controller;
use think\Db;
use app\common\JsonService;
use think\db\Where;
use PhpOffice\PhpSpreadsheet\IOFactory;

class Register extends Controller
{
    protected $dealer_id;
    public function initialize(){
        $userInfo=Request::userInfo();
        $this->dealer_id=array_key_exists('dealer_id',$userInfo)?$userInfo['dealer_id']:$userInfo['id'];
    }
    public function getRegisterList(Request $request){
        $params=$request->get();
        if($params['address']){
            $condition['address']=['like','%'.$params['address'].'%'];
        }
        $condition['name']=['like','%'.$params['name'].'%'];
        $condition['phone']=['like','%'.$params['phone'].'%'];
        $list=Db::name('dealer_qrcode_marketing_redpack_register')
            ->where(new Where($condition))
            ->where('dealer_id',$this->dealer_id)
            ->order('create_time','desc')
            ->page($params['pageNum'])
            ->limit($params['pageSize'])
            ->select();
        $total=Db::name('dealer_qrcode_marketing_redpack_register')
            ->where(new Where($condition))
            ->where('dealer_id',$this->dealer_id)
            ->count();
        $res=[
            'code'=>200,
            'msg'=>'查询成功',
            'total'=>$total,
            'data'=>$list,
        ];
        return json($res);
    }
    public function deleRegisterInfo(Request $request){
        $res=Db::name('dealer_qrcode_marketing_redpack_register')
            ->delete($request->param('id'));
        if($res){
            return JsonService::successful('删除成功');
        }else{
            return JsonService::fail('请联系管理员');
        }
    }
    public function changeRegisterStatus(Request $request){
        $params=$request->get();
        $res=Db::name('dealer_qrcode_marketing_redpack_register')
            ->where('id',$params['id'])
            ->update([
               'status'=>$params['status']
            ]);
        if($res){
            return JsonService::successful('操作成功');
        }else{
            return JsonService::fail('请联系管理员');
        }
    }
    public function importRegister(Request $request){
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
            for ($i = 0; $i < $countSheet; $i++){
                $currentSheet = $objPHPExcel -> getSheet($i);   //获取工作表内容
                $dataArray = $currentSheet -> toArray();       //转换为数组
                if(count($dataArray)<=1) return JsonService::fail('请检查表格内容');
                //表头
                $header = $dataArray[0];
                //内容
                for($j = 1; $j < count($dataArray); $j++){
                    for($t=0;$t<4;$t++){
                        if(!$dataArray[$j][$t]) return JsonService::fail('请检查表格必填字段');
                    }
                    $info[$j]['openid'] = $dataArray[$j][0];
                    $info[$j]['status'] = 1;
                    $info[$j]['name'] = $dataArray[$j][1];
                    $info[$j]['phone'] = $dataArray[$j][3];
                    $info[$j]['dealer_id'] = $dataArray[$j][2];
                }
                $res=Db::name('dealer_qrcode_marketing_redpack_register')->data($info)->limit(100)->insertAll();
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
}