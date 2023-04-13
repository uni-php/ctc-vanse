<template>
  <div class="app-container">
    <el-form :model="form" ref="form" class="form" label-width="120px" :rules="rule" size="medium">
      <el-form-item prop="product_name" label="商品名称：" >
          <el-input style="width:80%" @focus="clickProduct" v-model="form.product_name" placeholder="请选择商品"/>
      </el-form-item>
      <el-form-item label="一级分类：" prop="class_one">
          <el-select style="width:80%"  @change="selectOneClass" v-model="form.class_one" placeholder="请选择商品分类">
              <el-option
                  v-for="item in classOptions"
                  :key="item.id"
                  :label="item.class_name"
                  :value="item.id">
              </el-option>
          </el-select>
      </el-form-item>
      <el-form-item label="二级分类：" prop="class_two">
          <el-select style="width:80%"  v-model="form.class_two" placeholder="请选择商品分类">
              <el-option
                  v-for="item in classTwoOptions"
                  :key="item.id"
                  :label="item.class_name"
                  :value="item.id">
              </el-option>
          </el-select>
      </el-form-item>
      <el-form-item label="运费模板：" prop="freight_id">
            <el-select style="width:80%" v-model="form.freight_id" placeholder="请选择运费模板">
                <el-option
                    v-for="item in freightOptions"
                    :key="item.id"
                    :label="item.tpl_name"
                    :value="item.id">
                </el-option>
            </el-select>
      </el-form-item>
      <el-form-item label="零售价范围：" prop="price_small">
        <el-row style="width:80%">
          <el-col :span="11">
            <el-input style="width:100%"  v-model="form.price_small" placeholder="请输入"/>
          </el-col>
          <el-col class="line" :span="2" style="text-align:center">-</el-col>
          <el-col :span="11">
            <el-input style="width:100%"  v-model="form.price_big" placeholder="请输入"/>
          </el-col>
        </el-row>
        <div class="tips" style="font-size:13px;color:red">当该商品被门店上架后，限制门店修改商品的价格时不能超出该区间</div>
      </el-form-item>
      <el-form-item label="佣金设置：" prop="commission_type">
        <el-radio-group v-model="form.commission_type">
          <el-radio :label="0">按金额：以实际成交金额为主</el-radio>
          <el-radio :label="1">按比例：以实际成交金额为主</el-radio>
        </el-radio-group>
      </el-form-item>
      <el-form-item prop="commission_money" label="返佣金额：" v-if="form.commission_type==0">
          <el-input style="width:80%" v-model="form.commission_money" placeholder="请输入">
            <template slot="append">元</template>
          </el-input>
          <div class="tips" style="font-size:13px;color:red">当门店每销出一件总部仓库的商品后，给予门店一定数值的金额返利。（门店上传的商品除外）</div>
      </el-form-item>
      <el-form-item prop="commission_scale" label="返佣比例：" v-if="form.commission_type==1">
          <el-input style="width:80%" v-model="form.commission_scale" placeholder="请输入">
            <template slot="append">%</template>
          </el-input>
          <div class="tips" style="font-size:13px;color:red">当门店每销出一件总部仓库的商品后，给予门店一定数值的金额返利。（门店上传的商品除外）</div>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" @click="submitForm">保 存</el-button>
        <el-button @click="cancel">取消</el-button>
      </el-form-item>
    </el-form>
    <el-dialog title="选择产品" :visible.sync="productDialog" width="80%" @close="productDialog=false">
        <ProductPanel @selectProduct="selectProduct" />
    </el-dialog>
  </div>
</template>

<script>
import ProductPanel from '@/components/ProductPanel'
import {getStoreGoodsClass} from '@/api/app/store/index'
import {saveSelfGoods,querySelfGoodsInfo} from '@/api/app/store/goods'
import {getTpl} from '@/api/system/sys/freight'
export default {
  components:{
      ProductPanel
  },
  data(){
    return{
      productDialog:false,
      form:{
        product_name:'',
        product_id:'',
        class_one:'',
        class_two:'',
        freight_id:'',
        price_small:'',
        price_big:'',
        commission_type:0,//佣金类型
        commission_money:'',
        commission_scale:''
      },
      freightOptions:[],
      rule:{
        product_name:[
            { required: true, message: "商品名称不能为空", trigger: "blur" },
        ],
        class_one:[
              { required: true, message: "商品分类不能为空", trigger: "blur" },
        ],
        class_two:[
            { required: true, message: "商品分类不能为空", trigger: "blur" },
        ],
        freight_id:[
            { required: true, message: "运费模板不能为空", trigger: "blur" },
        ],
        commission_money:[
          { required: true, message: "请输入返佣金额", trigger: "blur" }
        ],
        commission_scale:[
          { required: true, message: "请输入返佣比例", trigger: "blur" }
        ]
      },
      queryParams:{
          pageNum:1,
          pageSize:999
      },
      classOptions:[],
      classTwoOptions:[],
      queryClassParams:{
          pageNum:1,
          pageSize:999
      },
    }
  },
  async created(){
    await this.getClassList()
    this.getFreightTpl()
    this.self_product_id=this.$route.query.id
    if(this.self_product_id){
      this.querySelfGoodsInfo()
    }
  },
  methods:{
    clickProduct(){
        this.productDialog=true
    },
    getClassList(){
      return getStoreGoodsClass(this.queryClassParams).then(res=>{
          this.classOptions=res.data
      })
    },
    querySelfGoodsInfo(){
      querySelfGoodsInfo({id:this.self_product_id}).then(res=>{
        this.classTwoOptions=this.classOptions.filter(item=>item.id==res.data.class_one).map(it=>it.children)[0]
        console.log(this.classTwoOptions)
        this.$forceUpdate()
        this.form=res.data
      })
    },
    getFreightTpl(){
        getTpl(this.queryParams).then(res=>{
            this.freightOptions=res.data
        })
    },
    selectOneClass(val){
      this.classTwoOptions=this.classOptions.filter(item=>item.id==val).map(it=>it.children)[0]
    },
    submitForm(){
      this.$refs["form"].validate(valid => {
        if(valid){
          saveSelfGoods(this.form).then(res=>{
            if(res.code==200){
              this.$message.success(res.msg)
              this.close()
            }else{
              this.$message.error(res.msg)
            }
          })
        }
      })
    },
    cancel(){
      this.close()
    },
    /** 关闭按钮 */
    close() {
        this.$store.dispatch("tagsView/delView", this.$route);
        this.$router.go(-1)
    },
    selectProduct(row){
        //将商品信息回传到表单
        this.productDialog=false
        this.form={
            product_id:row.id,
            product_name:row.product_name
        }
    }
  }
}
</script>

<style>

</style>
