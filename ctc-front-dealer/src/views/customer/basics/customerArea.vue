<template>
  <div class="app-container">
      <el-col :span="24" style="margin:10px 0;">
        <el-button @click="addFirstLevel" type="primary" size="small" >添加一级区域</el-button>
      </el-col>
      <el-table
        :data="tableData"
        :header-cell-style="{background:'#FAFAFA',color:'#606266',height:'50px'}"
        border
        stripe
        :tree-props="{children: 'children', hasChildren: 'hasChildren'}"
        size="medium"
        row-key="id"
        class="trace-table"
        style="width: 100%">
         <el-table-column prop="area_name" align="left" label="名称">
             <template slot-scope="scope">
                 <span>{{scope.row.area_name}} [ID:{{scope.row.id}}]</span>
             </template>
         </el-table-column>
         <el-table-column label="操作" align="center" width="350px" fixed="right">
            <template slot-scope="scope">
                <el-button
                    size="mini"
                    type="primary"
                    v-if="scope.row.level<=3"
                    @click="handleAddChildClass(scope.row)">添加下级区域</el-button>
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
      <el-dialog :title="title" :visible.sync="dialogVisible" width="30%" @close="dialogVisible=false">
        <el-form ref="form" :model="form" label-width="100px" :rules="rule"  size="small">
            <el-form-item prop="level_name" label="名称" >
                <el-input style="width:90%" v-model="form.area_name" placeholder="请输入名称"></el-input>
            </el-form-item>
            <el-form-item prop="order" label="排序" >
                <el-input style="width:90%" v-model.number="form.order" placeholder="请输入级别编号"></el-input>
                <div>（1-1000，数字越大越靠前）</div>
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
import{getCustomerAreaList,saveCustomerArea,queryCustomerArea,deleCustomerArea} from '@/api/customer/basics'
export default {
    data(){
        return{
            tableData:[],
            title:'',
            dialogVisible:false,
            form:{
                area_name:'',
                order:'',
                id:undefined
            },
            rule:{
                area_name:[
                    {required: true, message: "请输入区域名称", trigger: "blur" },
                ],
                order:[
                    {required: true, message: "请输入区域排序", trigger: "blur" },
                    { type: 'number', message: '排序字段必须为数字值'}
                ]
            }
        }
    },
    created(){
        this.getList()
    },
    methods:{
        getList(){
            getCustomerAreaList({}).then(res=>{
                this.tableData=this.setTreeLevel(this.handleTree(res.data, "id"),1);
                console.log(this.tableData)
            })
        },
        handleAddChildClass(row){
            this.form={
                area_name:'',
                order:'',
                parentId:row.id,
                id:undefined
            }
            this.title='添加下级区域'
            this.dialogVisible=true
        },
        addFirstLevel(){
            this.form={
                area_name:'',
                order:'',
                id:undefined,
                parentId:0
            }
            this.title='添加一级区域'
            this.dialogVisible=true
        },
        handleEdit(row){
            queryCustomerArea({id:row.id}).then(res=>{
                this.title='编辑区域'
                this.form=res.data
                this.dialogVisible=true
            })
        },
        handleDele(row){
            this.$confirm(`确认删除${row.area_name}区域?`, '提示', {
                confirmButtonText: '确定',
                cancelButtonText: '取消',
                type: 'warning'
            }).then(() => {
                if(row.children&&row.children.length>0){
                    this.$message.warning('请先删除该区域的下级区域')
                    return;
                }
                deleCustomerArea(row).then(res=>{
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
                    saveCustomerArea(this.form).then(res=>{
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
        }
    }
}
</script>

<style>

</style>