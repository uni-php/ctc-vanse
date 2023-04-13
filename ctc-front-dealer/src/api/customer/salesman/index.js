import request from '@/utils/request'
export function getSalesmanTypeList(query) {
    return request({
      url: '/dealer/customer/salesman/getSalesmanTypeList',
      method: 'get',
      params: query
    })
}
export function saveSalesmanType(data) {
    return request({
      url: '/dealer/customer/salesman/saveSalesmanType',
      method: 'post',
      data
    })
  }
  export function querySalesmanTypeInfo(query) {
    return request({
      url: '/dealer/customer/salesman/querySalesmanTypeInfo',
      method: 'get',
      params: query
    })
  }
  export function deleSalesmanType(query) {
    return request({
      url: '/dealer/customer/salesman/deleSalesmanType',
      method: 'get',
      params: query
    })
  }
  export function saveSalesman(data) {
    return request({
      url: '/dealer/customer/salesman/saveSalesman',
      method: 'post',
      data
    })
  }
  export function getSalesmanList(query) {
    return request({
      url: '/dealer/customer/salesman/getSalesmanList',
      method: 'get',
      params: query
    })
  }
  export function getSalesmanInfo(query) {
    return request({
      url: '/dealer/customer/salesman/getSalesmanInfo',
      method: 'get',
      params: query
    })
  }
  export function deleSalesman(query) {
    return request({
      url: '/dealer/customer/salesman/deleSalesman',
      method: 'get',
      params: query
    })
  }
  export function cutSalesman(query) {
    return request({
      url: '/dealer/customer/salesman/cutSalesman',
      method: 'get',
      params: query
    })
  }