<template>
  <div class="app-container">
      <div class="tab-bar">
        <el-form ref="queryForm" :model="queryForm" label-width="100px" :inline="true" size="small">
            <el-form-item label="提现时间" prop="time">
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
            <el-form-item label="关键字" prop="keywords">
                <el-input style="width:220px" v-model="queryForm.keywords" placeholder="手机号、姓名"></el-input>
            </el-form-item>
             <el-form-item label="状态" prop="status">
                <el-select style="width:220px" size="small" v-model="queryForm.status" placeholder="请选择提现状态">
                   <el-option
                        v-for="item in statusOptions"
                        :key="item.dict_value"
                        :label="item.dict_label"
                        :value="item.dict_value">
                    </el-option>
                </el-select>
            </el-form-item>
            <el-form-item > 
                <el-button type="primary" icon="el-icon-search" @click="query">查询</el-button>
                <el-button icon="el-icon-refresh" @click="reset('queryForm')">重置</el-button>
            </el-form-item>
        </el-form>
      </div>
       <el-table
        :data="tableData"
        :header-cell-style="{background:'#FAFAFA',color:'#606266',height:'50px'}"
        border
        stripe
        size="medium"
        class="trace-table"
        style="width: 100%">
        <el-table-column prop="nickname" align="center" label="提现人"></el-table-column>
        <el-table-column prop="phone" align="center" label="手机号"></el-table-column>
        <el-table-column prop="cash_fee" align="center" label="提现金额"></el-table-column>
        <el-table-column prop="account" align="center" label="提现账号"></el-table-column>
        <el-table-column prop="status" align="center" label="提现状态" :formatter="status"></el-table-column>
        <el-table-column prop="create_time" align="center" label="提现时间"></el-table-column>
        <el-table-column label="操作" align="center" fixed="right" width="220px">
            <template slot-scope="scope">
                <el-button
                    size="mini"
                    type="primary"
                    v-if="scope.row.status==1"
                    @click="handlePass(scope.row)">通过</el-button>
                    <el-button
                    size="mini"
                    type="primary"
                    v-if="scope.row.status==2"
                    >已通过</el-button>
                     <el-button
                    size="mini"
                    type="primary"
                    v-if="scope.row.status==3"
                    >已驳回</el-button>
                <el-button
                    size="mini"
                    type="primary"
                    v-if="scope.row.status==1"
                    @click="handleRefuse(scope.row)">驳回</el-button>
            </template>
        </el-table-column>
       </el-table>
         <pagination
        v-show="+total>10"
        :total="+total"
        :page.sync="queryForm.pageNum"
        :limit.sync="queryForm.pageSize"
        @pagination="getList"/>
         <el-dialog title="审核未通过原因" class="refuseDialog" :visible.sync="refuseDialog" width="40%" @close="refuseDialog=false">
            <el-form :model="form" ref="form" :rules="rule" label-width="100px"  size="medium">
                <el-form-item label="原因：" prop="reason">
                    <el-input
                        style="width:80%"
                        type="textarea"
                        :autosize="{ minRows: 3, maxRows: 5}"
                        placeholder="请输入回复内容"
                        v-model="form.reason">
                    </el-input>
                </el-form-item>
            </el-form>
            <div slot="footer" class="dialog-footer">
                <el-button size="medium" type="primary" @click="submit">确 定</el-button>
                <el-button size="medium" @click="refuseDialog=false">取 消</el-button>
            </div>
        </el-dialog>
  </div>
</template>

<script>
import {getFenxiaoCashOrder,passCashOrder,refuseCashOrder} from '@/api/app/mall/distribution.js'
export default {
    data(){
        return{
            form:{
                reason:'',
                id:undefined
            },
            refuseDialog:false,
            queryForm:{
                time:[],
                keywords:'',
                status:'',
                pageNum:1,
                pageSize:10
            },
            tableData:[],
            total:0,
            statusOptions:[
            ],
            rule:{
                reason:[
                    { required: true, message: "回复内容不能为空", trigger: "blur" },
                    { min: 2, max: 15, message: '长度在 2 到 30 个字符', trigger: 'blur' }
                ],
            }
        }
    },
    created(){
        this.getList()
        this.getDicts({type:'mall_fenxiao_cash_status'}).then(res=>{
            this.statusOptions=res.data
        })
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
            getFenxiaoCashOrder(params).then(res=>{
                this.tableData=res.data
                this.total=res.data
            })
        },
        status(row){
            return this.statusOptions.filter(item=>item.dict_value==row.status).map(item=>item.dict_label)[0]
        },
        handleRefuse(row){
            this.refuseDialog=true
            this.form.reason=''
            this.form.id=row.id
        },
        handlePass(row){
            this.$confirm(`确认已打款?`, '提示', {  
                confirmButtonText: '确定',
                cancelButtonText: '取消',
                type: 'warning'
            }).then(() => {
                passCashOrder({id:row.id}).then(res=>{
                    if(res.code==200){
                        this.$message.success(res.msg)
                        this.getList()
                    }else{
                        this.$message.error(res.msg)
                    }
                 })
            }).catch(() => {});
        },
        submit(){
            this.$refs["form"].validate(valid => {
                refuseCashOrder(this.form).then(res=>{
                    if(res.code==200){
                        this.$message.success(res.msg)
                        this.refuseDialog=false
                        this.getList()
                    }else{
                        this.$message.error(res.msg)
                    }
                })
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