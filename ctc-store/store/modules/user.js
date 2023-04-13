import { ACCESS_TOKEN, USER_ID,USER_INFO,DEPTLIST,STORE_INFO } from '@/store/mutation-types'
import storage from '@/utils/storage'
import * as LoginApi from '@/api/login'

// 登陆成功后执行
const loginSuccess = (commit, result) => {
  // 过期时间30天
  const expiryTime = 30 * 86400
  // 保存tokne userInfo和userId到缓存
  console.log(result)
  storage.set(STORE_INFO, result, expiryTime)
  // 记录到store全局变
  commit('SET_STORE_INFO',result)
}

const user = {
  state: {
    // 用户认证token
    token: '',
    // 用户ID
    userId: null,
	storeInfo:{},//门店信息
	userInfo:{},//用户信息
  },

  mutations: {
    SET_TOKEN: (state, value) => {
      state.token = value
    },
    SET_USER_ID: (state, value) => {
      state.userId = value
    },
	SET_USER_INFO: (state, value) => {
	  state.userInfo = value
	},
	SET_STORE_INFO: (state, value) => {
	  state.storeInfo = value
	}
  },

  actions: {

    // 用户登录(普通登录: 输入手机号和验证码)
    Login({ commit }, data) {
      return new Promise((resolve, reject) => {
        LoginApi.login(data)
          .then(response => {
            const result = response.data
            loginSuccess(commit, result)
            resolve(response)
          })
          .catch(reject)
      })
    },
    // 退出登录
    Logout({ commit }, data) {
      const store = this
      return new Promise((resolve, reject) => {
        if (store.getters.userId > 0) {
          // 删除缓存中的tokne和userId
          storage.remove(USER_ID)
          storage.remove(ACCESS_TOKEN)
          // 记录到store全局变量
          commit('SET_TOKEN', '')
          commit('SET_USER_ID', null)
          resolve()
        }
      })
    }

  }
}

export default user
