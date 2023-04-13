<template>
  <div class="app-container">
    <el-col :span="24" style="margin:10px 0;text-align:right">
        <el-button @click="visitUser" type="primary" size="small" >访问个人中心</el-button>
    </el-col>
    <!-- 手机盒子 -->
    <div class="mobile-box">
        <div class="mobile">
            <div class="app-header"></div>
            <div class="app-body">
                <el-popover
                        placement="right"
                        title="页面名称"
                        width="600"
                        trigger="hover"
                        v-model="titleVisible">
                        <div>
                            <el-form ref="titleForm" :model="titleForm" label-width="100px" :rules="titleRule"  size="small">
                                <el-form-item prop="page_name" label="页面名称" >
                                        <el-input style="width:90%" v-model="titleForm.page_name" placeholder="请输入页面名称"></el-input>
                                </el-form-item>
                                <el-row style="text-align:center">
                                    <el-form-item>
                                        <el-button type="primary" @click="saveTitleForm">确定</el-button>
                                        <el-button @click="titleVisible=false">取消</el-button>
                                    </el-form-item>
                                </el-row>
                            </el-form>
                        </div>
                <div class="title-box" slot="reference">
                    <div class="title">{{titleForm.page_name}}</div>
                </div>
                </el-popover>
                <div class="content-box">
                    <div class="user-info-box">
                        <div class="bd">
                            <div class="headimg">
                                <img src="@/assets/user_img.png"/>
                            </div>
                            <div class="nickname">
                                用户昵称
                            </div>
                            <el-button class="account-set" size="mini" plain>账号管理</el-button>
                        </div>
                    </div>
                    <div class="user-fix-box">
                        <!-- <div class="user-fix-item">
                            <i style="font-size:22px;" class="el-icon-coin"></i>
                            <span class="fun-text">账户积分</span>
                            <span class="arrow"><span style="color:#F6AD3C">0.00</span><i class="el-icon-arrow-right"></i></span>
                        </div> -->
                        <div class="user-fix-item">
                            <i style="font-size:22px" class="el-icon-menu"></i>
                            <span class="fun-text">我的扫码记录</span>
                            <span class="arrow"><i class="el-icon-arrow-right"></i></span>
                        </div>
                        <div class="user-fix-item">
                            <i style="font-size:22px" class="el-icon-tickets"></i>
                            <span class="fun-text">领奖记录</span>
                            <span class="arrow"><i class="el-icon-arrow-right"></i></span>
                        </div>
                        <!-- <div class="user-fix-item">
                            <i style="font-size:22px" class="el-icon-s-order"></i>
                            <span class="fun-text">订单中心</span>
                            <span class="arrow"><i class="el-icon-arrow-right"></i></span>
                        </div>
                        <div class="user-fix-item">
                            <i style="font-size:22px" class="el-icon-view"></i>
                            <span class="fun-text">我浏览的店铺</span>
                            <span class="arrow"><i class="el-icon-arrow-right"></i></span>
                        </div> -->
                    </div>
                     <el-popover
                        placement="right"
                        title="快捷菜单"
                        width="600"
                        trigger="manual"
                        v-model="visible">
                            <div>
                                <el-form ref="form" :model="form" label-width="100px" :rules="rule"  size="small">
                                  <el-row>
                                        <el-col :span="8">
                                            <el-form-item prop="is_scan" label="导购扫一扫" >
                                                <el-checkbox :disabled="form.is_scan==0" v-model="form.is_scan"  :true-label="1" :false-label="0">导购扫一扫</el-checkbox>
                                            </el-form-item>
                                        </el-col>
                                        <el-col :span="14">
                                            <el-form-item prop="scan_name" label="自定义名称" >
                                                 <el-input style="width:90%" v-model="form.scan_name" placeholder="请输入扫一扫名称"></el-input>
                                            </el-form-item>
                                        </el-col>
                                    </el-row>
                                    <!-- <el-row>
                                        <el-col :span="8">
                                            <el-form-item prop="is_micro_mall" label="微商城" >
                                                <el-checkbox :disabled="form.is_points_mall==0" v-model="form.is_micro_mall"  :true-label="1" :false-label="0">微商城</el-checkbox>
                                            </el-form-item>
                                        </el-col>
                                        <el-col :span="14">
                                            <el-form-item prop="micro_mall_name" label="自定义名称" >
                                                 <el-input style="width:90%" v-model="form.micro_mall_name" placeholder="请输入微商城名称"></el-input>
                                            </el-form-item>
                                        </el-col>
                                    </el-row> -->
                                    <el-row>
                                        <el-col :span="8">
                                            <el-form-item prop="is_points_mall" label="积分商城" >
                                                <el-checkbox v-model="form.is_points_mall" :disabled="form.is_micro_mall==0"  :true-label="1" :false-label="0">积分商城</el-checkbox>
                                            </el-form-item>
                                        </el-col>
                                        <el-col :span="14">
                                            <el-form-item prop="micro_points_name" label="自定义名称" >
                                                 <el-input style="width:90%" v-model="form.micro_points_name" placeholder="请输入积分商城名称"></el-input>
                                            </el-form-item>
                                        </el-col>
                                    </el-row>
                                    <el-row style="text-align:center">
                                        <el-form-item>
                                            <el-button type="primary" @click="saveMenu">确定</el-button>
                                            <el-button @click="visible=false">取消</el-button>
                                        </el-form-item>
                                    </el-row>
                                </el-form>
                            </div>
                            <div class="user-control-box" v-show="is_fun_show" slot="reference" >
                                <div class="user-fix-item" style="margin-bottom:2px" v-show="form.is_scan==1">
                                    <i style="font-size:22px;" class="el-icon-shopping-bag-2"></i>
                                    <span class="fun-text">{{form.scan_name}}</span>
                                    <span class="arrow"><i class="el-icon-arrow-right"></i></span>
                                </div>
                                <!-- <div class="user-fix-item" style="margin-bottom:2px" v-show="form.is_micro_mall==1">
                                    <i style="font-size:22px;" class="el-icon-shopping-bag-2"></i>
                                    <span class="fun-text">{{form.micro_mall_name}}</span>
                                    <span class="arrow"><i class="el-icon-arrow-right"></i></span>
                                </div> -->
                                <div class="user-fix-item" style="margin-bottom:0" v-show="form.is_points_mall==1">
                                    <i style="font-size:22px" class="el-icon-present"></i>
                                    <span class="fun-text">{{form.micro_points_name}}</span>
                                    <span class="arrow"><i class="el-icon-arrow-right"></i></span>
                                </div>
                                <!-- 设置按钮 -->
                                <div class="set-btn">
                                    <el-button type="primary" size="mini" plain @click="visible = true">编辑</el-button>
                                    <el-button type="danger" size="mini" plain @click="handleDele">删除</el-button>
                                </div>
                            </div>
                     </el-popover>
                </div>
            </div>
            <!-- 快捷菜单 -->
            <div class="design">
                <el-button size="medium" @click="design" type="primary">快捷菜单</el-button>
            </div>
            <div class="app-end">
                <i></i>
            </div>
        </div>
    </div>
    <div class="save-btn">
        <el-button type="primary" @click="saveSet">保存</el-button>
    </div>
    <!-- 二维码弹窗 -->
    <CopyDialog :copyDialogVisible="copyDialogVisible" :title="copyTitle" :url="url" @close="closeCopyDialog"/>
  </div>
</template>

<script>
import {queryUserSetInfo,saveUserSetInfo} from '@/api/app/guide/user'
import CopyDialog from '@/components/CopyDialog'
import { mapGetters } from 'vuex'
export default {
    components:{
        CopyDialog
    },
    data(){
        return{
            src:'',
            is_fun_show:true,
            visible:false,
            titleVisible:false,
            dialogVisible:false,
            copyDialogVisible:false,
            copyTitle:'复制链接',
            titleForm:{
                page_name:'导购中心'
            },
            titleRule:{
                page_name:[
                    {required: true, message: "请输入页面名称", trigger: "blur" },
                ],
            },
            form:{
                // is_micro_mall:1,
                is_points_mall:1,
                // micro_mall_name:'微商城',
                micro_points_name:'积分商城',
                is_scan:1,//导购扫一扫
                scan_name:'导购扫一扫'
            },
            url:'',
            rule:{
                micro_mall_name:[
                    {required: true, message: "请输入微商城名称", trigger: "blur" },
                ],
                micro_points_name:[
                    {required: true, message: "请输入积分商城名称", trigger: "blur" },
                ],
                scan_name:[
                    {required: true, message: "请输入扫一扫名称", trigger: "blur" },
                ]
            }
        }
    },
    computed:{
        ...mapGetters([
            'dealer_id'
        ]),
    },
    created(){
        this.getSetInfo()
    },
    methods:{
        handleDele(){
            this.is_fun_show=false
            this.visible=false
        },
        saveSet(){
            this.form.page_name=this.titleForm.page_name
            this.form.is_fun_show=this.is_fun_show?1:0
            saveUserSetInfo(this.form).then(res=>{
                if(res.code==200){
                    this.$message.success(res.msg)
                    this.getSetInfo()
                }else{
                    this.$message.error(res.msg)
                }
            })
        },
        getSetInfo(){
            queryUserSetInfo({}).then(res=>{
                if(res.data){
                    this.form=res.data
                    this.titleForm.page_name=res.data.page_name
                    this.is_fun_show=res.data.is_fun_show
                }
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
        saveMenu(){
            this.$refs["form"].validate(valid => {
                if(valid){
                    this.visible=false
                }
            })
        },
        saveTitleForm(){
            this.$refs["titleForm"].validate(valid => {
                if(valid){
                    this.titleVisible=false
                }
            })
        },
        design(){
            this.is_fun_show=true
            this.$forceUpdate()
        },
        visitUser(){
          this.url='http://register.gawxg.com/guide?dealer_id='+this.dealer_id
          this.copyDialogVisible=true
        },
        closeCopyDialog(val){
            this.copyDialogVisible=val
        }
    }
}
</script>

<style lang="scss" scoped>
.app-container{
    color: #666;
}
.mobile-box{
    width: 100%;
    height: 100vh;
    .mobile{
        float: left;
        width: 350px;
        height: auto;
        min-height: 600px;
        border: 1px solid #e5e5e5;
        box-sizing: border-box;
        background: #fff;
        border-radius: 18px 18px 0 0;
        margin-bottom: 100px;
        margin-left: 50px;
        padding-bottom: 10px;
        .app-header{
            height: 70px;
            background-image: url("../../../../assets/iphone_head.png");
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
            .title-box{
                background-color: #fff;
                color: #333;
                height: 64px;
                font-size: 16px;
                font-weight: bold;
                text-align: center;
                background: url("../../../../assets//titlebar.png") no-repeat;
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
            .title-box:hover{
                border: 2px dashed rgba(255,0,0,0.5);
                box-sizing: border-box;
                position: relative;
                cursor: move;
            }
            .content-box{
                background-color: #eee;
                min-height: 536px;
                width: 100%;
                position: relative;
                z-index: 1;
                .user-info-box{
                    background: url("../../../../assets/user_bg.png") no-repeat #fff;
                    background-size: 100% auto;
                    min-height: 210px;
                    border-bottom: 1px #F0F0F0 solid;
                    overflow: hidden;
                    .bd{
                        margin-top: 110px;
                        padding: 0 20px;
                        display: flex;
                        align-items: center;
                        .headimg{
                            width: 80px;
                            img{
                                max-width: 100%;
                                border: none;
                            }
                        }
                        .nickname{
                            overflow: hidden;
                            margin: 20px 0 0 15px;
                            font-weight: 500;
                            font-size: 18px;
                        }
                        .account-set{
                            margin: 30px 0 0 25px;
                        }
                    }
                }
                .user-fix-box,.user-control-box{
                    width: 100%;
                    display: flex;
                    flex-direction: column;
                    .user-fix-item{
                        padding: 0 15px;
                        height: 52px;
                        line-height: 52px;
                        background: #fff;
                        margin-bottom: 10px;
                        display: flex;
                        color: gray;
                        justify-content: flex-start;
                        align-items: center;
                        position: relative;
                        .fun-text{
                            font-size: 16px;
                            color: #333;
                            margin-left:15px
                        }
                        .arrow{
                            position: absolute;
                            right: 20px;
                        }
                    }
                }
                .set-btn{
                    position: absolute;
                    right: 0;
                    bottom: 0;
                    display: none;
                }
                .user-control-box:hover{
                    border: 2px dashed rgba(255,0,0,0.5);
                    box-sizing: border-box;
                    position: relative;
                    cursor: move;
                    .set-btn{
                        display: block;
                    }
                }
            }
        }
        .design{
            position: relative;
            padding: 20px 14px 10px 10px;
            background: #f8f8f8;
            width: 350px;
            margin: 0 auto;
            box-sizing: border-box;
            left: -1px;
            top: -1px;
            border: 1px solid #ddd;
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
    }
}
.save-btn{
    display: flex;
    width: 100%;
    justify-content: center;
    align-items: center;
    position: fixed;
    height: 80px;
    background:white;
    bottom: 0;
    z-index: 999;
}
</style>
