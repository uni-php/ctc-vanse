<!--
 * @Author: wenhanhan 1196086345@qq.com
 * @Date: 2022-09-04 12:47:54
 * @LastEditors: wenhanhan 1196086345@qq.com
 * @LastEditTime: 2022-10-23 17:09:00
 * @Description: 添加分组
-->
<template>
  <div class="app-container">
    <el-form :model="form" ref="form" label-width="160px" :rules="rule"  class="form" size="medium">
      <el-form-item prop="group_name" label="身份分组名称：" >
          <el-input style="width:50%" v-model="form.group_name" placeholder="请输入分组名称"></el-input>
      </el-form-item>
      <el-form-item prop="order" label="身份分组排序：" >
          <el-input style="width:50%" v-model="form.order" placeholder="请输入分组排序"></el-input>
      </el-form-item>
      <el-form-item prop="is_check" label="是否审核导购员：" >
          <el-radio-group v-model="form.is_check">
            <el-radio :label="1">是</el-radio>
            <el-radio :label="2">否</el-radio>
          </el-radio-group>
      </el-form-item>
      <el-form-item prop="is_sms" label="开启短信通知：" >
          <el-radio-group v-model="form.is_sms">
            <el-radio :label="1">是</el-radio>
            <el-radio :label="2">否</el-radio>
          </el-radio-group>
      </el-form-item>
      <el-form-item prop="is_condition" label="是否显示申请条件：" >
          <el-radio-group v-model="form.is_condition">
            <el-radio :label="1">是</el-radio>
            <el-radio :label="2">否</el-radio>
          </el-radio-group>
      </el-form-item>
      <el-form-item prop="condition_title" label="标题：" v-if="form.is_condition==1">
          <el-input style="width:50%" v-model="form.condition_title" placeholder="请输入条件标题"></el-input>
      </el-form-item>
      <el-form-item prop="condition_content" v-if="form.is_condition==1" label="内容：" >
          <el-input  :autosize="{ minRows: 5, maxRows: 6}" type="textarea" style="width:50%" v-model="form.condition_content" placeholder="请输入内容"></el-input>
      </el-form-item>
      <el-form-item prop="is_rank" label="排行榜显示：" >
          <el-radio-group v-model="form.is_rank">
            <el-radio :label="1">是</el-radio>
            <el-radio :label="2">否</el-radio>
          </el-radio-group>
      </el-form-item>
      <el-form-item prop="rank_type" label="显示类别："  v-if="form.is_rank==1">
         <el-checkbox-group v-model="form.rank_type">
          <el-checkbox :label="1">扫码领奖排行榜</el-checkbox>
          <el-checkbox :label="2">红包排行榜</el-checkbox>
        </el-checkbox-group>
      </el-form-item>
      <el-form-item prop="prize_rank_num" label="领奖排行榜显示数量：" v-if="form.is_rank==1&&form.rank_type.includes(1)">
          <el-input style="width:50%" v-model="form.prize_rank_num" placeholder="请输入排行榜显示数量"></el-input>
      </el-form-item>
       <el-form-item prop="prize_rank_time" label="领奖排行榜显示时间："  v-if="form.is_rank==1&&form.rank_type.includes(1)">
         <el-checkbox-group v-model="form.prize_rank_time">
          <el-checkbox :label="1">本周</el-checkbox>
          <el-checkbox :label="2">本月</el-checkbox>
          <el-checkbox :label="3">本年</el-checkbox>
          <el-checkbox :label="4">累计</el-checkbox>
        </el-checkbox-group>
      </el-form-item>
      <el-form-item prop="red_rank_num" label="红包排行榜显示数量：" v-if="form.is_rank==1&&form.rank_type.includes(2)">
          <el-input style="width:50%" v-model="form.red_rank_num" placeholder="请输入排行榜显示数量"></el-input>
      </el-form-item>
       <el-form-item prop="red_rank_time" label="红包排行榜显示时间："  v-if="form.is_rank==1&&form.rank_type.includes(2)">
         <el-checkbox-group v-model="form.red_rank_time">
          <el-checkbox :label="1">本周</el-checkbox>
          <el-checkbox :label="2">本月</el-checkbox>
          <el-checkbox :label="3">本年</el-checkbox>
          <el-checkbox :label="4">累计</el-checkbox>
        </el-checkbox-group>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" @click="onSubmit">保存</el-button>
        <el-button @click="goBack">取消</el-button>
      </el-form-item>
    </el-form>
  </div>
</template>

<script>
import {saveGuideGroup,getGuideGroupInfo} from '@/api/app/guide/group'
export default {
  data(){
    return{
      form:{
        group_name:'',
        order:'',
        is_check:1,
        is_sms:1,
        is_condition:1,
        condition_title:'申请条件',
        is_rank:1,
        rank_type:[1,2],
        prize_rank_num:3,
        prize_rank_time:[1,2,3,4],
        red_rank_time:[1,2,3,4],
        red_rank_num:3
      },
      rule:{
        group_name:[
            { required: true, message: "请输入分组名称", trigger: "blur" },
            { min: 3, max: 10, message: '长度在 3 到 10 个字符', trigger: 'blur' }
        ],
        condition_title:[
          { required: true, message: "请输入条件标题", trigger: "blur" },
          { min: 3, max: 10, message: '长度在 3 到 10 个字符', trigger: 'blur' }
        ],
        condition_content:[
          { required: true, message: "请输入条件内容", trigger: "blur" },
          { min: 3, max: 150, message: '长度在 3 到 150 个字符', trigger: 'blur' }
        ]
      }
    }
  },
  created(){
    const id =this.$route.query.id
    if(id){
      this.getGuideGroupInfo(id)
    }
  },
  methods:{
    getGuideGroupInfo(id){
      getGuideGroupInfo({id:id}).then(res=>{
        this.form = res.data
      })
    },
    onSubmit(){
      this.$refs["form"].validate(valid => {
        if(valid){
          saveGuideGroup(this.form).then(res=>{
            if(res.code==200){
                this.$message.success(res.msg)
                setTimeout(()=>{
                    this.close();
                },500)
            }else{
                this.$message.error(res.msg)
            }
          })
        }
      })
    },
    goBack(){
      this.close();
  },
  /** 关闭按钮 */
  close() {
      this.$store.dispatch("tagsView/delView", this.$route);
      this.$router.go(-1)
  },
  }
}
</script>

<style>

</style>
