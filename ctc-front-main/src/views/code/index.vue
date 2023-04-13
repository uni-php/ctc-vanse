<template>
  <div class="app-container">
      <div class="tab-bar">
        <el-form ref="queryForm" :model="queryForm" label-width="80px" :inline="true" size="small">
                <el-form-item label="合伙人" prop="partner">
                    <el-input style="width:200px" v-model="queryForm.partner" placeholder="请输入合伙人"></el-input>
                </el-form-item>
                <el-form-item label="品牌商" prop="dealer">
                    <el-input style="width:200px" v-model="queryForm.dealer" placeholder="请输入品牌商"></el-input>
                </el-form-item>
                <el-form-item label="类型" prop="type">
                    <el-select style="width:200px" size="small" v-model="queryForm.type" placeholder="请选择生码类型">
                        <el-option
                            v-for="item in options"
                            :key="item.dict_value"
                            :label="item.dict_label"
                            :value="item.dict_value">
                        </el-option>
                    </el-select>
                </el-form-item>
                <el-form-item label="应用场景" prop="scene">
                    <el-select style="width:200px" size="small"  v-model="queryForm.scene" placeholder="请选择应用场景">
                        <el-option
                            v-for="item in sceneOptions"
                            :key="item.dict_value"
                            :label="item.dict_label"
                            :value="item.dict_value">
                        </el-option>
                    </el-select>
                </el-form-item>
                <el-form-item label="备注说明" prop="mark">
                    <el-input style="width:200px" v-model="queryForm.mark" placeholder="请输入备注"></el-input>
                </el-form-item>
                <el-form-item > 
                    <el-button type="primary" icon="el-icon-search" @click="query">查询</el-button>
                    <el-button icon="el-icon-refresh" @click="reset('queryForm')">重置</el-button>
                </el-form-item>
        </el-form>
      </div>
      <el-col :span="24" style="margin:10px 0;">
        <el-button type="primary" style="font-size:14px" size="small" >生码总量：{{sum}}</el-button>
      </el-col>
      <!-- 表格区域 -->
      <el-table
      :data="tableData"
      :header-cell-style="{background:'#FAFAFA',color:'#606266',height:'50px'}"
      border
      stripe
      size="medium"
      class="trace-table"
      style="width: 100%">
      <el-table-column prop="partner_company" align="center" label="合伙人公司名称" width="180px"></el-table-column>
      <el-table-column prop="partner_account" align="center" label="合伙人账号" width="120px"></el-table-column>
      <el-table-column prop="dealer_name" align="center" label="品牌商名称" show-overflow-tooltip></el-table-column>
      <el-table-column prop="account" align="center" label="品牌商账号" width="120px"></el-table-column>
      <el-table-column prop="batch" align="center" label="批次号"></el-table-column>
      <el-table-column prop="scene" align="center" label="应用场景">
          <template slot-scope="scope">
            <span v-for="(item,index) in scene(scope.row.scene)" :key="index" :class="{active:item.dict_value==4}" @click="handleViewDes(scope.row,item)">
                  {{item.dict_label}}
                  <span v-if="item.dict_value==2">{{scope.row.verification_code==1?'(验证码)':''}}</span>
                  <span v-if="scope.row.prize&&item.dict_value==3" :class="{active:scope.row.prize==2}" >{{scope.row.prize==1?'(单奖模式)':'(双奖模式)'}}</span>
                  <span v-show="index!=scene(scope.row.scene).length-1">、</span>
            </span>
          </template>
      </el-table-column>
      <el-table-column prop="order" align="center" show-overflow-tooltip label="流水号范围">
           <template slot-scope="scope">
              <span>{{scope.row.order_begin}} - {{scope.row.order_end}}</span>
          </template>
      </el-table-column>
      <el-table-column prop="count" align="center" label="数量"></el-table-column>
      <el-table-column prop="code_type" align="center" label="类型">
          <template slot-scope="scope">
              <span>{{scope.row.code_type==1?'普通码':"小程序码"}}</span>
          </template>
      </el-table-column>
      <el-table-column prop="used_num" align="center" label="已启用数量" :formatter="used_num"></el-table-column>
      <el-table-column prop="create_time" align="center" show-overflow-tooltip label="生码时间"></el-table-column>
      <el-table-column prop="remark" align="center" label="备注说明" show-overflow-tooltip></el-table-column>
      <el-table-column prop="product_name" align="center" label="关联产品">
          <template slot-scope="scope">
              <span v-if="scope.row.is_rel==0">未关联</span>
              <span class="rel-product" @click="handleMoreProduct(scope.row)" v-if="scope.row.is_rel==1&&!scope.row.rel_product_id">多产品</span>
              <span v-if="scope.row.is_rel==1&&scope.row.rel_product_id">{{scope.row.rel_product_name}}</span>
          </template>
      </el-table-column>
      <el-table-column prop="status" align="center" label="状态">
           <template slot-scope="scope">
               <span>{{scope.row.status==0?'未启用':scope.row.status==1?'全部启用':'部分启用'}}</span>
           </template>
      </el-table-column>
      <el-table-column label="操作" align="center" fixed="right" width="240px">
        <template slot-scope="scope">
          <!-- <el-button
            size="mini"
            type="primary"
            @click="handleImport(scope.row)">导入</el-button> -->
            <el-button
            size="mini"
            type="text"
             v-hasPermi="['codeStore:code:key']"
            icon="el-icon-key"
            @click="handleKey(scope.row)">秘钥</el-button>
            <el-button
            size="mini"
            type="text"
            icon="el-icon-download"
            @click="handleDown(scope.row)">下载</el-button>
          <el-button
            size="mini"
            type="text"
            v-hasPermi="['codeStore:code:delete']"
            @click="handleDelete(scope.row)">删除</el-button>
        </template>
      </el-table-column>
    </el-table>
    <pagination
        v-show="+total>10"
        :total="+total"
        :page.sync="queryForm.pageNum"
        :limit.sync="queryForm.pageSize"
        @pagination="getList"
     />
     <el-dialog title="秘钥" :visible.sync="keyDialog" width="40%" append-to-body>
        <el-form ref="keyForm" :model="keyForm" label-width="130px">
            <!-- <el-form-item label="URL前缀:" prop="prefix">
                <el-input readonly="" v-model="keyForm.prefix" />
            </el-form-item> -->
            <el-form-item label="生码秘钥:" prop="key" v-if="keyForm.keys.length==0">
                <el-input readonly="" v-model.number="keyForm.key"/>
            </el-form-item>
            <el-form-item v-for="(item,index) in keyForm.keys" :key="index" :label="(index+1)+'级包装生码秘钥:'" prop="key">
                <el-input readonly="" v-model.number="item.key"/>
            </el-form-item>
        </el-form>
     </el-dialog>
      <!-- 物流码明细 -->
    <el-dialog title="物流码明细" :visible.sync="logisticsDialog" width="50%" class="logistics">
        <div><span>物流码类型：</span>{{logisticsCodeInfo.rel_logistics_code_order==1?'先关联':'后关联'}}</div>
        <div><span>包装类型：</span>{{packing_type}}</div>
        <div><span>规格：</span>{{specifications}}</div>
        <div><span>物流码明细：</span>{{logistics_code_detail}}</div>
    </el-dialog>
    <!-- 双奖模式明细 -->
    <el-dialog :title="prizeTitle" :visible.sync="prizeDialog" width="30%" class="prizeDialog">
        <div class="prize-box">
            <div class="prize-box-left">
                领奖顺序
            </div>
            <div class="prize-box-right">
                <div class="prize-box-right-top">
                    {{dislof_prize_order}}
                </div>
                <div class="prize-box-right-bottom">
                    {{prize_order_des}}
                </div>
            </div>
        </div>
    </el-dialog>
    <!-- 查看多产品关联 -->
    <el-dialog title="关联产品" :visible.sync="viewRelDialog" width="50%" @close="viewRelDialog=false">
         <el-table
            :data="relProductData"
            :header-cell-style="{background:'#FAFAFA',color:'#606266',height:'50px'}"
            border
            stripe
            size="medium"
            class="trace-table"
            style="width: 100%">
            <el-table-column prop="id" align="center" label="序号"></el-table-column>
            <el-table-column prop="id" align="center" label="关联区间">
                <template slot-scope="scope">
                    <span>{{scope.row.start_code}}-{{scope.row.end_code}}</span>
                </template>
            </el-table-column>
            <el-table-column prop="quantity" align="center" label="数量"></el-table-column>
            <el-table-column prop="product_name" align="center" label="产品名称"></el-table-column>
            <el-table-column prop="remark" align="center" label="备注说明"></el-table-column>
            <el-table-column prop="create_time" align="center" label="添加时间"></el-table-column>
        </el-table>
            <pagination
                v-show="+relProductTotal>10"
                :total="+relProductTotal"
                :page.sync="queryRelProductFrom.pageNum"
                :limit.sync="queryRelProductFrom.pageSize"
                @pagination="getRelProduct"
            />
    </el-dialog>
  </div>
</template>

<script>
import {listCode,deleCode,getRelProduct,checkCode,downLoad} from "@/api/code/index"
export default {
    data(){
        return{
            relProductData:[],
            relProductTotal:0,
            queryForm:{
                partner:'',//合伙人
                dealer:'',//品牌商
                type:'',
                scene:'',
                mark:'',
                pageNum:1,
                pageSize:10
            },
            prizeTitle:'',
            logisticsDialog:false,
            logisticsCodeInfo:{},
            dislof_prize_order:'',
            prize_order_des:'',
            keyDialog:false,
            prizeDialog:false,
            viewRelDialog:false,
            keyForm:{
               prefix:'trace.union-aid.com',
               key:'',
               keys:[],//单独物流码秘钥
            },
            queryRelProductFrom:{
                pageNum:1,
                pageSize:10
            },
            sum:0,
            total:0,
            options:[],
            sceneOptions:[
            ],
            tableData:[
            ],
        }
    },
    created(){
        this.getList()
        this.getDicts({type:'code_type'}).then(res=>{
            this.options=res.data
        })
        this.getDicts({type:'code_scene'}).then(res=>{
            this.sceneOptions=res.data
        })
    },
    computed:{
        scene(){
            return function(value){
                return this.sceneOptions.filter(item=>value.split(',').includes(item.dict_value))
            }
        },
         //包装类型
        packing_type:function(){
            if(this.logisticsCodeInfo.rel_logistics_code_order==2) return '--'
            if(this.logisticsCodeInfo.rel_logistics_code_order==1){
                var level=JSON.parse(this.logisticsCodeInfo.logistics_level_item).length
                return `${+level+1}级包装`
            }
        },
        //包装规格
        specifications:function(){
            if(this.logisticsCodeInfo.rel_logistics_code_order==2) return '--'
            if(this.logisticsCodeInfo.rel_logistics_code_order==1){
                var scale=JSON.parse(this.logisticsCodeInfo.logistics_level_item)
                var text=scale.map(item=>`拖${item.num}`)
                return `1${text.join('')}`
            }
        },
        //物流码明细
        logistics_code_detail:function(){
            console.log(this.logisticsCodeInfo)
            var arr=this.logisticsCodeInfo.secret_key
            if(!arr) return '-'
            var text='大码：'
            if(arr.length==0){
                return `${this.logisticsCodeInfo.order_begin}--${this.logisticsCodeInfo.order_end}`
            }else{
                if(arr.length==1) text='小码：'
               arr.forEach((item,index)=>{
                   text+=item.order+'\n'+(index==arr.length-1?'':'小码：')
               })
               return text
            } 

        }
    },
    methods:{
        getList(){
            var arr=Object.assign({},this.queryForm)
            // if(arr.scene.length>0){
            //     arr.scene=arr.scene.join(',')
            // }else{
            //     arr.scene=''
            // }
            listCode(arr).then(res=>{
              this.total=res.total
              this.tableData=res.data
              this.sum=res.sum
            })
        },
        //已启用数量
        used_num(row){
            if(row.status==0) return 0;
            if(row.status==1) return row.count
            if(row.status==2) return row.used_num
        },
        handleMoreProduct(row){
            this.queryRelProductFrom.pageNum=1
            this.queryRelProductFrom.batch=row.batch
            this.queryRelProductFrom.dealer_id=row.dealer_id
            this.queryRelProductFrom.partner_id=row.partner_id
            this.getRelProduct()
            this.viewRelDialog=true
        },
        getRelProduct(){
            getRelProduct(this.queryRelProductFrom).then(res=>{
                if(res.total==1&&res.data[0]['is_rel_all']==1){
                    this.relProductData=[]
                    this.relProductTotal=0
                    // this.relAllForm.product_name=res.data[0]['product_name']
                    // this.relAllForm.product_id=res.data[0]['product_id']
                    // this.relAllForm.remark=res.data[0]['remark']
                    // this.relAllForm.batch=res.data[0].batch
                }else{
                    this.relProductData=res.data
                    this.relProductTotal=res.total
                    this.rel_count=res.rel_count
                    // this.relAllForm.product_name=''
                    // this.relAllForm.product_id=''
                    // this.relAllForm.remark=''
                    // this.relAllForm.batch=''
                }
            })
        },
        handleViewDes(row,item){
            if(item.dict_value==4){
                this.logisticsDialog=true
                this.logisticsCodeInfo=row
            }
            //导购码 双奖模式
            if(item.dict_value==3&&row.prize==2){
                this.prizeDialog=true
                var ob=this.prizeOrderOptions.filter(item=>item.dict_value==row.prize_order)
                this.dislof_prize_order=ob.map(item=>item.dict_label)[0]
                this.prize_order_des=ob.map(item=>item.remark)[0]
            }
        },
        //下载码包
        handleDown(row){
            downLoad({batch:row.batch}).then(res=>{
                const content = res 
                const blob = new Blob([content],{type:"application/zip"})
                var timestamp = (new Date()).valueOf();
                const fileName = `${row.dealer_name}-${row.batch}`+'.zip'
                if ('download' in document.createElement('a')) { // 非IE下载
                    const elink = document.createElement('a')
                    elink.download = fileName
                    elink.style.display = 'none'
                    elink.href = window.URL.createObjectURL(blob)
                    document.body.appendChild(elink)
                    elink.click()
                    window.URL.revokeObjectURL(elink.href) // 释放URL 对象
                    document.body.removeChild(elink)
                } else { // IE10+下载
                    navigator.msSaveBlob(blob, fileName)
                }
            })
        },
        handleImport(){

        },
        handleKey(row){
            this.keyDialog=true
            this.keyForm.key=''
            this.keyForm.keys=[]
            if(row.secret_key.length==0){
                this.keyForm.key=row.key
            }else{
                this.keyForm.keys=row.secret_key
            }
        },
        handleDelete(row){
            this.$prompt('请输入管理密码', '提示', {
                confirmButtonText: '确定',
                cancelButtonText: '取消',
                inputErrorMessage: ''
                }).then(({ value }) => {
                //开始删除
                if(!value){
                    this.$message.error('请输入密码')
                    return
                }
                deleCode({id:row.id,pwd:value}).then(res=>{
                    if(res.code==200){
                        this.getList();
                        this.$message.success(res.msg)
                    }else{
                        this.$message.error(res.msg)
                    }
                })
                }).catch(() => {   
            });
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
.rel-product,.active{
    color: #409EFF;
    cursor: pointer;
}
.logistics{
    div{
        margin: 10px 0;
        padding: 10px;
        box-sizing: border-box;
        display: flex;
        align-items: center;
        border: 1px solid #eeeeee;
        span{
            width: 100px;
            display: inline-block;
            height: 20px;
            line-height: 20px;
            margin-right: 15px;
            text-align: left;
            border-right: 1px solid #eeeeee;
        }
    }
}
.prizeDialog{
    .prize-box{
        width: 100%;
        min-height:200px;
        display: flex;
        justify-content: space-between;
        align-items: center;
        flex-direction: row;
        border:1px solid #eeeeee;
        .prize-box-left{
            width: 30%;
            height: 200px;
            display: flex;
            padding: 10px;
            justify-content: flex-start;
            align-items: center;
            border-right: 1px solid #eeeeee;
        }
        .prize-box-right{
            width: 70%;
            height: 200px;
            display: flex;
            justify-content: flex-start;
            align-items: center;
            flex-direction: column;
            .prize-box-right-top{
                width: 100%;
                height: 30%;
                display: flex;
                padding: 10px;
                justify-content: flex-start;
                align-items: center;
                border-bottom: 1px solid #eeeeee;
            }
            .prize-box-right-bottom{
                width: 100%;
                height: 70%;
                display: flex;
                padding: 10px;
                justify-content: flex-start;
                align-items: center;
            }
        }
    }
}
</style>