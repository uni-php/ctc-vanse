<template>
  <div class="app-container">
      <el-row :gutter="20">
        <el-col :span="6">
                <el-card class="box-card">
                    <div slot="header" class="trace-header">
                        <span>导购总数</span>
                        <el-tag effect="dark"  size="mini">个</el-tag>
                    </div>
                    <div class="trace-surplus">
                       {{baseInfo[0]}}
                    </div>
                    <div class="trace-footer">
                        <el-link type="primary"></el-link>
                        <el-tooltip class="item" effect="dark" content="统计注册导购总数" placement="top">
                            <i style="font-size:18px" class="el-icon-warning-outline"></i>
                        </el-tooltip>
                    </div>
                </el-card>
          </el-col>
          <el-col :span="6">
                <el-card class="box-card">
                    <div slot="header" class="trace-header">
                        <span>活动参与总量</span>
                        <el-tag effect="dark"  size="mini">次</el-tag>
                    </div>
                    <div class="trace-surplus">
                       {{baseInfo[1]}}
                    </div>
                    <div class="trace-footer">
                        <el-link type="primary"></el-link>
                        <el-tooltip class="item" effect="dark" content="统计扫码参与活动的总数量" placement="top">
                            <i style="font-size:18px" class="el-icon-warning-outline"></i>
                        </el-tooltip>
                    </div>
                </el-card>
          </el-col>
          <el-col :span="6">
                <el-card class="box-card">
                    <div slot="header" class="trace-header">
                        <span>累积中奖金额</span>
                        <el-tag effect="dark"  size="mini">元</el-tag>
                    </div>
                    <div class="trace-surplus">
                       {{baseInfo[2]}}
                    </div>
                    <div class="trace-footer">
                        <el-link type="primary"></el-link>
                        <el-tooltip class="item" effect="dark" content="统计已发放成功的红包金额" placement="top">
                        <i style="font-size:18px" class="el-icon-warning-outline"></i>
                        </el-tooltip>
                    </div>
                </el-card>
          </el-col>
          <el-col :span="6">
                <el-card class="box-card">
                    <div slot="header" class="trace-header">
                        <span>扫码总量</span>
                        <el-tag effect="dark"  size="mini">次</el-tag>
                    </div>
                    <div class="trace-surplus">
                       {{baseInfo[3]}}
                    </div>
                    <div class="trace-footer">
                        <el-link type="primary"></el-link>
                        <el-tooltip class="item" effect="dark" content="统计扫码总次数，每扫码一次就会增加一次" placement="top">
                        <i style="font-size:18px" class="el-icon-warning-outline"></i>
                        </el-tooltip>
                    </div>
                </el-card>
          </el-col>
      </el-row>
      <el-row :gutter="20">
          <el-col :span="24">
            <el-card class="box-card">
                <div slot="header" class="clearfix">
                    <span>扫码地区分布</span>
                    <!-- <el-button style="float: right; padding: 3px 0" type="text">操作按钮</el-button> -->
                </div>
                <div class="map" id="map">
                   <china-map :user-json="objectData" ></china-map>
                </div>
            </el-card>
          </el-col>
      </el-row>
  </div>
</template>

<script>
import BarChart from '@/components/BarChart.vue'
import RoseChart from '@/components/RoseChart'
import LineChart from '@/components/LineChart'
import ChinaMap from '@/components/ChinaMap'
import {getPageData,getScanArea} from '@/api/app/guide/data'
export default {
    components: {
        BarChart,
        RoseChart,
        LineChart,
        ChinaMap
    },
    data(){
        return{
            baseInfo:[],
            id:'trend',
            xData:[],
            dataList:[],
            max:undefined,
            seriesType:'line',
            queryForm:{
                time:[]
            },
            objectData:[],//[{value: 2, name: '上海'}, {value:3,name: '北京'}],
        }
    },
    created(){
        this.getPageData()
        this.getScanArea()
    },
    methods:{
        getScanArea(){
            var params=Object.assign({},this.queryForm)
            if(!this.queryForm.time||this.queryForm.time.length==0){
                params.startTime=''
                params.endTime=''
            }else{
                params.startTime=this.queryForm.time[0]
                params.endTime=this.queryForm.time[1]
            }
            delete params.time
           getScanArea(params).then(res=>{
                this.objectData=res.data
           })
       },
        getPageData(){
            getPageData({}).then(res=>{
                this.baseInfo=res.data
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
