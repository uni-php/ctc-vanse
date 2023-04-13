<!--
 * @Author: wenhanhan 1196086345@qq.com
 * @Date: 2022-09-25 00:15:55
 * @LastEditors: error: git config user.name && git config user.email & please set dead value or install git
 * @LastEditTime: 2022-11-14 14:44:39
 * @Description: 添加导购
-->
<template>
  <div class="app-container">
    <el-form :model="form" ref="form" class="form" label-width="120px" :rules="rule" size="medium">
      <el-form-item prop="name" label="姓名：" >
          <el-input style="width:80%" v-model="form.name" placeholder="请输入"></el-input>
      </el-form-item>
      <el-form-item prop="phone" label="手机号(账号)：" >
          <el-input style="width:80%" v-model="form.phone" placeholder="请输入"></el-input>
      </el-form-item>
      <el-form-item prop="password" label="登录密码：" v-if="!form.id" >
          <el-input style="width:80%" v-model="form.password" placeholder="请输入"></el-input>
      </el-form-item>
      <el-form-item prop="group_id" label="所属分组：" >
        <el-select style="width:80%" v-model="form.group_id" placeholder="所属分组">
          <el-option
              v-for="item in groupOption"
              :key="item.id"
              :label="item.group_name"
              :value="item.id">
          </el-option>
            </el-select>
      </el-form-item>
      <el-form-item prop="store_name" label="所属门店：" >
        <el-input readonly="" style="width:80%" @focus="storeVisible=true" v-model="form.store_name" placeholder="请选择"></el-input>
      </el-form-item>
      <el-form-item prop="address" label="所在地址" >
          <el-cascader
              size="medium"
              style="width:80%"
              :options="options"
              placeholder="请选择地址"
              v-model="selectedOptions"
              @change="handleChange">
          </el-cascader>
      </el-form-item>
      <el-form-item label="详细地址" prop="address">
          <el-input style="width:80%" v-model="form.address" placeholder="请输入详细地址"/>
      </el-form-item>
      <el-form-item prop="wechat" label="微信号：" >
          <el-input style="width:80%" v-model="form.wechat" placeholder="请输入"></el-input>
      </el-form-item>
      <el-form-item label="上传图片：" prop="cover">
          <vuedraggable class="wrapper" v-model="form.cover">
              <transition-group>
                  <div v-for="(item,index) in form.cover" :key="index" class="drag-box" @mouseover="selectStyle(item,index)" @mouseout="idx=undefined">
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
      <el-form-item prop="remark" label="备注：" >
          <el-input maxlength="150"
  show-word-limit type="textarea" :autosize="{ minRows: 3, maxRows: 5}" style="width:80%" v-model="form.remark" placeholder="请输入"></el-input>
      </el-form-item>
      <el-form-item>
          <el-button type="primary" size="medium" @click="onSubmit">保存</el-button>
          <el-button size="medium" @click="goBack">返回</el-button>
      </el-form-item>
    </el-form>
     <!-- 添加门店 -->
     <el-dialog title="添加门店" :visible.sync="storeVisible" width="75%" @close="storeVisible=false">
        <div class="tab-bar">
            <el-form ref="queryStoreForm" :model="queryStoreForm" label-width="100px" :inline="true" size="small">
                <el-form-item label="门店编号" prop="store_code">
                    <el-input style="width:180px" v-model="queryStoreForm.store_code" placeholder="请输入门店编号"></el-input>
                </el-form-item>
                <el-form-item label="门店名称" prop="store_name">
                    <el-input style="width:180px" v-model="queryStoreForm.store_name" placeholder="请输入门店名称"></el-input>
                </el-form-item>
                <el-form-item label="门店类型" prop="type">
                    <el-select style="width:180px" size="small" v-model="queryStoreForm.type" placeholder="请选择类型">
                        <el-option
                            v-for="item in storeTypeOptions"
                            :key="item.id"
                            :label="item.class_name"
                            :value="item.id">
                        </el-option>
                    </el-select>
                </el-form-item>
                <el-form-item label="关键词" prop="keywords">
                    <el-input style="width:180px" v-model="queryStoreForm.keywords" placeholder="手机号、负责人"></el-input>
                </el-form-item>
                <el-form-item >
                    <el-button type="primary" icon="el-icon-search" @click="queryStore">查询</el-button>
                    <el-button type="primary" @click="resetStore('queryStoreForm')">重置</el-button>
                </el-form-item>
            </el-form>
        </div>
        <el-col :span="24" style="margin:0 0 10px 0;">
            <!-- <el-button :disabled="selected_store.length==0" @click="handleSelectAllStore" type="primary" size="small" >添加</el-button> -->
            <div style="margin-top:10px">提示：门店资料请【客户】-【门店管理】中添加、管理。。</div>
        </el-col>
        <el-table
            :data="selectStoreTableData"
            :header-cell-style="{background:'#FAFAFA',color:'#606266',height:'50px'}"
            border
            stripe
            size="medium"
            class="trace-table"
            style="width: 100%">
            <el-table-column prop="store_code" align="center" label="门店编号"></el-table-column>
            <el-table-column prop="store_name" align="center" label="门店名称"></el-table-column>
            <el-table-column prop="address" align="center" label="地址"></el-table-column>
            <el-table-column prop="mobile_phone" align="center" label="手机号"></el-table-column>
            <el-table-column prop="person" align="center" label="负责人"></el-table-column>
            <el-table-column prop="type" align="center" label="门店类型" :formatter="store_type"></el-table-column>
            <el-table-column label="操作" align="center" fixed="right" width="120px">
                <template slot-scope="scope">
                    <el-button
                        size="mini"
                        type="primary"
                        @click="handleSelectStore(scope.row)">选择</el-button>
                </template>
            </el-table-column>
        </el-table>
    </el-dialog>
    <el-dialog title="素材库" :visible.sync="imgDialog" width="80%" @close="imgDialog=false">
        <ImgPanel @selectImg="selectImg" :count=1 v-if="hackReset" />
        <div slot="footer" class="dialog-footer">
            <el-button type="primary" @click="submitImg">确 定</el-button>
            <el-button @click="imgDialog=false">取 消</el-button>
        </div>
    </el-dialog>
    <el-dialog :visible.sync="dialogVisible">
        <img width="100%" :src="dialogImageUrl" alt="">
      </el-dialog>
  </div>
</template>

<script>
import {getGuideGroupList} from '@/api/app/guide/group'
import {saveGuide,getGuideInfo} from '@/api/app/guide/index'
import  vuedraggable from "vuedraggable";
import { regionDataPlus,CodeToText, TextToCode } from 'element-china-area-data'
import ImgPanel from '@/components/ImgPanel'
import {getStoreTypeList,getAvailableStore,getStoreById} from '@/api/customer/store'
export default {
  components:{
      ImgPanel,
      vuedraggable
  },
  data(){
    return{
      dialogVisible:false,
      dialogImageUrl:'',
      imgDialog:false,
      queryGroupForm:{
        pageNum:1,
        pageSize:999,
      },
      options: regionDataPlus,
      storeTypeOptions:[],
      queryStoreForm:{
          store_code:'',
          store_name:'',
          type:'',
          keywords:'',
          pageNum:1,
          pageSize:10
      },
      guide_id:'',
      selectedOptions:["","",""],
      queryStoreTypeForm:{
          pageNum:1,
          pageSize:999
      },
      idx:undefined,
      hackReset:false,
      storeVisible:false,
      groupOption:[],
      selectStoreTableData:[],
      form:{
        name:'',
        phone:'',
        password:'123456',
        group_id:'',
        store_id:'',
        store_name:'',
        address:'',
        wechat:'',
        cover:[]
      },
      imgList:[],
      rule:{
        name:[
            { required: true, message: "导购姓名不能为空", trigger: "blur" },
        ],
        phone:[
          { required: true, message: "手机号不能为空", trigger: "blur" },
        ],
        password:[
          { required: true, message: "密码不能为空", trigger: "blur" },
        ],
        group_id:[
          { required: true, message: "请选择所属分组", trigger: "blur" },
        ],
        store_name:[
          { required: true, message: "请选择所属门店", trigger: "blur" },
        ]
      }
    }
  },
  created(){
    this.getGroupList()
    this.getStoreList()
    getStoreTypeList(this.queryStoreTypeForm).then(res=>{
        this.storeTypeOptions=res.data
    })
    if(this.$route.query.id){
      this.guide_id = this.$route.query.id
      this.getGuideInfo()
    }
  },
  methods:{
    getGroupList(){
       getGuideGroupList(this.queryGroupForm).then(res=>{
        this.groupOption = res.data
      })
    },
    getGuideInfo(){
      getGuideInfo({id:this.guide_id}).then(res=>{
        var arr=Object.assign({},res.data)
        var address=[]
        this.form=res.data
        address[0]=TextToCode[arr.province].code
        address[1]=TextToCode[arr.province][arr.city].code
        address[2]=TextToCode[arr.province][arr.city][arr.district].code
        this.selectedOptions=address
      })
    },
    selectCover(){
        this.imgDialog=true
        this.imgList=[]
        this.hackReset = false
        this.$nextTick(() => {
        this.hackReset = true
        })
    },
    selectStyle(item,index){
      this.idx=index
    },
    selectImg(list){
        this.imgList=list
    },
    handleRemove(item,index){
        this.form.cover.splice(index,1)
    },
    handleChange(){},
    getStoreList(){
        getAvailableStore(this.queryStoreForm).then(res=>{
            this.selectStoreTableData=res.data
        })
    },
    handlePictureCardPreview(file) {
        this.dialogImageUrl = file.url;
        this.dialogVisible = true;
    },
    //门店类型翻译
    store_type(row){
          return this.storeTypeOptions.filter(item=>item.id==row.type).map(item=>item.class_name)[0]
      },
    queryStore(){
        this.queryStoreForm.pageNum = 1;
        this.getStoreList();
    },
    handleSelectStore(row){
      this.form.store_name=row.store_name
      this.form.store_id=row.id
      this.storeVisible=false
    },
    onSubmit(){
      this.$refs["form"].validate(valid => {
        if(valid){
          var arr=Object.assign({},this.form)
          arr.province=CodeToText[this.selectedOptions[0]]
          arr.city=CodeToText[this.selectedOptions[1]]
          arr.district=CodeToText[this.selectedOptions[2]]
          if(arr.id) delete arr.password
          saveGuide(arr).then(res=>{
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
    goBack(){
        this.close()
    },
    /** 关闭按钮 */
    close() {
          this.$store.dispatch("tagsView/delView", this.$route);
          this.$router.go(-1)
      },
    submitImg(){
        this.form.cover=this.form.cover.concat(this.imgList)
        this.imgDialog=false
    },
    resetStore(formName){
        this.$nextTick(()=>{
            this.$refs[formName].resetFields();
        })
        this.queryStore()
    },
  }
}
</script>

<style lang="scss" scoped>
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
  </style>
