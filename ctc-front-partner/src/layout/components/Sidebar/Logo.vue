<template>
  <div class="sidebar-logo-container" :class="{'collapse':collapse}">
    <transition name="sidebarLogoFade">
      <router-link v-if="collapse" key="collapse" class="sidebar-logo-link" to="/">
        <img v-if="logo" :src="logo" class="sidebar-logo">
        <h1 v-else class="sidebar-title">{{ title }} </h1>
      </router-link>
      <router-link v-else key="expand" class="sidebar-logo-link" to="/">
        <img v-if="logo" :src="logo" class="sidebar-logo">
        <h1 class="sidebar-title">{{ title }} </h1>
      </router-link>
    </transition>
  </div>
</template>

<script>
import { mapGetters } from 'vuex'
import {listLevel } from '@/api/user'
export default {
  name: 'SidebarLogo',
  props: {
    collapse: {
      type: Boolean,
      required: true
    }
  },
  created(){
    this.getLevelOptions()
  },
  computed:{
      ...mapGetters([
          'user_info'
      ]),
      title(){
        if(this.levelConfig.is_custom_name=='1'){
          return this.user_info.platform_name||'合伙人管理平台'
        }else{
          return '合伙人管理平台'
        }
      },
      logo(){
        if(this.levelConfig.is_custom_logo=='1'){
            return this.user_info.logo||require('@/assets/logo.png')
        }else{
            return require('@/assets/logo.png')
        }
      }
  },
  data() {
    return {
      levelOptions:[],
      levelConfig:{},
      // title: '合伙人管理平台',
      // logo: require('@/assets/logo.png')
    }
  },
  methods:{
    getLevelOptions(){
      listLevel({level_name:"",pageNum:1,pageSize:999}).then(res=>{
        this.levelOptions=res.data
        this.levelConfig=res.data.filter(item=>item.id==this.user_info.level_id)[0]
      })
    },
  }

}
</script>

<style lang="scss" scoped>
.sidebarLogoFade-enter-active {
  transition: opacity 1.5s;
}

.sidebarLogoFade-enter,
.sidebarLogoFade-leave-to {
  opacity: 0;
}

.sidebar-logo-container {
  position: relative;
  width: 100%;
  height: 50px;
  line-height: 50px;
  background: #2b2f3a;
  text-align: center;
  overflow: hidden;

  & .sidebar-logo-link {
    height: 100%;
    width: 100%;

    & .sidebar-logo {
      width: 32px;
      height: 32px;
      vertical-align: middle;
      margin-right: 12px;
    }

    & .sidebar-title {
      display: inline-block;
      margin: 0;
      color: #fff;
      font-weight: 600;
      line-height: 50px;
      font-size: 14px;
      font-family: Avenir, Helvetica Neue, Arial, Helvetica, sans-serif;
      vertical-align: middle;
    }
  }

  &.collapse {
    .sidebar-logo {
      margin-right: 0px;
    }
  }
}
</style>
