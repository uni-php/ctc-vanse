<template>
   <div class="app-container">
        <div class="tips">
            <p>直营门店指的是品牌自己的门店，非直营门店指的是加盟店或者由下级经销商管理的门店</p>
        </div>
        <el-tabs v-model="activeName" type="card" @tab-click="handleClick">
            <el-tab-pane label="直营门店" name="first"></el-tab-pane>
            <el-tab-pane label="非直营门店" name="second"></el-tab-pane>
            <el-tab-pane label="申请审核" name="third"></el-tab-pane>
        </el-tabs>
        <div class="tab-bar">
            <el-form ref="queryForm" :model="queryForm" label-width="100px" :inline="true" size="small">
                <el-form-item label="门店编号" prop="store_code">
                    <el-input style="width:220px" v-model="queryForm.store_code" placeholder="请输入门店编号"></el-input>
                </el-form-item>
                <el-form-item label="门店名称" prop="store_name">
                    <el-input style="width:220px" v-model="queryForm.store_name" placeholder="请输入门店名称"></el-input>
                </el-form-item>
                <el-form-item label="门店状态" prop="status">
                    <el-select style="width:220px" size="small" v-model="queryForm.status" placeholder="请选择状态">
                        <el-option
                            v-for="item in statusOptions"
                            :key="item.dict_value"
                            :label="item.dict_label"
                            :value="item.dict_value">
                        </el-option>
                    </el-select>
                </el-form-item>
                <el-form-item label="门店类型" prop="type">
                    <el-select style="width:220px" size="small" v-model="queryForm.type" placeholder="请选择类型">
                        <el-option
                            v-for="item in typeOptions"
                            :key="item.id"
                            :label="item.class_name"
                            :value="item.id">
                        </el-option>
                    </el-select>
                </el-form-item>
                <el-form-item label="门店属性" prop="attribute" v-if="activeName=='second'">
                    <el-select style="width:220px" size="small" v-model="queryForm.attribute" placeholder="请选择属性">
                        <el-option
                            v-for="item in attributeOptions"
                            :key="item.value"
                            :label="item.label"
                            :value="item.value">
                        </el-option>
                    </el-select>
                </el-form-item>
                <el-form-item label="所属经销商" prop="distributor_name" v-if="activeName=='second'">
                    <el-input style="width:220px" v-model="queryForm.distributor_name" @focus="getSuperiorDis" placeholder="请选择所属经销商"></el-input>
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
            <el-button  type="primary" size="small" @click="addStore('is_self')" v-show="activeName=='first'||activeName=='third'">添加直营门店</el-button>
            <el-button  type="primary" size="small" @click="addStore('isnot_self')" v-show="activeName=='second'" >添加非直营门店</el-button>
            <!-- <el-button  type="primary" size="small" v-show="activeName=='first'||activeName=='third'">批量导入直营门店</el-button> -->
            <!-- <el-button  type="primary" size="small" @click="register" v-show="activeName=='first'||activeName=='third'">门店邀请注册</el-button> -->
            <!-- <el-button  type="primary" size="small" v-show="activeName=='second'">批量导入非直营门店</el-button> -->
            <el-button  type="primary" size="small" @click="nearby" >附近门店</el-button>
            <!-- <el-button  type="primary" size="small" @click="handleLogin" >门店登录地址</el-button> -->
        </el-col>
        <!-- 数据表格 -->
         <el-table
            :data="tableData"
            :header-cell-style="{background:'#FAFAFA',color:'#606266',height:'50px'}"
            border
            stripe
            size="medium"
            class="trace-table"
            style="width: 100%">
            <el-table-column prop="store_code" align="center" label="门店编号"></el-table-column>
            <el-table-column prop="store_name" align="center" label="门店名称"></el-table-column>
            <el-table-column prop="type" align="center" label="门店类型" :formatter="type"></el-table-column>
            <el-table-column prop="address" align="center" label="门店地址"></el-table-column>
            <el-table-column prop="person" align="center" label="负责人"></el-table-column>
            <el-table-column prop="mobile_phone" align="center" label="手机号"></el-table-column>
            <el-table-column prop="distributor_name" v-if="activeName=='second'" align="center" label="所属经销商"></el-table-column>
            <el-table-column prop="status" align="center" label="状态" :formatter="status"></el-table-column>
            <el-table-column prop="check_status" v-if="activeName=='third'" align="center" label="审核状态" :formatter="check_status"></el-table-column>
            <el-table-column prop="create_time" align="center" label="添加时间" width="160px"></el-table-column>
            <el-table-column label="操作" align="center" fixed="right" width="360px">
                <template slot-scope="scope">
                    <el-button
                        size="mini"
                        type="primary"
                        v-if="scope.row.check_status==1"
                        >加标签</el-button>
                    <el-button
                        size="mini"
                        type="primary"
                        v-if="scope.row.check_status==1"
                        @click="handleDes(scope.row)">详情</el-button>
                    <el-button
                        size="mini"
                        type="primary"
                        @click="handleEdit(scope.row)">{{scope.row.check_status==1?'编辑':'查看审核'}}</el-button>
                    <el-button
                        size="mini"
                        v-if="scope.row.check_status==1"
                        :type="scope.row.status==1?'primary':'danger'"
                        @click="handleSetStatus(scope.row)">{{scope.row.status=='2'?'启用':'禁用'}}</el-button>
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
        <!-- 详情弹窗 -->
        <el-dialog title="门店详情" :visible.sync="dialogVisible" width="50%" @close="dialogVisible=false">
            <el-descriptions title="详细信息" :column="2" >
                <el-descriptions-item label="门店图片">
                <div class="block" v-for="(item,index) in storeInfo.cover" :key="index">
                    <el-image
                        style="width: 100px; height: 100px"
                        :src="item.url"
                        :preview-src-list="storeInfo.cover.map(item=>item.url)"
                        fit="fill"></el-image>
                </div>
                </el-descriptions-item>
                <el-descriptions-item label="门店编号">{{storeInfo.store_code}}</el-descriptions-item>
                <el-descriptions-item label="门店名称">{{storeInfo.store_name}}</el-descriptions-item>
                <el-descriptions-item label="门店地址">{{storeInfo.address}}</el-descriptions-item>
                <el-descriptions-item label="GPS位置">{{storeInfo.gps}}</el-descriptions-item>
                <el-descriptions-item label="负责人名称">{{storeInfo.person}}</el-descriptions-item>
                <el-descriptions-item label="门店电话">{{storeInfo.telephone}}</el-descriptions-item>
                <el-descriptions-item label="门店账号">{{storeInfo.mobile_phone}}</el-descriptions-item>
                <el-descriptions-item label="人均价格">{{storeInfo.average_price}}</el-descriptions-item>
                <el-descriptions-item label="营业时间">{{storeInfo.time|business_hours}}</el-descriptions-item>
            </el-descriptions>
        </el-dialog>
        <!-- 链接生成二维码网址 -->
        <CopyDialog :copyDialogVisible="copyDialogVisible" :title="copyTitle" :url="copy_url" @close="closeCopyDialog"/>
        <!-- 邀请注册 -->
        <el-dialog title="门店邀请注册" :visible.sync="invitationDialog" width="50%" @close="invitationDialog=false">
            <el-row>
                <el-col :span="8">
                    <div class="qrcode-box">
                        <div class="qrcode" ref="qrCodeUrl"></div>
                        <div class="tip">微信扫一扫立即预览</div>
                    </div>
                </el-col>
                <el-col :span="16">
                    <div class="url-box">
                        <el-form ref="form" :model="inviteForm" label-width="120px" size="medium">
                            <el-form-item label="邀请注册上级" prop="distributor_id">
                                <el-select style="width:80%;" size="small" v-model="inviteForm.distributor_id" @change="changeDistributor" placeholder="请选择经销商">
                                    <el-option
                                        v-for="item in allSuperiorDis"
                                        :key="item.id"
                                        :label="item.distributor_name"
                                        :value="item.id">
                                    </el-option>
                                </el-select>
                            </el-form-item>
                            <el-form-item label="链接地址" prop="url">
                                <el-input v-model="url" readonly="" style="width:80%;" placeholder="请输入内容">
                                    <el-button class="copy" slot="append" :data-clipboard-text="url"  icon="el-icon-document-copy" @click="copy">复制</el-button>
                                </el-input>
                            </el-form-item>
                        </el-form>
                        <div style="margin-left:120px">可将链接复制到您的公众号菜单中</div>
                    </div>
                </el-col>
        </el-row>
        </el-dialog>
   </div>
</template>

<script>
import {
    getDistributorLevelList,
    getSuperiorDistributorList,
    getAllSuperiorDistributorList
} from '@/api/customer/distributor'
import {getStoreTypeList,getStoreList,getStoreInfo,deleStore,changeStoreStatus} from '@/api/customer/store'
import{getCustomerAreaList} from '@/api/customer/basics'
import CopyDialog from '@/components/CopyDialog'
import QRCode from 'qrcodejs2'
import { mapGetters } from 'vuex'
export default {
    components:{
        CopyDialog
    },
    data(){
        return{
            inviteForm:{
                url:'',
                distributor_id:0
            },
            register_url_prefix:'invite.ctc.com?dealer_id=23'+'&distributor_id=',
            invitationDialog:false,
            copyDialogVisible:false,
            copyTitle:'复制链接',
            copy_url:'',
            activeName:'first',
            queryForm:{
                store_code:'',
                store_name:'',
                attribute:'',
                distributor_name:'',
                distributor_id:'',
                type:'',
                status:'',
                zone:[],
                pageNum:1,
                pageSize:10
            },
            attributeOptions:[
                {
                    label:'直属总部',
                    value:1
                },
                {
                    label:'非直属',
                    value:2
                }
            ],
            queryTypeForm:{
                pageNum:1,
                pageSize:999
            },
            zoneOptions:[],
            statusOptions:[],//门店状态
            levelOption:[],//经销商级别选项
            typeOptions:[],
            zoneProps:{
                label:'area_name',
                value:'id',
                checkStrictly:true
            },
            superiorDisVisible:false,
            querySuperiorDisForm:{
                distributor_name:'',
                level_id:'',
                pageNum:1,
                pageSize:10
            },
            tableData:[],
            superiorDis:[],
            allSuperiorDis:[],//所有上级经销商
            total:0,
            totals:0,
            dialogVisible:false,
            storeInfo:{}
        }
    },
    created(){
        this.getList()
        this.getZoneList()
        this.getDisLevel()
        this.getDicts({type:'store_status'}).then(res=>{
            this.statusOptions=res.data
        })
        getStoreTypeList(this.queryTypeForm).then(res=>{
            this.typeOptions=res.data
        })
    },
    computed:{
        url:{
            get:function(){
                this.inviteForm.url=this.register_url_prefix+this.inviteForm.distributor_id
                return this.inviteForm.url
            },
            set:function(value){
                this.inviteForm.url=value
            }
        },
        ...mapGetters([
            'dealer_id'
        ]),
    },
    filters:{
        business_hours:function(value){
            if(!value) return '--'
            return JSON.parse(value).join('~')
        },
        cover:function(value){
            return JSON.parse(value)
        }
    },
    methods:{
        getList(){
            var params=Object.assign({},this.queryForm)
            params.zone=params.zone.join(',')
            params.activeName=this.activeName
            getStoreList(params).then(res=>{
                this.tableData=res.data
                this.total=res.total
            })
        },
        getZoneList(){
            getCustomerAreaList({}).then(res=>{
                this.zoneOptions=this.setTreeLevel(this.handleTree(res.data, "id"),1);
            })
        },
        getDisLevel(){
            getDistributorLevelList({}).then(res=>{
                this.levelOption=res.data
            })
        },
        getSuperiorDis(){
            getSuperiorDistributorList(this.querySuperiorDisForm).then(res=>{
                this.superiorDisVisible=true
                this.superiorDis=res.data
                this.totals=res.total
            })
        },
        handleSelectMain(){
            this.queryForm.distributor_id=0
            this.queryForm.distributor_name='总部'
            this.superiorDisVisible=false
        },
        handleSelect(row){
            this.queryForm.distributor_name=row.distributor_name
            this.queryForm.distributor_id=row.id
            this.superiorDisVisible=false
        },
        level(row){
            return this.levelOption.filter(item=>item.id==row.distributor_level).map(item=>item.level_name)[0]
        },
        closeCopyDialog(val){
            this.copyDialogVisible=val
        },
        //门店类型翻译
        type(row){
            return this.typeOptions.filter(item=>item.id==row.type).map(item=>item.class_name)[0]
        },
        check_status(row){
            return row.check_status==2?'未通过':'待审核'
        },
        status(row){
            return this.statusOptions.filter(item=>item.dict_value==row.status).map(item=>item.dict_label)[0]
        },
        changeDistributor(val){
            this.inviteForm.distributor_id=val
            this.$nextTick(()=>{
                this.creatQrCode()
            })
        },
        querySuperiorDis(){
            this.querySuperiorDisForm.pageNum = 1;
            this.getSuperiorDis();
        },
        addStore(type){
            this.$router.push({path:'/customer/storeDes',query:{type:type}})
        },
        handleEdit(row){
            var type=this.activeName=='first'?'is_self':'isnot_self'
            this.$router.push({path:'/customer/storeDes',query:{type:type,store_id:row.id}})
        },
        handleDes(row){
            getStoreInfo({id:row.id}).then(res=>{
                this.dialogVisible=true
                this.storeInfo=res.data
                this.storeInfo.cover=JSON.parse(res.data.cover)
            })
        },
        handleSetStatus(row){
            this.$confirm(`确定${row.status==1?'禁用':'启用'}该门店`, '提示', {
                confirmButtonText: '确定',
                cancelButtonText: '取消',
                type: 'warning'
            }).then(() => {
                 changeStoreStatus({id:row.id,status:row.status}).then(res=>{
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
            this.$confirm(`确定删除该门店`, '提示', {
                confirmButtonText: '确定',
                cancelButtonText: '取消',
                type: 'warning'
            }).then(() => {
                 deleStore({id:row.id}).then(res=>{
                    if(res.code==200){
                        this.$message.success(res.msg)
                        this.getList()
                    }else{
                        this.$message.error(res.msg)
                    }
                 })
            }).catch(() => {});
        },
        handleClick(){
            this.tableData=[]
            this.reset('queryForm')
        },
        handleLogin(){
            this.copyDialogVisible=true,
            this.copy_url='store.ctc.com'
        },
        nearby(){
          this.copyDialogVisible=true,
          this.copy_url='http://yx.gawxg.com/vicinity/?dealer_id='+this.dealer_id
        },
        register(){
            this.invitationDialog=true
            getAllSuperiorDistributorList({}).then(res=>{
                this.allSuperiorDis=res.data
                //插入总部
                this.allSuperiorDis.unshift({
                    id:0,
                    distributor_name:'总部'
                })
                this.$nextTick(()=>{
                    this.creatQrCode();
                })
            })
        },
        creatQrCode(){
            this.$refs.qrCodeUrl.innerHTML = ''
            var qrcode = new QRCode(this.$refs.qrCodeUrl, {
                text: this.inviteForm.url, // 需要转换为二维码的内容
                width: 120,
                height: 120,
                colorDark: '#000000',
                colorLight: '#ffffff',
                correctLevel: QRCode.CorrectLevel.H
            })
        },
        copy(){
            var clipboard = new this.clipboard('.copy')
            clipboard.on('success', e => {
                this.$message.success('已经复制到剪贴板')
                //  释放内存
               clipboard.destroy();
            })
            clipboard.on('error', e =>{
                // 不支持复制
                this.$message.warning('该浏览器不支持复制')
                // 释放内存
               clipboard.destroy();
            })
        },
        query(){
          this.queryForm.pageNum = 1;
          this.getList();
        },
        reset(formName){
            this.$refs[formName].resetFields();
            this.queryForm.distributor_id=undefined
            this.query()
        },
    }
}
</script>

<style lang="scss" scoped>
.app-container .tips{
    padding: 6px 16px;
    background-color: #ecf8ff;
    border-radius: 4px;
    border-left: 5px solid #50bfff;
    margin: 10px 0;
    p{
        font-size: 14px;
    }
}
.dialog-footer{
  margin: 20px 0;
}
.qrcode-box{
    display: flex;
    justify-content: center;
    align-items: center;
    flex-direction: column;
    border-right: 1px solid #ccc;
    .tip{
        margin-top: 15px;
    }
}
.url-box{
    display: flex;
    justify-content: center;
    height: 150px;
    flex-direction: column;
    padding-left: 20px;
}
.qrcode{
    display: inline-block;
    img {
        width: 132px;
        height: 132px;
        background-color: #fff; //设置白色背景色
        padding: 6px; // 利用padding的特性，挤出白边
        box-sizing: border-box;
    }
}
</style>
