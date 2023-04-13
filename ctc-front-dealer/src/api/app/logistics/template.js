import request from '@/utils/request'
export function getTplInfo(query) {
    return request({
      url: '/dealer/app/logistics/getTplInfo',
      method: 'get',
      params: query
    })
}
export function saveTraceTpl(data) {
    return request({
      url: '/dealer/app/logistics/saveTraceTpl',
      method: 'post',
      data
    })
}