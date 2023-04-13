<?php
/**
 * Created by PhpStorm.
 * User: wenhan
 * Date: 2022/12/1
 * Time: 下午12:50
 */

namespace app\api\controller\mall;
use app\Request;
use think\Db;
use app\common\JsonService;

use think\Controller;

class Page extends Controller
{
    /**
     * 商城页模板数据
     * @param Request $request
     */
    public function getPageData(Request $request){
        $dealer_id=$request->param('dealer_id');
        $page_data=Db::name('dealer_mall_template')->where('dealer_id',$dealer_id)->find();
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
            $list=Db::name('dealer_mall_goods')
                ->alias('a')
                ->join('dealer_product b','a.product_id=b.id')
                ->where('a.dealer_id',$dealer_id)
                ->where('a.is_del',0)
                ->where('a.is_cut',1)
                ->order('a.create_time','desc')
                ->limit(10)
                ->field('b.cover,b.product_name,a.sales,a.sale_price,a.id')
                ->select();
        }else{
            //自动推荐销售量前10个商品
            $list=Db::name('dealer_mall_goods')
                ->alias('a')
                ->join('dealer_product b','a.product_id=b.id')
                ->where('a.dealer_id',$dealer_id)
                ->where('a.is_del',0)
                ->where('a.is_cut',1)
                ->order('a.sales','desc')
                ->limit(10)
                ->field('b.cover,b.product_name,a.sales,a.sale_price,a.id')
                ->select();
        }
        foreach ($list as $key =>$value){
            $list[$key]['cover']=json_decode($value['cover']);
        }
        return JsonService::returnData(200,'查询成功',$list);
    }

}