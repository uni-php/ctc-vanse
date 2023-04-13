<template>
  <div class="red-box">
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
        <el-table-column label="操作" align="center" fixed="right" width="200px">
            <template slot-scope="scope">
                <el-button
                  size="mini"
                  type="primary"
                  @click="handleSelectRed(scope.row)">选择</el-button>
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
import {getRedPackList} from '@/api/assets/redpack'
export default {
    name:'RedPack',
    props:{},
    data(){
        return{
            tableData:[],
            total:0,
            redpackTypeOptions:[],
            queryForm:{
                keywords:'',
                type:'',
                status:'',
                moneyType:'',
                pageNum:1,
                pageSize:10
            },
        }   
    },
    created(){
        this.getList()
        this.getDicts({type:'redpack_type'}).then(res=>{
            this.redpackTypeOptions=res.data
        })
    },
    methods:{
        getList(){
            getRedPackList(this.queryForm).then(res=>{
                this.tableData=res.data
                this.total=res.total
            })
        },
        type(row){
            return this.redpackTypeOptions.filter(item=>item.dict_value==row.type).map(item=>item.dict_label)[0]
        },
        moneyType(row){
            if(row.is_random==1){
                return row.money
            }else{
                return `${row.random_min_money}~${row.random_max_money}(随机)`
            }
        },
        handleSelectRed(row){
            row.red_type_name=this.type(row)
            this.$emit('selectRedPack',row)
        }
    }
}
</script>

<style>

</style>