import request from '@/utils/request'
export function login(params) {
  return request({
    url: '/dealer/login',
    method: 'get',
    params
  })
}

export function getInfo(params) {
  return request({
    url: '/dealer/auth/getUserInfo',
    method: 'get',
    params
  })
}

export function logout(params) {
  return request({
    url: '/dealer/logout',
    method: 'get',
    params
  })
}

export function updatePwd(params) {
  return request({
    url: '/dealer/system/resetPwd',
    method: 'get',
    params
  })
}