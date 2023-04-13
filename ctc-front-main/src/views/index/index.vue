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
                <div class="card-box-items">{{base_info.code.dayNum}}</div>
                <div class="card-box-item">
                  <span>平台总生码量</span>
                  <span>{{base_info.code.sumNum}}</span>
                </div>
              </div>
            </el-card>
          </el-col>
          <el-col :span="6">
            <el-card shadow="always">
              <div class="card-box">
                <div class="card-box-item">
                  <span>红包剩余量</span>
                  <span>
                    <el-tag effect="dark" size="mini">实时</el-tag>
                  </span>
                </div>
                <div class="card-box-items">{{base_info.resPack.surplus}}</div>
                <div class="card-box-item">
                  <span>红包总量</span>
                  <span>{{base_info.resPack.sumNum}}</span>
                </div>
              </div>
            </el-card>
          </el-col>
          <el-col :span="6">
            <el-card shadow="always">
              <div class="card-box">
                <div class="card-box-item">
                  <span>合伙人余额</span>
                  <span>
                    <el-tooltip class="item" effect="dark" :content="base_info.partner.mark" placement="top">
                      <i class="el-icon-info"></i>
                    </el-tooltip>
                  </span>
                </div>
                <div class="card-box-items">{{base_info.partner.surplus}}</div>
                <div class="card-box-item">
                  <span>合伙人预存款</span>
                  <span>{{base_info.partner.deposit}}</span>
                </div>
              </div>
            </el-card>
          </el-col>
          <el-col :span="6">
            <el-card shadow="always">
              <div class="card-box">
                <div class="card-box-item">
                  <span>日扫码量</span>
                  <span>
                    <el-tag effect="dark" size="mini">实时</el-tag>
                  </span>
                </div>
                <div class="card-box-items">{{base_info.scan.dayNum}}</div>
                <div class="card-box-item">
                  <span>总扫码量</span>
                  <span>{{base_info.scan.sumNum}}</span>
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
          <el-col :span="8">
            <el-card shadow="always">
              <div slot="header" style="display:flex;justify-content: space-between">
                <span>访问量</span>
                <span>
                    <el-tag effect="dark" size="mini">每周</el-tag>
                </span>
              </div>
              <div class="card-dashboard" id="scan">
                 <EchartsLine :id="id1" :xData='xData' :dataList='dataList' :max='max' :seriesType='seriesType1'></EchartsLine>
              </div>
            </el-card>
          </el-col>
          <el-col :span="8">
            <el-card shadow="always">
              <div slot="header" style="display:flex;justify-content: space-between">
                <span>代理商数量</span>
                <span>
                    <el-tag effect="dark" size="mini">每周</el-tag>
                </span>
              </div>
              <div class="card-dashboard" id="agent">
                 <EchartsBar :id="id2" :xData='xData' :dataList='dataList2' :max='max' :seriesType='seriesType2'></EchartsBar>
              </div>
            </el-card>
          </el-col>
          <el-col :span="8">
            <el-card shadow="always">
              <div slot="header" style="display:flex;justify-content: space-between">
                <span>客户来源</span>
                <span>
                    <el-tag effect="dark" size="mini">每周</el-tag>
                </span>
              </div>
              <div class="card-dashboard" id="user">
                 <EchartsPie :id="id3" :dataList='pieItems'></EchartsPie>
              </div>
            </el-card>
          </el-col>
        </el-row>
      </div>
    </el-card>
  </div>
</template>
<script>
import { getList,getCompanyType,addCompany,updateCompany,freeze } from '@/api/company'
import EchartsLine from "@/components/EchartsLine"
import EchartsBar from "@/components/EchartsBar"
import EchartsPie from "@/components/EchartsPie"
export default {
  components:{EchartsLine,EchartsBar,EchartsPie},
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
      max:undefined
    }
  },
  created() {
  },
  filters:{
    
  },
  methods: {
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
