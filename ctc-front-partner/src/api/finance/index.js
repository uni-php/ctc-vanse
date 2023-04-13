import request from '@/utils/request'
export function listFinanceBill(params) {
    return request({
      url: '/partner/finance/listFinanceBill',
      method: 'get',
      params
    })
}
export function listFinanceDealerBill(params) {
    return request({
      url: '/partner/finance/listFinanceDealerBill',
      method: 'get',
      params
    })
}
export function getCashRule(params) {
  return request({
    url: '/partner/finance/getCashRule',
    method: 'get',
    params
  })
}
export function getCashLimitTimes(params) {
  return request({
    url: '/partner/finance/getCashLimitTimes',
    method: 'get',
    params
  })
}
export function cash(data) {
  return request({
    url: '/partner/finance/cash',
    method: 'post',
    data:data
  })
}
export function cashList(params) {
  return request({
    url: '/partner/finance/cashList',
    method: 'get',
    params
  })
}