import request from '@/utils/request'
const apiUri = {
	getVicinityStoreList:'store/getVicinityStoreList',
	getJsConfig:'store/getJsConfig'
}
export function getVicinityStoreList(params) {
  return request.get(apiUri.getVicinityStoreList,params)
}
export function getJsConfig(params) {
  return request.get(apiUri.getJsConfig,params)
}