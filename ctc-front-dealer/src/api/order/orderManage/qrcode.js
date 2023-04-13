import request from '@/utils/request'
export function getMarketingOrderList(query) {
  return request({
    url: '/dealer/order/orderManage/getMarketingOrderList',
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
    url: '/dealer/order/orderManage/markQrcodeShipment',
    method: 'post',
    data
  })
}
