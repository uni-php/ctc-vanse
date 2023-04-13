import request from '@/utils/request'
const apiUri = {
	getAuthInfo: 'store_shop/getAuthInfo',
	getAuthUserInfo: 'store_shop/getAuthUserInfo',
	getJsConfig: 'store_shop/getJsConfig',
	getStoreGoodsClass: 'store_shop/getStoreGoodsClass',
	getStoreGoods: 'store_shop/getStoreGoods',
	getStoreInfo: 'store_shop/getStoreInfo',
	getGoodsInfo: 'store_shop/getGoodsInfo',
	getMemberAddressList: 'store_shop/getMemberAddressList',
	queryMemberAddress: 'store_shop/queryMemberAddress',
	saveMemberAddress: 'store_shop/saveMemberAddress',
	addCart: 'store_shop/addCart',
	getCartList: 'store_shop/getCartList',
	updateCart: 'store_shop/updateCart',
	clearCart: 'store_shop/clearCart',
	getUserInfo: 'store_shop/getUserInfo',
	getOrderInfo: 'store_shop/getOrderInfo',
	createOrder: 'store_shop/createOrder',
	checkOrder: 'store_shop/checkOrder',
	getMyOrder: 'store_shop/getMyOrder',
	cancelMyOrder: 'store_shop/cancelMyOrder',
	getOrderDesById: 'store_shop/getOrderDesById',
	getLogisticsCompany: 'store_shop/getLogisticsCompany',
	receiving: 'store_shop/receiving',
	payOrder: 'store_shop/payOrder'
}
export function getAuthInfo(data) {
  return request.get(apiUri.getAuthInfo, data)
}
export function getAuthUserInfo(data) {
  return request.get(apiUri.getAuthUserInfo, data)
}
export function getJsConfig(data) {
  return request.get(apiUri.getJsConfig, data)
}
export function getStoreGoodsClass(data) {
  return request.get(apiUri.getStoreGoodsClass, data)
}
export function getStoreGoods(data) {
  return request.get(apiUri.getStoreGoods, data)
}
export function getStoreInfo(data) {
  return request.get(apiUri.getStoreInfo, data)
}
export function getGoodsInfo(data) {
  return request.get(apiUri.getGoodsInfo, data)
}
export function getMemberAddressList(data) {
  return request.get(apiUri.getMemberAddressList, data)
}
export function queryMemberAddress(data) {
  return request.get(apiUri.queryMemberAddress, data)
}
export function saveMemberAddress(data) {
  return request.post(apiUri.saveMemberAddress, data)
}
export function addCart(data) {
  return request.get(apiUri.addCart, data)
}
export function getCartList(data) {
  return request.get(apiUri.getCartList, data)
}
export function updateCart(data) {
  return request.get(apiUri.updateCart, data)
}
export function clearCart(data) {
  return request.post(apiUri.clearCart, data)
}
export function getUserInfo(data) {
  return request.get(apiUri.getUserInfo, data)
}
export function getOrderInfo(data) {
  return request.get(apiUri.getOrderInfo, data)
}
export function createOrder(data) {
  return request.post(apiUri.createOrder, data)
}
export function checkOrder(data) {
  return request.get(apiUri.checkOrder, data)
}
export function getMyOrder(data) {
  return request.get(apiUri.getMyOrder, data)
}
export function cancelMyOrder(data) {
  return request.get(apiUri.cancelMyOrder, data)
}
export function getOrderDesById(data) {
  return request.get(apiUri.getOrderDesById, data)
}
export function getLogisticsCompany(data) {
  return request.get(apiUri.getLogisticsCompany, data)
}
export function receiving(data) {
  return request.get(apiUri.receiving, data)
}
export function payOrder(data) {
  return request.get(apiUri.payOrder, data)
}