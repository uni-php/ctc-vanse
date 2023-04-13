import request from '@/utils/request'
export function getCode(params){
    return request({
      url: '/index/SecurityCode/getCode',
      method: 'get',
      params
    })
}
export function createCode(params){
    return request({
        url: '/index/SecurityCode/createCode',
        method: 'get',
        params
    })
}
export function deleteCode(params){
    return request({
        url: '/index/SecurityCode/deleteCode',
        method: 'get',
        params
    })
}
export function getCodeOrder(params){
    return request({
        url: '/index/SecurityCode/getCodeOrder',
        method: 'get',
        params
    })
}