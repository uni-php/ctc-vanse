<template>
  <div class="app-container">
    <div class="tips">
        <p>温馨提示：前往萤石云官网创建应用 萤石云官网>></p>
    </div>
    <el-form :model="form" ref="form" label-width="120px" class="form" :rules="rule" size="medium">
        <el-form-item label="AppKey：" prop="app_key">
            <el-input style="width:30%"  v-model="form.app_key" placeholder="请输入AppKey"/>
        </el-form-item>
        <el-form-item label="Secret：" prop="secret">
            <el-input style="width:30%"  v-model="form.secret" placeholder="请输入Secret"/>
        </el-form-item>
        <el-form-item>
            <el-button type="primary" @click="onSubmit">保存</el-button>
        </el-form-item>
    </el-form>
  </div>
</template>

<script>
import {getSetInfo,saveSetInfo} from '@/api/access/monitor'
export default {
    data(){
        return{
            form:{
                app_key:'',
                secret:''
            },
            rule:{
                app_key:[
                    { required: true, message: "请输入AppKey", trigger: "blur" },
                ],
                secret:[
                    { required: true, message: "请输入Secret", trigger: "blur" },
                ],
            }
        }
    },
    created(){
        this.getSetInfo()
    },
    methods:{
        getSetInfo(){
            getSetInfo({}).then(res=>{
                this.form=res.data||{}
            })
        },
        onSubmit(){
            this.$refs["form"].validate(valid => {
                if(valid){
                    saveSetInfo(this.form).then(res=>{
                        if(res.code==200){
                            this.$message.success(res.msg)
                            this.getSetInfo()
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
</style>