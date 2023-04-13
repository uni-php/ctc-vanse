import request from '@/utils/request'
const api = {
  getUserInfo: 'getUserInfo'
}
export const getUserInfo = (param, option) => {
  return request.get(api.getUserInfo, param, option)
}