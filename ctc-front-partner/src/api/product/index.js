import request from '@/utils/request'
export function getModule(params) {
    return request({
      url: '/partner/product/getModule',
      method: 'get',
      params
    })
}
export function setModulePrice(params) {
    return request({
      url: '/partner/product/setModulePrice',
      method: 'get',
      params
    })
}
export function getCodeList(params) {
    return request({
      url: '/partner/product/getCodeList',
      method: 'get',
      params
    })
}
export function getServer(params) {
    return request({
      url: '/partner/product/getServer',
      method: 'get',
      params
    })
}
export function addServer(params) {
    return request({
      url: '/partner/product/addServer',
      method: 'get',
      params
    })
}
export function addCodePrice(params) {
    return request({
      url: '/partner/product/addCodePrice',
      method: 'get',
      params
    })
}
