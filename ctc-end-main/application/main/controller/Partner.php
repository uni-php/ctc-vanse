<?php
/**
 * Created by PhpStorm.
 * Role: wenhan
 * Date: 2021/10/7
 * Time: 下午10:01
 */

namespace app\main\controller;
use think\Controller;
use think\Db;
use app\Request;
use app\common\ImgUpload;
use app\common\Qiniu;
use think\facade\Hook;

class Partner extends Controller
{
    //查询级别列表
    public function getLevelList(Request $request){
        $params=$request->get();
        $list=Db::name('partner_level')
            ->where('level_name','like','%'.$params['level_name'].'%')
            ->page($params['pageNum'])
            ->limit($params['pageSize'])
            ->select();
        $total=Db::name('partner_level')
            ->where('level_name','like','%'.$params['level_name'].'%')
            ->count();
        $res=[
            'code'=>200,
            'msg'=>'查询成功',
            'data'=>$list,
            'total'=>$total,
        ];
        return json($res);
    }
    //新增合伙人级别
    public function addLevel(Request $request){
        $data=$request->get();
        $data['create_by']=$request->userInfo()['account'];
        $address = $request->address();
        $id=array_key_exists('id',$data);
        if($id){
            Db::name('partner_level')
                ->update($data);
            $info=[
                'code'=>200,
                'msg'=>'更新成功'
            ];
            $log=[
              'module_name'=>'合伙人级别',
              'operator'=>$data['create_by'],
              'ip'=>$request->ip(),
              'address'=>$address[2].$address[3],
              'operate_type'=>'2',
              'operate_event'=>'修改合伙人等级'
            ];
            Hook::listen('op_log',$log);
        }else{
            $has=Db::name('partner_level')
                ->where('level',$data['level'])
                ->find();
            if($has){
                $info=[
                    'code'=>201,
                    'msg'=>'合伙人等级已存在'
                ];
            }else{
                $res=Db::name('partner_level')
                    ->insert($data);
                if($res){
                    $info=[
                        'code'=>200,
                        'msg'=>'新增成功'
                    ];
                    $log=[
                        'module_name'=>'合伙人级别',
                        'operator'=>$data['create_by'],
                        'ip'=>$request->ip(),
                        'address'=>$address[2].$address[3],
                        'operate_type'=>'1',
                        'operate_event'=>'新增合伙人等级'
                    ];
                    Hook::listen('op_log',$log);
                }else{
                    $info=[
                        'code'=>201,
                        'msg'=>'系统异常'
                    ];
                }
            }
        }
        return json($info);
    }
    public function getLevelInfo(Request $request){
        $id=$request->param('id');
        $info=Db::name('partner_level')
            ->where('id',$id)
            ->find();
        $res=[
            'code'=>200,
            'msg'=>'查询成功',
            'data'=>$info
        ];
        return json($res);
    }
    //删除合伙人级别
    public function deleLevel(Request $request){
        $id=$request->param('id');
        $address = $request->address();
        $res=Db::name('partner_level')
            ->delete($id);
        if($res){
            $info=[
                'code'=>200,
                'msg'=>'删除成功'
            ];
            $log=[
                'module_name'=>'合伙人级别',
                'operator'=>$request->userInfo()['account'],
                'ip'=>$request->ip(),
                'address'=>$address[2].$address[3],
                'operate_type'=>'3',
                'operate_event'=>'删除合伙人等级'
            ];
            Hook::listen('op_log',$log);
        }else{
            $info=[
                'code'=>201,
                'msg'=>'删除失败'
            ];
        }
        return json($info);
    }
    //查询合伙人列表
    public function getPartnerList(Request $request){
        $params=$request->get();
        $condition=[];
        if($params['id']){
            $condition['id']=$params['id'];
        }
        if($params['status']){
            $condition['status']=$params['status'];
        }
        if($params['level_id']){
            $condition['level_id']=$params['level_id'];
        }
        if($params['startTime']){
            $condition['end_time']=['<time',$params['endTime']];
        }
        if(count($condition)>0){
            $list=Db::name('partner')
                ->where('company','like','%'.$params['company'].'%')
                ->where($condition)
                ->where('is_del',0)
                ->page($params['pageNum'])
                ->limit($params['pageSize'])
                ->select();
            $total=Db::name('partner')
                ->where('company','like','%'.$params['company'].'%')
                ->where('is_del',0)
                ->where($condition)
                ->count();
        }else{
            $list=Db::name('partner')
                ->where('company','like','%'.$params['company'].'%')
                ->page($params['pageNum'])
                ->where('is_del',0)
                ->limit($params['pageSize'])
                ->select();
            $total=Db::name('partner')
                ->where('company','like','%'.$params['company'].'%')
                ->where('is_del',0)
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
    public function addPartner(Request $request){
        $data=$request->get();
        $address = $request->address();
        $id=array_key_exists('id',$data);
        if($id){
            Db::name('partner')
                ->update($data);
            $log=[
                'module_name'=>'合伙人列表',
                'operator'=>$request->userInfo()['account'],
                'ip'=>$request->ip(),
                'address'=>$address[2].$address[3],
                'operate_type'=>'2',
                'operate_event'=>'修改合伙人'
            ];
            Hook::listen('op_log',$log);
            $info=[
                'code'=>200,
                'msg'=>'更新成功'
            ];
        }else{
            $data['password']=md5($data['password']);
            $res=Db::name('partner')
                ->insert($data);
            if($res){
                $log=[
                    'module_name'=>'合伙人列表',
                    'operator'=>$request->userInfo()['account'],
                    'ip'=>$request->ip(),
                    'address'=>$address[2].$address[3],
                    'operate_type'=>'1',
                    'operate_event'=>'新增合伙人'
                ];
                Hook::listen('op_log',$log);
                $info=[
                    'code'=>200,
                    'msg'=>'新增成功'
                ];
            }else{
                $info=[
                    'code'=>201,
                    'msg'=>'系统异常'
                ];
            }
        }
        return json($info);
    }
    //查询合伙人详情
    public function getPartnerInfo(Request $request){
        $id=$request->param('id');
        $info=Db::name('partner')
            ->where('id',$id)
            ->find();
        $res=[
            'code'=>200,
            'msg'=>'查询成功',
            'data'=>$info
        ];
        return json($res);
    }
    //获取认证信息
    public function getAuthData(Request $request){
        $id=$request->param('id');
        $info=Db::name('partner')
            ->where('id',$id)
            ->find();
        $info['name']='企业营业执照';
        $info['tips']='认证后的品牌商资料将作为品牌商的通用名片，可在版权、防伪查询等地方进行应用。';
        $arr=[
            $info
        ];
        $info=[
            'code'=>200,
            'msg'=>'查询成功',
            'data'=>$arr
        ];
        return json($info);
    }
    public function checkLicense(Request $request){
        $data=$request->get();
        $address = $request->address();
        $code=Db::name('partner')
            ->update($data);
        if($code||$code==0){
            $log=[
                'module_name'=>'合伙人列表',
                'operator'=>$request->userInfo()['account'],
                'ip'=>$request->ip(),
                'address'=>$address[2].$address[3],
                'operate_type'=>'2',
                'operate_event'=>'审核合伙人营业执照'
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
    public function resetPartnerPwd(Request $request){
        $params=$request->get();
        $address = $request->address();
        $code=Db::name('partner')
            ->where('id',$params['id'])
            ->update([
                'password'=>md5($params['password'])
            ]);
        $log=[
            'module_name'=>'合伙人列表',
            'operator'=>$request->userInfo()['account'],
            'ip'=>$request->ip(),
            'address'=>$address[2].$address[3],
            'operate_type'=>'2',
            'operate_event'=>'重置合伙人密码'
        ];
        Hook::listen('op_log',$log);
        $info=[
            'code'=>200,
            'msg'=>'更新成功'
        ];
        return json($info);
    }
    public function disableAccount(Request $request){
        $data=$request->get();
        $address = $request->address();
        $code=Db::name('partner')
            ->update($data);
        $log=[
            'module_name'=>'合伙人列表',
            'operator'=>$request->userInfo()['account'],
            'ip'=>$request->ip(),
            'address'=>$address[2].$address[3],
            'operate_type'=>'2',
            'operate_event'=>'修改合伙人状态'
        ];
        Hook::listen('op_log',$log);
        if($code){
            $info=[
                'code'=>200,
                'msg'=>'操作成功'
            ];
        }else{
            $info=[
                'code'=>201,
                'msg'=>'系统异常'
            ];
        }
        return json($info);
    }
    public function delePartner(Request $request){
        $id=$request->param('id');
        $address = $request->address();
        $res=Db::name('partner')
            ->where('id',$id)
            ->update([
                'is_del'=>1
            ]);
        if($res){
            $log=[
                'module_name'=>'合伙人列表',
                'operator'=>$request->userInfo()['account'],
                'ip'=>$request->ip(),
                'address'=>$address[2].$address[3],
                'operate_type'=>'3',
                'operate_event'=>'删除合伙人'
            ];
            Hook::listen('op_log',$log);
            $info=[
                'code'=>200,
                'msg'=>'删除成功'
            ];
        }else{
            $info=[
                'code'=>201,
                'msg'=>'删除失败'
            ];
        }
        return json($info);
    }
    public function uploadImg(Request $request){
        $Qiniu=new Qiniu();
        $file = request()->file('img');
        $res=$Qiniu->uploadImg($file);
        return json([
            'filePath'=>$res['imgPath'],
            'key'=>$res['key']
        ]);
    }

}