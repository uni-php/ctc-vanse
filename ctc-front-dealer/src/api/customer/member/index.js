import request from '@/utils/request'
export function getMemberTagList(query) {
    return request({
      url: '/dealer/customer/member/getMemberTagList',
      method: 'get',
      params: query
    })
  }
export function saveMemberTag(data) {
    return request({
      url: '/dealer/customer/member/saveMemberTag',
      method: 'post',
      data
    })
}
export function deleteTag(query) {
    return request({
      url: '/dealer/customer/member/deleteTag',
      method: 'get',
      params: query
    })
}
export function queryTagInfo(query) {
    return request({
      url: '/dealer/customer/member/queryTagInfo',
      method: 'get',
      params: query
    })
}
export function getMemberList(query) {
  return request({
    url: '/dealer/customer/member/getMemberList',
    method: 'get',
    params: query
  })
}
export function batchUnTagging(query) {
  return request({
    url: '/dealer/customer/member/batchUnTagging',
    method: 'get',
    params: query
  })
}
export function batchTagging(query) {
  return request({
    url: '/dealer/customer/member/batchTagging',
    method: 'get',
    params: query
  })
}
export function addPoints(query) {
  return request({
    url: '/dealer/customer/member/addPoints',
    method: 'get',
    params: query
  })
}
export function getAssetsList(query) {
  return request({
    url: '/dealer/customer/member/getAssetsList',
    method: 'get',
    params: query
  })
}
/**
 * 
 * @param {*} query 
 * @returns 
 * 获取自定义字段列表
 */
export function getFieldList(query) {
  return request({
    url: '/dealer/customer/member/getFieldList',
    method: 'get',
    params: query
  })
}
export function deleField(query) {
  return request({
    url: '/dealer/customer/member/deleField',
    method: 'get',
    params: query
  })
}
export function queryFieldInfo(query) {
  return request({
    url: '/dealer/customer/member/queryFieldInfo',
    method: 'get',
    params: query
  })
}
export function changeFieldStatus(query) {
  return request({
    url: '/dealer/customer/member/changeFieldStatus',
    method: 'get',
    params: query
  })
}
export function saveFiled(data) {
  return request({
    url: '/dealer/customer/member/saveFiled',
    method: 'post',
    data
  })
}