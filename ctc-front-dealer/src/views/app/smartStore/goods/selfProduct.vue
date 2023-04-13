<template>
  <div class="app-container">
    <div class="tab-bar">
        <el-form ref="queryForm" :model="queryForm" label-width="100px" :inline="true" size="small">
            <el-form-item label="添加时间" prop="time">
              <el-date-picker
                  style="width:220px"
                  v-model="queryForm.time"
                  type="daterange"
                  unlink-panels=""
                  range-separator="至"
                  value-format="yyyy-MM-dd"
                  start-placeholder="开始日期"
                  end-placeholder="结束日期">
              </el-date-picker>
            </el-form-item>
            <el-form-item label="商品编号" prop="product_code">
                <el-input style="width:220px" v-model="queryForm.product_code" placeholder="请输入商品编号"></el-input>
            </el-form-item>
            <el-form-item label="商品名称" prop="product_name">
                <el-input style="width:220px" v-model="queryForm.product_name" placeholder="请输入商品名称"></el-input>
            </el-form-item>
            <el-form-item label="一级分类" prop="class_one">
                <el-select style="width:220px" @change="selectOneClass" v-model="queryForm.class_one" placeholder="请选择商品分类">
                    <el-option
                        v-for="item in classOptions"
                        :key="item.id"
                        :label="item.class_name"
                        :value="item.id">
                    </el-option>
                </el-select>
            </el-form-item>
            <el-form-item label="二级分类" prop="class_two">
                <el-select style="width:220px" v-model="queryForm.class_two" placeholder="请选择商品分类">
                    <el-option
                        v-for="item in classTwoOptions"
                        :key="item.id"
                        :label="item.class_name"
                        :value="item.id">
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
        <el-button  type="primary" size="small" @click="addProduct">添加商品</el-button>
    </el-col>
    <el-table
           :data="tableData"
           :header-cell-style="{background:'#FAFAFA',color:'#606266',height:'50px'}"
           border
           stripe
           size="medium"
           class="trace-table"
           style="width: 100%">
           <el-table-column prop="cover" align="center" label="产品图片">
             <template slot-scope="scope">
                <img :src="scope.row.cover|cover" width="40px" height="40px">
            </template>
        </el-table-column>
        <el-table-column prop="code" align="center" label="产品编号"></el-table-column>
        <el-table-column prop="product_name" align="center" label="产品名称"></el-table-column>
        <el-table-column prop="class" align="center" label="产品分类">
            <template slot-scope="scope">
                <span>{{type(scope.row.class_one,scope.row.class_two)}}</span>
            </template>
        </el-table-column>
        <el-table-column prop="create_time" align="center" label="添加时间"></el-table-column>
        <el-table-column label="操作" align="center" fixed="right" width="220px">
            <template slot-scope="scope">
                <el-button
                    size="mini"
                    type="primary"
                    @click="handleEdit(scope.row)">编辑</el-button>
                <el-button
                    size="mini"
                    type="danger"
                    @click="handleDele(scope.row)">移除</el-button>
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
import {getStoreGoodsClass} from '@/api/app/store/index'
import {getSelfGoodsList,deleSelfGoods} from '@/api/app/store/goods'
export default {
  data(){
    return{
      queryForm:{
        time:[],
        product_code:'',
        product_name:'',
        class_one:'',
        class_two:'',
        pageNum:1,
        pageSize:10
      },
      queryClassParams:{
          pageNum:1,
          pageSize:999
      },
      tableData:[],
      total:0,
      classOptions:[],
      classTwoOptions:[]
    }
  },
  created(){
    this.getList()
    this.getClassList()
  },
  filters:{
      cover(value){
          if(!value) return ''
          return JSON.parse(value)[0]['url']
      }
  },
  computed:{
      type(){
          return function(a,b){
              var class_one=this.classOptions.filter(item=>item.id==a).map(item=>item.class_name)[0]
              var class_two_options=this.classOptions.filter(item=>item.id==a).map(it=>it.children)[0]
              if(class_two_options){
                  var class_two=class_two_options.filter(item=>item.id==b).map(item=>item.class_name)[0]
              }
              return `${class_one}\\${class_two}`
          }
      }
  },
  methods:{
    getList(){
      var params=Object.assign({},this.queryForm)
      if(!this.queryForm.time||this.queryForm.time.length==0){
          params.startTime=''
          params.endTime=''
      }else{
          params.startTime=this.queryForm.time[0]
          params.endTime=this.queryForm.time[1]
      }
      delete params.time
      getSelfGoodsList(params).then(res=>{
          this.tableData=res.data
          this.total=res.total
      })
    },
    getClassList(){
      getStoreGoodsClass(this.queryClassParams).then(res=>{
          this.classOptions=res.data
      })
    },
    selectOneClass(val){
      this.classTwoOptions=this.classOptions.filter(item=>item.id==val).map(it=>it.children)[0]
    },
    addProduct(){
      this.$router.push({path:'/app/smartStore/goods/selfProductInfo'})
    },
    handleEdit(row){
      this.$router.push({path:'/app/smartStore/goods/selfProductInfo',query:{
        id:row.id
      }})
    },
    handleDele(row){
      this.$confirm(`确认删除该商品?`, '提示', {
          confirmButtonText: '确定',
          cancelButtonText: '取消',
          type: 'warning'
      }).then(() => {
        deleSelfGoods({id:row.id}).then(res=>{
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
      reset(formName){
          this.$refs[formName].resetFields();
          this.query()
      }
  }
}
</script>

<style>

</style>
