<template>
  <div class="app-container">
    <div class="tab-bar">
        <el-form ref="queryForm" :model="queryForm" label-width="100px" :inline="true" size="small">
            <el-form-item label="标签名" prop="keywords">
                <el-input placeholder="请输入关键字" v-model="queryForm.keywords" class="input-with-select">
                    <el-select v-model="queryForm.keyType" slot="prepend" style="width:100px" placeholder="请选择">
                        <el-option label="微信昵称" value="1"></el-option>
                        <el-option label="用户ID" value="2"></el-option>
                        <el-option label="openid" value="3"></el-option>
                        <el-option label="手机号码" value="4"></el-option>
                    </el-select>
                </el-input>
            </el-form-item>
            <el-form-item label="微信状态" prop="wechat_status">
                <el-select style="width:220px" size="small" v-model="queryForm.wechat_status" placeholder="请选择微信状态">
                    <el-option
                        v-for="item in fansOption"
                        :key="item.dict_value"
                        :label="item.dict_label"
                        :value="item.dict_value">
                    </el-option>
                </el-select>
            </el-form-item>
            <el-form-item label="手机认证" prop="phone_status">
                <el-select style="width:220px" size="small" v-model="queryForm.phone_status" placeholder="请选择手机认证">
                    <el-option
                        v-for="item in phoneOption"
                        :key="item.dict_value"
                        :label="item.dict_label"
                        :value="item.dict_value">
                    </el-option>
                </el-select>
            </el-form-item>
            <el-form-item label="黑名单状态" prop="black_status">
                <el-select style="width:220px" size="small" v-model="queryForm.black_status" placeholder="请选择黑名单状态">
                    <el-option
                        v-for="item in blackOption"
                        :key="item.dict_value"
                        :label="item.dict_label"
                        :value="item.dict_value">
                    </el-option>
                </el-select>
            </el-form-item>
            <el-form-item label="时间" prop="time">
                <el-date-picker
                    style="width:220px"
                    v-model="queryForm.time"
                    type="daterange"
                    unlink-panels=""
                    range-separator="至"
                    value-format="yyyy-MM-dd"
                    start-placeholder="开始日期"
                    end-placeholder="结束日期">
                </el-date-picker>
            </el-form-item>
            <el-form-item label="标签" prop="tag_id">
                <el-select style="width:220px" size="small" v-model="queryForm.tag_id" placeholder="请选择标签">
                    <el-option
                        v-for="item in tagOption"
                        :key="item.wechat_id"
                        :label="item.tag_name"
                        :value="item.wechat_id">
                    </el-option>
                </el-select>
            </el-form-item>
            <el-form-item label="所在地区" prop="address">
                <el-input style="width:220px" v-model="queryForm.address" placeholder="请输入所在地区"></el-input>
            </el-form-item>
            <el-form-item label="排序" prop="order">
                <el-select style="width:220px" size="small" v-model="queryForm.order" placeholder="请选择标签">
                    <el-option
                        v-for="item in orderOption"
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
        <el-table-column prop="id" align="center" label="会员ID"></el-table-column>
        <el-table-column prop="phone" align="center" label="手机号码">
            <template slot-scope="scope">
                <span>{{scope.row.phone||'未获取'}}</span>
            </template>
        </el-table-column>
        <el-table-column prop="headimgurl" align="center" label="微信头像">
            <template slot-scope="scope">
                <el-avatar :size="35" :src="scope.row.headimgurl" @error="errorHandler">
                    <img src="https://cube.elemecdn.com/e/fd/0fc7d20532fdaf769a25683617711png.png"/>
                </el-avatar>
            </template>
        </el-table-column>
        <el-table-column prop="nickname" align="center" label="昵称">
            <template slot-scope="scope">
                <span>{{scope.row.nickname||'未获取'}}</span>
            </template>
        </el-table-column>
        <el-table-column prop="follow_status" align="center" label="关注状态" :formatter="follow_status"></el-table-column>
        <el-table-column prop="follow_status" align="center" label="会员级别"></el-table-column>
        <el-table-column prop="username" align="center" label="姓名"></el-table-column>
        <el-table-column prop="points" align="center" label="积分余额"></el-table-column>
         <el-table-column label="操作" align="center" fixed="right" width="280px">
            <template slot-scope="scope">
                <el-button
                    size="mini"
                    type="primary"
                    @click="addTags(scope.row)">加标签</el-button>
                <el-button
                    size="mini"
                    type="primary"
                    @click="handleDes(scope.row)">详情</el-button>
                <el-button
                    size="mini"
                    type="danger"
                    @click="addPoints(scope.row)">给积分</el-button>
            </template>
         </el-table-column>
    </el-table>
    <pagination
        v-show="+total>10"
        :total="+total"
        :page.sync="queryForm.pageNum"
        :limit.sync="queryForm.pageSize"
        @pagination="getList"/>
    <!-- 添加标签 -->
    <el-dialog title="添加标签" :visible.sync="tagOpen" width="30%" @close="tagOpen=false">
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
    <!-- 给积分 -->
    <el-dialog title="给积分" :visible.sync="jifenOpen" width="30%" @close="jifenOpen=false">
        <el-form :model="jifenForm" ref="jifenForm" label-width="100px" :rules="jifenRule" size="medium">
            <el-form-item label="微信昵称：" prop="nickname">
                <span>{{userInfo.nickname||'未获取微信昵称'}}</span>
            </el-form-item>
            <el-form-item label="积分余额：" prop="points">
                <span>{{userInfo.points}}</span>
            </el-form-item>
            <el-form-item label="积分：" prop="score">
                 <el-input style="width:90%" v-model.number="jifenForm.score" placeholder="请输入积分"></el-input>
                 <div>可输入负数，负数即为扣减</div>
            </el-form-item>
            <el-form-item label="备注：" prop="remark">
                <el-input style="width:90%" v-model="jifenForm.remark" placeholder="请输入备注"></el-input>
            </el-form-item>
        </el-form>
        <div slot="footer" class="dialog-footer">
            <el-button type="primary" @click="submitJifenForm">确 定</el-button>
            <el-button type="primary" @click="jifenOpen=false">取 消</el-button>
        </div>
    </el-dialog>
    <!-- 详情 -->
    <el-dialog title="查看详情" :visible.sync="userInfoDialog" width="60%" @close="userInfoDialog=false">
            <el-tabs type="border-card" v-model="activeName" @tab-click="handleClick">
                <el-tab-pane label="用户资料" name="user-info">
                    <el-descriptions title="基础信息"  :column="2" border>
                        <template slot="extra">
                            <el-button type="primary" size="small" @click="block(memberInfo)">加入黑名单</el-button>
                        </template>
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
                        <div v-if="myTag.length>0">
                            <el-tag closable  style="margin-right:5px" size="small" v-for="(item,index) of myTag" :key="index"  @close="handleClose(item)">{{item.tag_name}}</el-tag>
                        </div>
                        <div v-else>暂无</div>
                        </el-col>
                    </el-row>
                </el-tab-pane>
                <el-tab-pane label="资产记录" name="assets-log">
                    <div class="tab-bar">
                        <el-form ref="queryAssetsForm" :model="queryAssetsForm" label-width="100px" :inline="true" size="small">
                            <el-form-item label="资产类型" prop="assets_type">
                                <el-select style="width:220px"  v-model="queryAssetsForm.assets_type" placeholder="请选择资产类型">
                                    <el-option
                                        v-for="item in assetsTypeOptions"
                                        :key="item.dict_value"
                                        :label="item.dict_label"
                                        :value="item.dict_value">
                                    </el-option>
                                </el-select>
                            </el-form-item> 
                            <el-form-item v-if="queryAssetsForm.assets_type==1" label="红包类型" prop="redpack_type">
                                <el-select style="width:220px"  v-model="queryAssetsForm.redpack_type" placeholder="请选择红包类型">
                                    <el-option
                                        v-for="item in redpackTypeOptions"
                                        :key="item.dict_value"
                                        :label="item.dict_label"
                                        :value="item.dict_value">
                                    </el-option>
                                </el-select>
                            </el-form-item>
                            <el-form-item label="资产来源" prop="assets_source">
                                <el-select style="width:220px"  v-model="queryAssetsForm.assets_source" placeholder="请选择资产来源">
                                    <el-option
                                        v-for="item in assetsSourceOption"
                                        :key="item.dict_value"
                                        :label="item.dict_label"
                                        :value="item.dict_value">
                                    </el-option>
                                </el-select>
                            </el-form-item>
                            <el-form-item label="发送时间" prop="time">
                                <el-date-picker
                                    style="width:220px"
                                    v-model="queryAssetsForm.time"
                                    type="daterange"
                                    unlink-panels=""
                                    range-separator="至"
                                    value-format="yyyy-MM-dd"
                                    start-placeholder="开始日期"
                                    end-placeholder="结束日期">
                                </el-date-picker>
                            </el-form-item>
                            <el-form-item> 
                                <el-button type="primary" icon="el-icon-search" @click="queryAssets">查询</el-button>
                                <el-button icon="el-icon-refresh" @click="resetAssetsQuery('queryAssetsForm')">重置</el-button>
                            </el-form-item> 
                        </el-form>
                    </div>
                    <el-table
                        :data="assetsTableData"
                        :header-cell-style="{background:'#FAFAFA',color:'#606266',height:'50px'}"
                        border
                        stripe
                        size="medium"
                        class="trace-table"
                        style="width: 100%">
                        <el-table-column prop="id" align="center" label="序号"></el-table-column>
                        <el-table-column prop="type" align="center" label="类型" :formatter="assets_type"></el-table-column>
                        <el-table-column prop="number" align="center" label="金额/面值"></el-table-column>
                        <el-table-column prop="app_id" align="center" label="来源" :formatter="assets_source"></el-table-column>
                        <el-table-column prop="create_time" align="center" label="时间"></el-table-column>
                        <el-table-column prop="remark" align="center" label="备注"></el-table-column>
                    </el-table>
                    <pagination
                        v-show="+assetsTotal>10"
                        :total="+assetsTotal"
                        :page.sync="queryAssetsForm.pageNum"
                        :limit.sync="queryAssetsForm.pageSize"
                        @pagination="getAssetsList"/>
                </el-tab-pane>
            </el-tabs>
    </el-dialog>
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
  </div>
</template>
<script>
import {getMemberTagList,getMemberList,batchTagging,addPoints,batchUnTagging,getAssetsList} from '@/api/customer/member'
import {getMemberInfo,blockMember} from '@/api/assets/points'
export default {
    data(){
        return{
            queryForm:{
                keywords:'',
                keyType:'1' ,
                wechat_status:'',
                phone_status:'',
                black_status:'',
                time:[],
                tag_id:'',
                address:'',
                order:'',
                pageNum:1,
                pageSize:10
            },
            queryAssetsForm:{
                assets_type:'',
                assets_source:'',
                redpack_type:'',
                time:[],
                member_id:undefined,
                pageNum:1,
                pageSize:10
            },
            queryTagForm:{
                tag_name:'',
                remark:'',
                pageNum:1,
                pageSize:999
            },
            activeName:'user-info',
            userInfo:{},
            memberInfo:{},
            userInfoDialog:false,
            visible:false,
            myTag:[],
            addTagForm:{
                tag_id:'',
                openid:''
            },
            jifenForm:{
                score:'',
                remark:''
            },
            tagRule:{
                tag_id:[
                    {required: true, message: "请选择标签", trigger: "blur" },
                ],
            },
            jifenRule:{
                score:[
                     {required: true, message: "请输入积分", trigger: "blur" },
                     { type: 'number', message: '数量必须为数字值'}
                ]
            },
            tagOpen:false,
            jifenOpen:false,
            assetsTableData:[],
            assetsTotal:0,
            tableData:[],
            total:0,
            tagOption:[],
            addTagOption:[],
            fansOption:[],
            sexOptions:[],
            assetsTypeOptions:[],//资产类型
            assetsSourceOption:[],
            redpackTypeOptions:[
                {
                    dict_label:'现金红包',
                    dict_value:1
                },
                {
                    dict_label:'企业零钱',
                    dict_value:2
                }
            ],
            phoneOption:[
                {
                    dict_label:'已认证',
                    dict_value:1
                },
                {
                    dict_label:'未认证',
                    dict_value:2
                }
            ],
            orderOption:[
                {
                    dict_label:'按关注时间从早到晚',
                    dict_value:1
                },
                {
                    dict_label:'按关注时间从晚到早',
                    dict_value:2
                },
                {
                    dict_label:'按剩余积分从大到小',
                    dict_value:3
                }
            ],
            blackOption:[
                {
                    dict_label:'正常会员',
                    dict_value:0
                },
                {
                    dict_label:'黑名单会员',
                    dict_value:1
                }
            ]
        }
    },
    computed:{
        sex:function(){
            return this.sexOptions.filter(item=>item.dict_value==this.memberInfo.sex).map(item=>item.dict_label)[0]
        }
    },
    created(){
        this.getList()
        this.getDicts({type:'sys_user_sex'}).then(res=>{
            this.sexOptions=res.data
        })
        this.getDicts({type:'integral_grant_app'}).then(res=>{
            this.assetsSourceOption=res.data
        })
        this.getDicts({type:'assets_type'}).then(res=>{
            this.assetsTypeOptions=res.data
        })
        this.getDicts({type:'official_account_status'}).then(res=>{
            this.fansOption=res.data
        })
        getMemberTagList(this.queryTagForm).then(res=>{
            this.tagOption=res.data
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
            getMemberList(params).then(res=>{
                this.tableData=res.data
                this.total=res.total
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
                        this.handleDes({id:this.memberInfo.id})
                    }else{
                        this.$message.error(res.msg)
                    }
            })
        },
        addTags(row){
            var tag_id=row.tags//客户本身的标签
            this.userInfo=row
            this.addTagForm.tag_id=''
            if(tag_id){
                var addTagOption=this.tagOption.filter(item=>!(tag_id.split(',').includes(item.wechat_id)))
                this.myTag=this.tagOption.filter(item=>tag_id.split(',').includes(item.wechat_id))
            }else{
                var addTagOption=this.tagOption
                this.myTag=[]
            }
            this.addTagOption=addTagOption
            this.tagOpen=true
        },
        submitJifenForm(){
            this.$refs["jifenForm"].validate(valid => {
                if(valid){
                  if(this.jifenForm.score==0){
                      this.$message.warning('积分不能为0')
                      return;
                  }
                  if(this.jifenForm.score*1+this.userInfo.points*1<0){
                      this.$message.warning('积分不足抵扣')
                      return;
                  }
                  this.jifenForm.member_id=this.userInfo.id
                  addPoints(this.jifenForm).then(res=>{
                      if(res.code==200){
                            this.$message.success(res.msg)
                            this.jifenOpen=false
                            this.getList()
                        }else{
                            this.$message.error(res.msg)
                        }
                  })
                }
            })
        },
        submitTagForm(){
            this.$refs["tagForm"].validate(valid => {
                if(valid){
                    var arr={
                        openid:this.userInfo.openid,
                        tag_id:this.addTagForm.tag_id,
                        tags:this.userInfo.tags?this.userInfo.tags+',':''+`${this.addTagForm.tag_id}`
                    }
                    batchTagging(arr).then(res=>{
                        if(res.code==200){
                            this.$message.success(res.msg)
                            this.tagOpen=false
                            this.getList()
                        }else{
                            this.$message.error(res.msg)
                        }
                    })
                }
            })
        },
        handleDes(row){
            getMemberInfo({id:row.id}).then(res=>{
                this.memberInfo=res.data
                if(res.data.tags){
                    var addTagOption=this.tagOption.filter(item=>!(res.data.tags.split(',').includes(item.wechat_id)))
                    this.myTag=this.tagOption.filter(item=>res.data.tags.split(',').includes(item.wechat_id))
                }
                this.addTagOption=addTagOption
                this.userInfoDialog=true
            })
        },
        addPoints(row){
            this.userInfo=row
            this.jifenOpen=true
        },
        block(row){
            this.visible=true
        },
        setBlock(){
            blockMember({id:this.memberInfo.id}).then(res=>{
                if(res.code==200){
                    this.$message.success(res.msg)
                    this.getList()
                    this.visible=false
                }else{
                    this.$message.error(res.msg)
                }
            })
        },
        follow_status(row){
            return this.fansOption.filter(item=>item.dict_value==row.follow_status).map(item=>item.dict_label)[0]
        },
        //资金类型
        assets_type(row){
             return this.assetsTypeOptions.filter(item=>item.dict_value==row.type).map(item=>item.dict_label)[0]
        },
        //资产来源
        assets_source(row){
            return this.assetsSourceOption.filter(item=>item.dict_value==row.app_id).map(item=>item.dict_label)[0]
        },
        //查询资产记录
        getAssetsList(){
            var params=Object.assign({},this.queryAssetsForm)
            if(!this.queryAssetsForm.time||this.queryAssetsForm.time.length==0){
                params.startTime=''
                params.endTime=''
            }else{
                params.startTime=this.queryAssetsForm.time[0]
                params.endTime=this.queryAssetsForm.time[1]
            }
            delete params.time
            params.member_id=this.memberInfo.id
            getAssetsList(params).then(res=>{
                this.assetsTableData=res.data
                this.assetsTotal=res.total
            })
        },
        errorHandler() {
            return true
        },
        query(){
          this.queryForm.pageNum = 1;
          this.getList();
        },
        reset(formName){
            this.$refs[formName].resetFields();
            this.query()
        },
        handleClick(){
            if(this.activeName=='user-info'){
                this.handleDes({id:this.memberInfo.id})
            }else{
                this.getAssetsList()
            }
        },
        queryAssets(){
          this.queryAssetsForm.pageNum = 1;
          this.getAssetsList();
        },
        resetAssetsQuery(formName){
            this.$refs[formName].resetFields();
            this.queryAssets()
        },
    }
}
</script>

<style lang="scss" scoped>
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