<template>
  <div class="app-container">
    <div class="tips">
        <p>添加的直播设备需提前在萤石云设置好，添加成功后的直播设备可在溯源模板中直接调用。</p>
    </div>
    <div class="tab-bar">
        <el-form ref="queryForm" :model="queryForm" label-width="100px" :inline="true" size="small">
            <el-form-item label="设备名称" prop="equ_name">
                <el-input style="width:240px" v-model="queryForm.equ_name" placeholder="请输入设备名称"></el-input>
            </el-form-item>
            <el-form-item > 
                <el-button type="primary" icon="el-icon-search" @click="query">查询</el-button>
                <el-button icon="el-icon-refresh" @click="resetQuery('queryForm')">重置</el-button>
            </el-form-item>
        </el-form>
    </div>
    <el-col :span="24" style="margin:10px 0;">
        <el-button @click="handleAdd" type="primary" size="small" >添加监控设备</el-button>
    </el-col>
    <el-table
      :data="tableData"
      :header-cell-style="{background:'#FAFAFA',color:'#606266',height:'50px'}"
      border
      stripe
      size="medium"
      class="trace-table"
      style="width: 100%">
        <el-table-column prop="id" align="center" label="设备编号"  width="80px"></el-table-column>
        <el-table-column prop="equ_name" align="center" label="设备名称"></el-table-column>
        <el-table-column prop="equ_definition" align="center" label="清晰度"></el-table-column>
        <el-table-column prop="cover" align="center" label="封面图片">
            <template slot-scope="scope">
                <span>
                    <img style="width:30px;height:30px" :src="prefix+scope.row.cover">
                </span>
            </template>
        </el-table-column>
        <el-table-column prop="create_time" align="center" label="添加时间"></el-table-column>
        <el-table-column label="操作" align="center" fixed="right" width="280px">
            <template slot-scope="scope">
                <el-button
                    size="mini"
                    type="primary"
                    @click="handleEdit(scope.row)">修改</el-button>
                <el-button
                    size="mini"
                    type="danger"
                    @click="handleDele(scope.row)">删除</el-button>
            </template>
        </el-table-column>
    </el-table>
    <pagination
        v-show="+total>10"
        :total="+total"
        :page.sync="queryForm.pageNum"
        :limit.sync="queryForm.pageSize"
        @pagination="getList"
     />
    <!-- 添加设置 -->
    <el-dialog :title="title" class="form" :visible.sync="monitorOpen" width="40%" @close="monitorOpen=false">
        <el-form :model="form" ref="form" label-width="120px" :rules="rule" size="medium">
            <el-form-item label="直播设备名：" prop="equ_name">
                <el-input style="width:90%"  v-model="form.equ_name" placeholder="请输入设备名"/>
            </el-form-item>
            <el-form-item label="设备序列号：" prop="equ_num">
                <el-input style="width:90%"  v-model="form.equ_num" placeholder="请输入设备序列号"/>
            </el-form-item>
            <el-form-item label="设备通道：" prop="equ_way">
                <el-input style="width:90%"  v-model="form.equ_way" placeholder="请输入设备通道"/>
            </el-form-item>
            <el-form-item label="设备授权码：" prop="equ_code">
                <el-input style="width:90%"  v-model="form.equ_code" placeholder="请输入设备授权码"/>
            </el-form-item>
            <el-form-item label="清晰度：" prop="equ_definition">
                <el-radio-group v-model="form.equ_definition">
                    <el-radio v-for="(item,index) in definitionOptions" :key="index" :label="item.dict_value">{{item.dict_label}}</el-radio>
                </el-radio-group>
            </el-form-item>
            <el-form-item label="直播封面图：" prop="cover">
                <el-upload
                    class="avatar-uploader"
                    :action="upload.url"
                    :headers="upload.headers"
                    :show-file-list="false"
                    :on-success="handleSuccessImg"
                    name="img"
                    :before-upload="beforeUpload">
                    <img v-if="form.cover" :src="prefix+form.cover" class="avatar">
                    <i v-else class="el-icon-plus avatar-uploader-icon"></i>
                    <div slot="tip" class="el-upload__tip">图片大小不超过1M，支持jpg,jpeg,png格式</div>
                </el-upload>
            </el-form-item>
        </el-form>
        <div slot="footer" class="dialog-footer">
            <el-button type="primary" @click="submitForm">确 定</el-button>
            <el-button @click="monitorOpen=false">取 消</el-button>
        </div>
    </el-dialog>
  </div>
</template>

<script>
import {getMonitorList,saveMonitorList,deleMonitor,queryMonitor} from '@/api/access/monitor'
import { getToken } from "@/utils/auth";
export default {
    data(){
        return{
            prefix:"http://localhost/static/mainImgs/",
            queryForm:{
                equ_name:'',
                pageNum:1,
                pageSize:10
            },
            tableData:[],
            total:0,
            upload:{
                headers: { Authorization: "Bearer " + getToken() },
                url: process.env.VUE_APP_BASE_API + "/dealer/access/uploadMaterial",
            },
            monitorOpen:false,
            title:'',
            form:{
                equ_name:'',
                equ_num:'',
                equ_way:'',
                equ_code:'',
                equ_definition:'1'
            },
            definitionOptions:[],
            rule:{
                equ_name:[
                    { required: true, message: "请输入设备名", trigger: "blur" },
                ],
                equ_num:[
                    { required: true, message: "请输入设备序列号", trigger: "blur" },
                ],
                equ_way:[
                    { required: true, message: "请输入设备通道", trigger: "blur" },
                ],
                equ_code:[
                    { required: true, message: "请输入设备授权码", trigger: "blur" },
                ],
                equ_definition:[
                    { required: true, message: "请选择设备清晰度", trigger: "blur" },
                ],
                cover:[
                    { required: true, message: "请上传直播封面图", trigger: "blur" },
                ],
            }
        }
    },
    created(){
        this.getList(),
        this.getDicts({type:'equ_definition'}).then(res=>{
            this.definitionOptions=res.data
        })
    },
    methods:{
        handleAdd(){
            this.title='添加设备'
            this.monitorOpen=true
            this.form={
                equ_name:'',
                equ_num:'',
                equ_way:'',
                equ_code:'',
                equ_definition:'1',
                cover:'',
                id:undefined
            }
        },
        handleEdit(row){
            queryMonitor({id:row.id}).then(res=>{
                this.monitorOpen=true
                this.form=res.data
                this.form.equ_definition=String(this.form.equ_definition)
            })
        },
        handleSuccessImg(res,file){
            this.form.cover=file.response
        },
        getList(){
            getMonitorList(this.queryForm).then(res=>{
                this.tableData=res.data
                this.total=res.total
            })
        },
        beforeUpload(file){
            const isJPG = file.type === 'image/jpeg'||file.type === 'image/png'||file.type === 'image/jpg';
            const isLt2M = file.size / 1024 / 1024 < 1;
            if (!isJPG) {
              this.$message.error('上传头像图片只能是 jpg,png,jpeg 格式!');
            }
            if (!isLt2M) {
              this.$message.error('上传图片大小不能超过 2MB!');
            }
            return isJPG && isLt2M;
        },
        handleDele(row){
            this.$confirm(`确认删除该设备吗?`, '提示', {
                confirmButtonText: '确定',
                cancelButtonText: '取消',
                type: 'warning'
            }).then(() => {
                 deleMonitor({id:row.id}).then(res=>{
                     if(res.code==200){
                        this.$message.success(res.msg)
                        this.getList()
                    }else{
                        this.$message.error(res.msg)
                    }
                 })
            }).catch(() => {});
        },
        submitForm(){
            this.$refs["form"].validate(valid => {
                if(valid){
                    saveMonitorList(this.form).then(res=>{
                        if(res.code==200){
                            this.$message.success(res.msg)
                            this.monitorOpen=false
                            this.getList()
                        }else{
                            this.$message.error(res.msg)
                        }
                    })
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


<style lang="scss" scoped>
.app-container .tips{
    padding: 8px 16px;
    background-color: #ecf8ff;
    border-radius: 4px;
    border-left: 5px solid #50bfff;
    margin: 20px 0;
}
.form{
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
  .tips{
    padding: 10px;
    background: #eeeeee;
    margin-bottom: 20px 0;
  }
}
.dialog-footer{
  margin: 30px 0;
}
</style>