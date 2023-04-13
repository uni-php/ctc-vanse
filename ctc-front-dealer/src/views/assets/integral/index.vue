<template>
  <div class="app-container">
    <div class="tips">
        <p>积分价值定义</p>
    </div>
    <div>
        <span style="margin-left:100px">1元=</span>
        <el-input-number style="margin:0 10px" size="small" v-model="exchange_value"  :min="1" :max="10000" label="兑换值"></el-input-number>
        <span>积分 <span style="color:red">(积分值取0~10000整数)</span></span>
        <div class="tip">
            <p>定义积分的价值:1元=N积分（默认为1元=100积分）</p>
            <p>此积分定义值仅作参考,方便把握积分价值,比如在设置兑换礼品时,将根据设置的积分定义值与礼品的原售价/市面价自动计算推荐的积分价(不足1积分时,计算为1积分),方便设置礼品的积分兑换价。</p>
        </div>
    </div>
    <div class="tips">
        <p>积分说明</p>
    </div>
    <div>
        <el-form :model="form" ref="form" label-width="100px" :rules="rule" size="medium">
            <el-form-item label="积分说明：" prop="integral_explain">
                <el-input 
                style="width:80%" 
                type="textarea" 
                maxlength="1000"
                show-word-limit :autosize="{ minRows: 3, maxRows: 4}" 
                v-model="form.integral_explain" 
                placeholder="请输入积分说明"/>
            </el-form-item>
            <span class="tip">此积分规则将显示在会员的 个人中心>>我的积分>>积分说明.请根据您的世界运营情况修改补充说明。</span>
        </el-form>
    </div>
    <div class="tips">
        <p>积分清零设置</p>
    </div>
    <div>
        <el-form :model="form1" ref="form1" label-width="120px" size="medium">
            <el-form-item label="是否定期清零：">
                <el-radio-group v-model="form1.is_clear">
                <el-radio label="0">关闭</el-radio>
                <el-radio label="1">开启</el-radio>
                </el-radio-group>
            </el-form-item>
        </el-form>
    </div>
    <el-row style="text-align:center">
        <el-button type="primary" @click="onSubmit">保存</el-button>
    </el-row>
  </div>
</template>

<script>
import {savePointsSet,getPointsSetInfo} from '@/api/assets/points'
export default {
    data(){
        return{
            exchange_value:100,
            form:{
                integral_explain:"",
                id:''
            },
            form1:{
                is_clear:'0'//默认关闭
            },
            rule:{
                integral_explain:[
                     { required: true, message: "请输入积分说明", trigger: "blur" },
                ]
            },
        }
    },
    created(){
        this.getPointsSetInfo()
    },
    methods:{
        getPointsSetInfo(){
            getPointsSetInfo({}).then(res=>{
                if(!res.data) return;
                this.exchange_value=res.data.exchange_value
                this.form.id=res.data.id
                this.form.integral_explain=res.data.integral_explain
                this.form1.is_clear=String(res.data.is_clear)
            })
        },
        onSubmit(){
            this.$refs["form"].validate(valid => {
                if(valid){
                    var params={
                        exchange_value:this.exchange_value,
                        integral_explain:this.form.integral_explain,
                        is_clear:this.form1.is_clear,
                        id:this.form.id
                    }
                    savePointsSet(params).then(res=>{
                        if(res.code==200){
                            this.$message.success(res.msg)
                            this.getPointsSetInfo()
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
.tip{
    font-size: 14px;
    margin-left: 100px;
}
.dialog-footer{
  margin: 30px 0;
}
</style>