<template>
  <div class="app-container">
    <el-descriptions title="" direction="vertical" :column="5" border>
        <el-descriptions-item label-class-name="my-label" label="昨日分销订单数">{{baseInfo.orderNum}}</el-descriptions-item>
        <el-descriptions-item label-class-name="my-label" label="昨日分销订单金额">{{baseInfo.orderMoney}}</el-descriptions-item>
        <el-descriptions-item label-class-name="my-label" label="昨日分销佣金">{{baseInfo.orderYJ}}</el-descriptions-item>
        <el-descriptions-item label-class-name="my-label" label="昨日新增分销员">{{baseInfo.orderUser}}</el-descriptions-item>
        <el-descriptions-item label-class-name="my-label" label="累计分销员总数">{{baseInfo.orderSumUser}}</el-descriptions-item>
    </el-descriptions>
     <el-divider content-position="left">最近七天走势图</el-divider>
     <div class="card-dashboard" id="trend">
        <line-chart :chartData="lineChartData" />
    </div>
  </div>
</template>

<script>
import {getFenxiaoData} from '@/api/app/mall/distribution.js'
import LineChart from './components/LineChart.vue'
export default {
      components: {
        LineChart
    },
    data(){
        return{
            baseInfo:{
                orderNum:0,
                orderMoney:0,
                orderYJ:0,
                orderUser:0,
                orderSumUser:0
            },
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
        this.getFenxiaoData()
    },
    methods:{
        getFenxiaoData(){
            getFenxiaoData({}).then(res=>{
                this.baseInfo=res.data.baseInfo
                this.lineChartData=res.data.lineChartData
            })
        }
    }
}
</script>

<style lang="scss" scoped>
.my-label{
    background:#f2f2f2 ;
}
.card-dashboard{
    margin-top: 80px;
    width: 100%;
    height: 500px;
}
</style>