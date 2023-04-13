import Vue from 'vue'
import Router from 'vue-router'

Vue.use(Router)

/* Layout */
import Layout from '@/layout'

/**
 * Note: sub-menu only appear when route children.length >= 1
 *
 * hidden: true                   if set true, item will not show in the sidebar(default is false)
 * alwaysShow: true               if set true, will always show the root menu
 *                                if not set alwaysShow, when item has more than one children route,
 *                                it will becomes nested mode, otherwise not show the root menu
 * redirect: noRedirect           if set noRedirect will no redirect in the breadcrumb
 * name:'router-name'             the name is used by <keep-alive> (must set!!!)
 * meta : {
    roles: ['admin','editor']    control the page roles (you can set multiple roles)
    title: 'title'               the name show in sidebar and breadcrumb (recommend set)
    icon: 'svg-name'/'el-icon-x' the icon show in the sidebar
    breadcrumb: false            if set false, the item will hidden in breadcrumb(default is true)
    activeMenu: '/example/list'  if set path, the sidebar will highlight the path you set
  }
 */

/**
 * constantRoutes
 * a base page that does not have permission requirements
 * all roles can be accessed
 */
export const constantRoutes = [
  {
    path: '/login',
    component: () => import('@/views/login/index'),
    hidden: true
  },
  {
    path: '/404',
    component: () => import('@/views/404'),
    hidden: true
  },
  //创建图文素材
  {
    path: '/access',
    component: Layout,
    hidden: true,
    children: [
      {
        path: '/createArticleMaterial',
        component: (resolve) => require(['@/views/access/officialAccount/createArticleMaterial.vue'], resolve),
        name: 'createArticleMaterial',
        meta: { title: '创建图文素材', activeMenu: 'access'}
      }
    ]
  },
  {
    path: '/assets',
    component: Layout,
    hidden: true,
    children: [
      {
        path: '/productDes',
        component: (resolve) => require(['@/views/assets/product/productDes.vue'], resolve),
        name: 'productDes',
        meta: { title: '产品详情', activeMenu: 'assets'}
      }
    ]
  },
  {
    path: '/assets',
    component: Layout,
    hidden: true,
    children: [
      {
        path: '/giftDes',
        component: (resolve) => require(['@/views/assets/gift/giftDes.vue'], resolve),
        name: 'giftDes',
        meta: { title: '礼品详情', activeMenu: 'assets'}
      }
    ]
  },
  {
    path: '/customer',
    component: Layout,
    hidden: true,
    children: [
      {
        path: 'distributorDes',
        component: (resolve) => require(['@/views/customer/distributor/addDistributor.vue'], resolve),
        name: 'distributorDes',
        meta: { title: '经销商详情', activeMenu: 'assets'}
      }
    ]
  },
  {
    path: '/customer',
    component: Layout,
    hidden: true,
    children: [
      {
        path: 'storeDes',
        component: (resolve) => require(['@/views/customer/store/addStore.vue'], resolve),
        name: 'storeDes',
        meta: { title: '门店详情', activeMenu: 'assets'}
      }
    ]
  },
  {
    path: '/customer',
    component: Layout,
    hidden: true,
    children: [
      {
        path: 'salesmanDes',
        component: (resolve) => require(['@/views/customer/salesman/salesmanDes.vue'], resolve),
        name: 'salesmanDes',
        meta: { title: '业务员详情', activeMenu: 'customer'}
      }
    ]
  },
  {
    path: '/app',
    component: Layout,
    hidden: true,
    children: [
      {
        path: 'trace/templateDes',
        component: (resolve) => require(['@/views/app/trace/templateDes.vue'], resolve),
        name: 'templateDes',
        meta: { title: '溯源页模板详情', activeMenu: 'app'}
      }
    ]
  },
  {
    path: '/app',
    component: Layout,
    hidden: true,
    children: [
      {
        path: 'trace/productBatch',
        component: (resolve) => require(['@/views/app/trace/productBatch.vue'], resolve),
        name: 'productBatch',
        meta: { title: '生产批次详情', activeMenu: 'app'}
      }
    ]
  },
  // 添加商品
  {
    path: '/app',
    component: Layout,
    hidden: true,
    children: [
      {
        path: '/mall/addProduct',
        component: (resolve) => require(['@/views/app/microMall/addProduct.vue'], resolve),
        name: 'addProduct',
        meta: { title: '添加商品', activeMenu: 'app'}
      }
    ]
  },
  //添加礼品
  {
    path: '/app',
    component: Layout,
    hidden: true,
    children: [
      {
        path: '/points/addGift',
        component: (resolve) => require(['@/views/app/pointsMall/addGift.vue'], resolve),
        name: 'addGift',
        meta: { title: '添加礼品', activeMenu: 'app'}
      }
    ]
  },
  {
    path: '/app',
    component: Layout,
    hidden: true,
    children: [
      {
        path: '/qrcodeMarketing/sacnaAtivity/addTpl',
        component: (resolve) => require(['@/views/app/qrcodeMarketing/scanActivity/addTpl.vue'], resolve),
        name: 'addTpl',
        meta: { title: '创建模板', activeMenu: 'app'}
      }
    ]
  },
  //创建扫码模板
  {
    path: '/app',
    component: Layout,
    hidden: true,
    children: [
      {
        path: '/guide/sacnaAtivity/addTpl',
        component: (resolve) => require(['@/views/app/guide/scanActivity/addTpl.vue'], resolve),
        name: 'addTpl',
        meta: { title: '创建模板', activeMenu: 'app'}
      }
    ]
  },
  //创建扫码活动
  {
    path: '/app',
    component: Layout,
    hidden: true,
    children: [
      {
        path: '/qrcodeMarketing/sacnaAtivity/addActivity',
        component: (resolve) => require(['@/views/app/qrcodeMarketing/scanActivity/addActivity.vue'], resolve),
        name: 'addActivity',
        meta: { title: '创建活动', activeMenu: 'app'}
      }
    ]
  },
  //创建导购扫码活动
  {
    path: '/app',
    component: Layout,
    hidden: true,
    children: [
      {
        path: '/guide/sacnaAtivity/addActivity',
        component: (resolve) => require(['@/views/app/guide/scanActivity/addActivity.vue'], resolve),
        name: 'addGuideActivity',
        meta: { title: '创建活动', activeMenu: 'app'}
      }
    ]
  },
  //添加导购分组
  {
    path: '/app',
    component: Layout,
    hidden: true,
    children: [
      {
        path: '/guide/manage/addGroup',
        component: (resolve) => require(['@/views/app/guide/manage/addGroup.vue'], resolve),
        name: 'addGroup',
        meta: { title: '导购分组', activeMenu: 'app'}
      }
    ]
  },
  {
    path: '/app',
    component: Layout,
    hidden: true,
    children: [
      {
        path: '/guide/manage/addGuide',
        component: (resolve) => require(['@/views/app/guide/manage/addGuide.vue'], resolve),
        name: 'addGuide',
        meta: { title: '导购信息', activeMenu: 'app'}
      }
    ]
  },
  //添加门店自营商品
  {
    path: '/app',
    component: Layout,
    hidden: true,
    children: [
      {
        path: '/app/smartStore/goods/selfProductInfo',
        component: (resolve) => require(['@/views/app/smartStore/goods/selfProductInfo.vue'], resolve),
        name: 'selfProductInfo',
        meta: { title: '自营商品信息', activeMenu: 'app'}
      }
    ]
  },
  {
    path: '/',
    component: Layout,
    redirect: '/dashboard',
    children: [{
      path: 'dashboard',
      name: 'Dashboard',
      component: () => import('@/views/index/index'),
      meta: { title: '主页', icon: 'home',affix: true }
    }]
  },
]

const createRouter = () => new Router({
  // mode: 'history', // require service support
  scrollBehavior: () => ({ y: 0 }),
  routes: constantRoutes
})

const router = createRouter()

// Detail see: https://github.com/vuejs/vue-router/issues/1234#issuecomment-357941465
export function resetRouter() {
  const newRouter = createRouter()
  router.matcher = newRouter.matcher // reset router
}

export default router
