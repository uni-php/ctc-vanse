
// #ifndef VUE3
import Vue from 'vue'
import uView from "uview-ui";
import store from './store'
import platform from './core/platform'
import bootstrap from './core/bootstrap'
import { VueJsonp } from 'vue-jsonp'
import App from './App'
import dayjs from 'dayjs'
import {
  navTo,
  showToast,
  showSuccess,
  showError,
  getShareUrlParams
} from './core/app'
import './js_sdk/ican-H5Api/ican-H5Api'

Vue.config.productionTip = false

App.mpType = 'app'
// 当前运行的终端
Vue.prototype.$platform = platform
Vue.prototype.$dayjs = dayjs;//可以全局使用dayjs
// 载入uView库
Vue.use(uView)
Vue.use(VueJsonp)
// 挂载全局函数
Vue.prototype.$toast = showToast
Vue.prototype.$success = showSuccess
Vue.prototype.$error = showError
Vue.prototype.$navTo = navTo
Vue.prototype.$getShareUrlParams = getShareUrlParams

const app = new Vue({
    ...App,
	store,
	created: bootstrap
})
app.$mount()
// #endif

// #ifdef VUE3
import { createSSRApp } from 'vue'
import App from './App.vue'
export function createApp() {
  const app = createSSRApp(App)
  return {
    app
  }
}
// #endif