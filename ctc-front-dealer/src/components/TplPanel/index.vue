<template>
  <div class="tpl-box">
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
                        <div class="bottom">
                            <el-button type="primary" @click="handleSelect(item)" size="mini">选择</el-button>
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
import {getTplList} from '@/api/app/trace'
export default {
    name:'TplPanel',
    props:{},
    data(){
        return{
            tabelData:[],
            total:0,
            queryForm:{
                time:[],
                template_name:'',
                pageNum:1,
                pageSize:10
            },
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
        handleSelect(item){
            this.$emit('selectTpl',item)
        }
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