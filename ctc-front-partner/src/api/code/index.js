import request from '@/utils/request'
export function listCode(params) {
    return request({
      url: '/partner/securityCode/listCode',
      method: 'get',
      params
    })
}
export function downLoad(params) {
  return request({
    url: '/partner/securityCode/downLoad',
    method: 'get',
    responseType:'blob',
    headers:{ 'Content-Type': 'application/json; application/octet-stream'},
    params
  })
}
//获取秘钥
export function generateKeyPair(params) {
    return request({
      url: '/partner/createKey/generateKeyPair',
      method: 'get',
      params
    })
}
export function createCodes(data) {
    return request({
      url: '/partner/securityCode/createCodes',
      method: 'post',
      data:data
    })
}
//获取启用码段
export function getEnableCodes(params) {
  return request({
    url: '/partner/securityCode/getEnableCodes',
    method: 'get',
    params
  })
}
export function deleEnableLog(params) {
  return request({
    url: '/partner/securityCode/deleEnableLog',
    method: 'get',
    params
  })
}
export function saveEnableStatus(data) {
  return request({
    url: '/partner/securityCode/saveEnableStatus',
    method: 'post',
    data:data
  })
}
export function addEnableLog(data) {
  return request({
    url: '/partner/securityCode/addEnableLog',
    method: 'post',
    data:data
  })
}
/**
 * 
 * @param {*} params 
 * @returns 
 * 查询品牌商商品
 */
export function getProduct(params) {
  return request({
    url: '/partner/securityCode/getProduct',
    method: 'get',
    params
  })
}
export function getRelProduct(params) {
  return request({
    url: '/partner/securityCode/getRelProduct',
    method: 'get',
    params
  })
}
export function addRelLog(data) {
  return request({
    url: '/partner/securityCode/addRelLog',
    method: 'post',
    data:data
  })
}
export function deleRelLog(params) {
  return request({
    url: '/partner/securityCode/deleRelLog',
    method: 'get',
    params
  })
}
//清除关联
export function removeProductRel(params) {
  return request({
    url: '/partner/securityCode/removeProductRel',
    method: 'get',
    params
  })
}
export function queryDealerCodeBatch(params) {
  return request({
    url: '/partner/securityCode/queryDealerCodeBatch',
    method: 'get',
    params
  })
}
/**
 * 查询品牌商生码起始号段
 * @param {*} params 
 * @returns 
 */
export function getCodeBeginOrder(params) {
  return request({
    url: '/partner/securityCode/getCodeBeginOrder',
    method: 'get',
    params
  })
}
/**
 * 生码价格查询
 * @param {*} params 
 * @returns 
 */
export function getCreateCodePrice(params) {
  return request({
    url: '/partner/securityCode/getCreateCodePrice',
    method: 'get',
    params
  })
}

