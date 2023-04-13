<template>
  <div class="app-container">
    <el-tabs type="border-card" v-model="activeName" @tab-click="handleClick">
        <el-tab-pane label="带参数二维码" name="first">
            <el-row>
                <el-col class="tips">
                    <p>1、带参数二维码可用于区分客户的来源，达到客户管理的目的。客户扫了带参数二维码后，会被打上设定的客户标签；同时已关注的客户会收到设定的回复；未关注的客户会先进入公众号关注页，关注后会收到设定的回复（注：带参数二维码有效期为30天）</p>
                    <p>2、通过带参数二维码打上的客户标签不会覆盖客户原有的标签。</p>
                </el-col>
            </el-row>
            <div class="tab-bar" style="margin-top:20px">
                <el-form ref="queryForm" :model="queryForm" label-width="100px" :inline="true" size="small">
                    <el-form-item label="名称" prop="qr_name">
                        <el-input style="width:240px" v-model="queryForm.qr_name" placeholder="请输入二维码名称"></el-input>
                    </el-form-item>
                     <el-form-item label="分类" prop="qr_type">
                        <el-select style="width:240px" v-model="queryForm.qr_type" placeholder="请选择二维码分类">
                            <el-option
                            v-for="item in typeTableData"
                            :key="item.id"
                            :label="item.type_name"
                            :value="item.id">
                            </el-option>
                        </el-select>
                    </el-form-item>
                    <el-form-item label="状态" prop="status">
                        <el-select style="width:240px" v-model="queryForm.status" placeholder="请选择二维码状态">
                            <el-option
                            v-for="item in statusOptions"
                            :key="item.value"
                            :label="item.label"
                            :value="item.value">
                            </el-option>
                        </el-select>
                    </el-form-item>
                    <el-form-item > 
                        <el-button type="primary" icon="el-icon-search" @click="query">查询</el-button>
                        <el-button icon="el-icon-refresh" @click="resetQuery('queryForm')">重置</el-button>
                    </el-form-item>
                </el-form>
            </div>
            <el-col :span="24" style="margin:10px 0;">
                <el-button @click="addQrcode" type="primary" size="small" >新建二维码</el-button>
            </el-col>
            <el-table
                :data="tableData"
                :header-cell-style="{background:'#FAFAFA',color:'#606266',height:'50px'}"
                border
                stripe
                size="medium"
                class="trace-table"
                style="width: 100%">
                <el-table-column prop="id" align="center" label="编号" width="80px"></el-table-column>
                <el-table-column prop="qr_name" align="center" label="名称"></el-table-column>
                <el-table-column prop="type_name" align="center" label="分类"></el-table-column>
                <el-table-column prop="status" align="center" label="状态">
                    <template slot-scope="scope">
                        {{scope.row.status==0?'未启用':scope.row.status==1?'已启用':'已禁用'}}
                    </template>
                </el-table-column>
                <el-table-column prop="valid_time" align="center" label="有效期" width="100px"></el-table-column>
                <el-table-column prop="create_time" align="center" label="创建时间"></el-table-column>
                <el-table-column label="操作" align="center" fixed="right" width="280px">
                    <template slot-scope="scope">
                        <el-button
                            size="mini"
                            type="primary"
                            @click="handleEdit(scope.row)">修改</el-button>
                            <el-button
                            size="mini"
                            v-show="scope.row.status==1"
                            type="primary"
                            @click="handleDown(scope.row)">下载</el-button>
                            <el-button
                            size="mini"
                            type="danger"
                            v-show="scope.row.status==1"
                            @click="handleAble(scope.row)">禁用</el-button>
                            <el-button
                            size="mini"
                            v-show="scope.row.status==0||scope.row.status==2"
                            type="primary"
                            @click="handleAble(scope.row)">启用</el-button>
                            <el-button
                            size="mini"
                            type="primary"
                            @click="handleDele(scope.row)">删除</el-button>
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
            <!-- 添加二维码 -->
            <el-dialog :title="codeTitle" :visible.sync="codeOpen" width="40%" @close="codeOpen=false">
                <el-form :model="codeForm" ref="codeForm" label-width="120px" :rules="codeRule" size="medium">
                    <el-form-item label="二维码名称：" prop="qr_name">
                        <el-input style="width:90%"  v-model="codeForm.qr_name" placeholder="请输入二维码名称"/>
                    </el-form-item>
                    <el-form-item label="分类：" prop="qr_type">
                        <el-select style="width:90%" v-model="codeForm.qr_type" placeholder="请选择二维码分类">
                            <el-option
                            v-for="item in typeTableData"
                            :key="item.id"
                            :label="item.type_name"
                            :value="item.id">
                            </el-option>
                        </el-select>
                    </el-form-item>
                    <el-form-item label="自动回复：" prop="reply">
                        <el-input style="width:90%" type="textarea"  v-model="codeForm.reply" placeholder="请输入自动回复"/>
                    </el-form-item>
                    <el-form-item label="有效期：" prop="valid_time">
                        <el-input style="width:90%" readonly=""  v-model="codeForm.valid_time" placeholder="有效期"/>
                    </el-form-item>
                    <el-form-item label="标签：" prop="tags">
                        <el-checkbox-group v-model="codeForm.tags">
                            <el-checkbox v-for="(item,index) in tags" :key="index" :label="item.id" :name="item.name">{{item.name}}</el-checkbox>
                        </el-checkbox-group>
                    </el-form-item>
                </el-form>
                <div slot="footer" class="dialog-footer">
                    <el-button type="primary" @click="submitCodeForm">确 定</el-button>
                    <el-button @click="codeOpen=false">取 消</el-button>
                </div>
            </el-dialog>
        </el-tab-pane>
        <el-tab-pane label="分类管理" name="second">
            <el-col :span="24" style="margin:10px 0;">
                <el-button @click="addQrcodeType" type="primary" size="small" >添加分组</el-button>
            </el-col>
            <el-table
                :data="typeTableData"
                :header-cell-style="{background:'#FAFAFA',color:'#606266',height:'50px'}"
                border
                stripe
                size="medium"
                class="trace-table"
                style="width: 100%">
                <el-table-column prop="type_name" align="center" label="分组名称"></el-table-column>
                <el-table-column prop="create_time" align="center" label="创建时间"></el-table-column>
                <el-table-column label="操作" align="center" fixed="right" width="240px">
                    <template slot-scope="scope">
                        <el-button
                            size="mini"
                            type="primary"
                            @click="handleEditType(scope.row)">修改</el-button>
                        <el-button
                            size="mini"
                            type="danger"
                            @click="handleDel(scope.row)">删除</el-button>
                    </template>
                </el-table-column>
            </el-table>
            <pagination
                v-show="+totals>10"
                :total="+totals"
                :page.sync="queryForms.pageNum"
                :limit.sync="queryForms.pageSize"
                @pagination="getType"
            />
            <!-- 添加分组 -->
            <el-dialog :title="groupTitle" :visible.sync="groupOpen" width="30%" @close="groupOpen=false">
                <el-form :model="groupForm" ref="groupForm" label-width="80px" :rules="groupRule" size="medium">
                    <el-form-item label="分组名称" prop="type_name">
                        <el-input style="width:90%"  v-model="groupForm.type_name" placeholder="请输入分组名称"/>
                    </el-form-item>
                </el-form>
                <div slot="footer" class="dialog-footer">
                    <el-button type="primary" @click="submitGroupForm">确 定</el-button>
                    <el-button @click="groupOpen=false">取 消</el-button>
                </div>
            </el-dialog>
        </el-tab-pane>
    </el-tabs>
  </div>
</template>

<script>
import {
    getQRCodeList,
    saveQRCode,
    queryQRCode,
    getUserTags,
    deleQRCode,
    getQRCodeType,
    changeQRcodeStatus,
    saveQRCodeGroup,
    queryQRCodeGroup,
    deleQRCodeGroup} from '@/api/access/officialAccount/qrcode'
export default {
    data(){
        return{
            activeName:'first',
            queryForm:{
                qr_name:'',
                qr_type:'',
                status:'',
                pageNum:1,
                pageSize:10
            },
            groupForm:{
                type_name:''
            },
            groupTitle:'',
            groupOpen:false,
            queryForms:{
                pageNum:1,
                pageSize:10
            },
            total:0,
            totals:0,
            codeForm:{
                qr_name:'',
                qr_type:'',
                reply:'',
                valid_time:30,
                tags:[]
            },
            codeOpen:false,
            codeTitle:'',
            statusOptions:[
                {
                    label:'禁用',
                    value:2
                },
                {
                    label:'启用',
                    value:1
                },
                {
                    label:'已过期',
                    value:3
                }
            ],
            tableData:[],
            typeTableData:[],
            tags:[],
            codeRule:{
                qr_name:[
                    { required: true, message: "二维码名称不能为空", trigger: "blur" },
                ],
                qr_type:[
                    { required: true, message: "二维码分类不能为空", trigger: "blur" },
                ],
                reply:[
                    { required: true, message: "自动回复不能为空", trigger: "blur" },
                ],
                tags:[
                    { required: true, message: "二维码标签不能为空", trigger: "blur" },
                ],
            },
            groupRule:{
                type_name:[
                    { required: true, message: "分组名称不能为空", trigger: "blur" },
                ]
            }
        }
    },
    created(){
        this.getList()
        this.getType()
        this.getUserTags()
    },
    methods:{
        getList(){
            getQRCodeList(this.queryForm).then(res=>{
                this.tableData=res.data
                this.total=res.total
            })
        },
        getType(){
            getQRCodeType(this.queryForms).then(res=>{
                this.typeTableData=res.data
                this.totals=res.total
            })
        },
        getUserTags(){
            getUserTags({}).then(res=>{
                this.tags=res.data
            })
        },
        query(){
            this.queryForm.pageNum = 1;
            this.getList();
        },
        addQrcode(){
            this.codeTitle='新建二维码'
            this.codeOpen=true
            this.codeForm={
                qr_name:'',
                qr_type:'',
                reply:'',
                valid_time:30,
                tags:[]
            }
            this.resetForm("codeForm");
        },
        addQrcodeType(){
            this.groupTitl='添加分组'
            this.groupOpen=true
            this.groupForm={
                type_name:'',
                id:undefined
            }
        },
        resetQuery(formName){
            this.$refs[formName].resetFields();
            this.query()
        },
        handleDele(row){
            this.$confirm(`确认删除${row.qr_name}二维码?`, '提示', {
                confirmButtonText: '确定',
                cancelButtonText: '取消',
                type: 'warning'
            }).then(() => {
                 deleQRCode({id:row.id}).then(res=>{
                    if(res.code==200){
                        this.$message.success(res.msg)
                        this.getList()
                    }else{
                        this.$message.error(res.msg)
                    }
                 })
            }).catch(() => {});
        },
        handleDel(row){
            this.$confirm('确认删除该分组?', '提示', {
                confirmButtonText: '确定',
                cancelButtonText: '取消',
                type: 'warning'
            }).then(() => {
                 deleQRCodeGroup({id:row.id}).then(res=>{
                     if(res.code==200){
                        this.$message.success(res.msg)
                        this.getType()
                    }else{
                        this.$message.error(res.msg)
                    }
                 })
            }).catch(() => {});
        },
        handleEdit(row){
            queryQRCode({id:row.id}).then(res=>{
                this.codeOpen=true
                this.codeTitle='新建二维码'
                var arr=Object.assign({},res.data)
                arr.tags=arr.tags.split(',').map(Number)
                this.codeForm=arr
            })
        },
        handleEditType(row){
            queryQRCodeGroup({id:row.id}).then(res=>{
                this.groupOpen=true
                this.groupForm=res.data
            })
        },
        handleAble(row){
            var text=row.status==0?'启用':row.status==1?'禁用':'启用'
            var status=row.status==0?1:row.status==1?'2':1
            this.$confirm('确认要"' + text + '""' + row.qr_name + '"二维码吗?', "警告", {
                confirmButtonText: "确定",
                cancelButtonText: "取消",
            type: "warning"
            }).then(function() {
                return changeQRcodeStatus({id:row.id, status:status});
            }).then(() => {
                this.$message.success(text + "成功")
                this.getList()
            }).catch(function() {
            });
        },
        submitCodeForm(){
            this.$refs["codeForm"].validate(valid => {
                if(valid){
                    var arr=Object.assign({},this.codeForm)
                    arr.tags=arr.tags.join(',')
                    saveQRCode(arr).then(res=>{
                        if(res.code==200){
                            this.$message.success(res.msg)
                            this.codeOpen=false
                            this.getList()
                        }else{
                            this.$message.error(res.msg)
                        }
                    })
                }
            })
        },
        submitGroupForm(){
            this.$refs["groupForm"].validate(valid => {
                if(valid){
                    saveQRCodeGroup(this.groupForm).then(res=>{
                        if(res.code==200){
                            this.$message.success(res.msg)
                            this.groupOpen=false
                            this.getType()
                        }else{
                            this.$message.error(res.msg)
                        }
                    })
                }
            })
        },
        handleDown(row){
           window.open(row.url)
        },
        handleClick(){}
    }
}
</script>

<style lang="scss" scoped>
.tips{
    p{
        font-size: 14px;
    }
}
</style>