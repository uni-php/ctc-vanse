import request from '@/utils/request'
export function listCode(params) {
    return request({
      url: '/main/securityCode/listCode',
      method: 'get',
      params
    })
}
export function listWaitCode(params) {
    return request({
      url: '/main/securityCode/listWaitCode',
      method: 'get',
      params
    })
}
export function getRelProduct(params) {
  return request({
    url: '/main/securityCode/getRelProduct',
    method: 'get',
    params
  })
}
/**
 * 
 * @param {*} params 
 * @returns 
 * 审核码包
 */
export function checkCode(params) {
  return request({
    url: '/main/securityCode/checkCode',
    method: 'get',
    params
  })
}
export function downLoad(params) {
  return request({
    url: '/main/securityCode/downLoad',
    method: 'get',
    responseType:'blob',
    headers:{ 'Content-Type': 'application/json; application/octet-stream'},
    params
  })
}
export function deleCode(params) {
    return request({
      url: '/main/securityCode/deleCode',
      method: 'get',
      params
    })
}