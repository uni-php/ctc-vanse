import request from '@/utils/request'
export function warehouseList(query) {
    return request({
      url: '/dealer/system/warehouse/warehouseList',
      method: 'get',
      params: query
    })
}
export function getWarehouse(query) {
  return request({
    url: '/dealer/system/warehouse/getWarehouse',
    method: 'get',
    params: query
  })
}
export function changeWarehouseStatus(query) {
  return request({
    url: '/dealer/system/warehouse/changeWarehouseStatus',
    method: 'get',
    params: query
  })
}
export function deleWarehouse(query) {
  return request({
    url: '/dealer/system/warehouse/deleWarehouse',
    method: 'get',
    params: query
  })
}
export function saveWarehouse(data) {
  return request({
    url: '/dealer/system/warehouse/saveWarehouse',
    method: 'post',
    data
  })
}