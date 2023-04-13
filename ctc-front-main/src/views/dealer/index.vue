<template>
  <div class="app-container">
    <div class="tab-bar">
        <el-form ref="queryForm" :model="queryForm" label-width="100px" :inline="true" size="small">
            <el-form-item label="品牌商编号" prop="code">
                <el-input style="width:240px" v-model="queryForm.code" placeholder="请输入品牌商编号"></el-input>
            </el-form-item>
            <el-form-item label="品牌商名称" prop="dealer_name">
                <el-input style="width:240px" placeholder="请输入品牌商名称" v-model="queryForm.dealer_name"></el-input>
            </el-form-item>
            <el-form-item label="状态" prop="status">
              <el-select style="width:240px" v-model="queryForm.status" placeholder="请选择品牌商状态">
                <el-option
                  v-for="dict in statusOptions"
                  :key="dict.dict_value"
                  :label="dict.dict_label"
                  :value="dict.dict_value">
                </el-option>
              </el-select>
            </el-form-item>
            <el-form-item label="创建时间" prop="duration">
              <el-date-picker
                style="width:240px"
                v-model="queryForm.duration"
                type="daterange"
                unlink-panels=""
                range-separator="至"
                format="yyyy 年 MM 月 dd 日"
                value-format="yyyy-MM-dd"
                start-placeholder="开始日期"
                end-placeholder="结束日期">
              </el-date-picker>
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
      <el-table-column prop="id" align="center" label="编号" width="80px"></el-table-column>
      <el-table-column prop="dealer_name" align="center" label="品牌商名称"></el-table-column>
      <el-table-column prop="account" align="center" label="品牌商账号"></el-table-column>
      <el-table-column prop="company" align="center" label="公司名称"></el-table-column>
      <el-table-column prop="partner" align="center" label="所属合伙人"></el-table-column>
      <el-table-column prop="behalf_balance" align="center" label="代发余额"></el-table-column>
      <el-table-column prop="duration" align="center" label="有效期" show-overflow-tooltip>
         <template slot-scope="scope">
           <span>{{scope.row.validity_begin}}至{{scope.row.validity_end}}</span>
         </template>
      </el-table-column>
      <el-table-column prop="status" align="center" label="状态" :formatter="status"></el-table-column>
      <el-table-column prop="wechat_auth" align="center" label="微信授权">
        <template slot-scope="scope">
          <span>{{scope.row.wechat_auth==0?'未授权':'已授权'}}</span>
        </template>
      </el-table-column>
      <el-table-column prop="" align="center" label="认证状态" width="150px">
         <template slot-scope="scope">
           <el-link @click="auth(scope.row)" type="primary">{{scope.row.license_status|auth}}</el-link>
           <el-link @click="auth(scope.row)" style="margin-left:4px" type="primary">{{scope.row.trademark_status|auth}}</el-link>
         </template>
      </el-table-column>
      <el-table-column label="操作" align="center" fixed="right" width="240px">
        <template slot-scope="scope">
          <el-button
            size="mini"
            type="primary"
            @click="handleInfo(scope.row)">详情</el-button>
          <el-button
            size="mini"
            type="danger"
            @click="handleCut(scope.row)">{{scope.row.status==0||scope.row.status==1?'禁用':'恢复'}}</el-button>
          <el-dropdown size="mini" @command="(command) => handleCommand(command, scope.row)">
              <span class="el-dropdown-link">
                <i class="el-icon-d-arrow-right el-icon--right"></i>更多
              </span>
              <el-dropdown-menu slot="dropdown">
                <el-dropdown-item command="handleRecharge" icon="el-icon-bank-card"
                  >充值</el-dropdown-item>
                <el-dropdown-item command="handleDele" icon="el-icon-delete"
                  >删除</el-dropdown-item>
              </el-dropdown-menu>
          </el-dropdown>
        </template>
-      </el-table-column>
    </el-table>
    <pagination
        v-show="+total>10"
        :total="+total"
        :page.sync="queryForm.pageNum"
        :limit.sync="queryForm.pageSize"
        @pagination="getList"
     />
     <el-dialog title="代发红包池充值" :visible.sync="rechargeDialog" width="40%" @close="rechargeDialog=false">
        <el-form :model="rechargeFrom" ref="rechargeFrom" label-width="120px" :rules="rule" size="medium">
          <el-row>
            <el-col :span="12">
              <el-form-item label="品牌商编号:" prop="code">
                <el-input readonly=""  v-model="rechargeFrom.id"/>
              </el-form-item>
            </el-col>
            <el-col :span="12">
              <el-form-item label="品牌商名称:" prop="dealer_name">
                <el-input readonly=""  v-model="rechargeFrom.dealer_name"/>
              </el-form-item>
            </el-col>
          </el-row>
          <el-row>
            <el-col :span="12">
              <el-form-item label="品牌商账号:" prop="account">
                <el-input readonly=""  v-model="rechargeFrom.account"/>
              </el-form-item>
            </el-col>
            <el-col :span="12">
              <el-form-item label="代发红包池余额:" prop="behalf_balance">
                <el-input readonly=""  v-model="rechargeFrom.behalf_balance"/>
              </el-form-item>
            </el-col>
          </el-row>
          <el-row>
            <el-col :span="12">
              <el-form-item label="充值:" prop="recharge">
                <el-input  v-model.number="rechargeFrom.recharge" placeholder="请输入充值金额"/>
              </el-form-item>
            </el-col>
            <el-col :span="12">
              <el-form-item label="备注:" prop="remark">
                <el-input  v-model.number="rechargeFrom.remark" placeholder="备注"/>
              </el-form-item>
            </el-col>
          </el-row>
          <el-row>
            <el-col :span="12">
              <el-form-item label="密码:" prop="password">
                <el-input  v-model.number="rechargeFrom.password" placeholder="请输入密码"/>
              </el-form-item>
            </el-col>
          </el-row>
        </el-form>
        <div slot="footer" class="dialog-footer">
          <el-button type="primary" @click="submitForm">确 定</el-button>
          <el-button @click="cancel">取 消</el-button>
        </div>
     </el-dialog>
     <el-dialog title="品牌商资质认证" :visible.sync="authDialog" width="60%" @close="authDialog=false">
          <el-row class="tips">
            <el-col>
              1、开通物元码平台的品牌商必须是依法在中国大陆注册的企业或个体工商户，须持有商标或商标授权书。为了您能正常使用物元码系统 功能入扫码查询，营销等，请先完成企业资质和商标资质认证。
            </el-col>
            <el-col style="margin-top:4px">
              2、所有提交的资质证书需为清晰彩色原件扫描件，复印件则需加盖公司红章，我们将在三个工作日内完成审核。
            </el-col>
          </el-row>
         <el-table
            :data="authData"
            :header-cell-style="{background:'#FAFAFA',color:'#606266',height:'50px'}"
            border
            stripe
            size="medium"
            class="trace-table"
            style="width: 100%;">
            <el-table-column prop="name" width="200px" align="center" label="资质名称"></el-table-column>
            <el-table-column prop="status" width="100px" align="center" label="状态">
              <template slot-scope="scope">
                <span>{{scope.row.status|auth}}</span>
              </template>
            </el-table-column>
            <el-table-column prop="tips" align="center" label="说明"></el-table-column>
            <el-table-column label="操作" align="center" fixed="right" width="200px">
                <template slot-scope="scope">
                  <el-button
                    size="mini"
                    type="primary"
                    @click="handleAuth(scope.row)">{{scope.row.status|auth}}</el-button>
                </template>
            </el-table-column>
         </el-table>
         <!-- 嵌套dialog 商标认证 -->
          <el-dialog
            width="40%"
            title="商标权认证"
            class="authDialog"
            :visible.sync="trademarkDialog"
            append-to-body>
            <el-form :model="trademarkFrom" ref="trademarkFrom" label-width="160px" :rules="trademarkRule" size="medium">
              <el-form-item label="资质名称:" prop="company">
                中国商标权证书
                <i v-show="trademarkFrom.status=='0'||trademarkFrom.status=='2'" style="color:red" class="el-icon-error"></i>
                <i v-show="trademarkFrom.status=='3'" style="color:red" class="el-icon-warning"></i>
                <i v-show="trademarkFrom.status=='1'" style="color:red" class="el-icon-circle-check"></i>
                {{trademarkFrom.status|auth}}
              </el-form-item>
              <el-form-item label="商标注册号/申请号:" prop="trademark_code">
                <el-input  v-model="trademarkFrom.trademark_code" placeholder="商标注册号/申请号"/>
              </el-form-item>
              <el-form-item label="中国商标权证书:" prop="trademark_cert">
                <el-upload
                  class="avatar-uploader"
                  :action="upload.url"
                  :headers="upload.headers"
                  :show-file-list="false"
                  :on-success="handleSuccess"
                  name="img"
                  :before-upload="beforeUpload">
                  <img v-if="trademarkFrom.trademark_cert" :src="trademarkFrom.trademark_cert" class="avatar">
                  <i v-else class="el-icon-plus avatar-uploader-icon"></i>
                  <div slot="tip" class="el-upload__tip">图片大小不超过5M，支持jpg/png格式</div>
                  <div slot="tip" class="el-upload__tip">注：非以本公司名为持有的商标请务必在补充材料选项上传商标授权书</div>
                </el-upload>
              </el-form-item>
              <el-form-item label="补充材料:" prop="trademark_supplement">
                <el-upload
                  class="avatar-uploader"
                  :action="upload.url"
                  :headers="upload.headers"
                  :show-file-list="false"
                  :on-success="handleSuccessSupplement"
                  name="img"
                  :before-upload="beforeUpload">
                  <img v-if="trademarkFrom.trademark_supplement" :src="trademarkFrom.trademark_supplement" class="avatar">
                  <i v-else class="el-icon-plus avatar-uploader-icon"></i>
                  <div slot="tip" class="el-upload__tip">图片大小不超过5M，支持jpg/png格式</div>
                  <div slot="tip" class="el-upload__tip">授权书上传必须为彩色图片，格式为png、jpeg、jpg</div>
                </el-upload>
              </el-form-item>
              <el-form-item label="审核操作:" prop="checkStatus">
                <el-radio-group v-model="trademarkFrom.checkStatus">
                  <el-radio
                    @change="checktrademarkFrom"
                    v-for="dict in checkOptions"
                    :key="dict.value"
                    :label="dict.value"
                  >{{dict.label}}</el-radio>
                </el-radio-group>
              </el-form-item>
            </el-form>
            <div slot="footer" class="dialog-footer">
              <el-button type="primary" @click="submitTrademarkFrom">立即提交</el-button>
            </div>
          </el-dialog>
          <!-- 营业执照认证 -->
          <el-dialog
            width="40%"
            title="营业执照认证"
            class="authDialog"
            :visible.sync="licenseDialog"
            append-to-body>
            <el-form :model="licenseFrom" ref="licenseFrom" label-width="160px" :rules="licenseRule" size="medium">
              <el-form-item label="资质名称:" prop="company">
                企业营业执照
                <i v-show="licenseFrom.status=='0'||licenseFrom.status=='2'" style="color:red" class="el-icon-error"></i>
                <i v-show="licenseFrom.status=='3'" style="color:red" class="el-icon-warning"></i>
                <i v-show="licenseFrom.status=='1'" style="color:red" class="el-icon-circle-check"></i>
                {{licenseFrom.status|auth}}
              </el-form-item>
              <el-form-item label="公司名称:" prop="company_name">
                <el-input style="width:80%"  v-model="licenseFrom.company_name" placeholder="请填写公司名称"/>
              </el-form-item>
              <el-form-item label="公司类型:" prop="company_type">
                <el-select style="width:80%" v-model="licenseFrom.company_type" placeholder="请选择公司类型" clearable>
                  <el-option
                    v-for="dict in companyTypeOptions"
                    :key="dict.dict_value"
                    :label="dict.dict_label"
                    :value="dict.dict_value"
                  />
                </el-select>
              </el-form-item>
              <el-form-item label="注册地址:" prop="register_address">
                <el-input style="width:80%"  v-model="licenseFrom.register_address" placeholder="请填写公司注册地址"/>
              </el-form-item>
              <el-form-item label="公司法人:" prop="legal_person">
                <el-input style="width:80%"  v-model="licenseFrom.legal_person" placeholder="请填写公司法人"/>
              </el-form-item>
              <el-form-item label="注册资本:" prop="capital">
                <el-input style="width:80%" v-model="licenseFrom.capital" placeholder="请填写公司注册资本"/>
              </el-form-item>
              <el-form-item label="成立日期:" prop="establish_date">
                <el-date-picker
                  style="width:80%" 
                  v-model="licenseFrom.establish_date"
                  format="yyyy 年 MM 月 dd 日"
                  value-format="yyyy-MM-dd"
                  type="date"
                  placeholder="选择日期">
                </el-date-picker>
              </el-form-item>
              <el-form-item label="营业期限:" prop="business_period">
                <el-date-picker
                  style="width:80%" 
                  v-model="licenseFrom.business_period"
                  type="daterange"
                  range-separator="至"
                  ormat="yyyy 年 MM 月 dd 日"
                  value-format="yyyy-MM-dd"
                  start-placeholder="开始日期"
                  end-placeholder="结束日期">
                </el-date-picker>
              </el-form-item>
              <el-form-item label="营业执照号码:" prop="business_license_code">
                <el-input style="width:80%"  v-model="licenseFrom.business_license_code" placeholder="请填写公司营业执照号码"/>
              </el-form-item>
              <el-form-item label="组织机构代码:" prop="organization_code">
                <el-input style="width:80%" v-model="licenseFrom.organization_code" placeholder="请填写公司组织机构代码"/>
              </el-form-item>
              <el-form-item label="营业执照:" prop="business_license_url">
                <el-upload
                  class="avatar-uploader"
                  :action="upload.url"
                  :headers="upload.headers"
                  :show-file-list="false"
                  :on-success="handleSuccessLicense"
                  name="img"
                  :before-upload="beforeUpload">
                  <img v-if="licenseFrom.business_license_url" :src="licenseFrom.business_license_url" class="avatar">
                  <i v-else class="el-icon-plus avatar-uploader-icon"></i>
                  <div slot="tip" class="el-upload__tip">图片大小不超过5M，支持jpg/png格式</div>
                  <div slot="tip" class="el-upload__tip">注：请上传有效期内且年检章齐全的营业执照清晰彩色原件扫描件</div>
                </el-upload>
              </el-form-item>
              <el-form-item label="审核操作:" prop="checkStatus">
                <el-radio-group v-model="licenseFrom.checkStatus">
                  <el-radio
                    @change="checkLicenseFrom"
                    v-for="dict in checkOptions"
                    :key="dict.value"
                    :label="dict.value"
                  >{{dict.label}}</el-radio>
                </el-radio-group>
              </el-form-item>
            </el-form>
            <div slot="footer" class="dialog-footer">
              <el-button type="primary" @click="submitLicenseFrom">立即提交</el-button>
            </div>
          </el-dialog>
     </el-dialog>
  </div>
</template>
<script>
import {listDealer,delDealer,cutDealer,getDealerInfo,rechargeDealer,getAuthData,checkTrademark,checkLicense} from "@/api/dealer/index";
import { getToken } from "@/utils/auth";
export default {
  data(){
    return{
      queryForm:{
        code:'',
        dealer_name:'',
        status:'',
        duration:undefined,
        pageNum:1,
        pageSize:10
      },
      statusOptions:[],
      tableData:[],
      authData:[],
      total:0,
      rechargeDialog:false,
      authDialog:false,
      trademarkDialog:false,
      licenseDialog:false,
      rechargeFrom:{
        id:'',
        recharge:undefined,
        password:undefined,
        remark:undefined
      },
      companyTypeOptions:[],
      dealer_id:undefined,
      checkOptions:[
          {
              value:"1",
              label:'审核通过'
          },
          {
              value:"2",
              label:'不通过'
          }
      ],
      upload:{
        headers: { Authorization: "Bearer " + getToken() },
        // 上传的地址
        url: process.env.VUE_APP_BASE_API + "/main/dealer/uploadTrademark"
      },
      trademarkFrom:{
        checkStatus:'1'
      },
      licenseFrom:{
        checkStatus:'1'
      },
      trademarkRule:{
        trademark_code:[
          { required: true, message: "商标注册号/申请号不能为空", trigger: "blur" },
        ],
        trademark_cert:[
          { required: true, message: "中国商标权证书不能为空", trigger: "blur" },
        ],
        checkStatus:[
          { required: true, message: "请选择审核状态", trigger: "blur" },
        ]
      },
      licenseRule:{
        company_name:[
           { required: true, message: "公司名称不能为空", trigger: "blur" },
        ],
        company_type:[
          { required: true, message: "请选择公司类型", trigger: "blur" },
        ],
        register_address:[
          { required: true, message: "注册地址不能为空", trigger: "blur" },
        ],
        legal_person:[
            { required: true, message: "公司法人不能为空", trigger: "blur" },
        ],
        capital:[
          { required: true, message: "注册资本不能为空", trigger: "blur" },
        ],
        business_license_code:[
          { required: true, message: "营业执照号码不能为空", trigger: "blur" },
        ],
        business_license_url:[
          { required: true, message: "营业执照不能为空", trigger: "blur" },
        ],
        checkStatus:[
          { required: true, message: "请选择审核状态", trigger: "blur" },
        ]
      },
      rule:{
        recharge:[
          { required: true, message: "充值金额不能为空", trigger: "blur" },
          { type: 'number', message: '充值金额必须为数字值'}
        ],
        password:[
          { required: true, message: "密码不能为空", trigger: "blur" },
        ],
      }
    }
  },
  created(){
    this.getList()
    this.getDicts({type:'partner_status'}).then(res=>{
      this.statusOptions=res.data
    })
    this.getDicts({type:'company_type'}).then(res=>{
      this.companyTypeOptions=res.data
    })
  },
  filters:{
    auth:function(value){
      var status;
      switch (Number(value)){
        case 0:
          status='未认证'
          break;
        case 1:
          status='已认证'
          break;
        case 2:
          status='未通过'
          break;
        case 3:
          status='更新中'
          break;
      }
      return status
    }
  },
  methods:{
    getList(){
      var params=Object.assign({},this.queryForm)
      if(!this.queryForm.duration||this.queryForm.duration.length==0){
        params.startTime=''
        params.endTime=''
      }else{
        params.startTime=this.queryForm.duration[0]
        params.endTime=this.queryForm.duration[1]
      }
      delete params.duration
      listDealer(params).then(res=>{
        this.total=res.total
        this.tableData=res.data
      })
    },
    query(){
      this.queryForm.pageNum = 1;
      this.getList();
    },
    resetQuery(formName){
      this.$refs[formName].resetFields();
      this.query()
    },
    handleInfo(row){
      this.$router.push({path:'/dealer/dealerInfo',query:{id:row.id}})
    },
    status(row){
      if(row.status==0) return '未授权'
      if(row.status==1) return '正常'
      if(row.status==2||row.status==3) return '已禁用'
    },
    handleCommand(command, row) {
      switch (command) {
        case "handleRecharge":
          this.handleRecharge(row);
          break;
        case "handleDele":
          this.handleDele(row);
          break;
        default:
          break;
      }
    },
    handleRecharge(row){
      this.reset()
      getDealerInfo({id:row.id}).then(res=>{
        this.rechargeFrom.id=res.data.id
        this.rechargeDialog=true
        this.rechargeFrom.code=res.data.code
        this.rechargeFrom.dealer_name=res.data.dealer_name
        this.rechargeFrom.account=res.data.account
        this.rechargeFrom.behalf_balance=res.data.behalf_balance
      })
    },
    handleDele(row){
      this.$confirm('是否确认删除"' + row.dealer_name + '"品牌商?', "警告", {
          confirmButtonText: "确定",
          cancelButtonText: "取消",
          type: "warning"
      }).then(function() {
        return delDealer({id:row.id});
      }).then(() => {
        this.getList();
        this.msgSuccess("删除成功");
      }).catch(() => {});
    },
    handleCut(row){
      var text=row.status==0||row.status==1?'禁用':'恢复'
      this.$confirm(`是否${text}${row.dealer_name}品牌商`, "警告", {
          confirmButtonText: "确定",
          cancelButtonText: "取消",
          type: "warning"
      }).then(function() {
        return cutDealer({id:row.id,status:row.status});
      }).then((res) => {
        this.getList();
        this.msgSuccess(res.msg);
      }).catch(() => {});
    },
    submitForm(){
      this.$refs["rechargeFrom"].validate(valid => {
        if(valid){
          rechargeDealer(this.rechargeFrom).then(response=>{
            if(response.code==200){
              this.$message.success(response.msg)
              this.rechargeDialog = false;
              this.getList();
            }else{
              this.$message.error(response.msg)
            }
          })
        }
      })
    },
    submitTrademarkFrom(){
      this.$refs["trademarkFrom"].validate(valid => {
        if(valid){
          var arr=Object.assign({},this.trademarkFrom)
          arr.status=this.trademarkFrom.checkStatus
          arr.dealer_id=this.dealer_id
          delete arr.checkStatus
          delete arr.name
          delete arr.tips
          delete arr.type
          checkTrademark(arr).then(res=>{
            if(res.code==200){
              this.$message.success(res.msg)
              this.trademarkDialog = false;
              getAuthData({id:this.dealer_id}).then(res=>{
                this.authData=res.data
              })
              this.getList()
            }else{
              this.$message.error(res.msg)
            }
          })
        }
      })
    },
    submitLicenseFrom(){
      this.$refs["licenseFrom"].validate(valid => {
        if(valid){
          var arr=Object.assign({},this.licenseFrom)
          arr.status=this.licenseFrom.checkStatus
          arr.business_period=this.licenseFrom.business_period.join(',')
          arr.dealer_id=this.dealer_id
          delete arr.checkStatus
          delete arr.name
          delete arr.tips
          delete arr.type
          checkLicense(arr).then(res=>{
            if(res.code==200){
              this.$message.success(res.msg)
              this.licenseDialog = false;
              getAuthData({id:this.dealer_id}).then(res=>{
                this.authData=res.data
              })
              this.getList()
            }else{
              this.$message.error(res.msg)
            }
          })
        }
      })
    },
    auth(row){
      getAuthData({id:row.id}).then(res=>{
        this.authData=res.data
        this.dealer_id=row.id
        this.authDialog=true
      })
    },
    handleAuth(row){
      if(row.type==1){
        //认证营业执照
        this.resetForm('licenseFrom')
        this.licenseDialog=true
        var arr=Object.assign({},this.authData[0])
        arr.business_period=arr.business_period?arr.business_period.split(','):undefined
        this.licenseFrom=arr,
        this.$forceUpdate()
      }else{
        //认证商标
        this.resetForm('trademarkFrom')
        this.trademarkDialog=true
        this.trademarkFrom=this.authData[1],
        this.$forceUpdate()
      }
    },
    checktrademarkFrom(){
      console.log(this.trademarkFrom.checkStatus)
      this.$forceUpdate()
    },
    checkLicenseFrom(){
      this.$forceUpdate()
    },
    handleSuccess(res,file){
      this.trademarkFrom.trademark_cert = res.filePath;
      this.$forceUpdate()
    },
    handleSuccessSupplement(res,file){
      this.trademarkFrom.trademark_supplement=res.filePath
      this.$forceUpdate()
    },
    handleSuccessLicense(res,file){
      this.licenseFrom.business_license_url=res.filePath
      this.$forceUpdate()
    },
     beforeUpload(file){
        const isJPG = file.type === 'image/jpeg'||file.type === 'image/png'||file.type === 'image/jpg';
        const isLt2M = file.size / 1024 / 1024 < 5;
        if (!isJPG) {
          this.$message.error('上传头像图片只能是 jpg/png 格式!');
        }
        if (!isLt2M) {
          this.$message.error('上传图片大小不能超过 5MB!');
        }
        return isJPG && isLt2M;
    },
    cancel(){
      this.rechargeDialog = false;
      this.reset();
    },
    reset(){
      this.rechargeFrom={
        id:'',
        recharge:undefined,
        password:undefined,
        remark:undefined
      }
      this.resetForm("rechargeFrom");
    }
  }
}
</script>

<style lang="scss" scoped>
.authDialog{
  .avatar-uploader .el-upload {
    border: 1px dashed #d9d9d9;
    border-radius: 6px;
    cursor: pointer;
    position: relative;
    overflow: hidden;
  }
  ::v-deep .avatar-uploader .el-upload:hover {
    border-color: #409EFF;
  }
  .avatar-uploader-icon {
    font-size: 28px;
    color: #8c939d;
    width: 120px;
    height: 120px;
    line-height: 120px;
    border: 1px dashed #8c939d;
    text-align: center;
  }
  .avatar {
    width: 120px;
    height: 120px;
    display: block;
  }
}
.tips{
  padding: 10px;
  background: #eeeeee;
  margin-bottom: 20px 0;
}
</style>