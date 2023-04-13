<template>
  <div class="app-container">
    <el-tabs v-model="activeName" @tab-click="handleClick">
        <el-tab-pane label="已上架" name="1"></el-tab-pane>
        <el-tab-pane label="下架库" name="2"></el-tab-pane>
    </el-tabs>
     <div class="tab-bar">
        <el-form ref="queryForm" :model="queryForm" label-width="100px" :inline="true" size="small">
            <el-form-item label="商品编号" prop="code">
                <el-input style="width:240px" v-model="queryForm.code" placeholder="请输入商品编号"></el-input>
            </el-form-item>
            <el-form-item label="商品名称" prop="goods_name">
                <el-input style="width:240px" v-model="queryForm.goods_name" placeholder="请输入商品名称"></el-input>
            </el-form-item>
            <el-form-item > 
                <el-button type="primary" icon="el-icon-search" @click="query">查询</el-button>
                <el-button icon="el-icon-refresh" @click="resetQuery('queryForm')">重置</el-button>
            </el-form-item>
        </el-form>
     </div>
    <el-col :span="24" style="margin:10px 0;">
        <el-button @click="handleAddGoods" type="primary" size="small" >添加商品</el-button>
    </el-col>
    <el-table
        :data="tableData"
        :header-cell-style="{background:'#FAFAFA',color:'#606266',height:'50px'}"
        border
        stripe
        size="medium"
        class="trace-table"
        style="width: 100%">
        <el-table-column prop="code" align="center" label="产品编号"></el-table-column>
        <el-table-column prop="goods_name" align="center" show-overflow-tooltip="" label="产品名称"></el-table-column>
        <el-table-column prop="cover" align="center" label="产品图片">
             <template slot-scope="scope">
                <img :src="scope.row.cover|cover" width="40px" height="40px">
            </template>
        </el-table-column>
        <el-table-column prop="sale_price" align="center" label="售价"></el-table-column>
        <el-table-column prop="type" align="center" label="分类" :formatter="type"></el-table-column>
        <el-table-column prop="sales" align="center" label="销量"></el-table-column>
        <el-table-column prop="score" align="center" label="赠送积分"></el-table-column>
        <el-table-column prop="update_time" align="center" label="上架时间"></el-table-column>
         <el-table-column label="操作" align="center" fixed="right" width="280px">
            <template slot-scope="scope">
                <el-button
                    size="mini"
                    type="primary"
                    @click="handleEdit(scope.row)">编辑</el-button>
                <el-button
                    size="mini"
                    v-show="activeName==1"
                    type="primary"
                    @click="handleCut(scope.row)">下架</el-button>
                    <el-button
                    size="mini"
                    v-show="activeName==2"
                    type="primary"
                    @click="handleUp(scope.row)">上架</el-button>
            </template>
         </el-table-column>
    </el-table>
     <pagination
        v-show="+total>10"
        :total="+total"
        :page.sync="queryForm.pageNum"
        :limit.sync="queryForm.pageSize"
        @pagination="getList"/>
  </div>
</template>

<script>
import {getGoodsList,cutGoods,upGoods,getClassLists} from '@/api/app/mall'
export default {
    data(){
        return{
            activeName:'1',
            queryForm:{
                code:'',
                goods_name:'',
                pageNum:1,
                pageSize:10
            },
            queryClassParams:{
                pageNum:1,
                pageSize:999
            },
            classOptions:[],
            tableData:[],
            total:0
        }
    },
    created(){
        this.getList();
        this.getClassList()
    },
     filters:{
        cover(value){
            return value[0]['url']
        }
    },
    methods:{
        getList(){
            this.queryForm.status=this.activeName
            getGoodsList(this.queryForm).then(res=>{
                this.tableData=res.data
                this.total=res.total
            })
        },
        getClassList(){
            getClassLists(this.queryClassParams).then(res=>{
                this.classOptions=res.data
            })
        },
        type(row){
            const class_one=this.classOptions.filter(item=>item.id==row.class_one).map(item=>item.class_name)[0]
            const class_two=this.classOptions.filter(item=>item.id==row.class_two).map(item=>item.class_name)[0]
            return class_one+'\\'+class_two
        },
        handleClick(){
            this.queryForm.pageNum=1
            this.tableData=[]
            this.getList()
        },
        handleAddGoods(){
            this.$router.push({path:'/mall/addProduct'})
        },
        handleEdit(row){
            this.$router.push({path:'/mall/addProduct',query:{goods_id:row.id}})
        },
        handleCut(row){
             this.$confirm(`确认下架该商品?`, '提示', {
                confirmButtonText: '确定',
                cancelButtonText: '取消',
                type: 'warning'
            }).then(() => {
                 cutGoods({id:row.id}).then(res=>{
                    if(res.code==200){
                        this.$message.success(res.msg)
                        this.getList()
                    }else{
                        this.$message.error(res.msg)
                    }
                 })
            }).catch(() => {});
        },
        handleUp(row){
            this.$confirm(`确认上架该商品?`, '提示', {  
                confirmButtonText: '确定',
                cancelButtonText: '取消',
                type: 'warning'
            }).then(() => {
                 upGoods({id:row.id}).then(res=>{
                    if(res.code==200){
                        this.$message.success(res.msg)
                        this.getList()
                    }else{
                        this.$message.error(res.msg)
                    }
                 })
            }).catch(() => {});
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