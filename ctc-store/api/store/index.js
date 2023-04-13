import request from '@/utils/request'
const api = {
  get_store_list: '/pda/get_store_list'
}
export function getStoreList(params) {
  return request.get(api.get_store_list,params)
}