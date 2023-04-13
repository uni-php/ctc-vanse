<template>
   <div class="app-container">
        <div class="tips">
            <p>管理经销商端,门店点的公告信息</p>
        </div>
        <div class="tab-bar">
            <el-form ref="queryForm" :model="queryForm" label-width="100px" :inline="true" size="small">
                <el-form-item label="发布时间" prop="time">
                    <el-date-picker
                        style="width:230px"
                        v-model="queryForm.time"
                        type="daterange"
                        unlink-panels=""
                        range-separator="至"
                        value-format="yyyy-MM-dd"
                        start-placeholder="开始日期"
                        end-placeholder="结束日期">
                    </el-date-picker>
                </el-form-item>
                <el-form-item label="公告标题" prop="title">
                    <el-input style="width:230px" v-model="queryForm.title" placeholder="请输入公告标题"></el-input>
                </el-form-item>
                <el-form-item >
                    <el-button type="primary" icon="el-icon-search" @click="query">查询</el-button>
                    <el-button icon="el-icon-refresh" @click="reset('queryForm')">重置</el-button>
                </el-form-item>
            </el-form>
        </div>
        <el-col :span="24" style="margin:10px 0;">
            <el-button @click="addNotice" type="primary" size="small" >添加公告</el-button>
        </el-col>
        <el-table
            :data="tableData"
            :header-cell-style="{background:'#FAFAFA',color:'#606266',height:'50px'}"
            border
            stripe
            size="medium"
            class="trace-table"
            style="width: 100%">
             <el-table-column prop="id" align="center" label="公告编号"></el-table-column>
             <el-table-column prop="title" align="center" label="公告标题" show-overflow-tooltip=""></el-table-column>
             <el-table-column prop="create_time" align="center" label="发布时间"></el-table-column>
             <el-table-column label="操作" align="center" fixed="right" width="280px">
                <template slot-scope="scope">
                    <el-button
                        size="mini"
                        type="primary"
                        @click="handleEdit(scope.row)">修改</el-button>
                    <el-button
                        size="mini"
                        type="primary"
                        @click="handleDele(scope.row)">删除</el-button>
                </template>
             </el-table-column>
        </el-table>
        <pagination
            v-show="+total>10"
            :total="+total"
            :page.sync="queryForm.pageNum"
            :limit.sync="queryForm.pageSize"
            @pagination="getList"/>
        <!-- 添加公告 -->
        <el-dialog :title="title" :visible.sync="dialogVisible" width="30%" @close="dialogVisible=false">
            <el-form ref="form" :model="form" label-width="100px" :rules="rule"  size="small">
                <el-form-item prop="title" label="公告标题" >
                    <el-input style="width:90%" v-model="form.title" placeholder="请输入公告标题"></el-input>
                </el-form-item>
                <el-form-item prop="content" label="公告内容" >
                    <QiniuEditor v-model="form.content" style="width:90%" :min-height="300"/>
                </el-form-item>
            </el-form>
            <div slot="footer" class="dialog-footer">
                <el-button type="primary" @click="submitForm">确 定</el-button>
                <el-button type="primary" @click="dialogVisible=false">取 消</el-button>
            </div>
        </el-dialog>
   </div>
</template>

<script>
import {getNoticeList,saveNotice,queryNoticeInfo,deleNotice} from '@/api/customer/notice'
export default {
    data(){
        return{
            queryForm:{
                time:[],
                title:'',
                pageNum:1,
                pageSize:10
            },
            form:{
                title:'',
                content:''
            },
            rule:{
                title:[
                    {required: true, message: "请输入公告标题", trigger: "blur" },
                ],
                content:[
                    {required: true, message: "请输入公告内容", trigger: "blur" },
                ],
            },
            title:'',
            dialogVisible:false,
            tableData:[],
            total:0
        }
    },
    created(){
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
            getNoticeList(params).then(res=>{
                this.tableData=res.data
                this.total=res.total
            })
        },
        addNotice(){
            this.form={
                title:'',
                content:''
            }
            this.title='添加公告'
            this.dialogVisible=true
        },
        handleEdit(row){
            queryNoticeInfo({id:row.id}).then(res=>{
                this.title='编辑公告'
                this.form=res.data
                this.dialogVisible=true
            })
        },
        handleDele(row){
            this.$confirm(`确认删除${row.title}公告?`, '提示', {
                confirmButtonText: '确定',
                cancelButtonText: '取消',
                type: 'warning'
            }).then(() => {
                deleNotice(row).then(res=>{
                    if(res.code==200){
                        this.$message.success(res.msg)
                        this.getList()
                    }else{
                        this.$message.error(res.msg)
                    }
                })
            }).catch(() => {});
        },
        submitForm(){
            this.$refs["form"].validate(valid => {
                if(valid){
                    saveNotice(this.form).then(res=>{
                        if(res.code==200){
                            this.$message.success(res.msg)
                            this.dialogVisible=false
                            this.getList()
                        }else{
                            this.$message.error(res.msg)
                        }
                    })
                }
            })
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

<style lang="scss" scoped>
.app-container .tips{
    padding: 8px 16px;
    background-color: #ecf8ff;
    border-radius: 4px;
    border-left: 5px solid #50bfff;
    margin: 20px 0;
}
</style>
