<template>
  <div class="app-container">
    <el-col :span="24" style="margin:10px 0;">
        <el-button @click="addGroup" type="primary" size="small" >添加分组</el-button>
    </el-col>
    <el-table
            :data="tableData"
            :header-cell-style="{background:'#FAFAFA',color:'#606266',height:'50px'}"
            border
            stripe
            size="medium"
            class="trace-table"
            style="width: 100%">
            <el-table-column prop="group_name" align="center" label="分组名称"></el-table-column>
            <el-table-column prop="num" align="center" label="礼品数量"></el-table-column>
            <el-table-column prop="create_time" align="center" label="添加时间"></el-table-column>
            <el-table-column label="操作" align="center" fixed="right" width="280px">
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
    <pagination
        v-show="+total>10"
        :total="+total"
        :page.sync="queryGroupForm.pageNum"
        :limit.sync="queryGroupForm.pageSize"
        @pagination="getList"
        />
    <!-- 新建分组 -->
    <el-dialog :title="groupTitle" :visible.sync="groupOpen" width="30%" @close="groupOpen=false">
        <el-form :model="groupForm" ref="groupForm" label-width="80px" :rules="groupRule" size="medium">
            <el-form-item label="分组名称" prop="group_name">
                <el-input style="width:90%"  v-model="groupForm.group_name" placeholder="请输入分组名称"/>
            </el-form-item>
        </el-form>
        <div slot="footer" class="dialog-footer">
            <el-button type="primary" @click="submitGroupForm">确 定</el-button>
            <el-button @click="groupOpen=false">取 消</el-button>
        </div>
    </el-dialog>
  </div>
</template>

<script>
import {getGroupList,saveGroup,queryGroup,deleGroup} from '@/api/assets/gift'
export default {
    data(){
        return{
            tableData:[],
            total:0,
            queryGroupForm:{
                pageNum:1,
                pageSize:10
            },
            groupForm:{
                group_name:''
            },
            groupTitle:'',
            groupOpen:false,
            groupRule:{
                group_name:[
                    { required: true, message: "分组名称不能为空", trigger: "blur" },
                ]
            }
        }
    },
    created(){
        this.getList()
    },
    methods:{
        getList(){
           getGroupList(this.queryGroupForm).then(res=>{
               this.tableData=res.data
               this.total=res.total
           }) 
        },
        addGroup(){
            this.groupOpen=true
            this.groupTitle='添加分组'
            this.groupForm={
                group_name:'',
                id:undefined
            }
        },
        submitGroupForm(){
            this.$refs["groupForm"].validate(valid => {
                if(valid){
                    saveGroup(this.groupForm).then(res=>{
                        if(res.code==200){
                            this.$message.success(res.msg)
                            this.groupOpen=false
                            this.getList()
                        }else{
                            this.$message.error(res.msg)
                        }
                    })
                }
            })
        },
        handleEdit(row){
            queryGroup({id:row.id}).then(res=>{
                this.groupOpen=true
                this.groupTitle='修改分组'
                this.groupForm=res.data
            })
        },
        handleDele(row){
            if(row.num>0){
                this.$message.warning('该分组下存在礼品，不可删除')
                return;
            }
            this.$confirm(`确认删除${row.group_name}分组?`, '提示', {
                confirmButtonText: '确定',
                cancelButtonText: '取消',
                type: 'warning'
            }).then(() => {
                 deleGroup({id:row.id}).then(res=>{
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