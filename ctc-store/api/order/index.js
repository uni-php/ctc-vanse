import request from '@/utils/request'
const api = {
  getMyOrder: 'store/getMyOrder',
  getOrderDesById: 'store/getOrderDesById',
  getUserInfo: 'store/getUserInfo'
}
export function getMyOrder(data) {
  return request.get(api.getMyOrder, data)
}
export function getOrderDesById(data) {
  return request.get(api.getOrderDesById, data)
}
export function getUserInfo(data) {
  return request.get(api.getUserInfo, data)
}