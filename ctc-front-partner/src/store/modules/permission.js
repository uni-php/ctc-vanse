import {constantRoutes} from '@/router'
import {getRouters} from '@/api/system'
import Layout from '@/layout/index'
import ParentView from '@/components/ParentView';

const permission={
    state:{
        routes:[],
        addRoutes:[]
    },
    mutations:{
        SET_ROUTES:(state,routes)=>{
            state.addRoutes=routes
            state.routes=constantRoutes.concat(routes)
        }
    },
    actions:{
        //生成路由
        GenerateRoutes({commit}){
            return new Promise(resolve=>{
                //向后端请求路由
                getRouters().then(res=>{
                    const rdata = JSON.parse(JSON.stringify(res.data))
                    const rewriteRoutes = filterAsyncRouter(rdata, false, true)
                    rewriteRoutes.push({ path: '*', redirect: '/404', hidden: true })
                    commit('SET_ROUTES', rewriteRoutes)
                    resolve(rewriteRoutes)

                    // const accessedRoutes=filterAsyncRouter(res)
                    // accessedRoutes.push({path:'*',redirect:"/404",hidden:true})
                    // commit('SET_ROUTES',accessedRoutes)
                    // resolve(accessedRoutes)
                })
            })
        }
    }
}
//遍历后台传来的路由字符换
// function filterAsyncRouter(asyncRouterMap,type = false){
//     return asyncRouterMap.filter(route=>{
//         if (type && route.children) {
//             route.children = filterChildren(route.children)
//         }
//         if(route.component){
//             if(route.component==='Layout'){
//                 route.component=Layout
//                 route.alwaysShow=true
//                 route.icon=route.icons
//             }else if (route.component === 'ParentView') {
//                 route.component = ParentView
//                 route.alwaysShow=true
//                 route.icon=route.icons
//             }else{
//                 route.component=loadView(route.component)
//                 route.alwaysShow=false
//                 route.icon=route.icons
//             }
//             route.meta={}
//             route.meta.title=route.menuname
//             route.meta.icon=route.icon
//         }
//         if(route.children!=null&&route.children&&route.children.length){
//             route.children=filterAsyncRouter(route.children)
//         }
//         return true
//     })
// }
function filterAsyncRouter(asyncRouterMap, lastRouter = false, type = false) {
    return asyncRouterMap.filter(route => {
      if (type && route.children) {
        route.children = filterChildren(route.children)
      }
      if (route.component) {
        // Layout ParentView 组件特殊处理
        if (route.component === 'Layout') {
          route.component = Layout
        } else if (route.component === 'ParentView') {
          route.component = ParentView
        } else if (route.component === 'InnerLink') {
          route.component = InnerLink
        } else {
          route.component = loadView(route.component)
        }
      }
      if (route.children != null && route.children && route.children.length) {
        route.children = filterAsyncRouter(route.children, route, type)
      } else {
        delete route['children']
        delete route['redirect']
      }
      return true
    })
  }
  
  function filterChildren(childrenMap, lastRouter = false) {
    var children = []
    childrenMap.forEach((el, index) => {
      if (el.children && el.children.length) {
        if (el.component === 'ParentView') {
          el.children.forEach(c => {
            c.path = el.path + '/' + c.path
            if (c.children && c.children.length) {
              children = children.concat(filterChildren(c.children, c))
              return
            }
            children.push(c)
          })
          return
        }
      }
      if (lastRouter) {
        el.path = lastRouter.path + '/' + el.path
      }
      children = children.concat(el)
    })
    return children
  }

// export const loadView=(view)=>{
//     return (resolve)=>require([`@/views/${view}`],resolve)
// }
export const loadView = (view) => {
    return (resolve) => require([`@/views/${view}.vue`], resolve)
}
export default permission