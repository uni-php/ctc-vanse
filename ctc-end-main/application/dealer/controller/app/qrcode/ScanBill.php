<?php
/**
 * Created by PhpStorm.
 * User: wenhan
 * Date: 2022/4/27
 * Time: 下午10:30
 */

namespace app\dealer\controller\app\qrcode;
use app\Request;
use think\Controller;
use think\Db;
use app\common\JsonService;
use PhpOffice\PhpSpreadsheet\Spreadsheet;
use PhpOffice\PhpSpreadsheet\Writer\Xlsx;
use PhpOffice\PhpSpreadsheet\IOFactory;
use think\db\Where;

class ScanBill extends Controller
{
    protected $dealer_id;
    public function initialize(){
        $userInfo=Request::userInfo();
        $this->dealer_id=array_key_exists('dealer_id',$userInfo)?$userInfo['dealer_id']:$userInfo['id'];
    }
    /**
     * @param Request $request
     * 扫码明细
     */
    public function getScanBill(Request $request){
        $params=$request->get();
        try {
            Db::execute("SET @@sql_mode='';");
        } catch (\Exception $e) {
        }
        if($params['startTime']){
            $condition['a.create_time']=['between time',[$params['startTime'],$params['endTime']]];
        }
        if($params['phone']){
            $condition['b.phone']=['like','%'.$params['phone'].'%'];
        }
        $condition['a.batch']=['like','%'.$params['code_batch'].'%'];
        $condition['a.ip']=['like','%'.$params['ip'].'%'];
        $condition['a.code']=['like','%'.$params['code'].'%'];
        $condition['b.nickname']=['like','%'.$params['nickname'].'%'];
        $condition['a.openid']=['like','%'.$params['openid'].'%'];
        $list=Db::name('dealer_qrcode_marketing_query_bill')
            ->alias('a')
            ->leftJoin('dealer_member b','a.openid=b.openid and a.dealer_id=b.dealer_id')
            ->leftJoin('dealer_qrcode_marketing_redpack_register c','a.openid=c.openid and a.dealer_id=c.dealer_id')
            ->where(new Where($condition))
            ->where('a.dealer_id',$this->dealer_id)
            ->where('a.is_first',$params['res_status']?:'not null')
            ->page($params['pageNum'])
            ->limit($params['pageSize'])
            ->group('a.id')
            ->field('a.*,b.id as uid,b.nickname,b.headimgurl,c.operation_center')
            ->order('a.create_time','desc')
            ->select();
        $total=Db::name('dealer_qrcode_marketing_query_bill')
            ->alias('a')
            ->leftJoin('dealer_member b','a.openid=b.openid and a.dealer_id=b.dealer_id')
            ->where(new Where($condition))
            ->where('a.dealer_id',$this->dealer_id)
            ->where('a.is_first',$params['res_status']?:'not null')
            ->group('a.id')
            ->count();
        $res=[
            'code'=>200,
            'msg'=>'查询成功',
            'data'=>$list,
            'total'=>$total
        ];
        return json($res);
    }
    public function exportBill(Request $request){
        $params=$request->post();
        $fileName='扫码明细表';
        $fileType='Xlsx';
        $type = ['Excel2007', 'Xlsx', 'Excel5', 'xls'];
        if(!in_array($fileType, $type)) {
            trigger_error('未知文件类型', E_USER_ERROR);
        }
        if($fileType == 'Excel2007' || $fileType == 'Xlsx') {
            header('Content-Type: application/vnd.openxmlformats-officedocument.spreadsheetml.sheet');
            header('Content-Disposition: attachment;filename="'.$fileName.'.xlsx"');
            header('Cache-Control: max-age=0');
        } else { //Excel5
            header('Content-Type: application/vnd.ms-excel');
            header('Content-Disposition: attachment;filename="'.$fileName.'.xls"');
            header('Cache-Control: max-age=0');
        }
        $list=Db::name('dealer_qrcode_marketing_query_bill')
            ->alias('a')
            ->leftJoin('dealer_member b','a.openid=b.openid and a.dealer_id=b.dealer_id')
            ->leftJoin('dealer_qrcode_marketing_redpack_register c','a.openid=c.openid and a.dealer_id=c.dealer_id')
            ->where('a.id','in',$params['ids'])
            ->field('a.*,b.id as uid,b.nickname,b.headimgurl,c.operation_center')
            ->select();
        $data=[];
        foreach ($list as $key=>$value){
            $data[$key]['ip']=$value['ip'];
            $data[$key]['operation_center']=$value['operation_center'];
            $data[$key]['nickname']=$value['nickname'];
            $data[$key]['code']=$value['code'];
            $data[$key]['batch']=$value['batch'];
            $data[$key]['is_first']=$value['is_first']==1?'首次':'重复';
            $data[$key]['product_name']=$value['product_name'];
            $data[$key]['create_time']=$value['create_time'];
            $data[$key]['address']=$value['province'].$value['city'];
        }
        $title = ['IP地址','运营中心', '昵称','二维码编号','数码批次','扫码结果','产品名称','扫码时间','扫码地区'];
        $spreadsheet = new Spreadsheet();
        $worksheet = $spreadsheet->getActiveSheet();
        $worksheet->setTitle('扫码明细表');
        //表头
//设置单元格内容
        foreach ($title as $key => $value) {
            $worksheet->setCellValueByColumnAndRow($key+1, 1, $value);
        }
        $row = 2; //从第二行开始
        foreach ($data as $item) {
            $column = 1;
            foreach (array_values($item) as $value) {
                $worksheet->setCellValueByColumnAndRow($column, $row, $value);
                $column++;
            }
            $row++;
        }
        $writer = IOFactory::createWriter($spreadsheet, 'Xlsx'); //按照指定格式生成Excel文件
        $writer->save('php://output');
    }
    public function getPrizeLog(Request $request){
        $params=$request->get();
        if($params['startTime']){
            $condition['a.create_time']=['between time',[$params['startTime'],$params['endTime']]];
        }
        $condition['a.batch']=['like','%'.$params['code_batch'].'%'];
        $condition['a.code']=['like','%'.$params['code'].'%'];
        $condition['b.nickname']=['like','%'.$params['nickname'].'%'];
        $condition['a.openid']=['like','%'.$params['openid'].'%'];
        $list=Db::name('dealer_qrcode_marketing_prize_bill')
            ->alias('a')
            ->leftJoin('dealer_member b','a.openid=b.openid and a.dealer_id=b.dealer_id')
            ->leftJoin('dealer_qrcode_marketing_activity c','a.activity_id=c.id')
            ->leftJoin('dealer_qrcode_marketing_redpack_register d','a.openid=d.openid and a.dealer_id=d.dealer_id')
            ->where(new Where($condition))
            ->where('a.dealer_id',$this->dealer_id)
            ->page($params['pageNum'])
            ->limit($params['pageSize'])
            ->field('a.*,b.id as uid,b.nickname,b.headimgurl,c.activity_name,d.name,d.operation_center')
            ->order('a.create_time','desc')
            ->select();
        foreach ($list as $key =>$value){
            $list[$key]['user_info_field']=json_decode($value['user_info_field'],true);
        }
        $total=Db::name('dealer_qrcode_marketing_prize_bill')
            ->alias('a')
            ->leftJoin('dealer_member b','a.openid=b.openid and a.dealer_id=b.dealer_id')
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
    public function exportAward(Request $request){
        $params=$request->post();
        $fileName='领奖记录表';
        $fileType='Xlsx';
        $type = ['Excel2007', 'Xlsx', 'Excel5', 'xls'];
        if(!in_array($fileType, $type)) {
            trigger_error('未知文件类型', E_USER_ERROR);
        }
        if($fileType == 'Excel2007' || $fileType == 'Xlsx') {
            header('Content-Type: application/vnd.openxmlformats-officedocument.spreadsheetml.sheet');
            header('Content-Disposition: attachment;filename="'.$fileName.'.xlsx"');
            header('Cache-Control: max-age=0');
        } else { //Excel5
            header('Content-Type: application/vnd.ms-excel');
            header('Content-Disposition: attachment;filename="'.$fileName.'.xls"');
            header('Cache-Control: max-age=0');
        }
        $data=Db::name('dealer_qrcode_marketing_prize_bill')
            ->alias('a')
            ->leftJoin('dealer_member b','a.openid=b.openid and a.dealer_id=b.dealer_id')
            ->leftJoin('dealer_qrcode_marketing_activity c','a.activity_id=c.id')
            ->leftJoin('dealer_qrcode_marketing_redpack_register d','a.openid=d.openid and a.dealer_id=d.dealer_id')
            ->where('a.id','in',$params['ids'])
            ->field('d.name,d.operation_center,a.code,a.serial_number,a.batch,c.activity_name,a.prize_name,a.prize_content,a.create_time,c.remark,a.province,a.city,a.district')
            ->order('a.create_time','desc')
            ->select();
        $title = ['施工师傅姓名','运营中心','二维码编号','序列号','数码批次','活动主题','奖项名称','奖项内容','领奖时间','活动备注','省','市','区'];
        $spreadsheet = new Spreadsheet();
        $worksheet = $spreadsheet->getActiveSheet();
        $worksheet->setTitle('领奖记录表');
        //表头
//设置单元格内容
        foreach ($title as $key => $value) {
            $worksheet->setCellValueByColumnAndRow($key+1, 1, $value);
        }
        $row = 2; //从第二行开始
        foreach ($data as $item) {
            $column = 1;
            foreach (array_values($item) as $value) {
                $worksheet->setCellValueByColumnAndRow($column, $row, $value);
                $column++;
            }
            $row++;
        }
        $writer = IOFactory::createWriter($spreadsheet, 'Xlsx'); //按照指定格式生成Excel文件
        $writer->save('php://output');
    }
}