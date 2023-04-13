import request from '@/utils/request'
export function getPageData(query) {
  return request({
    url: '/dealer/app/trace/getPageData',
    method: 'get',
    params: query
  })
}
export function getTplList(query) {
    return request({
      url: '/dealer/app/trace/getTplList',
      method: 'get',
      params: query
    })
}
export function getTplInfo(query) {
    return request({
      url: '/dealer/app/trace/getTplInfo',
      method: 'get',
      params: query
    })
}
export function deleTpl(query) {
    return request({
      url: '/dealer/app/trace/deleTpl',
      method: 'get',
      params: query
    })
}
export function saveTraceTpl(data) {
    return request({
        url: '/dealer/app/trace/saveTraceTpl',
        method: 'post',
        data
    })
}
export function getProductBatchList(query) {
    return request({
      url: '/dealer/app/trace/getProductBatchList',
      method: 'get',
      params: query
    })
}
export function getBatchInfo(query) {
  return request({
    url: '/dealer/app/trace/getBatchInfo',
    method: 'get',
    params: query
  })
}
export function deleProductBatch(query) {
  return request({
    url: '/dealer/app/trace/deleProductBatch',
    method: 'get',
    params: query
  })
}
/**
 * 保存生产批次
 * @param {*} data 
 * @returns 
 */
export function saveProductBatch(data) {
    return request({
        url: '/dealer/app/trace/saveProductBatch',
        method: 'post',
        data
    })
}
/**
 * 保存赋码批次
 * @param {*} data 
 * @returns 
 */
export function saveCodebBatch(data) {
  return request({
      url: '/dealer/app/trace/saveCodebBatch',
      method: 'post',
      data
  })
}
export function getCodeBatchList(query) {
  return request({
    url: '/dealer/app/trace/getCodeBatchList',
    method: 'get',
    params: query
  })
}
export function deleCodeBatch(query) {
  return request({
    url: '/dealer/app/trace/deleCodeBatch',
    method: 'get',
    params: query
  })
}
/**
 * 查询产品追溯信息
 * @param {} query 
 * @returns 
 */
export function queryTraceInfo(query) {
  return request({
    url: '/dealer/app/trace/queryTraceInfo',
    method: 'get',
    params: query
  })
}
export function getTraceQueryDetail(query) {
  return request({
    url: '/dealer/app/trace/getTraceQueryDetail',
    method: 'get',
    params: query
  })
}