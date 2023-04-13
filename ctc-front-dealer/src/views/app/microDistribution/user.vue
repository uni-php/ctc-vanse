<template>
  <div class="app-container">
      <el-row class="content-box">
          <el-col :span="12" style="height:100%">
              <!-- 手机盒子 -->
              <div class="mobile-box">
                    <div class="app-header"></div>
                    <div class="app-body">
                        <div class="app-bar-box">
                            <div class="title">分销员招募</div>
                        </div>
                        <div class="app-content-box">
                            <div class="img-bg">
                                <img :src="form.bk_img"/>
                                <!-- 个人头像 -->
                                <div class="user-info">
                                    <div class="user-head">
                                        <img :style="{borderRadius:form.head_style=='1'?0:'35px'}" :src="userInfo.headImg">
                                    </div>
                                    <div class="user-nickname" :style="{color:form.font_color,fontSize:form.font_size+'px'}">{{userInfo.nickName}}</div>
                                    <div class="user-qrcode">
                                        <img :src="userInfo.headImg"/>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="app-end">
                        <i></i>
                    </div>
              </div>
          </el-col>
          <el-col :span="12" style="height:100%">
               <el-form :model="form" class="form" ref="form" label-width="140px" :rules="rule" size="medium">
                   <el-form-item label="海报背景图片：" prop="bk_img">
                        <div @click="selectCover">
                            <img v-if="form.bk_img" :src="form.bk_img" class="avatar">
                            <i v-else class="el-icon-plus avatar-uploader-icon"></i>
                            <span>（建议尺寸750*1200px）</span>
                        </div>
                    </el-form-item>
                    <el-form-item label="头像样式：" prop="head_style">
                        <el-radio v-model="form.head_style" label="1">正方形</el-radio>
                        <el-radio v-model="form.head_style" label="2">圆形</el-radio>
                    </el-form-item>
                    <el-form-item label="昵称字体大小：" prop="font_size">
                        <el-select style="width:220px" size="small" v-model="form.font_size" placeholder="请选择昵称字体大小">
                            <el-option
                                v-for="item in fontOption"
                                :key="item.value"
                                :label="item.label"
                                :value="item.value">
                            </el-option>
                        </el-select>
                    </el-form-item>
                    <el-form-item label="昵称字体颜色：" prop="font_color">
                        <el-color-picker v-model="form.font_color"></el-color-picker>
                    </el-form-item>
                    <el-form-item>
                        <el-button type="primary" size="medium" @click="onSubmit">保存</el-button>
                    </el-form-item>
               </el-form>
          </el-col>
      </el-row>
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
import {saveDistributionUser,getDistributionUser} from '@/api/app/mall/distribution.js'
export default {
    components:{
        ImgPanel
    },
    data(){
        return{
            imgList:[],
            imgDialog:false,
            hackReset:false,
            form:{
                bk_img:'https://cdn.icloudapi.cn/fenxiao.png',
                head_style:'1',
                font_size:14,
                font_color:'#000000',
                id:undefined
            },
            rule:{

            },
            fontOption:[
                {
                   value:14,
                   label:'14px' 
                },
                {
                   value:15,
                   label:'15px' 
                },
                {
                   value:16,
                   label:'16px' 
                }
            ],
            userInfo:{
                headImg:'https://thirdwx.qlogo.cn/mmopen/vi_32/Q0j4TwGTfTI0Wjshxm16cPsj3S1a98xkIiayFeI1FYPCREuO7vIuveTWsoXOQZGzqxbY2vzbf6nvK3db3VTZP6A/132',
                nickName:'这里是昵称',
                qrCode:' '
            }
        }
    },
    created(){
        this.getDistributionUser()
    },
    methods:{
        onSubmit(){
            saveDistributionUser(this.form).then(res=>{
                if(res.code==200){
                    this.$message.success(res.msg)
                    this.getDistributionUser()
                }else{
                    this.$message.error(res.msg)
                }
            })
        },
        getDistributionUser(){
            getDistributionUser({}).then(res=>{
                if(res.data){
                    this.form=res.data
                }
            })
        },
         submitImg(){
            this.form.bk_img=this.imgList[0].url
            this.imgDialog=false
        },
         selectImg(list){
            this.imgList=list
            console.log(list)
        },
        selectCover(){
            this.imgDialog=true
            this.hackReset = false
            this.$nextTick(() => {
                this.hackReset = true
            })
        }
    }
}
</script>

<style lang="scss" scoped>
.app-container{
    .form{
        margin-top: 100px;
        background: #F5F5F5;
        padding: 30px;
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
    .content-box{
        width:100%;
        height: calc(100vh - 100px);
    }
    .mobile-box{
    width: 350px;
    border: 1px solid #e5e5e5;
    box-sizing: border-box;
    background: #fff;
    border-radius: 18px 18px 0 0;
    margin: 0 auto;
    margin-top: 100px;
    padding-bottom: 10px;
    .app-header{
        height: 70px;
            background-image: url("../../../assets/iphone_head.png");
            background-repeat: no-repeat;
            background-position:center center;
    }
    .app-body{
        width: 320px;
        margin: 0 auto;
        min-height: 600px;
        border: 1px solid #c5c5c5;
        background: #fff;
        overflow: hidden;
        .actives{
            width: 100%;
            height: 100%;
            border: 2px dashed rgba(255,0,0,0.5);
            box-sizing: border-box;
            position: relative;
            cursor: move;
            opacity: 1;
        }
        .app-bar-box{
            position: relative;
            cursor: move;
            background-color: #409EFF !important;
            height: 64px;
            font-size: 16px;
            color: #fff;
            font-weight: bold;
            text-align: center;
            background: url("../../../assets/titlebar.png") no-repeat;
            overflow: hidden;
            .title{
                display: block;
                line-height: 46px;
                height: 46px;
                margin: 18px 60px 0;
                text-overflow: ellipsis;
                white-space: nowrap;
                overflow: hidden;
            }
        }
        .app-content-box{
            background-color: #eee;
            height: 550px;
            width: 100%;
            position: relative;
            z-index: 1;
            .img-bg{
                width: 100%;
                height: 100%;
                position: relative;
                .user-info{
                    width: 200px;
                    height: 220px;
                    background: white;
                    position: absolute;
                    left: 50%;
                    transform: translateX(-50%);
                    top: 60px;
                    .user-head{
                        width: 70px;
                        height: 70px;
                        display: flex;
                        justify-content: center;
                        align-items: center;
                        position: absolute;
                        top: -30px;
                        left: 50%;
                        transform: translateX(-50%);
                        img{
                            width: 100%;
                            height: 100%;
                        }
                    }
                    .user-nickname{
                        width: 100%;
                        display: flex;
                        justify-content: center;
                        align-items: 40px;
                        font-size: 13px;
                        margin-top: 50px
                    }
                    .user-qrcode{
                        width:100px;
                        height: 100px;
                        margin: 0 auto;
                        margin-top: 20px;
                        img{
                            width: 100%;
                            height: 100%;
                        }
                    }
                }
                img{
                    width: 100%;
                    height: 100%;
                }
            }
            .app-content{
                margin: 0;
                padding: 0;
                display: flex;
                justify-content: center;
                flex-direction: column;
                .set-btn{
                    position: absolute;
                    right: 0;
                    bottom: 0;
                    z-index: 999;
                }
                .banner{
                    margin: 0;
                    width: 100%;
                    height: 152px !important;
                    -webkit-box-sizing: border-box;
                    -moz-box-sizing: border-box;
                    box-sizing: border-box;
                    min-height: 20px;
                    position: relative;
                    .activity-img,.scroll-img{
                        width: 100%;
                        height: 152px;
                        display: flex;
                        ::v-deep .el-carousel--horizontal{
                            width: 100%;
                        }
                    }
                    ::v-deep .el-image{
                        height: 100%;
                    }
                }
                .app-tab{
                    position: relative;
                    cursor: move;    
                    box-sizing: border-box;
                    min-height: 20px;
                    display: flex;
                    justify-content: center;
                    width: 100%;
                    background: white;
                    ::v-deep .el-tabs__header{
                        margin-bottom:0
                    }
                }
                .line{
                    width: 100%;
                    background: #eeeeee;
                    position: relative;
                }
                .search{
                    width: 100%;
                    height: 60px !important;
                    background: white;
                    display: flex;
                    justify-content: center;
                    align-items: center;
                    position: relative;
                    .search-bk{
                        width: 90%;
                        height: 36px;
                        background: #ffffff;
                        border-radius: 40px;
                        display: flex;
                        justify-content: flex-start;
                        align-items: center;
                        background-color: #f7f7f7;
                        padding-left: 20px;
                        font-size: 15px;
                        color: #acacac;
                    }
                }
                .nav{
                    width: 100%;
                    height: 90px !important;
                    display: flex;
                    justify-content: space-around;
                    align-items: center;
                    background: white;
                    position: relative;
                    .nav-item{
                        width: 25%;
                        height: 100%;
                        display: flex;
                        justify-content: center;
                        align-items: center;
                        flex-direction: column;
                        color: #646464;
                        font-size: 12px;
                        padding: 12px 0;
                        img{
                            width: 50px;
                            height: 50px;
                            margin-bottom: 7px;
                        }
                    }
                }
                .recom{
                    width: 100%;
                    height: 176px !important;
                    display: flex;
                    justify-content: center;
                    align-items: center;
                    flex-direction: column;
                    flex-wrap: wrap;
                    position: relative;
                    .recom-title{
                        width: 100%;
                        height: 36px;
                        display: flex;
                        justify-content: space-between;
                        align-items: center;
                        padding: 0 12px;
                        background: white;
                        border-bottom: 1px solid #eeeeee;
                        position: relative;
                    }
                    .product-box{
                        width: 100%;
                        height: 140px !important;
                        display: flex;
                        flex-direction: column;
                        position: relative;
                        .product-item{
                            width: 100%;
                            height: 140px;
                            display: flex;
                            justify-content: center;
                            background: white;
                            align-items: center;
                            border-bottom: 1px solid #eeeeee;
                            padding: 12px;
                            box-sizing: border-box;
                            .product-img{
                                width: 120px;
                                height: 100%;
                                display: flex;
                                justify-content: center;
                                align-items: center;
                                img{
                                    width: 120px;
                                    height: 120px;
                                }
                            }
                            .product_info{
                                width: calc(100% - 120px);
                                height: 100%;
                                display: flex;
                                flex-direction: column;
                                padding-left: 12px;
                                .product-title{
                                    width: 100%;
                                    height: auto;
                                    display: flex;
                                    justify-content: flex-start;
                                    font-size: 14px;
                                    color: #333;
                                    margin: 2px 0 15px;
                                    height: 40px;
                                }
                                .product-sale{
                                    width: 100%;
                                    height: auto;
                                    display: flex;
                                    justify-content: flex-start;
                                    font-size: 14px;
                                    color: gray;
                                    margin: 2px 0 15px;
                                }
                                .product-price{
                                    width: 100%;
                                    height: auto;
                                    display: flex;
                                    justify-content: flex-start;
                                    height: 20px;
                                    line-height: 20px;
                                    color: #dd2726;
                                    font-size: 14px;
                                    overflow: hidden;
                                }
                            }
                        }
                    }
                }
                .notice{
                    width: 100%;
                    height: 36px !important;
                    display: flex;
                    padding-left: 6px;
                    justify-content: flex-start;
                    align-items: center;
                    background: white;
                    position: relative;
                }
                .custom{
                    width: 100%;
                    min-height: 140px !important;
                    padding: 12px;
                    background: white;
                    position: relative;
                }
                .nav_title{
                    width: 100%;
                    height: 30px !important;
                    display: flex;
                    padding-left: 12px;
                    justify-content: flex-start;
                    align-items: center;
                    background: white;
                    position: relative;
                    span{
                        border-left: 2px solid red;
                        font-size: 15px;
                        padding-left: 4px;
                    }
                }
            }
        }
    }
      .app-end{
            height: 60px;
            border-radius: 0 0 10px 10px;
            border: 1px solid #e5e5e5;
            border-top: none;
            position: relative;
            left: -1px;
            top: 18px;
            width: 350px;
            background: #fff;
            text-align: center;
            i{
                display: inline-block;
                width: 50px;
                height: 50px;
                border: 1px solid #ccc;
                position: relative;
                z-index: 0;
                border-radius: 50%;
            }
            i:after{
                content: '';
                position: absolute;
                width: 40px;
                height: 40px;
                margin: -20px 0 0 -20px;
                left: 50%;
                top: 50%;
                background: #ccc;
                border-radius: 50%;
            }
        }
    .app-add-field{
        position: relative;
        background: #f8f8f8;
        width: 350px;
        margin: 0 auto;
        padding: 15px 0;
        box-sizing: border-box;
        left: -1px;
        top: -1px;
        border: 1px solid #ddd;
        display: flex;
        justify-content: center;
    }
    .app-end{
        height: 60px;
        border-radius: 0 0 10px 10px;
        border: 1px solid #e5e5e5;
        border-top: none;
        position: relative;
        left: -1px;
        top: 18px;
        width: 348px;
        background: #fff;
        text-align: center;
        i{
            display: inline-block;
            width: 50px;
            height: 50px;
            border: 1px solid #ccc;
            position: relative;
            z-index: 0;
            border-radius: 50%;
        }
        i:after{
            content: '';
            position: absolute;
            width: 40px;
            height: 40px;
            margin: -20px 0 0 -20px;
            left: 50%;
            top: 50%;
            background: #ccc;
            border-radius: 50%;
        }
    }
  
    .row-bg{
        border: 1px solid #eeeeee;
        height: calc(100vh - 120px);
        overflow:auto;
    }
    .row-right{
        height: 100%;
        overflow: auto;
    }
    .row-left{
        border-right: 1px solid #eeeeee;
        height: 100%;
    }
    ::v-deep .el-image{
        width: 100%;
    }
    ::v-deep .image-slot{
        display: flex;
        justify-content: center;
        align-items: center;
        width: 100%;
        height:150px;
        background: #f5f7fa;
        color: #909399;
        font-size: 14px;
        font-size: 30px;
    }
    .tw-title{
        width: 100%;
        height: 40px;
        font-size: 14px;
        background: #eeeeee;
        text-align: left;
        padding: 10px;
    }
    
}
}
</style>