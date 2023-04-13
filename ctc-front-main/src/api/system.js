import request from '@/utils/request'
export function getRouters(params) {
    return request({
      url: '/main/auth/route',
      method: 'get',
      params
    })
  }