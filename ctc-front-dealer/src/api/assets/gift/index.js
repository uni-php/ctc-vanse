import request from '@/utils/request'
export function getGroupList(query) {
    return request({
      url: '/dealer/assets/gift/getGroupList',
      method: 'get',
      params: query
    })
  }
  export function queryGroup(query) {
    return request({
      url: '/dealer/assets/gift/queryGroup',
      method: 'get',
      params: query
    })
  }
  export function deleGroup(query) {
    return request({
      url: '/dealer/assets/gift/deleGroup',
      method: 'get',
      params: query
    })
  }
  export function saveGroup(data) {
    return request({
      url: '/dealer/assets/gift/saveGroup',
      method: 'post',
      data
    })
  }
export function getGiftList(query) {
  return request({
    url: '/dealer/assets/gift/getGiftList',
    method: 'get',
    params: query
  })
}
export function deleGift(query) {
  return request({
    url: '/dealer/assets/gift/deleGift',
    method: 'get',
    params: query
  })
}
export function reductionGift(query) {
  return request({
    url: '/dealer/assets/gift/reductionGift',
    method: 'get',
    params: query
  })
}
export function queryGiftInfo(query) {
  return request({
    url: '/dealer/assets/gift/queryGiftInfo',
    method: 'get',
    params: query
  })
}
export function saveGift(data) {
  return request({
    url: '/dealer/assets/gift/saveGift',
    method: 'post',
    data
  })
}