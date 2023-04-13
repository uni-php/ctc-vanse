<?php
/**
 * Created by PhpStorm.
 * Role: wenhan
 * Date: 2021/11/10
 * Time: 下午3:12
 */

namespace app\main\controller;
use think\Controller;
use think\Db;
use think\Request;

class DealerMenu extends Controller
{
    //查询菜单数据
    public function getMenu(Request $request){
        $params=$request->get();
        $list=Db::name('dealer_menu')
            ->where('menuName','like','%'.$params['menuName'].'%')
            ->where('status','like','%'.$params['status'].'%')
            ->order('orderNum','desc')
            ->select();
        $res=[
            'code'=>200,
            'msg'=>'查询成功',
            'data'=>$list
        ];
        return json($res);
    }
    //新增菜单
    public function addMenu(Request $request){
        $data=$request->get();
        $menuId=array_key_exists('menuId',$data);
        if($menuId){
            Db::name('dealer_menu')
//                ->where('menuId',$menuId)
                ->update($data);
            $info=[
                'code'=>200,
                'msg'=>'更新成功'
            ];
        }else{
            $code=Db::name('dealer_menu')
                ->insert($data);
            if($code){
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
    //查询某项菜单详情
    public function getMemuItem(Request $request){
        $id=$request->param('menuId');
        $info=Db::name('dealer_menu')
            ->where('menuId',$id)
            ->find();
        $res=[
            'code'=>200,
            'msg'=>'查询成功',
            'data'=>$info
        ];
        return json($res);
    }
    //删除菜单
    public function delMenu(Request $request){
        $id=$request->param('menuId');
        $res=Db::name('dealer_menu')->delete($id);
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
    //查询菜单树结构
    public function treeSelect(Request $request){
        $list=Db::name('dealer_menu')
            ->where('status',0)
            ->where('visible',0)
            ->field('menuId as id,menuName as label,parentId')
            ->select();
        $tree=$this->tree($list,0);
        $res=[
            'code'=>200,
            'msg'=>'操作成功',
            'data'=>$tree
        ];
        return json($res);
    }
    public function roleMenuTreeselect(Request $request){
        $roleId=$request->param('roleId');
        $list=Db::name('dealer_menu')
            ->where('status',0)
            ->where('visible',0)
            ->field('menuId as id,menuName as label,parentId')
            ->select();
        $tree=$this->tree($list,0);
        $checkedKeys=Db::name('role')
            ->where('roleId',$roleId)
            ->value('menuIds');
        $res=[
            'code'=>200,
            'msg'=>'操作成功',
            'menus'=>$tree,
            'checkedKeys'=>explode(",",$checkedKeys)
        ];
        return json($res);
    }

    public function tree($array, $parent_id = 0){
        $tree = [];
        foreach ($array as $k => $v) {
            if ($v['parentId'] == $parent_id) {
                $v['children'] = $this->tree($array, $v['id']);
                $tree[] = $v;
                unset($array[$k]);
            }
        }
        return $tree;
    }
}