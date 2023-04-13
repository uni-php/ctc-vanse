import request from '@/utils/request'
//查询等级列表
export function listLevel(params) {
    return request({
      url: '/main/partner/levelList',
      method: 'get',
      params
    })
}
//新增
export function addLevel(params) {
    return request({
      url: '/main/partner/addLevel',
      method: 'get',
      params
    })
}
export function deleLevel(params) {
    return request({
      url: '/main/partner/deleLevel',
      method: 'get',
      params
    })
}
export function getLevel(params) {
    return request({
      url: '/main/partner/getLevel',
      method: 'get',
      params
    })
}
export function listPartner(params) {
  return request({
    url: '/main/partner/listPartner',
    method: 'get',
    params
  })
}
export function addPartner(params) {
  return request({
    url: '/main/partner/addPartner',
    method: 'get',
    params
  })
}
export function getPartnerInfo(params) {
  return request({
    url: '/main/partner/getPartnerInfo',
    method: 'get',
    params
  })
}
export function resetUserPwd(params) {
  return request({
    url: '/main/partner/resetPartnerPwd',
    method: 'get',
    params
  })
}
export function disableAccount(params) {
  return request({
    url: '/main/partner/disableAccount',
    method: 'get',
    params
  })
}
export function delePartner(params) {
  return request({
    url: '/main/partner/delePartner',
    method: 'get',
    params
  })
}
//认证信息
export function getAuthData(params) {
  return request({
    url: '/main/partner/getAuthData',
    method: 'get',
    params
  })
}
//营业执照审核
export function checkLicense(params) {
  return request({
    url: '/main/partner/checkLicense',
    method: 'get',
    params
  })
}
