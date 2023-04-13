<template>
  <div class="app-container">
    <el-col :span="24" style="margin:10px 0;">
        <el-button @click="handleTax" type="primary" size="small" >新增税费模板</el-button>
    </el-col>
    <el-table
      :data="tableData"
      :header-cell-style="{background:'#FAFAFA',color:'#606266',height:'50px'}"
      border
      stripe
      size="medium"
      class="trace-table"
      style="width: 100%">
      <el-table-column prop="id" align="center" label="编号" ></el-table-column>
      <el-table-column prop="template_name" align="center" label="模板名称" ></el-table-column>
      <el-table-column prop="status" align="center" label="状态" >
          <template slot-scope="scope">
              <el-switch
                v-model="scope.row.status"
                active-value="0"
                inactive-value="1"
                @change="handleStatusChange(scope.row)"
              ></el-switch>
            </template>
      </el-table-column>
      <el-table-column prop="create_time" align="center" label="时间" ></el-table-column>
      <el-table-column label="操作" align="center" fixed="right" width="240px">
            <template slot-scope="scope">
                <el-button
                    size="mini"
                    type="primary"
                    @click="handleEdit(scope.row)">修改</el-button>
                    <el-button
                    size="mini"
                    type="danger"
                    @click="handleDele(scope.row)">删除</el-button>
            </template>
      </el-table-column>
    </el-table>
    <!-- 新增模板 -->
    <el-dialog :title="title" :visible.sync="dialog" width="30%" @close="dialog=false">
        <el-form :model="form" ref="form" label-width="100px" :rules="rule" size="medium">
            <el-form-item label="模板名称:" prop="template_name">
                <el-input style="width:90%" v-model="form.template_name" placeholder="请输入模板名称"/>
            </el-form-item>
            <el-form-item label="仓库:" prop="store_id">
                <el-select style="width:90%" v-model="form.store_id" placeholder="请选择仓库" clearable>
                <el-option
                    v-for="dict in storeOptions"
                    :key="dict.id"
                    :label="dict.warehouse_name"
                    :value="dict.id"
                />
                </el-select>
            </el-form-item>
        </el-form>
        <div slot="footer" class="dialog-footer">
          <el-button type="primary" @click="submitForm">确 定</el-button>
          <el-button @click="cancel">取 消</el-button>
        </div>
    </el-dialog>
  </div>
</template>

<script>
import {taxTplList,saveTaxTpl,deleTaxTpl,getTaxTpl,changeTaxTplStatus} from '@/api/system/sys/tax'
import {warehouseList} from '@/api/system/sys/store'
export default {
    data(){
        return{
            tableData:[],
            queryParams:{
                pageNum:1,
                pageSize:10
            },
            queryParam:{
                pageNum:1,
                pageSize:999
            },
            rule:{
                template_name:[
                     { required: true, message: "模板名称不能为空", trigger: "blur" },
                ],
                store_id:[
                     { required: true, message: "请选择仓库", trigger: "blur" },
                ]
            },
            total:0,
            title:'',
            dialog:false,
            form:{
                template_name:''
            },
            storeOptions:[]
        }
    },
    created(){
        this.getList()
        this.getStore()
    },
    methods:{
        getList(){
            taxTplList(this.queryParams).then(res=>{
                this.tableData=res.data
                this.total=res.total
            })
        },
        getStore(){
            warehouseList(this.queryParam).then(res=>{
                this.storeOptions=res.data
            })
        },
        handleTax(){
            this.title='新增税费模板'
            this.dialog=true
            this.form={
                id:undefined,
                template_name:'',
                store_id:''
            }
        },
        handleEdit(row){
            getTaxTpl({id:row.id}).then(res=>{
                this.title='修改税费模板',
                this.form=res.data
                this.dialog=true
            })
        },
        handleStatusChange(row){
            let text = row.status === "1" ? "停用" : "启用";
            this.$confirm('确认要"' + text + '""' + row.template_name + '"模板吗?', "警告", {
            confirmButtonText: "确定",
            cancelButtonText: "取消",
            type: "warning"
            }).then(function() {
            return changeTaxTplStatus({id:row.id, status:row.status});
            }).then(() => {
            this.$message.success(text + "成功")
            this.getList()
            }).catch(function() {
            row.status = row.status === "0" ? "1" : "0";
            });
        },
        handleDele(row){
            this.$confirm(`确认删除${row.template_name}模板?`, '提示', {
                confirmButtonText: '确定',
                cancelButtonText: '取消',
                type: 'warning'
                }).then(() => {
                 deleTaxTpl({id:row.id}).then(res=>{
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
                    saveTaxTpl(this.form).then(res=>{
                        if(res.code==200){
                            this.$message.success(res.msg)
                            this.dialog=false
                            this.getList()
                        }else{
                            this.$message.error(res.msg)
                        }
                    })
                }
            })
        },
        cancel(){
            this.dialog=false
        },
    }
}
</script>
<style>

</style>