import request from '@/utils/request'
export function getAuthInfo(query) {
    return request({
      url: '/dealer/access/zan/getAuthInfo',
      method: 'get',
      params: query
    })
}
export function saveAuthInfo(data) {
    return request({
      url: '/dealer/access/zan/saveAuthInfo',
      method: 'post',
      data
    })
}