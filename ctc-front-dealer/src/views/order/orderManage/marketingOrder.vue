<template>
<div class="app-container">
    <div class="tab-bar">
        <el-form ref="queryForm" :model="queryForm" label-width="100px" :inline="true" size="small">
          <el-form-item label="订单号" prop="order">
              <el-input style="width:220px" v-model="queryForm.order" placeholder="请输入订单号"></el-input>
          </el-form-item>
          <el-form-item label="领奖方式" prop="get_prize_mode">
            <el-select style="width:220px" size="small" v-model="queryForm.get_prize_mode" placeholder="请选择领奖方式">
                  <el-option
                      v-for="item in get_prize_mode_option"
                      :key="item.value"
                      :label="item.label"
                      :value="item.value">
                  </el-option>
              </el-select>
          </el-form-item>
          <el-form-item label="下单时间" prop="create_time">
                <el-date-picker
                    style="width:260px"
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
        stripe
        size="medium"
        class="trace-table"
        style="width: 100%">
        <el-table-column prop="order" width="200" align="center" label="订单编号"></el-table-column>
        <el-table-column prop="code" width="200" align="center" label="二维码编号"></el-table-column>
        <el-table-column prop="nickname" width="200" align="center" label="收货人"></el-table-column>
        <el-table-column prop="gift_name" width="200" align="center" label="订单商品" :formatter="goods"></el-table-column>
        <el-table-column prop="get_prize_mode" width="200" align="center" label="领奖方式">
          <template slot-scope="scope">
            {{scope.row.get_prize_mode==0?'物流配送':'门店核销'}}
          </template>
        </el-table-column>
        <el-table-column prop="address" width="200" align="center" label="收货地址" :formatter="address"></el-table-column>
        <!-- <el-table-column prop="status" width="200" align="center" label="订单状态" :formatter="status"></el-table-column> -->
        <el-table-column prop="create_time" width="200" align="center" label="下单时间"></el-table-column>
        <el-table-column label="操作" align="center" fixed="right" width="260px">
         <template slot-scope="scope">
              <el-button
                  size="mini"
                  type="text"
                  v-if="(scope.row.status==1||scope.row.status==2)&&scope.row.get_prize_mode==0"
                  @click="handleDes(scope.row)">物流详情</el-button>
              <el-button
                    size="mini"
                    type="text"
                    v-if="scope.row.status==0&&scope.row.get_prize_mode==0"
                    @click="handleSend(scope.row)">标记发货</el-button>
                <el-button
                  size="mini"
                  type="text"
                  v-if="scope.row.get_prize_mode==1"
                  @click="handlCheckDes(scope.row)"><span style="color:red">{{scope.row.is_get==1?'已核销':'未核销'}}</span></el-button>
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
    <el-dialog title="标记发货" :visible.sync="sendOpen" width="30%" @close="sendOpen=false">
      <el-form :model="sendForm" ref="sendForm" label-width="100px" :rules="sendRule" size="medium">
        <el-form-item label="收货地址：" prop="address">
          <span>{{cus_address.address+cus_address.location}}</span>
        </el-form-item>
        <el-form-item label="收货人：" prop="consignee">
          <span>{{cus_address.consignee+' '+cus_address.phone}}</span>
        </el-form-item>
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
    <el-dialog title="核销信息" :visible.sync="storeDialog" width="30%" @close="storeDialog=false">
      <el-form :model="storeInfo" ref="storeInfo" label-width="100px" size="medium">
        <el-form-item label="门店名称：" prop="store_name">
          <span>{{storeInfo.store_name}}</span>
        </el-form-item>
        <el-form-item label="门店负责人：" prop="person">
          <span>{{storeInfo.person}}</span>
        </el-form-item>
        <el-form-item label="门店电话：" prop="telephone">
          <span>{{storeInfo.telephone}}</span>
        </el-form-item>
        <el-form-item label="核销时间：" prop="check_time">
          <span>{{storeInfo.check_time}}</span>
        </el-form-item>
      </el-form>
    </el-dialog>
</div>
</template>

<script>
import {getMarketingOrderList,markShipment} from '@/api/order/orderManage/qrcode'
import {getAddressInfo} from '@/api/order/orderManage/address'
import {getStoreInfo} from '@/api/customer/store'
export default {
  data(){
    return{
      logisticsOptions:[],
      cus_address:{
        address:'',
        location:'',
        consignee:'',
        phone:''
      },
      sendRule:{
        delivery_name:[
            {required: true, message: "请选择发货公司", trigger: "blur" },
        ],
        delivery_id:[
            {required: true, message: "请填写快递单号", trigger: "blur" },
        ],
      },
      storeInfo:{},
      storeDialog:false,
      sendOpen:false,
      tableData:[],
      total:0,
      queryForm:{
        get_prize_mode:'',
        order:'',
        pageNum:1,
        pageSize:10
      },
      sendForm:{
        order_id:'',
        delivery_name:'',
        delivery_id:'',
        delivery_mark:''
      },
      activeName: '-2',
      get_prize_mode_option:[
        {
          value:0,
          label:'物流配送'
        },
        {
          value:1,
          label:'门店核销'
        }
      ],
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
          label: '已过期',
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
        getMarketingOrderList(params).then(res=>{
            this.tableData=res.data
            this.total=res.total
        })
    },
    handleClick(){
      this.tableData=[]
      this.getList()
    },
    //查询核销门店
    handlCheckDes(row){
      getStoreInfo({id:row.store_id}).then(res=>{
        this.storeInfo=res.data
        this.storeInfo.check_time=row.check_time
        this.storeDialog=true
      })
    },
    status(){

    },
    handleDes(row){
      this.sendForm=row
      getAddressInfo({user_address_id:row.user_address_id}).then(res=>{
        this.cus_address=res.data
      })
      this.sendOpen=true
    },
    handleSend(row){
      if(!row.user_address_id) return this.$message.warning('客户未填写地址')
      this.sendForm={
        order:row.order,
        delivery_name:'',
        delivery_id:'',
        delivery_mark:''
      }
      getAddressInfo({user_address_id:row.user_address_id}).then(res=>{
        this.cus_address=res.data
      })
      this.sendOpen=true
    },
    goods(val){
      return JSON.parse(val.gift)[0].gift_name+`(礼品id:${JSON.parse(val.gift)[0].gift_id})`
    },
    submitSendForm(){
      this.$refs["sendForm"].validate(valid => {
        if(valid){
          markShipment(this.sendForm).then(res=>{
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
    address(val){
      if(!val.user_address_id) return '未填写'
      return '已登记'
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
