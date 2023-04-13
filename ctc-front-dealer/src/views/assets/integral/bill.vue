<template>
  <div class="app-container">
      <div class="tab-bar">
          <el-form ref="queryForm" :model="queryForm" label-width="100px" :inline="true" size="small">
            <el-form-item label="发送时间" prop="time">
                <el-date-picker
                    style="width:240px"
                    v-model="queryForm.time"
                    type="daterange"
                    unlink-panels=""
                    range-separator="至"
                    value-format="yyyy-MM-dd"
                    start-placeholder="开始日期"
                    end-placeholder="结束日期">
                </el-date-picker>
            </el-form-item> 
            <el-form-item label="发放角色" prop="role">
                <el-select style="width:240px"  v-model="queryForm.role" placeholder="请选择发放角色">
                    <el-option
                        v-for="item in roleOptions"
                        :key="item.dict_value"
                        :label="item.dict_label"
                        :value="item.dict_value">
                    </el-option>
                </el-select>
            </el-form-item>
            <el-form-item label="经销商编号" prop="distributor_id">
              <el-input style="width:240px" v-model="queryForm.distributor_id" placeholder="经销商编号"></el-input>
            </el-form-item>
            <el-form-item label="类型" prop="attribute">
                <el-select style="width:240px"  v-model="queryForm.attribute" placeholder="请选择发放类型">
                    <el-option
                        v-for="item in type"
                        :key="item.value"
                        :label="item.label"
                        :value="item.value">
                    </el-option>
                </el-select>
            </el-form-item>
            <el-form-item label="发放应用" prop="app_id">
                <el-select style="width:240px"  v-model="queryForm.app_id" placeholder="请选择积分发放应用">
                    <el-option
                        v-for="item in integralAppOptions"
                        :key="item.dict_value"
                        :label="item.dict_label"
                        :value="item.dict_value">
                    </el-option>
                </el-select>
            </el-form-item>
            <el-form-item label="搜索方式" prop="keywords">
                <el-input placeholder="请输入内容"  style="width:240px" v-model="queryForm.keywords" class="input-with-select">
                    <el-select style="width:100px" v-model="queryForm.type" slot="prepend" placeholder="请选择">
                    <el-option label="会员ID" value="1"></el-option>
                    <el-option label="手机号" value="2"></el-option>
                    <el-option label="openid" value="3"></el-option>
                    </el-select>
                </el-input>
            </el-form-item>
            <el-form-item label="备注" prop="remark">
              <el-input style="width:240px" v-model="queryForm.remark" placeholder="备注"></el-input>
            </el-form-item>
            <el-form-item> 
                <el-button type="primary" icon="el-icon-search" @click="query">查询</el-button>
                <el-button icon="el-icon-refresh" @click="resetQuery('queryForm')">重置</el-button>
            </el-form-item>
          </el-form>
      </div>
      <el-col :span="24" style="margin:10px 0;">
        <el-button @click="handleExport" type="primary" size="small" >导出</el-button>
      </el-col>
      <el-table
        :data="tableData"
        :header-cell-style="{background:'#FAFAFA',color:'#606266',height:'50px'}"
        border
        stripe
        size="medium"
        class="trace-table"
        style="width: 100%">
        <el-table-column prop="id" align="center" label="会员ID">
            <template slot-scope="scope">
                <el-popover
                    placement="top-start"
                    title="会员信息"
                    width="300"
                    trigger="hover"
                    >
                    <div class="user-info">
                        <el-row>
                            <el-col :span="4">
                                <el-avatar :size="40" :src="scope.row.headimgurl" @error="errorHandler">
                                    <img src="https://cube.elemecdn.com/e/fd/0fc7d20532fdaf769a25683617711png.png"/>
                                </el-avatar>
                            </el-col>
                        </el-row>
                        <div>微信昵称：{{scope.row.nickname||'--'}}</div>
                        <div>姓名：{{scope.row.username}}</div>
                        <div>客户ID：{{scope.row.member_id}}</div>
                        <div>OpenID：{{scope.row.openid}}</div>
                        <div>手机号：{{scope.row.phone}}</div>
                        <div>状态：<span style="color:red">{{scope.row.status==1?'已拉黑':'正常'}}</span></div>
                        <div style="text-align:right">
                            <el-button type="text" @click="block(scope.row)" size="small">加入黑名单</el-button>
                            <el-button type="text" style="margin-left:20px" @click="handleUserInfo(scope.row)"  size="small">会员详情</el-button>
                        </div>
                    </div>
                    <span  slot="reference">
                        <el-button type="text" size="small">{{scope.row.member_id}}</el-button>
                    </span>
                </el-popover>
            </template>
        </el-table-column>
        <el-table-column prop="pm" align="center" label="类型">
            <template slot-scope="scope">
               <span>{{scope.row.pm==1?'获得':'消耗'}}</span>
           </template> 
        </el-table-column>
        <el-table-column prop="app_id" align="center" label="发放应用" :formatter="app"></el-table-column>
        <el-table-column prop="number" align="center" label="积分">
            <template slot-scope="scope">
               <span>{{scope.row.pm==1?('+'+scope.row.number):('-'+scope.row.number)}}</span>
           </template> 
        </el-table-column>
        <el-table-column prop="role" align="center" label="发放角色" :formatter="role"></el-table-column>
        <el-table-column prop="remark" align="center" label="备注" show-overflow-tooltip=""></el-table-column>
         <el-table-column prop="create_time" align="center" label="时间"></el-table-column>
      </el-table>
      <pagination
        v-show="+total>10"
        :total="+total"
        :page.sync="queryForm.pageNum"
        :limit.sync="queryForm.pageSize"
        @pagination="getList"/>
        <!-- 加入黑名单 -->
        <el-dialog
            title="提示"
            :visible.sync="visible"
            width="20%"
            center>
            <span>是否将该用户加入黑名单？</span>
            <span slot="footer" class="dialog-footer">
                <el-button @click="visible = false">取 消</el-button>
                <el-button type="primary" @click="setBlock">确 定</el-button>
            </span>
        </el-dialog>
        <!-- 用户资料弹窗 -->
        <el-dialog title="查看详情" :visible.sync="userInfoDialog" width="50%" @close="userInfoDialog=false">
            <el-tabs type="border-card">
                <el-tab-pane label="用户资料">
                    <el-descriptions title="基础信息"  :column="2" border>
                        <el-descriptions-item label="ID">{{memberInfo.id}}</el-descriptions-item>
                        <el-descriptions-item label="OpenID">{{memberInfo.openid}}</el-descriptions-item>
                        <el-descriptions-item label="手机">{{memberInfo.phone}}</el-descriptions-item>
                        <el-descriptions-item label="姓名">{{memberInfo.username}}</el-descriptions-item>
                        <el-descriptions-item label="微信名">{{memberInfo.nickname}}</el-descriptions-item>
                        <el-descriptions-item label="所在地区">{{memberInfo.address}}</el-descriptions-item>
                        <el-descriptions-item label="生日">{{memberInfo.birthday}}</el-descriptions-item>
                        <el-descriptions-item label="身份证号">{{memberInfo.idcard}}</el-descriptions-item>
                        <el-descriptions-item label="微信号">{{memberInfo.wechat}}</el-descriptions-item>
                        <el-descriptions-item label="性别">{{sex}}</el-descriptions-item>
                        <el-descriptions-item label="来源渠道">{{memberInfo.sources}}</el-descriptions-item>
                        <el-descriptions-item label="注册时间">{{memberInfo.create_time}}</el-descriptions-item>
                    </el-descriptions>
                    <el-row>
                        <el-col class="user-info-item">自定义资料</el-col>
                        <el-col class="user-info-content">暂无</el-col>
                    </el-row>
                    <el-descriptions title="资产信息"  :column="2" border>
                        <el-descriptions-item label="余额">{{memberInfo.balance}}</el-descriptions-item>
                        <el-descriptions-item label="积分">{{memberInfo.points}}</el-descriptions-item>
                    </el-descriptions>
                    <el-row>
                        <el-col class="user-info-item">会员标签</el-col>
                        <el-col class="user-info-content">
                        <div>
                            <el-tag closable  style="margin-right:5px" size="small" v-for="(item,index) of myTag" :key="index"  @close="handleClose(item)">{{item.tag_name}}</el-tag>
                            <el-button type="primary" size="mini" @click="addTag">添加标签</el-button>
                        </div>
                        </el-col>
                    </el-row>
                </el-tab-pane>
                <el-tab-pane label="配置管理">资产记录</el-tab-pane>
            </el-tabs>
             <!-- 添加标签 -->
            <el-dialog title="添加标签" :visible.sync="tagOpen" width="30%" @close="tagOpen=false" append-to-body>
                <el-form :model="addTagForm" ref="tagForm" label-width="100px" :rules="tagRule" size="medium">
                    <el-form-item label="标签名称：" prop="tag_id">
                        <el-select style="width:90%" size="small" v-model="addTagForm.tag_id" placeholder="请选择标签">
                            <el-option
                                v-for="item in addTagOption"
                                :key="item.wechat_id"
                                :label="item.tag_name"
                                :value="item.wechat_id">
                            </el-option>
                        </el-select>
                    </el-form-item>
                    <el-form-item label="已有标签：" prop="tag_name">
                        <div v-if="myTag.length>0">
                            <el-tag style="margin-right:5px" size="small" v-for="(item,index) of myTag" :key="index">{{item.tag_name}}</el-tag>
                        </div>
                        <div v-else>暂无</div>
                    </el-form-item>
                </el-form>
                <div slot="footer" class="dialog-footer">
                    <el-button type="primary" @click="submitTagForm">确 定</el-button>
                    <el-button type="primary" @click="tagOpen=false">取 消</el-button>
                </div>
            </el-dialog>
        </el-dialog>
  </div>
</template>

<script>
import {getPointsBill,blockMember,getMemberInfo} from '@/api/assets/points'
import {getMemberTagList,batchTagging,batchUnTagging} from '@/api/customer/member'
export default {
    data(){
        return{
            visible:false,
            addTagForm:{
                tag_id:'',
                openid:''
            },
            queryForm:{
                time:[],
                role:'',
                distributor_id:'',
                type:'1',
                app_id:'',
                attribute:'',
                keywords:'',
                remark:'',
                pageNum:1,
                pageSize:10
            },
            queryTagForm:{
                tag_name:'',
                remark:'',
                pageNum:1,
                pageSize:999
            },
            tagOpen:false,
            tagOption:[],
            memberInfo:[],
            sexOptions:[],
            userInfoDialog:false,
            member_id:undefined,
            tableData:[],
            total:0,
            integralAppOptions:[],
            myTag:[],
            addTagOption:[],
            tagRule:{
                tag_id:[
                    {required: true, message: "请选择标签", trigger: "blur" },
                ],
            },
            type:[
                {
                    label:'获得',
                    value:1
                },
                {
                    label:"消耗",
                    value:2
                }
            ],
            roleOptions:[
                {
                    dict_value:'1',
                    dict_label:'总部'
                },
                {
                    dict_value:'2',
                    dict_label:'经销商'
                }
            ]
        }
    },
    created(){
        this.getList()
        this.getDicts({type:'integral_grant_app'}).then(res=>{
            this.integralAppOptions=res.data
        })
        this.getDicts({type:'sys_user_sex'}).then(res=>{
            this.sexOptions=res.data
        })
        getMemberTagList(this.queryTagForm).then(res=>{
            this.tagOption=res.data
        })
    },
    computed:{
        sex:function(){
            return this.sexOptions.filter(item=>item.dict_value==this.memberInfo.sex).map(item=>item.dict_label)[0]
        }
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
            getPointsBill(params).then(res=>{
                this.tableData=res.data
                this.total=res.total
            })
        },
        handleUserInfo(row){ 
            getMemberInfo({id:row.member_id}).then(res=>{
                this.memberInfo=res.data
                var addTagOption=this.tagOption.filter(item=>!(res.data.tags.split(',').includes(item.wechat_id)))
                this.myTag=this.tagOption.filter(item=>res.data.tags.split(',').includes(item.wechat_id))
                this.addTagOption=addTagOption
                this.userInfoDialog=true
            })
        },
        submitTagForm(){
            this.$refs["tagForm"].validate(valid => {
                if(valid){
                    var arr={
                        openid:this.memberInfo.openid,
                        tag_id:this.addTagForm.tag_id,
                        tags:this.memberInfo.tags+`,${this.addTagForm.tag_id}`
                    }
                    batchTagging(arr).then(res=>{
                        if(res.code==200){
                            this.$message.success(res.msg)
                            this.tagOpen=false
                            this.handleUserInfo({member_id:this.memberInfo.id})
                            this.getList()
                        }else{
                            this.$message.error(res.msg)
                        }
                    })
                }
            })
        },
        handleClose(item){
            var arr={
                openid:this.memberInfo.openid,
                tag_id:item.wechat_id,
                tags:this.memberInfo.tags.split(',').filter(it=>it!=item.wechat_id).join(',')
            }
            batchUnTagging(arr).then(res=>{
                    if(res.code==200){
                        this.$message.success(res.msg)
                        this.handleUserInfo({member_id:this.memberInfo.id})
                    }else{
                        this.$message.error(res.msg)
                    }
            })
        },
        handleExport(){

        },
        addTag(){
            this.addTagForm.tag_id=''
            this.tagOpen=true
        },
        app(row){
            return this.integralAppOptions.filter(item=>item.dict_value==row.app_id).map(item=>item.dict_label)[0]
        },
        role(row){
            return this.roleOptions.filter(item=>item.dict_value==row.role).map(item=>item.dict_label)[0]
        },
        errorHandler() {
            return true
        },
        block(row){
            this.visible=true
            this.member_id=row.member_id
        },
        setBlock(){
            blockMember({id:this.member_id}).then(res=>{
                if(res.code==200){
                    this.$message.success(res.msg)
                    this.getList()
                    this.visible=false
                }else{
                    this.$message.error(res.msg)
                }
            })
        },
        query(){
            this.queryForm.pageNum = 1;
            this.getList();
        },
        resetQuery(formName){
            this.$refs[formName].resetFields();
            this.query()
        }
    }
}
</script>

<style lang="scss" scoped>
.container{
    ::v-deep .el-table__row{
        .cell{
            span{
                width: 30px;
                height: 30px;
                cursor: pointer;
            }
        }
    }
    ::v-deep .user-id{
        color: #409EFF !important;
        cursor: pointer;
    }
    .user-info{
        div{
            margin: 6px 0;
        }
        img{
            width: 40px;
            height: 40px;
        }
    }
}
.user-info-item{
    margin-top: 20px;
    font-size: 16px;
    font-weight: 700;
    color: #303133;
}
.user-info-content{
    margin: 20px 20px 20px 0;
}
</style>