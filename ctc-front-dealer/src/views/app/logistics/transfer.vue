<template>
  <div class="app-container">
    <div class="tips">
        <p>通过排单设置需要调仓的仓库、商品和数量，调仓人员可按排单进行定仓、定品、定量扫码调仓，系统自动核对数据，未入库或已出货的商品不能调仓</p>
    </div>
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
             <el-form-item label="调仓单号" prop="order">
                <el-input style="width:220px" v-model="queryForm.order" placeholder="请输入调仓单号"></el-input>
            </el-form-item>
            <el-form-item label="调入仓库" prop="in_warehouse_id">
                <el-select style="width:220px" v-model="queryForm.in_warehouse_id" placeholder="请选择调入仓库">
                    <el-option
                        v-for="item in warehouseOption1"
                        :key="item.id"
                        :label="item.warehouse_name"
                        :value="item.id">
                    </el-option>
                </el-select>
            </el-form-item>
            <el-form-item label="调出仓库" prop="out_warehouse_id">
                <el-select style="width:220px" v-model="queryForm.out_warehouse_id" placeholder="请选择调出仓库">
                    <el-option
                        v-for="item in warehouseOption2"
                        :key="item.id"
                        :label="item.warehouse_name"
                        :value="item.id">
                    </el-option>
                </el-select>
            </el-form-item>
            <el-form-item label="调仓状态" prop="status">
                <el-select style="width:220px" v-model="queryForm.status" placeholder="请选择调仓状态">
                    <el-option
                        v-for="item in statusOption"
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
        <el-button @click="handleOrder" type="primary" size="small" >添加调仓单</el-button>
    </el-col>
    <el-table
        :data="tableData"
        :header-cell-style="{background:'#FAFAFA',color:'#606266',height:'50px'}"
        border
        stripe
        size="medium"
        class="trace-table"
        style="width: 100%">
        <el-table-column prop="dc_order" width="190px" fixed="left" align="center" label="调仓单号"></el-table-column>
        <el-table-column prop="out_warehouse_id" :formatter="warehouse_id_out"   align="center" label="调出仓库"></el-table-column>
        <el-table-column prop="in_warehouse_id" :formatter="warehouse_id_in"  align="center" label="调入仓库"></el-table-column>
        <el-table-column prop="order_num"   align="center" label="订单数量"></el-table-column>
        <el-table-column prop="transfer_num"   align="center" label="已调仓数量"></el-table-column>
        <el-table-column prop="create_by"   align="center" label="添加人"></el-table-column>
        <el-table-column prop="create_time"   align="center" label="添加时间"></el-table-column>
        <el-table-column prop="remark"   align="center" label="备注"></el-table-column>
        <el-table-column prop="status"   align="center" label="调仓状态" :formatter="status"></el-table-column>
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
    <!-- 添加调仓单 -->
    <el-dialog :title="title" :visible.sync="dcDialog" width="70%" @close="dcDialog=false">
        <el-form :model="form" ref="form" label-width="120px" :rules="rule" size="medium">
            <el-form-item label="调仓单号:" prop="dc_order">
                <el-input readonly="" style="width:80%" v-model="form.dc_order" placeholder="请输入调仓单号"/>
            </el-form-item>
            <el-form-item label="调出仓库：" prop="out_warehouse_id">
                <el-select style="width:80%" @change="out_warehousing_id"  v-model="form.out_warehouse_id" placeholder="请选择调出仓库">
                    <el-option
                        v-for="item in warehouseOption1"
                        :key="item.id"
                        :label="item.warehouse_name"
                        :value="item.id">
                    </el-option>
                </el-select>
            </el-form-item>
            <el-form-item label="调入仓库：" prop="in_warehouse_id">
                <el-select style="width:80%" @change="in_warehousing_id"  v-model="form.in_warehouse_id" placeholder="请选择调入仓库">
                    <el-option
                        v-for="item in warehouseOption2"
                        :key="item.id"
                        :label="item.warehouse_name"
                        :value="item.id">
                    </el-option>
                </el-select>
            </el-form-item>
            <el-form-item label="备注:" prop="remark">
                <el-input  style="width:80%" v-model="form.remark" placeholder="请输入备注"/>
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
            <el-table-column prop="product_name" align="center" label="产品名称"></el-table-column>
            <el-table-column prop="barcode" align="center" label="产品条码"></el-table-column>
            <el-table-column prop="specifications" align="center" label="产品规格"></el-table-column>
            <el-table-column prop="order_num" align="center" label="订单数量"></el-table-column>
            <el-table-column prop="dc_num" align="center" label="已调仓数量"></el-table-column>
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
        <div slot="footer" class="dialog-footer">
          <el-button type="primary" @click="submitOrder">确 定</el-button>
          <el-button @click="dcDialog=false">取 消</el-button>
        </div>
    </el-dialog>
    <!-- 打印框 -->
    <el-dialog title="出库单打印" :visible.sync="printDialog" width="80%" @close="printDialog=false;$refs.qrCodeUrl.innerHTML = ''">
        <div id="printMer">
        <el-row>
            <el-col :span="16" style="height:120px;display:flex;align-items: flex-end">
                <el-descriptions title="">
                    <el-descriptions-item :contentStyle="{color:'rgb(217, 83, 79)'}" label="调仓单号">{{orderInfo.dc_order}}</el-descriptions-item>
                    <el-descriptions-item :contentStyle="{color:'rgb(217, 83, 79)'}" label="调仓时间">{{orderInfo.create_time}}</el-descriptions-item>
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
            <el-table-column prop="order_num" align="center" label="订单数量"></el-table-column>
            <el-table-column prop="dc_num" align="center" label="已调仓数量"></el-table-column>
            <el-table-column prop="unit" align="center" label="包装类型"></el-table-column>
        </el-table>
        </div>
        <div slot="footer" class="dialog-footer">
          <el-button type="primary" v-print="printMer">打 印</el-button>
          <el-button @click="printDialog=false">关 闭</el-button>
        </div>
    </el-dialog>
    <!-- 产品框 -->
    <el-dialog title="选择产品" :visible.sync="productDialog" width="80%" @close="productDialog=false">
        <ProductPanel @selectProduct="selectProduct" />
    </el-dialog>
  </div>
</template>

<script>
import {getWarehouseList} from '@/api/app/logistics/basic'
import {createDcCode,saveDcOrder,getDcOrderInfo,getDcOrderList,deleDcOrder} from '@/api/app/logistics/dc'
import QRCode from 'qrcodejs2'
import ProductPanel from '@/components/ProductPanel'
import {valiPositiveNumber} from '@/utils/validate'
export default {
    components:{
        ProductPanel
    },
    data(){
        return{
            productDialog:false,
            productData:[],
            form:{
                in_warehouse_id:'',
                out_warehouse_id:'',
                dc_order:'',
                remark:''
            },
            printMer:{
                id:"printMer",
                popTitle:'调仓单明细',
            },
            title:'',
            dcDialog:false,
            tableData:[],
            total:0,
            printDialog:false,
            searchForm:{
                order_num:'',
                product_name:'',
                product_code:''
            },
            searchRule:{
                order_num:[
                    { required: true, message: "订单数量不能为空", trigger: "blur" },
                    {validator:valiPositiveNumber,trigger: "change"}
                ],
                product_name:[
                    { required: true, message: "出货商品不能为空", trigger: "blur" },
                ]
            },
            rule:{
                dc_order:[
                    { required: true, message: "调仓单号不能为空", trigger: "blur" }
                ],
                out_warehousing_id:[
                    { required: true, message: "请选择调出仓库", trigger: "blur" }
                ],
                in_warehousing_id:[
                    { required: true, message: "请选择调入仓库", trigger: "blur" }
                ],
            },
           queryForm:{
               time:[],
               order:'',
               in_warehouse_id:'',
               out_warehouse_id:'',
               status:'',
               pageNum:1,
               pageSize:10
           },
           queryWareForm:{
                keywords:'',
                pageNum:1,
                pageSize:999
            },
            warehouseOption1:[],
            warehouseOption2:[],
            warehouseOption:[],
            printData:[],
            orderInfo:{},
           searchDialog:false,
           is_edit:false,
           statusOption:[
               {
                   value:'待调仓',
                   id:0 
                },
                {
                   value:'调仓中',
                   id:1 
                },
                {
                   value:'调仓完成',
                   id:2 
                }
           ] 
        }
    },
    created(){
        this.getWarehouseList()
        this.getList()
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
            getDcOrderList(params).then(res=>{
                this.tableData=res.data
                this.total=res.total
            })
        },
        warehouse_id_in(row){
            return this.warehouseOption.filter(item=>item.id==row.in_warehouse_id).map(item=>item.warehouse_name)[0]
        },
        warehouse_id_out(row){
            return this.warehouseOption.filter(item=>item.id==row.out_warehouse_id).map(item=>item.warehouse_name)[0]
        },
        out_warehousing_id(val){
            this.warehouseOption2=this.warehouseOption.filter(item=>item.id!=val)
        }, 
        in_warehousing_id(val){
            this.warehouseOption1=this.warehouseOption.filter(item=>item.id!=val)
        },
        status(row){
            return this.statusOption.filter(item=>item.id==row.status).map(item=>item.value)[0]
        },
        handleOrder(){
            this.dcDialog=true
            this.productData=[]
            this.title='添加调仓单'
            createDcCode({}).then(res=>{
                this.form={
                    dc_order:res.data,
                    out_warehouse_id:'',
                    in_warehouse_id:'',
                    remark:'',
                }
            })
        },
        handleEdit(row){
            getDcOrderInfo({id:row.id}).then(res=>{
                this.title='编辑调仓单'
                this.dcDialog=true
                this.productData=res.data.printData
                this.form=res.data
            })
        },
        handleDele(row){
            if(row.transfer_num*1>0) return this.$message.warning('调仓单物流码明细已存在，不可删除！')
            this.$confirm('确认删除该调仓单?', '提示', {
            confirmButtonText: '确定',
            cancelButtonText: '取消',
            type: 'warning'
            }).then(() => {
                deleDcOrder({dc_order:row.dc_order}).then(res=>{
                if(res.code==200){
                    this.$message.success(res.msg)
                    this.getList()
                }else{
                    this.$message.error(res.msg)
                }
                })
            }).catch(() => {});
        },
        handlePrint(row){
             getDcOrderInfo({id:row.id}).then(res=>{
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
                text: this.orderInfo.dc_order, // 需要转换为二维码的内容
                width: 120,
                height: 120,
                colorDark: '#000000',
                colorLight: '#ffffff',
                correctLevel: QRCode.CorrectLevel.H
            })
        },
        selectProduct(val){
            this.searchForm={
                product_name:val.product_name,
                product_code:val.code,
                unit:val.unit,
                product_id:val.id,
                barcode:val.barcode,
                specifications:val.specifications,
                dc_num:0,//默认已调仓数量为0
            }
            this.productDialog=false
        },
        handleAddProduct(){
            if(!this.form.out_warehouse_id) return this.$message.warning('请选择调出仓库')
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
                dc_num:0,//默认数量为0
            }

        },
        submitOrder(){
            this.$refs["form"].validate(valid => {
                if(valid){
                    if(this.productData.length==0) return this.$message.warning('产品不能为空')
                    var data=Object.assign({},this.form)
                        data.dc_products=this.productData
                        if(data.printData) delete data.printData
                        saveDcOrder(data).then(res=>{
                            if(res.code==200){
                                this.$message.success(res.msg)
                                this.dcDialog=false
                                this.getList()
                            }else{
                                this.$message.error(res.msg)
                            }
                    })
                }
            })
        },
        handleEditPro(row){
            this.searchDialog=true
            this.is_edit=true
            var data=Object.assign({},row)
            this.searchForm=data
        },
        handleDelePro(row){
            this.productData=this.productData.filter(item=>item.product_code!=row.product_code)
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
        getWarehouseList(){
            getWarehouseList(this.queryWareForm).then(res=>{
                this.warehouseOption1=res.data
                this.warehouseOption2=res.data
                this.warehouseOption=res.data
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

<style lang="scss" scoped>
.app-container .tips{
    padding: 8px 16px;
    background-color: #ecf8ff;
    border-radius: 4px;
    border-left: 5px solid #50bfff;
    margin: 20px 0;
}
.dialog-footer{
  margin: 30px 0;
}
</style>