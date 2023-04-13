import request from '@/utils/request'
export function listCode(params) {
    return request({
      url: '/dealer/codeStore/qrcode/listCode',
      method: 'get',
      params
    })
}
export function getEnableCodes(params) {
  return request({
    url: '/dealer/codeStore/qrcode/getEnableCodes',
    method: 'get',
    params
  })
}
export function saveEnableStatus(data) {
  return request({
    url: '/dealer/codeStore/qrcode/saveEnableStatus',
    method: 'post',
    data:data
  })
}
export function addEnableLog(data) {
  return request({
    url: '/dealer/codeStore/qrcode/addEnableLog',
    method: 'post',
    data:data
  })
}
export function deleEnableLog(params) {
  return request({
    url: '/dealer/codeStore/qrcode/deleEnableLog',
    method: 'get',
    params
  })
}
export function getRelProduct(params) {
  return request({
    url: '/dealer/codeStore/qrcode/getRelProduct',
    method: 'get',
    params
  })
}
export function getProduct(params) {
  return request({
    url: '/dealer/codeStore/qrcode/getProduct',
    method: 'get',
    params
  })
}
export function removeProductRel(params) {
  return request({
    url: '/dealer/codeStore/qrcode/removeProductRel',
    method: 'get',
    params
  })
}
export function deleRelLog(params) {
  return request({
    url: '/dealer/codeStore/qrcode/deleRelLog',
    method: 'get',
    params
  })
}
export function addRelLog(data) {
  return request({
    url: '/dealer/codeStore/qrcode/addRelLog',
    method: 'post',
    data:data
  })
}
export function getCodeBatch(params) {
  return request({
    url: '/dealer/codeStore/qrcode/getCodeBatch',
    method: 'get',
    params
  })
}
/**
 * 查询溯源码生码批次
 * @param {*} params
 * @returns
 */
export function getTraceCodeBatch(params) {
  return request({
    url: '/dealer/codeStore/qrcode/getTraceCodeBatch',
    method: 'get',
    params
  })
}

export function getInvalidCodeList(params) {
  return request({
    url: '/dealer/codeStore/qrcode/getInvalidCodeList',
    method: 'get',
    params
  })
}
export function recoverInvalidCode(params) {
  return request({
    url: '/dealer/codeStore/qrcode/recoverInvalidCode',
    method: 'get',
    params
  })
}
export function saveInvalidCode(data) {
  return request({
    url: '/dealer/codeStore/qrcode/saveInvalidCode',
    method: 'post',
    data:data
  })
}
/**
 * 查询营销码生码批次
 * @param {*} params
 * @returns
 */
 export function getMarketCodeBatch(params) {
  return request({
    url: '/dealer/codeStore/qrcode/getMarketCodeBatch',
    method: 'get',
    params
  })
}
/**
 * 查询导购码生码批次
 */
 export function getGuideCodeBatch(params) {
  return request({
    url: '/dealer/codeStore/qrcode/getGuideCodeBatch',
    method: 'get',
    params
  })
}
