<template>
  <div class="app-container">
    <div class="tab-bar">
      <el-form ref="queryForm" :model="queryForm" label-width="100px" :inline="true" size="small">
        <el-form-item label="增值订单" prop="order_num">
            <el-input style="width:240px" v-model="queryForm.order_num" placeholder="请输入增值订单"></el-input>
        </el-form-item>
        <el-form-item label="品牌商名称" prop="dealer_name">
            <el-input style="width:240px" v-model="queryForm.dealer_name" placeholder="请输入品牌商名称"></el-input>
        </el-form-item>
        <el-form-item label="状态" prop="status">
          <el-select style="width:240px" v-model="queryForm.status" placeholder="请选择订单状态">
            <el-option
              v-for="dict in statusOptions"
              :key="dict.dict_value"
              :label="dict.dict_label"
              :value="dict.dict_value">
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
        <el-table-column prop="order_num" align="center" show-overflow-tooltip="" label="增值订单"></el-table-column>
        <el-table-column prop="partner_company" show-overflow-tooltip="" align="center" label="合伙人" ></el-table-column>
        <el-table-column prop="dealer_name" align="center" label="品牌商" ></el-table-column>
        <el-table-column prop="company" align="center" show-overflow-tooltip="" label="公司名称" ></el-table-column>
        <el-table-column label="详细内容" align="center" fixed="right">
          <template slot-scope="scope">
            <span @click="handlInfo(scope.row)" class="link-type">点击查看</span>
          </template>
        </el-table-column>
        <el-table-column prop="sum" align="center" label="服务总价" width="180px">
          <template slot-scope="scope">
            <p>成本价：￥{{scope.row.cost}}</p>
            <p>销售价：￥{{scope.row.sale}}</p>
          </template>
        </el-table-column>
        <el-table-column prop="sale" align="center" label="支付方式">
            <template slot-scope="scope">
                <span>{{scope.row.pay_type==0?'余额支付':'线下支付'}}</span>
            </template>
        </el-table-column>
        <el-table-column label="状态" align="center" fixed="right" >
          <template slot-scope="scope">
            <span>{{scope.row.status==0?'未审核':"已审核"}}</span>
          </template>
        </el-table-column>
        <el-table-column label="操作" align="center" fixed="right" width="180px">
          <template slot-scope="scope">
            <el-button
              size="mini"
              v-show="scope.row.status==0"
              type="primary"
              @click="handleCheck(scope.row)">审核</el-button>
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
        :page.sync="queryForm.pageNum"
        :limit.sync="queryForm.pageSize"
        @pagination="getList"
     />
     <!-- 订单详情 -->
     <el-dialog title="增值详情" :visible.sync="orderDialog" width="40%" @close="orderDialog=false">
        <el-card class="box-card">
            <div v-for="(item,index) in orderFrom" :key="index" class="text item">
                <div class="order-item">{{item.name}}：{{item.is_select==1?'已选':'未选'}}
                    <span style="color:red">{{item.id==3&&item.is_select==1?item.times+'次':''}}</span>
                </div>
            </div>
            <div class="demand">
                <span>定制开发需求：{{is_customized==0?'无':order_demand}}</span>
            </div>
        </el-card>
        <div style="margin:30px" v-if="isCheck">
          <el-radio-group v-model="status">
            <el-radio :label="1">审核通过</el-radio>
            <el-radio :label="2">审核不通过</el-radio>
          </el-radio-group>
        </div>
        <div slot="footer" class="dialog-footer" v-if="isCheck">
          <el-button @click="check" type="primary">确 定</el-button>
        </div>
     </el-dialog>
  </div>
</template>

<script>
import {getServiceOrder,deleOrder,checkOrder,orderInfo} from "@/api/increment/index";
export default {
  data(){
    return{
      queryForm:{
        order_num:'',
        dealer_name:'',
        status:'',
        pageNum:1,
        pageSize:10
      },
      tableData:[],
      total:0,
      status:0,
      isCheck:false,
      orderDialog:false,
      is_customized:1,
      orderFrom:[],
      order_demand:'',
      orderInfo:{},
      statusOptions:[
        {
          dict_value:'0',
          dict_label:'未审核'
        },
        {
          dict_value:'1',
          dict_label:'已审核'
        }
      ]
    }
  },
  created(){
    this.getList()
  },
  methods:{
    getList(){
      getServiceOrder(this.queryForm).then(res=>{
        this.tableData=res.data
        this.total=res.total
      })
    },
    handlInfo(row){
      orderInfo({id:row.id}).then(res=>{
        this.orderFrom=res.data
        this.orderDialog=true
        this.isCheck=false
        this.order_demand=res.demand
        this.is_customized=res.is_customized
      })
    },
    handleCheck(row){
      this.status=0//恢复初始状态
      orderInfo({id:row.id}).then(res=>{
        this.orderFrom=res.data
        this.orderDialog=true
        this.isCheck=true
        this.orderInfo=row
      })
    },
    check(){
      if(this.status==0){
        this.$message.warning('请选择审核状态')
        return;
      }
      this.orderInfo.checkStatus=this.status
      checkOrder(this.orderInfo).then(res=>{
        if(res.code==200){
          this.getList();
          this.$message.success(res.msg)
          this.orderDialog=false
          this.isCheck=false
        }else{
          this.$message.error(res.msg)
        }
      })
    },
    handleDele(row){
      this.$confirm('是否确认删除该订单', "警告", {
          confirmButtonText: "确定",
          cancelButtonText: "取消",
          type: "warning"
        }).then(function() {
          return deleOrder({id:row.id});
        }).then(() => {
          this.getList();
          this.$message.success(res.msg)
        }).catch(() => {});
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
.order-item{
    margin: 14px 0;
    font-size: 15px;
}
</style>