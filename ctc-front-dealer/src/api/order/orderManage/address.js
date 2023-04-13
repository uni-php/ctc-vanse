import request from '@/utils/request'
export function getAddressInfo(query) {
  return request({
    url: '/dealer/order/orderManage/getAddressInfo',
    method: 'get',
    params: query
  })
}
