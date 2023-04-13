<template>
  <div class="app-container">
    <div class="tab-bar">
        <el-form ref="queryForm" :model="queryForm" label-width="100px" :inline="true" size="small">
          <el-form-item label="订单号" prop="order">
              <el-input style="width:240px" v-model="queryForm.order" placeholder="请输入订单号"></el-input>
          </el-form-item>
          <el-form-item label="会员昵称" prop="nickname">
              <el-input style="width:240px" v-model="queryForm.nickname" placeholder="请输入会员昵称"></el-input>
          </el-form-item>
          <el-form-item label="下单时间" prop="create_time">
                <el-date-picker
                    style="width:240px"
                    v-model="queryForm.create_time"
                    type="daterange"
                    unlink-panels=""
                    range-separator="至"
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
    <el-tabs v-model="activeName" @tab-click="handleClick">
      <el-tab-pane v-for="(item,index) in nav_list" :key="index" :label="item.label" :name="item.name">
      </el-tab-pane>
    </el-tabs>
    <el-table
        :data="tableData"
        :header-cell-style="{background:'#FAFAFA',color:'#606266',height:'50px'}"
        border
        row-key="id"
        :tree-props="{children: 'children', hasChildren: 'hasChildren'}"
        stripe
        default-expand-all=""
        size="medium"
        class="trace-table"
        style="width: 100%">
        <el-table-column prop="order_id" width="200" align="center" label="订单编号"></el-table-column>
        <el-table-column prop="nickname" align="center" label="买家"></el-table-column>
        <el-table-column prop="total_price" align="center" label="订单金额"></el-table-column>
        <el-table-column prop="store_name" align="center" label="门店名称"></el-table-column>
        <el-table-column prop="product_name" align="center" label="商品名称"></el-table-column>
        <el-table-column prop="cover" align="center" label="商品图片">
          <template slot-scope="scope" v-if="scope.row.cover">
                <el-avatar :size="35" :src="scope.row.cover" @error="errorHandler">
                    <img src="https://cube.elemecdn.com/e/fd/0fc7d20532fdaf769a25683617711png.png"/>
                </el-avatar>
            </template>
        </el-table-column>
        <el-table-column prop="sale_price" align="center" label="商品价格"></el-table-column>
        <el-table-column prop="goods_num" align="center" label="购买数量"></el-table-column>
        <el-table-column prop="status" align="center" label="订单状态" :formatter="status"></el-table-column>
        <el-table-column prop="create_time" align="center" label="下单时间" show-overflow-tooltip="">
        </el-table-column>
        <el-table-column label="操作" align="center" fixed="right" width="260px">
         <template slot-scope="scope" v-if="scope.row.children">
              <el-button
                  size="mini"
                  type="text"
                  v-if="scope.row.status==1||scope.row.status==2"
                  @click="handleDes(scope.row)">物流详情</el-button>
              <el-button
                    size="mini"
                    type="text"
                    v-if="scope.row.status==0"
                    @click="handleSend(scope.row)">标记发货</el-button>
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
    <!-- 标记发货 -->
    <el-dialog title="标记发货" :visible.sync="sendOpen" width="30%" @close="sendOpen=false">
      <el-form :model="sendForm" ref="sendForm" label-width="100px" :rules="sendRule" size="medium">
          <el-form-item label="物流公司：" prop="delivery_name">
              <el-select style="width:90%" size="small"  v-model="sendForm.delivery_name" placeholder="请选择物流公司">
                  <el-option
                      v-for="item in logisticsOptions"
                      :key="item.dict_value"
                      :label="item.dict_label"
                      :value="item.dict_value">
                  </el-option>
              </el-select>
          </el-form-item>
          <el-form-item label="运单号：" prop="delivery_id">
            <el-input style="width:90%" v-model="sendForm.delivery_id" placeholder="请输入运单号"></el-input>
          </el-form-item>
          <el-form-item label="备注：" prop="delivery_mark">
              <el-input style="width:90%"  type="textarea" :autosize="{ minRows: 3, maxRows: 5}" v-model="sendForm.delivery_mark" placeholder="请输入备注"></el-input>
          </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
          <el-button size="medium" type="primary" @click="submitSendForm" v-if="!sendForm.id">确 定</el-button>
          <el-button size="medium" type="primary" @click="sendOpen=false">取 消</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
import {getStoreOrderList,markStoreShipment} from '@/api/app/store/order'
export default {
  data(){
    return{
       sendRule:{
        delivery_name:[
            {required: true, message: "请选择发货公司", trigger: "blur" },
        ],
        delivery_id:[
            {required: true, message: "请填写快递单号", trigger: "blur" },
        ],
      },
      logisticsOptions:[],
      sendOpen:false,
      sendForm:{
        order_id:'',
        delivery_name:'',
        delivery_id:'',
        delivery_mark:''
      },
      activeName: '-2',
      queryForm:{
        order:'',
        nickname:'',
        create_time:[],
        pageNum:1,
        pageSize:10
      },
      tableData:[],
      total:0,
      nav_list: [
        {
          label: '全部订单',
          name: '-2'
        },
        {
          label: '待发货',
          name: '0'
        },
        {
          label: '待收货',
          name: '1'
        },
        {
          label: '已完成',
          name: '2'
        },
        {
          label: '已取消',
          name: '-3'
        }
      ]
    }
  },
  created(){
    this.getList()
    this.getDicts({type:'logistics_company'}).then(res=>{
        this.logisticsOptions=res.data
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
        params.status=this.activeName
        getStoreOrderList(params).then(res=>{
            this.tableData=res.data
            this.total=res.total
        })
    },
    status(val){
        if(val.status==0) return '待发货'
				if(val.status==1) return '待收货'
				if(val.status==2) return '已完成'
				if(val.status==-1&&val.is_del==0) return '待付款'
        if(val.status==-1&&val.is_del==1) return '已取消'
    },
    handleClick(){
      this.tableData=[]
      this.getList()
    },
    handleDes(row){
      this.sendForm=row
      this.sendOpen=true
    },
    handleSend(row) {
      this.sendForm={
        order_id:row.order_id,
        delivery_name:'',
        delivery_id:'',
        delivery_mark:''
      }
      this.sendOpen=true
    },
    errorHandler() {
      return true
    },
    submitSendForm(){
       this.$refs["sendForm"].validate(valid => {
        if(valid){
          markStoreShipment(this.sendForm).then(res=>{
            if(res.code==200){
              this.$message.success(res.msg)
              this.sendOpen=false
              this.getList()
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
  }
}
</script>

<style>

</style>
