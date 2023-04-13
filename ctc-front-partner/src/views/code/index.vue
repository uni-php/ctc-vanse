<template>
  <div class="app-container">
    <div class="tab-bar">
        <el-form ref="queryForm" :model="queryForm" label-width="100px" :inline="true" size="small">
            <el-form-item label="品牌商" prop="dealer">
                <el-input style="width:220px" v-model="queryForm.dealer" placeholder="请输入品牌商"></el-input>
            </el-form-item>
            <el-form-item label="类型" prop="type">
                <el-select style="width:220px" size="small" v-model="queryForm.type" placeholder="请选择生码类型">
                    <el-option
                        v-for="item in codeType"
                        :key="item.dict_value"
                        :label="item.dict_label"
                        :value="item.dict_value">
                    </el-option>
                </el-select>
            </el-form-item>
            <el-form-item label="应用场景" prop="scene">
                <el-select style="width:220px" size="small"  v-model="queryForm.scene" placeholder="请选择应用场景">
                    <el-option
                        v-for="item in sceneOptions"
                        :key="item.dict_value"
                        :label="item.dict_label"
                        :value="item.dict_value">
                    </el-option>
                </el-select>
            </el-form-item>
            <el-form-item label="备注说明" prop="mark">
                <el-input style="width:220px" v-model="queryForm.mark" placeholder="请输入备注"></el-input>
            </el-form-item>
            <el-form-item > 
                <el-button type="primary" icon="el-icon-search" @click="query">查询</el-button>
                <el-button icon="el-icon-refresh" @click="reset('queryForm')">重置</el-button>
            </el-form-item>
        </el-form>
    </div>
    <el-col :span="24" style="margin:10px 0;">
        <el-button type="primary" plain style="font-size:14px" size="small" >生码总量：{{sum}}</el-button>
        <el-button type="primary" style="font-size:14px" size="small" @click="createCode">生码</el-button>
    </el-col>
    <!-- 表格 -->
    <el-table
      :data="tableData"
      :header-cell-style="{background:'#FAFAFA',color:'#606266',height:'50px'}"
      border
      stripe
      size="medium"
      class="trace-table"
      style="width: 100%">
      <el-table-column prop="batch" align="center" show-overflow-tooltip="" label="批次号"></el-table-column>
      <el-table-column prop="dealer_name" align="center" label="品牌商名称" show-overflow-tooltip></el-table-column>
      <el-table-column prop="account" align="center" label="品牌商账号" width="120px"></el-table-column>
      <el-table-column prop="scene" align="center" label="应用场景" width="360px">
          <template slot-scope="scope">
            <span v-for="(item,index) in scene(scope.row.scene)" :key="index" :class="{active:item.dict_value==4}" @click="handleViewDes(scope.row,item)">
                  {{item.dict_label}}
                  <span v-if="item.dict_value==2">{{scope.row.verification_code==1?'(验证码)':''}}</span>
                  <span v-if="scope.row.prize&&item.dict_value==3" :class="{active:scope.row.prize==2}" >{{scope.row.prize==1?'(单奖模式)':'(双奖模式)'}}</span>
                  <span v-show="index!=scene(scope.row.scene).length-1">、</span>
            </span>
          </template>
      </el-table-column>
      <el-table-column prop="order" align="center" show-overflow-tooltip label="流水号范围">
          <template slot-scope="scope">
              <span>{{scope.row.order_begin}} - {{scope.row.order_end}}</span>
          </template>
      </el-table-column>
      <el-table-column prop="count" align="center" label="数量"></el-table-column>
      <el-table-column prop="code_type" align="center" label="类型">
          <template slot-scope="scope">
              <span>{{scope.row.code_type==1?'普通码':"小程序码"}}</span>
          </template>
      </el-table-column>
      <el-table-column prop="code_length" align="center" label="数码位数"></el-table-column>
      <el-table-column prop="used_num" align="center" label="已启用数量" :formatter="used_num"></el-table-column>
      <el-table-column prop="create_time" align="center" show-overflow-tooltip label="生码时间"></el-table-column>
      <el-table-column prop="remark" align="center" label="备注说明" show-overflow-tooltip></el-table-column>
      <el-table-column prop="product_name" align="center" label="关联产品">
          <template slot-scope="scope">
              <span v-if="scope.row.is_rel==0">未关联</span>
              <span class="rel-product" @click="handleMoreProduct(scope.row)" v-if="scope.row.is_rel==1&&!scope.row.rel_product_id">多产品</span>
              <span v-if="scope.row.is_rel==1&&scope.row.rel_product_id">{{scope.row.rel_product_name}}</span>
          </template>
      </el-table-column>
      <el-table-column prop="status" align="center" label="启用状态">
           <template slot-scope="scope">
               <span>{{scope.row.status==0?'未启用':scope.row.status==1?'全部启用':'部分启用'}}</span>
           </template>
      </el-table-column>
       <el-table-column prop="enable" align="center" label="审核状态">
           <template slot-scope="scope">
               <span>{{scope.row.enable==0?'审核中':scope.row.enable==1?'已通过':'未通过'}}</span>
           </template>
      </el-table-column>
      <el-table-column label="操作" align="center" fixed="right" width="200px">
        <template slot-scope="scope">
          <el-button
            size="mini"
            type="text"
            @click="handleRel(scope.row)">关联产品</el-button>
            <el-button
            size="mini"
            type="text"
            @click="handleSet(scope.row)">启用</el-button>
            <el-button
            size="mini"
            type="text"
            @click="handleKey(scope.row)">秘钥</el-button>
            <el-button
            size="mini"
            type="text"
            icon="el-icon-download"
            v-if="scope.row.enable==1"
            @click="handleDown(scope.row)">下载</el-button>
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
     <!-- 生码表单 -->
    <el-dialog title="系统生码" :visible.sync="codeDialog" width="60%" @close="codeDialog=false">
        <el-form :model="codeForm" ref="codeForm" label-width="120px" :rules="rule" size="medium">
            <el-form-item label="品牌商：" prop="dealer_name">
                <el-input style="width:90%" @focus="selectPartner" v-model="codeForm.dealer_name" placeholder="请选择品牌商"/>
            </el-form-item>
            <el-form-item label="批次号：" prop="batch">
                <span>系统自动生成</span>
            </el-form-item>
            <el-form-item label="应用场景：" prop="scene">
                <el-checkbox-group v-model="codeForm.scene" @change="changeScene">
                    <el-checkbox v-for="(item,index) in sceneOptions" :key="index" :label="item.dict_value" name="type">
                        {{item.dict_label}}
                        <span>
                            <el-tooltip :content="item.remark" placement="top">
                                <i class="el-icon-info"></i>
                            </el-tooltip>
                        </span>
                    </el-checkbox>
                </el-checkbox-group>
            </el-form-item>
            <el-form-item label="验证码：" prop="verification_code" v-if="codeForm.scene.includes('2')">
                <el-checkbox v-model="codeForm.verification_code">验证码</el-checkbox>
            </el-form-item>
            <el-form-item label="导购奖项：" prop="prize" v-if="prize">
                <el-radio-group v-model="codeForm.prize">
                    <el-radio :label="1">单奖</el-radio>
                    <el-radio :label="2">多奖</el-radio>
                </el-radio-group>
            </el-form-item>
            <el-form-item  prop="prize_order" v-if="prize_order">
                <span slot="label">
                    <el-tooltip :content="prize_order_tips" placement="top">
                    <i class="el-icon-info"></i>
                    </el-tooltip>
                    领奖顺序：
                </span>
                <el-radio-group v-model="codeForm.prize_order">
                    <el-radio v-for="(item,index) in prizeOrderOptions" :label="item.dict_value" :key="index">
                        {{item.dict_label}}
                        <span>
                            <el-tooltip :content="item.remark" placement="top">
                                <i class="el-icon-info"></i>
                            </el-tooltip>
                        </span>
                    </el-radio>
                </el-radio-group>
            </el-form-item>
            <el-form-item label="关联导购码：" prop="rel_guide_code" v-if="rel_guide_code">
                <el-checkbox v-model="codeForm.rel_guide_code">关联导购码</el-checkbox>
            </el-form-item>
            <el-form-item label="关联批次：" prop="rel_guide_code_batch" v-if="rel_guide_code_batch">
                <el-input style="width:90%" @focus="selectGuideBatch" v-model="codeForm.rel_guide_code_batch" placeholder="请选择关联批次"/>
            </el-form-item>
            <!-- 只有物流码 -->
            <el-form-item label="关联物流码：" prop="rel_logistics_code_order" v-if="codeForm.scene.length==1&&codeForm.scene.includes('4')">
                <el-radio-group v-model="codeForm.rel_logistics_code_order" @change="change_rel_logistics_code_order">
                    <el-radio :label="1">先关联</el-radio>
                    <el-radio :label="2">后关联</el-radio>
                </el-radio-group>
                <!-- 包装级别 选择关联级别后渲染 -->
                <template v-if="codeForm.rel_logistics_code_order">
                    <el-row v-if="codeForm.rel_logistics_code_order!=2">
                        <el-select  size="small" v-model="codeForm.logistics_level" @change="changeLogisticsLevel" placeholder="请选择包装层级关系">
                            <el-option
                                v-for="item in logisticsLevelOptions"
                                :key="item.dict_value"
                                :label="item.dict_label"
                                :value="item.dict_value">
                            </el-option>
                        </el-select>
                    </el-row>
                    <!-- 包装规格 -->
                    <el-row v-if="codeForm.logistics_level!=1&&codeForm.rel_logistics_code_order!=2">
                        <span style="margin-right:5px">包装规格：1</span>
                        <span v-for="(item,index) in codeForm.logistics_level_item" :key="index">
                            <span style="margin-right:5px">拖</span>
                            <el-input @change="handleInputScale" :id="'a'+index" size="mini" style="width:50px;margin-right:5px" v-model="item.num" placeholder="0"/>
                        </span>
                    </el-row>
                    <el-row>
                        <span style="margin-right:5px">套标数量：</span>
                        <el-input size="mini" style="width:50px;margin-right:5px" @change="handleInputScaleCount" v-model="codeForm.scale_count" placeholder="0"/>
                        <span>套</span>
                    </el-row>
                    <el-row>
                        <span style="margin-right:5px">数量明细：</span>
                        <span v-if="codeForm.logistics_level==1||codeForm.rel_logistics_code_order==2">小标 ( {{codeForm.scale_count}} )  二维码 ( {{codeForm.scale_count}} )</span>
                        <span v-if="codeForm.logistics_level!=1&&codeForm.rel_logistics_code_order!=2">大标 ( {{codeForm.scale_count}} ) 
                            <span v-for="(item,index) in codeForm.logistics_level_item" :key="index"> 小标 （ {{small_code(index)}} ） </span>
                        二维码 ( {{small_code(codeForm.logistics_level_item.length-1)}} )
                        </span>
                    </el-row>
                    <el-row>
                        <span style="margin-right:5px">温馨提示：请考虑预留足够的损耗数量</span>
                    </el-row>
                </template>
            </el-form-item>
            <el-form-item label="数量：" prop="count" v-if="count">
                <el-input style="width:90%" @change="handleInputCodeCount" v-model.number="codeForm.count" placeholder="请输入生码数量"/>
            </el-form-item>
            <el-form-item label="起始编号：" prop="order_begin">
                <el-input style="width:90%" v-model="codeForm.order_begin" readonly="" placeholder="请输入起始编号"/>
            </el-form-item>
            <el-form-item label="截止编号：" prop="order_end">
                <el-input style="width:90%" readonly="" v-model="codeForm.order_end" placeholder="请输入截止编号"/>
            </el-form-item>
            <el-form-item label="关联产品：" prop="rel_product_name">
                <el-input style="width:90%" @focus="selectRelProduct('all')" v-model="codeForm.rel_product_name" placeholder="请输入关联产品"/>
                <div style="font-size:12px;color:red">若要关联多个产品，可先不选择，保存后在【生码管理】列表中再做关联操作</div>
            </el-form-item>
            <el-form-item label="数码长度：" prop="code_length" v-if="codeForm.scene.length>=2||!codeForm.scene.includes('4')" >
                <el-select style="width:90%" @change="selectCodeLen" v-model="codeForm.code_length" placeholder="请选择数码长度">
                    <el-option
                        v-for="dict in codeLengthOptions"
                        :key="dict.id"
                        :label="dict.dict_label"
                        :value="dict.dict_value">
                    </el-option>
                </el-select>
            </el-form-item>
            <el-form-item label="秘钥对：" v-if="codeForm.scene.length>=2||!codeForm.scene.includes('4')" prop="key_pair">
                <el-tag>{{codeForm.KEY_N||'暂无'}}</el-tag><el-tag style="margin-left:5px">{{codeForm.KEY_D||'暂无'}}</el-tag><el-tag style="margin-left:5px">{{codeForm.KEY_E||'暂无'}}</el-tag>
            </el-form-item>
            <!-- 数码长度 根据选择套标级别 逐级展示 -->
            <template v-if="codeForm.scene.includes('4')&&codeForm.scene.length==1">
                <el-form-item v-for="(item, index) in codeForm.secret_key" :label="index+1+'级包装数码长度'" :prop="'secret_key.' + index + '.value'"  :key="index.key">
                    <el-select style="width:90%" @change="selectLevelCodeLen(index)" v-model="item.length" placeholder="请选择数码长度">
                    <el-option
                        v-for="dict in codeLengthOptions"
                        :key="dict.id"
                        :label="dict.dict_label"
                        :value="dict.dict_value">
                    </el-option>
                    </el-select>
                    <div>
                        <span style="margin-right:4px">序号：<el-tag>{{logis_level_order(index)||'暂无'}}</el-tag></span>
                        <span>秘钥：<el-tag>{{item.key||'暂无'}}</el-tag></span>
                    </div>
                </el-form-item>
                <!-- <el-form-item label="秘钥对：" v-if="codeForm.code_length" prop="key_pair" :key="index">
                    <el-tag>{{codeForm.KEY_N}}</el-tag><el-tag style="margin-left:5px">{{codeForm.KEY_D}}</el-tag><el-tag style="margin-left:5px">{{codeForm.KEY_E}}</el-tag>
                </el-form-item> -->
            </template>
            <el-form-item label="备注说明：" prop="remark">
                <el-input style="width:90%" v-model="codeForm.remark" placeholder="请输入备注说明"/>
            </el-form-item>
            <el-form-item label="生码类型：" prop="code_type">
                <el-radio-group v-model="codeForm.code_type">
                    <el-radio v-for="(item,index) in codeType" :key="index" :label="item.dict_value">
                        {{item.dict_label}}
                    </el-radio>
                </el-radio-group>
            </el-form-item>
        </el-form>
        <!-- 价格区域 -->
        <div class="tips">
            <p>成本单价：{{code_cost}}元/个</p>
            <p>品牌商单价：{{code_retail}}元/个</p>
            <p>需向平台支付金额：{{total_cost_fee}}元</p>
            <p>支付方式：
                <el-radio-group v-model="pay_type">
                    <el-radio :label="0">余额支付<span style="color:red">（余额：{{user_info.balance}}元）</span></el-radio>
                    <el-radio :label="1">线下支付（联系客服）</el-radio>
                </el-radio-group> 
            </p>
        </div>
        <!-- 选择品牌商表格 -->
        <el-dialog
          width="70%"
          title="选择品牌商商"
          :visible.sync="dealerDialog"
          append-to-body>
          <el-form ref="queryDealerForm" :model="queryDealerForm" label-width="100px" :inline="true" size="small">
            <el-form-item label="品牌商名称" prop="dealer_name">
              <el-input style="width:240px" v-model="queryDealerForm.dealer_name" placeholder="请输入品牌商名称"></el-input>
            </el-form-item>
            <el-form-item label="品牌商账户" prop="account">
              <el-input style="width:240px" v-model="queryDealerForm.account" placeholder="请输入品牌商账户"></el-input>
            </el-form-item>
            <el-form-item > 
              <el-button type="primary" icon="el-icon-search" @click="queryDealer">查询</el-button>
              <el-button icon="el-icon-refresh" @click="resetDealerQuery('queryDealerForm')">重置</el-button>
            </el-form-item>
          </el-form>
          <el-table
            :data="tableDealerData"
            :header-cell-style="{background:'#FAFAFA',color:'#606266',height:'50px'}"
            border
            stripe
            size="small"
            class="trace-table"
            style="width: 100%">
            <el-table-column prop="id" align="center" label="品牌商编号" ></el-table-column>
            <el-table-column prop="dealer_name" align="center" label="品牌商名称" ></el-table-column>
            <el-table-column prop="account" align="center" label="品牌商账号" ></el-table-column>
            <el-table-column label="操作" align="center" fixed="right" width="200px">
              <template slot-scope="scope">
                <el-button
                  size="mini"
                  type="primary"
                  @click="handleSelect(scope.row)">选择</el-button>
              </template>
            </el-table-column>
          </el-table>
          <pagination
            v-show="+totals>10"
            :total="+totals"
            :page.sync="queryDealerForm.pageNum"
            :limit.sync="queryDealerForm.pageSize"
            @pagination="getDealerList"
        />
        </el-dialog>
        <div slot="footer" class="dialog-footer">
            <el-button type="primary" plain @click="resetKey">秘钥重置</el-button>
            <el-button type="primary" @click="submitFrom">立即生码</el-button>
        </div>
    </el-dialog>
    <!-- 导购批次关联 -->
   <el-dialog title="批次管理" :visible.sync="dealerCodeBatchDialog" width="70%" @close="dealerCodeBatchDialog=false">
       <el-table
            :data="dealerCodeBatch"
            :header-cell-style="{background:'#FAFAFA',color:'#606266',height:'50px'}"
            border
            stripe
            size="medium"
            class="trace-table"
            style="width: 100%">
            <el-table-column prop="batch" align="center" label="批次"></el-table-column>
            <el-table-column prop="scene" align="center" label="应用场景">
                <template slot-scope="scope">
                    <span>{{scene(scope.row.scene)}}</span>
                </template>
            </el-table-column>
            <el-table-column prop="order" align="center" show-overflow-tooltip label="流水号范围">
                <template slot-scope="scope">
                    <span>{{scope.row.order_begin}} - {{scope.row.order_end}}</span>
                </template>
            </el-table-column>
            <el-table-column prop="count" align="center" label="数量"></el-table-column>
            <el-table-column prop="code_type" align="center" label="类型">
                <template slot-scope="scope">
                    <span>{{scope.row.code_type==1?'普通码':"小程序码"}}</span>
                </template>
            </el-table-column>
            <el-table-column prop="used_num" align="center" label="已启用数量" :formatter="used_num"></el-table-column>
            <el-table-column prop="create_time" align="center" show-overflow-tooltip label="生码时间"></el-table-column>
            <el-table-column prop="remark" align="center" label="备注说明" show-overflow-tooltip></el-table-column>
            <el-table-column prop="product_name" align="center" label="关联产品">
                <template slot-scope="scope">
                    <span v-if="scope.row.is_rel==0">未关联</span>
                    <span class="rel-product" @click="handleMoreProduct(scope.row)" v-if="scope.row.is_rel==1&&!scope.row.rel_product_id">多产品</span>
                    <span v-if="scope.row.is_rel==1&&scope.row.rel_product_id">{{scope.row.product_name}}</span>
                </template>
            </el-table-column>
             <el-table-column label="操作" align="center" width="150px">
                <template slot-scope="scope">
                    <el-button
                        size="mini"
                        type="primary"
                        @click="handleSelectBatch(scope.row)">选择</el-button>
                </template>
             </el-table-column>
       </el-table>
   </el-dialog>
    <!-- 启用管理 -->
    <el-dialog title="启用管理" :visible.sync="setDialog" width="50%" @close="setDialog=false">
        <el-tabs v-model="activeName" type="card">
            <el-tab-pane label="全部启用" name="all">
                <el-form ref="setForm" :model="setForm" label-width="100px">
                    <el-form-item label="全部启用：">
                        <el-radio-group v-model="setForm.status">
                        <el-radio label="1">是</el-radio>
                        <el-radio label="2">否</el-radio>
                        </el-radio-group>
                    </el-form-item>
                    <el-form-item>
                        <el-button type="primary" size="small" @click="saveEnableStatus">保存</el-button>
                    </el-form-item>
                </el-form>
            </el-tab-pane>
            <el-tab-pane label="部分启用" name="part">
                <el-form ref="setForm" :model="setForm" label-width="130px" size="small" :rules="setRules">
                    <el-form-item label="起始二维码编号:"  prop="start_code">
                        <el-input style="width:80%" @change="start_code" v-model="setForm.start_code" />
                    </el-form-item>
                    <el-form-item label="截止二维码编号:" prop="end_code">
                        <el-input style="width:80%" @change="end_code" v-model="setForm.end_code" />
                    </el-form-item>
                    <el-form-item label="数量:"  prop="quantity">
                        <el-input style="width:80%" readonly="" v-model.number="setForm.quantity" />
                    </el-form-item>
                    <el-form-item label="备注:" prop="remark">
                        <el-input style="width:80%" v-model="setForm.remark" />
                    </el-form-item>
                    <el-form-item>
                        <el-button type="primary" size="small" @click="addEnableLog">添加到启用记录</el-button>
                    </el-form-item>
                </el-form>
                <!-- 启用记录表单 -->
                <el-table
                    :data="enableLog"
                    :header-cell-style="{background:'#FAFAFA',color:'#606266',height:'50px'}"
                    border
                    stripe
                    size="medium"
                    class="trace-table"
                    style="width: 100%">
                     <el-table-column prop="id" align="center" label="序号"></el-table-column>
                     <el-table-column prop="" align="center" label="启用区间">
                         <template slot-scope="scope">
                             <span>{{scope.row.start_code}}-{{scope.row.end_code}}</span>
                         </template>
                     </el-table-column>
                     <el-table-column prop="quantity" align="center" label="数量"></el-table-column>
                     <el-table-column prop="remark" align="center" label="备注说明"></el-table-column>
                     <el-table-column prop="create_time" align="center" label="添加时间"></el-table-column>
                     <el-table-column label="操作" align="center" fixed="right" width="100px">
                        <template slot-scope="scope">
                            <el-button
                            size="mini"
                            type="danger"
                            @click="handleDele(scope.row)">删除</el-button>
                        </template>
                    </el-table-column>
                </el-table>
                <pagination
                    v-show="+enableTotal>10"
                    :total="+enableTotal"
                    :page.sync="queryEnableForm.pageNum"
                    :limit.sync="queryEnableForm.pageSize"
                    @pagination="getEnableCodes"
                />
            </el-tab-pane>
        </el-tabs>
    </el-dialog>
    <!-- 关联产品 -->
    <el-dialog title="关联产品" :visible.sync="relDialog" width="50%" @close="relDialog=false">
        <el-tabs type="card" v-model="relTab" @tab-click="handleClick">
            <el-tab-pane label="全部关联到一个产品" name="all">
               <el-form :model="relAllForm" v-if="relTab=='all'" ref="relAllForm" label-width="100px" :rules="relAllRule" size="medium">
                    <el-form-item label="产品选择" prop="product_name">
                        <el-input style="width:90%" @focus="selectProduct('all')" v-model="relAllForm.product_name" placeholder="请选择关联产品"/>
                    </el-form-item>
                    <el-form-item label="备注:" prop="remark">
                        <el-input style="width:90%" v-model="relAllForm.remark" />
                    </el-form-item>
                    <el-form-item>
                        <el-button type="primary" size="small" @click="saveAllProductRel">保存</el-button>
                        <el-button type="danger" size="small" @click="removeProductRel">清除关联</el-button>
                    </el-form-item>
               </el-form> 
            </el-tab-pane>
            <el-tab-pane label="关联到不同产品" name="part">
                <el-form :model="relPartForm" v-if="relTab=='part'" ref="relPartForm" label-width="130px" :rules="relRule" size="medium">
                    <el-form-item label="产品选择" prop="product_name">
                        <el-input style="width:80%" @focus="selectProduct('part')" v-model="relPartForm.product_name" placeholder="请选择关联产品"/>
                    </el-form-item>
                    <el-form-item label="起始二维码编号:"  prop="start_code">
                        <el-input style="width:80%" @change="part_start_code" v-model="relPartForm.start_code" />
                    </el-form-item>
                    <el-form-item label="截止二维码编号:" prop="end_code">
                        <el-input style="width:80%" @change="part_end_code" v-model="relPartForm.end_code" />
                    </el-form-item>
                    <el-form-item label="数量:"  prop="quantity">
                        <el-input style="width:80%" readonly="" v-model.number="relPartForm.quantity" />
                    </el-form-item>
                    <el-form-item label="备注:" prop="remark">
                        <el-input style="width:80%" v-model="relPartForm.remark" />
                    </el-form-item>
                    <el-form-item>
                        <el-button type="primary" size="small" @click="saveProductRel">添加到关联记录</el-button>
                    </el-form-item>
                </el-form>
                <!-- 关联记录 -->
                <el-table
                    :data="relProductData"
                    :header-cell-style="{background:'#FAFAFA',color:'#606266',height:'50px'}"
                    border
                    stripe
                    size="medium"
                    class="trace-table"
                    style="width: 100%">
                    <el-table-column prop="id" align="center" label="序号"></el-table-column>
                    <el-table-column prop="id" align="center" label="关联区间">
                        <template slot-scope="scope">
                            <span>{{scope.row.start_code}}-{{scope.row.end_code}}</span>
                        </template>
                    </el-table-column>
                    <el-table-column prop="quantity" align="center" label="数量"></el-table-column>
                    <el-table-column prop="product_name" align="center" label="产品名称"></el-table-column>
                    <el-table-column prop="remark" align="center" label="备注说明"></el-table-column>
                    <el-table-column prop="create_time" align="center" label="添加时间"></el-table-column>
                    <el-table-column label="操作" align="center" fixed="right" width="100px">
                        <template slot-scope="scope">
                            <el-button
                            size="mini"
                            type="danger"
                            @click="handleDeleRel(scope.row)">删除</el-button>
                        </template>
                    </el-table-column>
                </el-table>
                <pagination
                    v-show="+relProductTotal>10"
                    :total="+relProductTotal"
                    :page.sync="queryRelProductFrom.pageNum"
                    :limit.sync="queryRelProductFrom.pageSize"
                    @pagination="getRelProduct"
                />
            </el-tab-pane>
        </el-tabs>
        <!-- 选择产品表格 -->
        <el-dialog
          width="50%"
          title="选择产品"
          :visible.sync="productDialog"
          append-to-body>
          <el-form ref="queryProductForm" :model="queryProductForm" label-width="100px" :inline="true" size="small">
            <el-form-item label="产品名称" prop="product_name">
              <el-input style="width:240px" v-model="queryProductForm.product_name" placeholder="请输入产品名称"></el-input>
            </el-form-item>
            <el-form-item > 
              <el-button type="primary" icon="el-icon-search" @click="queryProduct">查询</el-button>
              <el-button icon="el-icon-refresh" @click="resetProductQuery('queryProductForm')">重置</el-button>
            </el-form-item>
          </el-form>
          <el-table
            :data="productData"
            :header-cell-style="{background:'#FAFAFA',color:'#606266',height:'50px'}"
            border
            stripe
            size="small"
            class="trace-table"
            style="width: 100%">
            <el-table-column prop="id" align="center" label="产品编号" ></el-table-column>
            <el-table-column prop="product_name" align="center" label="产品名称" ></el-table-column>
            <el-table-column label="操作" align="center" width="200px">
              <template slot-scope="scope">
                <el-button
                  size="mini"
                  type="primary"
                  @click="handleSelectProduct(scope.row)">选择</el-button>
              </template>
            </el-table-column>
          </el-table>
          <pagination
            v-show="+productTotal>10"
            :total="+productTotal"
            :page.sync="queryProductForm.pageNum"
            :limit.sync="queryProductForm.pageSize"
            @pagination="getProduct"
        />
        </el-dialog>
    </el-dialog>
    <!-- 查看多产品关联 -->
    <el-dialog title="关联产品" :visible.sync="viewRelDialog" width="50%" @close="viewRelDialog=false">
         <el-table
            :data="relProductData"
            :header-cell-style="{background:'#FAFAFA',color:'#606266',height:'50px'}"
            border
            stripe
            size="medium"
            class="trace-table"
            style="width: 100%">
            <el-table-column prop="id" align="center" label="序号"></el-table-column>
            <el-table-column prop="id" align="center" label="关联区间">
                <template slot-scope="scope">
                    <span>{{scope.row.start_code}}-{{scope.row.end_code}}</span>
                </template>
            </el-table-column>
            <el-table-column prop="quantity" align="center" label="数量"></el-table-column>
            <el-table-column prop="product_name" align="center" label="产品名称"></el-table-column>
            <el-table-column prop="remark" align="center" label="备注说明"></el-table-column>
            <el-table-column prop="create_time" align="center" label="添加时间"></el-table-column>
        </el-table>
            <pagination
                v-show="+relProductTotal>10"
                :total="+relProductTotal"
                :page.sync="queryRelProductFrom.pageNum"
                :limit.sync="queryRelProductFrom.pageSize"
                @pagination="getRelProduct"
            />
    </el-dialog>
    <!-- 查看秘钥 -->
    <el-dialog title="秘钥" :visible.sync="keyDialog" width="40%" append-to-body>
        <el-form ref="keyForm" :model="keyForm" label-width="130px">
            <!-- <el-form-item label="URL前缀:" prop="prefix">
                <el-input readonly="" v-model="keyForm.prefix" />
            </el-form-item> -->
            <el-form-item label="生码秘钥:" prop="key" v-if="keyForm.keys.length==0">
                <el-input readonly="" v-model.number="keyForm.key"/>
            </el-form-item>
            <el-form-item v-for="(item,index) in keyForm.keys" :key="index" :label="(index+1)+'级包装生码秘钥:'" prop="key">
                <el-input readonly="" v-model.number="item.key"/>
            </el-form-item>
        </el-form>
     </el-dialog>
     <!-- 物流码明细 -->
    <el-dialog title="物流码明细" :visible.sync="logisticsDialog" width="40%" class="logistics">
        <div><span>物流码类型：</span>{{logisticsCodeInfo.rel_logistics_code_order==1?'先关联':'后关联'}}</div>
        <div><span>包装类型：</span>{{packing_type}}</div>
        <div><span>规格：</span>{{specifications}}</div>
        <div><span>物流码明细：</span>{{logistics_code_detail}}</div>
    </el-dialog>
    <!-- 双奖模式明细 -->
    <el-dialog :title="prizeTitle" :visible.sync="prizeDialog" width="30%" class="prizeDialog">
        <div class="prize-box">
            <div class="prize-box-left">
                领奖顺序
            </div>
            <div class="prize-box-right">
                <div class="prize-box-right-top">
                    {{dislof_prize_order}}
                </div>
                <div class="prize-box-right-bottom">
                    {{prize_order_des}}
                </div>
            </div>
        </div>
    </el-dialog>
    <!-- 生码关联产品 -->
    <el-dialog
          width="50%"
          title="选择产品"
          :visible.sync="productDialog"
        >
          <el-form ref="queryProductForm" :model="queryProductForm" label-width="100px" :inline="true" size="small">
            <el-form-item label="产品名称" prop="product_name">
              <el-input style="width:240px" v-model="queryProductForm.product_name" placeholder="请输入产品名称"></el-input>
            </el-form-item>
            <el-form-item > 
              <el-button type="primary" icon="el-icon-search" @click="queryProduct">查询</el-button>
              <el-button icon="el-icon-refresh" @click="resetProductQuery('queryProductForm')">重置</el-button>
            </el-form-item>
          </el-form>
          <el-table
            :data="productData"
            :header-cell-style="{background:'#FAFAFA',color:'#606266',height:'50px'}"
            border
            stripe
            size="small"
            class="trace-table"
            style="width: 100%">
            <el-table-column prop="id" align="center" label="产品编号" ></el-table-column>
            <el-table-column prop="product_name" align="center" label="产品名称" ></el-table-column>
            <el-table-column label="操作" align="center" width="200px">
              <template slot-scope="scope">
                <el-button
                  size="mini"
                  type="primary"
                  @click="handleSelectRelProduct(scope.row)">选择</el-button>
              </template>
            </el-table-column>
          </el-table>
          <pagination
            v-show="+productTotal>10"
            :total="+productTotal"
            :page.sync="queryProductForm.pageNum"
            :limit.sync="queryProductForm.pageSize"
            @pagination="getProduct"
        />
    </el-dialog>
  </div>
</template>
<script>
import { mapGetters } from 'vuex'
import {
listCode,
generateKeyPair,
createCodes,
downLoad,
getEnableCodes,
saveEnableStatus,
deleEnableLog,
getProduct,
getRelProduct,
addRelLog,
deleRelLog,
removeProductRel,
queryDealerCodeBatch,
getCodeBeginOrder,
getCreateCodePrice,
addEnableLog} from "@/api/code/index"
import {getDealer} from "@/api/demand/index";
export default {
    data(){
        return{
            queryForm:{
                dealer:'',//品牌商
                type:'',
                scene:'',//单选
                mark:'',
                pageNum:1,
                pageSize:10
            },
            queryDealerForm:{
                dealer_name:'',
                account:'',
                pageNum:1,
                pageSize:10
            },
            queryProductForm:{
                product_name:'',
                dealer_id:'',
                pageNum:1,
                pageSize:10
            },
            queryRelProductFrom:{
                pageNum:1,
                pageSize:10
            },
            prizeTitle:'双奖模式',
            productData:[],
            productTotal:0,
            relProductTotal:0,
            activeName:'all',
            relTab:'all',
            sum:0,
            total:0,
            totals:0,
            enableTotal:0,
            relProductTotal:0,
            queryEnableForm:{
                pageNum:1,
                pageSize:10,
                batch:undefined,//批次唯一
                id:undefined,//批次id唯一
                partner_id:undefined
            },
            rel_count:0,//批次已关联的总数
            bacthInfo:{},//码批次信息
            options:[],
            sceneOptions:[
            ],
            productData:[],
            prizeOrderOptions:[],
            logisticsLevelOptions:[],//物流关联层级
            logisticsCodeInfo:{},
            sceneOptions:[],
            codeType:[],
            tableData:[
            ],
            enableLog:[],
            codeLengthOptions:[],
            tableDealerData:[],
            codeDialog:false,
            relDialog:false,
            dealerDialog:false,
            keyDialog:false,
            setDialog:false,
            productDialog:false,
            viewRelDialog:false,
            dealerCodeBatchDialog:false,
            logisticsDialog:false,
            prizeDialog:false,
            dealerCodeBatch:[],
            relProductData:[],
            prize_order_tips:'温馨提示：领奖顺序可生码后更改',
            dislof_prize_order:'',//领奖顺序
            prize_order_des:'',
             keyForm:{
               prefix:'trace.union-aid.com',
               key:'',
               keys:[],//单独物流码秘钥
            },
            relForm:{
                product_id:'',
                product_name:'',
                remark:''
            },
            relAllForm:{
                product_id:'',
                product_name:'',
                remark:''
            },
            relPartForm:{
                product_id:'',
                product_name:'',
                start_code:'',
                end_code:'',
                quantity:'',
                remark:''
            },
            relAllRule:{
                product_name:[
                    { required: true, message: "请输入产品名称", trigger: "blur" }
                ],
                remark:[
                    { required: true, message: "请输入备注", trigger: "blur" }
                ]
            },
            relRule:{
                start_code:[
                    { required: true, message: "请输入起始二维码编号", trigger: "blur" }
                ],
                end_code:[
                    { required: true, message: "请输入截止二维码编号", trigger: "blur" }
                ],
                product_name:[
                    { required: true, message: "请输入产品名称", trigger: "blur" }
                ],
                quantity:[
                    { required: true, message: "请输入关联二维码数量", trigger: "blur" },
                    { type: 'number', message: '数量必须为数字值'}
                ],
                remark:[
                    { required: true, message: "请输入备注", trigger: "blur" }
                ]
            },
            setForm:{
                status:'1',
                start_code:'',
                end_code:'',
                quantity:'',
                remark:''
            },
            codeForm:{
                dealer_name:'',
                partner_id:undefined,
                dealer_id:'',
                dealer_name:'',
                verification_code:'',//验证码
                prize:'',//导购码单奖 多奖品
                prize_order:'',//领奖顺序
                rel_guide_code:'',//关联导购码
                rel_guide_code_batch:'',//关联导购批次
                rel_logistics_code_order:1,//关联物流码 先关联
                logistics_level:'',//包装层级关系
                logistics_level_item:[
                    {
                        num:''//具体层级的套数
                    }
                ],
                scale_count:0,//套标数量
                scene:[],
                batch:'',
                count:'',
                order_begin:'',
                order_end:'',
                rel_product_name:'',
                rel_product_id:'',
                code_length:'',
                remark:'',
                //秘钥展示逻辑改写
                secret_key:[
                    {
                        length:'',//数码长度
                        key:'',//秘钥
                        order:'',//码段区间 前端来计算 
                    }
                ],
                code_type:'1',//默认普通码
                KEY_N:undefined,
                KEY_D:undefined,
                KEY_E:undefined
            },
            pay_type:0,//支付方式0余额支付 1现在支付
            code_cost:0,//成本单价
            code_retail:0,//品牌商单价
            total_fee:0,//品牌商生码费用
            total_cost_fee:0,//合伙人生码成本总价
            rule:{
                dealer_name:[
                    { required: true, message: "请选择品牌商", trigger: "blur" }
                ],
                count:[
                    { required: true, message: "请填写生码数量", trigger: "blur" }
                ],
                code_length:[
                    { required: true, message: "请选择数码长度", trigger: "blur" }
                ],
                order_begin:[
                    { required: true, message: "请填写起始编号", trigger: "blur" }
                ],
                order_end:[
                    { required: true, message: "请填写截止编号", trigger: "blur" }
                ],

            },
            setRules:{
                start_code:[
                    { required: true, message: "请输入起始二维码编号", trigger: "blur" }
                ],
                end_code:[
                    { required: true, message: "请输入截止二维码编号", trigger: "blur" }
                ],
                quantity:[
                    { required: true, message: "请输入启用二维码数量", trigger: "blur" },
                    { type: 'number', message: '数量必须为数字值'}
                ],
                remark:[
                    { required: true, message: "请输入备注", trigger: "blur" }
                ],
            }

        }
    },
    computed:{
        ...mapGetters([
            'user_info'
        ]),
        //多选
        scene(){
            return function(value){
                return this.sceneOptions.filter(item=>value.split(',').includes(item.dict_value))
            }
        },
        prize:function(){
            return this.codeForm.scene.includes('1')&&this.codeForm.scene.includes('3')
        },
        rel_guide_code:function(){
            return this.codeForm.scene.includes('3')&&!this.codeForm.scene.includes('1')&&!this.codeForm.scene.includes('2')
        },
        rel_guide_code_batch:function(){
            return this.codeForm.rel_guide_code&&this.codeForm.scene.includes('3')&&!this.codeForm.scene.includes('1')&&!this.codeForm.scene.includes('2')
        },
        prize_order:function(){
            return this.codeForm.prize==2&&this.codeForm.scene.includes('1')&&this.codeForm.scene.includes('3')
        },
        count:function(){
            return this.codeForm.scene.length>=2||!this.codeForm.scene.includes('4')
        },
        //计算小标数量
        small_code(){
            return function(index){
                //1拖5拖10 套标10-> 10|50|500
                var mul_sum=1;
                for(var i=0;i<index+1;i++){
                    mul_sum*=this.codeForm.logistics_level_item[i]['num'];
                }
                return this.codeForm.scale_count*mul_sum
            }
        },
         //计算托标序列号 更新codeForm
        logis_level_order(){
            return function(index){
                var mul_sum=1;
                // var sum=0;
                if(index==0) {
                    var order=`${this.codeForm.order_begin}--${this.codeForm.order_begin*1+this.codeForm.scale_count*1-1}`
                    this.$set(this.codeForm.secret_key[index],'order',order)
                    return order
                }else{
                    var sum=0;
                    for(var i=0;i<index;i++){
                        mul_sum*=this.codeForm.logistics_level_item[i]['num'];
                        sum+=mul_sum
                    }
                    var cur_num=this.codeForm.scale_count*mul_sum
                    var num=this.codeForm.scale_count*sum+this.codeForm.scale_count*1
                    var order=`${this.codeForm.order_begin*1+num*1-cur_num}--${this.codeForm.order_begin*1+num*1-1}`
                    this.$set(this.codeForm.secret_key[index],'order',order)
                    return order
                }
            }
        },
        //包装类型
        packing_type:function(){
            if(this.logisticsCodeInfo.rel_logistics_code_order==2) return '--'
            if(this.logisticsCodeInfo.rel_logistics_code_order==1){
                var level=JSON.parse(this.logisticsCodeInfo.logistics_level_item).length
                return `${+level+1}级包装`
            }
        },
        //包装规格
        specifications:function(){
            if(this.logisticsCodeInfo.rel_logistics_code_order==2) return '--'
            if(this.logisticsCodeInfo.rel_logistics_code_order==1){
                var scale=JSON.parse(this.logisticsCodeInfo.logistics_level_item)
                var text=scale.map(item=>`拖${item.num}`)
                return `1${text.join('')}`
            }
        },
        //物流码明细
        logistics_code_detail:function(){
            console.log(this.logisticsCodeInfo)
            var arr=this.logisticsCodeInfo.secret_key
            if(!arr) return '-'
            var text='大码：'
            if(arr.length==0){
                return `${this.logisticsCodeInfo.order_begin}--${this.logisticsCodeInfo.order_end}`
            }else{
                if(arr.length==1) text='小码：'
               arr.forEach((item,index)=>{
                   text+=item.order+'\n'+(index==arr.length-1?'':'小码：')
               })
               return text
            } 

        }
    },
    created(){
        this.getList()
        //查询批次关联产品
        this.getDicts({type:'code_scene'}).then(res=>{
            this.sceneOptions=res.data
        })
        this.getDicts({type:'guide_prize_order'}).then(res=>{
            this.prizeOrderOptions=res.data
        })
        this.getDicts({type:'code_length'}).then(res=>{
            this.codeLengthOptions=res.data
        })
        this.getDicts({type:'code_type'}).then(res=>{
            this.codeType=res.data
        })
        this.getDicts({type:'code_scene'}).then(res=>{
            this.sceneOptions=res.data
        })
        this.getDicts({type:'logistics_level'}).then(res=>{
            this.logisticsLevelOptions=res.data
        })
    },
    methods:{
        getList(){
            var arr=Object.assign({},this.queryForm)
            // if(arr.scene.length>0){
            //     arr.scene=arr.scene.join(',')
            // }else{
            //     arr.scene=''
            // }
            listCode(arr).then(res=>{
              this.total=res.total
              this.tableData=res.data
              this.sum=res.sum
            })
        },
        //选择套标的层级  同时将数码长度选框根据层级插值
        changeLogisticsLevel(val){
            this.codeForm.logistics_level_item=[]
            this.codeForm.secret_key=[]
            if(val>1){
                for(var i=1;i<Number(val);i++){
                    this.codeForm.logistics_level_item.push({
                        num: '',
                        key: Date.now()
                    })
                }
            }
            //额外插入一个 最后对象为二维码
            for(var i=0;i<Number(val);i++){
                this.codeForm.secret_key.push({
                    length:'',
                    key:''
                })
            }
            this.codeForm.scale_count=0//切换层级 套标数量置零！！
            this.$forceUpdate()
        },
        //选择关联物流码的先后顺序
        change_rel_logistics_code_order(val){
            this.codeForm.secret_key=[]
            this.codeForm.order_end=''
            if(val=='2'){
                this.codeForm.secret_key.push({
                    key:'',
                    length:'',
                    order:''
                })
                this.codeForm.scale_count=''
            }
            this.$forceUpdate()
        },
        changeScene(val){
            console.log(val)
            if(!val.includes('4')){
                this.codeForm.rel_logistics_code_order=''//清除物流码关联
            }
            //清除生码数量与终止编号
            this.codeForm.count=''
            this.codeForm.order_end=''
            this.codeForm.logistics_level=''
            this.codeForm.secret_key=[]//清除数码包装位数
        },
        //已启用数量
        used_num(row){
            if(row.status==0) return 0;
            if(row.status==1) return row.count
            if(row.status==2) return row.used_num
        },
        start_code(val){
            if(val&&this.setForm.end_code){
                if(parseInt(this.setForm.end_code)<=parseInt(val)){
                    this.$message.warning('请检查激活区间')
                    this.setForm.quantity=''
                    return;
                }else{
                    this.setForm.quantity=parseInt(this.setForm.end_code)-parseInt(val)+1
                }
            }else{
                return;
            }
        },
        end_code(val){
            if(val&&this.setForm.start_code){
                if(parseInt(this.setForm.start_code)>=parseInt(val)){
                    this.$message.warning('请检查激活区间')
                    this.setForm.quantity=''
                    return;
                }else{
                    this.setForm.quantity=parseInt(val)-parseInt(this.setForm.start_code)+1
                }
            }else{
                return;
            }
        },
        part_start_code(val){
            if(val&&this.relPartForm.end_code){
                if(parseInt(this.relPartForm.end_code)<=parseInt(val)){
                    this.$message.warning('请检查激活区间')
                    this.relPartForm.quantity=''
                    return;
                }else{
                    this.relPartForm.quantity=parseInt(this.relPartForm.end_code)-parseInt(val)+1
                }
            }else{
                return;
            }
        },
        part_end_code(val){
            if(val&&this.relPartForm.start_code){
                if(parseInt(this.relPartForm.start_code)>=parseInt(val)){
                    this.$message.warning('请检查激活区间')
                    this.relPartForm.quantity=''
                    return;
                }else{
                    this.relPartForm.quantity=parseInt(val)-parseInt(this.relPartForm.start_code)+1
                }
            }else{
                return;
            }
        },
        //选择关联批次
        selectGuideBatch(){
            if(!this.codeForm.dealer_name){
                this.$message.warning('请先选择品牌商')
                return;
            }
            //查询批次
            queryDealerCodeBatch({dealer_id:this.codeForm.dealer_id}).then(res=>{
                this.dealerCodeBatch=res.data
                this.dealerCodeBatchDialog=true
            })
        },
        //输入生码数量 计算生码末尾码段
        handleInputCodeCount(val){
            if(!val){
                this.codeForm.order_end=''
                return;
            }
            if(!this.codeForm.dealer_id){
                this.$message.warning('请选择品牌商')
                return;
            }
            this.codeForm.order_end=parseInt(val)+parseInt(this.codeForm.order_begin)-1
            //是否关联物流码
            if(this.codeForm.scene.includes('4')){
                //根据托标关系计算套标
                if(this.codeForm.logistics_level==1){
                    this.codeForm.scale_count=val
                }
            }
            //计算生码价格
            this.getCreateCodePrice()
        },
        //计算生码价格
        getCreateCodePrice(){
            getCreateCodePrice({
                dealer_id:this.codeForm.dealer_id,
                count:this.codeForm.count||(this.codeForm.order_end*1-this.codeForm.order_begin*1+1)
            }).then(res=>{
                this.code_cost=res.code_cost
                this.code_retail=res.code_retail,
                this.total_fee=res.sum_fee
                this.total_cost_fee=res.sum_cost_fee
            })
        },
        handleViewDes(row,item){
            if(item.dict_value==4){
                this.logisticsDialog=true
                this.logisticsCodeInfo=row
            }
            //导购码 双奖模式
            if(item.dict_value==3&&row.prize==2){
                this.prizeDialog=true
                var ob=this.prizeOrderOptions.filter(item=>item.dict_value==row.prize_order)
                this.dislof_prize_order=ob.map(item=>item.dict_label)[0]
                this.prize_order_des=ob.map(item=>item.remark)[0]
            }
        },
        //更改套标比例 需要重新计价与计算编号区间
        handleInputScale(val){
            if(!this.codeForm.dealer_id) return this.$message.warning('请选择生码品牌商！')
            //将数码最后的码段截取
            var last_order=this.codeForm.secret_key[this.codeForm.secret_key.length-1]['order'].split('--')//==>[a,b]
            var length=(last_order[1]*1-last_order[0]*1+1)
            this.codeForm.order_end=last_order[1]*1+length*1//加上防伪码
            //计算价格
            this.getCreateCodePrice()
        },
        //输入套标数量 
        handleInputScaleCount(val){
            //计算套标生码总数
            if(!this.codeForm.dealer_id) return this.$message.warning('请选择生码品牌商！')
            //先关联 将数码最后的码段截取
            // if(this.codeForm.rel_logistics_code_order=='1'){
                var last_order=this.codeForm.secret_key[this.codeForm.secret_key.length-1]['order'].split('--')//==>[a,b]
                var length=(last_order[1]*1-last_order[0]*1+1)
                this.codeForm.order_end=last_order[1]*1+length*1//加上防伪码
            // }else{
            //     //后关联
                
            // }
            //计算价格
            this.getCreateCodePrice()
        },
        handleSelectBatch(row){
            this.codeForm.rel_guide_code_batch=row.batch
            this.dealerCodeBatchDialog=false
        },
        submitFrom(){
             this.$refs["codeForm"].validate(valid => {
                 if(valid){
                     if(+this.codeForm.order_begin>+this.codeForm.order_end){
                         this.$message.warning('请检测码段是否正确')
                         return;
                     }
                     if(this.codeForm.KEY_E<0||this.codeForm.KEY_N<0||this.codeForm.KEY_D<0){
                         this.$message.warning('请重新选取密码')
                         return
                     }
                     //验证秘钥是否未填
                     if(this.codeForm.secret_key.length>0){
                        var validKey=this.codeForm.secret_key.filter(item=>!item.key)
                        if(validKey.length>0) return this.$message.warning('请填写包装数码长度')
                     }
                     if(this.pay_type==0&&this.total_cost_fee*1>=this.user_info.balance*1){
                         this.$message.warning('您的账户余额不足')
                         return;
                     }
                     var arr=Object.assign({},this.codeForm)
                     arr.key=`${arr.KEY_N},${arr.KEY_D},${arr.KEY_E}`
                     arr.scene=arr.scene.join(',')
                     delete arr.KEY_E
                     delete arr.KEY_D
                     delete arr.KEY_N
                    //  delete arr.dealer_name
                     arr.logistics_level_item=JSON.stringify(arr.logistics_level_item)
                     arr.code_retail=this.code_retail
                     arr.code_cost=this.code_cost
                     arr.total_fee=this.total_fee
                     arr.total_cost_fee=this.total_cost_fee
                     arr.pay_type=this.pay_type
                     createCodes(arr).then(res=>{
                         if(res.code==200){
                             this.codeDialog=false
                             this.$message.success(res.msg)
                             this.$store.dispatch('user/getInfo')
                             this.getList()
                             //下载
                            // var title=`${this.codeForm.dealer_name}--(${arr.order_begin}-${arr.order_end})`
                            // this.downLoad(`${title}.txt`,res.securityCode)
                         }else{
                             this.$message.error(res.msg)
                         }
                     })
                 }
             })
        },
        //下载码包
        handleDown(row){
             downLoad({batch:row.batch}).then(res=>{
                const content = res 
                const blob = new Blob([content],{type:"application/zip"})
                var timestamp = (new Date()).valueOf();
                const fileName = `${row.dealer_name}-${row.batch}`+'.zip'
                if ('download' in document.createElement('a')) { // 非IE下载
                    const elink = document.createElement('a')
                    elink.download = fileName
                    elink.style.display = 'none'
                    elink.href = window.URL.createObjectURL(blob)
                    document.body.appendChild(elink)
                    elink.click()
                    window.URL.revokeObjectURL(elink.href) // 释放URL 对象
                    document.body.removeChild(elink)
                } else { // IE10+下载
                    navigator.msSaveBlob(blob, fileName)
                }
            })
        },
        downLoad(filename, content,contentType){
            if (!contentType) contentType = 'application/octet-stream';
            var a = document.createElement('a');
            var blob = new Blob([content], { 'type': contentType });
            a.href = window.URL.createObjectURL(blob);
            a.download = filename;
            a.click();
        },
        //启用码段
        handleSet(row){
            this.queryEnableForm.dealer_id=row.dealer_id
            this.queryEnableForm.partner_id=row.partner_id
            this.queryEnableForm.batch=row.batch
            this.queryEnableForm.id=row.id
            this.bacthInfo=row
            this.setForm={
                start_code:'',
                end_code:'',
                quantity:'',
                remark:'',
                status:String(row.status)
            }
            this.getEnableCodes()
            this.setDialog=true
        },
        getEnableCodes(){
            getEnableCodes(this.queryEnableForm).then(res=>{
                this.enableTotal=res.total
                this.enableLog=res.data
            })
        },
        saveEnableStatus(){
            var params={
                status:this.setForm.status,
                id:this.queryEnableForm.id
            }
            saveEnableStatus(params).then(res=>{
                if(res.code==200){
                    this.$message.success(res.msg)
                    this.setDialog=false
                    this.getList()
                }else{
                    this.$message.error(res.msg)
                }
            })
        },
        addEnableLog(){
            this.setForm.batch=this.queryEnableForm.batch
            this.setForm.dealer_id=this.queryEnableForm.dealer_id
            this.setForm.partner_id=this.queryEnableForm.partner_id
            var arr=Object.assign({},this.setForm)
            this.$refs["setForm"].validate(valid => {
                if(valid){
                    if(this.setForm.quantity<=0){
                        this.$message.warning('启用码段数量须大于0')
                        return;
                    }
                    if(this.setForm.quantity*1+this.bacthInfo.used_num*1>this.bacthInfo.count*1){
                        this.$message.warning('启用码段数量不得大于该批次数码数量')
                        return;
                    }
                    addEnableLog(arr).then(res=>{
                        if(res.code==200){
                            this.$message.success(res.msg)
                            this.setDialog=false
                            this.getList()
                        }else{
                            this.$message.error(res.msg)
                        }
                    })
                }
            })
        },
        removeProductRel(){
            this.$confirm(`确认要清除关联吗?`, '提示', {
                confirmButtonText: '确定',
                cancelButtonText: '取消',
                type: 'warning'
            }).then(() => {
                 removeProductRel({'batch':this.bacthInfo.batch}).then(res=>{
                    if(res.code==200){
                        this.$message.success(res.msg)
                        this.relDialog=false
                        this.getList()
                    }else{
                        this.$message.error(res.msg)
                    }
                 })
            }).catch(() => {});
        },
        handleDele(row){
            this.$confirm(`若删除，该批次码段将不可用。确认删除?`, '提示', {
                confirmButtonText: '确定',
                cancelButtonText: '取消',
                type: 'warning'
            }).then(() => {
                 deleEnableLog(row).then(res=>{
                    if(res.code==200){
                        this.$message.success(res.msg)
                        this.getEnableCodes()
                        this.getList()
                    }else{
                        this.$message.error(res.msg)
                    }
                 })
            }).catch(() => {});
        },
        handleDeleRel(row){
            this.$confirm(`是否删除该关联记录。确认删除?`, '提示', {
                confirmButtonText: '确定',
                cancelButtonText: '取消',
                type: 'warning'
            }).then(() => {
                 deleRelLog(row).then(res=>{
                    if(res.code==200){
                        this.$message.success(res.msg)
                        this.getRelProduct()
                    }else{
                        this.$message.error(res.msg)
                    }
                 })
            }).catch(() => {});
        },
        //触发产品关联
        handleRel(row){
            this.bacthInfo=row
            this.queryRelProductFrom.pageNum=1
            this.queryRelProductFrom.batch=row.batch
            this.queryRelProductFrom.dealer_id=row.dealer_id
            this.queryRelProductFrom.partner_id=row.partner_id
            this.relPartForm.product_id=''
            this.relPartForm.product_name=''
            this.relPartForm.remark=''
            this.relPartForm.start_code=''
            this.relPartForm.end_code=''
            this.relPartForm.quantity=''
            this.relTab='all'
            this.getRelProduct()
            this.relDialog=true
        },
        handleClick(){
            this.getRelProduct()
        },
        getRelProduct(){
            getRelProduct(this.queryRelProductFrom).then(res=>{
                if(res.total==1&&res.data[0]['is_rel_all']==1){
                    this.relProductData=[]
                    this.relProductTotal=0
                    this.relAllForm.product_name=res.data[0]['product_name']
                    this.relAllForm.product_id=res.data[0]['product_id']
                    this.relAllForm.remark=res.data[0]['remark']
                    this.relAllForm.batch=res.data[0].batch
                }else{
                    this.relProductData=res.data
                    this.relProductTotal=res.total
                    this.rel_count=res.rel_count
                    this.relAllForm.product_name=''
                    this.relAllForm.product_id=''
                    this.relAllForm.remark=''
                    this.relAllForm.batch=''
                }
            })
        },
        //保存产品关联
        saveProductRel(){
            this.relPartForm.batch=this.queryRelProductFrom.batch
            this.relPartForm.dealer_id=this.queryRelProductFrom.dealer_id
            this.relPartForm.partner_id=this.queryRelProductFrom.partner_id
            this.relPartForm.tab=this.relTab;
            var arr=Object.assign({},this.relPartForm)
            this.$refs["relPartForm"].validate(valid => {
                if(valid){
                    if(this.relPartForm.quantity<=0){
                        this.$message.warning('关联码段数量须大于0')
                        return;
                    }
                    if(this.relPartForm.quantity*1+this.rel_count*1>this.bacthInfo.count*1){
                        this.$message.warning('关联码段总数量不得大于该批次数码数量')
                        return;
                    }
                    arr.order_begin=this.bacthInfo.order_begin
                    arr.order_end=this.bacthInfo.order_end
                    addRelLog(arr).then(res=>{
                        if(res.code==200){
                            this.$message.success(res.msg)
                            this.relDialog=false
                            this.getList()
                        }else{
                            this.$message.error(res.msg)
                        }
                    })
                }
            })
        },
        saveAllProductRel(){
            this.relAllForm.batch=this.queryRelProductFrom.batch
            this.relAllForm.dealer_id=this.queryRelProductFrom.dealer_id
            this.relAllForm.partner_id=this.queryRelProductFrom.partner_id
            this.relAllForm.tab=this.relTab;
            var arr=Object.assign({},this.relAllForm)
            this.$refs["relAllForm"].validate(valid => {
                if(valid){
                    arr.order_begin=this.bacthInfo.order_begin
                    arr.order_end=this.bacthInfo.order_end
                    arr.quantity=this.bacthInfo.count
                    addRelLog(arr).then(res=>{
                        if(res.code==200){
                            this.$message.success(res.msg)
                            this.relDialog=false
                            this.getList()
                        }else{
                            this.$message.error(res.msg)
                        }
                    })
                }
            })
        },
        getProduct(){
            getProduct(this.queryProductForm).then(res=>{
                this.productData=res.data[0]
                this.productTotal=res.data[1]
            })
        },
        queryProduct(){
            this.queryProductForm.pageNum=1
            this.getProduct()
        },
        handleMoreProduct(row){
            this.queryRelProductFrom.pageNum=1
            this.queryRelProductFrom.batch=row.batch
            this.queryRelProductFrom.dealer_id=row.dealer_id
            this.queryRelProductFrom.partner_id=row.partner_id
            this.getRelProduct()
            this.viewRelDialog=true
        },
        resetProductQuery(formName){
            this.$refs[formName].resetFields();
            this.queryProduct()
        },
        handleKey(row){
            this.keyDialog=true
            this.keyForm.key=''
            this.keyForm.keys=[]
            if(row.secret_key.length==0){
                this.keyForm.key=row.key
            }else{
                this.keyForm.keys=row.secret_key
            }
        },
        selectCodeLen(){
            generateKeyPair({length:this.codeForm.code_length}).then(res=>{
                this.codeForm.KEY_N=res.N
                this.codeForm.KEY_D=res.D
                this.codeForm.KEY_E=res.E
            })
        },
        //选择套标的数码长度
        selectLevelCodeLen(index){
            generateKeyPair({length:this.codeForm.secret_key[index].length}).then(res=>{
                this.$set(this.codeForm.secret_key[index],'key',`${res.N},${res.D},${res.E}`)
                console.log(this.codeForm.secret_key)
                this.$forceUpdate()
            })
            this.$forceUpdate()
        },
        resetKey(){
            this.selectCodeLen()
        },
        createCode(){
            this.codeDialog=true
            //清空表单残留数据
            this.codeForm={
                dealer_name:'',
                partner_id:undefined,
                dealer_id:'',
                verification_code:'',//验证码
                prize:'',//导购码单奖 多奖品
                prize_order:'',//领奖顺序
                rel_guide_code:'',//关联导购码
                rel_guide_code_batch:'',//关联导购批次
                rel_logistics_code_order:1,//关联物流码 先关联
                logistics_level:'',//包装层级关系
                logistics_level_item:[
                    {
                        num:''//具体层级的套数
                    }
                ],
                secret_key:[],
                scale_count:0,//套标数量
                scene:[],
                batch:'',
                count:'',
                order_begin:'',
                order_end:'',
                code_type:'1',
                rel_product_name:'',
                rel_product_id:'',
                code_length:'',
                remark:'',
                KEY_N:undefined,
                KEY_D:undefined,
                KEY_E:undefined
            }

        },
        selectPartner(){
            //重置筛选条件
            this.queryDealerForm.dealer_name=''
            this.queryDealerForm.account=''
            this.queryDealerForm.pageNum=1
            this.dealerDialog=true
            this.getDealerList()
        },
        selectProduct(attr){
            this.queryProductForm.pageNum=1
            this.queryProductForm.product_name=''
            this.queryProductForm.dealer_id=this.bacthInfo.dealer_id
            this.queryProductForm.attr=attr
            this.getProduct()
            this.productDialog=true
            this.$forceUpdate()
        },
        selectRelProduct(attr){
            if(!this.codeForm.dealer_id){
                this.$message.warning('请选择品牌商')
                return;
            }
            this.queryProductForm.pageNum=1
            this.queryProductForm.product_name=''
            this.queryProductForm.dealer_id=this.codeForm.dealer_id
            this.queryProductForm.attr=attr
            this.getProduct()
            this.productDialog=true
            this.$forceUpdate()
        },
        //选中某商品
        handleSelectProduct(row){
            if(this.queryProductForm.attr=='all'){
                this.relAllForm.product_name=row.product_name
                this.relAllForm.product_id=row.id
            }else{
                this.relPartForm.product_id=row.id
                this.relPartForm.product_name=row.product_name
            }
            this.productDialog=false
        },
        handleSelectRelProduct(row){
            this.codeForm.rel_product_name=row.product_name//关联产品名称
            this.codeForm.rel_product_id=row.id//关联产品id
            this.productDialog=false
        },
        handleSelect(row){
            //查询生码起始序列号
            getCodeBeginOrder({id:row.id}).then(res=>{
                this.dealerDialog=false
                // this.codeForm.dealer_name=row.dealer_name
                // this.codeForm.dealer_id=row.id
                // this.codeForm.partner_id=row.partner_id
                // this.codeForm.rel_guide_code_batch=''//重选品牌商 清空残留的批次信息
                // this.codeForm.order_begin=res.data//起始序列号
                // //截止编号清空
                // this.codeForm.order_end=''
                //更改
                this.codeForm={
                dealer_name:row.dealer_name,
                partner_id:row.partner_id,
                dealer_id:row.id,
                verification_code:'',//验证码
                prize:'',//导购码单奖 多奖品
                prize_order:'',//领奖顺序
                rel_guide_code:'',//关联导购码
                rel_guide_code_batch:'',//关联导购批次
                rel_logistics_code_order:1,//关联物流码 先关联
                logistics_level:'',//包装层级关系
                logistics_level_item:[
                    {
                        num:''//具体层级的套数
                    }
                ],
                scale_count:0,//套标数量
                code_type:'1',
                scene:[],
                batch:'',
                count:'',
                order_begin:res.data,
                order_end:'',
                rel_product_name:'',
                rel_product_id:'',
                code_length:'',
                remark:'',
                KEY_N:undefined,
                KEY_D:undefined,
                KEY_E:undefined
            }
            })  
        },
        getDealerList(){
            getDealer(this.queryDealerForm).then(res=>{
                this.tableDealerData=res.data
                this.totals=res.total
            })
        },
        queryDealer(){
            this.queryDealerForm.pageNum = 1;
            this.getDealerList();
        },
        resetDealerQuery(formName){
            this.$refs[formName].resetFields();
            this.queryDealer()
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

<style lang="scss" scoped>
.app-container .tips{
    padding: 8px 16px;
    background-color: #ecf8ff;
    border-radius: 4px;
    border-left: 5px solid #50bfff;
    margin: 20px 0;
}
.rel-product,.active{
    color: #409EFF;
    cursor: pointer;
}
.logistics{
    div{
        margin: 10px 0;
        padding: 10px;
        box-sizing: border-box;
        display: flex;
        align-items: center;
        border: 1px solid #eeeeee;
        span{
            width: 100px;
            display: inline-block;
            height: 20px;
            line-height: 20px;
            margin-right: 15px;
            text-align: left;
            border-right: 1px solid #eeeeee;
        }
    }
}
.prizeDialog{
    .prize-box{
        width: 100%;
        min-height:200px;
        display: flex;
        justify-content: space-between;
        align-items: center;
        flex-direction: row;
        border:1px solid #eeeeee;
        .prize-box-left{
            width: 30%;
            height: 200px;
            display: flex;
            padding: 10px;
            justify-content: flex-start;
            align-items: center;
            border-right: 1px solid #eeeeee;
        }
        .prize-box-right{
            width: 70%;
            height: 200px;
            display: flex;
            justify-content: flex-start;
            align-items: center;
            flex-direction: column;
            .prize-box-right-top{
                width: 100%;
                height: 30%;
                display: flex;
                padding: 10px;
                justify-content: flex-start;
                align-items: center;
                border-bottom: 1px solid #eeeeee;
            }
            .prize-box-right-bottom{
                width: 100%;
                height: 70%;
                display: flex;
                padding: 10px;
                justify-content: flex-start;
                align-items: center;
            }
        }
    }
}
</style>