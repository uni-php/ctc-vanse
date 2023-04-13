<template>
  <div class="app-container">
      <el-col :span="24" style="margin:10px 0;">
          <el-button @click="handleAddSms" type="primary" size="small" >添加定价</el-button>
      </el-col>
      <el-table
      :data="tableData"
      :header-cell-style="{background:'#FAFAFA',color:'#606266',height:'50px'}"
      border
      stripe
      size="medium"
      class="trace-table"
      style="width: 100%">
        <el-table-column prop="sms_count" align="center" label="短信条数" ></el-table-column>
        <el-table-column prop="sms_cost" align="center" label="条/价格（成本价）">
          <template slot-scope="scope">
            <span>￥{{scope.row.sms_cost}}</span>
          </template>
        </el-table-column>
        <el-table-column prop="sms_retail" align="center" label="条/价格（零售价）">
          <template slot-scope="scope">
            <span>￥{{scope.row.sms_retail}}</span>
          </template>
        </el-table-column>
        <el-table-column label="操作" align="center" fixed="right" width="240px">
          <template slot-scope="scope">
            <el-button
            size="mini"
            type="primary"
            @click="handleEdit(scope.row)">修改</el-button>
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
     <el-dialog :title="title" :visible.sync="open" width="500px" append-to-body>
        <el-form ref="form" :model="form" :rules="rules" label-width="80px">
          <el-form-item label="短信条数" prop="sms_count">
            <el-input v-model.number="form.sms_count" placeholder="请输入短信条数"/>
          </el-form-item>
          <el-form-item label="成本价" prop="sms_cost">
            <el-input v-model.number="form.sms_cost" placeholder="请输入短信成本价" />
          </el-form-item>
          <el-form-item label="零售价" prop="sms_retail">
            <el-input v-model.number="form.sms_retail" placeholder="请输入短信零售价" />
          </el-form-item>
        </el-form>
        <div slot="footer" class="dialog-footer">
          <el-button type="primary" @click="submitForm">确 定</el-button>
          <el-button @click="cancel">取 消</el-button>
        </div>
     </el-dialog>
  </div>
</template>

<script>
import {listSms,addSms,getSms,deleSms} from "@/api/sms/index";
export default {
  data(){
    return{
      tableData:[],
      total:0,
      queryForm:{
        pageNum:1,
        pageSize:10
      },
      open:false,
      title:'',
      form:{

      },
      rules:{
        sms_count:[
          { required: true, message: "短信条数不能为空", trigger: "blur" },
          { type: 'number', message: '短信条数必须为数字值'}
        ],
        sms_retail:[
          { required: true, message: "短信零售价不能为空", trigger: "blur" },
          { type: 'number', message: '零售价必须为数字值'}
        ],
        sms_cost:[
          { required: true, message: "短信成本价不能为空", trigger: "blur" },
          { type: 'number', message: '成本价必须为数字值'}
        ]
      }
    }
  },
  created(){
    this.getList()
  },
  methods:{
    getList(){
      listSms(this.queryForm).then(res=>{
        this.total=res.total
        this.tableData=res.data
      })
    },
    handleAddSms(){
      this.reset()
      this.title='添加短信包'
      this.open=true
    },
    handleEdit(row){
      this.reset()
      getSms({id:row.id}).then(res=>{
        this.title='修改短信包'
        this.open=true
        this.form=res.data
        this.form.sms_count=Number(res.data.sms_count)
        this.form.sms_cost=Number(res.data.sms_cost)
        this.form.sms_retail=Number(res.data.sms_retail)
      })
    },
    reset() {
      this.form = {
        id:undefined,
        sms_count: '',
        sms_cost:'',
        sms_retail:'',
      };
      this.resetForm("form");
    },
    handleDelete(row){
       this.$confirm('是否确认删除?', "警告", {
              confirmButtonText: "确定",
              cancelButtonText: "取消",
              type: "warning"
          }).then(function() {
            return deleSms({id:row.id});
          }).then(() => {
            this.getList();
            this.msgSuccess("删除成功");
          }).catch(() => {});
    },
    submitForm(){
      this.$refs["form"].validate(valid => {
        if(valid){
          addSms(this.form).then(response => {
            if(response.code==200){
              this.$message.success(response.msg)
              this.open = false;
              this.getList();
            }else{
              this.$message.error(response.msg)
            }
          });
        }
      })    
    },
    cancel(){
      this.open=false
      this.reset()
    }
  }
}
</script>

<style>

</style>