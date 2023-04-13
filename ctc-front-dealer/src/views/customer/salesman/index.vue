<template>
  <div class="app-container">
       <div class="tab-bar">
           <el-form ref="queryForm" :model="queryForm" label-width="100px" :inline="true" size="small">
                <el-form-item label="编号" prop="salesman_code">
                    <el-input style="width:220px" v-model="queryForm.salesman_code" placeholder="请输入业务员编号"></el-input>
                </el-form-item>
                <el-form-item label="姓名" prop="username">
                    <el-input style="width:220px" v-model="queryForm.username" placeholder="请输入业务员姓名"></el-input>
                </el-form-item>
                <el-form-item label="手机号" prop="phone">
                    <el-input style="width:220px" v-model="queryForm.phone" placeholder="请输入业务员手机号"></el-input>
                </el-form-item>
                <el-form-item label="备注" prop="remark">
                    <el-input style="width:220px" v-model="queryForm.remark" placeholder="请输入备注"></el-input>
                </el-form-item>
                <el-form-item label="状态" prop="status">
                    <el-select style="width:220px" size="small" v-model="queryForm.status" placeholder="请选择状态">
                        <el-option
                            v-for="item in statusOption"
                            :key="item.value"
                            :label="item.label"
                            :value="item.value">
                        </el-option>
                    </el-select>
                </el-form-item>
                <el-form-item label="类型" prop="type">
                    <el-select style="width:220px" size="small" v-model="queryForm.type" placeholder="请选择类型">
                        <el-option
                            v-for="item in typeOptions"
                            :key="item.id"
                            :label="item.class_name"
                            :value="item.id">
                        </el-option>
                    </el-select>
                </el-form-item>
                <el-form-item label="所属区域" prop="zone">
                    <el-cascader
                        style="width:220px" 
                        v-model="queryForm.zone"
                        :options="zoneOptions"
                        :props="zoneProps"
                        ></el-cascader>
                </el-form-item>
                <el-form-item > 
                    <el-button type="primary" icon="el-icon-search" @click="query">查询</el-button>
                    <el-button icon="el-icon-refresh" @click="reset('queryForm')">重置</el-button>
                </el-form-item>
           </el-form>
       </div>
       <el-col :span="24" style="margin:10px 0;">
            <el-button @click="addSalesman" type="primary" size="small" >添加员工</el-button>
       </el-col>
        <el-table
            :data="tableData"
            :header-cell-style="{background:'#FAFAFA',color:'#606266',height:'50px'}"
            border
            stripe
            size="medium"
            class="trace-table"
            style="width: 100%">
            <el-table-column prop="salesman_code" align="center" label="编号"></el-table-column>
            <el-table-column prop="username" align="center" label="姓名"></el-table-column>
            <el-table-column prop="phone" align="center" label="手机号"></el-table-column>
            <el-table-column prop="zone" align="center" label="管理范围" :formatter="manage_area"></el-table-column>
            <el-table-column prop="type" align="center" label="业务员类型" :formatter="type"></el-table-column>
            <el-table-column prop="remark" align="center" label="备注"></el-table-column>
            <el-table-column prop="status" align="center" label="状态" :formatter="status"></el-table-column>
            <el-table-column label="操作" align="center" fixed="right" width="260px">
                <template slot-scope="scope">
                    <el-button
                        size="mini"
                        :type="scope.row.status==0?'primary':'danger'"
                        @click="handleSetStatus(scope.row)"
                        >{{scope.row.status==0?'禁用':'启用'}}</el-button>
                    <el-button
                        size="mini"
                        type="primary"
                        @click="handleEdit(scope.row)"
                        >修改</el-button>
                    <el-button
                        size="mini"
                        type="primary"
                        @click="handleDele(scope.row)"
                        >删除</el-button>
                </template>
            </el-table-column>
        </el-table>
        <pagination
        v-show="+total>10"
        :total="+total"
        :page.sync="queryForm.pageNum"
        :limit.sync="queryForm.pageSize"
        @pagination="getList"/>
  </div>
</template>

<script>
import{getCustomerAreaList} from '@/api/customer/basics'
import {getSalesmanTypeList,getSalesmanList,deleSalesman,cutSalesman} from '@/api/customer/salesman'
export default {
    data(){
        return{
            queryForm:{
                salesman_code:'',
                username:'',
                phone:'',
                remark:'',
                status:'',
                type:'',
                zone:[],
                pageNum:1,
                pageSize:10
            },
            statusOption:[
                {
                    label:'正常',
                    value:1
                },
                {
                    label:'禁用',
                    value:2
                }
            ],
            zoneProps:{
                label:'area_name',
                value:'id',
                checkStrictly:true
            },
            queryTypeForm:{
                pageNum:1,
                pageSize:999
            },
            zoneOptions:[],
            originZoneOptions:[],
            tableData:[],
            typeOptions:[],
            total:0
        }
    },
    created(){
        this.getList()
        this.getZoneList()
        getSalesmanTypeList(this.queryTypeForm).then(res=>{
            this.typeOptions=res.data
        })
    },
    methods:{
        getList(){
            var params=Object.assign({},this.queryForm)
            params.zone=params.zone.join(',')
            getSalesmanList(params).then(res=>{
                this.tableData=res.data
                this.total=res.total
            })
        },
        getZoneList(){
            getCustomerAreaList({}).then(res=>{
                this.originZoneOptions=res.data
                this.zoneOptions=this.setTreeLevel(this.handleTree(res.data, "id"),1);
            })
        },
        manage_area(row){
            var area=row.zone.split(',').map(Number)
            var area_text=this.originZoneOptions.filter(item=>area.includes(item.id)).map(item=>item.area_name).join('-')
            return area_text
        },
        handleEdit(row){
            this.$router.push({path:'/customer/salesmanDes',query:{salesman_id:row.id}})
        },
        handleSetStatus(row){
            var text=row.status==1?'禁用':'启用'
            this.$confirm(`确定${text}该业务员`, '提示', {
                confirmButtonText: '确定',
                cancelButtonText: '取消',
                type: 'warning'
            }).then(() => {
                 cutSalesman({id:row.id,status:row.status}).then(res=>{
                    if(res.code==200){
                        this.$message.success(res.msg)
                        this.getList()
                    }else{
                        this.$message.error(res.msg)
                    }
                 })
            }).catch(() => {});
        },
        handleDele(row){
            this.$confirm(`确定删除${row.username}业务员`, '提示', {
                confirmButtonText: '确定',
                cancelButtonText: '取消',
                type: 'warning'
            }).then(() => {
                 deleSalesman({id:row.id}).then(res=>{
                    if(res.code==200){
                        this.$message.success(res.msg)
                        this.getList()
                    }else{
                        this.$message.error(res.msg)
                    }
                 })
            }).catch(() => {});
        },
        //业务员类型翻译
        type(row){
            return this.typeOptions.filter(item=>item.id==row.type).map(item=>item.class_name)[0]
        },
        status(row){
            return this.statusOption.filter(item=>item.value==row.status).map(item=>item.label)[0]
        },
        addSalesman(){
            this.$router.push({path:'/customer/salesmanDes'})
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

<style>

</style>