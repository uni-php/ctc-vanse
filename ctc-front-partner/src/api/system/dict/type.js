import request from '@/utils/request'
import qs from 'qs';
// 查询字典类型列表
export function listType(query) {
  return request({
    url: '/main/dict/list',
    method: 'get',
    params: query
  })
}

// 查询字典类型详细
export function getType(params) {
  return request({
    url: '/main/dict/getType',
    method: 'get',
    params
  })
}

// 新增字典类型
export function addType(params) {
  return request({
    url: '/main/dict/addType',
    method: 'get',
    params
  })
}

// 修改字典类型
export function updateType(params) {
  return request({
    url: '/main/dict/addType',
    method: 'get',
    params
  })
}

// 删除字典类型
export function delType(dictId) {
  return request({
    url: '/main/dict/deleType?ids=' + dictId,
    method: 'delete'
  })
}

// 刷新字典缓存
export function refreshCache() {
  return request({
    url: '/system/dict/type/refreshCache',
    method: 'delete'
  })
}

// 导出字典类型
export function exportType(query) {
  return request({
    url: '/system/dict/type/export',
    method: 'get',
    params: query
  })
}

// 获取字典选择框列表
export function optionselect() {
  return request({
    url: '/system/dict/type/optionselect',
    method: 'get'
  })
}