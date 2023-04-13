import request from '@/utils/request'
export function getDashboardData(query) {
    return request({
      url: '/dealer/index/index/getPageData',
      method: 'get',
      params: query
    })
}