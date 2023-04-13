import request from '@/utils/request'
export function getAuthConfig(query) {
    return request({
      url: '/dealer/access/officialAccount/getAuthConfig',
      method: 'get',
      params: query
    })
}
export function saveAuthConfig(data) {
    return request({
      url: '/dealer/access/officialAccount/saveAuthConfig',
      method: 'post',
      data
    })
}
/**
 * 
 * @param {*} data 
 * @returns 
 * 保存授权信息
 */
export function saveAuthInfo(data) {
  return request({
    url: '/dealer/access/officialAccount/saveAuthInfo',
    method: 'post',
    data
  })
}