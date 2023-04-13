<template>
  <div class="app-container">
      <el-form ref="form" :model="form" label-width="100px" :rules="rule" :inline="true" size="small">
        <el-form-item label="模板名称" prop="tpl_name">
            <el-input style="width:240px" v-model="form.tpl_name" placeholder="请输入模板名称"></el-input>
        </el-form-item>
        <el-form-item label="备注" prop="remark">
            <el-input style="width:240px" v-model="form.remark" placeholder="请输入备注"></el-input>
        </el-form-item>
      </el-form>
      <el-tabs v-model="activeName" type="card" @tab-click="handleClick">
            <el-tab-pane v-for="(item,index) in comTabOptions" :key="index" :label="item.label" :name="item.name"></el-tab-pane>
      </el-tabs>
      <!-- 欢迎页 -->
      <div v-if="activeName=='welcome'">
            <p>提示：欢迎页可选择开启，开启后消费者扫码会先看到此页面，2-5秒后自动转入活动页或扫码页，欢迎页可以用来做广告哦！</p>
            <el-row class="content-box">
                <el-col :span="12" style="height:100%">
                <!-- 手机盒子 -->
                    <div class="mobile-box">
                        <div class="app-header"></div>
                        <div class="app-body">
                            <div class="app-bar-box">
                                <div class="title">{{welForm.title}}</div>
                            </div>
                            <div class="app-content-box">
                                <div class="img-bg">
                                    <img :src="welForm.cover"/>
                                    <div class="skip-box">
                                        {{welForm.tips}}({{welForm.duration}})
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="app-end">
                            <i></i>
                        </div>
                    </div>
                </el-col>
                <el-col class="col" :span="12" style="height:100%">
                    <el-form :model="welForm" class="form" ref="welForm" label-width="140px" :rules="welRule" size="medium">
                        <el-form-item label="是否启用欢迎页:" prop="is_active">
                            <el-switch :active-value="1" :inactive-value="0" v-model="welForm.is_active"></el-switch>
                        </el-form-item>
                        <el-form-item v-show="welForm.is_active==1" label="页面标题:" prop="title">
                            <el-input  style="width:80%" v-model="welForm.title" placeholder="请输入页面标题"/>
                        </el-form-item>
                        <el-form-item v-show="welForm.is_active==1" label="欢迎页停留时间:" prop="duration">
                            <el-select style="width:80%" v-model="welForm.duration" placeholder="请选择停留时间">
                                <el-option
                                    v-for="item in durationOption"
                                    :key="item.value"
                                    :label="item.label"
                                    :value="item.value">
                                </el-option>
                            </el-select>
                        </el-form-item>
                        <el-form-item v-show="welForm.is_active==1" label="跳过提示:" prop="tips">
                            <el-input  style="width:80%" v-model="welForm.tips" placeholder="请输入跳过提示"/>
                        </el-form-item>
                        <el-form-item v-show="welForm.is_active==1" label="欢迎图片:">
                            <div style="width:120px" @click="selectCover">
                                <img v-if="welForm.cover" :src="welForm.cover" class="avatar">
                                <i v-else class="el-icon-plus avatar-uploader-icon"></i>
                            </div>
                            <div style="color:#409EFF;cursor: pointer;" @click="resetCover">恢复默认</div>
                            <span>（建议尺寸750*1334，图片大小500KB内）</span>
                        </el-form-item>
                    </el-form>
                </el-col>
            </el-row>
      </div>
      <!-- 普通模板活动页 -->
      <div v-if="activeName=='activity'">
          <p>提示：活动页是消费者扫码后参与活动的页面，以活动主图为主，作为活动入口，清晰的设计很重要哦！</p>
          <el-row class="content-box">
                <el-col :span="12" style="height:100%">
                <!-- 手机盒子 -->
                    <div class="mobile-box">
                        <div class="app-header"></div>
                        <div class="app-body">
                            <div class="app-bar-box">
                                <div class="title">{{acviveForm.title}}</div>
                            </div>
                            <div class="app-content-box">
                                <div class="img-bg">
                                    <img :src="acviveForm.cover"/>
                                </div>
                            </div>
                        </div>
                        <div class="app-end">
                            <i></i>
                        </div>
                    </div>
                </el-col>
                <el-col class="col" :span="12" style="height:100%">
                    <el-form :model="acviveForm" class="form" ref="acviveForm" label-width="160px" :rules="activeRule" size="medium">
                        <el-form-item  label="页面标题:" prop="title">
                            <el-input  style="width:80%" v-model="acviveForm.title" placeholder="请输入页面标题"/>
                        </el-form-item>
                        <el-form-item label="是否开启防伪验证信息:" prop="is_fangwei">
                            <el-switch :active-value="1" :inactive-value="0" v-model="acviveForm.is_fangwei"></el-switch>
                            <div>开启后消费者在扫码后会先弹出防伪验证信息，验证信息可在【宣传页-防伪验证模块】内修改</div>
                        </el-form-item>
                        <el-form-item label="主题图片:">
                            <div style="width:120px" @click="selectCover">
                                <img v-if="acviveForm.cover" :src="acviveForm.cover" class="avatar">
                                <i v-else class="el-icon-plus avatar-uploader-icon"></i>
                            </div>
                            <div style="color:#409EFF;cursor: pointer;" @click="resetActiveCover">恢复默认</div>
                            <span>（建议尺寸750*1334，图片大小500KB内）</span>
                        </el-form-item>
                    </el-form>
                </el-col>
            </el-row>
      </div>
      <!-- 普通模板活动页 -->
      <div v-if="activeName=='propaganda'">
          <p>提示：宣传页是消费者参与活动后，或者无活动时看到的页面，可以设置丰富的内容哦！</p>
          <el-row class="content-box">
            <el-col class="col" :span="5">
                <el-collapse v-model="activeNames" @change="handleChange">
                        <el-collapse-item title="自定义组件" name="1">
                            <div class="comp-item" v-for="(item,index) in propagandaComp" :key="index" @click="addCom(item)">
                                <div><i style="font-size:20px" :class="item.icon"></i></div>
                                <div>{{item.text}}</div>
                            </div>
                        </el-collapse-item>
                </el-collapse>
            </el-col>
            <el-col class="col" :span="9">
              <!-- 手机盒子 -->
              <div class="mobile-box">
                    <div class="app-header"></div>
                    <div class="app-body">
                        <div class="app-bar-box" @click="active_index=-2,type=undefined" :class="{'actives':active_index==-2}">
                            <div class="title">{{title.page_title}}</div>
                        </div>
                        <div class="app-content-box">
                            <div class="app-content">
                                <vuedraggable class="wrapper" v-model="xuanchuan_page" @start="onStart" @end="onEnd">
                                    <transition-group>
                                         <div v-for="(item,index) in xuanchuan_page" :key="index" :class="[item.type,active_index==index?'actives':'']" @click="clickItem(item,index)"  :style="{'height':item.height+'px'}">
                                             <!-- 防伪信息 -->
                                             <div v-if="item.type=='auth'" class="auth-box">
                                                <i style="font-size:100px;color:white" class="el-icon-circle-check"></i>
                                                <div class="auth-tips">{{item.first_tips}}</div>
                                                <div v-if="item.is_auth_code==1" style="font-size:16px" class="auth-tips">{{item.auth_tips}}：56564565</div>
                                                <div class="auth-res">
                                                    {{item.first_res}}
                                                </div>
                                             </div>
                                             <!-- 商品信息 -->
                                             <div v-if="item.type=='goods'" class="goods-box">
                                                    <el-image>
                                                        <div slot="error" class="image-slot">
                                                            <i class="el-icon-picture-outline"></i>
                                                        </div>
                                                    </el-image>
                                                    <div class="goods_title">商品名称</div>
                                             </div>
                                             <!-- 轮播 -->
                                             <div :class="{'scroll-img':true}"  v-if="item.type=='banner'" class="goods-box">
                                                <el-carousel height="152px">
                                                    <el-carousel-item v-for="(it,idx) in item.imgList" :key="idx">
                                                        <el-image :src="it.url" fit="fill">
                                                            <div slot="error" class="image-slot">
                                                                <i class="el-icon-picture-outline"></i>
                                                            </div>
                                                        </el-image>
                                                    </el-carousel-item>
                                                </el-carousel>
                                             </div>
                                             <!-- 视频信息 -->
                                             <div v-if="item.type=='video'" class="goods-box">
                                                    <el-image>
                                                        <div slot="error" class="image-slot">
                                                            <i class="el-icon-video-play"></i>
                                                        </div>
                                                    </el-image>
                                             </div>
                                             <!-- 菜单信息 -->
                                             <div v-if="item.type=='menu'" class="menu-box">
                                                 <div class="mp">进入公众号</div>
                                                 <div class="user-center" style="border-right:0">个人中心</div>
                                             </div>
                                             <!-- 排行信息 -->
                                             <div v-if="item.type=='rank'" class="rank-box">
                                                 <div class="rank-title">
                                                     <div class="rank-title-left" style="color:red;">红包排行榜</div>
                                                     <div class="rank-title-right">积分排行榜</div>
                                                 </div>
                                                 <div class="rank-content-box">
                                                    <div class="rank-content-head">
                                                        <div style="width:20%;text-align:center">排名</div>
                                                        <div style="width:20%;text-align:center">昵称</div>
                                                        <div style="width:60%;text-align:center">金额</div>
                                                    </div>
                                                    <div class="rank-content-body">
                                                        <div class="rank-content-body-item">
                                                            <div style="width:20%;text-align:center">
                                                            1
                                                            </div>
                                                            <div style="width:20%;text-align:center">
                                                                张*
                                                            </div>
                                                            <div style="width:60%;text-align:center">
                                                                100元
                                                            </div>
                                                        </div>
                                                        <div class="rank-content-body-item">
                                                            <div style="width:20%;text-align:center">
                                                            2
                                                            </div>
                                                            <div style="width:20%;text-align:center">
                                                                李*
                                                            </div>
                                                            <div style="width:60%;text-align:center">
                                                                90元
                                                            </div>
                                                        </div>
                                                    </div>
                                                 </div>
                                             </div>
                                            <div class="set-btn" v-if="active_index==index">
                                                <el-button size="mini" type="primary" plain>编辑</el-button>
                                                <el-button size="mini" type="danger" @click="deleteItem(index)" plain>删除</el-button>
                                            </div>
                                         </div>
                                    </transition-group>
                                </vuedraggable>
                            </div>
                        </div>
                    </div>
                    <div class="app-end">
                        <i></i>
                    </div>
              </div>
            </el-col>
            <!-- 表单 -->
            <el-col class="col" :span="10">
                <div v-if="active_index==-2" style="margin-top:50px">
                    <el-form :model="title" ref="form" label-width="140px" class="form" :rules="titleRule" size="medium">
                        <el-form-item prop="page_title" label="页面标题：" >
                            <el-input style="width:90%" v-model="title.page_title" placeholder="请输入页面标题"></el-input>
                        </el-form-item>
                    </el-form>
                </div>
                 <!-- 防伪信息 -->
                <div v-if="type=='auth'" style="margin:0 auto;margin-top:100px;width:90%">
                    <el-form :model="xuanchuan_page[active_index]" ref="form" label-width="100px"  class="form" size="medium">
                        <el-form-item prop="is_auth_code" label="防伪码：" >
                            <el-radio-group  v-model="xuanchuan_page[active_index].is_auth_code">
                                <el-radio :label="0">不显示</el-radio>
                                <el-radio :label="1">显示</el-radio>
                            </el-radio-group>
                        </el-form-item>
                        <el-form-item v-if="xuanchuan_page[active_index].is_auth_code==1" prop="auth_tips" label="提示文案：" >
                            <el-input style="width:90%" v-model="xuanchuan_page[active_index].auth_tips" placeholder="请输入提示文案"></el-input>
                        </el-form-item>
                        <el-form-item prop="first_tips" label="首次扫码提示：" >
                            <el-input style="width:90%" v-model="xuanchuan_page[active_index].first_tips" placeholder="请输入首次扫码提示"></el-input>
                        </el-form-item>
                        <el-form-item prop="first_res" label="首次扫码提示：" >
                            <el-input  type="textarea" :rows="2" style="width:90%" v-model="xuanchuan_page[active_index].first_res" placeholder="请输入首次扫码提示"></el-input>
                        </el-form-item>
                        <el-form-item prop="repet_tips" label="重复扫码提示：" >
                            <el-input style="width:90%" v-model="xuanchuan_page[active_index].repet_tips" placeholder="请输入重复扫码提示"></el-input>
                        </el-form-item>
                        <el-form-item prop="repet_res" label="重复扫码提示：" >
                            <el-input  type="textarea" :rows="2" style="width:90%" v-model="xuanchuan_page[active_index].repet_res" placeholder="请输入重复扫码提示"></el-input>
                        </el-form-item>
                    </el-form>
                </div>
                <!-- 商品信息 -->
                <div v-if="type=='goods'" style="margin:0 auto;margin-top:100px;width:90%">
                    <el-form :model="xuanchuan_page[active_index]" ref="form" label-width="100px"  class="form" size="medium">
                        <el-form-item prop="is_auth_code" label="防伪码：" >
                            <el-radio-group  v-model="xuanchuan_page[active_index].link">
                                <el-radio :label="0">不带链接</el-radio>
                                <el-radio :label="1">带链接</el-radio>
                            </el-radio-group>
                            <div>
                                <p>温馨提示：</p>
                                <p>1、商品详情的显示取决于【码库-生码管理-产品关联】中的设置；</p>
                                <p>2、若码库中未关联产品，此模块将不显示；</p>
                            </div>
                        </el-form-item>
                    </el-form>
                </div>
                 <!-- 轮播图 -->
                <div v-if="type=='banner'" style="margin:0 auto;margin-top:100px;width:90%">
                    <div class="form">
                        <el-form :model="xuanchuan_page[active_index]" ref="form"  class="form" :rules="bannerRule" size="medium">
                        <el-form-item label="轮播图：" prop="activity_img">
                            <vuedraggable class="wrapper" v-model="xuanchuan_page[active_index].imgList">
                                <transition-group>
                                    <div v-for="(item,index) in xuanchuan_page[active_index].imgList" :key="index" class="drag-box" @mouseover="selectStyle(item,index)" @mouseout="idx=undefined">
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
                                <img v-for="(item,index) in xuanchuan_page[active_index].imgList" :key="index" :src="item.url" class="avatar" style="width:120px;height:120px;display:none">
                                <i @click="selectCover" class="el-icon-plus avatar-uploader-icon"></i>
                            </div>
                        </el-form-item>
                        </el-form>
                    </div>
                </div>
                <!-- 视频信息 -->
                <div v-if="type=='video'" style="margin:0 auto;margin-top:100px;width:90%">
                    <el-form :model="xuanchuan_page[active_index]" ref="form" label-width="100px"  class="form" size="medium">
                        <el-form-item prop="video_title" label="模块标题" >
                            <el-input style="width:90%" maxlength="10" show-word-limit v-model="xuanchuan_page[active_index].title" placeholder="请输入模块标题"></el-input>
                        </el-form-item>
                        <el-form-item prop="video_url" label="视频地址" >
                            <el-input style="width:90%" placeholder="请输入网址" v-model="xuanchuan_page[active_index].url"><template slot="prepend">Https://</template></el-input>
                        </el-form-item>
                    </el-form>
                </div>
                <!-- 菜单设置 -->
                <div v-if="type=='menu'" style="margin:0 auto;margin-top:100px;width:90%">
                    <el-form :model="xuanchuan_page[active_index]" ref="form" label-width="100px"  class="form" size="medium">
                        <el-form-item prop="menu_set" label="进入公众号：" >
                            <el-checkbox-group @change="menu_set" v-model="xuanchuan_page[active_index].menu_set">
                                <el-checkbox label="进入公众号">进入公众号</el-checkbox>
                                <el-checkbox label="进入中心">进入中心</el-checkbox>
                            </el-checkbox-group>
                        </el-form-item>
                    </el-form>
                </div>
                <div v-if="type=='rank'" style="margin:0 auto;margin-top:100px;width:90%">
                    <el-form :model="xuanchuan_page[active_index]" ref="form" label-width="100px"  class="form" size="medium">
                        <el-form-item prop="is_auth_code" label="红包排行榜：" >
                            <el-radio-group  v-model="xuanchuan_page[active_index].is_red_show">
                                <el-radio :label="0">不显示</el-radio>
                                <el-radio :label="1">显示</el-radio>
                            </el-radio-group>
                        </el-form-item>
                        <el-form-item prop="is_auth_code" label="积分排行榜：" >
                            <el-radio-group  v-model="xuanchuan_page[active_index].is_points_show">
                                <el-radio :label="0">不显示</el-radio>
                                <el-radio :label="1">显示</el-radio>
                            </el-radio-group>
                        </el-form-item>
                        <el-form-item prop="show_num" label="显示数量"  :rules="[
                                { required: true, message: '数量不能为空'},
                                { type: 'number', message: '数量必须为数字值'}
                        ]" >
                            <el-input style="width:90%" maxlength="10" v-model.number="xuanchuan_page[active_index].show_num" placeholder="请输入模块标题"></el-input>
                        </el-form-item>
                    </el-form>
                </div>
            </el-col>
          </el-row>
      </div>
    <el-dialog title="素材库" :visible.sync="imgDialog" width="80%" @close="imgDialog=false">
        <ImgPanel @selectImg="selectImg" :count=1 v-if="hackReset" />
        <div slot="footer" class="dialog-footer">
            <el-button type="primary" @click="submitImg">确 定</el-button>
            <el-button @click="imgDialog=false">取 消</el-button>
        </div>
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
        <el-button size="medium" type="primary" @click="save">保存</el-button>
        <el-button size="medium" type="primary" @click="goBack">返回</el-button>
    </div>
  </div>
</template>

<script>
import ImgPanel from '@/components/ImgPanel'
import  vuedraggable from "vuedraggable";
import {saveScanTpl,getTplInfo} from '@/api/app/qrcode'
export default {
    components:{
        ImgPanel,
        vuedraggable
    },
    data(){
        return{
            dialogVisible:false,
            dialogImageUrl:'',
            active_index:-1,//选中的区域序号 默认未选中
            activeNames:'1',
            title:{
                page_title:'扫码结果',
            },
            titleRule:{

            },
            bannerRule:{

            },
            auth_defaut:{
                first_tips:'正品',
                first_res:'您好，您所查询的是@品牌商名称生产的产品，请放心使用！',
                repet_tips:'重复',
                repet_res:'该防伪码已经被人查询过，首次查询时间：@查询时间，谨防假冒！'
            },
            xuanchuan_page:[
                {
                    type:'auth',
                    auth_tips:'查询防伪码为',
                    is_auth_code:1,
                    height:300,
                    first_tips:'正品',
                    first_res:'您好，您所查询的是@品牌商名称生产的产品，请放心使用！',
                    repet_tips:'重复',
                    repet_res:'该防伪码已经被人查询过，首次查询时间：@查询时间，谨防假冒！'
                }
            ],
            propagandaComp:[
                {
                    icon:'el-icon-circle-check',
                    type:'auth',
                    text:'防伪信息',
                    is_show:true
                },
                {
                    icon:'el-icon-goods',
                    type:'goods',
                    text:'商品信息',
                    is_show:true
                },
                {
                    icon:'el-icon-picture-outline',
                    text:'图片轮播',
                    type:'banner',
                    is_show:true
                },
                {
                    icon:'el-icon-video-play',
                    text:'宣传视频',
                    type:'video',
                    is_show:true
                },
                 {
                    icon:'el-icon-s-operation',
                    text:'底部菜单',
                    type:'menu',
                    is_show:true
                },
                {
                    icon:'el-icon-tickets',
                    text:'排行榜',
                    type:'rank',
                    is_show:true
                },
                // {
                //     icon:'el-icon-user',
                //     text:'经销商信息',
                //     type:'distributor',
                //     is_show:true
                // },
                // {
                //     icon:'el-icon-search',
                //     text:'溯源信息',
                //     type:'trace',
                //     is_show:true
                // },
            ],
            hackReset:false,
            type:undefined,
            imgDialog:false,
            idx:undefined,
            banner_img_index:undefined,
            form:{
                tpl_name:'默认模板',
                remark:'默认数据',
                id:undefined
            },
            durationOption:[
                {
                    label:'2s',
                    value:2
                },
                {
                    label:'3s',
                    value:3
                },
                {
                    label:'4s',
                    value:4
                },
                {
                    label:'5s',
                    value:5
                }
            ],
            welForm:{
                is_active:1,
                title:'扫码有礼',
                duration:2,
                tips:'跳过',
                cover:'http://cdn.uni-2id.com/welcom_page.png'
            },
            acviveForm:{
                title:'扫码结果',
                btn_text:'我知道了',
                is_fangwei:0,//是否开启防伪
                cover:'http://cdn.uni-2id.com/active_page.png'
            },
            activeRule:{

            },
            welRule:{
                tips:[
                    { required: true, message: '跳过提示不能为空'},
                ]
            },
            linkDialog:false,
            linkForm:{
                link:''
            },
            rule:{
                 tpl_name:{required: true, message: "请输入模板名称", trigger: "blur" },
            },
            imgList:[],
            tpl_id:undefined,
            type:undefined,
            activeName:'welcome',
            tabOptions:[],
            drag: false,
            comTabOptions:[
                {
                    label:'欢迎页',
                    name:'welcome'
                },
                {
                    label:'活动页',
                    name:'activity'
                },
                {
                    label:'宣传页',
                    name:'propaganda'
                }
            ]
        }
    },

    created(){
        this.type=this.$route.query.type
        if(this.$route.query.id){
            this.tpl_id=this.$route.query.id
            this.getTplInfo()
        }
        if(this.type==1){
            this.tabOptions=this.comTabOptions
        }
    },
    methods:{
        getTplInfo(){
            var tpl_id=this.tpl_id
            getTplInfo({id:tpl_id}).then(res=>{
                this.form.id=res.data.id
                this.form.tpl_name=res.data.tpl_name
                this.form.remark=res.data.remark
                this.welForm=res.data.welcom_page[0]
                this.acviveForm=res.data.activity_page[0]
                this.xuanchuan_page=res.data.xuanchuan_page
            })
        },
        menu_set(val){
          console.log(val)
        },
         submitLink(){
            this.$set(this.xuanchuan_page[this.active_index].imgList[this.banner_img_index],'link',this.linkForm.link)
            this.linkDialog=false
        },
        //添加链接
        handleLink(item,index){
            this.linkDialog=true
            this.linkForm.link=item.link
            this.banner_img_index=index
        },
         handleRemove(item,index){
            if(this.xuanchuan_page[this.active_index].imgList.length==1) return this.$message.warning('至少保留一张轮播图')
            this.xuanchuan_page[this.active_index].imgList.splice(index,1)
        },
        handlePictureCardPreview(file) {
            this.dialogImageUrl = file.url;
            this.dialogVisible = true;
        },
        selectStyle(item,index){
            this.idx=index
        },
        // 添加组件
        addCom(item){
            if(item.type=='auth'){
                var status=this.xuanchuan_page.filter(item=>item.type=='auth')
                if(status.length==1) return this.$message.warning('该元素只能添加一个')
                this.xuanchuan_page.push({
                    type:'auth',
                    auth_tips:'查询防伪码为',
                    is_auth_code:1,
                    height:300,
                    first_tips:'正品',
                    first_res:'您好，您所查询的是@品牌商名称生产的产品，请放心使用！',
                    repet_tips:'重复',
                    repet_res:'该防伪码已经被人查询过，首次查询时间：@查询时间，谨防假冒！'
                })
            }
            if(item.type=='goods'){
                var status=this.xuanchuan_page.filter(item=>item.type=='goods')
                if(status.length==1) return this.$message.warning('该元素只能添加一个')
                this.xuanchuan_page.push({
                    type:'goods',
                    link:0,
                    height:200
                })
            }
            if(item.type=='banner'){
                var status=this.xuanchuan_page.filter(item=>item.type=='banner')
                if(status.length==1) return this.$message.warning('该元素只能添加一个')
                this.xuanchuan_page.push({
                    type:'banner',
                    imgList:[
                        {
                            url:require('@/assets/wsc-default.png'),
                            link:''
                        }
                    ]
                })
            }
            if(item.type=='video'){
                var status=this.xuanchuan_page.filter(item=>item.type=='video')
                if(status.length==1) return this.$message.warning('该元素只能添加一个')
                this.xuanchuan_page.push({
                    type:'video',
                    title:'宣传视频',
                    url:'',
                    height:200
                })
            }
            if(item.type=='menu'){
                var status=this.xuanchuan_page.filter(item=>item.type=='menu')
                if(status.length==1) return this.$message.warning('该元素只能添加一个')
                this.xuanchuan_page.push({
                    type:'menu',
                    menu_set:['进入公众号','进入中心'],
                    height:60
                })
            }
            if(item.type=='rank'){
                var status=this.xuanchuan_page.filter(item=>item.type=='rank')
                if(status.length==1) return this.$message.warning('该元素只能添加一个')
                this.xuanchuan_page.push({
                    type:'rank',
                    is_red_show:1,//红包排行
                    is_points_show:1,//积分排行
                    show_num:5,
                    height:200
                })
            }
        },
        deleteItem(index){
            this.type=undefined
            this.xuanchuan_page.splice(index,1)
        },
        clickItem(item,index){
            this.active_index=index
            this.type=item.type
        },
        handleChange(){

        },
        handleClick(tab, event) {
            console.log(tab, event);
        },
        selectImg(list){
            this.imgList=list
        },
        //恢复欢迎页面默认
        resetCover(){
            this.welForm.cover='http://cdn.uni-2id.com/welcom_page.png'
        },
        resetActiveCover(){
            this.acviveForm.cover='http://cdn.uni-2id.com/active_page.png'
        },
        submitImg(){
            if(this.activeName=='welcome'){
                this.welForm.cover=this.imgList[0].url
            }
            if(this.activeName=='activity'){
                this.acviveForm.cover=this.imgList[0].url
            }
            if(this.activeName=='propaganda'){
                if(this.xuanchuan_page[this.active_index].imgList.length>=5) return this.$message.warning('最多上传5张轮播图')
                this.xuanchuan_page[this.active_index].imgList.push({
                    url:this.imgList[0].url,
                    link:''
                })
            }

            this.imgDialog=false
        },
        selectCover(){
            this.imgDialog=true
            this.hackReset = false
            this.$nextTick(() => {
                this.hackReset = true
            })
        },
        save(){
            this.$refs["form"].validate(valid => {
                if(valid){
                    const params={
                        welcom_page:[this.welForm],
                        activity_page:[this.acviveForm],
                        xuanchuan_page:this.xuanchuan_page,
                        tpl_name:this.form.tpl_name,
                        remark:this.form.remark,
                        id:this.form.id,
                        type:1
                    }
                    saveScanTpl(params).then(res=>{
                        if(res.code==200){
                            this.$message.success(res.msg)
                            setTimeout(()=>{
                                this.close();
                            },500)
                        }else{
                            this.$message.error(res.msg)
                        }
                    })
                }
            })
        },
        goBack(){
            this.close();
        },
        /** 关闭按钮 */
        close() {
            this.$store.dispatch("tagsView/delView", this.$route);
            this.$router.go(-1)
        },
         onStart() {
            this.drag = true;
            this.$forceUpdate()
        },
        onEnd() {
            this.drag = false;
            this.$forceUpdate()
            console.log(this.page)
        },
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
        height: 200px;
        display: block;
    }
    }
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
.content-box{
    width:100%;
    height: calc(100vh + 100px);
    padding-bottom: 100px;
    ::v-deep .el-collapse-item__content{
        display: flex;
        justify-content: flex-start;
        flex-wrap: wrap;
    }
    .col{
        height: 100%;
        // border: 1px solid red;
        overflow: auto;
        padding-bottom: 50px;
        background: white;
        .comp-item{
            width: 33%;
            height: 80px;
            background: #fafafa;
            display: flex;
            justify-content: center;
            align-items: center;
            flex-direction: column;
            flex-wrap: wrap;
            margin-bottom: 10px;
        }
        .comp-item:hover{
            border: 1px dashed #409EFF;
            cursor: pointer;
        }
    }
}
.mobile-box{
    width: 350px;
    border: 1px solid #e5e5e5;
    box-sizing: border-box;
    background: #fff;
    border-radius: 18px 18px 0 0;
    margin: 0 auto;
    // margin-top: 100px;
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
            background: url("../../../../assets/titlebar.png") no-repeat;
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
             .img-bg{
                width: 100%;
                height: 100%;
                position: relative;
                .skip-box{
                    width: 85px;
                    height: 35px;
                    background: gray;
                    opacity: .8;
                    border-radius: 25px;
                    font-size: 14px;
                    font-weight: 600;
                    position: absolute;
                    display: flex;
                    color: white;
                    justify-content: center;
                    align-items: center;
                    right: 20px;
                    top: 30px;
                }
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
                .rank-box{
                    width: 100%;
                    height: 200px;
                    display: flex;
                    justify-content:center;
                    align-items: center;
                    flex-direction: column;
                    background: white;
                    font-size: 12px;
                    .rank-content-box{
                        width: 95%;
                        height: 170px;
                        display: flex;
                        justify-content: space-between;
                        align-items: center;
                        flex-direction: column;
                        .rank-content-head{
                            width: 100%;
                            height: 30px;
                            display: flex;
                            justify-content: center;
                            align-items: center;
                        }
                        .rank-content-body{
                            width: 100%;
                            height: 140px;
                            display: flex;
                            // justify-content: center;
                            align-items: center;
                            flex-direction:column;
                            .rank-content-body-item{
                                width: 100%;
                                height: 40px;
                                display: flex;
                                justify-content: center;
                                align-items: center;
                            }
                        }
                    }
                    .rank-title{
                        width: 95%;
                        height: 30px;
                        display: flex;
                        justify-content: space-between;
                        align-items: center;
                        border: 1px solid gray;
                        border-radius: 5px;
                        font-size: 12px;
                        .rank-title-left,.rank-title-right{
                            width: 50%;
                            height: 100%;
                            display: flex;
                            justify-content: center;
                            align-items: center;
                        }
                    }
                }
                .menu-box{
                    width: 90%;
                    height: 50px;
                    display: flex;
                    justify-content: center;
                    align-items: center;
                    border-radius: 40px;
                    border: 1px solid #eeeeee;
                    background: white;
                    margin: 0 auto;
                    // margin-top: 20px;
                    .mp,.user-center{
                        width: 50%;
                        height: 100%;
                        display: flex;
                        justify-content: center;
                        align-items: center;
                        border-right: 1px solid #eeeeee;
                    }
                }
                .goods-box{
                    width:100% ;
                    height: 152px;
                    display: flex;
                    justify-content: center;
                    flex-direction: column;
                    align-items: center;
                    position: relative;
                }
                .goods-box{
                    width: 100%;
                    height: 200px;
                    display: flex;
                    justify-content: center;
                    flex-direction: column;
                    align-items: center;
                    position: relative;
                    .goods_title{
                        width: 100%;
                        height: 50px;
                        background: rgba(4,4,4,.10);
                        color: white;
                        font-size: 14px;
                        display: flex;
                        justify-content: flex-start;
                        align-items: center;
                        padding-left: 20px;
                        box-sizing: border-box;
                    }
                }
                .auth-box{
                    width: 100%;
                    height: 300px !important;
                    background: #409EFF;
                    display: flex;
                    justify-content: center;
                    flex-direction: column;
                    align-items: center;
                    position: relative;
                    .auth-res{
                        width: 95%;
                        height: 70px;
                        display: flex;
                        justify-content: flex-start;
                        align-items: center;
                        background: rgba(4,4,4,.15);
                        border-radius: 8px;
                        color: #fff;
                        padding: 10px 15px;
                        margin-top: 20px;
                        font-size: 14px;
                    }
                    .auth-tips{
                        width: 100%;
                        display: flex;
                        justify-content: center;
                        align-items: center;
                        font-size: 20px;
                        color: white;
                        margin-top: 20px;
                    }
                }
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
.save-btn{
    width: 100%;
    height: 60px;
    border: 1px solid gray;
    border-top-left-radius: 4px;
    border-top-right-radius: 4px;
    display: flex;
    justify-content: center;
    align-items: center;
    position: fixed;
    bottom: 0;
    background: white;
    left: 0;
    z-index: 999;
}
</style>
