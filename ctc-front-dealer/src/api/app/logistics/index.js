import request from '@/utils/request'
export function createRkCode(query) {
    return request({
      url: '/dealer/app/logistics/createRkCode',
      method: 'get',
      params: query
    })
}
export function createCkCode(query) {
  return request({
    url: '/dealer/app/logistics/createCkCode',
    method: 'get',
    params: query
  })
}
export function getRkOrderList(query) {
    return request({
      url: '/dealer/app/logistics/getRkOrderList',
      method: 'get',
      params: query
    })
}
export function deleRkOrder(query) {
    return request({
      url: '/dealer/app/logistics/deleRkOrder',
      method: 'get',
      params: query
    })
}
export function getRkOrderInfo(query) {
    return request({
      url: '/dealer/app/logistics/getRkOrderInfo',
      method: 'get',
      params: query
    })
}
/**
 * 
 * @param {*} query 
 * @returns 
 * 查询入库物流码明细
 */
export function getCodeList(query) {
  return request({
    url: '/dealer/app/logistics/getCodeList',
    method: 'get',
    params: query
  })
}
export function saveRkOrder(data) {
    return request({
      url: '/dealer/app/logistics/saveRkOrder',
      method: 'post',
      data
    })
}
export function saveCkOrder(data) {
  return request({
    url: '/dealer/app/logistics/saveCkOrder',
    method: 'post',
    data
  })
}
export function getCkOrderList(query) {
  return request({
    url: '/dealer/app/logistics/getCkOrderList',
    method: 'get',
    params: query
  })
}
export function getCkOrderInfo(query) {
  return request({
    url: '/dealer/app/logistics/getCkOrderInfo',
    method: 'get',
    params: query
  })
}
/**
 * 
 * @param {*} data 
 * @returns 
 * 扫码出库
 */
export function saveScanRkOrder(data) {
  return request({
    url: '/dealer/app/logistics/saveScanRkOrder',
    method: 'post',
    data
  })
}
/**
 * 
 * @param {*} data
 * @returns 
 * 一键发货
 */
export function quickDeliver(data) {
  return request({
    url: '/dealer/app/logistics/quickDeliver',
    method: 'post',
    data
  })
}
export function getCkCodeList(query) {
  return request({
    url: '/dealer/app/logistics/getCkCodeList',
    method: 'get',
    params: query
  })
}
export function deleCkOrder(query) {
  return request({
    url: '/dealer/app/logistics/deleCkOrder',
    method: 'get',
    params: query
  })
}
export function finishCkOrder(query) {
  return request({
    url: '/dealer/app/logistics/finishCkOrder',
    method: 'get',
    params: query
  })
}