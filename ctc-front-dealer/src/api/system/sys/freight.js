import request from '@/utils/request'
// 保存运费模板
export function saveFreightTpl(data) {
    return request({
      url: '/dealer/system/freight/saveTpl',
      method: 'post',
      data
    })
}
export function getTpl(query) {
    return request({
      url: '/dealer/system/freight/getTpl',
      method: 'get',
      params: query
    })
}
export function deleTpl(query) {
    return request({
      url: '/dealer/system/freight/deleTpl',
      method: 'get',
      params: query
    })
}
export function queryTpl(query) {
    return request({
      url: '/dealer/system/freight/queryTpl',
      method: 'get',
      params: query
    })
}