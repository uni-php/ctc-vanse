import request from '@/utils/request'
export function getStoreList(query) {
  return request({
    url: '/dealer/app/store/getStoreList',
    method: 'get',
    params: query
  })
}
export function getStoreInfo(query) {
  return request({
    url: '/dealer/app/store/getStoreInfo',
    method: 'get',
    params: query
  })
}
export function getStoreGoodsClass(query) {
  return request({
    url: '/dealer/app/store/getStoreGoodsClass',
    method: 'get',
    params: query
  })
}
export function deleStoreGoodsClass(query) {
  return request({
    url: '/dealer/app/store/deleStoreGoodsClass',
    method: 'get',
    params: query
  })
}
export function queryStoreGoodsClass(query) {
  return request({
    url: '/dealer/app/store/queryStoreGoodsClass',
    method: 'get',
    params: query
  })
}
export function saveStoreGoodsClass(data) {
  return request({
    url: '/dealer/app/store/saveStoreGoodsClass',
    method: 'post',
    data
  })
}
export function saveStoreAuth(data) {
  return request({
    url: '/dealer/app/store/saveStoreAuth',
    method: 'post',
    data
  })
}
