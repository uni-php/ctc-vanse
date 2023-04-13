<template>
  <div class="app-container">
       <div class="tips">
            <div>
              1、开通物元码平台的品牌商必须是依法在中国大陆注册的企业或个体工商户，须持有商标或商标授权书。为了您能正常使用物元码系统 功能入扫码查询，营销等，请先完成企业资质和商标资质认证。
            </div>
            <div style="margin-top:10px">
              2、所有提交的资质证书需为清晰彩色原件扫描件，复印件则需加盖公司红章，我们将在三个工作日内完成审核。
            </div>
       </div>
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
            width="50%"
            title="商标权认证"
            class="authDialog"
            :visible.sync="trademarkDialog"
            >
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
            </el-form>
            <div slot="footer" class="dialog-footer">
              <el-button type="primary" @click="submitTrademarkFrom">立即提交</el-button>
            </div>
          </el-dialog>
          <!-- 营业执照认证 -->
          <el-dialog
            width="50%"
            title="营业执照认证"
            class="authDialog"
            :visible.sync="licenseDialog"
            >
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
            </el-form>
            <div slot="footer" class="dialog-footer">
              <el-button type="primary" @click="submitLicenseFrom">立即提交</el-button>
            </div>
          </el-dialog>
  </div>
</template>

<script>
import { getToken } from "@/utils/auth";
import {getAuthData,checkTrademark,checkLicense} from "@/api/system/account";
export default {
    data(){
        return{
            authData:[],
            trademarkDialog:false,
            licenseDialog:false,
            companyTypeOptions:[],
            trademarkFrom:{

            },
            licenseFrom:{

            },
            upload:{
                headers: { Authorization: "Bearer " + getToken() },
                // 上传的地址
                url: process.env.VUE_APP_BASE_API + "/dealer/system/uploadTrademark",
            },
            trademarkRule:{
              trademark_code:[
                { required: true, message: "商标注册号/申请号不能为空", trigger: "blur" },
              ],
              trademark_cert:[
                { required: true, message: "中国商标权证书不能为空", trigger: "blur" },
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
                ]
            },
          }
    },
    created(){
        this.auth(),
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
            default:
            status='未认证'
        }
        return status
        }
  },
    methods:{
        auth(){
            getAuthData({}).then(res=>{
                this.authData=res.data
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
        submitTrademarkFrom(){
          this.$refs["trademarkFrom"].validate(valid => {
            if(valid){
              var arr=Object.assign({},this.trademarkFrom)
              delete arr.name
              delete arr.tips
              delete arr.type
              checkTrademark(arr).then(res=>{
                if(res.code==200){
                  this.$message.success(res.msg)
                  this.trademarkDialog = false;
                  getAuthData().then(res=>{
                    this.authData=res.data
                  })
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
              arr.business_period=this.licenseFrom.business_period.join(',')
              delete arr.name
              delete arr.tips
              delete arr.type
              checkLicense(arr).then(res=>{
                if(res.code==200){
                  this.$message.success(res.msg)
                  this.licenseDialog = false;
                  getAuthData().then(res=>{
                    this.authData=res.data
                  })
                }else{
                  this.$message.error(res.msg)
                }
              })
            }
          })
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
    padding: 20px 16px;
    background-color: #ecf8ff;
    border-radius: 4px;
    border-left: 5px solid #50bfff;
    margin: 10px 0;
    display: flex;
    flex-direction: column;
    min-height: 50px;
    justify-content: flex-start;
    // align-items: center;
}
</style>