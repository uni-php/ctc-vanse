<template>
  <div class="app-container">
    <div class="tab-bar">
        <el-form ref="queryForm" :model="queryForm" label-width="100px" :inline="true" size="small">
            <el-form-item label="标签名" prop="tag_name">
              <el-input style="width:240px" v-model="queryForm.tag_name" placeholder="请输入标签名"></el-input>
            </el-form-item>
            <el-form-item label="标签备注" prop="remark">
              <el-input style="width:240px" v-model="queryForm.remark" placeholder="请输入标签备注"></el-input>
            </el-form-item>
             <el-form-item> 
                <el-button type="primary" icon="el-icon-search" @click="query">查询</el-button>
                <el-button icon="el-icon-refresh" @click="resetQuery('queryForm')">重置</el-button>
            </el-form-item>
        </el-form>
    </div>
    <el-col :span="24" style="margin:10px 0;">
        <el-button @click="addTag" type="primary" size="small" >添加标签</el-button>
    </el-col>
    <el-table
        :data="tableData"
        :header-cell-style="{background:'#FAFAFA',color:'#606266',height:'50px'}"
        border
        stripe
        size="medium"
        class="trace-table"
        style="width: 100%">
        <el-table-column prop="tag_name" align="center" label="标签名"></el-table-column>
        <el-table-column prop="count" align="center" width="200px" label="会员数量"></el-table-column>
        <el-table-column prop="remark" align="center" label="标签备注"></el-table-column>
        <el-table-column prop="create_time" align="center" label="添加时间"></el-table-column>
        <el-table-column label="操作" align="center" fixed="right" width="280px">
            <template slot-scope="scope">
                <el-button
                    size="mini"
                    type="primary"
                    @click="handleList(scope.row)">会员列表</el-button>
                <el-button
                    size="mini"
                    type="primary"
                    @click="handleEdit(scope.row)">编辑</el-button>
                <el-button
                    size="mini"
                    type="danger"
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
    <!-- 添加标签 -->
    <el-dialog :title="title" :visible.sync="dialogVisible" width="40%" @close="dialogVisible=false">
        <el-form ref="form" :model="form" label-width="100px" :rules="rule"  size="small">
            <el-form-item prop="tag_name" label="标签名称" >
                <el-input style="width:80%" v-model="form.tag_name" placeholder="请输入标签名称"></el-input>
            </el-form-item>
            <el-form-item prop="remark" label="标签备注">
                <el-input style="width:80%" v-model="form.remark" placeholder="请输入标签备注"></el-input>
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
import {saveMemberTag,getMemberTagList,deleteTag,queryTagInfo} from '@/api/customer/member'
export default {
    data(){
        return{
            queryForm:{
                tag_name:'',
                remark:'',
                pageNum:1,
                pageSize:10
            },
            title:'',
            form:{
                tag_name:'',
                remark:'',
                id:undefined
            },
            rule:{
                tag_name:[
                    {required: true, message: "请输入标签名称", trigger: "blur" },
                ],
                remark:[
                    {required: true, message: "请输入标签备注", trigger: "blur" },
                ]
            },
            dialogVisible:false,
            total:0,
            tableData:[]
        }
    },
    created(){
        this.getList()
    },
    methods:{
        getList(){
            getMemberTagList(this.queryForm).then(res=>{
                this.tableData=res.data
                this.total=res.total
            })
        },
        handleEdit(row){
            queryTagInfo({id:row.id}).then(res=>{
                this.title='编辑标签'
                this.form=res.data
                this.dialogVisible=true
            })
        },
        handleDele(row){
            this.$confirm(`确定删除？删除后，标签分类以及标签数据无法恢复。`, '提示', {
                confirmButtonText: '确定',
                cancelButtonText: '取消',
                type: 'warning'
            }).then(() => {
                 deleteTag(row).then(res=>{
                    if(res.code==200){
                        this.$message.success(res.msg)
                        this.getList()
                    }else{
                        this.$message.error(res.msg)
                    }
                 })
            }).catch(() => {});
        },
        handleList(){

        },
        submitForm(){
            this.$refs["form"].validate(valid => {
                if(valid){
                    saveMemberTag(this.form).then(res=>{
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
        addTag(){
            this.form={
                tag_name:'',
                remark:''
            }
            this.title='添加标签'
            this.dialogVisible=true
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