import request from '@/utils/request'
const apiUri = {
  auth: 'qrcode/getAuthInfo',
  getUserInfo:'qrcode/getUserInfo',
  getUserOpenid:'qrcode/getUserOpenid',
  getJsConfig:'qrcode/getJsConfig',
  getTpl:'qrcode/getTpl',
  getPrize:'qrcode/getPrize',
  saveRegisterInfo:'qrcode/saveRegisterInfo',
  getWorkType:'qrcode/getWorkType',
  getOperationCenter:'qrcode/getOperationCenter'
}
// 页面数据
export function getAuthInfo(params) {
  return request.get(apiUri.auth,params)
}
export function getUserInfo(params) {
  return request.get(apiUri.getUserInfo,params)
}
export function getUserOpenid(params) {
  return request.get(apiUri.getUserOpenid,params)
}
export function getJsConfig(data) {
  return request.post(apiUri.getJsConfig,data)
}
export function getTpl(params) {
  return request.get(apiUri.getTpl,params)
}
export function getPrize(data) {
  return request.post(apiUri.getPrize, data)
}
export function saveRegisterInfo(data) {
  return request.post(apiUri.saveRegisterInfo, data)
}
export function getWorkType(params) {
  return request.get(apiUri.getWorkType,params)
}
export function getOperationCenter(params) {
  return request.get(apiUri.getOperationCenter,params)
}