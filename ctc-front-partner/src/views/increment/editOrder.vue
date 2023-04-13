<template>
  <div class="app-container">
    <el-card class="box-card">
        <span>当前品牌商已订购的模块：</span>
        <el-tag v-for="tag in module" effect="light" :key="tag.name" style="margin-right:5px">
            {{tag.module_name}}
        </el-tag>
    </el-card>
    <div class="tips">
        <div class="tips-title">增值服务</div>
        <div>增值服务为平台官方提供</div>
    </div>
    <div class="server-list">
        <el-checkbox-group v-model="checkList" @change="selectSer">
            <el-row>
                <el-col class="server-list-item" :span="24" v-for="(item,index) in service" :key="index">
                    <el-checkbox  :label="item.id">
                        <span>{{item.name}} {{item|price}}</span>
                        <div style="position:absolute;top:25px">本项合计：{{item.sum||0}}元（成本）{{item.sale||0}}元（销售价）</div>
                    </el-checkbox>
                    <el-input-number 
                        style="margin:4px"
                        v-if="item.id==3" 
                        size="small"
                        @change="selectTimes" 
                        v-model="form.times" 
                        :min="1" 
                        :max="10" 
                        label="培训次数">
                    </el-input-number>
                </el-col>
            </el-row>
        </el-checkbox-group>
    </div>
    <div class="tips">
        <div class="tips-title">定制开发</div>
    </div>
    <p style="font-size:14px;margin:20px 0 20px 0">温馨提示：定制开发请提前跟平台客服沟通，然后再下单。按开发周期、难易程度定价</p>
    <div style="margin:30px 0">
    <el-switch
        v-model="form.customized"
        inactive-text="定制开发"
        active-value="1"
        @change="customized"
        inactive-value="0">
    </el-switch>
    </div>
    <el-form :model="form" v-if="form.customized=='1'" ref="form" label-width="80px" :rules="rule" size="medium">
        <el-row>
            <el-col :span="10">
              <el-form-item label="定制需求" prop="demand">
                <el-input type="textarea" :autosize="{ minRows: 3, maxRows: 5}" v-model="form.demand" placeholder="请输入定制需求"/>
              </el-form-item>
            </el-col>
        </el-row>
        <el-row>
            <el-col :span="10">
              <el-form-item label="定制成本" prop="cost">
                <el-input @change="changeCost" v-model.number="form.cost" placeholder="请输入定制成本"/>
              </el-form-item>
            </el-col>
        </el-row>
        <el-row>
            <el-col :span="10">
              <el-form-item label="销售价格" prop="sale">
                <el-input @change="changeSale"  v-model.number="form.sale" placeholder="请输入销售价格"/>
              </el-form-item>
            </el-col>
        </el-row>
        <el-row>
            <el-col :span="10">
              <el-form-item label="本项合计">
                <span><span style="color:red">{{form.cost}}</span>元（成本）</span>
                <span><span style="color:red">{{form.sale}}</span>元（销售价）</span>
              </el-form-item>
            </el-col>
        </el-row>
    </el-form>
    <!-- 成本总价 -->
    <div class="sum-price">
        <span>成本总价：{{cost}}元</span>
        <span>销售价：{{sale}}元</span>
        <span>仅供参考</span>
    </div>
    <div class="sum-price">
        <el-radio-group v-model="pay_type">
            <el-row>
                <el-col :span="24">
                    <el-radio :label="0">余额支付 <span style="color:red">（余额：￥{{user_info.balance}}元）余额支付不需要人工审核，处理速度更快</span></el-radio>
                </el-col>
                <el-col :span="24" style="margin-top:20px">
                    <el-radio :label="1">线下支付 （联系客服)</el-radio>
                </el-col>
            </el-row>
        </el-radio-group>
    </div>
    <div class="dialog-footer">
        <el-button type="primary" @click="submitFrom">提交</el-button>
    </div>
  </div>
</template>

<script>
import { mapGetters } from 'vuex'
import{getDealerModule,saveIncrement} from '@/api/dealer'
import {listService,orderDes} from "@/api/increment/index";
export default {
    data(){
        return{
            id:undefined,
            order_id:undefined,
            module:[],
            service:[],
            checkList:[],
            orderInfo:[],
            form:{  
                cost:0,
                sale:0,
                demand:'',
                customized:'0',
                times:1//培训次数
            },
            pay_type:0,//0余额支付 1线下支付
            cost:0,
            sale:0,
            rule:{
                demand:[
                    { required: true, message: "请输入定制需求", trigger: "blur" },
                ],
                cost:[
                    { required: true, message: "定制成本不能为空", trigger: "blur" },
                    { type: 'number', message: '定制成本必须为数字值'}
                ],
                sale:[
                    { required: true, message: "销售价格不能为空", trigger: "blur" },
                    { type: 'number', message: '销售价格必须为数字值'}
                ]
            }
        }
    },
    created(){
        this.id=this.$route.query.dealer_id
        this.order_id=this.$route.query.id
        this.getModule()
        this.getServer()
    },
     computed:{
      ...mapGetters([
            'user_info'
        ]),
    },
    filters:{
        price:function(item){
            var unit
            switch(item.id){
                case 1:
                unit=`(${item.retail_price}元/模块，按模块收费）`
                break;
                case 2:
                unit=`(${item.retail_price}元/模块/年，按模块收费）`
                break;
                case 3:
                unit=`(${item.retail_price}元/次，按次数进行收费）`
                break;
                case 4:
                unit=`(${item.retail_price}元/次，按次数收费）`
                break;
            }
            return unit
        }
    },
    methods:{
        getOrderInfo(){
            orderDes({order_id:this.order_id}).then(res=>{
                this.orderInfo=res.data
                this.checkList=res.data.increment_service_id.split(',').map(Number)
                this.form.times=res.data.train_times
                this.form.customized=String(res.data.is_customized)
                this.form.cost=Number(res.data.customized_cost)
                this.form.sale=Number(res.data.customized_sale)
                this.form.demand=res.data.customized_des
                this.form.order_num=res.data.order_num
                this.sale=0
                this.cost=0
                this.$forceUpdate()
                this.selectSer(this.checkList)
            })
        },
        getModule(){
            getDealerModule({id:this.id}).then(res=>{
                this.module=res.data
                this.$nextTick(function(){
                    this.getOrderInfo()
                })
            })
        },
        getServer(){
            listService({}).then(res=>{
                this.service=res.data
            })
        },
        selectTimes(val){
            this.selectSer(this.checkList)
        },
        changeCost(){
            this.selectSer(this.checkList)
        },
        changeSale(){
            this.selectSer(this.checkList)
        },
        customized(val){
            if(val=='0'){
                this.cost-=this.form.cost
                this.sale-=this.form.cost
            }else{
                this.cost+=this.form.cost
                this.sale+=this.form.cost
            }
        },
        selectSer(val){
            //计算价格
            var module_num=this.module.length//模块个数
            this.cost=0
            this.sale=0
            this.service.forEach((item,index)=>{
                this.$set(this.service[index],'sum',0)
                this.$set(this.service[index],'sale',0)
            })
            val.forEach(item=>{
                this.service.forEach((it,index)=>{
                    var cost;
                    var retail;
                    if(item==it.id){
                        if(item==4){
                            cost=it.cost_price
                            retail=it.retail_price
                        }else if(item==3){
                            cost=it.cost_price*this.form.times
                            retail=it.retail_price*this.form.times
                        }else{
                            cost=it.cost_price*module_num
                            retail=it.retail_price*module_num
                        }
                        this.$set(this.service[index],'sum',cost)
                        this.$set(this.service[index],'sale',retail)
                    }
                })
            })
            this.service.forEach(item=>{
                this.cost+=item.sum*1||0
                this.sale+=item.sale*1||0
            })
            if(this.form.customized=='1'){
                this.cost+=this.form.cost
                this.sale+=this.form.sale
            }
        },
        submitFrom(){
            if(this.checkList.length==0){
                this.$message.warning('请选择增值服务项目')
                return
            }
            if(this.cost*1>this.user_info.balance*1){
                this.$message.warning('您的余额不足')
                return;
            }
            if(this.form.customized=='1'){
                this.$refs["form"].validate(valid => {
                    if(valid){
                        var params={
                            'increment_service_id':this.checkList.join(','),
                            'cost':this.cost,
                            'sale':this.sale,
                            'order_num':this.form.order_num,
                            'train_times':this.form.times,
                            'is_customized':1,
                            'train_times':this.form.times,
                            'customized_cost':this.form.cost,
                            'customized_sale':this.form.sale,
                            'customized_des':this.form.demand,
                            'dealer_id':this.id,
                            'id':this.order_id,
                            'pay_type':this.pay_type
                        }
                        saveIncrement(params).then(res=>{
                            if(res.code==200){
                                this.$message.success(res.msg)
                                setTimeout(() => {
                                    this.$router.go(-1)
                                }, 1000);
                            }else{
                                this.$message.error(res.msg)
                            }
                        })
                    }
                })
            }else{
                var params={
                    'increment_service_id':this.checkList.join(','),
                    'cost':this.cost,
                    'train_times':this.form.times,
                    'order_num':this.form.order_num,
                    'sale':this.sale,
                    'is_customized':0,
                    'dealer_id':this.id,
                    'id':this.order_id,
                    'pay_type':this.pay_type
                }
                saveIncrement(params).then(res=>{
                    if(res.code==200){
                        this.$message.success(res.msg)
                        setTimeout(() => {
                            this.$router.go(-1)
                        }, 1000);
                    }else{
                        this.$message.error(res.msg)
                    }
                })
            }
        }
    }
}
</script>

<style lang="scss" scoped>
.app-container .tips{
    padding: 6px 16px;
    background-color: #ecf8ff;
    border-radius: 4px;
    border-left: 5px solid #50bfff;
    margin: 20px 0;
    display: flex;
    height: 50px;
    justify-content: space-between;
    align-items: center;
    .tips-title{
        font-weight: 600;
    }
}
.server-list-item{
    margin: 20px 0 !important;
    padding-bottom: 50px;
    border-bottom: 1px dashed #50bfff
}
.sum-price{
    width: 100%;
    padding: 16px 16px;
    margin: 20px 0;
    font-size: 14px;
    border-radius: 4px;
    min-height: 50px;
    display: flex;
    align-items: center;
    background-color: #ecf8ff;
}
.dialog-footer{
    margin: 30px 0;
}
</style>