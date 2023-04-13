<template>
  <div class="app-container">
    <el-tabs v-model="activeName" @tab-click="handleClick">
      <el-tab-pane v-for="(item,index) in nav_list" :key="index" :label="item.label" :name="item.name">
      </el-tab-pane>
    </el-tabs>
    <div class="tab-bar">
      <el-form ref="queryForm" :model="queryForm" label-width="100px" :inline="true" size="small">
        <el-form-item label="门店" prop="store_id">
          <el-select style="width:220px" size="small" v-model="queryForm.store_id" placeholder="请选择">
              <el-option
                  v-for="item in storeTableData"
                  :key="item.id"
                  :label="item.store_name"
                  :value="item.id">
              </el-option>
          </el-select>
        </el-form-item>
        <el-form-item label="门店名称" prop="store_name" v-if="activeName=='2'">
            <el-input style="width:240px" v-model="queryForm.store_name" placeholder="请输入"></el-input>
        </el-form-item>
        <el-form-item >
            <el-button type="primary" icon="el-icon-search" @click="query">查询</el-button>
            <el-button icon="el-icon-refresh" @click="resetQuery('queryForm')">重置</el-button>
        </el-form-item>
      </el-form>
    </div>
    <!-- 统计数据 -->
    <el-card class="box-card" v-if="activeName=='1'">
        <div class="card-dashboard" id="trend">
            <line-chart :chartData="lineChartData" />
        </div>
         <el-table
            :data="tableData"
            :header-cell-style="{background:'#FAFAFA',color:'#606266',height:'50px'}"
            border
            stripe
            size="medium"
            class="trace-table"
            style="width: 100%">
            <el-table-column prop="date" align="center" label="日期"></el-table-column>
            <el-table-column prop="order" align="center" label="佣金发放"></el-table-column>
            <el-table-column prop="excharge_num" align="center" label="佣金提现"></el-table-column>
            <el-table-column prop="points" align="center" label="发放商品数"></el-table-column>
         </el-table>
      </el-card>
    <!-- 门店数据统计 -->
    <el-table
           :data="storeOrderData"
           v-if="activeName=='2'"
           :header-cell-style="{background:'#FAFAFA',color:'#606266',height:'50px'}"
           border
           stripe
           size="medium"
           class="trace-table"
           style="width: 100%">
          <el-table-column prop="store_name" align="center" label="门店名称"></el-table-column>
          <el-table-column prop="order_num" align="center" label="累计佣金收益"></el-table-column>
          <el-table-column prop="turnover" align="center" label="已提现佣金"></el-table-column>
          <el-table-column prop="person_quantity" align="center" label="佣金余额"></el-table-column>
    </el-table>
    <pagination
           v-show="+storeOrderTotal>10&&activeName=='2'"
           :total="+storeOrderTotal"
           :page.sync="queryForm.pageNum"
           :limit.sync="queryForm.pageSize"
           @pagination="getStoreOrderList"/>
  </div>
</template>

<script>
import {getStoreList} from '@/api/app/store/index'
import LineChart from './comLineChart.vue'
export default {
  components: {
      LineChart
  },
  data(){
    return{
      queryForm:{
        store_id:'',
        store_name:'',
        pageNum:1,
        pageSize:10
      },
      queryStoreForm:{
          store_code:'',
          store_name:'',
          is_mall:'',
          is_self:'',
          is_commission:'',
          pageNum:1,
          pageSize:999
      },
      lineChartData: {
          data1: [],
          data2: [],
          data3: [],
          data4: [],
          xData:[]
      },
      tableData:[],
      storeTableData:[],
      storeOrderData:[],
      storeOrderTotal:0,
      activeName:'1',
      nav_list: [
        {
          label: '佣金概况',
          name: '1'
        },
        {
          label: '佣金统计',
          name: '2'
        }
      ]
    }
  },
  created(){
    this.getStoreList()
  },
  methods:{
    getStoreOrderList(){

    },
    getList(){},
    handleClick(){
      this.resetQuery('queryForm')
    },
    getStoreList(){
      var params=Object.assign({},this.queryStoreForm)
      getStoreList(params).then(res=>{
          this.storeTableData=res.data
      })
    },
    query(){
          this.queryForm.pageNum = 1;
          if(this.activeName=='1'){
            this.getList();
          }else{
            this.getStoreOrderList()
          }
    },
    resetQuery(formName){
        this.$refs[formName].resetFields();
        this.query()
    }
  }
}
</script>

<style lang="scss" scoped>
.card-dashboard{
    margin-top: 80px;
    width: 100%;
    height: 500px;
}
</style>
