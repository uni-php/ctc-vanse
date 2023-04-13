<template>
  <div class="app-container">
    <el-tabs v-model="activeName" type="card" @tab-click="handleClick">
        <el-tab-pane label="积分管理" name="first">
            <el-tabs v-model="firstActiveName" @tab-click="handleAdmin">
                <el-tab-pane label="直营门店" name="first"></el-tab-pane>
                <el-tab-pane label="非直营门店" name="second"></el-tab-pane>
            </el-tabs>
            <div class="tab-bar">
                <el-form ref="queryForm" :model="queryForm" label-width="100px" :inline="true" size="small">
                    <el-form-item label="门店编号" prop="store_code">
                        <el-input style="width:220px" v-model="queryForm.store_code" placeholder="请输入门店编号"></el-input>
                    </el-form-item>
                    <el-form-item label="门店名称" prop="store_name">
                        <el-input style="width:220px" v-model="queryForm.store_name" placeholder="请输入门店名称"></el-input>
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
                <el-table-column prop="type" align="center" label="门店类型" :formatter="store_type"></el-table-column>
                <el-table-column prop="address" align="center" label="门店地址"></el-table-column>
                <el-table-column prop="person" align="center" label="负责人"></el-table-column>
                <el-table-column prop="mobile_phone" align="center" label="手机号"></el-table-column>
                <el-table-column prop="distributor_name" v-if="firstActiveName=='second'" align="center" label="所属经销商"></el-table-column>
                <el-table-column prop="status" align="center" label="状态" :formatter="status"></el-table-column>
                <el-table-column prop="points_num" align="center" label="积分总数"></el-table-column>
                <el-table-column label="操作" align="center" width="150px">
                    <template slot-scope="scope">
                        <el-button
                            size="mini"
                            type="primary"
                            @click="handleSetPoints(scope.row)">加减</el-button>
                    </template>
                </el-table-column>
            </el-table>
            <pagination
                v-show="+total>10"
                :total="+total"
                :page.sync="queryForm.pageNum"
                :limit.sync="queryForm.pageSize"
                @pagination="getList"/>
        </el-tab-pane>
        <el-tab-pane label="积分变动记录" name="second">
            <el-tabs v-model="secondActiveName" @tab-click="handleLog">
                <el-tab-pane label="直营门店" name="is_self"></el-tab-pane>
                <el-tab-pane label="非直营门店" name="isnot_self"></el-tab-pane>
            </el-tabs>
            <div class="tab-bar">
                <el-form ref="queryLogForm" :model="queryLogForm" label-width="100px" :inline="true" size="small">
                    <el-form-item label="时间" prop="time">
                        <el-date-picker
                            style="width:220px"
                            v-model="queryLogForm.time"
                            type="daterange"
                            range-separator="至"
                            unlink-panels=""
                            format="yyyy 年 MM 月 dd 日"
                            value-format="yyyy-MM-dd"
                            start-placeholder="开始日期"
                            end-placeholder="结束日期">
                        </el-date-picker>
                    </el-form-item>
                    <el-form-item label="关键词" prop="keywords">
                        <el-input style="width:220px" v-model="queryLogForm.keywords" placeholder="门店名称、编号、备注"></el-input>
                    </el-form-item>
                    <el-form-item label="门店类型" prop="type">
                        <el-select style="width:220px" size="small" v-model="queryLogForm.type" placeholder="请选择类型">
                            <el-option
                                v-for="item in typeOptions"
                                :key="item.id"
                                :label="item.class_name"
                                :value="item.id">
                            </el-option>
                        </el-select>
                    </el-form-item>
                    <el-form-item label="类型" prop="pm">
                        <el-select style="width:220px" size="small" v-model="queryLogForm.pm" placeholder="请选择类型">
                            <el-option
                                v-for="item in pmOptions"
                                :key="item.value"
                                :label="item.label"
                                :value="item.value">
                            </el-option>
                        </el-select>
                    </el-form-item>
                    <el-form-item > 
                        <el-button type="primary" icon="el-icon-search" @click="queryLog">查询</el-button>
                        <el-button icon="el-icon-refresh" @click="resetLog('queryLogForm')">重置</el-button>
                    </el-form-item>
                </el-form>
            </div>
            <el-table
                :data="logTableData"
                :header-cell-style="{background:'#FAFAFA',color:'#606266',height:'50px'}"
                border
                stripe
                size="medium"
                class="trace-table"
                style="width: 100%">
                <el-table-column prop="store_code" align="center" label="门店编号"></el-table-column>
                <el-table-column prop="store_name" align="center" label="门店名称"></el-table-column>
                <el-table-column prop="type" align="center" label="门店类型" :formatter="store_type"></el-table-column>
                <el-table-column prop="number" align="center" label="积分变动">
                    <template slot-scope="scope">
                        <span>{{scope.row.pm==1?`+${scope.row.number}`:`${scope.row.number}`}}</span>
                    </template>
                </el-table-column>
                <el-table-column prop="pm" align="center" label="类型" :formatter="pm"></el-table-column>
                <el-table-column prop="remark" align="center" label="备注"></el-table-column>
                <el-table-column prop="create_time" align="center" label="时间"></el-table-column>
                <el-table-column prop="create_by" align="center" label="操作人"></el-table-column>
            </el-table>
            <pagination
                v-show="+totals>10"
                :total="+totals"
                :page.sync="queryLogForm.pageNum"
                :limit.sync="queryLogForm.pageSize"
                @pagination="getLogList"/>
        </el-tab-pane>
    </el-tabs>
    <el-dialog title="增减积分" :visible.sync="dialogVisible" width="30%" @close="dialogVisible=false">
        <el-form ref="form" :model="form" label-width="100px" size="small">
            <el-form-item prop="points_num" label="积分量" >
                <el-input-number style="width:80%" v-model="form.points_num" :step="1"></el-input-number>
            </el-form-item>
        </el-form>
        <div slot="footer" class="dialog-footer">
            <el-button type="primary" @click="submitForm">确 定</el-button>
            <el-button type="primary" @click="dialogVisible=false">取 消</el-button>
        </div>
    </el-dialog>
  </div>
</template>

<script>
import {getStoreTypeList,getStoreList,getPointsLog,saveStorePoints} from '@/api/customer/store'
export default {
    data(){
        return{
            total:0,
            totals:0,
            logTableData:[],
            tableData:[],
            form:{
                points_num:0
            },
            activeName:'first',
            firstActiveName:'first',
            secondActiveName:'is_self',
            queryTypeForm:{
                pageNum:1,
                pageSize:999
            },
            typeOptions:[],//门店类型
            statusOptions:[],//门店状态
            dialogVisible:false,
            pmOptions:[
                {
                    label:'支出',
                    value:0
                },
                {
                    label:'获得',
                    value:1
                }
            ],
            queryLogForm:{
                time:[],
                keywords:'',
                type:'',
                pm:'',
                pageNum:1,
                pageSize:10
            },
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
            }
        }
    },
    created(){
        getStoreTypeList(this.queryTypeForm).then(res=>{
            this.typeOptions=res.data
        })
        this.getDicts({type:'store_status'}).then(res=>{
            this.statusOptions=res.data
        })
        this.getList()
    },
    methods:{
        getList(){
            var params=Object.assign({},this.queryForm)
            params.activeName=this.firstActiveName
            params.zone=params.zone.join(',')
            getStoreList(params).then(res=>{
                this.tableData=res.data
                this.total=res.total
            })
        },
        getLogList(){
            var params=Object.assign({},this.queryLogForm)
            if(!this.queryLogForm.time||this.queryLogForm.time.length==0){
                params.startTime=''
                params.endTime=''
            }else{
                params.startTime=this.queryLogForm.time[0]
                params.endTime=this.queryLogForm.time[1]
            }
            delete params.time
            params.is_self=this.secondActiveName=='is_self'?0:1
            getPointsLog(params).then(res=>{
                this.logTableData=res.data
                this.totals=res.total
            })
        },
        submitForm(){
            if(this.form.points_num==0){
                this.$message.warning('积分量不得为零')
                return;
            }
            if(this.form.points_num<0){
                if(this.form.points_num*-1>+this.info.points_num){
                    this.$message.warning('扣减积分量大于该门店总积分')
                    return;
                }
            }
            saveStorePoints({id:this.info.id,points_num:this.form.points_num,store_id:this.info.id}).then(res=>{
                if(res.code==200){
                    this.$message.success(res.msg)
                    this.dialogVisible=false
                    this.getList()
                }else{
                    this.$message.error(res.msg)
                }
            })
        },
        handleClick(){
            if(this.activeName=='first'){
                this.reset('queryForm')
            }else{
                this.resetLog('queryLogForm')
            }
        },
        handleSetPoints(row){
            this.info=row
            this.dialogVisible=true
            this.form.points_num=0
        },
        handleAdmin(){
            this.tableData=[]
            this.reset('queryForm')
        },
        handleLog(){
            this.logTableData=[]
            this.resetLog('queryLogForm')
        },
        store_type(row){
            return this.typeOptions.filter(item=>item.id==row.type).map(item=>item.class_name)[0]
        },
        status(row){
            return this.statusOptions.filter(item=>item.dict_value==row.status).map(item=>item.dict_label)[0]
        },
        pm(row){    
            return this.pmOptions.filter(item=>item.value==row.pm).map(item=>item.label)[0]
        },
        queryLog(){
          this.queryLogForm.pageNum = 1;
          this.getLogList()
        },
        resetLog(formName){
            this.$refs[formName].resetFields();
            this.queryLog()
        },
        query(){
          this.queryForm.pageNum = 1;
          this.getList()
        },
        reset(formName){
            this.$refs[formName].resetFields();
            this.queryForm.distributor_id=undefined
            this.query()
        },
    }
}
</script>

<style>

</style>