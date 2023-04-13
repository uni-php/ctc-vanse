<template>
  <div class="app-container">
      <el-form :model="form" ref="form" class="form" label-width="100px" :rules="rule" size="medium">
            <el-form-item label="礼品编号：" prop="code">
                <el-input style="width:90%" :disabled="gift_id?true:false" v-model="form.code" placeholder="请输入礼品编号"/>
            </el-form-item>
            <el-form-item label="礼品条码：" prop="barcode">
                <el-input style="width:90%" v-model="form.barcode" placeholder="请输入礼品条码"/>
            </el-form-item>
            <el-form-item label="礼品分组：" prop="group_id">
                <el-select style="90%"  v-model="form.group_id" placeholder="请选择产品分类">
                    <el-option
                        v-for="item in classOptions"
                        :key="item.id"
                        :label="item.group_name"
                        :value="item.id">
                    </el-option>
                </el-select>
            </el-form-item>
            <el-form-item label="礼品重量：" prop="weight">
                <el-input style="width:90%" v-model="form.weight" placeholder="请输入礼品重量"/>
            </el-form-item>
            <el-form-item label="礼品排序：" prop="order">
                <el-input style="width:90%" v-model="form.order" placeholder="请输入礼品排序"/>
            </el-form-item>
            <el-form-item label="礼品名称：" prop="gift_name">
                <el-input style="width:90%" v-model="form.gift_name" placeholder="请输入礼品名称"/>
            </el-form-item>
            <el-form-item label="礼品图片：" prop="cover">
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
        <el-form-item label="成本价：" prop="cost_price">
            <el-input style="width:90%"  v-model="form.cost_price" placeholder="请输入礼品成本价"/>
        </el-form-item>
        <el-form-item label="市场价：" prop="market_price">
            <el-input style="width:90%"  v-model="form.market_price" placeholder="请输入礼品市场价"/>
        </el-form-item>
        <el-form-item label="库存：" prop="stock">
            <el-input style="width:90%"  v-model="form.stock" placeholder="请输入礼品库存"/>
        </el-form-item>
        <el-form-item label="礼品单位：" prop="unit">
            <el-input style="width:90%"  v-model="form.unit" placeholder="请输入礼品单位"/>
        </el-form-item>
        <el-form-item label="礼品详情：" prop="details">
            <QiniuEditor v-model="form.details" style="width:90%" aria-placeholder="礼品详情" :min-height="300"/>
        </el-form-item>
        <el-form-item>
            <el-button type="primary" @click="onSubmit">保存</el-button>
        </el-form-item>
      </el-form>
      <el-dialog :visible.sync="dialogVisible">
        <img width="100%" :src="dialogImageUrl" alt="">
      </el-dialog>
      <!-- 图片素材 -->
      <el-dialog title="素材库" class="materialDialog" :visible.sync="materialOpen" width="50%" @close="materialOpen=false">
            <el-tabs v-model="queryForm.img_group" :tab-position="tabPosition" @tab-click="handleClick" style="height: 600px;overflow:auto">
                <el-tab-pane v-for="(item,index) in group" :key="index" :label="item.group_name" :name="String(item.id)">
                    <div class="img-list">
                        <ul>
                            <li v-for="(it,idx) in imgMaterialList" :key="idx" :class="{active:active(it)}" @click="handleClickImg(it,idx)">
                                <el-image
                                    style="width: 150px; height: 150px"
                                    :src="it.img_url"
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
import { getToken } from "@/utils/auth";
import  vuedraggable from "vuedraggable";
import { Loading } from "element-ui";
import{getGroupList,queryGiftInfo,saveGift} from '@/api/assets/gift'
import {getGroupList as getMaterialClass,getImgMaterial} from '@/api/assets/material'
export default {
    components: {
        vuedraggable
    },
    data(){
        return{
            total:0,
            group:[],
            materialOpen:false,
            idx:undefined,
            tabPosition: 'left',
            imgMaterialList:[],
            gift_id:undefined,
            dialogImageUrl:'',
            myArray:[],
            fileList:[],
            dialogVisible:false,
            classOptions:[],
            form:{
                code:'',
                barcode:'',
                group_id:'',
                weight:'',
                order:'',
                gift_name:'',
                cover:[],
                covers:[],
                cost_price:'',
                market_price:'',
                unit:'',
                stock:'',
                details:''
            },
            //礼品分类查询条件
            queryGroupForm:{
                pageNum:1,
                pageSize:999
            },
            //图片库分类查询条件
            queryClassForm:{
                pageNum:1,
                pageSize:999,
                group_name:''
            },
            //图片库查询条件
            queryForm:{
                pageNum:1,
                pageSize:20,
                img_group:'01',//默认查询全部图片库
                img_name:'',
            },
            upload:{
                headers: { Authorization: "Bearer " + getToken() },
                url: process.env.VUE_APP_BASE_API + "/dealer/assets/material/uploadImg",//七牛云地址
            },
            rule:{
                code:[
                    { required: true, message: "请输入礼品编号", trigger: "blur" },
                ],
                weight:[
                    { required: true, message: "请输入礼品重量", trigger: "blur" },
                ],
                order:[
                    { required: true, message: "请输入礼品排序", trigger: "blur" },
                ],
                gift_name:[
                    { required: true, message: "请输入礼品名称", trigger: "blur" },
                ],
                cover:[
                    { required: true, message: "请输入礼品图片", trigger: "blur" },
                ],
                cost_price:[
                    { required: true, message: "请输入礼品成本价", trigger: "blur" },
                ],
                stock:[
                    { required: true, message: "请输入礼品库存", trigger: "blur" },
                ],
            }
        }
    },
    created(){
        this.gift_id=this.$route.query.gift_id
        if(this.gift_id){
            this.queryGiftInfo()
        }
        this.getGroupList()
        this.getMaterialClass()
    },
    computed:{
        active(){
            return function (value){
                return this.form.covers.map(item=>item.name).includes(value.img_name)
            }
        }
    },
    methods:{
        queryGiftInfo(){
            queryGiftInfo({id:this.gift_id}).then(res=>{
                this.form=res.data
                this.form.cover=JSON.parse(this.form.cover)
            })
        },
        getMaterialClass(){
            getMaterialClass(this.queryClassForm).then(res=>{
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
        getGroupList(){
            getGroupList(this.queryGroupForm).then(res=>{
               this.classOptions=res.data
           })
        },
        handleRemove(item, index) {
            this.form.cover.splice(index,1)
        },
        handlePictureCardPreview(file) {
            this.dialogImageUrl = file.url;
            this.dialogVisible = true;
        },
        selectStyle(item,index){
            this.idx=index
        },
        handleSuccess(res,file){
            Loading.service({ fullscreen: true }).close();
            this.form.cover.push({
                name:file.response.key,
                url:file.response.imgPath
            })
        },
        handleClickImg(it,idx){
            if(this.form.covers.map(item=>item.name).includes(it.img_name)){
                var index=this.form.covers.map(item=>item.name).indexOf(it.img_name)
                this.form.covers.splice(index,1)
                return;
            }
            if(this.form.cover.length+this.form.covers.length==5){
                this.$message.warning('最多上传5张图片')
                return;
            }
            this.form.covers.push({
                url:it.img_url,
                name:it.img_name
            })
            this.$forceUpdate()
        },
        submitCover(){
            var arr=Object.assign([],this.form.covers)
            this.form.cover=this.form.cover.concat(arr)
            this.form.covers=[]
            this.materialOpen=false
        },
        selectCover(){
            this.imgMaterialList=[]
            this.form.covers=[]
            this.queryForm.img_group='01'
            this.queryForm.pageNum=1
            this.getImgMaterial()
            this.materialOpen=true
        },
        handleClick(){
            this.queryForm.pageNum=1
            this.getImgMaterial()
        },
        getImgMaterial(){
            var params=Object.assign({},this.queryForm)
            if(params.img_group=='01') params.img_group=''
            getImgMaterial(params).then(res=>{
                this.imgMaterialList=res.data
                this.total=res.total
            })
        },
        beforeUpload(file){
            let self = this;
            let type_arr = ["image/jpeg", "image/png"];
            let type = file.type;
            if (!type_arr.includes(type)) {
                this.$message.error("图片格式不正确,只支持jpg和png类型图片");
                return false;
            }
            const is_size = new Promise((resolve, reject) => {
                let img = new Image();
                img.src = window.URL.createObjectURL(file);
                img.onload = () => {
                let valid = img.width === img.height;
                if (valid) {
                    Loading.service({ fullscreen: true, text: "图片上传中，请稍后" ,background: 'rgba(0, 0, 0, 0.5)'});
                    resolve(file);
                } else {
                    self.$message.error("请上传宽高比例为1:1的图片!");
                    reject();
                }
                };
            });
            return is_size;
        },
        onSubmit(){
            this.$refs["form"].validate(valid => {
                if(valid){
                    var arr=Object.assign({},this.form)
                    arr.cover=JSON.stringify(arr.cover)
                    delete arr.covers
                    saveGift(arr).then(res=>{
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
.item{
  width: 300px;
  height: 50px;
  background-color: #42b983;
  color: #ffffff;
}
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
</style>
