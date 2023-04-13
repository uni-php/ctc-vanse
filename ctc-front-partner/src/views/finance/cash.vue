<template>
  <div class="app-container">
      <el-tabs v-model="activeName" type="card" @tab-click="handleClick">
        <el-tab-pane label="我要提现" name="first"></el-tab-pane>
        <el-tab-pane label="提现记录" name="second"></el-tab-pane>
      </el-tabs>
      <div v-show="activeName=='first'">
          <el-form :model="form" ref="form" label-width="140px" :rules="rule" size="medium">
              <el-form-item label="当前用户余额：" prop="balance">
                <span style="color:red;font-size:15px">{{user_info.balance}}</span>
              </el-form-item>
              <el-form-item label="当前剩余提现次数：" prop="limit_times">
                <span style="color:red;font-size:15px">{{limit_times}}</span>
              </el-form-item>
              <el-form-item label="开户银行：" prop="bank_info">
                  <el-select style="width:350px" v-model="form.bank_info" placeholder="请选择开户银行">
                        <el-option
                            v-for="item in bankOptions"
                            :key="item.dict_value"
                            :label="item.dict_label"
                            :value="item.dict_value">
                        </el-option>
                    </el-select>
              </el-form-item>
              <el-form-item label="银行卡号：" prop="card_num">
                  <el-input style="width:350px"   v-model="form.card_num" placeholder="请输入银行卡号"/>
              </el-form-item>
              <el-form-item label="开卡人姓名：" prop="user_name">
                  <el-input style="width:350px"   v-model="form.user_name" placeholder="请输入开卡人姓名"/>
              </el-form-item>
              <el-form-item label="提现金额：" prop="money">
                  <el-input style="width:350px" @blur="setMoney" v-model.number="form.money" placeholder="请输入提现金额"/>
              </el-form-item>
              <el-form-item label="实际到账：" prop="received_money">
                  <span>{{form.received_money}}（ 提现手续费：{{cashRule.service_charge}}%  ）</span>
              </el-form-item>
              <div class="dialog-footer">
                    <el-button type="primary" :disabled="limit_times==0" @click="submitFrom">确定</el-button>
              </div>
          </el-form>
      </div>
      <div v-show="activeName=='second'">
          <div class="tab-bar">
                <el-form :model="queryForm" ref="queryForm" :inline="true" size="small"  label-width="100px">
                    <el-form-item label="提现时间" prop="date">
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
                    <el-form-item > 
                        <el-button type="primary" icon="el-icon-search" @click="query">查询</el-button>
                        <el-button icon="el-icon-refresh" @click="resetQuery('queryForm')">重置</el-button>
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
            <el-table-column prop="cash_order" show-overflow-tooltip="" align="center" label="提现订单号"></el-table-column>
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
          </el-table>
          <pagination
            v-show="+total>10"
            :total="+total"
            :page.sync="queryForm.pageNum"
            :limit.sync="queryForm.pageSize"
            @pagination="getList"
        />
      </div>
  </div>
</template>

<script>
import { mapGetters } from 'vuex'
import {getCashRule,getCashLimitTimes,cash,cashList} from '@/api/finance'
export default {
    data(){
        return{
            activeName:'first',
            limit_times:0,
            form:{
                bank_info:'',
                card_num:'',
                user_name:'',
                money:0,
                received_money:0
            },
            queryForm:{
                date:[],
                pageNum:1,
                pageSize:10
            },
            tableData:[],
            total:0,
            rule:{
                bank_info:[
                    { required: true, message: "请选择开户银行", trigger: "blur" },
                ],
                card_num:[
                     { required: true, message: "请选择银行卡号", trigger: "blur" },
                ],
                user_name:[
                    { required: true, message: "请输入开卡人姓名", trigger: "blur" },
                ],
                money:[
                    { required: true, message: "最高提现金额不能为空", trigger: "blur" },
                    { type: 'number', message: '最高提现金额必须为数字值'}
                ]
            },
            bankOptions:[],
            cashRule:{}
        }
    },
    computed: {
        ...mapGetters([
            'user_info'
        ]),
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
    created(){
        this.getDicts({type:'bank_type'}).then(res=>{
            this.bankOptions=res.data
        })
        this.getCashRule()
        this.getCashLimitTimes()
        this.getList()
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
                this.cashRule=res.data
            })
        },
        getCashLimitTimes(){
            getCashLimitTimes({}).then(res=>{
                this.limit_times=res.data
            })
        },
        setMoney(){
            this.form.received_money=this.form.money-(this.form.money*this.cashRule.service_charge/100)
        },
        submitFrom(){
            this.$refs["form"].validate(valid => {
                if(valid){
                    if(this.form.money>=this.user_info.balance){
                        this.$message.warning('余额不足！')
                        return
                    }
                    cash(this.form).then(res=>{
                        if(res.code==200){
                            this.$message.success(res.msg)
                            this.getCashLimitTimes()
                            this.$store.dispatch('user/getInfo')
                        }else{
                            this.$message.error(res.msg)
                        }
                    })
                }
            })
        },
        handleClick(){
            if(this.activeName=='second'){
                this.getList()
            }
        },
        query(){
            this.queryForm.pageNum = 1;
            this.getList();
        },
        resetQuery(formName){
            this.$refs[formName].resetFields();
            this.query()
        }
    }
}
</script>

<style lang="scss" scoped>
.dialog-footer{
    width: 100%;
    display: flex;
    justify-content: flex-start;
    margin-left: 280px;
    margin-top: 50px;
}
</style>