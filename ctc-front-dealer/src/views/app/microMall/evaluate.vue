<template>
  <div class="app-container">
    <el-tabs v-model="activeName" @tab-click="handleClick">
        <el-tab-pane label="未审核评价" name="0"></el-tab-pane>
        <el-tab-pane label="已审核评价" name="1"></el-tab-pane>
    </el-tabs>
       <el-table
        :data="tableData"
        :header-cell-style="{background:'#FAFAFA',color:'#606266',height:'50px'}"
        border
        stripe
        size="medium"
        class="trace-table"
        style="width: 100%">
        <el-table-column prop="goods_name" align="center" label="商品名称"></el-table-column>
        <el-table-column prop="cover" align="center" label="商品图片">
             <template slot-scope="scope">
                <img :src="scope.row.cover|cover" width="40px" height="40px">
            </template>
        </el-table-column>
        <el-table-column prop="nickname" align="center" label="评价人"></el-table-column>
        <el-table-column prop="content" align="center" label="评价内容"></el-table-column>
        <el-table-column prop="pic" align="center" label="评价图片">
            <template slot-scope="scope">
                <img :src="scope.row.pic|pic" width="40px" height="40px">
            </template>
        </el-table-column>
        <el-table-column prop="create_time" align="center" label="评价时间"></el-table-column>
        <el-table-column prop="replay_content" align="center" label="管理员回复内容" v-if="activeName=='1'"></el-table-column>
        <el-table-column prop="update_time" align="center" label="管理员回复时间" v-if="activeName=='1'"></el-table-column>
          <el-table-column label="操作" align="center" fixed="right" width="220px">
            <template slot-scope="scope">
                <el-button
                    size="mini"
                    type="primary"
                    @click="handleDele(scope.row)">删除</el-button>
                <el-button
                    size="mini"
                    v-if="activeName=='0'"
                    type="primary"
                    @click="handleReply(scope.row)">回复</el-button>
            </template>
          </el-table-column>
       </el-table>
       <pagination
        v-show="+total>10"
        :total="+total"
        :page.sync="queryForm.pageNum"
        :limit.sync="queryForm.pageSize"
        @pagination="getList"/>
        <!-- 回复 -->
        <el-dialog title="回复" class="replyDialog" :visible.sync="replyDialog" width="40%" @close="replyDialog=false">
            <el-form :model="form" ref="form" :rules="rule" label-width="100px"  size="medium">
                <el-form-item label="回复内容：" prop="replay_content">
                    <el-input
                        type="textarea"
                        :autosize="{ minRows: 3, maxRows: 5}"
                        placeholder="请输入回复内容"
                        v-model="form.replay_content">
                    </el-input>
                </el-form-item>
            </el-form>
            <div slot="footer" class="dialog-footer">
                <el-button size="medium" type="primary" @click="submit">确 定</el-button>
                <el-button size="medium" @click="replyDialog=false">取 消</el-button>
            </div>
        </el-dialog>
  </div>
</template>

<script>
import {getGoodsJudge,deleJudge,saveJudge} from '@/api/app/mall'
export default {
    data(){
        return{
            activeName:'0',
            queryForm:{
                pageNum:1,
                pageSize:10
            },
            tableData:[],
            total:0,
            form:{
                replay_content:''
            },
            replyDialog:false,
            judge_id:undefined,
            rule:{
                replay_content:[
                    { required: true, message: "回复内容不能为空", trigger: "blur" },
                    { min: 2, max: 15, message: '长度在 2 到 30 个字符', trigger: 'blur' }
                ],
            }
        }
    },
    filters:{
        cover(value){
            return value[0]['url']
        },
         pic(value){
            return value[0]['url']
        }
    },
    created(){
        this.getList()
    },
    methods:{
        getList(){
            this.queryForm.status=this.activeName
            getGoodsJudge(this.queryForm).then(res=>{
                this.tableData=res.data
                this.total=res.total
            })
        },
        handleClick(){
            this.queryForm.pageNum=1
            this.tableData=[]
            this.getList()
        },
        handleDele(row){
             this.$confirm(`确认删除该评价?`, '提示', {  
                confirmButtonText: '确定',
                cancelButtonText: '取消',
                type: 'warning'
            }).then(() => {
                 deleJudge({id:row.id}).then(res=>{
                    if(res.code==200){
                        this.$message.success(res.msg)
                        this.getList()
                    }else{
                        this.$message.error(res.msg)
                    }
                 })
            }).catch(() => {});
        },
        handleReply(row){
            this.replyDialog=true
            this.judge_id=row.id
        },
        submit(){
            this.$refs["form"].validate(valid => {
                if(valid){
                    this.form.id=this.judge_id
                   saveJudge(this.form).then(res=>{
                       if(res.code==200){
                            this.$message.success(res.msg)
                            this.replyDialog=false
                            this.getList()
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