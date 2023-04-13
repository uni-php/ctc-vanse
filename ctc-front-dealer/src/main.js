import Vue from 'vue'

import 'normalize.css/normalize.css' // A modern alternative to CSS resets
import ElementUI from 'element-ui'
import 'element-ui/lib/theme-chalk/index.css';
import locale from 'element-ui/lib/locale/lang/en' // lang i18n
import { getDicts } from "@/api/system/dict/data";
import Pagination from "@/components/Pagination";//引入封装分页组件
import * as echarts from 'echarts';
import '@/styles/index.scss' // global css
import '@/styles/ctc.scss'//ctc平台自定义css
import md5 from 'js-md5';
import Print from 'vue-print-nb'
import dayjs from "dayjs"
// 富文本组件
import Editor from "@/components/Editor"
import QiniuEditor from "@/components/QiniuEditor"
import { parseTime, resetForm, addDateRange, selectDictLabel, selectDictLabels, download, handleTree,setTreeLevel} from "@/utils/ctc";
import Clipboard from 'clipboard'
import { VueJsonp } from 'vue-jsonp'
Vue.prototype.$md5 = md5;//全局注册
Vue.prototype.$dayjs = dayjs;//可以全局使用dayjs
Vue.prototype.getDicts = getDicts
Vue.prototype.$echarts = echarts//全局引入echarts
Vue.prototype.download = download
Vue.prototype.resetForm = resetForm
Vue.prototype.parseTime = parseTime
Vue.prototype.addDateRange = addDateRange
Vue.prototype.selectDictLabel = selectDictLabel
Vue.prototype.selectDictLabels = selectDictLabels
Vue.prototype.download = download
Vue.prototype.handleTree = handleTree
Vue.prototype.setTreeLevel=setTreeLevel
Vue.prototype.clipboard = Clipboard;
import App from './App'
import store from './store'
import router from './router'
import directive from './directive' //directive

import '@/icons' // icon 
import '@/permission' // permission control

/**
 * If you don't want to use mock-server
 * you want to use MockJs for mock api
 * you can execute: mockXHR()
 *
 * Currently MockJs will be used in the production environment,
 * please remove it before going online ! ! !
 */
if (process.env.NODE_ENV === 'production') {
  const { mockXHR } = require('../mock')
  mockXHR()
}
//分页组件 全局注册
Vue.component('Pagination',Pagination)
Vue.component('Editor', Editor)//本地服务器存储图片
Vue.component('QiniuEditor', QiniuEditor)//七牛云云存储
Vue.use(VueJsonp)
Vue.use(Print);

// set ElementUI lang to EN
// Vue.use(ElementUI, { locale })
// 如果想要中文版 element-ui，按如下方式声明
Vue.use(ElementUI)
Vue.use(directive)
Vue.config.productionTip = false

new Vue({
  el: '#app',
  router,
  store,
  render: h => h(App)
})
