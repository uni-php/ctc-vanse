<template>
   <div class="app-container">
       <div class="tab-bar">
           <el-form ref="queryForm" :model="queryForm" label-width="100px" :inline="true" size="small">
               <el-form-item label="关键词" prop="keywords">
                    <el-input style="width:240px" v-model="queryForm.keywords" placeholder="红包ID、发放者、红包说明"></el-input>
                </el-form-item>
                <el-form-item label="红包状态" prop="status">
                    <el-select style="width:240px"  v-model="queryForm.status" placeholder="请选择红包状态">
                        <el-option
                            v-for="item in statusOptions"
                            :key="item.id"
                            :label="item.label"
                            :value="item.value">
                        </el-option>
                    </el-select>
                </el-form-item>
                <el-form-item label="红包类型" prop="type">
                    <el-select style="width:240px"  v-model="queryForm.type" placeholder="请选择红包类型">
                        <el-option
                            v-for="item in redpackTypeOptions"
                            :key="item.dict_value"
                            :label="item.dict_label"
                            :value="item.dict_value">
                        </el-option>
                    </el-select>
                </el-form-item>
                <el-form-item label="金额类型" prop="moneyType">
                    <el-select style="width:240px"  v-model="queryForm.moneyType" placeholder="请选择金额类型">
                        <el-option
                            v-for="item in redpackMoneyOptions"
                            :key="item.dict_value"
                            :label="item.dict_label"
                            :value="item.dict_value">
                        </el-option>
                    </el-select>
                </el-form-item>
                <el-form-item> 
                    <el-button type="primary" icon="el-icon-search" @click="query">查询</el-button>
                    <el-button icon="el-icon-refresh" @click="resetQuery('queryForm')">重置</el-button>
                </el-form-item>
           </el-form>
       </div>
        <el-col :span="24" style="margin:10px 0;">
            <el-button @click="addRedpack" type="primary" size="small" >新建红包</el-button>
        </el-col>
       <el-table
        :data="tableData"
        :header-cell-style="{background:'#FAFAFA',color:'#606266',height:'50px'}"
        border
        stripe
        size="medium"
        class="trace-table"
        style="width: 100%">
        <el-table-column prop="id" align="center" label="红包ID"></el-table-column>
        <el-table-column prop="type" align="center" label="红包类型" :formatter="type"></el-table-column>
        <el-table-column prop="money" align="center" label="红包金额" :formatter="moneyType"></el-table-column>
        <el-table-column prop="issuer" align="center" label="发放者">
           <template slot-scope="scope">
               <span>{{scope.row.issuer||'--'}}</span>
           </template> 
        </el-table-column>
        <el-table-column prop="remark" align="center" width="150px" show-overflow-tooltip="" label="红包说明/入账说明"></el-table-column>
        <el-table-column prop="instructions" align="center" show-overflow-tooltip="" label="使用说明"></el-table-column>
        <el-table-column prop="create_time" align="center" show-overflow-tooltip="" label="创建时间"></el-table-column>
        <el-table-column prop="status" align="center" label="状态" :formatter="status"></el-table-column>
        <el-table-column label="操作" align="center" fixed="right" width="200px">
            <template slot-scope="scope">
                <el-button
                    size="mini"
                    type="primary"
                    @click="handleEdit(scope.row)">编辑</el-button>
                <el-button
                    size="mini"
                    type="primary"
                    @click="handleSet(scope.row)">{{scope.row.status==0?'禁用':'启用'}}</el-button>
            </template>
        </el-table-column>
       </el-table>
       <pagination
        v-show="+total>10"
        :total="+total"
        :page.sync="queryForm.pageNum"
        :limit.sync="queryForm.pageSize"
        @pagination="getList"/>
        <!-- 新建红包弹窗 -->
        <el-dialog :title="title" :visible.sync="repackDialog" width="60%" @close="repackDialog=false">
            <el-form :model="form" ref="form" label-width="140px" class="form" :rules="rule" size="medium">
                <el-form-item label="红包类型" prop="type">
                        <div class="type-box">
                            <div class="a" v-for="(item,index) of redpackTypeOptions" :key="index">
                                    <div class="tips" v-if="index==0">
                                        <div style="height:40px">
                                            <el-radio :disabled="form.id>=1" v-model="form.type" :label="item.dict_value">{{item.dict_label}}</el-radio>
                                        </div>
                                        <div style="height:calc(100% - 40px)">由公众号推送红包，用户需点击红包领取，领取后才能到用户微信零钱账户。</div>
                                    </div>
                                    <div class="tips" v-else-if="index==1">
                                        <div style="height:40px">
                                            <el-radio :disabled="form.id>=1" v-model="form.type" :label="item.dict_value">{{item.dict_label}}</el-radio>
                                        </div>
                                        <div style="height:calc(100% - 40px)">发放后，红包金额直接到用户微信零钱账户，用户不需要领取操作。</div>
                                    </div>
                                    <div class="tips" v-else>
                                        <div style="height:40px">
                                            <el-radio :disabled="form.id>=1" v-model="form.type" :label="item.dict_value">{{item.dict_label}}</el-radio>
                                        </div>
                                        <div style="height:calc(100% - 40px)">发放后，红包金额直接到用户微信零钱账户，用户不需要领取操作。（此类型需要提前充值代发红包池）</div>
                                    </div>
                            </div>
                        </div>
                </el-form-item>
                <el-form-item label="红包金额" >
                    <el-select style="width:130px" v-model="form.is_random" :disabled="form.id>=1"  placeholder="金额类型">
                        <el-option v-for="(item,index) of redpackMoneyOptions" :key="index" :label="item.dict_label" :value="item.dict_value"></el-option>
                    </el-select>
                    <el-input v-if="form.is_random==1" :disabled="form.id>=1" style="width:50%" placeholder="0.3~2000" v-model="form.money">
                    </el-input>
                    <el-input v-if="form.is_random==2" :disabled="form.id>=1" style="width:30%" placeholder="0.3" v-model="form.random_min_money">
                    </el-input>
                    <el-input v-if="form.is_random==2" :disabled="form.id>=1" style="width:calc(30% - 30px);margin-left:20px" placeholder="2000" v-model="form.random_max_money">
                    </el-input>
                    <div style="color:red;margin:10px 0" v-if="form.type==1||form.type==3">(金额保存后不可修改)</div>
                    <div style="color:red;margin:10px 0" v-if="form.type==2">(金额保存后不可修改,现金红包如果低于1.00元需要到公众号中申请)</div>
                    <div>请在微信支付后台设置相关限额</div>
                </el-form-item>
                <el-form-item label="入账详情" prop="remark" v-if="form.type==1||form.type==3">
                    <el-input style="width:80%"  v-model="form.remark" placeholder="例如“积分兑换红包”"/>
                </el-form-item>
                <el-form-item label="发放者" prop="issuer" v-if="form.type==2">
                    <el-input style="width:80%"  v-model="form.issuer" placeholder="输入红包发放方的商户名称"/>
                </el-form-item>
                <el-form-item label="使用说明" prop="instructions">
                    <el-input style="width:80%"  v-model="form.instructions" placeholder="备注红包使用场景，方便区分"/>
                </el-form-item>
            </el-form>
            <div slot="footer" class="dialog-footer">
                <el-button type="primary" @click="submitForm">确 定</el-button>
                <el-button @click="repackDialog=false">取 消</el-button>
            </div>
        </el-dialog>
   </div>
</template>
<script>
import {saveRedPack,getRedPackList,queryRedPackInfo,setRedPackStatus} from '@/api/assets/redpack'
export default {
    data(){ 
        return{
            title:'',
            queryForm:{
                keywords:'',
                type:'',
                status:'',
                moneyType:'',
                pageNum:1,
                pageSize:10
            },
            statusOptions:[
                {
                    label:'启用',
                    value:0
                },
                {
                    label:'禁用',
                    value:1
                }
            ],
            redpackTypeOptions:[],
            redpackMoneyOptions:[],
            repackDialog:false,
            total:0,
            tableData:[],
            form:{
                id:undefined,
                type:'1',
                is_random:'1',
                money:'',
                random_max_money:'',
                random_min_money:'',
                remark:'',
                instructions:'',
                issuer:''
            },
            rule:{
                type:[
                   { required: true, message: "请选择红包类型", trigger: "blur" },
                ],
                money:[
                   { required: true, message: "请输入红包金额", trigger: "blur" },
                ],
                money1:[
                   { required: true, message: "请输入红包金额", trigger: "blur" },
                ],
                remark:[
                   { required: true, message: "请输入入账详情", trigger: "blur" },
                ],
                issuer:[
                    { required: true, message: "请输入发放者", trigger: "blur" },
                    { min: 5, max: 30, message: '长度在 5 到 30 个字符', trigger: 'blur' }
                ],
                instructions:[
                    { required: true, message: "请输入使用说明", trigger: "blur" },
                ]
            }
        }
    },
    created(){
        this.getList()
        this.getDicts({type:'redpack_type'}).then(res=>{
            this.redpackTypeOptions=res.data
        })
        this.getDicts({type:'redpack_monry_type'}).then(res=>{
            this.redpackMoneyOptions=res.data
        })
    },
    methods:{
        getList(){
            getRedPackList(this.queryForm).then(res=>{
                this.tableData=res.data
                this.total=res.total
            })
        },
        addRedpack(){
            this.repackDialog=true
            this.form={
                type:'1',
                is_random:'1',
            }
            this.title='新建红包'
        },
        type(row){
            return this.redpackTypeOptions.filter(item=>item.dict_value==row.type).map(item=>item.dict_label)[0]
        },
        status(row){
            return row.status==0?'启用':'禁用'
        },
        moneyType(row){
            if(row.is_random==1){
                return row.money
            }else{
                return `${row.random_min_money}~${row.random_max_money}(随机)`
            }
        },
        handleEdit(row){
            queryRedPackInfo({id:row.id}).then(res=>{
                this.title='编辑红包'
                this.repackDialog=true
                this.form=res.data
                this.form.type=String(this.form.type)
                this.form.is_random=String(this.form.is_random)
            })
        },
        handleSet(row){
            var text=row.status==0?'禁用':'启用'
            this.$confirm(`确认${text}红包?`, '提示', {
                confirmButtonText: '确定',
                cancelButtonText: '取消',
                type: 'warning'
            }).then(() => {
                setRedPackStatus({id:row.id,status:row.status}).then(res=>{
                    if(res.code==200){
                        this.$message.success(res.msg)
                        this.getList()
                    }else{
                        this.$message.error(res.msg)
                    }
                })
            }).catch(() => {});
        },
        submitForm(){
            this.$refs["form"].validate(valid => {
                if(valid){
                    saveRedPack(this.form).then(res=>{
                        if(res.code==200){
                            this.$message.success(res.msg)
                            this.repackDialog=false
                            this.getList()
                        }else{
                            this.$message.error(res.msg)
                        }
                    })
                }
            })
        },
        query(){
            this.queryForm.pageNum = 1;
            this.getList();
        },
        resetQuery(formName){
            this.$refs[formName].resetFields();
            this.query()
        }
    }
}
</script>

<style lang="scss" scoped>
.form{
    .type-box{
        width: 80%;
        display: flex;
        justify-content: space-around;
        align-items: center;
        flex-wrap: nowrap;
    }
    .a{
        width:30%;
        height:200px;
        border:1px solid #eeeeee;
        display:flex;
        justify-content: center;
        .tips{
            width: 100%;
            height: auto;
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            padding: 10px;
            div{
                line-height: 25px;
            }
        }
    }
}
.el-radio-group{
    display:flex;
}
</style>