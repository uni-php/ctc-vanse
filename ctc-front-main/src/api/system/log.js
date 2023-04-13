import request from '@/utils/request'
// 登录日志
export function loginList(query) {
    return request({
      url: '/main/log/loginList',
      method: 'get',
      params: query
    })
}
//操作日志
export function operationList(query) {
  return request({
    url: '/main/log/operationList',
    method: 'get',
    params: query
  })
}