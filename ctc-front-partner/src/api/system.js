import request from '@/utils/request'
export function getRouters(params) {
    return request({
      url: '/partner/auth/route',
      method: 'get',
      params
    })
  }
  export function updatePwd(params) {
    return request({
      url: '/partner/system/resetPwd',
      method: 'get',
      params
    })
  }