import request from '@/utils/request'

// 查询菜单列表
export function listMenu(query) {
  return request({
    url: '/main/menu/getMenu',
    method: 'get',
    params: query
  })
}

// 查询菜单详细
export function getMenu(params) {
  return request({
    url: '/main/menu/getMemuItem',
    method: 'get',
    params
  })
}

// 查询菜单下拉树结构
export function treeselect() {
  return request({
    url: '/main/menu/treeselect',
    method: 'get'
  })
}

// 根据角色ID查询菜单下拉树结构
export function roleMenuTreeselect(params) {
  return request({
    url: '/main/menu/roleMenuTreeselect',
    method: 'get',
    params
  })
}

// 新增菜单
export function addMenu(params) {
  return request({
    url: '/main/menu/addMenu',
    method: 'get',
    params
  })
}

// 修改菜单
export function updateMenu(params) {
  return request({
    url: '/main/menu/addMenu',
    method: 'get',
    params
  })
}

// 删除菜单
export function delMenu(menuId) {
  return request({
    url: '/main/menu/delMenu?menuId=' + menuId,
    method: 'delete'
  })
}