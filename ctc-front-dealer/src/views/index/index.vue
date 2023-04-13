<template>
  <div class="app-container">
    <!-- 数据统计 -->
    <el-card class="box-card">
      <div slot="header" class="clearfix">
        <img src="@/assets/icon/statistics.png">
        <span>数据统计</span>
      </div>
      <div class="box-card-item">
        <el-row :gutter="20">
          <el-col :span="6">
            <el-card shadow="always">
              <div class="card-box">
                <div class="card-box-item">
                  <span>日生码量</span>
                  <span>
                    <el-tag effect="dark" size="mini">实时</el-tag>
                  </span>
                </div>
                <div class="card-box-items">{{baseInfo.code[0]}}</div>
                <div class="card-box-item">
                  <span>平台总生码量</span>
                  <span>{{baseInfo.code[1]}}</span>
                </div>
              </div>
            </el-card>
          </el-col>
          <el-col :span="6">
            <el-card shadow="always">
              <div class="card-box">
                <div class="card-box-item">
                  <span>门店日注册量</span>
                  <span>
                    <el-tag effect="dark" size="mini">实时</el-tag>
                  </span>
                </div>
                <div class="card-box-items">{{baseInfo.store[0]}}</div>
                <div class="card-box-item">
                  <span>门店总数</span>
                  <span>{{baseInfo.store[1]}}</span>
                </div>
              </div>
            </el-card>
          </el-col>
          <el-col :span="6">
            <el-card shadow="always">
              <div class="card-box">
                <div class="card-box-item">
                  <span>会员日注册数</span>
                   <span>
                    <el-tag effect="dark" size="mini">实时</el-tag>
                  </span>
                </div>
                <div class="card-box-items">{{baseInfo.customer[0]}}</div>
                <div class="card-box-item">
                  <span>会员总数</span>
                  <span>{{baseInfo.customer[1]}}</span>
                </div>
              </div>
            </el-card>
          </el-col>
          <el-col :span="6">
            <el-card shadow="always">
              <div class="card-box">
                <div class="card-box-item">
                  <span>经销商日注册量</span>
                  <span>
                    <el-tag effect="dark" size="mini">实时</el-tag>
                  </span>
                </div>
                <div class="card-box-items">{{baseInfo.distributor[0]}}</div>
                <div class="card-box-item">
                  <span>经销商总量</span>
                  <span>{{baseInfo.distributor[1]}}</span>
                </div>
              </div>
            </el-card>
          </el-col>
        </el-row>
      </div>
    </el-card>
    <!-- 报表统计 -->
    <el-card class="box-card">
      <div slot="header" class="clearfix">
        <img src="@/assets/icon/table.png">
        <span>报表统计</span>
      </div>
      <div class="box-card-item">
        <el-row :gutter="20">
          <el-col :span="24">
            <el-card shadow="always">
              <div slot="header" style="display:flex;justify-content: space-between">
                <span>上周会员趋势</span>
                <span>
                    <el-tag effect="dark" size="mini">每周</el-tag>
                </span>
              </div>
              <div class="card-dashboard" id="scan">
                 <line-chart :chartData="lineChartData" />
              </div>
            </el-card>
          </el-col>
          <!-- <el-col :span="12">
            <el-card shadow="always">
              <div slot="header" style="display:flex;justify-content: space-between">
                <span></span>
                <span>
                    <el-tag effect="dark" size="mini">每周</el-tag>
                </span>
              </div>
              <div class="card-dashboard" id="agent">
                 <line-chart :chartData="lineChartData" />
              </div>
            </el-card>
          </el-col> -->
        </el-row>
      </div>
    </el-card>
  </div>
</template>
<script>
import EchartsLine from "@/components/EchartsLine"
import EchartsBar from "@/components/EchartsBar"
import EchartsPie from "@/components/EchartsPie"
import LineChart from './LineChart.vue'
import {getDashboardData} from '@/api/index/index'
export default {
  components:{LineChart},
  data() {
    return {
      base_info:{
        code:{
          dayNum:100000,
          sumNum:'200万',
          mark:'没什么好说的'
        },
        resPack:{
          surplus:3291.68,
          sumNum:3311,
          mark:'没什么好说的'
        },
        partner:{
          surplus:'￥10400.00',
          deposit:'￥4600.00',
          mark:'都来存款吧'
        },
        scan:{
          dayNum:1000,
          sumNum:'1000万',
          mark:'没什么好说的'
        }
      },
      lineChartData:{
          data1: [],
          xData:[]
      },
      //表格数据
      id1:'scan',
      id2:'agent',
      id3:'user',
      xData:['周一', '周二', '周三', '周四', '周五', '周六', '周日'],
      dataList:[820, 1000, 850, 934, 800, 1330, 1320],
      dataList2:[820, 850, 1000, 1100, 1200, 1330, 1340],
      pieItems:[
                {value: 1048, name: '直接访问'},
                {value: 735, name: '直接访问'},
                {value: 580, name: '邮件营销'},
                {value: 484, name: '联盟广告'},
                {value: 300, name: '视频广告'}
      ],
      seriesType1:'line',
      seriesType2:'bar',
      max:undefined,
      baseInfo:{
        code:[],
        customer:[],
        store:[],
        distributor:[]
      }
    }
  },
  created() {
    this.getPageData()
  },
  filters:{
    
  },
  methods: {
    getPageData(){
      getDashboardData({}).then(res=>{
        this.baseInfo=res.data
        this.lineChartData=res.data.memberEchart
      })
    }
  }
}
</script>
<style lang="scss" scoped>
  .box-card{
    margin-bottom: 30px;
  }
  .box-card-item{
    ::v-deep .el-card__body{
      padding-bottom: 0;
      padding-top: 0;
    }
  }
  .clearfix{
    display: flex;
    justify-content: flex-start;
    align-items: center;
    img{
      width:17px;
      height:17px;
      margin-right: 5px;
    }
  }
  .card-box{
    width: 100%;
    height: 160px;
    display: flex;
    flex-direction: column;
    .card-box-item{
      display: flex;
      justify-content: space-between;
      align-items: center;
      width: 100%;
      height: 30%;
      font-size: 16px;
      color: #303133;
    }
    .card-box-items{
      display: flex;
      justify-content: space-between;
      align-items: center;
      width: 100%;
      height: 40%;
      border-top: 1px solid #eeeeee;
      border-bottom: 1px solid #eeeeee;
      font-size: 26px;
      color: #303133;
      font-weight: 600;
    }
  }
  .card-dashboard{
    width: 100%;
    height: calc(100vh - 550px);
  }
</style>
