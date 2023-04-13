import request from '@/utils/request'
export function getNoticeList(query) {
    return request({
      url: '/dealer/customer/notice/getNoticeList',
      method: 'get',
      params: query
    })
}
export function saveNotice(data) {
    return request({
      url: '/dealer/customer/notice/saveNotice',
      method: 'post',
      data
    })
}
export function queryNoticeInfo(query) {
    return request({
      url: '/dealer/customer/notice/queryNoticeInfo',
      method: 'get',
      params: query
    })
}
export function deleNotice(query) {
    return request({
      url: '/dealer/customer/notice/deleNotice',
      method: 'get',
      params: query
    })
}