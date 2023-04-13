<?php
/**
 * Created by PhpStorm.
 * User: wenhan
 * Date: 2022/1/22
 * Time: 下午3:18
 */

namespace app\api\model\trace;
use app\common\JsonService;
use think\Model;

class DealerTraceTemplate extends Model
{
    protected $pk = 'id';
    public function detail($tpl_id=null){
        if(empty($tpl_id)) return JsonService::fail('很抱歉，未找到该页面');
        return DealerTraceTemplate::get($tpl_id);
    }
}