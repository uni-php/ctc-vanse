<template>
  <div class="app-container">
    <el-col :span="24" style="margin:10px 0;">
        <el-button @click="handleAddTpl" type="primary" size="small" >新增运费模板</el-button>
    </el-col>
    <el-table
      :data="tableData"
      :header-cell-style="{background:'#FAFAFA',color:'#606266',height:'50px'}"
      border
      stripe
      size="medium"
      class="trace-table"
      style="width: 100%">
        <el-table-column prop="tpl_name" align="center" label="模板名称" ></el-table-column>
        <el-table-column prop="create_time" align="center" label="创建时间" ></el-table-column>
        <el-table-column label="操作" align="center" fixed="right" width="240px">
            <template slot-scope="scope">
                <el-button
                    size="mini"
                    type="primary"
                    @click="handleEditTpl(scope.row)">修改</el-button>
                    <el-button
                    size="mini"
                    type="danger"
                    @click="handleDeleTpl(scope.row)">删除</el-button>
            </template>
        </el-table-column>
    </el-table>
    <pagination
        v-show="+total>10"
        :total="+total"
        :page.sync="queryParams.pageNum"
        :limit.sync="queryParams.pageSize"
        @pagination="getList"
     />
     <!-- 新增弹窗 -->
    <el-dialog :title="title" :visible.sync="tplDialog" width="50%" @close="tplDialog=false">
        <el-form :model="form" ref="form" label-width="100px" :rules="rule" size="medium">
            <el-form-item label="模板名称:" prop="tpl_name">
                <el-input style="width:30%" v-model="form.tpl_name" placeholder="请输入模板名称"/>
            </el-form-item>
            <el-row class="rule">
                <el-col :span="6">
                    <el-form-item label="计价方式:" prop="tpl_type">
                        <span>按重量</span>
                    </el-form-item>
                </el-col>
                <el-col :span="6">
                    <el-form-item label="运送方式:" prop="tpl_type">
                        <span>按快递</span>
                    </el-form-item>
                </el-col>
            </el-row>
            <el-row>
                <el-col :span="24" style="display:flex;justify-content: flex-end;margin:10px 0;">
                    <el-button @click="handleAddArea" type="primary" size="small" >添加区域</el-button>
                </el-col>
            </el-row>
            <el-row class="form-title">
                <el-col :span="10" class="form-item">
                    配送区域
                </el-col>
                <el-col :span="10" class="form-item">
                    <div class="item">首重(kg)</div>
                    <div class="item">运费(元)</div>
                    <div class="item">续重(kg)</div>
                    <div class="item">续费(元)</div>
                </el-col>
                <el-col :span="4" class="form-item">
                    
                </el-col>
            </el-row>
            <el-row class="form-content">
                <el-col :span="10" class="content">
                    <el-checkbox v-model="form.is_default" true-label='1' false-label='0'></el-checkbox>
                    <span style="margin-left:4px" class="wrap">未指定地区默认运费(设置未指定地区的默认运费，不勾选则代表未指定地区不支持配送)</span>
                </el-col>
                <el-col :span="10" class="content">
                    <div class="item">
                        <el-form-item label="" prop="weight">
                            <el-input size="small" v-model="form.weight" placeholder="0.0"/>
                        </el-form-item>
                    </div>
                    <div class="item">
                        <el-form-item label="" prop="freight">
                            <el-input size="small" v-model="form.freight" placeholder="0.0"/>
                        </el-form-item>
                    </div>
                    <div class="item">
                        <el-form-item label="" prop="weights">
                            <el-input size="small" v-model="form.weights" placeholder="0.0"/>
                        </el-form-item>
                    </div>
                    <div class="item">
                        <el-form-item label="" prop="renew">
                            <el-input size="small" v-model="form.renew" placeholder="0.0"/>
                        </el-form-item>
                    </div>
                </el-col>
                <el-col :span="4" class="content" style="justify-content: center">
                    
                </el-col>
            </el-row>
            <el-row class="form-content" v-for="(item,index) in form.area" :key="index">
                <el-col :span="10" class="content">
                    {{item.province|province}}
                </el-col>
                <el-col :span="10" class="content">
                    <div class="item">
                        <el-form-item label="" prop="weight">
                            <el-input size="small" v-model="item.weight" placeholder="0.0"/>
                        </el-form-item>
                    </div>
                    <div class="item">
                        <el-form-item label="" prop="freight">
                            <el-input size="small" v-model="item.freight" placeholder="0.0"/>
                        </el-form-item>
                    </div>
                    <div class="item">
                        <el-form-item label="" prop="weights">
                            <el-input size="small" v-model="item.weights" placeholder="0.0"/>
                        </el-form-item>
                    </div>
                    <div class="item">
                        <el-form-item label="" prop="renew">
                            <el-input size="small" v-model="item.renew" placeholder="0.0"/>
                        </el-form-item>
                    </div>
                </el-col>
                <el-col :span="4" class="content" style="justify-content: center">
                    <el-button
                    size="mini"
                    type="primary"
                    @click="handleEdit(index)">修改</el-button>
                    <el-button
                    size="mini"
                    type="danger"
                    @click="handleDele(index)">删除</el-button>
                </el-col>
            </el-row>
        </el-form>
        <el-dialog
            width="50%"
            title="可配送区域"
            :visible.sync="innerVisible"
            append-to-body>
            <el-row type="flex" class="row-bg" justify="space-between">
                <el-col style="display:flex;justify-content: flex-start;align-items: center;">
                    <el-button type="text" @click="selectAll">全选</el-button>
                    <el-button type="text" @click="reset">重置</el-button>
                </el-col>
                <el-col style="display:flex;justify-content: flex-end;align-items: center;">
                    <el-button type="text" @click="handleAdd">确定</el-button>
                    <el-button type="text" @click="handleCancel" >取消</el-button>
                </el-col>
            </el-row>
            <div>
                <el-checkbox-group class="area-check" v-model="checkedCities" @change="handleCheckedCitiesChange">
                    <el-row>
                        <el-col style="" :span="6" v-for="(city,index) in options" :key="city.value">
                            <el-popover
                                placement="top-start"
                                title="市区"
                                width="500px"
                                trigger="hover"
                                >
                                <div style="width:500px">
                                    <el-checkbox-group class="area-check" v-model="city.check">
                                        <el-row>
                                            <el-col style="" :span="6" v-for="(item,id) in city.children" :key="id">
                                                <el-checkbox @change="handleChildCitiesChange($event,index,id)"  :label="item.value+''" >{{item.label}}</el-checkbox>
                                            </el-col>
                                        </el-row>
                                    </el-checkbox-group>
                                </div>
                                <el-checkbox slot="reference" :label="city.value" @change="handleCheckedCities($event,index)" >{{city.label}}</el-checkbox>
                            </el-popover>
                        </el-col>
                    </el-row>
                </el-checkbox-group>
            </div>
        </el-dialog>
        <div slot="footer" class="dialog-footer">
          <el-button type="primary" @click="submitForm">确 定</el-button>
          <el-button @click="cancel">取 消</el-button>
        </div>
    </el-dialog>
  </div>
</template>

<script>
import { regionData,CodeToText, TextToCode } from 'element-china-area-data'
import {saveFreightTpl,getTpl,deleTpl,queryTpl} from '@/api/system/sys/freight'
export default {
    data(){
        return{
            tableData:[
                {
                    tpl_name:'测试',
                    create_time:'2021-11-14',
                    id:1
                }
            ],
            queryParams:{
                pageNum:1,
                pageSize:10
            },
            index:undefined,
            is_add:undefined,
            checkedCities:[],
            form:{
                is_default:'1',
                tpl_name:'',
                weight:'',
                freight:'',
                weights:'',
                renew:'',
                area:[
                    // {
                    //     province:[],
                    //     city:[],
                    //     weight:'',
                    //     freight:'',
                    //     weights:'',
                    //     renew:''
                    // }
                ]
            },
            rule:{
                tpl_name:[
                     { required: true, message: "模板名称不能为空", trigger: "blur" },
                ]
            },
            innerVisible:false,
            tplDialog:false,
            total:0,
            title:'',
            options: regionData,
        }
    },
    filters:{
        province:function(value){
            return value.map(item=>CodeToText[item]).join('、')
        }
    },
    created(){
        this.getList()
        this.options.forEach(item => {
            item.check=[]
        });
        console.log(this.options)
    },
    methods:{
        getList(){
            getTpl(this.queryParams).then(res=>{
                this.tableData=res.data
                this.total=res.total
            })
        },
        handleAddTpl(){
            this.form={
                is_default:'1',
                tpl_name:'',
                weight:'',
                freight:'',
                weights:'',
                renew:'',
                id:undefined
            }
            this.form.area=[]
            this.tplDialog=true
            this.title='新增模板'
        },
        handleEditTpl(row){
            queryTpl({id:row.id}).then(res=>{
                this.tplDialog=true
                var arr=Object.assign({},res.data)
                arr.is_default=String(arr.is_default)
                this.form=arr
            })
        },
        handleEdit(index){
            this.is_add=false
            this.innerVisible=true
            this.options=regionData
            this.form.area[index]['city'].forEach(item=>{
                this.options.forEach(it=>{
                    if(item.value==it.value){
                        it.check=item.check
                    }
                })
            })
            this.index=index
            this.checkedCities=this.form.area[index]['province']
            console.log(this.options)
        },
        handleDele(index){
            this.form.area.splice(index,1)
        },
        selectAll(){
            this.checkedCities=this.options.map(item=>item.value)
            this.options.forEach((item,index)=>{
                item.check=this.options[index]['children'].map(it=>it.value)
            })
        },
        reset(){
            this.checkedCities=[]
            this.options.forEach((item,index)=>{
                item.check=[]
            })
        },
        handleAddArea(){
            this.reset()
            this.innerVisible=true
            this.is_add=true
        },
        handleCheckedCitiesChange(val){
            
        },
        handleCheckedCities(val,index){
            var cityValue=this.options[index]['children'].map(item=>item.value)
            if(val){
                this.$set(this.options[index],'check',cityValue)
            }else{
                this.$set(this.options[index],'check',[])
            }
        },
        handleChildCitiesChange(val,index,id){
            var city=this.options[index]['check']
            if(city.length==0){
                this.checkedCities=this.checkedCities.filter(item=>item!=this.options[index]['value'])
            }
            if(city.length>0){
                if(!this.checkedCities.includes(String(this.options[index]['value']))){
                    this.checkedCities.push(String(this.options[index]['value']))
                }
            }
            // if(city.length==this.options[index]['children'].length){
            //     this.checkedCities.push(String(this.options[index]['value']))
            // }
            this.$forceUpdate()
        },
        handleAdd(){
            if(this.checkedCities.length==0){
                this.$message.warning('请选择配送市区')
                return;
            }
            //拼接数据结构 过滤options中check长度不为零的项目
            var arr=JSON.parse(JSON.stringify(this.options))
            var city=arr.filter(item=>item.check.length>0)
            city.forEach((item,index)=>{
                delete city[index]['children']
            })
            var ob={
                province:this.checkedCities,
                city:city
            }
            if(!this.is_add){
                this.$set(this.form.area[this.index],'province',this.checkedCities)
                this.$set(this.form.area[this.index],'city',city)
            }else{
                this.form.area.push(ob)
            }
            this.innerVisible=false
            this.$forceUpdate()
        },
        submitForm(){
            this.$refs["form"].validate(valid => {
                if(valid){
                    saveFreightTpl(this.form).then(res=>{
                        if(res.code==200){
                            this.$message.success(res.msg)
                            this.tplDialog=false
                            this.getList()
                        }else{
                            this.$message.error(res.msg)
                        }
                    })
                }
            })
        },
        handleDeleTpl(row){
            this.$confirm('确认删除该模板?', '提示', {
                confirmButtonText: '确定',
                cancelButtonText: '取消',
                type: 'warning'
                }).then(() => {
                 deleTpl({id:row.id}).then(res=>{
                     if(res.code==200){
                        this.$message.success(res.msg)
                        this.getList()
                    }else{
                        this.$message.error(res.msg)
                    }
                 })
                }).catch(() => {});
        },
        cancel(){
            this.tplDialog=false
            this.resetForm("form");
            this.form.area=[]
        },
        handleCancel(){
            this.reset()
            this.innerVisible=false
        }
    }
}
</script>

<style lang="scss" scoped>
.app-container{
    ::v-deep .el-form-item__content{
        margin-left: 0 !important;
    }   
}
.form-title{
    width: 100%;
    height: 40px;
    background: #eeeeee;
    padding: 0 10px;
    color: black;
    .form-item{
        height: 100%;
        display: flex;
        justify-content: flex-start;
        align-items: center;
        border-right: 1px solid lightgray;
        &:last-child{
            border-right: 0;
        }
        .item{
            width: 25%;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100%;
        }
    }
}
.rule{
    .el-form-item{
        margin-bottom: 0;
    }
}
.form-content{
    width: 100%;
    height: 60px;
    background: white;
    padding: 0 10px;
    border-bottom: 1px solid #eeeeee;
    border-left: 1px solid #eeeeee;
    border-right: 1px solid #eeeeee;
    .content{
        display: flex;
        padding: 10px 5px;
        height: 100%;
        justify-content: flex-start;
        align-items: center;
        border-right: 1px solid lightgray;
        overflow: hidden;
        white-space: nowrap;
        text-overflow:ellipsis;
        .el-form-item{
            margin-bottom: 0;
        }
        &:last-child{
            border-right: 0;
        }
        .wrap{
            overflow: hidden;
            white-space: nowrap;
            text-overflow: ellipsis;
        }
        .item{
            width: 25%;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100%;
        }
    }
    ::v-deep .el-form-item{
        width: 60%;
    }
}
.row-bg{
    height: 40px;
    width: 100%;
    padding: 0 10px;
    background: #eeeeee;
}
.area-check{
    .el-col {
        margin-top: 20px;
    }
}
</style>