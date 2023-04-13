import request from '@/utils/request'
export function listService(params) {
    return request({
      url: '/partner/increment/listService',
      method: 'get',
      params
    })
}
export function saveServide(data) {
  return request({
    url: '/partner/increment/saveServide',
    method: 'post',
    data
  })
}
export function getServiceOrder(params) {
  return request({
    url: '/partner/increment/getServiceOrder',
    method: 'get',
    params
  })
}
export function deleOrder(params) {
  return request({
    url: '/partner/increment/deleOrder',
    method: 'get',
    params
  })
}
export function checkOrder(params) {
  return request({
    url: '/partner/increment/checkOrder',
    method: 'get',
    params
  })
}
export function orderInfo(params) {
  return request({
    url: '/partner/increment/orderInfo',
    method: 'get',
    params
  })
}
// 增值订单详情
export function orderDes(params) {
  return request({
    url: '/partner/increment/orderDes',
    method: 'get',
    params
  })
}