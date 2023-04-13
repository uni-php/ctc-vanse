<template>
  <div class="app-container">
      <div class="tab-bar">
        <el-form ref="queryForm" :model="queryForm" label-width="100px" :inline="true" size="small">
            <el-form-item label="合伙人编号" prop="id">
                <el-input style="width:240px" v-model="queryForm.id" placeholder="请输入合伙人编号"></el-input>
            </el-form-item>
            <el-form-item label="公司名称" prop="company">
                <el-input style="width:240px" v-model="queryForm.company" placeholder="请输入公司名称"></el-input>
            </el-form-item>
            <el-form-item label="合伙人级别" prop="level_id">
              <el-select style="width:240px" v-model="queryForm.level_id" placeholder="请选择合伙人级别">
                <el-option
                  v-for="item in levelOptions"
                  :key="item.id"
                  :label="item.level_name"
                  :value="item.id">
                  <span style="float: left">{{ item.level+'-'+item.level_name }}</span>
                </el-option>
              </el-select>
            </el-form-item>
            <el-form-item label="状态" prop="status">
              <el-select style="width:240px" v-model="queryForm.status" placeholder="请选择合伙人状态">
                <el-option
                  v-for="dict in statusOptions"
                  :key="dict.dict_value"
                  :label="dict.dict_label"
                  :value="dict.dict_value">
                </el-option>
              </el-select>
            </el-form-item>
            <el-form-item label="签约时间" prop="duration">
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
      <el-col :span="24" style="margin:10px 0;">
        <el-button v-hasPermi="['partner:partnerList:addPartner']" @click="addPartner" type="primary" size="small" >添加合伙人</el-button>
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
      <el-table-column prop="id" align="center" label="编号" width="80px"></el-table-column>
      <el-table-column prop="company" align="center" label="公司名称" width="120px"></el-table-column>
      <el-table-column prop="account" align="center" label="合伙人账号" show-overflow-tooltip>
      </el-table-column>
      <el-table-column prop="level_id" align="center" label="合伙人级别" width="120px">
        <template slot-scope="scope">
          <span>{{level(scope.row.level_id)}}</span>
        </template>
      </el-table-column>
      <el-table-column prop="deposit" align="center" label="预存款">
      </el-table-column>
      <el-table-column prop="balance" align="center" label="账户余额">
      </el-table-column>
      <el-table-column prop="duration" align="center" show-overflow-tooltip label="签约时间">
         <template slot-scope="scope">
          <span>{{scope.row.duration|duration}}</span>
        </template>
      </el-table-column>
      <el-table-column prop="status" align="center" label="状态">
        <template slot-scope="scope">
          <span>{{scope.row.status==0?'正常':'禁用'}}</span>
        </template>
      </el-table-column>
      <el-table-column prop="is_auth" align="center" label="营业执照认证">
        <template slot-scope="scope">
          <el-link v-hasPermi="['partner:partnerList:authInfoView']"  @click="auth(scope.row)" type="primary">{{scope.row.is_auth|auth}}</el-link>
        </template>
      </el-table-column>
      <el-table-column prop="domain" align="center" label="自定义域名">
      </el-table-column>
      <el-table-column prop="copy" align="center" show-overflow-tooltip label="自定义版权">
      </el-table-column>
      <el-table-column prop="logo" align="center" label="自定义logo">
        <template slot-scope="scope">
          <span v-if="scope.row.logo">
            <el-image style="width: 35px; height: 35px" :src="scope.row.logo" fit="fill"></el-image>
          </span>
          <span v-else>--</span>
        </template>
      </el-table-column>
      <el-table-column label="操作" align="center" fixed="right" width="240px">
        <template slot-scope="scope">
          <el-button
            size="mini"
            type="primary"
            v-hasPermi="['partner:partnerList:editPartner']"
            @click="handleEdit(scope.row)">修改</el-button>
          <el-button
            size="mini"
            type="danger"
            v-hasPermi="['partner:partnerList:delePartner']"
            @click="handleDelete(scope.row)">删除</el-button>
          <el-dropdown size="mini" @command="(command) => handleCommand(command, scope.row)">
              <span class="el-dropdown-link" v-hasPermi="['partner:partnerList:moreOption']">
                <i class="el-icon-d-arrow-right el-icon--right"></i>更多
              </span>
              <el-dropdown-menu slot="dropdown">
                <el-dropdown-item command="handleResetPwd" v-hasPermi="['partner:partnerList:resetPwd']" icon="el-icon-key"
                  >重置密码</el-dropdown-item>
                <el-dropdown-item command="handleInfo" v-hasPermi="['partner:partnerList:partnerView']" icon="el-icon-info"
                  >详情</el-dropdown-item>
                <el-dropdown-item command="handleCut" v-hasPermi="['partner:partnerList:cutPartner']" icon="el-icon-remove"
                >{{scope.row.status==0?'禁用':'恢复'}}</el-dropdown-item>
              </el-dropdown-menu>
          </el-dropdown>
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
    <el-dialog :title="dialogTitle" :visible.sync="open" width="60%" @close="open=false">
        <el-form :model="form" ref="form" label-width="140px" :rules="rule" size="medium">
          <el-row>
            <el-col :span="12">
              <el-form-item label="公司名称" prop="company">
                <el-input  v-model="form.company" placeholder="请输入公司名称"/>
              </el-form-item>
            </el-col>
            <el-col :span="12">
              <el-form-item label="合伙人级别" prop="level_id">
                <el-select style="width:100%" @change="selectLevel" v-model="form.level_id" placeholder="请选择合伙人级别">
                  <el-option
                    v-for="item in levelOptions"
                    :key="item.id"
                    :label="item.level_name"
                    :value="item.id">
                    <span style="float: left">{{ item.level+'-'+item.level_name }}</span>
                  </el-option>
                </el-select>
              </el-form-item>
            </el-col>
          </el-row>
          <el-row>
            <el-col :span="12">
              <el-form-item label="签约时间" prop="duration">
                <el-date-picker
                  style="width:100%"
                  v-model="form.duration"
                  type="daterange"
                  unlink-panels=""
                  range-separator="至"
                  format="yyyy 年 MM 月 dd 日"
                  value-format="yyyy-MM-dd"
                  start-placeholder="开始日期"
                  end-placeholder="结束日期">
                </el-date-picker>
              </el-form-item>
            </el-col>
            <el-col :span="12">
              <el-form-item label="联系人" prop="contact_name">
                <el-input  v-model="form.contact_name" placeholder="请输入联系人姓名"/>
              </el-form-item>
            </el-col>
          </el-row>
          <el-row>
            <el-col :span="12">
              <el-form-item label="手机号" prop="phone">
                <el-input  v-model="form.phone" placeholder="请输入手机号"/>
              </el-form-item>
            </el-col>
            <el-col :span="12">
              <el-form-item label="账号" prop="account">
                <el-input  v-model="form.account" placeholder="请输入账户"/>
              </el-form-item>
            </el-col>
          </el-row>
          <el-row v-if="!form.id">
            <el-col :span="12">
              <el-form-item label="密码" prop="password">
                <el-input  v-model="form.password" placeholder="请输入密码"/>
              </el-form-item>
            </el-col>
            <el-col :span="12">
              <el-form-item label="再次输入密码" prop="passwords">
                <el-input  v-model="form.passwords" placeholder="请输入密码"/>
              </el-form-item>
            </el-col>
          </el-row>
          <el-row>
            <el-col :span="12">
              <el-form-item label="详细地址" prop="address">
                <el-cascader
                  size="medium"
                  style="width:100%"
                  :options="options"
                  placeholder="请选择地址"
                  v-model="selectedOptions"
                  @change="handleChange">
                </el-cascader>
              </el-form-item>
            </el-col>
            <el-col :span="12">
              <el-form-item label="街道" prop="street">
                <el-input  v-model="form.street" placeholder="请输入详细地址"/>
              </el-form-item>
            </el-col>
          </el-row>
          <el-row>
            <el-col :span="12">
              <el-form-item label="官方网站" prop="website">
                <el-input  v-model="form.website" placeholder="请输入官方网站"/>
              </el-form-item>
            </el-col>
            <el-col :span="12">
              <el-form-item label="所属行业" prop="industry">
                <el-select style="width:100%" v-model="form.industry" placeholder="请选择所属行业">
                  <el-option
                    v-for="dict in industryOptions"
                    :key="dict.id"
                    :label="dict.dict_label"
                    :value="dict.dict_value">
                  </el-option>
                </el-select>
              </el-form-item>
            </el-col>
          </el-row>
          <el-row>
            <el-col :span="12">
              <el-form-item label="E-Mail" prop="email">
                <el-input  v-model="form.email" placeholder="请输入公司邮箱"/>
              </el-form-item>
            </el-col>
            <el-col :span="12">
              <el-form-item label="联系电话" prop="telephone">
                <el-input  v-model="form.telephone" placeholder="请输入公司联系电话"/>
              </el-form-item>
            </el-col>
          </el-row>
          <el-row>
            <el-col :span="12" v-if="levelConfig.is_custom_domain=='1'">
              <el-form-item label="自定义域名" prop="domain">
                <el-input  v-model="form.domain" placeholder="请输入自定义域名"/>
              </el-form-item>
            </el-col>
            <el-col :span="12">
              <el-form-item label="应用域名" prop="app_domain">
                <el-input  v-model="form.app_domain" placeholder="请输入应用域名"/>
              </el-form-item>
            </el-col>
          </el-row>
          <el-row>
            <el-col :span="12" v-if="levelConfig.is_custom_name=='1'">
              <el-form-item label="自定义平台名" prop="platform_name">
                <el-input  v-model="form.platform_name" placeholder="请输入自定义平台名"/>
              </el-form-item>
            </el-col>
            <el-col :span="12" v-if="levelConfig.is_custom_copy=='1'" > 
              <el-form-item label="自定义版权信息" prop="copy">
                <el-input  v-model="form.copy" placeholder="请输入自定义版权信息"/>
              </el-form-item>
            </el-col>
          </el-row>
          <el-row>
            <el-col :span="12" v-if="levelConfig.is_custom_logo=='1'">
              <el-form-item label="后台logo" prop="logo">
                <el-upload
                  class="avatar-uploader"
                  :action="upload.url"
                  :headers="upload.headers"
                  :show-file-list="false"
                  :on-success="handleSuccess"
                  name="img"
                  :before-upload="beforeUpload">
                  <img v-if="form.logo" :src="form.logo" class="avatar">
                  <i v-else class="el-icon-plus avatar-uploader-icon"></i>
                  <div slot="tip" class="el-upload__tip">图片大小不超过2M，支持jpg/png格式</div>
                </el-upload>
              </el-form-item>
            </el-col>
            <el-col :span="12">
              <el-form-item label="登录logo" prop="login_logo">
                <el-upload
                  class="avatar-uploader"
                  :action="upload.url"
                  :headers="upload.headers"
                  :show-file-list="false"
                  :on-success="handleLogoSuccess"
                  name="img"
                  :before-upload="beforeUpload">
                  <img v-if="form.login_logo" :src="form.login_logo" class="avatar">
                  <i v-else class="el-icon-plus avatar-uploader-icon"></i>
                  <div slot="tip" class="el-upload__tip">图片大小不超过2M，支持jpg/png格式</div>
                </el-upload>
              </el-form-item>
            </el-col>
          </el-row>
          <el-col :span="12">
              <el-form-item label="标题ico" prop="ico">
                <el-upload
                  class="upload-demo"
                  :action="upload.url"
                  :on-preview="handlePreview"
                  :on-remove="handleRemove"
                  name="img"
                  accept=".ico"
                  :before-remove="beforeRemove"
                  :limit="1"
                  :headers="upload.headers"
                  :on-success="handleIcoSuccess"
                  :on-exceed="handleExceed"
                  :file-list="icoList">
                  <el-button size="small" type="primary">点击上传</el-button>
                  <div slot="tip" class="el-upload__tip">只支持ico格式</div>
                </el-upload>
              </el-form-item>
          </el-col>
        </el-form>
        <div slot="footer" class="dialog-footer">
          <el-button type="primary" @click="submitForm">确 定</el-button>
          <el-button @click="cancel">取 消</el-button>
        </div>
    </el-dialog>
    <!-- 资质认证 -->
    <el-dialog title="合伙人资质认证" :visible.sync="authDialog" width="60%" @close="authDialog=false">
      <el-row class="tips">
        <el-col>
          1、开通企鹅码平台的品牌商必须是依法在中国大陆注册的企业或个体工商户，须持有商标或商标授权书。为了您能正常使用企鹅码系统 功能入扫码查询，营销等，请先完成企业资质和商标资质认证。
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
          <el-table-column prop="is_auth" width="100px" align="center" label="状态">
            <template slot-scope="scope">
              <span>{{scope.row.is_auth|auth}}</span>
            </template>
          </el-table-column>
          <el-table-column prop="tips" align="center" label="说明"></el-table-column>
          <el-table-column label="操作" align="center" fixed="right" width="200px">
              <template slot-scope="scope">
                <el-button
                  size="mini"
                  v-hasPermi="['partner:partnerList:authInfoView']"
                  type="primary"
                  @click="handleAuth(scope.row)">{{scope.row.is_auth|auth}}</el-button>
              </template>
          </el-table-column>
      </el-table>
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
            <i v-show="licenseFrom.is_auth=='0'||licenseFrom.is_auth=='2'" style="color:red" class="el-icon-error"></i>
            <i v-show="licenseFrom.is_auth=='3'" style="color:red" class="el-icon-warning"></i>
            <i v-show="licenseFrom.is_auth=='1'" style="color:red" class="el-icon-circle-check"></i>
            {{licenseFrom.is_auth|auth}}
          </el-form-item>
          <el-form-item label="公司名称:" prop="company">
            <el-input style="width:80%"  v-model="licenseFrom.company" placeholder="请填写公司名称"/>
          </el-form-item>
          <el-form-item label="公司类型:" prop="qualification_type">
            <el-select style="width:80%" v-model="licenseFrom.qualification_type" placeholder="请选择公司类型" clearable>
              <el-option
                v-for="dict in companyTypeOptions"
                :key="dict.dict_value"
                :label="dict.dict_label"
                :value="dict.dict_value"
              />
            </el-select>
          </el-form-item>
          <el-form-item label="注册地址:" prop="registered_address">
            <el-input style="width:80%"  v-model="licenseFrom.registered_address" placeholder="请填写公司注册地址"/>
          </el-form-item>
          <el-form-item label="公司法人:" prop="representative">
            <el-input style="width:80%"  v-model="licenseFrom.representative" placeholder="请填写公司法人"/>
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
          <el-form-item label="营业执照号码:" prop="business_license">
            <el-input style="width:80%"  v-model="licenseFrom.business_license" placeholder="请填写公司营业执照号码"/>
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
          <el-form-item label="审核操作:" prop="is_auth">
            <el-radio-group v-model="licenseFrom.is_auth">
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
          <el-button v-hasPermi="['partner:partnerList:editAuthInfo']" type="primary" @click="submitLicenseFrom">立即提交</el-button>
        </div>
      </el-dialog>
    </el-dialog>
  </div>
</template>
<script>
import {listLevel,listPartner,addPartner,getPartnerInfo,resetUserPwd,disableAccount,getAuthData,delePartner,checkLicense} from "@/api/partner/index";
import { getToken } from "@/utils/auth";
import { regionDataPlus,CodeToText, TextToCode } from 'element-china-area-data'
export default {
    data(){
        return{
            levelConfig:{},
            queryForm:{
                id:'',
                company:'',
                level_id:'',
                duration:[],
                status:'',
                pageNum:1,
                pageSize:10
            },
            partner_id:undefined,
            levelOptions:[],
            statusOptions:[],
            industryOptions:[],
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
            companyTypeOptions:[],
            //上传参数
            upload:{
              headers: { Authorization: "Bearer " + getToken() },
              // 上传的地址
              url: process.env.VUE_APP_BASE_API + "/main/partner/uploadImg"
            },
            fileLogoList:[],
            loginLogoList:[],
            icoList:[],
            dialogTitle:'',
            options: regionDataPlus,
            open:false,
            login_logo:'',
            authDialog:false,
            licenseDialog:false,
            authData:[],
            logo:"",
            form:{
              logo:'',
              login_logo:'',
            },
            licenseFrom:{
            },
            selectedOptions: [],
            licenseRule:{
              company:[
                { required: true, message: "公司名称不能为空", trigger: "blur" },
              ],
              qualification_type:[
                { required: true, message: "请选择公司类型", trigger: "blur" },
              ],
              registered_address:[
                { required: true, message: "注册地址不能为空", trigger: "blur" },
              ],
              representative:[
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
              is_auth:[
                { required: true, message: "请选择审核状态", trigger: "blur" },
              ]
            },
            rule:{
              company:[
                { required: true, message: "请填写公司名称", trigger: "blur" }
              ],
              level_id:[
                { required: true, message: "请选择合伙人级别", trigger: "blur" }
              ],
              duration:[
                { required: true, message: "请选择签约时间", trigger: "blur" }
              ],
              contact_name:[
                { required: true, message: "请填写联系人", trigger: "blur" }
              ],
              phone:[
                { required: true, message: "请填写手机号", trigger: "blur" }
              ],
              account:[
                { required: true, message: "请填写账号", trigger: "blur" }
              ],
              password:[
                { required: true, message: "请填写密码", trigger: "blur" }
              ],
              passwords:[
                { required: true, message: "请填写密码", trigger: "blur" }
              ],
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
        this.getLevelOptions();
        this.getDicts({type:'partner_status'}).then(res=>{
            this.statusOptions=res.data
        })
        this.getDicts({type:'partner_industry'}).then(res=>{
            this.industryOptions=res.data
        }),
        this.getDicts({type:'company_type'}).then(res=>{
          this.companyTypeOptions=res.data
        })
    },
    filters:{
      duration:function(value){
        var date=value.split(',')
        return `${date[0]}至${date[1]}`
      },
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
            listPartner(params).then(res=>{
              this.total=res.total
              this.tableData=res.data
            })
        },
        level(val){
          return this.levelOptions.filter(item=>item.id==val).map(item=>item.level_name)[0]
        },
        //选择合伙人级别
        selectLevel(val){
          var levelConfig=this.levelOptions.filter(item=>item.id==val)[0]
          this.levelConfig=levelConfig
        },
        getLevelOptions(){
          listLevel({level_name:"",pageNum:1,pageSize:999}).then(res=>{
            this.levelOptions=res.data
          })
        },
        addPartner(){
          this.dialogTitle='添加合伙人（基础信息）'
          this.reset();
          this.open=true
        },
        reset() {
          this.form = {
              id:undefined,
              company:'',
              level_id:'',
              duration:[],
              contact_name:'',
              phone:'',
              account:'',
              password:'',
              passwords:'',
              logo:'',
              login_logo:'',
              ico:'',
              selectedOptions:[],
              street:'',
              website:'',
              industry:'',
              email:'',
              telephone:'',
              domain:"",
              platform_name:'',
              copy:""
          };
          this.login_logo='',
          this.logo=''
          this.resetForm("form");
        },
        handleRemove(file, fileList) {
          console.log(file, fileList);
          this.form.icon=''
        },
        handlePreview(file) {
          console.log(file);
        },
        checkLicenseFrom(){
          this.$forceUpdate()
        },
        handleExceed(files, fileList) {
          this.$message.warning(`当前限制选择 1 个文件，本次选择了 ${files.length} 个文件，共选择了 ${files.length + fileList.length} 个文件`);
        },
        beforeRemove(file, fileList) {
          return this.$confirm(`确定移除 ${ file.name }？`);
        },
        handleSuccess(res,file){
          // this.logo=URL.createObjectURL(file.raw);
          this.form.logo = res.filePath;
        },
        handleIcoSuccess(res,file){
          this.form.ico=res.filePath
        },
        handleLogoSuccess(res,file){
          // this.login_logo = URL.createObjectURL(file.raw);
          this.form.login_logo=res.filePath
        },
        handleSuccessLicense(res,file){
          this.licenseFrom.business_license_url=res.filePath
        },
        beforeUpload(file){
            const isJPG = file.type === 'image/jpeg'||file.type === 'image/png'||file.type === 'image/jpg';
            const isLt2M = file.size / 1024 / 1024 < 2;
            if (!isJPG) {
              this.$message.error('上传头像图片只能是 jpg/png 格式!');
            }
            if (!isLt2M) {
              this.$message.error('上传图片大小不能超过 2MB!');
            }
            return isJPG && isLt2M;
        },
        handleChange (value) {
        },
        //合伙人认证
        auth(row){
          getAuthData({id:row.id}).then(res=>{
            this.authData=res.data
            this.partner_id=row.id
            this.authDialog=true
          })
        },
        handleAuth(row){
          this.resetForm('licenseFrom')
          this.licenseDialog=true
          var arr=Object.assign({},this.authData[0])
          arr.business_period=arr.business_period?arr.business_period.split(','):[]
          arr.is_auth=arr.is_auth==0?undefined:arr.is_auth
          this.licenseFrom=arr,
          this.$forceUpdate()
        },
        handleCommand(command, row) {
          switch (command) {
            case "handleResetPwd":
              this.handleResetPwd(row);
              break;
            case "handleCut":
              this.handleCut(row);
              break;
            case "handleInfo":
              this.handleInfo(row);
              break;
            default:
              break;
          }
        },
        handleInfo(row){
          this.$router.push({path:'/partner/partnerInfo',query:{id:row.id}})
        },
        /** 重置密码按钮操作 */
        handleResetPwd(row) {
          this.$prompt('请输入"' + row.account + '"的新密码', "提示", {
            confirmButtonText: "确定",
            cancelButtonText: "取消",
            closeOnClickModal: false,
            inputPattern: /^.{5,20}$/,
            inputErrorMessage: "用户密码长度必须介于 5 和 20 之间",
          }).then(({ value }) => {
              resetUserPwd({id:row.id, password:value}).then(response => {
                this.$message.success("修改成功，新密码是：" + value)
              });
            }).catch(() => {});
        },
        handleCut(row){
           var statusTxt=row.status==0?'禁用':"恢复"
           var status=row.status==0?1:0
           this.$confirm(`确定${statusTxt}该合伙人账户吗, 是否继续?`, '提示', {
              confirmButtonText: '确定',
              cancelButtonText: '取消',
              type: 'warning'
            }).then(() => {
              disableAccount({id:row.id,status:status}).then(res=>{
                if(res.code==200){
                  this.$message.success(`成功${statusTxt}`)
                  this.getList()
                }else{
                  this.$message.error(res.msg)
                  this.getList()
                }
              })
            }).catch(() => {
                      
            });
        },
        // 取消按钮
        cancel() {
          this.open = false;
          this.reset();
        },
        submitForm(){
          this.$refs["form"].validate(valid => {
            if(valid){
              if(!this.form.id){
                if(this.form.passwords!=this.form.password){
                this.$message.error('密码前后输入不一致')
                return;
              }
              }
              var arr=Object.assign({},this.form)
                arr.start_time=arr.duration[0]//转换为字符串
                arr.end_time=arr.duration[1]
                arr.province=CodeToText[this.selectedOptions[0]]
                arr.city=CodeToText[this.selectedOptions[1]]
                arr.county=CodeToText[this.selectedOptions[2]]
                arr.duration=arr.duration.join(',')
                delete arr.passwords
              if(arr.id!=undefined){
                addPartner(arr).then(response => {
                  if(response.code==200){
                    this.$message.success(response.msg)
                    this.open = false;
                    this.getList();
                  }else{
                    this.$message.error(response.msg)
                  }
                });
              }else{
                addPartner(arr).then(response => {
                  if(response.code==200){
                    this.$message.success(response.msg)
                    this.open = false;
                    this.getList();
                  }else{
                    this.$message.error(response.msg)
                  }
                });
              }
            }
          })
        },
        handleEdit(row){
          this.reset();
          getPartnerInfo({id:row.id}).then(res=>{
            var arr=res.data
            arr.duration=arr.duration.split(',')
            if(arr.province){
              this.selectedOptions[0]=TextToCode[arr.province].code
              this.selectedOptions[1]=TextToCode[arr.province][arr.city].code
              this.selectedOptions[2]=TextToCode[arr.province][arr.city][arr.county].code
            }
            arr.industry=String(arr.industry)
            this.form=arr
            this.open=true
            this.dialogTitle='修改合伙人（基础信息）'
            //更新合伙人级别信息
            this.levelConfig=this.levelOptions.filter(item=>item.id==arr.level_id)[0]
          })
        },
        submitLicenseFrom(){
          this.$refs["licenseFrom"].validate(valid => {
            if(valid){
              var arr=Object.assign({},this.licenseFrom)
              arr.business_period=this.licenseFrom.business_period.join(',')
              delete arr.name
              delete arr.tips
              checkLicense(arr).then(res=>{
                if(res.code==200){
                  this.$message.success(res.msg)
                  this.licenseDialog = false;
                  getAuthData({id:this.partner_id}).then(res=>{
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
        handleDelete(row){
          this.$confirm('是否确认删除"' + row.account + '"合伙人?', "警告", {
              confirmButtonText: "确定",
              cancelButtonText: "取消",
              type: "warning"
          }).then(function() {
            return delePartner({id:row.id});
          }).then((res) => {
            if(res.code==200){
              this.$message.success(res.msg)
              this.getList();
            }else{
              this.$message.error(res.msg)
            }
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

<style lang="scss" scoped>
.app-container,.authDialog{
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
  .tips{
    padding: 10px;
    background: #eeeeee;
    margin-bottom: 20px 0;
  }
}
</style>>