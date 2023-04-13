import request from '@/utils/request'
export function taxTplList(query) {
    return request({
      url: '/dealer/system/taxTpl/taxTplList',
      method: 'get',
      params: query
    })
}
export function deleTaxTpl(query) {
    return request({
      url: '/dealer/system/taxTpl/deleTaxTpl',
      method: 'get',
      params: query
    })
}
export function changeTaxTplStatus(query) {
    return request({
      url: '/dealer/system/taxTpl/changeTaxTplStatus',
      method: 'get',
      params: query
    })
}
export function getTaxTpl(query) {
    return request({
      url: '/dealer/system/taxTpl/getTaxTpl',
      method: 'get',
      params: query
    })
}
export function saveTaxTpl(data) {
    return request({
      url: '/dealer/system/taxTpl/saveTaxTpl',
      method: 'post',
      data
    })
  }