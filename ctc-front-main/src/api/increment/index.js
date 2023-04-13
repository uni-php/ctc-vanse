import request from '@/utils/request'
export function listServide(params) {
    return request({
      url: '/main/increment/listServide',
      method: 'get',
      params
    })
}
export function saveServide(params) {
  return request({
    url: '/main/increment/saveServide',
    method: 'get',
    params
  })
}
export function getServiceOrder(params) {
  return request({
    url: '/main/increment/getServiceOrder',
    method: 'get',
    params
  })
}
export function deleOrder(params) {
  return request({
    url: '/main/increment/deleOrder',
    method: 'get',
    params
  })
}
export function checkOrder(params) {
  return request({
    url: '/main/increment/checkOrder',
    method: 'get',
    params
  })
}
export function orderInfo(params) {
  return request({
    url: '/main/increment/orderInfo',
    method: 'get',
    params
  })
}