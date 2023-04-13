<template>
  <div class="app-container">
    <div class="tab-bar">
        <el-form ref="queryForm" :model="queryForm" label-width="100px" :inline="true" size="small">
            <el-form-item label="发送时间" prop="time">
                <el-date-picker
                style="width:240px"
                v-model="queryForm.time"
                type="daterange"
                unlink-panels=""
                range-separator="至"
                format="yyyy 年 MM 月 dd 日"
                value-format="yyyy-MM-dd"
                start-placeholder="开始日期"
                end-placeholder="结束日期">
              </el-date-picker>
            </el-form-item>
            <el-form-item label="手机号" prop="phone">
                <el-input style="width:240px" v-model="queryForm.phone" placeholder="请输入手机号"></el-input>
            </el-form-item>
            <el-form-item label="短信类型" prop="type">
              <el-select style="width:240px" v-model="queryForm.type" placeholder="请选择短信类型">
                <el-option
                  v-for="dict in smsTypeOption"
                  :key="dict.dict_value"
                  :label="dict.dict_label"
                  :value="dict.dict_value">
                </el-option>
              </el-select>
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
        <el-table-column prop="id" align="center" label="ID"  width="80px"></el-table-column>
        <el-table-column prop="type" align="center" label="类型"></el-table-column>
        <el-table-column prop="phone" align="center" label="手机号码"></el-table-column>
        <el-table-column prop="content" align="center" label="短信内容"></el-table-column>
        <el-table-column prop="create_time" align="center" label="发送时间"></el-table-column>
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
import {getLogList} from '@/api/assets/sms'
export default {
    data(){
        return{
            queryForm:{
                time:[],
                phone:'',
                type:'',
                pageNum:1,
                pageSize:10
            },
            smsTypeOption:[],
            tableData:[],
            total:0
        }
    },
    created(){
        this.getList()
        this.getDicts({type:'sms_type'}).then(res=>{
            this.smsTypeOption=res.data
        })
    },
    methods:{
        getList(){
            var params=Object.assign({},this.queryForm)
            if(!this.queryForm.time||this.queryForm.time.length==0){
                params.startTime=''
                params.endTime=''
            }else{
                params.startTime=this.queryForm.duration[0]
                params.endTime=this.queryForm.duration[1]
            }
            delete params.time
            getLogList(params).then(res=>{
                this.total=res.total
                this.tableData=res.data
            })
        },
        query(){
            this.queryForm.pageNum = 1;
            this.getList();
        },
        resetQuery(formName){
            this.$refs[formName].resetFields();
            this.query()
        }
    }
}
</script>

<style>

</style>