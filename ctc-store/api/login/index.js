import request from '@/utils/request'

// api地址
const api = {
  login: 'store/login',
}

// 用户登录(手机号+验证码)
export function login(data) {
  return request.get(api.login, data)
}

// 微信小程序快捷登录(获取微信用户基本信息)
export function loginMpWx(data, option) {
  return request.post(api.loginMpWx, data, option)
}
//判断是否登录
export function isLogin(data, option) {
  return request.post(api.isLogin, data, option)
}

// 微信小程序快捷登录(授权手机号)
export function loginMpWxMobile(data, option) {
  return request.post(api.loginMpWxMobile, data, option)
}
