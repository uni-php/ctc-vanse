import request from '@/utils/request'
export function saveRedPack(data) {
    return request({
      url: '/dealer/assets/redpack/addRedPack',
      method: 'post',
      data
    })
}
export function getRedPackList(query) {
  return request({
    url: '/dealer/assets/redpack/getRedPackList',
    method: 'get',
    params: query
  })
}
export function queryRedPackInfo(query) {
  return request({
    url: '/dealer/assets/redpack/queryRedPackInfo',
    method: 'get',
    params: query
  })
}
export function setRedPackStatus(query) {
  return request({
    url: '/dealer/assets/redpack/setRedPackStatus',
    method: 'get',
    params: query
  })
}
// 红包池信息
export function getRedpackPoolInfo(query) {
  return request({
    url: '/dealer/assets/redpack/getRedpackPoolInfo',
    method: 'get',
    params: query
  })
}
//红包发放记录
export function getRedpackGrantList(query) {
  return request({
    url: '/dealer/assets/redpack/getRedpackGrantList',
    method: 'get',
    params: query
  })
}
//红包明细
export function getRedpackGrantBill(query) {
  return request({
    url: '/dealer/assets/redpack/getRedpackGrantBill',
    method: 'get',
    params: query
  })
}
