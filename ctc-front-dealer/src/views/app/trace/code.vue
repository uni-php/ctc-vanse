<template>
  <div class="app-container">
    <div class="tips">
        <p>此功能可以将溯源二维码跟某个生产批次号进行关联绑定，扫码查询页面通过关联信息显示对应批次信息。可按批次/流水号范围绑定批次信息；同一个二维码可以重复设置在不同的赋码类型（批次/流水号）中，但系统会根据优先级调用最终的批次信息；优先级：流水号范围>批次</p>
    </div>
    <div class="tab-bar">
        <el-form ref="queryForm" :model="queryForm" label-width="100px" :inline="true" size="small">
            <el-form-item label="添加时间" prop="time">
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
            <el-form-item label="生产批次" prop="product_batch">
                <el-input style="width:220px" v-model="queryForm.product_batch" placeholder="请输入生产批次"></el-input>
            </el-form-item>
            <el-form-item label="码批次" prop="code_batch">
                <el-select style="width:220px" size="small" v-model="queryForm.code_batch" placeholder="请选择码批次">
                   <el-option
                        v-for="item in codeBatchOptions"
                        :key="item.id"
                        :label="item.batch+'--'+'('+item.order_begin+'~'+item.order_end+')'"
                        :value="item.batch">
                    </el-option>
                </el-select>
            </el-form-item>
            <el-form-item label="产品名称" prop="product_name">
                <el-input style="width:220px" v-model="queryForm.product_name" placeholder="请输入产品名称"></el-input>
            </el-form-item>
            <el-form-item label="流水号" prop="serial_number">
                <el-input style="width:220px" v-model="queryForm.serial_number" placeholder="请输入流水号"></el-input>
            </el-form-item>
            <el-form-item > 
                <el-button type="primary" icon="el-icon-search" @click="query">查询</el-button>
                <el-button icon="el-icon-refresh" @click="reset('queryForm')">重置</el-button>
            </el-form-item> 
        </el-form>
    </div>
        <el-col :span="24" style="margin:10px 0;">
            <el-button @click="addBatch" type="primary" size="small" >添加赋码批次</el-button>
        </el-col>
        <el-table
        :data="tableData"
        :header-cell-style="{background:'#FAFAFA',color:'#606266',height:'50px'}"
        border
        stripe
        size="medium"
        class="trace-table"
        style="width: 100%">
            <el-table-column prop="code_batch" align="center" label="码批次"></el-table-column>
            <el-table-column prop="number" align="center" label="流水号范围">
                <template slot-scope="scope">
                    <span>{{scope.row.order_begin}} - {{scope.row.order_end}}</span>
                </template>
            </el-table-column>
            <el-table-column prop="product_batch" align="center" label="生产批次"></el-table-column>
            <el-table-column prop="product_name" align="center" label="产品名称"></el-table-column>
            <el-table-column prop="create_time" align="center" label="添加时间"></el-table-column>
            <el-table-column label="操作" align="center" fixed="right" width="150px">
                <template slot-scope="scope">
                    <el-button
                        size="mini"
                        type="danger"
                        @click="handleDele(scope.row)"
                        >删除</el-button>
                </template>
            </el-table-column>
        </el-table>
        <pagination
        v-show="+total>10"
        :total="+total"
        :page.sync="queryForm.pageNum"
        :limit.sync="queryForm.pageSize"
        @pagination="getList"/>
        <!-- 添加赋码批次 -->
        <el-dialog title="赋码批次" class="codeDialog" :visible.sync="codeDialog" width="40%" @close="codeDialog=false">
            <el-form ref="codeForm" :model="codeForm" label-width="120px" :rules="rule" size="small">
                <el-form-item label="可选码批次" prop="code_batch">
                    <el-select style="width:80%" size="small" v-model="codeForm.code_batch" placeholder="请选择码批次">
                        <el-option
                            v-for="item in codeBatchOptions"
                            :key="item.id"
                            :label="item.batch+'--'+'('+item.order_begin+'~'+item.order_end+')'"
                            :value="item.batch">
                        </el-option>
                    </el-select>
                </el-form-item>
                <el-form-item label="设置流水号" prop="is_serial_number">
                    <el-checkbox v-model="codeForm.is_serial_number">按流水号区间设置</el-checkbox>
                </el-form-item>
                <el-form-item prop="order_begin" label="起始流水号" v-if="codeForm.is_serial_number" >
                    <el-input style="width:80%" @change="start_code"  v-model="codeForm.order_begin" placeholder="请输入起始流水号"/>
                </el-form-item>
                <el-form-item prop="order_end" label="终止流水号" v-if="codeForm.is_serial_number" >
                    <el-input style="width:80%" @change="end_code"  v-model="codeForm.order_end" placeholder="请输入终止流水号"/>
                </el-form-item>
                <el-form-item prop="quantity" label="区间数量" v-if="codeForm.is_serial_number">
                    <el-input style="width:80%" readonly=""  v-model="codeForm.quantity" placeholder="区间数量"/>
                </el-form-item>
                <el-form-item prop="product_batch" label="关联生产批次" >
                    <el-input style="width:80%" @focus="clickProductBatch" v-model="codeForm.product_batch" placeholder="请选择生产批次"/>
                </el-form-item>
            </el-form>
            <div slot="footer" class="dialog-footer">
                <el-button type="primary" @click="submitForm">保 存</el-button>
                <el-button @click="codeDialog=false">取 消</el-button>
            </div>
        </el-dialog>
        <!-- 关联生产批次 -->
        <el-dialog title="生产批次" class="batchDialog" :visible.sync="batchDialog" width="50%" @close="batchDialog=false">
            <el-form ref="queryBatchForm" :model="queryBatchForm" label-width="100px" :inline="true" size="small">
                <el-form-item label="关键词" prop="keywords">
                    <el-input style="width:220px" v-model="queryBatchForm.keywords" placeholder="生产批次号、产品名称、批次备注"></el-input>
                </el-form-item>
                <el-form-item > 
                    <el-button type="primary" icon="el-icon-search" @click="queryBatch">查询</el-button>
                    <el-button icon="el-icon-refresh" @click="resetBatch('queryBatchForm')">重置</el-button>
                </el-form-item> 
            </el-form>
             <el-table
                :data="productBatchList"
                :header-cell-style="{background:'#FAFAFA',color:'#606266',height:'50px'}"
                border
                stripe
                size="medium"
                class="trace-table"
                style="width: 100%">
                <el-table-column prop="product_batch" align="center" label="生产批次号"></el-table-column>
                <el-table-column prop="code" align="center" label="产品编号"></el-table-column>
                <el-table-column prop="product_name" align="center" label="产品名称"></el-table-column>
                <el-table-column prop="remark" align="center" label="批次备注"></el-table-column>
                <el-table-column label="操作" align="center" fixed="right" width="120px">
                    <template slot-scope="scope">
                        <el-button
                            size="mini"
                            type="primary"
                            @click="handleSelect(scope.row)"
                            >选择</el-button>
                    </template>
                </el-table-column>
             </el-table>
             <pagination
                v-show="+totals>10"
                :total="+totals"
                :page.sync="queryBatchForm.pageNum"
                :limit.sync="queryBatchForm.pageSize"
                @pagination="getProductBatchList"/>
        </el-dialog>
  </div>
</template>

<script>
import {getTraceCodeBatch} from '@/api/codeStore/qrcode'
import {saveCodebBatch,getCodeBatchList,deleCodeBatch,getProductBatchList} from '@/api/app/trace'
export default {
    data(){
        return{
            batchDialog:false,
            queryForm:{
                time:[],
                product_batch:'',
                code_batch:'',
                product_name:'',
                serial_number:'',
                pageNum:1,
                pageSize:10
            },
            codeForm:{
                code_batch:'',
                is_serial_number:false,
                quantity:0,
                order_begin:'',
                order_end:'',
                product_batch:''//唯一
            },
            codeDialog:false,
            codeBatchOptions:[],
            tableData:[],
            productBatchList:[],
            total:0,
            totals:0,
            queryBatchForm:{
                time:[],
                keywords:'',
                pageNum:1,
                pageSize:10
            },
            rule:{
                code_batch:[
                    { required: true, message: "请选择码批次", trigger: "blur" },
                ],
                order_begin:[
                    { required: true, message: "请输入起始流水号", trigger: "blur" },
                ],
                order_end:[
                    { required: true, message: "请输入终止流水号", trigger: "blur" },
                ],
                product_batch:[
                    { required: true, message: "请选择生产批次", trigger: "blur" },
                ]
            }
        }
    },
    created(){
        this.getList()
        this.getTraceCodeBatch()
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
            getCodeBatchList(params).then(res=>{
                this.tableData=res.data
                this.total=res.total
            })
        },
        getTraceCodeBatch(){
            getTraceCodeBatch({}).then(res=>{
               this.codeBatchOptions=res.data 
            })
        },
        addBatch(){
            this.codeForm={
                code_batch:'',
                is_serial_number:false,
                quantity:0,
                order_begin:'',
                order_end:'',
                product_batch:''//唯一
            }
            this.codeDialog=true
        },
        handleSelect(row){
            this.codeForm.product_batch=row.product_batch
            this.batchDialog=false
        },
        handleEdit(row){

        },
        handleDele(row){
            this.$confirm(`删除数据不可恢复，是否确认要删除`, '提示', {
                confirmButtonText: '确定',
                cancelButtonText: '取消',
                type: 'warning'
            }).then(() => {
                deleCodeBatch({id:row.id}).then(res=>{
                    if(res.code==200){
                        this.$message.success(res.msg)
                        this.getList()
                    }else{
                        this.$message.error(res.msg)
                    }
                 })
            }).catch(() => {});
        },
        clickProductBatch(){
            this.getProductBatchList()
            this.batchDialog=true
        },
        async getProductBatchList(){
            var params=Object.assign({},this.queryBatchForm)
            if(!this.queryBatchForm.time||this.queryBatchForm.time.length==0){
                params.startTime=''
                params.endTime=''
            }else{
                params.startTime=this.queryBatchForm.time[0]
                params.endTime=this.queryBatchForm.time[1]
            }
            delete params.time
            await getProductBatchList(params).then(res=>{
                this.productBatchList=res.data
                this.totals=res.total
            })
        },
        submitForm(){
            this.$refs["codeForm"].validate(valid => {
                if(valid){
                    console.log(this.codeForm)
                    if(this.codeForm.is_serial_number){
                        //检查赋码区间是否合理
                        var codeBatch=this.codeBatchOptions.filter(item=>item.batch==this.codeForm.code_batch)[0]
                        if(this.codeForm.order_begin*1>=codeBatch.order_begin*1&&this.codeForm.order_end*1<=codeBatch.order_end*1){
                            saveCodebBatch(this.codeForm).then(res=>{
                                if(res.code==200){
                                    this.$message.success(res.msg)
                                    this.codeDialog=false
                                    this.getList()
                                }else{
                                    this.$message.error(res.msg)
                                }
                            })
                        }else{
                            this.$message.warning('请检查赋码区间')
                        }
                    }else{
                        var arr=Object.assign({},this.codeForm)
                        var code_batch=this.codeBatchOptions.filter(item=>item.batch==this.codeForm.code_batch).[0]
                        arr.quantity=code_batch.order_end*1-code_batch.order_begin*1+1
                        saveCodebBatch(arr).then(res=>{
                            if(res.code==200){
                                this.$message.success(res.msg)
                                this.codeDialog=false
                                this.getList()
                            }else{
                                this.$message.error(res.msg)
                            }
                        })
                    }
                }
            })
        },
        start_code(val){
            if(val&&this.codeForm.order_end){
                if(parseInt(this.codeForm.order_end)<parseInt(val)){
                    this.$message.warning('请检查激活区间')
                    this.codeForm.quantity=''
                    this.codeForm.order_begin=''
                    return;
                }else{
                    this.codeForm.quantity=parseInt(this.codeForm.order_end)-parseInt(val)+1
                }
            }else{
                return;
            }
        },
        end_code(val){
            if(val&&this.codeForm.order_begin){
                if(parseInt(this.codeForm.order_begin)>parseInt(val)){
                    this.$message.warning('请检查激活区间')
                    this.codeForm.quantity=''
                    this.codeForm.order_end=''
                    return;
                }else{
                    this.codeForm.quantity=parseInt(val)-parseInt(this.codeForm.order_begin)+1
                }
            }else{
                return;
            }
        },
        queryBatch(){
          this.queryForm.pageNum = 1;
          this.getProductBatchList();
        },
        resetBatch(formName){
            this.$refs[formName].resetFields();
            this.queryBatch()
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
.dialog-footer{
  margin: 30px 0;
}
</style>