<?php
/**
 * Created by PhpStorm.
 * Role: wenhan
 * Date: 2021/10/6
 * Time: 上午12:37
 */

namespace app\main\controller;
use think\Controller;
use think\Db;
use think\Request;

class Dict extends Controller
{
    public function listType(Request $request){
        $params=$request->get();
        $list=Db::name('dict_type')
            ->where('dict_name','like','%'.$params['dictName'].'%')
            ->where('status',$params['status']?:'not null')
            ->where('dict_type','like','%'.$params['dictType'].'%')
            ->page($params['pageNum'])
            ->limit($params['pageSize'])
            ->select();
        $total=Db::name('dict_type')
            ->where('dict_name','like','%'.$params['dictName'].'%')
            ->where('status',$params['status']?:'not null')
            ->where('dict_type','like','%'.$params['dictType'].'%')
            ->count();
        $res=[
            'code'=>200,
            'msg'=>'查询成功',
            'rows'=>$list,
            'total'=>$total
        ];
        return json($res);
    }
    //新增字典
    public function addType(Request $request){
        $params=$request->get();
        $data=[
            'dict_name'=>$params['dictName'],
            'dict_type'=>$params['dictType'],
            'remark'=>$params['remark']
        ];
        $status=array_key_exists('dictId',$params);
        if($status){
            $res=Db::name('dict_type')
                ->where('id',$params['dictId'])
                ->update($data);
            $info=[
                'code'=>200,
                'msg'=>'更新成功'
            ];
        }else{
            $res=Db::name('dict_type')
                ->insert($data);
            if($res){
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
    //查询字典
    public function getType(Request $request){
        $id=$request->param('id');
        $info=Db::name('dict_type')
            ->where('id',$id)
            ->find();
        $res=[
            'code'=>200,
            'msg'=>'查询成功',
            'data'=>$info
        ];
        return json($res);
    }
    //删除字典
    public function deleType(Request $request){
        $ids=$request->get();
        $ids=explode(",",$ids['ids']);
        $res=Db::name('dict_type')->delete($ids);
        if($res){
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
    //查询字典数据列表
    public function dictData(Request $request){
        $params=$request->get();
        $list=Db::name('dict_data')
            ->where('dict_type',$params['dictType'])
            ->where('dict_label','like','%'.$params['dictLabel'].'%')
            ->where('status',$params['status']?:'not null')
            ->page($params['pageNum'])
            ->limit($params['pageSize'])
            ->select();
        $total=Db::name('dict_data')
            ->where('dict_type',$params['dictType'])
            ->where('dict_label','like','%'.$params['dictLabel'].'%')
            ->where('status',$params['status']?:'not null')
            ->count();
        $res=[
            'code'=>200,
            'msg'=>'查询成功',
            'rows'=>$list,
            'total'=>$total
        ];
        return json($res);
    }
    //添加数据字典数据
    public function addDictData(Request $request){
        $params=$request->get();
        $data=[
            'dict_value'=>$params['dictValue'],
            'dict_type'=>$params['dictType'],
            'dict_label'=>$params['dictLabel'],
            'dict_sort'=>$params['dictSort'],
            'remark'=>$params['remark'],
            'status'=>$params['status'],
        ];
        $status=array_key_exists('dictCode',$params);
        if($status){
            $res=Db::name('dict_data')
                ->where('id',$params['dictCode'])
                ->update($data);
            $info=[
                'code'=>200,
                'msg'=>'更新成功'
            ];
        }else{
            $res=Db::name('dict_data')
                ->insert($data);
            if($res){
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
    //删除字典数据
    public function deleDictData(Request $request){
        $ids=$request->get();
        $ids=explode(",",$ids['ids']);
        $res=Db::name('dict_data')->delete($ids);
        if($res){
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
    //查询字典数据
    public function getDictData(Request $request){
        $id=$request->param('id');
        $info=Db::name('dict_data')
            ->where('id',$id)
            ->find();
        $res=[
            'code'=>200,
            'msg'=>'查询成功',
            'data'=>$info
        ];
        return json($res);
    }
    public function dictByType(Request $request){
        $list=Db::name('dict_data')
            ->where('dict_type',$request->param('type'))
            ->where('status',0)
            ->select();
        $res=[
            'code'=>200,
            'msg'=>'查询成功',
            'data'=>$list
        ];
        return json($res);
    }
}