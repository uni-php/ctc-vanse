/*
 * @Author: wenhanhan 1196086345@qq.com
 * @Date: 2022-10-01 23:34:40
 * @LastEditors: error: git config user.name && git config user.email & please set dead value or install git
 * @LastEditTime: 2022-11-14 22:50:27
 * @Description: 导购
 */
import request from '@/utils/request'
export function getGuideList(query) {
  return request({
    url: '/dealer/app/guide/getGuideList',
    method: 'get',
    params: query
  })
}
export function getGuideInfo(query) {
  return request({
    url: '/dealer/app/guide/getGuideInfo',
    method: 'get',
    params: query
  })
}
export function saveGuide(data) {
  return request({
      url: '/dealer/app/guide/saveGuide',
      method: 'post',
      data
  })
}
export function delGuide(query) {
  return request({
    url: '/dealer/app/guide/delGuide',
    method: 'get',
    params: query
  })
}
export function checkGuide(query) {
  return request({
    url: '/dealer/app/guide/checkGuide',
    method: 'get',
    params: query
  })
}
