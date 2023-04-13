import request from '@/utils/request'
export function getChOrderList(query) {
    return request({
      url: '/dealer/app/logistics/getChOrderList',
      method: 'get',
      params: query
    })
}
export function getChOrderBill(query) {
    return request({
      url: '/dealer/app/logistics/getChOrderBill',
      method: 'get',
      params: query
    })
}
export function getBillDes(query) {
    return request({
      url: '/dealer/app/logistics/getBillDes',
      method: 'get',
      params: query
    })
}