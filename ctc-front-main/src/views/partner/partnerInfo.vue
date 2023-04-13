<template>
  <div class="app-container">
    <el-tabs type="border-card" v-model="activeName" @tab-click="handleClick">
        <el-tab-pane name="first" label="基础信息">
            <el-form style="margin-top:20px" :model="form" ref="form" label-width="140px" size="medium">
                <el-row>
                    <el-col :span="12">
                        <el-form-item label="公司名称:" prop="company">
                            <span>{{form.company}}</span>
                        </el-form-item>
                    </el-col>
                    <el-col :span="12">
                        <el-form-item label="合伙人级别:" prop="level_id">
                            <span>{{level(form.level_id)}}</span>
                        </el-form-item>
                    </el-col>
                </el-row>
                <el-row>
                    <el-col :span="12">
                        <el-form-item label="联系人:">
                            <span>{{form.contact_name}}</span>
                        </el-form-item>
                    </el-col>
                    <el-col :span="12">
                        <el-form-item label="手机号:">
                            <span>{{form.phone}}</span>
                        </el-form-item>
                    </el-col>
                </el-row>
                <el-row>
                    <el-col :span="12">
                        <el-form-item label="账号:">
                            <span>{{form.account}}</span>
                        </el-form-item>
                    </el-col>
                    <el-col :span="12">
                        <el-form-item label="详细地址:">
                            <span>{{form.province}} {{form.city}} {{form.county}}</span>
                        </el-form-item>
                    </el-col>
                </el-row>
                <el-row>
                    <el-col :span="12">
                        <el-form-item label="官方网站:">
                            <span>{{form.website}}</span>
                        </el-form-item>
                    </el-col>
                    <el-col :span="12">
                        <el-form-item label="所属行业:">
                            <span>{{industry(form.industry)}}</span>
                        </el-form-item>
                    </el-col>
                </el-row>
                <el-row>
                    <el-col :span="12">
                        <el-form-item label="E-Mail:">
                            <span>{{form.email}}</span>
                        </el-form-item>
                    </el-col>
                    <el-col :span="12">
                        <el-form-item label="联系电话:">
                            <span>{{form.telephone}}</span>
                        </el-form-item>
                    </el-col>
                </el-row>
                <el-row>
                    <el-col :span="12">
                        <el-form-item label="签约时间:">
                            <span>{{form.start_time}}至{{form.end_time}}</span>
                        </el-form-item>
                    </el-col>
                    <el-col :span="12">
                        <el-form-item label="账户余额:">
                            <span style="color:red">{{form.balance}}</span>
                        </el-form-item>
                    </el-col>
                </el-row>
                <el-row>
                    <el-col :span="12">
                        <el-form-item label="状态:">
                            <span>{{form.status==0?'正常':'禁用'}}</span>
                        </el-form-item>
                    </el-col>
                </el-row>
            </el-form>
        </el-tab-pane>
        <el-tab-pane name="second" label="资质信息">
            <el-form style="margin-top:20px" :model="form" ref="form1" label-width="140px" size="medium">
                <el-row>
                    <el-col :span="12">
                        <el-form-item label="资质名称:" prop="zizhi_name">
                            <span>企业营业执照<span style="color:red">{{form.is_auth|license_status}}</span></span>
                        </el-form-item>
                    </el-col>
                    <el-col :span="12">
                        <el-form-item label="营业执照号码:">
                            <span>{{form.business_license||'暂无'}}</span>
                        </el-form-item>
                    </el-col>
                </el-row>
                <el-row>
                    <el-col :span="12">
                        <el-form-item label="组织机构代码:">
                            <span>{{form.organization_code||'暂无'}}</span>
                        </el-form-item>
                    </el-col>
                    <el-col :span="12">
                        <el-form-item label="名称:">
                            <span>暂无</span>
                        </el-form-item>
                    </el-col>
                </el-row>
                <el-row>
                    <el-col :span="12">
                        <el-form-item label="类型:">
                            <span>{{qualification_type(form.qualification_type)}}</span>
                        </el-form-item>
                    </el-col>
                    <el-col :span="12">
                        <el-form-item label="注册地址:">
                            <span>{{form.registered_address||'暂无'}}</span>
                        </el-form-item>
                    </el-col>
                </el-row>
                <el-row>
                    <el-col :span="12">
                        <el-form-item label="法定代表人:">
                            <span>{{form.representative||'暂无'}}</span>
                        </el-form-item>
                    </el-col>
                    <el-col :span="12">
                        <el-form-item label="注册资本:">
                            <span>{{form.capital||'暂无'}}</span>
                        </el-form-item>
                    </el-col>
                </el-row>
                <el-row>
                    <el-col :span="12">
                        <el-form-item label="成立日期:">
                            <span>{{form.establish_date||'暂无'}}</span>
                        </el-form-item>
                    </el-col>
                    <el-col :span="12">
                        <el-form-item label="营业期至:">
                            <span>{{form.business_period|business_period}}</span>
                        </el-form-item>
                    </el-col>
                </el-row>
                <el-row>
                    <el-col :span="12">
                        <el-form-item label="营业执照:" prop="business_license_url">
                            <span v-if="form.business_license_url"><img :src="prefix+form.business_license_url" class="avatar"></span>
                            <span v-else>--</span>
                        </el-form-item>
                    </el-col>
                </el-row>
            </el-form>
        </el-tab-pane>
    </el-tabs>
  </div>
</template>

<script>
import {getPartnerInfo,listLevel} from '@/api/partner/index';
export default {
    data(){
        return{
            activeName: 'first',
            id:'',
            form:{},
            industryOptions:[],
            companyTypeOptions:[],
            levelOptions:[],
            prefix:"http://localhost/static/mainImgs/",
        }
    },
    created(){
        this.id=this.$route.query.id
        this.getPartnerDes()
        this.getLevelOptions();
        this.getDicts({type:'partner_industry'}).then(res=>{
            this.industryOptions=res.data
        })
        this.getDicts({type:'company_type'}).then(res=>{
            this.companyTypeOptions=res.data
        })
    },
    computed:{
        industry(){
            return function(value){
                if(!value) return '--'
                var item=this.industryOptions.filter(item=>{
                return item.dict_value==value
            })
                return item[0].dict_label
            }
        },
        qualification_type(){
            return function(value){
                if(!value) return '--'
                var item=this.companyTypeOptions.filter(item=>{
                return item.dict_value==value
            })
                return item[0].dict_label
            }
        }
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
        },
        business_period:function(value){
            if(!value) return '--'
            value=value.split(',')
            return value[0]+'至'+value[1]
        },
    },
    methods:{
       getPartnerDes(){
           getPartnerInfo({id:this.id}).then(res=>{
               this.form=res.data
           })
       },
       level(val){
          return this.levelOptions.filter(item=>item.id==val).map(item=>item.level_name)[0]
        },
       getLevelOptions(){
          listLevel({level_name:"",pageNum:1,pageSize:999}).then(res=>{
            this.levelOptions=res.data
          })
        },
       handleClick(tab, event) {
         console.log(tab, event);
       }
    }
}
</script>

<style>

</style>