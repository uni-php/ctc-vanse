<template>
  <div class="app-container">
      <div class="auth-box">
          <div class="tips">公众号二维码</div>
          <div class="img-box">
            <el-image style="width: 100px; height: 100px;" :src="auth_info.qrcode_url||''" fit="fill">
                <div slot="error" class="image-slot" style="margin:0 auto">
                    <i style="font-size:100px" class="el-icon-picture-outline"></i>
                </div>
            </el-image>
          </div>
          <div class="info-box">
              <div>微信昵称：{{auth_info.nick_name||'未授权'}}</div>
              <div>主体：{{auth_info.service_type_info.id|service_type_info}}/{{auth_info.verify_type_info.id|verify_type_info}}</div>
              <div>注册公司：{{auth_info.principal_name||'未授权'}}</div>
              <div>授权绑定：{{auth_info.create_time}}</div>
          </div>
          <div class="btn-box">
               <el-button v-if="auth_url" size="medium" @click="auth" type="primary">授权</el-button>
          </div>
      </div>
      <!-- <el-form :model="form" class="form" ref="form" label-width="160px" :rules="rule" size="medium">
        <el-divider content-position="left">公众号对接</el-divider>
        <el-form-item label="公众号AppID：" prop="oa_appid">
            <el-input style="width:40%"  v-model="form.oa_appid" placeholder="请输入公众号AppID"/>
        </el-form-item>
        <el-form-item label="公众号AppSecret：" prop="oa_secret">
            <el-input style="width:40%"  v-model="form.oa_secret" placeholder="请输入公众号AppSecret"/>
        </el-form-item>
         <el-divider content-position="left">小程序对接</el-divider>
        <el-form-item label="小程序AppID：" prop="mp_appid">
            <el-input style="width:40%"  v-model="form.mp_appid" placeholder="请输入小程序AppID"/>
        </el-form-item>
        <el-form-item label="公众号AppSecret：" prop="mp_secret">
            <el-input style="width:40%"  v-model="form.mp_secret" placeholder="请输入小程序AppSecret"/>
        </el-form-item>
        <el-form-item>
            <el-button type="primary" @click="onSubmit">提交</el-button>
        </el-form-item>
      </el-form> -->
  </div>
</template>

<script>
import {saveAuthConfig,getAuthConfig,saveAuthInfo} from '@/api/access/officialAccount/auth'
let that;
export default {
    data(){
        return{
            form:{
                oa_appid:'',//公众号appid
                oa_secret:'',//公众号secret
                mp_appid:'',//小程序appid
                mp_secret:'',//小程序secret
            },
            rule:{
                oa_appid:[
                    { required: true, message: "请输入公众号AppID", trigger: "blur" },
                ],
                oa_secret:[
                    { required: true, message: "请输入公众号AppSecret", trigger: "blur" },
                ]
            },
            auth_info:{
                qrcode_url:'',//头像
                nick_name:'',//昵称
                service_type_info:{id:''},//公众号类型
                verify_type_info:{id:''},//公众号认证类型
                principal_name:'',//主体名称
                create_time:''
            },
            auth_url:'',//授权链接
            auth_code:undefined,//授权码
            serviceTypeOption:[],//公众号类型
            sverifyTypeOption:[]//认证类型
        }
    },
    filters:{
        service_type_info(val){
            if(!val&&val!=0) return '未授权'
            return that.serviceTypeOption.filter(item=>item.dict_value==val).map(item=>item.dict_label)[0]
        },
        verify_type_info(val){
            if(!val&&val!=0) return '未授权'
            return that.sverifyTypeOption.filter(item=>item.dict_value==val).map(item=>item.dict_label)[0]
        }
    },
    beforeCreate: function () {
        that = this;
    },
    created(){
        this.getAuthInfo()
        this.getDicts({type:'service_type_info'}).then(res=>{
            this.serviceTypeOption=res.data
        })
        this.getDicts({type:'verify_type_info'}).then(res=>{
            this.sverifyTypeOption=res.data
        })
        //本页面为授权扫码回调页面
        if(this.$route.query.auth_code){
            this.auth_code=this.$route.query.auth_code
            saveAuthInfo({auth_code:this.$route.query.auth_code}).then(res=>{
                if(res.code==200){
                    //继续查询授权信息
                    this.getAuthInfo()
                }else{
                    this.$message.error(res.msg)
                }
            })
        }
    },
    methods:{
        /**
         * 查询是否进行授权 
         * 已授权返回授权信息
         * 未授权 返回授权码
         */
        getAuthInfo(){
            getAuthConfig({}).then(res=>{
                if(res.data.auth_info){
                    console.log(res.data)
                    this.$nextTick(()=>{
                        this.auth_info=res.data.auth_info
                        this.auth_info.create_time=res.data.create_time
                        this.auth_url=''
                        this.$forceUpdate()
                    })
                }else{
                    this.auth_url=res.data.auth_url
                    this.$forceUpdate()                }
            })
        },
        //跳转扫码将返回本页面 继续查询是否授权成功
        auth(){
            window.location.href =this.auth_url
        },
        onSubmit(){
            this.$refs["form"].validate(valid => {
                if(valid){
                    saveAuthConfig(this.form).then(res=>{
                        if(res.code==200){
                            this.$message.success(res.msg)
                            this.getAuthInfo()
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
.auth-box{
    width: 100%;
    height: 100px;
    display: flex;
    justify-content: flex-start;
    align-items: center;
    .tips{
        width: auto;
        height: 100%;
        display: flex;
        justify-content: center;
        align-items: center;
    }
    .info-box{
        width: auto;
        height: 100%;
        display: flex;
        flex-direction: column;
        justify-content: flex-start;
        font-size: 14px;
        div{
            margin: 4px 0;
        }
    }
    .btn-box{
        height: 100%;
        display: flex;
        justify-content: center;
        align-items: center;
        margin-left: 30px;    
    }
    .img-box{
        width: 100px;
        height: 100px;
        display: flex;
        justify-content: center;
        align-items: center;
        margin: 0 20px;
        img{
            width: 100%;
            height: 100%;
            display: flex;
            justify-content: center;
            align-items: center;
        }
    }
}
.form{
    ::v-deep .el-divider--horizontal{
        margin: 50px 0;
    }
}
</style>