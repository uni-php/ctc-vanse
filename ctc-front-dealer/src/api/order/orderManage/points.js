import request from '@/utils/request'
export function getPointsOrderList(query) {
  return request({
    url: '/dealer/order/orderManage/getPointsOrderList',
    method: 'get',
    params: query
  })
}
/**
 * 标记发货
 * @param {*} query
 * @returns
 */
export function markShipment(data) {
  return request({
    url: '/dealer/order/orderManage/markShipment',
    method: 'post',
    data
  })
}
