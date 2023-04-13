<?php
/**
 * Created by PhpStorm.
 * Role: wenhan
 * Date: 2021/10/11
 * Time: 上午3:53
 */

namespace app\main\controller;
use think\Controller;
use think\Db;
use think\Request;
use app\common\JsonService;
class SecurityCode extends Controller
{
    /**
     * @param Request $request
     * @return \think\response\Json
     * @throws \think\db\exception\DataNotFoundException
     * @throws \think\db\exception\ModelNotFoundException
     * @throws \think\exception\DbException
     * 查询已审核过的码包
     */
    public function listCode(Request $request){
        $params=$request->get();
        $list=Db::name('code_manage')
            ->alias('a')
            ->join('partner b','a.partner_id=b.id')
            ->join('dealer c','a.dealer_id=c.id')
            ->where('b.company','like','%'.$params['partner'].'%')
            ->where('c.dealer_name','like','%'.$params['dealer'].'%')
            ->where('a.remark','like','%'.$params['mark'].'%')
            ->where('a.code_type','like','%'.$params['type'].'%')
            ->where('a.scene','like','%'.$params['scene'].'%')
            ->where('a.enable',1)
            ->where('a.is_del',0)
            ->page($params['pageNum'])
            ->limit($params['pageSize'])
            ->order('a.create_time','desc')
            ->field('a.*,b.company as partner_company,b.account as partner_account,c.dealer_name,c.account')
            ->select();
        foreach ($list as $k=>$val){
            $list[$k]['secret_key']=json_decode($val['secret_key'],true);
        }
        $sum=Db::name('code_manage')
            ->alias('a')
            ->join('partner b','a.partner_id=b.id')
            ->join('dealer c','a.dealer_id=c.id')
            ->where('b.company','like','%'.$params['partner'].'%')
            ->where('c.dealer_name','like','%'.$params['dealer'].'%')
            ->where('a.remark','like','%'.$params['mark'].'%')
            ->where('a.code_type','like','%'.$params['type'].'%')
            ->where('a.scene','like','%'.$params['scene'].'%')
            ->where('a.is_del',0)
            ->where('a.enable',1)
            ->sum('count');
        $total=Db::name('code_manage')
            ->alias('a')
            ->join('partner b','a.partner_id=b.id')
            ->join('dealer c','a.dealer_id=c.id')
            ->where('b.company','like','%'.$params['partner'].'%')
            ->where('c.dealer_name','like','%'.$params['dealer'].'%')
            ->where('a.remark','like','%'.$params['mark'].'%')
            ->where('a.code_type','like','%'.$params['type'].'%')
            ->where('a.scene','like','%'.$params['scene'].'%')
            ->where('a.is_del',0)
            ->where('a.enable',1)
            ->count();
        $res=[
            'code'=>200,
            'msg'=>'查询成功',
            'data'=>$list,
            'sum'=>$sum,
            'total'=>$total
        ];
        return json($res);
    }
    public function listWaitCode(Request $request){
        $params=$request->get();
        $list=Db::name('code_manage')
            ->alias('a')
            ->join('partner b','a.partner_id=b.id')
            ->join('dealer c','a.dealer_id=c.id')
            ->where('b.company','like','%'.$params['partner'].'%')
            ->where('c.dealer_name','like','%'.$params['dealer'].'%')
            ->where('a.remark','like','%'.$params['mark'].'%')
            ->where('a.code_type','like','%'.$params['type'].'%')
            ->where('a.scene','like','%'.$params['scene'].'%')
            ->where('a.enable','<>',1)
            ->where('a.is_del',0)
            ->page($params['pageNum'])
            ->limit($params['pageSize'])
            ->order('a.create_time','desc')
            ->field('a.*,b.company as partner_company,b.account as partner_account,c.dealer_name,c.account')
            ->select();
        foreach ($list as $k=>$val){
            $list[$k]['secret_key']=json_decode($val['secret_key'],true);
        }
        $sum=Db::name('code_manage')
            ->alias('a')
            ->join('partner b','a.partner_id=b.id')
            ->join('dealer c','a.dealer_id=c.id')
            ->where('b.company','like','%'.$params['partner'].'%')
            ->where('c.dealer_name','like','%'.$params['dealer'].'%')
            ->where('a.remark','like','%'.$params['mark'].'%')
            ->where('a.code_type','like','%'.$params['type'].'%')
            ->where('a.scene','like','%'.$params['scene'].'%')
            ->where('a.is_del',0)
            ->where('a.enable','<>',1)
            ->sum('count');
        $total=Db::name('code_manage')
            ->alias('a')
            ->join('partner b','a.partner_id=b.id')
            ->join('dealer c','a.dealer_id=c.id')
            ->where('b.company','like','%'.$params['partner'].'%')
            ->where('c.dealer_name','like','%'.$params['dealer'].'%')
            ->where('a.remark','like','%'.$params['mark'].'%')
            ->where('a.code_type','like','%'.$params['type'].'%')
            ->where('a.scene','like','%'.$params['scene'].'%')
            ->where('a.is_del',0)
            ->where('a.enable','<>',1)
            ->count();
        $res=[
            'code'=>200,
            'msg'=>'查询成功',
            'data'=>$list,
            'sum'=>$sum,
            'total'=>$total
        ];
        return json($res);
    }
    public function deleCode(Request $request){
        $id=$request->param('id');
        $pwd=$request->param('pwd');
        $password=Db::name('user')
            ->where('uid',1)
            ->value('password');
        if(md5($pwd)!=$password){
            $info=[
                'code'=>201,
                'msg'=>'密码不正确'
            ];
        }else{
            $code=Db::name('code_manage')
                ->where('id',$id)
                ->update([
                    'is_del'=>1
                ]);
            if($code){
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
        }
        return json($info);
    }

    /**
     * @param Request $request
     * 查询关联产品
     */
    public function getRelProduct(Request $request){
        $params=$request->get();
        $list=Db::name('code_rel_product')
            ->alias('a')
            ->join('dealer_product b','a.product_id=b.id')
            ->where('a.dealer_id',$params['dealer_id'])
            ->where('a.batch',$params['batch'])
            ->where('a.partner_id',$params['partner_id'])
            ->field('a.*,b.product_name')
            ->page($params['pageNum'])
            ->limit($params['pageSize'])
            ->select();
        $rel_count=Db::name('code_rel_product')
            ->where('dealer_id',$params['dealer_id'])
            ->where('batch',$params['batch'])
            ->where('partner_id',$params['partner_id'])
            ->sum('quantity');//已关联总数
        $total=Db::name('code_rel_product')
            ->where('dealer_id',$params['dealer_id'])
            ->where('batch',$params['batch'])
            ->where('partner_id',$params['partner_id'])
            ->count();
        $res=[
            'code'=>200,
            'msg'=>'查询成功',
            'rel_count'=>$rel_count,
            'data'=>$list,
            'total'=>$total
        ];
        return json($res);
    }

    /**
     * @param Request $request
     * 审核码包
     */
    public function checkCode(Request $request){
        $data=$request->get();
        $res=Db::name('code_manage')->update($data);
        if($res){
            return JsonService::successful('操作成功');
        }else{
            return JsonService::fail('请联系管理员');
        }
    }

    /**
     * @param Request $request
     * 下载码包
     */
    public function downLoad(Request $request){
        $batch=$request->param('batch');
        try{
            $download =  new \think\response\Download(config('public_code_dir').$batch.'.zip');
            return $download->name('code.zip');
        }catch (\Exception $e){
            return JsonService::fail('文件不存在');
        }
    }

}