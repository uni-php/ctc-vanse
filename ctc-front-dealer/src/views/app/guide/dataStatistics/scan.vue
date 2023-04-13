<template>
  <div class="app-container">
      <div class="tips">
          <p>数据非实时显示，数据统计截止到前一天。</p>
      </div>
      <div class="card-dashboard" id="trend">
           <line-chart :chartData="lineChartData" />
      </div>
      <el-table
      :data="baseInfo"
      :header-cell-style="{background:'#FAFAFA',color:'#606266',height:'50px'}"
      border
      stripe
      size="medium"
      class="trace-table"
      style="width: 100%">
      <el-table-column prop="date"  align="center" label="日期"></el-table-column>
      <el-table-column prop="scan_num"  align="center" label="扫码次数"></el-table-column>
      <el-table-column prop="scan_person"  align="center" label="扫码人数"></el-table-column>
      <el-table-column prop="join_num"  align="center" label="活动参与次数"></el-table-column>
      <!-- <el-table-column prop="new_member" align="center" label="新会员参与数"></el-table-column> -->
      <!-- <el-table-column prop="old_member"  align="center" label="老会员参与数"></el-table-column> -->
      </el-table>
  </div>
</template>

<script>
import {getScanNum} from '@/api/app/guide/data'
import LineChart from './LineChart.vue'
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
          baseInfo:[],
      }
  },
  created(){
      this.getScanNum()
  },
  methods:{
     getScanNum(){
         getScanNum({}).then(res=>{
              this.baseInfo=res.data.baseInfo
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
