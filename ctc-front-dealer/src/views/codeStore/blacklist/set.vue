<template>
  <div class="app-container">
      <el-form ref="form" :model="form" label-width="140px" :inline="true" :rules="rule" size="small">
          <el-form-item label="自动加入黑名单：" prop="auto_join">
                <el-radio-group v-model="form.auto_join">
                    <el-radio :label="0">开启</el-radio>
                    <el-radio :label="1">禁用</el-radio>
                </el-radio-group>
          </el-form-item>
          <el-form-item label="每日扫码："  required="" style="width:100%" v-if="form.auto_join==0">
                <span>每日首次扫码次数满</span>
                <el-form-item prop="daily_scan_times">
                   <el-input style="width:50px" v-model="form.daily_scan_times" placeholder="0"></el-input>次，拉黑
                </el-form-item>
                <el-form-item prop="block_duration">
                   <el-input style="width:50px" v-model="form.block_duration" placeholder="0"></el-input>小时
                </el-form-item>
          </el-form-item>
          <el-form-item label="扫码提示：" prop="daily_scan_tips" v-if="form.auto_join==0">
              <el-input
              maxlength="100" 
              show-word-limit  
              style="width:500px"
              :autosize="{ minRows: 3, maxRows: 5}"  
              type="textarea" 
              v-model="form.daily_scan_tips" 
              placeholder="请输入扫码提示"></el-input>
          </el-form-item>
          <el-form-item label="永久拉黑" required="" style="width:100%" v-if="form.auto_join==0">
                <el-form-item prop="permanent">
                    <el-checkbox v-model="form.permanent"></el-checkbox>
                </el-form-item>
                <span>每 </span>
                <el-form-item prop="unit">
                    <el-select style="width:60px" size="small" v-model="form.unit" placeholder="">
                        <el-option
                            v-for="item in unitOptions"
                            :key="item.value"
                            :label="item.label"
                            :value="item.value">
                        </el-option>
                    </el-select>
                </el-form-item>
                <span>拉黑 </span>
                <el-form-item prop="block_times">
                    <el-input style="width:50px" v-model="form.block_times" placeholder="0"></el-input>次，
                </el-form-item>
                <span>永久拉黑</span>
            </el-form-item>
            <el-row v-if="form.auto_join==0">
                <el-form-item label="扫码提示：" prop="permanent_scan_tips">
                    <el-input 
                    style="width:500px"
                    maxlength="100" 
                    show-word-limit  
                    type="textarea" 
                    v-model="form.permanent_scan_tips" 
                    :autosize="{ minRows: 3, maxRows: 5}" 
                    placeholder="请输入扫码提示"></el-input>
                </el-form-item>
            </el-row>
            <el-row>
                <el-form-item label="手动加入黑名单（扫码提示）：" prop="manual_scan_tips">
                    <el-input 
                    maxlength="100" 
                    show-word-limit 
                    style="width:500px" 
                    type="textarea" 
                    v-model="form.manual_scan_tips"
                    :autosize="{ minRows: 3, maxRows: 5}" 
                    placeholder="请输入扫码提示"></el-input>
                </el-form-item>
            </el-row>
            <el-row type="flex" justify="space-between">
                <el-col :span="8" style="padding-left:140px">
                    <el-button type="primary" size="medium" @click="save">保存</el-button>
                </el-col>
            </el-row>
      </el-form>
  </div>
</template>

<script>
import {saveBlackListSet,getBlackListSet} from '@/api/codeStore/blackList'
export default {
    data(){
        return{
            form:{
                auto_join:0,
                daily_scan_times:0,
                block_duration:0,
                daily_scan_tips:'',
                unit:1,
                block_times:0,
                permanent:false,
                permanent_scan_tips:'',
                manual_scan_tips:''
            },
            unitOptions:[
                {
                    value:1,
                    label:'日'
                },
                {
                    value:2,
                    label:'周'
                },
                {
                    value:3,
                    label:'月'
                }
            ],
            rule:{
                daily_scan_times:[
                    { required: true, message: "请输入每日扫码次数", trigger: "blur" },
                ],
                block_duration:[
                    { required: true, message: "请输入拉黑时长", trigger: "blur" },
                ],
                daily_scan_tips:[
                     { required: true, message: "请输入扫码提示", trigger: "blur" },
                ],
                permanent_scan_tips:[
                     { required: true, message: "请输入扫码提示", trigger: "blur" },
                ],
                manual_scan_tips:[
                     { required: true, message: "请输入扫码提示", trigger: "blur" },
                ]
            }
        }
    },
    created(){
        this.getBlackListSet()
    },
    methods:{
        getBlackListSet(){
            getBlackListSet({}).then(res=>{
                if(res.data){
                    var ob=res.data
                    ob.permanent=ob.permanent==1?true:false
                    this.form=ob
                }   
            })
        },
        save(){
            this.$refs["form"].validate(valid => {
                if(valid){
                    var arr=Object.assign({},this.form)
                    arr.permanent=arr.permanent?1:0
                    saveBlackListSet(arr).then(res=>{
                        if(res.code==200){
                            this.$message.success(res.msg)
                            this.getBlackListSet()
                        }else{
                            this.$message.error(res.msg)
                        }
                    })
                }
            })
        }
    }
}
</script>

<style>

</style>