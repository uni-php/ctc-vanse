import request from '@/utils/request'
const api = {
  getStoreGoodsClass: 'store/getStoreGoodsClass',
  getStoreGoods: 'store/getStoreGoods',
  getStoreGoodsInfo:'store/getStoreGoodsInfo',
  saveStoreGoods: 'store/saveStoreGoods',
  getSelfGoods: 'store/getSelfGoods',
  cutSelfGoods: 'store/cutSelfGoods',
  deleSelfGoods: 'store/deleSelfGoods',
}
export function getStoreGoodsClass(data) {
  return request.get(api.getStoreGoodsClass, data)
}
export function getStoreGoods(data) {
  return request.get(api.getStoreGoods, data)
}
export function getStoreGoodsInfo(data) {
  return request.get(api.getStoreGoodsInfo, data)
}
export function saveStoreGoods(data) {
  return request.get(api.saveStoreGoods, data)
}
export function getSelfGoods(data) {
  return request.get(api.getSelfGoods, data)
}
export function cutSelfGoods(data) {
  return request.get(api.cutSelfGoods, data)
}
export function deleSelfGoods(data) {
  return request.get(api.deleSelfGoods, data)
}