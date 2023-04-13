<template>
  <div class="app-container">
    <el-tabs v-model="activeName">
      <el-tab-pane label="提现列表" name="first"></el-tab-pane>
      <el-tab-pane label="提现设置" name="second"></el-tab-pane>
    </el-tabs>
    <div v-if="activeName=='first'">
        <el-form :model="queryForm" ref="queryForm" :inline="true" size="small"  label-width="100px">
          <el-form-item label="提现时间" prop="date" v-if="activeName=='first'">
            <el-date-picker
              style="width:240px"
              v-model="queryForm.date"
              type="daterange"
              unlink-panels=""
              range-separator="至"
              format="yyyy-MM-dd"
              value-format="yyyy-MM-dd"
              start-placeholder="开始日期"
              end-placeholder="结束日期">
            </el-date-picker>
          </el-form-item>
          <el-form-item label="合伙人名称" prop="company">
            <el-input style="width:240px" v-model="queryForm.company" placeholder="请输入合伙人名称"></el-input>
          </el-form-item>
          <el-form-item > 
            <el-button type="primary" icon="el-icon-search" @click="query">查询</el-button>
            <el-button icon="el-icon-refresh" @click="resetQuery('queryForm')">重置</el-button>
          </el-form-item>
        </el-form>
        <el-table
          :data="tableData"
          :header-cell-style="{background:'#FAFAFA',color:'#606266',height:'50px'}"
          border
          stripe
          size="medium"
          class="trace-table"
          style="width: 100%">
            <el-table-column prop="cash_order" show-overflow-tooltip="" align="center" label="提现订单号"></el-table-column>
            <el-table-column prop="company" show-overflow-tooltip="" align="center" label="合伙人"></el-table-column>
            <el-table-column prop="account" align="center" label="合伙人账号"></el-table-column>
            <el-table-column prop="bank_info" align="center" label="银行卡信息">
                <template slot-scope="scope">
                  <span>{{bank_type(scope.row.bank_info)}}</span>
                </template>
            </el-table-column>
            <el-table-column prop="money" align="center" label="提现金额"></el-table-column>
            <el-table-column prop="received_money" align="center" label="实际到账金额"></el-table-column>
            <el-table-column prop="create_time" show-overflow-tooltip="" align="center" label="提现时间"></el-table-column>
            <el-table-column prop="status" align="center" label="状态">
              <template slot-scope="scope">
                <span>{{scope.row.status==0?'待打款':scope.row.status==1?'已打款':'已拒绝'}}</span>
              </template>
            </el-table-column>
            <el-table-column label="操作" align="center" fixed="right" width="200px">
              <template slot-scope="scope">
                 <el-button
                  size="mini"
                  v-if="scope.row.status==0"
                  type="primary"
                  @click="handlePayment(scope.row)">已打款</el-button>
                <el-button
                  size="mini"
                  type="danger"
                  v-if="scope.row.status==0"
                  @click="handleReject(scope.row)">驳回</el-button>
                  <el-button
                  size="mini"
                  type="text"
                  v-if="scope.row.status==1"
                  >已打款</el-button>
              </template>
          </el-table-column>
        </el-table>
        <pagination
        v-show="+total>10"
        :total="+total"
        :page.sync="queryForm.pageNum"
        :limit.sync="queryForm.pageSize"
        @pagination="getList"
     />
    </div>
    <div v-else>
       <el-form style="margin-top:20px" :model="cashFrom" ref="cashFrom" label-width="160px" :rules="rule" size="medium">
        <el-form-item label="最低提现金额:" prop="min_cash">
          <el-input style="width:60%" v-model.number="cashFrom.min_cash" placeholder="请填写最低提现金额">
            <template slot="append">元</template>
          </el-input>
        </el-form-item>
        <el-form-item label="最高提现金额:" prop="max_cash">
          <el-input style="width:60%" v-model.number="cashFrom.max_cash" placeholder="请填写最高提现金额">
            <template slot="append">元</template>
          </el-input>
        </el-form-item>
        <el-form-item label="每月最多提现次数:" prop="limit_times">
          <el-input style="width:60%" v-model.number="cashFrom.limit_times" placeholder="请填写每月最多提现次数">
            <template slot="append">次</template>
          </el-input>
        </el-form-item>
        <el-form-item label="提现手续费:" prop="service_charge">
          <el-input style="width:60%" max="10" v-model="cashFrom.service_charge" placeholder="提现手续费不大于10">
            <template slot="append">%</template>
          </el-input>
        </el-form-item>
        <el-form-item>
          <el-button type="primary" @click="submitFrom">修改</el-button>
        </el-form-item>
       </el-form>
    </div>
  </div>
</template>

<script>
import { cashList,cashPayment,cashReject,getCashRule,saveCashRule } from '@/api/finance/index';
export default {
  data(){
    return{
      activeName: 'first',
      queryForm:{
        date:[],
        company:'',
        pageNum:1,
        pageSize:10
      },
      cashFrom:{
        min_cash:""
      },
      rule:{
        min_cash:[
          { required: true, message: "最低提现金额不能为空", trigger: "blur" },
          { type: 'number', message: '最低提现金额必须为数字值'}
        ],
        max_cash:[
          { required: true, message: "最高提现金额不能为空", trigger: "blur" },
          { type: 'number', message: '最高提现金额必须为数字值'}
        ],
         limit_times:[
          { required: true, message: "每月最多提现次数不能为空", trigger: "blur" },
          { type: 'number', message: '每月最多提现次数必须为数字值'}
        ],
        service_charge:[
          { required: true, message: "提现手续费不能为空", trigger: "blur" },
          { min:0,max:10, message: '提现手续费必须为数字值且不大于10'}
        ],
      },
      bankOptions:[],
      tableData:[],
      total:0
    }
  },
  created(){
    this.getList()
    this.getCashRule()
    this.getDicts({type:'bank_type'}).then(res=>{
        this.bankOptions=res.data
    })
  },
  computed:{
    bank_type(){
      return function(value){
          if(!value) return '--'
          var item=this.bankOptions.filter(item=>{
          return item.dict_value==value
      })
          return item[0].dict_label
      }
      },
  },
  methods:{
    getList(){
      var arr=Object.assign({},this.queryForm)
      if(arr.date&&arr.date.length>0){
        arr.beginTime=arr.date[0]
        arr.endTime=arr.date[1]
      }else{
        arr.beginTime=''
        arr.endTime=''
      }
      delete arr.date
      cashList(arr).then(res=>{
        this.total=res.total,
        this.tableData=res.data
      })
    },
    getCashRule(){
      getCashRule({}).then(res=>{
        this.cashFrom=res.data
      })
    },
    handlePayment(row){
       this.$confirm('确认已经给该合伙人打款吗?', '提示', {
          confirmButtonText: '确定',
          cancelButtonText: '取消',
          type: 'warning'
        }).then(() => {
          //已打款
          cashPayment(row).then(res=>{
            if(res.code==200){
              this.$message.success(res.msg)
              this.getList()
            }else{
              this.$message.error(res.msg)
            }
          })
        }).catch(() => {      
      });
    },
    handleReject(row){
      this.$confirm('确认驳回提现申请并删除该打款记录吗？同时将余额全数增加回合伙人帐号（包含手续费）', '提示', {
          confirmButtonText: '确定',
          cancelButtonText: '取消',
          type: 'warning'
        }).then(() => {
          //已驳回
          cashReject(row).then(res=>{
            if(res.code==200){
              this.$message.success(res.msg)
              this.getList()
            }else{
              this.$message.error(res.msg)
            }
          })
        }).catch(() => {      
      });
    },
    submitFrom(){
      this.$refs["cashFrom"].validate(valid => {
        if(valid){
          if(this.cashFrom.min_cash>=this.cashFrom.max_cash){
            this.$message.warning("请重新设置提现金额边界值")
            return;
          }
          saveCashRule(this.cashFrom).then(res=>{
            if(res.code==200){
              this.$message.success(res.msg)
              this.getCashRule()
            }else{
              this.$message.error(res.msg)
            }
          })
        }
      })
    },
    query(){
      this.queryForm.pageNum = 1;
      this.getList();
    },
    resetQuery(formName){
      this.$refs[formName].resetFields();
      this.query()
    }
  },
}
</script>

<style>

</style>