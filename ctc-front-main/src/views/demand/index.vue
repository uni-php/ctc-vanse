<template>
  <div class="app-container">
      <div class="tab-bar">
        <el-form ref="queryForm" :model="queryForm" label-width="100px" :inline="true" size="small">
          <el-form-item label="标题" prop="title">
            <el-input style="width:240px" v-model="queryForm.title" placeholder="请输入需求标题"></el-input>
          </el-form-item>
          <el-form-item label="优先级" prop="priority">
            <el-select style="width:240px" v-model="queryForm.priority" placeholder="请选择优先级">
                <el-option
                    v-for="item in priorityOptions"
                    :key="item.dict_value"
                    :label="item.dict_label"
                    :value="item.dict_value">
                </el-option>
            </el-select>
          </el-form-item>
          <el-form-item label="功能模块" prop="module">
            <el-select style="width:240px" v-model="queryForm.module" placeholder="请选择功能模块">
                <el-option
                    v-for="item in moduleOptions"
                    :key="item.id"
                    :label="item.module_name"
                    :value="item.id">
                </el-option>
            </el-select>
          </el-form-item>
          <el-form-item label="状态" prop="status">
            <el-select style="width:240px" v-model="queryForm.status" placeholder="请选择状态">
                <el-option
                    v-for="item in statusOptions"
                    :key="item.dict_value"
                    :label="item.dict_label"
                    :value="item.dict_value">
                </el-option>
            </el-select>
          </el-form-item>
          <el-form-item label="合伙人" prop="company">
            <el-input style="width:240px" v-model="queryForm.company" placeholder="请输入合伙人"></el-input>
          </el-form-item>
          <el-form-item label="品牌商" prop="dealer_name">
            <el-input style="width:240px" v-model="queryForm.dealer_name" placeholder="请输入品牌商"></el-input>
          </el-form-item>
          <el-form-item label="提交时间" prop="date">
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
        <el-table-column prop="title" align="center" label="标题" ></el-table-column>
        <el-table-column prop="module_name" align="center" label="功能模块" ></el-table-column>
        <el-table-column prop="priority" align="center" label="优先级" >
           <template slot-scope="scope">
             <span>{{priority(scope.row.priority)}}</span>
           </template>
        </el-table-column>
        <el-table-column show-overflow-tooltip="" prop="company" align="center" label="合伙人" ></el-table-column>
        <el-table-column prop="dealer_name" align="center" label="品牌商" ></el-table-column>
        <el-table-column prop="describe" align="center" show-overflow-tooltip="" label="需求描述" ></el-table-column>
        <el-table-column prop="tips" align="center" label="审核意见" ></el-table-column>
        <el-table-column prop="create_time" align="center" label="提交时间" ></el-table-column>
        <el-table-column prop="status" align="center" label="审核状态" >
          <template slot-scope="scope">
             <span>{{status(scope.row.status)}}</span>
           </template>
        </el-table-column>
        <el-table-column prop="enclosure" align="center" label="附件" >
          <template slot-scope="scope">
            <span style="color:blue" v-if="scope.row.enclosure">
              <el-link @click="download(scope.row)">下载<i class="el-icon-download"></i></el-link>
            </span>
            <span v-else>--</span>
          </template>
        </el-table-column>
        <el-table-column label="操作" align="center" fixed="right" width="180px">
          <template slot-scope="scope">
            <span v-if="scope.row.status==4">已完成</span>
            <el-button
            size="mini"
            v-if="scope.row.status==1"
            type="primary"
            @click="handleCheck(scope.row)">审核</el-button>
            <el-button
            size="mini"
            v-if="scope.row.status==2"
            type="primary"
            @click="handleChange(scope.row)">实现中</el-button>
            <el-button
            size="mini"
            v-if="scope.row.status==3"
            type="primary"
            @click="handleChange(scope.row)">已完成</el-button>
          </template>
        </el-table-column>
      </el-table>
      <!-- 审核框 -->
      <el-dialog title="需求审核" :visible.sync="checkDialog" width="40%" @close="checkDialog=false">
        <el-form :model="checkFrom" ref="checkFrom" label-width="100px" :rules="rule" size="medium">
          <el-form-item label="生码类型" prop="status">
            <el-radio-group v-model="checkFrom.status">
                <el-radio v-for="(item,index) in codeType" :key="index" :label="item.dict_value">
                    {{item.dict_label}}
                </el-radio>
            </el-radio-group>
          </el-form-item>
          <el-form-item label="审核意见" prop="tips">
                <el-input style="width:90%" :autosize="{ minRows: 3, maxRows: 5}" type="textarea" v-model="checkFrom.tips" placeholder="请输入审核意见"/>
            </el-form-item>
        </el-form>
        <div slot="footer" class="dialog-footer">
            <el-button type="primary"  @click="checkDemand">保存</el-button>
        </div>
      </el-dialog>

  </div>
</template>

<script>
import {getAllModule,getDemands,checkDemand} from "@/api/demand/index";
export default {
  data(){
    return{
      queryForm:{
        title:'',
        priority:"",
        status:'',
        date:[],
        company:"",
        dealer_name:'',
        module:'',
        pageNum:1,
        pageSize:10
      },
      checkDialog:false,
      checkFrom:{
        status:2,
        id:undefined,
        tips:''
      },
      codeType:[
        {
          dict_value:5,
          dict_label:'审核不通过'
        },
        {
          dict_value:2,
          dict_label:'审核通过'
        }
      ],
      rule:{},
      prefix:"http://localhost/static/mainImgs/",
      priorityOptions:[],
      moduleOptions:[],
      statusOptions:[],
      total:0,
      tableData:[]
    }
  },
  created(){
    this.getList()
    this.getModules()
    this.getDicts({type:'demand_priority'}).then(res=>{
      this.priorityOptions=res.data
    })
    this.getDicts({type:'demand_status'}).then(res=>{
      this.statusOptions=res.data
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
        getDemands(arr).then(res=>{
          this.tableData=res.data
          this.total=res.total
        })
    },
    handleEdit(){
      this.$message.info('待排期需求无法修改')
    },
    handleChange(row){
      var text=row.status==3?'已完成':'实现中'
      this.$confirm(`确定将该需求状态置为${text}?`, '提示', {
          confirmButtonText: '确定',
          cancelButtonText: '取消',
          type: 'warning'
        }).then(() => {
          var params={
            id:row.id,
            status:row.status==3?4:3
          }
          checkDemand(params).then(res=>{
            if(res.code==200){
              this.$message.success(res.msg)
              this.getList()
            }else{
              this.$message.error(res.msg)
            }
          })
        }).catch(() => {      
        });
    },
    handleCheck(row){
      this.checkDialog=true
      this.checkFrom.id=row.id
    },
    checkDemand(){
      checkDemand(this.checkFrom).then(res=>{
        if(res.code==200){
          this.$message.success(res.msg)
          this.checkDialog=false
          this.getList()
        }else{
          this.$message.error(res.msg)
        }
      })
    },
    getModules(){
      getAllModule({}).then(res=>{
        this.moduleOptions=res.data
      })
    },
    download(row){
      window.open(this.prefix+row.enclosure)
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
    priority(){
        return function(value){
            if(!value) return '--'
            var item=this.priorityOptions.filter(item=>{
            return item.dict_value==value
        })
            return item[0].dict_label
        }
    },
    status(){
        return function(value){
            if(!value) return '--'
            var item=this.statusOptions.filter(item=>{
            return item.dict_value==value
        })
            return item[0].dict_label
        }
    },
  }
}
</script>

<style>

</style>