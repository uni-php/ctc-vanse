<template>
  <div class="app-container">
    <div class="tab-bar">
      <el-form ref="queryForm" :model="queryForm" label-width="100px" :inline="true" size="small">
        <el-form-item label="注册时间" prop="create_time">
            <el-date-picker
                style="width:240px"
                v-model="queryForm.time"
                type="daterange"
                unlink-panels=""
                range-separator="至"
                value-format="yyyy-MM-dd"
                start-placeholder="开始日期"
                end-placeholder="结束日期">
            </el-date-picker>
        </el-form-item>
        <el-form-item label="关键词" prop="keywords">
            <el-input style="width:240px" v-model="queryForm.store_name" placeholder="用户昵称/手机号码/门店编号"></el-input>
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
           style="width: 100%">
           <el-table-column prop="store_name" align="center" label="所属门店"></el-table-column>
           <el-table-column prop="member_id" align="center" label="客户id"></el-table-column>
           <el-table-column prop="nickname" align="center" label="客户昵称"></el-table-column>
           <el-table-column prop="create_time" align="center" label="注册时间"></el-table-column>
           <el-table-column prop="buy_num" align="center" label="累计消费次数"></el-table-column>
           <el-table-column prop="buy_money" align="center" label="累计消费金额"></el-table-column>
    </el-table>
    <pagination
           v-show="+total>10"
           :total="+total"
           :page.sync="queryForm.pageNum"
           :limit.sync="queryForm.pageSize"
           @pagination="getList"/>
  </div>
</template>

<script>
export default {
  data(){
    return{
      queryForm:{
        time:[],
        keywords:'',
        pageNum:1,
        pageSize:10
      },
      tableData:[],
      total:0
    }
  },
  created(){
    this.getList()
  },
  methods:{
    getList(){},
    query(){
      this.queryForm.pageNum = 1;
      this.getList();
    },
    reset(formName){
        this.$refs[formName].resetFields();
        this.queryForm.distributor_id=undefined
        this.query()
    },
  }
}
</script>

<style>

</style>
