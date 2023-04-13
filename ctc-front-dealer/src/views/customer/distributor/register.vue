<template>
  <div class="app-container">
        <el-form ref="form" :model="form" label-width="120px" :rules="rule"  size="small">
            <el-form-item prop="distributor_name" label="经销商姓名：" >
                <el-radio-group v-model="form.distributor_name">
                    <el-radio :label="1">必填</el-radio>
                    <el-radio :label="2">选填</el-radio>
                </el-radio-group>
                <span class="tips">启用后注册时 经销商姓名 必填</span>
            </el-form-item>
            <el-form-item prop="distributor_company" label="店铺名/公司名：" >
                <el-radio-group v-model="form.distributor_company">
                    <el-radio :label="1">必填</el-radio>
                    <el-radio :label="2">选填</el-radio>
                </el-radio-group>
                <span class="tips">启用后注册时 店铺名/公司名 必填</span>
            </el-form-item>
            <el-form-item prop="phone" label="手机号：" >
                <el-radio-group v-model="form.phone">
                    <el-radio :label="1">必填</el-radio>
                    <el-radio :label="2">选填</el-radio>
                </el-radio-group>
                <span class="tips">启用后注册时 手机号 必填</span>
            </el-form-item>
            <el-form-item prop="id_card" label="身份证号码：" >
                <el-radio-group v-model="form.id_card">
                    <el-radio :label="1">必填</el-radio>
                    <el-radio :label="2">选填</el-radio>
                </el-radio-group>
                <span class="tips">启用后注册时 身份证号码 必填</span>
            </el-form-item>
            <el-form-item prop="address" label="住址/店铺地址：" >
                <el-radio-group v-model="form.address">
                    <el-radio :label="1">必填</el-radio>
                    <el-radio :label="2">选填</el-radio>
                </el-radio-group>
                <span class="tips">启用后注册时 住址/店铺地址 必填</span>
            </el-form-item>
            <el-form-item prop="wechat" label="微信号：" >
                <el-radio-group v-model="form.wechat">
                    <el-radio :label="1">必填</el-radio>
                    <el-radio :label="2">选填</el-radio>
                </el-radio-group>
                 <span class="tips">启用后注册时 微信号 必填</span>
            </el-form-item>
            <el-form-item prop="contact" label="其他联系方式：" >
                <el-radio-group v-model="form.contact">
                    <el-radio :label="1">必填</el-radio>
                    <el-radio :label="2">选填</el-radio>
                </el-radio-group>
                <span class="tips">启用后注册时 其他联系方式 必填</span>
            </el-form-item>
            <el-form-item prop="rec_name" label="收货人姓名：" >
                <el-radio-group v-model="form.rec_name">
                    <el-radio :label="1">必填</el-radio>
                    <el-radio :label="2">选填</el-radio>
                </el-radio-group>
                <span class="tips">启用后注册时 收货人姓名 必填</span>
            </el-form-item>
            <el-form-item prop="rec_phone" label="收货人电话：" >
                <el-radio-group v-model="form.rec_phone">
                    <el-radio :label="1">必填</el-radio>
                    <el-radio :label="2">选填</el-radio>
                </el-radio-group>
                <span class="tips">启用后注册时 收货人电话 必填</span>
            </el-form-item>
            <el-form-item prop="rec_phone" label="收货人地址：" >
                <el-radio-group v-model="form.rec_address">
                    <el-radio :label="1">必填</el-radio>
                    <el-radio :label="2">选填</el-radio>
                </el-radio-group>
                <span class="tips">启用后注册时 收货人地址 必填</span>
            </el-form-item>
            <el-form-item prop="id_card_img" label="身份证图片：" >
                <el-radio-group v-model="form.id_card_img">
                    <el-radio :label="1">必填</el-radio>
                    <el-radio :label="2">选填</el-radio>
                </el-radio-group>
                <span class="tips">启用后注册时 身份证图片 必填</span>
            </el-form-item>
            <el-form-item>
                <el-button type="primary" size="medium" @click="onSubmit">保存</el-button>
            </el-form-item>
        </el-form>
  </div>
</template>

<script>
import {saveRegisterConfig,queryRegisterConfig} from '@/api/customer/distributor'
export default {
    data(){
        return{
            form:{
                distributor_name:1,
                distributor_company:1,
                phone:1,
                id_card:1,
                address:1,
                wechat:1,
                contact:1,
                rec_name:1,
                rec_phone:1,
                rec_address:1,
                id_card_img:1,
                id:undefined
            },
            rule:{

            }
        }
    },
    created(){
        this.getList()
    },
    methods:{
        getList(){
            queryRegisterConfig({}).then(res=>{
                if(res.data){
                    this.form=res.data
                }
            })
        },
        onSubmit(){
            saveRegisterConfig(this.form).then(res=>{
                if(res.code==200){
                    this.$message.success(res.msg)
                    this.getList()
                }else{
                    this.$message.error(res.msg)
                }
            })
        }
    }
}
</script>

<style lang="scss" scoped>
.tips{
    margin-left: 30px;
    font-size: 14px;
    color: gray;
}
</style>