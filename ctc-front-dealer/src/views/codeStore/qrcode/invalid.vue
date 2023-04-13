<template>
  <div class="app-container">
    <div class="tab-bar">
        <el-form ref="queryForm" :model="queryForm" label-width="100px" :inline="true" size="small">
            <el-form-item label="时间" prop="time">
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
            <el-form-item label="批次" prop="batch">
                <el-input style="width:220px" v-model="queryForm.batch" placeholder="请输入生码批次"></el-input>
            </el-form-item>
            <el-form-item label="备注说明" prop="remark">
                <el-input style="width:220px" v-model="queryForm.remark" placeholder="请输入备注"></el-input>
            </el-form-item>
            <el-form-item > 
                <el-button type="primary" icon="el-icon-search" @click="query">查询</el-button>
                <el-button icon="el-icon-refresh" @click="reset('queryForm')">重置</el-button>
            </el-form-item> 
        </el-form>
    </div>
    <el-col :span="24" style="margin:10px 0;">
        <el-button type="primary" style="font-size:14px" size="mini" @click="invalid">作废</el-button>
    </el-col>
    <el-table
      :data="tableData"
      :header-cell-style="{background:'#FAFAFA',color:'#606266',height:'50px'}"
      border
      stripe
      size="medium"
      class="trace-table"
      style="width: 100%">
      <el-table-column prop="id" width="80px" align="center" label="编号"></el-table-column>
      <el-table-column prop="batch" align="center" show-overflow-tooltip="" label="批次"></el-table-column>
       <el-table-column prop="code_type" align="center" label="类型">
          <template slot-scope="scope">
              <span>{{scope.row.code_type==1?'普通码':"小程序码"}}</span>
          </template>
      </el-table-column>
      <el-table-column prop="order" align="center" show-overflow-tooltip label="流水号">
          <template slot-scope="scope">
              <span>{{scope.row.order_begin}} - {{scope.row.order_end}}</span>
          </template>
      </el-table-column>
      <el-table-column prop="count" align="center" label="作废数量"></el-table-column>
      <el-table-column prop="remark" align="center" label="备注说明"></el-table-column>
      <el-table-column prop="create_time" align="center" show-overflow-tooltip label="作废时间"></el-table-column>
      <el-table-column label="操作" align="center" fixed="right" width="150px">
        <template slot-scope="scope">
            <el-button
            size="mini"
            type="primary"
            @click="recovery(scope.row)">恢复</el-button>
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
    <el-dialog title="码段作废" :visible.sync="disDialog" width="40%" @close="disDialog=false">
        <el-form :model="form"  ref="form" label-width="100px" :rules="rule" size="medium">
            <el-form-item label="可选批次" prop="batch">
                <el-select style="width:100%" size="small"  v-model="form.batch" placeholder="请选择批次">
                    <el-option
                        v-for="item in batchOptions"
                        :key="item.id"
                        :label="item.batch+'--'+'('+item.order_begin+'~'+item.order_end+')'"
                        :value="item.batch">
                    </el-option>
                </el-select>
            </el-form-item>
            <el-form-item label="流水号" required>
                <el-col :span="9">
                    <el-form-item prop="order_begin">
                        <el-input @change="handleInputBegin" v-model.number="form.order_begin" placeholder="请输入起始流水号"></el-input>
                    </el-form-item>
                </el-col>
                <el-col class="line" :span="1" style="text-align:center">-</el-col>
                <el-col :span="9">
                    <el-form-item prop="order_end">
                        <el-input @change="handleInputEnd"  v-model.number="form.order_end" placeholder="请输入终止流水号"></el-input>
                    </el-form-item>
                </el-col>
                <el-col :span="5" style="text-align:center;">
                    <span>区间数量:<span style="color:red">{{form.count}}</span></span>
                </el-col>
            </el-form-item>
            <el-form-item label="备注" prop="remark">
                <el-input  type="textarea" v-model="form.remark" placeholder="请输入备注"></el-input>
            </el-form-item>
        </el-form>
        <div slot="footer" class="dialog-footer">
            <el-button type="primary" @click="submitFrom">作废</el-button>
        </div>
    </el-dialog>
  </div>
</template>

<script>
import {getInvalidCodeList,saveInvalidCode,getCodeBatch,recoverInvalidCode} from '@/api/codeStore/qrcode'
export default {
    data(){
        return{
            queryForm:{
                time:[],
                type:'',
                batch:'',
                remark:'',
                pageNum:1,
                pageSize:10,
            },
            count:0,
            form:{
                batch:'',
                order_begin:'',
                order_end:'',
                remark:'',
                count:0
            },
            rule:{
                batch:[
                    { required: true, message: "请选择批次", trigger: "blur" },
                ],
                order_begin:[
                    { required: true, message: "请输入起始序列号", trigger: "blur" },
                    { type: 'number', message: '数量必须为数字值'}
                ],
                order_end:[
                    { required: true, message: "请输入终止序列号", trigger: "blur" },
                    { type: 'number', message: '数量必须为数字值'}
                ],
                remark:[
                    { required: true, message: "请输入备注", trigger: "blur" },
                ]
            },
            batchOptions:[],
            disDialog:false,
            total:0,
            tableData:[],
            codeTypeOptions:[]
        }
    },
    created(){
        this.getList()
        this.getDicts({type:'code_type'}).then(res=>{
            this.codeTypeOptions=res.data
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
            getInvalidCodeList(params).then(res=>{
                this.tableData=res.data
                this.total=res.total
            })
        },
        handleInputBegin(val){
           if(!this.form.batch){
               this.$message.warning('请先选择批次')
               this.form.order_begin=''
               this.form.order_end=''
               this.form.count=0
                return
           }
           if(val&&this.form.order_end){
               if(parseInt(this.form.order_end)<=parseInt(val)){
                   this.$message.warning('请检查码段区间')
                   this.form.count=0
                   return
               }else{
                   this.form.count=parseInt(this.form.order_end)-parseInt(val)+1
               }
           }else{
               return;
           }
        },
        handleInputEnd(val){
            if(!this.form.batch){
               this.$message.warning('请先选择批次')
               this.form.order_begin=''
               this.form.order_end=''
                this.form.count=0
                return
           }
            if(val&&this.form.order_begin){
               if(parseInt(this.form.order_begin)>=parseInt(val)){
                   this.$message.warning('请检查码段区间')
                   this.form.count=0
                   return
               }else{
                   this.form.count=parseInt(val)-parseInt(this.form.order_begin)+1
               }
           }else{
               return;
           }
        },
        invalid(){
            this.form={
                batch:'',
                order_begin:'',
                order_end:'',
                remark:'',
                count:0
            }
            getCodeBatch({}).then(res=>{
                this.batchOptions=res.data
                this.disDialog=true
            })
        },
        recovery(row){
            recoverInvalidCode({id:row.id}).then(res=>{
                if(res.code==200){
                    this.$message.success(res.msg)
                    this.getList()
                }else{
                    this.$message.error(res.msg)
                }
            })
        },
        submitFrom(){
             this.$refs["form"].validate(valid => {
                 if(valid){
                     saveInvalidCode(this.form).then(res=>{
                        if(res.code==200){
                            this.$message.success(res.msg)
                            this.disDialog=false
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
        reset(formName){
            this.$refs[formName].resetFields();
            this.query()
        },
    }
}
</script>

<style>

</style>