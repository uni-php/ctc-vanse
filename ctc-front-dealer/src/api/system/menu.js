import request from '@/utils/request'
// 查询菜单下拉树结构
export function treeselect() {
  return request({
    url: '/dealer/system/role/treeselect',
    method: 'get'
  })
}

// 根据角色ID查询菜单下拉树结构
export function roleMenuTreeselect(params) {
  return request({
    url: '/dealer/system/role/roleMenuTreeselect',
    method: 'get',
    params
  })
}


