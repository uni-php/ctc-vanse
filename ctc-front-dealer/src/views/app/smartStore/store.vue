<template>
  <div class="app-container">
       <div class="tips">
           <p>用户可以在这里启用或者是关闭门店的商品上传、自助下单等功能。用户可以查看门店的商品、订单情况！</p>
       </div>
       <div class="tab-bar">
           <el-form ref="queryForm" :model="queryForm" label-width="100px" :inline="true" size="small">
               <el-form-item label="门店编号" prop="store_code">
                   <el-input style="width:220px" v-model="queryForm.store_code" placeholder="请输入门店编号"></el-input>
               </el-form-item>
               <el-form-item label="门店名称" prop="store_name">
                   <el-input style="width:220px" v-model="queryForm.store_name" placeholder="请输入门店名称"></el-input>
               </el-form-item>
               <el-form-item label="商城管理" prop="is_mall">
                   <el-select style="width:220px" size="small" v-model="queryForm.is_mall" placeholder="请选择">
                       <el-option
                           v-for="item in mallOptions"
                           :key="item.value"
                           :label="item.label"
                           :value="item.value">
                       </el-option>
                   </el-select>
               </el-form-item>
               <el-form-item label="商品自营" prop="is_self">
                   <el-select style="width:220px" size="small" v-model="queryForm.is_self" placeholder="请选择">
                       <el-option
                           v-for="item in selfOptions"
                           :key="item.value"
                           :label="item.label"
                           :value="item.value">
                       </el-option>
                   </el-select>
               </el-form-item>
               <!-- <el-form-item label="商品返佣" prop="is_commission">
                   <el-select style="width:220px" size="small" v-model="queryForm.is_commission" placeholder="请选择">
                       <el-option
                           v-for="item in commissionOptions"
                           :key="item.value"
                           :label="item.label"
                           :value="item.value">
                       </el-option>
                   </el-select>
               </el-form-item> -->
               <el-form-item >
                   <el-button type="primary" icon="el-icon-search" @click="query">查询</el-button>
                   <el-button icon="el-icon-refresh" @click="reset('queryForm')">重置</el-button>
               </el-form-item>
           </el-form>
       </div>
       <el-col :span="24" style="margin:10px 0;">
           <el-button  type="primary" size="small" @click="addStore">添加门店</el-button>
       </el-col>
       <!-- 数据表格 -->
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
           <el-table-column prop="is_mall" align="center" label="商城管理" :formatter="is_mall"></el-table-column>
           <!-- <el-table-column prop="is_commission" align="center" label="商品返佣" :formatter="is_commission"></el-table-column> -->
           <el-table-column prop="is_goods_self" align="center" label="商品自营" :formatter="is_goods_self"></el-table-column>
           <el-table-column prop="is_self_lifting" align="center" label="商品自提">
            <template slot-scope="scope">
              {{scope.row.is_self_lifting==0?'不支持':'支持'}}
            </template>
           </el-table-column>
           <el-table-column label="操作" align="center" fixed="right" width="240px">
               <template slot-scope="scope">
                   <el-button
                       size="mini"
                       type="primary"
                       @click="handleDes(scope.row)">详情</el-button>
                   <el-button
                       size="mini"
                       type="primary"
                       @click="handleGoods(scope.row)">商品</el-button>
                   <el-button
                       size="mini"
                       type="primary"
                       @click="handleSet(scope.row)">权限</el-button>
               </template>
           </el-table-column>
        </el-table>
         <pagination
           v-show="+total>10"
           :total="+total"
           :page.sync="queryForm.pageNum"
           :limit.sync="queryForm.pageSize"
           @pagination="getList"/>
       <!-- 详情弹窗 -->
       <el-dialog title="门店详情" :visible.sync="dialogVisible" width="50%" @close="dialogVisible=false">
           <el-descriptions title="详细信息" :column="2" >
               <el-descriptions-item label="门店图片">
               <div class="block" v-for="(item,index) in storeInfo.cover" :key="index">
                   <el-image
                       style="width: 100px; height: 100px"
                       v-if="index<=0"
                       :src="item.url"
                       :preview-src-list="storeInfo.cover.map(item=>item.url)"
                       fit="fill"></el-image>
               </div>
               </el-descriptions-item>
               <el-descriptions-item label="门店编号">{{storeInfo.store_code}}</el-descriptions-item>
               <el-descriptions-item label="门店名称">{{storeInfo.store_name}}</el-descriptions-item>
               <el-descriptions-item label="门店地址">{{storeInfo.address}}</el-descriptions-item>
               <el-descriptions-item label="GPS位置">{{storeInfo.gps}}</el-descriptions-item>
               <el-descriptions-item label="负责人名称">{{storeInfo.person}}</el-descriptions-item>
               <el-descriptions-item label="门店电话">{{storeInfo.telephone}}</el-descriptions-item>
               <el-descriptions-item label="门店账号">{{storeInfo.mobile_phone}}</el-descriptions-item>
               <el-descriptions-item label="人均价格">{{storeInfo.average_price}}</el-descriptions-item>
               <el-descriptions-item label="营业时间">{{storeInfo.time|business_hours}}</el-descriptions-item>
               <el-descriptions-item label="商城管理">{{storeInfo.is_mall==1?'已启用':'未启用'}}</el-descriptions-item>
               <el-descriptions-item label="商城返佣">{{storeInfo.is_commission==1?'已启用':'未启用'}}</el-descriptions-item>
               <el-descriptions-item label="商品自营">{{storeInfo.is_goods_self==1?'已启用':'未启用'}}</el-descriptions-item>
               <el-descriptions-item label="商品自提">{{storeInfo.is_self_lifting==1?'已启用':'未启用'}}</el-descriptions-item>
           </el-descriptions>
            <el-descriptions title="交易信息" :column="4" >
               <el-descriptions-item label="累计成交订单数">0</el-descriptions-item>
               <el-descriptions-item label="累计成交商品数">0</el-descriptions-item>
               <el-descriptions-item label="累计交易金额">0</el-descriptions-item>
               <el-descriptions-item label="累计交易返佣">0</el-descriptions-item>
            </el-descriptions>
            <el-descriptions title="佣金信息（通过门店商城商品销售产生的佣金）" :column="3" >
               <el-descriptions-item label="佣金提现次数">0</el-descriptions-item>
               <el-descriptions-item label="累计佣金总额">0</el-descriptions-item>
               <el-descriptions-item label="当前账户余额">0</el-descriptions-item>
            </el-descriptions>
       </el-dialog>
       <!-- 权限设置 -->
      <el-dialog title="权限设置" :visible.sync="authDialogVisible" width="50%" @close="authDialogVisible=false">
        <el-form ref="authForm" :model="authForm" label-width="120px" size="small">
          <el-form-item label="商城管理：">
            <el-radio-group v-model="authForm.is_mall">
              <el-radio :label="0">未启用</el-radio>
              <el-radio :label="1">已启用</el-radio>
            </el-radio-group>
          </el-form-item>
          <el-form-item label="商城自营：">
            <el-radio-group v-model="authForm.is_goods_self">
              <el-radio :label="0">未启用</el-radio>
              <el-radio :label="1">已启用</el-radio>
            </el-radio-group>
          </el-form-item>
          <!-- <el-form-item label="商城返佣金：">
            <el-radio-group v-model="authForm.is_commission">
              <el-radio :label="0">未启用</el-radio>
              <el-radio :label="1">已启用</el-radio>
            </el-radio-group>
          </el-form-item> -->
          <el-form-item label="支持自提：">
            <el-radio-group v-model="authForm.is_self_lifting">
              <el-radio :label="0">未启用</el-radio>
              <el-radio :label="1">已启用</el-radio>
            </el-radio-group>
          </el-form-item>
        </el-form>
        <div slot="footer" class="dialog-footer">
          <el-button @click="authDialogVisible = false">取 消</el-button>
          <el-button type="primary" @click="saveAuthForm">保 存</el-button>
        </div>
      </el-dialog>
       <!-- 链接生成二维码网址 -->
       <CopyDialog :copyDialogVisible="copyDialogVisible" :title="copyTitle" :url="copy_url" @close="closeCopyDialog"/>
  </div>
</template>

<script>
import {
   getDistributorLevelList,
   getSuperiorDistributorList,
   getAllSuperiorDistributorList
} from '@/api/customer/distributor'
import {getStoreList,getStoreInfo,saveStoreAuth} from '@/api/app/store/index'
import{getCustomerAreaList} from '@/api/customer/basics'
import CopyDialog from '@/components/CopyDialog'
import QRCode from 'qrcodejs2'
import { mapGetters } from 'vuex'
export default {
   components:{
       CopyDialog
   },
   data(){
       return{
          authForm:{
            id:'',
            is_mall:0,
            is_goods_self:0,
            is_commission:0,
            is_self_lifting:0
          },
           authDialogVisible:false,
           invitationDialog:false,
           copyDialogVisible:false,
           copyTitle:'复制链接',
           copy_url:'',
           activeName:'first',
           queryForm:{
               store_code:'',
               store_name:'',
               is_mall:'',
               is_self:'',
               is_commission:'',
               pageNum:1,
               pageSize:10
           },
           mallOptions:[
            {
              label:'未启用',
              value:0
            },
            {
              label:'已启用',
              value:1
            }
           ],
           selfOptions:[
            {
              label:'未启用',
              value:0
            },
            {
              label:'已启用',
              value:1
            }
           ],
           commissionOptions:[
              {
                label:'未启用',
                value:0
              },
              {
                label:'已启用',
                value:1
              }
           ],
           queryTypeForm:{
               pageNum:1,
               pageSize:999
           },
           zoneOptions:[],
           statusOptions:[],//门店状态
           levelOption:[],//经销商级别选项
           typeOptions:[],
           zoneProps:{
               label:'area_name',
               value:'id',
               checkStrictly:true
           },
           superiorDisVisible:false,
           querySuperiorDisForm:{
               distributor_name:'',
               level_id:'',
               pageNum:1,
               pageSize:10
           },
           tableData:[],
           superiorDis:[],
           allSuperiorDis:[],//所有上级经销商
           total:0,
           totals:0,
           dialogVisible:false,
           storeInfo:{}
       }
   },
   created(){
       this.getList()
       this.getDicts({type:'store_status'}).then(res=>{
           this.statusOptions=res.data
       })
   },
   computed:{
       ...mapGetters([
           'dealer_id'
       ]),
   },
   filters:{
       business_hours:function(value){
           if(!value) return '--'
           return JSON.parse(value).join('~')
       },
       cover:function(value){
           return JSON.parse(value)
       }
   },
   methods:{
       getList(){
           var params=Object.assign({},this.queryForm)
           getStoreList(params).then(res=>{
               this.tableData=res.data
               this.total=res.total
           })
       },
       getZoneList(){
           getCustomerAreaList({}).then(res=>{
               this.zoneOptions=this.setTreeLevel(this.handleTree(res.data, "id"),1);
           })
       },
       getDisLevel(){
           getDistributorLevelList({}).then(res=>{
               this.levelOption=res.data
           })
       },
       getSuperiorDis(){
           getSuperiorDistributorList(this.querySuperiorDisForm).then(res=>{
               this.superiorDisVisible=true
               this.superiorDis=res.data
               this.totals=res.total
           })
       },
       handleSelectMain(){
           this.queryForm.distributor_id=0
           this.queryForm.distributor_name='总部'
           this.superiorDisVisible=false
       },
       handleSelect(row){
           this.queryForm.distributor_name=row.distributor_name
           this.queryForm.distributor_id=row.id
           this.superiorDisVisible=false
       },
       level(row){
           return this.levelOption.filter(item=>item.id==row.distributor_level).map(item=>item.level_name)[0]
       },
       closeCopyDialog(val){
           this.copyDialogVisible=val
       },
       is_mall(row){
          return this.mallOptions.filter(item=>item.value==row.is_mall).map(item=>item.label)[0]
       },
       is_commission(row){
          return this.commissionOptions.filter(item=>item.value==row.is_commission).map(item=>item.label)[0]
       },
       is_goods_self(row){
        return this.selfOptions.filter(item=>item.value==row.is_goods_self).map(item=>item.label)[0]
       },
       check_status(row){
           return row.check_status==2?'未通过':'待审核'
       },
       status(row){
           return this.statusOptions.filter(item=>item.dict_value==row.status).map(item=>item.dict_label)[0]
       },
       querySuperiorDis(){
           this.querySuperiorDisForm.pageNum = 1;
           this.getSuperiorDis();
       },
       addStore(type){
           this.$router.push({path:'/customer/store/storeList'})
       },
       handleGoods(row){},
       handleDes(row){
           getStoreInfo({id:row.id}).then(res=>{
               this.dialogVisible=true
               this.storeInfo=res.data
               this.storeInfo.cover=JSON.parse(res.data.cover)
           })
       },
       handleSet(row){
        this.authForm={
          id:row.id,
          is_mall:row.is_mall,
          is_goods_self:row.is_goods_self,
          is_commission:row.is_commission,
          is_self_lifting:row.is_self_lifting
        }
        this.authDialogVisible=true
       },
       saveAuthForm(){
        saveStoreAuth(this.authForm).then(res=>{
          if(res.code==200){
              this.$message.success(res.msg)
              this.authDialogVisible=false
              this.getList()
          }else{
              this.$message.error(res.msg)
          }
        })
       },
       handleClick(){
           this.tableData=[]
           this.reset('queryForm')
       },
       handleLogin(){
           this.copyDialogVisible=true,
           this.copy_url='store.ctc.com'
       },
       nearby(){
         this.copyDialogVisible=true,
         this.copy_url='http://yx.gawxg.com/vicinity/?dealer_id='+this.dealer_id
       },
       creatQrCode(){
           this.$refs.qrCodeUrl.innerHTML = ''
           var qrcode = new QRCode(this.$refs.qrCodeUrl, {
               text: this.inviteForm.url, // 需要转换为二维码的内容
               width: 120,
               height: 120,
               colorDark: '#000000',
               colorLight: '#ffffff',
               correctLevel: QRCode.CorrectLevel.H
           })
       },
       copy(){
           var clipboard = new this.clipboard('.copy')
           clipboard.on('success', e => {
               this.$message.success('已经复制到剪贴板')
               //  释放内存
              clipboard.destroy();
           })
           clipboard.on('error', e =>{
               // 不支持复制
               this.$message.warning('该浏览器不支持复制')
               // 释放内存
              clipboard.destroy();
           })
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

<style lang="scss" scoped>
.app-container .tips{
   padding: 6px 16px;
   background-color: #ecf8ff;
   border-radius: 4px;
   border-left: 5px solid #50bfff;
   margin: 10px 0;
   p{
       font-size: 14px;
   }
}
.dialog-footer{
 margin: 20px 0;
}
.qrcode-box{
   display: flex;
   justify-content: center;
   align-items: center;
   flex-direction: column;
   border-right: 1px solid #ccc;
   .tip{
       margin-top: 15px;
   }
}
.url-box{
   display: flex;
   justify-content: center;
   height: 150px;
   flex-direction: column;
   padding-left: 20px;
}
.qrcode{
   display: inline-block;
   img {
       width: 132px;
       height: 132px;
       background-color: #fff; //设置白色背景色
       padding: 6px; // 利用padding的特性，挤出白边
       box-sizing: border-box;
   }
}
</style>
