import request from '@/utils/request'
export function saveBlackListSet(data) {
  return request({
    url: '/dealer/codeStore/blackList/saveBlackListSet',
    method: 'post',
    data:data
  })
}
export function getBlackListSet(params) {
  return request({
    url: '/dealer/codeStore/blackList/getBlackListSet',
    method: 'get',
    params
  })
}
export function getBlackList(params) {
  return request({
    url: '/dealer/codeStore/blackList/getBlackList',
    method: 'get',
    params
  })
}
export function revokeBlackList(params) {
  return request({
    url: '/dealer/codeStore/blackList/revokeBlackList',
    method: 'get',
    params
  })
}
export function saveBlackList(data) {
  return request({
    url: '/dealer/codeStore/blackList/saveBlackList',
    method: 'post',
    data:data
  })
}