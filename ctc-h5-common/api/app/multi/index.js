import request from '@/utils/request'
const apiUri = {
	getAuthInfo:'multi/getAuthInfo',
	getUserInfo:'multi/getUserInfo',
	getJsConfig:'multi/getJsConfig',
	getTpl:'multi/getTpl',
	getPrize:'multi/getPrize',
	getRedPrize:'multi/getRedPrize',
	getRedTpl:'multi/getRedTpl',
	queryCodeByOrder:'multi/queryCodeByOrder'//根据条码序号查询二维码与批次
}
export function getAuthInfo(params) {
  return request.get(apiUri.getAuthInfo,params)
}
export function getUserInfo(params) {
  return request.get(apiUri.getUserInfo,params)
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
export function getRedPrize(params) {
  return request.post(apiUri.getRedPrize,params)
}
export function getRedTpl(params) {
  return request.get(apiUri.getRedTpl,params)
}
export function queryCodeByOrder(params) {
  return request.get(apiUri.queryCodeByOrder,params)
}