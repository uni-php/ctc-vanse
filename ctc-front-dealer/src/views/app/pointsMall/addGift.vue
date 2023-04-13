<template>
  <div class="app-container">
      <el-form :model="form" ref="form" class="form" label-width="120px" :rules="rule" size="medium">
            <el-form-item prop="gift_name" label="礼品名称：" >
                <el-input style="width:80%" @focus="clickGift" v-model="form.gift_name" placeholder="请选择礼品"/>
            </el-form-item>
            <el-form-item prop="code" label="礼品编号：" >
                {{form.code||'暂无'}}
            </el-form-item>
            <el-form-item prop="market_price" label="市场价：" >
                <span>{{form.market_price||'暂无'}}</span>
            </el-form-item>
            <el-form-item prop="cost_price" label="成本价：" >
                <span>{{form.cost_price||'暂无'}}</span>
            </el-form-item>
             <el-form-item label="一级分类：" prop="class_one">
                <el-select style="width:80%" @change="selectOneClass" v-model="form.class_one" placeholder="请选择礼品分类">
                    <el-option
                        v-for="item in classOptions"
                        :key="item.id"
                        :label="item.class_name"
                        :value="item.id">
                    </el-option>
                 </el-select>
            </el-form-item>
            <el-form-item label="二级级分类：" prop="class_two">
                <el-select style="width:80%" v-model="form.class_two" placeholder="请选择礼品分类">
                    <el-option
                        v-for="item in classTwoOptions"
                        :key="item.id"
                        :label="item.class_name"
                        :value="item.id">
                    </el-option>
                </el-select>
            </el-form-item>
            <el-form-item prop="type" label="积分模式价格：" >
                <el-radio-group v-model="form.type">
                    <el-radio :label="1">积分</el-radio>
                    <el-radio :label="2">积分+现金</el-radio>
                </el-radio-group>
            </el-form-item>
            <el-form-item prop="points_num" label="所需积分：" >
                <el-input style="width:80%" v-model="form.points_num" placeholder="请输入所需积分"/>
            </el-form-item>
            <el-form-item prop="money" v-if="form.type=='2'" label="所需金额：" >
                <el-input style="width:80%" v-model="form.money" placeholder="请输入额外金额"/>
            </el-form-item>
            <el-form-item prop="limit_num" label="可兑换数量：" >
                <el-input style="width:80%" v-model.number="form.limit_num" placeholder="请输入可兑换数量"/>
                <span>库存：{{form.stock}}</span>
            </el-form-item>
            <el-form-item prop="permission" label="兑换权限设置：" >
                <el-radio-group v-model="form.permission">
                    <el-radio :label="1">限兑数量</el-radio>
                    <el-radio :label="2">限兑用户</el-radio>
                </el-radio-group>
            </el-form-item>
            <el-form-item label="限兑数量设置：" v-if="form.permission==1" prop="limit_num_type">
                <el-checkbox-group v-model="form.limit_num_type">
                    <el-checkbox :label="1" >每人限兑</el-checkbox>
                    <el-checkbox :label="2" >每单限兑</el-checkbox>
                </el-checkbox-group>
            </el-form-item>
            <el-form-item prop="person_limit_num" v-if="form.permission==1&&form.limit_num_type.includes(1)" label="每人限兑数量：" >
                <el-input style="width:80%" v-model.number="form.person_limit_num" placeholder="请输入每人限兑数量"/>
            </el-form-item>
            <el-form-item prop="order_limit_num" v-if="form.permission==1&&form.limit_num_type.includes(2)" label="每单限兑数量：" >
                <el-input style="width:80%" v-model="form.order_limit_num" placeholder="请输入每单兑换数量"/>
            </el-form-item>
             <el-form-item label="请选择可兑换该礼品的客户标签：" label-width="250px" v-if="form.permission==2" prop="white_tag">
                <el-select style="width:80%" v-model="form.white_tag" placeholder="请选择标签">
                    <el-option
                        v-for="item in tagsOptions"
                        :key="item.id"
                        :label="item.tag_name"
                        :value="item.id">
                    </el-option>
                </el-select>
            </el-form-item>
            <el-form-item prop="limits_explain" v-if="form.permission==2" label="限兑说明：" >
                <el-input style="width:80%" v-model="form.limits_explain" placeholder="请输入限兑说明"/>
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
            <el-form-item prop="order" label="排序：" >
                <el-input style="width:80%" v-model="form.order" placeholder="请输入序号"/>
            </el-form-item>
             <el-form-item>
                <el-button type="primary" size="medium" v-if="form.id" @click="onSubmit()">保存</el-button>
                <el-button type="primary" size="medium" v-if="!form.id" @click="onSubmit(1)">立即上架</el-button>
                <el-button type="primary" size="medium" v-if="!form.id" @click="onSubmit(0)">放进仓库</el-button>
                <el-button size="medium" @click="goBack">返回</el-button>
            </el-form-item>
      </el-form>
      <!-- 礼品选择弹窗 -->
      <el-dialog title="选择礼品" :visible.sync="giftDialog" width="80%" @close="giftDialog=false">
            <GiftPanel @selectGift="selectGift" />
      </el-dialog>
  </div>
</template>

<script>
import {getMemberTagList} from '@/api/customer/member'
import {getTpl} from '@/api/system/sys/freight'
import GiftPanel from '@/components/GiftPanel'
import {getClassList,savePointsGift,queryGiftInfo} from '@/api/app/points'
import {valiNumberPass} from '@/utils/validate'
export default {
    components:{
        GiftPanel
    },
    data(){
        return{
            form:{
                id:undefined,
                gift_name:'',
                code:'',
                class_one:'',
                class_two:'',
                gift_id:'',
                type:1,
                permission:1,
                points_num:'',
                money:'',
                limit_num:'',
                stock:'',
                limit_num_type:[1],
                person_limit_num:'',
                order_limit_num:'',
                white_tag:'',//可兑换的用户标签
                limits_explain:'很抱歉，你不能兑换此礼品',
                freight_id:'',
                order:''
            },
            gift_id:undefined,
            tagsOptions:[],
            freightOptions:[],
            rule:{
                class_one:[
                     { required: true, message: "礼品分类不能为空", trigger: "blur" },
                ],
                class_two:[
                     { required: true, message: "礼品分类不能为空", trigger: "blur" },
                ],
                points_num:[
                    { required: true, message: "所需积分不能为空", trigger: "blur" },
                    { validator: valiNumberPass, trigger: 'blur'}
                ],
                money:[
                    { required: true, message: "所需金额不能为空", trigger: "blur" },
                    { validator: valiNumberPass, trigger: 'blur'}
                ],
                limit_num:[
                    { required: true, message: "兑换数量不能为空", trigger: "blur" },
                    { type: 'number', message: '兑换数量必须为数字值'}
                ],
                person_limit_num:[
                     { required: true, message: "每人限兑数量不能为空", trigger: "blur" },
                    { type: 'number', message: '每人限兑数量必须为数字值'}
                ],
                order_limit_num:[
                     { required: true, message: "每单兑换数量不能为空", trigger: "blur" },
                    { type: 'number', message: '每单兑换数量必须为数字值'}
                ],
                white_tag:[
                     { required: true, message: "用户标签不能为空", trigger: "blur" },
                ],
                limits_explain:[
                    { required: true, message: "限兑说明不能为空", trigger: "blur" },
                ],
                freight_id:[
                    { required: true, message: "运费模板不能为空", trigger: "blur" },
                ]
            },
            queryClassParams:{
                pageNum:1,
                pageSize:999
            },
            queryParams:{
                pageNum:1,
                pageSize:999
            },
            queryTagForm:{
                tag_name:'',
                remark:'',
                pageNum:1,
                pageSize:999
            },
            giftDialog:false,
            classOptions:[],
            classTwoOptions:[],
        }
    },
    created(){
        this.gift_id=this.$route.query.gift_id
        this.getClassList()
        this.getFreightTpl()
        this.getTagList()
        if(this.gift_id){
            this.queryGiftInfo()
        }
    },
    methods:{
        clickGift(){
            this.giftDialog=true
        },
        getTagList(){
            getMemberTagList(this.queryTagForm).then(res=>{
                this.tagsOptions=res.data
            })
        },
        queryGiftInfo(){
            queryGiftInfo({gift_id:this.gift_id}).then(res=>{
                this.form=res.data
                this.form.class_one=Number(this.form.class_one)
                this.form.class_two=Number(this.form.class_two)
                this.classTwoOptions=this.classOptions.filter(item=>item.id==this.form.class_one).map(it=>it.children)[0]
                this.$forceUpdate()
            })
        },
        getFreightTpl(){
            getTpl(this.queryParams).then(res=>{
                this.freightOptions=res.data
            })
        },
        selectGift(row){
            //将礼品信息回传到表单
            this.giftDialog=false
            this.form.gift_name=row.gift_name
            this.form.gift_id=row.id
            this.form.code=row.code
            this.form.market_price=row.market_price
            this.form.cost_price=row.cost_price
            this.form.stock=row.stock
        },
         selectOneClass(val){
            this.form.class_two=''
            this.classTwoOptions=this.classOptions.filter(item=>item.id==val).map(it=>it.children)[0]
        },
        getClassList(){
            getClassList(this.queryClassParams).then(res=>{
                this.classOptions=res.data
            })
        },
        onSubmit(val){
            if(!this.form.id) this.form.status=val
            if(this.form.limit_num*1>this.form.stock) return this.$message.warning('可兑换数量不得大于礼品库存')
            var data=Object.assign({},this.form)
            delete data.gift_name
            delete data.stock
            delete data.market_price
            delete data.cost_price
            this.$refs["form"].validate(valid => {
                if(valid){
                    savePointsGift(data).then(res=>{
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
        goBack(){
            this.close()
        },
        /** 关闭按钮 */
        close() {
            this.$store.dispatch("tagsView/delView", this.$route);
            this.$router.go(-1)
        },
    }
}
</script>

<style lang="scss" scoped>

</style>