<?php
/**
 * Created by PhpStorm.
 * User: wenhan
 * Date: 2022/12/6
 * Time: 上午12:04
 */

namespace app\api\controller\store;

class Location
{
    public function __construct()
    {
        $this->_geo_conf = array(
            'pi'           => pi(),
            'EARTH_RADIUS' => 6378.137,
        );
    }

    /**
     * 求两个地理位置之间的距离
     *
     * @param $longitude_a a坐标经度
     * @param $latitude_a  a坐标纬度
     * @param $longitude_b b坐标经度
     * @param $latitude_b  b坐标纬度
     * @return bool|float|int
     */
    public function get_distance_by_geo($latitude_a, $longitude_a, $latitude_b, $longitude_b)
    {
        if (!$latitude_a || !$longitude_a || !$latitude_b || !$longitude_b){
            return false;
        }

        $latitude_a_radian = $this->_angle_to_radian($latitude_a);
        $latitude_b_radian = $this->_angle_to_radian($latitude_b);

        $longitude_a_radian = $this->_angle_to_radian($longitude_a);
        $longitude_b_radian =  $this->_angle_to_radian($longitude_b);

        $latitude_radian_diff = $latitude_a_radian - $latitude_b_radian;
        $longitude_radian_diff = $longitude_a_radian - $longitude_b_radian;

        $S = 2 * asin(sqrt(pow(sin($latitude_radian_diff / 2), 2) + cos($latitude_a_radian) * cos($latitude_b_radian) * pow(sin($longitude_radian_diff / 2), 2))) * $this->_geo_conf['EARTH_RADIUS'];

        return $S;

    }

    /**
     * 根据某个经纬度和距离范围，求范围内到经纬度最大最小值
     * @param $latitude
     * @param $longitude
     * @param $distance
     * @return array|bool
     */
    public function get_geo_by_distance($latitude, $longitude, $distance)
    {
        if (!$latitude || !$longitude) {
            return false;
        }

        $lat_a = $this->_angle_to_radian($latitude);

        $lng_D = asin(sin($distance / (2 * $this->_geo_conf['EARTH_RADIUS'])) / cos($lat_a)) * 2;
        $lat_D = asin(sin($distance / (2 * $this->_geo_conf['EARTH_RADIUS']))) * 2;

        $lat_D = $this->_radian_to_angle($lat_D);
        $lon_D = $this->_radian_to_angle($lng_D);
        $lat_res = array('lat_min' => ($latitude - $lat_D), 'lat_max' => ($latitude + $lat_D));
        $lon_res = array('lon_min' => ($longitude - $lon_D), 'lon_max' => ($longitude + $lon_D));

        return array($lat_res, $lon_res);
    }

    /**
     * 角度转弧度
     * @param $angle
     * @return float
     */
    private function _angle_to_radian($angle)
    {
        return $angle * $this->_geo_conf['pi'] / 180.0;
    }

    /**
     * 弧度转角度
     * @param $radian
     * @return float|int
     */
    private function _radian_to_angle($radian)
    {
        return abs($radian * 180 / $this->_geo_conf['pi']);
    }
}
