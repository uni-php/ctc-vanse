import request from '@/utils/request'
export function getStoreTypeList(query) {
    return request({
      url: '/dealer/customer/store/getStoreTypeList',
      method: 'get',
      params: query
    })
}
export function getAvailableStore(query) {
  return request({
    url: '/dealer/customer/store/getAvailableStore',
    method: 'get',
    params: query
  })
}
export function queryStoreTypeInfo(query) {
  return request({
    url: '/dealer/customer/store/queryStoreTypeInfo',
    method: 'get',
    params: query
  })
}
export function deleStoreType(query) {
  return request({
    url: '/dealer/customer/store/deleStoreType',
    method: 'get',
    params: query
  })
}
export function saveStoreType(data) {
  return request({
    url: '/dealer/customer/store/saveStoreType',
    method: 'post',
    data
  })
}
export function getStoreList(query) {
  return request({
    url: '/dealer/customer/store/getStoreList',
    method: 'get',
    params: query
  })
}
export function getStoreInfo(query) {
  return request({
    url: '/dealer/customer/store/getStoreInfo',
    method: 'get',
    params: query
  })
}
export function saveStore(data) {
  return request({
    url: '/dealer/customer/store/saveStore',
    method: 'post',
    data
  })
}
export function deleStore(query) {
  return request({
    url: '/dealer/customer/store/deleStore',
    method: 'get',
    params: query
  })
}
export function changeStoreStatus(query) {
  return request({
    url: '/dealer/customer/store/changeStoreStatus',
    method: 'get',
    params: query
  })
}
/**
 * 店员查询
 */
 export function getStoreClerkList(query) {
  return request({
    url: '/dealer/customer/store/getStoreClerkList',
    method: 'get',
    params: query
  })
}
export function getStoreFinanceBill(query) {
  return request({
    url: '/dealer/customer/store/getStoreFinanceBill',
    method: 'get',
    params: query
  })
}
export function getStoreCashBill(query) {
  return request({
    url: '/dealer/customer/store/getStoreCashBill',
    method: 'get',
    params: query
  })
}
export function getPointsLog(query) {
  return request({
    url: '/dealer/customer/store/getPointsLog',
    method: 'get',
    params: query
  })
}
export function getStoreCashSet(query) {
  return request({
    url: '/dealer/customer/store/getStoreCashSet',
    method: 'get',
    params: query
  })
}
export function saveStoreCashSet(data) {
  return request({
    url: '/dealer/customer/store/saveStoreCashSet',
    method: 'post',
    data
  })
}
/**
 * 
 * @param {*} data 
 * @returns 
 * 门店转账
 */
export function cashStore(data) {
  return request({
    url: '/dealer/customer/store/cashStore',
    method: 'post',
    data
  })
}
export function refuseCashReply(data) {
  return request({
    url: '/dealer/customer/store/refuseCashReply',
    method: 'post',
    data
  })
}
export function deleCashReply(query) {
  return request({
    url: '/dealer/customer/store/deleCashReply',
    method: 'get',
    params: query
  })
}
export function saveStorePoints(data) {
  return request({
    url: '/dealer/customer/store/saveStorePoints',
    method: 'post',
    data
  })
}
export function getStoreById(query) {
  return request({
    url: '/dealer/customer/store/getStoreById',
    method: 'get',
    params: query
  })
}
