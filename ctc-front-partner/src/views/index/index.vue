<template>
  <div class="app-container">
    <el-descriptions class="margin-top" title="基本信息" :column="2"  border>
      <el-descriptions-item label="公司名称">
        {{user_info.company}}
      </el-descriptions-item>
      <el-descriptions-item label="合伙人级别">
        {{level(user_info.level_id)}}
      </el-descriptions-item>
      <el-descriptions-item label="预存款余额">
        <span style="color:red">{{user_info.deposit}}</span>
      </el-descriptions-item>
      <el-descriptions-item label="账户余额">
        <span style="color:red">{{user_info.balance}}</span>
      </el-descriptions-item>
      <el-descriptions-item label="签约时间">
        {{user_info.duration.split(',').join('至')}}
      </el-descriptions-item>
      <el-descriptions-item label="联系人">
        {{user_info.contact_name}}
      </el-descriptions-item>
       <el-descriptions-item label="手机号">
        {{user_info.phone}}
      </el-descriptions-item>
       <el-descriptions-item label="详细地址">
        {{user_info.province}}-{{user_info.city}}-{{user_info.county}}-{{user_info.street}}
      </el-descriptions-item>
       <el-descriptions-item label="官方网站">
        {{user_info.website}}
      </el-descriptions-item>
       <el-descriptions-item label="所属行业">
        {{industry(user_info.industry)}}
      </el-descriptions-item>
      <el-descriptions-item label="E-Mail">
        {{user_info.email}}
      </el-descriptions-item>
      <el-descriptions-item label="公司电话">
        {{user_info.telephone}}
      </el-descriptions-item>
    </el-descriptions>
  </div>
</template>
<script>
import {listLevel } from '@/api/user'
import { mapGetters } from 'vuex'
export default {
  data() {
    return {
      levelOptions:[],
      industryOptions:[],
      base_info:{
      }
    }
  },
  computed:{
        ...mapGetters([
            'user_info'
        ]),
  },
  created() {
    this.getLevelOptions()
    this.getDicts({type:'partner_industry'}).then(res=>{
        this.industryOptions=res.data
    })
  },
  filters:{
    
  },
  methods: {
    getLevelOptions(){
      listLevel({level_name:"",pageNum:1,pageSize:999}).then(res=>{
        this.levelOptions=res.data
      })
    },
    industry(val){
      return this.industryOptions.filter(item=>item.dict_value==val).map(item=>item.dict_label)[0]
    },
    level(val){
      return this.levelOptions.filter(item=>item.id==val).map(item=>item.level_name)[0]
    }
  }
}
</script>
<style lang="scss" scoped>
 
</style>
