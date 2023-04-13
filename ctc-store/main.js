
// #ifndef VUE3
import Vue from 'vue'
import dayjs from "dayjs"
import uView from "uview-ui";
import store from './store'
import platform from './core/platform'
import bootstrap from './core/bootstrap'
import { getDicts } from "@/api/dict";
import App from './App'
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
// 载入uView库
Vue.use(uView)

// 挂载全局函数
Vue.prototype.$dayjs = dayjs;//可以全局使用dayjs
Vue.prototype.getDicts = getDicts
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