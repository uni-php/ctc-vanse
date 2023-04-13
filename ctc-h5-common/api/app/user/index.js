import request from '@/utils/request'
const apiUri = {
	getJsConfig:'user/getJsConfig',
	getUserCenterPage:'user/getUserCenterPage',
	getAuthInfo:'user/getAuthInfo',
	getUserInfo:'user/getUserInfo',
	saveUserInfo:'user/saveUserInfo',
	getAuthUserInfo:'user/getAuthUserInfo',
	getUserOpenid:'user/getUserOpenid',
	getRrizeRecords:'user/getRrizeRecords',
	getMemberAddressList:'user/getMemberAddressList',
	queryMemberAddress:'user/queryMemberAddress',
	saveMemberAddress:'user/saveMemberAddress',
	deleMemberAddress:'user/deleMemberAddress',
	setDefaultMemberAddress:'user/setDefaultMemberAddress',
	getMarketingOrderList:'user/getMarketingOrderList',
	registerOrderAddress:'user/registerOrderAddress',
	getOrderDesById:'user/getOrderDesById',
	getLogisticsCompany:'user/getLogisticsCompany',
	receiving:'user/receiving'
}
export function getUserCenterPage(params) {
  return request.get(apiUri.getUserCenterPage,params)
}
export function getJsConfig(params) {
  return request.get(apiUri.getJsConfig,params)
}
export function getAuthInfo(params) {
  return request.get(apiUri.getAuthInfo,params)
}
export function getUserInfo(params) {
  return request.get(apiUri.getUserInfo,params)
}
export function saveUserInfo(params) {
  return request.post(apiUri.saveUserInfo,params)
}
export function getAuthUserInfo(params) {
  return request.get(apiUri.getAuthUserInfo,params)
}
export function getUserOpenid(params) {
  return request.get(apiUri.getUserOpenid,params)
}
export function getRrizeRecords(params) {
  return request.get(apiUri.getRrizeRecords,params)
}
export function getMemberAddressList(params) {
  return request.get(apiUri.getMemberAddressList,params)
}
export function deleMemberAddress(params) {
  return request.get(apiUri.deleMemberAddress,params)
}
export function setDefaultMemberAddress(params) {
  return request.get(apiUri.setDefaultMemberAddress,params)
}
export function queryMemberAddress(params) {
  return request.get(apiUri.queryMemberAddress,params)
}
export function saveMemberAddress(params) {
  return request.post(apiUri.saveMemberAddress,params)
}
export function getMarketingOrderList(params) {
  return request.get(apiUri.getMarketingOrderList,params)
}
export function registerOrderAddress(params) {
  return request.post(apiUri.registerOrderAddress,params)
}
export function getOrderDesById(params) {
  return request.get(apiUri.getOrderDesById,params)
}
export function getLogisticsCompany(params) {
  return request.get(apiUri.getLogisticsCompany,params)
}
export function receiving(params) {
  return request.get(apiUri.receiving,params)
}