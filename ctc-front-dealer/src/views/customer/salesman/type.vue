<template>
  <div class="app-container">
    <el-col :span="24" style="margin:10px 0;">
        <el-button @click="addType" type="primary" size="small" >添加类型</el-button>
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
        <el-table-column prop="class_name" align="center" label="类型名称"></el-table-column>
        <el-table-column prop="num" align="center" label="人员数量"></el-table-column>
        <el-table-column prop="remark" align="center" label="备注"></el-table-column>
        <el-table-column prop="create_time" align="center" label="创建时间"></el-table-column>
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
    <el-dialog :title="title" :visible.sync="dialogVisible" width="30%" @close="dialogVisible=false">
        <el-form ref="form" :model="form" label-width="100px" :rules="rule"  size="small">
            <el-form-item prop="class_name" label="类型名称" >
                <el-input style="width:90%" v-model="form.class_name" placeholder="请输入类型名称"></el-input>
            </el-form-item>
            <el-form-item prop="remark" label="备注" >
                <el-input style="width:90%" v-model="form.remark" placeholder="请输入类型备注"></el-input>
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
import {getSalesmanTypeList,saveSalesmanType,querySalesmanTypeInfo,deleSalesmanType} from '@/api/customer/salesman'
export default {
    data(){
        return{
            title:'',
            dialogVisible:false,
            tableData:[],
            total:0,
            queryForm:{
                pageNum:1,
                pageSize:10
            },
            form:{
                class_name:'',
                remark:'',
                id:undefined
            },
            rule:{
                class_name:[
                    {required: true, message: "请输入类型名称", trigger: "blur" },
                ],
            }
        }   
    },
    created(){
        this.getList()
    },
    methods:{
        getList(){
            getSalesmanTypeList(this.queryForm).then(res=>{
                this.tableData=res.data
                this.total=res.total
            })
        },
        submitForm(){
            this.$refs["form"].validate(valid => {
                if(valid){
                    saveSalesmanType(this.form).then(res=>{
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
        addType(){
            this.form={
                class_name:'',
                id:undefined
            }
            this.title='添加类型'
            this.dialogVisible=true
        },
        handleEdit(row){
            querySalesmanTypeInfo({id:row.id}).then(res=>{
                this.form=res.data
                this.dialogVisible=true
                this.title='修改类型'
            })
        },
        handleDele(row){
            this.$confirm(`确定删除${row.class_name}类型`, '提示', {
                confirmButtonText: '确定',
                cancelButtonText: '取消',
                type: 'warning'
            }).then(() => {
                if(row.num!=0){
                    this.$message.warning('该类型下存在人员，不可删除')
                    return;
                }
                deleSalesmanType({id:row.id}).then(res=>{
                    if(res.code==200){
                        this.$message.success(res.msg)
                        this.getList()
                    }else{
                        this.$message.error(res.msg)
                    }
                })
            }).catch(() => {});
        }
    }
}
</script>

<style>

</style>