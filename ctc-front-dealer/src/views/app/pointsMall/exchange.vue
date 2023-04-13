<template>
  <div class="app-container">
    <div class="tips">
        <p>积分兑换设置，用于给消费者说明积分商城的相关兑换规则与限制，有默认规则详情文案，您可以根据自身平台需要修改文案。</p>
    </div>
    <el-form :model="form" ref="form" class="form" label-width="120px" :rules="rule" size="medium">
        <el-form-item label="规则详情：" prop="rule_des">
            <QiniuEditor v-model="form.rule_des" style="width:90%" :min-height="300"/>
        </el-form-item>
        <el-form-item>
            <el-button type="primary" size="medium" @click="onSubmit">保存</el-button>
        </el-form-item>
    </el-form>
  </div>
</template>

<script>
import {getPointsRule,savePointsRule} from '@/api/app/points'
export default {
    data(){
        return{
            form:{
                rule_des:'',
                id:undefined
            },
            rule:{
                rule_des:[
                    { required: true, message: "规则详情不能为空", trigger: "blur" },
                ]
            }
        }
    },
    created(){
        this.getPointsRule()
    },
    methods:{
        getPointsRule(){
            getPointsRule({}).then(res=>{
                if(res.data){
                    this.form=res.data
                }
            })
        },
        onSubmit(){
            this.$refs["form"].validate(valid => {
                if(valid){
                    savePointsRule(this.form).then(res=>{
                        if(res.code==200){
                            this.$message.success(res.msg)
                            this.getPointsRule()
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
    .tips{
        padding: 8px 16px;
        background-color: #ecf8ff;
        border-radius: 4px;
        border-left: 5px solid #50bfff;
        margin: 20px 0;
    }
}
</style>