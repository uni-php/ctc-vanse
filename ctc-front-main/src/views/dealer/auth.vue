<template>
  <div class="app-container">
    <div class="tab-bar">
      <el-form ref="queryForm" :model="queryForm" label-width="100px" :inline="true" size="small">
        <el-form-item label="模板名称" prop="template_name">
            <el-input style="width:240px" placeholder="请输入模板名称" v-model="queryForm.template_name"></el-input>
        </el-form-item>
        <el-form-item label="品牌商名称" prop="dealer_name">
            <el-input style="width:240px" placeholder="请输入品牌商名称" v-model="queryForm.dealer_name"></el-input>
        </el-form-item>
        <el-form-item > 
            <el-button type="primary" icon="el-icon-search" @click="query">查询</el-button>
            <el-button icon="el-icon-refresh" @click="resetQuery('queryForm')">重置</el-button>
        </el-form-item>
      </el-form>
    </div>
    <el-table
      :data="tableData"
      :header-cell-style="{background:'#FAFAFA',color:'#606266',height:'50px'}"
      border
      stripe
      size="medium"
      class="trace-table"
      style="width: 100%">
      <el-table-column prop="code" align="center" label="品牌商编号" width="100px"></el-table-column>
      <el-table-column prop="dealer_name" width="120px" align="center" label="品牌商名称" ></el-table-column>
      <el-table-column prop="account" width="120px" align="center" label="品牌商账号" ></el-table-column>
      <el-table-column prop="company" width="140px" align="center" label="公司名称" ></el-table-column>
      <el-table-column prop="partner_company" width="120px" align="center" label="所属合伙人" ></el-table-column>
      <el-table-column prop="template_name" width="120px" align="center" label="扫码模板名称" ></el-table-column>
      <el-table-column prop="query_tips" align="center" show-overflow-tooltip label="查询提示" ></el-table-column>
      <el-table-column prop="scene" width="120px" align="center" label="应用场景"></el-table-column>
      <el-table-column prop="create_time" width="160px" align="center" label="创建时间" ></el-table-column>
      <el-table-column label="操作" align="center" fixed="right" width="180px">
        <template slot-scope="scope">
          <el-button
            size="mini"
            type="primary"
            @click="handleEdit(scope.row)">修改</el-button>
          <el-button
            size="mini"
            type="primary"
            @click="handleView(scope.row)">查看</el-button>
        </template>
      </el-table-column>
    </el-table>
    <el-dialog title="防伪认证信息" :visible.sync="authDialog" width="40%" @close="authDialog=false">
        <el-form :model="authFrom" ref="authFrom" label-width="120px" :rules="rule" size="medium">
          <el-divider style="margin-bottom:30px" content-position="left">品牌商信息</el-divider>
          <el-row>
            <el-col :span="12">
              <el-form-item label="品牌商名称:" prop="dealer_name">
                <el-input readonly=""  v-model="authFrom.dealer_name"/>
              </el-form-item>
            </el-col>
            <el-col :span="12">
              <el-form-item label="品牌商账号:" prop="account">
                <el-input readonly=""  v-model="authFrom.account"/>
              </el-form-item>
            </el-col>
          </el-row>
          <el-row>
            <el-col :span="12">
              <el-form-item label="公司名称:" prop="company">
                <el-input readonly=""  v-model="authFrom.company"/>
              </el-form-item>
            </el-col>
            <el-col :span="12">
              <el-form-item label="状态:" prop="account">
                <span>{{authFrom.status==0?'未授权':authFrom.status==1?'正常':"已禁用"}}</span>
              </el-form-item>
            </el-col>
          </el-row>
          <el-divider style="margin-bottom:30px" content-position="left">查询提示信息</el-divider>
          <el-row>
            <el-col :span="12">
              <el-form-item label="扫码页模板名称:" prop="template_name">
                <el-input readonly=""  v-model="authFrom.template_name"/>
              </el-form-item>
            </el-col>
            <el-col :span="12">
              <el-form-item label="应用场景:" prop="scene">
                <span>{{scene(authFrom.scene)}}</span>
              </el-form-item>
            </el-col>
          </el-row>
          <el-row>
            <el-col :span="24">
              <el-form-item label="首次扫码提示:" prop="query_tips">
                <el-input
                  type="textarea"
                  :rows="2"
                  :readonly="view"
                  placeholder="首次扫码提示"
                  v-model="authFrom.query_tips">
                </el-input>
              </el-form-item>
            </el-col>
            <el-col :span="24">
              <el-form-item label="重复查询提示:" prop="query_tips_again">
                <el-input
                  type="textarea"
                  :rows="2"
                  :readonly="view"
                  placeholder="重复查询提示"
                  v-model="authFrom.query_tips_again">
                </el-input>
              </el-form-item>
            </el-col>
          </el-row>
        </el-form>
        <div slot="footer" v-if="!view" class="dialog-footer">
          <el-button type="primary" @click="submitForm">确 定</el-button>
          <el-button @click="cancel">取 消</el-button>
        </div>
    </el-dialog>
  </div>
</template>

<script>
import {listAuth,getAuthInfo,updateAuthInfo} from "@/api/dealer/index";
export default {
  data(){
    return{
      queryForm:{
        template_name:'',
        dealer_name:'',
        pageNum:1,
        pageSize:10
      },
      authDialog:false,
      authFrom:{

      },
      rule:{
        query_tips:[
          { required: true, message: "扫码提示不能为空", trigger: "blur" }
        ],
        query_tips_again:[
          { required: true, message: "重复查询提示不能为空", trigger: "blur" }
        ]
      },
      view:false,
      sceneOptions:[],
      tableData:[],
      total:0
    }
  },
  created(){
    this.getList()
    this.getDicts({type:'code_scene'}).then(res=>{
      this.sceneOptions=res.data
    })
  },
  computed:{
     scene(){
        return function(value){
          if(!value) return '--'
          var item=this.sceneOptions.filter(item=>{
            return item.dict_value==value
          })
          return item[0].dict_label
        }
      },
  },
  methods:{
    getList(){
      listAuth(this.queryForm).then(res=>{
        this.total=res.total
        this.tableData=res.data
      })
    },
    handleView(row){
      this.view=true
      getAuthInfo({id:row.auth_id}).then(res=>{
        this.authFrom=res.data
        this.authDialog=true
      })
    },
    handleEdit(row){
      this.view=false
      getAuthInfo({id:row.auth_id}).then(res=>{
        this.authFrom=res.data
        this.authDialog=true
      })
    },
    submitForm(){
      this.$refs["authFrom"].validate(valid => {
        if(valid){
          var arr={
            id:this.authFrom.template_id,
            query_tips:this.authFrom.query_tips,
            query_tips_again:this.authFrom.query_tips_again
          }
          updateAuthInfo(arr).then(res=>{
              if(res.code==200){
                this.$message.success(res.msg)
                this.authDialog = false;
                this.getList();
              }else{
                this.$message.error(res.msg)
              }
          })
        }
      })
    },
    cancel(){
      this.authDialog = false;
      this.reset();
    },
    reset(){
      this.resetForm("authFrom");
    },
    query(){
      this.queryForm.pageNum = 1;
      this.getList();
    },
    resetQuery(formName){
      this.$refs[formName].resetFields();
      this.query()
    },
  }
}
</script>

<style>

</style>