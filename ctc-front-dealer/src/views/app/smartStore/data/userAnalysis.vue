<template>
  <div class="app-container">
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
            <el-form-item >
                <el-button type="primary" icon="el-icon-search" @click="query">查询</el-button>
                <el-button icon="el-icon-refresh" @click="resetQuery('queryForm')">重置</el-button>
            </el-form-item>
        </el-form>
    </div>
    <el-card class="box-card">
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
            <el-table-column prop="excharge_num" align="center" label="新增用户"></el-table-column>
            <el-table-column prop="points" align="center" label="累计用户"></el-table-column>
            <el-table-column prop="money" align="center" label="消耗金额"></el-table-column>
         </el-table>
      </el-card>
  </div>
</template>

<script>
import LineChart from './userLineChart.vue'
import {getStoreList} from '@/api/app/store/index'
export default {
  components: {
      LineChart
  },
  data(){
    return{
      lineChartData: {
          data1: [],
          data2: [],
          data3: [],
          data4: [],
          xData:[]
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
      storeTableData:[],
      queryForm:{
        store_id:'',
        pageNum:1,
        pageSize:10
      }
    }
  },
  created(){
    this.getStoreList()
    this.getList()
  },
  methods:{
    getList(){},
    getStoreList(){
      var params=Object.assign({},this.queryStoreForm)
      getStoreList(params).then(res=>{
          this.storeTableData=res.data
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

<style lang="scss" scoped>
.card-dashboard{
    margin-top: 80px;
    width: 100%;
    height: 500px;
}
</style>
