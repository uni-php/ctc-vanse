import request from '@/utils/request'
const api = {
  getGuideList: 'store/getGuideList',
  checkGuide: 'store/checkGuide',
  getScanRecords: 'store/getScanRecords',
  getRrizeRecords: 'store/getRrizeRecords'
}
export function getGuideList(data) {
  return request.get(api.getGuideList, data)
}
export function checkGuide(data) {
  return request.get(api.checkGuide, data)
}
export function getScanRecords(data) {
  return request.get(api.getScanRecords, data)
}
export function getRrizeRecords(data) {
  return request.get(api.getRrizeRecords, data)
}