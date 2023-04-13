<template>
  <div class="app-container">
      <el-form :model="form" ref="form" label-width="160px" :rules="rule" size="medium">
        <el-form-item prop="is_distributor" label="下级经销商管理权限：" >
            <el-radio-group v-model="form.is_distributor">
                <el-radio :label="1">启用</el-radio>
                <el-radio :label="0">关闭</el-radio>
            </el-radio-group>
            <span class="tips">启用后所有的经销商都可以添加、管理自己的下级经销商</span>
        </el-form-item>
        <el-form-item prop="is_store" label="门店管理权限：" >
            <el-radio-group v-model="form.is_store">
                <el-radio :label="1">启用</el-radio>
                <el-radio :label="0">关闭</el-radio>
            </el-radio-group>
            <span class="tips">关闭后所有角色无法使用功能（总部除外）</span>
        </el-form-item>
        <el-form-item prop="is_next_store" label="" v-if="form.is_store==1">
            <el-checkbox :true-label="1" :false-label="0" v-model="form.is_next_store">允许经销商管理自己下级门店</el-checkbox>
        </el-form-item>
        <el-form-item prop="is_rank" label="门店排行查看权限：" >
            <el-radio-group v-model="form.is_rank">
                <el-radio :label="1">启用</el-radio>
                <el-radio :label="0">关闭</el-radio>
            </el-radio-group>
            <span class="tips">关闭后所有门店无法使用功能(总部除外)</span>
        </el-form-item>
        <el-form-item style="margin-top:20px">
            <el-button  type="primary" @click="onSubmit">保存</el-button>
        </el-form-item>
      </el-form>
  </div>
</template>

<script>
import {queryBasicSetInfo,saveBasicSetInfo} from '@/api/customer/basics'
export default {
    data(){
        return{
            form:{
                is_distributor:1,
                is_store:1,
                is_rank:1,
                is_next_store:1
            },
            rule:{

            }
        }
    },
    created(){
        this.getSetInfo()
    },
    methods:{
        getSetInfo(){
            queryBasicSetInfo({}).then(res=>{
                if(res.data){
                    this.form=res.data
                }
            })
        },
        onSubmit(){
            saveBasicSetInfo(this.form).then(res=>{
                if(res.code==200){
                    this.$message.success(res.msg)
                    this.getSetInfo()
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
    color: gray;
}
</style>