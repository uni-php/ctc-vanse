import request from '@/utils/request'
export function getStoreOrderList(query) {
  return request({
    url: '/dealer/app/store/getStoreOrderList',
    method: 'get',
    params: query
  })
}
export function markStoreShipment(data) {
  return request({
    url: '/dealer/app/store/markStoreShipment',
    method: 'post',
    data
  })
}

