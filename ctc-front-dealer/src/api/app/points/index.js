import request from '@/utils/request'
export function getPointsDashboard(query) {
  return request({
    url: '/dealer/app/points/getPointsDashboard',
    method: 'get',
    params: query
  })
}
export function savePointsTpl(data) {
    return request({
        url: '/dealer/app/points/savePointsTpl',
        method: 'post',
        data
    })
}
export function getTplInfo(query) {
    return request({
      url: '/dealer/app/points/getTplInfo',
      method: 'get',
      params: query
    })
}
/**
 * 
 * @param {}} query 
 * @returns
 * 积分规则 
 */
export function getPointsRule(query) {
  return request({
    url: '/dealer/app/points/getPointsRule',
    method: 'get',
    params: query
  })
}
export function savePointsRule(data) {
  return request({
      url: '/dealer/app/points/savePointsRule',
      method: 'post',
      data
  })
}
/**
 * 
 * @param {*} query 
 * @returns 
 * 礼品自定义分类
 */
export function getClassList(query) {
  return request({
    url: '/dealer/app/points/getClassList',
    method: 'get',
    params: query
  })
}
export function getClassLists(query) {
  return request({
    url: '/dealer/app/points/getClassLists',
    method: 'get',
    params: query
  })
}
export function savePointsClass(data) {
  return request({
      url: '/dealer/app/points/savePointsClass',
      method: 'post',
      data
  })
}
export function delePointsClass(query) {
  return request({
    url: '/dealer/app/points/delePointsClass',
    method: 'get',
    params: query
  })
}
export function queryPointsClass(query) {
  return request({
    url: '/dealer/app/points/queryPointsClass',
    method: 'get',
    params: query
  })
}
/**
 * 
 * @param {*} data 
 * @returns 
 * 保存兑换礼品
 */
export function savePointsGift(data) {
  return request({
      url: '/dealer/app/points/savePointsGift',
      method: 'post',
      data
  })
}
export function getPointsGiftList(query) {
  return request({
    url: '/dealer/app/points/getPointsGiftList',
    method: 'get',
    params: query
  })
}
export function cutPointsGift(query) {
  return request({
    url: '/dealer/app/points/cutPointsGift',
    method: 'get',
    params: query
  })
}
export function queryGiftInfo(query) {
  return request({
    url: '/dealer/app/points/queryGiftInfo',
    method: 'get',
    params: query
  })
}
export function queryPointsMallData(query) {
  return request({
    url: '/dealer/app/points/queryPointsMallData',
    method: 'get',
    params: query
  })
}