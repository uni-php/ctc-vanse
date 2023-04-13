<template>
  <div class="app-container">
    <div class="tab-bar">
        <el-form ref="queryForm" :model="queryForm" label-width="100px" :inline="true" size="small">
            <el-form-item label="时间" prop="time">
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
            <el-form-item label="openid" prop="openid">
                <el-input style="width:220px" v-model="queryForm.openid" placeholder="请输入会员openid"></el-input>
            </el-form-item>
            <el-form-item label="有效期" prop="validity">
                <el-select style="width:220px" size="small"  v-model="queryForm.validity" placeholder="请选择有效期">
                    <el-option
                        v-for="item in validityOptions"
                        :key="item.value"
                        :label="item.label"
                        :value="item.value">
                    </el-option>
                </el-select>
            </el-form-item>
            <el-form-item label="会员ID" prop="member_id">
                <el-input style="width:220px" v-model="queryForm.member_id" placeholder="请输入会员ID"></el-input>
            </el-form-item>
            <el-form-item > 
                <el-button type="primary" icon="el-icon-search" @click="query">查询</el-button>
                <el-button icon="el-icon-refresh" @click="reset('queryForm')">重置</el-button>
            </el-form-item>
        </el-form>
    </div>
    <el-col :span="24" style="margin:10px 0;">
        <el-button type="primary" style="font-size:14px" size="mini" @click="addBlackList">添加黑名单</el-button>
    </el-col>
    <el-table
      :data="tableData"
      :header-cell-style="{background:'#FAFAFA',color:'#606266',height:'50px'}"
      border
      stripe
      size="medium"
      class="trace-table"
      style="width: 100%">
        <el-table-column prop="openid"  align="center" show-overflow-tooltip="" label="openid" :formatter="openid"></el-table-column>
        <el-table-column prop="phone"  align="center" show-overflow-tooltip="" label="手机号" :formatter="phone"></el-table-column>
        <el-table-column prop="id"  align="center" show-overflow-tooltip="" label="会员ID" :formatter="member_id"></el-table-column>
        <el-table-column prop="validity"  align="center" show-overflow-tooltip="" label="有效期" :formatter="validity"></el-table-column>
        <el-table-column prop="reason"  align="center" show-overflow-tooltip="" label="原因"></el-table-column>
        <el-table-column prop="create_time"  align="center" show-overflow-tooltip="" label="拉黑时间"></el-table-column>
        <el-table-column prop="duration"  align="center" show-overflow-tooltip="" label="释放时间" :formatter="duration"></el-table-column>
        <el-table-column label="操作" align="center" fixed="right" width="200px">
            <template slot-scope="scope">
                <el-button
                    size="mini"
                    type="primary"
                    @click="revoke(scope.row)">撤销黑名单</el-button>
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
    <!-- 添加黑名单弹窗 -->
    <el-dialog title="添加黑名单" :visible.sync="dialogVisible" width="40%" @close="dialogVisible=false">
        <el-form ref="form" :model="form" label-width="100px" :rules="rule"  size="small">
            <el-form-item label="关键词："  prop="keywords">
                <el-input style="width:80%" placeholder="请输入内容" v-model="form.keywords" class="input-with-select">
                    <el-select v-model="form.type" slot="prepend" style="width:100px" placeholder="请选择">
                        <el-option label="ID" value="1"></el-option>
                        <el-option label="手机号" value="2"></el-option>
                        <el-option label="openid" value="3"></el-option>
                    </el-select>
                </el-input>
            </el-form-item>
            <el-form-item label="有效期：" prop="validity">
                <el-radio-group v-model="form.validity">
                    <el-radio v-for="(item,index) of validityOptions" :key="index" :label="item.value">{{item.label}}</el-radio>
                </el-radio-group>
            </el-form-item>
            <el-form-item prop="duration" label="拉黑时长" v-if="form.validity==1">
                <el-input style="width:80%" v-model.number="form.duration" placeholder="多少小时"></el-input>
            </el-form-item>
            <el-form-item label="原因：" prop="reason">
                <el-input 
                    maxlength="100" 
                    show-word-limit 
                    style="width:80%"
                    type="textarea" 
                    v-model="form.reason"
                    :autosize="{ minRows: 3, maxRows: 5}" 
                    placeholder="请输入拉黑原因"></el-input>
            </el-form-item>
        </el-form>
        <div slot="footer" class="dialog-footer">
            <el-button type="primary" @click="submitForm">确 定</el-button>
        </div>
    </el-dialog>
  </div>
</template>

<script>
import {getBlackList,saveBlackList,revokeBlackList} from '@/api/codeStore/blackList'
export default {
    data(){
        return{
            dialogVisible:false,
            queryForm:{
                time:[],
                openid:'',
                validity:'',
                member_id:'',
                pageNum:1,
                pageSize:10
            },
            form:{
                keywords:'',
                type:'1',
                validity:1,
                duration:'',
                reason:''
            },
            rule:{
                reason:[
                    { required: true, message: "请输入拉黑原因", trigger: "blur" },
                ],
                keywords:[
                     { required: true, message: "请输入关键词", trigger: "blur" },
                ],
                duration:[
                    { required: true, message: "请输入拉黑时长", trigger: "blur" },
                ]
            },
            validityOptions:[
                {
                    value:1,
                    label:'限时拉黑'
                },
                {
                    value:2,
                    label:'永久拉黑'
                },
            ],
            tableData:[],
            total:0
        }
    },
    created(){
        this.getList()
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
            getBlackList(params).then(res=>{
                this.tableData=res.data
                this.total=res.total
            })
        },
        submitForm(){
             this.$refs["form"].validate(valid => {
                 if(valid){
                    saveBlackList(this.form).then(res=>{
                        if(res.code==200){
                            this.$message.success(res.msg)
                            this.dialogVisible=false
                            this.getList()
                        }else{
                            this.$message.error(res.msg)
                        }
                    })
                 }
             })
        },
        addBlackList(){
            this.form={
                keywords:'',
                type:'1',
                validity:1,
                duration:'',
                reason:''
            }
            this.dialogVisible=true
        },
        revoke(row){
            this.$confirm(`确定是否要撤销?`, '提示', {
                confirmButtonText: '确定',
                cancelButtonText: '取消',
                type: 'warning'
            }).then(() => {
                 revokeBlackList(row).then(res=>{
                    if(res.code==200){
                        this.$message.success(res.msg)
                        this.getList()
                    }else{
                        this.$message.error(res.msg)
                    }
                 })
            }).catch(() => {});
        },
        phone(row){
            if(row.type==2){
                return row.keywords
            }else{
                return '--'
            }
        },
        member_id(row){
            if(row.type==1){
                return row.keywords
            }else{
                return '--'
            }
        },
        duration(row){
            if(row.validity==2){
                return '永久拉黑'
            }else{
                return `${row.duration}小时`
            }
        },
        openid(row){
             if(row.type==3){
                return row.keywords
            }else{
                return '--'
            }
        },
        validity(row){
            return row.validity==1?'限时拉黑':'永久拉黑'
        },
        query(){
          this.queryForm.pageNum = 1;
          this.getList();
        },
        reset(formName){
            this.$refs[formName].resetFields();
            this.query()
        },
    }
}
</script>

<style>

</style>