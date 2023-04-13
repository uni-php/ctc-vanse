<template>
  <div class="app-container">
      <el-table
        :data="tableData"
        :header-cell-style="{background:'#FAFAFA',color:'#606266',height:'50px'}"
        border
        stripe
        size="medium"
        class="trace-table"
        style="width: 100%">
        <el-table-column prop="id" align="center" label="ID"></el-table-column>
        <el-table-column prop="nickname" align="center" label="昵称"></el-table-column>
        <el-table-column prop="phone" align="center" label="手机号"></el-table-column>
        <!-- <el-table-column prop="superior" align="center" label="上级分销员"></el-table-column> -->
        <el-table-column prop="create_time" align="center" label="添加时间"></el-table-column>
          <el-table-column label="操作" align="center" fixed="right" width="220px">
            <template slot-scope="scope">
                <el-button
                    size="mini"
                    type="primary"
                    @click="handleDes(scope.row)">下级成员</el-button>
            </template>
          </el-table-column>
      </el-table>
       <pagination
        v-show="+total>10"
        :total="+total"
        :page.sync="queryForm.pageNum"
        :limit.sync="queryForm.pageSize"
        @pagination="getList"/>
    <el-dialog title="下级成员" class="nextDialog" :visible.sync="nextDialog" width="50%" @close="nextDialog=false">
        <el-tabs v-model="activeName" @tab-click="handleClick">
            <el-tab-pane label="一级分销" name="1"></el-tab-pane>
            <el-tab-pane label="二级分销" name="2"></el-tab-pane>
        </el-tabs>
        <el-table
        :data="nextTableData"
        :header-cell-style="{background:'#FAFAFA',color:'#606266',height:'50px'}"
        border
        stripe
        size="medium"
        class="trace-table"
        style="width: 100%">
            <el-table-column prop="id" align="center" label="ID"></el-table-column>
            <el-table-column prop="nickname" align="center" label="昵称"></el-table-column>
            <el-table-column prop="phone" align="center" label="手机号"></el-table-column>
            <el-table-column prop="create_time" align="center" label="添加时间"></el-table-column>
        </el-table>
        <pagination
        v-show="+totals>10"
        :total="+totals"
        :page.sync="queryNextForm.pageNum"
        :limit.sync="queryNextForm.pageSize"
        @pagination="getFenxiaoyuanChild"/>
    </el-dialog>
  </div>
</template>

<script>
import {getFenxiaoyuanList,getFenxiaoyuanChild} from '@/api/app/mall/distribution.js'
export default {
    data(){
        return{
            activeName:'1',
            nextDialog:false,
            tableData:[],
            nextTableData:[],
            total:0,
            totals:0,
            queryNextForm:{
                pageNum:1,
                pageSize:10
            },
            queryForm:{
                pageNum:1,
                pageSize:10
            },
            uid:undefined
        }
    },
    created(){
        this.getList()
    },
    methods:{
        handleClick(){
            this.queryNextForm.status=this.activeName
            this.queryNextForm.pageNum=1
            this.getFenxiaoyuanChild()
        },
        getList(){
            getFenxiaoyuanList(this.queryForm).then(res=>{
                this.tableData=res.data
                this.total=res.total
            })
        },
        getFenxiaoyuanChild(){
            this.queryNextForm.uid=this.uid
            getFenxiaoyuanChild(this.queryNextForm).then(res=>{
                this.nextTableData=res.data
                this.totals=res.total
            })
        },
        handleDes(row){
            this.queryNextForm.status='1'
            this.uid=row.id
            this.nextDialog=true
            this.getFenxiaoyuanChild()
        }
    }
}
</script>

<style>

</style>