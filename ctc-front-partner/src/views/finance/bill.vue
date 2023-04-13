<template>
  <div class="app-container">
      <el-tabs v-model="activeName" type="card" @tab-click="handleClick">
        <el-tab-pane label="我的收支" name="first"></el-tab-pane>
        <el-tab-pane label="我的品牌商" name="second"></el-tab-pane>
      </el-tabs>
      <div v-show="activeName=='first'">
          <div class="tab-bar">
              <el-form :model="queryForm" ref="queryForm" :inline="true" size="small"  label-width="80px">
                  <el-form-item label="日期" prop="date">
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
                <el-form-item label="交易类型" prop="transaction_type">
                    <el-select style="width:240px" v-model="queryForm.transaction_type" placeholder="请选择交易类型">
                        <el-option
                            v-for="item in transactionTypeOptions"
                            :key="item.dict_value"
                            :label="item.dict_label"
                            :value="item.dict_value">
                        </el-option>
                    </el-select>
                </el-form-item>
                <el-form-item label="账户类型" prop="type">
                    <el-select style="width:240px" v-model="queryForm.type" placeholder="请选择账户类目">
                        <el-option
                            v-for="item in typeOptions"
                            :key="item.dict_value"
                            :label="item.dict_label"
                            :value="item.dict_value">
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
            <el-table-column show-overflow-tooltip="" prop="serial_number" align="center" label="流水号"></el-table-column>
            <el-table-column prop="create_time" show-overflow-tooltip="" align="center" label="日期"></el-table-column>
            <el-table-column prop="transaction_type" align="center" label="交易类型">
                <template slot-scope="scope">
                    <span>{{transaction_type(scope.row.transaction_type)}}</span>
                </template>
            </el-table-column>
            <el-table-column prop="transaction_type" align="center" label="账户类型">
                <template slot-scope="scope">
                    <span>{{account_type(scope.row.account_type)}}</span>
                </template>
            </el-table-column>
            <el-table-column prop="payments_type" align="center" label="收入">
                <template slot-scope="scope">
                    <span>{{scope.row.payments_type==0?('￥'+scope.row.bill):'--'}}</span>
                </template>
            </el-table-column>
            <el-table-column prop="payments_type" align="center" label="支出">
                <template slot-scope="scope">
                    <span>{{scope.row.payments_type==1?('￥'+scope.row.bill):'--'}}</span>
                </template>
            </el-table-column>
            <el-table-column prop="balance" align="center" label="余额"></el-table-column>
            <el-table-column prop="remark" show-overflow-tooltip="" align="center" label="备注"></el-table-column>
          </el-table>
          <pagination
            v-show="+total>10"
            :total="+total"
            :page.sync="queryForm.pageNum"
            :limit.sync="queryForm.pageSize"
            @pagination="getList"
        />
      </div>
      <div v-show="activeName=='second'">
           <div class="tab-bar">
               <el-form :model="queryDealerForm" ref="queryDealerForm" :inline="true" size="small"  label-width="100px">
                   <el-form-item label="日期" prop="date">
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
                <el-form-item label="品牌商名称" prop="dealer_name">
                    <el-input style="width:240px" v-model="queryDealerForm.dealer_name" placeholder="请输入品牌商名称"></el-input>
                </el-form-item>
                <el-form-item label="账户类型" prop="type">
                    <el-select style="width:240px" v-model="queryDealerForm.type" placeholder="请选择账户类目">
                        <el-option
                            v-for="item in typeOptions"
                            :key="item.dict_value"
                            :label="item.dict_label"
                            :value="item.dict_value">
                        </el-option>
                    </el-select>
                </el-form-item>
                <el-form-item > 
                    <el-button type="primary" icon="el-icon-search" @click="queryDealer">查询</el-button>
                    <el-button icon="el-icon-refresh" @click="resetQueryDealer('queryDealerForm')">重置</el-button>
                </el-form-item>
               </el-form>
           </div>
           <el-table
            :data="tableDealerData"
            :header-cell-style="{background:'#FAFAFA',color:'#606266',height:'50px'}"
            border
            stripe
            size="medium"
            class="trace-table"
            style="width: 100%">
                <el-table-column show-overflow-tooltip="" prop="serial_number" align="center" label="流水号"></el-table-column>
                <el-table-column prop="dealer_id" show-overflow-tooltip="" align="center" label="品牌商编号"></el-table-column>
                <el-table-column prop="dealer_name" show-overflow-tooltip="" align="center" label="品牌商名称"></el-table-column>
                <el-table-column prop="account" show-overflow-tooltip="" align="center" label="品牌商账号"></el-table-column>
                <el-table-column prop="create_time" show-overflow-tooltip="" align="center" label="日期"></el-table-column>
                <el-table-column prop="transaction_type" align="center" label="交易类型">
                    <template slot-scope="scope">
                        <span>{{transaction_type(scope.row.transaction_type)}}</span>
                    </template>
                </el-table-column>
                <el-table-column prop="payments_type" align="center" label="支出">
                    <template slot-scope="scope">
                        <span>{{scope.row.payments_type==1?('￥'+scope.row.bill):'--'}}</span>
                    </template>
                </el-table-column>
                <el-table-column prop="remark" show-overflow-tooltip="" align="center" label="备注"></el-table-column>
           </el-table>
           <pagination
            v-show="+totals>10"
            :total="+totals"
            :page.sync="queryDealerForm.pageNum"
            :limit.sync="queryDealerForm.pageSize"
            @pagination="getDealerList"
        />
      </div>
  </div>
</template>

<script>
import {listFinanceBill,listFinanceDealerBill} from "@/api/finance/index";
export default {
    data(){
        return{
            activeName:"first",
            queryForm:{
                date:[],
                transaction_type:'',
                type:'',
                pageNum:1,
                pageSize:10
            },
            queryDealerForm:{
                pageNum:1,
                pageSize:10,
                date:[],
                dealer_name:'',
                type:'',
            },
            typeOptions:[],
            transactionTypeOptions:[],
            tableData:[],
            tableDealerData:[],
            totals:0,
            total:0
        }
    },
    computed:{
        transaction_type(){
            return function(value){
                if(!value) return '--'
                var item=this.transactionTypeOptions.filter(item=>{
                return item.dict_value==value
            })
                return item[0].dict_label
            }
        },
        account_type(){
            return function(value){
                if(!value) return '--'
                var item=this.typeOptions.filter(item=>{
                return item.dict_value==value
            })
                return item[0].dict_label
            }
        }
    },
    created(){
        this.getList()
        this.getDealerList()
        this.getDicts({type:'recharge_type'}).then(res=>{
            this.typeOptions=res.data
        })
        this.getDicts({type:'transaction_type'}).then(res=>{
            this.transactionTypeOptions=res.data
        })
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
            listFinanceBill(arr).then(res=>{
                this.total=res.total
                this.tableData=res.data
            })
        },
        getDealerList(){
            var arr=Object.assign({},this.queryDealerForm)
            if(arr.date&&arr.date.length>0){
                arr.beginTime=arr.date[0]
                arr.endTime=arr.date[1]
            }else{
                arr.beginTime=''
                arr.endTime=''
            }
            delete arr.date
            listFinanceDealerBill(arr).then(res=>{
                this.totals=res.total
                this.tableDealerData=res.data
            })
        },
        handleClick(){

        },
        query(){
            this.queryForm.pageNum = 1;
            this.getList();
        },
        queryDealer(){
            this.queryDealerForm.pageNum = 1;
            this.getDealerList();
        },
        resetQueryDealer(formName){
            this.$refs[formName].resetFields();
            this.query()
        },
        resetQuery(formName){
            this.$refs[formName].resetFields();
            this.query()
        }
    }
}
</script>

<style>

</style>