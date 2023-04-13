<template>
  <div class="app-container">
    <div v-for="(item,index) in tableData" :key="index">
       <div class="tips">
          <p>{{item.name}}</p>
       </div>
       <el-form :model="item" label-width="120px" ref="authFrom" :rules="rule" size="medium">
          <el-row>
            <el-col :span="8">
              <el-form-item label="成本价:">
                  <span>{{item.cost_price}}{{item.id|unit}}</span>
              </el-form-item>
            </el-col>
          </el-row>
          <el-row>
            <el-col :span="8">
              <el-form-item label="零售价:" prop="retail_pice">
                <el-input v-model.number="item.retail_price">
                    <template slot="append">{{item.id|unit}}</template>
                </el-input>
              </el-form-item>
            </el-col>
          </el-row>
        </el-form>
    </div>
    <div class="dialog-footer">
      <el-button style="width:120px" type="primary" @click="submitForm">保 存</el-button>
    </div>
  </div>
</template>

<script>
import {listService,saveServide} from "@/api/increment/index";
export default {
  data(){
    return{
      tableData:[],
      rule:{
        cost_price:[
          { required: true, message: "成本价不能为空", trigger: "blur" },
          { type: 'number', message: '成本价必须为数字值'}
        ],
        retail_pice:[
          { required: true, message: "零售价不能为空", trigger: "blur" },
          { type: 'number', message: '零售价必须为数字值'}
        ]
      }
    }
  },
  created(){
    this.getList()
  },
  filters:{
    unit:function(value){
      var unit
      switch (value){
        case 1:
        unit='元/模块'
        break;
        case 2:
        unit='元/模块/年'
        break;
        case 3:
        unit='元/次'
        break;
        case 4:
        unit='元/次'
        break;
      }
      return unit
    }
  },
  methods:{
    getList(){
      listService({}).then(res=>{
        this.tableData=res.data
      })
    },
    submitForm(){
      saveServide({arr:JSON.stringify(this.tableData)}).then(res=>{
        if(res.code==200){
          this.$message.success(res.msg)
          this.authDialog = false;
          this.getList();
        }else{
          this.$message.error(res.msg)
        }
      })
    }
  }
}
</script>

<style lang="scss" scoped>
.app-container .tips{
    padding: 8px 16px;
    background-color: #ecf8ff;
    border-radius: 4px;
    border-left: 5px solid #50bfff;
    margin: 20px 0;
}
.dialog-footer{
  margin: 30px 0;
}
</style>