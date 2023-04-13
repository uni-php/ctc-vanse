import request from '@/utils/request'
export function getMonitorList(query) {
    return request({
      url: '/dealer/access/monitor/getMonitorList',
      method: 'get',
      params: query
    })
}
export function queryMonitor(query) {
    return request({
      url: '/dealer/access/monitor/queryMonitor',
      method: 'get',
      params: query
    })
}
export function saveMonitorList(data) {
    return request({
      url: '/dealer/access/monitor/saveMonitorList',
      method: 'post',
      data
    })
}
export function deleMonitor(query) {
    return request({
      url: '/dealer/access/monitor/deleMonitor',
      method: 'get',
      params: query
    })
}
export function getSetInfo(query) {
    return request({
      url: '/dealer/access/monitor/getSetInfo',
      method: 'get',
      params: query
    })
}
export function saveSetInfo(data) {
    return request({
      url: '/dealer/access/monitor/saveSetInfo',
      method: 'post',
      data
    })
}