import request from '@/utils/request'
// api地址
const apiUri = {
  detail: 'trace/getPageData',
  companyInfo:'trace/getCompanyInfo',
  querySecurity:'trace/querySecurity'
}

// 页面数据
export function detail(params) {
  return request.get(apiUri.detail,params)
}