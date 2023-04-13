import request from '@/utils/request'
export function login(params) {
  return request({
    url: '/login',
    method: 'get',
    params
  })
}

export function getInfo(params) {
  return request({
    url: '/main/auth/getUserInfo',
    method: 'get',
    params
  })
}

export function logout(params) {
  return request({
    url: '/logout',
    method: 'get',
    params
  })
}
