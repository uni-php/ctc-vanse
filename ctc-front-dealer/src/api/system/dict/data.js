import request from '@/utils/request'

// 查询字典数据列表
export function listData(params) {
  return request({
    url: '/main/dict/dictData',
    method: 'get',
    params
  })
}

// 查询字典数据详细
export function getData(params) {
  return request({
    url: '/main/dict/getDictData',
    method: 'get',
    params
  })
}

// 根据字典类型查询字典数据信息
export function getDicts(params) {
  return request({
    url: '/main/dict/dictByType',
    method: 'get',
    params
  })
}

// 新增字典数据
export function addData(params) {
  return request({
    url: '/main/dict/addDictData',
    method: 'get',
    params
  })
}

// 修改字典数据
export function updateData(params) {
  return request({
    url: '/main/dict/addDictData',
    method: 'get',
    params
  })
}

// 删除字典数据
export function delData(dictCode) {
  return request({
    url: '/main/dict/deleDictData?ids=' + dictCode,
    method: 'delete'
  })
}

// 导出字典数据
export function exportData(query) {
  return request({
    url: '/system/dict/data/export',
    method: 'get',
    params: query
  })
}