import request from '@/utils/request'
export function login(params) {
  return request({
    url: '/partner/login',
    method: 'get',
    params
  })
}

export function getInfo(params) {
  return request({
    url: '/partner/auth/getUserInfo',
    method: 'get',
    params
  })
}

export function logout(params) {
  return request({
    url: '/partner/logout',
    method: 'get',
    params
  })
}
export function listLevel(params) {
  return request({
    url: '/partner/auth/listLevel',
    method: 'get',
    params
  })
}

