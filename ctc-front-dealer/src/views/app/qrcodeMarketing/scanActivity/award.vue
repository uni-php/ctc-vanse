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
            <el-form-item label="昵称" prop="nickname">
                <el-input style="width:220px" v-model="queryForm.nickname" placeholder="请输入会员昵称"></el-input>
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
            <el-form-item label="运营中心" prop="operation_center">
                <el-select style="width:220px" v-model="queryForm.operation_center" placeholder="请选择运营中心">
                    <el-option
                        v-for="item in operationCenterOption"
                        :key="item.dict_value"
                        :label="item.dict_label"
                        :value="item.dict_value">
                    </el-option>
                </el-select>
            </el-form-item>
             <el-form-item >
                <el-button type="primary" icon="el-icon-search" @click="query">查询</el-button>
                <el-button icon="el-icon-refresh" @click="reset('queryForm')">重置</el-button>
                <el-button :disabled="multiple" size="mini" icon="el-icon-download" @click="exportExcel">导出</el-button>
            </el-form-item>
          </el-form>
      </div>
      <el-table
        :data="tableData"
        :header-cell-style="{background:'#FAFAFA',color:'#606266',height:'50px'}"
        border
        stripe
        size="medium"
        @selection-change="handleSelectionChange"
        class="trace-table"
        style="width: 100%">
        <el-table-column type="selection" width="55" align="center" />
        <el-table-column prop="nickname" show-overflow-tooltip="" align="center" label="昵称"></el-table-column>
        <!-- <el-table-column prop="headimgurl" width="80" align="center" label="头像">
            <template slot-scope="scope">
                <el-avatar :size="35" :src="scope.row.headimgurl">
                    <img src="https://cube.elemecdn.com/e/fd/0fc7d20532fdaf769a25683617711png.png"/>
                </el-avatar>
            </template>
        </el-table-column> -->
        <el-table-column prop="name" align="center" label="施工师傅姓名"></el-table-column>
        <el-table-column prop="operation_center" align="center" label="运营中心" :formatter="operation_center"></el-table-column>
        <el-table-column prop="code" align="center" label="二维码编号"></el-table-column>
        <el-table-column prop="serial_number" align="center" label="序列号"></el-table-column>
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
import {getMarketCodeBatch} from '@/api/codeStore/qrcode'
import {getPrizeLog,exportAward} from '@/api/app/qrcode'
export default {
    data(){
        return{
            ids:[],
            multiple:true,
            userData:[],
            imgData:[],
            desDialog:false,
            tableData:[],
            total:0,
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
            operationCenterOption:[],
            codeBatchOptions:[],
            queryForm:{
              operation_center:'',
                time:[],
                code:'',
                code_batch:'',
                openid:'',
                phone:'',
                activity_name:'',
                nickname:'',
                pageNum:1,
                pageSize:10
            }
        }
    },
    created(){
        this.getMarketCodeBatch()
        this.getList()
        this.getDicts({type:'operation_center'}).then(res=>{
            this.operationCenterOption=res.data
        })
    },
    methods:{
        getMarketCodeBatch(){
            getMarketCodeBatch({}).then(res=>{
               this.codeBatchOptions=res.data
            })
        },
        operation_center(row){
          return this.operationCenterOption.filter(item=>item.dict_value==row.operation_center).map(item=>item.dict_label)[0]
        },
        exportExcel(){
            const ids=this.ids
            exportAward({ids:ids}).then(response=>{
                 let url = window.URL.createObjectURL(new Blob([response], {type: 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'}));
                // 生成一个a标签
                let link = document.createElement("a");
                link.style.display = "none";
                link.href = url;
                // 生成时间戳
                let timestamp=new Date().getTime();
                link.download = '领奖记录表';
                document.body.appendChild(link);
                link.click();
            })
        },
        handleSelectionChange(selection) {
            this.ids = selection.map(item => item.id)
            this.multiple = !selection.length
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
