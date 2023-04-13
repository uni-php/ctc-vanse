<template>
  <div class="app-container">
    <div class="tips">
        <p>追踪查询</p>
    </div>
    <div class="tab-bar">
        <el-form ref="queryForm" :model="queryForm" label-width="100px" :inline="true" size="small">
            <el-form-item label="可选码批次" prop="batch">
                <el-select style="width:260px" size="small" clearable=""  v-model="queryForm.batch" placeholder="请选择码批次">
                    <el-option
                        v-for="item in batchOption"
                        :key="item.id"
                        :label="item.batch+'--'+'('+item.order_begin+'~'+item.order_end+')'"
                        :value="item.batch">
                    </el-option>
                </el-select>
            </el-form-item>
            <el-form-item label="请输入物流码" prop="code">
                <el-input clearable="" style="width:260px" v-model="queryForm.code" placeholder="请输入物流码"></el-input>
            </el-form-item>
            <el-form-item > 
                <el-button type="primary" icon="el-icon-search" @click="query">查询</el-button>
                <el-button icon="el-icon-refresh" @click="resetQuery('queryForm')">重置</el-button>
            </el-form-item>
        </el-form>
    </div>
    <!-- 基本信息 -->
    <div class="content-box" v-if="is_active">
        <el-descriptions class="margin-top" title="基本信息" :column="1"  border v-if="baseInfo.log[0]">
            <el-descriptions-item label="状态">{{baseInfo.log[4]}}</el-descriptions-item>
            <el-descriptions-item label="标签类型">{{baseInfo.info.code_type==1?'大标':'小标'}}</el-descriptions-item>
            <el-descriptions-item label="批号">{{baseInfo.info.batch}}</el-descriptions-item>
            <el-descriptions-item label="包装类型">{{baseInfo.info.scale.join('/')}}</el-descriptions-item>
            <el-descriptions-item label="产品代码">{{baseInfo.log[0]['barcode']}}</el-descriptions-item>
            <el-descriptions-item label="产品名称">{{baseInfo.log[0]['product_name']}}</el-descriptions-item>
            <el-descriptions-item label="产品规格">{{baseInfo.log[0]['specifications']}}</el-descriptions-item>
            <el-descriptions-item label="产品数量">{{baseInfo.info['rk_num']}}</el-descriptions-item>
            <el-descriptions-item label="生产日期">{{baseInfo.log[0]['manufacture_time']}}</el-descriptions-item>
            <el-descriptions-item label="有效日期">{{baseInfo.log[0]['validity_time']}}</el-descriptions-item>
        </el-descriptions>
        
        <!-- 物流信息 -->
        <el-descriptions class="margin-top" title="入库信息" :column="1"  border v-if="baseInfo.log[0]" style="margin-top:20px">
            <el-descriptions-item label="日期">{{baseInfo.log[0]['create_time']}}</el-descriptions-item>
            <el-descriptions-item label="入库单号">{{baseInfo.log[0]['rk_order']}}</el-descriptions-item>
            <el-descriptions-item label="入库仓库">{{warehouse(baseInfo.log[0]['warehouse_id'])}}</el-descriptions-item>
            <el-descriptions-item label="入库产品">{{baseInfo.log[0]['product_name']}}</el-descriptions-item>
            <el-descriptions-item label="操作人">{{baseInfo.log[0]['create_by']||'--'}}</el-descriptions-item>
        </el-descriptions>
         <el-descriptions class="margin-top" title="出库信息" :column="1"  border v-if="baseInfo.log[1]" style="margin-top:20px">
            <el-descriptions-item label="日期">{{baseInfo.log[1]['create_time']}}</el-descriptions-item>
            <el-descriptions-item label="出库单号">{{baseInfo.log[1]['ck_order']}}</el-descriptions-item>
            <el-descriptions-item label="出货仓库">{{warehouse(baseInfo.log[1]['warehouse_id'])}}</el-descriptions-item>
            <el-descriptions-item label="出货产品">{{baseInfo.log[1]['product_name']}}</el-descriptions-item>
            <el-descriptions-item label="收货客户">{{baseInfo.log[1]['customer_name']}}</el-descriptions-item>
            <el-descriptions-item label="是否赠品">{{baseInfo.log[1]['is_gift']==0?'否':'是'}}</el-descriptions-item>
            <el-descriptions-item label="操作人">{{baseInfo.log[0]['create_by']||'--'}}</el-descriptions-item>
        </el-descriptions>
        <el-descriptions class="margin-top" title="退货信息" :column="1"  border v-if="baseInfo.log[2]" style="margin-top:20px">
            <el-descriptions-item label="日期">{{baseInfo.log[2]['create_time']}}</el-descriptions-item>
            <el-descriptions-item label="退货单号">{{baseInfo.log[2]['th_order']}}</el-descriptions-item>
            <el-descriptions-item label="退货客户">{{baseInfo.log[2]['customer_name']}}</el-descriptions-item>
            <el-descriptions-item label="退货产品">{{baseInfo.log[2]['product_name']}}</el-descriptions-item>
        </el-descriptions>
         <el-descriptions class="margin-top" title="调仓信息" :column="1"  border v-if="baseInfo.log[3]" style="margin-top:20px">
            <el-descriptions-item label="日期">{{baseInfo.log[3]['create_time']}}</el-descriptions-item>
            <el-descriptions-item label="调仓单号">{{baseInfo.log[3]['dc_order']}}</el-descriptions-item>
            <el-descriptions-item label="调出仓库">{{warehouse(baseInfo.log[3]['out_warehouse_id'])}}</el-descriptions-item>
            <el-descriptions-item label="调入仓库">{{warehouse(baseInfo.log[3]['in_warehouse_id'])}}</el-descriptions-item>
            <el-descriptions-item label="入库产品">{{baseInfo.log[3]['product_name']}}</el-descriptions-item>
        </el-descriptions>
        <!-- 数码关联信息 -->
        <el-descriptions class="margin-top" title="数码信息" :column="1"  border  style="margin-top:20px">
        </el-descriptions>  
        <div class="order-content-box">
            <div class="table-head">
                <span v-for="(item,index) in baseInfo.code" :key="index" :style="{'width':100/(baseInfo.code.length)+'%'}" class="head-item">{{index==0?'大标':'小标'}}</span>
            </div>
            <div class="table-item"   v-for="(item,index) in baseInfo.code[baseInfo.code.length-1]" :key="index">
                <span v-for="(item1,index1) in baseInfo.code" :key="index+'a'+index1" :style="{'width':100/(baseInfo.code.length)+'%','color':is_code(item,index1,index)?'red':''}" class="content-item">{{code(index1,index)}}</span>
            </div>
        </div>

    </div>
  </div>
</template>

<script>
import {getLogCodeBatch,queryCodeLink} from '@/api/app/logistics/query'
import {getWarehouseList} from '@/api/app/logistics/basic'
export default {
    data(){
        return{
            batchOption:[],
            queryForm:{
                code:'',
                batch:''
            },
            queryWareForm:{
                keywords:'',
                pageNum:1,
                pageSize:999
            },
            warehouseOption:[],
            is_active:false,
            baseInfo:{
                code:[],
                log:[]
            }
        }
    },
    created(){
        this.getTraceCodeBatch()
        this.getWarehouseList()
    },
    methods:{
        code(a,b){
			return this.baseInfo.code[a][b]
		},
        is_code(item,a,b){
            if(!this.baseInfo.code[a][b]) return false
            return this.baseInfo.code[a][b].includes(this.queryForm.code)
        },
        warehouse(val){
            return this.warehouseOption.filter(item=>item.id==val).map(item=>item.warehouse_name)[0]
        },
         getWarehouseList(){
            getWarehouseList(this.queryWareForm).then(res=>{
                this.warehouseOption=res.data
            })
        },
        getTraceCodeBatch(){
            getLogCodeBatch({}).then(res=>{
               this.batchOption=res.data 
            })
        },
        getList(){
            if(!this.queryForm.batch) return this.$message.warning('请选择产品批次')
            if(!this.queryForm.code) return this.$message.warning('请输入物流码')
            queryCodeLink(this.queryForm).then(res=>{
                if(res.code==200){
                     this.baseInfo=res.data
                     this.is_active=true
                     this.$message.success(res.msg)
                }else{
                    this.is_active=false
                    this.$message.error(res.msg)
                }
            })
        },
        query(){
            this.getList()
        },
        resetQuery(formName){
            this.$refs[formName].resetFields();
            this.is_active=false
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
.content-box{
    width: 100%;
    height: auto;
    display: flex;
    justify-content: center;
    align-items: center;
    flex-direction: column;
    ::v-deep .el-descriptions{
        width: 100%;
    }
    .order-content-box{
				width: 100%;
				display: flex;
				justify-content: center;
				align-items: center;
				flex-direction: column;
				box-sizing: border-box;
				// margin-top: 10px;
				border: 1px solid #c8c7cc;
				.table-head{
					width: 100%;
					height: 30px;
					display: flex;
					justify-content: center;
					align-items: center;
					// background: #caddf2;
					font-size: 14px;
					.head-item{
						height: 100%;
						display: flex;
						justify-content: center;
						align-items: center;
						padding: 3px;
						border-right: 1px solid #c8c7cc;
						box-sizing: border-box;
					}
				}
				.table-item{
					width: 100%;
					height: 50px;
					display: flex;
					justify-content: center;
					align-items: center;
					font-size: 14px;
					border-top: 1px solid #c8c7cc;
					.content-item{
						height: 100%;
						display: flex;
						justify-content: center;
						word-break:break-all;
						align-items: center;
						border-right: 1px solid #c8c7cc;
						padding: 3px;
						box-sizing: border-box;
						.u-button--mini{
							min-width: 30px;
						}
					}
				}
			}
}
.dialog-footer{
  margin: 30px 0;
}
</style>