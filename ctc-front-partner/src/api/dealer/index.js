import request from '@/utils/request'
//查询等级列表
export function listDealer(params) {
    return request({
      url: '/partner/dealer/dealerList',
      method: 'get',
      params
    })
}
export function delDealer(params) {
  return request({
    url: '/partner/dealer/delDealer',
    method: 'get',
    params
  })
}
//禁用
export function cutDealer(params) {
  return request({
    url: '/partner/dealer/cutDealer',
    method: 'get',
    params
  })
}
export function getDealerInfo(params) {
  return request({
    url: '/partner/dealer/getDealerInfo',
    method: 'get',
    params
  })
}
export function getDealerMoreInfo(params) {
  return request({
    url: '/partner/dealer/getDealerMoreInfo',
    method: 'get',
    params
  })
}
export function updateDealer(data) {
  return request({
    url: '/partner/dealer/updateDealer',
    method: 'post',
    data
  })
}
//查询红包池充值记录
export function rechargeLog(params) {
  return request({
    url: '/partner/dealer/rechargeLog',
    method: 'get',
    params
  })
}
//红包池发放记录
export function redPackIssueLog(params) {
  return request({
    url: '/partner/dealer/redPackIssueLog',
    method: 'get',
    params
  })
}
//品牌商认证状态
export function getAuthData(params) {
  return request({
    url: '/partner/dealer/getAuthData',
    method: 'get',
    params
  })
}
//审核商标状态
export function checkTrademark(params) {
  return request({
    url: '/partner/dealer/checkTrademark',
    method: 'get',
    params
  })
}
//营业执照审核
export function checkLicense(params) {
  return request({
    url: '/partner/dealer/checkLicense',
    method: 'get',
    params
  })
}
//防伪认证管理
export function listAuth(params) {
  return request({
    url: '/partner/dealer/listAuth',
    method: 'get',
    params
  })
}
export function getAuthInfo(params) {
  return request({
    url: '/partner/dealer/getAuthInfo',
    method: 'get',
    params
  })
}
export function updateAuthInfo(params) {
  return request({
    url: '/partner/dealer/updateAuthInfo',
    method: 'get',
    params
  })
}
//计算价格
export function calculatePrice(params) {
    return request({
      url: '/partner/dealer/calculatePrice',
      method: 'get',
      params
    })
}
//计算升降服务选择后的价格
export function calculateLiftPrice(data) {
  return request({
    url: '/partner/dealer/calculateLiftPrice',
    method: 'post',
    data
  })
}
//计算升降服务选择后的价格
export function calculateLiftSerPrice(data) {
  return request({
    url: '/partner/dealer/calculateLiftSerPrice',
    method: 'post',
    data
  })
}
//保存升降服务
export function liftingService(data) {
  return request({
    url: '/partner/dealer/liftingService',
    method: 'post',
    data
  })
}
export function addDealer(data) {
    return request({
      url: '/partner/dealer/addDealer',
      method: 'post',
      data
    })
}
//查询品牌商模块
export function getDealerModule(params) {
  return request({
    url: '/partner/dealer/getDealerModule',
    method: 'get',
    params
  })
}
//保存增值服务
export function saveIncrement(data) {
  return request({
    url: '/partner/dealer/saveIncrement',
    method: 'post',
    data
  })
}
//查询续费模块
export function getRenewModule(params) {
  return request({
    url: '/partner/dealer/getRenewModule',
    method: 'get',
    params
  })
}
//品牌商续费
export function renew(params) {
  return request({
    url: '/partner/dealer/renew',
    method: 'get',
    params
  })
}
//保存品牌商模块价格
//品牌商续费
export function saveDealerModulePrice(params) {
  return request({
    url: '/partner/dealer/saveDealerModulePrice',
    method: 'get',
    params
  })
}
export function saveDealerCodePrice(params) {
  return request({
    url: '/partner/dealer/saveDealerCodePrice',
    method: 'get',
    params
  })
}
export function getDealerPrice(params) {
  return request({
    url: '/partner/dealer/getDealerPrice',
    method: 'get',
    params
  })
}
export function saveDealerSerPrice(params) {
  return request({
    url: '/partner/dealer/saveDealerSerPrice',
    method: 'get',
    params
  })
}
