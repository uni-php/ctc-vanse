<template>
  <div class="app-container">
    <el-tabs v-model="activeName" type="card" @tab-click="handleClick">
        <el-tab-pane label="基础设置" name="first">
            <el-form ref="form" :model="form" label-width="140px" :rules="rule" size="medium">
                <el-form-item label="商品窜货后:">
                    <el-radio-group v-model="form.is_fleeing_goods_join">
                        <el-radio label="1">允许查询和参与活动</el-radio>
                        <el-radio label="2">只允许查询，不允许参与活动</el-radio>
                    </el-radio-group>
                </el-form-item>
                <el-form-item required="" label="呆滞品计算周期:" prop="dead_goods_time">
                    <el-input  style="width:50%" v-model="form.dead_goods_time" placeholder="请输入呆滞品计算周期"/>
                </el-form-item>
                <el-form-item required="" label="串货查询密码:" prop="query_password">
                    <el-input  style="width:50%" v-model="form.query_password" placeholder="默认123456"/>
                </el-form-item>
                <el-form-item>
                    <el-button type="primary" @click="onSubmit">保存</el-button>
                    <el-button>取消</el-button>
                </el-form-item>
            </el-form>
        </el-tab-pane>
    </el-tabs>
  </div>
</template>

<script>
import {getBasicSetInfo,saveBasicSetInfo} from '@/api/app/logistics/basic'
export default {
    data(){
        const validatePassword = (rule, value, callback) => {
            if (value.length < 6||!value) {
                callback(new Error('请输入6位查询密码'))
            } else {
                callback()
            }
        }
        return{
            activeName:'first',
            baseInfo:{},
            form:{
                is_fleeing_goods_join:'1',
                dead_goods_time:'',
                query_password:''
            },
            rule:{
                dead_goods_time:[
                    { required: true, message: "请输入呆滞品计算周期", trigger: "blur" }
                ],
                query_password:[
                     { required: true, trigger: "blur", validator: validatePassword }
                ]
            }
        }
    },
    created(){
        this.getBasicSetInfo()
    },
    methods:{
        getBasicSetInfo(){
            getBasicSetInfo({}).then(res=>{
                if(res.data){
                    this.form=res.data
                }
            })
        },
        handleClick(){

        },
        onSubmit(){
            this.$refs.form.validate(valid => {
                if(valid){
                    saveBasicSetInfo(this.form).then(res=>{
                        if(res.code==200){
                            this.$message.success(res.msg)
                            this.getBasicSetInfo()
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