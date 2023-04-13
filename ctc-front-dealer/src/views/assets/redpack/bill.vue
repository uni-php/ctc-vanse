<template>
  <div class="app-container">
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
            <el-form-item label="搜索方式" prop="keywords">
                <el-input placeholder="请输入内容"  style="width:240px" v-model="queryForm.keywords" class="input-with-select">
                    <el-select style="width:100px" v-model="queryForm.type" slot="prepend" placeholder="请选择">
                    <el-option label="会员ID" value="1"></el-option>
                    <el-option label="手机号" value="2"></el-option>
                    <el-option label="openid" value="3"></el-option>
                    </el-select>
                </el-input>
            </el-form-item>
            <el-form-item label="红包ID" prop="redpack_id">
                <el-input style="width:240px" v-model="queryForm.redpack_id" placeholder="红包ID"></el-input>
            </el-form-item>
            <el-form-item label="红包类型" prop="redpack_type">
                <el-select style="width:240px"  v-model="queryForm.redpack_type" placeholder="请选择红包类型">
                    <el-option
                        v-for="item in redpackTypeOptions"
                        :key="item.dict_value"
                        :label="item.dict_label"
                        :value="item.dict_value">
                    </el-option>
                </el-select>
            </el-form-item>
            <el-form-item label="发放应用" prop="app_id">
                <el-select style="width:240px"  v-model="queryForm.app_id" placeholder="请选择红包发放应用">
                    <el-option
                        v-for="item in redpackAppOptions"
                        :key="item.dict_value"
                        :label="item.dict_label"
                        :value="item.dict_value">
                    </el-option>
                </el-select>
            </el-form-item>
            <el-form-item label="备注" prop="remark">
                <el-input style="width:240px" v-model="queryForm.remark" placeholder="备注"></el-input>
            </el-form-item>
            <el-form-item label="微信业务单号" prop="billno">
                <el-input style="width:240px" v-model="queryForm.billno" placeholder="微信业务单号"></el-input>
            </el-form-item>
            <el-form-item label="发放状态" prop="status">
                <el-select style="width:240px"  v-model="queryForm.status" placeholder="请选择发放状态">
                    <el-option
                        v-for="item in statusOptions"
                        :key="item.dict_value"
                        :label="item.dict_label"
                        :value="item.dict_value">
                    </el-option>
                </el-select>
            </el-form-item>
            <el-form-item label="发放角色" prop="role">
                <el-select style="width:240px"  v-model="queryForm.role" placeholder="请选择发放角色">
                    <el-option
                        v-for="item in roleOptions"
                        :key="item.dict_value"
                        :label="item.dict_label"
                        :value="item.dict_value">
                    </el-option>
                </el-select>
            </el-form-item>
            <el-form-item label="经销商编号" prop="dealer_num">
                <el-input style="width:240px" v-model="queryForm.dealer_num" placeholder="经销商编号"></el-input>
            </el-form-item>
            <el-form-item> 
                <el-button type="primary" icon="el-icon-search" @click="query">查询</el-button>
                <el-button icon="el-icon-refresh" @click="resetQuery('queryForm')">重置</el-button>
            </el-form-item>
          </el-form>
      </div>
    <!-- <el-col :span="24" style="margin:10px 0;">
        <el-button @click="handleExport" type="primary" size="small" >导出</el-button>
    </el-col> -->
      <el-table
        :data="tableData"
        :header-cell-style="{background:'#FAFAFA',color:'#606266',height:'50px'}"
        border
        stripe
        size="medium"
        class="trace-table"
        style="width: 100%">
        <el-table-column prop="openid" align="center" label="发放人(openid)"></el-table-column>
        <el-table-column prop="redpack_type" align="center" label="红包类型" :formatter="type"></el-table-column>
        <el-table-column prop="redpack_id" align="center" label="红包ID"></el-table-column>
        <el-table-column prop="money" align="center" label="红包金额"></el-table-column>
        <el-table-column prop="status" align="center" label="发放状态" :formatter="grantStatus"></el-table-column>
        <el-table-column prop="app_id" align="center" label="发放应用" :formatter="app"></el-table-column>
        <el-table-column prop="role" align="center" label="发放角色">
            <template slot-scope="scope">
                {{scope.row.role==1?'总部':'经销商'}}
            </template>
        </el-table-column>
        <el-table-column prop="remark" align="center" label="备注" show-overflow-tooltip=""></el-table-column>
        <el-table-column prop="mch_billno" align="center" label="微信业务单号"></el-table-column>
        <el-table-column prop="create_time" align="center" label="发放时间"></el-table-column>
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
import {getRedpackGrantBill} from '@/api/assets/redpack'
export default {
    data(){
        return{
            queryForm:{
                time:[],
                type:'1',
                keywords:'',
                redpack_id:'',
                redpack_type:'',
                app_id:'',
                remark:'',
                billno:'',
                status:'',
                role:'',
                dealer_num:'',
                pageNum:1,
                pageSize:10
            },
            tableData:[],
            total:0,
            redpackTypeOptions:[],
            redpackAppOptions:[],
            statusOptions:[],
            roleOptions:[
                {
                    dict_value:'1',
                    dict_label:'总部'
                },
                {
                    dict_value:'2',
                    dict_label:'经销商'
                }
            ]
        }
    },
    created(){
        this.getList()
        this.getDicts({type:'redpack_type'}).then(res=>{
            this.redpackTypeOptions=res.data
        })
        this.getDicts({type:'redpack_grant_status'}).then(res=>{
            this.statusOptions=res.data
        })
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
            getRedpackGrantBill(params).then(res=>{
                this.tableData=res.data
                this.total=res.total
            })
        },
        type(row){
            return this.redpackTypeOptions.filter(item=>item.dict_value==row.redpack_type).map(item=>item.dict_label)[0]
        },
        grantStatus(row){
            return this.statusOptions.filter(item=>item.dict_value==row.status).map(item=>item.dict_label)[0]
        },
        app(row){
            return this.redpackAppOptions.filter(item=>item.dict_value==row.app_id).map(item=>item.dict_label)[0]
        },
        handleExport(){

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

<style>

</style>