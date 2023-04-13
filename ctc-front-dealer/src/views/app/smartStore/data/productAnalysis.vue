<template>
  <div class="app-container">
    <el-row :gutter="20">
          <el-col :span="6">
                <el-card class="box-card">
                    <div slot="header" class="trace-header">
                        <span>昨日成交商品</span>
                        <el-tag effect="dark"  size="mini">个</el-tag>
                    </div>
                    <div class="trace-surplus">
                       {{traceInfo[0]}}
                    </div>
                    <div class="trace-footer">
                    </div>
                </el-card>
          </el-col>
          <el-col :span="6">
                <el-card class="box-card">
                    <div slot="header" class="trace-header">
                        <span>昨日成交件数</span>
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
                        <span>成交商品总数</span>
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
                        <span>成交商品总金额</span>
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
    <div class="tab-bar" style="margin-top:30px">
        <el-form ref="queryForm" :model="queryForm" label-width="100px" :inline="true" size="small">
          <el-form-item label="门店" prop="store_id">
            <el-select style="width:220px" size="small" v-model="queryForm.store_id" placeholder="请选择">
                <el-option
                    v-for="item in storeTableData"
                    :key="item.id"
                    :label="item.store_name"
                    :value="item.id">
                </el-option>
            </el-select>
          </el-form-item>
          <el-form-item label="时间" prop="time">
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
            <el-form-item >
                <el-button type="primary" icon="el-icon-search" @click="query">查询</el-button>
                <el-button icon="el-icon-refresh" @click="resetQuery('queryForm')">重置</el-button>
            </el-form-item>
        </el-form>
    </div>
    <el-table
           :data="tableData"
           :header-cell-style="{background:'#FAFAFA',color:'#606266',height:'50px'}"
           border
           stripe
           size="medium"
           class="trace-table"
           style="width: 100%">
           <el-table-column prop="product_name" align="center" label="商品名称"></el-table-column>
           <el-table-column prop="person" align="center" label="下单人数"></el-table-column>
           <el-table-column prop="deal_num" align="center" label="成交件数"></el-table-column>
           <el-table-column prop="money" align="center" label="成交金额"></el-table-column>
    </el-table>
    <pagination
           v-show="+total>10"
           :total="+total"
           :page.sync="queryForm.pageNum"
           :limit.sync="queryForm.pageSize"
           @pagination="getProductAnalysisData"/>
  </div>
</template>

<script>
import {getStoreList} from '@/api/app/store/index'
import {getProductAnalysisData,getProductPanelAnalysisData} from '@/api/app/store/data'
export default {
  data(){
    return{
      storeTableData:[],
      tableData:[],
      total:0,
      queryStoreForm:{
          store_code:'',
          store_name:'',
          is_mall:'',
          is_self:'',
          is_commission:'',
          pageNum:1,
          pageSize:999
      },
      traceInfo:[],
      queryForm:{
        store_id:'',
        time:[],
        pageNum:1,
        pageSize:10
      }
    }
  },
  watch:{
    'queryForm.store_id': {
      handler(newVal, oldVal) {
        if(newVal){
          this.getProductAnalysisData()
        }
      },
      immediate: true,
    }
  },
  created(){
    this.getStoreList()
    this.getProductPanelAnalysisData()
  },
  methods:{
    getProductPanelAnalysisData(){
        getProductPanelAnalysisData({}).then(res=>{
            this.traceInfo=res.data
        })
    },
    getStoreList(){
      var params=Object.assign({},this.queryStoreForm)
      getStoreList(params).then(res=>{
          this.storeTableData=res.data
      })
    },
    getProductAnalysisData(){
        var params=Object.assign({},this.queryForm)
        if(!this.queryForm.time||this.queryForm.time.length==0){
            params.startTime=''
            params.endTime=''
        }else{
            params.startTime=this.queryForm.time[0]
            params.endTime=this.queryForm.time[1]
        }
        delete params.time
        params.status=this.activeName
        getProductAnalysisData(params).then(res=>{
            this.tableData=res.data
            this.total=res.total
        })
    },
    query(){
          this.queryForm.pageNum = 1;
          this.getProductAnalysisData();
    },
    resetQuery(formName){
        this.$refs[formName].resetFields();
        this.query()
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
