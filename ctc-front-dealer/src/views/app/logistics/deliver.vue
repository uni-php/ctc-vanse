<template>
  <div class="app-container">
    <div class="tab-bar">
        <el-form ref="queryForm" :model="queryForm" label-width="100px" :inline="true" size="small">
            <el-form-item label="发货时间" prop="time">
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
            <el-form-item label="生产批次号" prop="batch">
                <el-input style="width:220px" v-model="queryForm.batch" placeholder="请输入生产批次号"></el-input>
            </el-form-item>
            <el-form-item label="发货单号" prop="order">
                <el-input style="width:220px" v-model="queryForm.order" placeholder="请输入发货单号"></el-input>
            </el-form-item>
            <el-form-item label="产品编号" prop="code">
                <el-input style="width:220px" v-model="queryForm.code" placeholder="请输入产品编号"></el-input>
            </el-form-item>
            <el-form-item label="产品名称" prop="product_name">
                <el-input style="width:220px" v-model="queryForm.product_name" placeholder="请输入生产名称"></el-input>
            </el-form-item>
            <el-form-item label="发货仓库" prop="warehouse_id">
                <el-select style="width:220px" v-model="queryForm.warehouse_id" placeholder="请选择发货仓库">
                    <el-option
                        v-for="item in warehouseOption"
                        :key="item.id"
                        :label="item.warehouse_name"
                        :value="item.id">
                    </el-option>
                </el-select>
            </el-form-item>
            <el-form-item label="状态" prop="status">
                <el-select style="width:220px" v-model="queryForm.status" placeholder="请选择单号状态">
                    <el-option
                        v-for="item in statusOption"
                        :key="item.id"
                        :label="item.value"
                        :value="item.id">
                    </el-option>
                </el-select>
            </el-form-item>
            <el-form-item label="经销商/门店" prop="customer_name">
                <el-input style="width:220px" v-model="queryForm.customer_name" placeholder="请输入经销商/门店"></el-input>
                <el-button style="margin-left:4px" size="small" type="primary" @click="chooseCustomer">选择</el-button>
            </el-form-item>
            <el-form-item label="是否赠品" prop="is_gift">
                <el-select style="width:220px" v-model="queryForm.is_gift" placeholder="是否赠品">
                    <el-option
                        v-for="item in giftOption"
                        :key="item.id"
                        :label="item.value"
                        :value="item.id">
                    </el-option>
                </el-select>
            </el-form-item>
             <el-form-item label="发货单类型" prop="order_type">
                <el-select style="width:220px" v-model="queryForm.order_type" placeholder="发货单类型">
                    <el-option
                        v-for="item in typeOption"
                        :key="item.id"
                        :label="item.value"
                        :value="item.id">
                    </el-option>
                </el-select>
            </el-form-item>
             <el-form-item > 
                <el-button type="primary" icon="el-icon-search" @click="query">查询</el-button>
                <el-button icon="el-icon-refresh" @click="resetQuery('queryForm')">重置</el-button>
            </el-form-item>
        </el-form>
    </div>
    <el-col :span="24" style="margin:10px 0;">
        <el-button @click="handleOrder" type="primary" size="small" >添加发货单</el-button>
        <!-- <el-button @click="handleImport" type="primary" size="small" >批量导入</el-button> -->
    </el-col>
    <el-table
        :data="tableData"
        :header-cell-style="{background:'#FAFAFA',color:'#606266',height:'50px'}"
        border
        row-key="id"
        stripe
        size="medium"
        class="trace-table"
        :tree-props="{children: 'children', hasChildren: 'hasChildren'}"
        style="width: 100%">
        <el-table-column prop="ck_order" width="190px" fixed="left" align="center" label="发货单号"></el-table-column>
        <!-- <el-table-column prop="online_order" align="center" label="在线订单单号"></el-table-column> -->
        <el-table-column prop="create_time" show-overflow-tooltip="" align="center" label="日期"></el-table-column>
        <el-table-column prop="customer_code" align="center" label="经销商/门店编号"></el-table-column>
        <el-table-column prop="customer_name" align="center" label="经销商/门店名称"></el-table-column>
        <el-table-column prop="is_gift" align="center" :formatter="is_gift" label="是否赠品"></el-table-column>
        <el-table-column prop="deliver_sum" align="center" label="应发总数量" ></el-table-column>
        <el-table-column prop="send_sum" align="center" label="实发总数量">
            <template slot-scope="scope">
                <span @click="ckCodeDes(scope.row)" class="stock-in">{{scope.row.send_sum}}</span>
            </template>
        </el-table-column>
        <el-table-column prop="order_num" align="center" label="产品应发数量"></el-table-column>
        <el-table-column prop="out_num" align="center" label="产品实发数量"></el-table-column>
        <el-table-column prop="product_code" align="center" label="产品编号">
            <template slot-scope="scope">
                {{scope.row.product_code||'--'}}
            </template>
        </el-table-column>
        <el-table-column prop="product_name" align="center" label="产品名称">
            <template slot-scope="scope">
                {{scope.row.product_name||'--'}}
            </template>
        </el-table-column>
        <el-table-column prop="specifications" align="center" label="规格">
            <template slot-scope="scope">
                {{scope.row.specifications||'--'}}
            </template>
        </el-table-column>
        <el-table-column prop="unit" align="center" label="单位">
            <template slot-scope="scope">
                {{scope.row.unit||'--'}}
            </template>
        </el-table-column>
        <el-table-column prop="warehouse_id" align="center" show-overflow-tooltip="" :formatter="warehouse_id" label="发货仓库"></el-table-column>
        <el-table-column prop="manufacture_time" show-overflow-tooltip="" align="center" label="生产日期"></el-table-column>
        <el-table-column prop="validity_time" align="center" show-overflow-tooltip="" label="有效期至"></el-table-column>
        <el-table-column prop="status" align="center" :formatter="status" label="状态"></el-table-column>
        <el-table-column prop="address" align="center" label="收货地址"></el-table-column>
        <el-table-column label="操作" align="center" fixed="right" width="260px">
            <template slot-scope="scope" v-if="!(String(scope.row.id).includes('pro'))">
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
                    icon="el-icon-delete"
                    @click="handleDele(scope.row)">删除</el-button>
                    <!-- 发货中可以提前结单 -->
                <el-button
                    size="mini"
                    type="text"
                    icon="el-icon-finished"
                    v-if="scope.row.status==2"
                    @click="handleFinish(scope.row)">提前结单</el-button>
                    <!-- 该功能不合理 暂不开发 -->
                <!-- <el-button
                    size="mini"
                    type="text"
                    icon="el-icon-thumb"
                    @click="handleReturn(scope.row)">一键退货</el-button> -->
            </template>
        </el-table-column>
    </el-table>
    <pagination
        v-show="+total>10"
        :total="+total"
        :page.sync="queryForm.pageNum"
        :limit.sync="queryForm.pageSize"
        @pagination="getList"/>
         <!-- 客户框 -->
    <el-dialog title="选择经销商/门店" :visible.sync="customerDialog" width="80%" @close="customerDialog=false">
        <CustomerPanel @selectCustomer="selectCustomer" />
    </el-dialog>
     <!-- 产品框 -->
    <el-dialog title="选择产品" :visible.sync="productDialog" width="80%" @close="productDialog=false">
        <ProductPanel @selectProduct="selectProduct" />
    </el-dialog>
    <!-- 扫描单选择产品 -->
    <el-dialog title="选择产品" :visible.sync="productScanDialog" width="80%" @close="productScanDialog=false">
        <ProductPanel @selectProduct="selectScanProduct" />
    </el-dialog>
    <el-dialog title="产品搜索" :visible.sync="searchDialog" width="50%" @close="searchDialog=false">
        <el-form :model="searchForm" ref="searchForm" label-width="120px" :rules="searchRule" size="medium">
            <el-form-item label="选择出货产品:" prop="product_name">
                <el-row style="width:80%" >
                    <el-col :span="9"><el-input readonly=""  v-model="searchForm.product_code" placeholder="请选择产品"/></el-col>
                    <el-col :span="2" style="text-align:center">--</el-col>
                    <el-col :span="9"><el-input readonly=""  v-model="searchForm.product_name" placeholder="请选择产品"/></el-col>
                    <el-col :span="4" v-if="!is_edit"><el-button style="float:right" type="primary" size="medium" @click="productDialog=true">选择</el-button></el-col>
                </el-row>
            </el-form-item>
            <el-form-item label="订单数量:" prop="order_num">
                <el-input style="width:80%" v-model="searchForm.order_num" placeholder="请输入订单数量"/>
            </el-form-item>
        </el-form>
        <div slot="footer" class="dialog-footer">
          <el-button type="primary" @click="submitSearchForm">确 定</el-button>
          <el-button @click="searchDialog=false">取 消</el-button>
        </div>
    </el-dialog>
    <!-- 添加出库单 -->
    <el-dialog :title="title" :visible.sync="ckDialog" width="70%" @close="ckDialog=false">
        <el-tabs v-model="activeName" @tab-click="handleClick">
            <el-tab-pane label="直接添加" name="add">
                <el-form :model="form" ref="form" label-width="120px" :rules="rule" size="medium">
                    <el-form-item label="发货单号:" prop="ck_order">
                        <el-input readonly="" style="width:80%" v-model="form.ck_order" placeholder="请输入发货单号"/>
                    </el-form-item>
                    <el-form-item label="经销商/门店信息:" prop="customer_name">
                        <el-row style="width:80%" >
                            <el-col :span="9"><el-input readonly=""  v-model="form.customer_code" placeholder="经销商/门店编号"/></el-col>
                            <el-col :span="2" style="text-align:center">--</el-col>
                            <el-col :span="9"><el-input readonly=""  v-model="form.customer_name" placeholder="经销商/门店名称"/></el-col>
                            <el-col :span="4"><el-button :disabled="form.id?true:false" style="float:right" type="primary" size="medium" @click="chooseCustomer">选择</el-button></el-col>
                        </el-row>
                    </el-form-item>
                    <el-form-item label="出库仓库：" prop="warehousing_id">
                        <el-select style="width:80%" :disabled="form.id?true:false" v-model="form.warehouse_id" placeholder="请选择出库仓库">
                            <el-option
                                v-for="item in warehouseOption"
                                :key="item.id"
                                :label="item.warehouse_name"
                                :value="item.id">
                            </el-option>
                        </el-select>
                    </el-form-item>
                    <el-form-item label="是否赠品:" prop="is_gift">
                        <el-checkbox v-model="form.is_gift" :true-label='1' :false-label='0'></el-checkbox>
                    </el-form-item>
                    <el-form-item label="出货时间" prop="out_time">
                        <el-date-picker
                            v-model="form.out_time"
                            value-format="yyyy-MM-dd"
                            type="date"
                            placeholder="请选择出货时间">
                        </el-date-picker>
                    </el-form-item>
                    <el-form-item label="收货地址:" prop="address">
                        <el-input  style="width:80%" v-model="form.address" placeholder="请输入收货地址"/>
                    </el-form-item>
                    <el-form-item label="备注:" prop="remark">
                        <el-input style="width:80%" v-model="form.remark" placeholder="请输入备注"/>
                    </el-form-item>
                </el-form>
                <el-col :span="24" style="margin:10px 0;">
                    <el-button @click="handleAddProduct" type="primary" size="small" >添加产品</el-button>
                </el-col>
                <el-table
                    :data="productData"
                    :header-cell-style="{background:'#FAFAFA',color:'#606266',height:'50px'}"
                    border
                    stripe
                    size="small"
                    class="trace-table"
                    style="width: 100%">
                    <el-table-column prop="product_code" align="center" label="产品编号"></el-table-column>
                    <el-table-column prop="product_name" align="center" label="产品名称"></el-table-column>
                    <el-table-column prop="barcode" align="center" label="产品条码"></el-table-column>
                    <el-table-column prop="unit" align="center" label="单位"></el-table-column>
                    <el-table-column prop="specifications" align="center" label="产品规格"></el-table-column>
                    <el-table-column prop="order_num" align="center" label="订单数量"></el-table-column>
                    <el-table-column prop="out_num" align="center" label="已出货数量"></el-table-column>
                    <el-table-column label="操作" align="center" fixed="right" width="240px">
                        <template slot-scope="scope">
                            <el-button
                                size="mini"
                                type="primary"
                                @click="handleEditPro(scope.row)">编辑</el-button>
                            <el-button
                                size="mini"
                                type="danger"
                                @click="handleDelePro(scope.row)">删除</el-button>
                        </template>
                    </el-table-column>
                </el-table>
            </el-tab-pane>
            <el-tab-pane label="出库扫描" name="scan">
                <el-form :model="scanForm" ref="scanForm" label-width="120px" :rules="scanRule" size="medium">
                    <el-form-item label="出库单号:" prop="ck_order">
                        <el-input readonly="" style="width:80%" v-model="scanForm.ck_order" placeholder="请输入出库单号"/>
                    </el-form-item>
                    <el-form-item label="入库单号:" prop="rk_order">
                        <el-input readonly="" style="width:80%" v-model="scanForm.rk_order" placeholder="请输入入库单号"/>
                    </el-form-item>
                    <el-form-item label="出库仓库：" prop="warehouse_id">
                        <el-select style="width:80%" v-model="scanForm.warehouse_id" placeholder="请选择出库仓库">
                            <el-option
                                v-for="item in warehouseOption"
                                :key="item.id"
                                :label="item.warehouse_name"
                                :value="item.id">
                            </el-option>
                        </el-select>
                    </el-form-item>
                     <el-form-item label="经销商/门店信息:" prop="customer_name">
                        <el-row style="width:80%" >
                            <el-col :span="9"><el-input readonly=""  v-model="scanForm.customer_code" placeholder="经销商/门店编号"/></el-col>
                            <el-col :span="2" style="text-align:center">--</el-col>
                            <el-col :span="9"><el-input readonly=""  v-model="scanForm.customer_name" placeholder="经销商/门店名称"/></el-col>
                            <el-col :span="4"><el-button style="float:right" type="primary" size="medium" @click="chooseScanCustomer">选择</el-button></el-col>
                        </el-row>
                    </el-form-item>
                    <el-form-item label="产品信息:" prop="product_name">
                        <el-row style="width:80%" >
                            <el-col :span="9"><el-input readonly=""  v-model="scanForm.product_code" placeholder="请选择产品"/></el-col>
                            <el-col :span="2" style="text-align:center">--</el-col>
                            <el-col :span="9"><el-input readonly=""  v-model="scanForm.product_name" placeholder="请选择产品"/></el-col>
                            <el-col :span="4"><el-button style="float:right" type="primary" size="medium" @click="clickProduct">选择</el-button></el-col>
                        </el-row>
                    </el-form-item>
                    <el-form-item label="生产批次号:" prop="product_batch">
                        <el-input style="width:80%" v-model="scanForm.product_batch" placeholder="请输入生产批次号"/>
                    </el-form-item>
                    <el-form-item label="扫码方式:" prop="scan_type">
                        <el-radio-group v-model="scanForm.scan_type">
                            <el-radio :label="1">单码扫描</el-radio>
                            <!-- <el-radio :label="2">流水号区间</el-radio> -->
                        </el-radio-group>
                    </el-form-item>
                    <el-form-item label="生产日期" prop="manufacture_time">
                        <el-date-picker
                            v-model="scanForm.manufacture_time"
                            @change="select_manufacture_time"
                            value-format="yyyy-MM-dd"
                            type="date"
                            placeholder="请选择生产日期">
                        </el-date-picker>
                    </el-form-item>
                    <el-form-item label="有效期至" prop="validity_time">
                        <el-date-picker
                            v-model="scanForm.validity_time"
                            value-format="yyyy-MM-dd"
                            type="date"
                            placeholder="请选择有效期">
                        </el-date-picker>
                    </el-form-item>
                    <el-form-item label="扫描二维码:" prop="logistics_code" v-if="activeName=='scan'&&scanForm.scan_type==1">
                        <el-input style="width:80%" @keyup.enter.native="submitForm" v-model="scanForm.logistics_code" placeholder="请扫描二维码"/>
                    </el-form-item>
                    <el-form-item label="流水号区间:" prop="order_start" v-if="activeName=='scan'&&scanForm.scan_type==2">
                        <el-row style="width:80%" >
                            <el-col :span="9"><el-input  v-model.number="scanForm.order_start" placeholder="开始流水号"/></el-col>
                            <el-col :span="2" style="text-align:center">--</el-col>
                            <el-col :span="9"><el-input  v-model.number="scanForm.order_end" placeholder="结束流水号"/></el-col>
                            <el-col :span="4"><el-button style="float:right" type="plain" size="medium">数量:{{order_count()}}</el-button></el-col>
                        </el-row>
                    </el-form-item>
                </el-form>
            </el-tab-pane>
        </el-tabs>
        <div slot="footer" class="dialog-footer">
          <el-button type="primary" @click="submitOrder">确 定</el-button>
          <el-button @click="ckDialog=false">取 消</el-button>
        </div>
    </el-dialog>
    <!-- 打印框 -->
    <el-dialog title="出库单打印" :visible.sync="printDialog" width="80%" @close="printDialog=false;$refs.qrCodeUrl.innerHTML = ''">
        <div id="printMer">
        <el-row>
            <el-col :span="16" style="height:120px;display:flex;align-items: flex-end">
                <el-descriptions title="">
                    <el-descriptions-item :contentStyle="{color:'rgb(217, 83, 79)'}" label="入库单号">{{orderInfo.ck_order}}</el-descriptions-item>
                    <el-descriptions-item :contentStyle="{color:'rgb(217, 83, 79)'}" label="入库时间">{{orderInfo.create_time}}</el-descriptions-item>
                </el-descriptions>
            </el-col>
            <el-col :span="8" style="display:flex;justify-content: flex-end;">
                <div class="qrcode" ref="qrCodeUrl"></div>
            </el-col>
        </el-row>
        <!-- 打印表格 -->
        <el-table
            :data="printData"
            :header-cell-style="{background:'#c7dcf5',color:'#606266',height:'50px'}"
            border
            stripe
            size="small"
            class="trace-table"
            style="width: 100%">
            <el-table-column prop="customer_name" align="center" label="经销商名称"></el-table-column>
            <el-table-column prop="product_code" align="center" label="产品编号"></el-table-column>
            <el-table-column prop="product_name" align="center" label="产品名称"></el-table-column>
            <el-table-column prop="specifications" align="center" label="规格"></el-table-column>
            <el-table-column prop="order_num" align="center" label="应发数量"></el-table-column>
            <el-table-column prop="out_num" align="center" label="实发数量"></el-table-column>
            <el-table-column prop="unit" align="center" label="包装类型"></el-table-column>
        </el-table>
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
            <el-table-column prop="product_name" align="center" label="商品名称"></el-table-column>
            <el-table-column prop="product_code" align="center" label="商品编号"></el-table-column>
            <el-table-column prop="ck_num" align="center" label="数量"></el-table-column>
        </el-table>
        <pagination
        v-show="+codeTotal>10"
        :total="+codeTotal"
        :page.sync="querycodeForm.pageNum"
        :limit.sync="querycodeForm.pageSize"
        @pagination="getCodeList"/>
    </el-dialog>
  </div>
</template>

<script>
import ProductPanel from '@/components/ProductPanel'
import CustomerPanel from '@/components/CustomerPanel'
import {getWarehouseList} from '@/api/app/logistics/basic'
import {valiPositiveNumber} from '@/utils/validate'
import {getUrlParams} from '@/utils/ctc'
import QRCode from 'qrcodejs2'
import Decimal from "decimal.js" 
import {createCkCode,createRkCode,saveCkOrder,getCkOrderList,getCkOrderInfo,saveScanRkOrder,getCkCodeList,deleCkOrder,finishCkOrder} from '@/api/app/logistics/index'
export default {
    components:{
        CustomerPanel,
        ProductPanel
    },
    data(){
        return{
            activeName:'add',
            orderInfo:{},
            printData:[],
            codeDialog:false,
            printDialog:false,
            is_edit:false,
            productScanDialog:false,
            searchForm:{
                order_num:'',
                product_name:'',
                product_code:''
            },
            printMer:{
                id:"printMer",
                popTitle:'入库单明细',
            },
            searchRule:{
                order_num:[
                    { required: true, message: "订单数量不能为空", trigger: "blur" },
                    {validator:valiPositiveNumber,trigger: "change"}
                ],
                order_start:[
                    { required: true, message: "请输入物流码区间", trigger: "blur" },
                    {validator:valiPositiveNumber,trigger: "change"}
                ],
                product_name:[
                    { required: true, message: "出货商品不能为空", trigger: "blur" },
                ],
                logistics_code:[
                     { required: true, message: "请扫描出库二维码", trigger: "blur" },
                ],
                manufacture_time:[
                    { required: true, message: "生产日期不能为空", trigger: "blur" },
                ]
            },
            shelf_life:'',
            searchDialog:false,
            productDialog:false,
            title:'',
            form:{
                ck_order:'',
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
            scanForm:{
                ck_order:'',
                rk_order:'',
                warehouse_id:'',
                customer_code:'',
                customer_name:'',
                customer_type:'',
                outwarehouse_products:[],//产品信息数据结构
                customer_id:'',
                product_code:'',
                product_name:'',
                product_id:'',
                product_batch:'',
                scan_type:1,
                manufacture_time:'',
                validity_time:'',
                logistics_code:'',
                order_start:'',
                order_end:''
            },
            ckDialog:false,
            customerDialog:false,
            queryForm:{
                time:[],
                batch:'',
                order:'',
                code:'',
                product_name:'',
                warehouse_id:'',
                status:'',
                customer_name:'',
                is_gift:'',
                order_type:'',
                pageNum:1,
                pageSize:10
            },
            querycodeForm:{
                ck_order:'',
                pageNum:1,
                pageSize:10
            },
            codeData:[],
            codeTotal:0,
            productData:[],
            warehouseOption:[],
            queryWareForm:{
                keywords:'',
                pageNum:1,
                pageSize:999
            },
            tableData:[],
            total:0,
            scanRule:{
                warehouse_id:[
                     { required: true, message: "请选择出库仓库", trigger: "blur" }
                ],
                product_name:[
                    { required: true, message: "请选择产品信息", trigger: "blur" }
                ],
                order_start:[
                    { required: true, message: "请填写流水号区间", trigger: "blur" }
                ]
            },
            rule:{
                ck_order:[
                    { required: true, message: "发货单号不能为空", trigger: "blur" }
                ],
                customer_name:[
                    { required: true, message: "经销商/门店不能为空", trigger: "blur" }
                ],
                out_time:[
                     { required: true, message: "出货时间不能为空", trigger: "blur" }
                ]
            },
            statusOption:[
                {
                   value:'未发货',
                   id:0 
                },
                {
                   value:'待收货',
                   id:1 
                },
                {
                   value:'发货中',
                   id:2 
                },
                {
                   value:'已完成',
                   id:3 
                }
            ],
            giftOption:[
                {
                   value:'赠品',
                   id:1
                },
                {
                   value:'非赠品',
                   id:0
                }
            ],
            typeOption:[
                {
                   value:'自建发货单',
                   id:0
                },
                {
                   value:'在线订单发货单',
                   id:1
                },
                {
                   value:'客户自助入库单',
                   id:2
                }
            ]
        }
    },
    watch:{
        //出库扫码 一个入库单只能对应一个商品 切换商品重新生成出库单
        'scanForm.product_id'(newName, oldName){
            if(oldName&&(newName!=oldName)){
                createRkCode({}).then(res=>{
                    this.scanForm.rk_order=res.data
                })
            }
        },
        //切换发货人 出库单与入库单都要改变
        'scanForm.customer_id'(newName, oldName){
            if(oldName&&(newName!=oldName)){
                createCkCode({type:'scan'}).then(res=>{
                    this.scanForm.ck_order=res.data
                    this.scanForm.rk_order='R'+res.data.substr(1)
                    this.$forceUpdate()
                })
            }
        }
    },
    created(){
        this.getList()
        this.getWarehouseList()
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
            getCkOrderList(params).then(res=>{
                this.tableData=res.data
                this.total=res.total
            })
        },
        handleAddProduct(){
            this.searchDialog=true
            this.is_edit=false
            //将搜索表单置空
            this.searchForm={
                product_name:'',
                product_code:'',
                unit:'',
                product_id:'',
                barcode:'',
                specifications:'',
                out_num:0,//默认已出货数量为0
            }
        },
        order_count(){
            if(!this.scanForm.order_start||!this.scanForm.order_end) return '--'
            return new Decimal(this.scanForm.order_end).sub(new Decimal(this.scanForm.order_start))*1+1
        },
        handleClick(){
            createCkCode({type:'scan'}).then(res=>{
                this.scanForm.ck_order=res.data
                this.scanForm.rk_order='R'+res.data.substr(1)
                this.$forceUpdate()
            })
        },
        //提前结单
        handleFinish(row){
            this.$confirm('是否提前结单?', '提示', {
                confirmButtonText: '确定',
                cancelButtonText: '取消',
                type: 'warning'
                }).then(() => {
                 finishCkOrder({ck_order:row.ck_order}).then(res=>{
                        if(res.code==200){
                            this.$message.success(res.msg)
                            this.getList()
                        }else{
                            this.$message.error(res.msg)
                        }
                })
                }).catch(() => {});
        },
        select_manufacture_time(val){
            //计算有效期
            this.scanForm.validity_time=this.$dayjs(val).add(this.shelf_life,'month').format('YYYY-MM-DD')
        },
        chooseScanCustomer(){
            this.customerDialog=true
        },
        clickProduct(){
            this.productScanDialog=true
        },
        getWarehouseList(){
            getWarehouseList(this.queryWareForm).then(res=>{
                this.warehouseOption=res.data
            })
        },
        is_gift(row){
            return this.giftOption.filter(item=>item.id==row.is_gift).map(item=>item.value)[0]
        },
        warehouse_id(row){
            return this.warehouseOption.filter(item=>item.id==row.warehouse_id).map(item=>item.warehouse_name)[0]
        },
        status(row){
            return this.statusOption.filter(item=>item.id==row.status).map(item=>item.value)[0]
        },
        level(row){
            return this.levelOption.filter(item=>item.id==row.distributor_level).map(item=>item.level_name)[0]
        },
        selectCustomer(val){
            if(!this.ckDialog){
                if(val.activeName=='1'){
                    this.queryForm.customer_name=val.distributor_name
                }else{
                    this.queryForm.customer_name=val.store_name
                }
                this.customerDialog=false
            }else{
                if(this.activeName=='add'){
                    if(val.activeName=='1'){
                        this.form.customer_code=val.distributor_code
                        this.form.customer_name=val.distributor_name
                        this.form.customer_id=val.id
                        this.form.customer_type='distributor'//经销商
                    }else{
                        this.form.customer_code=val.store_code
                        this.form.customer_name=val.store_name
                        this.form.customer_id=val.id
                        this.form.customer_type='store'//门店
                    }
                }else{
                    if(val.activeName=='1'){
                        this.scanForm.customer_code=val.distributor_code
                        this.scanForm.customer_name=val.distributor_name
                        this.scanForm.customer_id=val.id
                        this.scanForm.customer_type='distributor'//经销商
                    }else{
                        this.scanForm.customer_code=val.store_code
                        this.scanForm.customer_name=val.store_name
                        this.scanForm.customer_id=val.id
                        this.scanForm.customer_type='store'//门店
                    }
                }
                this.customerDialog=false
            }
        },
        chooseCustomer(){
            this.customerDialog=true
        },
        handleOrder(){
            this.ckDialog=true
            this.productData=[]
            this.title='添加发货单'
            this.activeName='add'
            createCkCode({}).then(res=>{
                this.form={
                    ck_order:res.data,
                    customer_code:'',
                    customer_name:'',
                    customer_type:'',
                    customer_id:'',
                    warehouse_id:'',
                    is_gift:'',
                    out_time:'',
                    address:'',
                    remark:'',
                }
            })
        },
        //回传产品搜索框
        selectProduct(val){
            this.searchForm={
                product_name:val.product_name,
                product_code:val.code,
                unit:val.unit,
                product_id:val.id,
                barcode:val.barcode,
                specifications:val.specifications,
                out_num:0,//默认已出货数量为0
            }
            this.productDialog=false
        },
        selectScanProduct(row){
            console.log(row)
            this.shelf_life=row.shelf_life//保质期
            this.productScanDialog=false
            this.scanForm.product_name=row.product_name,
            this.scanForm.product_code=row.code
            this.scanForm.product_id=row.id
            this.scanForm.barcode=row.barcode
            this.scanForm.manufacture_time='',//生产日期
            this.scanForm.validity_time='',
            this.scanForm.unit=row.unit
            this.scanForm.specifications=row.specifications
            this.scanForm.outwarehouse_products=[
                {
                    product_code:row.code,
                    product_id:row.id,
                    product_name:row.product_name,
                    barcode:row.barcode,
                    unit:row.unit,
                    specifications:row.specifications,
                    order_num:1,
                    out_num:1
                }
            ]
        },
        submitSearchForm(){
             this.$refs["searchForm"].validate(valid => {
                 if(valid){
                    //插入产品表格 验重
                    var params=Object.assign({},this.searchForm)
                    var table=Object.assign([],this.productData)
                    if(table.length==0){
                        this.productData.push(params)
                    }else{
                        if(this.is_edit){
                            //替换
                            table.forEach((item,index)=>{
                                if(item.product_code==params.product_code){
                                    this.$set(this.productData[index],'order_num',params.order_num)//更新数据
                                }
                            })
                        }else{
                            var has=table.map(item=>item.product_code).includes(params.product_code)
                            if(has) return this.$message.warning('请勿上传重复商品')
                            this.productData.push(params)
                        }
                    }
                    this.searchDialog=false
                    this.is_edit=false
                 }
             })
        },
        submitOrder(){
            if(this.activeName=='add'){
                this.$refs["form"].validate(valid => {
                if(valid){
                        if(this.productData.length==0) return this.$message.warning('产品不能为空')
                        //提交出库单信息
                        var data=Object.assign({},this.form)
                        data.outwarehouse_products=this.productData
                        data.order_type=this.activeName=='add'?1:2//新增入库方式
                        if(data.printData) delete data.printData
                        saveCkOrder(data).then(res=>{
                            if(res.code==200){
                                this.$message.success(res.msg)
                                this.ckDialog=false
                                this.getList()
                            }else{
                                this.$message.error(res.msg)
                            }
                        })
                    }
                })
            }else{
                this.$refs["scanForm"].validate(valid => {
                if(valid){
                        //提交出库单信息
                        var data=Object.assign({},this.scanForm)
                        data.order_type=this.activeName=='add'?1:2//新增入库方式
                        if(this.scanForm.scan_type==1){
                            if(!data.logistics_code) return this.$message.error('请扫描二维码')
                            //将扫描二维码参数拆分 =>code batch
                            data.code=getUrlParams(data.logistics_code,'code')
                            data.batch=getUrlParams(data.logistics_code,'batch')
                            if(!data.code||!data.batch) return this.$message.error('二维码格式有误')
                        }else{
                            if(!data.order_start||!data.order_end) return this.$message.warning('请输入物流码区间')
                            if(data.order_end*1<data.order_start*1) return this.$message.warning('请检查物流码区间')
                        }
                        delete data.logistics_code
                        data.outwarehouse_products[0].manufacture_time=data.manufacture_time
                        data.outwarehouse_products[0].validity_time=data.validity_time
                        saveScanRkOrder(data).then(res=>{
                            if(res.code==200){
                                this.$message.success(res.msg)
                                // this.ckDialog=false
                                this.getList()
                            }else{
                                this.$message.error(res.msg)
                            }
                        })
                    }
                })
            }
        },
        submitForm(){

        },
        handleDelePro(row){
            this.productData=this.productData.filter(item=>item.product_code!=row.product_code)
        },
        handleEditPro(row){
            this.searchDialog=true
            this.is_edit=true
            var data=Object.assign({},row)
            this.searchForm=data
        },
        handleImport(){

        },
        //查看码详情
        ckCodeDes(row){
            this.querycodeForm.ck_order=row.ck_order
            this.codeData=[]
            this.querycodeForm.pageNum=1
            this.getCodeList()
            this.codeDialog=true
        },
        getCodeList(){
            getCkCodeList(this.querycodeForm).then(res=>{
                this.codeData=res.data
                this.codeTotal=res.total
            })
        },
        handlePrint(row){
             getCkOrderInfo({id:row.id}).then(res=>{
                this.printDialog=true
                this.orderInfo=res.data
                this.printData=res.data.printData
                this.$nextTick(()=>{
                    this.creatQrCode(); 
                })
            })
        },
        creatQrCode(){
            var qrcode = new QRCode(this.$refs.qrCodeUrl, {
                text: this.orderInfo.ck_order, // 需要转换为二维码的内容
                width: 120,
                height: 120,
                colorDark: '#000000',
                colorLight: '#ffffff',
                correctLevel: QRCode.CorrectLevel.H
            })
        },
        handleEdit(row){
            getCkOrderInfo({id:row.id}).then(res=>{
                this.title='编辑出库单'
                this.ckDialog=true
                this.activeName='add'
                this.productData=res.data.printData
                this.form=res.data
                this.form.out_time=res.data.out_time||res.data.create_time
            })
        },
        handleDele(row){
            this.$confirm('确认删除该出库单?', '提示', {
                confirmButtonText: '确定',
                cancelButtonText: '取消',
                type: 'warning'
                }).then(() => {
                 deleCkOrder({ck_order:row.ck_order}).then(res=>{
                    if(res.code==200){
                        this.$message.success(res.msg)
                        this.getList()
                    }else{
                        this.$message.error(res.msg)
                    }
                 })
                }).catch(() => {});
        },
        handleReturn(row){

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
.stock-in{
    color: red;
    cursor: pointer;
}
</style>