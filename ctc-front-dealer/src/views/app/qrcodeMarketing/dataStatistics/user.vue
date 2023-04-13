<template>
  <div class="app-container">
    <div class="tips">
        <p>数据非实时显示，数据统计截止到前一天。</p>
    </div>
    <div class="tab-bar">
        <el-form ref="queryForm" :model="queryForm" label-width="100px" :inline="true" size="small">
            <el-form-item label="用户昵称" prop="nickname">
                <el-input style="width:220px" v-model="queryForm.nickname" placeholder="请输入用户昵称"></el-input>
            </el-form-item>
            <el-form-item label="用户手机号" prop="phone">
                <el-input style="width:220px" v-model="queryForm.phone" placeholder="请输入用户手机号"></el-input>
            </el-form-item>
            <el-form-item label="用户OPENID" prop="openid">
                <el-input style="width:220px" v-model="queryForm.openid" placeholder="请输入用户OPENID"></el-input>
            </el-form-item>
            <el-form-item >
                <el-button type="primary" icon="el-icon-search" @click="query">查询</el-button>
                <el-button icon="el-icon-refresh" @click="reset('queryForm')">重置</el-button>
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
            <el-table-column prop="id" width="80" align="center" label="用户ID"></el-table-column>
            <el-table-column prop="nickname" show-overflow-tooltip="" align="center" label="昵称"></el-table-column>
            <el-table-column prop="headimgurl" width="80" align="center" label="头像">
                <template slot-scope="scope">
                    <el-avatar :size="35" :src="scope.row.headimgurl" @error="errorHandler">
                        <img src="https://cube.elemecdn.com/e/fd/0fc7d20532fdaf769a25683617711png.png"/>
                    </el-avatar>
                </template>
            </el-table-column>
            <el-table-column prop="scan_times" align="center" label="扫码次数"></el-table-column>
            <el-table-column prop="join_times" align="center" label="活动参与次数"></el-table-column>
            <el-table-column prop="red_num" align="center" label="红包个数"></el-table-column>
            <el-table-column prop="red_money" align="center" label="红包总金额"></el-table-column>
            <el-table-column prop="points" align="center" label="积分"></el-table-column>
            <el-table-column prop="gifts" align="center" label="礼品个数"></el-table-column>
        </el-table>
        <pagination
        v-show="+total>10"
        :total="+total"
        :page.sync="queryForm.pageNum"
        :limit.sync="queryForm.pageSize"
        @pagination="getScanUser"/>
  </div>
</template>

<script>
import {getScanUser} from '@/api/app/qrcode/data'
export default {
     data(){
        return{
            objectData:[],//[{value: 2, name: '上海'}, {value:3,name: '北京'}],
            baseInfo:[],
            queryForm:{
                nickname:'',
                phone:'',
                openid:'',
                pageNum:1,
                pageSize:10
            },
            tableData:[],
            total:0
        }
    },
    created(){
        this.getScanUser()
    },
    methods:{
        getScanUser(){
           getScanUser(this.queryForm).then(res=>{
                this.tableData=res.data
                this.total=res.total
           })
       },
       query(){
          this.queryForm.pageNum = 1;
          this.getScanUser();
        },
        reset(formName){
            this.$refs[formName].resetFields();
            this.query()
        },
        errorHandler(){
            return true
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
.card-dashboard{
    margin-top: 80px;
    width: 100%;
    height: 500px;
}
</style>
