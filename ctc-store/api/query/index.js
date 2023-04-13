import request from '@/utils/request'
const api = {
  query_code_link: '/pda/query_code_link'
}
/**
 * @param {Object} params
 * 追踪物流码
 */
export function queryCodeLink(params) {
  return request.get(api.query_code_link,params)
}