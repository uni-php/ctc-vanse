import request from '@/utils/request'
export function getRouters(params) {
    return request({
      url: '/dealer/auth/route',
      method: 'get',
      params
    })
  }