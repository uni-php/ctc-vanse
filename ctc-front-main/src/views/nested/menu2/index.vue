<template>
  <div class="app-container">
    <el-form :inline="true" :model="formInline" class="demo-form-inline">
      <el-form-item label="公司名称">
        <el-input size="small" v-model="formInline.user" placeholder="请输入公司名称"></el-input>
      </el-form-item>
      <el-form-item label="加密长度">
        <el-select size="small" v-model="formInline.region" placeholder="请选择加密长度">
          <el-option label="10位" value="10"></el-option>
          <el-option label="11位" value="11"></el-option>
        </el-select>
      </el-form-item>
      <el-form-item>
        <el-button size="small" type="primary" @click="onSubmit">开始生成</el-button>
      </el-form-item>
    </el-form>
  </div>
</template>
<script>
export default {
  data(){
    return{
     formInline: {
          user: '',
          region: ''
        }
    }
  },
  mounted(){
    
  },
  
  methods:{
   
  }
}
</script>
