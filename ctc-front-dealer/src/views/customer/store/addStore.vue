<template>
  <div class="app-container">
      <el-form :model="form" ref="form" class="form" label-width="140px" :rules="rule" size="medium">
        <el-form-item prop="store_code" label="门店编号" >
            <el-input style="width:80%" :readonly="form.id?true:false" v-model="form.store_code" placeholder="请输入门店编号"></el-input>
        </el-form-item>
        <el-form-item prop="distributor_name" label="所属经销商" v-if="is_self=='isnot_self'" >
            <el-input style="width:80%" v-model="form.distributor_name" @focus="getSuperiorDis" placeholder="请选择所属经销商"></el-input>
        </el-form-item>
        <el-form-item prop="type" label="门店类型" >
            <el-select style="width:80%" size="small" v-model="form.type" placeholder="请选择状态">
                <el-option
                    v-for="item in typeOptions"
                    :key="item.id"
                    :label="item.class_name"
                    :value="item.id">
                </el-option>
            </el-select>
        </el-form-item>
        <el-form-item prop="address" label="门店地址" >
            <el-cascader
                size="medium"
                style="width:80%"
                :options="options"
                placeholder="请选择地址"
                v-model="selectedOptions"
                @change="handleChange">
            </el-cascader>
        </el-form-item>
        <el-form-item label="详细地址" prop="address">
            <el-input style="width:80%" v-model="form.address" placeholder="请输入详细地址"/>
        </el-form-item>
        <el-form-item label="GPS地址" prop="gps">
            <el-input style="width:80%" v-model="form.gps" @focus="gps" placeholder="请选择GPS地址"/>
        </el-form-item>
        <el-form-item label="门店图片" prop="cover">
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
        <el-form-item label="营业时间" prop="time">
            <el-date-picker
                v-model="form.time"
                type="daterange"
                range-separator="至"
                unlink-panels=""
                format="yyyy 年 MM 月 dd 日"
                value-format="yyyy-MM-dd"
                start-placeholder="开始日期"
                end-placeholder="结束日期">
            </el-date-picker>
        </el-form-item>
        <el-form-item label="门店电话" prop="telephone">
            <el-input style="width:80%" v-model="form.telephone" placeholder="请输入门店电话"/>
        </el-form-item>
        <el-form-item label="手机号" prop="mobile_phone">
            <el-input style="width:80%" v-model="form.mobile_phone" placeholder="请输入手机号"/>
            <div style="color:red">*备注：手机号就是登陆账号</div>
        </el-form-item>
        <el-form-item label="密码" prop="password">
            <el-input style="width:80%" v-model="form.password" placeholder="请输入密码"/>
        </el-form-item>
        <el-form-item label="所属区域" prop="zone">
            <el-cascader
                style="width:80%" 
                v-model="form.zone"
                :options="zoneOptions"
                :props="zoneProps"
                @change="handleChangeZone"></el-cascader>
        </el-form-item>
        <el-collapse v-model="activeNames">
            <el-collapse-item title="拓展信息" name="1">
                <el-form-item label="门店名称" prop="store_name">
                    <el-input style="width:80%"  v-model="form.store_name" placeholder="请输入门店名称"/>
                </el-form-item>
                <el-form-item label="人均价格" prop="average_price">
                    <el-input style="width:80%"  v-model="form.average_price" placeholder="请输入人均价格"/>
                </el-form-item>
                <el-form-item label="门店负责人" prop="person">
                    <el-input style="width:80%"  v-model="form.person" placeholder="请输入门店负责人"/>
                </el-form-item>
                <el-form-item label="门店简介" prop="introduce">
                    <el-input style="width:80%" type="textarea" :autosize="{ minRows: 3, maxRows: 5}" v-model="form.introduce" placeholder="请输入简介"/>
                </el-form-item>
            </el-collapse-item>
            <el-collapse-item title="审核信息" name="2" v-if="check_status!=1">
                <el-form-item label="审核" prop="check_status">
                    <el-radio-group v-model="form.check_status">
                        <el-radio :label="1">通过</el-radio>
                        <el-radio :label="2">未通过</el-radio>
                    </el-radio-group>
                </el-form-item>
            </el-collapse-item>
        </el-collapse>
        <el-form-item style="margin-top:20px">
            <el-button  type="primary" @click="onSubmit">保存</el-button>
        </el-form-item>
      </el-form>
      <!-- 选择门店经纬度 -->
      <el-dialog title="选择经纬度" :visible.sync="gpsVisible" width="50%" @close="gpsVisible=false">
           <TXMap
                :latitude="latitude"
                :longitude="longitude"
                @poiClick="poiClick"
                @addressInfo="addressInfo"
            />
        <div slot="footer" class="dialog-footer">
            <el-button type="primary" @click="saveGps">确 定</el-button>
            <el-button type="primary" @click="gpsVisible=false">取 消</el-button>
        </div>
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
      <el-dialog :visible.sync="dialogVisible">
        <img width="100%" :src="dialogImageUrl" alt="">
      </el-dialog>
       <!-- 经销商列表 -->
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
  </div>
</template>

<script>
import { regionDataPlus,CodeToText, TextToCode } from 'element-china-area-data'
import {getStoreTypeList,saveStore,getStoreInfo} from '@/api/customer/store'
import {getGroupList,getImgMaterial} from '@/api/assets/material'
import {
    getDistributorLevelList,
    getSuperiorDistributorList
} from '@/api/customer/distributor'
import{getCustomerAreaList} from '@/api/customer/basics'
import  vuedraggable from "vuedraggable";
import TXMap from "@/components/TXMap";
export default {
    components:{
        TXMap,
        vuedraggable
    },
    data(){
        return{
            store_id:undefined,
            superiorDisVisible:false,
            superiorDis:[],
            totals:0,
            is_self:undefined,
            activeNames:['1','2'],
            zoneOptions:[],
            active_idx:undefined,
            idx:undefined,
            drag: false,
            group:[],
            tabPosition: 'left',
            latitude:'39.984104',
            longitude:'116.307503',
            check_status:undefined,
            form:{
                id:undefined,
                store_code:'',
                type:'',
                address:'',
                gps:'',
                covers:[],
                cover:[],
                telephone:'',
                time:[],
                password:'',
                mobile_phone:'',
                zone:[],
                store_name:'',
                average_price:'',
                introduce:'',
                distributor_id:'',
                distributor_name:'',
                check_status:1
            },
            rule:{
                store_code:[
                    {required: true, message: "请输入门店编号", trigger: "blur" },
                ],
                address:[
                    {required: true, message: "请输入门店地址", trigger: "blur" },
                ],
                gps:[
                    {required: true, message: "请输入门店GPS地址", trigger: "blur" },
                ],
                cover:[
                    {required: true, message: "请上传门店图片", trigger: "blur" },
                ],
                mobile_phone:[
                    {required: true, message: "请输入门店手机号", trigger: "blur" },
                ],
                password:[
                    {required: true, message: "请输入门店密码", trigger: "blur" },
                ],
                store_name:[
                    {required: true, message: "请输入门店名称", trigger: "blur" },
                ],
                person:[
                    {required: true, message: "请输入门店负责人", trigger: "blur" },
                ],
            },
            zoneProps:{
                label:'area_name',
                value:'id',
                checkStrictly:true
            },
            queryForm:{
                pageNum:1,
                pageSize:20,
                img_group:'01',//默认查询全部图片库
                img_name:'',
            },
            typeOptions:[],
            queryTypeForm:{
                pageNum:1,
                pageSize:999
            },
            queryGroupForm:{
                pageNum:1,
                pageSize:999,
                group_name:''
            },
            imgMaterialList:[],
            levelOption:[],//经销商级别选项
            total:0,
            dialogImageUrl:'',
            dialogVisible:false,
            materialOpen:false,
            gpsVisible:false,
            selectedOptions:["","",""],
            options: regionDataPlus,
            querySuperiorDisForm:{
                distributor_name:'',
                level_id:'',
                pageNum:1,
                pageSize:10
            },
        }
    },
    created(){
        this.getZoneList()
        this.getGroupList()
        this.getDisLevel()
        this.is_self=this.$route.query.type
        getStoreTypeList(this.queryTypeForm).then(res=>{
            this.typeOptions=res.data
        })
        if(this.$route.query.store_id){
            this.store_id=this.$route.query.store_id
            getStoreInfo({id:this.store_id}).then(res=>{
                var arr=Object.assign({},res.data)
                this.form=res.data
                this.form.zone=this.form.zone.split(',').map(Number)
                this.form.cover=JSON.parse(res.data.cover)
                this.form.time=JSON.parse(res.data.time)
                var address=[]
                address[0]=TextToCode[arr.province].code
                address[1]=TextToCode[arr.province][arr.city].code
                address[2]=TextToCode[arr.province][arr.city][arr.district].code
                this.selectedOptions=address
                this.check_status=arr.check_status
            })
        }
    },
    computed:{
        active(){
            return function (value){
                return this.form.covers.map(item=>item.name).includes(value.img_name)
            }
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
        getZoneList(){
            getCustomerAreaList({}).then(res=>{
                this.zoneOptions=this.setTreeLevel(this.handleTree(res.data, "id"),1);
            })
        },
        handleChange(){

        },
        getDisLevel(){
            getDistributorLevelList({}).then(res=>{
                this.levelOption=res.data
            })
        },
         level(row){
            return this.levelOption.filter(item=>item.id==row.distributor_level).map(item=>item.level_name)[0]
        },
         handleSelectMain(){
            this.form.distributor_id=0
            this.form.distributor_name='总部'
            this.superiorDisVisible=false
            this.form.attribute=1//直属总部
        },
         handleSelect(row){
            this.form.distributor_name=row.distributor_name
            this.form.distributor_id=row.id
            this.superiorDisVisible=false
            this.form.attribute=0//非直属
        },
        handleClick(){
            this.queryForm.pageNum=1
            this.getImgMaterial()
        },
        querySuperiorDis(){
            this.querySuperiorDisForm.pageNum = 1;
            this.getSuperiorDis();
        },
        getImgMaterial(){
            var params=Object.assign({},this.queryForm)
            if(params.img_group=='01') params.img_group=''
            getImgMaterial(params).then(res=>{
                this.imgMaterialList=res.data
                this.total=res.total
            })
        },
        saveGps(){
            if(!this.form.gps) return this.$message.warning('请选择GPS地址')
            this.gpsVisible=false
        },
        selectStyle(item,index){
            this.idx=index
        },
        gps(){
            this.gpsVisible=true
        },
        addressInfo(row){
            this.form.gps=`${row.location.lat},${row.location.lat.lng}`
        },
        poiClick(lat,lng){
            this.form.gps=`${lat},${lng}`
        },
         handlePictureCardPreview(file) {
            this.dialogImageUrl = file.url;
            this.dialogVisible = true;
        },
         handleRemove(item, index) {
            this.form.cover.splice(index,1)
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
        getSuperiorDis(){
            getSuperiorDistributorList(this.querySuperiorDisForm).then(res=>{
                this.superiorDisVisible=true
                this.superiorDis=res.data
                this.totals=res.total
            })
        },
        handleChangeZone(val){
        },
        onSubmit(){
            this.$refs["form"].validate(valid => {
                if(valid){
                    if(this.selectedOptions.length==0){
                        this.$message.warning('请选择门店地址')
                        return
                    }
                    var arr=Object.assign({},this.form)
                    arr.province=CodeToText[this.selectedOptions[0]]
                    arr.city=CodeToText[this.selectedOptions[1]]
                    arr.district=CodeToText[this.selectedOptions[2]]
                    arr.zone=arr.zone.join(',')
                    arr.is_self=this.is_self=='is_self'?0:1
                    arr.cover=JSON.stringify(arr.cover)
                    arr.time=JSON.stringify(arr.time)
                    delete arr.covers
                    saveStore(arr).then(res=>{
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
        close() {
            this.$store.dispatch("tagsView/delView", this.$route);
            this.$router.go(-1)
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
    }
}
</script>

<style lang="scss" scoped>
.app-container{
    ::v-deep .el-collapse-item__header{
        background: #eeeeee;
        padding: 0 10px;
        margin: 10px 0;
    }
}
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