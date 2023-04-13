import request from '@/utils/request'
export function getPointsSetInfo(query) {
    return request({
      url: '/dealer/assets/points/getPointsSetInfo',
      method: 'get',
      params: query
    })
  }
  export function getPointsBill(query) {
    return request({
      url: '/dealer/assets/points/getPointsBill',
      method: 'get',
      params: query
    })
  }
  /**
   * 拉黑用户
   * @param {*} query 
   * @returns 
   */
  export function blockMember(query) {
    return request({
      url: '/dealer/assets/points/blockMember',
      method: 'get',
      params: query
    })
  }
export function savePointsSet(data) {
    return request({
      url: '/dealer/assets/points/savePointsSet',
      method: 'post',
      data
    })
}
export function getMemberInfo(query) {
  return request({
    url: '/dealer/assets/points/getMemberInfo',
    method: 'get',
    params: query
  })
}