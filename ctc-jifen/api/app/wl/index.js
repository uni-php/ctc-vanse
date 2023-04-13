import request from '@/utils/request'
// api地址
const apiUri = {
  detail: 'wl/getPageData',
  companyInfo:'wl/getCompanyInfo',
  querySecurity:'wl/querySecurity',
  queryLogisticsInfo:'wl/queryLogisticsInfo',
  getWarehouseList:'wl/getWarehouseList'
}

// 页面数据
export function detail(params) {
  return request.get(apiUri.detail,params)
}
export function getWarehouseList(params) {
  return request.get(apiUri.getWarehouseList,params)
}
export function queryLogisticsInfo(params) {
  return request.get(apiUri.queryLogisticsInfo,params)
}