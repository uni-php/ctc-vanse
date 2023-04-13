<template>
  <div class="product-box">
       <div class="tab-bar">
            <el-form ref="queryForm" :model="queryForm" label-width="100px" :inline="true" size="small">
                <el-form-item label="礼品名称" prop="gift_name">
                    <el-input style="width:240px" v-model="queryForm.gift_name" placeholder="请输入礼品名称"></el-input>
                </el-form-item>
                <el-form-item > 
                    <el-button type="primary" icon="el-icon-search" @click="query">查询</el-button>
                    <el-button icon="el-icon-refresh" @click="resetQuery('queryForm')">重置</el-button>
                </el-form-item>
            </el-form>
       </div>
       <el-table
        :data="tableData"
        :header-cell-style="{background:'#FAFAFA',color:'#606266',height:'50px'}"
        border
        stripe
        size="medium"
        class="trace-table"
        style="width: 100%">
        <el-table-column prop="code" align="center" label="产品编号"></el-table-column>
        <el-table-column prop="gift_name" align="center" label="产品名称"></el-table-column>
        <el-table-column prop="cover" align="center" label="礼品图片">
            <template slot-scope="scope">
                <img :src="scope.row.cover|cover" width="40px" height="40px">
            </template>
        </el-table-column>
        <el-table-column prop="market_price" align="center" label="市场价"></el-table-column>
        <el-table-column prop="stock" align="center" label="剩余库存"></el-table-column>
        <el-table-column label="操作" align="center" width="200px">
              <template slot-scope="scope">
                <el-button
                  size="mini"
                  type="primary"
                  @click="handleSelectGift(scope.row)">选择</el-button>
              </template>
        </el-table-column>
       </el-table>
  </div>
</template>

<script>
import{getGiftList} from '@/api/assets/gift'
export default {
    name:'GiftPanelPanel',
    props:{},
    data(){
        return{
            queryForm:{
                code:'',
                gift_name:'',
                gift_group:'',
                is_del:0,
                pageNum:1,
                pageSize:10
            },
            tableData:[],
            total:0
        }
    },
    filters:{
        cover(value){
            if(!value) return '--'
            return JSON.parse(value)[0]['url']
        }
    },
    created(){
        this.getList()
    },
    methods:{
        getList(){
             getGiftList(this.queryForm).then(res=>{
                this.tableData=res.data
                this.total=res.total
            })
        },
        handleSelectGift(row){
            this.$emit('selectGift',row)
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