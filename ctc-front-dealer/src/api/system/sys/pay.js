import request from '@/utils/request'
export function savePayInfo(data) {
    return request({
      url: '/dealer/system/payment/savePayInfo',
      method: 'post',
      data
    })
}
export function getPayInfo(query) {
    return request({
      url: '/dealer/system/payment/getPayInfo',
      method: 'get',
      params: query
    })
}