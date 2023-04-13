import request from '@/utils/request'
const api = {
  ck_order_info: '/pda/ck_order_info',
  ck_order_list:'pda/ck_order_list',
  save_ck_order:'pda/save_ck_order',
  create_ck_order:'pda/create_ck_order',
  save_direct_ck_order:'pda/save_direct_ck_order',
  get_code_list:'pda/get_code_list',
  get_ck_product_list:'pda/get_ck_product_list',
  ck_order_notes:'pda/ck_order_notes'
}
export function getCkOrderInfo(params) {
  return request.get(api.ck_order_info,params)
}
export function getCkOrderList(params) {
  return request.get(api.ck_order_list,params)
}
export function saveCkOrder(data) {
  return request.post(api.save_ck_order,data)
}
export function saveDirectCkOrder(data) {
  return request.post(api.save_direct_ck_order,data)
}
export function createCkOrder(params) {
  return request.get(api.create_ck_order,params)
}
export function getCodeList(params) {
  return request.get(api.get_code_list,params)
}
export function getCkProductList(params) {
  return request.get(api.get_ck_product_list,params)
}
export function getCkNotes(params) {
  return request.get(api.ck_order_notes,params)
}