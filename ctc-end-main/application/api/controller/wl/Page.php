<?php
/**
 * Created by PhpStorm.
 * User: wenhan
 * Date: 2022/1/22
 * Time: 下午3:16
 */

namespace app\api\controller\wl;
use app\Request;
use think\Controller;
use think\Db;
use app\common\JsonService;
class Page extends Controller
{

    protected $parent=[];//父级包装
    protected $child=[];//子包装码
    protected $new_child=[];//子包装码
    protected $new_parent=[];//父级包装
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
        if(empty($params['code'])) return JsonService::returnData(500,'物流码不得为空');
        if(empty($params['batch'])) return JsonService::returnData(500,'批次号不得为空');
        if(empty($params['dealer_id'])) return JsonService::returnData(500,'请检查品牌商账号');
        if(!$this->isBatchAvailable($batch,$dealer_id)) return JsonService::returnData(500,'未找到该码批次');
        //判断物流码是否可用 并返回物流信息
        $available=$this->isCodeAvailable($code,$batch,$dealer_id);
        if($available['code']==201) return JsonService::returnData(500,$available['msg']);
        $this->child=[];
        $wl_info=$this->isCodeAvailable($code,$batch,$dealer_id,true);//获取物流信息 查询是否窜货
        /** 窜货开始 */
        //串货预警 判断扫码与经销商售货区域是否一致
        if($wl_info['log'][4]=='已发货'&&$wl_info['log'][1]['customer_type']=='distributor'){
            //查询发货经销商销售区域
            $send_distributor=Db::name('dealer_distributor')
                ->where('dealer_id',$dealer_id)
                ->where('id',$wl_info['log'][1]['customer_id'])
                ->find();
            if($send_distributor['sale_area']){
                $area=json_decode($send_distributor['sale_area'],true);
                $index=-1;
                foreach ($area as $key=>$value){
                    $child_area=explode('-',$value);//['河北省','邯郸市','永年区'];
                    if(strpos($child_area[0],$address[2])&&strpos($child_area[1],$address[3])){
                        $index=$key;
                        break;
                    }
                }
                if($index==-1){
                    //保存串货信息
                    Db::name('dealer_logistics_ch_order')
                        ->insert([
                            'dealer_id'=>$dealer_id,
                            'ch_num'=>$wl_info['log'][1]['ck_num'],
                            'ch_distributor_id'=>'',
                            'bch_distributor_id'=>$wl_info['log'][1]['customer_id'],
                            'bch_distributor_name'=>$wl_info['log'][1]['customer_name'],
                            'bch_distributor_code'=>$wl_info['log'][1]['customer_code'],
                            'from_type'=>2,//扫码触发
                            'cu_address'=>$address[2].$address[3],
                            'ck_order'=>$wl_info['log'][1]['ck_order'],
                            'code'=>$code,
                            'serial_number'=>$wl_info['info']['serial_number'],
                            'code_type'=>$wl_info['info']['code_type'],
                            'remark'=>'扫码查询'
                        ]);
                }
            }
        }
        /** 串货结束**/
        $product=null;
        if($available['log']&&$available['log'][0]){
            $product=Db::name('dealer_product')
                ->where('id',$available['log'][0]['product_id'])
                ->find();
        }
        $company_info=$this->getCompanyInfo($dealer_id);//企业信息
        $queryInfo=Db::name('dealer_logistics_template')
            ->where('dealer_id',$dealer_id)
            ->find();
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
                'data'=>$available,//物流信息
                'trace_info_title'=>$queryInfo['trace_info_title'],//溯源模块标题
                'trace_log_title'=>$queryInfo['trace_log_title'],
                'is_log_show'=>$queryInfo['is_log_show'],
                'trace_log_tips'=>'',
                'trace_log'=>''
            ],
            //产品信息
            'product_info'=>[
                'type'=>'product_type',
                'data'=>[
                    'product_title'=>$queryInfo['product_title'],
                    'cover'=>$product?json_decode($product['cover'],true):'',//轮播图
                    'code'=>$product?$product['code']:'',//产品编号,
                    'product_name'=>$product?$product['product_name']:'',
                    'weight'=>$product?$product['weight']:'',
                    'price'=>$product?$product['price']:'',
                    'details'=>$product?$product['details']:''
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


    public function isBatchAvailable($batch,$dealer_id){
        $batch=Db::name('code_manage')
            ->where('dealer_id',$dealer_id)
            ->where('batch',$batch)
            ->where('is_del',0)
            ->find();
        if(!$batch) return false;
        return true;
    }
    /**
     * @param $code
     * @param $batch
     * @param $dealer_id
     * 查询物流码信息
     */
    public function isCodeAvailable($code,$batch,$dealer_id,$is_active=false){
        $batch_info=Db::name('code_manage')
            ->where('dealer_id',$dealer_id)
            ->where('scene','like','%'.'4'.'%')//查询物流码
            ->where('batch',$batch)
            ->where('enable',1)
            ->find();
        if(!$batch_info) return ['code'=>201,'msg'=>'该物流码无效'];
        $secret_key=json_decode($batch_info['secret_key'],true);
        if(count($secret_key)==0){
            //不存在组套关系
            $key=explode(',',$batch_info['key']);//秘钥形式（n,d,e)
            if(strlen($code)!=$batch_info['code_length']) return JsonService::returnData(500,'该物流码无效');
            $decrypt_code=bcpowmod($code,$key[1],$key[0],0);
            //判断是否属于所在区间
            if($batch_info['order_begin']<=$decrypt_code&&$decrypt_code<=$batch_info['order_end']){
                //正常数码
                $codeList=[
                    [$code.'('.$decrypt_code.')']
                ];
                if($is_active){
                    $log=$this->getLogisticsInfo($code,$batch,false,$dealer_id,'');
                }else{
                    $log=[];
                }
                $info=[
                    'code_type'=>2,
                    'batch'=>$batch,
                    'serial_number'=>$decrypt_code,
                    'scale'=>[1],
                    'rk_num'=>1
                ];
                return ['code'=>$codeList,'log'=>$log,'info'=>$info];
            }else{
                return ['code'=>201,'msg'=>'该物流码无效'];
            }
        }else{
            //存在组套关系
            foreach ($secret_key as $k=>$val){
                if($val['length']==strlen($code)){
                    //解密
                    $new_key=explode(',',$val['key']);//n d e
                    $order=explode('--',$val['order']);
                    $decrypt_code=bcpowmod($code,$new_key[1],$new_key[0],0);
                    if($order[0]<=$decrypt_code&&$decrypt_code<=$order[1]){
                        //正常数码
                        $code_type=2;//默认小标
                        $rk_num=1;//默认
                        //查询码关系与入库数量
                        if($batch_info['logistics_level']&&$batch_info['logistics_level']>1){
                            $logistics_level_item=json_decode($batch_info['logistics_level_item'],true);
                            $scale=[1];
                            $section=[];
                            //查询比例关系
                            foreach ($logistics_level_item as $ks=>$vs){
                                array_push($scale,(int)$vs['num']);//=>[1,5,10]转化成数组比例
                            }
                            foreach ($secret_key as $kss=>$vss){
                                array_push($section,[(int)explode('--',$vss['order'])[0],(int)explode('--',$vss['order'])[1]]);
                            }
                            $this->getNewChildCode($scale,$section,$k,(int)$decrypt_code);//查询子包装码
                            if(count($this->new_child)>0){
                                if($batch_info['logistics_level']==2){
                                    //二级包装
                                    $code_type=1;
                                }else if(count($this->new_child)==2) {
                                    $code_type=1;//大标
                                }else{
                                    $code_type=2; //中级包装小标对待
                                }
                                //产品数量
                                $rk_num=(int)end(array_reverse($this->new_child)[0])-(int)current(array_reverse($this->new_child)[0])+1;
                            }
                            //查询父级 由父级反推
                            $this->getParentCode($scale,$section,$k,(int)$decrypt_code);//查询父级包装码
                            $parent_order=array_reverse($this->parent);//父级包装[22,44]
                            $temp=$parent_order;
                            array_push($temp,(int)$decrypt_code);
                            if($is_active){
                                $log=$this->getLogisticsInfo($code,$batch,true,$dealer_id,$temp);
                            }else{
                                $log=[];
                            }
                            if(count($parent_order)==0){
                                //本身是父级
                                $parent_code=$decrypt_code;
                            }else{
                                $parent_code=$parent_order[0];
                            }

                            $this->getChildCode($scale,$section,0,(int)$parent_code);
                            $ser_arr=[];//序号数组
                            foreach ($this->child as $key =>$value){
                                array_push($ser_arr,[current($value),end($value)]);
                            }
                            array_unshift($ser_arr,[(int)$parent_code]);
                            //循环加密
                            $arr=array();
                            foreach ($ser_arr as $ks=>$vs){
                                $arr[$ks]=[];
                                for($i=$vs[0];$i<=end($vs);$i++){
                                    $key=explode(',',$secret_key[$ks]['key']);//n d e
                                    $encry_code=bcpowmod($i,$key[2],$key[0],0);
                                    $length=(int)$secret_key[$ks]['length'];
                                    $curCode=$this->appendString($encry_code,$length-strlen($encry_code),'0');//转字符串 统计长度
                                    array_push($arr[$ks],$curCode.'\n'.'(流水号'.$i.')');
                                }
                            }
                            $info=[
                                'code_type'=>$code_type,
                                'batch'=>$batch,
                                'serial_number'=>$decrypt_code,
                                'scale'=>$scale,
                                'rk_num'=>$rk_num
                            ];

                            //补零
                            return['code'=>$arr,'log'=>$log,'info'=>$info];
                        }
                    }else{
                        return ['code'=>201,'msg'=>'该物流码无效'];
                        break;
                    }
                }
            }
            return JsonService::returnData(400,'该物流码无效');
        }
    }
    public function getLogisticsInfo($code,$batch,$is_scale,$dealer_id,$parent_order=[]){
        if(!$is_scale){
            //未组套
            //入库信息
            $rk_info=Db::name('dealer_logistics_rk_code')
                ->alias('a')
                ->join('dealer_logistics_rk_order b','a.rk_order=b.rk_order')
                ->where('a.code',$code)
                ->where('a.batch',$batch)
                ->where('a.dealer_id',$dealer_id)
                ->field('a.rk_order,a.create_time,b.create_by,b.warehouse_id,b.product_id,b.product_name,b.product_code,b.barcode,b.specifications,b.manufacture_time,b.validity_time,b.unit')
                ->find();
            //出库信息
            $ck_info=Db::name('dealer_logistics_ck_code')
                ->alias('a')
                ->join('dealer_logistics_ck_order b','a.ck_order=b.ck_order')
                ->where('a.batch',$batch)
                ->where('a.code',$code)
                ->where('a.dealer_id',$dealer_id)
                ->field('a.ck_num,a.is_return,a.create_time,a.ck_order,b.create_by,b.warehouse_id,b.customer_id,b.customer_code,b.customer_type,b.customer_name,b.is_gift,a.product_name,a.unit,a.specifications')
                ->find();
            //退货信息
            $th_info=Db::name('dealer_logistics_th_code')
                ->alias('a')
                ->join('dealer_logistics_th_order b','a.th_order=b.th_order')
                ->join('dealer_product c','a.product_id=c.id')
                ->where('a.batch',$batch)
                ->where('a.dealer_id',$dealer_id)
                ->where('a.code',$code)
                ->field('a.*,b.customer_name,c.product_name')
                ->select();
            //调仓信息
            $dc_info=Db::name('dealer_logistics_dc_code')
                ->alias('a')
                ->join('dealer_logistics_dc_order b','a.dc_order=b.dc_order')
                ->where('a.batch',$batch)
                ->where('a.dealer_id',$dealer_id)
                ->where('a.code',$code)
                ->field('a.dc_order,a.product_name,b.out_warehouse_id,b.in_warehouse_id')
                ->find();
            $status='暂无信息';
            if($rk_info) $status='已入库';
            if($ck_info&&$ck_info['is_return']==0) $status='已发货';
            if($ck_info&&$ck_info['is_return']==1) $status='已退货';
            return [$rk_info,$ck_info,count($th_info)>0?$th_info[0]:null,$dc_info,$status];
        }else{
            //原则 大码优先级最高
            foreach ($parent_order as $key=>$val){
                $rk_info=Db::name('dealer_logistics_rk_code')
                    ->alias('a')
                    ->join('dealer_logistics_rk_order b','a.rk_order=b.rk_order')
                    ->where('a.serial_number',$val)
                    ->where('a.batch',$batch)
                    ->where('a.dealer_id',$dealer_id)
                    ->field('a.rk_order,a.create_time,b.warehouse_id,b.product_id,b.product_name,b.product_code,b.barcode,b.specifications,b.manufacture_time,b.validity_time,b.unit')
                    ->find();
                if($rk_info) break;//中断循环
            }
            foreach ($parent_order as $key=>$val){
                $ck_info=Db::name('dealer_logistics_ck_code')
                    ->alias('a')
                    ->join('dealer_logistics_ck_order b','a.ck_order=b.ck_order')
                    ->where('a.batch',$batch)
                    ->where('a.serial_number',$val)
                    ->where('a.dealer_id',$dealer_id)
                    ->field('a.ck_num,a.is_return,a.create_time,a.ck_order,b.warehouse_id,b.customer_id,b.customer_code,b.customer_type,b.customer_name,b.is_gift,a.product_name,a.unit,a.specifications')
                    ->find();
                if($ck_info) break;//中断循环
            }
            foreach ($parent_order as $key=>$val){
                //退货信息
                $th_info=Db::name('dealer_logistics_th_code')
                    ->alias('a')
                    ->join('dealer_logistics_th_order b','a.th_order=b.th_order')
                    ->join('dealer_product c','a.product_id=c.id')
                    ->where('a.batch',$batch)
                    ->where('a.dealer_id',$dealer_id)
                    ->where('a.serial_number',$val)
                    ->field('a.*,b.customer_name,c.product_name')
                    ->order('create_time','desc')
                    ->select();
                if(count($th_info)>0) break;
            }
            foreach ($parent_order as $key=>$val){
                $dc_info=Db::name('dealer_logistics_dc_code')
                    ->alias('a')
                    ->join('dealer_logistics_dc_order b','a.dc_order=b.dc_order')
                    ->join('dealer_product c','a.product_id=c.id')
                    ->where('a.batch',$batch)
                    ->where('a.dealer_id',$dealer_id)
                    ->where('a.serial_number',$val)
                    ->field('a.dc_order,a.create_time,c.product_name,b.out_warehouse_id,b.in_warehouse_id')
                    ->find();
                if($dc_info) break;
            }
            $status='暂无信息';
            if($rk_info) $status='已入库';
            if($ck_info&&$ck_info['is_return']==0) $status='已发货';
            if($ck_info&&$ck_info['is_return']==1) $status='已退货';
            return [$rk_info,$ck_info,count($th_info)>0?$th_info[0]:null,$dc_info,$status];
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
                        'title'=>'产品',
                        'is_show'=>1
                    ],
                    [
                        'title'=>'物流',
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
    public function getWarehouseList(Request $request){
        $params=$request->get();
        $list=Db::name('dealer_logistics_warehouse')
            ->where('dealer_id',$params['dealer_id'])
            ->where('code|warehouse_name|address|person','like','%'.$params['keywords'].'%')
            ->page($params['pageNum'])
            ->limit($params['pageSize'])
            ->select();
        return JsonService::returnData(200,'查询成功',$list);
    }

    /**
     * @param Request $request
     * 查询物流
     * 窜货预警
     */
    public function queryLogisticsInfo(Request $request){
        $address=$request->address();
        $code=$request->param('code');
        $batch=$request->param('batch');
        $dealer_id=$request->param('dealer_id');
        $password=$request->param('password');
        $pass=Db::name('dealer_logistics_basic_set')->where('dealer_id',$dealer_id)->value('query_password');
        if($pass!=$password) return JsonService::returnData(500,'查询密码错误');
        Db::startTrans();//开启事务
        try{
            //查询是否有替换码
            $replace=Db::name('dealer_logistics_replace_code')
                ->where('cur_code',$code)
                ->where('cur_batch',$batch)
                ->find();
            if($replace){
                $code=$replace['origin_code'];
                $batch=$replace['origin_batch'];
            }
            $available=$this->isCodeAvailable($code,$batch,$dealer_id,true);
            if($available['code']==201) return JsonService::returnData(500,$available['msg']);
            $product=null;
            if($available['log']&&$available['log'][0]){
                $product=Db::name('dealer_product')
                    ->where('id',$available['log'][0]['product_id'])
                    ->find();
            }
            $company_info=$this->getCompanyInfo($dealer_id);//企业信息
            $queryInfo=Db::name('dealer_logistics_template')
                ->where('dealer_id',$dealer_id)
                ->find();
            //写查询日志
            $first_query_info=Db::name('dealer_logistics_query_log')
                ->where('code',$code)
                ->where('batch',$batch)
                ->where('dealer_id',$dealer_id)
                ->where('is_first',1)
                ->find();
            if(!$first_query_info){
                //第一次查询
                Db::name('dealer_logistics_query_log')->insert([
                    'code'=>$code,
                    'batch'=>$batch,
                    'dealer_id'=>$dealer_id,
                    'is_first'=>1,
                    'address'=>$address[2].$address[3],
                ]);
                $query_res_tips='该物流码为首次查询。'."\n".'查询时间为'.date("Y-m-d H:i:s");
            }else{
                Db::name('dealer_logistics_query_log')->insert([
                    'code'=>$code,
                    'batch'=>$batch,
                    'dealer_id'=>$dealer_id,
                    'address'=>$address[2].$address[3],
                ]);
                $count=Db::name('dealer_logistics_query_log')
                    ->where('code',$code)
                    ->where('batch',$batch)
                    ->where('dealer_id',$dealer_id)
                    ->count();
                $query_res_tips='该物流码为第'.$count.'次查询'."\n".'首次查询时间为'.$first_query_info['create_time'];
            }
            //串货预警 判断扫码与经销商售货区域是否一致
//            if($available['log'][4]=='已发货'&&$available['log'][1]['customer_type']=='distributor'){
//                //查询发货经销商销售区域
//                $send_distributor=Db::name('dealer_distributor')
//                    ->where('dealer_id',$dealer_id)
//                    ->where('id',$available['log'][1]['customer_id'])
//                    ->find();
//                $area=json_decode($send_distributor['sale_area'],true);
//                $index=-1;
//                foreach ($area as $key=>$value){
//                    $child_area=explode('-',$value);//['河北省','邯郸市','永年区'];
//                    if(strpos($child_area[0],$address[2])&&strpos($child_area[1],$address[3])){
//                        $index=$key;
//                        break;
//                    }
//                }
//                if($index==-1){
//                    //保存串货信息
//                    Db::name('dealer_logistics_ch_order')
//                        ->insert([
//                            'dealer_id'=>$dealer_id,
//                            'ch_num'=>$available['log'][1]['ck_num'],
//                            'ch_distributor_id'=>$available['log'][1]['customer_id'],
//                            'bch_distributor_id'=>$available['log'][1]['customer_id'],
//                            'bch_distributor_name'=>$available['log'][1]['customer_name'],
//                            'bch_distributor_code'=>$available['log'][1]['customer_code'],
//                            'from_type'=>2,//扫码触发
//                            'cu_address'=>$address[2].$address[3],
//                            'ck_order'=>$available['log'][1]['ck_order'],
//                            'code'=>$code,
//                            'serial_number'=>$available['info']['serial_number'],
//                            'code_type'=>$available['info']['code_type'],//小标对待
//                            'remark'=>'扫码查询'
//                        ]);
//                }
//            }
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
                    'data'=>$available,//物流信息
                    'trace_info_title'=>$queryInfo['trace_info_title'],//溯源模块标题
                    'trace_log_title'=>$queryInfo['trace_log_title'],
                    'is_log_show'=>$queryInfo['is_log_show'],
                    'trace_log_tips'=>$query_res_tips,
                    'trace_log'=>''
                ],
                //产品信息
                'product_info'=>[
                    'type'=>'product_type',
                    'data'=>[
                        'product_title'=>$queryInfo['product_title'],
                        'cover'=>$product?json_decode($product['cover'],true):'',//轮播图
                        'code'=>$product?$product['code']:'',//产品编号,
                        'product_name'=>$product?$product['product_name']:'',
                        'weight'=>$product?$product['weight']:'',
                        'price'=>$product?$product['price']:'',
                        'details'=>$product?$product['details']:''
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

            Db::commit();
            return JsonService::returnData(200,'查询成功',$this->_mergeDefaultData($pageData));
        }catch (\Exception $e){
            Db::rollback();
            return JsonService::returnData(500,$e->getMessage());
        }
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
    /**
     * @param $scale //比例关系[1,12,13]1拖12拖13
     * @param $section//码段区间数列
     * @param $index //查询数码所在上述区间
     * @param $order //查询数码
     * @return array
     * 根据子包装推导外侧包装物流码序号[a,b,c...]abc依次为一二级包装序号 依次类推
     */
    public function getParentCode($scale,$section,$index,$order){
        if($index==0) return $this->parent;
        $start=floor(($order-$section[$index][0])/$scale[$index]);
        array_push($this->parent,$section[$index-1][0]+$start);
        $index--;
        if($index>0){
            $this->getParentCode($scale,$section,$index,$this->parent[count($this->parent)-1]);
        }
    }
    public function getNewParentCode($scale,$section,$index,$order){
        if($index==0) return $this->new_parent;
        $start=floor(($order-$section[$index][0])/$scale[$index]);
        array_push($this->new_parent,$section[$index-1][0]+$start);
        $index--;
        if($index>0){
            $this->getNewParentCode($scale,$section,$index,$this->new_parent[count($this->new_parent)-1]);
        }
    }
    /**
     * @param $scale
     * @param $section
     * @param $index
     * @param $order
     * @return array
     * 查询外包装对应子包装的物流码5=>[[4,6],[44,55]...]元素为首位字段
     */
    public function getChildCode($scale,$section,$index,$order){
        if($index==count($scale)-1) return $this->child;
        $star=($order-$section[$index][0])*$scale[$index+1];
        array_push($this->child,[($star+$section[$index+1][0]),($star+$section[$index+1][0]+$scale[$index+1]-1)]);
        $index++;
        if($index<count($scale)-1){
            $this->getChildCode($scale,$section,$index,$this->child[count($this->child)-1][0]);
            $this->getChildCode($scale,$section,$index,$this->child[count($this->child)-2][1]);
            $this->child=[$this->child[0],array_merge($this->child[count($this->child)-2],$this->child[count($this->child)-1])];
        }
    }
    public function getNewChildCode($scale,$section,$index,$order){
        if($index==count($scale)-1) return $this->new_child;
        $star=($order-$section[$index][0])*$scale[$index+1];
        array_push($this->new_child,[($star+$section[$index+1][0]),($star+$section[$index+1][0]+$scale[$index+1]-1)]);
        $index++;
        if($index<count($scale)-1){
            $this->getNewChildCode($scale,$section,$index,$this->new_child[count($this->new_child)-1][0]);
            $this->getNewChildCode($scale,$section,$index,$this->new_child[count($this->new_child)-2][1]);
            $this->new_child=[$this->new_child[0],array_merge($this->new_child[count($this->new_child)-2],$this->new_child[count($this->new_child)-1])];
        }
    }

}