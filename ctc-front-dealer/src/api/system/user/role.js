import request from '@/utils/request'
// 查询角色列表
export function listRole(query) {
  return request({
    url: '/dealer/system/role/roleList',
    method: 'get',
    params: query
  })
}

// 查询角色详细
export function getRole(params) {
  return request({
    url: '/dealer/system/role/getRole',
    method: 'get',
    params
  })
}

// 新增角色
export function addRole(params) {
  return request({
    url: '/dealer/system/role/addRole',
    method: 'get',
    params
  })
}

// 修改角色
export function updateRole(params) {
  return request({
    url: '/dealer/system/role/addRole',
    method: 'get',
    params
  })
}

// 角色数据权限
export function dataScope(data) {
  return request({
    url: '/dealer/system/role/dataScope',
    method: 'put',
    data: data
  })
}

// 角色状态修改
export function changeRoleStatus(params) {
  return request({
    url: '/dealer/system/role/changeStatus',
    method: 'get',
    params
  })
}

// 删除角色
export function delRole(params) {
  return request({
    url: '/dealer/system/role/deleRole',
    method: 'get',
    params
  })
}

// 导出角色
export function exportRole(query) {
  return request({
    url: '/dealer/system/role/export',
    method: 'get',
    params: query
  })
}


