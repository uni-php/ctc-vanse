<template>
  <div class="app-container">
      <el-row :gutter="20">
          <el-col :span="6">
                <el-card class="box-card">
                    <div slot="header" class="sms-header">
                        <span>短信剩余条数</span>
                        <el-tag effect="dark"  size="mini">条</el-tag>
                    </div>
                    <div class="sms-surplus">
                       {{smsInfo.surplus_num}}
                    </div>
                </el-card>
          </el-col>
          <el-col :span="6">
                <el-card class="box-card">
                    <div slot="header" class="sms-header">
                        <span>短信发送总条数</span>
                        <el-tag effect="dark"  size="mini">条</el-tag>
                    </div>
                    <div class="sms-surplus">
                       {{smsInfo.send_num}}
                    </div>
                </el-card>
          </el-col>
      </el-row>
      <!-- 预警 -->
      <el-row :gutter="20">
          <el-col :span="12">
                <el-card class="box-card">
                    <div slot="header" class="sms-header">
                        <span>自动预警</span>
                        <el-switch
                            v-model="form.status"
                            active-color="#13ce66"
                            inactive-color="#C0CCDA"
                            active-value="1"
                            inactive-value="0">
                        </el-switch>
                    </div>
                    <div class="sms-surplus">
                        <el-form :model="form" ref="form" label-width="120px" :rules="rule" size="medium">
                            <el-form-item label="剩余条数少于：" prop="num">
                                <el-input style="width:90%"  v-model="form.num" placeholder="请输入剩余数量"/>
                            </el-form-item>
                            <el-form-item label="通知手机：" prop="phone">
                                <el-input style="width:90%"  v-model="form.phone" placeholder="请输入通知手机号"/>
                            </el-form-item>
                            <el-form-item >
                                <el-button type="primary" @click="submitForm">确 定</el-button>
                            </el-form-item>
                        </el-form>
                    </div>
                </el-card>
          </el-col>
      </el-row>
      <!-- 套餐 -->
        <el-card class="box-card">
            <div slot="header" class="sms-header">
                <span>选择套餐</span>
            </div>
            <el-row :gutter="20">
                <el-col :span="4" v-for="(item,index) in packageData" :key="index" @click.native="handleClick(item)">
                    <el-card class="sms-box">
                        <div class="sms-num">
                            {{item.sms_count}}条
                        </div>
                        <div class="sms-price">
                            {{item.sum_price}}元（{{item.sms_retail}}元/条）
                        </div>
                    </el-card>
                </el-col>
            </el-row>
        </el-card>
        <el-card class="box-card" v-show="is_pay">
            <div slot="header" class="sms-header">
                <span>立即支付</span>
            </div>
            <div class="pay-info">
                <div>支付方式：<el-tag type="success">微信支付</el-tag></div>
                <div>充值条数：<span class="num">{{num}}</span></div>
                <div>支付金额：<span class="price">￥{{price}}</span></div>
                <div class="pay-code">
                    <span>支付码：</span>
                    <span class="pay-code-box">
                        <el-image style="width: 100px; height: 100px" :src="code_img" fit="fill"></el-image>
                        <span>支付码有效期60秒</span>
                    </span>
                </div>
            </div>
        </el-card>
        <!-- 购买记录 -->
        <el-card class="box-card">
            <div slot="header" class="sms-header">
                <span>充值记录</span>
            </div>
            <div>
                <el-table
                    :data="tableData"
                    :header-cell-style="{background:'#FAFAFA',color:'#606266',height:'50px'}"
                    border
                    stripe
                    size="medium"
                    class="trace-table"
                    style="width: 100%">
                    <el-table-column prop="order" align="center" label="订单号"></el-table-column>
                    <el-table-column prop="money" align="center" label="充值金额"></el-table-column>
                    <el-table-column prop="num" align="center" label="充值条数"></el-table-column>
                    <el-table-column prop="create_time" align="center" label="下单时间"></el-table-column>
                    <el-table-column prop="create_by" align="center" label="操作人"></el-table-column>
                </el-table>
                 <pagination
                    v-show="+total>10"
                    :total="+total"
                    :page.sync="queryForm.pageNum"
                    :limit.sync="queryForm.pageSize"
                    @pagination="getPayLog"
                />
            </div>
        </el-card>
  </div>
</template>

<script>
import {getSmsPrice,smsPay,queryPayStatus,getPayLog,getSmsInfo,saveSmsWarning} from '@/api/assets/sms'
export default {
    data(){
        return{
            packageData:[],
            tableData:[],
            smsInfo:{},
            queryForm:{
                pageNum:1,
                pageSize:10
            },
            form:{
                phone:'',
                sum:''
            },
            rule:{
                num:[
                    { required: true, message: "请输入预警数量", trigger: "blur" },
                ],
                phone:[
                    { required: true, message: "请输入预警手机号", trigger: "blur" },
                ]
            },
            num:'',
            price:'',
            code_img:'',
            total:0,
            is_pay:false,
            wx_timer:undefined
        }
    },
    created(){
        this.getPackData()
        this.getPayLog()
        this.getSmsInfo()
    },
    methods:{
        getPackData(){
            getSmsPrice({}).then(res=>{
                this.packageData=res.data
            })
        },
        getPayLog(){
            getPayLog(this.queryForm).then(res=>{
                this.tableData=res.data
                this.total=res.total
            })
        },
        getSmsInfo(){
            getSmsInfo({}).then(res=>{
                this.smsInfo=res
                this.form=res.warning?res.warning:{phone:'',num:'',status:'0'}
                this.form.status=String(this.form.status)
            })
        },
        submitForm(){
            this.$refs["form"].validate(valid => {
                if(valid){
                    saveSmsWarning(this.form).then(res=>{
                        if(res.code==200){
                            this.$message.success(res.msg)
                            this.getSmsInfo()
                        }else{
                            this.$message.error(res.msg)
                        }
                    })
                }
            })
        },
        handleClick(item){
            this.num=item.sms_count
            this.price=item.sum_price
            smsPay(item).then(res=>{
                this.code_img=res.code_url
                this.is_pay=true
                this.setTime(2000,res.out_trade_no)
            })
        },
        setTime(set_time,order){
            clearInterval(this.wx_timer)
            var time=0;
            this.wx_timer=setInterval(()=>{
                time=time+2000
                if(time>=60*1000){
                    this.$message.warning('二维码失效')
                    this.is_pay=false
                    clearInterval(this.wx_timer)
                    return;
                }
                queryPayStatus({'order':order}).then(res=>{
                    if(res.code==200){
                        this.$message.success(res.msg)
                        this.getPackData()
                        this.getPayLog()
                        this.is_pay=false
                        clearInterval(this.wx_timer)
                    }else{
                        console.log('等待支付')
                    }
                })
            },set_time)
        }
    }
}
</script>

<style lang="scss" scoped>
.sms-header{
    display: flex;
    justify-content: space-between;
    align-items: center;
    width: 100%;
    span{
        font-size: 14px;
    }
}
.sms-surplus{
    font-size: 26px;
    font-weight: 600;
}
.sms-num{
    display: flex;
    justify-content: center;
    align-items: center;
    font-size: 26px;
    font-weight: 500;
    color: orange;
}
.sms-price{
    display: flex;
    justify-content: center;
    align-items: center;
    margin-top: 10px;
    font-size: 15px;
    font-weight: 400;
    color: gray;
}
.box-card {
    width: 100%;
    display: block;
    margin-bottom: 20px;
}
.sms-box{
    width: 100%;
    display: block;
    cursor: pointer;
}
.sms-box:hover{
    border: 1px solid orange;
}
.pay-info{
    .num{
        font-size: 20px;
        font-weight: 500;
        margin: 10px 0;
        display: inline-block;
    }
    .price{
        font-size: 20px;
        font-weight: 500;
        color: orange;
    }
}
.pay-code{
    display: flex;
    align-items: center;
    margin-top: 20px;
    .pay-code-box{
        display: flex;
        align-items: center;
        justify-content: center;
        flex-direction: column;
        span{
            font-size: 13px;
            color: gray;
            margin-top: 5px;
        }
    }
}
</style>