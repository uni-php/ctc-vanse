import request from '@/utils/request'
//查询企业类型
export function getCompanyType(){
  return request({
    url: '/index/Company/getCompanyType',
    method: 'get',
  })
}
//查询注册企业列表
export function getList(params) {
  return request({
    url: '/index/Company/getCompanyList',
    method: 'get',
    params
  })
}
//新增企业
export function addCompany(data){
  return request({
    url: '/index/Company/addCompany',
    method: 'get',
    params:data
  })
}
//更新企业
export function updateCompany(data){
  return request({
    url: '/index/Company/updateCompany',
    method: 'get',
    params:data
  })
}
//冻结企业
export function freeze(data){
  return request({
    url: '/index/Company/freeze',
    method: 'get',
    params:data
  })
}
//查询所有企业
export function getAllCompany(){
  return request({
    url: '/index/Company/getAllCompany',
    method: 'get',
  })
}
//查询企业码关系
export function getCodeRelation(data){
  return request({
    url: '/index/SecurityCode/getCodeRelation',
    method: 'get',
    params:data
  })
}