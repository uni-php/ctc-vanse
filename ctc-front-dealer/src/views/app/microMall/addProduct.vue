<template>
  <div class="app-container">
      <el-form :model="form" ref="form" class="form" label-width="120px" :rules="rule" size="medium">
           <el-form-item prop="goods_name" label="商品名称：" >
                <el-input style="width:80%" @focus="clickProduct" v-model="form.goods_name" placeholder="请选择商品"/>
            </el-form-item>
           <el-form-item label="商品图片：" prop="cover">
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
            <el-form-item label="一级分类：" prop="class_one">
                <el-select style="width:80%" @change="selectOneClass" v-model="form.class_one" placeholder="请选择产品分类">
                    <el-option
                        v-for="item in classOptions"
                        :key="item.id"
                        :label="item.class_name"
                        :value="item.id">
                    </el-option>
                 </el-select>
            </el-form-item>
            <el-form-item label="二级级分类：" prop="class_two">
                <el-select style="width:80%" v-model="form.class_two" placeholder="请选择产品分类">
                    <el-option
                        v-for="item in classTwoOptions"
                        :key="item.id"
                        :label="item.class_name"
                        :value="item.id">
                    </el-option>
                </el-select>
            </el-form-item>
            <el-form-item label="运费模板：" prop="freight_id">
                <el-select style="width:80%" v-model="form.freight_id" placeholder="请选择运费模板">
                    <el-option
                        v-for="item in freightOptions"
                        :key="item.id"
                        :label="item.tpl_name"
                        :value="item.id">
                    </el-option>
                </el-select>
            </el-form-item>
            <el-form-item label="商品价格：" prop="sale_price">
                <el-input style="width:80%" v-model="form.sale_price" placeholder="请输入商品价格"/>
            </el-form-item>
            <el-form-item label="商品划线价：" prop="original_price">
                <el-input style="width:80%" v-model="form.original_price" placeholder="请输入商品划线价"/>
            </el-form-item>
            <el-form-item label="购物送积分：" prop="score">
                <el-input style="width:80%" v-model="form.score" placeholder="请输入商品积分"/>
            </el-form-item>
            <el-form-item label="销量：" prop="sales">
                <el-input style="width:80%" v-model="form.sales" placeholder="请输入商品销量"/>
            </el-form-item>
            <el-form-item label="佣金计算方式：" prop="commission_type">
                <el-radio-group v-model="form.commission_type">
                    <el-radio v-for="(item,index) in commissionTypeOptions" :key="index" :label="item.dict_value">{{item.dict_label}}</el-radio>
                </el-radio-group>
            </el-form-item>
            <el-form-item label="一级分销：" prop="distribution_one">
                <el-input style="width:80%" placeholder="0.00" v-model="form.distribution_one" @change="calculation">
                    <template slot="append">{{form.commission_type==1?'%':'￥'}}</template>
                </el-input>
                <span>(填写“0”代表该商品不参与分销返佣)</span>
            </el-form-item>
            <el-form-item label="二级分销：" prop="distribution_two">
                <el-input style="width:80%" placeholder="0.00" v-model="form.distribution_two" @change="calculation">
                    <template slot="append">{{form.commission_type==1?'%':'￥'}}</template>
                </el-input>
            </el-form-item>
            <el-form-item label="预计佣金明细：">
                <p>一级佣金：￥{{commission_one}}</p>
                <p>二级佣金：￥{{commission_two}}</p>
                <p>合计佣金：￥{{commission_sum}}</p>
                <p>预计佣金仅供参考，实际佣金可能会受促销、打折活动的影响而不同。</p>
            </el-form-item>
            <el-form-item label="产品详情：" prop="details">
                <QiniuEditor v-model="form.details" style="width:80%" :min-height="300"/>
            </el-form-item>
             <el-form-item>
                <el-button type="primary" size="medium" @click="onSubmit">保存</el-button>
                <el-button size="medium" @click="goBack">返回</el-button>
            </el-form-item>
      </el-form>
        <el-dialog title="选择产品" :visible.sync="productDialog" width="80%" @close="productDialog=false">
            <ProductPanel @selectProduct="selectProduct" />
        </el-dialog>
         <el-dialog title="素材库" :visible.sync="imgDialog" width="80%" @close="imgDialog=false">
            <ImgPanel @selectImg="selectImg" :count=5 v-if="hackReset" />
            <div slot="footer" class="dialog-footer">
                <el-button type="primary" @click="submitImg">确 定</el-button>
                <el-button @click="imgDialog=false">取 消</el-button>
            </div>
        </el-dialog>
       <el-dialog :visible.sync="dialogVisible">
        <img width="100%" :src="dialogImageUrl" alt="">
      </el-dialog>
  </div>
</template>

<script>
import ProductPanel from '@/components/ProductPanel'
import {getTpl} from '@/api/system/sys/freight'
import {getClassList,saveGoods,queryGoodsInfo} from '@/api/app/mall'
import ImgPanel from '@/components/ImgPanel'
import  vuedraggable from "vuedraggable";
import Decimal from "decimal.js"  // 具体文件中引入
export default {
     components:{
        ProductPanel,
        vuedraggable,
        ImgPanel
    },
    data(){
        return{
            idx:undefined,
            hackReset:false,
            commission_one:0,
            commission_two:0,
            commission_sum:0,
            form:{
                cover:[],
                goods_name:'',
                product_id:'',
                class_one:'',
                class_two:'',
                freight_id:'',
                sale_price:'',
                original_price:'',
                score:'',
                sales:0,
                commission_type:'1',
                distribution_one:'',
                distribution_two:'',
                details:''
            },
            classOptions:[],
            classTwoOptions:[],
            productDialog:false,
            imgDialog:false,
            rule:{
                goods_name:[
                    { required: true, message: "商品名称不能为空", trigger: "blur" },
                ],
                cover:[
                    { required: true, message: "商品图片不能为空", trigger: "blur" },
                ],
                sale_price:[
                    { required: true, message: "商品价格不能为空", trigger: "blur" },
                ],
                original_price:[
                    { required: true, message: "商品划线价不能为空", trigger: "blur" },
                ],
                class_one:[
                     { required: true, message: "商品分类不能为空", trigger: "blur" },
                ],
                class_two:[
                    { required: true, message: "商品分类不能为空", trigger: "blur" },
                ],
                freight_id:[
                    { required: true, message: "运费模板不能为空", trigger: "blur" },
                ]
            },
            queryClassParams:{
                pageNum:1,
                pageSize:999
            },
            queryParams:{
                pageNum:1,
                pageSize:999
            },
            freightOptions:[],
            commissionTypeOptions:[],
            imgList:[],
            dialogImageUrl:undefined,
            dialogVisible:false,
            goods_id:undefined
        }
    },
    created(){
        this.getClassList()
        this.getFreightTpl()
        this.getDicts({type:'mall_commission_type'}).then(res=>{
            this.commissionTypeOptions=res.data
        })
        this.goods_id=this.$route.query.goods_id
        if(this.goods_id){
            this.queryGoodsInfo()
        }
    },
    methods:{
        queryGoodsInfo(){
            queryGoodsInfo({goods_id:this.goods_id}).then(res=>{
                this.form=res.data
                this.form.class_one=Number(this.form.class_one)
                this.form.class_two=Number(this.form.class_two)
                this.classTwoOptions=this.classOptions.filter(item=>item.id==this.form.class_one).map(it=>it.children)[0]
                this.$forceUpdate()
            })
        },
        selectCover(){
            this.imgDialog=true
            this.imgList=[]
            this.hackReset = false
            this.$nextTick(() => {
            this.hackReset = true
            })
        },
        calculation(){
            if(this.form.commission_type=='1'){
                this.commission_one=this.form.distribution_one*0.01*this.form.sale_price
                this.commission_two=this.form.distribution_two*0.01*this.form.sale_price
            }else{
                this.commission_one=this.form.distribution_one
                this.commission_two=this.form.distribution_two
            }
            this.commission_sum=new Decimal(this.commission_one).add(new Decimal(this.commission_two))
        },
        getFreightTpl(){
            getTpl(this.queryParams).then(res=>{
                this.freightOptions=res.data
            })
        },
        getClassList(){
            getClassList(this.queryClassParams).then(res=>{
                this.classOptions=res.data
            })
        },
        selectOneClass(val){
            this.form.class_two=''
            this.classTwoOptions=this.classOptions.filter(item=>item.id==val).map(it=>it.children)[0]
        },
        selectProduct(row){
            //将商品信息回传到表单
            this.form.cover=[]
            this.productDialog=false
            this.form={
                product_id:row.id,
                goods_name:row.product_name,
                sale_price:row.price,
                original_price:row.market_price,
                score:row.integral,
                distribution_one:0,
                distribution_two:0,
                details:row.details,
                commission_type:'1',
                sales:0,
                code:row.code,
                cover:JSON.parse(row.cover)
            }
        },
        submitImg(){
            this.form.cover=this.form.cover.concat(this.imgList)
            this.imgDialog=false
        },
        selectImg(list){
            this.imgList=list
        },
        clickProduct(){
            this.productDialog=true
        },
        handlePictureCardPreview(file) {
            this.dialogImageUrl = file.url;
            this.dialogVisible = true;
        },
        handleRemove(item,index){
            this.form.cover.splice(index,1)
        },
         selectStyle(item,index){
            this.idx=index
        },
        goBack(){
            this.close()
        },
        onSubmit(){
            this.$refs["form"].validate(valid => {
                if(valid){
                    saveGoods(this.form).then(res=>{
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
</style>
