import request from '@/utils/request'
const api = {
	getJsConfig: 'store/getJsConfig',
	checkOrderQrcode: 'store/checkOrderQrcode',
	getCheckLog: 'store/getCheckLog',
}
export function getJsConfig(data) {
  return request.get(api.getJsConfig, data)
}
export function checkOrderQrcode(data) {
  return request.get(api.checkOrderQrcode, data)
}
export function getCheckLog(data) {
  return request.get(api.getCheckLog, data)
}