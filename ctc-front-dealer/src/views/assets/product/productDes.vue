<template>
  <div class="app-container">
      <el-form :model="form" ref="form" class="form" label-width="100px" :rules="rule" size="medium">
        <el-form-item label="产品编号：" prop="code">
            <el-input style="width:90%" :disabled="product_id?true:false" v-model="form.code" placeholder="请输入产品编号"/>
        </el-form-item>
        <el-form-item label="一级分类：" prop="class_one">
            <el-select style="90%" @change="selectOneClass" v-model="form.class_one" placeholder="请选择产品分类">
                <el-option
                    v-for="item in classOptions"
                    :key="item.id"
                    :label="item.class_name"
                    :value="item.id">
                </el-option>
            </el-select>
        </el-form-item>
        <el-form-item label="二级级分类：" prop="class_two">
            <el-select style="90%" v-model="form.class_two" placeholder="请选择产品分类">
                <el-option
                    v-for="item in classTwoOptions"
                    :key="item.id"
                    :label="item.class_name"
                    :value="item.id">
                </el-option>
            </el-select>
        </el-form-item>
        <el-form-item label="产品条码：" prop="barcode">
            <el-input style="width:90%"  v-model="form.barcode" placeholder="请输入产品条码"/>
        </el-form-item>
        <el-form-item label="产品重量：" prop="weight">
            <el-input style="width:90%"  v-model="form.weight" placeholder="请输入产品重量"/>
        </el-form-item>
        <el-form-item label="产品积分：" prop="integral">
            <el-input style="width:90%"  v-model="form.integral" placeholder="请输入产品积分"/>
        </el-form-item>
        <el-form-item label="库存：" prop="stock">
            <el-input style="width:90%"  v-model="form.stock" placeholder="请输入产品库存"/>
        </el-form-item>
        <el-form-item label="产品名称：" prop="product_name">
            <el-input style="width:90%"  v-model="form.product_name" placeholder="请输入产品名称"/>
        </el-form-item>
        <el-form-item label="产品单位：" prop="unit">
            <el-input style="width:90%"  v-model="form.unit" placeholder="请输入产品单位"/>
        </el-form-item>
        <!-- <el-form-item label="产品图片：" prop="cover">
            <vuedraggable class="wrapper" v-model="form.cover">
                <transition-group>
                    <div v-for="(item,index) in form.cover" :key="item.name" class="drag-box" @mouseover="selectStyle(item,index)" @mouseout="idx=undefined">
                            <img  :src="item.url"/>
                            <div :class="[index==idx?'active':'no-active']">
                                <span @click="handlePictureCardPreview(item)" style="color:white"><i class="el-icon-zoom-in"></i></span>
                                <span @click="handleRemove(item,index)" style="margin-left:15px;color:white"><i class="el-icon-delete"></i></span>
                            </div>
                    </div>
                </transition-group>
            </vuedraggable>
            <el-upload
                :action="upload.url"
                name="img"
                v-show="form.cover.length<5"
                :headers="upload.headers"
                :file-list="fileList"
                :before-upload="beforeUpload"
                :limit="5"
                :on-success="handleSuccess"
                list-type="picture-card"
                :show-file-list="true"
                >
                <i class="el-icon-plus"></i>
            </el-upload>
        </el-form-item> -->
        <el-form-item label="产品图片：" prop="cover">
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
        <el-form-item label="价格：" prop="price">
            <el-input style="width:90%"  v-model="form.price" placeholder="请输入产品价格"/>
        </el-form-item>
        <el-form-item label="市场价：" prop="market_price">
            <el-input style="width:90%"  v-model="form.market_price" placeholder="请输入产品市场价"/>
        </el-form-item>
        <el-form-item label="产品详情：" prop="details">
            <QiniuEditor v-model="form.details" style="width:90%" aria-placeholder="产品详情" :min-height="300"/>
        </el-form-item>
        <el-form-item label="排序：" prop="order">
            <el-input style="width:90%"  v-model="form.order" placeholder="请输入产品排序"/>
        </el-form-item>
        <el-form-item label="产品规格：" prop="specifications">
            <el-input style="width:90%"  v-model="form.specifications" placeholder="请输入产品规格"/>
        </el-form-item>
        <el-form-item label="呆滞品周期：" prop="dull_cycle">
            <el-input style="width:90%"  v-model="form.dull_cycle" placeholder="请输入呆滞品周期"/>
        </el-form-item>
        <el-form-item label="批准文号：" prop="approval_number">
            <el-input style="width:90%"  v-model="form.approval_number" placeholder="请输入批准文号"/>
        </el-form-item>
        <el-form-item label="生产厂家：" prop="manufacturer">
            <el-input style="width:90%"  v-model="form.manufacturer" placeholder="请输入生产厂家"/>
        </el-form-item>
        <el-form-item label="品牌：" prop="brand">
            <el-input style="width:90%"  v-model="form.brand" placeholder="请输入品牌"/>
        </el-form-item>
        <el-form-item label="保质期：" prop="shelf_life">
            <el-input style="width:90%"  v-model="form.shelf_life" placeholder="请输入保质期">
                <template slot="append">月</template>
            </el-input>
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
import {getClassList,saveProduct,queryProductInfo} from '@/api/assets/product'
import {getGroupList,getImgMaterial} from '@/api/assets/material'
import { getToken } from "@/utils/auth";
import  vuedraggable from "vuedraggable";
import { Loading } from "element-ui";
export default {
    components: {
        vuedraggable
    },
    data(){
        return{
            total:0,
            group:[],
            tabPosition: 'left',
            imgMaterialList:[],
            materialOpen:false,
            product_id:undefined,
            active_idx:undefined,
            idx:undefined,
            list: [1,2,34,4,54,5],
            drag: false,
            myArray:[],
            fileList:[],
            dialogVisible:false,
            dialogImageUrl: '',
            classOptions:[],
            classTwoOptions:[],
            form:{
                covers:[],
                code:'',
                class_one:'',
                class_two:'',
                barcode:'',
                weight:'',
                integral:'',
                stock:'',
                product_name:'',
                unit:'',
                cover:[],
                price:'',
                market_price:'',
                details:'',
                order:'',
                specifications:'',
                dull_cycle:'',
                approval_number:'',
                manufacturer:'',
                shelf_life:''
            },
            upload:{
                headers: { Authorization: "Bearer " + getToken() },
                url: process.env.VUE_APP_BASE_API + "/dealer/assets/material/uploadImg",//七牛云地址
            },
            queryClassParams:{
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
            rule:{
                code:[
                    { required: true, message: "请输入产品编号", trigger: "blur" },
                ],
                stock:[
                    { required: true, message: "请输入产品库存", trigger: "blur" },
                ],
                product_name:[
                    { required: true, message: "请输入产品名称", trigger: "blur" },
                ],
                cover:[
                    { required: true, message: "请上传产品图片", trigger: "blur" },
                ],
                price:[
                    { required: true, message: "请输入产品价格", trigger: "blur" },
                ],
            }
        }
    },
    computed:{
        active(){
            return function (value){
                return this.form.covers.map(item=>item.name).includes(value.img_name)
            }
        }
    },
    created(){
        this.product_id=this.$route.query.product_id
        this.getClassList()
        this.getGroupList()
        if(this.product_id){
            this.queryProductInfo()
        }
    },
    methods:{
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
        queryProductInfo(){
            queryProductInfo({id:this.product_id}).then(res=>{
                //查询二级分类
                this.classTwoOptions=this.classOptions.filter(item=>item.id==res.data.class_one).map(it=>it.children)[0]
                console.log(this.classOptions)
                this.$forceUpdate()
                this.form=res.data
                if(this.form.cover){
                    this.form.cover=JSON.parse(this.form.cover)
                }else{
                    this.form.cover=[]
                }
            })
        },
        selectStyle(item,index){
            this.idx=index
        },
        handleClick(){
            this.queryForm.pageNum=1
            this.getImgMaterial()
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
        getImgMaterial(){
            var params=Object.assign({},this.queryForm)
            if(params.img_group=='01') params.img_group=''
            getImgMaterial(params).then(res=>{
                this.imgMaterialList=res.data
                this.total=res.total
            })
        },
        handleSuccess(res,file){
            Loading.service({ fullscreen: true }).close();
            this.form.cover.push({
                name:file.response.key,
                url:file.response.imgPath
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
        handleRemove(item, index) {
            this.form.cover.splice(index,1)
        },
        handlePictureCardPreview(file) {
            this.dialogImageUrl = file.url;
            this.dialogVisible = true;
        },
        async getClassList(){
           await getClassList(this.queryClassParams).then(res=>{
                this.classOptions=res.data
            })
        },
        selectOneClass(val){
            this.classTwoOptions=this.classOptions.filter(item=>item.id==val).map(it=>it.children)[0]
            this.form.class_two=''
        },
        onStart() {
            this.drag = true;
        },
        onEnd() {
            this.drag = false;
        },
        onSubmit(){
            this.$refs["form"].validate(valid => {
                if(valid){
                    var arr=Object.assign({},this.form)
                    arr.cover=JSON.stringify(arr.cover)
                    delete arr.covers
                    saveProduct(arr).then(res=>{
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