<template>
  <div class="app-container">
    <el-tabs v-model="activeName" type="card" @tab-click="handleClick">
        <el-tab-pane label="门店余额" name="first">
            <el-tabs v-model="firstActiveName" @tab-click="handleClickStore">
                <el-tab-pane label="直营门店" name="is_self"></el-tab-pane>
                <el-tab-pane label="非直营门店" name="isnot_self"></el-tab-pane>
            </el-tabs>
            <!-- 搜索框 -->
            <div class="tab-bar">
                <el-form ref="queryForm" :model="queryForm" label-width="100px" :inline="true" size="small">
                    <el-form-item label="添加时间" prop="time">
                        <el-date-picker
                            style="width:220px"
                            v-model="queryForm.time"
                            type="daterange"
                            range-separator="至"
                            unlink-panels=""
                            format="yyyy 年 MM 月 dd 日"
                            value-format="yyyy-MM-dd"
                            start-placeholder="开始日期"
                            end-placeholder="结束日期">
                        </el-date-picker>
                    </el-form-item>
                    <el-form-item label="关键词" prop="keywords">
                        <el-input style="width:220px" v-model="queryForm.keywords" placeholder="门店编号、名称"></el-input>
                    </el-form-item>
                    <el-form-item label="门店类型" prop="type">
                        <el-select style="width:220px" size="small" v-model="queryForm.type" placeholder="请选择类型">
                            <el-option
                                v-for="item in typeOptions"
                                :key="item.id"
                                :label="item.class_name"
                                :value="item.id">
                            </el-option>
                        </el-select>
                    </el-form-item>
                    <el-form-item label="类型" prop="flow_type">
                        <el-select style="width:220px" size="small" v-model="queryForm.flow_type" placeholder="请选择类型">
                            <el-option
                                v-for="item in flowOptions"
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
            <!-- 表格数据 -->
            <el-table
                :data="tableData"
                :header-cell-style="{background:'#FAFAFA',color:'#606266',height:'50px'}"
                border
                stripe
                size="medium"
                class="trace-table"
                style="width: 100%">
                <el-table-column prop="store_code" align="center" label="门店编号"></el-table-column>
                <el-table-column prop="store_name" align="center" label="门店名称"></el-table-column>
                <el-table-column prop="type" align="center" label="门店类型" :formatter="type"></el-table-column>
                <el-table-column prop="number" align="center" label="余额变动">
                    <template slot-scope="scope">
                        <span>{{scope.row.pm==1?`+${scope.row.number}`:`${scope.row.number}`}}</span>
                    </template>
                </el-table-column>
                <el-table-column prop="flow_typw" align="center" label="类型" :formatter="flow_type"></el-table-column>
                <el-table-column prop="balance" align="center" label="余额"></el-table-column>
                <el-table-column prop="create_time" align="center" label="时间"></el-table-column>
                <el-table-column label="操作" align="center" fixed="right" width="150px">
                    <template slot-scope="scope">
                        <el-button
                            size="mini"
                            type="primary"
                            @click="handleDes(scope.row)">详情</el-button>
                    </template>
                </el-table-column>
            </el-table>
            <pagination
                v-show="+total>10"
                :total="+total"
                :page.sync="queryForm.pageNum"
                :limit.sync="queryForm.pageSize"
                @pagination="getStoreBalance"/>
        </el-tab-pane>
        <el-tab-pane label="佣金提现" name="second">
            <el-tabs v-model="secondActiveName" @tab-click="handleClickCash">
                <el-tab-pane label="提现申请管理" name="cash_check"></el-tab-pane>
                <el-tab-pane label="已结算记录" name="cash_log"></el-tab-pane>
            </el-tabs>
            <div class="tab-bar">
                <el-form ref="queryCashForm" :model="queryCashForm" label-width="100px" :inline="true" size="small">
                    <el-form-item label="申请时间" prop="time">
                        <el-date-picker
                            style="width:220px"
                            v-model="queryCashForm.time"
                            type="daterange"
                            range-separator="至"
                            unlink-panels=""
                            format="yyyy 年 MM 月 dd 日"
                            value-format="yyyy-MM-dd"
                            start-placeholder="开始日期"
                            end-placeholder="结束日期">
                        </el-date-picker>
                    </el-form-item>
                    <el-form-item label="发放时间" prop="time" v-if="secondActiveName=='cash_log'">
                        <el-date-picker
                            style="width:220px"
                            v-model="queryCashForm.issue_time"
                            type="daterange"
                            range-separator="至"
                            unlink-panels=""
                            format="yyyy 年 MM 月 dd 日"
                            value-format="yyyy-MM-dd"
                            start-placeholder="开始日期"
                            end-placeholder="结束日期">
                        </el-date-picker>
                    </el-form-item>
                    <el-form-item label="关键词" prop="keywords">
                        <el-input style="width:220px" v-model="queryCashForm.keywords" placeholder="门店编号、名称"></el-input>
                    </el-form-item>
                    <el-form-item label="提现方式" prop="cash_type">
                        <el-select style="width:220px" size="small" v-model="queryCashForm.cash_type" placeholder="请选择提现方式">
                            <el-option
                                v-for="item in cashTypeOptions"
                                :key="item.dict_value"
                                :label="item.dict_label"
                                :value="item.dict_value">
                            </el-option>
                        </el-select>
                    </el-form-item>
                    <el-form-item label="状态" prop="status" v-if="secondActiveName!='cash_log'">
                        <el-select style="width:220px" size="small" v-model="queryCashForm.status" placeholder="请选择提现状态">
                            <el-option
                                v-for="item in cashStatusOptions"
                                :key="item.dict_value"
                                :label="item.dict_label"
                                :value="item.dict_value">
                            </el-option>
                        </el-select>
                    </el-form-item>
                    <el-form-item > 
                        <el-button type="primary" icon="el-icon-search" @click="queryCash">查询</el-button>
                        <el-button icon="el-icon-refresh" @click="resetCash('queryCashForm')">重置</el-button>
                    </el-form-item>
                </el-form>
            </div>
            <!-- 表格数据 -->
             <el-table
                :data="cashTableData"
                :header-cell-style="{background:'#FAFAFA',color:'#606266',height:'50px'}"
                border
                stripe
                size="medium"
                class="trace-table"
                style="width: 100%">
                <el-table-column prop="order" align="center" label="订单号"></el-table-column>
                <el-table-column prop="store_code" align="center" label="门店编号"></el-table-column>
                <el-table-column prop="store_name" align="center" label="门店名称"></el-table-column>
                <el-table-column prop="cash_money" align="center" label="提现金额"></el-table-column>
                <el-table-column prop="get_money" align="center" label="到账金额"></el-table-column>
                <el-table-column prop="create_time" align="center" label="申请时间"></el-table-column>
                <el-table-column prop="issue_time" align="center" label="发放时间" v-if="secondActiveName=='cash_log'"></el-table-column>
                <el-table-column prop="cash_type" align="center" label="提现方式" :formatter="cash_type"></el-table-column>
                <el-table-column prop="status" align="center" label="状态" :formatter="cash_status" v-if="secondActiveName!='cash_log'"></el-table-column>
                <el-table-column label="操作" align="center" fixed="right" width="150px" v-if="secondActiveName!='cash_log'" >
                    <template slot-scope="scope">
                        <el-button
                            size="mini"
                            v-if="scope.row.status==1"
                            type="danger"
                            @click="handleRefuse(scope.row)">驳回</el-button>
                        <el-button
                            size="mini"
                            v-if="scope.row.status==1"
                            type="primary"
                            @click="handleCash(scope.row)">转账</el-button>
                        <el-button
                            size="mini"
                            v-if="scope.row.status==3||scope.row.status==4"
                            type="danger"
                            @click="handleDele(scope.row)">删除</el-button>
                    </template>
                </el-table-column>
             </el-table>
             <pagination
                v-show="+totals>10"
                :total="+totals"
                :page.sync="queryCashForm.pageNum"
                :limit.sync="queryCashForm.pageSize"
                @pagination="getCashLog"/>
        </el-tab-pane>
        <el-tab-pane label="提现设置" name="third">
            <el-form :model="form" ref="form" class="form" label-width="150px" :rules="rule" size="medium">
                <el-form-item prop="cash_type" label="提现方式" >
                    <el-radio-group v-model="form.cash_type">
                        <el-radio v-for="(item,index) in cashTypeOptions" :label="item.dict_value" :key="index">
                            {{item.dict_label}}
                            <span>
                                <el-tooltip :content="item.remark" placement="top">
                                    <i class="el-icon-info"></i>
                                </el-tooltip>
                            </span>
                        </el-radio>
                    </el-radio-group>
                </el-form-item>
                <el-form-item prop="cash_min" label="提现门槛" >
                    <el-input style="width:80%" v-model.number="form.cash_min" placeholder="请输入提现门槛"/>
                </el-form-item>
                <el-form-item prop="cash_max" label="提现上限" >
                    <el-input style="width:80%" v-model.number="form.cash_max" placeholder="请输入提现上限"/>
                </el-form-item>
                <el-form-item prop="cash_times" label="每日提现次数" >
                    <el-input style="width:80%" v-model.number="form.cash_times" placeholder="请输入每日提现次数"/>
                </el-form-item>
                <el-form-item prop="cash_charge" label="提现手续费" >
                    <el-input style="width:80%" v-model.number="form.cash_charge" placeholder="请输入提现手续费"/>
                </el-form-item>
                <el-form-item prop="cash_settle_charge" label="店铺自营商品结算手续费" >
                    <el-input style="width:80%" v-model.number="form.cash_settle_charge" placeholder="店铺自营商品结算手续费"/>
                </el-form-item>
                 <el-form-item style="margin-top:20px">
                    <el-button  type="primary" @click="onSubmit">保存</el-button>
                </el-form-item>
            </el-form>
        </el-tab-pane>
    </el-tabs>
  </div>
</template>

<script>
import {
getStoreTypeList,
getStoreFinanceBill,
getStoreCashBill,
getStoreCashSet,
saveStoreCashSet,
cashStore,
refuseCashReply,
deleCashReply} from '@/api/customer/store'
export default {
    data(){
        return{
            activeName:'first',
            secondActiveName:'cash_check',
            firstActiveName:'is_self',
            form:{
                cash_type:'1',
                cash_min:'',
                cash_max:'',
                cash_times:'',
                cash_charge:'',
                cash_settle_charge:'',
            },
            //提现方式
            cashTypeOptions:[],
            tableData:[],
            cashTableData:[],
            total:0,
            totals:0,
            typeOptions:[],
            flowOptions:[],
            cashStatusOptions:[],
            queryCashForm:{
                time:[],
                issue_time:[],
                keywords:'',
                cash_type:'',
                status:'',
                pageNum:1,
                pageSize:10
            },
            queryForm:{
                time:[],
                keywords:'',
                type:'',
                flow_type:'',
                pageNum:1,
                pageSize:10
            },
            queryTypeForm:{
                pageNum:1,
                pageSize:999
            },
            rule:{

            }
        }
    },
    created(){
        this.getStoreBalance()
        getStoreTypeList(this.queryTypeForm).then(res=>{
            this.typeOptions=res.data
        })
        this.getDicts({type:'store_balance_flow_type'}).then(res=>{
            this.flowOptions=res.data
        })
         //佣金提现状态
        this.getDicts({type:'store_commission_cash_status'}).then(res=>{
            this.cashStatusOptions=res.data
        })
        //提现方式
        this.getDicts({type:'store_commission_cash_type'}).then(res=>{
            this.cashTypeOptions=res.data
        })
    },
    methods:{
        handleClick(){
            var val=this.activeName
            if(val=='first'){
                this.reset('queryForm')
            }else if(val=='second'){
                this.resetCash('queryCashForm')
            }else{
                this.getStoreCashSet()
            }
        },
        getStoreCashSet(){
            getStoreCashSet({}).then(res=>{
                if(res.data){
                    this.form=res.data
                    
                }
            })
        },
        handleClickStore(){
            this.tableData=[]
            this.reset('queryForm')
        },
        handleClickCash(){
            this.cashTableData=[]
            this.resetCash('queryCashForm')
        },
        onSubmit(){
             this.$refs["form"].validate(valid => {
                 if(valid){
                     saveStoreCashSet(this.form).then(res=>{
                         if(res.code==200){
                            this.$message.success(res.msg)
                            this.getStoreCashSet()
                        }else{
                            this.$message.error(res.msg)
                        }
                     })
                 }
             })
        },
        type(row){
            return this.typeOptions.filter(item=>item.id==row.type).map(item=>item.class_name)[0]
        },
        cash_type(row){
            return this.cashTypeOptions.filter(item=>item.dict_value==row.type).map(item=>item.dict_label)[0]
        },
        cash_status(row){
            return this.cashStatusOptions.filter(item=>item.dict_value==row.status).map(item=>item.dict_label)[0]
        },
        //明细种类
        flow_type(row){
            return this.flowOptions.filter(item=>item.dict_value==row.category).map(item=>item.dict_label)[0]
        },
        //门店余额
        getStoreBalance(){
            var params=Object.assign({},this.queryForm)
            if(!this.queryForm.time||this.queryForm.time.length==0){
                params.startTime=''
                params.endTime=''
            }else{
                params.startTime=this.queryForm.time[0]
                params.endTime=this.queryForm.time[1]
            }
            delete params.time
            params.is_self=this.firstActiveName=='is_self'?0:1
            getStoreFinanceBill(params).then(res=>{
                this.tableData=res.data
                this.total=res.total
            })
        },
        //提现记录
        getCashLog(){
            var params=Object.assign({},this.queryCashForm)
            if(!this.queryCashForm.time||this.queryCashForm.time.length==0){
                params.startTime=''
                params.endTime=''
            }else{
                params.startTime=this.queryCashForm.time[0]
                params.endTime=this.queryCashForm.time[1]
            }
            if(!this.queryCashForm.issue_time||this.queryCashForm.issue_time.length==0){
                params.issueStartTime=''
                params.issueEndTime=''
            }else{
                params.issueStartTime=this.queryCashForm.time[0]
                params.issueEndTime=this.queryCashForm.time[1]
            }
            params.log_status=this.secondActiveName=='cash_check'?0:1
            delete params.time
            delete params.issue_time
             getStoreCashBill(params).then(res=>{
                this.cashTableData=res.data
                this.totals=res.total
            })
        },
        handleCash(row){
            this.$confirm(`确认已转账完成吗？`, '提示', {
                confirmButtonText: '确定',
                cancelButtonText: '取消',
                type: 'warning'
            }).then(() => {
                 cashStore(row).then(res=>{
                    if(res.code==200){
                        this.$message.success(res.msg)
                        this.getCashLog()
                    }else{
                        this.$message.error(res.msg)
                    }
                 })
            }).catch(() => {});
        },
        handleRefuse(row){
            this.$confirm(`确认驳回该提现申请吗？`, '提示', {
                confirmButtonText: '确定',
                cancelButtonText: '取消',
                type: 'warning'
            }).then(() => {
                 refuseCashReply(row).then(res=>{
                    if(res.code==200){
                        this.$message.success(res.msg)
                        this.getCashLog()
                    }else{
                        this.$message.error(res.msg)
                    }
                 })
            }).catch(() => {});
        },
        handleDele(row){
            this.$confirm(`确认删除该提现申请吗？`, '提示', {
                confirmButtonText: '确定',
                cancelButtonText: '取消',
                type: 'warning'
            }).then(() => {
                 deleCashReply({id:row.id}).then(res=>{
                    if(res.code==200){
                        this.$message.success(res.msg)
                        this.getCashLog()
                    }else{
                        this.$message.error(res.msg)
                    }
                 })
            }).catch(() => {});
        },
        handleDes(row){

        },
        queryCash(){
          this.queryCashForm.pageNum = 1;
          this.getCashLog();
        },
        resetCash(formName){
            this.$refs[formName].resetFields();
            this.queryCash()
        },
        query(){
          this.queryForm.pageNum = 1;
          this.getStoreBalance();
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