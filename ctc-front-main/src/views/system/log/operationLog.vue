<template>
  <div class="app-container">
    <div class="tab-bar">
      <el-form ref="queryForm" :model="queryForm" label-width="100px" :inline="true" size="small">
        <el-form-item label="模块名称" prop="module_name">
          <el-input style="width:240px" v-model="queryForm.module_name" placeholder="请输入模块名称"></el-input>
        </el-form-item>
        <el-form-item label="操作人员" prop="operator">
          <el-input style="width:240px" v-model="queryForm.operator" placeholder="请输入操作人员"></el-input>
        </el-form-item>
        <el-form-item label="操作类型" prop="operate_type">
          <el-select style="width:240px" v-model="queryForm.operate_type" placeholder="请选择操作类型">
              <el-option
                  v-for="item in opOptions"
                  :key="item.dict_value"
                  :label="item.dict_label"
                  :value="item.dict_value">
              </el-option>
          </el-select>
        </el-form-item>
        <el-form-item label="操作时间" prop="date">
          <el-date-picker
            style="width:240px"
            v-model="queryForm.date"
            type="daterange"
            unlink-panels=""
            range-separator="至"
            format="yyyy-MM-dd"
            value-format="yyyy-MM-dd"
            start-placeholder="开始日期"
            end-placeholder="结束日期">
          </el-date-picker>
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
      <el-table-column prop="module_name" align="center" label="系统模块" ></el-table-column>
      <el-table-column prop="operate_type" align="center" label="操作类型" >
        <template slot-scope="scope">
          <span>{{operateType(scope.row.operate_type)}}</span>
        </template>
      </el-table-column>
      <el-table-column prop="operator" align="center" label="操作人员" ></el-table-column>
      <el-table-column prop="ip" align="center" label="ip地址" ></el-table-column>
      <el-table-column prop="address" align="center" label="操作地点" ></el-table-column>
      <el-table-column prop="ip" align="center" label="ip地址" ></el-table-column>
      <el-table-column prop="operate_event" show-overflow-tooltip="" align="center" label="时间名称" ></el-table-column>
      <el-table-column width="200px" prop="create_time" align="center" label="操作日期" ></el-table-column>
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
import {operationList} from "@/api/system/log";
export default {
  data(){
    return{
      queryForm:{
        module_name:'',
        operate_type:'',
        operator:'',
        date:[],
        pageNum:1,
        pageSize:10
      },
      opOptions:[],
      tableData:[],
      total:0
    }
  },
  created(){
    this.getList()
    this.getDicts({type:'sys_oper_type'}).then(res=>{
      this.opOptions=res.data
    })
  },
  methods:{
    getList(){
      var arr=Object.assign({},this.queryForm)
      if(arr.date.length>0){
          arr.beginTime=arr.date[0]
          arr.endTime=arr.date[1]
      }else{
          arr.beginTime=''
          arr.endTime=''
      }
      delete arr.date
      operationList(arr).then(res=>{
          this.tableData=res.data
          this.total=res.total
      })
    },
    query(){
      this.queryForm.pageNum = 1;
      this.getList();
    },
    resetQuery(formName){
      this.$refs[formName].resetFields();
      this.query()
    },
  },
  computed:{
    operateType(){
      return function(value){
          if(!value) return '--'
          var item=this.opOptions.filter(item=>{
          return item.dict_value==value
      })
          return item[0].dict_label
      }
    }
  }
}
</script>

<style>

</style>