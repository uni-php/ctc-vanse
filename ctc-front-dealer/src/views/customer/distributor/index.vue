<template>
  <div class="app-container">
    <div class="tab-bar">
        <el-form ref="queryForm" :model="queryForm" label-width="100px" :inline="true" size="small">
        <el-form-item label="添加时间" prop="time">
            <el-date-picker
                style="width:220px"
                v-model="queryForm.time"
                type="daterange"
                unlink-panels=""
                range-separator="至"
                value-format="yyyy-MM-dd"
                start-placeholder="开始日期"
                end-placeholder="结束日期">
            </el-date-picker>
        </el-form-item>
        <el-form-item label="经销商编号" prop="distributor_code">
            <el-input style="width:220px" v-model="queryForm.distributor_code" placeholder="请输入经销商编号"></el-input>
        </el-form-item>
        <el-form-item label="经销商名称" prop="distributor_name">
            <el-input style="width:220px" v-model="queryForm.distributor_name" placeholder="请输入经销商名称"></el-input>
        </el-form-item>
        <el-form-item label="经销商级别" prop="distributor_level">
            <el-select style="width:220px" size="small" v-model="queryForm.distributor_level" placeholder="请选择经销商级别">
                <el-option
                    v-for="item in levelOption"
                    :key="item.id"
                    :label="item.level_name"
                    :value="item.id">
                </el-option>
            </el-select>
        </el-form-item>
        <el-form-item label="上级经销商" prop="superior_dis_name">
            <el-input style="width:220px" v-model="queryForm.superior_dis_name" @focus="getSuperiorDis" placeholder="请选择上级经销商"></el-input>
        </el-form-item>
        <el-form-item label="所属区域" prop="zone">
            <el-cascader
                style="width:220px" 
                v-model="queryForm.zone"
                :options="zoneOptions"
                :props="zoneProps"
                ></el-cascader>
        </el-form-item>
        <el-form-item > 
            <el-button type="primary" icon="el-icon-search" @click="query">查询</el-button>
            <el-button icon="el-icon-refresh" @click="reset('queryForm')">重置</el-button>
        </el-form-item>
        </el-form>
    </div>
    <el-col :span="24" style="margin:10px 0;">
        <el-button @click="addDistributor" type="primary" size="small" >添加经销商</el-button>
        <el-button @click="handleImport" type="primary" size="small" >批量导入经销商</el-button>
        <!-- <el-button  type="primary" size="small" @click="handleRegister" >邀请注册经销商</el-button>
        <el-button  type="primary" size="small" @click="handleMobileLogin" >经销商登录地址</el-button>
        <el-button  type="primary" size="small" @click="handlePCLogin" >经销商PC端登录地址</el-button> -->
    </el-col>
    <el-table
        :data="tableData"
        :header-cell-style="{background:'#FAFAFA',color:'#606266',height:'50px'}"
        border
        stripe
        size="medium"
        class="trace-table"
        style="width: 100%">
        <el-table-column prop="distributor_code" align="center" label="经销商编号"></el-table-column>
        <el-table-column prop="distributor_name" align="center" label="经销商名称"></el-table-column>
        <el-table-column prop="distributor_level" align="center" label="经销商级别" :formatter="level"></el-table-column>
        <el-table-column prop="person" align="center" label="负责人"></el-table-column>
        <el-table-column prop="phone" align="center" label="手机号码"></el-table-column>
        <el-table-column prop="superior_dis_name" align="center" label="上级经销商"></el-table-column>
        <el-table-column prop="address" align="center" label="详细地址"></el-table-column>
        <el-table-column prop="create_time" align="center" label="添加时间"></el-table-column>
        <el-table-column label="操作" align="center" fixed="right" width="280px">
            <template slot-scope="scope">
                <el-button
                    size="mini"
                    type="primary"
                    @click="handleEdit(scope.row)">编辑</el-button>
                <el-button
                    size="mini"
                    type="primary"
                    @click="handleDes(scope.row)">详情</el-button>
                <el-button
                    size="mini"
                    :type="scope.row.is_disable==0?'primary':'danger'"
                    @click="handleSetStatus(scope.row)">{{scope.row.is_disable==0?'禁用':'启用'}}</el-button>
                <el-button
                    size="mini"
                    type="primary"
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
    <!-- 详情弹窗 -->
    <el-dialog title="经销商详情" :visible.sync="dialogVisible" width="50%" @close="dialogVisible=false">
        <el-descriptions title="详细信息" :column="2" >
            <el-descriptions-item label="经销商编号">{{distributorInfo.distributor_code}}</el-descriptions-item>
            <el-descriptions-item label="经销商名称">{{distributorInfo.distributor_name}}</el-descriptions-item>
            <el-descriptions-item label="经销商级别">{{level(distributorInfo)}}</el-descriptions-item>
            <el-descriptions-item label="销售地区">
                <el-tag style="margin-right:5px" v-for="(item,index) of sale_area" :key="index" size="small">{{item}}</el-tag>
            </el-descriptions-item>
            <el-descriptions-item label="经销商地址">{{distributor_address}}</el-descriptions-item>
            <el-descriptions-item label="手机号码">{{distributorInfo.phone}}</el-descriptions-item>
            <el-descriptions-item label="上级经销商">{{distributorInfo.superior_dis_name}}</el-descriptions-item>
            <el-descriptions-item label="添加时间">{{distributorInfo.create_time}}</el-descriptions-item>
            <el-descriptions-item label="简介">{{distributorInfo.introduce}}</el-descriptions-item>
        </el-descriptions>
    </el-dialog>
    <!-- 链接生成二维码网址 -->
    <CopyDialog :copyDialogVisible="copyDialogVisible" :title="copyTitle" :url="url" @close="closeCopyDialog"/>
    <!-- 上级经销商列表 -->
    <el-dialog title="上级经销商" :visible.sync="superiorDisVisible" width="50%" @close="superiorDisVisible=false">
        <div class="tab-bar">
            <el-form ref="querySuperiorDisForm" :model="querySuperiorDisForm" label-width="100px" :inline="true" size="small">
                <el-form-item label="经销商名称" prop="distributor_name">
                    <el-input style="width:220px" v-model="querySuperiorDisForm.distributor_name" placeholder="请输入经销商名称"></el-input>
                </el-form-item>
                <el-form-item > 
                    <el-button type="primary" icon="el-icon-search" @click="querySuperiorDis">查询</el-button>
                    <el-button type="primary" @click="handleSelectMain">选择总部</el-button>
                </el-form-item>
            </el-form>
        </div>
        <el-table
            :data="superiorDis"
            :header-cell-style="{background:'#FAFAFA',color:'#606266',height:'50px'}"
            border
            stripe
            size="medium"
            class="trace-table"
            style="width: 100%">
            <el-table-column prop="distributor_code" align="center" label="经销商编号"></el-table-column>
            <el-table-column prop="distributor_name" align="center" label="经销商名称"></el-table-column>
            <el-table-column prop="distributor_level" align="center" label="经销商级别" :formatter="level"></el-table-column>
            <el-table-column prop="phone" align="center" label="手机号码"></el-table-column>
            <el-table-column prop="create_time" align="center" label="添加时间"></el-table-column>
            <el-table-column label="操作" align="center" fixed="right" width="150px">
                <template slot-scope="scope">
                    <el-button
                        size="mini"
                        type="primary"
                        @click="handleSelect(scope.row)">选择</el-button>
                </template>
            </el-table-column>
        </el-table>
        <pagination
        v-show="+totals>10"
        :total="+totals"
        :page.sync="querySuperiorDisForm.pageNum"
        :limit.sync="querySuperiorDisForm.pageSize"
        @pagination="getSuperiorDis"/>
    </el-dialog>
    <!-- 批量导入经销商 -->
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
          <div style="margin:4px 0">2、经销商导入信息严格按照导入模板填写，红色字段为必填项</div>
          <div style="margin:4px 0">3、批量导入的经销商所属默认为总部</div>
          <div style="margin:4px 0">4、销售区域默认为全国</div>
          <el-link type="primary" :underline="false" style="font-size:12px;vertical-align: baseline;" @click="importTemplate">下载模板</el-link>
        </div>
      </el-upload>
      <div slot="footer" class="dialog-footer">
        <el-button type="primary" @click="submitFileForm">确 定</el-button>
        <el-button @click="upload.open = false">取 消</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
import {
    getDistributorLevelList,
    getDistributorList,
    getSuperiorDistributorList,
    deleDistributor,
    getDistributorInfo,
    cutDistributor,
    importDistributorTemplate 
} from '@/api/customer/distributor'
import CopyDialog from '@/components/CopyDialog'
import { getToken } from "@/utils/auth";
import{getCustomerAreaList} from '@/api/customer/basics'
export default {
    components:{
        CopyDialog
    },
    data(){
        return{
            copyDialogVisible:false,
            superiorDisVisible:false,
            url:'',
            copyTitle:'复制链接',
            queryForm:{
                time:[],
                distributor_code:'',
                distributor_name:'',
                distributor_level:'',
                superior_dis_name:'',
                superior_dis_id:undefined,
                zone:[],
                pageNum:1,
                pageSize:10
            },
            querySuperiorDisForm:{
                distributor_name:'',
                level_id:'',
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
                url: process.env.VUE_APP_BASE_API + "/dealer/customer/distributor/importData"
            },
            distributorInfo:{},
            zoneOptions:[],
            superiorDis:[],
            levelOption:[],//经销商级别选项
            tableData:[],
            total:0,
            totals:0,
            dialogVisible:false,
            zoneProps:{
                label:'area_name',
                value:'id',
                checkStrictly:true
            },
        }
    },
    created(){
        this.getList()
        this.getDisLevel()
        this.getZoneList()
    },
    computed:{
        sale_area:function(){
            if (!this.distributorInfo.sale_area) return '--'
            return JSON.parse(this.distributorInfo.sale_area)
        },
        distributor_address:function(){
            return this.distributorInfo.province+'-'+this.distributorInfo.city+'-'+this.distributorInfo.district+'-'+this.distributorInfo.address
        }
    },
    methods:{
        getList(){
            var params=Object.assign({},this.queryForm)
            if(!this.queryForm.time||this.queryForm.time.length==0){
                params.startTime=''
                params.endTime=''
            }else{
                params.startTime=this.queryForm.time[0]
                params.endTime=this.queryForm.time[1]
            }
            delete params.time
            params.zone=params.zone.join(',')
            getDistributorList(params).then(res=>{
                this.tableData=res.data
                this.total=res.total
            })
        },
        getSuperiorDis(){
            getSuperiorDistributorList(this.querySuperiorDisForm).then(res=>{
                this.superiorDisVisible=true
                this.superiorDis=res.data
                this.totals=res.total
            })
        },
        getZoneList(){
            getCustomerAreaList({}).then(res=>{
                this.zoneOptions=this.setTreeLevel(this.handleTree(res.data, "id"),1);
            })
        },
         handleFileSuccess(response, file, fileList) {
            this.upload.open = false;
            this.upload.isUploading = false;
            this.$refs.upload.clearFiles();
            this.$alert(response.msg, "导入结果", { dangerouslyUseHTMLString: true });
            this.getList();
        },
        importTemplate(){
            importDistributorTemplate().then(response => {
                // this.download(response.msg);
                let url = window.URL.createObjectURL(new Blob([response], {type: 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'})); 
                // 生成一个a标签
                let link = document.createElement("a");
                link.style.display = "none";
                link.href = url;
                // 生成时间戳
                let timestamp=new Date().getTime();   
                link.download = '经销商批量导入模板'; 
                document.body.appendChild(link);
                link.click();
            });
        },
        // 文件上传中处理
        handleFileUploadProgress(event, file, fileList) {
            this.upload.isUploading = true;
        },
        getDisLevel(){
            getDistributorLevelList({}).then(res=>{
                this.levelOption=res.data
            })
        },
        level(row){
            return this.levelOption.filter(item=>item.level_order==row.distributor_level).map(item=>item.level_name)[0]
        },
        addDistributor(){
            this.$router.push({path:'/customer/distributorDes'})
        },
        handleEdit(row){
            this.$router.push({path:'/customer/distributorDes',query:{distributor_id:row.id}})
        },
        handleDes(row){
            getDistributorInfo({id:row.id}).then(res=>{
                this.dialogVisible=true
                this.distributorInfo=res.data
            })
        },
        submitFileForm(){
            this.$refs.upload.submit();
        },
        handleSetStatus(row){
            var text=row.is_disable==0?'禁用':'启用'
            this.$confirm(`确定${text}该经销商`, '提示', {
                confirmButtonText: '确定',
                cancelButtonText: '取消',
                type: 'warning'
            }).then(() => {
                 cutDistributor({id:row.id,status:row.is_disable}).then(res=>{
                    if(res.code==200){
                        this.$message.success(res.msg)
                        this.getList()
                    }else{
                        this.$message.error(res.msg)
                    }
                 })
            }).catch(() => {});
        },
        handleDele(row){
            this.$confirm(`确定删除${row.distributor_name}经销商`, '提示', {
                confirmButtonText: '确定',
                cancelButtonText: '取消',
                type: 'warning'
            }).then(() => {
                 deleDistributor({id:row.id}).then(res=>{
                    if(res.code==200){
                        this.$message.success(res.msg)
                        this.getList()
                    }else{
                        this.$message.error(res.msg)
                    }
                 })
            }).catch(() => {});
        },
        handleImport(){
            this.upload.title = "经销商导入";
            this.upload.open = true;
        },
        handleRegister(){
            this.copyDialogVisible=true,
            this.copyTitle='邀请经销商注册'
            this.url='register.ctc.com'
        },
        handlePCLogin(){
            this.copyDialogVisible=true,
            this.url='pc.ctc.com'
        },
        handleMobileLogin(){
            this.copyDialogVisible=true,
            this.url='mobile.ctc.com'
        },
        closeCopyDialog(val){
            this.copyDialogVisible=val
        },
        handleSelect(row){
            this.queryForm.superior_dis_name=row.distributor_name
            this.queryForm.superior_dis_id=row.id
            this.superiorDisVisible=false
        },
        //选择总部
        handleSelectMain(){
            this.queryForm.superior_dis_id=0
            this.queryForm.superior_dis_name='总部'
            this.superiorDisVisible=false
        },
        querySuperiorDis(){
            this.querySuperiorDisForm.pageNum = 1;
            this.getSuperiorDis();
        },
        query(){
          this.queryForm.pageNum = 1;
          this.getList();
        },
        reset(formName){
            this.$refs[formName].resetFields();
            this.queryForm.superior_dis_id=undefined
            this.query()
        },
    }
}
</script>

<style>

</style>