<template>
  <div class="app-container">
    <el-tabs v-model="activeName" type="card" @tab-click="handleClick">
        <el-tab-pane label="直营门店" name="first"></el-tab-pane>
        <el-tab-pane label="非直营门店" name="second"></el-tab-pane>
    </el-tabs>
    <div class="tab-bar">
        <el-form ref="queryForm" :model="queryForm" label-width="100px" :inline="true" size="small">
            <el-form-item label="创建时间" prop="time">
                <el-date-picker
                    style="width:220px"
                    v-model="queryForm.time"
                    type="daterange"
                    range-separator="至"
                    unlink-panels=""
                    format="yyyy 年 MM 月 dd 日"
                    value-format="yyyy-MM-dd"
                    start-placeholder="开始日期"
                    end-placeholder="结束日期">
                </el-date-picker>
            </el-form-item>
            <el-form-item label="店员编号" prop="clerk_code">
                <el-input style="width:220px" v-model="queryForm.clerk_code" placeholder="请输入店员编号"></el-input>
            </el-form-item>
             <el-form-item label="店员名称" prop="clerk_name">
                <el-input style="width:220px" v-model="queryForm.clerk_name" placeholder="请输入店员名称"></el-input>
            </el-form-item>
            <el-form-item label="手机号" prop="phone">
                <el-input style="width:220px" v-model="queryForm.phone" placeholder="请输入店员手机号"></el-input>
            </el-form-item>
            <el-form-item label="备注" prop="remark">
                <el-input style="width:220px" v-model="queryForm.remark" placeholder="请输入备注"></el-input>
            </el-form-item>
            <el-form-item label="角色名称" prop="role_name">
                <el-select style="width:220px" size="small" v-model="queryForm.role_name" placeholder="请选择角色名称">
                    <el-option
                        v-for="item in roleOptions"
                        :key="item.value"
                        :label="item.label"
                        :value="item.value">
                    </el-option>
                </el-select>
            </el-form-item>
            <el-form-item label="门店编号" prop="store_code">
                <el-input style="width:220px" v-model="queryForm.store_code" placeholder="请输入门店编号"></el-input>
            </el-form-item>
            <el-form-item label="门店名称" prop="store_name">
                <el-input style="width:220px" v-model="queryForm.store_name" placeholder="请输入门店名称"></el-input>
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
        <el-table-column prop="clerk_code" align="center" label="编号"></el-table-column>
        <el-table-column prop="clerk_name" align="center" label="店员姓名"></el-table-column>
        <el-table-column prop="phone" align="center" label="手机号码"></el-table-column>
        <el-table-column prop="role_id" align="center" label="角色" :formatter="role"></el-table-column>
        <el-table-column prop="create_time" align="center" label="添加时间"></el-table-column>
        <el-table-column prop="login_time" align="center" label="最后登录时间"></el-table-column>
        <el-table-column prop="store_name" align="center" label="所属门店"></el-table-column>
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
import {getStoreClerkList} from '@/api/customer/store'
export default {
    data(){
        return{
            activeName:'first',
            tableData:[],
            total:0,
            queryForm:{
                time:[],
                clerk_code:'',
                clerk_name:'',
                phone:'',
                remark:'',
                store_name:'',
                store_code:'',
                role_id:'',
                pageNum:1,
                pageSize:10
            },
            roleOptions:[
                {
                    label:'店长',
                    value:1
                },
                {
                    label:'店员',
                    value:2
                }
            ]
        }
    },
    created(){
        this.getList()
    },
    methods:{
        getList(){
            var params=Object.assign({},this.queryForm)
            if(!this.queryForm.time||this.queryForm.time.length==0){
                params.startTime=''
                params.endTime=''
            }else{
                params.startTime=this.queryForm.time[0]
                params.endTime=this.queryForm.time[1]
            }
            delete params.time
            params.is_self=this.activeName=='first'?1:2
            getStoreClerkList(params).then(res=>{
                this.tableData=res.data
                this.total=res.total
            })
        },
        handleClick(){
            this.queryForm.pageNum=1
            this.tableData=[]
            this.reset('queryForm')
        },
        role(row){
            return this.roleOptions.filter(item=>item.value==row.role_id).map(item=>item.label)[0]
        },
        query(){
          this.queryForm.pageNum = 1;
          this.getList();
        },
        reset(formName){
            this.$refs[formName].resetFields();
            this.query()
        },
    }
}
</script>

<style>

</style>