<!--
 * @Author: wenhanhan 1196086345@qq.com
 * @Date: 2022-09-04 00:33:51
 * @LastEditors: wenhanhan 1196086345@qq.com
 * @LastEditTime: 2022-10-01 23:56:09
 * @Description: 导购分组
-->
<template>
  <div class="app-container">
    <el-col :span="24" style="margin:10px 0;">
        <el-button @click="handleAddClass" type="primary" size="small" >添加身份组</el-button>
    </el-col>
     <el-table
      :data="tableData"
      :header-cell-style="{background:'#FAFAFA',color:'#606266',height:'50px'}"
      border
      stripe
      size="medium"
      class="trace-table"
      style="width: 100%"
      >
      <el-table-column prop="id" align="center" label="身份组ID" ></el-table-column>
      <el-table-column prop="group_name" align="center" label="身份组名称" ></el-table-column>
      <el-table-column label="操作" align="center" fixed="right" width="300px">
            <template slot-scope="scope">
                    <el-button
                    size="mini"
                    type="text"
                    @click="handleEdit(scope.row)">编辑</el-button>
                    <el-button
                    size="mini"
                    type="text"
                    @click="handleDele(scope.row)">删除</el-button>
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
import {getGuideGroupList,deleGuideGroup} from '@/api/app/guide/group'
export default {
  data(){
    return{
      queryForm:{
          pageNum:1,
          pageSize:10,
      },
      tableData:[],
      total:0
    }
  },
  created(){
    this.getList()
  },
  methods:{
    getList() {
      getGuideGroupList(this.queryForm).then(res=>{
        this.tableData = res.data
        this.total = res.total
      })
    },
    handleAddClass() {
      this.$router.push({path:'/guide/manage/addGroup'})
    },
    handleEdit(row) {
      this.$router.push({path:'/guide/manage/addGroup',query:{
        id:row.id
      }})
    },
    handleDele(row) {
      this.$confirm('确认删除该分组?', '提示', {
          confirmButtonText: '确定',
          cancelButtonText: '取消',
          type: 'warning'
          }).then(() => {
            deleGuideGroup({id:row.id}).then(res=>{
              if(res.code==200){
                  this.$message.success(res.msg)
                  this.getList()
              }else{
                  this.$message.error(res.msg)
              }
            })
      }).catch(() => {});
    }
  }
}
</script>

<style>

</style>
