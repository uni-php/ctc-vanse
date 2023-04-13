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
                <el-form-item label="生产批次" prop="product_batch">
                    <el-input style="width:220px" v-model="queryForm.product_batch" placeholder="请输入生产批次"></el-input>
                </el-form-item>
                <el-form-item label="产品名称" prop="product_name">
                    <el-input style="width:220px" v-model="queryForm.product_name" placeholder="请输入产品名称"></el-input>
                </el-form-item>
                <el-form-item label="溯源码流水号" prop="serial_number">
                    <el-input style="width:220px" v-model="queryForm.serial_number" placeholder="请输入溯源码流水号"></el-input>
                </el-form-item>
                <el-form-item label="扫码者昵称" prop="nickname">
                    <el-input style="width:220px" v-model="queryForm.nickname" placeholder="请输入扫码者昵称"></el-input>
                </el-form-item>
                <el-form-item label="扫码地区" prop="address">
                    <el-input style="width:220px" v-model="queryForm.address" placeholder="请输入扫码地区"></el-input>
                </el-form-item>
                <el-form-item label="手机号" prop="phone">
                    <el-input style="width:220px" v-model="queryForm.phone" placeholder="请输入手机号"></el-input>
                </el-form-item>
                <el-form-item label="码批次" prop="code_batch">
                    <el-select style="width:220px" size="small" v-model="queryForm.code_batch" placeholder="请选择码批次">
                        <el-option
                                v-for="item in codeBatchOptions"
                                :key="item.id"
                                :label="item.batch+'--'+'('+item.order_begin+'~'+item.order_end+')'"
                                :value="item.batch">
                            </el-option>
                    </el-select>
                </el-form-item>
                <el-form-item label="扫码结果" prop="is_first">
                    <el-select style="width:220px" size="small" v-model="queryForm.is_first" placeholder="请选择扫码结果">
                        <el-option
                                v-for="item in resultOptions"
                                :key="item.value"
                                :label="item.label"
                                :value="item.value">
                            </el-option>
                    </el-select>
                </el-form-item>
                <el-form-item label="防伪验证" prop="security">
                    <el-select style="width:220px" size="small" v-model="queryForm.security" placeholder="请选择防伪验证">
                        <el-option
                                v-for="item in securityOptions"
                                :key="item.value"
                                :label="item.label"
                                :value="item.value">
                            </el-option>
                    </el-select>
                </el-form-item>
                <el-form-item label="扫码方式" prop="scan_type">
                    <el-select style="width:220px"  v-model="queryForm.scan_type" placeholder="请选择扫码方式">
                        <el-option
                            v-for="item in scanTypeOptions"
                            :key="item.dict_value"
                            :label="item.dict_label"
                            :value="item.dict_value">
                        </el-option>
                    </el-select>
                </el-form-item>
                <el-form-item> 
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
            <el-table-column prop="user_id" align="center" label="用户ID"></el-table-column>
            <el-table-column prop="nickname" align="center" label="用户昵称"></el-table-column>
            <el-table-column prop="code" align="center" label="溯源码"></el-table-column>
            <el-table-column prop="serial_number" align="center" label="流水号"></el-table-column>
            <el-table-column prop="result" align="center" label="扫码结果" :formatter="result"></el-table-column>
            <el-table-column prop="scan_type" align="center" label="扫码方式" :formatter="scan_type"></el-table-column>
            <el-table-column prop="product_name" align="center" label="产品名称"></el-table-column>
            <el-table-column prop="product_batch" align="center" label="生产批次号"></el-table-column>
            <el-table-column prop="security" align="center" label="防伪验证" :formatter="security"></el-table-column>
            <el-table-column prop="create_time" align="center" label="扫码时间"></el-table-column>
            <el-table-column prop="address" align="center" label="扫码地区"></el-table-column>
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
import {getTraceCodeBatch} from '@/api/codeStore/qrcode'
import {getTraceQueryDetail} from '@/api/app/trace'
export default {
    data(){
        return{
            queryForm:{
                time:[],
                product_batch:'',
                product_name:'',
                serial_number:'',
                nickname:'',
                address:'',
                phone:'',
                code_batch:'',//溯源码批次
                is_first:'',
                security:'',
                scan_type:'',
                pageNum:1,
                pageSize:10
            },
            codeBatchOptions:[],
            scanTypeOptions:[],
            resultOptions:[
                {
                    label:'首次',
                    value:1
                },
                {
                    label:'重复',
                    value:0
                }
            ],
            securityOptions:[
                {
                    label:'已验证',
                    value:1
                },
                {
                    label:'未验证',
                    value:2
                }
            ],
            tableData:[],
            total:0
        }
    },
    created(){
        this.getTraceCodeBatch()
        this.getDicts({type:'scan_type'}).then(res=>{
            this.scanTypeOptions=res.data
        })
        this.getList()
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
            getTraceQueryDetail(params).then(res=>{
                this.tableData=res.data
                this.total=res.total
            })
        },
        result(row){
            return this.resultOptions.filter(item=>item.value==row.is_first).map(item=>item.label)[0]
        },
        scan_type(row){
            return this.scanTypeOptions.filter(item=>item.dict_value==row.scan_type).map(item=>item.dict_label)[0]
        },
        security(row){
            return this.securityOptions.filter(item=>item.dict_value==row.security).map(item=>item.dict_label)[0]
        },
        getTraceCodeBatch(){
            getTraceCodeBatch({}).then(res=>{
               this.codeBatchOptions=res.data 
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

<style>

</style>