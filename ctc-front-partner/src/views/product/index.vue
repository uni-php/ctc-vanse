<template>
  <div class="app-container">
      <el-tabs v-model="activeName" type="card" @tab-click="handleClick">
        <el-tab-pane label="功能模块费" name="first"></el-tab-pane>
        <el-tab-pane label="码费" name="second"></el-tab-pane>
        <el-tab-pane label="服务费" name="third"></el-tab-pane>
      </el-tabs>
      <div v-show="activeName=='first'">
          <el-table
            :data="moduleData"
            :header-cell-style="{background:'#FAFAFA',color:'#606266',height:'50px'}"
            border
            stripe
            size="medium"
            class="trace-table"
            style="width: 100%">
            <el-table-column prop="module_name" align="center" label="产品模块" ></el-table-column>
            <el-table-column prop="module_cost" align="center" label="成本价/年" ></el-table-column>
            <el-table-column prop="module_retail" align="center" label="零售价/年" ></el-table-column>
            <el-table-column label="操作" align="center" fixed="right" width="200px">
              <template slot-scope="scope">
                <el-button
                  size="mini"
                  type="primary"
                  @click="setPrice(scope.row)">设置价格</el-button>
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
      </div>
      <!-- 码费 -->
      <div v-show="activeName=='second'">
          <!-- 自定义价格 -->
        <el-col :span="24" style="margin:10px 0;" >
            <el-button @click="handleAddCode" type="primary" size="small" >添加码阶梯</el-button>
        </el-col>
        <el-table
        :data="codeData"
        :header-cell-style="{background:'#FAFAFA',color:'#606266',height:'50px'}"
        border
        stripe
        size="medium"
        class="trace-table"
        style="width: 100%">
        <el-table-column prop="code_order_begin" width="600px" align="center" label="码阶梯" >
            <template slot-scope="scope">
                <span>{{scope.row.code_order_begin}}-{{scope.row.code_order_end}}</span>
            </template>
        </el-table-column>
        <el-table-column prop="code_retail" width="600px" align="center" label="单码零售价" >
            <template slot-scope="scope">
                <span>￥{{scope.row.code_retail}}</span>
            </template>
        </el-table-column>
        <el-table-column label="操作" align="center" fixed="right" >
            <template slot-scope="scope">
                <el-button
                size="mini"
                type="primary"
                @click="setCodePrice(scope.row)">设置价格</el-button>
            </template>
        </el-table-column>
        </el-table>
          <!-- 总部定价 -->
        <!-- <el-divider>总部定价<i class="el-icon-caret-bottom"></i></el-divider> -->
        <el-tag style="margin:20px 0" >总部码定价</el-tag>
        <el-table
        :data="mainCodeData"
        :header-cell-style="{background:'#FAFAFA',color:'#606266',height:'50px'}"
        border
        stripe
        size="medium"
        class="trace-table"
        style="width: 100%">
        <el-table-column prop="code_order_begin" width="600px" align="center" label="码阶梯" >
            <template slot-scope="scope">
                <span>{{scope.row.code_order_begin}}-{{scope.row.code_order_end}}</span>
            </template>
        </el-table-column>
        <el-table-column prop="code_cost" width="600px" align="center" label="单码成本价" >
            <template slot-scope="scope">
                <span>￥{{scope.row.code_cost}}</span>
            </template>
        </el-table-column>
        <el-table-column prop="code_retail" align="center" fixed="right" label="参考零售价" >
            <template slot-scope="scope">
                <span>￥{{scope.row.code_retail}}</span>
            </template>
        </el-table-column>
        </el-table>
      </div>
      <!-- 服务费用 -->
      <div v-show="activeName=='third'">
        <el-col :span="24" style="margin:10px 0;" >
            <el-button @click="handleAddService" type="primary" size="small" >添加服务等级</el-button>
        </el-col>
        <el-table
        :data="serverData"
        :header-cell-style="{background:'#FAFAFA',color:'#606266',height:'50px'}"
        border
        stripe
        size="medium"
        class="trace-table"
        style="width: 100%">
            <el-table-column prop="service_name" align="center" label="服务等级名称" ></el-table-column>
            <el-table-column prop="service_cost" align="center" label="服务费/年" ></el-table-column>
            <el-table-column prop="service_des" align="center" label="服务描述" ></el-table-column>
            <el-table-column label="操作" align="center" fixed="right" >
                <template slot-scope="scope">
                    <el-button
                    size="mini"
                    type="primary"
                    @click="handleEdit(scope.row)">修改</el-button>
                </template>
            </el-table-column>
        </el-table>
      </div>
      <!-- 设置价格 -->
      <el-dialog title="设置价格" :visible.sync="moduleDialog" width="20%" @close="moduleDialog=false">
        <el-form :model="moduleForm" ref="moduleForm" label-width="100px" :rules="rule" size="medium">
            <el-form-item :label="label" prop="retail_price">
                <el-input style="width:90%"  v-model="moduleForm.retail_price" placeholder="请输入零售价格"/>
            </el-form-item>
        </el-form>
        <div slot="footer" class="dialog-footer">
          <el-button type="primary" @click="submitForm">确 定</el-button>
          <el-button @click="cancel">取 消</el-button>
        </div>
      </el-dialog>
      <!-- 添加码阶梯 -->
      <el-dialog :title="codeTitle" :visible.sync="codeDialog" width="30%" @close="codeDialog=false">
        <el-form :model="codeForm" ref="codeForm" label-width="60px" :rules="codeRule" size="medium">
            <el-row>
                <el-col :span="12">
                    <el-form-item label="阶梯" prop="code_order_begin">
                        <el-input :readonly="codeForm.status" v-model.number="codeForm.code_order_begin" placeholder="起始序号"/>
                    </el-form-item>
                </el-col>
                <el-col :span="12">
                    <el-form-item label="" prop="code_order_end">
                        <el-input :readonly="codeForm.status" v-model.number="codeForm.code_order_end" placeholder="终止序号"/>
                    </el-form-item>
                </el-col>
            </el-row>
            <el-form-item label="价格" prop="code_retail">
                <el-input v-model.number="codeForm.code_retail" placeholder="请输入零售价" />
            </el-form-item>
        </el-form>
        <div slot="footer" class="dialog-footer">
          <el-button type="primary" @click="submitCodeForm">确 定</el-button>
          <el-button @click="cancelCode">取 消</el-button>
        </div>
      </el-dialog>
      <!-- 添加服务等级 -->
      <el-dialog :title="serTitle" :visible.sync="serDialog" width="30%" @close="serDialog=false">
        <el-form :model="serForm" ref="serForm" label-width="100px" :rules="serRule" size="medium">
            <el-form-item label="等级名称" prop="service_name">
                <el-input style="width:90%"  v-model="serForm.service_name" placeholder="请输入等级名称"/>
            </el-form-item>
            <el-form-item label="服务费/年" prop="service_cost">
                <el-input style="width:90%"  v-model.number="serForm.service_cost" placeholder="请输入年服务费"/>
            </el-form-item>
            <el-form-item label="服务描述" prop="service_des">
                <el-input style="width:90%" type="textarea" :autosize="{ minRows: 3, maxRows: 5}" v-model="serForm.service_des" placeholder="请输入服务描述"/>
            </el-form-item>
        </el-form>
        <div slot="footer" class="dialog-footer">
          <el-button type="primary" @click="submitSerForm">确 定</el-button>
          <el-button @click="cancelSer">取 消</el-button>
        </div>
      </el-dialog>
  </div>
</template>

<script>
import {getModule,setModulePrice,getCodeList,addCodePrice,getServer,addServer} from '@/api/product'
export default {
    data(){
        return{
            activeName:'first',
            moduleData:[],
            serverData:[],
            codeData:[],
            mainCodeData:[],
            total:0,
            codeTitle:'',
            serTitle:'',
            moduleDialog:false,
            codeDialog:false,
            serDialog:false,
            codeForm:{
                code_order_begin:undefined,
                code_order_end:undefined,
                code_retail:undefined,
                status:undefined,
                id:undefined
            },
            serForm:{
                service_name:'',
                service_cost:'',
                service_des:'',
                id:undefined
            },
            moduleForm:{
                retail_price:'',
                id:undefined
            },
            total:0,
            queryForm:{
                pageNum:1,
                pageSize:10
            },
            label:'',
            rule:{
                retail_price:[
                   { required: true, message: "请输入零售价格", trigger: "blur" } 
                ]
            },
            serRule:{
                service_name:[
                    { required: true, message: "请输入等级名称", trigger: "blur" } 
                ],
                service_cost:[
                    { required: true, message: "年服务费不能为空", trigger: "blur" },
                    { type: 'number', message: '年服务费必须为数字值'}
                ],
                service_des:[
                     { required: true, message: "请输入等级描述", trigger: "blur" } 
                ]
            },
            codeRule:{
                code_order_begin:[
                    { required: true, message: "起始阶梯不能为空", trigger: "blur" },
                    { type: 'number', message: '阶梯必须为数字值'}
                ],
                    code_order_end:[
                    { required: true, message: "终止阶梯不能为空", trigger: "blur" },
                    { type: 'number', message: '阶梯必须为数字值'}
                ],
                code_retail:[
                    { required: true, message: "零售价不能为空", trigger: "blur" },
                    { type: 'number', message: '零售价必须为数字值'}
                ]
            }
        }
    },
    created(){
        this.getList()
    },
    methods:{
        getList(){
           switch (this.activeName){
               case 'first':
               getModule(this.queryForm).then(res=>{
                   this.moduleData=res.data
                   this.total=res.total
               })
               break;
               case 'second':
               getCodeList().then(res=>{
                   this.mainCodeData=res.data[0]
                   this.codeData=res.data[1]
               })
               break;
               case 'third':
               getServer().then(res=>{
                   this.serverData=res.data
               })
               break;
           } 
        },
        handleClick(){
            this.getList()
        },
        setPrice(row){
            this.moduleDialog=true
            this.moduleForm.retail_price=row.module_retail
            this.moduleForm.id=row.id
            this.label=row.module_name
        },
        setCodePrice(row){
            this.codeForm={
                code_order_begin:Number(row.code_order_begin),
                code_order_end:Number(row.code_order_end),
                code_retail:Number(row.code_retail),
                id:row.id,
                status:row.id?true:false
            }
            this.codeDialog=true
            this.codeTitle="设置码费"
        },
        handleAddCode(){
            this.codeDialog=true
            this.codeTitle='添加码费'
            this.codeForm.code_order_begin=undefined
            this.codeForm.code_order_end=undefined
            this.codeForm.code_retail=undefined
            this.codeForm.id=undefined
            this.codeForm.status=false
        },
        handleEdit(row){
            this.serTitle='修改服务等级'
            this.serDialog=true
            this.serForm=row
            this.serForm.service_cost=Number(this.serForm.service_cost)
        },
        handleAddService(){
            this.serDialog=true
            this.serTitle='添加服务等级'
            this.serForm.service_cost=undefined
            this.serForm.service_des=undefined
            this.serForm.service_name=undefined
            this.serForm.id=undefined
        },
        submitForm(){
            this.$refs["moduleForm"].validate(valid => {
                if(valid){
                    setModulePrice(this.moduleForm).then(res=>{
                        if(res.code==200){
                            this.$message.success(res.msg)
                            this.moduleDialog=false
                            this.getList()
                        }else{
                            this.$message.error(res.msg)
                        }
                    })
                }
            })
        },
        submitCodeForm(){
            this.$refs["codeForm"].validate(valid => {
                if(valid){
                   var arr=Object.assign({},this.codeForm)
                   delete arr.status
                   addCodePrice(arr).then(res=>{
                       if(res.code==200){
                            this.$message.success(res.msg)
                            this.codeDialog=false
                            this.getList()
                       }else{
                           this.$message.error(res.msg)
                       }
                   }) 
                }
            })
        },
        submitSerForm(){
            this.$refs["serForm"].validate(valid => {
                if(valid){
                    addServer(this.serForm).then(res=>{
                        if(res.code==200){
                            this.$message.success(res.msg)
                            this.serDialog=false
                            this.getList()
                       }else{
                           this.$message.error(res.msg)
                       }
                    })
                }
            })
        },
        cancel(){
            this.moduleDialog = false;
            this.resetForm("moduleForm");
        },
        cancelSer(){
            this.serDialog=false
            this.resetForm("serForm");
        },
        cancelCode(){
            this.codeDialog=false
            this.resetForm("codeForm");
            this.codeForm.status=undefined
        }
    }
}
</script>

<style>

</style>