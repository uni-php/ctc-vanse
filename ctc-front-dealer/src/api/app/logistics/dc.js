import request from '@/utils/request'
export function createDcCode(query) {
    return request({
      url: '/dealer/app/logistics/createDcCode',
      method: 'get',
      params: query
    })
}
export function getDcOrderList(query) {
    return request({
      url: '/dealer/app/logistics/getDcOrderList',
      method: 'get',
      params: query
    })
}
export function getDcOrderInfo(query) {
    return request({
      url: '/dealer/app/logistics/getDcOrderInfo',
      method: 'get',
      params: query
    })
}
export function deleDcOrder(query) {
    return request({
      url: '/dealer/app/logistics/deleDcOrder',
      method: 'get',
      params: query
    })
}
export function saveDcOrder(data) {
    return request({
      url: '/dealer/app/logistics/saveDcOrder',
      method: 'post',
      data
    })
}