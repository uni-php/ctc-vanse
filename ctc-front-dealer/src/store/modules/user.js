import { login, logout, getInfo } from '@/api/user'
import { getToken, setToken, removeToken } from '@/utils/auth'
import { resetRouter } from '@/router'

const getDefaultState = () => {
  return {
    token: '',
    name: '',
    dealer_id:'',
    avatar: '',
    roles: [],
    account:'',
    permissions:[],
  }
}

const state = getDefaultState()

const mutations = {
  RESET_STATE: (state) => {
    Object.assign(state, getDefaultState())
  },
  SET_TOKEN: (state, token) => {
    state.token = token
  },
  SET_ROLES: (state, roles) => {
    state.roles = roles
  },
  SET_PERMISSIONS: (state, permissions) => {
    state.permissions = permissions
  },
  SET_NAME: (state, name) => {
    state.name = name
  },
  SET_DEALERID: (state, id) => {
    state.dealer_id = id
  },
  SET_ACCOUNT: (state, account) => {
    state.account = account
  },
  SET_AVATAR: (state, avatar) => {
    state.avatar = avatar
  }
}

const actions = {
  // user login
  login({ commit }, userInfo) {
    const { account, password } = userInfo
    return new Promise((resolve, reject) => {
      login({ account: account.trim(), password: password }).then(response => {
        if(response.code==200){
          const { data} = response
          commit('SET_TOKEN', data.token)
          setToken(data.token)
          resolve(response)
        }else{
          resolve(response)
        } 
      }).catch(error => {
        reject(error)
      })
    })
  },

  // get user info
  getInfo({ commit, state }) {
    return new Promise((resolve, reject) => {
      getInfo({}).then(response => {
        const { data } = response
        if (!data) {
          return reject('账号异常，请重新登录')
        }
        if (response.roles && response.roles.length > 0) { // 验证返回的roles是否是一个非空数组
          commit('SET_ROLES', response.roles)
          commit('SET_PERMISSIONS', response.permissions)
          commit('SET_ACCOUNT',response.data.account)
          commit('SET_DEALERID',response.data.id)
        } else {
          commit('SET_ROLES', ['ROLE_DEFAULT'])
        }
        commit('SET_NAME', response.data.dealer_name) 
        resolve(response)
      }).catch(error => {
        reject(error)
      })
    })
  },

  // user logout
  logout({ commit, state }) {
    return new Promise((resolve, reject) => {
      logout({}).then(() => {
        removeToken() // must remove  token  first
        resetRouter()
        commit('RESET_STATE')
        resolve()
      }).catch(error => {
        reject(error)
      })
    })
  },

  // remove token
  resetToken({ commit }) {
    return new Promise(resolve => {
      removeToken() // must remove  token  first
      commit('RESET_STATE')
      resolve()
    })
  }
}

export default {
  namespaced: true,
  state,
  mutations,
  actions
}

