<template>
  <div class="app-container">
      <el-form :model="form" ref="form" label-width="140px" :rules="rule" size="medium">
          <el-row>
            <el-col :span="12">
              <el-form-item label="品牌商名称" prop="dealer_name">
                <el-input  v-model="form.dealer_name" placeholder="请输入品牌商名称"/>
              </el-form-item>
            </el-col>
            <el-col :span="12">
              <el-form-item label="公司名称" prop="company">
                <el-input  v-model="form.company" placeholder="请输入公司名称"/>
              </el-form-item>
            </el-col>
          </el-row>
          <el-row>
            <el-col :span="12">
              <el-form-item label="联系人" prop="concact_name">
                <el-input  v-model="form.concact_name" placeholder="请输入联系人姓名"/>
              </el-form-item>
            </el-col>
            <el-col :span="12">
             <el-form-item label="手机号" prop="phone">
                <el-input  v-model="form.phone" placeholder="请输入手机号"/>
              </el-form-item>
            </el-col>
          </el-row>
          <el-row>
            <el-col :span="12">
              <el-form-item label="账号" prop="account">
                <el-input  v-model="form.account" placeholder="请输入账号"/>
              </el-form-item>
            </el-col>
            <el-col :span="12">
              <el-form-item label="密码" prop="password">
                <el-input  v-model="form.password" placeholder="请输入密码"/>
              </el-form-item>
            </el-col>
          </el-row>
          <el-row>
            <el-col :span="12">
              <el-form-item label="密码" prop="passwords">
                <el-input  v-model="form.passwords" placeholder="请再次输入密码"/>
              </el-form-item>
            </el-col>
            <el-col :span="12">
              <el-form-item label="省市区" prop="address">
                <el-cascader
                  size="medium"
                  style="width:100%"
                  :options="options"
                  placeholder="请选择地址"
                  v-model="selectedOptions"
                  @change="handleChange">
                </el-cascader>
              </el-form-item>
            </el-col>
          </el-row>
          <el-row>
            <el-col :span="12">
              <el-form-item label="详细地址" prop="address">
                <el-input  v-model="form.address" placeholder="请输入详细地址"/>
              </el-form-item>
            </el-col>
            <el-col :span="12">
              <el-form-item label="官方网站" prop="website">
                <el-input  v-model="form.website" placeholder="请输入官方网站"><template slot="prepend">Http://</template></el-input>
              </el-form-item>
            </el-col>
          </el-row>
          <el-row>
            <el-col :span="12">
             <el-form-item label="所属行业" prop="industry">
                <el-select style="width:100%" v-model="form.industry" placeholder="请选择所属行业">
                  <el-option
                    v-for="dict in industryOptions"
                    :key="dict.id"
                    :label="dict.dict_label"
                    :value="dict.dict_value">
                  </el-option>
                </el-select>
              </el-form-item>
            </el-col>
            <el-col :span="12">
              <el-form-item label="E-Mail" prop="email">
                <el-input  v-model="form.email" placeholder="请输入品牌商邮箱"></el-input>
              </el-form-item>
            </el-col>
          </el-row>
          <el-row>
            <el-col :span="24">
                <el-form-item label="访问环境" prop="sys_env">
                    <el-checkbox-group v-model="form.sys_env">
                        <el-checkbox v-for="(item,index) in access_env" :key="index" :label="item.dict_value" name="type">{{item.dict_label}}</el-checkbox>
                    </el-checkbox-group>
                </el-form-item>
            </el-col>
          </el-row>
          <el-row>
              <el-col :span="24">
                  <el-form-item label="功能模块" prop="module">
                    <el-checkbox-group v-model="form.module" @change="selectModule">
                        <el-checkbox v-for="(item,index) in moduleOptions" :key="index" :label="item.module_name" name="type">{{item.module_name}}</el-checkbox>
                    </el-checkbox-group>
                    <div>本项合计：<span style="color:red">{{module_cost}}</span>元/年（成本）<span style="color:red">{{module_sale}}</span>元/年（销售价）</div>
                  </el-form-item>
              </el-col>
          </el-row>
          <el-row>
              <el-col :span="24">
                  <el-form-item label="服务等级" prop="service_level">
                      <el-radio-group v-model="form.service_level" @change="selectSer" v-if="serverData.length>0">
                          <el-row>
                              <el-col style="margin:10px 0" :span="24" v-for="(item,index) in serverData" :key="index">
                                  <el-radio :label="item.id">
                                      <span>服务等级：{{item.service_name}}</span><span style="margin-left:20px">服务费/年：￥{{item.service_cost}}</span>
                                      <div style="margin:20px 0 0 25px">服务描述：{{item.service_des}}</div>
                                  </el-radio>
                              </el-col>
                          </el-row>
                      </el-radio-group>
                      <span v-if="serverData.length==0">暂无</span>
                  </el-form-item>
              </el-col>
          </el-row>
          <el-row>
              <el-col :span="24">
                  <el-form-item label="">
                      <div class="tips">
                        <p>成本总价：<span style="color:red">{{sum_price}}元/年</span>（成本） 销售价： <span style="color:red">{{sum_sale}}元/年</span>（销售价）</p>
                      </div>
                  </el-form-item>
              </el-col>
          </el-row>
          <el-row>
              <el-col :span="24">
                <el-form-item label="支付方式">
                  <el-radio-group v-model="form.pay_type">
                    <el-radio :label="0">预存款支付 <span style="color:red">（预存款剩余：￥{{user_info.deposit}}元）</span></el-radio>
                  </el-radio-group>
                </el-form-item>
              </el-col>
          </el-row>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button type="primary" @click="submitFrom">开户</el-button>
      </div>
  </div>
</template>

<script>
import { mapGetters } from 'vuex'
import { regionDataPlus,CodeToText, TextToCode } from 'element-china-area-data'
import {getAllModule} from "@/api/demand/index";
import {calculatePrice,addDealer} from "@/api/dealer"
import {getServer} from "@/api/product"
export default {
    data(){
        return{
            form:{
                dealer_name:'',
                company:'',
                concact_name:'',
                phone:'',
                account:'',
                password:'',
                passwords:'',
                address:'',
                website:'',
                industry:'',
                email:'',
                sys_env:[],
                module:[],
                service_level:undefined,
                pay_type:0//支付方式
            },
            rule:{
                dealer_name:[
                    { required: true, message: "请输入品牌商名称", trigger: "blur" },
                ],
                company:[
                    { required: true, message: "请输入公司名称", trigger: "blur" },
                ],
                concact_name:[
                    { required: true, message: "请输入联系人姓名", trigger: "blur" },
                ],
                phone:[
                    { required: true, message: "请输入手机号", trigger: "blur" },
                ],
                account:[
                    { required: true, message: "请输入品牌商账号", trigger: "blur" },
                ],
                password:[
                    { required: true, message: "请输入品牌商密码", trigger: "blur" },
                ],
                passwords:[
                    { required: true, message: "请再次输入品牌商密码", trigger: "blur" },
                ],
                sys_env:[
                    { required: true, message: "请选择系统访问环境", trigger: "blur" },
                ],
                module:[
                    { required: true, message: "请选择品牌商功能模块", trigger: "blur" },
                ],
                // service_level:[
                //     { required: true, message: "请选择品牌商服务等级", trigger: "blur" },
                // ]
            },
            module_cost:0,
            module_sale:0,
            sum_price:0,
            sum_sale:0,
            ser_price:0,
            selectedOptions:[],
            options: regionDataPlus,
            industryOptions:[],
            access_env:[],
            moduleOptions:[],
            serverData:[],
            module_price:[],
            exp:['码库','系统模块','订单管理','客户','公众号','资产','万能溯源','营销分控','在线订单']
        }
    },
    created(){
        this.getDicts({type:'partner_industry'}).then(res=>{
            this.industryOptions=res.data
        })
        this.getDicts({type:'access_environment'}).then(res=>{
            this.access_env=res.data
        })
        this.getModules()
        getServer().then(res=>{
            this.serverData=res.data
        })
    },
    computed:{
      ...mapGetters([
            'user_info'
        ]),
    },
    methods:{
        handleChange (value) {
        },
        getModules(ids=[]){
            var exp=this.exp
            getAllModule({}).then(res=>{
                this.moduleOptions=res.data.filter(item=>exp.every(it=>it!=item.module_name))
                if(ids.length==0){
                    this.module_sale=0
                    this.module_cost=0
                    return;
                }
                var module_id=this.moduleOptions.filter(item=>ids.some(it=>it==item.module_name)).map(item=>item.id)
                 //计算价格 后台计算
                calculatePrice({module_id:module_id.join(',')}).then(res=>{
                    this.module_cost=res.module_cost
                    this.module_sale=res.module_sale
                    this.sum_price=this.module_cost
                    this.sum_sale=this.ser_price*1+this.module_sale*1
                    this.module_price=res.module_price
                })
            })
        },
        selectModule(value){
            if(value.includes('二维码营销')){
                this.exp=this.exp.filter(item=>item!='营销分控')
            }else{
                if(!this.exp.includes('营销分控')){
                    this.exp.push('营销分控')
                }
            }
            if(value.includes('智能物流')){
                this.exp=this.exp.filter(item=>item!='在线订单')
            }else{
                if(!this.exp.includes('在线订单')){
                    this.exp.push('在线订单')
                }
            }
            if(value.includes('智能物流')){
                this.exp=this.exp.filter(item=>item!='在线订单')
            }else{
                if(!this.exp.includes('在线订单')){
                    this.exp.push('在线订单')
                }
            }
            this.getModules(value)
        },
        selectSer(val){
            this.ser_price=this.serverData.filter(item=>item.id==val).map(item=>item.service_cost)[0]
            this.sum_price=this.module_cost
            this.sum_sale=this.ser_price*1+this.module_sale*1
        },
        submitFrom(){
            this.$refs["form"].validate(valid => {
                if(valid){
                    if(this.form.password!=this.form.passwords){
                        this.$message.error('前后两次输入密码不一致')
                        return
                    }
                    if(this.sum_price*1>this.user_info.deposit){
                      this.$message.warning('您的预存款账户余额不足')
                      return;
                    }
                    var arr=Object.assign({},this.form)
                    delete arr.passwords
                    delete arr.pay_type
                    arr.sys_env=arr.sys_env.join(',')
                    arr.province=CodeToText[this.selectedOptions[0]]
                    arr.city=CodeToText[this.selectedOptions[1]]
                    arr.district=CodeToText[this.selectedOptions[2]]
                    var modules=this.module_price.filter(item=>arr.module.some(it=>it==item.module_name))
                    let newArr = [];
                    modules.forEach((item) => {
                        newArr.push({
                            module_name: item.module_name,
                            module_retail: item.module_retail,
                            module_cost:item.module_cost,
                            module_id:item.id,//模块id
                        });
                    });
                    arr.module=newArr
                    arr.sum_price=Number(this.sum_price)
                    addDealer(arr).then(res=>{
                        if(res.code==200){
                            this.$message.success(res.msg)
                            //更新账户数据
                            this.$store.dispatch('user/getInfo')
                            setTimeout(() => {
                                this.$router.go(-1)
                            }, 1000);
                        }else{
                            this.$message.error(res.msg)
                        }
                    })
                }
            })
        }
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
</style>>