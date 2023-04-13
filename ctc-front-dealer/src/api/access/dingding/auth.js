import request from '@/utils/request'
export function getAuthInfo(query) {
    return request({
      url: '/dealer/access/dingding/getAuthInfo',
      method: 'get',
      params: query
    })
}
export function saveAuthInfo(data) {
    return request({
      url: '/dealer/access/dingding/saveAuthInfo',
      method: 'post',
      data
    })
}