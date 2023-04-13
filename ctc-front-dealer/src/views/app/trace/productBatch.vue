<template>
  <div class="app-container">
    <el-form :model="form" ref="form" label-width="140px" class="form" :rules="rule" size="medium">
        <el-form-item prop="product_batch" label="生产批次号" >
            <el-input style="width:80%" maxlength="30" show-word-limit :readonly="form.id?true:false" v-model="form.product_batch" placeholder="不能包含汉字"></el-input>
        </el-form-item>
        <el-form-item prop="product_name" label="产品名称" >
            <el-input style="width:80%" @focus="clickProduct" v-model="form.product_name" placeholder="请选择产品"/>
        </el-form-item>
        <el-form-item prop="template_name" label="扫码模板" >
            <el-input style="width:80%" @focus="clickTpl" v-model="form.template_name" placeholder="请选择扫码模板"/>
        </el-form-item>
        <el-form-item prop="remark" label="批次备注" >
            <el-input style="width:80%" v-model="form.remark" placeholder="请填写批次备注"/>
        </el-form-item>
    </el-form>
    <!-- 改写tab标签 -->
    <div class="batch-content">
        <el-tabs @keydown.native.delete.capture.stop v-model="editableTabsValue" type="card" editable @edit="handleTabsEdit">
            <el-tab-pane
                :key="index"
                v-for="(item, index) in editableTabs"
                :label="item.title+(index+1)"
                :name="item.name"
            >
            <span slot="label">
                <el-input size="mini" style="width:100px" v-model="item.title"></el-input>
            </span>
            <QiniuEditor v-model="item.content" style="width:90%" :min-height="300"/>
            </el-tab-pane>
        </el-tabs>
    </div>
    <el-dialog title="选择产品" :visible.sync="productDialog" width="80%" @close="productDialog=false">
        <ProductPanel @selectProduct="selectProduct" />
    </el-dialog>
    <el-dialog title="选择模板" :visible.sync="tplDialog" width="80%" @close="tplDialog=false">
        <TplPanel @selectTpl="selectTpl" />
    </el-dialog>
    <el-row>
        <el-col style="margin:20px 0;text-align:center">
            <el-button size="medium" @click="save" type="primary">保 存</el-button>
        </el-col>
    </el-row>
  </div>
</template>

<script>
import ProductPanel from '@/components/ProductPanel'
import TplPanel from '@/components/TplPanel'
import {saveProductBatch,getBatchInfo} from '@/api/app/trace'
export default {
    components:{
        ProductPanel,
        TplPanel
    },
    data(){
        return{
            product_batch:undefined,
            form:{
                product_batch:'',
                product_name:'',
                product_id:'',
                template_name:'',
                template_id:'',
                remark:''
            },
            productDialog:false,
            tplDialog:false,
            rule:{
                product_batch:[
                    { required: true, message: "请填写生产批次号", trigger: "blur" },
                ],
                product_name:[
                    { required: true, message: "请填写产品名称", trigger: "blur" },
                ],
                template_name:[
                    { required: true, message: "请填写扫码模板", trigger: "blur" },
                ]
            },
            editableTabsValue: '1',
            editableTabs: [{
                title: '环节1',
                name: '1',
                content: '环节1'
            },],
            tabIndex: 1
        }
    },
    created(){
        if(this.$route.query.batch){
            this.batch=this.$route.query.batch
            getBatchInfo({batch:this.batch}).then(res=>{
                this.form=res.data
                this.editableTabs=res.data.batch_content
                this.tabIndex=res.data.batch_content.length||1
            })
        }
    },
    methods:{
        clickProduct(){
            this.productDialog=true
        },
        selectTpl(item){
            this.form.template_name=item.template_name
            this.form.template_id=item.id
            this.tplDialog=false
        },
        clickTpl(){
            this.tplDialog=true
        },
        selectProduct(row){
            this.form.product_name=row.product_name
            this.form.product_id=row.id
            this.productDialog=false
        },
        handleTabsEdit(targetName, action) {
        if (action === 'add') {
          let newTabName = ++this.tabIndex + '';
          this.editableTabs.push({
            title: '环节'+newTabName,
            name: newTabName,
            content: '环节'+newTabName
          });
          this.editableTabsValue = newTabName;
        }
        if (action === 'remove') {
          if(this.editableTabs.length==1){
              this.$message.warning('至少保留一个批次信息')
              return;
          }
          let tabs = this.editableTabs;
          let activeName = this.editableTabsValue;
          if (activeName === targetName) {
            tabs.forEach((tab, index) => {
              if (tab.name === targetName) {
                let nextTab = tabs[index + 1] || tabs[index - 1];
                if (nextTab) {
                  activeName = nextTab.name;
                }
              }
            });
          }
          this.editableTabsValue = activeName;
          this.editableTabs = tabs.filter(tab => tab.name !== targetName);
        }
      },
      save(){
          this.$refs["form"].validate(valid => {
              if(valid){
                  var is_complete=this.editableTabs.filter(item=>(item.title==''||item.content==''))
                  if(is_complete.length>0){
                    this.$message.warning('请检查批次信息是否完整')
                    return
                  }
                  this.form.batch_content=this.editableTabs
                  var arr=Object.assign({},this.form)
                  delete arr.product_name
                  delete arr.template_name
                  saveProductBatch(arr).then(res=>{
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
       /** 关闭按钮 */
        close() {
            this.$store.dispatch("tagsView/delView", this.$route);
            this.$router.go(-1)
        },
    }
}
</script>

<style lang="scss" scoped>
.batch-content{
    width: 100%;
    padding: 0 50px;
}
</style>