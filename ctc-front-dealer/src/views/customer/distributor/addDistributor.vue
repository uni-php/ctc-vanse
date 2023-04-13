<template>
  <div class="app-container">
    <el-form :model="form" ref="form" label-width="140px" :rules="rule" size="medium">
        <el-form-item prop="distributor_code" label="经销商编号" >
            <el-input style="width:80%" :readonly="form.id?true:false" v-model="form.distributor_code" placeholder="请输入经销商编号"></el-input>
        </el-form-item>
        <el-form-item prop="distributor_name" label="经销商名称" >
            <el-input style="width:80%" v-model="form.distributor_name" placeholder="请输入经销商名称"></el-input>
        </el-form-item>
        <el-form-item label="经销商地址" prop="address">
            <el-cascader
                size="medium"
                style="width:80%"
                :options="options"
                placeholder="请选择地址"
                v-model="selectedOptions"
                @change="handleChange">
            </el-cascader>
        </el-form-item>
        <el-form-item label="详细地址" prop="address">
            <el-input style="width:80%" v-model="form.address" placeholder="请输入详细地址"/>
        </el-form-item>
        <el-form-item label="销售区域" prop="sale_address">
            <el-cascader
                size="medium"
                style="width:80%"
                :options="options"
                placeholder="请选择地址"
                v-model="selectedOption"
                @change="handleChangeSale">
            </el-cascader>
            <el-button style="margin-left:10px" type="primary" size="medium" @click="handleSelectSaleArea">添加</el-button>
        </el-form-item>
        <el-form-item label="已选区域" prop="sale_address">
            <div v-if="select_sale_address.length>0">
                <el-tag style="margin-right:10px" size="small" :closable="form.id?true:false"  @close="handleClose(item)" v-for="(item,index) of select_sale_address" :key="index">{{item+'  '}}</el-tag>
            </div>
            <div v-else>
                <span>暂无</span>
            </div>
        </el-form-item>
        <el-form-item label="经销商级别" prop="distributor_level">
            <el-select style="width:80%" size="small" v-model="form.distributor_level" @change="handleChangeLevel" placeholder="请选择经销商级别">
                <el-option
                    v-for="item in levelOption"
                    :key="item.id"
                    :label="item.level_name"
                    :value="item.id">
                </el-option>
            </el-select>
        </el-form-item>
        <el-form-item label="上级经销商" prop="superior_dis_name">
            <el-input style="width:80%"  v-model="form.superior_dis_name" @focus="getSuperiorDis" placeholder="请选择上级经销商"/>
        </el-form-item>
        <el-form-item label="手机号码（账号）" prop="phone">
            <el-input style="width:80%"  v-model="form.phone" placeholder="请输入手机账号"/>
        </el-form-item>
        <el-form-item label="密码" prop="password">
            <el-input style="width:80%"  v-model="form.password" placeholder="请输入密码"/>
        </el-form-item>
        <el-form-item label="负责人姓名" prop="person">
            <el-input style="width:80%"  v-model="form.person" placeholder="请输入负责人姓名"/>
        </el-form-item>
        <el-form-item label="所属区域" prop="zone">
            <el-cascader
                style="width:80%" 
                v-model="form.zone"
                :options="zoneOptions"
                :props="zoneProps"
                @change="handleChangeZone"></el-cascader>
        </el-form-item>
        <el-collapse v-model="activeNames">
            <el-collapse-item title="拓展信息" name="1">
                <el-form-item label="电话" prop="telephone">
                    <el-input style="width:80%"  v-model="form.telephone" placeholder="请输入电话"/>
                </el-form-item>
                <el-form-item label="微信号" prop="wechat">
                    <el-input style="width:80%"  v-model="form.wechat" placeholder="请输入微信号"/>
                </el-form-item>
                <el-form-item label="QQ" prop="qq">
                    <el-input style="width:80%"  v-model="form.qq" placeholder="请输入QQ"/>
                </el-form-item>
                <el-form-item label="邮箱" prop="email">
                    <el-input style="width:80%"  v-model="form.email" placeholder="请输入邮箱"/>
                </el-form-item>
                <el-form-item label="专卖信息" prop="monopoly">
                    <el-input style="width:80%"  v-model="form.monopoly" placeholder="请输入专卖信息"/>
                </el-form-item>
                <el-form-item label="简介" prop="introduce">
                    <el-input style="width:80%" type="textarea" :autosize="{ minRows: 3, maxRows: 5}" v-model="form.introduce" placeholder="请输入简介"/>
                </el-form-item>
            </el-collapse-item>
        </el-collapse>
        <el-form-item style="margin-top:20px">
            <el-button  type="primary" @click="onSubmit">保存</el-button>
        </el-form-item>
    </el-form>
     <!-- 上级经销商列表 -->
    <el-dialog title="上级经销商" :visible.sync="superiorDisVisible" width="50%" @close="superiorDisVisible=false">
        <div class="tab-bar">
            <el-form ref="querySuperiorDisForm" :model="querySuperiorDisForm" label-width="100px" :inline="true" size="small">
                <el-form-item label="经销商名称" prop="distributor_name">
                    <el-input style="width:220px" v-model="querySuperiorDisForm.distributor_name" placeholder="请输入经销商名称"></el-input>
                </el-form-item>
                <el-form-item > 
                    <el-button type="primary" icon="el-icon-search" @click="querySuperiorDis">查询</el-button>
                    <el-button type="primary" @click="handleSelectMain">选择总部</el-button>
                </el-form-item>
            </el-form>
        </div>
        <el-table
            :data="superiorDis"
            :header-cell-style="{background:'#FAFAFA',color:'#606266',height:'50px'}"
            border
            stripe
            size="medium"
            class="trace-table"
            style="width: 100%">
            <el-table-column prop="distributor_code" align="center" label="经销商编号"></el-table-column>
            <el-table-column prop="distributor_name" align="center" label="经销商名称"></el-table-column>
            <el-table-column prop="distributor_level" align="center" label="经销商级别" :formatter="level"></el-table-column>
            <el-table-column prop="phone" align="center" label="手机号码"></el-table-column>
            <el-table-column prop="create_time" align="center" label="添加时间"></el-table-column>
            <el-table-column label="操作" align="center" fixed="right" width="150px">
                <template slot-scope="scope">
                    <el-button
                        size="mini"
                        type="primary"
                        @click="handleSelect(scope.row)">选择</el-button>
                </template>
            </el-table-column>
        </el-table>
        <pagination
        v-show="+total>10"
        :total="+total"
        :page.sync="querySuperiorDisForm.pageNum"
        :limit.sync="querySuperiorDisForm.pageSize"
        @pagination="getSuperiorDis"/>
    </el-dialog>
  </div>
</template>

<script>
import { regionDataPlus,CodeToText, TextToCode } from 'element-china-area-data'
import {getDistributorLevelList,saveDistributor,getDistributorInfo,getSuperiorDistributorList} from '@/api/customer/distributor'
import{getCustomerAreaList} from '@/api/customer/basics'
export default {
    data(){
        return{
            form:{
                distributor_code:'',
                distributor_name:'',
                address:'',
                distributor_level:'',
                superior_dis_name:'',//上级经销商
                superior_dis_id:undefined,
                phone:'',
                password:'',
                person:'',
                telephone:'',
                wechat:'',
                qq:'',
                email:'',
                monopoly:'',
                introduce:'',
                zone:[],
                id:undefined
            },
            rule:{
                distributor_code:[
                    {required: true, message: "请输入经销商编号", trigger: "blur" },
                ],
                distributor_name:[
                    {required: true, message: "请输入经销商名称", trigger: "blur" },
                ],
                distributor_level:[
                    {required: true, message: "请选择经销商级别", trigger: "blur" },
                ],
                superior_dis_name:[
                     {required: true, message: "请选择上级经销商", trigger: "blur" },
                ],
                phone:[
                    {required: true, message: "请输入手机号码", trigger: "blur" },
                ],
                password:[
                    {required: true, message: "请输入密码", trigger: "blur" },
                ],
                person:[
                    {required: true, message: "请输入负责人名称", trigger: "blur" },
                ],
            },
            zoneProps:{
                label:'area_name',
                value:'id',
                checkStrictly:true
            },
            querySuperiorDisForm:{
                distributor_name:'',
                level_id:'',
                pageNum:1,
                pageSize:10
            },
            total:0,
            superiorDisVisible:false,
            distributor_id:undefined,
            superiorDis:[],
            zoneOptions:[],//自定义划分区域
            activeNames:['1'],
            levelOption:[],
            selectedOptions:["","",""],//经销商地址
            selectedOption:[],//销售区域
            options: regionDataPlus,
            select_sale_address:[],//已选区域
        }
    },
    created(){
        this.getDisLevel()
        this.getZoneList()
        if(this.$route.query.distributor_id){
            this.distributor_id=this.$route.query.distributor_id
            this.getDistributorInfo()
        }
    },
    methods:{
        getDisLevel(){
            getDistributorLevelList({}).then(res=>{
                this.levelOption=res.data
            })
        },
        getZoneList(){
            getCustomerAreaList({}).then(res=>{
                this.zoneOptions=this.setTreeLevel(this.handleTree(res.data, "id"),1);
            })
        },
        getDistributorInfo(){
            getDistributorInfo({id:this.distributor_id}).then(res=>{
                var arr=Object.assign({},res.data)
                this.form=res.data
                if(this.form.zone){
                    this.form.zone=this.form.zone.split(',').map(Number)
                }
                this.select_sale_address=JSON.parse(this.form.sale_area)
                var address=[]
                address[0]=TextToCode[arr.province].code
                address[1]=TextToCode[arr.province][arr.city].code
                address[2]=TextToCode[arr.province][arr.city][arr.district].code
                this.selectedOptions=address
            })
        },
        getSuperiorDis(){
            if(!this.form.distributor_level){
                this.$message.warning('请先选择经销商级别')
                return;
            }
            this.querySuperiorDisForm.level_id=this.form.distributor_level
            getSuperiorDistributorList(this.querySuperiorDisForm).then(res=>{
                this.superiorDisVisible=true
                this.superiorDis=res.data
                this.total=res.total
            })
        },
        handleClose(tag) {
            this.select_sale_address.splice(this.select_sale_address.indexOf(tag), 1);
        },
        handleChangeLevel(){
            this.form.superior_dis_name=''
            this.form.superior_dis_id=undefined
        },
        handleChange (value) {
        },
        handleChangeSale(value){

        },
        handleChangeZone(val){

        },
        level(row){
            return this.levelOption.filter(item=>item.id==row.distributor_level).map(item=>item.level_name)[0]
        },
        handleSelectMain(){
            this.form.superior_dis_id=0
            this.form.superior_dis_name='总部'
            this.superiorDisVisible=false
        },
        handleSelect(row){
            this.form.superior_dis_name=row.distributor_name
            this.form.superior_dis_id=row.id
            this.superiorDisVisible=false
        },
        onSubmit(){
            this.$refs["form"].validate(valid => {
                if(valid){
                    if(this.selectedOptions.length==0){
                        this.$message.warning('请输入经销商地址')
                        return
                    }
                    if(this.select_sale_address.length==0){
                        this.$message.warning('请输入销售区域')
                        return
                    }
                    //经销商地址
                    var arr=Object.assign({},this.form)
                    arr.province=CodeToText[this.selectedOptions[0]]
                    arr.city=CodeToText[this.selectedOptions[1]]
                    arr.district=CodeToText[this.selectedOptions[2]]
                    //经销商销售区域
                    arr.sale_area=JSON.stringify(this.select_sale_address);
                    //经销商所属区域
                    if(arr.zone){
                        arr.zone=arr.zone.join(',')
                    }
                    saveDistributor(arr).then(res=>{
                        if(res.code==200){
                            this.$message.success(res.msg)
                            this.close();
                        }else{
                            this.$message.error(res.msg)
                        }
                    })
                }
            })
        },
        querySuperiorDis(){
            this.querySuperiorDisForm.pageNum = 1;
            this.getSuperiorDis();
        },
         /** 关闭按钮 */
        close() {
            this.$store.dispatch("tagsView/delView", this.$route);
            this.$router.go(-1)
        },
        handleSelectSaleArea(){
            var address=''
            var province=CodeToText[this.selectedOption[0]]
            var city=CodeToText[this.selectedOption[1]]
            var district=CodeToText[this.selectedOption[2]]
            address=`${province}-${city}-${district}`
            var arr=this.select_sale_address.filter(item=>address.indexOf(item)>-1)
            if(arr.length>0){
                this.$message.warning('亲，销售不能重复或重叠，请重新选择')
                return;
            }
            this.select_sale_address.push(address)
        }
    }
}
</script>

<style lang="scss" scoped>
.app-container{
    ::v-deep .el-collapse-item__header{
        background: #eeeeee;
        padding: 0 10px;
        margin: 10px 0;
    }
}
</style>