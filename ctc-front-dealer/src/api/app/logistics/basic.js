import request from '@/utils/request'
export function getWarehouseList(query) {
    return request({
      url: '/dealer/app/logistics/getWarehouseList',
      method: 'get',
      params: query
    })
}
export function getWarehouseInfo(query) {
    return request({
      url: '/dealer/app/logistics/getWarehouseInfo',
      method: 'get',
      params: query
    })
}
export function deleWarehouse(query) {
    return request({
      url: '/dealer/app/logistics/deleWarehouse',
      method: 'get',
      params: query
    })
}
export function saveWarehouse(data) {
    return request({
      url: '/dealer/app/logistics/saveWarehouse',
      method: 'post',
      data
    })
}
export function getBasicSetInfo(query) {
  return request({
    url: '/dealer/app/logistics/getBasicSetInfo',
    method: 'get',
    params: query
  })
}
export function saveBasicSetInfo(data) {
  return request({
    url: '/dealer/app/logistics/saveBasicSetInfo',
    method: 'post',
    data
  })
}
export function getPageData(query) {
  return request({
    url: '/dealer/app/logistics/getPageData',
    method: 'get',
    params: query
  })
}