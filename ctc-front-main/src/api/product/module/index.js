import request from '@/utils/request'
export function listModule(params) {
    return request({
      url: '/main/module/moduleList',
      method: 'get',
      params
    })
}
export function addModule(params) {
    return request({
      url: '/main/module/addModule',
      method: 'get',
      params
    })
}
export function deleModule(params) {
    return request({
      url: '/main/module/deleModule',
      method: 'get',
      params
    })
}
export function getModule(params) {
    return request({
      url: '/main/module/getModule',
      method: 'get',
      params
    })
}