<template>
  <div class="app-container">
    <el-col :span="24" style="margin:10px 0;">
        <el-button @click="handleAddClass" type="primary" size="small" >新增一级分类</el-button>
    </el-col>
    <el-table
      :data="tableData"
      row-key="id"
      :header-cell-style="{background:'#FAFAFA',color:'#606266',height:'50px'}"
      border
      stripe
      size="medium"
      class="trace-table"
      style="width: 100%"
      :tree-props="{children: 'children', hasChildren: 'hasChildren'}">
        <el-table-column prop="id" align="center" label="ID" ></el-table-column>
        <el-table-column prop="class_name" align="center" label="分类名称" ></el-table-column>
        <el-table-column prop="product_num" align="center" label="产品数" ></el-table-column>
        <el-table-column label="操作" align="center" fixed="right" width="300px">
            <template slot-scope="scope">
                    <el-button
                    size="mini"
                    type="text"
                    @click="handleEdit(scope.row)">修改</el-button>
                    <el-button
                    size="mini"
                    v-show="scope.row.parent_id==0"
                    type="text"
                    @click="handleAddChildClass(scope.row)">添加二级分类</el-button>
                    <el-button
                    size="mini"
                    type="text"
                    @click="handleDele(scope.row)">删除</el-button>
            </template>
        </el-table-column>
    </el-table>
    <!-- 添加分类 -->
    <el-dialog :title="title" :visible.sync="dialog" width="30%" @close="dialog=false">
        <el-form :model="form" ref="form" label-width="100px" :rules="rule" size="medium">
            <el-form-item label="分类名称:" prop="class_name">
                <el-input style="width:90%" v-model="form.class_name" placeholder="请输入分类名称"/>
            </el-form-item>
            <el-form-item label="排序:" prop="order">
                <el-input style="width:90%" v-model="form.order" placeholder="请输入排序数字"/>
            </el-form-item>
        </el-form>
        <div slot="footer" class="dialog-footer">
          <el-button type="primary" @click="submitForm">保 存</el-button>
          <el-button @click="cancel">取 消</el-button>
        </div>
    </el-dialog>
  </div>
</template>

<script>
import {getClassList,saveProductClass,deleProductClass,queryProductClass} from '@/api/assets/product'
export default {
    data(){
        return{
            tableData:[],
            title:'',
            dialog:false,
            queryParams:{
                pageNum:1,
                pageSize:999
            },
            total:0,
            form:{
                class_name:'',
                order:'',
                parent_id:undefined
            },
            rule:{
                class_name:[
                    { required: true, message: "分组名称不能为空", trigger: "blur" },
                ],
                order:[
                    { required: true, message: "排序序号不能为空", trigger: "blur" },
                ]
            }
        }
    },
    created(){
        this.getList()
    },
    methods:{
        getList(){
            getClassList(this.queryParams).then(res=>{
                this.tableData=res.data
                this.total=res.total
            })
        },
        handleEdit(row){
            queryProductClass({id:row.id}).then(res=>{
                this.title='修改分类'
                this.dialog=true
                this.form=res.data
            })
        },
        handleAddClass(){
            this.dialog=true
            this.title='添加分类'
            this.form.parent_id=''
            this.form.class_name=''
            this.form.order=''
            this.form.id=undefined
        },
        handleAddChildClass(row){
            this.dialog=true
            this.title='添加二级分类'
            this.form.parent_id=row.id
            this.form.class_name=''
            this.form.order=''
            this.form.id=undefined
        },
        handleDele(row){
            this.$confirm(`确认删除${row.class_name}分类?`, '提示', {
                confirmButtonText: '确定',
                cancelButtonText: '取消',
                type: 'warning'
            }).then(() => {
                if(row.children.length>0){
                    this.$message.warning('请先删除该类别下的二级分类')
                    return;
                }
                deleProductClass(row).then(res=>{
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
                    saveProductClass(this.form).then(res=>{
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
        }
    }
}
</script>

<style>

</style>