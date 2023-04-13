import axios from "axios";
import qs from 'qs';
import { Notification,MessageBox,Loading,Message } from "element-ui";
import { Promise } from "core-js";
import store from '@/store'
import { getToken} from '@/utils/auth'
//开始加载动画
let loading;
let loadingCount=0;
function startLoading(){
    if(loadingCount===0){
        loading=Loading.service({
            spinner:'el-icon-loading',
            background:'rgba(0,0,0,0)'
        })
    }
    loadingCount++;
}
//结束加载动画
function endLoading(){
    loadingCount--;
    if(loadingCount===0){
        loading.close()
    }
}

axios.defaults.headers['Content-Type']='application/json;charset=utf-8'
//创建axios实例
const service=axios.create({
    baseURL:process.env.VUE_APP_BASE_API,
    timeout:1000000
})
//request拦截器
service.interceptors.request.use(
    config=>{
        //可发送token
      startLoading()
      const isToken = (config.headers || {}).isToken === false
        if (getToken() && !isToken) {
            config.headers['Authorization'] = 'Bearer ' + getToken()
        }
        if (config.method === 'post') {
            config.headers['Content-Type'] = 'app/json;charset=utf-8'
        }
          // get请求映射params参数
       if (config.method === 'get' && config.params) {
        let url = config.url + '?';
        for (const propName of Object.keys(config.params)) {
        const value = config.params[propName];
        var part = encodeURIComponent(propName) + "=";
        if (value !== null && typeof(value) !== "undefined") {
            if (typeof value === 'object') {
            for (const key of Object.keys(value)) {
                if (value[key] !== null && typeof (value[key]) !== 'undefined') {
                let params = propName + '[' + key + ']';
                let subPart = encodeURIComponent(params) + '=';
                url += subPart + encodeURIComponent(value[key]) + '&';
                }
            }
            } else {
            url += part + encodeURIComponent(value) + "&";
            }
        }
        }
        url = url.slice(0, -1);
        config.params = {};
        config.url = url;
    }
    return config
    },
    error=>{
        console.log(error)
        endLoading();
        Promise.reject(error)
    }
)
//响应拦截器
service.interceptors.response.use(res=>{
    const code = res.data.error_code || 200;
    if(code!=200){
        MessageBox.confirm('登录状态已过期，您可以继续留在该页面，或者重新登录', '系统提示', {
            confirmButtonText: '重新登录',
            cancelButtonText: '取消',
            type: 'warning'
          }
        ).then(() => {
                store.dispatch('user/logout').then(() => {
                location.reload()
            })
        }).catch(() => {
            endLoading();
        });
        return Promise.reject('无效的会话，或者会话已过期，请重新登录。')
    }
    if(res.status==200){
        endLoading();
        return res.data;
    }else{
        Notification.error({
            title:res.data.msg
        });
        endLoading();
        return res.data;
    }
},error=>{
    console.log('err',error)
    Message({
        message:error.message,
        type:'error',
        duration:5000
    });
    endLoading();
    return Promise.reject(error)
}
);
export default service