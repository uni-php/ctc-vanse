<template>
  <div class="app-container">
      <div class="tab-bar">
          <el-form ref="queryForm" :model="queryForm" label-width="100px" :inline="true" size="small">
            <el-form-item label="创建时间" prop="time">
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
            <el-form-item label="模板名称" prop="template_name">
                <el-input style="width:220px" v-model="queryForm.template_name" placeholder="请输入模板名称"></el-input>
            </el-form-item>
            <el-form-item > 
                <el-button type="primary" icon="el-icon-search" @click="query">查询</el-button>
                <el-button icon="el-icon-refresh" @click="reset('queryForm')">重置</el-button>
            </el-form-item> 
          </el-form>
      </div>
      <el-row>
       <el-col :span="24" style="margin:10px 0;">
        <el-button @click="addTemplate" type="primary" size="small" >创建扫码模板</el-button>
       </el-col>
      </el-row>
       <!-- 内容区域 -->
       <el-row>
            <el-col style="margin-bottom:20px" :span="4" v-for="(item, index) in tabelData" :key="index" :offset="index%5==0? 0 : 1">
                <el-card :body-style="{ padding: '0px',height:'400px',position:'relative' }">
                    <img v-if="item.banner_type==1" :src="item.activity_img[0].url" class="image">
                    <el-carousel v-if="item.banner_type==2" height="150px">
                        <el-carousel-item v-for="(it,idx) in item.banner_img" :key="idx+'banner'">
                            <el-image :src="it.url" fit="fill">
                                <div slot="error" class="image-slot">
                                    <i class="el-icon-picture-outline"></i>
                                </div>
                            </el-image>
                        </el-carousel-item>
                    </el-carousel>
                    <div class="tpl-info">
                        <div>名称：{{item.template_name}}</div>
                        <div>编号：{{item.template_code}}</div>
                        <div>创建时间：{{item.create_time}}</div>
                        <div>使用状态：{{item.num>0?'已使用':'未使用'}}</div>
                        <div class="bottom">
                            <el-button type="primary" @click="handleEdit(item)" size="mini">编辑</el-button>
                            <el-button type="danger" @click="handleDele(item)" size="mini" >删除</el-button>
                        </div>
                    </div>
                </el-card>
            </el-col>
        </el-row>
        <pagination
            v-show="+total>0"
            :total="+total"
            :page.sync="queryForm.pageNum"
            :limit.sync="queryForm.pageSize"
            @pagination="getList"/>
  </div>
</template>

<script>
import {getTplList,deleTpl} from '@/api/app/trace'
export default {
    data(){
        return{
            queryForm:{
                time:[],
                template_name:'',
                pageNum:1,
                pageSize:10
            },
            dateRange:[],
            tabelData:[],
            total:0,
            currentDate: new Date()
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
            getTplList(params).then(res=>{
                this.tabelData=res.data
                this.total=res.total
            })
        },
        handleEdit(item){
            this.$router.push({path:'/app/trace/templateDes',query:{tpl_id:item.id}})
        },
        handleDele(item){
            this.$confirm(`确定删除该模板`, '提示', {
                confirmButtonText: '确定',
                cancelButtonText: '取消',
                type: 'warning'
            }).then(() => {
                if(item.num>0){
                    this.$message.warning('该模板已被使用，无法删除')
                    return;
                }
                deleTpl({id:item.id}).then(res=>{
                    if(res.code==200){
                        this.$message.success(res.msg)
                        this.getList()
                    }else{
                        this.$message.error(res.msg)
                    }
                 })
            }).catch(() => {});
        },
        addTemplate(){
            this.$router.push({path:'/app/trace/templateDes'})
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
.time {
    font-size: 13px;
    color: #999;
  }
  
  .bottom {
    margin-top: 13px;
    line-height: 12px;
    display: flex;
    width: 100%;
    justify-content: flex-end;
  }

  .button {
    padding: 0;
    float: right;
  }

  .image {
    width: 100%;
    display: block;
  }

  .clearfix:before,
  .clearfix:after {
      display: table;
      content: "";
  }
  
  .clearfix:after {
      clear: both
  }
  .tpl-info{
      padding: 14px;
      position:absolute;
      bottom:0;
      font-size:14px;
      width: 100%;
      div{
          font-size: 14px;
          margin-bottom: 5px;
      }
  }
</style>