import request from '@/utils/request'
export function getAllModule(params) {
    return request({
      url: '/partner/demand/getAllModule',
      method: 'get',
      params
    })
}
export function getDemands(params) {
    return request({
      url: '/partner/demand/getDemands',
      method: 'get',
      params
    })
}
export function getDealer(params) {
  return request({
    url: '/partner/demand/getDealer',
    method: 'get',
    params
  })
}
export function addDemands(data) {
  return request({
    url: '/partner/demand/addDemands',
    method: 'post',
    data:data
  })
}