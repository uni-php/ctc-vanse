<!--
 * @Author: wenhanhan 1196086345@qq.com
 * @Date: 2022-09-04 00:33:42
 * @LastEditors: 文寒 zhaowenhan@cmict.chinamobile.com
 * @LastEditTime: 2023-03-09 01:34:38
 * @Description: 导购
-->
<template>
  <div class="app-container">
    <el-tabs v-model="activeName" @tab-click="handleClick">
      <el-tab-pane label="导购列表" name="first"></el-tab-pane>
      <el-tab-pane label="申请审核" name="second"></el-tab-pane>
    </el-tabs>
    <div class="tab-bar">
       <el-form ref="queryForm" :model="queryForm" label-width="100px" :inline="true" size="small">
        <el-form-item label="关键词" prop="keywords">
            <el-input style="width:220px" v-model="queryForm.keywords" placeholder="姓名、手机号"></el-input>
        </el-form-item>
        <el-form-item label="所属" prop="type">
            <el-select style="width:220px" v-model="queryForm.type" placeholder="所属门店">
                <el-option
                    v-for="item in typeOption"
                    :key="item.value"
                    :label="item.label"
                    :value="item.value">
                </el-option>
            </el-select>
        </el-form-item>
        <el-form-item label="状态" prop="status" v-if="activeName=='first'">
            <el-select style="width:220px" v-model="queryForm.status" placeholder="请选择活动状态">
                <el-option
                    v-for="item in statusOption"
                    :key="item.value"
                    :label="item.label"
                    :value="item.value">
                </el-option>
            </el-select>
        </el-form-item>
        <el-form-item label="状态" prop="status" v-if="activeName=='second'">
            <el-select style="width:220px" v-model="queryForm.status" placeholder="请选择活动状态">
                <el-option
                    v-for="item in checkStatusOption"
                    :key="item.value"
                    :label="item.label"
                    :value="item.value">
                </el-option>
            </el-select>
        </el-form-item>
        <el-form-item label="导购身份分组" prop="group">
            <el-select style="width:220px" v-model="queryForm.group" placeholder="请选择导购分组">
                <el-option
                    v-for="item in groupOption"
                    :key="item.id"
                    :label="item.group_name"
                    :value="item.id">
                </el-option>
            </el-select>
        </el-form-item>
        <el-form-item >
            <el-button type="primary" icon="el-icon-search" @click="query">查询</el-button>
            <el-button icon="el-icon-refresh" @click="reset('queryForm')">重置</el-button>
        </el-form-item>
       </el-form>
    </div>
    <el-row>
        <el-col :span="24" style="margin:10px 0;">
          <el-button @click="addGuide" type="primary" size="small" >添加导购</el-button>
          <el-button @click="addRegister" type="primary" size="small" >邀请注册</el-button>
          <el-button @click="addRegister" type="primary" size="small" >登录地址</el-button>
        </el-col>
    </el-row>
     <el-table
        :data="tableData"
        :header-cell-style="{background:'#FAFAFA',color:'#606266',height:'50px'}"
        border
        stripe
        size="medium"
        class="trace-table"
        style="width: 100%">
        <el-table-column prop="name" align="center" label="姓名"></el-table-column>
        <el-table-column prop="phone" align="center" label="手机号"></el-table-column>
        <el-table-column prop="group_name" align="center" label="导购身份分组"></el-table-column>
        <el-table-column prop="address" align="center" label="所在地区">
          <template slot-scope="scope">
            {{scope.row.province}} {{scope.row.city}} {{scope.row.district}} {{scope.row.address}}
          </template>
        </el-table-column>
        <!-- <el-table-column prop="distributor_name" align="center" label="所属经销商"></el-table-column> -->
        <el-table-column prop="store_name" align="center" label="所属门店"></el-table-column>
        <el-table-column prop="status" align="center" label="状态" :formatter="status"></el-table-column>
        <el-table-column prop="create_time" align="center" label="添加时间"></el-table-column>
        <el-table-column label="操作" align="center" fixed="right" width="220px">
            <template slot-scope="scope">
               <el-button
                    size="mini"
                    v-if="activeName=='first'"
                    type="primary"
                    @click="handleEdit(scope.row)">编辑</el-button>
                <el-button
                  size="mini"
                  type="primary"
                  @click="handleView(scope.row)">详情</el-button>
              <el-button
                  size="mini"
                  v-if="activeName=='first'"
                  type="primary"
                  @click="handleDele(scope.row)">删除</el-button>
              <el-button
                  v-if="activeName=='second'"
                  size="mini"
                  type="primary"
                  @click="handleCheck(scope.row)">审核</el-button>
            </template>
        </el-table-column>
     </el-table>
     <pagination
        v-show="+total>10"
        :total="+total"
        :page.sync="queryForm.pageNum"
        :limit.sync="queryForm.pageSize"
        @pagination="getList"/>
    <el-dialog title="导购员信息" class="visiableDialog" :visible.sync="visiableDialog" width="50%" @close="visiableDialog=false">
      <el-form :model="guideInfo" ref="form" label-width="100px" class="form" size="medium">
        <el-row>
          <el-col :span="12">
            <el-form-item prop="name" label="姓名：" >
              {{guideInfo.name}}
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item prop="phone" label="手机号：" >
              {{guideInfo.phone}}
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="12">
            <el-form-item prop="wechat" label="微信号：" >
              {{guideInfo.wechat}}
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item prop="group_name" label="身份组：" >
              {{guideInfo.group_name}}
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="12">
            <el-form-item prop="store_name" label="所属门店：" >
              {{guideInfo.store_name}}
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item prop="address" label="所在地区：" >
              {{guideInfo.province}} {{guideInfo.city}} {{guideInfo.district}} {{guideInfo.address}}
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="12">
            <el-form-item prop="create_time" label="申请时间：" >
              {{guideInfo.create_time}}
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item prop="remark" label="备注：" >
              {{guideInfo.remark}}
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="24">
            <el-form-item prop="address" label="上传图片：" >
              <div class="block" v-if="guideInfo.cover&&guideInfo.cover.length>0">
                <el-image
                  v-for="(item,index) in guideInfo.cover"
                  style="width: 100px; height: 100px;margin-right:6px"
                  :src="item.url"
                  :key="index"
                  fit="fill"></el-image>
              </div>
              <div v-else>暂无</div>
            </el-form-item>
          </el-col>
        </el-row>
      </el-form>
    </el-dialog>
    <CopyDialog :copyDialogVisible="copyDialogVisible" :title="copyTitle" :url="url" @close="closeCopyDialog"/>
    <el-dialog title="导购审核" class="checkDialog" :visible.sync="checkDialog" width="30%" @close="checkDialog=false">
      <el-form ref="checkForm" :model="checkForm" label-width="80px" size="small" :rules="checkRule">
        <el-form-item label="审核" prop="status">
          <el-radio-group v-model="checkForm.status">
            <el-radio :label="1">审核通过</el-radio>
            <el-radio :label="-2">审核不通过</el-radio>
          </el-radio-group>
        </el-form-item>
        <el-form-item>
          <el-button type="primary" @click="onSubmit">提交</el-button>
          <el-button @click="checkDialog=false" >取消</el-button>
        </el-form-item>
      </el-form>
    </el-dialog>
  </div>
</template>

<script>
import {getGuideGroupList} from '@/api/app/guide/group'
import {getGuideList,delGuide,getGuideInfo,checkGuide} from '@/api/app/guide/index'
import CopyDialog from '@/components/CopyDialog'
import { mapGetters } from 'vuex'
export default {
  components: {
      CopyDialog
  },
  data(){
    return{
      checkForm:{
        status:''
      },
      copyDialogVisible:false,
      checkDialog:false,
      copyTitle:'复制链接',
      url:'',
      visiableDialog:false,
      activeName:'first',
      queryForm:{
        keywords:'',
        status:'',
        group:'',
        pageNum:1,
        pageSize:10,
      },
      checkItem:{},
      guideInfo:{},
      queryGroupForm:{
        pageNum:1,
        pageSize:999,
      },
      checkRule:{
        status:[
            { required: true, message: "请选择审核状态", trigger: "blur" },
        ],
      },
      tableData:[],
      total:0,
      groupOption:[],
      typeOption:[
         {
              label:'总部',
              value:0
          },
          {
              label:'直营门店',
              value:1
          },
          {
              label:'非直营门店',
              value:2
          }
      ],
      statusOption:[
          {
              label:'正常',
              value:1
          },
          {
              label:'已禁用',
              value:2
          },
          {
              label:'未激活',
              value:0
          }
      ],
      checkStatusOption:[
          {
              label:'未审核',
              value:-1
          },
          {
              label:'审核未通过',
              value:-2
          },
      ]
    }
  },
  computed:{
      ...mapGetters([
          'dealer_id'
      ]),
  },
  created(){
    this.getGroupList()
    this.getList()
  },
  methods:{
    getList(){
      this.queryForm.activeName = this.activeName
      getGuideList(this.queryForm).then(res=>{
        this.tableData = res.data
        this.total = res.total
      })
    },
    onSubmit(){
      this.$refs["checkForm"].validate(valid => {
        if(valid){
          const params ={
            openid:this.checkItem.openid,
            status:this.checkForm.status
          }
          checkGuide(params).then(res=>{
            if(res.code==200){
                  this.$message.success(res.msg)
                  this.getList()
                  this.checkDialog=false
                  this.checkItem={}
              }else{
                  this.$message.error(res.msg)
              }
          })
        }
      })
    },
    addRegister(){
      this.copyDialogVisible=true,
      this.url='http://register.gawxg.com/guide?dealer_id='+this.dealer_id
    },
    closeCopyDialog(val){
        this.copyDialogVisible=val
    },
    addGuide(){
      this.$router.push({path:'/guide/manage/addGuide'})
    },
    handleEdit(row){
      this.$router.push({path:'/guide/manage/addGuide',query:{
        id:row.id
      }})
    },
    handleView(row){
      getGuideInfo({id:row.id}).then(res=>{
        this.guideInfo=res.data
        this.visiableDialog=true
      })
    },
    handleCheck(row){
      this.checkItem=row
      this.checkDialog=true
    },
    handleDele(row){
      this.$confirm('确认删除该导购员?', '提示', {
          confirmButtonText: '确定',
          cancelButtonText: '取消',
          type: 'warning'
          }).then(() => {
            delGuide({id:row.id}).then(res=>{
              if(res.code==200){
                  this.$message.success(res.msg)
                  this.getList()
              }else{
                  this.$message.error(res.msg)
              }
            })
      }).catch(() => {});
    },
    getGroupList(){
       getGuideGroupList(this.queryGroupForm).then(res=>{
        this.groupOption = res.data
      })
    },
    status(row){
      if(this.activeName=='first'){
        return this.statusOption.filter(item=>item.value==row.status).map(item=>item.label)[0]
      }else{
        return this.checkStatusOption.filter(item=>item.value==row.status).map(item=>item.label)[0]
      }
    },
    handleClick(){
      this.tableData=[]
      this.query()
    },
    query(){
      this.queryForm.pageNum = 1;
      this.getList();
    },
    reset(formName){
        this.$refs[formName].resetFields();
        this.query()
    }
  }
}
</script>

<style>

</style>
