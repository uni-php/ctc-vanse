<template>
  <div class="app-container">
       <div class="tab-bar">
         <el-form ref="queryForm" :model="queryForm" label-width="100px" :inline="true" size="small">
            <el-form-item label="合伙人名称" prop="partner">
                <el-input style="width:240px" v-model="queryForm.partner" placeholder="请输入合伙人名称"></el-input>
            </el-form-item>
            <el-form-item label="合伙人级别" prop="level_id">
                <el-select style="width:100%" v-model="queryForm.level_id" placeholder="请选择合伙人级别">
                  <el-option
                    v-for="item in levelOptions"
                    :key="item.id"
                    :label="item.level_name"
                    :value="item.level">
                    <span style="float: left">{{ item.level+'-'+item.level_name }}</span>
                  </el-option>
                </el-select>
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
       <el-table-column prop="id" align="center" label="编号" width="80px"></el-table-column>
       <el-table-column prop="company" align="center" label="公司名称"></el-table-column>
       <el-table-column prop="account" align="center" label="合伙人账号"></el-table-column>
       <el-table-column prop="level_id" align="center" label="合伙人级别">
        <template slot-scope="scope">
          <span>{{level(scope.row.level_id)}}</span>
        </template>
       </el-table-column>
       <el-table-column prop="deposit" align="center" label="预存款"></el-table-column>
       <el-table-column prop="balance" align="center" label="账户余额"></el-table-column>
       <el-table-column label="操作" align="center" fixed="right" width="240px">
        <template slot-scope="scope">
          <el-button
            size="mini"
            type="primary"
            @click="handleCharge(scope.row)">充值</el-button>
            <el-button
            size="mini"
            type="primary"
            @click="handleChargeLog(scope.row)">充值记录</el-button>
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
     <!-- 充值表格 -->
      <el-dialog title="充值" :visible.sync="rechargeDialog" width="40%" @close="rechargeDialog=false">
        <el-form :model="rechargeFrom" ref="rechargeFrom" label-width="120px" :rules="rule" size="medium">
          <el-form-item label="状态">
            <el-radio-group v-model="rechargeFrom.type">
              <el-radio
                v-for="dict in typeOptions"
                :key="dict.dict_value"
                :label="dict.dict_value"
              >{{dict.dict_label}}</el-radio>
            </el-radio-group>
          </el-form-item>
          <el-form-item label="账户余额:" v-if="rechargeFrom.type=='1'" prop="balance">
              <el-input readonly=""  v-model="rechargeFrom.balance"/>
          </el-form-item>
          <el-form-item label="预存款余额:" v-if="rechargeFrom.type=='2'" prop="deposit">
              <el-input readonly=""  v-model="rechargeFrom.deposit"/>
          </el-form-item>
          <el-form-item label="充值金额:" prop="money">
              <el-input  placeholder="请输入充值金额" v-model.number="rechargeFrom.money"/>
          </el-form-item>
          <el-form-item label="备注:" prop="remark">
              <el-input  placeholder="请输入备注" v-model="rechargeFrom.remark"/>
          </el-form-item>
        </el-form>
        <div slot="footer" class="dialog-footer">
          <el-button type="primary" @click="submitForm">确 定</el-button>
          <el-button @click="cancel">取 消</el-button>
        </div>
      </el-dialog>
      <!-- 充值记录 -->
      <el-dialog title="充值记录" :visible.sync="rechargeLogDialog"  width="85%" @close="rechargeLogDialog=false">
        <el-form :model="queryChargeForm" ref="queryChargeForm" :inline="true" label-width="100px" size="medium">
          <el-form-item label="充值时间" prop="date">
              <el-date-picker
                style="width:240px"
                v-model="queryChargeForm.date"
                type="daterange"
                unlink-panels=""
                range-separator="至"
                format="yyyy-MM-dd"
                value-format="yyyy-MM-dd"
                start-placeholder="开始日期"
                end-placeholder="结束日期">
              </el-date-picker>
          </el-form-item>
          <!-- <el-form-item label="合伙人" prop="company">
            <el-input style="width:200px" v-model="queryChargeForm.company" placeholder="请输入合伙人名称"></el-input>
          </el-form-item> -->
          <el-form-item label="充值类型" prop="type">
            <el-select style="width:240px" v-model="queryChargeForm.type" placeholder="请选择充值类型">
                <el-option
                    v-for="item in typeOptions"
                    :key="item.dict_value"
                    :label="item.dict_label"
                    :value="item.dict_value">
                </el-option>
            </el-select>
          </el-form-item>
          <el-form-item > 
              <el-button type="primary" icon="el-icon-search" @click="queryLog">查询</el-button>
              <el-button icon="el-icon-refresh" @click="reset('queryChargeForm')">重置</el-button>
          </el-form-item>
        </el-form>
        <el-table
          :data="rechargeLogData"
          :header-cell-style="{background:'#FAFAFA',color:'#606266',height:'50px'}"
          border
          stripe
          size="small"
          class="trace-table"
          style="width: 100%">
          <el-table-column prop="code" align="center" label="合伙人编号"></el-table-column>
          <el-table-column prop="company" align="center" label="公司名称"></el-table-column>
          <el-table-column prop="account" align="center" label="合伙人账号"></el-table-column>
          <el-table-column prop="recharge_type" align="center" label="充值类型">
            <template slot-scope="scope">
              <span>{{recharge_type(scope.row.recharge_type)}}</span>
            </template>
          </el-table-column>
          <el-table-column prop="money" align="center" label="充值金额"></el-table-column>
          <el-table-column prop="balance" align="center" label="充值后余额"></el-table-column>
          <el-table-column prop="remark" align="center" label="备注"></el-table-column>
          <el-table-column prop="create_time" align="center" label="充值时间"></el-table-column>
          <el-table-column prop="create_by" align="center" label="操作人">
          </el-table-column>
        </el-table>
        <pagination
        v-show="+totals>0"
        :total="+totals"
        :page.sync="queryChargeForm.pageNum"
        :limit.sync="queryChargeForm.pageSize"
        @pagination="getRechargeLog"
     />
      </el-dialog>
  </div>
</template>

<script>
import {listAccount,recharge,rechargeLog} from "@/api/finance/index";
import {listLevel} from '@/api/partner/index';
export default {
  data(){
    return{
      queryForm:{
        partner:'',
        level_id:"",
        pageNum:1,
        pageSize:10
      },
       queryChargeForm:{
        partner_id:undefined,
        date:[],
        type:"",
        company:"",
        pageNum:1,
        pageSize:10
      },
      rule:{
        money:[
          { required: true, message: "充值金额不能为空", trigger: "blur" },
          { type: 'number', message: '金额必须为数字值'}
        ],
      },
      typeOptions:[],
      rechargeDialog:false,
      rechargeLogDialog:false,
      rechargeLogData:[],
      rechargeFrom:{
        balance:"",
        money:'',
        remark:"",
        type:'1'
      },
      levelOptions:[],
      tableData:[],
      total:0,
      totals:0
    }
  },
  created(){
      this.getList()
      this.getLevelOptions();
      this.getDicts({type:'recharge_type'}).then(res=>{
        this.typeOptions=res.data
      })
  },
  computed:{
    recharge_type(){
      return function(value){
        if(!value) return '--'
          var item=this.typeOptions.filter(item=>{
          return item.dict_value==value
        })
        return item[0].dict_label
      }
    },
    level(){
      return function(value){
        if(!value) return '--'
          var item=this.levelOptions.filter(item=>{
          return item.id==value
        })
        return value+'-'+item[0].level_name
      }
    }
  },
  methods:{
     getLevelOptions(){
        listLevel({level_name:"",pageNum:1,pageSize:999}).then(res=>{
          this.levelOptions=res.data
        })
      },
      getList(){
        listAccount(this.queryForm).then(res=>{
          this.tableData=res.data
          this.total=res.total
        })
      },
      handleChargeLog(row){
        this.rechargeLogData=[],
        this.totals=0
        this.queryChargeForm.partner_id=row.id
        this.queryChargeForm.pageNum=1
        this.rechargeLogDialog=true
        this.getRechargeLog()
      },
      getRechargeLog(){
        var arr=Object.assign({},this.queryChargeForm)
        if(arr.date.length>0){
          arr.beginTime=arr.date[0]
          arr.endTime=arr.date[1]
        }else{
          arr.beginTime=''
          arr.endTime=''
        }
        delete arr.date
        rechargeLog(arr).then(res=>{
          this.rechargeLogData=res.data
          this.totals=res.total
        })
      },
      handleCharge(row){
        this.rechargeDialog=true
        this.resetForm("rechargeFrom");
        this.rechargeFrom.type='1'
        this.rechargeFrom.balance=row.balance
        this.rechargeFrom.deposit=row.deposit
        this.rechargeFrom.id=row.id
      },
      submitForm(){
        this.$refs["rechargeFrom"].validate(valid => {
          if(valid){
            recharge(this.rechargeFrom).then(res=>{
              if(res.code==200){
                this.rechargeDialog=false
                this.$message.success(res.msg)
                this.getList()
              }else{
                this.$message.error(res.msg)
              }
            })
          }
        })
      },
      cancel(){
        this.rechargeDialog = false;
        this.resetForm("rechargeFrom");
      },
      query(){
        this.queryForm.pageNum = 1;
        this.getList();
      },
      resetQuery(formName){
        this.$refs[formName].resetFields();
        this.query()
      },
      reset(formName){
          this.$refs[formName].resetFields();
          this.queryLog()
      },
      queryLog(){
        this.queryChargeForm.pageNum=1
        this.getRechargeLog()
      }
  }
}
</script>  

<style>

</style>