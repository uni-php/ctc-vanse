import request from '@/utils/request'
const apiUri = {
	getStoreList:'guide/getStoreList',
	getGuideGroupList:'guide/getGuideGroupList',
	saveRegisterInfo:'guide/saveRegisterInfo',
	getAuthInfo:'guide/getAuthInfo',
	getUserInfo:'guide/getUserInfo',
	getUserOpenid:'guide/getUserOpenid',
	getJsConfig:'guide/getJsConfig',
	getTpl:'guide/getTpl',
	getPrize:'guide/getPrize',
	getUserCenterPage:'guide/getUserCenterPage',
	getScanRecords:'guide/getScanRecords',
	getRrizeRecords:'guide/getRrizeRecords',
	getGuideUserInfo:'guide/getGuideUserInfo',
	getGuideGroupInfo:'guide/getGuideGroupInfo',
	getRankList:'guide/getRankList'
}
export function getStoreList(params) {
  return request.get(apiUri.getStoreList,params)
}
export function getGuideGroupList(params) {
  return request.get(apiUri.getGuideGroupList,params)
}
export function saveRegisterInfo(data) {
  return request.post(apiUri.saveRegisterInfo, data)
}
export function getAuthInfo(params) {
  return request.get(apiUri.getAuthInfo,params)
}
export function getUserInfo(params) {
  return request.get(apiUri.getUserInfo,params)
}
export function getUserOpenid(params) {
  return request.get(apiUri.getUserOpenid,params)
}
export function getJsConfig(params) {
  return request.get(apiUri.getJsConfig,params)
}
export function getTpl(params) {
  return request.get(apiUri.getTpl,params)
}
export function getPrize(params) {
  return request.post(apiUri.getPrize,params)
}
export function getUserCenterPage(params) {
  return request.get(apiUri.getUserCenterPage,params)
}
export function getScanRecords(params) {
  return request.get(apiUri.getScanRecords,params)
}
export function getRrizeRecords(params) {
  return request.get(apiUri.getRrizeRecords,params)
}
export function getGuideUserInfo(params) {
  return request.get(apiUri.getGuideUserInfo,params)
}
export function getRankList(params) {
  return request.get(apiUri.getRankList,params)
}
export function getGuideGroupInfo(params) {
  return request.get(apiUri.getGuideGroupInfo,params)
}