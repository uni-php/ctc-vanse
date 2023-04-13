import request from '@/utils/request'
//查询等级列表
export function listSms(params) {
    return request({
      url: '/main/sms/smsList',
      method: 'get',
      params
    })
}
export function addSms(data) {
    return request({
      url: '/main/sms/addSms',
      method: 'post',
      data:data
    })
}
export function deleSms(params) {
    return request({
      url: '/main/sms/deleSms',
      method: 'get',
      params
    })
}
export function getSms(params) {
    return request({
      url: '/main/sms/getSms',
      method: 'get',
      params
    })
}