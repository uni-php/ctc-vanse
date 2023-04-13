<template>
  <div class="app-container">
    <el-tabs v-model="activeName" @tab-click="handleClick">
      <el-tab-pane label="合伙人" name="first"></el-tab-pane>
      <el-tab-pane label="品牌商" name="second"></el-tab-pane>
    </el-tabs>
    <div class="tab-bar">
      <el-form :model="queryForm" ref="queryForm" :inline="true" size="small"  label-width="100px">
        <el-form-item label="合伙人名称" prop="company" v-if="activeName=='first'">
          <el-input style="width:240px" v-model="queryForm.company" placeholder="请输入合伙人名称"></el-input>
        </el-form-item>
        <el-form-item label="品牌商名称" prop="company" v-if="activeName=='second'">
          <el-input style="width:240px" v-model="queryForm.company" placeholder="请输入品牌商名称"></el-input>
        </el-form-item>
        <el-form-item label="账户类型" prop="type">
          <el-select style="width:240px" v-model="queryForm.type" placeholder="请选择账户类目">
              <el-option
                  v-for="item in typeOptions"
                  :key="item.dict_value"
                  :label="item.dict_label"
                  :value="item.dict_value">
              </el-option>
          </el-select>
        </el-form-item>
        <el-form-item label="日期" prop="date">
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
        <el-form-item label="交易类型" prop="transaction_type">
          <el-select style="width:240px" v-model="queryForm.transaction_type" placeholder="请选择交易类型">
              <el-option
                  v-for="item in transactionTypeOptions"
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
    <div v-if="activeName=='first'">
      <!-- 表格 -->
      <el-table
      :data="tableData"
      :header-cell-style="{background:'#FAFAFA',color:'#606266',height:'50px'}"
      border
      stripe
      size="medium"
      class="trace-table"
      style="width: 100%">
        <el-table-column prop="serial_number" show-overflow-tooltip="" align="center" label="流水号"></el-table-column>
        <el-table-column prop="code" align="center" label="合伙人编号" width="100px"></el-table-column>
        <el-table-column prop="company" width="160px" align="center" label="公司名称"></el-table-column>
        <el-table-column prop="create_time" show-overflow-tooltip="" align="center" label="日期"></el-table-column>
        <el-table-column prop="remark" align="center" show-overflow-tooltip="" label="备注"></el-table-column>
        <el-table-column prop="transaction_type" align="center" label="交易类型">
          <template slot-scope="scope">
            <span>{{transaction_type(scope.row.transaction_type)}}</span>
          </template>
        </el-table-column>
        <el-table-column prop="payments_type" align="center" label="收入">
          <template slot-scope="scope">
            <span>{{scope.row.payments_type==0?('￥'+scope.row.bill):'--'}}</span>
          </template>
        </el-table-column>
        <el-table-column prop="payments_type" align="center" label="支出">
          <template slot-scope="scope">
            <span>{{scope.row.payments_type==1?('￥'+scope.row.bill):'--'}}</span>
          </template>
        </el-table-column>
        <el-table-column prop="balance" align="center" label="余额"></el-table-column>
      </el-table>
    </div>
    <div v-else>
      <el-table
      :data="tableData"
      :header-cell-style="{background:'#FAFAFA',color:'#606266',height:'50px'}"
      border
      stripe
      size="medium"
      class="trace-table"
      style="width: 100%">
        <el-table-column prop="serial_number" show-overflow-tooltip="" align="center" label="流水号"></el-table-column>
        <el-table-column prop="code" align="center" label="品牌商编号" width="100px"></el-table-column>
        <el-table-column prop="dealer_name" align="center" label="品牌商名称"></el-table-column>
        <el-table-column prop="create_time" show-overflow-tooltip="" align="center" label="日期"></el-table-column>
        <el-table-column prop="remark" show-overflow-tooltip="" align="center" label="备注"></el-table-column>
        <el-table-column prop="transaction_type" align="center" label="交易类型">
          <template slot-scope="scope">
            <span>{{transaction_type(scope.row.transaction_type)}}</span>
          </template>
        </el-table-column>
        <el-table-column prop="payments_type" align="center" label="收入">
          <template slot-scope="scope">
            <span>{{scope.row.payments_type==0?('￥'+scope.row.bill):'--'}}</span>
          </template>
        </el-table-column>
        <el-table-column prop="payments_type" align="center" label="支出">
          <template slot-scope="scope">
            <span>{{scope.row.payments_type==1?('￥'+scope.row.bill):'--'}}</span>
          </template>
        </el-table-column>
        <el-table-column prop="balance" align="center" label="余额"></el-table-column>
      </el-table>
    </div>
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
import {listFinanceBill} from "@/api/finance/index";
export default {
  data(){
    return{
      activeName: 'first',
      queryForm:{
        company:'',
        transaction_type:"",
        type:"",
        date:[],
        pageNum:1,
        pageSize:10
      },
      total:0,
      tableData:[],
      transactionTypeOptions:[],
      typeOptions:[]
    }
  },
  created(){
    this.getList()
    this.getDicts({type:'recharge_type'}).then(res=>{
      this.typeOptions=res.data
    })
    this.getDicts({type:'transaction_type'}).then(res=>{
      this.transactionTypeOptions=res.data
    })
  },
  computed:{
    transaction_type(){
      return function(value){
          if(!value) return '--'
          var item=this.transactionTypeOptions.filter(item=>{
          return item.dict_value==value
      })
          return item[0].dict_label
      }
    },
  },
  methods:{
    getList(){
      var arr=Object.assign({},this.queryForm)
      if(arr.date&&arr.date.length>0){
        arr.beginTime=arr.date[0]
        arr.endTime=arr.date[1]
      }else{
        arr.beginTime=''
        arr.endTime=''
      }
      delete arr.date
      arr.subject=this.activeName=='first'?1:2
      listFinanceBill(arr).then(res=>{
        this.total=res.total
        this.tableData=res.data
      })
    },
    handleClick(){
      this.resetQuery('queryForm')
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