import request from '@/utils/request'
export function getTplList(query) {
  return request({
    url: '/dealer/app/guide/getTplList',
    method: 'get',
    params: query
  })
}
export function getTplInfo(query) {
  return request({
    url: '/dealer/app/guide/getTplInfo',
    method: 'get',
    params: query
  })
}
export function saveScanTpl(data) {
  return request({
    url: '/dealer/app/guide/saveScanTpl',
    method: 'post',
    data
  })
}
export function getActivityList(query) {
  return request({
    url: '/dealer/app/guide/getActivityList',
    method: 'get',
    params: query
  })
}
export function getActivityInfo(query) {
  return request({
    url: '/dealer/app/guide/getActivityInfo',
    method: 'get',
    params: query
  })
}
export function setActivityStatus(query) {
  return request({
    url: '/dealer/app/guide/setActivityStatus',
    method: 'get',
    params: query
  })
}
export function deleActivity(query) {
  return request({
    url: '/dealer/app/guide/deleActivity',
    method: 'get',
    params: query
  })
}
export function saveActivity(data) {
  return request({
    url: '/dealer/app/guide/saveActivity',
    method: 'post',
    data
  })
}
export function getScanBill(query) {
  return request({
    url: '/dealer/app/guide/getScanBill',
    method: 'get',
    params: query
  })
}
export function getPrizeLog(query) {
  return request({
    url: '/dealer/app/guide/getPrizeLog',
    method: 'get',
    params: query
  })
}
