<template>
  <div class="app-container">
      <div class="main-info">
          <el-row :gutter="20">
              <el-col :span="12">
                <div class="tips">
                    <p>功能模块费/年</p>
                </div>
                <el-table
                    :data="modules"
                    :header-cell-style="{background:'#FAFAFA',color:'#606266',height:'50px'}"
                    border
                    stripe
                    size="small"
                    class="trace-table"
                    style="width: 100%">
                    <el-table-column prop="module_name" align="center" label="功能模块"></el-table-column>
                    <el-table-column prop="module_cost" align="center" label="成本价/年" ></el-table-column>
                    <el-table-column prop="module_retail" align="center" label="销售价/年" ></el-table-column>
                </el-table>
              </el-col>
              <el-col :span="12">
                <div class="tips">
                    <p>服务费/年</p>
                </div>
                <el-table
                    :data="[serverInfo]"
                    :header-cell-style="{background:'#FAFAFA',color:'#606266',height:'50px'}"
                    border
                    stripe
                    size="small"
                    class="trace-table"
                    style="width: 100%">
                    <el-table-column prop="service_name" align="center" label="服务等级"></el-table-column>
                    <el-table-column prop="service_cost" align="center" label="费用/年"></el-table-column>
                </el-table>
              </el-col>
          </el-row>
      </div>
      <p class="renew-tips">若有不想续费的功能，请前往【升级】中降配后再来续费</p>
      <el-form ref="form" :model="form" label-width="100px">
            <el-form-item label="当前品牌商有效期至：" label-width="160px">
                {{validity_end}}
            </el-form-item>
            <el-form-item label="续费年限：">
                <el-select v-model="form.time" @change="changeYear" placeholder="续费年限">
                    <el-option label="1年" value="1"></el-option>
                    <el-option label="2年" value="2"></el-option>
                    <el-option label="3年" value="3"></el-option>
                    <el-option label="4年" value="4"></el-option>
                    <el-option label="5年" value="5"></el-option>
                </el-select>
            </el-form-item>
      </el-form>
      <div class="sum-price">
        <p>
        <span>成本总价：{{cost1?cost1:cost}}元</span>
        <span style="margin-left:10px">销售价：{{sale1?sale1:sale}}元</span>
        <span style="margin-left:10px">仅供参考</span>
        </p>
        <p>本次扣除预存款：<span style="color:red">{{cost1?cost1:cost}}</span>元（预存款剩余：{{partner_deposit}}元）</p>
      </div>
        <div class="dialog-footer">
            <el-button type="primary" @click="submitFrom">续费</el-button>
        </div>
  </div>
</template>

<script>
import {getRenewModule,renew} from "@/api/dealer/index";
export default {
    data(){
        return{
            id:undefined,
            modules:[],
            serverInfo:[],
            validity_end:"",
            partner_deposit:0,
            form:{
                time:1
            },
            cost:0,
            cost1:undefined,
            sale:0,
            sale1:undefined
        }
    },
    created(){
        this.id=this.$route.query.id
        this.getDealerDes()
    },
    methods:{
        getDealerDes(){
            getRenewModule({id:this.id}).then(res=>{
               this.modules=res.module_price
               this.serverInfo=res.serverInfo
               this.validity_end=res.validity_end
               this.partner_deposit=res.deposit
               this.cost=res.module_cost
               this.sale=res.module_sale+res.serverInfo.service_cost*1
           })
        },
        price(){
            var time=this.form.time
            //计算价格
            this.cost1=this.cost*time
            this.sale1=this.sale*time
            console.log(this.cost1)
        },
        changeYear(){
            this.price()
        },
        submitFrom(){
            var params={
                dealer_id:this.id,
                year:this.form.time,
                cost:this.cost1?this.cost1:this.cost,
                sale:this.sale1?this.sale1:this.sale
            }
            renew(params).then(res=>{
                if(res.code==200){
                    this.$message.success(res.msg)
                    this.$store.dispatch('user/getInfo')
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
</script>

<style lang="scss" scoped>
.app-container .tips{
    padding: 2px 16px;
    background-color: #ecf8ff;
    border-radius: 4px;
    border-left: 5px solid #50bfff;
    margin: 10px 0;
}
.renew-tips{
    font-size: 15px;
    color: #50bfff;
}
.sum-price{
    width: 100%;
    padding: 6px 16px;
    font-size: 14px;
    border-radius: 4px;
    height: auto;
    display: flex;
    flex-direction: column;
    align-items: center;
    background-color: #ecf8ff;
    p{
        width: 100%;
        display: block;
    }
}
.dialog-footer{
    margin: 30px 0;
}
</style>>