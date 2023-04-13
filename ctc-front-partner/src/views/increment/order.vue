<template>
  <div class="app-container">
      <div class="tab-bar">
          <el-form ref="queryForm" :model="queryForm" label-width="100px" :inline="true" size="small">
            <el-form-item label="增值订单号" prop="order_num">
                <el-input style="width:220px" v-model="queryForm.order_num" placeholder="请输入增值订单号"></el-input>
            </el-form-item>
            <el-form-item label="品牌商名称" prop="dealer_name">
                <el-input style="width:220px" v-model="queryForm.dealer_name" placeholder="请输入品牌商名称"></el-input>
            </el-form-item>
            <el-form-item label="状态" prop="status">
                <el-select style="width:220px" v-model="queryForm.status" placeholder="请选择订单状态">
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
        <el-table-column prop="dealer_name" align="center" label="品牌商名称"></el-table-column>
        <el-table-column prop="account" align="center" label="品牌商账号"></el-table-column>
        <el-table-column label="详情" align="center" fixed="right" width="180px">
          <template slot-scope="scope">
            <span @click="handlInfo(scope.row)" class="link-type">点击查看</span>
          </template>
        </el-table-column>
        <el-table-column prop="cost" align="center" label="成本价"></el-table-column>
        <el-table-column prop="sale" align="center" label="销售价"></el-table-column>
        <el-table-column prop="sale" align="center" label="支付方式">
            <template slot-scope="scope">
                <span>{{scope.row.pay_type==0?'余额支付':'线下支付'}}</span>
            </template>
        </el-table-column>
        <el-table-column prop="status" align="center" label="状态">
            <template slot-scope="scope">
                <span>{{scope.row.status==0?'未审核':scope.row.status==1?'审核通过':'审核未通过'}}</span>
            </template>
        </el-table-column>
        <el-table-column label="操作" align="center" fixed="right" width="180px">
          <template slot-scope="scope">
              <el-button
              size="mini"
              type="primary"
              @click="handleEdit(scope.row)">修改</el-button>
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
                <span>定制开发需求：</span>
                <div v-if="is_customized==0">无</div>
                <div v-else v-html="order_demand"></div>
            </div>
        </el-card>
     </el-dialog>
  </div>
</template>

<script>
import{getServiceOrder,orderInfo} from '@/api/increment'
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
            orderDialog:false,
            orderFrom:{

            },
            is_customized:0,
            order_demand:'',
            statusOptions:[
                {
                    dict_value:'0',
                    dict_label:'未审核'
                },
                {
                    dict_value:'1',
                    dict_label:'审核通过'
                },
                {
                    dict_value:'2',
                    dict_label:'审核未通过'
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
                this.order_demand=res.demand
                this.is_customized=res.is_customized
            })
       },
       handleEdit(row){
           if(row.status!=0){
               this.$message.warning('订单已经审核，不允许修改')
               return;
           }
           this.$router.push({path:'/increment/editOrder',query:{id:row.id,dealer_id:row.dealer_id}})
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
</style>>