import request from '@/utils/request'
//查询等级列表
export function listDealer(params) {
    return request({
      url: '/main/dealer/dealerList',
      method: 'get',
      params
    })
}
export function delDealer(params) {
  return request({
    url: '/main/dealer/delDealer',
    method: 'get',
    params
  })
}
//禁用
export function cutDealer(params) {
  return request({
    url: '/main/dealer/cutDealer',
    method: 'get',
    params
  })
}
export function getDealerInfo(params) {
  return request({
    url: '/main/dealer/getDealerInfo',
    method: 'get',
    params
  })
}
export function getDealerMoreInfo(params) {
  return request({
    url: '/main/dealer/getDealerMoreInfo',
    method: 'get',
    params
  })
}
export function rechargeDealer(params) {
  return request({
    url: '/main/dealer/rechargeDealer',
    method: 'get',
    params
  })
}
//查询红包池充值记录
export function rechargeLog(params) {
  return request({
    url: '/main/dealer/rechargeLog',
    method: 'get',
    params
  })
}
//红包池发放记录
export function redPackIssueLog(params) {
  return request({
    url: '/main/dealer/redPackIssueLog',
    method: 'get',
    params
  })
}
//品牌商认证状态
export function getAuthData(params) {
  return request({
    url: '/main/dealer/getAuthData',
    method: 'get',
    params
  })
}
//审核商标状态
export function checkTrademark(params) {
  return request({
    url: '/main/dealer/checkTrademark',
    method: 'get',
    params
  })
}
//营业执照审核
export function checkLicense(params) {
  return request({
    url: '/main/dealer/checkLicense',
    method: 'get',
    params
  })
}
//防伪认证管理
export function listAuth(params) {
  return request({
    url: '/main/dealer/listAuth',
    method: 'get',
    params
  })
}
export function getAuthInfo(params) {
  return request({
    url: '/main/dealer/getAuthInfo',
    method: 'get',
    params
  })
}
export function updateAuthInfo(params) {
  return request({
    url: '/main/dealer/updateAuthInfo',
    method: 'get',
    params
  })
}