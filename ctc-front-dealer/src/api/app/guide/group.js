/*
 * @Author: wenhanhan 1196086345@qq.com
 * @Date: 2022-09-18 17:20:22
 * @LastEditors: wenhanhan 1196086345@qq.com
 * @LastEditTime: 2022-10-23 17:09:30
 * @Description: 导购分组
 */
import request from '@/utils/request'
export function getGuideGroupList(query) {
  return request({
    url: '/dealer/app/guide/getGuideGroupList',
    method: 'get',
    params: query
  })
}
export function deleGuideGroup(query) {
  return request({
    url: '/dealer/app/guide/deleGuideGroup',
    method: 'get',
    params: query
  })
}
export function getGuideGroupInfo(query) {
  return request({
    url: '/dealer/app/guide/getGuideGroupInfo',
    method: 'get',
    params: query
  })
}
export function saveGuideGroup(data) {
  return request({
      url: '/dealer/app/guide/saveGuideGroup',
      method: 'post',
      data
  })
}
