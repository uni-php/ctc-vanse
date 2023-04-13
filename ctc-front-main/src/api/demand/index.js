import request from '@/utils/request'
export function getAllModule(params) {
    return request({
      url: '/main/demand/getAllModule',
      method: 'get',
      params
    })
}
export function getDemands(params) {
    return request({
      url: '/main/demand/getDemands',
      method: 'get',
      params
    })
}
export function checkDemand(params) {
  return request({
    url: '/main/demand/checkDemand',
    method: 'get',
    params
  })
}