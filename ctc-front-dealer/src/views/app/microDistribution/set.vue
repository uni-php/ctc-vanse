<template>
  <div class="app-container">
    <div class="tips">
        <h4>微分销</h4>
        <p>1、开启后，每个客户都可以作为分销员进行推广获取佣金。关闭后所有客户或原分销员不再获取佣金。</p>
        <p>2、系统只负责计算佣金，分销员的佣金由自己提现申请，总部线下安排发放。</p>
    </div>
    <el-form :model="form" class="form" ref="form" label-width="140px" :rules="rule" size="medium">
        <el-form-item label="是否开启分销：" prop="is_distribution">
            <el-radio-group v-model="form.is_distribution">
                <el-radio :label='1'>是</el-radio>
                <el-radio :label='0'>否</el-radio>
            </el-radio-group>
            <span style="margin-left:20px">关闭之后，客户下单上级将不享有分佣(不影响客户等级关系)</span>
        </el-form-item>
        <el-form-item label="分销层级：" prop="distribution_level">
            <span>系统支持一级和二级分销，具体设置请在【商品管理-上下架管理】中上架商品时设置。</span>
        </el-form-item>
         <el-form-item label="分销员参与佣金：" prop="is_self">
            <el-radio-group v-model="form.is_self">
                <el-radio :label='1'>是</el-radio>
                <el-radio :label='0'>否</el-radio>
            </el-radio-group>
            <span style="margin-left:20px">勾选后，分销员自己消费，自己获取一级佣金，直属上级获取二级佣金，间接上级不获取佣金。</span>
        </el-form-item>
        <el-form-item label="最低提现额度：" prop="cash_max">
            <el-input style="width:80%"  v-model="form.cash_max" placeholder="请输入最低提现额度"/>
        </el-form-item>
        <el-form-item label="分销员招募方式：" prop="recruit_type">
             <el-checkbox :true-label="1" :false-label="0" v-model="form.recruit_type">转发商城或商品</el-checkbox>
        </el-form-item>
        <el-form-item label="分销员别名：" prop="distributor_name">
            <el-input style="width:80%"  v-model="form.distributor_name" placeholder="请输入分销员别名"/>
        </el-form-item>
        <el-form-item label="页面标题：" prop="page_title">
            <el-input style="width:80%"  v-model="form.page_title" placeholder="请输入页面标题"/>
        </el-form-item>
        <el-form-item label="背景图片：" prop="page_bk">
            <div @click="selectCover">
                <img v-if="form.page_bk" :src="form.page_bk" class="avatar">
                <i v-else class="el-icon-plus avatar-uploader-icon"></i>
                <span>（建议尺寸750*1200px）</span>
            </div>
        </el-form-item>
        <el-form-item label="规则详情：" prop="rules">
             <QiniuEditor v-model="form.rules" style="width:90%" :min-height="300"/>
        </el-form-item>
        <el-form-item>
            <el-button type="primary" size="medium" @click="onSubmit">保存</el-button>
        </el-form-item>
    </el-form>
    <el-dialog title="素材库" :visible.sync="imgDialog" width="80%" @close="imgDialog=false">
        <ImgPanel @selectImg="selectImg" :count=1 v-if="hackReset" />
        <div slot="footer" class="dialog-footer">
            <el-button type="primary" @click="submitImg">确 定</el-button>
            <el-button @click="imgDialog=false">取 消</el-button>
        </div>
    </el-dialog>
  </div>
</template>

<script>
import ImgPanel from '@/components/ImgPanel'
import {saveDistributionSet,getDistributionInfo} from '@/api/app/mall/distribution.js'
export default {
     components:{
        ImgPanel
    },
    data(){
        return{
            hackReset:false,
            imgDialog:false,
            form:{
                is_distribution:'0',
                is_self:'0',
                cash_max:'',
                recruit_type:false,
                distributor_name:'分销员',
                page_title:'',
                page_bk:'',
                rules:''
            },
            imgList:[],
            rule:{
                page_bk:[
                    { required: true, message: "背景图片不能为空", trigger: "blur" },
                ],
                rules:[
                    { required: true, message: "规则详情不能为空", trigger: "blur" },
                ]
            }
        }
    },
    created(){
        this.getDistributionInfo()
    },
    methods:{
        getDistributionInfo(){
            getDistributionInfo({}).then(res=>{
                if(res.data){
                    this.form=res.data
                }else{
                    this.form.page_bk='https://cdn.icloudapi.cn/fenxiao.png'
                }
            })
        },
        selectCover(){
            this.imgDialog=true
            this.hackReset = false
            this.$nextTick(() => {
                this.hackReset = true
            })
        },
        selectImg(list){
            this.imgList=list
            console.log(list)
        },
        submitImg(){
            this.form.page_bk=this.imgList[0].url
            console.log(this.form)
            this.imgDialog=false
        },
        onSubmit(){
            this.$refs["form"].validate(valid => {
                if(valid){
                    saveDistributionSet(this.form).then(res=>{
                        if(res.code==200){
                            this.$message.success(res.msg)
                            this.getDistributionInfo()
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
    .form{
    ::v-deep .el-upload-list--picture-card .el-upload-list__item{
        display: none;
    }
    .drag-box{
        overflow: hidden;
        background-color: #fff;
        border: 1px solid #c0ccda;
        border-radius: 6px;
        -webkit-box-sizing: border-box;
        box-sizing: border-box;
        width: 120px;
        float: left;
        cursor: pointer;
        height: 120px;
        margin: 0 15px 8px 0;
        display: block;
        position: relative;
        img{
            width: 100%;
            height: 100%;
        }
    }
    .active{
        width: 120px;
        height: 120px;
        position: absolute;
        background: black;
        display: flex;
        justify-content: center;
        align-items: center;
        font-size: 20px;
        opacity: .5;
        bottom: 0;
        left: 0;
    }
    .no-active{
        display: none;
    }
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
}
}
</style>