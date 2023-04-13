<template>
  <div class="app-container">
    <el-col :span="24" style="margin:10px 0;">
        <el-button @click="handleAddClass" type="primary" size="small" >新增一级分类</el-button>
    </el-col>
    <el-table
      :data="tableData"
      row-key="id"
      :header-cell-style="{background:'#FAFAFA',color:'#606266',height:'50px'}"
      border
      stripe
      size="medium"
      class="trace-table"
      style="width: 100%"
      :tree-props="{children: 'children', hasChildren: 'hasChildren'}">
        <el-table-column prop="id" align="center" label="ID" ></el-table-column>
        <el-table-column prop="class_name" align="center" label="分类名称" ></el-table-column>
        <!-- <el-table-column prop="product_num" align="center" label="产品数" ></el-table-column> -->
        <el-table-column label="操作" align="center" fixed="right" width="300px">
            <template slot-scope="scope">
                    <el-button
                    size="mini"
                    type="text"
                    @click="handleEdit(scope.row)">修改</el-button>
                    <el-button
                    size="mini"
                    v-show="scope.row.parent_id==0"
                    type="text"
                    @click="handleAddChildClass(scope.row)">添加二级分类</el-button>
                    <el-button
                    size="mini"
                    type="text"
                    @click="handleDele(scope.row)">删除</el-button>
            </template>
        </el-table-column>
    </el-table>
    <!-- 添加分类 -->
    <el-dialog :title="title" :visible.sync="dialog" width="30%" @close="dialog=false">
        <el-form :model="form" class="form" ref="form" label-width="100px" :rules="rule" size="medium">
            <el-form-item label="分类名称:" prop="class_name">
                <el-input style="width:90%" v-model="form.class_name" placeholder="请输入分类名称"/>
            </el-form-item>
            <el-form-item label="选择图片：" prop="cover" v-if="form.parent_id">
                <div @click="selectCover">
                <img v-if="form.cover" :src="form.cover" class="avatar">
                <i v-else class="el-icon-plus avatar-uploader-icon"></i>
                </div>
            </el-form-item>
            <el-form-item label="排序:" prop="order">
                <el-input style="width:90%" v-model="form.order" placeholder="请输入排序数字"/>
            </el-form-item>
        </el-form>
        <div slot="footer" class="dialog-footer">
          <el-button type="primary" @click="submitForm">保 存</el-button>
          <el-button @click="cancel">取 消</el-button>
        </div>
    </el-dialog>
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
                            v-show="+totals>20"
                            :total="+totals"
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
import {getClassList,saveProductClass,deleProductClass,queryProductClass} from '@/api/app/mall'
import {getGroupList,getImgMaterial} from '@/api/assets/material'
export default {
    data(){
        return{
            materialOpen:false,
            tableData:[],
            title:'',
            dialog:false,
            imgMaterialList:[],
            tabPosition: 'left',
            cover:undefined,
            active_idx:undefined,
            queryParams:{
                pageNum:1,
                pageSize:999
            },
             queryForm:{
                pageNum:1,
                pageSize:20,
                img_group:'01',//默认查询全部图片库
                img_name:'',
            },
            queryGroupForm:{
                pageNum:1,
                pageSize:999,
                group_name:''
            },
            group:[],
            total:0,
            totals:0,
            form:{
                class_name:'',
                order:'',
                parent_id:undefined,
                cover:''
            },
            rule:{
                class_name:[
                    { required: true, message: "分组名称不能为空", trigger: "blur" },
                ],
                order:[
                    { required: true, message: "排序序号不能为空", trigger: "blur" },
                ]
            }
        }
    },
    created(){
        this.getList()
        this.getGroupList()
        this.getImgMaterial()
    },
    methods:{
        getList(){
            getClassList(this.queryParams).then(res=>{
                this.tableData=res.data
                this.total=res.total
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
            this.materialOpen=false
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
        handleEdit(row){
            queryProductClass({id:row.id}).then(res=>{
                this.title='修改分类'
                this.dialog=true
                this.form=res.data
            })
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
        getImgMaterial(){
           var params=Object.assign({},this.queryForm)
            if(params.img_group=='01') params.img_group=''
            getImgMaterial(params).then(res=>{
                this.imgMaterialList=res.data
                this.totals=res.total
            })
        },
        handleAddClass(){
            this.dialog=true
            this.title='添加分类'
            this.form.parent_id=''
            this.form.class_name=''
            this.form.order=''
            this.form.id=undefined
        },
        handleAddChildClass(row){
            this.dialog=true
            this.title='添加二级分类'
            this.form.parent_id=row.id
            this.form.class_name=''
            this.form.order=''
            this.form.id=undefined
        },
        handleDele(row){
            this.$confirm(`确认删除${row.class_name}分类?`, '提示', {
                confirmButtonText: '确定',
                cancelButtonText: '取消',
                type: 'warning'
            }).then(() => {
                if(row.children.length>0){
                    this.$message.warning('请先删除该类别下的二级分类')
                    return;
                }
                deleProductClass(row).then(res=>{
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
                    saveProductClass(this.form).then(res=>{
                        if(res.code==200){
                            this.$message.success(res.msg)
                            this.dialog=false
                            this.getList()
                        }else{
                            this.$message.error(res.msg)
                        }
                    })
                }
            })
        },
        cancel(){
            this.dialog=false
        }
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