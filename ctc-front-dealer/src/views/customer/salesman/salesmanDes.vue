<template>
  <div class="app-container">
    <el-form :model="form" ref="form" label-width="140px" :rules="rule" size="medium">
        <el-form-item prop="salesman_code" label="业务员编号" >
            <el-input style="width:80%" :readonly="form.id?true:false" v-model="form.salesman_code" placeholder="请输入业务员编号"></el-input>
        </el-form-item>
         <el-form-item prop="username" label="业务员姓名" >
            <el-input style="width:80%" v-model="form.username" placeholder="请输入业务员姓名"></el-input>
        </el-form-item>
         <el-form-item prop="phone" label="手机号" >
            <el-input style="width:80%" v-model="form.phone" placeholder="请输入手机号"></el-input>
        </el-form-item>
        <el-form-item prop="password" label="密码" >
            <el-input style="width:80%" v-model="form.password" placeholder="请输入密码"></el-input>
        </el-form-item>
        <el-form-item prop="type" label="员工类型" >
            <el-select style="width:80%" size="small" v-model="form.type" placeholder="请选择类型">
                <el-option
                    v-for="item in typeOptions"
                    :key="item.id"
                    :label="item.class_name"
                    :value="item.id">
                </el-option>
            </el-select>
        </el-form-item>
        <el-form-item prop="remark" label="备注" >
            <el-input style="width:80%" v-model="form.remark" placeholder="请输入备注"></el-input>
        </el-form-item>
        <el-form-item prop="region">
            <div slot="label">
                管理范围
                <el-tooltip class="item" effect="dark" content="可同时使用指定区域和指定人员管理两种方式或只使用一种方式,选中两种方式即选中指定的区域管理后,该区域内所有的经销商或门店均可管理,然后可再选中指定区域外的部分经销商或门店进行管理" placement="top">
                    <i class="el-icon-info"></i>
                </el-tooltip>
            </div>
            <el-checkbox-group v-model="form.region">
                <el-checkbox label="1">指定区域管理</el-checkbox>
                <el-checkbox label="2">指定客户管理</el-checkbox>
            </el-checkbox-group>
        </el-form-item>
        <el-form-item label="管理区域" prop="sale_address" v-if="form.region.includes('1')">
            <el-cascader
                style="width:80%"
                v-model="form.zone"
                :options="zoneOptions"
                :props="zoneProps"
                @change="handleChangeZone"></el-cascader>
            <!-- <el-button style="margin-left:10px" type="primary" size="medium" @click="handleSelectSaleArea">添加</el-button> -->
        </el-form-item>
         <!-- <el-form-item label="已选管理区域" prop="sale_address" v-if="form.region.includes('1')">
            <div v-if="select_sale_address.length>0">
                <el-tag style="margin-right:10px" size="small" :closable="form.id?true:false"  @close="handleClose(item)" v-for="(item,index) of select_sale_address" :key="index">{{item+'  '}}</el-tag>
            </div>
            <div v-else>
                <span>暂无</span>
            </div>
        </el-form-item> -->
        <!-- 选择客户管理 -->
        <template v-if="form.region.includes('2')">
            <div class="tips">
                <p>提示：选择该员工可管理的经销商和门店</p>
            </div>
            <el-tabs v-model="activeName" type="card" @tab-click="handleClick" style="margin-bottom:30px">
                <el-tab-pane label="经销商" name="distributor">
                    <el-col :span="24" style="margin:10px 0;">
                        <el-button @click="addDistributor" type="primary" size="small" >添加经销商</el-button>
                        <el-button @click="handleRemoveAll" :disabled="selected_dis_remove.length==0" type="primary" size="small" >移除</el-button>
                    </el-col>
                    <el-table
                        :data="selectedTableData"
                        @selection-change="handleSelectionChangeRemove"
                        :header-cell-style="{background:'#FAFAFA',color:'#606266',height:'50px'}"
                        border
                        stripe
                        size="small"
                        class="trace-table"
                        style="width: 100%">
                        <el-table-column type="selection" width="55"></el-table-column>
                        <el-table-column prop="distributor_code" align="center" label="经销商编号"></el-table-column>
                        <el-table-column prop="distributor_name" align="center" label="经销商名称"></el-table-column>
                        <el-table-column prop="distributor_level" align="center" label="经销商级别" :formatter="level"></el-table-column>
                        <el-table-column prop="phone" align="center" label="手机号"></el-table-column>
                        <el-table-column prop="person" align="center" label="负责人"></el-table-column>
                        <el-table-column prop="is_disable" align="center" label="状态">
                            <template slot-scope="scope">
                                <span>{{scope.row.is_disable==0?'正常':'禁用'}}</span>
                            </template>
                        </el-table-column>
                        <el-table-column label="操作" align="center" width="120px">
                            <template slot-scope="scope">
                                <el-button
                                    size="mini"
                                    type="primary"
                                    @click="handleRemove(scope.row)">移除</el-button>
                            </template>
                        </el-table-column>
                    </el-table>
                    <pagination
                    v-show="+total>10"
                    :total="+total"
                    :page.sync="queryDisidFrom.pageNum"
                    :limit.sync="queryDisidFrom.pageSize"
                    @pagination="getSelectDis"/>
                </el-tab-pane>
                <el-tab-pane label="门店" name="store">
                    <el-col :span="24" style="margin:10px 0;">
                        <el-button @click="addStore" type="primary" size="small" >添加门店</el-button>
                        <el-button @click="handleRemoveAllStore" :disabled="selected_store_remove.length==0" type="primary" size="small" >移除</el-button>
                    </el-col>
                    <el-table
                        :data="selectedStoreTableData"
                        @selection-change="handleSelectionChangeStoreRemove"
                        :header-cell-style="{background:'#FAFAFA',color:'#606266',height:'50px'}"
                        border
                        stripe
                        size="small"
                        class="trace-table"
                        style="width: 100%">
                        <el-table-column type="selection" width="55"></el-table-column>
                        <el-table-column prop="store_code" align="center" label="门店编号"></el-table-column>
                        <el-table-column prop="store_name" align="center" label="门店名称"></el-table-column>
                        <el-table-column prop="address" align="center" label="门店地址"></el-table-column>
                        <el-table-column prop="person" align="center" label="负责人"></el-table-column>
                        <el-table-column prop="mobile_phone" align="center" label="手机号"></el-table-column>
                        <el-table-column prop="type" align="center" label="门店类型" :formatter="store_type"></el-table-column>
                        <el-table-column prop="status" align="center" label="状态" :formatter="store_status"></el-table-column>
                        <el-table-column label="操作" align="center" width="120px">
                            <template slot-scope="scope">
                                <el-button
                                    size="mini"
                                    type="primary"
                                    @click="handleRemoveStore(scope.row)">移除</el-button>
                            </template>
                        </el-table-column>
                    </el-table>
                    <pagination
                    v-show="+totals>10"
                    :total="+totals"
                    :page.sync="queryStoreidFrom.pageNum"
                    :limit.sync="queryStoreidFrom.pageSize"
                    @pagination="getSelectStore"/>
                </el-tab-pane>
            </el-tabs>
        </template>
        <el-form-item style="margin-top:20px">
            <el-button  type="primary" @click="onSubmit">保存</el-button>
        </el-form-item>
    </el-form>
    <!-- 添加经销商 -->
    <el-dialog title="添加经销商" :visible.sync="disVisible" width="75%" @close="disVisible=false">
        <div class="tab-bar">
            <el-form ref="queryDisForm" :model="queryDisForm" label-width="100px" :inline="true" size="small">
                <el-form-item label="经销商编号" prop="distributor_code">
                    <el-input style="width:180px" v-model="queryDisForm.distributor_code" placeholder="请输入经销商编号"></el-input>
                </el-form-item>
                <el-form-item label="经销商名称" prop="distributor_name">
                    <el-input style="width:180px" v-model="queryDisForm.distributor_name" placeholder="请输入经销商名称"></el-input>
                </el-form-item>
                <el-form-item label="经销商级别" prop="distributor_level">
                    <el-select style="width:180px" size="small" v-model="queryDisForm.distributor_level" placeholder="请选择经销商级别">
                        <el-option
                            v-for="item in levelOption"
                            :key="item.id"
                            :label="item.level_name"
                            :value="item.id">
                        </el-option>
                    </el-select>
                </el-form-item>
                <el-form-item >
                    <el-button type="primary" icon="el-icon-search" @click="queryDis">查询</el-button>
                    <el-button type="primary" @click="reset('queryDisForm')">重置</el-button>
                </el-form-item>
            </el-form>
        </div>
        <el-col :span="24" style="margin:0 0 10px 0;">
            <el-button :disabled="selected_dis.length==0" @click="handleSelectAll" type="primary" size="small" >添加</el-button>
            <div style="margin-top:10px">提示：经销商资料请在【客户】-【经销商管理】中添加、管理。</div>
        </el-col>
        <el-table
            :data="selectTableData"
            @selection-change="handleSelectionChange"
            :header-cell-style="{background:'#FAFAFA',color:'#606266',height:'50px'}"
            border
            stripe
            size="medium"
            class="trace-table"
            style="width: 100%">
            <el-table-column type="selection" width="55"></el-table-column>
            <el-table-column prop="distributor_code" align="center" label="经销商编号"></el-table-column>
            <el-table-column prop="distributor_name" align="center" label="经销商名称"></el-table-column>
            <el-table-column prop="distributor_level" align="center" label="经销商级别" :formatter="level"></el-table-column>
            <el-table-column prop="phone" align="center" label="手机号"></el-table-column>
            <el-table-column prop="person" align="center" label="负责人"></el-table-column>
            <el-table-column label="操作" align="center" fixed="right" width="120px">
                <template slot-scope="scope">
                    <el-button
                        size="mini"
                        type="primary"
                        @click="handleSelect(scope.row)">选择</el-button>
                </template>
            </el-table-column>
        </el-table>
    </el-dialog>
    <!-- 添加门店 -->
    <el-dialog title="添加门店" :visible.sync="storeVisible" width="75%" @close="storeVisible=false">
        <div class="tab-bar">
            <el-form ref="queryStoreForm" :model="queryStoreForm" label-width="100px" :inline="true" size="small">
                <el-form-item label="门店编号" prop="store_code">
                    <el-input style="width:180px" v-model="queryStoreForm.store_code" placeholder="请输入门店编号"></el-input>
                </el-form-item>
                <el-form-item label="门店名称" prop="store_name">
                    <el-input style="width:180px" v-model="queryStoreForm.store_name" placeholder="请输入门店名称"></el-input>
                </el-form-item>
                <el-form-item label="门店类型" prop="type">
                    <el-select style="width:180px" size="small" v-model="queryStoreForm.type" placeholder="请选择类型">
                        <el-option
                            v-for="item in storeTypeOptions"
                            :key="item.id"
                            :label="item.class_name"
                            :value="item.id">
                        </el-option>
                    </el-select>
                </el-form-item>
                <el-form-item label="关键词" prop="keywords">
                    <el-input style="width:180px" v-model="queryStoreForm.keywords" placeholder="手机号、负责人"></el-input>
                </el-form-item>
                <el-form-item >
                    <el-button type="primary" icon="el-icon-search" @click="queryStore">查询</el-button>
                    <el-button type="primary" @click="resetStore('queryStoreForm')">重置</el-button>
                </el-form-item>
            </el-form>
        </div>
        <el-col :span="24" style="margin:0 0 10px 0;">
            <el-button :disabled="selected_store.length==0" @click="handleSelectAllStore" type="primary" size="small" >添加</el-button>
            <div style="margin-top:10px">提示：门店资料请【客户】-【门店管理】中添加、管理。。</div>
        </el-col>
        <el-table
            :data="selectStoreTableData"
            @selection-change="handleSelectionStoreChange"
            :header-cell-style="{background:'#FAFAFA',color:'#606266',height:'50px'}"
            border
            stripe
            size="medium"
            class="trace-table"
            style="width: 100%">
            <el-table-column type="selection" width="55"></el-table-column>
            <el-table-column prop="store_code" align="center" label="门店编号"></el-table-column>
            <el-table-column prop="store_name" align="center" label="门店名称"></el-table-column>
            <el-table-column prop="address" align="center" label="地址"></el-table-column>
            <el-table-column prop="mobile_phone" align="center" label="手机号"></el-table-column>
            <el-table-column prop="person" align="center" label="负责人"></el-table-column>
            <el-table-column prop="type" align="center" label="门店类型" :formatter="store_type"></el-table-column>
            <el-table-column label="操作" align="center" fixed="right" width="120px">
                <template slot-scope="scope">
                    <el-button
                        size="mini"
                        type="primary"
                        @click="handleSelectStore(scope.row)">选择</el-button>
                </template>
            </el-table-column>
        </el-table>
    </el-dialog>
  </div>
</template>

<script>
import {getDistributorLevelList,getAvailableDistributor,getDistributorById} from '@/api/customer/distributor'
import {getStoreTypeList,getAvailableStore,getStoreById} from '@/api/customer/store'
import {getSalesmanTypeList,saveSalesman,getSalesmanInfo} from '@/api/customer/salesman'
import{getCustomerAreaList} from '@/api/customer/basics'
export default {
    data(){
        return{
            form:{
                salesman_id:undefined,
                id:undefined,
                salesman_code:'',
                username:'',
                phone:'',
                password:'',
                type:'',
                region:[],//管理范围,
                zone:[],
                remark:''
            },
            rule:{
                salesman_code:[
                    {required: true, message: "请输入业务员编号", trigger: "blur" },
                ],
                username:[
                    {required: true, message: "请输入业务员姓名", trigger: "blur" },
                ],
                phone:[
                    {required: true, message: "请输入业务员手机号", trigger: "blur" },
                ],
                password:[
                    {required: true, message: "请输入业务员密码", trigger: "blur" },
                ],
                type:[
                     {required: true, message: "请输入业务员类型", trigger: "blur" },
                ]
            },
            queryDisForm:{
                distributor_name:'',
                distributor_code:'',
                distributor_level:'',
                pageNum:1,
                pageSize:10
            },
            queryDisidFrom:{
                ids:undefined,
                pageNum:1,
                pageSize:10
            },
            queryStoreidFrom:{
                ids:undefined,
                pageNum:1,
                pageSize:10
            },
            queryStoreForm:{
                store_code:'',
                store_name:'',
                type:'',
                keywords:'',
                pageNum:1,
                pageSize:10
            },
            activeName:'distributor',
            zoneProps:{
                label:'area_name',
                value:'id',
                checkStrictly:true
            },
            storeTypeOptions:[],
            storeStatusOptions:[],
            disVisible:false,
            storeVisible:false,
            selectedTableData:[],//已选经销商
            selectTableData:[],//待选经销商
            selectedStoreTableData:[],
            selectStoreTableData:[],
            total:0,
            totals:0,
            levelOption:[],
            zoneOptions:[],
            originZoneOptions:[],//原始区域数据  非树形结构
            typeOptions:[],
            selected_dis:[],//已选经销商
            selected_store:[],//已选门店
            selected_dis_remove:[],//已选待移除经销商
            selected_store_remove:[],//已选待移除门店
            select_sale_address:[],
            select_sale_address_id:[],
            queryStoreTypeForm:{
                pageNum:1,
                pageSize:999
            },
            queryTypeForm:{
                pageNum:1,
                pageSize:999
            }
        }
    },
    created(){
        this.getZoneList()
        this.getDisLevel()
        getSalesmanTypeList(this.queryTypeForm).then(res=>{
            this.typeOptions=res.data
        })
        getStoreTypeList(this.queryStoreTypeForm).then(res=>{
            this.storeTypeOptions=res.data
        })
        this.getDicts({type:'store_status'}).then(res=>{
            this.storeStatusOptions=res.data
        })
        if(this.$route.query.salesman_id){
            this.salesman_id=this.$route.query.salesman_id
            this.getSalesmanInfo()
        }
    },
    methods:{
        getZoneList(){
            getCustomerAreaList({}).then(res=>{
                this.originZoneOptions=res.data
                this.zoneOptions=this.setTreeLevel(this.handleTree(res.data, "id"),1);
            })
        },
        getDisLevel(){
            getDistributorLevelList({}).then(res=>{
                this.levelOption=res.data
            })
        },
        getSalesmanInfo(){
            getSalesmanInfo({id:this.salesman_id}).then(res=>{
                var arr=Object.assign({},res.data)
                arr.zone=arr.zone.split(',').map(Number)
                arr.region=arr.region.split(',')
                //查询门店与经销商
                this.queryDisidFrom.ids=arr.distributor
                this.queryStoreidFrom.ids=arr.store
                this.getSelectDis()
                this.getSelectStore()
                this.form=arr
            })
        },
        async getSelectDis(){
            await getDistributorById(this.queryDisidFrom).then(res=>{
                this.selectedTableData=res.data
                this.total=res.total
            })
        },
        async getSelectStore(){
            await getStoreById(this.queryStoreidFrom).then(res=>{
                this.selectedStoreTableData=res.data
                this.totals=res.total
            })
        },
        // 取消多选 一个经销商管理一个区域
        handleSelectSaleArea(){
            var zone=this.form.zone
            console.log(zone)
            if(zone.length==0){
                this.$message.warning('请选择区域')
                return
            }
            var selectZone=this.originZoneOptions.filter(item=>zone.includes(item.id)).map(item=>item.area_name).join('-')
            var selectZone_id=this.originZoneOptions.filter(item=>zone.includes(item.id)).map(item=>item.id).join('-')
            var arr=this.select_sale_address.filter(item=>selectZone.indexOf(item)>-1)
            if(arr.length>0){
                this.$message.warning('亲，管理区域不能重复或重叠，请重新选择')
                return;
            }
            this.select_sale_address.push(selectZone)
            this.select_sale_address_id.push(selectZone_id)
        },
        level(row){
            return this.levelOption.filter(item=>item.id==row.distributor_level).map(item=>item.level_name)[0]
        },
         //门店类型翻译
        store_type(row){
            return this.storeTypeOptions.filter(item=>item.id==row.type).map(item=>item.class_name)[0]
        },
        store_status(row){
            return this.storeStatusOptions.filter(item=>item.dict_value==row.status).map(item=>item.dict_label)[0]
        },
        handleSelectAll(){
            var available=this.selected_dis.filter(item=>!this.selectedTableData.map(item=>item.id).includes(item.id))
            this.selectedTableData=this.selectedTableData.concat(available)
            this.disVisible=false
        },
        handleSelectAllStore(){
            var available=this.selected_store.filter(item=>!this.selectedStoreTableData.map(item=>item.id).includes(item.id))
            this.selectedStoreTableData=this.selectedStoreTableData.concat(available)
            this.storeVisible=false
        },
        handleSelect(row){
            var has=this.selectedTableData.filter(item=>item.id==row.id)
            if(has.length>0){
                this.$message.warning('您已选择该经销商，请勿重复添加')
                return;
            }else{
                this.selectedTableData.unshift(row)
                this.disVisible=false
            }
        },
        handleSelectStore(row){
            var has=this.selectedStoreTableData.filter(item=>item.id==row.id)
            if(has.length>0){
                this.$message.warning('您已选择该门店，请勿重复添加')
                return;
            }else{
                this.selectedStoreTableData.unshift(row)
                this.storeVisible=false
            }
        },
        handleRemove(row){
            var arr=this.selectedTableData.filter(item=>item.id!=row.id)
            this.selectedTableData=arr
        },
        handleRemoveStore(row){
            var arr=this.selectedStoreTableData.filter(item=>item.id!=row.id)
            this.selectedStoreTableData=arr
        },
        //移除所有经销商
        handleRemoveAll(){
            var arr=this.selectedTableData.filter(item=>!this.selected_dis_remove.map(item=>item.id).includes(item.id))
            this.selectedTableData=arr
        },
        //移除所有门店
        handleRemoveAllStore(){
            var arr=this.selectedStoreTableData.filter(item=>!this.selected_store_remove.map(item=>item.id).includes(item.id))
            this.selectedStoreTableData=arr
        },
        handleSelectionChange(val){
            this.selected_dis=val
        },
        handleSelectionStoreChange(val){
            this.selected_store=val
        },
        handleSelectionChangeRemove(val){
            this.selected_dis_remove=val
        },
        handleSelectionChangeStoreRemove(val){
            this.selected_store_remove=val
        },
        getDistributorList(){
            getAvailableDistributor(this.queryDisForm).then(res=>{
                this.selectTableData=res.data
            })
        },
        getStoreList(){
            getAvailableStore(this.queryStoreForm).then(res=>{
                this.selectStoreTableData=res.data
            })
        },
        addDistributor(){
            this.disVisible=true
            this.reset('queryDisForm')
            this.selected_dis=[]
            this.selectTableData=[]
        },
        addStore(){
            this.storeVisible=true
            this.resetStore('queryStoreForm')
            this.selected_store=[]
            this.selectStoreTableData=[]
        },
        onSubmit(){
            this.$refs["form"].validate(valid => {
                if(valid){
                    if(this.form.region.includes('2')){
                        if(this.selectedTableData.length==0&&this.selectedStoreTableData.length==0){
                            this.$message.warning('请选择管理客户')
                            return;
                        }
                    }
                    this.form.distributor=this.selectedTableData.map(item=>item.id).join(',')
                    this.form.store=this.selectedStoreTableData.map(item=>item.id).join(',')
                    var arr=Object.assign({},this.form)
                    arr.zone=arr.zone.join(',')//已选区域
                    arr.region=arr.region.join(',')
                    saveSalesman(arr).then(res=>{
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
        handleClick(){

        },
        handleClose(){

        },
        handleChangeZone(val){

        },
        queryDis(){
            this.queryDisForm.pageNum = 1;
            this.getDistributorList();
        },
        reset(formName){
            this.$nextTick(()=>{
                this.$refs[formName].resetFields();
            })
            this.queryDis()
        },
        queryStore(){
            this.queryStoreForm.pageNum = 1;
            this.getStoreList();
        },
        resetStore(formName){
            this.$nextTick(()=>{
                this.$refs[formName].resetFields();
            })
            this.queryStore()
        },
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
</style>
