<?php
/**
 * Created by PhpStorm.
 * User: wenhan
 * Date: 2022/1/22
 * Time: 下午3:16
 */

namespace app\api\controller\trace;
use app\Request;
use app\api\model\trace\DealerTraceTemplate as PageModel;
use think\Controller;
use think\Db;
use app\common\JsonService;
class Page extends Controller
{
//    public function getPageData(Request $request){
//        $page=new PageModel;
//        return $page->detail('3');
//    }
    /**
     * @param Request $request
     * 获取溯源配置页模板信息
     * 参数 batch  code
     */
    public function getPageData(Request $request){
        $params=$request->get();
        $code=$params['code'];
        $batch=$params['batch'];
        $dealer_id=$params['dealer_id'];
        $tab_index=$params['tab_index'];
        $platform=$request->header('platform');
        $address=$request->address();
        $scan_type=platform($platform);
        if(empty($params['code'])) return JsonService::returnData(500,'溯源码不得为空');
        if(empty($params['batch'])) return JsonService::returnData(500,'批次号不得为空');
        if(empty($params['dealer_id'])) return JsonService::returnData(500,'请检查品牌商账号');
        if(!$this->isBatchAvailable($batch,$dealer_id)) return JsonService::returnData(500,'未找到该码批次');
        $number=$this->codeToNumber($code,$batch,$dealer_id);//流水号
        if(!$this->isBelongBatch($number,$batch,$dealer_id)) return JsonService::returnData(500,'溯源码信息异常');
        $available=$this->isCodeAvailable($number,$batch,$dealer_id);
        if($available['code']==201) return JsonService::returnData(500,$available['msg']);
        $queryInfo=$this->queryTraceInfo($number,$batch,$dealer_id);
        if(!$queryInfo) return JsonService::returnData(500,'溯源码未关联生产批次');
        $company_info=$this->getCompanyInfo($dealer_id);
        $querySecurityInfo=$tab_index==1?$this->querySecurityInfo($code,$batch,$dealer_id,$company_info,$queryInfo,$scan_type):['',''];//防伪验证信息
        $queryTraceLogInfo=$tab_index==0?$this->queryTraceLogInfo($code,$batch,$dealer_id,$queryInfo,$scan_type,$number,$address):['',''];//溯源查询信息
        //渲染页面结构
        $pageData['items']=[
            'banner'=>[
                'type' => 'banner',//轮播图
                'banner_type'=>$queryInfo['banner_type'],
                'data'=>json_decode($queryInfo['banner_img'],true),
                'is_banner'=>$queryInfo['is_banner'],
            ],
            'image' => [
                'type' => 'image',//单张活动图
                'banner_type'=>$queryInfo['banner_type'],
                'data'=>json_decode($queryInfo['activity_img'],true),
                'is_banner'=>$queryInfo['is_banner']
            ],
            'tabs'=>[
                'type'=>'tabs',
                'data'=>json_decode($queryInfo['tab'],true)
            ],
            'batch_content'=>[
                'type'=>'batch_content',
                'data'=>json_decode($queryInfo['batch_content'],true),//溯源批次信息
                'trace_info_title'=>$queryInfo['trace_info_title'],//溯源模块标题
                'trace_log_title'=>$queryInfo['trace_log_title'],
                'is_log_show'=>$queryInfo['is_log_show'],
                'trace_log_tips'=>$queryTraceLogInfo[0],
                'trace_log'=>$queryTraceLogInfo[1]
            ],
            'security_info'=>[
                'type'=>'security',
                'data'=>$querySecurityInfo[0],//返回防伪查询信息
                'is_first'=>$querySecurityInfo[1],
                'auth_title'=>$queryInfo['auth_title']
            ],
            //产品信息
            'product_info'=>[
                'type'=>'product_type',
                'data'=>[
                    'product_title'=>$queryInfo['product_title'],
                    'cover'=>json_decode($queryInfo['cover'],true),//轮播图
                    'code'=>$queryInfo['code'],//产品编号,
                    'product_name'=>$queryInfo['product_name'],
                    'weight'=>$queryInfo['weight'],
                    'price'=>$queryInfo['price'],
                    'details'=>$queryInfo['details']
                ],
                'is_show'=>[
                    'is_product_code'=>$queryInfo['is_product_code'],
                    'is_product_img'=>$queryInfo['is_product_img'],
                    'is_product_name'=>$queryInfo['is_product_name'],
                    'is_product_weight'=>$queryInfo['is_product_weight'],
                    'is_product_price'=>$queryInfo['is_product_price'],
                    'is_product_des'=>$queryInfo['is_product_des'],
                    'is_buy'=>$queryInfo['is_buy']
                ]
            ],
            //企业信息
            'company_info'=>[
                'type'=>'company_info',
                'data'=>[
                    'company_title'=>$queryInfo['company_title'],
                    'company_info'=>$company_info
                ],
                'is_show'=>[
                    'is_business_license_url'=>$queryInfo['is_business_license_url'],
                    'is_business_license_code'=>$queryInfo['is_business_license_code'],
                    'is_dealer_name'=>$queryInfo['is_dealer_name'],
                    'is_address'=>$queryInfo['is_address'],
                    'is_telephone'=>$queryInfo['is_telephone'],
                    'is_email'=>$queryInfo['is_email'],
                    'is_website'=>$queryInfo['is_website']
                ]
            ],
            //视频信息
            'video_info'=>[
                'type'=>'video_info',
                'data'=>[
                    'video'=>[
                      [
                          'url'=>$queryInfo['video_url']
                      ]
                    ],
                    'title'=>$queryInfo['video_title'],
                ],
                'is_video'=>$queryInfo['is_video']
            ]
        ];
        $pageData['page']=[
            'params' => [
                'title'=>$queryInfo['page_title'],
                'shareTitle' => $queryInfo['page_title']
            ],
        ];
        return JsonService::returnData(200,'success',$this->_mergeDefaultData($pageData));
    }

    /**
     * @param $code
     * @param $batch
     * @param $dealer_id
     * 溯源防伪信息展示
     */
    public function querySecurityInfo($code,$batch,$dealer_id,$company_info,$queryInfo,$scan_type){
        //判断是否进行过防伪查询
        $has=Db::name('dealer_security_query_log')
            ->where('code',$code)
            ->where('dealer_id',$dealer_id)
            ->where('code_batch',$batch)
            ->where('is_first',1)
            ->find();
        if($has){
            //重复查询
            if($queryInfo['auth_query_tips_check_status']==1){
                $result_text=$queryInfo['check_auth_again_query_tips'];
                $result_text=str_replace('@查询时间@',$has['create_time'],$result_text);
            }else{
                $result_text=$queryInfo['auth_again_query_tips'];
                $result_text=str_replace('@查询时间@',$has['create_time'],$result_text);
            }
        }else{
            //首次查询
            if($queryInfo['auth_query_tips_check_status']==1){
                $result_text=$queryInfo['check_auth_first_query_tips'];
                $result_text=str_replace('@品牌商名称@',$company_info['dealer_name'],$result_text);
            }else{
                $result_text=$queryInfo['auth_first_query_tips'];
                $result_text=str_replace('@品牌商名称@',$company_info['dealer_name'],$result_text);
            }
        }
        $info=[
          'dealer_id'=>$dealer_id,
          'code_batch'=>$batch,
          'code'=>$code,
          'is_first'=>$has?0:1,
          'member_id'=>1,
          'scan_type'=>$scan_type
        ];
        Db::name('dealer_security_query_log')->insert($info);
        return [$result_text,$has?0:1];
    }

    /**
     * @param $code
     * @param $batch
     * @param $dealer_id
     * @param $company_info
     * @param $queryInfo
     * @return array
     * 溯源查询结果
     */
    public function queryTraceLogInfo($code,$batch,$dealer_id,$queryInfo,$scan_type,$number,$address){
        //判断是否进行过溯源查询
        $has=Db::name('dealer_trace_query_log')
            ->where('dealer_id',$dealer_id)
            ->where('code_batch',$batch)
            ->where('code',$code)
            ->select();
        if(count($has)>0){
            //重复查询
            if($queryInfo['trace_query_tips_check_status']==1){
                $result_text=$queryInfo['check_trace_again_query_tips'];
                $result_text=str_replace('@次@',count($has)+1,$result_text);
            }else{
                $result_text=$queryInfo['trace_again_query_tips'];
                $result_text=str_replace('@次@',count($has)+1,$result_text);
            }
        }else{
            //首次查询
            if($queryInfo['trace_query_tips_check_status']==1){
                $result_text=$queryInfo['check_trace_first_query_tips'];
            }else{
                $result_text=$queryInfo['trace_first_query_tips'];
            }
        }
        $info=[
            'dealer_id'=>$dealer_id,
            'code_batch'=>$batch,
            'product_batch'=>$queryInfo['product_batch'],
            'code'=>$code,
            'is_first'=>count($has)>0?0:1,
            'member_id'=>1,
            'serial_number'=>$number,
            'address'=>$address[2].$address[3],
            'product_name'=>$queryInfo['product_name'],
            'scan_type'=>$scan_type
        ];
        Db::name('dealer_trace_query_log')->insert($info);
        //查询记录
        $log=Db::name('dealer_trace_query_log')
            ->alias('a')
            ->join('dealer_member b','a.member_id=b.id')
            ->where('a.code',$code)
            ->where('a.dealer_id',$dealer_id)
            ->where('a.code_batch',$batch)
            ->field('a.create_time,b.headimgurl,b.nickname')
//            ->limit(5)
            ->order('a.create_time','desc')
            ->select();
        return [$result_text,$log];
    }
    public function codeToNumber($code,$batch,$dealer_id){
        $key=Db::name('code_manage')
            ->where('dealer_id',$dealer_id)
            ->where('batch',$batch)
            ->value('key');//秘钥形式（n,d,e）
        $R_D=explode(',',$key)[1];
        $R_N=explode(',',$key)[0];
        $number=bcpowmod($code,$R_D,$R_N,0);//流水号
        return $number;
    }
    /**
     * @param $code
     * @param $batch
     * @param $dealer_id
     * 查询溯源信息
     */
    public function queryTraceInfo($number,$batch,$dealer_id){
        //查询赋码批次
        $code_batch=Db::name('dealer_trace_code_batch')
            ->alias('a')
            ->join('dealer_trace_product_batch b','a.product_batch=b.product_batch')
            ->where('a.dealer_id',$dealer_id)
            ->where('a.code_batch',$batch)
            ->where('a.status',0)
            ->where('b.status',0)
            ->where('a.is_serial_number',1)
            ->where('a.order_begin','<=',$number)
            ->where('a.order_end','>=',$number)
            ->field('a.*')
            ->find();
        if($code_batch){
            $pro_batch=Db::name('dealer_trace_product_batch')
                ->alias('a')
                ->join('dealer_trace_template b','a.template_id=b.id')
                ->join('dealer_product c','a.product_id=c.id')
                ->where('a.dealer_id',$dealer_id)
                ->where('a.product_batch',$code_batch['product_batch'])
                ->field('a.*,b.*,c.*')
                ->find();
            return $pro_batch;
        }else{
            $code_batch=Db::name('dealer_trace_code_batch')
                ->alias('a')
                ->join('dealer_trace_product_batch b','a.product_batch=b.product_batch')
                ->where('a.dealer_id',$dealer_id)
                ->where('a.code_batch',$batch)
                ->where('a.status',0)
                ->where('b.status',0)
                ->where('a.is_serial_number',0)
                ->field('a.*')
                ->find();
            if($code_batch){
                $pro_batch=Db::name('dealer_trace_product_batch')
                    ->alias('a')
                    ->join('dealer_trace_template b','a.template_id=b.id')
                    ->join('dealer_product c','a.product_id=c.id')
                    ->where('a.dealer_id',$dealer_id)
                    ->where('a.product_batch',$code_batch['product_batch'])
                    ->field('a.*,b.*,c.*')
                    ->find();
                return $pro_batch;
            }else{
                return $code_batch;
            }
        }
    }
    public function getQueryLog($dealer_id,$batch,$code){

    }
    public function isBelongBatch($number,$batch,$dealer_id){
        if(strlen($number)>10) return false;
        $is_belong=Db::name('code_manage')
            ->where('dealer_id',$dealer_id)
            ->where('batch',$batch)
            ->where('order_begin','<=',$number)
            ->where('order_end','>=',$number)
            ->find();
        if(!$is_belong) return false;
        return true;
    }
    public function isBatchAvailable($batch,$dealer_id){
        $batch=Db::name('code_manage')
            ->where('dealer_id',$dealer_id)
            ->where('batch',$batch)
            ->where('is_del',0)
            ->find();
        if(!$batch) return false;
        return true;
    }
    public function isCodeAvailable($number,$batch,$dealer_id){
        $batch_info=Db::name('code_manage')->where('batch',$batch)->where('dealer_id',$dealer_id)->find();
        if(!$batch_info) return ['code'=>201,'msg'=>'未找到该溯源码批次'];
        if($batch_info['status']==0) return ['code'=>201,'msg'=>'溯源码未启用'];
        if($batch_info['status']==1) return ['code'=>200,'msg'=>''];//全部启用
        if($batch_info['status']==2){//部分启用
            $has=Db::name('code_enable')
                ->where('dealer_id',$dealer_id)
                ->where('batch',$batch)
                ->where('start_code','<=',$number)
                ->where('end_code','>=',$number)
                ->find();
            if(!$has) return ['code'=>201,'msg'=>'溯源码未启用'];
            return ['code'=>200,'msg'=>''];
        }
    }
    /**
     * 页面标题栏默认数据
     * @return array
     */
    public function getDefaultPage()
    {
        return [
            'name' => '页面设置',
            'type' => 'page',
            'params' => [
                'name' => '页面名称',
                'title' => '溯源档案',
                'shareTitle' => '分享标题'
            ],
            'style' => [
                'titleTextColor' => 'white',
                'titleBackgroundColor' => '#409EFF',
            ]
        ];
    }
    /**
     * 页面diy元素默认数据
     * @return array
     */
    public function getDefaultItems(){
        return [
            'banner' => [
                'name' => '图片轮播',
                'type' => 'banner',//轮播图
                'banner_type'=>'2',
                'style' => [
                    'btnColor' => '#ffffff',
                    'btnShape' => 'round',
                    'interval' => 2.5
                ],
                'data' => [
                    [
                        'imgUrl' => config('public_dir'). 'app/trace/banner/01.png',
                        'link' => null
                    ],
                ]
            ],
            'image' => [
                'name' => '活动图',
                'type' => 'image',//单张活动图
                'banner_type'=>'1',
                'style' => [
                    'paddingTop' => 0,
                    'paddingLeft' => 0,
                    'background' => '#ffffff'
                ],
                'data' => [
                    [
                        'imgUrl' => config('public_dir'). 'app/trace/banner/01.png',
                        'imgName' => 'image-1.jpg',
                        'link' => null
                    ]
                ]
            ],
            'tabs'=>[
                'type'=>'tabs',
                'data'=>[
                    [
                        'title'=>'溯源',
                        'is_show'=>1
                    ],
                    [
                        'title'=>'认证',
                        'is_show'=>1
                    ],
                    [
                        'title'=>'产品',
                        'is_show'=>1
                    ],
                    [
                        'title'=>'企业',
                        'is_show'=>1
                    ]
                ]
            ],
            //批次信息
            'batch_content'=>[
                'type'=>'batch_content',
                'data'=>[],
                'trace_info_title'=>'',//溯源模块标题
                'trace_log_title'=>'',
                'is_log_show'=>''
            ],
            //防伪信息
            'security_info'=>[
              'type'=>'security',
              'data'=>[],
              'auth_title'=>''
            ],
            //产品信息
            'product_info'=>[
                'type'=>'product_type',
                'data'=>[
                    'product_title'=>'',//产品模块标题
                    'cover'=>[],//轮播图
                    'code'=>'',//产品编号,
                    'product_name'=>'',
                    'weight'=>'',
                    'price'=>'',
                    'details'=>''
                ],
                'is_show'=>[
                    'is_product_code'=>'',
                    'is_product_img'=>'',
                    'is_product_name'=>'',
                    'is_product_weight'=>'',
                    'is_product_price'=>'',
                    'is_product_des'=>'',
                    'is_buy'=>''
                ]
            ],
            'company_info'=>[
                'type'=>'company_info',
                'data'=>[
                    'company_title'=>'',
                    'company_info'=>[]
                ],
                'is_show'=>[
                    'is_business_license_url'=>'',
                    'is_business_license_code'=>'',
                    'is_dealer_name'=>'',
                    'is_address'=>'',
                    'is_telephone'=>'',
                    'is_email'=>'',
                    'is_website'=>''
                ]
            ],
            //视频信息
            'video_info'=>[
                'type'=>'video_info',
                'data'=>[],
                'is_video'=>''
            ]
        ];
    }

    /**
     * @param Request $request
     * 企业信息
     */
    public function getCompanyInfo($dealer_id){
        $info=Db::name('dealer')
            ->alias('a')
            ->leftJoin('dealer_business_license b','a.id=b.dealer_id')
            ->where('a.id',$dealer_id)
            ->field('a.*,b.business_license_code,b.business_license_url')
            ->find();
        return $info;
    }
    /**
     * 合并默认数据
     * @param $array
     * @return mixed
     */
    private function _mergeDefaultData($array)
    {
        $array['page'] = array_merge_multiple($this->getDefaultPage(), $array['page']);
        $defaultItems = $this->getDefaultItems();
        foreach ($array['items'] as &$item) {
            if (isset($defaultItems[$item['type']])) {
                array_key_exists('data', $item) && $defaultItems[$item['type']]['data'] = [];
                $item = array_merge_multiple($defaultItems[$item['type']], $item);
            }
        }
        return $array;
    }

}