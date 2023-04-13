<?php
/**
 * Created by PhpStorm.
 * Role: wenhan
 * Date: 2021/10/9
 * Time: 下午11:29
 */

namespace app\main\controller;
use think\Controller;
use think\Db;
use app\Request;
use app\common\ImgUpload;
use app\common\Qiniu;
use think\facade\Hook;

class Dealer extends Controller
{
    public function getDealerList(Request $request){
        $params=$request->get();
        $condition=[];
        if($params['startTime']){
            $condition['a.create_time']=['>time',$params['startTime']];
            $condition['a.create_time']=['<time',$params['endTime']];
        }
        //已过期
        if($params['status']==3){
            $condition['a.validity_end']=['<=time',time()];
        }
        if(count($condition)>0){
            if($params['status']!=3){
                $list=Db::name('dealer')
                    ->alias('a')
                    ->join('partner b','a.partner_id=b.id')
                    ->leftJoin(['ctc_dealer_business_license'=>'c'],'a.id=c.dealer_id')
                    ->leftJoin(['ctc_dealer_trademark'=>'d'],'a.id=d.dealer_id')
                    ->where('a.id','like','%'.$params['code'].'%')
                    ->where('a.dealer_name','like','%'.$params['dealer_name'].'%')
                    ->where('a.status','like','%'.$params['status'].'%')
                    ->where('a.is_del',0)
                    ->where($condition)
                    ->page($params['pageNum'])
                    ->limit($params['pageSize'])
                    ->field('a.*,b.company as partner,c.status as license_status,d.status as trademark_status')
                    ->select();
                $total=Db::name('dealer')
                    ->where('id','like','%'.$params['cdealerListode'].'%')
                    ->where('dealer_name','like','%'.$params['dealer_name'].'%')
                    ->where('status','like','%'.$params['status'].'%')
                    ->where($condition)
                    ->count();
            }else{
                $list=Db::name('dealer')
                    ->alias('a')
                    ->join('partner b','a.partner_id=b.id')
                    ->leftJoin(['ctc_dealer_business_license'=>'c'],'a.id=c.dealer_id')
                    ->leftJoin(['ctc_dealer_trademark'=>'d'],'a.id=d.dealer_id')
                    ->where('a.id','like','%'.$params['code'].'%')
                    ->where('a.dealer_name','like','%'.$params['dealer_name'].'%')
                    ->where('a.is_del',0)
                    ->where($condition)
                    ->page($params['pageNum'])
                    ->limit($params['pageSize'])
                    ->field('a.*,b.company as partner,c.status as license_status,d.status as trademark_status')
                    ->select();
                $total=Db::name('dealer')
                    ->where('id','like','%'.$params['code'].'%')
                    ->where('dealer_name','like','%'.$params['dealer_name'].'%')
                    ->where($condition)
                    ->count();
            }
        }else{
            $list=Db::name('dealer')
                ->alias('a')
                ->join('partner b','a.partner_id=b.id')
                ->leftJoin(['ctc_dealer_business_license'=>'c'],'a.id=c.dealer_id')
                ->leftJoin(['ctc_dealer_trademark'=>'d'],'a.id=d.dealer_id')
                ->where('a.id','like','%'.$params['code'].'%')
                ->where('a.dealer_name','like','%'.$params['dealer_name'].'%')
                ->where('a.status','like','%'.$params['status'].'%')
                ->where('a.is_del',0)
                ->page($params['pageNum'])
                ->limit($params['pageSize'])
                ->field('a.*,b.company as partner,c.status as license_status,d.status as trademark_status')
                ->select();
            $total=Db::name('dealer')
                ->where('id','like','%'.$params['code'].'%')
                ->where('dealer_name','like','%'.$params['dealer_name'].'%')
                ->where('status','like','%'.$params['status'].'%')
                ->count();
        }
        $res=[
            'code'=>200,
            'msg'=>'查询成功',
            'data'=>$list,
            'total'=>$total
        ];
        return json($res);
    }
    public function delDealer(Request $request){
        $id=$request->param('id');
        $address = $request->address();
        $code=Db::name('dealer')
            ->where('id',$id)
            ->update([
                'is_del'=>1
            ]);
        if($code){
            $log=[
                'module_name'=>'品牌商管理',
                'operator'=>$request->userInfo()['account'],
                'ip'=>$request->ip(),
                'address'=>$address[2].$address[3],
                'operate_type'=>'2',
                'operate_event'=>'删除品牌商'
            ];
            Hook::listen('op_log',$log);
            $info=[
                'code'=>200,
                'msg'=>'删除成功'
            ];
        }else{
            $info=[
                'code'=>201,
                'msg'=>'请联系管理员'
            ];
        }
        return json($info);
    }
    public function cutDealer(Request $request){
        $params=$request->get();
        $address = $request->address();
        if($params['status']==0){
            $status=3;
            $txt='禁用成功';
        }
        if($params['status']==1){
            $status=2;
            $txt='禁用成功';
        }
        if($params['status']==3){
            $status=0;
            $txt='已恢复';
        }
        if($params['status']==2){
            $status=1;
            $txt='已恢复';
        }
        $code=Db::name('dealer')
            ->where('id',$params['id'])
            ->update([
                'status'=>$status
            ]);
        if($code){
            $log=[
                'module_name'=>'品牌商管理',
                'operator'=>$request->userInfo()['account'],
                'ip'=>$request->ip(),
                'address'=>$address[2].$address[3],
                'operate_type'=>'2',
                'operate_event'=>'品牌商账号状态禁用、恢复'
            ];
            Hook::listen('op_log',$log);
            $info=[
                'code'=>200,
                'msg'=>$txt
            ];
        }else{
            $info=[
                'code'=>201,
                'msg'=>'请联系管理员'
            ];
        }
        return json($info);
    }
    public function getDealerInfo(Request $request){
        $id=$request->param('id');
        $data=Db::name('dealer')
            ->where('id',$id)
            ->field('id,code,account,dealer_name,behalf_balance')
            ->find();
        $info=[
            'code'=>200,
            'msg'=>'查询成功',
            'data'=>$data
        ];
        return json($info);
    }
    public function getDealerMoreInfo(Request $request){
        $id=$request->param('id');
        $data=Db::name('dealer')
            ->alias('a')
            ->leftJoin(['ctc_dealer_business_license'=>'b'],'a.id=b.dealer_id')
            ->leftJoin(['ctc_dealer_trademark'=>'c'],'a.id=c.dealer_id')
            ->field('a.*,b.*,b.status as license_status,c.*,c.status as trademark_status ')
            ->where('a.id',$id)
            ->find();
        $server=Db::name('partner_product_service')
            ->where('id',$data['service_level'])
            ->find();
        $info=[
            'code'=>200,
            'msg'=>'查询成功',
            'data'=>$data,
            'serverInfo'=>$server,
            'modules'=>json_decode($data['module'],true)
        ];
        return json($info);
    }

    public function rechargeDealer(Request $request){
        $params=$request->get();
        $address = $request->address();
        //验证密码
        $password=Db::name('dealer')->where('id',$params['id'])->value('password');
        if($password!=md5($params['password'])){
            $info=[
                'code'=>201,
                'msg'=>'内置密码不正确!'
            ];
        }else{
            $code=Db::name('dealer')
                ->where('id',$params['id'])
                ->setInc('behalf_balance', $params['recharge']);
            if($code){
                $balance=Db::name('dealer')
                    ->where('id',$params['id'])
                    ->value('behalf_balance');
                Db::name('redpool_recharge_record')
                    ->insert([
                       'dealer_id'=>$params['id'],
                       'balance'=>$balance,
                       'money'=>$params['recharge']
                    ]);
                $log=[
                    'module_name'=>'品牌商管理',
                    'operator'=>$request->userInfo()['account'],
                    'ip'=>$request->ip(),
                    'address'=>$address[2].$address[3],
                    'operate_type'=>'2',
                    'operate_event'=>'增减品牌商的代发红包资金池'
                ];
                Hook::listen('op_log',$log);
                $info=[
                    'code'=>200,
                    'msg'=>'充值成功'
                ];
            }else{
                $info=[
                    'code'=>201,
                    'msg'=>'请联系管理员'
                ];
            }
        }
        return json($info);
    }
    public function rechargeLog(Request $request){
        $params=$request->get();
        $data=Db::name('redpool_recharge_record')
            ->where('dealer_id',$params['id'])
            ->page($params['pageNum'])
            ->limit($params['pageSize'])
            ->select();
        $total=Db::name('redpool_recharge_record')
            ->where('dealer_id',$params['id'])
            ->count();
        $info=[
            'code'=>200,
            'msg'=>'查询成功',
            'data'=>$data,
            'total'=>$total
        ];
        return json($info);
    }
    //发放记录
    public function redPackIssueLog(Request $request){
        $params=$request->get();
        if($params['beginTime']){
            $data=Db::name('redpool_issue_record')
                ->where('dealer_id',$params['id'])
                ->where('openid','like','%'.$params['openid'].'%')
                ->where('create_time', 'between time', [$params['beginTime'],$params['endTime']])
                ->page($params['pageNum'])
                ->limit($params['pageSize'])
                ->select();
            $total=Db::name('redpool_issue_record')
                ->where('dealer_id',$params['id'])
                ->where('create_time', 'between time', [$params['beginTime'],$params['endTime']])
                ->where('openid','like','%'.$params['openid'].'%')
                ->count();
        }else{
            $data=Db::name('redpool_issue_record')
                ->where('dealer_id',$params['id'])
                ->where('openid','like','%'.$params['openid'].'%')
                ->page($params['pageNum'])
                ->limit($params['pageSize'])
                ->select();
            $total=Db::name('redpool_issue_record')
                ->where('dealer_id',$params['id'])
                ->where('openid','like','%'.$params['openid'].'%')
                ->count();
        }
        $info=[
            'code'=>200,
            'msg'=>'查询成功',
            'data'=>$data,
            'total'=>$total
        ];
        return json($info);
    }
    public function getAuthData(Request $request){
        $id=$request->param('id');
        $license=Db::name('dealer_business_license')
            ->where('dealer_id',$id)
            ->find();
        if(!$license) $license['status']=0;
        $license['type']=1;//营业执照
        $license['name']='企业营业执照';
        $license['tips']='认证后的品牌商资料将作为品牌商的通用名片，可在版权、防伪查询等地方进行应用。';
        $trademark=Db::name('dealer_trademark')
            ->where('dealer_id',$id)
            ->find();
        if(!$trademark) $trademark['status']=0;
        $trademark['type']=2;//商标
        $trademark['name']='中国商标权证书';
        $trademark['tips']='认证后的品牌商可以提升品牌的知名度和交易信任级别，认证后品牌商名称可以在查询页显示。';
        $arr=[
            $license,$trademark
        ];
        $info=[
            'code'=>200,
            'msg'=>'查询成功',
            'data'=>$arr
        ];
        return json($info);
    }
    public function checkTrademark(Request $request){
        $data=$request->get();
        $address = $request->address();
        if(array_key_exists('id',$data)){
            $code=Db::name('dealer_trademark')
                ->update($data);
        }else{
            $code=Db::name('dealer_trademark')
                ->insert($data);
        }
        if($code||$code==0){
            $log=[
                'module_name'=>'品牌商管理',
                'operator'=>$request->userInfo()['account'],
                'ip'=>$request->ip(),
                'address'=>$address[2].$address[3],
                'operate_type'=>'2',
                'operate_event'=>'更新品牌商商标权证书'
            ];
            Hook::listen('op_log',$log);
            $info=[
                'code'=>200,
                'msg'=>'更新成功',
            ];
        }else{
            $info=[
                'code'=>201,
                'msg'=>'请联系管理员',
            ];
        }
        return json($info);
    }
    public function checkLicense(Request $request){
        $data=$request->get();
        $address = $request->address();
        if(array_key_exists('id',$data)){
            $code=Db::name('dealer_business_license')
                ->update($data);
        }else{
            $code=Db::name('dealer_business_license')
                ->insert($data);
        }
        if($code||$code==0){
            $log=[
                'module_name'=>'品牌商管理',
                'operator'=>$request->userInfo()['account'],
                'ip'=>$request->ip(),
                'address'=>$address[2].$address[3],
                'operate_type'=>'2',
                'operate_event'=>'更新品牌商营业执照'
            ];
            Hook::listen('op_log',$log);
            $info=[
                'code'=>200,
                'msg'=>'更新成功',
            ];
        }else{
            $info=[
                'code'=>201,
                'msg'=>'请联系管理员',
            ];
        }
        return json($info);
    }
    //上传营业执照与商标
    public function uploadLicense(Request $request){
        $Qiniu=new Qiniu();
        $file = request()->file('img');
        $res=$Qiniu->uploadImg($file);
        return json([
            'filePath'=>$res['imgPath'],
            'key'=>$res['key']
        ]);
    }
    //防伪认证管理
    public function listAuth(Request $request){
        $params=$request->get();
        $list=Db::name('security_auth')
            ->alias('a')
            ->join('security_template b','a.security_template=b.id')
            ->join('dealer c','a.dealer_id=c.id')
            ->join('partner d','c.partner_id=d.id')
            ->where('b.template_name','like','%'.$params['template_name'].'%')
            ->where('c.dealer_name','like','%'.$params['dealer_name'].'%')
            ->field('c.*,c.code,d.company as partner_company,b.*,a.id as auth_id')
            ->page($params['pageNum'])
            ->limit($params['pageSize'])
            ->select();
        $total=Db::name('security_auth')
            ->alias('a')
            ->join('security_template b','a.security_template=b.id')
            ->join('dealer c','a.dealer_id=c.id')
            ->join('partner d','c.partner_id=d.id')
            ->where('b.template_name','like','%'.$params['template_name'].'%')
            ->where('c.dealer_name','like','%'.$params['dealer_name'].'%')
            ->count();
        $res=[
            'code'=>200,
            'msg'=>'查询成功',
            'data'=>$list,
            'total'=>$total
        ];
        return json($res);
    }
    public function getAuthInfo(Request $request){
        $id=$request->param('id');
        $data= Db::name('security_auth')
            ->alias('a')
            ->join('security_template b','a.security_template=b.id')
            ->join('dealer c','a.dealer_id=c.id')
            ->join('partner d','c.partner_id=d.id')
            ->where('a.id',$id)
            ->field('c.*,c.code,d.company as partner_company,b.*,b.id as template_id')
            ->find();
        $info=[
            'code'=>200,
            'msg'=>'查询成功',
            'data'=>$data,
        ];
        return json($info);
    }
    public function updateAuthInfo(Request $request){
        $params=$request->get();
        $address = $request->address();
        $code=Db::name('security_template')
            ->where('id',$params['id'])
            ->update([
               'query_tips'=>$params['query_tips'],
               'query_tips_again'=>$params['query_tips_again']
            ]);
        if($code||$code==0){
            $log=[
                'module_name'=>'品牌商管理',
                'operator'=>$request->userInfo()['account'],
                'ip'=>$request->ip(),
                'address'=>$address[2].$address[3],
                'operate_type'=>'2',
                'operate_event'=>'修改防伪认证成功'
            ];
            Hook::listen('op_log',$log);
            $info=[
                'code'=>200,
                'msg'=>'更新成功',
            ];
        }else{
            $info=[
                'code'=>201,
                'msg'=>'请联系管理员',
            ];
        }
        return json($info);
    }
}