import request from '@/utils/request'
const api = {
  rk_order_info: '/pda/rk_order_info',
  rk_order_list:'/pda/rk_order_list',
  warehouse_list:'/pda/warehouse_list',
  save_rk_order:'/pda/save_rk_order',
  rk_code_list:'/pda/rk_code_list',
  create_rk_order:'/pda/create_rk_order',
  save_direct_rk_order:'/pda/save_direct_rk_order',
  rk_order_notes:'/pda/rk_order_notes',
}
export function getRkOrderInfo(params) {
  return request.get(api.rk_order_info,params)
}
export function getRkOrderList(params) {
  return request.get(api.rk_order_list,params)
}
export function getWarehouseList(params) {
  return request.get(api.warehouse_list,params)
}
export function saveRkOrder(data) {
  return request.post(api.save_rk_order, data)
}
export function saveDirectRkOrder(data) {
  return request.post(api.save_direct_rk_order, data)
}
export function getCodeList(params) {
  return request.get(api.rk_code_list,params)
}
export function createRkOrder(params) {
  return request.get(api.create_rk_order,params)
}
export function getRkNotes(params) {
  return request.get(api.rk_order_notes,params)
}