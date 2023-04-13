<?php
/**
 * Created by PhpStorm.
 * User: wenhan
 * Date: 2021/11/22
 * Time: 下午10:40
 */

namespace app\dealer\controller\assets;
use app\Request;
use think\Controller;
use think\Db;
use app\common\JsonService;
use PhpOffice\PhpSpreadsheet\Spreadsheet;
use PhpOffice\PhpSpreadsheet\Writer\Xlsx;
use PhpOffice\PhpSpreadsheet\IOFactory;

class Product extends Controller
{
    protected $dealer_id;
    public function initialize(){
        $userInfo=Request::userInfo();
        $this->dealer_id=array_key_exists('dealer_id',$userInfo)?$userInfo['dealer_id']:$userInfo['id'];
    }
    public function getClassList(Request $request){
        $params=$request->get();
        $list=Db::name('dealer_product_class')
            ->where('dealer_id',$this->dealer_id)
            ->page($params['pageNum'])
            ->limit($params['pageSize'])
            ->select();
        $tree=$this->tree($list,0);
        $res=[
            'code'=>200,
            'msg'=>'查询成功',
            'data'=>$tree
        ];
        return json($res);
    }
    public function saveProductClass(Request $request){
        $data=$request->post();
        if(array_key_exists('id',$data)){
            $res=Db::name('dealer_product_class')->update($data);
        }else{
            $data['dealer_id']=$this->dealer_id;
            $res=Db::name('dealer_product_class')->insert($data);
        }
        if($res||$res==0){
            $info=[
                'code'=>200,
                'msg'=>'保存成功'
            ];
        }else{
            $info=[
                'code'=>201,
                'msg'=>'系统异常'
            ];
        }
        return json($info);
    }
    public function queryProductClass(Request $request){
        $res=Db::name('dealer_product_class')
            ->where('id',$request->param('id'))
            ->find();
        return json([
           'code'=>200,
           'data'=>$res
        ]);
    }
    public function deleProductClass(Request $request){
        $params=$request->get();
        if($params['parent_id']==0){
            //分类下存在产品 无法删除
            $has=Db::name('dealer_product')
                ->where('dealer_id',$this->dealer_id)
                ->where('class_one',$params['id'])
                ->count();
            if($has==0){
                $res=Db::name('dealer_product_class')->delete($params['id']);
            }else{
                $info=[
                    'code'=>201,
                    'msg'=>'该分类下存在产品'
                ];
                return json($info);
            }
        }else{
            $has=Db::name('dealer_product')
                ->where('dealer_id',$this->dealer_id)
                ->where('class_two',$params['id'])
                ->count();
            if($has==0){
                $res=Db::name('dealer_product_class')->delete($params['id']);
            }else{
                $info=[
                    'code'=>201,
                    'msg'=>'该分类下存在产品'
                ];
                return json($info);
            }
        }
        if($res){
            $info=[
                'code'=>200,
                'msg'=>'删除成功'
            ];
        }else{
            $info=[
                'code'=>201,
                'msg'=>'系统异常'
            ];
        }
        return json($info);
    }
    public function saveProduct(Request $request){
        $data=$request->post();
        if(array_key_exists('id',$data)){
            $res=Db::name('dealer_product')->update($data);
        }else{
            $data['dealer_id']=$this->dealer_id;
            $res=Db::name('dealer_product')->insert($data);
        }
        if($res||$res==0){
            $info=[
                'code'=>200,
                'msg'=>'保存成功'
            ];
        }else{
            $info=[
                'code'=>201,
                'msg'=>'系统异常'
            ];
        }
        return json($info);
    }
    public function deleProduct(Request $request){
        $id=$request->param('id');
        $des=Db::name('dealer_product')->where('id',$id)->find();
        if($des['is_del']==0){
            $res=Db::name('dealer_product')->where('id',$id)->update(['is_del'=>1]);
        }else{
            $res=Db::name('dealer_product')->delete($id);
        }
        if($res){
            $info=[
                'code'=>200,
                'msg'=>'删除成功'
            ];
        }else{
            $info=[
                'code'=>201,
                'msg'=>'系统异常'
            ];
        }
        return json($info);
    }
    public function reductionProduct(Request $request){
        $res=Db::name('dealer_product')
            ->where('id',$request->param('id'))
            ->update([
               'is_del'=>0
            ]);
        if($res){
            $info=[
                'code'=>200,
                'msg'=>'恢复成功'
            ];
        }else{
            $info=[
                'code'=>201,
                'msg'=>'系统异常'
            ];
        }
        return json($info);
    }
    public function queryProductInfo(Request $request){
        $res=Db::name('dealer_product')
            ->where('id',$request->param('id'))
            ->find();
        $info=[
            'code'=>200,
            'data'=>$res,
            'msg'=>'查询成功'
        ];
        return json($info);
    }
    public function getProductList(Request $request){
        $params=$request->get();
        $condition=[];
        if($params['class_one']){
            $condition['class_one']=['=',$params['class_one']];
        }
        if($params['class_two']){
            $condition['class_two']=['=',$params['class_two']];
        }
        $list=Db::name('dealer_product')
            ->where('code','like','%'.$params['code'].'%')
            ->where('product_name','like','%'.$params['product_name'].'%')
            ->where('dealer_id',$this->dealer_id)
            ->where('is_del',$params['is_del'])
            ->where($condition)
            ->order('create_time','desc')
            ->page($params['pageNum'])
            ->limit($params['pageSize'])
            ->select();
        $total=Db::name('dealer_product')
            ->where('code','like','%'.$params['code'].'%')
            ->where('dealer_id',$this->dealer_id)
            ->where('is_del',$params['is_del'])
            ->where('product_name','like','%'.$params['product_name'].'%')
            ->where($condition)
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
     * 批量导入产品
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
            for ($i = 0; $i < $countSheet; $i++){
                $currentSheet = $objPHPExcel -> getSheet($i);   //获取工作表内容
                $dataArray = $currentSheet -> toArray();       //转换为数组
//                return JsonService::fail('请检查表格内容',$dataArray);
                if(count($dataArray)<=1) return JsonService::fail('请检查表格内容');
                //表头
                $header = $dataArray[0];
                //内容
                for($j = 1; $j < count($dataArray); $j++){
                    for($t=0;$t<4;$t++){
                        if(!$dataArray[$j][$t]) return JsonService::fail('请检查表格必填字段');
                    }
                    $info[$j]['code'] = $dataArray[$j][0];
                    $info[$j]['product_name'] = $dataArray[$j][1];
                    $info[$j]['price'] = $dataArray[$j][2];
                    $info[$j]['stock'] = $dataArray[$j][3];
                    $info[$j]['class_one'] = $dataArray[$j][4];
                    $info[$j]['class_two'] = $dataArray[$j][5];
                    $info[$j]['barcode'] = $dataArray[$j][6];
                    $info[$j]['weight'] = $dataArray[$j][7];
                    $info[$j]['unit'] = $dataArray[$j][8];
                    $info[$j]['integral'] = $dataArray[$j][9];
                    $info[$j]['market_price'] = $dataArray[$j][10];
                    $info[$j]['order'] = $dataArray[$j][11];
                    $info[$j]['specifications'] = $dataArray[$j][12];
                    $info[$j]['dull_cycle'] = $dataArray[$j][13];
                    $info[$j]['approval_number'] = $dataArray[$j][14];
                    $info[$j]['manufacturer'] = $dataArray[$j][15];
                    $info[$j]['brand'] = $dataArray[$j][16];
                    $info[$j]['shelf_life'] = $dataArray[$j][17];
                    $info[$j]['dealer_id'] = $this->dealer_id;
                }
                $res=Db::name('dealer_product')->data($info)->limit(100)->insertAll();
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
     * @param Request $request
     * 下载产品模板
     */
    public function importTemplate(Request $request){
        $download =  new \think\response\Download(config('public_dir').'tpl/'.'product_tpl.xls');
        return $download->name('产品批量导入模板下载.xls');
    }
    public function tree($array, $parent_id = 0){
        $tree = [];
        foreach ($array as $k => $v) {
            if ($v['parent_id'] == $parent_id) {
                $v['children'] = $this->tree($array, $v['id']);
                $tree[] = $v;
                unset($array[$k]);
            }
        }
        return $tree;
    }
}