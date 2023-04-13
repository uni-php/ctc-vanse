<template>
  <div class="app-container">
    <el-tabs v-model="activeName" @tab-click="handleClick">
        <el-tab-pane label="产品库" name="first"></el-tab-pane>
        <el-tab-pane label="回收站" name="second"></el-tab-pane>
    </el-tabs>
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
    <el-col :span="24" style="margin:10px 0;">
        <el-button @click="handleAddProduct" type="primary" size="small" >上传产品</el-button>
        <el-button @click="handleImport" icon="el-icon-upload" type="primary" size="small" >批量导入</el-button>
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
        <el-table-column prop="cover" align="center" label="产品图片">
             <template slot-scope="scope">
                <img :src="scope.row.cover|cover" width="40px" height="40px">
            </template>
        </el-table-column>
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
        <el-table-column label="操作" align="center" fixed="right" width="280px">
            <template slot-scope="scope">
                <el-button
                    size="mini"
                    v-show="activeName=='first'"
                    type="primary"
                    @click="handleEdit(scope.row)">修改</el-button>
                <el-button
                    size="mini"
                    type="danger"
                    v-show="activeName=='first'"
                    @click="handleDele(scope.row)">删除</el-button>
                    <el-button
                    size="mini"
                    v-show="activeName=='second'"
                    type="primary"
                    @click="handlerReduction(scope.row)">还原</el-button>
                <el-button
                    size="mini"
                    type="danger"
                    v-show="activeName=='second'"
                    @click="handleDele(scope.row)">彻底删除</el-button>
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
    <!-- 批量导入 -->
    <el-dialog upload.title :visible.sync="upload.open" width="400px" append-to-body>
      <el-upload
        ref="upload"
        :limit="1"
        accept=".xlsx, .xls"
        name="excel"
        :headers="upload.headers"
        :action="upload.url"
        :disabled="upload.isUploading"
        :on-progress="handleFileUploadProgress"
        :on-success="handleFileSuccess"
        :auto-upload="false"
        drag
      > 
        <i class="el-icon-upload"></i>
        <div class="el-upload__text">将文件拖到此处，或<em>点击上传</em></div>
        <div class="el-upload__tip text-center" slot="tip">
          <span>1、仅允许导入xls、xlsx格式文件。</span>
           <div style="margin:4px 0">2、一次最多可导入100条</div>
          <div style="margin:4px 0">3、产品编号、产品名称、价格、库存为必填项，其他选填</div>
          <div style="margin:4px 0">4、产品编号不能重复</div>
          <el-link type="primary" :underline="false" style="font-size:12px;vertical-align: baseline;" @click="importTemplate">下载模板</el-link>
        </div>
      </el-upload>
      <div slot="footer" class="dialog-footer">
        <el-button type="primary" @click="submitFileForm">确 定</el-button>
        <el-button @click="upload.open = false">取 消</el-button>
      </div>
    </el-dialog>
  </div>
</template>
<script>
import {getClassList,getProductList,deleProduct,reductionProduct,importTemplate} from '@/api/assets/product'
import { getToken } from "@/utils/auth";
export default {
    data(){
        return{
            importDialog:false,
            tableData:[],
            total:0,
            activeName:'first',
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
            upload:{
                open: false,
                // 弹出层标题（用户导入）
                title: "",
                // 是否禁用上传
                isUploading: false,
                headers: { Authorization: "Bearer " + getToken() },
                url: process.env.VUE_APP_BASE_API + "/dealer/assets/product/importData",//七牛云地址
            }
        }
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
    created(){
        this.getList()
        this.getClassList()
    },
    methods:{
        getList(){
            this.queryForm.is_del=this.activeName=='first'?0:1
            getProductList(this.queryForm).then(res=>{
                this.tableData=res.data
                this.total=res.total
            })
        },
        getClassList(){
            getClassList(this.queryClassParams).then(res=>{
                this.classOptions=res.data
            })
        },
        selectOneClass(val){
            this.classTwoOptions=this.classOptions.filter(item=>item.id==val).map(it=>it.children)[0]
        },
        handleFileUploadProgress(){
            this.upload.isUploading = true;
        },
        handleFileSuccess(response, file, fileList){
            this.upload.open = false;
            this.upload.isUploading = false;
            this.$refs.upload.clearFiles();
            this.$alert(response.msg, "导入结果", { dangerouslyUseHTMLString: true });
            this.getList();
        },
        submitFileForm(){
            this.$refs.upload.submit();
        },
        importTemplate(){
            importTemplate().then(response => {
                console.log(response)
                // this.download(response.msg);
                 let url = window.URL.createObjectURL(new Blob([response], {type: 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'})); 
                // 生成一个a标签
                let link = document.createElement("a");
                link.style.display = "none";
                link.href = url;
                // 生成时间戳
                let timestamp=new Date().getTime();   
                link.download = '产品批量导入模板';   
                document.body.appendChild(link);
                link.click();
            });
        },
        handleEdit(row){
            this.$router.push({path:'/productDes',query:{product_id:row.id}})
        },
        handlerReduction(row){
            reductionProduct({id:row.id}).then(res=>{
                if(res.code==200){
                    this.$message.success(res.msg)
                    this.getList()
                }else{
                    this.$message.error(res.msg)
                }
            })
        },
        handleDele(row){
            this.$confirm(`删除商品可能会影响物流状态，确认删除?`, '提示', {
                confirmButtonText: '确定',
                cancelButtonText: '取消',
                type: 'warning'
            }).then(() => {
                 deleProduct({id:row.id}).then(res=>{
                    if(res.code==200){
                        this.$message.success(res.msg)
                        this.getList()
                    }else{
                        this.$message.error(res.msg)
                    }
                 })
            }).catch(() => {});
        },
        handleClick(){
            this.queryForm.pageNum=1
            this.getList()
        },
        handleAddProduct(){
            this.$router.push({path:'/productDes'})
        },
        handleImport(){
            this.upload.open=true
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