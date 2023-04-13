<template>
  <div class="app-container">
    <div class="tab-bar">
        <el-form ref="queryForm" :model="queryForm" label-width="100px" :inline="true" size="small">
            <el-form-item label="退货时间" prop="time">
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
            <el-form-item label="退货单号" prop="order">
                <el-input style="width:220px" v-model="queryForm.order" placeholder="请输入退货单号"></el-input>
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
            <el-form-item label="产品编号" prop="code">
                <el-input style="width:220px" v-model="queryForm.code" placeholder="请输入产品编号"></el-input>
            </el-form-item>
            <el-form-item label="产品名称" prop="product_name">
                <el-input style="width:220px" v-model="queryForm.product_name" placeholder="请输入生产名称"></el-input>
            </el-form-item>
            <el-form-item label="生产批次号" prop="batch">
                <el-input style="width:220px" v-model="queryForm.batch" placeholder="请输入生产批次号"></el-input>
            </el-form-item>
            <el-form-item label="审核状态" prop="check_status">
                <el-select style="width:220px" v-model="queryForm.check_status" placeholder="审核状态">
                    <el-option
                        v-for="item in checkOption"
                        :key="item.id"
                        :label="item.value"
                        :value="item.id">
                    </el-option>
                </el-select>
            </el-form-item>
            <el-form-item label="是否窜货" prop="is_fleeing_goods">
                <el-select style="width:220px" v-model="queryForm.is_fleeing_goods" placeholder="是否串货">
                    <el-option
                        v-for="item in fleeingOption"
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
            <el-form-item label="退往仓库" prop="warehouse_id">
                <el-select style="width:220px" v-model="queryForm.warehouse_id" placeholder="请选择退往仓库">
                    <el-option
                        v-for="item in warehouseOption"
                        :key="item.id"
                        :label="item.warehouse_name"
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
    <el-table
        :data="tableData"
        :header-cell-style="{background:'#FAFAFA',color:'#606266',height:'50px'}"
        border
        stripe
        row-key="id"
        :tree-props="{children: 'children', hasChildren: 'hasChildren'}"
        size="medium"
        class="trace-table"
        style="width: 100%">
        <el-table-column prop="th_order" width="170px" fixed="left" align="center" label="退货单号"></el-table-column>
        <el-table-column prop="express_order" fixed="left" align="center" label="快递单号">
            <template slot-scope="scope">
                {{scope.row.express_order||'--'}}
            </template>
        </el-table-column>
        <el-table-column prop="return_time"  align="center" label="日期"></el-table-column>
        <el-table-column prop="return_sub"  align="center" label="退往单位"></el-table-column>
        <el-table-column prop="customer_code" align="center" label="经销商/门店编号"></el-table-column>
        <el-table-column prop="customer_name" align="center" label="经销商/门店名称"></el-table-column>
        <el-table-column prop="return_warehouse_id"  align="center" label="退往仓库" :formatter="return_warehouse_id"></el-table-column>
        <el-table-column prop="check_status"  align="center" label="审核状态" :formatter="check_status"></el-table-column>
        <el-table-column prop="th_sum"  align="center" label="退货总数">
            <template slot-scope="scope">
                <span @click="thCodeDes(scope.row)" class="stock-in">{{scope.row.th_sum}}</span>
            </template>
        </el-table-column>
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
        <el-table-column prop="product_batch" align="center" label="生产批次号"></el-table-column>
        <el-table-column prop="return_num" align="center" label="退货数量"></el-table-column>
        <el-table-column prop="manufacture_time" show-overflow-tooltip="" align="center" label="生产日期"></el-table-column>
        <el-table-column prop="is_gift" align="center" :formatter="is_gift" label="是否赠品"></el-table-column>
        <el-table-column prop="barcode" show-overflow-tooltip="" align="center" label="条码"></el-table-column>
        <el-table-column prop="validity_time" align="center" show-overflow-tooltip="" label="有效期至"></el-table-column>
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
                    @click="handleOrder(scope.row)">快递单号</el-button>
                <el-button
                    size="mini"
                    type="text"
                    icon="el-icon-truck"
                    @click="handleCheck(scope.row)">退货审核</el-button>
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
    <el-dialog title="选择经销商/门店" :visible.sync="customerDialog" width="80%" @close="customerDialog=false">
        <CustomerPanel @selectCustomer="selectCustomer" />
    </el-dialog>
     <!-- 打印框 -->
    <el-dialog title="退货单打印" :visible.sync="printDialog" width="80%" @close="printDialog=false;$refs.qrCodeUrl.innerHTML = ''">
        <div id="printMer">
        <el-row>
            <el-col :span="16" style="height:120px;display:flex;align-items: flex-end">
                <el-descriptions title="">
                    <el-descriptions-item :contentStyle="{color:'rgb(217, 83, 79)'}" label="退货单号">{{orderInfo.th_order}}</el-descriptions-item>
                    <el-descriptions-item :contentStyle="{color:'rgb(217, 83, 79)'}" label="退货人">{{orderInfo.customer_name}}</el-descriptions-item>
                    <el-descriptions-item :contentStyle="{color:'rgb(217, 83, 79)'}" label="退货时间">{{orderInfo.return_time}}</el-descriptions-item>
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
            <el-table-column prop="product_code" align="center" label="产品编号"></el-table-column>
            <el-table-column prop="product_name" align="center" label="产品名称"></el-table-column>
            <el-table-column prop="specifications" align="center" label="规格"></el-table-column>
            <el-table-column prop="return_num" align="center" label="实发数量"></el-table-column>
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
            <el-table-column prop="th_num" align="center" label="数量"></el-table-column>
        </el-table>
        <pagination
        v-show="+codeTotal>10"
        :total="+codeTotal"
        :page.sync="querycodeForm.pageNum"
        :limit.sync="querycodeForm.pageSize"
        @pagination="getCodeList"/>
    </el-dialog>
    <!-- 审核 -->
    <el-dialog title="退货审核" :visible.sync="checkDialog" width="50%" @close="checkDialog=false">
        <el-form ref="checkForm" :model="checkForm" label-width="80px">
            <el-form-item label="审核：">
                <el-radio-group v-model="checkForm.check_status">
                    <el-radio label="1">审核通过</el-radio>
                    <el-radio label="2">审核不通过</el-radio>
                </el-radio-group>
            </el-form-item>
        </el-form>
        <div slot="footer" class="dialog-footer">
          <el-button type="primary" @click="checkOrder">确 定</el-button>
          <el-button @click="checkDialog=false">取 消</el-button>
        </div>
    </el-dialog>  
  </div>
</template>

<script>
import CustomerPanel from '@/components/CustomerPanel'
import {getWarehouseList} from '@/api/app/logistics/basic'
import QRCode from 'qrcodejs2'
import {getThOrderList,getThOrderInfo,saveExpressOrder,checkThOrder,deleThOrder,getThCodeList} from '@/api/app/logistics/return'
export default {
     components:{
        CustomerPanel
    },
    data(){
        return{
            codeTotal:0,
            codeData:[],
            querycodeForm:{
                th_order:'',
                pageNum:1,
                pageSize:10
            },
            codeDialog:false,
            checkForm:{
                check_status:0
            },
            checkDialog:false,
            tableData:[],
            printData:[],
            total:0,
            orderInfo:{},
            customerDialog:false,
            warehouseOption:[],
            printDialog:false,
            printMer:{
                id:"printMer",
                popTitle:'入库单明细',
            },
            queryForm:{
                time:[],
                order:'',
                is_gift:'',
                code:'',
                product_name:'',
                batch:'',
                check_status:'',
                customer_name:'',
                is_fleeing_goods:'',
                warehouse_id:'',
                pageNum:1,
                pageSize:10
            },
            queryWareForm:{
                keywords:'',
                pageNum:1,
                pageSize:999
            },
            giftOption:[
                {
                   value:'赠品',
                   id:0
                },
                {
                   value:'非赠品',
                   id:1
                }
            ],
            fleeingOption:[
                {
                   value:'未窜货',
                   id:0
                },
                {
                   value:'已窜货',
                   id:1
                }
            ],
            checkOption:[
                {
                   value:'未审核',
                   id:0
                },
                {
                   value:'审核通过',
                   id:1
                },
                {
                   value:'审核不通过',
                   id:2
                }
            ],
            orderInfo:{

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
            getThOrderList(params).then(res=>{
                this.tableData=res.data
                this.total=res.total
            })
        },
        thCodeDes(row){
            this.querycodeForm.th_order=row.th_order
            this.codeData=[]
            this.querycodeForm.pageNum=1
            this.getCodeList()
            this.codeDialog=true
        },
         getCodeList(){
            getThCodeList(this.querycodeForm).then(res=>{
                this.codeData=res.data
                this.codeTotal=res.total
            })
        },
        is_gift(row){
            return this.giftOption.filter(item=>item.id==row.is_gift).map(item=>item.value)[0]
        },
        check_status(row){
            return this.checkOption.filter(item=>item.id==row.check_status).map(item=>item.value)[0]
        },
        return_warehouse_id(row){
            return this.warehouseOption.filter(item=>item.id==row.return_warehouse_id).map(item=>item.warehouse_name)[0]
        },
        chooseCustomer(){
            this.customerDialog=true
        },
        handleOrder(row){
             this.$prompt('请输入快递单号', '快递单号', {
                confirmButtonText: '确定',
                inputValue:row.express_order||'',
                cancelButtonText: '取消',
                inputPattern: /^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{3,30}$/,
                inputErrorMessage: '快递单号长度3~30位，字母+数字'
                }).then(({ value }) => {
                    saveExpressOrder({id:row.id,express_order:value}).then(res=>{
                        if(res.code==200){
                            this.$message.success(res.msg)
                            this.getList()
                        }else{
                            this.$message.error(res.msg)
                        }   
                    })
                }).catch(() => {
            });
        },
        handlePrint(row){
            getThOrderInfo({id:row.id}).then(res=>{
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
                text: this.orderInfo.th_order, // 需要转换为二维码的内容
                width: 120,
                height: 120,
                colorDark: '#000000',
                colorLight: '#ffffff',
                correctLevel: QRCode.CorrectLevel.H
            })
        }, 
        handleCheck(row){
            if(row.check_status!=0) return this.$message.warning('已审核的订单不能重复审核！')
            this.checkDialog=true
            this.orderInfo=row
        },
        checkOrder(){
            if(this.checkForm.check_status==0) return this.$message.warning('请选择审核状态！')
            const data={
                id:this.orderInfo.id,
                check_status:this.checkForm.check_status
            }
            checkThOrder(data).then(res=>{
                if(res.code==200){
                    this.$message.success(res.msg)
                    this.checkDialog=false
                    this.getList()
                }else{
                    this.$message.error(res.msg)
                }   
            })
        },
        //
        handleDele(row){
            if(row.check_status!=0) return this.$message.warning('已审核订单不可删除！')
            this.$confirm('确认删除该退货单?', '提示', {
            confirmButtonText: '确定',
            cancelButtonText: '取消',
            type: 'warning'
            }).then(() => {
                deleThOrder({th_order:row.th_order}).then(res=>{
                if(res.code==200){
                    this.$message.success(res.msg)
                    this.getList()
                }else{
                    this.$message.error(res.msg)
                }
            })
            }).catch(() => {});
        },
        getWarehouseList(){
            getWarehouseList(this.queryWareForm).then(res=>{
                this.warehouseOption=res.data
            })
        },
        selectCustomer(val){
            if(val.activeName=='1'){
                this.queryForm.customer_name=val.distributor_name
            }else{
                this.queryForm.customer_name=val.store_name
            }
            this.customerDialog=false
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