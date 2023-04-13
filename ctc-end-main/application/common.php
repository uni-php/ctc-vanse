<?php
// +----------------------------------------------------------------------
// | ThinkPHP [ WE CAN DO IT JUST THINK ]
// +----------------------------------------------------------------------
// | Copyright (c) 2006-2016 http://thinkphp.cn All rights reserved.
// +----------------------------------------------------------------------
// | Licensed ( http://www.apache.org/licenses/LICENSE-2.0 )
// +----------------------------------------------------------------------
// | Author: 流年 <liu21st@gmail.com>
// +----------------------------------------------------------------------

// 应用公共文件
use think\Response;
use think\facade\Env;
use think\facade\Log;
use think\facade\Config;
use think\facade\Request;
/**
 * 多维数组合并
 * @param array $array1
 * @param array $array2
 * @return array
 */
function array_merge_multiple(array $array1, array $array2): array
{
    $merge = $array1 + $array2;
    $data = [];
    foreach ($merge as $key => $val) {
        if (
            isset($array1[$key])
            && is_array($array1[$key])
            && isset($array2[$key])
            && is_array($array2[$key])
        ) {
            $data[$key] = is_assoc($array1[$key]) ? array_merge_multiple($array1[$key], $array2[$key]) : $array2[$key];
        } else {
            $data[$key] = $array2[$key] ?? $array1[$key];
        }
    }
    return $data;
}
/**
 * 判断是否为自定义索引数组
 * @param array $array
 * @return bool
 */
function is_assoc(array $array): bool
{
    if (empty($array)) return false;
    return array_keys($array) !== range(0, count($array) - 1);
}

/**
 * 获取最近七天所有日期
 */
function get_weeks($time = '', $format='Y-m-d'){
    $time = $time != '' ? $time : time();
    //组合数据
    $date = [];
    for ($i=0; $i<7; $i++){
        $date[$i] = date($format ,strtotime( '+' . ($i-7) .' days', $time));
    }
    return $date;
}
function tree($array, $parent_id = 0){
    $tree = [];
    foreach ($array as $k => $v) {
        if ($v['parent_id'] == $parent_id) {
            $v['children'] = tree($array, $v['id']);
            $tree[] = $v;
            unset($array[$k]);
        }
    }
    return $tree;
}

/**
 * @param $min
 * @param $max
 * @return string
 * 区间随机数 保留两位小数
 */
function randomFloat($min, $max){
    $num = $min + mt_rand() / mt_getrandmax() * ($max - $min);
    return sprintf("%.2f", $num);
}

/**
 * @return string
 * 唯一订单
 */
function getOrderNum(){
    $trade_no=date('Ymd').substr(implode(NULL, array_map('ord', str_split(substr(uniqid(), 7, 13), 1))), 0, 8);
    return $trade_no;
}
/**
 * @param $platform
 * 平台判断 扫码类型
 * H5 APP MP-WEIXIN H5-WEIXIN
 */
function platform($platform){
    switch ($platform){
        case 'H5':
            $scan_type=3;
            break;
        case 'APP':
            $scan_type=3;
            break;
        case 'MP-WEIXIN':
            $scan_type=2;//微信小程序
            break;
        case 'H5-WEIXIN':
            $scan_type=1;//微信公众号
            break;
        default:
            $scan_type=1;
    }
    return $scan_type;
}

/**
 * @param string $url
 * @param string $postdata
 * @param array $options
 * @return mixed
 * 模拟post请求
 */
function curl_post($url='',$postdata='',$options=array()){
    $ch=curl_init($url);
    curl_setopt($ch,CURLOPT_RETURNTRANSFER,1);
    curl_setopt($ch,CURLOPT_POST,1);
    curl_setopt($ch, CURLOPT_POSTFIELDS, $postdata);
    curl_setopt($ch, CURLOPT_TIMEOUT, 5);
    curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, FALSE);
    curl_setopt($ch, CURLOPT_SSL_VERIFYHOST, FALSE);
    if(!empty($options)){
        curl_setopt_array($ch, $options);
    }
    $data=curl_exec($ch);
    curl_close($ch);
    return $data;
}


/**
 * 模拟GET请求 HTTPS的页面
 * @param string $url 请求地址
 * @param array $data
 * @return string $result
 *
 */
 function curl_get( $url, array $data = [])
{
    // 处理query参数
    if (!empty($data)) {
        $url = $url . '?' . http_build_query($data);
    }
    $curl = curl_init();
    curl_setopt($curl, CURLOPT_URL, $url);
    curl_setopt($curl, CURLOPT_HEADER, 0);
    curl_setopt($curl, CURLOPT_RETURNTRANSFER, 1);
    curl_setopt($curl, CURLOPT_SSL_VERIFYPEER, FALSE); // https请求 不验证证书和hosts
    $result = curl_exec($curl);
    curl_close($curl);
    return $result;
}
/**
 * @param array $a
 * @param array $b
 * return array
 * a=>[4,9]
 * b=>[[1,4],[6,24]...] 二维数组
 * 查找不重合的序列段
 */
function get_no_belong_section(array $a,array $b){
    $res=[];
    for($i=$a[0];$i<=$a[1];$i++){
        $flag=false;
        for($j=0;$j<count($b);$j++){
            if($b[$j][0]<=$i&&$i<=$b[$j][1]){
                $flag=true;
                break;
            }
        }
        if(!$flag) array_push($res,$i);
    }
    return $res;
}
/**
 * 写入日志 (使用tp自带驱动记录到runtime目录中)
 * @param $value
 * @param string $type
 */
function log_record($value, string $type = 'info')
{
    $content = is_string($value) ? $value : print_r($value, true);
    Log::record($content, $type);
}

function sum1($scale,$section,$index,$order,$parent=[]){
    if($index==0) return $parent;
    $start=floor(($order-$section[$index][0])/$scale[$index]);
    array_push($parent,$section[$index-1][0]+$start);
    $index--;
    if($index>0){
        sum1($scale,$section,$index,$parent[count($parent)-1],$parent);
    }

}