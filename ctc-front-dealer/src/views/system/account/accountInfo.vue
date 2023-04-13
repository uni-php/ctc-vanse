<template>
  <div class="app-container">
      <el-form :model="dealerInfo" ref="form" style="margin-top:30px" label-width="140px" v-show="isShow" :rules="rule" size="medium">
          <el-row>
            <el-col :span="8">
                <el-form-item label="品牌商名称：" prop="dealer_name">
                    <span>{{dealerInfo.dealer_name}}</span>
                </el-form-item>
            </el-col>
            <el-col :span="8">
                <el-form-item label="公司名称：" prop="company">
                    <span>{{dealerInfo.company}}</span>
                </el-form-item>
            </el-col>
          </el-row>
          <el-row>
            <el-col :span="8">
                <el-form-item label="联系人：" prop="concact_name">
                    <span>{{dealerInfo.concact_name}}</span>
                </el-form-item>
            </el-col>
            <el-col :span="8">
                <el-form-item label="手机号：" prop="phone">
                    <span>{{dealerInfo.phone}}</span>
                </el-form-item>
            </el-col>
          </el-row>
          <el-row>
            <el-col :span="8">
                <el-form-item label="联系地址：" prop="district">
                <el-cascader
                  size="medium"
                  style="width:80%"
                  :options="options"
                  placeholder="请选择地址"
                  v-model="dealerInfo.selectedOptions"
                  @change="handleChange">
                </el-cascader>
              </el-form-item>
            </el-col>
            <el-col :span="8">
                <el-form-item label="详细地址：" prop="address">
                    <el-input style="width:80%"  v-model="dealerInfo.address" placeholder="请输入详细地址"/>
                </el-form-item>
            </el-col>
          </el-row>
          <el-row>
            <el-col :span="8">
                <el-form-item label="官方网站：" prop="website">
                    <el-input style="width:80%" v-model="dealerInfo.website" placeholder="请输入网站地址"/>
                </el-form-item>
            </el-col>
            <el-col :span="8">
             <el-form-item label="所属行业：" prop="industry">
                <el-select style="width:80%" v-model="dealerInfo.industry" placeholder="请选择所属行业">
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
            <el-col :span="8">
                <el-form-item label="E-Mail：" prop="email">
                    <el-input style="width:80%" v-model="dealerInfo.email" placeholder="请输入邮箱地址"/>
                </el-form-item>
            </el-col>
            <el-col :span="8">
                <el-form-item label="客服电话：" prop="telephone">
                    <el-input style="width:80%" v-model="dealerInfo.telephone" placeholder="请输入客服电话"/>
                </el-form-item>
            </el-col>
          </el-row>
          <el-row>
            <el-col :span="12">
              <el-form-item label="品牌logo" prop="logo">
                <el-upload
                  class="avatar-uploader"
                  :action="upload.url"
                  :headers="upload.headers"
                  :show-file-list="false"
                  :on-success="handleSuccess"
                  name="img"
                  :before-upload="beforeUpload">
                  <img v-if="dealerInfo.logo" :src="dealerInfo.logo" class="avatar">
                  <i v-else class="el-icon-plus avatar-uploader-icon"></i>
                  <div slot="tip" class="el-upload__tip">图片大小不超过2M，支持jpg/png格式</div>
                </el-upload>
              </el-form-item>
            </el-col>
          </el-row>
          <el-row type="flex" justify="center">
            <el-col :span="8" style="text-align:start">
                <el-button type="primary" @click="save">保存</el-button>
            </el-col>
          </el-row>
      </el-form>
  </div>
</template>

<script>
import {getDealerInfo,saveDealerInfo} from "@/api/system/account";
import { getToken } from "@/utils/auth";
import { regionDataPlus,CodeToText, TextToCode } from 'element-china-area-data'
export default {
    data(){
        return{
            dealerInfo:{
            },
            rule:{

            },
            upload:{
                headers: { Authorization: "Bearer " + getToken() },
                url: process.env.VUE_APP_BASE_API + "/dealer/upload",
            },
            isShow:false,
            selectedOptions:["","",""],
            options: regionDataPlus,
            industryOptions:[]
        }
    },
    created(){
        this.getDealerInfo()
        this.getDicts({type:'partner_industry'}).then(res=>{
            this.industryOptions=res.data
        })
    },
    methods:{
        getDealerInfo(){
           getDealerInfo({}).then(res=>{
               this.$nextTick(()=>{
                    var arr=Object.assign({},res.data)
                    this.selectedOptions[0]=TextToCode[arr.province].code
                    this.selectedOptions[1]=TextToCode[arr.province][arr.city].code
                    this.selectedOptions[2]=TextToCode[arr.province][arr.city][arr.district].code
                    this.dealerInfo=arr
                    this.dealerInfo.selectedOptions=this.selectedOptions
                    this.isShow=true
               })
           }) 
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
        save(){
            var arr=Object.assign({},this.dealerInfo)
            arr.province=CodeToText[this.selectedOptions[0]]
            arr.city=CodeToText[this.selectedOptions[1]]
            arr.district=CodeToText[this.selectedOptions[2]]
            delete arr.selectedOptions
            saveDealerInfo(arr).then(res=>{
                if(res.code==200){
                    this.$message.success(res.msg)
                    this.getDealerInfo()
                }else{
                    this.$message.error(res.msg)
                }
            })
        },
        handleSuccess(res,file){
          this.dealerInfo.logo = res.filePath;
        },
        handleChange (value) {
        },
    }
}
</script>

<style lang="scss" scoped>
.app-container{
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