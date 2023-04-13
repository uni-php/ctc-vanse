<template>
  <div class="img-box">
    <el-tabs v-model="queryForm.img_group" :tab-position="tabPosition" @tab-click="handleClick" style="height: 600px;overflow:auto">
        <el-tab-pane v-for="(item,index) in group" :key="index" :label="item.group_name" :name="String(item.id)">
            <div class="img-list">
                <ul>
                    <li v-for="(it,idx) in imgMaterialList" :key="idx" :class="{active:active(it)}" @click="handleClickImg(it,idx)">
                        <el-image
                            style="width: 150px; height: 150px"
                            :src="it.img_url"
                            fit="fill">
                        </el-image>
                    </li>
                </ul>
                <pagination
                    v-show="+total>20"
                    :total="+total"
                    :page.sync="queryForm.pageNum"
                    :limit.sync="queryForm.pageSize"
                    @pagination="getImgMaterial"
                />
            </div>
        </el-tab-pane>
    </el-tabs>
  </div>
</template>

<script>
import {getGroupList,getImgMaterial} from '@/api/assets/material'
export default {
    name:'ImgPanel',
    props:{
        count:{
            type:Number,
            default:5
        }
    },
    data(){
        return{
            tabPosition: 'left',
            queryForm:{
                pageNum:1,
                pageSize:20,
                img_group:'01',//默认查询全部图片库
                img_name:'',
            },
            queryGroupForm:{
                pageNum:1,
                pageSize:999,
                group_name:''
            },
            group:[],
            total:0,
            imgMaterialList:[],
            imgList:[]
        }
    },
    created(){
        this.getGroupList()
        this.getImgMaterial()
    },
     computed:{
        active(){
            return function (value){
               return this.imgList.map(item=>item.name).includes(value.img_name)
            }
        }
    },
    methods:{
        handleClickImg(it,idx){
            if(this.imgList.map(item=>item.name).includes(it.img_name)){
                var index=this.imgList.map(item=>item.name).indexOf(it.img_name)
                this.imgList.splice(index,1)
                this.$message.warning('禁止选择重复图片')
                return;
            }
            if(this.imgList.length>=this.count){
                this.$message.warning(`图片最多上传${this.count}张`)
                return;
            }
            this.imgList.push({
                url:it.img_url,
                name:it.img_name,
                link:''
            })
            this.$emit('selectImg',this.imgList)
        },
        getImgMaterial(){
            var params=Object.assign({},this.queryForm)
            if(params.img_group=='01') params.img_group=''
            getImgMaterial(params).then(res=>{
                this.imgMaterialList=res.data
                this.total=res.total
            })
        },
        getGroupList(){
            getGroupList(this.queryGroupForm).then(res=>{
                this.group=Object.assign([],res.data)
                this.group.unshift(
                    {
                        id:'01',
                        group_name:'全部'
                    },
                    {
                        id:0,
                        group_name:'未分组'
                    }
                )
            })
        },
        handleClick(){
            this.queryForm.pageNum=1
            this.getImgMaterial()
        },
    }
}
</script>

<style lang="scss" scoped>
.img-list{
    ul li{
        display: inline-block;
        border: 1px solid #eeeeee;
        margin:0 10px 10px 0;
        cursor: pointer;
    }
    .active{
        border: 1px solid #409EFF;
    }
    .pagination-container{
        margin-bottom: 25px;
    }
}
</style>