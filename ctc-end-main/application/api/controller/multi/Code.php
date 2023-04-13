<?php
/**
 * Created by PhpStorm.
 * User: wenhan
 * Date: 2023/4/7
 * Time: 上午1:28
 */

namespace app\api\controller\multi;
use app\Request;
use think\Controller;
use app\lib\helper;
use think\Db;
use app\common\JsonService;

class Code extends Controller
{
    /**
     * @param Request $request
     * 根据序列号查询数码与批次号
     */
    public function queryCodeByOrder(Request $request){
        $params=$request->get();
        $order=intval($params['order']);
        $codeInfo=Db::name('code_manage')
            ->where('dealer_id',$params['dealer_id'])
            ->where('order_begin','<=',$order)
            ->where('order_end','>=',$order)
            ->find();
        $key=explode(',',$codeInfo['key']);
        $code=bcpowmod($order,$key[2],$key[0],0);
        $code=$this->appendString($code,$codeInfo['code_length']-strlen($code),'0');
        $data=[
          'qrcode'=>$code,
          'batch'=>$codeInfo['batch']
        ];
        return JsonService::returnData(200,'查询成功',$data);
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
}