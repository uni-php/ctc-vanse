import request from '@/utils/request'
export function getScanNum(query) {
    return request({
      url: '/dealer/app/qrcode/getScanNum',
      method: 'get',
      params: query
    })
}
export function getScanArea(query) {
  return request({
    url: '/dealer/app/qrcode/getScanArea',
    method: 'get',
    params: query
  })
}
export function getScanUser(query) {
  return request({
    url: '/dealer/app/qrcode/getScanUser',
    method: 'get',
    params: query
  })
}
export function getPageData(query) {
  return request({
    url: '/dealer/app/qrcode/getPageData',
    method: 'get',
    params: query
  })
}