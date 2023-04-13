import request from '@/utils/request'
export function saveScanTpl(data) {
    return request({
      url: '/dealer/app/qrcode/saveScanTpl',
      method: 'post',
      data
    })
}
export function getTplList(query) {
  return request({
    url: '/dealer/app/qrcode/getTplList',
    method: 'get',
    params: query
  })
}
export function getTplInfo(query) {
  return request({
    url: '/dealer/app/qrcode/getTplInfo',
    method: 'get',
    params: query
  })
}
export function saveActivity(data) {
  return request({
    url: '/dealer/app/qrcode/saveActivity',
    method: 'post',
    data
  })
}
export function getActivityList(query) {
  return request({
    url: '/dealer/app/qrcode/getActivityList',
    method: 'get',
    params: query
  })
}
export function setActivityStatus(query) {
  return request({
    url: '/dealer/app/qrcode/setActivityStatus',
    method: 'get',
    params: query
  })
}
export function deleActivity(query) {
  return request({
    url: '/dealer/app/qrcode/deleActivity',
    method: 'get',
    params: query
  })
}
export function getActivityInfo(query) {
  return request({
    url: '/dealer/app/qrcode/getActivityInfo',
    method: 'get',
    params: query
  })
}
export function getScanBill(query) {
  return request({
    url: '/dealer/app/qrcode/getScanBill',
    method: 'get',
    params: query
  })
}
export function getPrizeLog(query) {
  return request({
    url: '/dealer/app/qrcode/getPrizeLog',
    method: 'get',
    params: query
  })
}
export function getRegisterList(query) {
  return request({
    url: '/dealer/app/qrcode/getRegisterList',
    method: 'get',
    params: query
  })
}
export function deleRegisterInfo(query) {
  return request({
    url: '/dealer/app/qrcode/deleRegisterInfo',
    method: 'get',
    params: query
  })
}
export function changeRegisterStatus(query) {
  return request({
    url: '/dealer/app/qrcode/changeRegisterStatus',
    method: 'get',
    params: query
  })
}
export function exportAward(data) {
  return request({
    url: "/dealer/app/qrcode/exportAward",
    method: "post",
    responseType: "blob",
    data
  });
}
export function exportBill(data) {
  return request({
    url: "/dealer/app/qrcode/exportBill",
    method: "post",
    responseType: "blob",
    data
  });
}
