<template>
  <div class="app-container">
    <el-tabs type="border-card" v-model="activeName" @tab-click="handleClick">
        <el-tab-pane name="first" label="品牌商信息">
        </el-tab-pane>
        <el-tab-pane name="second" label="代发红包池">
        </el-tab-pane>
        <div v-if="activeName=='first'">
            <el-collapse v-model="activeNames">
                <el-collapse-item name="1">
                    <template slot="title">
                        <el-tag style="margin:10px 0">基础信息<i class="el-icon-info"></i></el-tag>
                    </template>
                    <el-form style="margin-top:20px" :model="form" ref="form" label-width="140px" size="medium">
                        <el-row>
                            <el-col :span="12">
                                <el-form-item label="品牌商名称:" prop="dealer_name">
                                    <span>{{form.dealer_name}}</span>
                                </el-form-item>
                            </el-col>
                            <el-col :span="12">
                                <el-form-item label="公司名称:" prop="company">
                                    <span>{{form.company}}</span>
                                </el-form-item>
                            </el-col>
                        </el-row>
                        <el-row>
                            <el-col :span="12">
                                <el-form-item label="手机号:" prop="phone">
                                    <span>{{form.phone}}</span>
                                </el-form-item>
                            </el-col>
                            <el-col :span="12">
                                <el-form-item label="联系人:" prop="concact_name">
                                    <span>{{form.concact_name}}</span>
                                </el-form-item>
                            </el-col>
                        </el-row>
                        <el-row>
                            <el-col :span="12">
                                <el-form-item label="账号:" prop="account">
                                    <span>{{form.account}}</span>
                                </el-form-item>
                            </el-col>
                            <el-col :span="12">
                                <el-form-item label="详细地址:" prop="address">
                                    <span>{{form.province}}{{form.city}}{{form.district}}{{form.address}}</span>
                                </el-form-item>
                            </el-col>
                        </el-row>
                        <el-row>
                            <el-col :span="12">
                                <el-form-item label="官方网站:" prop="website">
                                    <span>{{form.website}}</span>
                                </el-form-item>
                            </el-col>
                            <el-col :span="12">
                                <el-form-item label="所属行业:" prop="industry">
                                    <span>{{industry(form.industry)}}</span>
                                </el-form-item>
                            </el-col>
                        </el-row>
                        <el-row>
                            <el-col :span="12">
                                <el-form-item label="E-Mail:" prop="email">
                                    <span>{{form.email}}</span>
                                </el-form-item>
                            </el-col>
                            <el-col :span="12">
                                <el-form-item label="访问环境:" prop="sys_env">
                                    <span>{{sys_env(form.sys_env)}}</span>
                                </el-form-item>
                            </el-col>
                        </el-row>
                        <el-row>
                            <el-col :span="12">
                                <el-form-item label="微信公众号授权:" prop="official_account_auth">
                                    <span>{{form.official_account_auth==0?'未授权':"已授权"}}</span>
                                </el-form-item>
                            </el-col>
                            <el-col :span="12">
                                <el-form-item label="微信小程序授权:" prop="mini_pro_auth">
                                    <span>{{form.mini_pro_auth==0?'未授权':"已授权"}}</span>
                                </el-form-item>
                            </el-col>
                        </el-row>
                        <el-row>
                            <el-col :span="12">
                                <el-form-item label="状态:" prop="dealer_status">
                                    <span>{{form.dealer_status==0?'未授权':form.status==1?'正常':"已禁用"}}</span>
                                </el-form-item>
                            </el-col>
                            <el-col :span="12">
                                <el-form-item label="有效时间:" prop="valid_time">
                                    <span>{{form.validity_begin}}至{{form.validity_end}}</span>
                                </el-form-item>
                            </el-col>
                        </el-row>
                    </el-form>
                </el-collapse-item>
                <el-collapse-item name="2">
                    <template slot="title">
                        <el-tag style="margin:10px 0">功能信息<i class="el-icon-menu"></i></el-tag>
                    </template>
                    <div>已订购功能模块</div>
                    <el-table
                        :data="modules"
                        :header-cell-style="{background:'#FAFAFA',color:'#606266',height:'50px'}"
                        border
                        stripe
                        size="small"
                        class="trace-table"
                        style="width: 100%">
                        <el-table-column prop="module_name" align="center" label="功能模块"></el-table-column>
                        <el-table-column prop="module_retail" align="center" label="费用/年"></el-table-column>
                    </el-table>
                    <div style="margin-top:20px">服务等级</div>
                    <el-card class="box-card">
                        <div class="text item">
                            <div>服务等级：{{serverInfo.service_name}}</div>
                            <div>服务费/年：￥{{serverInfo.service_cost}}</div>
                            <div>服务描述：{{serverInfo.service_des}}</div>
                        </div>
                    </el-card>
                </el-collapse-item>
                <el-collapse-item name="3">
                    <template slot="title">
                        <el-tag style="margin:10px 0">资质信息<i class="el-icon-s-check"></i></el-tag>
                    </template>
                    <!-- 营业执照信息 -->
                    <el-form style="margin-top:20px" :model="form" ref="form" label-width="140px" size="medium">
                        <el-row>
                            <el-col :span="12">
                                <el-form-item label="资质名称:" prop="zizhi_name">
                                    <span>企业营业执照<span style="color:red">{{form.license_status|license_status}}</span></span>
                                </el-form-item>
                            </el-col>
                            <el-col :span="12">
                                <el-form-item label="营业执照号码:" prop="business_license_code">
                                    <span>{{form.business_license_code||'--'}}</span>
                                </el-form-item>
                            </el-col>
                        </el-row>
                        <el-row>
                            <el-col :span="12">
                                <el-form-item label="组织机构代码:" prop="organization_code">
                                    <span>{{form.organization_code||'--'}}</span>
                                </el-form-item>
                            </el-col>
                            <el-col :span="12">
                                <el-form-item label="名称:" prop="company_name">
                                    <span>{{form.company_name||'--'}}</span>
                                </el-form-item>
                            </el-col>
                        </el-row>
                        <el-row>
                            <el-col :span="12">
                                <el-form-item label="类型:" prop="company_type">
                                    <span>{{company_type(form.company_type)}}</span>
                                </el-form-item>
                            </el-col>
                            <el-col :span="12">
                                <el-form-item label="注册地址:" prop="register_address">
                                    <span>{{form.register_address||'--'}}</span>
                                </el-form-item>
                            </el-col>
                        </el-row>
                        <el-row>
                            <el-col :span="12">
                                <el-form-item label="法定代表人:" prop="legal_person">
                                    <span>{{form.legal_person||'--'}}</span>
                                </el-form-item>
                            </el-col>
                            <el-col :span="12">
                                <el-form-item label="注册资本:" prop="capital">
                                    <span>{{form.capital||'--'}}</span>
                                </el-form-item>
                            </el-col>
                        </el-row>
                        <el-row>
                            <el-col :span="12">
                                <el-form-item label="成立日期:" prop="establish_date">
                                    <span>{{form.establish_date||'--'}}</span>
                                </el-form-item>
                            </el-col>
                            <el-col :span="12">
                                <el-form-item label="营业期限:" prop="business_period">
                                    <span>{{business_period(form.business_period)}}</span>
                                </el-form-item>
                            </el-col>
                        </el-row>
                        <el-row>
                            <el-col :span="12">
                                <el-form-item label="营业执照:" prop="business_license_url">
                                    <span v-if="form.business_license_url"><img :src="form.business_license_url" class="avatar"></span>
                                    <span v-else>--</span>
                                </el-form-item>
                            </el-col>
                        </el-row>
                    </el-form>
                    <el-divider></el-divider>
                    <!-- 商标信息 -->
                    <el-form style="margin-top:20px" :model="form" ref="form" label-width="140px" size="medium">
                        <el-row>
                            <el-col :span="12">
                                <el-form-item label="资质名称:" prop="zizhi_name">
                                    <span>中国商标权证书 <span style="color:red">{{form.trademark_status|license_status}}</span></span>
                                </el-form-item>
                            </el-col>
                            <el-col :span="12">
                                <el-form-item label="商标注册号/申请号:" prop="trademark_code">
                                    <span>{{form.trademark_code||'--'}}</span>
                                </el-form-item>
                            </el-col>
                        </el-row>
                        <el-row>
                            <el-col :span="12">
                                <el-form-item label="中国商标权证书:" prop="trademark_cert">
                                    <span v-if="form.trademark_cert"><img :src="form.trademark_cert" class="avatar"></span>
                                    <span v-else>--</span>
                                </el-form-item>
                            </el-col>
                            <el-col :span="12">
                                <el-form-item label="补充材料:" prop="trademark_supplement">
                                    <span v-if="form.trademark_supplement"><img :src="form.trademark_supplement" class="avatar"></span>
                                    <span v-else>--</span>
                                </el-form-item>
                            </el-col>
                        </el-row>
                    </el-form>
                </el-collapse-item>
            </el-collapse>
        </div>
        <div v-else>
            <el-tabs v-model="redName" @tab-click="handleClickRed">
                <el-tab-pane label="发放记录" name="send"></el-tab-pane>
                <el-tab-pane label="充值记录" name="charge"></el-tab-pane>
            </el-tabs>
            <div v-if="redName=='send'">
                <el-form ref="queryForm" :model="queryForm" label-width="100px" :inline="true" size="small">
                    <el-form-item label="发放时间" prop="date">
                        <el-date-picker
                            v-model="queryForm.date"
                            type="daterange"
                            style="width:240px"
                            range-separator="至"
                            format="yyyy 年 MM 月 dd 日"
                            value-format="yyyy-MM-dd"
                            start-placeholder="开始日期"
                            end-placeholder="结束日期">
                        </el-date-picker>
                    </el-form-item>
                    <el-form-item label="发放openid" prop="openid">
                        <el-input style="width:240px" v-model="queryForm.openid"></el-input>
                    </el-form-item>
                    <el-form-item > 
                        <el-button type="primary" icon="el-icon-search" @click="query">查询</el-button>
                        <el-button icon="el-icon-refresh" @click="resetQuery('queryForm')">重置</el-button>
                    </el-form-item>
                </el-form>
                <el-table
                    :data="issueData"
                    ref="codeTable"
                    :header-cell-style="{background:'#FAFAFA',color:'#606266',height:'50px'}"
                    border
                    stripe
                    size="small"
                    class="trace-table"
                    style="width: 100%">
                     <el-table-column prop="id" align="center" label="ID" ></el-table-column>
                     <el-table-column prop="create_time" align="center" label="时间" ></el-table-column>
                     <el-table-column prop="money" align="center" label="发放金额" :formatter="issueMoney" ></el-table-column>
                     <el-table-column prop="balance" align="center" label="发放后余额" ></el-table-column>
                     <el-table-column prop="openid" align="center" label="openid" ></el-table-column>
                     <el-table-column prop="scene" align="center" label="发放应用" ></el-table-column>
                </el-table>
                <pagination
                    v-show="+total>10"
                    :total="+total"
                    :page.sync="queryForm.pageNum"
                    :limit.sync="queryForm.pageSize"
                    @pagination="getIssueLog"
                />
            </div>
            <div v-else>
                <el-table
                    :data="rechargeData"
                    ref="codeTable"
                    :header-cell-style="{background:'#FAFAFA',color:'#606266',height:'50px'}"
                    border
                    stripe
                    size="small"
                    class="trace-table"
                    style="width: 100%">
                    <el-table-column prop="id" align="center" label="ID" ></el-table-column>
                    <el-table-column prop="create_time" align="center" label="时间" ></el-table-column>
                    <el-table-column prop="money" align="center" label="充值金额" :formatter="money" ></el-table-column>
                    <el-table-column prop="balance" align="center" label="充值后余额" ></el-table-column>
                </el-table>
                 <pagination
                    v-show="+totals>10"
                    :total="+totals"
                    :page.sync="queryForms.pageNum"
                    :limit.sync="queryForms.pageSize"
                    @pagination="getRechargeLog"
                />
            </div>
        </div>
    </el-tabs>
  </div>
</template>

<script>
import {getDealerMoreInfo,rechargeLog,redPackIssueLog} from "@/api/dealer/index";
export default {
    data(){
        return{
            activeName:'first',
            redName:"send",
            activeNames: ['1','2','3'],
            id:'',
            form:{
            },
            queryForm:{
                id:undefined,
                date:[],
                openid:'',
                pageNum:1,
                pageSize:10
            },
            queryForms:{
                id:undefined,
                pageNum:1,
                pageSize:10
            },
            total:0,
            serverInfo:{},
            totals:0,
            modules:[],
            rechargeData:[],
            issueData:[],
            sysEnv:[],
            companyTypeOptions:[],
            industryOptions:[],
            // prefix:"http://ctc.icloudapi.cn/static/mainImgs/"
        }
    },
    methods:{
        getDealerDes(){
            getDealerMoreInfo({id:this.id}).then(res=>{
               this.form=res.data
               this.modules=res.modules
               this.serverInfo=res.serverInfo
           })
        },
        company_type(val){
            if(!val) return '--'
            return this.companyTypeOptions.filter(item=>item.dict_value==val).map(item=>item.dict_label)[0]
        },
        industry(val){
            return this.industryOptions.filter(item=>item.dict_value==val).map(item=>item.dict_label)[0]
        },
        sys_env(value){
            if(!value) return '--'
            return this.sysEnv.filter(item=>value.split(',').some(it=>it==item.dict_value)).map(item=>item.dict_label).join(',')
        },
        business_period(val){
            if(!val) return '--'
            return val.split(',').join('至')
        },
        money(row){
            return '+'+row.money
        },
        issueMoney(row){
            return '-'+row.money
        },
        getRechargeLog(){
            rechargeLog(this.queryForms).then(res=>{
                this.rechargeData=res.data
                this.totals=res.total
            })
        },
        getIssueLog(){
            var arr=Object.assign({},this.queryForm)
            if(this.queryForm.date.length>0){
                arr.beginTime=this.queryForm.date[0]
                arr.endTime=this.queryForm.date[1]
            }else{
                arr.beginTime=''
                arr.endTime=''
            }
            delete arr.date
            redPackIssueLog(arr).then(res=>{
                this.issueData=res.data
                this.total=res.total
            })
        },
        handleClick(){
            if(this.activeName=='second'){
                this.$nextTick(()=>{
                    this.getRechargeLog()
                    this.getIssueLog()
                })
            }
        },
        query(){
            this.queryForm.pageNum = 1;
            this.getIssueLog()
        },
        resetQuery(formName){
            this.$refs[formName].resetFields();
            this.query()
        },
        handleClickRed(){
            console.log(this.rechargeData)
        }
    },
    created(){
        this.id=this.$route.query.id
        this.queryForm.id=this.$route.query.id
        this.queryForms.id=this.$route.query.id
        this.getDealerDes()
        this.getDicts({type:'partner_industry'}).then(res=>{
            this.industryOptions=res.data
        })
        this.getDicts({type:'access_environment'}).then(res=>{
            this.sysEnv=res.data
        })
        this.getDicts({type:'company_type'}).then(res=>{
            this.companyTypeOptions=res.data
        })
    },
    filters:{
        license_status:function(value){
            var status;
            switch (Number(value)){
                case 0:
                    status='未认证'
                    break;
                case 1:
                    status='已认证'
                    break;
                case 2:
                    status='未通过'
                    break;
                case 3:
                    status='更新中'
                    break;
            }
            return status;
        }
    }
}
</script>

<style lang="scss" scoped>
.avatar {
    width: 120px;
    height: 120px;
    display: block;
}
</style>