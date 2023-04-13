<template>
  <div class="app-container">
    <div class="tips" style="margin-top:5px">
        <p><span>功能模块费/年：</span>显示该品牌商已经订购的功能模块</p>
    </div>
    <el-table
    :data="modules"
    :header-cell-style="{background:'#FAFAFA',color:'#606266',height:'50px'}"
    border
    stripe
    size="medium"
    class="trace-table"
    style="width: 100%">
        <el-table-column prop="module_name" align="center" label="产品模块"></el-table-column>
        <el-table-column prop="module_cost" align="center" label="成本价/年"></el-table-column>
        <el-table-column prop="module_retail" align="center" label="零售价"></el-table-column>
        <el-table-column label="操作" align="center" fixed="right" width="240px">
            <template slot-scope="scope">
                <el-button
                size="mini"
                type="primary"
                @click="handleSetModule(scope.row)">设置价格</el-button>
            </template>
        </el-table-column>
    </el-table>
    <el-dialog title="设置价格" :visible.sync="moduleDialog" width="30%" @close="moduleDialog=false">
        <el-form :model="moduleFrom" ref="moduleFrom" label-width="100px" :rules="moduleRule" size="medium">
            <el-form-item :label="moduleFrom.module_name" prop="module_retail">
                <el-input v-model.number="moduleFrom.module_retail" placeholder="请输入价格"/>
            </el-form-item>
        </el-form>
        <div class="dialog-footer" slot="footer">
            <el-button type="primary" @click="submitModuleFrom">保存</el-button>
        </div>
    </el-dialog>
    <div class="tips">
        <p><span>码费：</span>显示已经存在的码阶梯进行码费的设置</p>
    </div>
    <el-table
    :data="codeData"
    :header-cell-style="{background:'#FAFAFA',color:'#606266',height:'50px'}"
    border
    stripe
    size="medium"
    class="trace-table"
    style="width: 100%">
        <el-table-column prop="code_order_begin" align="center" label="码阶梯">
            <template slot-scope="scope">
                <span>{{scope.row.code_order_begin}}-{{scope.row.code_order_end}}</span>
            </template>
        </el-table-column>
        <el-table-column prop="code_retail" align="center" label="零售价"></el-table-column>
        <el-table-column label="操作" align="center" fixed="right" width="240px">
            <template slot-scope="scope">
                <el-button
                size="mini"
                type="primary"
                @click="handleSetCode(scope.row)">设置码费</el-button>
            </template>
        </el-table-column>
    </el-table>
    <el-dialog title="设置码费" :visible.sync="codeDialog" width="30%" @close="codeDialog=false">
        <el-form :model="codeForm" ref="codeFrom" label-width="80px" :rules="codeRule" size="medium">
            <el-form-item label="价格" prop="code_retail">
                <el-input v-model.number="codeForm.code_retail" placeholder="请输入价格"/>
            </el-form-item>
        </el-form>
        <div class="dialog-footer" slot="footer">
            <el-button type="primary" @click="submitCodeForm('codeFrom')">保存</el-button>
        </div>
    </el-dialog>
    <div class="tips">
        <p><span>服务费/年：</span>显示该品牌商当前的服务等级设置服务费</p>
    </div>
    <el-table
    :data="serData"
    :header-cell-style="{background:'#FAFAFA',color:'#606266',height:'50px'}"
    border
    stripe
    size="medium"
    class="trace-table"
    style="width: 100%">
    <el-table-column prop="service_des" align="center" label="服务等级"></el-table-column>
    <el-table-column prop="service_cost" align="center" label="价格"></el-table-column>
    <el-table-column label="操作" align="center" fixed="right" width="240px">
            <template slot-scope="scope">
                <el-button
                size="mini"
                type="primary"
                @click="handleSetSer(scope.row)">操作</el-button>
            </template>
        </el-table-column>
    </el-table>
    <el-dialog title="设置服务费" :visible.sync="serDialog" width="30%" @close="serDialog=false">
        <el-form :model="serForm" ref="serForm" label-width="80px" :rules="serRule" size="medium">
            <el-form-item label="价格" prop="service_cost">
                <el-input v-model.number="serForm.service_cost" placeholder="请输入价格"/>
            </el-form-item>
        </el-form>
        <div class="dialog-footer" slot="footer">
            <el-button type="primary" @click="submitSerForm('serForm')">保存</el-button>
        </div>
    </el-dialog>
  </div>
</template>

<script>
import {getDealerPrice,saveDealerModulePrice,saveDealerCodePrice,saveDealerSerPrice} from "@/api/dealer/index";
export default {
    data(){
        return{
            id:'',
            modules:[],
            moduleDialog:false,
            codeDialog:false,
            serDialog:false,
            moduleFrom:{},
            codeForm:{},
            serForm:{},
            codeData:[],
            serData:[],
            moduleRule:{
                module_retail:[
                    { required: true, message: "价格不能为空", trigger: "blur" },
                    { type: 'number', message: '价格必须为数字值'}
                ]
            },
            codeRule:{
                code_retail:[
                    { required: true, message: "价格不能为空", trigger: "blur" },
                    { type: 'number', message: '价格必须为数字值'}
                ]
            },
            serRule:{

            }
        }
    },
    created(){
        this.id=this.$route.query.id
        this.getDealerPrice()
    },
    methods:{
        getDealerPrice(){
            getDealerPrice({id:this.id}).then(res=>{
               this.modules=res.modules
               this.codeData=res.code_data
               this.serData=res.service_data
           })
        },
        handleSetModule(row){
            this.moduleDialog=true
            var arr=Object.assign({},row)
            this.moduleFrom=arr
            this.moduleFrom.dealer_id=this.id
            this.moduleFrom.module_retail=Number(this.moduleFrom.module_retail)
        },
        handleSetCode(row){
            this.codeDialog=true
            var arr=Object.assign({},row)
            this.codeForm=arr
            this.codeForm.dealer_id=this.id
            this.codeForm.code_retail=Number(this.codeForm.code_retail)
        },
        handleSetSer(row){
            this.serDialog=true
            var arr=Object.assign({},row)
            this.serForm=arr
            this.serForm.dealer_id=this.id
            this.serForm.service_cost=Number(this.serForm.service_cost)
        },
        submitCodeForm(codeFrom){
            this.$refs[codeFrom].validate(valid => {
                if(valid){
                    saveDealerCodePrice(this.codeForm).then(res=>{
                        if(res.code==200){
                            this.$message.success(res.msg)
                            this.codeDialog=false
                            this.getDealerPrice()
                        }else{
                            this.$message.error(res.msg)
                        }
                    })
                }
            })
        },
        submitSerForm(serFrom){
            this.$refs[serFrom].validate(valid => {
                if(valid){
                    saveDealerSerPrice(this.serForm).then(res=>{
                        if(res.code==200){
                            this.$message.success(res.msg)
                            this.serDialog=false
                            this.getDealerPrice()
                        }else{
                            this.$message.error(res.msg)
                        }
                    })
                }
            })
        },
        submitModuleFrom(){
            this.$refs["moduleFrom"].validate(valid => {
                if(valid){
                    saveDealerModulePrice(this.moduleFrom).then(res=>{
                        if(res.code==200){
                            this.$message.success(res.msg)
                            this.moduleDialog=false
                            this.getDealerPrice()
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
    padding: 6px 16px;
    background-color: #ecf8ff;
    border-radius: 4px;
    border-left: 5px solid #50bfff;
    margin: 25px 0 10px 0;
    display: flex;
    height: 50px;
    justify-content: space-between;
    align-items: center;
    p{
        font-size: 15px;
        color: gray;
        span{
            color: black;
            font-weight: 600;
        }
    }
}
</style>