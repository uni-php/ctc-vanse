<template>
  <div class="app-container">
    <el-card class="box-card">
        <div class="text item">
           <p>数据仅统计支付完成的微商城订单数据，不含退货／退款数据。每天凌晨0点更新一次数据。</p>
           <div style="float:right">
               <el-button size="medium" type="primary" @click="visitPoints">访问积分商城</el-button>
           </div>
           <!-- 数据表格 -->
           <div class="table-box">
               <div class="table-head">
                   <el-row style="width:100%;height:100%" class="row">
                       <el-col :span="4"><div class="header"></div></el-col>
                       <el-col :span="5"><div class="header" style="border-left:1px solid #eeeeee;border-right:1px solid #eeeeee;">积分订单数</div></el-col>
                       <el-col :span="5"><div class="header" style="border-left:1px solid #eeeeee;border-right:1px solid #eeeeee;">礼品兑换数</div></el-col>
                       <el-col :span="5"><div class="header" style="border-left:1px solid #eeeeee;border-right:1px solid #eeeeee;">消耗积分</div></el-col>
                       <el-col :span="5"><div class="header">消耗金额</div></el-col>
                   </el-row>
               </div>
               <div class="table-body">
                   <el-row style="width:100%;height:100%" class="row">
                       <el-col :span="4"><div class="header">昨日成交</div></el-col>
                       <el-col :span="5"><div class="header" style="border-left:1px solid #eeeeee;border-right:1px solid #eeeeee;">{{baseInfo.yes_order}}</div></el-col>
                       <el-col :span="5"><div class="header" style="border-left:1px solid #eeeeee;border-right:1px solid #eeeeee;">{{baseInfo.yes_exchange}}</div></el-col>
                       <el-col :span="5"><div class="header" style="border-left:1px solid #eeeeee;border-right:1px solid #eeeeee;">{{baseInfo.yes_points}}</div></el-col>
                       <el-col :span="5"><div class="header">{{baseInfo.yes_money}}</div></el-col>
                   </el-row>
               </div>
               <div class="table-body">
                   <el-row style="width:100%;height:100%" class="row">
                       <el-col :span="4"><div class="header">最近七天成交</div></el-col>
                       <el-col :span="5"><div class="header" style="border-left:1px solid #eeeeee;border-right:1px solid #eeeeee;">{{baseInfo.weeks_order}}</div></el-col>
                       <el-col :span="5"><div class="header" style="border-left:1px solid #eeeeee;border-right:1px solid #eeeeee;">{{baseInfo.weeks_exchange}}</div></el-col>
                       <el-col :span="5"><div class="header" style="border-left:1px solid #eeeeee;border-right:1px solid #eeeeee;">{{baseInfo.weeks_points}}</div></el-col>
                       <el-col :span="5"><div class="header">{{baseInfo.weeks_money}}</div></el-col>
                   </el-row>
               </div>
               <div class="table-body">
                   <el-row style="width:100%;height:100%" class="row">
                       <el-col :span="4"><div class="header">累计成交</div></el-col>
                       <el-col :span="5"><div class="header" style="border-left:1px solid #eeeeee;border-right:1px solid #eeeeee;">{{baseInfo.sum_order}}</div></el-col>
                       <el-col :span="5"><div class="header" style="border-left:1px solid #eeeeee;border-right:1px solid #eeeeee;">{{baseInfo.sum_exchange}}</div></el-col>
                       <el-col :span="5"><div class="header" style="border-left:1px solid #eeeeee;border-right:1px solid #eeeeee;">{{baseInfo.sum_points}}</div></el-col>
                       <el-col :span="5"><div class="header">{{baseInfo.sum_money}}</div></el-col>
                   </el-row>
               </div>
           </div>
           <p>最近七天的走势图 ({{lineChartData.xData[0]}} 到 {{lineChartData.xData[6]}})</p>
            <div class="card-dashboard" id="trend">
                <line-chart :chartData="lineChartData" />
            </div>
        </div>
    </el-card>
     <!-- 链接生成二维码网址 -->
    <CopyDialog :copyDialogVisible="copyDialogVisible" :title="copyTitle" :url="url" @close="closeCopyDialog"/>
  </div>
</template>

<script>
import {queryPointsMallData} from '@/api/app/points'
import CopyDialog from '@/components/CopyDialog'
import LineChart from './LineChart.vue'
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
            url:'',
            baseInfo:{
                'yes_order':0,
                'yes_exchange':0,
                'weeks_order':0,
                'weeks_exchange':0,
                'sum_order':0,
                'sum_exchange':0,
                'yes_points':0,
                'weeks_points':0,
                'sum_points':0,
                'yes_money':0,
                'weeks_money':0,
                'sum_money':0
            },
            lineChartData:{
                data1: [],
                data2: [],
                data3:[],
                data4:[],
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
        this.getPointsDashboard()
    },
    methods:{
        getPointsDashboard(){
            queryPointsMallData({}).then(res=>{
                this.baseInfo=res.data.baseInfo
                this.lineChartData=res.data.lineChartData
            })
        },
        visitPoints(){
            this.copyDialogVisible=true
            this.url='https://www.gawxg.com/jifen/?dealer_id='+this.dealer_id
        },
        closeCopyDialog(val){
            this.copyDialogVisible=val
        },
    }
}
</script>

<style lang="scss" scoped>
.table-box{
    width: 100%;
    height: auto;
    display: flex;
    justify-content: flex-start;
    // align-items: center;
    border: 1px solid #eeeeee;
    flex-direction: column;
    margin-top: 70px;
    .table-head,.table-body{
        width: 100%;
        height: 40px;
        background: #eeeeee;
        display: flex;
        justify-content: center;
        align-items: center;
        font-size: 14px;
        .header{
            width: 100%;
            height: 40px;
            display: flex;
            justify-content: flex-start;
            align-items: center;
            padding-left: 10px;
            border-bottom: 1px solid #eeeeee;
        }
    }
    .table-body{
        background: white;
    }
}
.card-dashboard{
    margin-top: 80px;
    width: 100%;
    height: 500px;
}
</style>
