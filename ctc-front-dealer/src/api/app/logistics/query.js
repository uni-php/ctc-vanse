import request from '@/utils/request'
export function getLogCodeBatch(query) {
    return request({
      url: '/dealer/app/logistics/getLogCodeBatch',
      method: 'get',
      params: query
    })
}
export function queryCodeLink(query) {
    return request({
      url: '/dealer/app/logistics/queryCodeLink',
      method: 'get',
      params: query
    })
}