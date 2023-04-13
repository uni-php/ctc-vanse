<template>
  <div class="app-container">
    <div class="tips">
        <p>数据非实时显示，数据统计截止到前一天。</p>
    </div>
    <div class="tab-bar">
        <el-form ref="queryForm" :model="queryForm" label-width="100px" :inline="true" size="small">
               <el-form-item label="领奖时间" prop="time">
                <el-date-picker
                    style="width:220px"
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
                <el-button icon="el-icon-refresh" @click="reset('queryForm')">重置</el-button>
            </el-form-item> 
        </el-form>
    </div>
    <div class="map" id="map">
        <china-map :user-json="objectData" ></china-map>
    </div>
  </div>
</template>

<script>
import {getScanArea} from '@/api/app/qrcode/data'
import ChinaMap from '@/components/ChinaMap'
export default {
     components: {
        ChinaMap
    },
    data(){
        return{
            objectData:[],//[{value: 2, name: '上海'}, {value:3,name: '北京'}],
            baseInfo:[],
            queryForm:{
                time:[]
            }
        }
    },
    created(){
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
       query(){
          this.getScanArea();
        },
        reset(formName){
            this.$refs[formName].resetFields();
            this.query()
        },
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