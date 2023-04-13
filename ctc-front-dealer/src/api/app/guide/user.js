import request from '@/utils/request'
export function queryUserSetInfo(query) {
  return request({
    url: '/dealer/app/guide/queryUserSetInfo',
    method: 'get',
    params: query
  })
}
export function saveUserSetInfo(data) {
  return request({
      url: '/dealer/app/guide/saveUserSetInfo',
      method: 'post',
      data
  })
}
