<template>
  <div class="app-container">
    <div class="tab-bar">
      <el-form ref="queryForm" :model="queryForm" label-width="80px" :inline="true" size="small">
        <el-form-item label="企业名称" prop="companyName">
          <el-input v-model="queryForm.companyName"></el-input>
        </el-form-item>
        <el-form-item > 
          <el-button type="primary" icon="el-icon-search" @click="query">查询</el-button>
          <el-button icon="el-icon-refresh" @click="reset('queryForm')">重置</el-button>
        </el-form-item>
      </el-form>
    </div>
    <el-row>
      <el-col :span="24">
        <el-button type="primary" size="small" icon="el-icon-plus" @click="addCode">数码生成</el-button>
        <!-- <el-button type="primary" size="small" icon="el-icon-search" @click="codeQuery">数码互查</el-button> -->
      </el-col>
    </el-row>
    <el-table
      :data="tableData"
      border
      stripe
      size="medium"
      class="trace-table"
      empty-text=""
      style="width: 100%">
      <el-table-column prop="CompanyName" align="center" label="企业名称"></el-table-column>
      <el-table-column prop="StartCode" align="center" label="流水号范围">
        <template slot-scope="scope">
          <span>{{scope.row.StartCode}}~{{scope.row.EndCode}}</span>
        </template>
      </el-table-column>
      <el-table-column prop="CodeLen" align="center" label="数码位数" width="100px"></el-table-column>
      <el-table-column prop="CodeCount" align="center" label="生码数量"></el-table-column>
      <el-table-column prop="Remark" align="center" label="备注说明"></el-table-column>
      <el-table-column prop="createTime" align="center" label="生码时间">
        <template slot-scope="scope">
          <span>{{scope.row.CreateDate}} {{scope.row.CreateTime}}</span>
        </template>
      </el-table-column>
      <el-table-column label="操作" align="center">
        <template slot-scope="scope">
          <el-button
            size="mini"
            type="primary"
            @click="handleDownload(scope.row)">下载</el-button>
            <!-- 不可编辑 -->
          <!-- <el-button 
            size="mini"
            @click="handleEdit(scope.$index, scope.row)">编辑</el-button> -->
          <el-button
            size="mini"
            type="danger"
            @click="handleDelete(scope.row)">删除</el-button>
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
     <!-- 弹窗区域 -->
    <el-dialog title="企业生码" :visible.sync="dialogFormVisible" width="30%">
      <el-form :model="form" :rules="rules" size="medium" ref="form" label-width="90px">
          <el-form-item label="企业名称"  prop="CompanyId">
            <el-select style="width:100%" filterable v-model="form.CompanyId" @change="selectCompany" clearable placeholder="请选择企业">
              <el-option
                v-for="item in company"
                :key="item.CompanyId"
                :label="item.CompanyName"
                :value="item.CompanyId"
              >
              </el-option>
            </el-select>
          </el-form-item>
          <el-form-item label="数码位数"  prop="CodeLen">
            <el-select style="width:100%" v-model="form.CodeLen" @change="selectCodeLen" clearable placeholder="请选择数码位数">
              <el-option
                v-for="item in codeLen"
                :key="item.value"
                :label="item.label"
                :value="item.value"
              >
              </el-option>
            </el-select>
          </el-form-item>
          <el-form-item label="生码数量"  prop="CodeCount">
            <el-input placeholder="请输入生码数量" v-model.number="form.CodeCount" @input="stCodeCount($event)" style="width:100%;" clearable autocomplete="off"></el-input>
          </el-form-item>
          <el-form-item label="数码序列号">
            <el-row type="flex" class="row-bg" justify="space-between">
              <el-col :span="11">
                <el-form-item prop="StartCode">
                  <el-input placeholder="请输入起始编号" disabled v-model="form.StartCode" style="width:100%;" clearable autocomplete="off"></el-input>
                </el-form-item>
              </el-col>
              <el-col class="line" style="text-align:center" :span="2">-</el-col>
              <el-col :span="11">
                <el-form-item prop="EndCode">
                  <el-input placeholder="请输入终止编号" v-model.number="form.EndCode" disabled style="width: 100%;" clearable autocomplete="off"></el-input>
                </el-form-item>
              </el-col>
            </el-row>
          </el-form-item>
          <el-form-item prop="prefix" label="加密前缀">
            <el-input placeholder="加密前缀" v-model="form.prefix" style="width: 100%;" clearable autocomplete="off"></el-input>
          </el-form-item>
          <el-form-item label="说明备注"  prop="Remark">
            <el-input type="textarea" v-model="form.Remark"></el-input>
          </el-form-item>
          <el-row type="flex" class="row-bg" justify="center">
            <el-col class="option-btn" :span="24">
              <el-button size="medium" class="option-btn-item" type="primary" @click="submitForm('form')">提交</el-button>
              <el-button size="medium" class="option-btn-item" @click="resetForm('form')">重置</el-button>
            </el-col>
          </el-row>
      </el-form>
    </el-dialog>
    <!-- 数码互查 -->
    <el-dialog title="数码互查" :visible.sync="dialogCodeQueryFormVisible" width="40%">
       <el-tabs v-model="activeName" type="card">
        <el-tab-pane label="序列密码反查" name="check"></el-tab-pane>
        <el-tab-pane label="数码关联互查" name="rel"></el-tab-pane>
      </el-tabs>
      <div class="check" v-if="activeName=='check'">
        <el-input style="width:80%" placeholder="请输入数码" v-model="code" class="input-with-select">
          <el-select v-model="checkType" slot="prepend" placeholder="请选择">
            <el-option label="查询加密码" value="1"></el-option>
            <el-option label="查询序列号" value="2"></el-option>
          </el-select>
          <el-button slot="append" icon="el-icon-search"></el-button>
        </el-input>
        <el-card class="box-card">
          <div v-for="o in 4" :key="o" class="text item">
            {{'列表内容 ' + o }}
          </div>
        </el-card>
      </div>
      <div class="check" v-else>
        <el-input style="width:80%" placeholder="请输入数码" v-model="code" class="input-with-select">
          <el-select v-model="checkType" slot="prepend" placeholder="请选择">
            <el-option label="外箱查中箱" value="1"></el-option>
            <el-option label="外箱查单盒" value="2"></el-option>
            <el-option label="中箱查外箱" value="3"></el-option>
            <el-option label="中箱查单盒" value="4"></el-option>
            <el-option label="单盒查中箱" value="5"></el-option>
            <el-option label="单盒查外箱" value="6"></el-option>
          </el-select>
          <el-button slot="append" icon="el-icon-search"></el-button>
        </el-input>
        <el-card class="box-card">
          <div v-for="o in 4" :key="o" class="text item">
            {{'列表内容 ' + o }}
          </div>
        </el-card>
      </div>  
    </el-dialog>
  </div>
</template>
<script>
import {getAllCompany,getCompanyType,getCodeRelation} from '@/api/company'
import {getCode,createCode,deleteCode,getCodeOrder} from '@/api/code'
export default{
  data(){
    return{
      total:0,
      activeName:'check',
      queryForm:{
        companyName:'',
        pageSize:10,
        pageNum:1
      },
      tableData:[],
      codeType:[],
      checkType:'1',//互查类型
      code:'',//查询数码
      checkResult:'',
      dialogFormVisible:false,
      dialogCodeQueryFormVisible:false,
      company:[],
      //数码位数关系 后台匹配查询 防止随意输入
      codeLen:[
      ],
      form:{
        CompanyId:'',
        CodeLen:'',
        StartCode:'',
        EndCode:'',
        Count:'',
        prefix:'',
        Remark:''
      },
      rules:{
        CompanyId:[
          { required: true, message: '请选择生码企业', trigger: 'blur' },
        ],
        CodeLen:[
          { required: true, message: '请选择生码位数', trigger: 'blur' },
        ],
        StartCode:[
          { required: true, message: '请输入起始编号', trigger: 'blur' },
        ],
        CodeCount:[
          { required: true, message: '请输入生码数量', trigger: 'blur' },
        ],
        EndCode:[
          { required: true, message: '请输入终止编号', trigger: 'blur' },
        ]
      }
    }
  },
  created(){
    this.getAllCompany()
    this.getList()
    this.getCompanyType()
  },
  methods:{
    getAllCompany(){
      getAllCompany().then(res => {
        this.company=res.data
      })
    },
    getList(){
      getCode(this.queryForm).then(res=>{
        this.tableData=res.data
        this.total=res.total
      })
    },
    getCompanyType(){
      getCompanyType().then(res=>{
        this.codeType=res.data
      })
    },
    typeFormat(row,column){
      var type
      this.codeType.forEach(item=>{
        if(item.type==row.codeType){
          type=item.name 
          return;
        }
      })
      return type
    },
    addCode(){
      this.dialogFormVisible=true
      this.codeLen=[]
      this.form={}
    },
    codeQuery(){
      this.dialogCodeQueryFormVisible=true
    },
    selectCompany(val){
      this.codeLen=[]
      this.form.CodeLen=''
      this.form.StartCode=''
      this.form.EndCode=''
      this.form.CodeCount=''
      getCodeRelation({'CompanyId':val}).then(res=>{
        if(res.data){
          var arr=JSON.parse(res.data);
          var newArr=[];
          arr.forEach((item,index)=>{
            newArr.push({
              value:item,
              label:`${item}位数字码`
            })
          })
          this.codeLen=newArr;
        }
      })
      this.$forceUpdate()
    },
    //生码数量计算码段
    stCodeCount(val){
      this.$forceUpdate()
      if (!val||val=='0'){
        this.form.EndCode=''
        return;
      } 
      this.form.EndCode=this.form.StartCode+Number(val)-1
      
    },
    //选中生码位数 匹配生码序列号
    selectCodeLen(val){
      var params={
        CompanyId:this.form.CompanyId,
        CodeLen:val
      }
      getCodeOrder(params).then(res=>{
        if(res.code==200){
          this.form.StartCode=res.data
          this.$forceUpdate()
        }else{
          this.$message.error(res.msg)
        }
      })
    },
    submitForm(formName){
      var arr=Object.assign({},this.form)
      this.$refs[formName].validate((valid) => {
        if (valid) {
          if(Number(arr.CodeCount)>500000){
              this.$message({
                message: '单次生码数量不超过50万',
                type: 'warning'
              });
              return;
          }
         this.createCode(arr)
        }else{
          console.log('error submit!!');
          return false;
        }
    })
  },
  createCode(arr){
    createCode(arr).then(res=>{
         if(res.code==200){
            this.$message({
              message:res.msg,
              type:'success'
            });
            this.dialogFormVisible=false
            var title=`${this.getCompanyName(arr['CompanyId'])}--(${arr['StartCode']}-${arr['EndCode']})`
            this.downLoad(`${title}.txt`,res.securityCode)
            this.getList()
          }else{  
            this.$message.error(res.msg)
          }
      })
  },
    downLoad(filename, content,contentType){
      if (!contentType) contentType = 'application/octet-stream';
      var a = document.createElement('a');
      var blob = new Blob([content], { 'type': contentType });
      a.href = window.URL.createObjectURL(blob);
      a.download = filename;
      a.click();
  },
  handleDownload(row){
    var arr=Object.assign({},row)
    this.createCode(arr)
  },
  handleDelete(row){
    deleteCode(row).then(res=>{
      if(res.code==200){
          this.$message({
            message:res.msg,
            type:'success'
          });
          this.dialogFormVisible=false
          this.getList()
        }else{  
          this.$message.error(res.msg)
        }
    })
  },
    getCompanyName(account){
      var company=this.company.filter(item=>{
        return item.CompanyId==account
      })
      return company[0]['CompanyName'];
    },
    resetForm(formName) {
      this.$refs[formName].resetFields();
    },
    reset(formName){
      this.$refs[formName].resetFields();
      this.getList()
    },
    query(){
      this.getList() 
    },
  }
}
</script>
<style lang="scss" scoped>
 .trace-table{
    margin-top: 10px;;
  }
  .option-btn{
    display: flex;
    justify-content: center;
    margin-top: 20px;
  }
  .option-btn-item{
    width: 120px;
  }
  //命名空间限制
  .check{
      ::v-deep .el-select .el-input {
      width: 130px;
    }
    .box-card{
      width: 80%;
      height: 200px;
      margin-top: 10px;
    }
  }
</style>

