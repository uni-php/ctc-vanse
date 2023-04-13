import request from '@/utils/request'
export function getScanNum(query) {
    return request({
      url: '/dealer/app/guide/getScanNum',
      method: 'get',
      params: query
    })
}
export function getGiftsNum(query) {
  return request({
    url: '/dealer/app/guide/getGiftsNum',
    method: 'get',
    params: query
  })
}
export function getScanArea(query) {
  return request({
    url: '/dealer/app/guide/getScanArea',
    method: 'get',
    params: query
  })
}
export function getScanRank(query) {
  return request({
    url: '/dealer/app/guide/getScanRank',
    method: 'get',
    params: query
  })
}
export function getPageData(query) {
  return request({
    url: '/dealer/app/guide/getPageData',
    method: 'get',
    params: query
  })
}

