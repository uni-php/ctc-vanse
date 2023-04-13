import request from '@/utils/request'
export function getThOrderList(query) {
    return request({
      url: '/dealer/app/logistics/getThOrderList',
      method: 'get',
      params: query
    })
}
export function getThOrderInfo(query) {
  return request({
    url: '/dealer/app/logistics/getThOrderInfo',
    method: 'get',
    params: query
  })
}
export function deleThOrder(query) {
  return request({
    url: '/dealer/app/logistics/deleThOrder',
    method: 'get',
    params: query
  })
}
export function checkThOrder(data) {
  return request({
    url: '/dealer/app/logistics/checkThOrder',
    method: 'post',
    data
  })
}
export function getThCodeList(query) {
  return request({
    url: '/dealer/app/logistics/getThCodeList',
    method: 'get',
    params: query
  })
}
export function saveExpressOrder(data) {
  return request({
    url: '/dealer/app/logistics/saveExpressOrder',
    method: 'post',
    data
  })
}