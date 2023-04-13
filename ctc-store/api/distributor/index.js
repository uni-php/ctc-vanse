import request from '@/utils/request'
const api = {
  get_distributor_list: '/pda/get_distributor_list'
}
export function getDistributorList(params) {
  return request.get(api.get_distributor_list,params)
}