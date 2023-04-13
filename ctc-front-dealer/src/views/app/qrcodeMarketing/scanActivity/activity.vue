<template>
  <div class="app-container">
      <div class="tab-bar">
        <el-form ref="queryForm" :model="queryForm" label-width="100px" :inline="true" size="small">
            <el-form-item label="生码批次号" prop="code_batch">
                <el-select style="width:220px" v-model="queryForm.code_batch" placeholder="请选择生码批次">
                    <el-option
                        v-for="item in codeBatchOptions"
                        :key="item.id"
                        :label="item.batch+'--'+'('+item.order_begin+'~'+item.order_end+')'"
                        :value="item.batch">
                    </el-option>
                </el-select>
            </el-form-item>
            <el-form-item label="关键词" prop="keywords">
                <el-input style="width:220px" v-model="queryForm.keywords" placeholder="活动主题/活动编号"></el-input>
            </el-form-item>
            <el-form-item label="状态" prop="status">
                <el-select style="width:220px" v-model="queryForm.status" placeholder="请选择活动状态">
                    <el-option
                        v-for="item in statusOption"
                        :key="item.value"
                        :label="item.label"
                        :value="item.value">
                    </el-option>
                </el-select>
            </el-form-item>
            <el-form-item > 
                <el-button type="primary" icon="el-icon-search" @click="query">查询</el-button>
                <el-button icon="el-icon-refresh" @click="reset('queryForm')">重置</el-button>
            </el-form-item> 
        </el-form>
      </div>
    <el-row>
        <el-col :span="24" style="margin:10px 0;">
            <el-button @click="createActivity" type="primary" size="small" >创建活动</el-button>
        </el-col>
    </el-row>
     <el-table
        :data="tableData"
        :header-cell-style="{background:'#FAFAFA',color:'#606266',height:'50px'}"
        border
        stripe
        size="medium"
        class="trace-table"
        style="width: 100%">
        <el-table-column prop="id" align="center" label="活动编号"></el-table-column>
        <el-table-column prop="activity_name" align="center" label="活动名称"></el-table-column>
        <el-table-column prop="time" align="center" label="活动起止时间">
            <template slot-scope="scope">
                <div>{{scope.row.begin_time}}</div>
                <div>{{scope.row.end_time}}</div>
            </template>
        </el-table-column>
        <el-table-column prop="status" align="center" label="状态" :formatter="status"></el-table-column>
        <el-table-column prop="create_by" align="center" label="创建人"></el-table-column>
        <el-table-column prop="remark" align="center" label="备注"></el-table-column>
        <el-table-column label="操作" align="center" fixed="right" width="240px">
            <template slot-scope="scope">
                <el-button
                    size="mini"
                    type="text"
                    @click="handleView(scope.row)">详情</el-button>
                    <el-button
                    size="mini"
                    type="text"
                    @click="handleSet(scope.row)">{{scope.row.status==0?'启用':'禁用'}}</el-button>
                    <el-button
                    size="mini"
                    type="text"
                    @click="handleEdit(scope.row)">修改</el-button>
                    <el-button
                    size="mini"
                    type="text"
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
    <el-dialog title="活动详情" :visible.sync="desDialog" width="80%" @close="desDialog=false">
        <el-collapse v-model="activeNames" >
            <el-collapse-item title="活动信息" name="1">
                <el-descriptions :column="3">
                    <el-descriptions-item label="活动主题">{{activityInfo.activity_name}}</el-descriptions-item>
                    <el-descriptions-item label="活动时间">{{activityInfo.begin_time}}至{{activityInfo.end_time}}</el-descriptions-item>
                    <el-descriptions-item label="扫码模板">{{activityInfo.tpl_name}}</el-descriptions-item>
                    <el-descriptions-item label="活动参与方式">{{activityInfo.join_condition==1?'关注微信公众号领奖':'直接领奖'}}</el-descriptions-item>
                    <el-descriptions-item label="活动规则">{{activityInfo.is_rule_show==1?'开启':'未开启'}}</el-descriptions-item>
                    <el-descriptions-item label="活动备注">{{activityInfo.remark}}</el-descriptions-item>
                    <el-descriptions-item label="活动区域">{{zone(activityInfo.active_area)}}</el-descriptions-item>
                    <el-descriptions-item label="添加时间">{{activityInfo.create_time}}</el-descriptions-item>
                </el-descriptions>
            </el-collapse-item>
            <el-collapse-item title="活动范围" name="2">
                <el-table
                    :data="activityInfo.code_batch_data"
                    :header-cell-style="{background:'#FAFAFA',color:'#606266',height:'50px'}"
                    border
                    stripe
                    size="small"
                    class="trace-table"
                    style="width: 100%">
                    <el-table-column prop="batch" align="center" label="批次"></el-table-column>
                    <el-table-column prop="order_begin" align="center" label="起始流水号"></el-table-column>
                    <el-table-column prop="order_end" align="center" label="结束流水号"></el-table-column>
                    <el-table-column prop="quantity" align="center" label="区间数量"></el-table-column>
                    <el-table-column prop="remark" align="center" label="备注"></el-table-column>
                </el-table>
            </el-collapse-item>
            <el-collapse-item title="活动奖项" name="3">
                <el-table
                    :data="activityInfo.prize_data"
                    :header-cell-style="{background:'#FAFAFA',color:'#606266',height:'50px'}"
                    border
                    stripe
                    size="small"
                    class="trace-table"
                    style="width: 100%">
                    <el-table-column prop="prize_name" align="center" label="奖项名称"></el-table-column>
                    <el-table-column prop="prize_number" align="center" label="中奖码数量"></el-table-column>
                    <el-table-column prop="prize_rate" align="center" label="中奖比例"></el-table-column>
                    <el-table-column prop="prize_content" align="center" label="奖项内容"></el-table-column>
                    <el-table-column prop="win_num" align="center" label="已中奖数量"></el-table-column>
                </el-table>
            </el-collapse-item>
            <el-collapse-item title="活动策略" name="4">
                <el-tabs v-model="activeName">
                    <el-tab-pane label="数据收集策略" name="first">
                        <el-descriptions :column="1">
                            <el-descriptions-item label="收集字段">{{activityInfo.is_user_info==1?'已开启':'未开启'}}</el-descriptions-item>
                            <el-descriptions-item label="自动打标签">{{activityInfo.is_auth_tag==1?'已开启':'未开启'}}</el-descriptions-item>
                            <el-descriptions-item label="获取用户地理位置">{{activityInfo.is_user_address==1?'已开启':'未开启'}}</el-descriptions-item>
                        </el-descriptions>
                    </el-tab-pane>
                    <el-tab-pane label="用户参与策略" name="second">
                        <el-descriptions :column="1">
                            <el-descriptions-item label="活动参与限制">{{activityInfo.is_join_limit==1?'已开启':'未开启'}}</el-descriptions-item>
                            <el-descriptions-item label="指定用户参与">{{activityInfo.is_user_limit==1?'已开启':'未开启'}}</el-descriptions-item>
                            <el-descriptions-item label="指定地区参与">{{activityInfo.is_address_limit==1?'已开启':'未开启'}}</el-descriptions-item>
                        </el-descriptions>
                    </el-tab-pane>
                </el-tabs>
            </el-collapse-item>
        </el-collapse>
    </el-dialog>
  </div>
</template>

<script>
import {getActivityList,setActivityStatus,deleActivity,getActivityInfo} from '@/api/app/qrcode'
import {getMarketCodeBatch} from '@/api/codeStore/qrcode'
import{getCustomerAreaList} from '@/api/customer/basics'
export default {
    data(){
        return{
            activeNames: ['1'],
            activeName:'first',
            desDialog:false,
            queryForm:{
                code_batch:'',
                keywords:'',
                status:'',
                pageNum:1,
                pageSize:10
            },
            zoneOption:[],
            activityInfo:{},
            codeBatchOptions:[],
            tableData:[],
            total:0,
            codeBatchOption:[],
            statusOption:[
                {
                    label:'未开始',
                    value:0
                },
                {
                    label:'进行中',
                    value:1
                },
                {
                    label:'已结束',
                    value:2
                },
                {
                    label:'已禁用',
                    value:3
                }
            ]
        }
    },
    created(){
        this.getList()
        this.getMarketCodeBatch()
        this.getZoneList()
    },
    methods:{
        getList(){
             getActivityList(this.queryForm).then(res=>{
                this.tableData=res.data
                this.total=res.total
            })
        },
        getZoneList(){
            getCustomerAreaList({}).then(res=>{
                this.zoneOption=res.data.filter(item=>item.parentId==0)
            })
        },
        getMarketCodeBatch(){
            getMarketCodeBatch({}).then(res=>{
               this.codeBatchOptions=res.data 
            })
        },
        zone(val){
            return this.zoneOption.filter(item=>item.id==val).map(item=>item.area_name)[0]
        },
        status(row){
            if(row.status==0) return '未启用'
            if(row.status==2) return '已禁用'
            if(row.status==1){
                //时间判断
                if(this.$dayjs().isBefore(this.$dayjs(row.begin_time))) return '未开始'
                if(this.$dayjs().isAfter(this.$dayjs(row.end_time))) return '已结束'
                return '进行中'
            }
        },
        handleView(row){
            getActivityInfo({id:row.id}).then(res=>{
                this.activityInfo=res.data
                this.desDialog=true
            })
        },
        handleDele(row){
            this.$confirm('确认删除该活动?', '提示', {
                confirmButtonText: '确定',
                cancelButtonText: '取消',
                type: 'warning'
                }).then(() => {
                 deleActivity({id:row.id}).then(res=>{
                    if(res.code==200){
                        this.$message.success(res.msg)
                        this.getList()
                    }else{
                        this.$message.error(res.msg)
                    }
                 })
            }).catch(() => {});
        },
        handleSet(row){
            setActivityStatus({id:row.id,status:row.status}).then(res=>{
                if(res.code==200){
                    this.$message.success(res.msg)
                    this.getList()
                }else{
                    this.$message.error(res.msg)
                }
            })
        },
        createActivity(){
            this.$router.push({path:'/qrcodeMarketing/sacnaAtivity/addActivity'})
        },
        handleEdit(row){
            this.$router.push({path:'/qrcodeMarketing/sacnaAtivity/addActivity',query:{activity_id:row.id}})
        },
        query(){
          this.queryForm.pageNum = 1;
          this.getList();
        },
        reset(formName){
            this.$refs[formName].resetFields();
            this.query()
        },
    }
}
</script>

<style>

</style>