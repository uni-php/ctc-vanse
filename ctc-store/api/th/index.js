import request from '@/utils/request'
const api = {
  create_th_order: '/pda/create_th_order',
  return_goods: '/pda/return_goods',
  get_th_product_list:'/pda/get_th_product_list',
  get_code_list:'/pda/get_th_code_list',
  get_th_notes:'/pda/get_th_notes'
}
export function createThOrder(params) {
  return request.get(api.create_th_order,params)
}
export function returnGoods(data) {
  return request.post(api.return_goods,data)
}
export function getThProductList(params) {
  return request.get(api.get_th_product_list,params)
}
export function getCodeList(params) {
  return request.get(api.get_code_list,params)
}
export function getThNotes(params) {
  return request.get(api.get_th_notes,params)
}