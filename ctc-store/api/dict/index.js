import request from '@/utils/request'
const api = {
  dictByType: 'dictByType'
}
export const getDicts = (param, option) => {
  return request.get(api.dictByType, param, option)
}