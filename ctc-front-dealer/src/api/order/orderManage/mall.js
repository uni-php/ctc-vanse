import request from '@/utils/request'
export function getMallOrderList(query) {
  return request({
    url: '/dealer/order/orderManage/getMallOrderList',
    method: 'get',
    params: query
  })
}
/**
 * 标记发货
 * @param {*} query
 * @returns
 */
export function markMallShipment(data) {
  return request({
    url: '/dealer/order/orderManage/markMallShipment',
    method: 'post',
    data
  })
}
