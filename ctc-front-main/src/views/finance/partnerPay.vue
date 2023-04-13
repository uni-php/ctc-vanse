<template>
  <div class="app-container">
      <div class="tab-bar">
         <el-form ref="queryForm" :model="queryForm" label-width="80px" :inline="true" size="small">
            <el-form-item label="充值时间" prop="date">
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
           <el-form-item label="合伙人" prop="company">
            <el-input style="width:240px" v-model="queryForm.company" placeholder="请输入合伙人名称"></el-input>
          </el-form-item>
          <el-form-item label="充值类型" prop="type">
            <el-select style="width:240px" v-model="queryForm.type" placeholder="请选择充值类型">
                <el-option
                    v-for="item in rechargeOptions"
                    :key="item.dict_value"
                    :label="item.dict_label"
                    :value="item.dict_value">
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
          <el-table-column prop="code" align="center" label="合伙人编号"></el-table-column>
          <el-table-column prop="company" align="center" show-overflow-tooltip="" label="公司名称"></el-table-column>
          <el-table-column prop="account" align="center" label="合伙人账号"></el-table-column>
          <el-table-column prop="recharge_type" align="center" label="充值类型">
            <template slot-scope="scope">
              <span>{{rechargeType(scope.row.recharge_type)}}</span>
            </template>
          </el-table-column>
          <el-table-column prop="money" align="center" label="充值金额"></el-table-column>
          <el-table-column prop="balance" align="center" label="充值后余额"></el-table-column>
          <el-table-column prop="remark" align="center" label="备注"></el-table-column>
          <el-table-column prop="create_time" show-overflow-tooltip="" align="center" label="充值时间"></el-table-column>
          <el-table-column prop="create_by" align="center" label="操作人">
          </el-table-column>
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
import {allRechargeLog} from "@/api/finance/index";
export default {
  data(){
    return{
      queryForm:{
        date:[],
        company:"",
        type:'',
        pageNum:1,
        pageSize:10
      },
      total:0,
      rechargeOptions:[],
      tableData:[]
    }
  },
  created(){
    this.getList()
    this.getDicts({type:'recharge_type'}).then(res=>{
      this.rechargeOptions=res.data
    })
  },
  computed:{
    rechargeType(){
      return function(value){
          if(!value) return '--'
          var item=this.rechargeOptions.filter(item=>{
          return item.dict_value==value
      })
          return item[0].dict_label
      }
    },
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
      allRechargeLog(arr).then(res=>{
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
  },
}
</script>

<style>

</style>