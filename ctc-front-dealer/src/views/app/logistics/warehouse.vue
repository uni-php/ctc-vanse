<template>
  <div class="app-container">
    <div class="tab-bar">
        <el-form ref="queryForm" :model="queryForm" label-width="100px" :inline="true" size="small">
            <el-form-item label="" prop="keywords">
                <el-input style="width:260px" v-model="queryForm.keywords" placeholder="仓库名称、仓库编号、仓库地址"></el-input>
            </el-form-item>
            <el-form-item > 
                <el-button type="primary" icon="el-icon-search" @click="query">查询</el-button>
                <el-button icon="el-icon-refresh" @click="resetQuery('queryForm')">重置</el-button>
            </el-form-item>
        </el-form>
    </div>
    <el-col :span="24" style="margin:10px 0;">
        <el-button @click="handleAddWarehouse" type="primary" size="small" >添加仓库</el-button>
    </el-col>
    <el-table
        :data="tableData"
        :header-cell-style="{background:'#FAFAFA',color:'#606266',height:'50px'}"
        border
        stripe
        size="medium"
        class="trace-table"
        style="width: 100%">
        <el-table-column prop="id" align="center" label="ID"></el-table-column>
        <el-table-column prop="warehouse_name" align="center" label="仓库名称"></el-table-column>
        <el-table-column prop="code" align="center" label="仓库编号"></el-table-column>
        <el-table-column prop="address" align="center" label="仓库地址"></el-table-column>
        <el-table-column prop="person" align="center" label="负责人"></el-table-column>
        <el-table-column label="操作" align="center" fixed="right" width="240px">
            <template slot-scope="scope">
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
    <el-dialog :title="title" :visible.sync="visibleDialog" width="50%" @close="visibleDialog=false">
        <el-form :model="form" ref="form" label-width="100px" :rules="rule" size="medium">
            <el-form-item label="仓库编号:" prop="code">
                <el-input :disabled="form.id" style="width:80%" v-model="form.code" placeholder="请输入仓库编号"/>
            </el-form-item>
            <el-form-item label="仓库名称:" prop="warehouse_name">
                <el-input style="width:80%" v-model="form.warehouse_name" placeholder="请输入仓库名称"/>
            </el-form-item>
            <el-form-item label="仓库地址:" prop="address">
                <el-input style="width:80%" v-model="form.address" placeholder="请输入仓库地址"/>
            </el-form-item>
            <el-form-item label="负责人:" prop="person">
                <el-input style="width:80%" v-model="form.person" placeholder="请输入负责人"/>
            </el-form-item>
            <el-form-item label="备注" prop="remark">
                <el-input style="width:80%" type="textarea" v-model="form.remark" placeholder="请输入备注"></el-input>
            </el-form-item>
        </el-form>
        <div slot="footer" class="dialog-footer">
          <el-button type="primary" @click="submitForm">确 定</el-button>
          <el-button @click="visibleDialog=false">取 消</el-button>
        </div>
    </el-dialog>
  </div>
</template>

<script>
import {getWarehouseList,saveWarehouse,getWarehouseInfo,deleWarehouse} from '@/api/app/logistics/basic'
export default {
    data(){
        return{
            queryForm:{
                keywords:'',
                pageNum:1,
                pageSize:10
            },
            visibleDialog:false,
            title:'',
            rule:{
                code:[
                     { required: true, message: "请输入仓库编号", trigger: "blur" },
                ],
                warehouse_name:[
                     { required: true, message: "请输入仓库名称", trigger: "blur" },
                ]
            },
            form:{
                code:'',
                warehouse_name:'',
                address:'',
                person:'',
                remark:'',
                id:undefined
            },
            tableData:[],
            total:0
        }
    },
    created(){
        this.getList()
    },
    methods:{
        getList(){
            getWarehouseList(this.queryForm).then(res=>{
                this.tableData=res.data
                this.total=res.total
            })
        },
        handleAddWarehouse(){
            this.visibleDialog=true
            this.form={
                code:'',
                warehouse_name:'',
                address:'',
                person:'',
                remark:'',
                id:undefined
            }
            this.title='添加仓库'
        },
        handleEdit(row){
            getWarehouseInfo({id:row.id}).then(res=>{
                this.title='编辑仓库'
                this.form=res.data
                this.visibleDialog=true
            })
        },
        handleDele(row){
            this.$confirm('确认删除该仓库?', '提示', {
                confirmButtonText: '确定',
                cancelButtonText: '取消',
                type: 'warning'
                }).then(() => {
                 deleWarehouse({id:row.id}).then(res=>{
                     if(res.code==200){
                        this.$message.success(res.msg)
                        this.getList()
                    }else{
                        this.$message.error(res.msg)
                    }
                 })
                }).catch(() => {});
        },
        query(){
            this.queryForm.pageNum = 1;
            this.getList();
        },
        submitForm(){
            this.$refs["form"].validate(valid => {
                if(valid){
                    saveWarehouse(this.form).then(res=>{
                        if(res.code==200){
                            this.$message.success(res.msg)
                            this.visibleDialog=false
                            this.getList()
                        }else{
                            this.$message.error(res.msg)
                        }
                    })
                }
            })
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