<template>
  <div class="app-container">
    <div class="tab-bar">
        <el-form ref="queryForm" :model="queryForm" label-width="100px" :inline="true" size="small">
            <el-form-item label="扫码时间" prop="time">
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
            <el-form-item label="扫码结果" prop="res_status">
                <el-select style="width:220px" v-model="queryForm.res_status" placeholder="请选择扫码结果">
                    <el-option
                        v-for="item in resOption"
                        :key="item.value"
                        :label="item.label"
                        :value="item.value">
                    </el-option>
                </el-select>
            </el-form-item>
            <el-form-item label="手机号码" prop="phone">
                <el-input style="width:220px" v-model="queryForm.phone" placeholder="请输入收集号码"></el-input>
            </el-form-item>
             <el-form-item label="IP地址" prop="ip">
                <el-input style="width:220px" v-model="queryForm.ip" placeholder="请输入IP地址"></el-input>
            </el-form-item>
            <el-form-item label="生码批次号" prop="code_batch">
                <el-select style="width:220px" v-model="queryForm.code_batch" placeholder="请选择生码批次">
                    <el-option
                        v-for="item in codeBatchOptions"
                        :key="item.id"
                        :label="item.batch+'--'+'('+item.order_begin+'~'+item.order_end+')'"
                        :value="item.batch">
                    </el-option>
                </el-select>
            </el-form-item>
            <el-form-item label="导购" prop="name">
                <el-input style="width:220px" v-model="queryForm.name" placeholder="请输入导购姓名"></el-input>
            </el-form-item>
            <el-form-item label="OPENID" prop="openid">
                <el-input style="width:220px" v-model="queryForm.openid" placeholder="请输入会员openid"></el-input>
            </el-form-item>
             <el-form-item label="二维码编号" prop="code">
                <el-input style="width:220px" v-model="queryForm.code" placeholder="请输入二维码编号"></el-input>
            </el-form-item>
            <el-form-item label="导购分组" prop="group">
                <el-select style="width:220px" v-model="queryForm.group" placeholder="请选择导购分组">
                    <el-option
                        v-for="item in groupOption"
                        :key="item.id"
                        :label="item.group_name"
                        :value="item.id">
                    </el-option>
                </el-select>
            </el-form-item>
            <el-form-item >
                <el-button type="primary" icon="el-icon-search" @click="query">查询</el-button>
                <el-button icon="el-icon-refresh" @click="reset('queryForm')">重置</el-button>
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
        <el-table-column prop="uid" width="80" align="center" label="用户ID"></el-table-column>
        <!-- <el-table-column prop="ip" align="center" label="IP地址"></el-table-column> -->
        <el-table-column prop="name" show-overflow-tooltip="" align="center" label="导购员"></el-table-column>
        <el-table-column prop="headimgurl" width="80" align="center" label="头像">
            <template slot-scope="scope">
                <el-avatar :size="35" :src="scope.row.headimgurl" @error="errorHandler">
                    <img src="https://cube.elemecdn.com/e/fd/0fc7d20532fdaf769a25683617711png.png"/>
                </el-avatar>
            </template>
        </el-table-column>
        <el-table-column prop="code" align="center" label="二维码编号"></el-table-column>
        <el-table-column prop="batch" align="center" label="数码批次"></el-table-column>
        <el-table-column prop="scan_res" align="center" label="扫码结果">
            <template slot-scope="scope">
                {{scope.row.is_first==1?'首次':'重复'}}
            </template>
        </el-table-column>
        <el-table-column prop="product" align="center" label="产品名称">
            <template slot-scope="scope">
                {{scope.row.product_name||'--'}}
            </template>
        </el-table-column>
        <el-table-column prop="create_time" align="center" label="扫码时间"></el-table-column>
        <el-table-column prop="address" align="center" label="扫码地区">
            <template slot-scope="scope">
                {{scope.row.province}}{{scope.row.city}}
            </template>
        </el-table-column>
        <!-- <el-table-column label="操作" align="center" fixed="right" width="240px">
            <template slot-scope="scope">
                <el-button
                    size="mini"
                    type="text"
                    @click="handleView(scope.row)">详情</el-button>
            </template>
        </el-table-column> -->
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
import {getGuideCodeBatch} from '@/api/codeStore/qrcode'
import {getScanBill} from '@/api/app/guide/activity'
import {getGuideGroupList} from '@/api/app/guide/group'
export default {
    data(){
        return{
            queryGuideGroupForm:{
                pageNum:1,
                pageSize:999,
            },
            codeBatchOptions:[],
            queryForm:{
                time:[],
                res_status:'',
                phone:'',
                group:'',
                ip:'',
                code:'',
                code_batch:'',
                name:'',
                openid:'',
                pageNum:1,
                pageSize:10
            },
            groupOption:[],
            tableData:[],
            total:0,
            resOption:[
                {
                    label:'首次',
                    value:1
                },
                {
                    label:'重复',
                    value:2
                }
            ]
        }
    },
    created(){
        this.getGuideCodeBatch()
        this.getGuideGroupList()
        this.getList()
    },
    methods:{
        getGuideCodeBatch(){
          getGuideCodeBatch({}).then(res=>{
               this.codeBatchOptions=res.data
            })
        },
        getGuideGroupList(){
          getGuideGroupList(this.queryGuideGroupForm).then(res=>{
            this.groupOption = res.data
          })
        },
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
            getScanBill(params).then(res=>{
                this.tableData=res.data
                this.total=res.total
            })
        },
        handleView(){

        },
        errorHandler() {
            return true
        },
        query(){
          this.queryForm.pageNum = 1;
          this.getList();
        },
        reset(formName){
            this.$refs[formName].resetFields();
            this.query()
        },
    }
}
</script>

<style>

</style>
