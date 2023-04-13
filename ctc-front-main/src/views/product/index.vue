<template>
  <div class="app-container">
      <el-tabs v-model="activeName" @tab-click="handleClick">
        <el-tab-pane label="功能模块费" name="first"></el-tab-pane>
        <el-tab-pane label="码费" name="second"></el-tab-pane>
      </el-tabs>
      <el-col :span="24" style="margin:10px 0;" v-if="activeName=='first'">
          <el-button @click="handleAddModule" type="primary" size="small" >添加模块</el-button>
      </el-col>
      <div v-if="activeName=='first'">
          <el-table
            :data="tableData"
            ref="codeTable"
            :header-cell-style="{background:'#FAFAFA',color:'#606266',height:'50px'}"
            border
            stripe
            size="medium"
            class="trace-table"
            style="width: 100%">
              <el-table-column prop="module_name" align="center" label="产品模块" ></el-table-column>
              <el-table-column prop="module_cost" align="center" label="成本定价" >
                <template slot-scope="scope">
                  <span>￥{{scope.row.module_cost}}</span>
                </template>
              </el-table-column>
              <el-table-column prop="module_retail" align="center" label="零售定价" >
                <template slot-scope="scope">
                  <span>￥{{scope.row.module_retail}}</span>
                </template>
              </el-table-column>
              <el-table-column label="操作" align="center" fixed="right" width="240px">
                <template slot-scope="scope">
                  <el-button
                    size="mini"
                    type="primary"
                    @click="handleEdit(scope.row)">修改</el-button>
                  <el-button
                    size="mini"
                    type="danger"
                    @click="handleDelete(scope.row)">删除</el-button>
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
          <el-dialog  :title="title" :visible.sync="open" width="500px" append-to-body>
            <el-form ref="form" :model="form" :rules="rules" label-width="80px">
              <el-form-item label="模块名称" prop="module_name">
                <el-input v-model.number="form.module_name" placeholder="请输入模块名称"/>
              </el-form-item>
              <el-form-item label="成本价" prop="module_cost">
                <el-input v-model.number="form.module_cost" placeholder="请输入成本价" />
              </el-form-item>
              <el-form-item label="零售价" prop="module_retail">
                <el-input v-model.number="form.module_retail" placeholder="请输入零售价" />
              </el-form-item>
            </el-form>
            <div slot="footer" class="dialog-footer">
              <el-button type="primary" @click="submitForm">确 定</el-button>
              <el-button @click="cancel">取 消</el-button>
            </div>
        </el-dialog>
      </div>
      <div v-else>
        <el-col :span="24" style="margin:10px 0;" >
            <el-button @click="handleAddCode" type="primary" size="small" >添加码阶梯</el-button>
        </el-col>
        <el-table
          :data="tableCodeData"
          :header-cell-style="{background:'#FAFAFA',color:'#606266',height:'50px'}"
          border
          ref="codeTable"
          stripe
          size="medium"
          class="trace-table"
          style="width: 100%">
            <el-table-column prop="code_order_begin" align="center" label="码费阶梯" >
              <template slot-scope="scope">
                <span>{{scope.row.code_order_begin}}-{{scope.row.code_order_end}}</span>
              </template>
            </el-table-column>
            <el-table-column prop="code_cost" align="center" label="单码成本价" >
              <template slot-scope="scope">
                <span>￥{{scope.row.code_cost}}</span>
              </template>
            </el-table-column>
            <el-table-column prop="code_retail" align="center" label="单码零售价" >
              <template slot-scope="scope">
                <span>￥{{scope.row.code_retail}}</span>
              </template>
            </el-table-column>
            <el-table-column label="操作" align="center" fixed="right" width="240px">
              <template slot-scope="scope">
                <el-button
                  size="mini"
                  type="primary"
                  @click="handleCodeEdit(scope.row)">修改</el-button>
                <el-button
                  size="mini"
                  type="danger"
                  @click="handleCodeDelete(scope.row)">删除</el-button>
              </template>
            </el-table-column>
        </el-table>
        <pagination
          v-show="+totals>10"
          :total="+totals"
          :page.sync="queryCodeForm.pageNum"
          :limit.sync="queryCodeForm.pageSize"
          @pagination="getCodeList"
        />
        <el-dialog :title="titleCode" :visible.sync="openCode" width="500px" append-to-body>
            <el-form ref="codeForm" :model="codeForm" :rules="codeRule" label-width="80px">
              <el-row >
                <el-col :span="12">
                  <el-form-item label="阶梯" prop="code_order_begin">
                    <el-input v-model.number="codeForm.code_order_begin" placeholder="起始序号"/>
                  </el-form-item>
                </el-col>
                <el-col :span="12">
                  <el-form-item label="" prop="code_order_end">
                    <el-input v-model.number="codeForm.code_order_end" placeholder="终止序号"/>
                  </el-form-item>
                </el-col>
              </el-row>
              <el-form-item label="成本价" prop="code_cost">
                <el-input v-model.number="codeForm.code_cost" placeholder="请输入成本价" />
              </el-form-item>
              <el-form-item label="零售价" prop="code_retail">
                <el-input v-model.number="codeForm.code_retail" placeholder="请输入零售价" />
              </el-form-item>
            </el-form>
            <div slot="footer" class="dialog-footer">
              <el-button type="primary" @click="submitCodeForm">确 定</el-button>
              <el-button @click="cancelCode">取 消</el-button>
            </div>
        </el-dialog>
      </div>
  </div>
</template>

<script>
import {listModule,addModule,deleModule,getModule} from "@/api/product/module";
import {listCode,addCode,deleCode,getCode} from "@/api/product/code";
export default {
  data(){
    return{
      tableData:[],
      tableCodeData:[],
      total:0,
      totals:0,
      open:false,
      openCode:false,
      title:'',
      titleCode:'',
      activeName: 'first',
      queryForm:{
        pageNum:1,
        pageSize:10
      },
      queryCodeForm:{
        pageNum:1,
        pageSize:10
      },
      form:{},
      codeForm:{},
      rules:{
        module_name:[
          { required: true, message: "请填写模块名", trigger: "blur" },
        ],
        module_retail:[
          { required: true, message: "零售价不能为空", trigger: "blur" },
          { type: 'number', message: '零售价必须为数字值'}
        ],
        module_cost:[
          { required: true, message: "成本价不能为空", trigger: "blur" },
          { type: 'number', message: '成本价必须为数字值'}
        ]
      },
      codeRule:{
        code_retail:[
          { required: true, message: "零售价不能为空", trigger: "blur" },
          { type: 'number', message: '零售价必须为数字值'}
        ],
        code_order_begin:[
          { required: true, message: "起始阶梯不能为空", trigger: "blur" },
          { type: 'number', message: '阶梯必须为数字值'}
        ],
        code_order_end:[
          { required: true, message: "终止阶梯不能为空", trigger: "blur" },
          { type: 'number', message: '阶梯必须为数字值'}
        ],
        code_cost:[
          { required: true, message: "成本价不能为空", trigger: "blur" },
          { type: 'number', message: '成本价必须为数字值'}
        ]
      }
    }
  },
  created(){
    this.getList()
    this.getCodeList()
  },
  methods:{
    getList(){
      listModule(this.queryForm).then(res=>{
        this.total=res.total
        this.tableData=res.data
      })
    },
    getCodeList(){
      listCode(this.queryCodeForm).then(res=>{
        this.totals=res.total
        this.tableCodeData=res.data
      })
    },
    handleClick(tab, event) {
      if(this.activeName=='first'){
        this.getList()
      }else{
        this.getCodeList()
      }
    },
    reset() {
      this.form = {
        id:undefined,
        module_name: '',
        module_cost:'',
        module_retail:'',
      };
      this.resetForm("form");
    },
    resetCode(){
      this.codeForm={
        id:undefined,
        code_order_begin:'',
        code_order_end:'',
        code_cost:'',
        code_retail:''
      }
      this.resetForm("codeForm");
    },
    handleEdit(row){
      this.reset()
      getModule({id:row.id}).then(res=>{
        this.title='修改模块'
        this.open=true
        this.form=res.data
        this.form.module_cost=Number(res.data.module_cost)
        this.form.module_retail=Number(res.data.module_retail)
      })
    },
    handleCodeEdit(row){
      this.resetCode()
      getCode({id:row.id}).then(res=>{
        this.title='设置码费'
        this.openCode=true
        this.codeForm=res.data
        this.codeForm.code_order_begin=Number(res.data.code_order_begin)
        this.codeForm.code_order_end=Number(res.data.code_order_end)
        this.codeForm.code_cost=Number(res.data.code_cost)
        this.codeForm.code_retail=Number(res.data.code_retail)
      })
    },
    handleAddModule(){
      this.reset()
      this.title='添加模块'
      this.open=true
    },
    handleAddCode(){
      this.resetCode()
      this.titleCode='设置码费'
      this.openCode=true
    },
     handleDelete(row){
       this.$confirm(`是否确认删除${row.module_name}模块?`, "警告", {
          confirmButtonText: "确定",
          cancelButtonText: "取消",
          type: "warning"
        }).then(function() {
          return deleModule({id:row.id});
        }).then(() => {
          this.getList();
          this.msgSuccess("删除成功");
        }).catch(() => {});
    },
    handleCodeDelete(row){
      this.$confirm(`是否确认删除该码费阶梯?`, "警告", {
          confirmButtonText: "确定",
          cancelButtonText: "取消",
          type: "warning"
        }).then(function() {
          return deleCode({id:row.id});
        }).then(() => {
          this.getCodeList();
          this.msgSuccess("删除成功");
        }).catch(() => {});
    },
    cancel(){
      this.open=false
      this.reset()
    },
    cancelCode(){
      this.openCode=false
      this.resetCode()
    },
    submitForm(){
      this.$refs["form"].validate(valid => {
        if(valid){
          addModule(this.form).then(response => {
            if(response.code==200){
              this.$message.success(response.msg)
              this.open = false;
              this.getList();
            }else{
              this.$message.error(response.msg)
            }
          });
        }
      })    
    },
    submitCodeForm(){
      this.$refs["codeForm"].validate(valid => {
        if(valid){
          if(this.codeForm.code_order_begin>=this.codeForm.code_order_end){
            this.$message.warning('码阶梯设置不合理！')
            return
          }
          addCode(this.codeForm).then(response => {
            if(response.code==200){
              this.$message.success(response.msg)
              this.openCode = false;
              this.getCodeList();
            }else{
              this.$message.error(response.msg)
            }
          });
        }
      })    
    }
  },
}
</script>

<style>

</style>