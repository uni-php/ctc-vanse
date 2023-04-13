import request from '@/utils/request'
export function getGroupList(query) {
    return request({
      url: '/dealer/access/material/getGroupList',
      method: 'get',
      params: query
    })
}
export function getArticleList(query) {
  return request({
    url: '/dealer/access/material/getArticleList',
    method: 'get',
    params: query
  })
}
export function getArticleInfo(query) {
  return request({
    url: '/dealer/access/material/getArticleInfo',
    method: 'get',
    params: query
  })
}
export function queryGroup(query) {
    return request({
      url: '/dealer/access/material/queryGroup',
      method: 'get',
      params: query
    })
}
export function getImgMaterial(query) {
    return request({
      url: '/dealer/access/material/getImgMaterial',
      method: 'get',
      params: query
    })
}
export function uploadImgMaterial(data) {
    return request({
      url: '/dealer/access/material/uploadImgMaterial',
      method: 'post',
      data
    })
}
export function deleGroup(query) {
    return request({
      url: '/dealer/access/material/deleGroup',
      method: 'get',
      params: query
    })
}
export function deleArticle(query) {
  return request({
    url: '/dealer/access/material/deleArticle',
    method: 'get',
    params: query
  })
}
export function saveGroup(data) {
    return request({
      url: '/dealer/access/material/saveGroup',
      method: 'post',
      data
    })
}
export function saveArticle(data) {
  return request({
    url: '/dealer/access/material/saveArticle',
    method: 'post',
    data
  })
}