import request from '@/utils/request'
export function getCustomerAreaList(query) {
    return request({
      url: '/dealer/customer/basics/getCustomerAreaList',
      method: 'get',
      params: query
    })
}
export function queryCustomerArea(query) {
    return request({
      url: '/dealer/customer/basics/queryCustomerArea',
      method: 'get',
      params: query
    })
}
export function saveCustomerArea(data) {
    return request({
      url: '/dealer/customer/basics/saveCustomerArea',
      method: 'post',
      data
    })
}
export function deleCustomerArea(query) {
    return request({
      url: '/dealer/customer/basics/deleCustomerArea',
      method: 'get',
      params: query
    })
}
/**
 * 查询基础设置
 */
 export function queryBasicSetInfo(query) {
  return request({
    url: '/dealer/customer/basics/queryBasicSetInfo',
    method: 'get',
    params: query
  })
}
/**
 * 保存基础配置
 */
 export function saveBasicSetInfo(data) {
  return request({
    url: '/dealer/customer/basics/saveBasicSetInfo',
    method: 'post',
    data
  })
}
/**
 * 查询个人中心设置信息
 */
 export function queryUserSetInfo(query) {
  return request({
    url: '/dealer/customer/basics/queryUserSetInfo',
    method: 'get',
    params: query
  })
}
export function saveUserSetInfo(data) {
  return request({
    url: '/dealer/customer/basics/saveUserSetInfo',
    method: 'post',
    data
  })
}