import request from '@/utils/request'
export function getDistributorLevelList(query) {
    return request({
      url: '/dealer/customer/distributor/getDistributorLevelList',
      method: 'get',
      params: query
    })
}
export function queryDistributorLevelInfo(query) {
    return request({
      url: '/dealer/customer/distributor/queryDistributorLevelInfo',
      method: 'get',
      params: query
    })
}
export function deleDistributorLevel(query) {
  return request({
    url: '/dealer/customer/distributor/deleDistributorLevel',
    method: 'get',
    params: query
  })
}
export function saveDistributorLevel(data) {
    return request({
      url: '/dealer/customer/distributor/saveDistributorLevel',
      method: 'post',
      data
    })
}
export function importDistributorTemplate() {
  return request({
    url: '/dealer/customer/distributor/importDistributorTemplate',
    method: 'get',
    responseType:'blob'
  })
}
export function saveDistributor(data) {
  return request({
    url: '/dealer/customer/distributor/saveDistributor',
    method: 'post',
    data
  })
}
/**
 * 查询上级经销商
 * @param {*} query 
 * @returns 
 */
export function getSuperiorDistributorList(query) {
  return request({
    url: '/dealer/customer/distributor/getSuperiorDistributorList',
    method: 'get',
    params: query
  })
}
export function getDistributorList(query) {
  return request({
    url: '/dealer/customer/distributor/getDistributorList',
    method: 'get',
    params: query
  })
}
/**
 * 查询可充值的经销商 直属总部
 * @param {*} query 
 * @returns 
 */
export function getRechargeDistributorList(query) {
  return request({
    url: '/dealer/customer/distributor/getRechargeDistributorList',
    method: 'get',
    params: query
  })
}
export function changeDistributorBalance(data) {
  return request({
    url: '/dealer/customer/distributor/changeDistributorBalance',
    method: 'post',
    data
  })
}
export function getDistributorBillLog(query) {
  return request({
    url: '/dealer/customer/distributor/getDistributorBillLog',
    method: 'get',
    params: query
  })
}
export function getAllSuperiorDistributorList(query) {
  return request({
    url: '/dealer/customer/distributor/getAllSuperiorDistributorList',
    method: 'get',
    params: query
  })
}
export function deleDistributor(query) {
  return request({
    url: '/dealer/customer/distributor/deleDistributor',
    method: 'get',
    params: query
  })
}
export function cutDistributor(query) {
  return request({
    url: '/dealer/customer/distributor/cutDistributor',
    method: 'get',
    params: query
  })
}
export function getDistributorInfo(query) {
  return request({
    url: '/dealer/customer/distributor/getDistributorInfo',
    method: 'get',
    params: query
  })
}
/**
 * 邀请注册设置
 */
 export function queryRegisterConfig(query) {
    return request({
      url: '/dealer/customer/distributor/queryRegisterConfig',
      method: 'get',
      params: query
    })
}
export function saveRegisterConfig(data) {
    return request({
      url: '/dealer/customer/distributor/saveRegisterConfig',
      method: 'post',
      data
    })
}
/**
 * 
 * @param {*} query 
 * @returns 
 * 添加业务员 可选经销商
 */
export function getAvailableDistributor(query) {
  return request({
    url: '/dealer/customer/distributor/getAvailableDistributor',
    method: 'get',
    params: query
  })
}
export function getDistributorById(query) {
  return request({
    url: '/dealer/customer/distributor/getDistributorById',
    method: 'get',
    params: query
  })
}