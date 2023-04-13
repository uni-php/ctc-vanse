import request from '@/utils/request'
export function listAccount(params) {
    return request({
      url: '/main/finance/listAccount',
      method: 'get',
      params
    })
}
export function recharge(params) {
    return request({
      url: '/main/finance/recharge',
      method: 'get',
      params
    })
}
export function rechargeLog(params) {
    return request({
      url: '/main/finance/rechargeLog',
      method: 'get',
      params
    })
}
export function allRechargeLog(params) {
    return request({
      url: '/main/finance/allRechargeLog',
      method: 'get',
      params
    })
}
export function listFinanceBill(params) {
  return request({
    url: '/main/finance/listFinanceBill',
    method: 'get',
    params
  })
}
//提现列表
export function cashList(params) {
  return request({
    url: '/main/finance/cashList',
    method: 'get',
    params
  })
}
//打款
export function cashPayment(params) {
  return request({
    url: '/main/finance/cashPayment',
    method: 'get',
    params
  })
}
export function cashReject(params) {
  return request({
    url: '/main/finance/cashReject',
    method: 'get',
    params
  })
}
export function getCashRule(params) {
  return request({
    url: '/main/finance/getCashRule',
    method: 'get',
    params
  })
}
export function saveCashRule(params) {
  return request({
    url: '/main/finance/saveCashRule',
    method: 'get',
    params
  })
}