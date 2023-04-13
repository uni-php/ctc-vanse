<template>
  <div class="app-container">
      <el-row class="content-box">
          <el-col class="col" :span="5">
              <el-collapse v-model="activeNames" @change="handleChange">
                    <el-collapse-item title="商城组件" name="1">
                        <div class="comp-item" v-for="(item,index) in comp" :key="index" @click="add(item)">
                            <div><i style="font-size:20px" :class="item.icon"></i></div>
                            <div>{{item.text}}</div>
                        </div>
                    </el-collapse-item>
              </el-collapse>
          </el-col>
          <el-col class="col" :span="12">
              <!-- 手机盒子 -->
              <div class="mobile-box">
                    <div class="app-header"></div>
                    <div class="app-body">
                        <div class="app-bar-box" @click="active_index=-2,type=undefined" :class="{'actives':active_index==-2}">
                            <div class="title">{{title.page_title}}</div>
                        </div>
                        <div class="app-content-box">
                            <div class="app-content">
                                <vuedraggable class="wrapper" v-model="page" @start="onStart" @end="onEnd">
                                    <transition-group>
                                    <div v-for="(item,index) in page" :key="index" :class="[item.type,active_index==index?'actives':'']" @click="clickItem(item,index)"  :style="{'height':item.height+'px'}">
                                        <!-- 用户信息 -->
                                        <div v-if="item.type=='user'" class="user-box">
                                            <div class="head">
                                                <img :src="item.face"/>
                                            </div>
                                            <div class="nickname">会员昵称</div>
                                            <div class="points">
                                                积分余额XXXXX
                                            </div>
                                        </div>
                                        <!-- 空白条 -->
                                        <div v-if="item.type=='line'"></div>
                                        <!-- 搜索框 -->
                                        <div class="search-bk" v-if="item.type=='search'">
                                            <i class="el-icon-search"></i><span>{{item.text}}</span>
                                        </div>
                                        <!-- 空白条 -->
                                        <div v-if="item.type=='line'"></div>
                                        <!-- 轮播图 -->
                                        <div :class="{'scroll-img':true}"  v-if="item.type=='banner'">
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
                                        <!-- 空白条 -->
                                        <div v-if="item.type=='line'"></div>
                                        <!-- 导航 -->
                                        <div v-if="item.type=='nav'" class="nav">
                                            <div class="nav-item" v-for="(it,idx) in item.content" v-if="it.is_show" :key="idx">
                                                <img :src="it.url"/>
                                                <div>{{it.text}}</div>
                                            </div>
                                        </div>
                                        <!-- 产品推荐 -->
                                        <div v-if="item.type=='recom'" class="recom">
                                            <div class="recom-title">
                                                <span style="font-size:15px;color:#333;">{{item.text}}</span>
                                                <span style="font-size:14px;color:#999;"><i class="el-icon-arrow-right"></i>更多</span>
                                            </div>
                                            <div class="product-box">
                                                <div class="product-item">
                                                    <div class="product-img">
                                                        <img :src="item.url"/>
                                                    </div>
                                                    <div class="product_info">
                                                        <div class="product-title">{{item.product_title}}</div>
                                                        <div class="product-sale">{{item.num}}</div>
                                                        <div class="product-price"><i style="color:orange" class="el-icon-coin"></i>{{item.points}}</div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        <!-- 空白条 -->
                                        <div v-if="item.type=='line'" :style="{'height':item.height+'px'}"></div>
                                        <div v-if="item.type=='notice'">
                                            <i style="font-size:18px;color:red" class="el-icon-mic"></i><span>{{item.text}}</span>
                                        </div>
                                        <div v-if="item.type=='custom'">
                                            <p v-html="item.text"></p>
                                        </div>
                                        <div v-if="item.type=='nav_title'">
                                            <span class="line">{{item.text}}</span>
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
              </div>
          </el-col>
          <el-col class="col" :span="7">
              <div v-if="active_index==-2" style="margin-top:50px">
                   <el-form :model="title" ref="form" label-width="140px" class="form" :rules="titleRule" size="medium">
                        <el-form-item prop="page_title" label="页面名称：" >
                            <el-input style="width:90%" v-model="title.page_title" placeholder="请输入页面名称"></el-input>
                        </el-form-item>
                         <el-form-item prop="share_title" label="分享标题：" >
                            <el-input style="width:90%" v-model="title.share_title" placeholder="请输入分享标题"></el-input>
                        </el-form-item>
                        <el-form-item prop="share_text" label="分享文案：" >
                            <el-input style="width:90%" v-model="title.share_text" placeholder="请输入分享文案"></el-input>
                        </el-form-item>
                        <el-form-item label="分享图标：" prop="share_img">
                            <div @click="selectCover">
                            <img v-if="title.share_img" :src="title.share_img" class="avatar" style="display:block">
                            <i v-else class="el-icon-plus avatar-uploader-icon"></i>
                            </div>
                        </el-form-item>
                   </el-form>
              </div>
            <div v-if="type=='line'" style="margin:0 auto;margin-top:100px;width:90%">
                <p>空白高度</p>
                <el-slider :max="30" :min="10" v-model="page[active_index].height"></el-slider>
            </div>
            <div v-if="type=='search'" style="margin:0 auto;margin-top:100px;width:90%">
                <el-form :model="page[active_index]" ref="form" label-width="140px" class="form" :rules="searchRule" size="medium">
                    <el-form-item prop="text" label="搜索指引词：" >
                        <el-input style="width:90%" v-model="page[active_index].text" placeholder="请输入搜索指引词"></el-input>
                    </el-form-item>
                </el-form>
            </div>
            <!-- 用户信息 -->
            <div v-if="type=='user'" style="margin:0 auto;margin-top:100px;width:90%">
                <el-form :model="page[active_index]" ref="form" label-width="140px" label-position="top" class="form" size="medium">
                    <el-form-item prop="text" label="用户信息：" >
                        <span>在积分商城首页显示用户的基本信息：微信头像、微信昵称、剩余积分。</span>
                    </el-form-item>
                </el-form>
            </div>
            <div v-if="type=='nav_title'" style="margin:0 auto;margin-top:100px;width:90%">
                <el-form :model="page[active_index]" ref="form" label-width="140px" class="form" :rules="titleRule" size="medium">
                    <el-form-item prop="text" label="标题名称：" >
                        <el-input style="width:90%" v-model="page[active_index].text" placeholder="请输入标题名称"></el-input>
                    </el-form-item>
                </el-form>
            </div>
            <div v-if="type=='notice'" style="margin:0 auto;margin-top:100px;width:90%">
                <el-form :model="page[active_index]" ref="form" label-width="140px" class="form" :rules="noticeRule" size="medium">
                    <el-form-item prop="text" label="公告内容：" >
                        <el-input style="width:90%" v-model="page[active_index].text" placeholder="请输入公告内容"></el-input>
                    </el-form-item>
                </el-form>
            </div>
             <div v-if="type=='custom'" style="margin:0 auto;margin-top:100px;width:90%">
                <el-form :model="page[active_index]" ref="form" label-width="140px" class="form" label-position="top" :rules="customRule" size="medium">
                    <el-form-item prop="text" label="自定义内容：" >
                        <QiniuEditor v-model="page[active_index].text" style="width:90%" :min-height="300"/>
                    </el-form-item>
                </el-form>
            </div>
             <div v-if="type=='recom'" style="margin:0 auto;margin-top:100px;width:90%">
                <el-form :model="page[active_index]" ref="form" label-width="140px" class="form" :rules="recomRule" size="medium">
                    <el-form-item prop="text" label="栏目标题：" >
                        <el-input style="width:90%" v-model="page[active_index].text" placeholder="请输入栏目标题"></el-input>
                    </el-form-item>
                     <el-form-item prop="text" label="推荐规则：" >
                        <el-select style="width:90%" size="small" v-model="page[active_index].recom_rule" placeholder="请选择推荐规则">
                            <el-option
                                v-for="item in recomRuleOptions"
                                :key="item.value"
                                :label="item.label"
                                :value="item.value">
                            </el-option>
                        </el-select>
                     </el-form-item>
                </el-form>
            </div>
            <!-- 轮播图 -->
             <div v-if="type=='banner'" style="margin:0 auto;margin-top:100px;width:90%">
                <div class="form">
                    <el-form :model="page[active_index]" ref="form"  class="form" :rules="bannerRule" size="medium">
                    <el-form-item label="轮播图：" prop="activity_img">
                        <vuedraggable class="wrapper" v-model="page[active_index].imgList">
                            <transition-group>
                                <div v-for="(item,index) in page[active_index].imgList" :key="index" class="drag-box" @mouseover="selectStyle(item,index)" @mouseout="idx=undefined">
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
                            <img v-for="(item,index) in page[active_index].imgList" :key="index" :src="item.url" class="avatar">
                            <i @click="selectCover" class="el-icon-plus avatar-uploader-icon"></i>
                        </div>
                    </el-form-item>
                    </el-form>
                </div>
             </div>
          </el-col>
      </el-row>
      <!-- 图片素材 -->
      <el-dialog title="素材库" class="materialDialog" :visible.sync="materialOpen" width="50%" @close="materialOpen=false">
            <el-tabs v-model="queryForm.group_id" :tab-position="tabPosition" @tab-click="handleClick" style="height: 600px;overflow:auto">
                <el-tab-pane v-for="(item,index) in group" :key="index" :label="item.group_name" :name="String(item.id)">
                    <div class="img-list">
                        <ul>
                            <li v-for="(it,idx) in imgMaterialList" :key="idx" :class="{active:idx==active_idx}" @click="handleClickImg(it,idx)">
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
      <!-- 保存 -->
      <div class="save-btn">
           <el-button size="medium" type="primary" @click="save">保存</el-button>
      </div>
  </div>
</template>

<script>
import myMarquee from '@/components/Notice'
import  vuedraggable from "vuedraggable";
import {getGroupList,getImgMaterial} from '@/api/assets/material'
import {savePointsTpl,getTplInfo} from '@/api/app/points'
export default {
  components: { myMarquee,vuedraggable },
    data(){
        return{
            dialogVisible:false,
            dialogImageUrl:'',
            imgMaterialList:[],
            titleForm:{

            },
            prefix:"http://localhost/static/mainImgs/",
            materialOpen:false,
            cover:undefined,
            queryForm:{
                pageNum:1,
                pageSize:20,
                img_group:'01',//默认查询全部图片库
                img_name:'',
            },
            group:[],
            active_idx:undefined,
            idx:undefined,
            type:undefined,
            activeNames:'1',
            total:0,
            active_index:-1,//选中的区域序号 默认未选中
            title:{
                page_title:'积分商城',
                share_title:'积分商城',
                share_text:'我正在看积分商城，挺不错的，你也来看看吧。',
                share_img:'###'
            },
            a:'ss',
            tabPosition: 'left',
            recomRuleOptions:[
                {
                    label:'自动推荐新上架前10个商品',
                    value:1
                },
                {
                    label:'自动推荐销售量前10个商品',
                    value:2
                }
            ],
            page:[
                {
                    type:'user',
                    face:require('@/assets/points/default-face.png'),
                    height:20
                },
                {
                    type:'line',
                    height:20
                },
                {
                    type:'search',
                    text:'搜索礼品',
                    height:60
                },
                // {
                //     type:'line',
                //     height:20
                // },
                  {
                    type:'nav',
                    content:[
                        {
                            url:require('@/assets/points/nav-1-icon@2x.png'),
                            text:"礼品列表",
                            is_show:1
                        },
                        {
                            url:require('@/assets/points/nav-2-icon@2x.png'),
                            text:"个人中心",
                            is_show:1
                        },
                        {
                            url:require('@/assets/points/nav-3-icon@2x.png'),
                            text:"订单中心",
                            is_show:1
                        },
                        {
                            url:require('@/assets/points/nav-4-icon@2x.png'),
                            text:"兑换规则",
                            is_show:1
                        }
                    ]
                },
                {
                    type:'line',
                    height:20
                },
                {
                    type:'banner',
                    imgList:[
                        {
                            url:require('@/assets/wsc-default.png'),
                            link:''
                        }
                    ],
                    height:152
                },
                {
                    type:'line',
                    height:20
                },
                {
                    type:'recom',
                    text:'热门推荐',
                    url:"",
                    product_title:'iPhone13',
                    num:'已兑换10',
                    points:100,
                },
                {
                    type:'line',
                    height:20
                },
                // {
                //     type:'notice',
                //     text:'ssadsadsadsada',
                // },
                // {
                //     type:'nav_title',
                //     text:'新品上架',
                // }

            ],
            comp:[
                {
                    icon:'el-icon-present',
                    type:'search',
                    text:'礼品推荐',
                    is_show:true
                },
                {
                    icon:'el-icon-search',
                    text:'搜索',
                    type:'search',
                    is_show:true
                },
                {
                    icon:'el-icon-guide',
                    text:'导航',
                    type:'nav',
                    is_show:true
                },
                 {
                    icon:'el-icon-bell',
                    text:'公告',
                    type:'notice',
                    is_show:true
                },
                {
                    icon:'el-icon-picture-outline',
                    text:'图片轮播',
                    type:'banner',
                    is_show:true
                },
                {
                    icon:'el-icon-minus',
                    text:'空白条',
                    type:'line',
                    is_show:true
                },
                {
                    icon:'el-icon-user',
                    type:'user',
                    text:'用户信息',
                    is_show:true
                },
            ],
            titleRule:{
                page_title:[
                    { required: true, message: "页面名称不能为空", trigger: "blur" },
                    { min: 2, max: 10, message: '长度在 2 到 10 个字符', trigger: 'blur' }
                ],
                share_title:[
                    { required: true, message: "分享标题不能为空", trigger: "blur" },
                    { min: 2, max: 15, message: '长度在 2 到 15 个字符', trigger: 'blur' }
                ],
                share_text:[
                    { required: true, message: "分享文案不能为空", trigger: "blur" },
                    { min: 2, max: 15, message: '长度在 2 到 15 个字符', trigger: 'blur' }
                ],
            },
            searchRule:{
                text:[
                    { required: true, message: "搜索指引词不能为空", trigger: "blur" },
                    { min: 2, max: 10, message: '长度在 2 到 10 个字符', trigger: 'blur' }
                ]
            },
            titleRule:{
                text:[
                    { required: true, message: "标题名称不能为空", trigger: "blur" },
                    { min: 2, max: 6, message: '长度在 2 到 6 个字符', trigger: 'blur' }
                ]
            },
            noticeRule:{
                text:[
                    { required: true, message: "公告内容不能为空", trigger: "blur" },
                    { min: 2, max: 20, message: '长度在 2 到 20 个字符', trigger: 'blur' }
                ]
            },
            customRule:{
                text:[
                    { required: true, message: "自定义内容不能为空", trigger: "blur" },
                    // { min: 2, max: 20, message: '长度在 2 到 20 个字符', trigger: 'blur' }
                ]
            },
            recomRule:{
                text:[
                    { required: true, message: "栏目标题不能为空", trigger: "blur" },
                    { min: 2, max: 6, message: '长度在 2 到 6 个字符', trigger: 'blur' }
                ]
            },
            bannerRule:{

            },
            linkDialog:false,
            linkForm:{
                link:''
            },
            banner_img_index:undefined,
            queryGroupForm:{
                pageNum:1,
                pageSize:999,
                group_name:''
            },
            drag: false,
        }
    },
    computed:{
        active(){
            return function (value){
                return false
            }
        },
    },
    created(){
        this.getGroupList()
        this.getImgMaterial()
        this.getTplInfo()
    },
    methods:{
        getTplInfo(){
            getTplInfo({}).then(res=>{
                if(res.data){
                    this.title=res.data
                    this.page=res.data.page_content
                }
            })
        },
         //添加链接
        handleLink(item,index){
            this.linkDialog=true
            this.linkForm.link=item.link
            this.banner_img_index=index
        },
         submitLink(){
            this.$set(this.page[this.active_index].imgList[this.banner_img_index],'link',this.linkForm.link)
            this.linkDialog=false
        },
        selectStyle(item,index){
            this.idx=index
        },
         handleRemove(item,index){
            if(this.page[this.active_index].imgList.length==1) return this.$message.warning('至少保留一张轮播图')
            this.page[this.active_index].imgList.splice(index,1)
        },
        handlePictureCardPreview(file) {
            this.dialogImageUrl = file.url;
            this.dialogVisible = true;
        },
        clickItem(item,index){
            this.active_index=index
            this.type=item.type
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
        add(item){
            if(item.type=='search'){
                var status=this.page.filter(item=>item.type=='search')
                if(status.length==1) return this.$message.warning('该元素只能添加一个')
                this.page.push({
                    type:'search',
                    text:'搜索店铺内商品'
                })
            }
            if(item.type=='recom'){
                var status=this.page.filter(item=>item.type=='recom')
                if(status.length==3) return this.$message.warning('该元素只能添加三个')
                 this.page.push({
                    type:'recom',
                    title:'产品推荐',
                    url:"",
                    product_title:'测试',
                    product_sale:90,
                    product_price:100,
                    recom_rule:1
                })
            }
            if(item.type=='banner'){
                var status=this.page.filter(item=>item.type=='banner')
                if(status.length==3) return this.$message.warning('该元素只能添加三个')
                this.page.push({
                    type:'banner',
                    imgList:[
                        {
                            url:require('@/assets/wsc-default.png'),
                            link:''
                        }
                    ]
                })
            }
            if(item.type=='user'){
                var status=this.page.filter(item=>item.type=='user')
                if(status.length>=1) return this.$message.warning('该元素只能添加一个')
                this.page.push({
                    type:'user',
                    face:require('@/assets/points/default-face.png'),
                    height:20
                })
            }
            if(item.type=='line'){
                this.page.push({
                     type:'line',
                    height:'20'
                })
            }
            if(item.type=='notice'){
                var status=this.page.filter(item=>item.type=='notice')
                if(status.length==1) return this.$message.warning('该元素只能添加一个')
                this.page.push({
                   type:'notice',
                    text:'ssadsadsadsada',
                })
            }
            if(item.type=='nav_title'){
                 var status=this.page.filter(item=>item.type=='nav_title')
                if(status.length>=2) return this.$message.warning('该元素只能添加两个')
                this.page.push({
                    type:'nav_title',
                    text:'新品上架',
                })
            }
            if(item.type=='nav'){
                 var status=this.page.filter(item=>item.type=='nav')
                if(status.length==1) return this.$message.warning('该元素只能添加一个')
                this.page.push({
                  type:'nav',
                    content:[
                        {
                            url:require('@/assets/nav-1-icon@2x.png'),
                            text:"全部商品",
                            is_show:1
                        },
                        {
                            url:require('@/assets/sel_products_icon@2x.png'),
                            text:"商品分类",
                            is_show:1
                        },
                        {
                            url:require('@/assets/cart_icon(1).png'),
                            text:"购物车",
                            is_show:1
                        },
                        {
                            url:require('@/assets/nav-2-icon@2x.png'),
                            text:"个人中心",
                            is_show:1
                        }
                    ]
                })
            }
        },
        deleteItem(index){
            this.page.splice(index,1)
        },
        handleChange(){

        },
        titleBox(){
            this.active_index=0
        },
        getImgMaterial(){
           var params=Object.assign({},this.queryForm)
            if(params.img_group=='01') params.img_group=''
            getImgMaterial(params).then(res=>{
                this.imgMaterialList=res.data
                this.total=res.total
            })
        },
        selectCover(){
            this.imgMaterialList=[]
            this.cover=undefined
            this.active_idx=undefined
            this.queryForm.group_id='0'
            this.queryForm.pageNum=1
            this.getImgMaterial()
            this.materialOpen=true
        },
        handleClick(){
            this.queryForm.pageNum=1
            this.getImgMaterial()
        },
        handleClickImg(it,idx){
            this.cover=it
            this.active_idx=idx
        },
        submitCover(){
            if(!this.cover){
                this.$message.warning('请选择封面图片')
                return;
            }
            if(!this.type){
                this.title.share_img=this.cover.img_url
            }else{
                this.page[this.active_index].imgList.push({
                    url:this.cover.img_url,
                    link:''
                })
                // var arr=Object.assign([],this.page[this.active_index].imgList)
                // this.$set(this.page[this.active_index],'imgList',this.page[this.active_index].imgList.concat(arr))
            }
            this.materialOpen=false
        },
        save(){
            var params=this.title
            params.page_content=this.page
            savePointsTpl(params).then(res=>{
                if(res.code==200){
                    this.$message.success(res.msg)
                }else{
                    this.$message.error(res.msg)
                }
            })
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
    background: #eeeeee;
}
 .form{
        margin: 30px 0 0 20px;
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
    width: 100%;
    height: calc(100vh - 100px);
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
                .user,.user-box{
                    width: 100%;
                    height: 65px !important;
                    background: white;
                    display: flex;
                    justify-content: flex-start;
                    align-items: center;
                    position: relative;
                    .head{
                        width:45px;
                        height: 45px;
                        display: flex;
                        justify-content: center;
                        align-items: center;
                        margin-left: 15px;
                        img{
                            width: 100%;
                            height: 100%;
                            border-radius: 25px;
                        }
                    }
                    .nickname{
                        width: auto;
                        height: 100%;
                        display: flex;
                        justify-content: center;
                        align-items: center;
                        margin-left: 10px;
                        font-size:14px;
                    }
                    .points{
                        width: 140px;
                        height: 30px;
                        position: absolute;
                        right: 0;
                        top: 50%;
                        transform: translateY(-50%);
                        background-image: linear-gradient(to right,#ffc658,#fa8945);
                        color: #fff;
                        font-size: 14px;
                        border-top-left-radius: 15px 50%;
                        border-bottom-left-radius: 15px 50%;
                        display: flex;
                        justify-content: flex-start;
                        align-items: center;
                        padding-left: 4px;
                    }
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
                                    align-items: center;
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
