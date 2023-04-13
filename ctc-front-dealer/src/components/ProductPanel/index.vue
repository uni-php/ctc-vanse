<template>
  <div class="product-box">
      <div class="tab-bar">
        <el-form ref="queryForm" :model="queryForm" label-width="100px" :inline="true" size="small">
        <el-form-item label="产品编号" prop="code">
            <el-input style="width:240px" v-model="queryForm.code" placeholder="请输入产品编号"></el-input>
        </el-form-item>
        <el-form-item label="产品名称" prop="product_name">
            <el-input style="width:240px" v-model="queryForm.product_name" placeholder="请输入产品名称"></el-input>
        </el-form-item>
        <el-form-item label="一级分类" prop="class_one">
            <el-select style="width:240px" @change="selectOneClass" v-model="queryForm.class_one" placeholder="请选择产品分类">
                <el-option
                    v-for="item in classOptions"
                    :key="item.id"
                    :label="item.class_name"
                    :value="item.id">
                </el-option>
            </el-select>
        </el-form-item>
        <el-form-item label="二级分类" prop="class_two">
            <el-select style="width:240px" v-model="queryForm.class_two" placeholder="请选择产品分类">
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
        <el-table-column prop="stock" align="center" label="总库存"></el-table-column>
        <el-table-column prop="price" align="center" label="价格/元"></el-table-column>
        <el-table-column prop="order" align="center" label="排序"></el-table-column>
        <el-table-column prop="create_time" align="center" label="添加时间"></el-table-column>
        <el-table-column label="操作" align="center" width="200px">
              <template slot-scope="scope">
                <el-button
                  size="mini"
                  type="primary"
                  @click="handleSelectProduct(scope.row)">选择</el-button>
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
import {getClassList,getProductList} from '@/api/assets/product'
export default {
    name:'ProductPanel',
    props:{},
    data(){
        return{
            queryForm:{
                code:'',
                product_name:'',
                class_one:'',
                class_two:'',
                is_del:0,
                pageNum:1,
                pageSize:10
            },
            queryClassParams:{
                pageNum:1,
                pageSize:999
            },
            classOptions:[],
            classTwoOptions:[],
            tableData:[],
            total:0
        }
    },
    filters:{
        cover(value){
            if(!value) return '暂无'
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
    created(){
        this.getClassList()
        this.getList()
    },
    methods:{
        getList(){
            getProductList(this.queryForm).then(res=>{
                this.tableData=res.data
                this.total=res.total
            })
        },
        handleSelectProduct(row){
            this.$emit('selectProduct',row)
        },
        getClassList(){
            getClassList(this.queryClassParams).then(res=>{
                this.classOptions=res.data
            })
        },
        selectOneClass(val){
            this.classTwoOptions=this.classOptions.filter(item=>item.id==val).map(it=>it.children)[0]
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

<style lang="scss" scoped>

</style>