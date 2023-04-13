import request from '@/utils/request'
const api = {
	dc_order_info:'pda/dc_order_info',
	get_dc_order_list:'pda/get_dc_order_list',
	save_dc_order:'pda/save_dc_order',
	get_dc_notes:'pda/get_dc_notes',
	get_dc_product_list:'pda/get_dc_product_list',
	get_dc_code_list:'pda/get_dc_code_list'
}
export function getDcOrderInfo(params) {
  return request.get(api.dc_order_info,params)
}
export function getDcOrderList(params) {
  return request.get(api.get_dc_order_list,params)
}
export function saveDcOrder(data) {
  return request.post(api.save_dc_order,data)
}
export function getDcNotes(params) {
  return request.get(api.get_dc_notes,params)
}
export function getDcProductList(params) {
  return request.get(api.get_dc_product_list,params)
}
export function getCodeList(params) {
  return request.get(api.get_dc_code_list,params)
}