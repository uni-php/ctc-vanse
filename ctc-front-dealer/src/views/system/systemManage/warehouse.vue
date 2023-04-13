<template>
  <div class="app-container">
    <el-col :span="24" style="margin:10px 0;">
        <el-button @click="handleStore" type="primary" size="small" >新增地区仓库</el-button>
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
      <el-table-column prop="warehouse_name" align="center" label="仓库名称" ></el-table-column>
      <el-table-column prop="type" align="center" label="仓库类型" >
        <template slot-scope="scope">
            <span>{{storeType(scope.row.type)}}</span>
        </template>
      </el-table-column>
      <el-table-column prop="stock" align="center" label="商品库存数量" ></el-table-column>
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
    <!-- 新增仓库 -->
    <el-dialog :title="title" :visible.sync="dialog" width="30%" @close="dialog=false">
        <el-form :model="form" ref="form" label-width="100px" :rules="rule" size="medium">
            <el-form-item label="仓库名称:" prop="warehouse_name">
                <el-input style="width:90%" v-model="form.warehouse_name" placeholder="请输入仓库名称"/>
            </el-form-item>
            <el-form-item label="仓库类型:" prop="type">
                <el-select style="width:90%" v-model="form.type" placeholder="请选择仓库类型" clearable>
                <el-option
                    v-for="dict in storeTypeOptions"
                    :key="dict.dict_value"
                    :label="dict.dict_label"
                    :value="dict.dict_value"
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
import {warehouseList,saveWarehouse,deleWarehouse,getWarehouse,changeWarehouseStatus} from '@/api/system/sys/store'
export default {
    data(){
        return{
            tableData:[],
            queryParams:{
                pageNum:1,
                pageSize:10
            },
            total:0,
            dialog:false,
            form:{
                warehouse_name:'',
                type:''
            },
            rule:{
                warehouse_name:[
                     { required: true, message: "仓库名称不能为空", trigger: "blur" },
                ],
                type:[
                     { required: true, message: "请选择仓库类型", trigger: "blur" },
                ]
            },
            title:'',
            storeTypeOptions:[]
        }
    },
    created(){
        this.getList()
        this.getDicts({type:'warehouse_type'}).then(res=>{
          this.storeTypeOptions=res.data
        })
    },
    computed:{
        storeType(){
            return function(value){
                if(!value) return '--'
                var item=this.storeTypeOptions.filter(item=>{
                return item.dict_value==value
            })
                return item[0].dict_label
            }
        },
    },
    methods:{
        getList(){
            warehouseList(this.queryParams).then(res=>{
                this.tableData=res.data
                this.total=res.total
            })
        },
        handleStore(){
            this.title='新增仓库'
            this.dialog=true
            this.form={
                id:undefined,
                type:'',
                warehouse_name:''
            }
            this.resetForm("form");
        },
        handleEdit(row){
            getWarehouse({id:row.id}).then(res=>{
                this.title='修改仓库',
                this.form=res.data
                this.form.type=String(this.form.type)
                this.dialog=true
            })
        },
        // 仓库状态修改
        handleStatusChange(row) {
        let text = row.status === "1" ? "停用" : "启用";
        this.$confirm('确认要"' + text + '""' + row.warehouse_name + '"仓库吗?', "警告", {
            confirmButtonText: "确定",
            cancelButtonText: "取消",
            type: "warning"
            }).then(function() {
            return changeWarehouseStatus({id:row.id, status:row.status});
            }).then(() => {
            this.$message.success(text + "成功")
            this.getList()
            }).catch(function() {
            row.status = row.status === "0" ? "1" : "0";
            });
        },
        cancel(){
            this.dialog=false
        },
        submitForm(){
            this.$refs["form"].validate(valid => {
                if(valid){
                    saveWarehouse(this.form).then(res=>{
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
        handleDele(row){
            this.$confirm(`确认删除${row.warehouse_name}仓库?`, '提示', {
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
    }
}
</script>

<style>

</style>