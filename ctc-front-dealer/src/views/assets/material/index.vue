<template>
  <div class="app-container">
    <el-tabs v-model="activeName" @tab-click="handleClick">
        <el-tab-pane label="图片库" name="first"></el-tab-pane>
        <el-tab-pane label="分组" name="second"></el-tab-pane>
    </el-tabs>
    <div v-show="activeName=='first'">
        <div class="tab-bar">
            <el-form ref="queryForm" :model="queryForm" label-width="100px" :inline="true" size="small">
                <el-form-item label="图片名称" prop="img_name">
                    <el-input style="width:240px" v-model="queryForm.img_name" placeholder="请输入图片名称"></el-input>
                </el-form-item>
                <el-form-item label="素材分组:" prop="img_group">
                    <el-select style="width:90%" v-model="queryForm.img_group" placeholder="请选择图片分组">
                        <el-option
                        v-for="item in groupOptions"
                        :key="item.id"
                        :label="item.group_name"
                        :value="item.id">
                        </el-option>
                    </el-select>
                </el-form-item>
                <el-form-item > 
                    <el-button type="primary" icon="el-icon-search" @click="query">查询</el-button>
                    <el-button icon="el-icon-refresh" @click="resetQuery('queryForm')">重置</el-button>
                </el-form-item>
            </el-form>
        </div>
        <el-row>
            <el-col :span="24" style="margin:10px 0;">
                <el-button @click.native="addImg" type="primary" size="small" >上传图片</el-button>
            </el-col>
        </el-row>
        <!-- 图片 -->
        <div >
            <div class="img-box">
                <ul>
                    <li v-for="(item,index) in imgMaterialList" :key="index">
                        <el-image style="width:100%;height:140px" fit="fill" :src="item.img_url"></el-image>
                        <!-- 操作按钮 -->
                        <div>
                            <el-popover
                                placement="top"
                                title="链接"
                                trigger="hover"
                                :content="item.img_url">
                                <el-button slot="reference" size="mini" type="text">链接</el-button>
                            </el-popover>
                            <el-button size="mini" type="text" @click="handleGroup(item)">分组</el-button>
                            <el-button size="mini" type="text" @click="deleImg(item)">删除</el-button>
                        </div>
                    </li>
                </ul>
            </div>
            <pagination
                v-show="+total>30"
                :total="+total"
                :page.sync="queryForm.pageNum"
                :limit.sync="queryForm.pageSize"
                @pagination="getImgList"
            />
        </div>
        <!-- 修改分组 -->
        <el-dialog title="修改分组" :visible.sync="changeGroupOpen" width="30%" @close="changeGroupOpen=false">
            <el-form :model="changeGroupForm" ref="changeGroupForm" label-width="100px"  size="medium">
                <el-form-item label="素材分组:" prop="img_group">
                    <el-select style="width:90%" v-model="changeGroupForm.img_group" placeholder="请选择素材分组">
                        <el-option
                        v-for="item in group"
                        :key="item.id"
                        :label="item.group_name"
                        :value="item.id">
                        </el-option>
                    </el-select>
                </el-form-item>
            </el-form>
            <div slot="footer" class="dialog-footer">
                <el-button type="primary" @click="changeGroup">确 定</el-button>
                <el-button @click="changeGroupOpen=false">取 消</el-button>
            </div>
        </el-dialog>
        <!-- 上传图片素材 -->
        <el-dialog title="上传图片" class="materialDialog" :visible.sync="materialOpen" width="40%" @close="materialOpen=false">
            <el-form :model="materialForm" ref="materialForm" label-width="100px" :rules="materialRule" size="medium">
                <el-form-item label="本地图片:" prop="img_url">
                    <el-upload
                    class="avatar-uploader"
                    :action="upload.url"
                    :headers="upload.headers"
                    :show-file-list="false"
                    :on-success="handleSuccessImg"
                    name="img"
                    :before-upload="beforeUpload">
                    <img v-if="materialForm.img_url" :src="materialForm.img_url" class="avatar">
                    <i v-else class="el-icon-plus avatar-uploader-icon"></i>
                    <div slot="tip" class="el-upload__tip">图片大小不超过5M，支持jpg,jpeg,png格式</div>
                    </el-upload>
                </el-form-item>
                <el-form-item label="素材分组:" prop="img_group">
                    <el-select style="width:90%" v-model="materialForm.img_group" placeholder="请选择素材分组">
                        <el-option
                        v-for="item in group"
                        :key="item.id"
                        :label="item.group_name"
                        :value="item.id">
                        </el-option>
                    </el-select>
                </el-form-item>
            </el-form>
            <div slot="footer" class="dialog-footer">
                <el-button type="primary" @click="submitImgMaterialForm">确 定</el-button>
                <el-button @click="materialOpen=false">取 消</el-button>
            </div>
        </el-dialog>
    </div>
    <!-- 分组 -->
    <div v-show="activeName=='second'">
        <el-col :span="24" style="margin:10px 0;">
            <el-button @click="addGroup" type="primary" size="small" >添加分组</el-button>
        </el-col>
        <el-table
                :data="group"
                :header-cell-style="{background:'#FAFAFA',color:'#606266',height:'50px'}"
                border
                stripe
                size="medium"
                class="trace-table"
                style="width: 100%">
                <el-table-column prop="group_name" align="center" label="分组名称"></el-table-column>
                <el-table-column prop="create_time" align="center" label="时间"></el-table-column>
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
            v-show="+totals>10"
            :total="+totals"
            :page.sync="queryGroupForm.pageNum"
            :limit.sync="queryGroupForm.pageSize"
            @pagination="getGroupList"
        />
        <!-- 新建分组 -->
        <el-dialog :title="groupTitle" :visible.sync="groupOpen" width="30%" @close="groupOpen=false">
            <el-form :model="groupForm" ref="groupForm" label-width="80px" :rules="groupRule" size="medium">
                <el-form-item label="分组名称" prop="group_name">
                    <el-input style="width:90%"  v-model="groupForm.group_name" placeholder="请输入分组名称"/>
                </el-form-item>
            </el-form>
            <div slot="footer" class="dialog-footer">
                <el-button type="primary" @click="submitGroupForm">确 定</el-button>
                <el-button @click="groupOpen=false">取 消</el-button>
            </div>
        </el-dialog>
    </div>
  </div>
</template>

<script>
import {
    getImgMaterial,
    saveGroup,
    getGroupList,
    uploadImgMaterial,
    deleGroup,
    changeGroup,
    deleImg,
    queryGroup
} from '@/api/assets/material'
import { getToken } from "@/utils/auth";
export default {
    data(){
        return{
            activeName:'first',
            upload:{
                headers: { Authorization: "Bearer " + getToken() },
                url: process.env.VUE_APP_BASE_API + "/dealer/assets/material/uploadImg",//七牛云地址
            },
            queryForm:{
                pageNum:1,
                pageSize:10,
                img_group:'',
                img_name:''
            },
            queryGroupForm:{
                pageNum:1,
                pageSize:10,
                group_name:''
            },
            changeGroupForm:{
                img_group:'',
                id:''
            },
            groupForm:{
                group_name:'',
            },
            groupRule:{
                group_name:[
                    { required: true, message: "分组名称不能为空", trigger: "blur" },
                ]
            },
            materialRule:{
                img_url:[
                    { required: true, message: "请选择图片素材", trigger: "blur" },
                ],
                img_group:[
                    { required: true, message: "请选择图片分组", trigger: "blur" },
                ]
            },
            imgMaterialList:[],
            materialOpen:false,
            materialForm:{
                img_url:'',
                img_group:'',
                img_name:undefined
            },
            groupOpen:false,
            changeGroupOpen:false,
            groupTitle:'',
            total:0,
            totals:0,
            group:[],
            groupOptions:[],
        }
    },
    created(){
        this.getGroupList()
        this.getImgList()
    },
    methods:{
        getGroupList(){
            getGroupList(this.queryGroupForm).then(res=>{
                this.group=res.data
                this.groupOptions=Object.assign([],res.data)
                this.groupOptions.unshift({
                    id:0,
                    group_name:'未分组'
                })
                this.totals=res.total
            })
        },
        getImgList(){
            getImgMaterial(this.queryForm).then(res=>{
                this.imgMaterialList=res.data
                this.total=res.data
            })
        },
        addImg(){
            this.materialOpen=true
            this.materialForm={
                img_name:'',
                img_url:'',
                img_group:''
            }
        },
        beforeUpload(file){
            const isJPG = file.type === 'image/jpeg'||file.type === 'image/png'||file.type === 'image/jpg';
            const isLt2M = file.size / 1024 / 1024 < 2;
            if (!isJPG) {
              this.$message.error('上传图片只能是 jpg,png,jpeg 格式!');
            }
            if (!isLt2M) {
              this.$message.error('上传图片大小不能超过 2MB!');
            }
            return isJPG && isLt2M;
        },
        addGroup(){
            this.groupOpen=true
            this.groupTitle='添加分组'
            this.groupForm={
                group_name:'',
                id:undefined
            }
        },
        handleGroup(item){
            this.changeGroupOpen=true
            this.changeGroupForm.img_group=item.img_group
            this.changeGroupForm.id=item.id
        },
        changeGroup(){
            var params={
                id:this.changeGroupForm.id,
                img_group:this.changeGroupForm.img_group
            }
            changeGroup(params).then(res=>{
                if(res.code==200){
                    this.$message.success(res.msg)
                    this.changeGroupOpen=false
                    this.getImgList()
                }else{
                    this.$message.error(res.msg)
                }
            })
        },
        handleClick(){

        },
        handleEdit(row){
            queryGroup({id:row.id}).then(res=>{
                this.groupOpen=true
                this.groupTitle='修改分组'
                this.groupForm=res.data
            })
        },
        handleSuccessImg(res,file){
          this.materialForm.img_url=file.response.imgPath
          this.materialForm.img_name=file.response.key
        },
        deleImg(item){
            this.$confirm(`若删除，不会对目前已使用该图片的相关页面内容造成影响。确认删除?`, '提示', {
                confirmButtonText: '确定',
                cancelButtonText: '取消',
                type: 'warning'
            }).then(() => {
                 deleImg({id:item.id}).then(res=>{
                    if(res.code==200){
                        this.$message.success(res.msg)
                        this.getImgList()
                    }else{
                        this.$message.error(res.msg)
                    }
                 })
            }).catch(() => {});
        },
        handleDele(row){
            this.$confirm(`分组删除后，分组下的图片将被移到未分组。确认删除${row.group_name}分组?`, '提示', {
                confirmButtonText: '确定',
                cancelButtonText: '取消',
                type: 'warning'
            }).then(() => {
                 deleGroup({id:row.id}).then(res=>{
                    if(res.code==200){
                        this.$message.success(res.msg)
                        this.getGroupList()
                    }else{
                        this.$message.error(res.msg)
                    }
                 })
            }).catch(() => {});
        },
        submitImgMaterialForm(){
            this.$refs["materialForm"].validate(valid => {
                if(valid){
                    uploadImgMaterial(this.materialForm).then(res=>{
                        if(res.code==200){
                            this.$message.success(res.msg)
                            this.materialOpen=false
                            this.getImgList()
                        }else{
                            this.$message.error(res.msg)
                        }
                    })    
                }
            })
        },
        submitGroupForm(){
            this.$refs["groupForm"].validate(valid => {
                if(valid){
                    saveGroup(this.groupForm).then(res=>{
                        if(res.code==200){
                            this.$message.success(res.msg)
                            this.groupOpen=false
                            this.getGroupList()
                        }else{
                            this.$message.error(res.msg)
                        }
                    })
                }
            })
        },
        query(){
            this.queryForm.pageNum = 1;
            this.getImgList();
        },
        resetQuery(formName){
            this.$refs[formName].resetFields();
            this.query()
        }
    }
}
</script>

<style lang="scss" scoped>
.app-container,.materialDialog{
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
.img-box{
    ul{
        padding-left: 0;
    }
    li{
        width: 140px;
        height: 180px;
        margin:10px;
        border: 1px solid #7bbdff46;
        display: inline-block;
        div{
            height: 40px;
            width: 100%;
            display: flex;
            justify-content: space-around;
            align-items: center;
            font-size: 12px;
            ::v-deep .el-button{
                margin-left: 0;
            }
        }
    }
    li:hover{
        border: 1px solid #409EFF;
    }
}
.material-img{
   border: 1px solid #eeeeee;
   height: 160px;
   margin-top: 10px;
}
</style>