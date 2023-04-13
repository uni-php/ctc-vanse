<template>
  <div class="app-container">
      <div class="tab-bar">
        <el-form ref="queryForm" :model="queryForm" label-width="80px" :inline="true" size="small">
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
      <el-col :span="24" style="margin:10px 0;">
          <el-button @click="handleAddDemand" type="primary" size="small" >提交需求</el-button>
      </el-col>
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
        <el-table-column prop="dealer_name" align="center" label="品牌商" ></el-table-column>
        <el-table-column prop="describe" align="center" show-overflow-tooltip="" label="需求描述" ></el-table-column>
        <el-table-column prop="tips" align="center" label="审核意见" >
          <template slot-scope="scope">
            <span>{{scope.row.tips||'--'}}</span>
          </template>
        </el-table-column>
        <el-table-column prop="create_time" align="center" label="提交时间" ></el-table-column>
        <el-table-column prop="status" align="center" label="审核状态" >
          <template slot-scope="scope">
             <span>{{status(scope.row.status)}}</span>
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
      <!-- 提交需求 -->
      <el-dialog :title="dialogTitle" :visible.sync="open" width="50%" @close="open=false">
        <el-form :model="form" ref="form" label-width="100px" :rules="rule" size="medium">
          <el-form-item label="标题" prop="title">
            <el-input style="width:90%"  v-model="form.title" placeholder="请输入需求标题"/>
          </el-form-item>
          <el-form-item label="功能模块" prop="module_id">
            <el-select style="width:90%" v-model="form.module_id" placeholder="请选择功能模块">
                <el-option
                    v-for="item in moduleOptions"
                    :key="item.id"
                    :label="item.module_name"
                    :value="item.id">
                </el-option>
            </el-select>
          </el-form-item>
          <el-form-item label="品牌商" prop="dealer_name">
            <el-input style="width:90%" @focus="selectPartner" v-model="form.dealer_name" placeholder="请选择品牌商"/>
          </el-form-item>
          <el-form-item label="优先级" prop="priority">
            <el-select style="width:90%" v-model="form.priority" placeholder="请选择优先级">
                <el-option
                    v-for="item in priorityOptions"
                    :key="item.dict_value"
                    :label="item.dict_label"
                    :value="item.dict_value">
                </el-option>
            </el-select>
          </el-form-item>
          <el-form-item label="需求描述" prop="describe" >
            <!-- <QuillEditor style="width:90%" v-model="form.describe"></QuillEditor> -->
            <el-input style="width:90%" :autosize="{ minRows: 3, maxRows: 5}" type="textarea" v-model="form.describe"></el-input>
          </el-form-item>
          <el-form-item label="需求附件" prop="ico">
            <el-upload
              class="upload-demo"
              :action="upload.url"
              :on-remove="handleRemove"
              name="file"
              :accept="uploadAccept"
              :before-remove="beforeRemove"
              :limit="1"
              :headers="upload.headers"
              :on-success="handleFileSuccess"
              :on-exceed="handleExceed"
              :file-list="fileList">
              <el-button size="small" type="primary">点击附件</el-button>
            </el-upload>
          </el-form-item>
        </el-form>
        <!-- 选择品牌商表格 -->
        <el-dialog
          width="70%"
          title="选择品牌商商"
          :visible.sync="dealerDialog"
          append-to-body>
          <el-form ref="queryDealerForm" :model="queryDealerForm" label-width="100px" :inline="true" size="small">
            <el-form-item label="品牌商名称" prop="queryDealerForm">
              <el-input style="width:240px" v-model="queryDealerForm.dealer_name" placeholder="请输入品牌商名称"></el-input>
            </el-form-item>
            <el-form-item label="品牌商账户" prop="account">
              <el-input style="width:240px" v-model="queryDealerForm.account" placeholder="请输入品牌商账户"></el-input>
            </el-form-item>
            <el-form-item > 
              <el-button type="primary" icon="el-icon-search" @click="queryDealer">查询</el-button>
              <el-button icon="el-icon-refresh" @click="resetDealerQuery('queryDealerForm')">重置</el-button>
            </el-form-item>
          </el-form>
          <el-table
            :data="tableDealerData"
            :header-cell-style="{background:'#FAFAFA',color:'#606266',height:'50px'}"
            border
            stripe
            size="small"
            class="trace-table"
            style="width: 100%">
            <el-table-column prop="id" align="center" label="品牌商编号" ></el-table-column>
            <el-table-column prop="dealer_name" align="center" label="品牌商名称" ></el-table-column>
            <el-table-column prop="account" align="center" label="品牌商账号" ></el-table-column>
            <el-table-column label="操作" align="center" fixed="right" width="200px">
              <template slot-scope="scope">
                <el-button
                  size="mini"
                  type="primary"
                  @click="handleSelect(scope.row)">选择</el-button>
              </template>
            </el-table-column>
          </el-table>
          <pagination
            v-show="+totals>10"
            :total="+totals"
            :page.sync="queryDealerForm.pageNum"
            :limit.sync="queryDealerForm.pageSize"
            @pagination="getDealerList"
        />
        </el-dialog>
        <div slot="footer" class="dialog-footer">
          <el-button type="primary" @click="submitForm">确 定</el-button>
          <el-button @click="cancel">取 消</el-button>
        </div>
      </el-dialog>
  </div>
</template>

<script>
import {getAllModule,getDemands,addDemands,getDealer} from "@/api/demand/index";
import QuillEditor from "@/components/Editor"
import {getToken} from '@/utils/auth'
export default {
  components:{QuillEditor},
  data(){
    return{
      queryForm:{
        title:'',
        priority:"",
        status:'',
        date:[],
        dealer_name:'',
        module:'',
        pageNum:1,
        pageSize:10
      },
      rule:{
        title:[
          { required: true, message: "请输入需求标题", trigger: "blur" }
        ],
        module_id:[
          { required: true, message: "请选择功能模块", trigger: "blur" }
        ],
        dealer_name:[
          { required: true, message: "请选择品牌商", trigger: "blur" }
        ],
        priority:[
          { required: true, message: "请选择优先级", trigger: "blur" }
        ],
        describe:[
          { required: true, message: "请填写需求描述", trigger: "blur" }
        ]
      },
      fileList:[],
      form:{
        title:'',
        module_id:'',
        partner_id:undefined,
        dealer_id:'',
        dealer_name:'',
        enclosure:'',
        describe:''
      },
      queryDealerForm:{
        dealer_name:'',
        account:'',
        pageNum:1,
        pageSize:10
      },
      uploadAccept:'.jpg,.jpeg,.png,.doc,.docx,.xls,.xlsx,.ppt,.pptx,.txt,.pdf',
      upload:{
        headers: { Authorization: "Bearer " + getToken() },
        // 上传的地址
        url: process.env.VUE_APP_BASE_API + "/partner/demand/uploadFile",
      },
      priorityOptions:[],
      moduleOptions:[],
      statusOptions:[],
      total:0,
      totals:0,
      open:false,
      dealerDialog:false,
      dialogTitle:'',
      tableData:[],
      tableDealerData:[]
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
    //查询品牌商
    getDealerList(){
      getDealer(this.queryDealerForm).then(res=>{
        this.tableDealerData=res.data
        this.totals=res.total
      })
    },
    handleSelect(row){
      this.dealerDialog=false
      this.form.dealer_name=row.dealer_name
      this.form.dealer_id=row.id
      this.form.partner_id=row.partner_id
    },
    handleAddDemand(){
      this.open=true,
      this.dialogTitle='提交需求'
    },
    handleEdit(){
      this.$message.info('待排期需求无法修改')
    },
    selectPartner(){
      this.dealerDialog=true
      this.getDealerList()
    },
    getModules(){
      getAllModule({}).then(res=>{
        this.moduleOptions=res.data
      })
    },
    handleRemove(file, fileList) {
      this.form.enclosure=''
    },
    beforeRemove(file, fileList) {
      return this.$confirm(`确定移除 ${ file.name }？`);
    },
    handleFileSuccess(res,file){
      this.form.enclosure=file.response
    },
    handleExceed(files, fileList) {
      this.$message.warning(`当前限制选择 1 个文件，本次选择了 ${files.length} 个文件，共选择了 ${files.length + fileList.length} 个文件`);
    },
    submitForm(){
      this.$refs["form"].validate(valid => {
        if(valid){
          var arr=Object.assign({},this.form)
          delete arr.dealer_name
          addDemands(arr).then(response=>{
             if(response.code==200){
                this.$message.success(response.msg)
                this.open = false;
                this.getList();
              }else{
                this.$message.error(response.msg)
              }
          })
        }
      })
    },
    cancel(){
      this.open = false;
      this.reset();
    },
    reset(){
      this.resetForm("form");
    },
    query(){
      this.queryForm.pageNum = 1;
      this.getList();
    },
    queryDealer(){
      this.queryDealerForm.pageNum = 1;
      this.getDealerList();
    },
    resetQuery(formName){
      this.$refs[formName].resetFields();
      this.query()
    },
    resetDealerQuery(formName){
      this.$refs[formName].resetFields();
      this.queryDealer()
    }
  },
  computed:{
    priority(){
      return function(value){
        const arr=this.priorityOptions.filter(item=>item.dict_value==value).map(item=>item.dict_label)
        return arr[0]
      }
    },
    status(){
      return function(value){
        console.log(this.statusOptions.filter(item=>item.dict_value==value))
        const arr=this.statusOptions.filter(item=>item.dict_value==value).map(item=>item.dict_label)
        return arr[0]
      }
    },
  }
}
</script>
<style lang="scss" scoped>
.app-container{
  ::v-deep .ql-container.ql-snow{
    height: 190px;
  }
}
</style>
