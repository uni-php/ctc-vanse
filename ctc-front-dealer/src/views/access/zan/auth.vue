<template>
  <div class="app-container">
    <div class="tips">
        <p>温馨提示：请先在有赞云管理后台的应用中心中创建应用</p>
    </div>
    <el-form :model="form" ref="form" label-width="120px" :rules="rule" size="medium">
        <el-form-item label="应用名称：" prop="micro_app_title">
            <el-input style="width:30%"  v-model="form.micro_app_title" placeholder="请输入应用名称"/>
        </el-form-item>
        <el-form-item label="grant_id：" prop="grant_id">
            <el-input style="width:30%"  v-model="form.grant_id" placeholder="请输入grant_id"/>
        </el-form-item>
        <el-form-item label="client_id：" prop="client_id">
            <el-input style="width:30%"  v-model="form.client_id" placeholder="请输入client_id"/>
        </el-form-item>
        <el-form-item label="client_secret：" prop="client_secret">
            <el-input style="width:30%"  v-model="form.client_secret" placeholder="请输入client_secret"/>
        </el-form-item>
        <el-form-item>
            <el-button type="primary" @click="onSubmit">提交</el-button>
        </el-form-item>
    </el-form>
  </div>
</template>

<script>
import {getAuthInfo,saveAuthInfo} from '@/api/access/zan/auth'
export default {
    data(){
        return{
            form:{
                micro_app_title:'',
                grant_id:'',
                client_id:'',
                client_secret:'',
                id:undefined
            },
            rule:{
                micro_app_title:[
                    { required: true, message: "请输入微应用标题", trigger: "blur" },
                ],
                grant_id:[
                    { required: true, message: "请输入grant_id", trigger: "blur" },
                ],
                client_id:[
                    { required: true, message: "请输入client_id", trigger: "blur" },
                ],
                client_secret:[
                    { required: true, message: "请输入client_secret", trigger: "blur" },
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