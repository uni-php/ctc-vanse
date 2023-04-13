import request from '@/utils/request'
export function saveSelfGoods(data) {
  return request({
    url: '/dealer/app/store/saveSelfGoods',
    method: 'post',
    data
  })
}
export function getSelfGoodsList(query) {
  return request({
    url: '/dealer/app/store/getSelfGoodsList',
    method: 'get',
    params: query
  })
}
export function querySelfGoodsInfo(query) {
  return request({
    url: '/dealer/app/store/querySelfGoodsInfo',
    method: 'get',
    params: query
  })
}
export function deleSelfGoods(query) {
  return request({
    url: '/dealer/app/store/deleSelfGoods',
    method: 'get',
    params: query
  })
}
