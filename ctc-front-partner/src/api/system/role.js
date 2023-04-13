import request from '@/utils/request'

// 查询角色列表
export function listRole(query) {
  return request({
    url: '/main/role/list',
    method: 'get',
    params: query
  })
}

// 查询角色详细
export function getRole(params) {
  return request({
    url: '/main/role/getRole',
    method: 'get',
    params
  })
}

// 新增角色
export function addRole(params) {
  return request({
    url: '/main/role/addRole',
    method: 'get',
    params
  })
}

// 修改角色
export function updateRole(params) {
  return request({
    url: '/main/role/addRole',
    method: 'get',
    params
  })
}

// 角色数据权限
export function dataScope(data) {
  return request({
    url: '/system/role/dataScope',
    method: 'put',
    data: data
  })
}

// 角色状态修改
export function changeRoleStatus(params) {
  return request({
    url: '/main/role/changeStatus',
    method: 'get',
    params
  })
}

// 删除角色
export function delRole(params) {
  return request({
    url: '/main/role/deleRole',
    method: 'get',
    params
  })
}

// 导出角色
export function exportRole(query) {
  return request({
    url: '/system/role/export',
    method: 'get',
    params: query
  })
}

// 查询角色已授权用户列表
export function allocatedUserList(query) {
  return request({
    url: '/system/role/authUser/allocatedList',
    method: 'get',
    params: query
  })
}

// 查询角色未授权用户列表
export function unallocatedUserList(query) {
  return request({
    url: '/system/role/authUser/unallocatedList',
    method: 'get',
    params: query
  })
}

// 取消用户授权角色
export function authUserCancel(data) {
  return request({
    url: '/system/role/authUser/cancel',
    method: 'put',
    data: data
  })
}

// 批量取消用户授权角色
export function authUserCancelAll(data) {
  return request({
    url: '/system/role/authUser/cancelAll',
    method: 'put',
    params: data
  })
}

// 授权用户选择
export function authUserSelectAll(data) {
  return request({
    url: '/system/role/authUser/selectAll',
    method: 'put',
    params: data
  })
}