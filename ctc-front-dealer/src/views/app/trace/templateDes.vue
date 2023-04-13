<template>
  <div class="app-container">
    <el-form :model="form" ref="form" label-width="140px" class="form" :rules="rule" size="medium">
    <el-form-item prop="template_name" label="模板名称" >
        <el-input style="width:30%" :readonly="form.id?true:false" v-model="form.template_name" placeholder="请输入模板名称"></el-input>
    </el-form-item>
    <el-form-item prop="remark" label="备注" >
        <el-input style="width:30%" v-model="form.remark" placeholder="请输入备注"></el-input>
    </el-form-item>
    <!-- 手机盒子 -->
    <div class="mobile-box">
        <div class="app-header"></div>
        <div class="app-body">
            <!-- 手机状态栏 -->
            <el-popover
                placement="right"
                title="页面名称"
                width="600"
                trigger="manual"
                v-model="titleVisible">
                <div>
                    <el-form-item prop="page_title" label="页面名称" >
                            <el-input style="width:90%" maxlength="10" show-word-limit v-model="form.page_title" placeholder="请输入页面名称"></el-input>
                    </el-form-item>
                    <el-form-item>
                        <el-button @click="titleVisible=false">关闭</el-button>
                    </el-form-item>
                </div>
                    <div class="app-bar-box" slot="reference" @click="titleBox" :class="{'actives':active_index==0}">
                        <div class="title">{{form.page_title}}</div>
                    </div>
            </el-popover>
            <div class="app-content-box">
                <div class="app-content">
                    <!-- app banner图 -->
                    <el-popover
                        placement="right"
                        title="活动图/广告轮播图模块设置(建议上传图片的尺寸为640*280px)"
                        width="800"
                        trigger="manual"
                        v-model="bannerVisible">
                        <div>
                            <el-form-item label="图片类型" label-width="80px">
                                <el-radio-group v-model="form.banner_type" @change="changeBannerType">
                                    <el-radio label="1">活动图</el-radio>
                                    <el-radio label="2">轮播图广告</el-radio>
                                </el-radio-group>
                                <div v-show="form.banner_type=='1'">温馨提示：一码多用的溯源码可设置扫码点击活动图领取奖励</div>
                            </el-form-item>
                            <div class="form">
                                <el-form-item label="活动图片：" prop="activity_img" v-if="form.banner_type=='1'">
                                    <vuedraggable class="wrapper" v-model="form.activity_img">
                                        <transition-group>
                                            <div v-for="(item,index) in form.activity_img" :key="index" class="drag-box" @mouseover="selectStyle(item,index)" @mouseout="idx=undefined">
                                                    <img  :src="item.url"/>
                                                    <div :class="[index==idx?'active':'no-active']">
                                                        <span @click="handlePictureCardPreview(item)" style="color:white"><i class="el-icon-zoom-in"></i></span>
                                                        <span @click="handleRemove(item,index)" style="margin-left:15px;color:white"><i class="el-icon-delete"></i></span>
                                                    </div>
                                            </div>
                                        </transition-group>
                                    </vuedraggable>
                                    <div>
                                        <img v-for="(item,index) in form.cover" :key="index" :src="item.url" class="avatar">
                                        <i @click="selectCover" class="el-icon-plus avatar-uploader-icon"></i>
                                    </div>
                                </el-form-item>
                                <el-form-item label="活动图片：" prop="activity_img" v-else>
                                    <vuedraggable class="wrapper" v-model="form.banner_img">
                                        <transition-group>
                                            <div v-for="(item,index) in form.banner_img" :key="index" class="drag-box" @mouseover="selectStyle(item,index)" @mouseout="idx=undefined">
                                                    <img  :src="item.url"/>
                                                    <div :class="[index==idx?'active':'no-active']">
                                                        <span @click="handlePictureCardPreview(item)" style="color:white"><i class="el-icon-zoom-in"></i></span>
                                                        <span @click="handleRemove(item,index)" style="margin-left:15px;color:white"><i class="el-icon-delete"></i></span>
                                                        <span @click="handleLink(item,index)" style="margin-left:15px;color:white"><i class="el-icon-link"></i></span>
                                                    </div>
                                            </div>
                                        </transition-group>
                                    </vuedraggable>
                                    <div>
                                        <img v-for="(item,index) in cur_banner_img" :key="index" :src="item.url" class="avatar">
                                        <!-- <el-form-item prop="link" label="备注链接" v-for="(item,index) in cur_banner_img" :key="index+'link'">
                                            <el-input style="width:30%" v-model="item.link" placeholder="请输入链接"></el-input>
                                        </el-form-item>
                                        <br> -->
                                        <i @click="selectCover" class="el-icon-plus avatar-uploader-icon"></i>
                                    </div>
                                </el-form-item>
                                <el-form-item>
                                    <el-button type="primary" @click="bannerVisible=false">关闭</el-button>
                                </el-form-item>
                            </div>
                        </div>
                        <div slot="reference" class="banner" v-show="form.is_banner" @click="bannerBox">
                            <!-- 活动图 -->
                            <div :class="{'activity-img':true,'actives':active_index==1}" v-if="form.banner_type==1" @click="active_index=1">
                                <el-image :src="cur_activity_img" fit="fill">
                                    <div slot="error" class="image-slot">
                                        <i class="el-icon-picture-outline"></i>
                                    </div>
                                </el-image>
                            </div>
                            <!-- 轮播图 -->
                            <div :class="{'scroll-img':true,'actives':active_index==1}"  @click="active_index=1" v-else>
                                <el-carousel height="152px">
                                    <el-carousel-item v-for="(item,index) in cur_banner_img" :key="index">
                                        <el-image :src="item.url" fit="fill">
                                        <div slot="error" class="image-slot">
                                            <i class="el-icon-picture-outline"></i>
                                        </div>
                                    </el-image>
                                    </el-carousel-item>
                                </el-carousel>
                            </div>
                            <div class="set-btn" v-if="active_index==1">
                                <!-- 阻止事件冒泡传递 -->
                                <el-button size="mini" type="danger" @click.stop="deleBannerBox">删除</el-button>
                            </div>
                        </div>
                    </el-popover>
                    <!-- tab标签 -->
                    <el-popover
                        placement="right"
                        title="导航栏模块设置"
                        width="600"
                        trigger="manual"
                        v-model="tabVisible">
                            <div>
                                <el-form ref="tabForm" :model="tabForm" label-width="100px"  size="small">
                                    <el-row>
                                        <el-col :span="4">
                                            <el-form-item prop="is_trace" label="" label-width="20px" >
                                                <el-checkbox @change="saveTab" v-model="tabForm.is_trace"  :true-label="1" :false-label="0">溯源</el-checkbox>
                                            </el-form-item>
                                        </el-col>
                                        <el-col :span="14">
                                            <el-form-item prop="trace_name" label="自定义名称" >
                                                 <el-input style="width:90%" maxlength="4" show-word-limit v-model="tabForm.trace_name" placeholder="请输入自定义名称"></el-input>
                                            </el-form-item>
                                        </el-col>
                                    </el-row>
                                    <el-row>
                                        <el-col :span="4">
                                            <el-form-item prop="is_auth" label="" label-width="20px" >
                                                <el-checkbox @change="saveTab" v-model="tabForm.is_auth"  :true-label="1" :false-label="0">认证</el-checkbox>
                                            </el-form-item>
                                        </el-col>
                                        <el-col :span="14">
                                            <el-form-item prop="auth_name" label="自定义名称" >
                                                 <el-input style="width:90%" maxlength="4" show-word-limit v-model="tabForm.auth_name" placeholder="请输入自定义名称"></el-input>
                                            </el-form-item>
                                        </el-col>
                                    </el-row>
                                    <el-row>
                                        <el-col :span="4">
                                            <el-form-item prop="is_product" label="" label-width="20px" >
                                                <el-checkbox @change="saveTab" v-model="tabForm.is_product"  :true-label="1" :false-label="0">产品</el-checkbox>
                                            </el-form-item>
                                        </el-col>
                                        <el-col :span="14">
                                            <el-form-item prop="product_name" label="自定义名称" >
                                                 <el-input style="width:90%" maxlength="4" show-word-limit v-model="tabForm.product_name" placeholder="请输入自定义名称"></el-input>
                                            </el-form-item>
                                        </el-col>
                                    </el-row>
                                    <el-row>
                                        <el-col :span="4">
                                            <el-form-item prop="is_company" label="" label-width="20px" >
                                                <el-checkbox @change="saveTab" v-model="tabForm.is_company"  :true-label="1" :false-label="0">企业</el-checkbox>
                                            </el-form-item>
                                        </el-col>
                                        <el-col :span="14">
                                            <el-form-item prop="company_name" label="自定义名称" >
                                                 <el-input style="width:90%" maxlength="4" show-word-limit v-model="tabForm.company_name" placeholder="请输入自定义名称"></el-input>
                                            </el-form-item>
                                        </el-col>
                                    </el-row>
                                     <el-form-item>
                                        <el-button type="primary" @click="tabVisible=false">关闭</el-button>
                                    </el-form-item>
                                </el-form>
                            </div>
                        <div class="app-tab" slot="reference" @click="tabBox" :class="{'actives':active_index==2}">
                            <el-tabs v-model="activeTabName" @tab-click="handleClickTab">
                                <el-tab-pane v-if="tabForm.is_trace==1" :label="tabForm.trace_name" name="1"></el-tab-pane>
                                <el-tab-pane v-if="tabForm.is_auth==1" :label="tabForm.auth_name" name="2"></el-tab-pane>
                                <el-tab-pane v-if="tabForm.is_product==1" :label="tabForm.product_name" name="3"></el-tab-pane>
                                <el-tab-pane v-if="tabForm.is_company==1" :label="tabForm.company_name" name="4"></el-tab-pane>
                                <!-- <el-tab-pane v-for="(item,index) of tabs" :label="item.label" :name="item.name" :key="index">
                                </el-tab-pane> -->
                            </el-tabs>
                        </div>
                    </el-popover>
                    <!-- tab点击对应内容 -->
                    <!-- 溯源查询记录 -->
                     <el-popover
                        placement="right"
                        title="查询结果模块设置"
                        width="600"
                        trigger="manual"
                        v-model="traceLogVisible">
                            <div>
                                <el-form ref="traceLogForm" :model="traceLogForm" label-width="100px"  size="small">
                                    <el-form-item prop="trace_log_title" label="模块标题" >
                                        <el-input style="width:90%" maxlength="10" show-word-limit v-model="traceLogForm.trace_log_title" placeholder="请输入模块标题"></el-input>
                                        <div>（以下为当前查询提示，审核通过后会以修改后的最新查询提示显示）</div>
                                    </el-form-item>
                                    <el-form-item prop="trace_first_query_tips" label="首次查询提示" >
                                        <el-input style="width:90%" disabled type="textarea" v-model="traceLogForm.trace_first_query_tips"></el-input>
                                        <el-link type="primary" @click="traceOpen=true">修改</el-link>
                                    </el-form-item>
                                    <el-form-item prop="trace_again_query_tips" label="重复查询提示" >
                                        <el-input style="width:90%" disabled type="textarea" v-model="traceLogForm.trace_again_query_tips"></el-input>
                                        <el-link type="primary" @click="traceOpen=true">修改</el-link>
                                    </el-form-item>
                                    <el-form-item prop="is_log_show" label="" >
                                        <el-checkbox v-model="traceLogForm.is_log_show" :true-label="1" :false-label="0">是否显示历史记录</el-checkbox>
                                    </el-form-item>
                                    <el-form-item>
                                        <el-button type="primary" @click="traceLogVisible=false">关闭</el-button>
                                    </el-form-item>
                                </el-form>
                            </div>
                            <!-- 查询记录 -->
                            <div class="trace-log" :class="{'actives':active_index==3}" slot="reference" @click="traceLogBox" v-show="activeTabName=='1'">
                                <p>{{traceLogForm.trace_log_title}}</p>
                                <p>当前溯源码为首次查询，感谢您的查询。</p>
                                <p style="text-align:right;width:100%">
                                <el-link type="primary" v-show="traceLogForm.is_log_show">查询记录</el-link>
                                </p>
                            </div>
                     </el-popover>
                    <!-- 溯源信息 -->
                    <el-popover
                        placement="right"
                        title="溯源信息模块设置"
                        width="600"
                        trigger="manual"
                        v-model="traceInfoVisible">
                        <div>
                            <el-form ref="traceInfoForm" :model="traceInfoForm" label-width="100px"  size="small">
                                    <el-form-item prop="trace_info_title" label="模块标题" >
                                        <el-input style="width:90%" maxlength="10" show-word-limit v-model="traceInfoForm.trace_info_title" placeholder="请输入模块标题"></el-input>
                                    </el-form-item>
                                    <el-form-item>
                                        <el-button type="primary" @click="traceInfoVisible=false">关闭</el-button>
                                    </el-form-item>
                            </el-form>
                        </div>
                        <div class="trace-info" :class="{'actives':active_index==4}" slot="reference" @click="traceInfoBox" v-show="activeTabName=='1'">
                            <p>{{traceInfoForm.trace_info_title}}</p>
                            <p>提示：溯源信息将调用对应的产品批次信息</p>
                            <p>请在【溯源信息管理】-【产品批次管理】中添加溯源信息</p>
                        </div>
                    </el-popover>
                    <!-- 认证信息 -->
                    <el-popover
                        placement="right"
                        title="防伪认证模块设置"
                        width="600"
                        trigger="manual"
                        v-model="authVisible">
                         <div>
                            <el-form ref="authForm" :model="authForm" label-width="100px"  size="small">
                                <el-form-item prop="auth_title" label="模块标题" >
                                    <el-input style="width:90%" maxlength="10" show-word-limit v-model="authForm.auth_title" placeholder="请输入模块标题"></el-input>
                                    <div>（以下为当前查询提示，审核通过后会以修改后的最新查询提示显示）</div>
                                </el-form-item>
                                <el-form-item prop="auth_first_query_tips" label="首次查询提示" >
                                    <el-input style="width:90%" disabled type="textarea" v-model="authForm.auth_first_query_tips"></el-input>
                                    <el-link type="primary" @click="authOpen=true">修改</el-link>
                                </el-form-item>
                                <el-form-item prop="auth_again_query_tips" label="重复查询提示" >
                                    <el-input style="width:90%" disabled type="textarea" v-model="authForm.auth_again_query_tips"></el-input>
                                    <el-link type="primary" @click="authOpen=true">修改</el-link>
                                </el-form-item>
                                <el-form-item>
                                    <el-button type="primary" @click="authVisible=false">关闭</el-button>
                                </el-form-item>
                            </el-form>
                            </div>
                        <div class="auth-box" :class="{'actives':active_index==5}" slot="reference" @click="authBox" v-show="activeTabName=='2'">
                            <p>{{authForm.auth_title}}</p>
                            <div class="auth-icon"><i class="el-icon-circle-check"></i></div>
                            <p style="font-size:14px">您好，您所查询的是@品牌商名称@生产的产品，请放心使用！</p>
                        </div>
                    </el-popover>
                    <!-- 产品信息 -->
                     <el-popover
                        placement="right"
                        title="产品信息模块设置"
                        width="600"
                        trigger="manual"
                        v-model="productVisible">
                        <div>
                            <el-form ref="productForm" :model="productForm" label-width="100px"  size="small">
                                <el-form-item prop="product_title" label="模块标题" >
                                    <el-input style="width:90%" maxlength="10" show-word-limit v-model="productForm.product_title" placeholder="请输入模块标题"></el-input>
                                </el-form-item>
                                <el-form-item prop="is_product_code" label="" label-width="20px" >
                                    <el-checkbox v-model="productForm.is_product_code"  :true-label="1" :false-label="0">产品编号</el-checkbox>
                                </el-form-item>
                                <el-form-item prop="is_product_img" label="" label-width="20px" >
                                    <el-checkbox v-model="productForm.is_product_img"  :true-label="1" :false-label="0">产品图片</el-checkbox>
                                </el-form-item>
                                <el-form-item prop="is_product_name" label="" label-width="20px" >
                                    <el-checkbox v-model="productForm.is_product_name"  :true-label="1" :false-label="0">产品名称</el-checkbox>
                                </el-form-item>
                                <el-form-item prop="is_product_weight" label="" label-width="20px" >
                                    <el-checkbox v-model="productForm.is_product_weight"  :true-label="1" :false-label="0">产品重量</el-checkbox>
                                </el-form-item>
                                <el-form-item prop="is_product_price" label="" label-width="20px" >
                                    <el-checkbox v-model="productForm.is_product_price"  :true-label="1" :false-label="0">产品价格</el-checkbox>
                                </el-form-item>
                                <el-form-item prop="is_product_des" label="" label-width="20px" >
                                    <el-checkbox v-model="productForm.is_product_des"  :true-label="1" :false-label="0">产品详情</el-checkbox>
                                </el-form-item>
                                 <el-form-item prop="is_buy" label="" label-width="20px" >
                                    <el-checkbox v-model="productForm.is_buy"  :true-label="1" :false-label="0">显示微商城购买链接</el-checkbox>
                                </el-form-item>
                                <el-form-item>
                                    <el-button type="primary" @click="productVisible=false">关闭</el-button>
                                </el-form-item>
                            </el-form>
                        </div>
                        <div class="product-box" :class="{'actives':active_index==6}" slot="reference" @click="productBox" v-show="activeTabName=='3'">
                            <div class="product-tips">
                                <span>{{productForm.product_title}}</span>
                                <el-link v-show="productForm.is_buy==1" type="primary">前往购买</el-link>
                            </div>
                            <el-image v-show="productForm.is_product_img==1">
                                <div slot="error" class="image-slot">
                                    <i class="el-icon-picture-outline"></i>
                                </div>
                            </el-image>
                            <div style="font-size:14px;float:left;width:100%">
                                <p v-show="productForm.is_product_code==1">产品编号：001</p>
                                <p v-show="productForm.is_product_name==1">产品名称：大鸭梨</p>
                                <p v-show="productForm.is_product_weight==1">产品重量：0.2kg</p>
                                <p v-show="productForm.is_product_price==1">产品价格：5元</p>
                            </div>
                            <div v-show="productForm.is_product_des==1">
                                <p>产品详情</p>
                                <el-empty description="此处调用产品库的产品详情"></el-empty>
                            </div>
                        </div>
                     </el-popover>
                     <!-- 企业信息 -->
                     <el-popover
                        placement="right"
                        title="企业信息模块设置"
                        width="600"
                        trigger="manual"
                        v-model="companyVisible">
                        <div>
                            <el-form ref="companyForm" :model="companyForm" label-width="100px"  size="small">
                                <el-form-item prop="company_title" label="模块标题" >
                                    <el-input style="width:90%" maxlength="10" show-word-limit v-model="companyForm.company_title" placeholder="请输入模块标题"></el-input>
                                </el-form-item>
                                <el-form-item prop="is_business_license_code" label="" label-width="20px" >
                                    <el-checkbox v-model="companyForm.is_business_license_code"  :true-label="1" :false-label="0">营业执照编号</el-checkbox>
                                </el-form-item>
                                <el-form-item prop="is_business_license_url" label="" label-width="20px" >
                                    <el-checkbox v-model="companyForm.is_business_license_url"  :true-label="1" :false-label="0">营业执照照片</el-checkbox>
                                </el-form-item>
                                <el-form-item prop="is_dealer_name" label="" label-width="20px" >
                                    <el-checkbox v-model="companyForm.is_dealer_name"  :true-label="1" :false-label="0">认证品牌</el-checkbox>
                                </el-form-item>
                                <el-form-item prop="is_address" label="" label-width="20px" >
                                    <el-checkbox v-model="companyForm.is_address"  :true-label="1" :false-label="0">联系地址</el-checkbox>
                                </el-form-item>
                                <el-form-item prop="is_telephone" label="" label-width="20px" >
                                    <el-checkbox v-model="companyForm.is_telephone"  :true-label="1" :false-label="0">客服电话</el-checkbox>
                                </el-form-item>
                                <el-form-item prop="is_email" label="" label-width="20px" >
                                    <el-checkbox v-model="companyForm.is_email"  :true-label="1" :false-label="0">邮箱</el-checkbox>
                                </el-form-item>
                                 <el-form-item prop="is_website" label="" label-width="20px" >
                                    <el-checkbox v-model="companyForm.is_website"  :true-label="1" :false-label="0">官方网站</el-checkbox>
                                </el-form-item>
                                <el-form-item prop="" label="" label-width="20px" >
                                    <span>企业信息请在【系统】-【账户管理】中修改，营业执照信息需要认证资料。</span>
                                </el-form-item>
                                <el-form-item>
                                    <el-button type="primary" @click="companyVisible=false">关闭</el-button>
                                </el-form-item>
                            </el-form>
                        </div>
                        <div class="company-box" :class="{'actives':active_index==7}" slot="reference" @click="companyBox" v-show="activeTabName=='4'">
                            <p style="width:100%;text-align:left">{{companyForm.company_title}}</p>
                            <div style="font-size:14px;float:left;width:100%">
                                <p>企业名称：{{dealerInfo.company}}</p>
                                <p v-show="companyForm.is_business_license_code==1">营业执照编号：</p>
                                <p v-show="companyForm.is_business_license_url==1">营业执照图片：</p>
                                <p v-show="companyForm.is_dealer_name==1">认证品牌：{{dealerInfo.dealer_name}}</p>
                                <p v-show="companyForm.is_address==1">联系地址：{{dealerInfo.province+'-'+dealerInfo.city+'-'+dealerInfo.district}}</p>
                                <p v-show="companyForm.is_telephone==1">客服电话：{{dealerInfo.telephone}}</p>
                                <p v-show="companyForm.is_email==1">邮箱：{{dealerInfo.email}}</p>
                                <p v-show="companyForm.is_website==1">官方网站：{{dealerInfo.website}}</p>
                            </div>
                        </div>
                     </el-popover>
                     <!-- 宣传视频 -->
                     <el-popover
                        placement="right"
                        title="宣传视频模块设置"
                        width="600"
                        trigger="manual"
                        v-model="videoVisible">
                        <div>
                            <el-form ref="videoForm" :model="videoForm" label-width="100px"  size="small">
                                <el-form-item prop="video_title" label="模块标题" >
                                    <el-input style="width:90%" maxlength="10" show-word-limit v-model="videoForm.video_title" placeholder="请输入模块标题"></el-input>
                                </el-form-item>
                                <el-form-item prop="video_url" label="视频地址" >
                                    <el-input style="width:90%" placeholder="请输入网址" v-model="videoForm.video_url"><template slot="prepend">Https://</template></el-input>
                                </el-form-item>
                                <el-form-item>
                                    <el-button type="primary" @click="videoVisible=false">关闭</el-button>
                                </el-form-item>
                            </el-form> 
                        </div>
                        <div class="video-box" :class="{'actives':active_index==8}" slot="reference" @click="videoBox" v-show="form.is_video">
                            <p>{{videoForm.video_title}}</p>
                            <el-image>
                                <div slot="error" class="image-slot">
                                    <i class="el-icon-video-play"></i>
                                </div>
                            </el-image>
                            <div class="set-btn">
                                <!-- 阻止事件冒泡传递 -->
                                <el-button size="mini" type="danger" @click.stop="deleVideoBox">删除</el-button>
                            </div>
                        </div>
                     </el-popover>
                </div>
                <div style="height: 60px;"></div>
            </div>
        </div>
        <div class="app-add-field">
            <el-button type="primary" @click="addBannerBox" size="small">活动/广告轮播图</el-button>
            <el-button type="primary" size="small">自定义通道</el-button>
            <el-button type="primary" @click="addVideo" size="small">宣传视频</el-button>
        </div>
        <div class="app-end">
            <i></i>
        </div>
    </div>
    </el-form>
    <!-- 修改防伪查询提示 -->
    <el-dialog title="防伪查询提示" class="authDialog" :visible.sync="authOpen" width="40%" @close="authOpen=false">
        <el-form ref="authUpadteForm" :model="authUpadteForm" label-width="100px"  size="small">
            <el-form-item prop="auth_query_tips_check_status" label="状态：" >
                {{authUpadteForm.auth_query_tips_check_status}}
            </el-form-item>
            <el-form-item prop="check_auth_first_query_tips" label="首次查询提示：" >
                <el-input style="width:90%" type="textarea" v-model="authUpadteForm.check_auth_first_query_tips"></el-input>
            </el-form-item>
            <el-form-item prop="check_auth_again_query_tips" label="重复查询提示：" >
                <el-input style="width:90%" type="textarea" v-model="authUpadteForm.check_auth_again_query_tips"></el-input>
                <div>温馨提示：修改查询提示后需等待客服审核通过后才会生效，可稍后再回来查看，如比较紧急或一直没生效请直接联系客服。</div>
            </el-form-item>
        </el-form>
        <div slot="footer" class="dialog-footer">
            <el-button type="primary" @click="submitAuthForm">确 定</el-button>
            <el-button @click="authOpen=false">取 消</el-button>
        </div>
    </el-dialog>
    <!-- 修改溯源码防伪查询提示 -->
    <el-dialog title="溯源查询提示" class="traceDialog" :visible.sync="traceOpen" width="40%" @close="traceOpen=false">
        <el-form ref="traceUpadteForm" :model="traceUpadteForm" label-width="100px"  size="small">
            <el-form-item prop="status" label="状态：" >
                {{traceUpadteForm.trace_query_tips_check_status}}
            </el-form-item>
            <el-form-item prop="check_trace_first_query_tips" label="首次查询提示：" >
                <el-input style="width:90%" type="textarea" v-model="traceUpadteForm.check_trace_first_query_tips"></el-input>
            </el-form-item>
            <el-form-item prop="check_trace_again_query_tips" label="重复查询提示：" >
                <el-input style="width:90%" type="textarea" v-model="traceUpadteForm.check_trace_again_query_tips"></el-input>
                <div>温馨提示：修改查询提示后需等待客服审核通过后才会生效，可稍后再回来查看，如比较紧急或一直没生效请直接联系客服。</div>
            </el-form-item>
        </el-form>
        <div slot="footer" class="dialog-footer">
            <el-button type="primary" @click="submitTraceLogForm">确 定</el-button>
            <el-button @click="traceOpen=false">取 消</el-button>
        </div>
    </el-dialog>
     <!-- 图片素材 -->
      <el-dialog title="素材库" class="materialDialog" :visible.sync="materialOpen" width="50%" @close="materialOpen=false">
            <el-tabs v-model="queryForm.img_group" :tab-position="tabPosition" @tab-click="handleClick" style="height: 600px;overflow:auto">
                <el-tab-pane v-for="(item,index) in group" :key="index" :label="item.group_name" :name="String(item.id)">
                    <div class="img-list">
                        <ul>
                            <li v-for="(it,idx) in imgMaterialList" :key="idx" :class="{active:active(it)}" @click="handleClickImg(it,idx)">
                                <el-image
                                    style="width: 150px; height: 150px"
                                    :src="it.img_url"
                                    fit="fill">
                                </el-image>
                            </li>
                        </ul>
                        <pagination
                            v-show="+total>20"
                            :total="+total"
                            :page.sync="queryForm.pageNum"
                            :limit.sync="queryForm.pageSize"
                            @pagination="getImgMaterial"
                        />
                    </div>
                </el-tab-pane>
            </el-tabs>
            <div slot="footer" class="dialog-footer">
                <el-button type="primary" @click="submitCover">确 定</el-button>
                <el-button @click="materialOpen=false">取 消</el-button>
            </div>
      </el-dialog>
      <el-dialog :visible.sync="dialogVisible">
        <img width="100%" :src="dialogImageUrl" alt="">
      </el-dialog>
      <!-- 添加链接 -->
      <el-dialog title="链接" class="linkDialog" :visible.sync="linkDialog" width="50%" @close="linkDialog=false">
        <el-form :model="linkForm" ref="linkForm" label-width="100px"  size="medium">
            <el-form-item label="链接：" prop="link">
                <el-input style="width:90%"  v-model="linkForm.link" placeholder="请输入图片链接">
                    <template slot="prepend">Http://</template>
                </el-input>
            </el-form-item>
        </el-form>
        <div slot="footer" class="dialog-footer">
            <el-button type="primary" @click="submitLink">确 定</el-button>
            <el-button @click="linkDialog=false">取 消</el-button>
        </div>
      </el-dialog>
    <div class="save-btn">
        <el-button type="primary" @click="saveTemplate">保存</el-button>
    </div>
  </div>
</template>

<script>
import  vuedraggable from "vuedraggable";
import {getGroupList,getImgMaterial} from '@/api/assets/material'
import {saveTraceTpl,getTplInfo} from '@/api/app/trace'
import {getDealerInfo} from "@/api/system/account";
export default {
    components: {
        vuedraggable
    },
    data(){
        return{
            dealerInfo:{},
            tpl_id:undefined,
            videoForm:{
                video_title:'宣传视频',
                video_url:''
            },
            videoVisible:false,
            companyForm:{
                company_title:'企业信息',
                is_business_license_code:1,
                is_business_license_url:1,
                is_dealer_name:1,
                is_address:1,
                is_telephone:1,
                is_email:1,
                is_website:1
            },
            companyVisible:false,
            productForm:{
                product_title:'产品信息',
                is_product_code:1,
                is_product_img:1,
                is_product_name:1,
                is_product_weight:1,
                is_product_price:1,
                is_product_des:1,
                is_buy:1
            },
            productVisible:false,
            authOpen:false,
            authForm:{
                auth_title:'防伪认证',
                auth_first_query_tips:'您好，您所查询的是@品牌商名称@生产的产品，请放心使用！',
                auth_again_query_tips:'该防伪码已经被人查询过，首次查询时间：@查询时间@，谨防假冒！'

            },
            traceInfoForm:{
                trace_info_title:'溯源信息'
            },
            authVisible:false,
            traceInfoVisible:false,
            traceUpadteForm:{
                trace_query_tips_check_status:'0',
                check_trace_first_query_tips:'当前溯源码为首次查询，感谢您的查询！',
                check_trace_again_query_tips:'当前溯源码为第@次@次查询，感谢您的查询！'
            },
            authUpadteForm:{
                auth_query_tips_check_status:'0',
                check_auth_first_query_tips:'您好，您所查询的是@品牌商名称@生产的产品，请放心使用！',
                check_auth_again_query_tips:'该防伪码已经被人查询过，首次查询时间：@查询时间@，谨防假冒！'
            },
            traceOpen:false,
            traceLogVisible:false,
            traceLogForm:{
                trace_log_title:'查询记录',
                trace_first_query_tips:'当前溯源码为首次查询，感谢您的查询！',
                trace_again_query_tips:'当前溯源码为第@次@次查询，感谢您的查询！',
                is_log_show:true
            },
            tabVisible:false,
            tabForm:{
                is_trace:1,
                trace_name:'溯源',
                is_auth:1,
                auth_name:'认证',
                is_product:1,
                product_name:'产品',
                is_company:1,
                company_name:'企业'
            },
            banner_img_index:undefined,
            linkForm:{
                link:''
            },
            linkDialog:false,
            tabPosition: 'left',
            imgMaterialList:[],
            total:0,
            group:[],
            form:{
                id:undefined,
                template_name:'',
                page_title:'溯源档案',
                remark:'',
                banner_img:[
                    {
                        img_name:'',
                        url:'https://cdn.icloudapi.cn/sy-default.png',
                        link:''
                    }
                ],
                banner_imgs:[],
                activity_img:[
                    {
                        img_name:'',
                        url:'https://cdn.icloudapi.cn/sy-default.png'
                    }
                ],
                activity_imgs:[],
                is_banner:true,//是否显示banne活动图片
                is_video:false,//是否显示推广视频
                banner_type:'1',//banner 1默认活动图 2轮播图
            },
            titleVisible:false,
            bannerVisible:false,
            rule:{
                template_name:[
                     {required: true, message: "请输入模板名称", trigger: "blur" },
                ]
            },
            queryGroupForm:{
                pageNum:1,
                pageSize:999,
                group_name:''
            },
            queryForm:{
                pageNum:1,
                pageSize:20,
                img_group:'01',//默认查询全部图片库
                img_name:'',
            },
            idx:undefined,
            active_index:-1,//选中的区域序号 默认未选中
            activity_img:'https://cdn.icloudapi.cn/sy-default.png',
            dialogVisible:false,
            materialOpen:false,
            dialogImageUrl:'',
            activeTabName:'1',
            tabs:[
                {
                    label:'溯源',
                    name:'1'
                },
                {
                    label:'认证',
                    name:'2'
                },
                {
                    label:'产品',
                    name:'3'
                },
                {
                    label:'企业',
                    name:'4'
                },
            ]
        }
    },
    computed:{
        active(){
            return function (value){
                if(this.form.banner_type=='1'){
                    return this.form.activity_imgs.map(item=>item.name).includes(value.img_name)
                }else{
                    return this.form.banner_imgs.map(item=>item.name).includes(value.img_name)
                }
            }
        },
        cur_activity_img(){
            return this.form.activity_img.length>0?this.form.activity_img[0].url:this.activity_img
        },
        cur_banner_img(){
            var origin=[
                {
                    img_name:'',
                    url:this.activity_img,
                    link:''
                }
            ]
            return this.form.banner_img.length>0?this.form.banner_img:origin
        }
    },
    created(){
        this.getDealerInfo()
        this.getGroupList()
        if(this.$route.query.tpl_id){
            this.tpl_id=this.$route.query.tpl_id
            getTplInfo({id:this.tpl_id}).then(res=>{
                this.form=res.data
                //tab页
                this.tabForm={
                    is_trace:res.data.tab[0].is_show,
                    trace_name:res.data.tab[0].title,
                    is_auth:res.data.tab[1].is_show,
                    auth_name:res.data.tab[1].title,
                    is_product:res.data.tab[2].is_show,
                    product_name:res.data.tab[2].title,
                    is_company:res.data.tab[3].is_show,
                    company_name:res.data.tab[3].title
                }
                //数据表格全赋值无影响
                this.traceLogForm=res.data
                this.traceUpadteForm=res.data
                this.traceInfoForm=res.data
                this.authForm=res.data
                this.authUpadteForm=res.data
                this.productForm=res.data
                this.companyForm=res.data
                this.videoForm=res.data
            })
        }
    },
    methods:{
        getDealerInfo(){
           getDealerInfo({}).then(res=>{
               this.$nextTick(()=>{
                    var arr=Object.assign({},res.data)
                    this.dealerInfo=arr
               })
           }) 
        },
        saveTitleForm(){

        },
        handlePreview(){

        },
        changeBannerType(val){

        },
        handleRemove(item,index){
            if(this.form.banner_type=='1'){
                this.form.activity_img.splice(index,1)
            }else{
                this.form.banner_img.splice(index,1)
            }
        },
        handlePictureCardPreview(file) {
            this.dialogImageUrl = file.url;
            this.dialogVisible = true;
        },
        selectStyle(item,index){
            console.log(index)
            this.idx=index
        },
        uploadActivityImg(){
            console.log(55)
        },
        tabBox(){
            this.active_index=2
            this.bannerVisible=false
            this.titleVisible=false
            this.traceInfoVisible=false
            this.traceLogVisible=false
            this.productVisible=false
            this.authVisible=false
            this.videoVisible=false
            this.companyVisible=false
            this.tabVisible=true
        },
        bannerBox(){
            this.active_index=1
            this.bannerVisible=true
            this.tabVisible=false
            this.titleVisible=false
            this.traceInfoVisible=false
            this.productVisible=false
            this.authVisible=false
            this.traceLogVisible=false
            this.videoVisible=false
            this.companyVisible=false
        },
        titleBox(){
            this.active_index=0
            this.titleVisible=true
            this.bannerVisible=false
            this.tabVisible=false
            this.authVisible=false
            this.traceInfoVisible=false
            this.productVisible=false
            this.traceLogVisible=false
            this.videoVisible=false
            this.companyVisible=false
        },
        traceLogBox(){
            this.traceLogVisible=true,
            this.titleVisible=false
            this.bannerVisible=false
            this.tabVisible=false
            this.authVisible=false
            this.traceInfoVisible=false
            this.videoVisible=false
            this.active_index=3
        },
        traceInfoBox(){
            this.traceLogVisible=false,
            this.titleVisible=false
            this.bannerVisible=false
            this.tabVisible=false
            this.traceInfoVisible=true
            this.companyVisible=false
            this.productVisible=false
            this.videoVisible=false
            this.authVisible=false
            this.active_index=4
        },
        authBox(){
            this.traceLogVisible=false,
            this.titleVisible=false
            this.bannerVisible=false
            this.tabVisible=false
            this.traceInfoVisible=false
            this.productVisible=false
            this.companyVisible=false
            this.videoVisible=false
            this.authVisible=true
            this.active_index=5
            this.$forceUpdate()
        },
        productBox(){
            this.traceLogVisible=false,
            this.titleVisible=false
            this.bannerVisible=false
            this.tabVisible=false
            this.traceInfoVisible=false
            this.authVisible=false
            this.companyVisible=false
            this.videoVisible=false
            this.productVisible=true
            this.active_index=6
        },
        companyBox(){
            this.traceLogVisible=false,
            this.titleVisible=false
            this.bannerVisible=false
            this.tabVisible=false
            this.traceInfoVisible=false
            this.authVisible=false
            this.productVisible=false
            this.videoVisible=false
            this.companyVisible=true
            this.active_index=7
        },
        videoBox(){
            this.active_index=8
            this.traceLogVisible=false,
            this.titleVisible=false
            this.bannerVisible=false
            this.tabVisible=false
            this.traceInfoVisible=false
            this.authVisible=false
            this.productVisible=false
            this.companyVisible=false
            this.videoVisible=true
            this.$forceUpdate()
        },
        saveTab(){
            if(!this.tabForm.is_trace&&!this.tabForm.is_auth&&!this.tabForm.is_product&&!this.tabForm.is_company){
                this.$message.warning('至少选择一个导航栏')
                return;
            }
        },
        submitAuthForm(){

        },
        submitTraceLogForm(){
            this.traceOpen=false
        },
        uploadSectionFile(){
        },
        handleClickTab(){

        },
        handleClick(){
            this.queryForm.pageNum=1
            this.getImgMaterial()
        },
        getGroupList(){
            getGroupList(this.queryGroupForm).then(res=>{
                this.group=Object.assign([],res.data)
                this.group.unshift(
                    {
                        id:'01',
                        group_name:'全部'
                    },
                    {
                        id:0,
                        group_name:'未分组'
                    }
                )
            })
        },
         selectCover(){
            this.imgMaterialList=[]
            this.queryForm.img_group='01'
            this.queryForm.pageNum=1
            this.getImgMaterial()
            this.materialOpen=true
            this.form.activity_imgs=[]
            this.form.banner_imgs=[]
        },
        handleClickImg(it,idx){
            if(this.form.banner_type=='1'){
                if(this.form.activity_img.map(item=>item.name).includes(it.img_name)){
                    var index=this.form.activity_imgs.map(item=>item.name).indexOf(it.img_name)
                    this.form.activity_imgs.splice(index,1)
                    this.$message.warning('禁止选择重复图片')
                    return;
                }
                if(this.form.activity_img.length+this.form.activity_imgs.length==1){
                    this.$message.warning('活动图最多上传1张')
                    return;
                }
                this.form.activity_imgs.push({
                    url:it.img_url,
                    name:it.img_name
                })
            }else{
                if(this.form.banner_img.map(item=>item.name).includes(it.img_name)){
                    var index=this.form.banner_imgs.map(item=>item.name).indexOf(it.img_name)
                    this.form.banner_imgs.splice(index,1)
                    this.$message.warning('禁止选择重复图片')
                    return;
                }
                if(this.form.banner_img.length+this.form.banner_imgs.length==5){
                    this.$message.warning('轮播图最多上传5张')
                    return;
                }
                this.form.banner_imgs.push({
                    url:it.img_url,
                    name:it.img_name,
                    link:''
                })
            }
            this.$forceUpdate()
        },
        //添加链接
        handleLink(item,index){
            this.linkDialog=true
            this.linkForm.link=item.link
            this.banner_img_index=index
        },
        submitLink(){
            this.$set(this.form.banner_img[this.banner_img_index],'link',this.linkForm.link)
            console.log(this.form)
            this.linkDialog=false
        },
        getImgMaterial(){
            var params=Object.assign({},this.queryForm)
            if(params.img_group=='01') params.img_group=''
            getImgMaterial(params).then(res=>{
                this.imgMaterialList=res.data
                this.total=res.total
            })
        },
        addBannerBox(){
            if(this.form.is_banner){
                this.$message.warning('该元素只能添加一个')
            }else{
                this.form.is_banner=true
            }
        },
        addVideo(){
            if(this.form.is_video){
                this.$message.warning('该元素只能添加一个')
            }else{
                this.form.is_video=true
            }
        },
        deleBannerBox(){
            this.form.is_banner=false
            this.bannerVisible=false
        },
        deleVideoBox(){
            this.form.is_video=false
            this.videoVisible=false
        },
        submitCover(){
            if(this.form.banner_type=='1'){
                var arr=Object.assign([],this.form.activity_imgs)
                this.form.activity_img=this.form.activity_img.concat(arr)
                this.form.activity_imgs=[]
                this.materialOpen=false
                this.bannerVisible=true
            }else{
                var arr=Object.assign([],this.form.banner_imgs)
                this.form.banner_img=this.form.banner_img.concat(arr)
                this.form.banner_imgs=[]
                this.materialOpen=false
                this.bannerVisible=true
            }
        },
        saveTemplate(){
            this.$refs["form"].validate(valid => {
                if(valid){
                    console.log(this.form)
                    var arr=Object.assign({},this.form)
                    arr=Object.assign({},arr,this.traceLogForm,this.traceUpadteForm,this.traceInfoForm,this.authForm,this.authUpadteForm,this.productForm,this.companyForm,this.videoForm)
                    arr.is_banner=arr.is_banner?1:0
                     //拼接tab标签数据结构
                    var tab=[
                        {
                            'title':this.tabForm.trace_name,
                            'is_show':this.tabForm.is_trace
                        },
                        {
                            'title':this.tabForm.auth_name,
                            'is_show':this.tabForm.is_auth
                        },
                        {
                            'title':this.tabForm.product_name,
                            'is_show':this.tabForm.is_product
                        },
                        {
                            'title':this.tabForm.company_name,
                            'is_show':this.tabForm.is_company
                        }
                    ];
                    arr.tab=tab
                    delete arr.activity_imgs
                    delete arr.banner_imgs
                    saveTraceTpl(arr).then(res=>{
                         if(res.code==200){
                            this.$message.success(res.msg)
                            this.close();
                        }else{
                            this.$message.error(res.msg)
                        }
                    })
                }
            })
        },
        /** 关闭按钮 */
        close() {
            this.$store.dispatch("tagsView/delView", this.$route);
            this.$router.go(-1)
        },
    }
}
</script>

<style lang="scss" scoped>
.app-container{
    color: #666;
}
.mobile-box{
    float: left;
    width: 350px;
    border: 1px solid #e5e5e5;
    box-sizing: border-box;
    background: #fff;
    border-radius: 18px 18px 0 0;
    margin-bottom: 100px;
    margin-left: 50px;
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
            min-height: 536px;
            width: 100%;
            position: relative;
            z-index: 1;
            .app-content{
                margin: 0;
                padding: 0;
                display: flex;
                justify-content: center;
                flex-direction: column;
                .banner{
                    margin: 0;
                    width: 100%;
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
                    .set-btn{
                        position: absolute;
                        z-index: 999;
                        bottom: 10px;
                        right: 10px
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
                .trace-log,.trace-info,.video-box{
                    position: relative;
                    cursor: move;    
                    box-sizing: border-box;
                    min-height: 20px;
                    display: flex;
                    flex-wrap: wrap;
                    background: white;
                    padding: 10px;
                    margin: 12px 0;
                    .set-btn{
                        position: absolute;
                        z-index: 999;
                        bottom: 10px;
                        right: 10px
                    }
                }
                .auth-box{
                    width: 95%;
                    margin: 0 auto;
                    margin-top:15px;
                    -webkit-box-sizing: border-box;
                    -moz-box-sizing: border-box;
                    box-sizing: border-box;
                    padding: 10px !important;
                    min-height: 20px;
                    border-radius: 10px;
                    color: white;
                    background-color: #409EFF;
                    .auth-icon{
                        width: 100%;
                        display: flex;
                        font-size: 60px;
                        justify-content: center;
                        margin: 18px 0;
                    }
                }
                .product-box,.company-box{
                    width: 100%;
                    margin-top: 15px;
                    padding: 10px !important;
                    background-color: white;
                    display: flex;
                    min-height: 20px;
                    justify-content: center;
                    align-items: center;
                    flex-direction: column;
                    position: relative;
                    .product-tips{
                        display: flex;
                        justify-content: space-between;
                        width: 100%;
                        padding: 0 10px;
                        margin-bottom: 20px;
                    }
                }
            }
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
}
.item{
  width: 300px;
  height: 50px;
  background-color: #42b983;
  color: #ffffff;
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
        display: none;
    }
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
.img-list{
    ul li{
        display: inline-block;
        border: 1px solid #eeeeee;
        margin:0 10px 10px 0;
        cursor: pointer;
    }
    .active{
        border: 1px solid #409EFF;
    }
    .pagination-container{
        margin-bottom: 25px;
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