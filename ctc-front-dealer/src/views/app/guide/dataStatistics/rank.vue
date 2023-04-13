<template>
  <div class="app-container">
    <div class="tips">
        <p>可查看导购员的扫码领奖排行榜和红包领奖排行榜，列表奖显示TOP100的榜单。</p>
    </div>
    <el-tabs v-model="activeName" @tab-click="handleClick">
      <el-tab-pane label="扫码领奖排行榜" name="first"></el-tab-pane>
      <el-tab-pane label="红包领奖排行" name="second"></el-tab-pane>
    </el-tabs>
    <div class="tab-bar">
      <el-form ref="queryForm" :model="queryForm" label-width="100px" :inline="true" size="small">
              <el-form-item label="领奖时间" prop="time">
              <el-date-picker
                  style="width:220px"
                  v-model="queryForm.time"
                  type="daterange"
                  unlink-panels=""
                  range-separator="至"
                  value-format="yyyy-MM-dd"
                  start-placeholder="开始日期"
                  end-placeholder="结束日期">
              </el-date-picker>
          </el-form-item>
            <el-form-item >
              <el-button type="primary" icon="el-icon-search" @click="query">查询</el-button>
              <el-button icon="el-icon-refresh" @click="reset('queryForm')">重置</el-button>
          </el-form-item>
      </el-form>
    </div>
    <el-table
      :data="tableData"
        :header-cell-style="{background:'#FAFAFA',color:'#606266',height:'50px'}"
        border
        stripe
        size="medium"
        class="trace-table"
        style="width: 100%"
        >
      <el-table-column prop="id" align="center" label="Top 100排名" ></el-table-column>
      <el-table-column prop="name" align="center" label="导购员" ></el-table-column>
      <el-table-column prop="phone" align="center" label="手机号码" ></el-table-column>
      <el-table-column prop="times" v-if="activeName=='first'" align="center" label="领奖次数" ></el-table-column>
      <el-table-column prop="money" v-if="activeName=='second'" align="center" label="红包金额" ></el-table-column>
      </el-table>
  </div>
</template>

<script>
import {getScanRank} from '@/api/app/guide/data'
export default {
  data(){
    return{
      activeName:'first',
      tableData:[],
      total:0,
      queryForm:{
        pageNum:1,
        pageSize:100,
        time:[]
      }
    }
  },
  created(){
    this.getScanRank()
  },
  methods:{
    handleClick(){
      this.reset('queryForm')
    },
    getScanRank(){
      var params=Object.assign({},this.queryForm)
      if(!this.queryForm.time||this.queryForm.time.length==0){
          params.startTime=''
          params.endTime=''
      }else{
          params.startTime=this.queryForm.time[0]
          params.endTime=this.queryForm.time[1]
      }
      delete params.time
      params.status = this.activeName
      getScanRank(params).then(res=>{
          this.tableData=res.data
          this.total = res.total
      })
  },
    query(){
      this.getScanRank();
    },
    reset(formName){
        this.$refs[formName].resetFields();
        this.query()
    },
  }
}
</script>
<style lang="scss" scoped>
.app-container .tips{
  padding: 8px 16px;
  background-color: #ecf8ff;
  border-radius: 4px;
  border-left: 5px solid #50bfff;
  margin: 20px 0;
}
.dialog-footer{
margin: 30px 0;
}
.card-dashboard{
  margin-top: 80px;
  width: 100%;
  height: 500px;
}
</style>
