import request from '@/utils/request'
export function saveGroup(data) {
    return request({
      url: '/dealer/assets/material/saveGroup',
      method: 'post',
      data
    })
}
export function getImgMaterial(query) {
  return request({
    url: '/dealer/assets/material/getImgMaterial',
    method: 'get',
    params: query
  })
}
export function uploadImgMaterial(data) {
  return request({
    url: '/dealer/assets/material/uploadImgMaterial',
    method: 'post',
    data
  })
}
export function getGroupList(query) {
  return request({
    url: '/dealer/assets/material/getGroupList',
    method: 'get',
    params: query
  })
}
export function deleGroup(query) {
  return request({
    url: '/dealer/assets/material/deleGroup',
    method: 'get',
    params: query
  })
}
export function changeGroup(data) {
  return request({
    url: '/dealer/assets/material/changeGroup',
    method: 'post',
    data
  })
}
export function deleImg(query) {
  return request({
    url: '/dealer/assets/material/deleImg',
    method: 'get',
    params: query
  })
}
export function queryGroup(query) {
  return request({
    url: '/dealer/assets/material/queryGroup',
    method: 'get',
    params: query
  })
}