<?php
/**
 * Created by PhpStorm.
 * User: wenhan
 * Date: 2022/12/5
 * Time: 下午1:53
 */

namespace app\api\controller\store;
use app\Request;
use think\Controller;
use think\Db;
use app\api\controller\store\Location;
use app\common\JsonService;

class Vicinity extends Controller
{
    public function getVicinityStoreList(Request $request){
        $params=$request->get();
        $location=new Location();
        $list=Db::name('dealer_store')
            ->where('dealer_id',$params['dealer_id'])
            ->where('store_name','like','%'.$params['keyword'].'%')
            ->where('status',1)
            ->where('check_status',1)
            ->select();
        foreach ($list as $key=>$value){
            $list[$key]['distance']=round($location->get_distance_by_geo($params['latitude'],$params['longitude'],explode(',',$value['gps'])[1],explode(',',$value['gps'])[0]));
        }
        return JsonService::returnData(200,'查询成功',$this->array_sort($list,'distance',SORT_ASC));
    }
    public function array_sort($data, $field, $sort){
        $fields = array_column($data, $field);
        array_multisort($fields, $sort, $data);
        return $data;
    }
}