<template>
  <div class="app-container">
    <div class="tab-bar">
        <el-form ref="queryForm" :model="queryForm" label-width="100px" :inline="true" size="small">
            <el-form-item label="登录地址" prop="address">
                <el-input style="width:240px" v-model="queryForm.address" placeholder="请输入登录地点"></el-input>
            </el-form-item>
            <el-form-item label="用户账号" prop="account">
                <el-input style="width:240px" v-model="queryForm.account" placeholder="请输入用户账号"></el-input>
            </el-form-item>
            <el-form-item label="登录时间" prop="date">
              <el-date-picker
                style="width:240px"
                v-model="queryForm.date"
                type="daterange"
                unlink-panels=""
                range-separator="至"
                format="yyyy-MM-dd"
                value-format="yyyy-MM-dd"
                start-placeholder="开始日期"
                end-placeholder="结束日期">
              </el-date-picker>
            </el-form-item>
            <el-form-item > 
                <el-button type="primary" icon="el-icon-search" @click="query">查询</el-button>
                <el-button icon="el-icon-refresh" @click="resetQuery('queryForm')">重置</el-button>
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
        <el-table-column prop="username" align="center" label="用户名称" ></el-table-column>
        <el-table-column prop="account" align="center" label="用户账号" ></el-table-column>
        <el-table-column prop="ip_address" align="center" label="登录ip" ></el-table-column>
        <el-table-column prop="address" align="center" label="登录地址" ></el-table-column>
        <el-table-column prop="browser" align="center" label="浏览器" ></el-table-column>
        <el-table-column prop="operating_system" align="center" label="操作系统" ></el-table-column>
        <el-table-column prop="status" align="center" label="状态" >
            <template slot-scope="scope">
                <span>{{scope.row.status==0?'正常':'失败'}}</span>
            </template>
        </el-table-column>
        <el-table-column prop="create_time" width="200px" align="center" label="登录日期" ></el-table-column>
    </el-table>
    <pagination
        v-show="+total>10"
        :total="+total"
        :page.sync="queryForm.pageNum"
        :limit.sync="queryForm.pageSize"
        @pagination="getList"
     />
  </div>
</template>
<script>
import {loginList} from "@/api/system/log";
export default {
    data(){
        return{
            queryForm:{
                address:'',
                account:'',
                date:[],
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
        getList(){
            var arr=Object.assign({},this.queryForm)
            if(arr.date.length>0){
                arr.beginTime=arr.date[0]
                arr.endTime=arr.date[1]
            }else{
                arr.beginTime=''
                arr.endTime=''
            }
            delete arr.date
            loginList(arr).then(res=>{
                this.tableData=res.data
                this.total=res.total
            })
        },
        query(){
            this.queryForm.pageNum = 1;
            this.getList();
        },
        resetQuery(formName){
            this.$refs[formName].resetFields();
            this.query()
        },
    }
}
</script>

<style>

</style>