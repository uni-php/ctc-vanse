<template>
  <div class="app-container">
    <div class="tips">
          <p>数据非实时显示，数据统计截止到前一天。</p>
      </div>
      <div class="card-dashboard" id="trend">
           <line-chart :chartData="lineChartData" />
      </div>
  </div>
</template>

<script>
import LineChart from './GiftLineChart.vue'
import {getGiftsNum} from '@/api/app/guide/data'
export default {
  components: {
      LineChart
  },
  data(){
    return{
      lineChartData:{
          data: [],
          xData:[]
      },
    }
  },
  created(){
    this.getGiftsNum()
  },
  methods:{
    getGiftsNum(){
      getGiftsNum({}).then(res=>{
          this.lineChartData=res.data.lineChartData
      })
     }
  }
}
</script>

<style lang="scss" scoped>
.app-container .tips{
  padding: 8px 16px;
  background-color: #ecf8ff;
  border-radius: 4px;
  border-left: 5px solid #50bfff;
  margin: 20px 0;
}
.dialog-footer{
margin: 30px 0;
}
.card-dashboard{
  margin-top: 80px;
  width: 100%;
  height: 500px;
}
</style>
