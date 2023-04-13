<template>
  <div class="app-container">
      <div class="tab-bar">
          <el-form ref="queryForm" :model="queryForm" label-width="100px" :inline="true" size="small">
               <el-form-item label="领奖时间" prop="time">
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
            <el-form-item label="二维码编号" prop="code">
                <el-input style="width:220px" v-model="queryForm.code" placeholder="请输入二维码编号"></el-input>
            </el-form-item>
            <el-form-item label="生码批次号" prop="code_batch">
                <el-select style="width:220px" v-model="queryForm.code_batch" placeholder="请选择生码批次">
                    <el-option
                        v-for="item in codeBatchOptions"
                        :key="item.id"
                        :label="item.batch+'--'+'('+item.order_begin+'~'+item.order_end+')'"
                        :value="item.batch">
                    </el-option>
                </el-select>
            </el-form-item>
            <el-form-item label="OPENID" prop="openid">
                <el-input style="width:220px" v-model="queryForm.openid" placeholder="请输入会员openid"></el-input>
            </el-form-item>
            <el-form-item label="手机号码" prop="phone">
                <el-input style="width:220px" v-model="queryForm.phone" placeholder="请输入收集号码"></el-input>
            </el-form-item>
            <el-form-item label="导购员" prop="name">
                <el-input style="width:220px" v-model="queryForm.name" placeholder="请输入导购姓名"></el-input>
            </el-form-item>
            <el-form-item label="活动主题" prop="activity_name">
                <el-input style="width:220px" v-model="queryForm.activity_name" placeholder="请输入活动主题"></el-input>
            </el-form-item>
            <el-form-item label="奖项" prop="prize_type">
                <el-select style="width:220px" v-model="queryForm.prize_type" placeholder="请选择奖项类型">
                    <el-option
                        v-for="item in prizeTypeOptions"
                        :key="item.value"
                        :label="item.label"
                        :value="item.value">
                    </el-option>
                </el-select>
            </el-form-item>
            <el-form-item label="导购分组" prop="group">
                <el-select style="width:220px" v-model="queryForm.group" placeholder="请选择导购分组">
                    <el-option
                        v-for="item in groupOption"
                        :key="item.id"
                        :label="item.group_name"
                        :value="item.id">
                    </el-option>
                </el-select>
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
        <el-table-column prop="uid" width="80" align="center" label="用户ID"></el-table-column>
        <el-table-column prop="name" show-overflow-tooltip="" align="center" label="导购员"></el-table-column>
        <el-table-column prop="headimgurl" width="80" align="center" label="头像">
            <template slot-scope="scope">
                <el-avatar :size="35" :src="scope.row.headimgurl">
                    <img src="https://cube.elemecdn.com/e/fd/0fc7d20532fdaf769a25683617711png.png"/>
                </el-avatar>
            </template>
        </el-table-column>
        <el-table-column prop="code" align="center" label="二维码编号"></el-table-column>
        <el-table-column prop="batch" align="center" label="数码批次"></el-table-column>
        <el-table-column prop="activity_name" align="center" label="活动主题"></el-table-column>
        <el-table-column prop="prize_name" align="center" label="奖项名称"></el-table-column>
        <el-table-column prop="prize_content" align="center" label="奖项内容"></el-table-column>
        <el-table-column prop="create_time" align="center" label="领奖时间"></el-table-column>
         <el-table-column prop="remark" align="center" label="活动备注">
            <template slot-scope="scope">
                {{scope.row.remark||'--'}}
            </template>
        </el-table-column>
        <el-table-column prop="address" align="center" label="领奖地区">
            <template slot-scope="scope">
                {{scope.row.province}}{{scope.row.city}}{{scope.row.district}}
            </template>
        </el-table-column>
        <el-table-column prop="is_user_info" align="center" label="详细信息">
            <template slot-scope="scope">
                <span class="circle" v-show="scope.row.is_user_info==1"></span>
                <span v-show="scope.row.is_user_info==0">--</span>
                <el-button
                    v-show="scope.row.is_user_info==1"
                    size="mini"
                    type="text"
                    @click="handleDes(scope.row)">详情</el-button>
            </template>
        </el-table-column>
      </el-table>
      <pagination
        v-show="+total>10"
        :total="+total"
        :page.sync="queryForm.pageNum"
        :limit.sync="queryForm.pageSize"
        @pagination="getList"/>
        <!-- 自定义表单 -->
        <el-dialog title="用户信息" :visible.sync="desDialog" width="40%" @close="desDialog=false">
            <el-descriptions title="" :column="2">
                <el-descriptions-item :key="index" v-for="(item,index) in userData" :label="item.field_name">{{item.value}}</el-descriptions-item>
            </el-descriptions>
            <div v-if="imgData.length>0" style="display:flex">
              <span>{{imgData[0]['field_name']}}：</span>
              <el-image
              :preview-src-list="[imgData[0]['value']]"
              :src="imgData[0]['value']"
              lazy
              style="width: 100px; height: 100px;margin-right:8px"
            >
              <div class="image-slot" slot="placeholder">
                加载中
                <span class="dot">...</span>
              </div>
               <div slot="error" class="image-slot">
                  暂无
                </div>
            </el-image>
            </div>
        </el-dialog>
  </div>
</template>

<script>
import {getGuideCodeBatch} from '@/api/codeStore/qrcode'
import {getPrizeLog} from '@/api/app/guide/activity'
import {getGuideGroupList} from '@/api/app/guide/group'
export default {
    data(){
        return{
            userData:[],
            imgData:[],
            desDialog:false,
            tableData:[],
            total:0,
            queryGuideGroupForm:{
                pageNum:1,
                pageSize:999,
            },
            groupOption:[],
            prizeTypeOptions:[
                {
                    label:'红包',
                    value:1
                },
                 {
                    label:'积分',
                    value:2
                },
                 {
                    label:'礼品',
                    value:3
                }
            ],
            codeBatchOptions:[],
            queryForm:{
                time:[],
                code:'',
                group:'',
                code_batch:'',
                openid:'',
                phone:'',
                activity_name:'',
                name:'',
                pageNum:1,
                pageSize:10
            }
        }
    },
    created(){
        this.getGuideCodeBatch()
        this.getGuideGroupList()
        this.getList()
    },
    methods:{
        getGuideCodeBatch(){
          getGuideCodeBatch({}).then(res=>{
                this.codeBatchOptions=res.data
              })
        },
        getGuideGroupList(){
          getGuideGroupList(this.queryGuideGroupForm).then(res=>{
            this.groupOption = res.data
          })
        },
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
            getPrizeLog(params).then(res=>{
                this.tableData=res.data
                this.total=res.total
            })
        },
        handleDes(row){
            this.desDialog=true
            this.userData=row.user_info_field.filter(item=>item.type!=5)
            this.imgData = row.user_info_field.filter(item=>item.type==5)
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

<style lang="scss" scoped>
    .circle{
        width: 10px;
        height: 10px;
        background: green;
        border-radius: 5px;
        margin-right: 5px;
        display: inline-block;
    }
</style>
