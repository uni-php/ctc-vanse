import request from '@/utils/request'
export function saveDistributionSet(data) {
    return request({
      url: '/dealer/app/mall/saveDistributionSet',
      method: 'post',
      data
    })
}
export function getDistributionInfo(query) {
    return request({
      url: '/dealer/app/mall/getDistributionInfo',
      method: 'get',
      params: query
    })
}
export function saveDistributionUser(data) {
    return request({
      url: '/dealer/app/mall/saveDistributionUser',
      method: 'post',
      data
    })
}
export function getDistributionUser(query) {
    return request({
      url: '/dealer/app/mall/getDistributionUser',
      method: 'get',
      params: query
    })
}
/**
 * 
 * @param {*} query 
 * @returns 
 * 分销员列表
 */
export function getFenxiaoyuanList(query) {
    return request({
      url: '/dealer/app/mall/getFenxiaoyuanList',
      method: 'get',
      params: query
    })
}
/**
 * 
 * @param {*} query 
 * @returns
 * 查询分销员下级 
 */
export function getFenxiaoyuanChild(query) {
    return request({
      url: '/dealer/app/mall/getFenxiaoyuanChild',
      method: 'get',
      params: query
    })
}
/**
 * 
 * @param {*} query 
 * @returns 
 * 分销订单
 */
export function getFenxiaoOrderList(query) {
  return request({
    url: '/dealer/app/mall/getFenxiaoOrderList',
    method: 'get',
    params: query
  })
}
/**
 * 
 * @param {*} query 
 * @returns 
 * 分销数据汇总
 */
export function getFenxiaoData(query) {
  return request({
    url: '/dealer/app/mall/getFenxiaoData',
    method: 'get',
    params: query
  })
}
/**
 * 
 * @param {*} query 
 * @returns 
 * 分销提现订单
 */
export function getFenxiaoCashOrder(query) {
  return request({
    url: '/dealer/app/mall/getFenxiaoCashOrder',
    method: 'get',
    params: query
  })
}
/**
 * 
 * @param {*} query 
 * @returns 
 * 通过审核
 */
export function passCashOrder(query) {
  return request({
    url: '/dealer/app/mall/passCashOrder',
    method: 'get',
    params: query
  })
}
export function refuseCashOrder(data) {
  return request({
    url: '/dealer/app/mall/refuseCashOrder',
    method: 'post',
    data
  })
}