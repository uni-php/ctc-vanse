<template>
  <div class="app-container">
    <div class="tips">
        <p>管理产品生产批次信息，生产批次是溯源流程的主体，所有的溯源流程信息都关联到生产批次。</p>
    </div>
    <div class="tab-bar">
        <el-form ref="queryForm" :model="queryForm" label-width="100px" :inline="true" size="small">
            <el-form-item label="添加时间" prop="time">
                <el-date-picker
                    style="width:220px"
                    v-model="queryForm.time"
                    type="daterange"
                    unlink-panels=""
                    range-separator="至"
                    value-format="yyyy-MM-dd"
                    start-placeholder="开始日期"
                    end-placeholder="结束日期">
                </el-date-picker>
            </el-form-item>
            <el-form-item label="关键词" prop="keywords">
                <el-input style="width:220px" v-model="queryForm.keywords" placeholder="生产批次号、产品名称、批次备注"></el-input>
            </el-form-item>
            <el-form-item > 
                <el-button type="primary" icon="el-icon-search" @click="query">查询</el-button>
                <el-button icon="el-icon-refresh" @click="reset('queryForm')">重置</el-button>
            </el-form-item> 
        </el-form>
    </div>
    <el-col :span="24" style="margin:10px 0;">
        <el-button @click="addBatch" type="primary" size="small" >添加生产批次</el-button>
    </el-col>
    <el-table
        :data="tableData"
        :header-cell-style="{background:'#FAFAFA',color:'#606266',height:'50px'}"
        border
        stripe
        size="medium"
        class="trace-table"
        style="width: 100%">
        <el-table-column prop="product_batch" align="center" label="生产批次号"></el-table-column>
        <el-table-column prop="code" align="center" label="产品编号"></el-table-column>
        <el-table-column prop="product_name" align="center" label="产品名称"></el-table-column>
        <el-table-column prop="remark" align="center" label="批次备注"></el-table-column>
        <el-table-column prop="template_name" align="center" label="扫码模板"></el-table-column>
        <el-table-column prop="create_time" align="center" label="添加时间啊"></el-table-column>
        <el-table-column label="操作" align="center" fixed="right" width="280px">
                <template slot-scope="scope">
                    <el-button
                        size="mini"
                        type="primary"
                        @click="handleCopy(scope.row)"
                        >复制</el-button>
                    <el-button
                        size="mini"
                        type="primary"
                        @click="handleEdit(scope.row)"
                        >修改</el-button>
                    <el-button
                        size="mini"
                        type="danger"
                        @click="handleDele(scope.row)"
                        >删除</el-button>
                </template>
        </el-table-column>
    </el-table>
    <pagination
        v-show="+total>0"
        :total="+total"
        :page.sync="queryForm.pageNum"
        :limit.sync="queryForm.pageSize"
        @pagination="getList"/>
    <el-dialog title="复制批次" class="copyDialog" :visible.sync="copyDialog" width="25%" @close="copyDialog=false">
        <el-form ref="copyForm" :model="copyForm" label-position="top" label-width="100px" :rules="rule" size="small">
            <el-form-item prop="product_batch" label="请先输入新的生产批次号：" >
                <el-input style="width:100%" v-model="copyForm.product_batch"></el-input>
            </el-form-item>
        </el-form>
        <div slot="footer" class="dialog-footer">
            <el-button type="primary" @click="submitForm">确 定</el-button>
            <el-button @click="copyDialog=false">取 消</el-button>
        </div>
    </el-dialog>
  </div>
</template>

<script>
import {getProductBatchList,deleProductBatch,saveProductBatch} from '@/api/app/trace'
export default {
    data(){
        return{
            batchInfo:{},
            copyForm:{
                product_batch:''
            },
            copyDialog:false,
            queryForm:{
                time:[],
                keywords:'',
                pageNum:1,
                pageSize:10
            },
            tableData:[],
            total:0,
            rule:{
                 product_batch:[
                    { required: true, message: "请输入新的生产批次号", trigger: "blur" },
                ],
            }
        }
    },
    created(){
        this.getList();
    },
    methods:{
        getList(){
            var params=Object.assign({},this.queryForm)
            if(!this.queryForm.time||this.queryForm.time.length==0){
                params.startTime=''
                params.endTime=''
            }else{
                params.startTime=this.queryForm.time[0]
                params.endTime=this.queryForm.time[1]
            }
            delete params.time
            getProductBatchList(params).then(res=>{
                this.tableData=res.data
                this.total=res.total
            })
        },
        addBatch(){
            this.$router.push({path:'/app/trace/productBatch'})
        },
        handleCopy(row){
            this.batchInfo=row
            this.copyForm={
                product_batch:''
            }
            this.copyDialog=true
        },
        submitForm(){
            this.$refs["copyForm"].validate(valid => {
                if(valid){
                    var arr=Object.assign({},this.batchInfo)
                    arr.product_batch=this.copyForm.product_batch
                    delete arr.create_time
                    delete arr.id
                    delete arr.template_name
                    delete arr.code
                    delete arr.product_name
                    saveProductBatch(arr).then(res=>{
                        if(res.code==200){
                            this.$message.success('复制成功')
                            this.copyDialog=false
                            this.getList()
                        }else{
                            this.$message.error(res.msg)
                        }
                    })
                }
            })
        },
        //根据批次号跳转
        handleEdit(row){
            this.$router.push({path:'/app/trace/productBatch',query:{batch:row.product_batch}})
        },
        handleDele(row){
            this.$confirm(`确定删除该生产批次`, '提示', {
                confirmButtonText: '确定',
                cancelButtonText: '取消',
                type: 'warning'
            }).then(() => {
                deleProductBatch({id:row.id}).then(res=>{
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
        reset(formName){
            this.$refs[formName].resetFields();
            this.query()
        },
    }
}
</script>

<style lang="scss" scoped>
.app-container .tips{
    padding: 8px 16px;
    background-color: #ecf8ff;
    border-radius: 4px;
    border-left: 5px solid #50bfff;
    margin: 20px 0;
}
.dialog-footer{
  margin: 30px 0;
}
</style>