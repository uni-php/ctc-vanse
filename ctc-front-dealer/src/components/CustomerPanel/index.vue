<template>
  <div class="customer-box">
    <el-tabs v-model="activeName" @tab-click="handleClick">
        <el-tab-pane label="选择经销商" name='1'>
            <div class="tab-bar">
                <el-form ref="queryForm" :model="queryForm" label-width="100px" :inline="true" size="small">
                    <el-form-item label="经销商编号"  prop="distributor_code">
                        <el-input style="width:220px" v-model="queryForm.distributor_code" placeholder="请输入经销商编号"></el-input>
                    </el-form-item>
                    <el-form-item label="经销商名称"  prop="distributor_name">
                        <el-input style="width:220px"  v-model="queryForm.distributor_name" placeholder="请输入经销商名称"></el-input>
                    </el-form-item>
                     <el-form-item > 
                        <el-button type="primary" icon="el-icon-search" @click="query1">查询</el-button>
                        <el-button icon="el-icon-refresh" @click="reset1('queryForm')">重置</el-button>
                    </el-form-item>
                </el-form>
            </div>
            <!-- 经销商表格 -->
            <el-table
                :data="tableData"
                :header-cell-style="{background:'#FAFAFA',color:'#606266',height:'50px'}"
                border
                stripe
                size="medium"
                class="trace-table"
                style="width: 100%">
                <el-table-column prop="distributor_code" align="center" label="经销商编号"></el-table-column>
                <el-table-column prop="distributor_name" align="center" label="经销商名称"></el-table-column>
                <el-table-column prop="distributor_level" align="center" label="经销商级别" :formatter="level"></el-table-column>
                <el-table-column prop="person" align="center" label="负责人"></el-table-column>
                <el-table-column prop="phone" align="center" label="手机号码"></el-table-column>
                <el-table-column label="操作" align="center" width="200px">
                    <template slot-scope="scope">
                        <el-button
                        size="mini"
                        type="primary"
                        @click="handleSelectCustomer(scope.row)">选择</el-button>
                    </template>
                </el-table-column>
            </el-table>
            <!-- 门店 -->
            <pagination
                v-show="+total>10"
                :total="+total"
                :page.sync="queryForm.pageNum"
                :limit.sync="queryForm.pageSize"
                @pagination="getList"/>
        </el-tab-pane>
        <el-tab-pane label="选择门店" name='2'>
            <div class="tab-bar">
                <el-form ref="queryForm" :model="queryForm" label-width="100px" :inline="true" size="small">
                    <el-form-item label="门店编号"  prop="store_code">
                        <el-input style="width:220px"  v-model="queryForm.store_code" placeholder="请输入门店编号"></el-input>
                    </el-form-item>
                    <el-form-item label="门店名称"  prop="store_name">
                        <el-input style="width:220px"  v-model="queryForm.store_name" placeholder="请输入门店名称"></el-input>
                    </el-form-item>
                    <el-form-item label="门店类型"  prop="type">
                        <el-select style="width:220px" size="small" v-model="queryForm.type" placeholder="请选择类型">
                            <el-option
                                v-for="item in typeOptions"
                                :key="item.id"
                                :label="item.class_name"
                                :value="item.id">
                            </el-option>
                        </el-select>
                    </el-form-item>
                    <el-form-item > 
                        <el-button type="primary" icon="el-icon-search" @click="query">查询</el-button>
                        <el-button icon="el-icon-refresh" @click="reset('queryForm')">重置</el-button>
                    </el-form-item>
                </el-form>
            </div>
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
                <el-table-column prop="address" align="center" label="门店地址"></el-table-column>
                <el-table-column prop="person" align="center" label="负责人"></el-table-column>
                <el-table-column prop="mobile_phone" align="center" label="手机号"></el-table-column>
                <el-table-column prop="type" align="center" label="门店类型" :formatter="type"></el-table-column>
                <el-table-column label="操作" align="center" width="200px">
                    <template slot-scope="scope">
                        <el-button
                        size="mini"
                        type="primary"
                        @click="handleSelectCustomer(scope.row)">选择</el-button>
                    </template>
                </el-table-column>
            </el-table>
            <!-- 门店 -->
            <pagination
                v-show="+total>10"
                :total="+total"
                :page.sync="queryForm.pageNum"
                :limit.sync="queryForm.pageSize"
                @pagination="getList"/>
        </el-tab-pane>
    </el-tabs>
  </div>
</template>

<script>
import {getStoreTypeList,getStoreList} from '@/api/customer/store'
import {
    getDistributorList,
    getDistributorLevelList,
} from '@/api/customer/distributor'
export default {
    data(){
        return{
            dealerData:[],//经销商数据
            storeData:[],//门店
            levelOption:[],//经销商级别选项
            activeName:'1',
            queryForm:{
                time:[],
                distributor_code:'',
                distributor_name:'',
                distributor_level:'',
                superior_dis_id:undefined,
                superior_dis_name:'',
                status:'',
                activeName:'first',
                zone:[],
                store_code:'',
                store_name:'',
                type:'',
                pageNum:1,
                pageSize:10
            },
            queryTypeForm:{
                pageNum:1,
                pageSize:999
            },
            tableData:[],
            typeOptions:[],
            total:0
        }
    },
    created(){
        this.getList()
        this.getDisLevel()
        getStoreTypeList(this.queryTypeForm).then(res=>{
            this.typeOptions=res.data
        })
    },
    methods:{
        getList(){
            var params=Object.assign({},this.queryForm)
            if(!this.queryForm.time||this.queryForm.time.length==0){
                params.startTime=''
                params.endTime=''
            }else{
                params.startTime=this.queryForm.time[0]
                params.endTime=this.queryForm.time[1]
            }
            delete params.time
            params.zone=params.zone.join(',')
            if(this.activeName==1){
                getDistributorList(params).then(res=>{
                    this.tableData=res.data
                    this.total=res.total
                })
            }else{
                getStoreList(params).then(res=>{
                    this.tableData=res.data
                    this.total=res.total
                })
            }
        },
        handleClick(){
            this.tableData=[]
            this.queryForm.pageNum=1
            this.reset('queryForm')
            this.$forceUpdate()
        },
        //门店类型翻译
        type(row){
            return this.typeOptions.filter(item=>item.id==row.type).map(item=>item.class_name)[0]
        },
        level(row){
            return this.levelOption.filter(item=>item.level_order==row.distributor_level).map(item=>item.level_name)[0]
        },
        getDisLevel(){
            getDistributorLevelList({}).then(res=>{
                this.levelOption=res.data
            })
        },
        handleSelectCustomer(row){
            row.activeName=this.activeName
            this.$emit('selectCustomer',row)
        },
        query(){
          this.queryForm.pageNum = 1;
          this.getList();
        },
        reset(formName){
            this.$refs[formName].resetFields();
            this.query()
        },
        query1(){
          this.queryForm.pageNum = 1;
          this.getList();
        },
        reset1(formName){
            this.queryForm.distributor_name=''
            this.queryForm.distributor_code=''
            this.$refs[formName].resetFields();
            this.query()
        },
    }
}
</script>

<style lang="scss" scoped>

</style>