import request from '@/utils/request'
export function saveProductClass(data) {
    return request({
      url: '/dealer/assets/product/saveProductClass',
      method: 'post',
      data
    })
}
export function getClassList(query) {
    return request({
      url: '/dealer/assets/product/getClassList',
      method: 'get',
      params: query
    })
}
export function saveProduct(data) {
  return request({
    url: '/dealer/assets/product/saveProduct',
    method: 'post',
    data
  })
}
export function queryProductClass(query) {
    return request({
      url: '/dealer/assets/product/queryProductClass',
      method: 'get',
      params: query
    })
}
export function queryProductInfo(query) {
  return request({
    url: '/dealer/assets/product/queryProductInfo',
    method: 'get',
    params: query
  })
}
export function deleProduct(query) {
  return request({
    url: '/dealer/assets/product/deleProduct',
    method: 'get',
    params: query
  })
}
// 下载产品导入模板
export function importTemplate() {
  return request({
    url: '/dealer/assets/product/importTemplate',
    method: 'get',
    responseType:'blob'
  })
}
export function getProductList(query) {
  return request({
    url: '/dealer/assets/product/getProductList',
    method: 'get',
    params: query
  })
}
export function reductionProduct(query) {
  return request({
    url: '/dealer/assets/product/reductionProduct',
    method: 'get',
    params: query
  })
}
export function deleProductClass(query) {
    return request({
      url: '/dealer/assets/product/deleProductClass',
      method: 'get',
      params: query
    })
}