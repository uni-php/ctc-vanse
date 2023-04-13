import request from '@/utils/request'
const api = {
  get_op_log_list: '/pda/get_op_log_list'
}
export function getOpLogList(params) {
  return request.get(api.get_op_log_list,params)
}