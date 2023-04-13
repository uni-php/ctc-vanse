<template>
  <div class="app-container">
    <div class="tips">
        <p>可通过溯源码或者生产批次号查询追溯信息。</p>
    </div>
    <div class="tab-bar">
        <el-form ref="queryForm" :model="queryForm" label-width="100px" :rules="rule" :inline="true" size="small">
            <el-form-item label="可选码批次" prop="code_batch" v-if="queryForm.type==1">
                <el-select style="width:220px" size="small" @change="changeCodeBatch" v-model="queryForm.code_batch" placeholder="请选择码批次">
                    <el-option
                        v-for="item in codeBatchOptions"
                        :key="item.id"
                        :label="item.batch+'--'+'('+item.order_begin+'~'+item.order_end+')'"
                        :value="item.batch">
                    </el-option>
                </el-select>
            </el-form-item>
            <el-form-item label="类型" prop="content">
                <el-input style="width:360px" v-model="queryForm.content" placeholder="">
                    <el-select style="width:140px" v-model="queryForm.type" slot="prepend" placeholder="请选择">
                        <el-option label="溯源码流水号" value="1"></el-option>
                        <el-option label="生产批次号" value="2"></el-option>
                    </el-select>
                </el-input>
            </el-form-item>
            <el-form-item > 
                <el-button type="primary" icon="el-icon-search" @click="query">查询</el-button>
                <el-button icon="el-icon-refresh" @click="reset('queryForm')">重置</el-button>
            </el-form-item> 
        </el-form>
    </div>
    <div class="content-box">
        <el-collapse v-if="is_active" v-model="activeNames" @change="handleChange">
            <el-collapse-item  name="1">
                <template slot="title">
                产品信息<i class="header-icon el-icon-info"></i>
                </template>
                <div>
                    <el-descriptions title="" :column="1">
                        <el-descriptions-item label="产品编号">{{traceInfo.code}}</el-descriptions-item>
                        <el-descriptions-item label="产品名称">{{traceInfo.product_name}}</el-descriptions-item>
                        <el-descriptions-item label="产品图片">
                             <span style="margin-left:10px" class="block" v-for="(item,index) in JSON.parse(traceInfo.cover) " :key="index">
                                <el-image
                                style="width: 100px; height: 100px"
                                :src="item.url"
                                fit="fill"></el-image>
                             </span>
                        </el-descriptions-item>
                        <el-descriptions-item label="产品详情">
                            <div style="margin-top:-14px" v-html="traceInfo.details">{{traceInfo.details}}</div>
                        </el-descriptions-item>
                    </el-descriptions>
                </div>
            </el-collapse-item>
            <el-collapse-item  name="2">
                <template slot="title">
                生产批次信息<i class="header-icon el-icon-info"></i>
                </template>
                <div>
                    <el-descriptions title="" :column="1">
                        <el-descriptions-item label="生产批次号">{{traceInfo.product_batch}}</el-descriptions-item>
                        <el-descriptions-item label="产品名称">{{traceInfo.product_name}}</el-descriptions-item>
                        <el-descriptions-item label="批次备注">{{traceInfo.remark}}</el-descriptions-item>
                        <el-descriptions-item label="批次信息">
                            <!-- 生产批次 -->
                            <el-tabs v-model="editableTabsValue" type="card">
                                <el-tab-pane
                                    :key="index"
                                    v-for="(item, index) in JSON.parse(traceInfo.batch_content)"
                                    :label="item.title+(index+1)"
                                    :name="item.name"
                                >
                                    <QiniuEditor v-model="item.content" style="width:90%" :min-height="300"/>
                                </el-tab-pane>
                            </el-tabs>
                        </el-descriptions-item>
                    </el-descriptions>
                </div>
            </el-collapse-item>
        </el-collapse>
        <el-empty v-if="!is_active" :image-size="200" description="暂无信息"></el-empty>
    </div>
  </div>
</template>

<script>
import {queryTraceInfo} from '@/api/app/trace'
import {getTraceCodeBatch} from '@/api/codeStore/qrcode'
export default {
    data(){
        return{
            editableTabsValue: '1',
            is_active:false,
            queryForm:{
                type:'1',
                content:'',
                code_batch:''
            },
            traceInfo:{},
            activeNames:['1','2'],
            codeBatchOptions:[],
            rule:{
                code_batch:[
                    { required: true, message: "请选择码批次", trigger: "blur" },
                ],
                content:[
                    { required: true, message: "请输入查询内容", trigger: "blur" },
                ]
            }
        }
    },
    created(){
        this.getTraceCodeBatch()
    },
    methods:{
        getList(){
            this.$refs["queryForm"].validate(valid => {
                if(valid){
                    this.is_active=false
                    queryTraceInfo(this.queryForm).then(res=>{
                        if(res.data){
                            this.traceInfo=res.data
                            this.is_active=true
                        }else{
                            this.$message.warning(res.msg)
                            this.traceInfo={}
                            this.is_active=false
                        }
                    })
                }
            })
        },
        changeCodeBatch(){
            this.queryForm.content=''
        },
        getTraceCodeBatch(){
            getTraceCodeBatch({}).then(res=>{
               this.codeBatchOptions=res.data 
            })
        },
        handleChange(){
        },
        query(){
          this.getList();
        },
        reset(formName){
            this.$refs[formName].resetFields();
            this.is_active=false
            this.queryForm.type=''
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
.content-box{
    width: 100%;
    padding: 0 30px;
}
.dialog-footer{
  margin: 30px 0;
}
</style>