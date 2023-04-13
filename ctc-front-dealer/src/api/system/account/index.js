import request from '@/utils/request'
export function getDealerInfo(query) {
    return request({
      url: '/dealer/system/getDealerInfo',
      method: 'get',
      params: query
    })
}
export function saveDealerInfo(data) {
    return request({
      url: '/dealer/system/saveDealerInfo',
      method: 'post',
      data
    })
}
export function getAuthData(query) {
  return request({
    url: '/dealer/system/getAuthData',
    method: 'get',
    params: query
  })
}
//审核商标状态
export function checkTrademark(data) {
  return request({
    url: '/dealer/system/checkTrademark',
    method: 'post',
    data
  })
}
//营业执照审核
export function checkLicense(data) {
  return request({
    url: '/dealer/system/checkLicense',
    method: 'post',
    data
  })
}