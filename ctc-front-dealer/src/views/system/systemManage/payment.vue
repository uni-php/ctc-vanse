<template>
  <div class="app-container">
      <el-form :model="payInfo" ref="form" style="margin-top:30px" label-width="160px"  :rules="rule" size="medium">
        <el-form-item label="AppID：" prop="appid">
            <el-input style="width:35%"  v-model="payInfo.appid" placeholder="请输入公众号AppID"/>
            <span>（公众号应用AppID）</span>
        </el-form-item>
        <el-form-item label="AppSecret：" prop="appsecret">
            <el-input style="width:35%"  v-model="payInfo.appsecret" placeholder="请输入商户秘钥"/>
            <span>（32位的API密钥）</span>
        </el-form-item>
        <el-form-item label="商户号：" prop="mchid">
            <el-input style="width:35%"  v-model="payInfo.mchid" placeholder="请输入商户号"/>
        </el-form-item>
        <el-form-item label="支付证书(cert)：" prop="cert">
            <el-upload
                class="upload-demo"
                :action="upload.urls"
                :on-remove="handleCertRemove"
                name="cert"
                accept=".pem"
                :before-remove="beforeCertRemove"
                :limit="1"
                :headers="upload.headers"
                :on-success="handleCertSuccess"
                :on-exceed="handleCertExceed"
                :file-list="certList">
                <el-button size="small" type="primary">点击上传</el-button>
                <div slot="tip" class="el-upload__tip">只支持pem格式</div>
            </el-upload>
        </el-form-item>
        <el-form-item label="支付证书秘钥(key)：" prop="key">
            <el-upload
                class="upload-demo"
                :action="upload.url"
                :on-remove="handleRemove"
                name="key"
                accept=".pem"
                :before-remove="beforeRemove"
                :limit="1"
                :headers="upload.headers"
                :on-success="handleKeySuccess"
                :on-exceed="handleExceed"
                :file-list="keyList">
                <el-button size="small" type="primary">点击上传</el-button>
                <div slot="tip" class="el-upload__tip">只支持pem格式</div>
            </el-upload>
        </el-form-item>
        <el-row type="flex" justify="space-between">
            <el-col :span="8" style="padding-left:160px">
                <el-button type="primary" size="medium" @click="save">保存</el-button>
            </el-col>
        </el-row>
      </el-form>
  </div>
</template>

<script>
import { getToken } from "@/utils/auth";
import {savePayInfo,getPayInfo} from '@/api/system/sys/pay'
export default {
    data(){
        return{
            payInfo:{
                appid:'',
                appsecret:'',
                mchid:'',
                key:'',
                cert:''
            },
            rule:{
                appid:[
                    { required: true, message: "请输入公众号AppID", trigger: "blur" },
                ],
                appsecret:[
                    { required: true, message: "请输入商户秘钥", trigger: "blur" },
                ],
                mchid:[
                    { required: true, message: "请输入商户号", trigger: "blur" },
                ],
                cert:[
                    { required: true, message: "请上传商户证书", trigger: "blur" },
                ],
                key:[
                    { required: true, message: "请上传商户证书秘钥", trigger: "blur" },
                ]
            },
            upload:{
              headers: { Authorization: "Bearer " + getToken() },
              url: process.env.VUE_APP_BASE_API + "/dealer/system/uploadKey",
              urls: process.env.VUE_APP_BASE_API + "/dealer/system/uploadCert",
            },
            keyList:[],
            certList:[]
        }
    },
    created(){
        this.getPayInfo()
    },
    methods:{
        getPayInfo(){
            getPayInfo({}).then(res=>{
                this.payInfo=res.data?res.data:{}
                this.keyList=[]
                this.certList=[]
                this.keyList.push({
                    name:'apiclient_key.pem',
                    url:res.data.key
                })
                this.certList.push({
                    name:'apiclient_cert.pem',
                    url:res.data.cert
                })
            })
        },
        handleCertRemove(file, fileList){
            this.payInfo.cert=''
        },
        handleRemove(file, fileList) {
          this.payInfo.key=''
        },
        beforeRemove(file, fileList) {
          return this.$confirm(`确定移除 ${ file.name }？`);
        },
        beforeCertRemove(file, fileList) {
          return this.$confirm(`确定移除 ${ file.name }？`);
        },
        handleKeySuccess(res,file){
          this.payInfo.key=file.response
        },
        handleCertSuccess(res,file){
          this.payInfo.cert=file.response
        },
        handleCertExceed(files, fileList){
            this.$message.warning(`当前限制选择 1 个文件，本次选择了 ${files.length} 个文件，共选择了 ${files.length + fileList.length} 个文件`);
        },
        handleExceed(files, fileList) {
          this.$message.warning(`当前限制选择 1 个文件，本次选择了 ${files.length} 个文件，共选择了 ${files.length + fileList.length} 个文件`);
        },
        save(){
             this.$refs["form"].validate(valid => {
                 if(valid){
                     savePayInfo(this.payInfo).then(res=>{
                         if(res.code==200){
                            this.$message.success(res.msg)
                            this.getPayInfo()
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
.app-container{
    ::v-deep .el-upload-list{
    width: 25%;
}
}
</style>