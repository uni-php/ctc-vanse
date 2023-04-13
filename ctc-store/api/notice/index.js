import request from '@/utils/request'

// api地址
const api = {
  getNoticeList: 'store/getNoticeList',
  getNoticeInfo: 'store/getNoticeInfo',
}
export function getNoticeList(data) {
  return request.get(api.getNoticeList, data)
}
export function getNoticeInfo(data) {
  return request.get(api.getNoticeInfo, data)
}