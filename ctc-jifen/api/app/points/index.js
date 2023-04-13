import request from '@/utils/request'
const apiUri={
	getPageData: 'points/getPageData',
	getHotRecommend: 'points/getHotRecommend',
	getPointsRule:'points/getPointsRule',
	getPointsBill:'points/getPointsBill',
	getPointsType:'points/getPointsType',//积分发放应用
	getGiftsList:'points/getGiftsList',
	getGiftsInfo:'points/getGiftsInfo',
	getUserInfo:'points/getUserInfo',
	getAuthUserInfo:'points/getAuthUserInfo',
	saveUserInfo:'points/saveUserInfo',
	getMemberAddressList:'points/getMemberAddressList',
	saveMemberAddress:'points/saveMemberAddress',
	queryMemberAddress:'points/queryMemberAddress',
	deleMemberAddress:'points/deleMemberAddress',
	setDefaultMemberAddress:'points/setDefaultMemberAddress',
	addCart:'points/addCart',//加入购物车
	getCartList:'points/getCartList',
	updateCart:'points/updateCart',//更新购物车
	clearCart:'points/clearCart',//更新购物车
	getOrderInfo:'points/getOrderInfo',//更新购物车
	settlement:'points/settlement',//结算
	getMyOrder:'points/getMyOrder',//我的订单
	cancelMyOrder:'points/cancelMyOrder',//我的订单
	getOrderDesById:'points/getOrderDesById',//我的订单
	getAuthInfo:'points/getAuthInfo',
	getJsConfig:'points/getJsConfig',
	createOrder:'points/createOrder',
	checkOrder:'points/checkOrder',//支付成功改变订单状态
	payOrder:'points/payOrder',//继续支付
	receiving:'points/receiving',//确认收货
	getLogisticsCompany:'points/getLogisticsCompany'//查询物流公司
}
export function getPageData(params) {
  return request.get(apiUri.getPageData,params)
}
export function getHotRecommend(params) {
  return request.get(apiUri.getHotRecommend,params)
}
export function getPointsRule(params) {
  return request.get(apiUri.getPointsRule,params)
}
export function getGiftsList(params) {
  return request.get(apiUri.getGiftsList,params)
}
export function getGiftsInfo(params) {
  return request.get(apiUri.getGiftsInfo,params)
}
export function getMemberAddressList(params) {
  return request.get(apiUri.getMemberAddressList,params)
}
export function saveMemberAddress(params) {
  return request.post(apiUri.saveMemberAddress,params)
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
export function getUserInfo(params) {
  return request.get(apiUri.getUserInfo,params)
}
export function saveUserInfo(params) {
  return request.post(apiUri.saveUserInfo,params)
}
export function getPointsBill(params) {
  return request.get(apiUri.getPointsBill,params)
}
export function getPointsType(params) {
  return request.get(apiUri.getPointsType,params)
}
export function addCart(params) {
  return request.get(apiUri.addCart,params)
}
export function updateCart(params) {
  return request.get(apiUri.updateCart,params)
}
export function clearCart(params) {
  return request.post(apiUri.clearCart,params)
}
export function getCartList(params) {
  return request.get(apiUri.getCartList,params)
}
export function getOrderInfo(params) {
  return request.get(apiUri.getOrderInfo,params)
}
export function settlement(params) {
  return request.post(apiUri.settlement,params)
}
export function getMyOrder(params) {
  return request.get(apiUri.getMyOrder,params)
}
export function cancelMyOrder(params) {
  return request.post(apiUri.cancelMyOrder,params)
}
export function getOrderDesById(params) {
  return request.get(apiUri.getOrderDesById,params)
}
export function getAuthInfo(params) {
  return request.get(apiUri.getAuthInfo,params)
}
export function getAuthUserInfo(params) {
  return request.get(apiUri.getAuthUserInfo,params)
}
export function getJsConfig(params) {
  return request.get(apiUri.getJsConfig,params)
}
export function createOrder(params) {
  return request.post(apiUri.createOrder,params)
}
export function checkOrder(params) {
  return request.get(apiUri.checkOrder,params)
}
export function payOrder(params) {
  return request.post(apiUri.payOrder,params)
}
export function getLogisticsCompany(params) {
  return request.get(apiUri.getLogisticsCompany,params)
}
export function receiving(params) {
  return request.get(apiUri.receiving,params)
}