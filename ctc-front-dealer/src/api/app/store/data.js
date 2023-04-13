import request from '@/utils/request'
export function getOrderAnalysisData(query) {
  return request({
    url: '/dealer/app/store/getOrderAnalysisData',
    method: 'get',
    params: query
  })
}
export function getOrderStatisticsData(query) {
  return request({
    url: '/dealer/app/store/getOrderStatisticsData',
    method: 'get',
    params: query
  })
}
export function getProductAnalysisData(query) {
  return request({
    url: '/dealer/app/store/getProductAnalysisData',
    method: 'get',
    params: query
  })
}
export function getProductPanelAnalysisData(query) {
  return request({
    url: '/dealer/app/store/getProductPanelAnalysisData',
    method: 'get',
    params: query
  })
}
export function getSurveyData(query) {
  return request({
    url: '/dealer/app/store/getSurveyData',
    method: 'get',
    params: query
  })
}


