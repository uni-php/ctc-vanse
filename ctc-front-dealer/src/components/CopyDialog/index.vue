<template>
    <el-dialog :title="title" :visible.sync="my_dialog" width="50%" @close="close">
        <el-row>
            <el-col :span="8">
                <div class="qrcode-box">
                    <div class="qrcode" ref="qrCodeUrl"></div>
                    <div class="tips">微信扫一扫立即预览</div>
                </div>
            </el-col>
            <el-col :span="16">
                <div class="url-box">
                    <div>链接地址</div>
                    <el-input v-model="url" readonly="" style="width:80%;margin:20px 0" size="medium" placeholder="请输入内容">
                        <el-button class="copy" slot="append" :data-clipboard-text="url"  icon="el-icon-document-copy" @click="copy">复制</el-button>
                    </el-input>
                    <div>可将链接复制到您的公众号菜单中</div>
                </div>
            </el-col>
        </el-row>
    </el-dialog>
</template>
<script>
import QRCode from 'qrcodejs2'
export default {
    name:'CopyDialog',
    props:{
        url:{
            default:'',
            type:String
        },
        title:{
            default:'复制链接',
            type:String
        },
        copyDialogVisible:{
            default:false,
            type:Boolean
        }
    },
    data(){
        return{
            my_dialog:false
        }
    },
    watch:{
        copyDialogVisible(value){
            this.my_dialog=value
            if(value){
                this.$nextTick(()=>{
                    this.creatQrCode(); 
                })
            }else{
                this.$refs.qrCodeUrl.innerHTML = ''
            }
        }
    },
    methods:{
        close(){
            this.$emit('close',false)
        },
        creatQrCode(){
            var qrcode = new QRCode(this.$refs.qrCodeUrl, {
                text: this.url, // 需要转换为二维码的内容
                width: 120,
                height: 120,
                colorDark: '#000000',
                colorLight: '#ffffff',
                correctLevel: QRCode.CorrectLevel.H
            })
        },
        copy(){
            var clipboard = new this.clipboard('.copy')
            clipboard.on('success', e => {
                this.$message.success('已经复制到剪贴板')
                //  释放内存
               clipboard.destroy();
            })
            clipboard.on('error', e =>{
                // 不支持复制
                this.$message.warning('该浏览器不支持复制')
                // 释放内存
               clipboard.destroy();
            })
        },
    }
}
</script>

<style lang="scss" scoped>
.qrcode-box{
    display: flex;
    justify-content: center;
    align-items: center;
    flex-direction: column;
    border-right: 1px solid #ccc;
    .tips{
        margin-top: 15px;
    }
}
.url-box{
    display: flex;
    justify-content: center;
    height: 150px;
    flex-direction: column;
    padding-left: 20px;
}
.qrcode{
    display: inline-block;
    img {
        width: 132px;
        height: 132px;
        background-color: #fff; //设置白色背景色
        padding: 6px; // 利用padding的特性，挤出白边
        box-sizing: border-box;
    }
}
</style>