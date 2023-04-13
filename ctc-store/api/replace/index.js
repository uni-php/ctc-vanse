import request from '@/utils/request'
const api = {
  replace_code: '/pda/replace_code'
}
/**
 * @param {Object} params
 * 追踪物流码
 */
export function replaceCode(params) {
  return request.get(api.replace_code,params)
}