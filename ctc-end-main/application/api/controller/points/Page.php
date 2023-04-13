<?php
/**
 * Created by PhpStorm.
 * User: wenhan
 * Date: 2022/7/9
 * Time: 下午3:47
 */

namespace app\api\controller\points;
use app\Request;
use think\Controller;
use think\Db;
use app\common\JsonService;

class Page extends Controller
{
    /**
     * 积分页模板数据
     * @param Request $request
     */
    public function getPageData(Request $request){
        $dealer_id=$request->param('dealer_id');
        $page_data=Db::name('dealer_points_template')->where('dealer_id',$dealer_id)->find();
        $page_data['page_content']=json_decode($page_data['page_content'],true);
        return JsonService::returnData(200,'查询成功',$page_data);
    }

    /**
     * @param Request $request
     * 首页热门推荐
     */
    public function getHotRecommend(Request $request){
        $dealer_id=$request->param('dealer_id');
        $rule=$request->param('recom_rule');
        if($rule==1){
            //自动推荐新上架前10个商品
            $list=Db::name('dealer_points_gifts')
                ->alias('a')
                ->join('dealer_gift b','a.gift_id=b.id')
                ->where('a.dealer_id',$dealer_id)
                ->where('a.status',1)
                ->order('a.create_time','desc')
                ->limit(10)
                ->field('b.cover,b.gift_name,a.exchanged_num,a.type,a.points_num,a.money,a.id')
                ->select();
        }else{
            //自动推荐销售量前10个商品
            $list=Db::name('dealer_points_gifts')
                ->alias('a')
                ->join('dealer_gift b','a.gift_id=b.id')
                ->where('a.dealer_id',$dealer_id)
                ->where('a.status',1)
                ->order('a.exchanged_num','desc')
                ->limit(10)
                ->field('b.cover,b.gift_name,a.exchanged_num,a.id,a.type,a.points_num,a.money')
                ->select();
        }
        foreach ($list as $key =>$value){
            $list[$key]['cover']=json_decode($value['cover']);
        }
        return JsonService::returnData(200,'查询成功',$list);
    }
}