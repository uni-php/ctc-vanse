<template>
  <div class="app-container">
      <div class="tab-bar">
        <el-form ref="queryForm" :model="queryForm" label-width="100px" :inline="true" size="small">
            <el-form-item label="下单时间" prop="time">
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
            <el-form-item label="买家昵称" prop="nickname">
                <el-input style="width:220px" v-model="queryForm.nickname" placeholder="请输入买家昵称"></el-input>
            </el-form-item>
            <el-form-item label="订单号" prop="order_id">
                <el-input style="width:220px" v-model="queryForm.order_id" placeholder="请输入订单号"></el-input>
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
        <el-table-column prop="goods_name" align="center" label="商品名称"></el-table-column>
        <el-table-column prop="uid" align="center" label="用户Id"></el-table-column>
        <el-table-column prop="nickname" align="center" label="用户昵称"></el-table-column>
        <el-table-column prop="order" align="center" label="订单号"></el-table-column>
        <el-table-column prop="money" align="center" label="订单金额(不含运费)"></el-table-column>
        <el-table-column prop="commission_one" align="center" label="一级佣金"></el-table-column>
        <el-table-column prop="commission_two" align="center" label="二级佣金"></el-table-column>
        <el-table-column prop="create_time" align="center" label="创建时间"></el-table-column>
        <el-table-column prop="status" align="center" label="状态" :formatter="status"></el-table-column>
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
import {getFenxiaoOrderList} from '@/api/app/mall/distribution.js'
export default {
    data(){
        return{
            queryForm:{
                time:[],
                nickname:'',
                order_id:'',
                pageNum:1,
                pageSize:10
            },
            orderStatus:[],
            tableData:[],
            total:0
        }
    },
    created(){
        this.getList();
         this.getDicts({type:'mall_order_status'}).then(res=>{
            this.orderStatus=res.data
        })
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
            getFenxiaoOrderList(params).then(res=>{
                this.tableData=res.data
                this.total=res.data
            })
        },
        status(row){
             return this.orderStatus.filter(item=>item.dict_value==row.status).map(item=>item.dict_label)[0]
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