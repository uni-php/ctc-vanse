<template>
  <div class="app-container">
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
            <el-table-column prop="order" align="center" label="积分订单"></el-table-column>
            <el-table-column prop="excharge_num" align="center" label="积分兑换量"></el-table-column>
            <el-table-column prop="points" align="center" label="消耗积分"></el-table-column>
            <el-table-column prop="money" align="center" label="消耗金额"></el-table-column>
         </el-table>
      </el-card>
  </div>
</template>

<script>
import {queryPointsMallData} from '@/api/app/points'
import LineChart from './LineChart.vue'
export default {
    components: {
        LineChart
    },
    data(){
        return{
            tableData:[],
            lineChartData: {
                data1: [],
                data2: [],
                data3: [],
                data4: [],
                xData:[]
            }
        }
    },
    created(){
        this.queryPointsMallData()
    },
    methods:{
        queryPointsMallData(){
            var tableData=[]
            queryPointsMallData({}).then(res=>{
                this.lineChartData=res.data.lineChartData
                res.data.lineChartData.xData.forEach((item,index) => {
                    tableData.push({
                        date:item,
                        order:res.data.lineChartData.data1[index],
                        excharge_num:res.data.lineChartData.data2[index],
                        points:res.data.lineChartData.data3[index],
                        money:res.data.lineChartData.data4[index],
                    })
                });
                this.tableData=tableData
            })
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