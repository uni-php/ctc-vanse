<template>
  <div class="app-container">
    <div class="tab-bar">
        <el-form ref="queryForm" :model="queryForm" label-width="100px" :inline="true" size="small">
            <el-form-item label="创建时间" prop="time">
                <el-date-picker
                    style="width:240px"
                    v-model="queryForm.time"
                    type="daterange"
                    unlink-panels=""
                    range-separator="至"
                    value-format="yyyy-MM-dd"
                    start-placeholder="开始日期"
                    end-placeholder="结束日期">
                </el-date-picker>
            </el-form-item>
            <el-form-item label="模板名称" prop="tpl_name">
                <el-input style="width:240px" v-model="queryForm.tpl_name" placeholder="请输入模板名称"></el-input>
            </el-form-item>
            <el-form-item >
                <el-button type="primary" icon="el-icon-search" @click="query">查询</el-button>
                <el-button icon="el-icon-refresh" @click="reset('queryForm')">重置</el-button>
            </el-form-item>
        </el-form>
    </div>
    <el-row>
        <el-col :span="24" style="margin:10px 0;">
            <el-button @click="addTpl" type="primary" size="small" >创建扫码模板</el-button>
        </el-col>
    </el-row>
    <!-- 模板列表 -->
    <div style="width:100%;position:relative">
        <el-row  :gutter="20">
            <el-col :span="4" v-for="(item,index) in tableData" :key="index">
                <div class="item-box">
                    <el-tooltip placement="right">
                        <div slot="content">
                            <div>编号：{{item.id}}</div>
                            <div>场景类型：{{item.scene_type}}</div>
                            <div>创建时间：{{item.create_time}}</div>
                            <div>使用状态：{{item.status}}</div>
                            <div>备注：{{item.remark}}</div>
                        </div>
                        <div class="item-box-top">
                            <img :src="cover(item)">
                        </div>
                    </el-tooltip>
                    <div class="item-box-bottom">
                        <div class="tpl-name">
                            模板名称：{{item.tpl_name}}
                        </div>
                        <div class="create-by">创建人：{{item.create_by}}</div>
                        <div class="bth">
                            <el-button size="mini" @click="editTpl(item)" type="primary">编辑</el-button>
                            <el-button size="mini"  type="danger">删除</el-button>
                        </div>
                    </div>
                </div>
            </el-col>
        </el-row>
    </div>
    <pagination
        v-show="+total>10"
        :total="+total"
        :page.sync="queryForm.pageNum"
        :limit.sync="queryForm.pageSize"
        @pagination="getList"/>
    <!-- 添加模板 -->
    <el-dialog title="选择模板" class="tplDialog" :visible.sync="tplDialog" width="50%" @close="tplDialog=false">
        <el-row :gutter="20">
            <el-col :span="12">
                <div class="com-tpl" @click="createTpl(1)">
                    <svg-icon style="width:65px;height:65px;color:#409EFF" icon-class="qrcode"></svg-icon>
                    <div class="tips">新建普通扫码模板</div>
                </div>
            </el-col>
            <el-col :span="12">
                <div class="com-tpl" @click="createTpl(2)">
                    <svg-icon style="width:70px;height:70px;color:#409EFF" icon-class="zhuanpan"></svg-icon>
                    <div class="tips">新建大转盘扫码模板</div>
                </div>
            </el-col>
        </el-row>
    </el-dialog>
  </div>
</template>

<script>
import {getTplList} from '@/api/app/guide/activity'
export default {
    data(){
        return{
            tplDialog:false,
            queryForm:{
                time:[],
                tpl_name:'',
                pageNum:1,
                pageSize:10
            },
            total:0,
            tableData:[
                // {
                //     tpl_name:'测试',
                //     create_by:'test',
                //     img_url:'http://cdn.uni-2id.com/temp-act-2.png',
                //     code:1,
                //     create_time:'1122',
                //     remark:'test',
                //     status:1,
                //     scene_type:1
                // }
            ]
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
                this.tableData=res.data
                this.total=res.total
            })
        },
        cover(item){
            if(item.type==1){
                return item.welcom_page[0]['cover']
            }
        },
        addTpl(){
            // this.tplDialog=true
            this.createTpl(1)
        },
        editTpl(item){
            this.$router.push({path:'/guide/sacnaAtivity/addTpl',query:{type:1,id:item.id}})
        },
        createTpl(val){
            this.$router.push({path:'/guide/sacnaAtivity/addTpl',query:{type:val}})
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
.item-box{
    width: 100%;
    height: 500px;
    border: 1px solid #eeeeee;
    display: flex;
    justify-content: center;
    align-items: center;
    flex-direction: column;
    margin-bottom: 20px;
    .item-box-top{
        width: 100;
        height: 80%;
        display: flex;
        justify-content: center;
        align-items: center;
        img{
            width: 100%;
            height: 100%;
        }
    }
    .item-box-bottom{
        width: 100%;
        height: 20%;
        display: flex;
        justify-content: center;
        align-items: center;
        flex-direction: column;
        .tpl-name,.create-by{
            width: 100%;
            height: auto;
            display: flex;
            justify-content: flex-start;
            padding: 5px;
            align-items: center;
        }
        .bth{
            width: 100%;
            height: auto;
            display: flex;
            justify-content: flex-end;
            align-items: center;
            padding-right: 10px;
        }
    }
    // background: red;
}
.com-tpl{
    width: 100%;
    height: 300px;
    border: 1px dashed gray;
    display: flex;
    justify-content: center;
    align-items: center;
    flex-direction: column;
    cursor: pointer;
    .tips{
        width: 100%;
        display: flex;
        justify-content: center;
        align-items: center;
        font-size: 15px;
        margin-top: 20px;
    }
}
</style>
