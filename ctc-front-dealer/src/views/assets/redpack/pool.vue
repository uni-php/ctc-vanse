<template>
  <div class="app-container">
    <div class="tips">
        <p>温馨提示：</p>
        <p>1、当无法开通微信支付红包功能的时候可以使用此功能发放红包；当自己的红包功能开通后，可无缝、无感知的进行切换，之前的数据不受影响；</p>
        <p>2、微信支付红包一般需要满足开户满90天，连续交易30天的条件；</p>
        <p>3、使用此功能需要提前充值代发红包池余额，请保证余额充足，否则红包会发放失败！</p>
    </div>
    <el-card class="box-card">
      <div class="box-card-item">
        <el-row :gutter="20">
          <el-col :span="8">
            <el-card shadow="always">
              <div class="card-box">
                <div class="card-box-item">
                  <span>代发红包池余额</span>
                  <span>
                    <el-tag effect="dark" size="mini">实时</el-tag>
                  </span>
                </div>
                <div class="card-box-items">{{base_info.balance}}</div>
              </div>
            </el-card>
          </el-col>
          <el-col :span="8">
            <el-card shadow="always">
              <div class="card-box">
                <div class="card-box-item">
                  <span>已发放金额</span>
                  <span>
                    <el-tag effect="dark" size="mini">实时</el-tag>
                  </span>
                </div>
                <div class="card-box-items">{{base_info.grant}}</div>
              </div>
            </el-card>
          </el-col>
          <el-col :span="8">
            <el-card shadow="always">
              <div class="card-box">
                <div class="card-box-item">
                  <span>累积充值金额</span>
                  <span>
                     <el-tag effect="dark" size="mini">实时</el-tag>
                  </span>
                </div>
                <div class="card-box-items">{{base_info.recharge_sum}}</div>
              </div>
            </el-card>
          </el-col>
        </el-row>
      </div>
    </el-card>
    <div class="tab-bar">
        <el-form ref="queryForm" :model="queryForm" label-width="100px" :inline="true" size="small">
            <el-form-item label="发放时间" prop="time">
                <el-date-picker
                    style="width:240px"
                    v-model="queryForm.time"
                    type="daterange"
                    unlink-panels=""
                    range-separator="至"
                    value-format="yyyy-MM-dd"
                    start-placeholder="开始日期"
                    end-placeholder="结束日期">
                </el-date-picker>
            </el-form-item>
            <el-form-item label="发放应用" prop="scene">
                <el-select style="width:240px"  v-model="queryForm.scene" placeholder="请选择红包发放应用">
                    <el-option
                        v-for="item in redpackAppOptions"
                        :key="item.dict_value"
                        :label="item.dict_label"
                        :value="item.dict_value">
                    </el-option>
                </el-select>
            </el-form-item>
            <el-form-item label="发放openid" prop="openid">
                <el-input style="width:240px" v-model="queryForm.openid" placeholder="发放openid"></el-input>
            </el-form-item> 
            <el-form-item label="红包ID" prop="redpack_id">
                <el-input style="width:240px" v-model="queryForm.redpack_id" placeholder="请输入红包ID"></el-input>
            </el-form-item> 
            <el-form-item label="活动ID" prop="activity_id">
                <el-input style="width:240px" v-model="queryForm.activity_id" placeholder="请输入活动ID"></el-input>
            </el-form-item>
            <el-form-item> 
                <el-button type="primary" icon="el-icon-search" @click="query">查询</el-button>
                <el-button icon="el-icon-refresh" @click="resetQuery('queryForm')">重置</el-button>
            </el-form-item> 
        </el-form>
    </div>
    <!-- 表格 -->
    <el-table
        :data="tableData"
        :header-cell-style="{background:'#FAFAFA',color:'#606266',height:'50px'}"
        border
        stripe
        size="medium"
        class="trace-table"
        style="width: 100%">
        <el-table-column prop="id" align="center" label="ID"></el-table-column>
        <el-table-column prop="create_time" align="center" label="时间"></el-table-column>
        <el-table-column prop="money" align="center" label="发放金额"></el-table-column>
        <el-table-column prop="balance" align="center" label="发放后余额"></el-table-column>
        <el-table-column prop="openid" align="center" label="openid"></el-table-column>
        <el-table-column prop="app_id" align="center" label="发放应用(活动主题-ID)" :formatter="app"></el-table-column>
        <el-table-column prop="redpack_id" align="center" label="红包ID"></el-table-column>
    </el-table>
    <pagination
        v-show="+total>10"
        :total="+total"
        :page.sync="queryForm.pageNum"
        :limit.sync="queryForm.pageSize"
        @pagination="getList"/>
  </div>
</template>

<script>
import {getRedpackPoolInfo,getRedpackGrantList} from '@/api/assets/redpack'
export default {
    data(){
        return{
            base_info:{
                recharge_sum:'',
                grant:'',
                balance:''
            },
            total:0,
            tableData:[],
            queryForm:{
                time:[],
                scene:'',
                openid:'',
                redpack_id:'',
                activity_id:'',
                pageNum:1,
                pageSize:10
            },
            redpackAppOptions:[]
        }
    },
    created(){
        this.getList()
        this.getRedpackPool()
        this.getDicts({type:'redpack_grant_app'}).then(res=>{
            this.redpackAppOptions=res.data
        })
    },
    methods:{
        getList(){
            var params=Object.assign({},this.queryForm)
            if(!this.queryForm.time||this.queryForm.time.length==0){
                params.startTime=''
                params.endTime=''
            }else{
                params.startTime=this.queryForm.time[0]
                params.endTime=this.queryForm.time[1]
            }
            delete params.time
            getRedpackGrantList(params).then(res=>{
                this.tableData=res.data
                this.total=res.total
            })
        },
        app(row){
            if(row.app_id){
                return this.redpackAppOptions.filter(item=>item.dict_value==row.app_id).map(item=>item.dict_label)[0]
            }else{
                //活动主题
                return row.activity_id
            }
        },
        getRedpackPool(){
            getRedpackPoolInfo({}).then(res=>{
                this.base_info=res.data
            })
        },
        query(){
            this.queryForm.pageNum = 1;
            this.getList();
        },
        resetQuery(formName){
            this.$refs[formName].resetFields();
            this.query()
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
    p{
        font-size: 14px;
    }
}
 .box-card{
    margin-bottom: 30px;
  }
  .box-card-item{
    ::v-deep .el-card__body{
      padding-bottom: 0;
      padding-top: 0;
    }
  }
  .card-box{
    width: 100%;
    height: 120px;
    display: flex;
    flex-direction: column;
    .card-box-item{
      display: flex;
      justify-content: space-between;
      align-items: center;
      width: 100%;
      height: 40%;
      font-size: 16px;
      color: #303133;
    }
    .card-box-items{
      display: flex;
      justify-content: space-between;
      align-items: center;
      width: 100%;
      height: 60%;
      border-top: 1px solid #eeeeee;
      font-size: 26px;
      color: #303133;
      font-weight: 600;
    }
  }
</style>>