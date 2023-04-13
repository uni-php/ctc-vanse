import request from '@/utils/request'
export function getLogList(query) {
    return request({
      url: '/dealer/assets/sms/getLogList',
      method: 'get',
      params: query
    })
  }
export function getSmsPrice(query) {
    return request({
        url: '/dealer/assets/sms/getSmsPrice',
        method: 'get',
        params: query
    })
}
export function getSmsInfo(query) {
    return request({
        url: '/dealer/assets/sms/getSmsInfo',
        method: 'get',
        params: query
    })
}
export function getPayLog(query) {
    return request({
        url: '/dealer/assets/sms/getPayLog',
        method: 'get',
        params: query
    })
}
export function queryPayStatus(query) {
    return request({
        url: '/dealer/assets/sms/queryPayStatus',
        method: 'get',
        params: query
    })
}
export function saveSmsWarning(data) {
    return request({
        url: '/dealer/assets/sms/saveSmsWarning',
        method: 'post',
        data
    })
}
export function smsPay(data) {
    return request({
        url: '/dealer/assets/sms/smsPay',
        method: 'post',
        data
    })
}