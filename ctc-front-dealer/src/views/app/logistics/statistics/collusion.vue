<template>
  <div class="app-container">
    <div class="tab-bar">
        <el-form ref="queryForm" :model="queryForm" label-width="100px" :inline="true" size="small">
            <el-form-item label="经销商" prop="customer_name">
                <el-input style="width:220px" v-model="queryForm.customer_name" placeholder="请输入经销商"></el-input>
                <el-button style="margin-left:4px" size="small" type="primary" @click="chooseCustomer">选择</el-button>
            </el-form-item>
            <el-form-item label="经销商级别" prop="distributor_level">
            <el-select style="width:220px" size="small" v-model="queryForm.distributor_level" placeholder="请选择经销商级别">
                <el-option
                    v-for="item in levelOption"
                    :key="item.id"
                    :label="item.level_name"
                    :value="item.level_order">
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
        <el-table-column prop="bch_distributor_code" align="center" label="被窜货经销商编号"></el-table-column>
        <el-table-column prop="bch_distributor_name" align="center" label="被窜货经销商名称"></el-table-column>
        <el-table-column prop="distributor_level" align="center" label="被窜货经销商级别" :formatter="level"></el-table-column>
        <el-table-column prop="sum" align="center" label="窜货总数量"></el-table-column>
        <el-table-column label="操作" align="center" fixed="right" width="180px">
            <template slot-scope="scope">
                <el-button
                    size="mini"
                    type="primary"
                    @click="handleDes(scope.row)">明细</el-button>
            </template>
        </el-table-column>
    </el-table>
    <pagination
        v-show="+total>10"
        :total="+total"
        :page.sync="queryForm.pageNum"
        :limit.sync="queryForm.pageSize"
        @pagination="getList"/>
    <el-dialog title="选择经销商" :visible.sync="customerDialog" width="80%" @close="customerDialog=false">
        <CustomerPanel @selectCustomer="selectCustomer" />
    </el-dialog>
    <el-dialog title="窜货经销商统计明细" :visible.sync="chDialog" width="80%" @close="chDialog=false">
        <el-form ref="queryBillForm" :model="queryBillForm" label-width="100px" :inline="true" size="small">
            <el-form-item label="记录时间" prop="time">
                <el-date-picker
                    style="width:220px"
                    v-model="queryBillForm.time"
                    type="daterange"
                    unlink-panels=""
                    range-separator="至"
                    value-format="yyyy-MM-dd"
                    start-placeholder="开始日期"
                    end-placeholder="结束日期">
                </el-date-picker>
            </el-form-item>
            <!-- <el-form-item label="被窜货经销商" prop="bch_distributor_name">
                <el-input style="width:220px" v-model="queryBillForm.bch_distributor_name" placeholder="请输入被窜货经销商"></el-input>
                <el-button style="margin-left:4px" size="small" type="primary" @click="chooseBchCustomer">选择</el-button>
            </el-form-item> -->
            <el-form-item label="来源" prop="from">
                <el-select style="width:220px" size="small" v-model="queryBillForm.from" placeholder="请选择窜货来源">
                    <el-option
                        v-for="item in fromOption"
                        :key="item.value"
                        :label="item.label"
                        :value="item.value">
                    </el-option>
                </el-select>
            </el-form-item>
            <el-form-item label="备注" prop="remark">
                <el-input style="width:220px" v-model="queryBillForm.remark" placeholder="请输入备注"></el-input>
            </el-form-item>
            <el-form-item > 
                <el-button type="primary" icon="el-icon-search" @click="queryBill">查询</el-button>
                <el-button icon="el-icon-refresh" @click="resetQueryBill('queryBillForm')">重置</el-button>
            </el-form-item>
        </el-form>
        <el-table
        :data="tableDataBill"
        :header-cell-style="{background:'#FAFAFA',color:'#606266',height:'50px'}"
        border
        stripe
        size="medium"
        class="trace-table"
        style="width: 100%">
            <el-table-column prop="code_type" align="center" label="标签类型">
                <template slot-scope="scope">
                        {{scope.row.code_type=='1'?'大标':'小标'}}
                    </template>
            </el-table-column>
            <el-table-column prop="code" align="center" label="物流码"></el-table-column>
            <el-table-column prop="ch_num" align="center" label="窜货数量"></el-table-column>
            <!-- <el-table-column prop="distributor_code" align="center" label="窜货经销商编号"></el-table-column> -->
            <!-- <el-table-column prop="distributor_name" align="center" label="窜货经销商名称"></el-table-column> -->
            <el-table-column prop="cu_address" align="center" label="窜货地点" :formatter="cu_address"></el-table-column>
            <el-table-column prop="bch_distributor_code" align="center" label="被窜货经销商编号"></el-table-column>
            <el-table-column prop="bch_distributor_name" align="center" label="被窜货经销商名称"></el-table-column>
            <!-- 窜货经销商销售区域 -->
            <el-table-column prop="sale_area" align="center" label="销售区域" :formatter="sale_area"></el-table-column>
            <el-table-column prop="create_time" align="center" label="记录时间"></el-table-column>
            <el-table-column prop="from_type" align="center" label="来源" :formatter="from_type"></el-table-column>
            <el-table-column prop="remark" align="center" label="备注"></el-table-column>
            <el-table-column label="操作" align="center" fixed="right" width="180px">
                <template slot-scope="scope"> 
                    <el-button
                        size="mini"
                        type="primary"
                        @click="handleBillDes(scope.row)">详情</el-button>
                </template>
            </el-table-column>
        </el-table>
        <pagination
        v-show="+billTotal>10"
        :total="+billTotal"
        :page.sync="queryBillForm.pageNum"
        :limit.sync="queryBillForm.pageSize"
        @pagination="getChOrderBill"/>
        <!-- 详情 -->
         <el-dialog
            width="50%"
            title="详情"
            :visible.sync="chDesDialog"
            append-to-body>
            <el-row :gutter="20">
                <el-col :span="12">
                    <el-descriptions class="margin-top" title="基础信息" :column="1">
                        <el-descriptions-item label="标签类型">{{chDes.baseInfo.code_type==1?'大标':'小标'}}</el-descriptions-item>
                        <el-descriptions-item label="物流码">{{chDes.baseInfo.code}}</el-descriptions-item>
                        <el-descriptions-item label="生产批次号">{{chDes.baseInfo.product_batch}}</el-descriptions-item>
                        <el-descriptions-item label="发货单号">{{chDes.baseInfo.ck_order}}</el-descriptions-item>
                        <el-descriptions-item label="发货时间">{{chDes.baseInfo.create_time}}</el-descriptions-item>
                        <el-descriptions-item label="退货单号">{{chDes.chInfo.th_order}}</el-descriptions-item>
                        <el-descriptions-item label="产品编号">{{chDes.baseInfo.product_code}}</el-descriptions-item>
                        <el-descriptions-item label="产品名称">{{chDes.baseInfo.product_name}}</el-descriptions-item>
                        <el-descriptions-item label="产品条码">{{chDes.baseInfo.barcode}}</el-descriptions-item>
                        <el-descriptions-item label="单位">{{chDes.baseInfo.unit}}</el-descriptions-item>
                        <el-descriptions-item label="生产日期">{{chDes.baseInfo.manufacture_time}}</el-descriptions-item>
                        <el-descriptions-item label="有效期至">{{chDes.baseInfo.validity_time}}</el-descriptions-item>
                        <el-descriptions-item label="来源">{{from_type(chDes.chInfo)}}</el-descriptions-item>
                        <el-descriptions-item label="记录时间">{{chDes.baseInfo.create_time}}</el-descriptions-item>
                    </el-descriptions>
                </el-col>
                <el-col :span="12">
                    <el-descriptions class="margin-top" title="窜货信息" :column="1" >
                        <el-descriptions-item label="窜货数量">{{chDes.chInfo.ch_num}}</el-descriptions-item>
                        <!-- <el-descriptions-item label="被窜货经销商编号">{{chDes.chInfo.distributor_code}}</el-descriptions-item>
                        <el-descriptions-item label="被窜货经销商名称">{{chDes.chInfo.distributor_name}}</el-descriptions-item> -->
                        <el-descriptions-item label="销售区域">{{chDes.chInfo.sale_area|sale_area}}</el-descriptions-item>
                        <el-descriptions-item label="窜货地点">{{cu_address(chDes.chInfo)}}</el-descriptions-item>
                        <el-descriptions-item label="被窜货经销商编号">{{chDes.chInfo.bch_distributor_code}}</el-descriptions-item>
                        <el-descriptions-item label="被窜货经销商名称">{{chDes.chInfo.bch_distributor_name}}</el-descriptions-item>
                        <el-descriptions-item label="备注">{{chDes.chInfo.remark}}</el-descriptions-item>
                    </el-descriptions>
                </el-col>
            </el-row>
        </el-dialog>
    </el-dialog>
  </div>
</template>

<script>
import CustomerPanel from '@/components/CustomerPanel'
import {getChOrderList,getChOrderBill,getBillDes} from '@/api/app/logistics/statistics'
import {
    getDistributorLevelList
} from '@/api/customer/distributor'
export default {
    components:{
        CustomerPanel
    },
    data(){
        return{
            chDes:{
                baseInfo:{},
                chInfo:{}
            },
            chDesDialog:false,
            billTotal:0,
            tableDataBill:[],
            queryBillForm:{
                time:[],
                bch_distributor_name:'',//被窜货经销商
                from:'',
                remark:'',
                pageNum:1,
                pageSize:10
            },
            fromOption:[
                {
                    value:1,
                    label:'退货'
                },
                {
                    value:2,
                    label:'扫码'
                }
            ],
            chDialog:false,
            tableData:[],
            total:0,
            customerDialog:false,
            levelOption:[],
            queryForm:{
                customer_name:'',
                distributor_level:'',
                pageNum:1,
                pageSize:10
            }
        }
    },
    created(){
        this.getList()
        this.getDisLevel()
    },
    filters:{
        sale_area(val){
            if(!val) return '--'
            return JSON.parse(val).join('//')
        }
    },
    methods:{
        getList(){
            getChOrderList(this.queryForm).then(res=>{
                this.tableData=res.data
                this.total=res.total
            })
        },
        level(row){
            return this.levelOption.filter(item=>item.level_order==row.distributor_level).map(item=>item.level_name)[0]
        },
        from_type(row){
            return this.fromOption.filter(item=>item.value==row.from_type).map(item=>item.label)[0]
        },
        sale_area(item){
            if(!item.sale_area) return '--'
            return JSON.parse(item.sale_area).join('//')
        },
        cu_address(item){
            if(!item.cu_address){
                if(!item.sale_area) return '--'
                return JSON.parse(item.sale_area).join('//')
            }else{
                return item.cu_address
            }
        },
        getDisLevel(){
            getDistributorLevelList({}).then(res=>{
                this.levelOption=res.data
            })
        },
        handleDes(item){
            this.queryBillForm.bch_distributor_id=item.bch_distributor_id
            this.getChOrderBill()
            this.chDialog=true
        },
        getChOrderBill(){
             var params=Object.assign({},this.queryBillForm)
            if(!this.queryBillForm.time||this.queryBillForm.time.length==0){
                params.startTime=''
                params.endTime=''
            }else{
                params.startTime=this.queryBillForm.time[0]
                params.endTime=this.queryBillForm.time[1]
            }
            delete params.time
            getChOrderBill(params).then(res=>{
                this.tableDataBill=res.data
                this.billTotal=res.total
            })
        },
        chooseCustomer(){
            this.customerDialog=true
        },
        selectCustomer(val){
            if(this.chDialog){
                if(val.activeName=='1'){
                    this.queryBillForm.bch_distributor_name=val.distributor_name
                }else{
                    this.queryBillForm.bch_distributor_name=val.store_name
                }
                this.customerDialog=false
            }else{
                if(val.activeName=='1'){
                    this.queryForm.customer_name=val.distributor_name
                }else{
                    this.queryForm.customer_name=val.store_name
                }
                this.customerDialog=false
            }
        },
        handleBillDes(item){
            getBillDes({serial_number:item.serial_number,id:item.id,ck_order:item.ck_order}).then(res=>{
                this.chDes=res.data
                this.chDesDialog=true
            })
        },
        chooseBchCustomer(){
            this.customerDialog=true            
        },
        query(){
            this.queryForm.pageNum = 1;
            this.getList();
        },
        resetQuery(formName){
            this.$refs[formName].resetFields();
            this.query()
        },
        queryBill(){
            this.queryBillForm.pageNum = 1;
            this.getChOrderBill()
        },
        resetQueryBill(formName){
            this.$refs[formName].resetFields();
            this.queryBill()
        }
    },
}
</script>

<style>

</style>