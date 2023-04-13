<template>
  <div class="tpl-box">
      <div style="width:100%;position:relative">
        <el-row  :gutter="20">
            <el-col :span="4" v-for="(item,index) in tableData" :key="index">
                <div class="item-box">
                    <div class="item-box-top">
                        <img :src="cover(item)">
                    </div>
                    <div class="item-box-bottom">
                        <div class="tpl-name">
                            模板名称：{{item.tpl_name}}
                        </div>
                        <div class="create-by">创建人：{{item.create_by}}</div>
                        <div class="bth">
                            <el-button size="mini" @click="handleSelectTpl(item)" type="primary">选择</el-button>
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
  </div>
</template>

<script>
import {getTplList} from '@/api/app/guide/activity'
export default {
    name:'GuideTpl',
    props:{},
    data(){
        return{
            tableData:[],
            total:0,
            queryForm:{
                time:[],
                tpl_name:'',
                pageNum:1,
                pageSize:10
            },
        }
    },
    created(){
        this.getList()
    },
    methods:{
        cover(item){
            if(item.type==1){
                return item.welcom_page[0]['cover']
            }
        },
        handleSelectTpl(row){
            this.$emit('selectTpl',row)
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
            getTplList(params).then(res=>{
                this.tableData=res.data
                this.total=res.total
            })
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
