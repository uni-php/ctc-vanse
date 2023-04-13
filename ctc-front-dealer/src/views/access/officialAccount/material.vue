<template>
  <div class="app-container">
      <el-tabs type="border-card" v-model="activeName" @tab-click="handleClick">
        <el-tab-pane label="图文素材" name="first">
            <el-row>
                <el-col style="font-size: 14px;">
                    <p>1、微信图文可用于群发、自动回复、自定义菜单、一对一回复等。</p>
                    <p>2、在公众号后台创建的微信图文不会自动同步到云追溯后台，需要手动操作同步。</p>
                    <p>3、受微信公众平台限制，微信图文素材和微信图片总数上限为5000，高级图文不在此限制范围。</p>
                </el-col>
            </el-row>
            <el-col :span="24" style="margin:10px 0;">
                <el-button @click="addTw" type="primary" size="small" >创建图文</el-button>
            </el-col>
            <el-table
                :data="tableData"
                :header-cell-style="{background:'#FAFAFA',color:'#606266',height:'50px'}"
                border
                stripe
                size="medium"
                class="trace-table"
                style="width: 100%">
                <el-table-column prop="title" align="center" label="标题"></el-table-column>
                <el-table-column prop="author" align="center" label="作者"></el-table-column>
                <el-table-column prop="cover" align="center" label="封面">
                    <template slot-scope="scope">
                        <span>
                            <img style="width:30px;height:30px" :src="prefix+scope.row.cover">
                        </span>
                    </template>
                </el-table-column>
                <el-table-column prop="digest" align="center" label="摘要"></el-table-column>
                <el-table-column prop="create_time" align="center" label="时间"></el-table-column>
                <el-table-column label="操作" align="center" fixed="right" width="280px">
                    <template slot-scope="scope">
                        <el-button
                            size="mini"
                            type="primary"
                            @click="handleEditTw(scope.row)">修改</el-button>
                        <el-button
                            size="mini"
                            type="danger"
                            @click="handleDeleTw(scope.row)">删除</el-button>
                    </template>
                </el-table-column>
            </el-table>
            <pagination
                v-show="+totals>10"
                :total="+totals"
                :page.sync="queryForm.pageNum"
                :limit.sync="queryForm.pageSize"
                @pagination="getArticleList"
            />
        </el-tab-pane>
        <el-tab-pane label="图片素材" name="second">
            <el-row type="flex" justify="space-between" class="material-sum">
                <el-col :span="22" class="sum">共{{total}}张图片</el-col>
                <el-col :span="2"><el-button type="primary" size="medium" @click="addMaterial">上传素材</el-button></el-col>
            </el-row>
            <el-row :gutter="20" type="flex" justify="space-between">
                <el-col :span="20">
                    <el-radio-group v-model="queryForm.group_id" size="medium" @change="selectGroup">
                        <el-radio-button v-for="(item,index) in group" :key="index" :label="item.id">{{item.group_name}}</el-radio-button>
                    </el-radio-group>
                </el-col>
                <el-col :span="4">
                    <el-button type="text" icon="el-icon-circle-plus-outline" @click="addGroup">新建</el-button>
                    <el-button type="text" icon="el-icon-setting" @click="setGroup">管理</el-button>
                </el-col>
            </el-row>
            <div class="demo-image__lazy">
                <el-row :gutter="20">
                    <el-col class="material-img" :span="3" v-for="(item,index) in imgMaterialList" :key="index">
                        <el-image style="width:100%;height:100%" fit="fill" :src="prefix+item.img_url"></el-image>
                    </el-col>
                </el-row>
                <pagination
                    v-show="+total>30"
                    :total="+total"
                    :page.sync="queryForm.pageNum"
                    :limit.sync="queryForm.pageSize"
                    @pagination="getImgMaterial"
                />
            </div>
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
            <!-- 上传图片素材 -->
            <el-dialog title="上传素材" class="materialDialog" :visible.sync="materialOpen" width="40%" @close="materialOpen=false">
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
                        <img v-if="materialForm.img_url" :src="prefix+materialForm.img_url" class="avatar">
                        <i v-else class="el-icon-plus avatar-uploader-icon"></i>
                        <div slot="tip" class="el-upload__tip">图片大小不超过5M，支持jpg,jpeg,png格式</div>
                        </el-upload>
                    </el-form-item>
                    <el-form-item label="素材分组:" prop="material_group">
                        <el-select style="width:90%" v-model="materialForm.material_group" placeholder="请选择素材分组">
                            <el-option
                            v-show="item.id!=0"
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
            <!-- 管理分组 -->
            <el-dialog :title="groupSetTitle" :visible.sync="groupSetOpen" width="50%" @close="groupSetOpen=false">
                <el-table
                :data="group"
                :header-cell-style="{background:'#FAFAFA',color:'#606266',height:'50px'}"
                border
                stripe
                size="medium"
                class="trace-table"
                style="width: 100%">
                <el-table-column prop="id" align="center" label="Id"></el-table-column>
                <el-table-column prop="group_name" align="center" label="分组名称"></el-table-column>
                <el-table-column label="操作" align="center" fixed="right" width="240px">
                    <template slot-scope="scope">
                        <el-button
                            size="mini"
                            type="primary"
                            v-show="scope.row.id!=0"
                            @click="handleEdit(scope.row)">修改</el-button>
                        <el-button
                            size="mini"
                            type="danger"
                            v-show="scope.row.id!=0"
                            @click="handleDel(scope.row)">删除</el-button>
                    </template>
                </el-table-column>
                </el-table>
            </el-dialog>
        </el-tab-pane>
      </el-tabs>
  </div>
</template>

<script>
import {getGroupList,
saveGroup,
queryGroup,
deleGroup,
deleArticle,
uploadImgMaterial,
getArticleList,
getImgMaterial} from '@/api/access/officialAccount/material'
import { getToken } from "@/utils/auth";
export default {
    data(){
        return{
            // prefix:"http://localhost/static/mainImgs/",
            prefix:"https://www.gawxg.com/static/mainImgs/",
            activeName:'first',
            groupOpen:false,
            groupSetOpen:false,
            materialOpen:false,
            groupTitle:'',
            groupSetTitle:'',
            groupForm:{
                group_name:''
            },
            tableData:[],
            queryForm:{
                pageNum:1,
                pageSize:30,
                group_id:'0'
            },
            queryArticleForm:{
                pageNum:1,
                pageSize:10,
            },
            groupRule:{
                group_name:[
                    { required: true, message: "分组名称不能为空", trigger: "blur" },
                ]
            },
            total:0,
            totals:0,
            imgMaterialList:[],
            materialForm:{
                img_url:'',
                material_group:'',
            },
            materialRule:{
                img_url:[
                    { required: true, message: "请选择图片素材", trigger: "blur" },
                ],
                material_group:[
                    { required: true, message: "请选择图片分组", trigger: "blur" },
                ]
            },
            upload:{
                headers: { Authorization: "Bearer " + getToken() },
                url: process.env.VUE_APP_BASE_API + "/dealer/access/uploadMaterial",
            },
            group:[]
        }
    },
    created(){
        this.getGroupList()
        this.getArticleList()
        this.getImgMaterial()
    },
    methods:{
        getGroupList(){
            getGroupList({}).then(res=>{
                this.group=res.data
                this.group.unshift({
                    id:0,
                    group_name:'全部'
                })
            })
        },
        getArticleList(){
            getArticleList(this.queryArticleForm).then(res=>{
                this.tableData=res.data
                this.totals=res.total
            })
        },
        getImgMaterial(){
            getImgMaterial(this.queryForm).then(res=>{
                this.imgMaterialList=res.data
                this.total=res.total
            })
        },
        addTw(){
            this.$router.push({path:'/createArticleMaterial'})
        },
        handleEditTw(row){
            this.$router.push({path:'/createArticleMaterial',query:{article_id:row.id}})
        },
        addMaterial(){
            this.materialOpen=true
            this.materialForm.img_url=''
            this.materialForm.material_group=''
        },
        handleClick(){},
        handleClickChild(){},
        selectGroup(){
            this.getImgMaterial()
        },
        setGroup(){
            this.groupSetTitle='管理分组'
            this.groupSetOpen=true
        },
        addGroup(){
            this.groupTitle='新建分组'
            this.groupOpen=true
            this.groupForm={
                group_name:''
            }
        },
        handleSuccessImg(res,file){
          this.materialForm.img_url=file.response
        },
        beforeUpload(file){
            const isJPG = file.type === 'image/jpeg'||file.type === 'image/png'||file.type === 'image/jpg';
            const isLt2M = file.size / 1024 / 1024 < 2;
            if (!isJPG) {
              this.$message.error('上传头像图片只能是 jpg,png,jpeg 格式!');
            }
            if (!isLt2M) {
              this.$message.error('上传图片大小不能超过 2MB!');
            }
            return isJPG && isLt2M;
        },
        handleEdit(row){
            queryGroup({id:row.id}).then(res=>{
                this.groupOpen=true
                this.groupTitle='修改分组'
                this.groupForm=res.data
            })
        },
        submitImgMaterialForm(){
            this.$refs["materialForm"].validate(valid => {
                if(valid){
                    uploadImgMaterial(this.materialForm).then(res=>{
                        if(res.code==200){
                            this.$message.success(res.msg)
                            this.materialOpen=false
                            this.getImgMaterial()
                        }else{
                            this.$message.error(res.msg)
                        }
                    })
                }
            })
        },
        handleDel(row){
            this.$confirm(`分组删除后，分组下的图片将被移到全部分组。确认删除${row.group_name}分组?`, '提示', {
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
        handleDeleTw(row){
            this.$confirm(`确认删除该图文消息?`, '提示', {
                confirmButtonText: '确定',
                cancelButtonText: '取消',
                type: 'warning'
            }).then(() => {
                 deleArticle({id:row.id,media_id:row.media_id}).then(res=>{
                     if(res.code==200){
                        this.$message.success(res.msg)
                        this.getArticleList()
                    }else{
                        this.$message.error(res.msg)
                    }
                 })
            }).catch(() => {});
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
.material-sum{
    margin-bottom: 20px;
    padding: 10px 0;
    border-bottom: 1px solid #eeeeee;
    .sum{
        font-weight: 500;
        font-size: 18px;
    }
}
.material-img{
   border: 1px solid #eeeeee;
   height: 160px;
   margin-top: 10px;
}
</style>
