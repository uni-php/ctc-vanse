import request from '@/utils/request'
export function listCode(params) {
    return request({
      url: '/main/code/codeList',
      method: 'get',
      params
    })
}
export function addCode(params) {
    return request({
      url: '/main/code/addCode',
      method: 'get',
      params
    })
}
export function deleCode(params) {
    return request({
      url: '/main/code/deleCode',
      method: 'get',
      params
    })
}
export function getCode(params) {
    return request({
      url: '/main/code/getCode',
      method: 'get',
      params
    })
}