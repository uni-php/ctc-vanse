<template>
  <div class="app-container">
      <el-row class="row-bg">
          <el-col :span="4" class="row-left">
            <div class="tw-title">图文列表</div>
            <div class="block">
                <el-image :src="prefix+form.cover" style="width: 100%; height: 200px">
                    <div slot="error" class="image-slot">
                        <i class="el-icon-picture-outline"></i>
                    </div>
                </el-image>
            </div>
          </el-col>
          <el-col :span="20" class="row-right">
              <el-form :model="form" ref="form" class="form" label-width="100px" :rules="rule" size="medium">
                    <el-form-item label="标题：" prop="title">
                        <el-input style="width:90%"  v-model="form.title" placeholder="请输入标题"/>
                    </el-form-item>
                    <el-form-item label="作者：" prop="author">
                        <el-input style="width:90%"  v-model="form.author" placeholder="请输入作者"/>
                    </el-form-item>
                    <el-form-item label="封面：" prop="cover">
                        <div @click="selectCover">
                        <img v-if="form.cover" :src="prefix+form.cover" class="avatar">
                        <i v-else class="el-icon-plus avatar-uploader-icon"></i>
                        </div>
                    </el-form-item>
                    <el-form-item label="摘要：" prop="digest">
                        <el-input style="width:90%" :autosize="{ minRows: 3, maxRows: 5}" type="textarea"  v-model="form.digest" placeholder="请输入摘要"/>
                    </el-form-item>
                    <el-form-item label="具体内容：" prop="content">
                        <editor v-model="form.content" style="width:90%" :min-height="300"/>
                    </el-form-item>
                     <el-form-item>
                        <el-button type="primary" @click="onSubmit">提交</el-button>
                    </el-form-item>
              </el-form>
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
                                    :src="prefix+it.img_url"
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
  </div>
</template>

<script>
import {getGroupList,getImgMaterial,saveArticle,getArticleInfo} from '@/api/access/officialAccount/material'
export default {
    data(){
        return{
            prefix:"https://2id.icloudapi.cn/static/mainImgs/",
            form:{
                title:'',
                author:'',
                cover:'',
                digest:'',
                thumb_media_id:'',
                id:undefined
            },
            cover:undefined,
            queryForm:{
                pageNum:1,
                pageSize:20,
                group_id:'0'
            },
            article_id:undefined,
            imgMaterialList:[],
            total:0,
            active_idx:undefined,
            group:[],
            tabPosition: 'left',
            materialOpen:false,
            rule:{
                title:[
                    { required: true, message: "标题不能为空", trigger: "blur" },
                ],
                author:[
                    { required: true, message: "作者不能为空", trigger: "blur" },
                ],
                cover:[
                    { required: true, message: "封面不能为空", trigger: "blur" },
                ],
                digest:[
                   { required: true, message: "摘要不能为空", trigger: "blur" }, 
                ],
                content:[
                    { required: true, message: "内容不能为空", trigger: "blur" }, 
                ]
            },
        }
    },
    created(){
        this.getGroupList()
        this.getImgMaterial()
        if(this.$route.query.article_id){
            this.article_id=this.$route.query.article_id
            this.getArticleInfo()
        }
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
        getArticleInfo(){
            getArticleInfo({id:this.article_id}).then(res=>{
                this.form=res.data
            })
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
            this.form.cover=this.cover.img_url
            this.form.thumb_media_id=this.cover.media_id//封面media_id
            this.materialOpen=false
        },
        getImgMaterial(){
            getImgMaterial(this.queryForm).then(res=>{
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
        onSubmit(){
            this.$refs["form"].validate(valid => {
                if(valid){
                    saveArticle(this.form).then(res=>{
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
        /** 关闭按钮 */
        close() {
            this.$store.dispatch("tagsView/delView", this.$route);
            this.$router.go(-1)
        },
    }
}
</script>

<style lang="scss" scoped>
.app-container{
    .form{
        margin: 30px 0 0 20px;
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
}

</style>