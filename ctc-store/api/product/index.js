import request from '@/utils/request'
const api = {
  get_product_list: '/pda/get_product_list'
}
export function getProductList(params) {
  return request.get(api.get_product_list,params)
}