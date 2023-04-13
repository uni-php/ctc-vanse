<template>
  <div class="app-container">
    <div class="tab-bar">
        <el-form ref="queryForm" :model="queryForm" label-width="100px" :inline="true" size="small">
            <el-form-item label="字段名称" prop="field_name">
                <el-input style="width:220px" v-model="queryForm.field_name" placeholder="请输入字段名称"></el-input>
            </el-form-item>
            <el-form-item label="状态" prop="status">
                <el-select style="width:220px" size="small" v-model="queryForm.status" placeholder="请选择状态">
                    <el-option
                        v-for="item in statusOption"
                        :key="item.value"
                        :label="item.label"
                        :value="item.value">
                    </el-option>
                </el-select>
            </el-form-item>
            <el-form-item > 
                <el-button type="primary" icon="el-icon-search" @click="query">查询</el-button>
                <el-button icon="el-icon-refresh" @click="reset('queryForm')">重置</el-button>
            </el-form-item>
        </el-form>
    </div>
    <el-col :span="24" style="margin:10px 0;">
        <el-button @click="addFiled" type="primary" size="small" >添加字段</el-button>
    </el-col>
    <el-table
        :data="tableData"
        :header-cell-style="{background:'#FAFAFA',color:'#606266',height:'50px'}"
        border
        stripe
        size="medium"
        class="trace-table"
        style="width: 100%">
        <el-table-column prop="field_name" align="center" label="字段名称"></el-table-column>
        <el-table-column prop="placeholder" align="center" label="输入提示"></el-table-column>
        <el-table-column prop="prop" align="center" label="prop"></el-table-column>
        <el-table-column prop="type" align="center" label="类型" :formatter="type"></el-table-column>
        <el-table-column prop="status" align="center" label="状态" :formatter="status"></el-table-column>
        <el-table-column label="操作" align="center" fixed="right" width="280px">
            <template slot-scope="scope">
                <div v-if="scope.row.is_sys_set==0">
                    <el-button
                        size="mini"
                        type="primary"
                        @click="handleEdit(scope.row)">编辑</el-button>
                    <el-button
                        size="mini"
                        type="primary"
                        @click="handleDis(scope.row)">{{scope.row.status==1?'禁用':'启用'}}</el-button>
                    <el-button
                        size="mini"
                        type="danger"
                        v-if="scope.row.status==2"
                        @click="handleDele(scope.row)">删除</el-button>
                </div>
                <div v-else>系统内置，无法修改</div>
            </template>
        </el-table-column>
    </el-table>
    <pagination
        v-show="+total>10"
        :total="+total"
        :page.sync="queryForm.pageNum"
        :limit.sync="queryForm.pageSize"
        @pagination="getList"/>
    <el-dialog :title="title" :visible.sync="dialogVisible" width="40%" @close="dialogVisible=false">
        <el-form ref="form" :model="form" label-width="100px" :rules="rule"  size="small">
            <el-form-item prop="field_name" label="字段名称" >
                <el-input style="width:90%" v-model="form.field_name" placeholder="请输入字段名称"></el-input>
            </el-form-item>
            <el-form-item prop="type" label="字段类型" >
                <el-select style="width:90%" size="small" v-model="form.type" placeholder="请选择字段类型">
                    <el-option
                        v-for="item in fieldTypeOptions"
                        :key="item.dict_value"
                        :label="item.dict_label"
                        :value="item.dict_value">
                    </el-option>
                </el-select>
            </el-form-item>
            <el-form-item prop="max_length" v-if="form.type==1" label="输入长度" >
                <el-input style="width:90%" v-model="form.max_length" placeholder="输入长度"></el-input>
            </el-form-item>
            <el-form-item prop="prop" label="prop" >
                <el-input style="width:90%" v-model="form.prop" placeholder="prop"></el-input>
            </el-form-item>
            <el-form-item prop="select_options" v-if="form.type==2||form.type==3" label="下拉选项" >
                <el-input style="width:90%" v-model="form.select_options" placeholder="选项1/选项2/选项3"></el-input>
            </el-form-item>
            <el-form-item prop="placeholder" label="输入提示" >
                <el-input style="width:90%" v-model="form.placeholder" placeholder="输入提示"></el-input>
            </el-form-item>
            <el-form-item prop="order" label="排序" >
                <el-input style="width:90%" v-model.number="form.order" placeholder="输入提示"></el-input>
            </el-form-item>
            <el-form-item prop="status" label="状态" >
                <el-radio-group v-model="form.status">
                    <el-radio v-for="(item,index) of statusOption" :key="index" :label="item.value">{{item.label}}</el-radio>
                </el-radio-group>
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
import {getFieldList,saveFiled,deleField,queryFieldInfo,changeFieldStatus} from '@/api/customer/member'
export default {
    data(){
        return{
            queryForm:{
                field_name:'',
                status:'',
                pageNum:1,
                pageSize:10
            },
            statusOption:[
                {
                    label:'已启用',
                    value:1
                },
                {
                    label:'未启用',
                    value:2
                }
            ],
            title:'',
            tableData:[],
            fieldTypeOptions:[],
            total:0,
            dialogVisible:false,
            form:{
                type:'',
                field_name:'',
                max_length:'',
                select_options:'',
                placeholder:'',
                order:'',
                value:'',
                prop:'',
                status:1
            },
            rule:{
                field_name:[
                    {required: true, message: "请输入字段名称", trigger: "blur" },
                ],
                type:[
                    {required: true, message: "请选择字段类型", trigger: "blur" },
                ],
                select_options:[
                    {required: true, message: "请选择下拉选项", trigger: "blur" },
                ],
                max_length:[
                    {required: true, message: "请输入字段长度", trigger: "blur" },
                ]
            }
        }
    },
    created(){
        this.getList()
        this.getDicts({type:'field_type'}).then(res=>{
            this.fieldTypeOptions=res.data
        })
    },
    methods:{
        getList(){
            getFieldList(this.queryForm).then(res=>{
                this.tableData=res.data
                this.total=res.total
            })
        },
        type(row){
            return this.fieldTypeOptions.filter(item=>item.dict_value==row.type).map(item=>item.dict_label)[0]
        },
        status(row){
            return this.statusOption.filter(item=>item.value==row.status).map(item=>item.label)[0]
        },
        addFiled(){
            this.form={
                type:'',
                field_name:'',
                max_length:'',
                select_options:'',
                placeholder:'',
                order:'',
                value:'',
                status:1
            }
            this.title='添加字段'
            this.dialogVisible=true
        },
        handleEdit(row){
            queryFieldInfo({id:row.id}).then(res=>{
                this.title='编辑字段'
                this.dialogVisible=true
                this.form=res.data
            })
        },
        handleDis(row){
            var text=row.status==1?'禁用':'启用'
            this.$confirm(`确定${text}该字段`, '提示', {
                confirmButtonText: '确定',
                cancelButtonText: '取消',
                type: 'warning'
            }).then(() => {
                 changeFieldStatus({id:row.id,status:row.status}).then(res=>{
                    if(res.code==200){
                        this.$message.success(res.msg)
                        this.getList()
                    }else{
                        this.$message.error(res.msg)
                    }
                 })
            }).catch(() => {});
        },
        handleDele(row){
            this.$confirm(`确定删除该字段`, '提示', {
                confirmButtonText: '确定',
                cancelButtonText: '取消',
                type: 'warning'
            }).then(() => {
                 deleField({id:row.id}).then(res=>{
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
                    saveFiled(this.form).then(res=>{
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

<style>

</style>