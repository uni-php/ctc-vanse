import request from '@/utils/request'
export function getQRCodeList(query) {
    return request({
      url: '/dealer/access/officialAccount/getQRCodeList',
      method: 'get',
      params: query
    })
}
export function changeQRcodeStatus(query) {
  return request({
    url: '/dealer/access/officialAccount/changeQRcodeStatus',
    method: 'get',
    params: query
  })
}
export function deleQRCode(query) {
  return request({
    url: '/dealer/access/officialAccount/deleQRCode',
    method: 'get',
    params: query
  })
}
export function saveQRCode(data) {
    return request({
      url: '/dealer/access/officialAccount/saveQRCode',
      method: 'post',
      data
    })
}
export function saveQRCodeGroup(data) {
    return request({
      url: '/dealer/access/officialAccount/saveQRCodeGroup',
      method: 'post',
      data
    })
}
export function queryQRCode(query) {
    return request({
      url: '/dealer/access/officialAccount/queryQRCode',
      method: 'get',
      params: query
    })
}
export function getQRCodeType(query) {
    return request({
      url: '/dealer/access/officialAccount/getQRCodeType',
      method: 'get',
      params: query
    })
}
export function queryQRCodeGroup(query) {
    return request({
      url: '/dealer/access/officialAccount/queryQRCodeGroup',
      method: 'get',
      params: query
    })
}
export function deleQRCodeGroup(query) {
    return request({
      url: '/dealer/access/officialAccount/deleQRCodeGroup',
      method: 'get',
      params: query
    })
}
export function getUserTags(query) {
    return request({
      url: '/dealer/access/officialAccount/getUserTags',
      method: 'get',
      params: query
    })
}