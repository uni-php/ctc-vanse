<template>
  <div class="app-container">
    <div class="tab-bar">
        <el-form ref="queryForm" :model="queryForm" label-width="100px" :inline="true" size="small">
            <el-form-item label="产品" prop="product">
                <el-input style="width:220px" v-model="queryForm.product" placeholder="请输入产品名称"></el-input>
            </el-form-item>
            <el-form-item label="类型" prop="type">
                <el-select style="width:220px" size="small" v-model="queryForm.type" placeholder="请选择生码类型">
                    <el-option
                        v-for="item in codeTypeOptions"
                        :key="item.dict_value"
                        :label="item.dict_label"
                        :value="item.dict_value">
                    </el-option>
                </el-select>
            </el-form-item>
            <el-form-item label="应用场景" prop="scene">
                <el-select style="width:220px" size="small"  v-model="queryForm.scene" placeholder="请选择应用场景">
                    <el-option
                        v-for="item in sceneOptions"
                        :key="item.dict_value"
                        :label="item.dict_label"
                        :value="item.dict_value">
                    </el-option>
                </el-select>
            </el-form-item>
            <el-form-item label="备注说明" prop="mark">
                <el-input style="width:220px" v-model="queryForm.mark" placeholder="请输入备注"></el-input>
            </el-form-item>
            <el-form-item > 
                <el-button type="primary" icon="el-icon-search" @click="query">查询</el-button>
                <el-button icon="el-icon-refresh" @click="reset('queryForm')">重置</el-button>
            </el-form-item>
        </el-form>
    </div>
    <el-col :span="24" style="margin:10px 0;">
        <el-button type="primary" plain style="font-size:14px" size="mini" >生码总量：{{code_num}}</el-button>
        <el-button type="primary" style="font-size:14px" size="mini" @click="createCode">生码</el-button>
        <!-- 此功能暂不开发 -->
        <!-- <el-button type="primary" style="font-size:14px" size="mini" @click="handleGlobalRel">全局关联</el-button> -->
    </el-col>
    <el-table
      :data="tableData"
      :header-cell-style="{background:'#FAFAFA',color:'#606266',height:'50px'}"
      border
      stripe
      size="medium"
      class="trace-table"
      style="width: 100%">
      <el-table-column prop="batch" width="150px" align="center" show-overflow-tooltip="" label="批次号"></el-table-column>
      <el-table-column prop="scene" align="center" label="应用场景" width="360px">
          <template slot-scope="scope">
            <span v-for="(item,index) in scene(scope.row.scene)" :key="index" :class="{active:item.dict_value==4}" @click="handleViewDes(scope.row,item)">
                  {{item.dict_label}}
                  <span v-if="item.dict_value==2">{{scope.row.verification_code==1?'(验证码)':''}}</span>
                  <span v-if="scope.row.prize&&item.dict_value==3" :class="{active:scope.row.prize==2}" >{{scope.row.prize==1?'(单奖模式)':'(双奖模式)'}}</span>
                  <span v-show="index!=scene(scope.row.scene).length-1">、</span>
            </span>
          </template>
      </el-table-column>
      <el-table-column prop="order" align="center" show-overflow-tooltip label="流水号范围">
          <template slot-scope="scope">
              <span>{{scope.row.order_begin}} - {{scope.row.order_end}}</span>
          </template>
      </el-table-column>
      <el-table-column prop="count" align="center" label="数量"></el-table-column>
      <el-table-column prop="code_type" align="center" label="类型">
          <template slot-scope="scope">
              <span>{{scope.row.code_type==1?'普通码':"小程序码"}}</span>
          </template>
      </el-table-column>
      <el-table-column prop="used_num" align="center" label="已启用数量" :formatter="used_num"></el-table-column>
      <el-table-column prop="create_time" align="center" show-overflow-tooltip label="生码时间"></el-table-column>
      <el-table-column prop="remark" align="center" label="备注说明" show-overflow-tooltip></el-table-column>
      <el-table-column prop="product_name" align="center" label="关联产品">
          <template slot-scope="scope">
              <span v-if="scope.row.is_rel==0">未关联</span>
              <span class="rel-product" @click="handleMoreProduct(scope.row)" v-if="scope.row.is_rel==1&&!scope.row.rel_product_id">多产品</span>
              <span v-if="scope.row.is_rel==1&&scope.row.rel_product_id">{{scope.row.rel_product_name}}</span>
          </template>
      </el-table-column>
       <el-table-column label="操作" align="center" fixed="right" width="200px">
        <template slot-scope="scope">
          <el-button
            size="mini"
            type="text"
            @click="handleRel(scope.row)">关联产品</el-button>
            <el-button
            size="mini"
            type="text"
            @click="handleSet(scope.row)">启用</el-button>
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
    <!-- 物流码明细 -->
    <el-dialog title="物流码明细" :visible.sync="logisticsDialog" width="40%" class="logistics">
        <div><span>物流码类型：</span>{{logisticsCodeInfo.rel_logistics_code_order==1?'先关联':'后关联'}}</div>
        <div><span>包装类型：</span>{{packing_type}}</div>
        <div><span>规格：</span>{{specifications}}</div>
        <div><span>物流码明细：</span>{{logistics_code_detail}}</div>
    </el-dialog>
    <!-- 双奖模式明细 -->
    <el-dialog title="双奖模式" :visible.sync="prizeDialog" width="30%" class="prizeDialog">
        <div class="prize-box">
            <div class="prize-box-left">
                领奖顺序
            </div>
            <div class="prize-box-right">
                <div class="prize-box-right-top">
                    {{dislof_prize_order}}
                </div>
                <div class="prize-box-right-bottom">
                    {{prize_order_des}}
                </div>
            </div>
        </div>
    </el-dialog>
    <!-- 生码提示 -->
    <el-dialog title="生码说明" :visible.sync="createDialog" width="40%">
        <div>尊敬的用户，请您联系业务经理或客服生码，谢谢！</div>
    </el-dialog>
    <!-- 启用管理 -->
    <el-dialog title="启用管理" :visible.sync="setDialog" width="50%" @close="setDialog=false">
        <el-tabs v-model="activeName" type="card">
            <el-tab-pane label="全部启用" name="all">
                <el-form ref="setForm" :model="setForm" label-width="100px">
                    <el-form-item label="全部启用：">
                        <el-radio-group v-model="setForm.status">
                        <el-radio label="1">是</el-radio>
                        <el-radio label="2">否</el-radio>
                        </el-radio-group>
                    </el-form-item>
                    <el-form-item>
                        <el-button type="primary" size="small" @click="saveEnableStatus">保存</el-button>
                    </el-form-item>
                </el-form>
            </el-tab-pane>
            <el-tab-pane label="部分启用" name="part">
                <el-form ref="setForm" :model="setForm" label-width="130px" size="small" :rules="setRules">
                    <el-form-item label="起始二维码编号:"  prop="start_code">
                        <el-input style="width:80%" @change="start_code" v-model="setForm.start_code" />
                    </el-form-item>
                    <el-form-item label="截止二维码编号:" prop="end_code">
                        <el-input style="width:80%" @change="end_code" v-model="setForm.end_code" />
                    </el-form-item>
                    <el-form-item label="数量:"  prop="quantity">
                        <el-input style="width:80%" readonly="" v-model.number="setForm.quantity" />
                    </el-form-item>
                    <el-form-item label="备注:" prop="remark">
                        <el-input style="width:80%" v-model="setForm.remark" />
                    </el-form-item>
                    <el-form-item>
                        <el-button type="primary" size="small" @click="addEnableLog">添加到启用记录</el-button>
                    </el-form-item>
                </el-form>
                <!-- 启用记录表单 -->
                <el-table
                    :data="enableLog"
                    :header-cell-style="{background:'#FAFAFA',color:'#606266',height:'50px'}"
                    border
                    stripe
                    size="medium"
                    class="trace-table"
                    style="width: 100%">
                     <el-table-column prop="id" align="center" label="序号"></el-table-column>
                     <el-table-column prop="" align="center" label="启用区间">
                         <template slot-scope="scope">
                             <span>{{scope.row.start_code}}-{{scope.row.end_code}}</span>
                         </template>
                     </el-table-column>
                     <el-table-column prop="quantity" align="center" label="数量"></el-table-column>
                     <el-table-column prop="remark" align="center" label="备注说明"></el-table-column>
                     <el-table-column prop="create_time" align="center" label="添加时间"></el-table-column>
                     <el-table-column label="操作" align="center" fixed="right" width="100px">
                        <template slot-scope="scope">
                            <el-button
                            size="mini"
                            type="danger"
                            @click="handleDele(scope.row)">删除</el-button>
                        </template>
                    </el-table-column>
                </el-table>
                <pagination
                    v-show="+enableTotal>10"
                    :total="+enableTotal"
                    :page.sync="queryEnableForm.pageNum"
                    :limit.sync="queryEnableForm.pageSize"
                    @pagination="getEnableCodes"
                />
            </el-tab-pane>
        </el-tabs>
    </el-dialog>
    <!-- 关联产品 -->
    <el-dialog title="关联产品" :visible.sync="relDialog" width="50%" @close="relDialog=false">
        <el-tabs type="card" v-model="relTab" @tab-click="handleClick">
            <el-tab-pane label="全部关联到一个产品" name="all">
               <el-form :model="relAllForm" v-if="relTab=='all'" ref="relAllForm" label-width="100px" :rules="relAllRule" size="medium">
                    <el-form-item label="产品选择" prop="product_name">
                        <el-input style="width:90%" @focus="selectProduct('all')" v-model="relAllForm.product_name" placeholder="请选择关联产品"/>
                    </el-form-item>
                    <el-form-item label="备注:" prop="remark">
                        <el-input style="width:90%" v-model="relAllForm.remark" />
                    </el-form-item>
                    <el-form-item>
                        <el-button type="primary" size="small" @click="saveAllProductRel">保存</el-button>
                        <el-button type="danger" size="small" @click="removeProductRel">清除关联</el-button>
                    </el-form-item>
               </el-form> 
            </el-tab-pane>
            <el-tab-pane label="关联到不同产品" name="part">
                <el-form :model="relPartForm" v-if="relTab=='part'" ref="relPartForm" label-width="130px" :rules="relRule" size="medium">
                    <el-form-item label="产品选择" prop="product_name">
                        <el-input style="width:80%" @focus="selectProduct('part')" v-model="relPartForm.product_name" placeholder="请选择关联产品"/>
                    </el-form-item>
                    <el-form-item label="起始二维码编号:"  prop="start_code">
                        <el-input style="width:80%" @change="part_start_code" v-model="relPartForm.start_code" />
                    </el-form-item>
                    <el-form-item label="截止二维码编号:" prop="end_code">
                        <el-input style="width:80%" @change="part_end_code" v-model="relPartForm.end_code" />
                    </el-form-item>
                    <el-form-item label="数量:"  prop="quantity">
                        <el-input style="width:80%" readonly="" v-model.number="relPartForm.quantity" />
                    </el-form-item>
                    <el-form-item label="备注:" prop="remark">
                        <el-input style="width:80%" v-model="relPartForm.remark" />
                    </el-form-item>
                    <el-form-item>
                        <el-button type="primary" size="small" @click="saveProductRel">添加到关联记录</el-button>
                    </el-form-item>
                </el-form>
                <!-- 关联记录 -->
                <el-table
                    :data="relProductData"
                    :header-cell-style="{background:'#FAFAFA',color:'#606266',height:'50px'}"
                    border
                    stripe
                    size="medium"
                    class="trace-table"
                    style="width: 100%">
                    <el-table-column prop="id" align="center" label="序号"></el-table-column>
                    <el-table-column prop="id" align="center" label="关联区间">
                        <template slot-scope="scope">
                            <span>{{scope.row.start_code}}-{{scope.row.end_code}}</span>
                        </template>
                    </el-table-column>
                    <el-table-column prop="quantity" align="center" label="数量"></el-table-column>
                    <el-table-column prop="product_name" align="center" label="产品名称"></el-table-column>
                    <el-table-column prop="remark" align="center" label="备注说明"></el-table-column>
                    <el-table-column prop="create_time" align="center" label="添加时间"></el-table-column>
                    <el-table-column label="操作" align="center" fixed="right" width="100px">
                        <template slot-scope="scope">
                            <el-button
                            size="mini"
                            type="danger"
                            @click="handleDeleRel(scope.row)">删除</el-button>
                        </template>
                    </el-table-column>
                </el-table>
                <pagination
                    v-show="+relProductTotal>10"
                    :total="+relProductTotal"
                    :page.sync="queryRelProductFrom.pageNum"
                    :limit.sync="queryRelProductFrom.pageSize"
                    @pagination="getRelProduct"
                />
            </el-tab-pane>
        </el-tabs>
        <!-- 选择产品表格 -->
        <el-dialog
          width="50%"
          title="选择产品"
          :visible.sync="productDialog"
          append-to-body>
          <el-form ref="queryProductForm" :model="queryProductForm" label-width="100px" :inline="true" size="small">
            <el-form-item label="产品名称" prop="product_name">
              <el-input style="width:240px" v-model="queryProductForm.product_name" placeholder="请输入产品名称"></el-input>
            </el-form-item>
            <el-form-item > 
              <el-button type="primary" icon="el-icon-search" @click="queryProduct">查询</el-button>
              <el-button icon="el-icon-refresh" @click="resetProductQuery('queryProductForm')">重置</el-button>
            </el-form-item>
          </el-form>
          <el-table
            :data="productData"
            :header-cell-style="{background:'#FAFAFA',color:'#606266',height:'50px'}"
            border
            stripe
            size="small"
            class="trace-table"
            style="width: 100%">
            <el-table-column prop="id" align="center" label="产品编号" ></el-table-column>
            <el-table-column prop="product_name" align="center" label="产品名称" ></el-table-column>
            <el-table-column label="操作" align="center" width="200px">
              <template slot-scope="scope">
                <el-button
                  size="mini"
                  type="primary"
                  @click="handleSelectProduct(scope.row)">选择</el-button>
              </template>
            </el-table-column>
          </el-table>
          <pagination
            v-show="+productTotal>10"
            :total="+productTotal"
            :page.sync="queryProductForm.pageNum"
            :limit.sync="queryProductForm.pageSize"
            @pagination="getProduct"
        />
        </el-dialog>
    </el-dialog>
    <!-- 查看多产品关联 -->
    <el-dialog title="关联产品" :visible.sync="viewRelDialog" width="50%" @close="viewRelDialog=false">
         <el-table
            :data="relProductData"
            :header-cell-style="{background:'#FAFAFA',color:'#606266',height:'50px'}"
            border
            stripe
            size="medium"
            class="trace-table"
            style="width: 100%">
            <el-table-column prop="id" align="center" label="序号"></el-table-column>
            <el-table-column prop="id" align="center" label="关联区间">
                <template slot-scope="scope">
                    <span>{{scope.row.start_code}}-{{scope.row.end_code}}</span>
                </template>
            </el-table-column>
            <el-table-column prop="quantity" align="center" label="数量"></el-table-column>
            <el-table-column prop="product_name" align="center" label="产品名称"></el-table-column>
            <el-table-column prop="remark" align="center" label="备注说明"></el-table-column>
            <el-table-column prop="create_time" align="center" label="添加时间"></el-table-column>
        </el-table>
            <pagination
                v-show="+relProductTotal>10"
                :total="+relProductTotal"
                :page.sync="queryRelProductFrom.pageNum"
                :limit.sync="queryRelProductFrom.pageSize"
                @pagination="getRelProduct"
            />
    </el-dialog>
  </div>
</template>
<script>
import {listCode,
getEnableCodes,
saveEnableStatus,
addEnableLog,
deleEnableLog,
getRelProduct,
addRelLog,
getProduct,
deleRelLog,
removeProductRel
} from '@/api/codeStore/qrcode'
export default {
    data(){
        return{
            code_num:0,
            total:0,
            productTotal:0,
            queryForm:{
                product:'',
                type:'',
                scene:'',
                mark:'',
                pageNum:1,
                pageSize:10,
            },
            relTab:'all',
            activeName:'all',
            bacthInfo:{},
            queryEnableForm:{
                pageNum:1,
                pageSize:10,
                batch:undefined,//批次唯一
                id:undefined,//批次id唯一
                partner_id:undefined
            },
            queryRelProductFrom:{
                pageNum:1,
                pageSize:10
            },
            relPartForm:{
                product_id:'',
                product_name:'',
                start_code:'',
                end_code:'',
                quantity:'',
                remark:''
            },
            queryProductForm:{
                product_name:'',
                dealer_id:'',
                pageNum:1,
                pageSize:10
            },
            setForm:{
                status:'1',
                start_code:'',
                end_code:'',
                quantity:'',
                remark:''
            },
            relAllForm:{
                product_id:'',
                product_name:'',
                remark:''
            },
            setRules:{
                start_code:[
                    { required: true, message: "请输入起始二维码编号", trigger: "blur" }
                ],
                end_code:[
                    { required: true, message: "请输入截止二维码编号", trigger: "blur" }
                ],
                quantity:[
                    { required: true, message: "请输入启用二维码数量", trigger: "blur" },
                    { type: 'number', message: '数量必须为数字值'}
                ],
                remark:[
                    { required: true, message: "请输入备注", trigger: "blur" }
                ],
            },
            relAllRule:{
                product_name:[
                    { required: true, message: "请输入产品名称", trigger: "blur" }
                ],
                remark:[
                    { required: true, message: "请输入备注", trigger: "blur" }
                ]
            },
            relRule:{
                start_code:[
                    { required: true, message: "请输入起始二维码编号", trigger: "blur" }
                ],
                end_code:[
                    { required: true, message: "请输入截止二维码编号", trigger: "blur" }
                ],
                product_name:[
                    { required: true, message: "请输入产品名称", trigger: "blur" }
                ],
                quantity:[
                    { required: true, message: "请输入关联二维码数量", trigger: "blur" },
                    { type: 'number', message: '数量必须为数字值'}
                ],
                remark:[
                    { required: true, message: "请输入备注", trigger: "blur" }
                ]
            },
            enableTotal:0,
            relProductTotal:0,
            enableLog:[],
            tableData:[],
            productData:[],
            relProductData:[],
            prizeOrderOptions:[],
            dislof_prize_order:'',
            prize_order_des:'',
            logisticsCodeInfo:{},
            viewRelDialog:false,
            relDialog:false,
            productDialog:false,
            prizeDialog:false,
            setDialog:false,
            createDialog:false,
            logisticsDialog:false,
            codeTypeOptions:[],
            sceneOptions:[]
        }
    },
    created(){
        this.getDicts({type:'guide_prize_order'}).then(res=>{
            this.prizeOrderOptions=res.data
        })
        this.getDicts({type:'code_scene'}).then(res=>{
            this.sceneOptions=res.data
        })
        this.getDicts({type:'code_type'}).then(res=>{
            this.codeTypeOptions=res.data
        })
        this.getList()
    },
    computed:{
        scene(){
            return function(value){
                return this.sceneOptions.filter(item=>value.split(',').includes(item.dict_value))
            }
        },
        //包装类型
        packing_type:function(){
            if(this.logisticsCodeInfo.rel_logistics_code_order==2) return '--'
            if(this.logisticsCodeInfo.rel_logistics_code_order==1){
                var level=JSON.parse(this.logisticsCodeInfo.logistics_level_item).length
                return `${+level+1}级包装`
            }
        },
        //包装规格
        specifications:function(){
            if(this.logisticsCodeInfo.rel_logistics_code_order==2) return '--'
            if(this.logisticsCodeInfo.rel_logistics_code_order==1){
                var scale=JSON.parse(this.logisticsCodeInfo.logistics_level_item)
                var text=scale.map(item=>`拖${item.num}`)
                return `1${text.join('')}`
            }
        },
        //物流码明细
        logistics_code_detail:function(){
            console.log(this.logisticsCodeInfo)
            var arr=this.logisticsCodeInfo.secret_key
            if(!arr) return '-'
            var text='大码：'
            if(arr.length==0){
                return `${this.logisticsCodeInfo.order_begin}--${this.logisticsCodeInfo.order_end}`
            }else{
                if(arr.length==1) text='小码：'
               arr.forEach((item,index)=>{
                   text+=item.order+'\n'+(index==arr.length-1?'':'小码：')
               })
               return text
            } 

        }
    },
    methods:{
        getList(){
            var arr=Object.assign({},this.queryForm)
            listCode(arr).then(res=>{
              this.total=res.total
              this.tableData=res.data
              this.code_num=res.sum
            })
        },
        //已启用数量
        used_num(row){
            if(row.status==0) return 0;
            if(row.status==1) return row.count
            if(row.status==2) return row.used_num
        },
        handleGlobalRel(){

        },
        //触发产品关联
        handleRel(row){
            this.bacthInfo=row
            this.queryRelProductFrom.pageNum=1
            this.queryRelProductFrom.batch=row.batch
            this.queryRelProductFrom.dealer_id=row.dealer_id
            this.queryRelProductFrom.partner_id=row.partner_id
            this.relPartForm.product_id=''
            this.relPartForm.product_name=''
            this.relPartForm.remark=''
            this.relPartForm.start_code=''
            this.relPartForm.end_code=''
            this.relPartForm.quantity=''
            this.relTab='all'
            this.getRelProduct()
            this.relDialog=true
        },
        handleClick(){
            this.getRelProduct()
        },
        getRelProduct(){
            getRelProduct(this.queryRelProductFrom).then(res=>{
                if(res.total==1&&res.data[0]['is_rel_all']==1){
                    this.relProductData=[]
                    this.relProductTotal=0
                    this.relAllForm.product_name=res.data[0]['product_name']
                    this.relAllForm.product_id=res.data[0]['product_id']
                    this.relAllForm.remark=res.data[0]['remark']
                    this.relAllForm.batch=res.data[0].batch
                }else{
                    this.relProductData=res.data
                    this.relProductTotal=res.total
                    this.rel_count=res.rel_count
                    this.relAllForm.product_name=''
                    this.relAllForm.product_id=''
                    this.relAllForm.remark=''
                    this.relAllForm.batch=''
                }
            })
        },
        getProduct(){
            getProduct(this.queryProductForm).then(res=>{
                this.productData=res.data[0]
                this.productTotal=res.data[1]
            })
        },
        queryProduct(){
            this.queryProductForm.pageNum=1
            this.getProduct()
        },
        removeProductRel(){
            this.$confirm(`确认要清除关联吗?`, '提示', {
                confirmButtonText: '确定',
                cancelButtonText: '取消',
                type: 'warning'
            }).then(() => {
                 removeProductRel({'batch':this.bacthInfo.batch}).then(res=>{
                    if(res.code==200){
                        this.$message.success(res.msg)
                        this.relDialog=false
                        this.getList()
                    }else{
                        this.$message.error(res.msg)
                    }
                 })
            }).catch(() => {});
        },
        handleDeleRel(row){
            this.$confirm(`是否删除该关联记录。确认删除?`, '提示', {
                confirmButtonText: '确定',
                cancelButtonText: '取消',
                type: 'warning'
            }).then(() => {
                 deleRelLog(row).then(res=>{
                    if(res.code==200){
                        this.$message.success(res.msg)
                        this.getRelProduct()
                    }else{
                        this.$message.error(res.msg)
                    }
                 })
            }).catch(() => {});
        },
        selectProduct(attr){
            this.queryProductForm.pageNum=1
            this.queryProductForm.product_name=''
            this.queryProductForm.dealer_id=this.bacthInfo.dealer_id
            this.queryProductForm.attr=attr
            this.getProduct()
            this.productDialog=true
            this.$forceUpdate()
        },
        start_code(val){
            if(val&&this.setForm.end_code){
                if(parseInt(this.setForm.end_code)<=parseInt(val)){
                    this.$message.warning('请检查激活区间')
                    this.setForm.quantity=''
                    return;
                }else{
                    this.setForm.quantity=parseInt(this.setForm.end_code)-parseInt(val)+1
                }
            }else{
                return;
            }
        },
        end_code(val){
            if(val&&this.setForm.start_code){
                if(parseInt(this.setForm.start_code)>=parseInt(val)){
                    this.$message.warning('请检查激活区间')
                    this.setForm.quantity=''
                    return;
                }else{
                    this.setForm.quantity=parseInt(val)-parseInt(this.setForm.start_code)+1
                }
            }else{
                return;
            }
        },
        part_start_code(val){
            if(val&&this.relPartForm.end_code){
                if(parseInt(this.relPartForm.end_code)<=parseInt(val)){
                    this.$message.warning('请检查激活区间')
                    this.relPartForm.quantity=''
                    return;
                }else{
                    this.relPartForm.quantity=parseInt(this.relPartForm.end_code)-parseInt(val)+1
                }
            }else{
                return;
            }
        },
        part_end_code(val){
            if(val&&this.relPartForm.start_code){
                if(parseInt(this.relPartForm.start_code)>=parseInt(val)){
                    this.$message.warning('请检查激活区间')
                    this.relPartForm.quantity=''
                    return;
                }else{
                    this.relPartForm.quantity=parseInt(val)-parseInt(this.relPartForm.start_code)+1
                }
            }else{
                return;
            }
        },
        createCode(){
            this.createDialog=true
        },
        handleViewDes(row,item){
            if(item.dict_value==4){
                this.logisticsDialog=true
                this.logisticsCodeInfo=row
            }
            //导购码 双奖模式
            if(item.dict_value==3&&row.prize==2){
                this.prizeDialog=true
                var ob=this.prizeOrderOptions.filter(item=>item.dict_value==row.prize_order)
                this.dislof_prize_order=ob.map(item=>item.dict_label)[0]
                this.prize_order_des=ob.map(item=>item.remark)[0]
            }
        },
        handleDele(row){
            this.$confirm(`若删除，该批次码段将不可用。确认删除?`, '提示', {
                confirmButtonText: '确定',
                cancelButtonText: '取消',
                type: 'warning'
            }).then(() => {
                 deleEnableLog(row).then(res=>{
                    if(res.code==200){
                        this.$message.success(res.msg)
                        this.getEnableCodes()
                        this.getList()
                    }else{
                        this.$message.error(res.msg)
                    }
                 })
            }).catch(() => {});
        },
        handleMoreProduct(row){
            this.queryRelProductFrom.pageNum=1
            this.queryRelProductFrom.batch=row.batch
            this.queryRelProductFrom.dealer_id=row.dealer_id
            this.queryRelProductFrom.partner_id=row.partner_id
            this.getRelProduct()
            this.viewRelDialog=true
        },
        //选中某商品
        handleSelectProduct(row){
            if(this.queryProductForm.attr=='all'){
                this.relAllForm.product_name=row.product_name
                this.relAllForm.product_id=row.id
            }else{
                this.relPartForm.product_id=row.id
                this.relPartForm.product_name=row.product_name
            }
            this.productDialog=false
        },
         //保存产品关联
        saveProductRel(){
            this.relPartForm.batch=this.queryRelProductFrom.batch
            this.relPartForm.dealer_id=this.queryRelProductFrom.dealer_id
            this.relPartForm.partner_id=this.queryRelProductFrom.partner_id
            this.relPartForm.tab=this.relTab;
            var arr=Object.assign({},this.relPartForm)
            this.$refs["relPartForm"].validate(valid => {
                if(valid){
                    if(this.relPartForm.quantity<=0){
                        this.$message.warning('关联码段数量须大于0')
                        return;
                    }
                    if(this.relPartForm.quantity*1+this.rel_count*1>this.bacthInfo.count*1){
                        this.$message.warning('关联码段总数量不得大于该批次数码数量')
                        return;
                    }
                    arr.order_begin=this.bacthInfo.order_begin
                    arr.order_end=this.bacthInfo.order_end
                    addRelLog(arr).then(res=>{
                        if(res.code==200){
                            this.$message.success(res.msg)
                            this.relDialog=false
                            this.getList()
                        }else{
                            this.$message.error(res.msg)
                        }
                    })
                }
            })
        },
        saveAllProductRel(){
            this.relAllForm.batch=this.queryRelProductFrom.batch
            this.relAllForm.dealer_id=this.queryRelProductFrom.dealer_id
            this.relAllForm.partner_id=this.queryRelProductFrom.partner_id
            this.relAllForm.tab=this.relTab;
            var arr=Object.assign({},this.relAllForm)
            this.$refs["relAllForm"].validate(valid => {
                if(valid){
                    arr.order_begin=this.bacthInfo.order_begin
                    arr.order_end=this.bacthInfo.order_end
                    arr.quantity=this.bacthInfo.count
                    addRelLog(arr).then(res=>{
                        if(res.code==200){
                            this.$message.success(res.msg)
                            this.relDialog=false
                            this.getList()
                        }else{
                            this.$message.error(res.msg)
                        }
                    })
                }
            })
        },
        handleSet(row){
            this.queryEnableForm.dealer_id=row.dealer_id
            this.queryEnableForm.partner_id=row.partner_id
            this.queryEnableForm.batch=row.batch
            this.queryEnableForm.id=row.id
            this.bacthInfo=row
            this.setForm={
                start_code:'',
                end_code:'',
                quantity:'',
                remark:'',
                status:String(row.status)
            }
            this.getEnableCodes()
            this.setDialog=true
        },
        getEnableCodes(){
            getEnableCodes(this.queryEnableForm).then(res=>{
                this.enableTotal=res.total
                this.enableLog=res.data
            })
        },
        addEnableLog(){
            this.setForm.batch=this.queryEnableForm.batch
            this.setForm.dealer_id=this.queryEnableForm.dealer_id
            this.setForm.partner_id=this.queryEnableForm.partner_id
            var arr=Object.assign({},this.setForm)
            this.$refs["setForm"].validate(valid => {
                if(valid){
                    if(this.setForm.quantity<=0){
                        this.$message.warning('启用码段数量须大于0')
                        return;
                    }
                    if(this.setForm.quantity*1+this.bacthInfo.used_num*1>this.bacthInfo.count*1){
                        this.$message.warning('启用码段数量不得大于该批次数码数量')
                        return;
                    }
                    addEnableLog(arr).then(res=>{
                        if(res.code==200){
                            this.$message.success(res.msg)
                            this.setDialog=false
                            this.getList()
                        }else{
                            this.$message.error(res.msg)
                        }
                    })
                }
            })
        },
        saveEnableStatus(){
            var params={
                status:this.setForm.status,
                id:this.queryEnableForm.id
            }
            saveEnableStatus(params).then(res=>{
                if(res.code==200){
                    this.$message.success(res.msg)
                    this.setDialog=false
                    this.getList()
                }else{
                    this.$message.error(res.msg)
                }
            })
        },
        resetProductQuery(formName){
            this.$refs[formName].resetFields();
            this.queryProduct()
        },
        query(){
          this.queryForm.pageNum = 1;
          this.getList();
        },
        reset(formName){
            this.$refs[formName].resetFields();
            this.query()
        },
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
.rel-product,.active{
    color: #409EFF;
    cursor: pointer;
}
.logistics{
    div{
        margin: 10px 0;
        padding: 10px;
        box-sizing: border-box;
        display: flex;
        align-items: center;
        border: 1px solid #eeeeee;
        span{
            width: 100px;
            display: inline-block;
            height: 20px;
            line-height: 20px;
            margin-right: 15px;
            text-align: left;
            border-right: 1px solid #eeeeee;
        }
    }
}
.prizeDialog{
    .prize-box{
        width: 100%;
        min-height:200px;
        display: flex;
        justify-content: space-between;
        align-items: center;
        flex-direction: row;
        border:1px solid #eeeeee;
        .prize-box-left{
            width: 30%;
            height: 200px;
            display: flex;
            padding: 10px;
            justify-content: flex-start;
            align-items: center;
            border-right: 1px solid #eeeeee;
        }
        .prize-box-right{
            width: 70%;
            height: 200px;
            display: flex;
            justify-content: flex-start;
            align-items: center;
            flex-direction: column;
            .prize-box-right-top{
                width: 100%;
                height: 30%;
                display: flex;
                padding: 10px;
                justify-content: flex-start;
                align-items: center;
                border-bottom: 1px solid #eeeeee;
            }
            .prize-box-right-bottom{
                width: 100%;
                height: 70%;
                display: flex;
                padding: 10px;
                justify-content: flex-start;
                align-items: center;
            }
        }
    }
}
</style>