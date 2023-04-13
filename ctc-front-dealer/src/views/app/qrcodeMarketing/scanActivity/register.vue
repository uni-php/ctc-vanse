<template>
  <div class="app-container">
      <div class="tab-bar">
           <el-form ref="queryForm" :model="queryForm" label-width="100px" :inline="true" size="small">
                <el-form-item label="姓名" prop="name">
                    <el-input style="width:220px" v-model="queryForm.name" placeholder="定向人员姓名"></el-input>
                </el-form-item>
                <el-form-item label="电话" prop="phone">
                    <el-input style="width:220px" v-model="queryForm.phone" placeholder="定向人员电话"></el-input>
                </el-form-item>
                <el-form-item label="地址" prop="address">
                    <el-input style="width:220px" v-model="queryForm.address" placeholder="定向人员地址"></el-input>
                </el-form-item>
                <el-form-item label="运营中心" prop="operation_center">
                <el-select style="width:220px" v-model="queryForm.operation_center" placeholder="请选择运营中心">
                    <el-option
                        v-for="item in operationCenterOption"
                        :key="item.dict_value"
                        :label="item.dict_label"
                        :value="item.dict_value">
                    </el-option>
                </el-select>
            </el-form-item>
                <el-form-item>
                    <el-button type="primary" icon="el-icon-search" @click="query">查询</el-button>
                    <el-button icon="el-icon-refresh" @click="resetQuery('queryForm')">重置</el-button>
                </el-form-item>
           </el-form>
      </div>
    <el-col :span="24" style="margin:10px 0;">
        <el-button  type="primary" size="small" @click="handleRegisterUrl" >定向人员注册地址</el-button>
        <!-- <el-button  type="primary" size="small" @click="handleImport" >导入</el-button> -->
    </el-col>
      <el-table
        :data="tableData"
        :header-cell-style="{background:'#FAFAFA',color:'#606266',height:'50px'}"
        border
        stripe
        size="medium"
        class="trace-table"
        style="width: 100%">
        <el-table-column prop="name" align="center" label="姓名"></el-table-column>
        <el-table-column prop="phone" align="center" label="电话"></el-table-column>
        <el-table-column prop="operation_center" align="center" label="运营中心" :formatter="operation_center"></el-table-column>
        <el-table-column prop="work_type" align="center" label="工种" :formatter="work_type"></el-table-column>
        <el-table-column prop="address" align="center" label="地址"></el-table-column>
        <el-table-column prop="location" align="center" label="街道"></el-table-column>
        <el-table-column prop="remark" align="center" label="备注"></el-table-column>
        <el-table-column label="操作" align="center" fixed="right" width="240px">
             <template slot-scope="scope">
                <el-button
                    size="mini"
                    type="text"
                    v-if="scope.row.status==0"
                    @click="handleStatus(scope.row,1)">通过</el-button>
                <el-button
                    size="mini"
                    type="text"
                    v-if="scope.row.status==1"
                    >已通过</el-button>
                <el-button
                    size="mini"
                    type="text"
                    v-if="scope.row.status==0"
                    @click="handleStatus(scope.row,2)">拒绝</el-button>
                <el-button
                    size="mini"
                    type="text"
                    v-if="scope.row.status==2"
                    >已拒绝</el-button>
                <el-button
                    size="mini"
                    type="text"
                    @click="handleDele(scope.row)">删除</el-button>
             </template>
        </el-table-column>
      </el-table>
      <pagination
        v-show="+total>10"
        :total="+total"
        :page.sync="queryForm.pageNum"
        :limit.sync="queryForm.pageSize"
        @pagination="getList"/>
     <el-dialog :title="upload.title" :visible.sync="upload.open" width="400px" append-to-body>
      <el-upload
        ref="upload"
        :limit="1"
        accept=".xlsx, .xls"
        name="excel"
        :headers="upload.headers"
        :action="upload.url + '?updateSupport=' + upload.updateSupport"
        :disabled="upload.isUploading"
        :on-progress="handleFileUploadProgress"
        :on-success="handleFileSuccess"
        :auto-upload="false"
        drag
      >
        <i class="el-icon-upload"></i>
        <div class="el-upload__text">将文件拖到此处，或<em>点击上传</em></div>
        <div class="el-upload__tip text-center" slot="tip">
          <!-- <div class="el-upload__tip" slot="tip">
            <el-checkbox v-model="upload.updateSupport" /> 是否更新已经存在的用户数据
          </div> -->
          <span>1、仅允许导入xls、xlsx格式文件</span>
        </div>
      </el-upload>
      <div slot="footer" class="dialog-footer">
        <el-button type="primary" @click="submitFileForm">确 定</el-button>
        <el-button @click="upload.open = false">取 消</el-button>
      </div>
    </el-dialog>
         <!-- 链接生成二维码网址 -->
    <CopyDialog :copyDialogVisible="copyDialogVisible" :title="copyTitle" :url="url" @close="closeCopyDialog"/>
  </div>
</template>

<script>
import {getRegisterList,deleRegisterInfo,changeRegisterStatus} from '@/api/app/qrcode'
import CopyDialog from '@/components/CopyDialog'
import { getToken } from "@/utils/auth";
import { mapGetters } from 'vuex'
export default {
    components:{
        CopyDialog
    },
    data(){
        return{
          operationCenterOption:[],
          workTypeOption:[],
            queryForm:{
              operation_center:'',
                name:'',
                phone:'',
                address:'',
                pageNum:1,
                pageSize:10
            },
            upload:{
                open: false,
                // 弹出层标题（用户导入）
                title: "",
                // 是否禁用上传
                isUploading: false,
                // 是否更新已经存在的用户数据
                updateSupport: 0,
                // 设置上传的请求头部
                headers: { Authorization: "Bearer " + getToken() },
                // 上传的地址
                url: process.env.VUE_APP_BASE_API + "/dealer/app/qrcode/importRegister"
            },
            copyDialogVisible:false,
            tableData:[],
            total:0,
            url:'',
            copyTitle:'复制链接',
        }
    },
    created(){
        this.getList()
        this.getDicts({type:'operation_center'}).then(res=>{
            this.operationCenterOption=res.data
        })
        this.getDicts({type:'work_type'}).then(res=>{
            this.workTypeOption=res.data
        })
    },
    computed:{
        ...mapGetters([
            'dealer_id'
        ]),
    },
    methods:{
        getList(){
            getRegisterList(this.queryForm).then(res=>{
                this.tableData=res.data
                this.total=res.total
            })
        },
        handleImport(){
            this.upload.title = "人员导入";
            this.upload.open = true;
        },
        handleRegisterUrl(){
            this.copyDialogVisible=true,
            this.url='http://register.gawxg.com?dealer_id='+this.dealer_id
        },
        closeCopyDialog(val){
            this.copyDialogVisible=val
        },
        operation_center(row){
          return this.operationCenterOption.filter(item=>item.dict_value==row.operation_center).map(item=>item.dict_label)[0]
        },
        work_type(row){
          return this.workTypeOption.filter(item=>item.dict_value==row.work_type).map(item=>item.dict_label)[0]
        },
        handleDele(row){
            this.$confirm('确认删除该注册人员?', '提示', {
                confirmButtonText: '确定',
                cancelButtonText: '取消',
                type: 'warning'
                }).then(() => {
                 deleRegisterInfo({id:row.id}).then(res=>{
                    if(res.code==200){
                        this.$message.success(res.msg)
                        this.getList()
                    }else{
                        this.$message.error(res.msg)
                    }
                 })
            }).catch(() => {});
        },
        handleFileUploadProgress(event, file, fileList) {
            this.upload.isUploading = true;
        },
        submitFileForm(){
            this.$refs.upload.submit();
        },
        handleFileSuccess(response, file, fileList) {
            this.upload.open = false;
            this.upload.isUploading = false;
            this.$refs.upload.clearFiles();
            this.$alert(response.msg, "导入结果", { dangerouslyUseHTMLString: true });
            this.getList();
        },
        handleStatus(row,status){
            changeRegisterStatus({id:row.id,status:status}).then(res=>{
                if(res.code==200){
                    this.$message.success(res.msg)
                    this.getList()
                }else{
                    this.$message.error(res.msg)
                }
            })
        },
        query(){
            this.queryForm.pageNum = 1;
            this.getList();
        },
        resetQuery(formName){
            this.$refs[formName].resetFields();
            this.query()
        }
    }
}
</script>

<style>

</style>
