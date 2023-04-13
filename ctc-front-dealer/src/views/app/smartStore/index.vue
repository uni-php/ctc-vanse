<template>
  <div class="app-container">
      <el-row :gutter="20">
          <el-col :span="8">
                <el-card class="box-card">
                    <div slot="header" class="trace-header">
                        <span>已成交订单数</span>
                        <el-tag effect="dark"  size="mini">个</el-tag>
                    </div>
                    <div class="trace-surplus">
                       {{baseInfo[0]}}
                    </div>
                    <div class="trace-footer">
                        <!-- <el-link type="primary">查看详细赋码信息</el-link>
                        <i style="font-size:18px" class="el-icon-coordinate"></i> -->
                    </div>
                </el-card>
          </el-col>
          <el-col :span="8">
                <el-card class="box-card">
                    <div slot="header" class="trace-header">
                        <span>已成交商品数</span>
                        <el-tag effect="dark"  size="mini">个</el-tag>
                    </div>
                    <div class="trace-surplus">
                       {{baseInfo[1]}}
                    </div>
                    <div class="trace-footer">
                        <!-- <el-link type="primary">溯源信息明细</el-link>
                        <i style="font-size:18px" class="el-icon-location-outline"></i> -->
                    </div>
                </el-card>
          </el-col>
          <el-col :span="8">
                <el-card class="box-card">
                    <div slot="header" class="trace-header">
                        <span>已成交客户数</span>
                        <el-tag effect="dark"  size="mini">个</el-tag>
                    </div>
                    <div class="trace-surplus">
                       {{baseInfo[2]}}
                    </div>
                    <div class="trace-footer">
                        <!-- <el-link type="primary">防伪验证明细</el-link>
                        <i style="font-size:18px" class="el-icon-circle-check"></i> -->
                    </div>
                </el-card>
          </el-col>
          <!-- <el-col :span="6">
                <el-card class="box-card">
                    <div slot="header" class="trace-header">
                        <span>已发放佣金</span>
                        <el-tag effect="dark"  size="mini">次</el-tag>
                    </div>
                    <div class="trace-surplus">
                       {{traceInfo[3]}}
                    </div>
                    <div class="trace-footer">
                    </div>
                </el-card>
          </el-col> -->
      </el-row>
      <div style="display: flex;margin:20px 0;justify-content: flex-end;">
        <el-button size="medium" type="primary" @click="visitStore">门店登录地址</el-button>
      </div>
      <el-row :gutter="20">
          <el-col :span="24">
            <el-card class="box-card">
                <div slot="header" class="clearfix">
                    <span>最近七天的走势图</span>
                    <!-- <el-button style="float: right; padding: 3px 0" type="text">操作按钮</el-button> -->
                </div>
                <div class="card-dashboard" id="trend">
                  <line-chart :chartData="lineChartData" />
                </div>
            </el-card>
          </el-col>
      </el-row>
      <!-- 链接生成二维码网址 -->
    <CopyDialog :copyDialogVisible="copyDialogVisible" :title="copyTitle" :url="url" @close="closeCopyDialog"/>
  </div>
</template>

<script>
import LineChart from './LineChart'
import {getSurveyData} from '@/api/app/store/data'
import CopyDialog from '@/components/CopyDialog'
import { mapGetters } from 'vuex'
export default {
    components: {
        LineChart,
        CopyDialog
    },
    data(){
        return{
            copyDialogVisible:false,
            copyTitle:'复制链接',
            baseInfo:[],
            id:'trend',
            url:'',
            xData:[],
            dataList:[],
            max:undefined,
            seriesType:'line',
            objectData:[],//[{value: 2, name: '上海'}, {value:3,name: '北京'}],
            lineChartData: {
                data1: [],
                data2: [],
                data3:[],
                xData:[]
            }
        }
    },
    computed:{
      ...mapGetters([
          'dealer_id'
      ]),
    },
    created(){
      this.getStoreDashboard()
    },
    methods:{
        getStoreDashboard(){
            getSurveyData({}).then(res=>{
                this.baseInfo=res.data.baseInfo
                this.lineChartData=res.data.lineChartData
            })
        },
        visitStore(){
            this.copyDialogVisible=true
            this.url='http://yx.gawxg.com/store/?dealer_id='+this.dealer_id
        },
        closeCopyDialog(val){
            this.copyDialogVisible=val
        }
    }
}
</script>

<style lang="scss" scoped>
.app-container{
  display: flex;
  flex-direction: column;
}
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
