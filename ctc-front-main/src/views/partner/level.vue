<template>
  <div class="app-container">
      <div class="tab-bar">
        <el-form ref="queryForm" :model="queryForm" label-width="80px" :inline="true" size="small">
                <el-form-item label="级别名称" prop="level_name">
                    <el-input style="width:200px" placeholder="请输入级别" v-model="queryForm.level_name"></el-input>
                </el-form-item>
                <el-form-item > 
                    <el-button type="primary" icon="el-icon-search" @click="query">查询</el-button>
                    <el-button icon="el-icon-refresh" @click="resetQuery('queryForm')">重置</el-button>
                </el-form-item>
        </el-form>
      </div>
      <el-col :span="24" style="margin:10px 0;">
        <el-button v-hasPermi="['partner:partnerLevel:addLevel']" @click="addLevel" type="primary" size="small" >添加合伙人级别</el-button>
      </el-col>
      <!-- 表格区域 -->
      <el-table
      :data="tableData"
      :header-cell-style="{background:'#FAFAFA',color:'#606266',height:'50px'}"
      border
      stripe
      size="medium"
      class="trace-table"
      style="width: 100%">
      <el-table-column prop="level" align="center" label="级别" width="80px"></el-table-column>
      <el-table-column prop="level_name" align="center" label="级别名称" width="120px"></el-table-column>
      <el-table-column prop="account_discount" align="center" label="开户折扣" show-overflow-tooltip>
        <template slot-scope="scope">
          <span>{{scope.row.account_discount+'折'}}</span>
        </template>
      </el-table-column>
      <el-table-column prop="renewal_discount" align="center" label="续费折扣" width="120px">
        <template slot-scope="scope">
          <span>{{scope.row.renewal_discount+'折'}}</span>
        </template>
      </el-table-column>
      <el-table-column prop="is_custom_name" align="center" label="自定义平台名称">
        <template slot-scope="scope">
          <span v-if="scope.row.is_custom_name=='1'"><i class="el-icon-check"></i></span>
          <span v-else><i class="el-icon-close"></i></span>
        </template>
      </el-table-column>
      <el-table-column prop="is_custom_logo" align="center" label="自定义LOGO">
        <template slot-scope="scope">
          <span v-if="scope.row.is_custom_logo=='1'"><i class="el-icon-check"></i></span>
          <span v-else><i class="el-icon-close"></i></span>
        </template>
      </el-table-column>
      <el-table-column prop="is_custom_price" align="center" show-overflow-tooltip label="自定义产品价格">
        <template slot-scope="scope">
          <span v-if="scope.row.is_custom_price=='1'"><i class="el-icon-check"></i></span>
          <span v-else><i class="el-icon-close"></i></span>
        </template>
      </el-table-column>
      <el-table-column prop="is_custom_codeSys" align="center" label="自有生码系统">
        <template slot-scope="scope">
          <span v-if="scope.row.is_custom_codeSys=='1'"><i class="el-icon-check"></i></span>
          <span v-else><i class="el-icon-close"></i></span>
        </template>
      </el-table-column>
      <el-table-column prop="is_custom_register" align="center" label="自定义品牌商注册页">
        <template slot-scope="scope">
          <span v-if="scope.row.is_custom_register=='1'"><i class="el-icon-check"></i></span>
          <span v-else><i class="el-icon-close"></i></span>
        </template>
      </el-table-column>
      <el-table-column prop="is_custom_login" align="center" label="自定义登录模板">
        <template slot-scope="scope">
          <span v-if="scope.row.is_custom_login=='1'"><i class="el-icon-check"></i></span>
          <span v-else><i class="el-icon-close"></i></span>
        </template>
      </el-table-column>
      <el-table-column prop="is_custom_customer_price" align="center" show-overflow-tooltip label="单客户定价">
        <template slot-scope="scope">
          <span v-if="scope.row.is_custom_customer_price=='1'"><i class="el-icon-check"></i></span>
          <span v-else><i class="el-icon-close"></i></span>
        </template>
      </el-table-column>
      <el-table-column prop="is_custom_copy" align="center" label="自定义版权" show-overflow-tooltip>
        <template slot-scope="scope">
          <span v-if="scope.row.is_custom_copy=='1'"><i class="el-icon-check"></i></span>
          <span v-else><i class="el-icon-close"></i></span>
        </template>
      </el-table-column>
      <el-table-column prop="is_custom_domain" align="center" label="自定义域名">
        <template slot-scope="scope">
          <span v-if="scope.row.is_custom_domain=='1'"><i class="el-icon-check"></i></span>
          <span v-else><i class="el-icon-close"></i></span>
        </template>
      </el-table-column>
      <el-table-column prop="free_support" align="center" label="免费上门支持"></el-table-column>
      <el-table-column prop="fiee_training" align="center" label="免费上门培训"></el-table-column>
      <el-table-column label="操作" align="center" fixed="right" width="240px">
        <template slot-scope="scope">
          <el-button
            size="mini"
            type="primary"
            v-hasPermi="['partner:partnerLevel:editLevel']"
            @click="handleEdit(scope.row)">修改</el-button>
          <el-button
            size="mini"
            type="danger"
            v-hasPermi="['partner:partnerLevel:deleLevel']"
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
    <el-dialog :title="dialogTitle" :visible.sync="levelDialog" width="60%" @close="storeDialog=false">
        <el-form :model="form" ref="form" label-width="140px" :rules="rule">
          <el-row>
            <el-col :span="12">
              <el-form-item label="级别" prop="level">
                <el-input-number style="width:80%" v-model="form.level" controls-position="right" :min="1" />
              </el-form-item>
            </el-col>
            <el-col :span="12">
              <el-form-item label="级别名称" prop="level_name">
                <el-input style="width:80%" v-model="form.level_name" placeholder="请输入级别名称"/>
              </el-form-item>
            </el-col>
          </el-row>
          <el-row>
            <el-col :span="12">
              <el-form-item label="开户折扣" prop="account_discount">
                <el-input-number style="width:80%" v-model="form.account_discount" controls-position="right" :min="0" />
              </el-form-item>
            </el-col>
            <el-col :span="12">
              <el-form-item label="续费折扣" prop="renewal_discount">
                <el-input-number style="width:80%" v-model="form.renewal_discount" controls-position="right" :min="0" />
              </el-form-item>
            </el-col>
          </el-row>
          <el-row>
            <el-col :span="12">
              <el-form-item label="免费上门支持" prop="free_support">
                <el-input-number style="width:80%" v-model="form.free_support" controls-position="right" :min="0" />
              </el-form-item>
            </el-col>
            <el-col :span="12">
              <el-form-item label="免费上门培训" prop="fiee_training">
                <el-input-number style="width:80%" v-model="form.fiee_training" controls-position="right" :min="0" />
              </el-form-item>
            </el-col>
          </el-row>
          <el-row>
            <el-col :span="12">
              <el-form-item label="自定义平台名称" prop="is_custom_name">
                <el-radio-group v-model="form.is_custom_name">
                  <el-radio
                    v-for="dict in customOptions"
                    :key="dict.value"
                    :label="dict.value"
                  >{{dict.label}}</el-radio>
                </el-radio-group>
              </el-form-item>
            </el-col>
            <el-col :span="12">
              <el-form-item label="自定义logo" prop="is_custom_logo">
                <el-radio-group v-model="form.is_custom_logo">
                  <el-radio
                    v-for="dict in customOptions"
                    :key="dict.value"
                    :label="dict.value"
                  >{{dict.label}}</el-radio>
                </el-radio-group>
              </el-form-item>
            </el-col>
          </el-row>
          <el-row>
            <el-col :span="12">
              <el-form-item  prop="is_custom_price">
                  <span slot="label">
                  <el-tooltip content="(合伙人自定码费、功能模块费、服务费)" placement="top">
                  <i class="el-icon-question"></i>
                  </el-tooltip>
                  自定产品价格
                </span>
                <el-radio-group v-model="form.is_custom_price">
                  <el-radio
                    v-for="dict in customOptions"
                    :key="dict.value+'vis'"
                    :label="dict.value"
                  >{{dict.label}}</el-radio>
                </el-radio-group>
              </el-form-item>
            </el-col>
            <el-col :span="12">
              <el-form-item  prop="is_custom_codeSys">
                  <span slot="label">
                  <el-tooltip content="(合伙人可自行生码)" placement="top">
                  <i class="el-icon-question"></i>
                  </el-tooltip>
                  自有生码系统
                </span>
                <el-radio-group v-model="form.is_custom_codeSys">
                  <el-radio
                    v-for="dict in customOptions"
                    :key="dict.value+'vis'"
                    :label="dict.value"
                  >{{dict.label}}</el-radio>
                </el-radio-group>
              </el-form-item>
            </el-col>
          </el-row>
          <el-row>
            <el-col :span="12">
              <el-form-item label="自定义品牌商注册页" prop="is_custom_register">
                <el-radio-group v-model="form.is_custom_register">
                  <el-radio
                    v-for="dict in customOptions"
                    :key="dict.value"
                    :label="dict.value"
                  >{{dict.label}}</el-radio>
                </el-radio-group>
              </el-form-item>
            </el-col>
            <el-col :span="12">
              <el-form-item label="自定义登录模板" prop="is_custom_login">
                <el-radio-group v-model="form.is_custom_login">
                  <el-radio
                    v-for="dict in customOptions"
                    :key="dict.value"
                    :label="dict.value"
                  >{{dict.label}}</el-radio>
                </el-radio-group>
              </el-form-item>
            </el-col>
          </el-row>
          <el-row>
            <el-col :span="12">
              <el-form-item  prop="is_custom_customer_price">
                  <span slot="label">
                  <el-tooltip content="(合伙人给单个品牌商自定码费、功能模块费、服务费)" placement="top">
                  <i class="el-icon-question"></i>
                  </el-tooltip>
                  单客户定价
                </span>
                <el-radio-group v-model="form.is_custom_customer_price">
                  <el-radio
                    v-for="dict in customOptions"
                    :key="dict.value+'vis'"
                    :label="dict.value"
                  >{{dict.label}}</el-radio>
                </el-radio-group>
              </el-form-item>
            </el-col>
            <el-col :span="12">
              <el-form-item label="自定义版权" prop="is_custom_copy">
                <el-radio-group v-model="form.is_custom_copy">
                  <el-radio
                    v-for="dict in customOptions"
                    :key="dict.value"
                    :label="dict.value"
                  >{{dict.label}}</el-radio>
                </el-radio-group>
              </el-form-item>
            </el-col>
          </el-row>
          <el-row>
            <el-col :span="12">
              <el-form-item label="自定义域名" prop="is_custom_domain">
                <el-radio-group v-model="form.is_custom_domain">
                  <el-radio
                    v-for="dict in customOptions"
                    :key="dict.value"
                    :label="dict.value"
                  >{{dict.label}}</el-radio>
                </el-radio-group>
              </el-form-item>
            </el-col>
          </el-row>
        </el-form>
        <div slot="footer" class="dialog-footer">
          <el-button type="primary" @click="submitForm">确 定</el-button>
          <el-button @click="cancel">取 消</el-button>
        </div>
    </el-dialog>
  </div>
</template>
<script>
import {listLevel,addLevel,deleLevel,getLevel} from "@/api/partner/index";
export default {
    data(){
        return{
            queryForm:{
                level_name:'',
                pageNum:1,
                pageSize:10
            },
            customOptions:[
                {
                    value:"0",
                    label:'不允许'
                },
                {
                    value:"1",
                    label:'允许'
                }
            ],
            dialogTitle:'',
            options:[],
            levelDialog:false,
            form:{},
            rule:{
              level:[
                { required: true, message: "级别为空", trigger: "blur" }
              ],
              level_name:[
                { required: true, message: "级别名称不能为空", trigger: "blur" },
                { min: 3, max: 20, message: '级别名称长度必须介于 3 和 10 之间', trigger: 'blur' }
              ],
              account_discount:[
                { required: true, message: "开户折扣不能为空", trigger: "blur" },
              ],
              renewal_discount:[
                { required: true, message: "续费折扣不能为空", trigger: "blur" },
              ]
            },
            sceneOptions:[
            ],
            tableData:[
            ],
            total:0
        }
    },
    created(){
        this.getList()
    },
    methods:{
        getList(){
            listLevel(this.queryForm).then(res=>{
              this.total=res.total
              this.tableData=res.data
            })
        },
        addLevel(){
          this.dialogTitle='添加级别'
          this.reset();
          this.levelDialog=true
        },
        reset() {
          this.form = {
            level: 1,
            id:undefined,
            fiee_training:'0',
            free_support:'0',
            level_name: '',
            account_discount: "0",
            renewal_discount: "0",
            is_custom_name:'0',
            is_custom_logo:'0',
            is_custom_price:'0',
            is_custom_codeSys: '0',
            is_custom_register:'0',
            is_custom_login: '0',
            is_custom_customer_price: "0",
            is_custom_copy: '0',
            is_custom_domain: '0'
          };
          this.resetForm("form");
        },
        // 取消按钮
        cancel() {
          this.levelDialog = false;
          this.reset();
        },
        submitForm(){
          this.$refs["form"].validate(valid => {
            if(valid){
                addLevel(this.form).then(response => {
                  if(response.code==200){
                    this.$message.success(response.msg)
                    this.levelDialog = false;
                    this.getList();
                  }else{
                    this.$message.error(response.msg)
                  }
                });
            }
          })
        },
        handleEdit(row){
          this.reset();
          getLevel({id:row.id}).then(res=>{
            this.form=res.data
            this.levelDialog=true
            this.dialogTitle='修改等级'
          })
        },
        handleDelete(row){
          this.$confirm('是否确认删除名称为"' + row.level_name + '"的数据项?', "警告", {
              confirmButtonText: "确定",
              cancelButtonText: "取消",
              type: "warning"
          }).then(function() {
            return deleLevel({id:row.id});
          }).then(() => {
            this.getList();
            this.msgSuccess("删除成功");
          }).catch(() => {});
        },
        query(){
          this.queryForm.pageNum = 1;
          this.getList();
        },
        resetQuery(formName){
            this.$refs[formName].resetFields();
            this.query()
        },
    }
}
</script>

<style>

</style>