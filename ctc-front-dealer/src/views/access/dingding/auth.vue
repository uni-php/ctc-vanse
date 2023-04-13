<template>
  <div class="app-container">
    <div class="tips">
        <p>温馨提示：请先在钉钉管理后台新增微应用，应用首页链接：http://jifen.c.smartcode.vip/Staff/index.html#/homePage?customer_id=10000001 钉钉应用仅支持员工登陆，请前往【员工管理】中添加员工账号。</p>
    </div>
    <el-form :model="form" ref="form" label-width="120px" :rules="rule" size="medium">
        <el-form-item label="微应用名称：" prop="micro_app_title">
            <el-input style="width:30%"  v-model="form.micro_app_title" placeholder="请输入微应用名称"/>
        </el-form-item>
        <el-form-item label="agentId：" prop="agentId">
            <el-input style="width:30%"  v-model="form.agentId" placeholder="请输入AgentId"/>
        </el-form-item>
        <el-form-item label="appKey：" prop="appKey">
            <el-input style="width:30%"  v-model="form.appKey" placeholder="请输入AppKey"/>
        </el-form-item>
        <el-form-item label="appSecret：" prop="appSecret">
            <el-input style="width:30%"  v-model="form.appSecret" placeholder="请输入AppSecret"/>
        </el-form-item>
        <el-form-item>
            <el-button type="primary" @click="onSubmit">提交</el-button>
        </el-form-item>
    </el-form>
  </div>
</template>

<script>
import {getAuthInfo,saveAuthInfo} from '@/api/access/dingding/auth'
export default {
    data(){
        return{
            form:{
                micro_app_title:'',
                agentId:'',
                appKey:'',
                appSecret:'',
                id:undefined
            },
            rule:{
                micro_app_title:[
                    { required: true, message: "请输入微应用名称", trigger: "blur" },
                ],
                agentId:[
                    { required: true, message: "请输入agentId", trigger: "blur" },
                ],
                appKey:[
                    { required: true, message: "请输入appKey", trigger: "blur" },
                ],
                appSecret:[
                    { required: true, message: "请输入appSecret", trigger: "blur" },
                ],
            }
        }
    },
    created(){
        this.getAuthInfo()
    },
    methods:{
        getAuthInfo(){
            getAuthInfo({}).then(res=>{
                this.form=res.data||{}
            })
        },
        onSubmit(){
            this.$refs["form"].validate(valid => {
                if(valid){
                    saveAuthInfo(this.form).then(res=>{
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