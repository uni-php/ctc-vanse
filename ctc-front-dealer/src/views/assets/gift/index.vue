<template>
  <div class="app-container">
        <el-tabs v-model="activeName" @tab-click="handleClick">
            <el-tab-pane label="自有礼品" name="first"></el-tab-pane>
            <el-tab-pane label="回收站" name="second"></el-tab-pane>
        </el-tabs>
        <div class="tab-bar">
            <el-form ref="queryForm" :model="queryForm" label-width="100px" :inline="true" size="small">
                <el-form-item label="礼品编号" prop="code">
                    <el-input style="width:240px" v-model="queryForm.code" placeholder="请输入礼品编号"></el-input>
                </el-form-item>
                <el-form-item label="礼品名称" prop="gift_name">
                    <el-input style="width:240px" v-model="queryForm.gift_name" placeholder="请输入礼品名称"></el-input>
                </el-form-item>
                <el-form-item label="礼品分组" prop="gift_group">
                    <el-select style="width:240px"  v-model="queryForm.gift_group" placeholder="请选择礼品分组">
                        <el-option
                            v-for="item in classOptions"
                            :key="item.id"
                            :label="item.group_name"
                            :value="item.id">
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
            <el-button @click="handleAddGify" type="primary" size="small" >上传礼品</el-button>
        </el-col>
        <el-table
        :data="tableData"
        :header-cell-style="{background:'#FAFAFA',color:'#606266',height:'50px'}"
        border
        stripe
        size="medium"
        class="trace-table"
        style="width: 100%">
            <el-table-column prop="code" align="center" label="礼品编号"></el-table-column>
            <el-table-column prop="cover" align="center" label="礼品图片">
                <template slot-scope="scope">
                    <img :src="scope.row.cover|cover" width="40px" height="40px">
                </template>
            </el-table-column>
            <el-table-column prop="gift_name" align="center" label="礼品名称"></el-table-column>
            <el-table-column prop="gift_name" align="center" label="礼品分组">
                <template slot-scope="scope">
                    <span>{{type(scope.row.group_id)}}</span>
                </template>
            </el-table-column>
            <el-table-column prop="stock" align="center" label="库存"></el-table-column>
            <el-table-column prop="cost_price" align="center" label="成本价格/元"></el-table-column>
            <el-table-column prop="order" align="center" label="排序"></el-table-column>
            <el-table-column prop="create_time" align="center" label="时间"></el-table-column>
            <el-table-column label="操作" align="center" fixed="right" width="280px">
            <template slot-scope="scope">
                <el-button
                    size="mini"
                    v-show="activeName=='first'"
                    type="primary"
                    @click="handleEdit(scope.row)">修改</el-button>
                <el-button
                    size="mini"
                    type="danger"
                    v-show="activeName=='first'"
                    @click="handleDele(scope.row)">删除</el-button>
                    <el-button
                    size="mini"
                    v-show="activeName=='second'"
                    type="primary"
                    @click="handlerReduction(scope.row)">还原</el-button>
                <el-button
                    size="mini"
                    type="danger"
                    v-show="activeName=='second'"
                    @click="handleDele(scope.row)">彻底删除</el-button>
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
  </div>
</template>

<script>
import{getGiftList,getGroupList,deleGift,reductionGift} from '@/api/assets/gift'
export default {
    data(){
        return{
            activeName:'first',
            queryForm:{
                code:'',
                gift_name:'',
                gift_group:'',
                pageNum:1,
                pageSize:10
            },
            tableData:[],
            total:0,
            queryGroupForm:{
                pageNum:1,
                pageSize:999
            },
            classOptions:[]
        }
    },
    created(){
        this.getList()
        this.getGroupList()
    },
    filters:{
        cover(value){
            return JSON.parse(value)[0]['url']
        }
    },
    computed:{
        type(){
            return function(a){
                var class_name=this.classOptions.filter(item=>item.id==a).map(item=>item.group_name)[0]
                return class_name
            }
        }
    },
    methods:{
        getList(){
            this.queryForm.is_del=this.activeName=='first'?0:1
            getGiftList(this.queryForm).then(res=>{
                this.tableData=res.data
                this.total=res.total
            })
        },
        handleClick(){
            this.queryForm.pageNum=1
            this.tableData=[]
            this.getList()
        },
        getGroupList(){
            getGroupList(this.queryGroupForm).then(res=>{
               this.classOptions=res.data
           }) 
        },
        handleAddGify(){
            this.$router.push({path:'/giftDes'})
        },
        handleEdit(row){
            this.$router.push({path:'/giftDes',query:{gift_id:row.id}})
        },
        handleDele(row){
            this.$confirm(`确认删除该礼品?`, '提示', {
                confirmButtonText: '确定',
                cancelButtonText: '取消',
                type: 'warning'
            }).then(() => {
                 deleGift({id:row.id}).then(res=>{
                    if(res.code==200){
                        this.$message.success(res.msg)
                        this.getList()
                    }else{
                        this.$message.error(res.msg)
                    }
                 })
            }).catch(() => {});
        },
        handlerReduction(row){
            reductionGift({id:row.id}).then(res=>{
                if(res.code==200){
                    this.$message.success(res.msg)
                    this.getList()
                }else{
                    this.$message.error(res.msg)
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

<style>

</style>