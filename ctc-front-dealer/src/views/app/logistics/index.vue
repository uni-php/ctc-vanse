<template>
  <div class="app-container">
      <el-row :gutter="20">
          <el-col :span="6">
                <el-card class="box-card">
                    <div slot="header" class="trace-header">
                        <span>经销商总数</span>
                        <el-tag effect="dark"  size="mini">个</el-tag>
                    </div>
                    <div class="trace-surplus">
                       {{traceInfo[0]}}
                    </div>
                    <div class="trace-footer">
                        <!-- <el-link type="primary">查看详细赋码信息</el-link>
                        <i style="font-size:18px" class="el-icon-coordinate"></i> -->
                    </div>
                </el-card>
          </el-col>
          <el-col :span="6">
                <el-card class="box-card">
                    <div slot="header" class="trace-header">
                        <span>直属门店总数</span>
                        <el-tag effect="dark"  size="mini">次</el-tag>
                    </div>
                    <div class="trace-surplus">
                       {{traceInfo[1]}}
                    </div>
                    <div class="trace-footer">
                        <!-- <el-link type="primary">溯源信息明细</el-link>
                        <i style="font-size:18px" class="el-icon-location-outline"></i> -->
                    </div>
                </el-card>
          </el-col>
          <el-col :span="6">
                <el-card class="box-card">
                    <div slot="header" class="trace-header">
                        <span>商品出货总数</span>
                        <el-tag effect="dark"  size="mini">次</el-tag>
                    </div>
                    <div class="trace-surplus">
                       {{traceInfo[2]}}
                    </div>
                    <div class="trace-footer">
                        <!-- <el-link type="primary">防伪验证明细</el-link>
                        <i style="font-size:18px" class="el-icon-circle-check"></i> -->
                    </div>
                </el-card>
          </el-col>
          <el-col :span="6">
                <el-card class="box-card">
                    <div slot="header" class="trace-header">
                        <span>窜货总数量</span>
                        <el-tag effect="dark"  size="mini">次</el-tag>
                    </div>
                    <div class="trace-surplus">
                       {{traceInfo[3]}}
                    </div>
                    <div class="trace-footer">
                        <!-- <el-link type="primary">防伪验证明细</el-link>
                        <i style="font-size:18px" class="el-icon-circle-check"></i> -->
                    </div>
                </el-card>
          </el-col>
      </el-row>
      <el-row :gutter="20">
          <el-col :span="24">
            <el-card class="box-card">
                <div slot="header" class="clearfix">
                    <span>出货数量趋势图</span>
                    <!-- <el-button style="float: right; padding: 3px 0" type="text">操作按钮</el-button> -->
                </div>
                <div class="card-dashboard" id="trend">
                    <line-chart :chartData="lineChartData" />
                </div>
            </el-card>
          </el-col>
      </el-row>
  </div>
</template>

<script>
import LineChart from './LineChart'
import {getPageData} from '@/api/app/logistics/basic'
export default {
    components: {
        LineChart
    },
    data(){
        return{
            traceInfo:[],
            id:'trend',
            xData:[],
            dataList:[],
            max:undefined,
            seriesType:'line',
            objectData:[],//[{value: 2, name: '上海'}, {value:3,name: '北京'}],
            lineChartData: {
                expectedData: [],
                actualData: [],
                xData:[]
            }
        }
    },
    created(){
        this.getPageData()
    },
    methods:{
        getPageData(){
            getPageData({}).then(res=>{
                this.traceInfo=res.data[0]
                this.objectData=res.data[2]
                this.lineChartData={
                    xData:res.data[1][0],
                    expectedData:res.data[1][1],
                    actualData:res.data[1][2],
                }
            })
        }
    }
}
</script>

<style lang="scss" scoped>
.trace-header{
    display: flex;
    justify-content: space-between;
    align-items: center;
    width: 100%;
    span{
        font-size: 14px;
    }
}
.trace-surplus{
    font-size: 26px;
    font-weight: 600;
}
.trace-footer{
    margin-top:15px;
    display: flex;
    justify-content: space-between;
}
.box-card {
    width: 100%;
    display: block;
    margin-bottom: 20px;
    .card-dashboard{
        width: 100%;
        height: 500px;
    }
    .map{
        width: 100%;
        min-height: 500px;
    }
}
</style>