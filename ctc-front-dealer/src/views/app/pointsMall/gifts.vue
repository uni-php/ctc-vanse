<template>
  <div class="app-container">
      <div class="tab-bar">
        <el-form ref="queryForm" :model="queryForm" label-width="100px" :inline="true" size="small">
            <el-form-item label="礼品名称" prop="gift_name">
                <el-input style="width:240px" v-model="queryForm.gift_name" placeholder="请输入礼品名称"></el-input>
            </el-form-item>
            <el-form-item label="兑换类型" prop="type">
                <el-select style="width:220px" size="small" v-model="queryForm.type" placeholder="请选择兑换类型">
                   <el-option
                        v-for="item in typeOptions"
                        :key="item.value"
                        :label="item.label"
                        :value="item.value">
                    </el-option>
                </el-select>
            </el-form-item>
            <el-form-item label="礼品状态" prop="status">
                <el-select style="width:220px" size="small" v-model="queryForm.status" placeholder="请选择礼品状态">
                   <el-option
                        v-for="item in statusOptions"
                        :key="item.value"
                        :label="item.label"
                        :value="item.value">
                    </el-option>
                </el-select>
            </el-form-item>
            <el-form-item > 
                <el-button type="primary" icon="el-icon-search" @click="query">查询</el-button>
                <el-button icon="el-icon-refresh" @click="reset('queryForm')">重置</el-button>
            </el-form-item>
        </el-form>
      </div>
    <el-col :span="24" style="margin:10px 0;">
        <el-button @click="handleAddGifts" type="primary" size="small" >添加礼品</el-button>
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
        <el-table-column prop="gift_name" align="center" label="礼品名称"></el-table-column>
        <el-table-column prop="type" align="center" label="分类" :formatter="type"></el-table-column>
        <el-table-column prop="points_num" align="center" label="兑换积分"></el-table-column>
        <el-table-column prop="limit_num" align="center" label="限兑数量"></el-table-column>
        <el-table-column prop="exchanged_num" align="center" label="已兑数量"></el-table-column>
        <el-table-column prop="status" align="center" label="礼品状态" :formatter="status"></el-table-column>
        <el-table-column prop="order" align="center" label="排序"></el-table-column>
        <el-table-column prop="create_time" align="center" label="创建时间"></el-table-column>
        <el-table-column label="操作" align="center" fixed="right" width="280px">
            <template slot-scope="scope">
                <el-button
                    size="mini"
                    type="primary"
                    v-if="scope.row.status==1||scope.row.status==0"
                    @click="handleCut(scope.row)">{{scope.row.status==0?'上架':'下架'}}</el-button>
                <el-button
                    size="mini"
                    type="danger"
                    v-if="scope.row.status==2"
                    @click="handleUp(scope.row)">重新上架</el-button>
                <el-button
                    size="mini"
                    type="primary"
                    @click="handleEdit(scope.row)">编辑</el-button>
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
import {getPointsGiftList,getClassLists,cutPointsGift} from '@/api/app/points'
export default {
    data(){
        return{
            queryForm:{
                gift_name:'',
                type:'',
                status:'',
                pageNum:1,
                pageSize:10
            },
            classOptions:[],
            tableData:[],
            total:0,
            queryParams:{
                pageNum:1,
                pageSize:999
            },
            typeOptions:[
                {
                    label:'纯积分',
                    value:1
                },
                {
                    label:'现金+积分',
                    value:2
                }
            ],
            statusOptions:[
                {
                    label:'等待上架',
                    value:0
                },
                {
                    label:'已上架',
                    value:1
                },
                 {
                    label:'已下架',
                    value:2
                }
            ]
        }
    },
    created(){
        this.getList()
        this.getClassList()
    },
    methods:{
        getList(){
            getPointsGiftList(this.queryForm).then(res=>{
                this.tableData=res.data
                this.total=res.total
            })
        },
        status(row){
            return this.statusOptions.filter(item=>item.value==row.status).map(item=>item.label)[0]
        },
        getClassList(){
            getClassLists(this.queryParams).then(res=>{
                this.classOptions=res.data
            })
        },
         type(row){
            const class_one=this.classOptions.filter(item=>item.id==row.class_one).map(item=>item.class_name)[0]
            const class_two=this.classOptions.filter(item=>item.id==row.class_two).map(item=>item.class_name)[0]
            return class_one+'\\'+class_two
        },
        handleCut(row){
            var text=row.status==0?'上架':'下架';
            var status=row.status==0?1:2
            this.$confirm(`确认${text}该商品?`, '提示', {  
                confirmButtonText: '确定',
                cancelButtonText: '取消',
                type: 'warning'
            }).then(() => {
                 cutPointsGift({id:row.id,status:status}).then(res=>{
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
            this.$confirm(`确认重新上架该商品?`, '提示', {  
                confirmButtonText: '确定',
                cancelButtonText: '取消',
                type: 'warning'
            }).then(() => {
                 cutPointsGift({id:row.id,status:1}).then(res=>{
                    if(res.code==200){
                        this.$message.success(res.msg)
                        this.getList()
                    }else{
                        this.$message.error(res.msg)
                    }
                 })
            }).catch(() => {});
        },
        handleEdit(row){
             this.$router.push({path:'/points/addGift',query:{gift_id:row.id}})
        },
        handleAddGifts(){
            this.$router.push({path:'/points/addGift'})
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

<style>

</style>