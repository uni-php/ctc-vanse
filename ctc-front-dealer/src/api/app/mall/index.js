import request from '@/utils/request'
export function getMallDashboard(query) {
  return request({
    url: '/dealer/app/mall/getMallDashboard',
    method: 'get',
    params: query
  })
}
export function saveMallTpl(data) {
    return request({
        url: '/dealer/app/mall/saveMallTpl',
        method: 'post',
        data
    })
}
export function getTplInfo(query) {
    return request({
      url: '/dealer/app/mall/getTplInfo',
      method: 'get',
      params: query
    })
}
export function saveProductClass(data) {
    return request({
      url: '/dealer/app/mall/saveProductClass',
      method: 'post',
      data
    })
}
export function getClassList(query) {
    return request({
      url: '/dealer/app/mall/getClassList',
      method: 'get',
      params: query
    })
}
export function getClassLists(query) {
    return request({
      url: '/dealer/app/mall/getClassLists',
      method: 'get',
      params: query
    })
}
export function queryProductClass(query) {
    return request({
      url: '/dealer/app/mall/queryProductClass',
      method: 'get',
      params: query
    })
}
export function deleProductClass(query) {
    return request({
      url: '/dealer/app/mall/deleProductClass',
      method: 'get',
      params: query
    })
}
export function saveGoods(data) {
    return request({
        url: '/dealer/app/mall/saveGoods',
        method: 'post',
        data
    })
}
export function getGoodsList(query) {
    return request({
      url: '/dealer/app/mall/getGoodsList',
      method: 'get',
      params: query
    })
}
export function cutGoods(query) {
    return request({
      url: '/dealer/app/mall/cutGoods',
      method: 'get',
      params: query
    })
}
export function upGoods(query) {
    return request({
      url: '/dealer/app/mall/upGoods',
      method: 'get',
      params: query
    })
}
export function queryGoodsInfo(query) {
    return request({
      url: '/dealer/app/mall/queryGoodsInfo',
      method: 'get',
      params: query
    })
}
export function getGoodsJudge(query) {
  return request({
    url: '/dealer/app/mall/getGoodsJudge',
    method: 'get',
    params: query
  })
}
export function deleJudge(query) {
  return request({
    url: '/dealer/app/mall/deleJudge',
    method: 'get',
    params: query
  })
}
export function saveJudge(data) {
  return request({
    url: '/dealer/app/mall/saveJudge',
    method: 'post',
    data
  })
}