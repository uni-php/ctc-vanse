<template>
  <div class="app-container">
       <el-tabs v-model="activeName" type="card" @tab-click="handleClick">
            <el-tab-pane label="账户余额管理" name="first">
                <div class="tips">
                    <p>1、如经销商需使用二维码营销或超级导购功能自行创建活动进行红包发放，则要确保账户余额充足，红包发放的金额会从余额中扣除，余额不足会导致红包发放失败；</p>
                    <p>2、因红包的实际发放金额是从总部微信支付商户平台的账户中扣除，所以在给经销商充值前，请让经销商线下转账给总部后再进行充值并保证总部微信支付商户平台的账户余额充足！</p>
                    <p>3、仅可对总部直属的经销商进行充值。</p>
                </div>
                <div class="tab-bar">
                    <el-form ref="queryForm" :model="queryForm" label-width="100px" :inline="true" size="small">
                        <el-form-item label="关键词" prop="keywords">
                            <el-input style="width:220px" v-model="queryForm.keywords" placeholder="经销商编号、名称、负责人"></el-input>
                        </el-form-item>
                        <el-form-item label="经销商级别" prop="distributor_level">
                            <el-select style="width:220px" size="small" v-model="queryForm.distributor_level" placeholder="请选择经销商级别">
                                <el-option
                                    v-for="item in levelOption"
                                    :key="item.id"
                                    :label="item.level_name"
                                    :value="item.id">
                                </el-option>
                            </el-select>
                        </el-form-item>
                        <el-form-item label="经销商状态" prop="status">
                            <el-select style="width:220px" size="small" v-model="queryForm.status" placeholder="请选择经销商状态">
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
                <el-table
                    :data="tableData"
                    :header-cell-style="{background:'#FAFAFA',color:'#606266',height:'50px'}"
                    border
                    stripe
                    size="medium"
                    class="trace-table"
                    style="width: 100%">
                    <el-table-column prop="distributor_code" align="center" label="经销商编号"></el-table-column>
                    <el-table-column prop="distributor_name" align="center" label="经销商名称"></el-table-column>
                    <el-table-column prop="distributor_level" align="center" label="经销商级别" :formatter="level"></el-table-column>
                    <el-table-column prop="person" align="center" label="负责人"></el-table-column>
                    <el-table-column prop="phone" align="center" label="手机号码"></el-table-column>
                    <el-table-column prop="is_disable" align="center" label="状态" :formatter="status"></el-table-column>
                    <el-table-column prop="balance" align="center" label="账户余额"></el-table-column>
                    <el-table-column label="操作" align="center" fixed="right" width="260px">
                        <template slot-scope="scope">
                             <el-button
                                size="mini"
                                type="primary"
                                @click="handleSet(scope.row)">增减</el-button>
                            <el-button
                                size="mini"
                                type="primary"
                                @click="handleDes(scope.row)">查看明细</el-button>
                        </template>
                    </el-table-column>
                </el-table>
            </el-tab-pane>
            <el-tab-pane label="余额变动明细" name="second">
                <div class="tab-bar">
                    <el-form ref="queryLogForm" :model="queryLogForm" label-width="100px" :inline="true" size="small">
                        <el-form-item label="添加时间" prop="time">
                            <el-date-picker
                                style="width:220px"
                                v-model="queryLogForm.time"
                                type="daterange"
                                unlink-panels=""
                                range-separator="至"
                                value-format="yyyy-MM-dd"
                                start-placeholder="开始日期"
                                end-placeholder="结束日期">
                            </el-date-picker>
                        </el-form-item>
                        <el-form-item label="关键词" prop="keywords">
                            <el-input style="width:220px" v-model="queryLogForm.keywords" placeholder="经销商编号、名称、负责人"></el-input>
                        </el-form-item>
                        <el-form-item label="经销商级别" prop="distributor_level">
                            <el-select style="width:220px" size="small" v-model="queryLogForm.distributor_level" placeholder="请选择经销商级别">
                                <el-option
                                    v-for="item in levelOption"
                                    :key="item.id"
                                    :label="item.level_name"
                                    :value="item.id">
                                </el-option>
                            </el-select>
                        </el-form-item>
                        <el-form-item label="类型" prop="type">
                            <el-select style="width:220px" size="small" v-model="queryLogForm.type" placeholder="请选择类型">
                                <el-option
                                    v-for="item in flowTypeOptions"
                                    :key="item.dict_value"
                                    :label="item.dict_label"
                                    :value="item.dict_value">
                                </el-option>
                            </el-select>
                        </el-form-item>
                        <el-form-item > 
                            <el-button type="primary" icon="el-icon-search" @click="queryLog">查询</el-button>
                            <el-button icon="el-icon-refresh" @click="resetLog('queryLogForm')">重置</el-button>
                        </el-form-item>
                    </el-form>
                </div>
                <el-row style="margin-bottom:10px">
                    <el-col :span="2"><el-tag size="medium">余额充值总数：<span style="color:red">{{recharge_sum}}</span></el-tag></el-col><el-col :span="2"><el-tag size="medium">余额充值总数：<span style="color:red">{{deduction_sum}}</span></el-tag></el-col>
                </el-row>
                <el-table
                    :data="logTableData"
                    :header-cell-style="{background:'#FAFAFA',color:'#606266',height:'50px'}"
                    border
                    stripe
                    size="medium"
                    class="trace-table"
                    style="width: 100%">
                    <el-table-column prop="distributor_code" align="center" label="经销商编号"></el-table-column>
                    <el-table-column prop="distributor_name" align="center" label="经销商名称"></el-table-column>
                    <el-table-column prop="distributor_level" align="center" label="经销商级别" :formatter="level"></el-table-column>
                    <el-table-column prop="person" align="center" label="负责人"></el-table-column>
                    <el-table-column prop="phone" align="center" label="手机号码"></el-table-column>
                    <el-table-column prop="number" align="center" label="余额变动">
                        <template slot-scope="scope">
                            <span>{{scope.row.pm==1?`+${scope.row.number}`:`${scope.row.number}`}}</span>
                        </template>
                    </el-table-column>
                    <el-table-column prop="type" align="center" label="类型" :formatter="flow_type"></el-table-column>
                    <el-table-column prop="remark" align="center" label="备注"></el-table-column>
                    <el-table-column prop="create_time" align="center" label="时间"></el-table-column>
                    <el-table-column prop="create_by" align="center" label="操作人"></el-table-column>
                </el-table>
                <pagination
                    v-show="+totals>10"
                    :total="+totals"
                    :page.sync="queryLogForm.pageNum"
                    :limit.sync="queryLogForm.pageSize"
                    @pagination="getLogList"/>
            </el-tab-pane>
       </el-tabs>
        <el-dialog title="余额更改" :visible.sync="dialogVisible" width="30%" @close="dialogVisible=false">
            <el-form ref="form" :model="form" label-width="100px" size="small">
                <el-form-item label="经销商：" prop="distributor">
                    <span>{{distributorInfo.distributor_name}}</span>
                </el-form-item>
                <el-form-item label="账户余额：" prop="balance">
                    <span>{{distributorInfo.balance}}</span>
                </el-form-item>
                <el-form-item prop="money_num" label="金额数值：" >
                    <el-input-number style="width:40%" v-model="form.money_num" :step="1"></el-input-number>
                </el-form-item>
                <el-form-item label="备注：" prop="remark">
                    <el-input style="width:80%"  v-model="form.remark" placeholder="请输入备注"/>
                </el-form-item>
            </el-form>
            <div slot="footer" class="dialog-footer">
                <el-button type="primary" @click="submitForm">确 定</el-button>
                <el-button type="primary" @click="dialogVisible=false">取 消</el-button>
            </div>
        </el-dialog>
        <!-- 经销商余额变动明细 -->
        <el-dialog title="明细" :visible.sync="billVisible" width="60%" @close="billVisible=false">
            <div class="tab-bar">
                <el-form ref="billForm" :model="billForm" label-width="100px" :inline="true" size="small">
                    <el-form-item label="添加时间" prop="time">
                        <el-date-picker
                            style="width:220px"
                            v-model="billForm.time"
                            type="daterange"
                            unlink-panels=""
                            range-separator="至"
                            value-format="yyyy-MM-dd"
                            start-placeholder="开始日期"
                            end-placeholder="结束日期">
                        </el-date-picker>
                    </el-form-item>
                    <el-form-item label="类型" prop="type">
                        <el-select style="width:220px" size="small" v-model="billForm.type" placeholder="请选择类型">
                            <el-option
                                v-for="item in flowTypeOptions"
                                :key="item.dict_value"
                                :label="item.dict_label"
                                :value="item.dict_value">
                            </el-option>
                        </el-select>
                    </el-form-item>
                    <el-form-item > 
                        <el-button type="primary" icon="el-icon-search" @click="queryBill">查询</el-button>
                        <el-button icon="el-icon-refresh" @click="resetBill('billForm')">重置</el-button>
                    </el-form-item>
                </el-form>
            </div>
            <el-table
                    :data="billTableData"
                    :header-cell-style="{background:'#FAFAFA',color:'#606266',height:'50px'}"
                    border
                    stripe
                    size="medium"
                    class="trace-table"
                    style="width: 100%">
                    <el-table-column prop="number" align="center" label="余额变动">
                        <template slot-scope="scope">
                            <span>{{scope.row.pm==1?`+${scope.row.number}`:`${scope.row.number}`}}</span>
                        </template>
                    </el-table-column>
                    <el-table-column prop="type" align="center" label="类型" :formatter="flow_type"></el-table-column>
                    <el-table-column prop="remark" align="center" label="备注"></el-table-column>
                    <el-table-column prop="create_time" align="center" label="时间"></el-table-column>
                    <el-table-column prop="create_by" align="center" label="操作人"></el-table-column>
            </el-table>
            <pagination
                    v-show="+billTotal>10"
                    :total="+billTotal"
                    :page.sync="billForm.pageNum"
                    :limit.sync="billForm.pageSize"
                    @pagination="getBillList"/>
        </el-dialog>
  </div>
</template>

<script>
import {
    getDistributorLevelList,
    getRechargeDistributorList,
    changeDistributorBalance,
    getDistributorBillLog} from '@/api/customer/distributor'
export default {
    data(){
        return{
            recharge_sum:0,
            deduction_sum:0,
            dialogVisible:false,
            billVisible:false,
            form:{
                money_num:0,
                remark:'',
            },
            levelOption:[],
            tableData:[],
            logTableData:[],
            billTableData:[],
            total:0,
            totals:0,
            billTotal:0,
            activeName:'first',
            flowTypeOptions:[],//资金流动类型
            statusOption:[
                {
                    label:'正常',
                    value:0
                },
                {
                    label:'禁用',
                    value:1
                }
            ],
            distributorInfo:{},
            queryLogForm:{
                time:[],
                keywords:'',
                distributor_level:'',
                distributor_id:'',
                type:'',
                pageNum:1,
                pageSize:10
            },
            billForm:{
                time:[],
                type:'',
                keywords:'',
                distributor_level:'',
                distributor_id:'',
                pageNum:1,
                pageSize:10
            },
            queryForm:{
                keywords:'',
                distributor_level:'',
                status:'',
                pageNum:1,
                pageSize:10
            }
        }
    },
    created(){
        this.getList()
        this.getDisLevel()
        this.getDicts({type:'distributor_balance_flow_type'}).then(res=>{
            this.flowTypeOptions=res.data
        })
    },
    methods:{
        getList(){
            getRechargeDistributorList(this.queryForm).then(res=>{
                this.tableData=res.data
                this.total=res.total
            })
        },
        getLogList(){
            var params=Object.assign({},this.queryLogForm)
            if(!this.queryLogForm.time||this.queryLogForm.time.length==0){
                params.startTime=''
                params.endTime=''
            }else{
                params.startTime=this.queryLogForm.time[0]
                params.endTime=this.queryLogForm.time[1]
            }
            delete params.time
            getDistributorBillLog(params).then(res=>{
                this.logTableData=res.data
                this.totals=res.total
                this.recharge_sum=res.recharge_sum
                this.deduction_sum=res.deduction_sum
            })
        },
        async getBillList(){
            var params=Object.assign({},this.billForm)
            if(!this.billForm.time||this.billForm.time.length==0){
                params.startTime=''
                params.endTime=''
            }else{
                params.startTime=this.billForm.time[0]
                params.endTime=this.billForm.time[1]
            }
            delete params.time
            await getDistributorBillLog(params).then(res=>{
                this.billTableData=res.data
                this.billTotal=res.total
            })
        },
        getDisLevel(){
            getDistributorLevelList({}).then(res=>{
                this.levelOption=res.data
            })
        },
        level(row){
            return this.levelOption.filter(item=>item.id==row.distributor_level).map(item=>item.level_name)[0]
        },
        flow_type(row){
            return this.flowTypeOptions.filter(item=>item.dict_value==row.type).map(item=>item.dict_label)[0]
        },
        status(row){
            return this.statusOption.filter(item=>item.value==row.is_disable).map(item=>item.label)[0]
        },
        handleClick(){
            if(this.activeName=='first'){
                this.tableData=[]
                this.reset('queryForm')
            }else{
                this.logTableData=[]
                this.resetLog('queryLogForm')
            }
        },
        handleSet(row){
            this.distributorInfo=row
            this.form.money_num=0
            this.form.remark=''
            this.dialogVisible=true
        },
        submitForm(){
            if(this.form.money_num==0){
                this.$message.warning('充值金额不得为零')
                return;
            }
            if(this.form.money_num<0){
                if(this.form.money_num*-1>+this.distributorInfo.balance){
                    this.$message.warning('扣减金额大于该经销商余额！')
                    return;
                }
            }
            changeDistributorBalance({id:this.distributorInfo.id,money_num:this.form.money_num}).then(res=>{
                if(res.code==200){
                    this.$message.success(res.msg)
                    this.dialogVisible=false
                    this.getList()
                }else{
                    this.$message.error(res.msg)
                }
            })
        },
        handleDes(row){
            this.billForm.distributor_id=row.id
            this.billForm.time=[]
            this.billForm.type=''
            this.billForm.pageNum=1
            this.billTableData=[]
            this.getBillList()
            this.billVisible=true
        },
        queryLog(){
          this.queryLogForm.pageNum = 1;
          this.getLogList();
        },
        resetLog(formName){
            this.$refs[formName].resetFields();
            this.queryLog()
        },
        queryBill(){
          this.billForm.pageNum = 1;
          this.getBillList();
        },
        resetBill(formName){
            this.$refs[formName].resetFields();
            this.queryBill()
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
    padding: 6px 16px;
    background-color: #ecf8ff;
    border-radius: 4px;
    border-left: 5px solid #50bfff;
    margin: 15px 0;
    p{
        font-size: 14px;
    }
}
</style>