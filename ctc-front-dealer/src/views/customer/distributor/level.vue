<template>
  <div class="app-container">
    <el-col :span="24" style="margin:10px 0;">
        <el-button @click="addLevel" type="primary" size="small" >添加级别</el-button>
    </el-col>
    <el-table
        :data="tableData"
        :header-cell-style="{background:'#FAFAFA',color:'#606266',height:'50px'}"
        border
        stripe
        size="medium"
        class="trace-table"
        style="width: 100%">
        <el-table-column prop="level_order" align="center" label="级别编号"></el-table-column>
        <el-table-column prop="level_name" align="center" label="级别名称"></el-table-column>
        <el-table-column prop="num" align="center" label="经销商数量"></el-table-column>
        <el-table-column prop="create_time" align="center" label="创建时间"></el-table-column>
        <el-table-column label="操作" align="center" fixed="right" width="280px">
            <template slot-scope="scope">
                <el-button
                    size="mini"
                    type="primary"
                    @click="handleView(scope.row)">查看经销商</el-button>
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
            <el-form-item prop="level_order" label="级别编号" >
                <el-input style="width:90%" disabled v-model.number="form.level_order" placeholder="请输入级别编号"></el-input>
                <div>（1-10，数字越小级别越高）</div>
            </el-form-item>
            <el-form-item prop="level_name" label="级别名称" >
                <el-input style="width:90%" v-model="form.level_name" placeholder="请输入级别名称"></el-input>
            </el-form-item>
        </el-form>
        <div slot="footer" class="dialog-footer">
            <el-button type="primary" @click="submitForm">确 定</el-button>
            <el-button type="primary" @click="dialogVisible=false">取 消</el-button>
        </div>
    </el-dialog>
    <!-- 经销商列表 -->
     <el-dialog title="经销商列表" :visible.sync="disVisible" width="50%" @close="disVisible=false">
        <div class="tab-bar">
            <el-form ref="queryForm" :model="queryForm" label-width="100px" :inline="true" size="small">
                <el-form-item label="经销商名称" prop="distributor_name">
                    <el-input style="width:220px" v-model="queryForm.distributor_name" placeholder="请输入经销商名称"></el-input>
                </el-form-item>
                 <el-form-item label="经销商编号" prop="distributor_code">
                    <el-input style="width:220px" v-model="queryForm.distributor_code" placeholder="请输入经销商编号"></el-input>
                </el-form-item>
                <el-form-item > 
                    <el-button type="primary" icon="el-icon-search" @click="query">查询</el-button>
                    <el-button icon="el-icon-refresh" @click="reset('queryForm')">重置</el-button>
                </el-form-item>
            </el-form>
        </div>
        <el-table
            :data="distributorData"
            :header-cell-style="{background:'#FAFAFA',color:'#606266',height:'50px'}"
            border
            stripe
            size="medium"
            class="trace-table"
            style="width: 100%">
            <el-table-column prop="distributor_code" align="center" label="经销商编号"></el-table-column>
            <el-table-column prop="distributor_name" align="center" label="经销商名称"></el-table-column>
            <el-table-column prop="address" align="center" label="经销商地址"></el-table-column>
            <el-table-column prop="create_time" align="center" label="添加时间"></el-table-column>
        </el-table>
        <pagination
        v-show="+total>10"
        :total="+total"
        :page.sync="queryForm.pageNum"
        :limit.sync="queryForm.pageSize"
        @pagination="getDistributorList"/>
    </el-dialog>

  </div>
</template>

<script>
import {getDistributorLevelList,saveDistributorLevel,queryDistributorLevelInfo,deleDistributorLevel,getDistributorList} from '@/api/customer/distributor'
export default {
    data(){
        return{
            tableData:[],
            distributorData:[],
            total:0,
            dialogVisible:false,
            disVisible:false,
            title:'',
            queryForm:{
                time:[],
                distributor_code:'',
                distributor_name:'',
                distributor_level:'',
                superior_dis_name:'',
                superior_dis_id:undefined,
                zone:[],
                pageNum:1,
                pageSize:10
            },
            form:{
                level_order:'',
                level_name:'',
                id:undefined
            },
            rule:{
                level_name:[
                    {required: true, message: "请输入级别名称", trigger: "blur" },
                ],
                level_order:[
                    {required: true, message: "请输入级别编号", trigger: "blur" },
                    { type: 'number', message: '编号必须为数字值'}
                ]
            }
        }
    },
    created(){
        this.getList()
    },
    methods:{
        getList(){
            getDistributorLevelList({}).then(res=>{
                this.tableData=res.data
            })
        },
        addLevel(){
            this.form={
                level_order:'',
                level_name:'',
                id:undefined
            }
            console.log(this.tableData[this.tableData.length-1])
            this.form.level_order=this.tableData.length>0?this.tableData[0]['level_order']*1+1:1
            this.title='添加级别'
            this.dialogVisible=true
        },
        handleEdit(row){
            queryDistributorLevelInfo({id:row.id}).then(res=>{
                this.form=res.data
                this.dialogVisible=true
                this.title='修改级别'
            })
        },
        async getDistributorList(){
            var params=Object.assign({},this.queryForm)
            if(!this.queryForm.time||this.queryForm.time.length==0){
                params.startTime=''
                params.endTime=''
            }else{
                params.startTime=this.queryForm.time[0]
                params.endTime=this.queryForm.time[1]
            }
            delete params.time
            params.zone=params.zone.join(',')
            await getDistributorList(params).then(res=>{
                this.distributorData=res.data
                this.total=res.total
            })
        },
        handleDele(row){
            this.$confirm(`确定删除${row.level_name}级别`, '提示', {
                confirmButtonText: '确定',
                cancelButtonText: '取消',
                type: 'warning'
            }).then(() => {
                if(row.num!=0){
                    this.$message.warning('该级别下存在经销商，不可删除')
                    return;
                }
                 deleDistributorLevel({id:row.id}).then(res=>{
                    if(res.code==200){
                        this.$message.success(res.msg)
                        this.getList()
                    }else{
                        this.$message.error(res.msg)
                    }
                 })
            }).catch(() => {});
        },
        handleView(row){
            this.queryForm.distributor_level=row.id
            this.distributorData=[]
            this.disVisible=true
            this.$nextTick(()=>{
                this.reset('queryForm')
            })
        },
        query(){
          this.queryForm.pageNum = 1;
          this.getDistributorList();
        },
        reset(formName){
            this.$refs[formName].resetFields();
            this.query()
        },
        submitForm(){
            this.$refs["form"].validate(valid => {
                if(valid){
                    saveDistributorLevel(this.form).then(res=>{
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