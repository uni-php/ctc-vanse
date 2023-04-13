<template>
  <div class="app-container">
    <div class="tab-bar">
        <el-form ref="queryForm" :model="queryForm" label-width="100px" :inline="true" size="small">
            <el-form-item label="入库时间" prop="time">
                <el-date-picker
                    style="width:220px"
                    v-model="queryForm.time"
                    type="daterange"
                    unlink-panels=""
                    range-separator="至"
                    value-format="yyyy-MM-dd"
                    start-placeholder="开始日期"
                    end-placeholder="结束日期">
                </el-date-picker>
            </el-form-item>
            <el-form-item label="产品编号" prop="code">
                <el-input style="width:220px" v-model="queryForm.code" placeholder="请输入产品编号"></el-input>
            </el-form-item>
            <el-form-item label="产品名称" prop="product_name">
                <el-input style="width:220px" v-model="queryForm.product_name" placeholder="请输入生产名称"></el-input>
            </el-form-item>
            <el-form-item label="入库仓库" prop="warehouse_id">
                <el-select style="width:220px" v-model="queryForm.warehouse_id" placeholder="请选择入库仓库">
                    <el-option
                        v-for="item in warehouseOption"
                        :key="item.id"
                        :label="item.warehouse_name"
                        :value="item.id">
                    </el-option>
                </el-select>
            </el-form-item>
            <el-form-item label="入库单号" prop="order">
                <el-input style="width:220px" v-model="queryForm.order" placeholder="请输入入库单号"></el-input>
            </el-form-item>
            <el-form-item label="生产批次号" prop="batch">
                <el-input style="width:220px" v-model="queryForm.batch" placeholder="请输入生产批次号"></el-input>
            </el-form-item>
            <el-form-item > 
                <el-button type="primary" icon="el-icon-search" @click="query">查询</el-button>
                <el-button icon="el-icon-refresh" @click="resetQuery('queryForm')">重置</el-button>
            </el-form-item>
        </el-form>
    </div>
    <el-col :span="24" style="margin:10px 0;">
        <el-button @click="handleOrder" type="primary" size="small" >添加入库单</el-button>
    </el-col>
     <el-table
        :data="tableData"
        :header-cell-style="{background:'#FAFAFA',color:'#606266',height:'50px'}"
        border
        stripe
        size="medium"
        class="trace-table"
        style="width: 100%">
        <el-table-column prop="rk_order" width="170px" fixed="left" align="center" label="入库单号"></el-table-column>
        <el-table-column prop="id" align="center" label="序号"></el-table-column>
        <el-table-column prop="product_batch" show-overflow-tooltip="" align="center" label="生产批次号"></el-table-column>
        <el-table-column prop="quantity" align="center" label="入库数量">
        </el-table-column>
        <el-table-column prop="rk_num" align="center" label="已入库数量">
            <template slot-scope="scope">
                <span @click="rkCodeDes(scope.row)" class="stock-in">{{scope.row.rk_num}}</span>
            </template>
        </el-table-column>
        <el-table-column prop="product_name" align="center" label="产品名称"></el-table-column>
        <el-table-column prop="product_code" align="center" label="产品编号"></el-table-column>
        <el-table-column prop="specifications" align="center" label="规格"></el-table-column>
        <el-table-column prop="brand" align="center" label="品牌"></el-table-column>
        <el-table-column prop="manufacturer" show-overflow-tooltip="" align="center" label="生产厂家"></el-table-column>
        <el-table-column prop="barcode" show-overflow-tooltip="" align="center" label="条码"></el-table-column>
        <el-table-column prop="approval_number" align="center" label="批准条文"></el-table-column>
        <el-table-column prop="manufacture_time" show-overflow-tooltip="" align="center" label="生产日期"></el-table-column>
        <el-table-column prop="validity_time" align="center" show-overflow-tooltip="" label="有效期至"></el-table-column>
        <el-table-column prop="warehouse_id" align="center" show-overflow-tooltip="" :formatter="warehouse_id" label="入库仓库"></el-table-column>
        <el-table-column prop="create_order_time" show-overflow-tooltip="" align="center" label="建单时间"></el-table-column>
        <el-table-column label="操作" align="center" fixed="right" width="260px">
            <template slot-scope="scope">
                <el-button
                    size="mini"
                    type="text"
                    icon="el-icon-printer"
                    @click="handlePrint(scope.row)">打印</el-button>
                <el-button
                    size="mini"
                    type="text"
                    icon="el-icon-edit"
                    @click="handleEdit(scope.row)">编辑</el-button>
                <el-button
                    size="mini"
                    type="text"
                    icon="el-icon-truck"
                    v-if="scope.row.quantity==scope.row.rk_num"
                    @click="handleSend(scope.row)">一键发货</el-button>
                <el-button
                    size="mini"
                    type="text"
                    icon="el-icon-delete"
                    @click="handleDele(scope.row)">删除</el-button>
            </template>
        </el-table-column>
     </el-table>
     <pagination
        v-show="+total>10"
        :total="+total"
        :page.sync="queryForm.pageNum"
        :limit.sync="queryForm.pageSize"
        @pagination="getList"/>
    <!-- 添加入库单 -->
    <el-dialog :title="title" :visible.sync="rkDialog" width="70%" :close-on-click-modal="false" @close="rkDialog=false">
        <el-tabs v-model="activeName" @tab-click="handleClick" v-if="!form.id">
            <el-tab-pane label="直接添加" name="add"></el-tab-pane>
            <el-tab-pane label="入库扫描" name="scan"></el-tab-pane>
        </el-tabs>
        <el-form :model="form" ref="form" label-width="100px" :rules="rule" size="medium">
            <el-form-item label="入库单号:" prop="rk_order">
                <el-input readonly="" style="width:80%" v-model="form.rk_order" placeholder="请输入入库单号"/>
            </el-form-item>
             <el-form-item label="自定义单号:" v-if="activeName=='add'" prop="self_order">
                <el-input   style="width:80%" v-model="form.self_order" placeholder="请输入自定义单号"/>
            </el-form-item>
            <el-form-item label="产品信息:" prop="product_name">
                <el-row style="width:80%" >
                    <el-col :span="9"><el-input readonly=""  v-model="form.product_code" placeholder="请选择产品"/></el-col>
                    <el-col :span="2" style="text-align:center">--</el-col>
                    <el-col :span="9"><el-input readonly=""  v-model="form.product_name" placeholder="请选择产品"/></el-col>
                    <el-col :span="4"><el-button style="float:right" type="primary" size="medium" @click="clickProduct">选择</el-button></el-col>
                </el-row>
            </el-form-item>
            <el-form-item label="产品条码:" v-if="activeName=='add'" prop="barcode">
                <el-input readonly=""  style="width:80%" v-model="form.barcode" placeholder="请选择产品"/>
            </el-form-item>
            <el-form-item label="生产批次号:" prop="product_batch">
                <el-input style="width:80%" v-model="form.product_batch" placeholder="请输入生产批次号"/>
            </el-form-item>
            <!-- 扫码方式 -->
            <el-form-item label="扫码方式:" v-if="activeName=='scan'&&!form.id" prop="scan_type">
                <el-radio-group v-model="form.scan_type">
                    <el-radio :label="1">单码扫描</el-radio>
                    <el-radio :label="2">流水号区间</el-radio>
                </el-radio-group>
            </el-form-item>
            <el-form-item label="数量:" v-if="activeName=='add'" prop="quantity">
                <el-input style="width:80%" v-model="form.quantity" placeholder="请输入产品数量"/>
            </el-form-item>
            <el-form-item label="生产日期" prop="manufacture_time">
                <el-date-picker
                    v-model="form.manufacture_time"
                    @change="select_manufacture_time"
                    value-format="yyyy-MM-dd"
                    type="date"
                    placeholder="请选择生产日期">
                </el-date-picker>
            </el-form-item>
            <el-form-item label="有效期至" prop="validity_time">
                <el-date-picker
                    v-model="form.validity_time"
                    value-format="yyyy-MM-dd"
                    type="date"
                    placeholder="请选择有效期">
                </el-date-picker>
            </el-form-item>
            <el-form-item label="入库仓库：" prop="warehouse_id">
                <el-select style="width:80%" v-model="form.warehouse_id" placeholder="请选择入库仓库">
                    <el-option
                        v-for="item in warehouseOption"
                        :key="item.id"
                        :label="item.warehouse_name"
                        :value="item.id">
                    </el-option>
                </el-select>
            </el-form-item>
            <el-form-item label="备注:" prop="remark" v-if="activeName=='add'&&!form.id">
                <el-input style="width:80%" v-model="form.remark" placeholder="请输入备注"/>
            </el-form-item>
            <el-form-item label="扫描二维码:" prop="logistics_code" v-if="activeName=='scan'&&form.scan_type==1&&!form.id">
                <el-input style="width:80%" @keyup.enter.native="submitForm" v-model="form.logistics_code" placeholder="请扫描二维码"/>
            </el-form-item>
            <el-form-item label="流水号区间:" prop="order_start" v-if="activeName=='scan'&&form.scan_type==2&&!form.id">
                <el-row style="width:80%" >
                    <el-col :span="9"><el-input  v-model.number="form.order_start" placeholder="开始流水号"/></el-col>
                    <el-col :span="2" style="text-align:center">--</el-col>
                    <el-col :span="9"><el-input  v-model.number="form.order_end" placeholder="结束流水号"/></el-col>
                    <el-col :span="4"><el-button style="float:right" type="plain" size="medium">数量:{{order_count()}}</el-button></el-col>
                </el-row>
            </el-form-item>
        </el-form>
        <div slot="footer" class="dialog-footer">
          <el-button type="primary" @click="submitForm">确 定</el-button>
          <el-button @click="rkDialog=false">取 消</el-button>
        </div>
    </el-dialog>
    <!-- 产品框 -->
    <el-dialog title="选择产品" :visible.sync="productDialog" width="80%" @close="productDialog=false">
        <ProductPanel @selectProduct="selectProduct" />
    </el-dialog>
    <!-- 打印框 -->
    <el-dialog title="入库单打印" :visible.sync="printDialog" width="80%" @close="printDialog=false;$refs.qrCodeUrl.innerHTML = ''">
        <div id="printMer">
        <el-row>
            <el-col :span="15" style="height:120px;display:flex;align-items: flex-end">
                <el-descriptions title="">
                    <el-descriptions-item :contentStyle="{color:'rgb(217, 83, 79)'}" label="入库单号">{{orderInfo.rk_order}}</el-descriptions-item>
                    <el-descriptions-item :contentStyle="{color:'rgb(217, 83, 79)'}" label="入库时间">{{orderInfo.create_order_time}}</el-descriptions-item>
                </el-descriptions>
            </el-col>
            <el-col :span="9" style="display:flex;justify-content: flex-end;">
                <div class="qrcode" ref="qrCodeUrl"></div>
            </el-col>
        </el-row>
        <el-descriptions :labelStyle="{background:'#c7dcf5'}" direction="vertical" :column="7" border>
            <el-descriptions-item  label="生产批次号">{{orderInfo.product_batch}}</el-descriptions-item>
            <el-descriptions-item label="产品编号">{{orderInfo.product_code}}</el-descriptions-item>
            <el-descriptions-item label="产品名称">{{orderInfo.product_name}}</el-descriptions-item>
            <el-descriptions-item label="规格">{{orderInfo.specifications}}</el-descriptions-item>
            <el-descriptions-item label="数量">{{orderInfo.quantity}}</el-descriptions-item>
            <el-descriptions-item label="产品条码">{{orderInfo.barcode}}</el-descriptions-item>
            <el-descriptions-item label="生产日期">{{orderInfo.manufacture_time}}</el-descriptions-item>
        </el-descriptions>
        </div>
        <div slot="footer" class="dialog-footer">
          <el-button type="primary" v-print="printMer">打 印</el-button>
          <el-button @click="printDialog=false">关 闭</el-button>
        </div>
    </el-dialog>
    <!-- 物流码明细 -->
    <el-dialog title="物流码明细" :visible.sync="codeDialog" width="50%" @close="codeDialog=false">
        <el-table
            :data="codeData"
            :header-cell-style="{background:'#FAFAFA',color:'#606266',height:'50px'}"
            border
            stripe
            size="small"
            class="trace-table"
            style="width: 100%">
            <el-table-column prop="code_type" align="center" label="标签类型">
                <template slot-scope="scope">
                    {{scope.row.code_type==1?'大标':'小标'}}
                </template>
            </el-table-column>
            <el-table-column prop="code" align="center" label="物流码">
                <template slot-scope="scope">
                    {{scope.row.code||`序列号：${scope.row.order_start}--${scope.row.order_end}`}}
                </template>
            </el-table-column>
            <el-table-column prop="rk_num" align="center" label="数量"></el-table-column>
        </el-table>
        <pagination
        v-show="+codeTotal>10"
        :total="+codeTotal"
        :page.sync="querycodeForm.pageNum"
        :limit.sync="querycodeForm.pageSize"
        @pagination="getCodeList"/>
    </el-dialog>
       <!-- 客户框 -->
    <el-dialog title="选择经销商/门店" :visible.sync="customerDialog" width="80%" @close="customerDialog=false">
        <CustomerPanel @selectCustomer="selectCustomer" />
    </el-dialog>
    <!-- 一键发货 -->
    <el-dialog title="一键发货" :visible.sync="sendDialog" width="50%" @close="sendDialog=false">
        <el-form :model="sendForm" ref="sendForm" label-width="100px" :rules="sendRule" size="medium">
            <el-form-item label="发货单号:" prop="ck_order">
                <el-input readonly="" style="width:80%" v-model="sendForm.ck_order" placeholder="请输入发货单号"/>
            </el-form-item>
            <el-form-item label="客户信息:" prop="customer_name">
                <el-row style="width:80%" >
                    <el-col :span="9"><el-input readonly=""  v-model="sendForm.customer_code" placeholder="经销商/门店编号"/></el-col>
                    <el-col :span="2" style="text-align:center">--</el-col>
                    <el-col :span="9"><el-input readonly=""  v-model="sendForm.customer_name" placeholder="经销商/门店名称"/></el-col>
                    <el-col :span="4"><el-button style="float:right" type="primary" size="medium" @click="chooseCustomer">选择</el-button></el-col>
                </el-row>
            </el-form-item>
            <el-form-item label="是否赠品:" prop="is_gift">
                <el-checkbox v-model="sendForm.is_gift" :true-label='0' :false-label='1'></el-checkbox>
            </el-form-item>
            <el-form-item label="出货时间" prop="out_time">
                <el-date-picker
                    v-model="sendForm.out_time"
                    value-format="yyyy-MM-dd"
                    type="date"
                    placeholder="请选择出货日期">
                </el-date-picker>
            </el-form-item>
            <el-form-item label="收货地址:" prop="address">
                <el-input  style="width:80%" v-model="sendForm.address" placeholder="请输入收货地址"/>
            </el-form-item>
            <el-form-item label="备注:" prop="remark">
                <el-input style="width:80%" v-model="sendForm.remark" placeholder="请输入备注"/>
            </el-form-item>
        </el-form>
         <div slot="footer" class="dialog-footer">
          <el-button type="primary" @click="submitOrder">一键出货</el-button>
          <el-button @click="sendDialog=false">取 消</el-button>
        </div>    
    </el-dialog>
  </div>
</template>

<script>
import ProductPanel from '@/components/ProductPanel'
import {getWarehouseList} from '@/api/app/logistics/basic'
import CustomerPanel from '@/components/CustomerPanel'
import {valiPositiveNumber} from '@/utils/validate'
import Decimal from "decimal.js" 
import {createRkCode,saveRkOrder,getRkOrderList,deleRkOrder,getRkOrderInfo,getCodeList,quickDeliver,createCkCode} from '@/api/app/logistics/index'
import QRCode from 'qrcodejs2'
import {getUrlParams} from '@/utils/ctc'
export default {
    components:{
        ProductPanel,
        CustomerPanel
    },
    data(){
        return{
            is_edit:false,
            sendForm:{
                ck_order:'',
                rk_order:'',
                customer_code:'',
                customer_name:'',
                customer_id:'',
                customer_type:'',
                warehouse_id:'',
                is_gift:'',
                out_time:'',
                address:'',
                remark:''
            },
            sendDialog:false,
            codeTotal:0,
            codeData:[],
            activeName:'add',
            printMer:{
                id:"printMer",
                popTitle:'入库单明细',
            },
            codeDialog:false,
            shelf_life:0,//保质期
            queryForm:{
                time:[],
                code:'',
                product_name:'',
                warehouse_id:'',
                order:'',
                batch:'',
                pageNum:1,
                pageSize:10
            },
            queryWareForm:{
                keywords:'',
                pageNum:1,
                pageSize:999
            },
            querycodeForm:{
                rk_order:'',
                pageNum:1,
                pageSize:999
            },
            form:{
                rk_order:'',
                self_order:'',
                product_name:'',
                product_code:'',
                product_id:'',
                barcode:'',
                quantity:'',
                logistics_code:'',//扫描二维码
                scan_type:1,//默认单码扫描
                manufacture_time:'',//生产日期
                product_batch:"",
                validity_time:'',
                warehouse_id:'',
                remark:'',
                order_start:'',
                order_end:'',
                id:undefined
            },
            sendRule:{
                customer_name:[
                    { required: true, message: "客户不能为空", trigger: "blur" }
                ],
                address:[
                     { required: true, message: "地址不能为空", trigger: "blur" }
                ],
                out_time:[
                    { required: true, message: "出货时间不能为空", trigger: "blur" }
                ]
            },
            rule:{
                rk_order:[
                    { required: true, message: "入库单号不能为空", trigger: "blur" },
                ],
                product_name:[
                    { required: true, message: "请选择产品", trigger: "blur" },
                ],
                quantity:[
                    { required: true, message: "请输入入库数量", trigger: "blur" },
                    {validator:valiPositiveNumber,trigger: "change"}
                ],
                warehouse_id:[
                    { required: true, message: "请选择入库仓库", trigger: "blur" },
                ],
                logistics_code:[
                     { required: true, message: "请输入扫描二维码", trigger: "blur" },
                ],
                order_start:[
                    { required: true, message: "请输入物流码区间", trigger: "blur" },
                    {validator:valiPositiveNumber,trigger: "change"}
                ]
            },
            orderInfo:{

            },
            printDialog:false,
            warehouseOption:[],
            productDialog:false,
            title:'',
            rkDialog:false,
            customerDialog:false,
            tableData:[],
            total:0
        }
    },
    created(){
        this.getList();
        this.getWarehouseList()
    },
    //保证同一单号对应同一种商品
    watch:{
        'form.product_code'(val){
            if(!this.is_edit){
                createRkCode({}).then(res=>{
                this.form.rk_order=res.data
            })
            }
        }
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
            getRkOrderList(params).then(res=>{
                this.tableData=res.data
                this.total=res.total
            })
        },
        order_count(){
            if(!this.form.order_start||!this.form.order_end) return '--'
            return new Decimal(this.form.order_end).sub(new Decimal(this.form.order_start))*1+1
        },
        getWarehouseList(){
            getWarehouseList(this.queryWareForm).then(res=>{
                this.warehouseOption=res.data
            })
        },
        warehouse_id(row){
            return this.warehouseOption.filter(item=>item.id==row.warehouse_id).map(item=>item.warehouse_name)[0]
        },
        handleOrder(){
            this.rkDialog=true
            this.title='添加入库单'
            this.activeName='add'
            this.is_edit=false
            createRkCode({}).then(res=>{
                this.form={
                rk_order:res.data,
                scan_type:1,
                self_order:'',
                product_name:'',
                product_batch:'',
                product_code:'',
                product_id:'',
                barcode:'',
                quantity:'',
                manufacture_time:'',//生产日期
                validity_time:'',
                warehouse_id:'',
                remark:'',
                id:undefined
            }
            })
        },
        handleClick(){
            createRkCode({}).then(res=>{
                this.form.rk_order=res.data
                this.$forceUpdate()
            })
        },
        //一键发货
        handleSend(row){
            createCkCode({}).then(res=>{
                this.sendForm.ck_order=res.data
                this.sendForm.rk_order=row.rk_order
                this.sendForm.warehouse_id=row.warehouse_id
                this.sendForm.customer_code=''
                this.sendForm.customer_name=''
                this.sendForm.customer_id=''
                this.sendForm.customer_type=''
                this.sendForm.is_gift='',
                this.sendForm.out_time='',
                this.sendForm.address='',
                this.sendForm.remark=''
                this.sendDialog=true
            })
        },
        //一键出货提交
        submitOrder(){
            this.$refs["sendForm"].validate(valid => {
                if(valid){
                    quickDeliver(this.sendForm).then(res=>{
                        if(res.code==200){
                            this.$message.success(res.msg)
                            this.sendDialog=false
                            this.getList()
                        }else{
                            this.$message.error(res.msg)
                        }   
                    })
                }   
            })
        },
        chooseCustomer(){
            this.customerDialog=true
        },
        selectCustomer(val){
            if(val.activeName=='1'){
                this.sendForm.customer_code=val.distributor_code
                this.sendForm.customer_name=val.distributor_name
                this.sendForm.customer_id=val.id
                this.sendForm.customer_type='distributor'//经销商
            }else{
                this.sendForm.customer_code=val.store_code
                this.sendForm.customer_name=val.store_name
                this.sendForm.customer_id=val.id
                this.sendForm.customer_type='store'//门店
            }
            this.customerDialog=false
        },
        select_manufacture_time(val){
            //计算有效期
            this.form.validity_time=this.$dayjs(val).add(this.shelf_life,'month').format('YYYY-MM-DD')
        },
        handlePrint(row){
            getRkOrderInfo({id:row.id}).then(res=>{
                this.printDialog=true
                this.orderInfo=res.data
                if(!this.orderInfo.quantity){
                    this.orderInfo.quantity=row.real_stock_in_num
                }
                this.$nextTick(()=>{
                    this.creatQrCode(); 
                })
            })
        },
         creatQrCode(){
            var qrcode = new QRCode(this.$refs.qrCodeUrl, {
                text: this.orderInfo.rk_order, // 需要转换为二维码的内容
                width: 120,
                height: 120,
                colorDark: '#000000',
                colorLight: '#ffffff',
                correctLevel: QRCode.CorrectLevel.H
            })
        },
        handleEdit(row){
            getRkOrderInfo({id:row.id}).then(res=>{
                this.title='编辑入库单'
                this.rkDialog=true
                this.activeName='add'
                this.form=res.data
                this.is_edit=true
            })
        },
        handleDele(row){
            this.$confirm('确认删除该入库单?', '提示', {
                confirmButtonText: '确定',
                cancelButtonText: '取消',
                type: 'warning'
                }).then(() => {
                 deleRkOrder({rk_order:row.rk_order}).then(res=>{
                    if(res.code==200){
                        this.$message.success(res.msg)
                        this.getList()
                    }else{
                        this.$message.error(res.msg)
                    }
                 })
                }).catch(() => {});
        },
        //查看入库物流码详情
        rkCodeDes(row){
            this.querycodeForm.rk_order=row.rk_order
            this.codeData=[]
            this.querycodeForm.pageNum=1
            this.getCodeList()
            this.codeDialog=true
        },
        getCodeList(){
            getCodeList(this.querycodeForm).then(res=>{
                this.codeData=res.data
                this.codeTotal=res.total
            })
        },
        submitForm(row){
            this.$refs["form"].validate(valid => {
                if(valid){
                    var data=Object.assign({},this.form)
                    // delete data.product_code
                    // delete data.barcode
                    // delete data.product_name
                    // delete data.specifications
                    data.rk_type=this.activeName=='add'?1:2//新增入库方式
                    if(data.rk_type==2&&data.scan_type==1){
                        if(!data.logistics_code) return this.$message.error('请扫描二维码')
                        //将扫描二维码参数拆分 =>code batch
                        data.code=getUrlParams(data.logistics_code,'code')
                        data.batch=getUrlParams(data.logistics_code,'batch')
                        if(!data.code||!data.batch) return this.$message.error('二维码格式有误')
                    }
                    if(data.rk_type==2&&data.scan_type==2){
                        if(!data.order_start||!data.order_end) return this.$message.warning('请输入物流码区间')
                        if(data.order_end*1<data.order_start*1) return this.$message.warning('请检查物流码区间')
                    }
                    delete data.logistics_code
                    saveRkOrder(data).then(res=>{
                         if(res.code==200){
                            this.$message.success(res.msg)
                            if(this.activeName=='add'){
                                this.rkDialog=false
                            }
                            this.getList()
                        }else{
                            this.$message.error(res.msg)
                        }
                    })
                }
            })
        },
        selectProduct(row){
            //将商品信息回传到表单
            console.log(row)
            this.shelf_life=row.shelf_life//保质期
            this.productDialog=false
            this.form.product_name=row.product_name,
            this.form.specifications=row.specifications
            this.form.unit=row.unit
            this.form.barcode=row.barcode
            this.form.product_code=row.code
            this.form.product_id=row.id
            this.form.manufacture_time='',//生产日期
            this.form.validity_time=''
        },
        clickProduct(){
            this.productDialog=true
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
.my-label {
    background: #c7dcf5;
  }
.qrcode{
    display: inline-block;
    img {
        width: 132px;
        height: 132px;
        background-color: #fff; //设置白色背景色
        padding: 6px; // 利用padding的特性，挤出白边
        box-sizing: border-box;
    }
}
.stock-in{
    color: red;
    cursor: pointer;
}
</style>