import request from '@/utils/request'
// 查询用户列表
export function listUser(query) {
  return request({
    url: '/dealer/system/user/list',
    method: 'get',
    params: query
  })
}

// 查询用户详细
export function getUser(params) {
  return request({
    url: '/dealer/system/user/getUser',
    method: 'get',
    params
  })
}

// 新增用户
export function addUser(params) {
  return request({
    url: '/dealer/system/user/addUser',
    method: 'get',
    params
  })
}

// 修改用户
export function updateUser(params) {
  return request({
    url: '/dealer/system/user/addUser',
    method: 'get',
    params
  })
}

// 删除用户
export function delUser(userId) {
  return request({
    url: '/dealer/system/user/deleUser?ids=' + userId,
    method: 'delete'
  })
}
// 用户状态修改
export function changeUserStatus(params) {
  return request({
    url: '/dealer/system/user/changeStatus',
    method: 'get',
    params
  })
}
// 用户密码重置
export function resetUserPwd(params) {
    return request({
      url: '/dealer/system/user/resetPwd',
      method: 'get',
      params
    })
}

