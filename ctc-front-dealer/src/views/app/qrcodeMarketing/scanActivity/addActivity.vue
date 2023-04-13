<template>
  <div class="app-container">
        <el-tabs v-model="activeName" type="card" @tab-click="handleClick">
            <el-tab-pane label="活动基础设置" name="first"></el-tab-pane>
            <el-tab-pane label="活动奖项策略设置" name="second"> </el-tab-pane>
        </el-tabs>
        <el-form :model="form" ref="form" label-width="140px" :rules="rule"  class="form" size="medium" v-show="activeName=='first'">
            <el-form-item prop="activity_name" label="活动名称：" >
                <el-input style="width:50%" v-model="form.activity_name" placeholder="请输入活动名称"></el-input>
            </el-form-item>
            <el-form-item prop="time" label="活动时间：">
               <el-date-picker
                    style="width:300px"
                    v-model="form.time"
                    type="daterange"
                    @blur="changeTime"
                    unlink-panels=""
                    range-separator="至"
                    value-format="yyyy-MM-dd"
                    start-placeholder="开始日期"
                    end-placeholder="结束日期">
                </el-date-picker>
            </el-form-item>
            <el-form-item prop="remark" label="活动备注：" >
                <el-input style="width:50%" v-model="form.remark" placeholder="请输入活动备注"></el-input>
            </el-form-item>
            <el-form-item prop="tpl_name" label="扫码模板：" >
                <el-row style="width:50%" >
                    <el-col :span="20"><el-input readonly=""  v-model="form.tpl_name" placeholder="请选择扫码模板"/></el-col>
                    <el-col :span="4"><el-button  type="primary" size="medium" @click="clickTpl">选择</el-button></el-col>
                </el-row>
            </el-form-item>
            <el-form-item prop="join_condition" label="活动参与方式：" >
                <el-radio-group v-model="form.join_condition">
                    <el-radio :label="1">关注微信公众号领奖</el-radio>
                    <el-radio :label="2">直接领奖</el-radio>
                </el-radio-group>
            </el-form-item>
            <el-form-item prop="is_user_info" label="用户资料收集：" >
                <el-switch v-model="form.is_user_info" :active-value="1" :inactive-value="0"></el-switch>
                <el-checkbox-group v-model="form.user_info_field" v-if="form.is_user_info!=0">
                    <el-checkbox v-for="(item,index) in fieldOption" :key="index" :label="item.id">{{item.field_name}}</el-checkbox>
                </el-checkbox-group>
            </el-form-item>
            <!-- <el-form-item prop="is_auth_tag" label="自动打标签：" >
                <el-switch v-model="form.is_auth_tag" :active-value="1" :inactive-value="0"></el-switch>
                <el-checkbox-group v-model="form.tags" v-if="form.is_auth_tag!=0">
                    <el-checkbox v-for="(item,index) in tags" :key="index" :label="item.id" :name="item.name">{{item.name}}</el-checkbox>
                </el-checkbox-group>
            </el-form-item> -->
            <el-form-item prop="is_user_address" label="获取用户地理位置：" >
                <el-switch :active-value="1" :inactive-value="0" v-model="form.is_user_address"></el-switch>
            </el-form-item>
            <el-form-item prop="is_rule_show" label="活动规则：" >
                <el-switch :active-value="1" :inactive-value="0" v-model="form.is_rule_show"></el-switch>
                <el-link type="primary" @click="pack_rule">点击查看示例</el-link>
            </el-form-item>
            <el-form-item prop="rule_title" v-if="form.is_rule_show!=0" label="规则标题：" >
                <el-input style="width:50%" v-model="form.rule_title" placeholder="请输入规则标题"></el-input>
            </el-form-item>
            <el-form-item prop="rule_content" v-if="form.is_rule_show!=0" label="规则内容：" >
                <el-input type="textarea" style="width:50%" v-model="form.rule_content" placeholder="请输入规则内容"></el-input>
            </el-form-item>
            <el-form-item prop="active_area"  label="活动区域：" >
                <el-select style="width:50%"  v-model="form.active_area" placeholder="请选择活动区域">
                    <el-option
                        v-for="item in zoneOption"
                        :key="item.id"
                        :label="item.area_name"
                        :value="item.id">
                    </el-option>
                </el-select>
            </el-form-item>
        </el-form>
        <!-- 策略设置 -->
        <div class="" v-show="activeName=='second'">
            <el-row>
                <el-col :span="24" style="margin:10px 0;">
                    <el-button @click="addBatch" type="primary" size="small" >添加活动范围</el-button>
                </el-col>
            </el-row>
            <el-table
            :data="codeBatchData"
            :header-cell-style="{background:'#FAFAFA',color:'#606266',height:'50px'}"
            border
            stripe
            size="small"
            class="trace-table"
            style="width: 100%">
            <el-table-column prop="batch" align="center" label="批次"></el-table-column>
            <el-table-column prop="order_begin" align="center" label="起始流水号"></el-table-column>
            <el-table-column prop="order_end" align="center" label="结束流水号"></el-table-column>
            <el-table-column prop="quantity" align="center" label="区间数量"></el-table-column>
            <el-table-column prop="remark" align="center" label="备注"></el-table-column>
            <el-table-column label="操作" align="center" fixed="right" width="240px">
                <template slot-scope="scope">
                        <el-button
                        size="mini"
                        type="danger"
                        @click="handleDeleBatch(scope.row)">删除</el-button>
                </template>
            </el-table-column>
            </el-table>
            <div style="font-size:14px;margin:10px 0">活动范围总数量：{{sum_code_num}}</div>
            <el-row>
                <el-col :span="24" style="margin:10px 0;">
                    <el-button @click="addPrize" type="primary" size="small" >添加奖项</el-button>
                </el-col>
            </el-row>
            <!-- 奖项 -->
            <el-table
            :data="prizeData"
            :header-cell-style="{background:'#FAFAFA',color:'#606266',height:'50px'}"
            border
            stripe
            size="small"
            class="trace-table"
            style="width: 100%">
            <el-table-column prop="prize_name" align="center" label="奖项名称"></el-table-column>
            <el-table-column prop="prize_number" align="center" label="中奖码数量"></el-table-column>
            <el-table-column prop="prize_rate" align="center" label="中奖比例"></el-table-column>
            <el-table-column prop="prize_content" align="center" label="奖项内容"></el-table-column>
            <el-table-column prop="win_num" align="center" label="已中奖数量"></el-table-column>
            <el-table-column label="操作" align="center" fixed="right" width="240px">
                <template slot-scope="scope">
                        <el-button
                        size="mini"
                        type="primary"
                        @click="handleEditPrize(scope.row)">修改</el-button>
                        <el-button
                        size="mini"
                        type="danger"
                        @click="handleDelePrize(scope.row)">删除</el-button>
                </template>
            </el-table-column>
            </el-table>
            <!-- 高级策略 -->
            <el-collapse v-model="activeNames" >
                <el-collapse-item title="高级策略" name="1">
                    <el-form :model="seniorForm" ref="seniorForm" label-width="140px" class="seniorForm" :rules="seniorRule" size="medium">
                        <el-form-item prop="empty_tips" label="未中奖提示" >
                            <el-input style="width:50%"   v-model="seniorForm.empty_tips" placeholder="请输入未中奖提示"/>
                            <el-link type="primary" @click="empty_tips">点击查看示例</el-link>
                        </el-form-item>
                        <el-form-item prop="repeat_tips" label="重复领奖提示" >
                            <el-input style="width:50%"   v-model="seniorForm.repeat_tips" placeholder="请输入重复领奖提示"/>
                            <el-link type="primary" @click="repeat_tips">点击查看示例</el-link>
                        </el-form-item>
                        <el-form-item prop="invalid_tips" label="奖项已被领取提示" >
                            <el-input style="width:50%"   v-model="seniorForm.invalid_tips" placeholder="请输入奖项已被领取提示"/>
                            <el-link type="primary">点击查看示例</el-link>
                        </el-form-item>
                        <el-form-item prop="is_join_limit" label="活动参与限制" >
                            <el-switch :active-value="1" :inactive-value="0" v-model="seniorForm.is_join_limit"></el-switch>
                        </el-form-item>
                        <el-form-item prop="day_limit_times" label="每人每天限" v-if="seniorForm.is_join_limit" >
                            <el-input style="width:50%"   v-model="seniorForm.day_limit_times" placeholder="请输入限制次数"/><span>次</span>
                        </el-form-item>
                        <el-form-item prop="limit_times_tips" label="超次提示" v-if="seniorForm.is_join_limit" >
                            <el-input style="width:50%"   v-model="seniorForm.limit_times_tips" placeholder="请输入超次提示"/>
                        </el-form-item>
                        <el-form-item prop="is_user_limit" label="指定工种参与" >
                            <el-switch :active-value="1" :inactive-value="0" v-model="seniorForm.is_user_limit"></el-switch>
                        </el-form-item>
                        <el-form-item prop="work_type" label="工种" v-if="seniorForm.is_user_limit==1">
                          <el-select style="width:50%" multiple v-model="seniorForm.work_type" placeholder="请选择分组">
                              <el-option
                                  v-for="item in workTypeOption"
                                  :key="item.dict_value"
                                  :label="item.dict_label"
                                  :value="item.dict_value">
                              </el-option>
                          </el-select>
                        </el-form-item>
                        <!-- 新增开启定向 -->
                        <el-form-item prop="is_open_appoint" label="是否开启定向注册" >
                            <el-switch :active-value="1" :inactive-value="0" v-model="seniorForm.is_open_appoint"></el-switch>
                        </el-form-item>
                        <el-form-item prop="unexpected_user_tips" label="非指定用户领奖提示" v-if="seniorForm.is_user_limit" >
                            <el-input style="width:50%"   v-model="seniorForm.unexpected_user_tips" placeholder="非指定用户领奖提示"/>
                        </el-form-item>
                        <el-form-item prop="is_address_limit" label="指定地区参与" >
                            <el-switch :active-value="1" :inactive-value="0" v-model="seniorForm.is_address_limit"></el-switch>
                        </el-form-item>
                        <el-form-item prop="is_address_limit_type" label="选择类型" v-if="seniorForm.is_address_limit">
                            <el-radio-group v-model="seniorForm.is_address_limit_type">
                                <el-radio :label="1">按行政区域划分</el-radio>
                                <el-radio :label="2">按GPS坐标设置</el-radio>
                            </el-radio-group>
                        </el-form-item>
                        <el-form-item label="活动区域" prop="limit_address" v-if="seniorForm.is_address_limit">
                            <el-cascader
                                size="medium"
                                style="width:80%"
                                :options="options"
                                placeholder="请选择地址"
                                v-model="selectedOption"
                              >
                            </el-cascader>
                            <el-button style="margin-left:10px" type="primary" size="medium" @click="handleSelectSaleArea">添加</el-button>
                        </el-form-item>
                        <el-form-item label="已选区域" prop="sale_address" v-if="seniorForm.is_address_limit">
                            <div v-if="select_sale_address.length>0">
                                <el-tag style="margin-right:10px" size="small" :closable="form.id?true:false"  @close="handleClose(item)" v-for="(item,index) of select_sale_address" :key="index">{{item+'  '}}</el-tag>
                            </div>
                            <div v-else>
                                <span>暂无</span>
                            </div>
                        </el-form-item>
                        <el-form-item label="非活动范围领奖提示" prop="out_address_tips" v-if="seniorForm.is_address_limit">
                             <el-input style="width:50%"   v-model="seniorForm.out_address_tips" placeholder="非活动范围领奖提示"/>
                        </el-form-item>
                        <el-form-item prop="fleeing_goods" label="监控窜货行为" v-if="seniorForm.is_address_limit">
                            <el-radio-group v-model="seniorForm.fleeing_goods">
                                <el-radio :label="1">是</el-radio>
                                <el-radio :label="2">否</el-radio>
                            </el-radio-group>
                        </el-form-item>
                    </el-form>
                </el-collapse-item>
            </el-collapse>
            <div style="width:100%;margin-top:20px;display: flex;justify-content: center;align-items: center;">
                <el-button size="medium"  type="primary" @click="goBack">返回</el-button>
                <el-button size="medium"  type="primary" @click="onSubmit(0)">只保存不启用</el-button>
                <el-button size="medium"  type="primary" @click="onSubmit(1)">保存并启用</el-button>
            </div>
        </div>
        <el-dialog title="选择营销码范围" :visible.sync="batchDialog" width="50%" @close="batchDialog=false">
            <el-form :model="codeForm" ref="codeForm" label-width="100px" :rules="codeRule" size="medium">
                <el-form-item label="可选码批次" prop="code_batch">
                    <el-select style="width:80%" size="small" v-model="codeForm.code_batch" placeholder="请选择码批次">
                        <el-option
                            v-for="item in codeBatchOptions"
                            :key="item.id"
                            :label="item.batch+'--'+'('+item.order_begin+'~'+item.order_end+')'"
                            :value="item.batch">
                        </el-option>
                    </el-select>
                </el-form-item>
                <el-form-item label="设置流水号" prop="is_serial_number">
                    <el-checkbox v-model="codeForm.is_serial_number">按流水号区间设置</el-checkbox>
                </el-form-item>
                <el-form-item prop="order_begin" label="起始流水号" v-if="codeForm.is_serial_number" >
                    <el-input style="width:80%" @change="start_code"  v-model="codeForm.order_begin" placeholder="请输入起始流水号"/>
                </el-form-item>
                <el-form-item prop="order_end" label="终止流水号" v-if="codeForm.is_serial_number" >
                    <el-input style="width:80%" @change="end_code"  v-model="codeForm.order_end" placeholder="请输入终止流水号"/>
                </el-form-item>
                <el-form-item prop="quantity" label="区间数量" v-if="codeForm.is_serial_number">
                    <el-input style="width:80%" readonly=""  v-model="codeForm.quantity" placeholder="区间数量"/>
                </el-form-item>
                <el-form-item prop="remark" label="备注" >
                    <el-input style="width:80%" v-model="codeForm.remark" placeholder="请输入备注"/>
                </el-form-item>
            </el-form>
            <div slot="footer" class="dialog-footer">
                <el-button type="primary" @click="submitBatchForm">保 存</el-button>
                <el-button @click="batchDialog=false">取 消</el-button>
            </div>
        </el-dialog>
        <el-dialog title="添加奖项" :visible.sync="prizeDialog" width="80%" @close="prizeDialog=false">
             <el-form :model="prizeForm" ref="prizeForm" label-width="100px" class="form" :rules="prizeRule" size="medium">
                <el-form-item label="奖项名称" prop="prize_name">
                    <el-input style="width:80%"  v-model="prizeForm.prize_name" placeholder="如：一等奖"/>
                </el-form-item>
                <el-form-item label="奖项数量" prop="prize_number">
                    <el-input style="width:80%" @change="change_prize_number"  v-model.number="prizeForm.prize_number" placeholder="请输入奖品数量"/>
                    <div>占总数的（中奖率）:{{prize_rate}}</div>
                </el-form-item>
                <el-form-item label="奖项内容" prop="prize_type">
                    <el-radio-group v-model="prizeForm.prize_type">
                        <el-radio :label="1">红包</el-radio>
                        <el-radio :label="2">积分</el-radio>
                        <el-radio :label="3">礼品</el-radio>
                    </el-radio-group>
                </el-form-item>
                <el-form-item label="送红包" prop="red_envelopes_name" v-if="prizeForm.prize_type==1">
                    <el-row style="width:50%" >
                        <el-col :span="20"><el-input readonly=""  v-model="prizeForm.red_envelopes_name" placeholder="请选择红包"/></el-col>
                        <el-col :span="4"><el-button  type="primary" size="medium" @click="clickRedEnvelopes">选择</el-button></el-col>
                    </el-row>
                </el-form-item>
                <el-divider v-if="prizeForm.prize_type==2"></el-divider>
                <!-- 送积分 -->
                <el-form-item label="送积分" prop="points" v-if="prizeForm.prize_type==2">
                    <el-input style="width:80%" v-model.number="prizeForm.points" placeholder="请输入积分数量"/>
                </el-form-item>
                <el-form-item label="送产品积分" prop="goods_points" v-if="prizeForm.prize_type==2">
                    <el-checkbox v-model="prizeForm.goods_points">送产品积分</el-checkbox>
                    <span>（按产品库内设置的产品积分来发放，若未设置发放上面的固定积分）</span>
                </el-form-item>
                <el-divider v-if="prizeForm.prize_type==3"></el-divider>
                <!-- 送礼品 -->
                <el-form-item label="送礼品：" prop="gift" v-if="prizeForm.prize_type==3">
                    <vuedraggable class="wrapper" v-model="prizeForm.gift">
                        <transition-group>
                            <div v-for="(item,index) in prizeForm.gift" :key="index" class="drag-box" @mouseover="selectStyle(item,index)" @mouseout="idx=undefined">
                                    <img  :src="item.url"/>
                                    <div :class="[index==idx?'active':'no-active']">
                                        <span @click="handlePictureCardPreview(item)" style="color:white"><i class="el-icon-zoom-in"></i></span>
                                        <span @click="handleRemove(item,index)" style="margin-left:15px;color:white"><i class="el-icon-delete"></i></span>
                                    </div>
                            </div>
                        </transition-group>
                    </vuedraggable>
                    <div>
                        <img v-for="(item,index) in prizeForm.gift" :key="index" :src="item.url" class="avatar">
                        <i @click="selectCover" class="el-icon-plus avatar-uploader-icon"></i>
                    </div>
                </el-form-item>
                <!-- 实物领奖方式 -->
                <el-form-item label="领奖方式" prop="get_prize_mode" v-if="prizeForm.prize_type==3">
                  <el-radio-group v-model="prizeForm.get_prize_mode">
                    <el-radio :label="0">快递邮寄</el-radio>
                    <el-radio :label="1">线下门店领奖</el-radio>
                  </el-radio-group>
                  <el-tooltip  effect="dark" placement="top-start">
                    <div slot="content">1、消费者通过快递邮寄方式领到奖品后，系统会自动生成订单，可以在【订单】-【营销奖品订单】中查看；<br/>2、若选择线下门店领奖，请先在【客户】-【门店管理】中添加门店。</div>
                    <i style="margin-left:10px" class="el-icon-warning"></i>
                  </el-tooltip>
                 </el-form-item>
                <el-form-item label="有效时间" prop="valid_day" v-if="prizeForm.prize_type==3">
                    <el-input style="width:80%" v-model.number="prizeForm.valid_day" placeholder="请输入有效时间"/>
                    <div>天内领取有效（中奖时间将作为生效开始时间）</div>
                </el-form-item>
                <el-form-item label="领取说明" prop="is_gift_tips" v-if="prizeForm.prize_type==3">
                    <el-checkbox v-model="prizeForm.is_gift_tips">开启</el-checkbox>
                </el-form-item>
                <el-form-item label="领取说明" prop="gift_tips" v-if="prizeForm.prize_type==3&&prizeForm.is_gift_tips">
                    <el-input type="textarea" style="width:80%" v-model="prizeForm.gift_tips" placeholder="请输入领取说明"/>
                </el-form-item>
                <!-- <el-form-item label="送礼品" prop="gift" v-if="prizeForm.prize_type.includes('3')">
                    <el-row style="width:50%" >
                        <el-col :span="20"><el-input readonly=""  v-model="prizeForm.gift" placeholder="请选择礼品"/></el-col>
                        <el-col :span="4"><el-button  type="primary" size="medium" @click="clickGift">选择</el-button></el-col>
                    </el-row>
                </el-form-item> -->
             </el-form>
            <div slot="footer" class="dialog-footer">
                <el-button type="primary" @click="submitPrizeForm">保 存</el-button>
                <el-button @click="prizeDialog=false">取 消</el-button>
            </div>
        </el-dialog>
    <el-dialog title="选择模板" :visible.sync="tplDialog" width="80%" @close="tplDialog=false">
        <QrcodeTpl @selectTpl="selectTpl" />
    </el-dialog>
    <el-dialog title="选择红包（仅显示有效红包）" :visible.sync="redDialog" width="80%" @close="redDialog=false">
        <RedPack @selectRedPack="selectRedPack" />
    </el-dialog>
     <!-- 礼品选择弹窗 -->
    <el-dialog title="选择礼品" :visible.sync="giftDialog" width="80%" @close="giftDialog=false">
        <GiftPanel @selectGift="selectGift" />
    </el-dialog>
    <el-dialog :visible.sync="dialogVisible">
        <img width="100%" :src="dialogImageUrl" alt="">
      </el-dialog>
  </div>
</template>

<script>
import {getMarketCodeBatch} from '@/api/codeStore/qrcode'
import {getFieldList} from '@/api/customer/member'
import {getUserTags} from '@/api/access/officialAccount/qrcode'
import{getCustomerAreaList} from '@/api/customer/basics'
import QrcodeTpl from '@/components/QrcodeTpl'
import RedPack from '@/components/RedPack'
import GiftPanel from '@/components/GiftPanel'
import  vuedraggable from "vuedraggable"
import { regionDataPlus,CodeToText, TextToCode } from 'element-china-area-data'
import {saveActivity,getActivityInfo} from '@/api/app/qrcode'
export default {
    components:{
        QrcodeTpl,
        RedPack,
        GiftPanel,
        vuedraggable
    },
    data(){
        return{
            options: regionDataPlus,
            select_sale_address:[],//已选区域
            selectedOption:[],//销售区域
            seniorForm:{
                empty_tips:'很抱歉，您未中奖，再接再厉哦!',
                repeat_tips:'该二维码您已经领过奖了！',
                invalid_tips:'该二维码已经被别人领过奖了！',
                work_type:[],
                is_join_limit:false,
                is_open_appoint:false,
                day_limit_times:3,
                limit_times_tips:'抱歉，您已超过活动当日参与次数上限，请明天再试！',
                is_user_limit:false,
                tags:[],//用户限制标签
                unexpected_user_tips:'您不符合本次活动的参与条件',
                is_address_limit:false,
                is_address_limit_type:1,
                limit_address:[],
                out_address_tips:'您不在本次活动指定的地区，无法参与活动~',
                fleeing_goods:2
            },
            tags:[],//微信用户标签
            empty_example:'http://cdn.uni-2id.com/empty_prize.jpeg',
            repeat_example:'http://cdn.uni-2id.com/repeat_prize.png',
            red_pack_rule:'http://cdn.uni-2id.com/red_pack_rule.png',
            seniorRule:{

            },
            activeNames: ['1'],
            prizeData:[],
            prizeForm:{
                prize_name:'',
                prize_number:'',
                red_envelopes_name:'',
                red_envelopes_id:'',
                points:1,
                goods_points:false,
                prize_type:'',
                gift:[],
                valid_day:3,
                get_prize_mode:0,//实物领奖方式 默认邮寄
                is_gift_tips:false,
                gift_tips:''
            },
            prizeRule:{
                prize_number:[
                    { required: true, message: "输入奖品数量", trigger: "blur" },
                    { type: 'number', message: '数量为数字值'}
                ],
                prize_name:[
                     { required: true, message: "请输入奖项名称", trigger: "blur" },
                ],
                prize_type:[
                    { required: true, message: "请选择奖项内容", trigger: "blur" },
                ]
            },
            giftDialog:false,
            redDialog:false,
            prizeDialog:false,
            codeBatchOptions:[],
            codeForm:{
                code_batch:'',
                is_serial_number:false,
                order_begin:'',
                order_end:'',
                quantity:'',
                remark:''
            },
            codeRule:{
                code_batch:[
                    { required: true, message: "请选择码批次", trigger: "blur" },
                ],
                order_begin:[
                    { required: true, message: "请输入起始流水号", trigger: "blur" },
                ],
                order_end:[
                    { required: true, message: "请输入终止流水号", trigger: "blur" },
                ],
                product_batch:[
                    { required: true, message: "请选择生产批次", trigger: "blur" },
                ],
                red_envelopes_name:[
                      { required: true, message: "请选择红包", trigger: "blur" },
                ]
            },
            batchDialog:false,
            codeBatchData:[],
            tplDialog:false,
            active_idx:undefined,
            idx:undefined,
            activeName:'first',
            queryFieldForm:{
                field_name:'',
                status:'',
                pageNum:1,
                pageSize:999
            },
            fieldOption:[],
            zoneOption:[],
            dialogVisible:false,
            dialogImageUrl:'',
            tags:[],
            prize_name:undefined,
            activity_id:undefined,
            rule:{
                activity_name:[
                     { required: true, message: "请输入活动名称", trigger: "blur" },
                ],
                time:[
                    { required: true, message: "请选择活动时间", trigger: "blur" },
                ],
                tpl_name:[
                    { required: true, message: "请选择活动模板", trigger: "blur" },
                ]
            },
            workTypeOption:[],
            form:{
                activity_name:'',
                time:[],
                remark:'',
                tpl_id:'',
                tpl_name:'',
                join_condition:2,
                is_user_info:0,
                user_info_field:[],
                is_auth_tag:0,
                tags:[],
                is_user_address:0,
                is_rule_show:0,
                rule_title:'',
                rule_content:'',
                active_area:''
            }
        }
    },
    computed:{
        prize_rate(){
            if(!this.prizeForm.prize_number) return'0%'
            return (this.prizeForm.prize_number/this.sum_code_num).toFixed(2)*100+'%'
        },
        sum_code_num(){
            if(this.codeBatchData.length==0) return 0
            var arr=this.codeBatchData.map(item=>item.quantity)
            return arr.reduce((n,m) => n + m);
        }
    },
    created(){
        this.activity_id=this.$route.query.activity_id
        this.getFieldList()
        this.getZoneList()
        this.getMarketCodeBatch()
        // this.getUserTags()
        if(this.$route.query.activity_id){
            this.getActivityInfo()
        }
        this.getDicts({type:'work_type'}).then(res=>{
            this.workTypeOption=res.data
        })
    },
    methods:{
        getActivityInfo(){
            getActivityInfo({id:this.activity_id}).then(res=>{
                this.form=res.data
                this.form.time=[res.data.begin_time,res.data.end_time]
                this.form.user_info_field=res.data.user_info_field?res.data.user_info_field.map(item=>item.id):[]
                this.form.tags=JSON.parse(res.data.tags)
                this.codeBatchData=res.data.code_batch_data
                this.prizeData=res.data.prize_data
                const temp=Object.assign({},res.data)
                this.seniorForm={
                        empty_tips:temp.empty_tips,
                        repeat_tips:temp.repeat_tips,
                        invalid_tips:temp.invalid_tips,
                        is_join_limit:temp.is_join_limit,
                        work_type:temp.work_type,
                        is_open_appoint:temp.is_open_appoint,
                        day_limit_times:temp.day_limit_times,
                        limit_times_tips:temp.limit_times_tips,
                        is_user_limit:temp.is_user_limit,
                        tags:JSON.parse(temp.limit_user_tags),//用户限制标签
                        unexpected_user_tips:temp.unexpected_user_tips,
                        is_address_limit:temp.is_address_limit,
                        is_address_limit_type:temp.is_address_limit_type,
                        limit_address:[],
                        out_address_tips:temp.out_address_tips,
                        fleeing_goods:temp.fleeing_goods
                }
                this.select_sale_address=JSON.parse(res.data.select_limit_address)
                this.seniorForm.tags=JSON.parse(res.data.limit_user_tags)
                console.log(this.form)
                this.$forceUpdate()
            })
        },
        getFieldList(){
            getFieldList(this.queryFieldForm).then(res=>{
                this.fieldOption=res.data
            })
        },
        changeTime(){
            this.$forceUpdate()
        },
        handleClose(tag) {
            this.select_sale_address.splice(this.select_sale_address.indexOf(tag), 1);
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
        },
        getUserTags(){
            getUserTags({}).then(res=>{
                this.tags=res.data
            })
        },
        empty_tips(){
            this.dialogImageUrl = this.empty_example;
            this.dialogVisible = true;
        },
        pack_rule(){
            this.dialogImageUrl = this.red_pack_rule;
            this.dialogVisible = true;
        },
        repeat_tips(){
            this.dialogImageUrl = this.repeat_example;
            this.dialogVisible = true;
        },
        handleEditPrize(row){
            this.prizeDialog=true
            this.prize_name=row.prize_name
            console.log(row)
        },
        handleDelePrize(row){
            var arr=this.prizeData.filter(item=>{
                return item.prize_name!=row.prize_name
            })
            this.prizeData=arr
        },
        clickRedEnvelopes(){
            this.redDialog=true
        },
        submitPrizeForm(){
            this.$refs["prizeForm"].validate(valid => {
                if(valid){
                    var red_content=''
                    var points_content=''
                    var gift_content=''
                    if(this.prizeForm.prize_type==1){
                        var red_content='红包'+'('+'￥'+this.prizeForm.red_envelopes_name+')'
                    }
                    if(this.prizeForm.prize_type==2){
                        var points_content='积分'+'('+this.prizeForm.points+')'
                    }
                    if(this.prizeForm.prize_type==3){
                        var gift_content='自选大礼包'
                    }
                    var data={
                            prize_name:this.prizeForm.prize_name,
                            prize_number:this.prizeForm.prize_number,
                            prize_rate:this.prizeForm.prize_number?(this.prizeForm.prize_number/this.sum_code_num).toFixed(2)*100+'%':0,
                            prize_content:red_content+points_content+gift_content,
                            win_num:0,
                            prize_type:this.prizeForm.prize_type,
                            red_envelopes_name:this.prizeForm.red_envelopes_name,
                            red_envelopes_id:this.prizeForm.red_envelopes_id,
                            points:this.prizeForm.points,
                            goods_points:this.prizeForm.goods_points,
                            gift:this.prizeForm.gift,
                            valid_day:this.prizeForm.valid_day,
                            get_prize_mode:this.prizeForm.get_prize_mode,
                            is_gift_tips:this.prizeForm.is_gift_tips,
                            gift_tips:this.prizeForm.gift_tips
                    }
                    console.log(data)
                    if(!this.prize_name){
                        this.prizeData.push(data)
                    }else{
                        //更新
                        this.prizeData=this.prizeData.map(item=>{
                            return item.prize_name==this.prize_name?data:item
                        })
                    }
                    this.prizeDialog=false
                }
            })
        },
        onSubmit(val){
            this.$refs["form"].validate(valid => {
                if(valid){
                    this.$forceUpdate()
                    var data=JSON.parse(JSON.stringify(this.form))
                    console.log(this.form)
                    console.log(data)
                    data.begin_time=data.time[0]
                    data.end_time=data.time[1]
                    data.tags=JSON.stringify(data.tags)//打用户标签
                    data.user_info_field=data.user_info_field//用户收集信息字段
                    //改写字段格式
                    data.user_info_field=this.fieldOption.filter(item=>data.user_info_field.includes(item.id))
                    var data1=Object.assign({},this.seniorForm)
                    data1.limit_user_tags=data1.tags
                    data1.select_limit_address=this.select_sale_address
                    delete data1.tags
                    console.log(data)
                    var datas=Object.assign(data,data1)
                    datas.limit_user_tags=JSON.stringify(data.limit_user_tags)
                    datas.select_limit_address=JSON.stringify(data.select_limit_address)
                    datas.status=val
                    datas.code_batch_data=this.codeBatchData
                    datas.prize_data=this.prizeData
                    if(this.prizeData.length==0) return this.$message.warning('请填写奖项信息')
                    if(this.codeBatchData.length==0) return this.$message.warning('请填写赋码信息')
                    saveActivity(datas).then(res=>{
                        if(res.code==200){
                            this.$message.success(res.msg)
                            setTimeout(()=>{
                                this.close();
                            },500)
                        }else{
                            this.$message.error(res.msg)
                        }
                    })
                }
            })
        },
        selectCover(){
            this.giftDialog=true
        },
        handlePictureCardPreview(file) {
            this.dialogImageUrl = file.url;
            this.dialogVisible = true;
        },
         selectStyle(item,index){
            this.idx=index
        },
        selectRedPack(row){
            var money=''
            if(row.is_random==1){
                money=row.money
            }else{
                money=`${row.random_min_money}~${row.random_max_money}(随机)`
            }
            this.prizeForm.red_envelopes_name=money+`(${row.red_type_name} ID:${row.id})`
            this.prizeForm.red_envelopes_id=row.id
            this.redDialog=false
        },
        selectTpl(row){
            console.log(row)
            this.form.tpl_name=row.tpl_name
            this.form.tpl_id=row.id
            this.tplDialog=false
        },
         handleRemove(item,index){
            if(this.prizeForm.gift.length==1) return this.$message.warning('至少保留一张轮播图')
            this.prizeForm.gift.splice(index,1)
        },
        getZoneList(){
            getCustomerAreaList({}).then(res=>{
                this.zoneOption=res.data.filter(item=>item.parentId==0)
            })
        },
        getMarketCodeBatch(){
            getMarketCodeBatch({}).then(res=>{
               this.codeBatchOptions=res.data
            })
        },
        addPrize(){
            this.prizeDialog=true
            this.prize_name=undefined
        },
        change_prize_number(){

        },
        selectGift(row){
            this.prizeForm.gift.push({
                url:row.cover?JSON.parse(row.cover)[0]['url']:'--',
                gift_name:row.gift_name,
                gift_id:row.id
            })
            this.giftDialog=false
        },
        handleDeleBatch(row){
            this.codeBatchData=this.codeBatchOptions.filter(item=>{
               return item.batch!=row.batch
            })
        },
         start_code(val){
            if(val&&this.codeForm.order_end){
                if(parseInt(this.codeForm.order_end)<parseInt(val)){
                    this.$message.warning('请检查激活区间')
                    this.codeForm.quantity=''
                    this.codeForm.order_begin=''
                    return;
                }else{
                    this.codeForm.quantity=parseInt(this.codeForm.order_end)-parseInt(val)+1
                }
            }else{
                return;
            }
        },
        end_code(val){
            if(val&&this.codeForm.order_begin){
                if(parseInt(this.codeForm.order_begin)>parseInt(val)){
                    this.$message.warning('请检查激活区间')
                    this.codeForm.quantity=''
                    this.codeForm.order_end=''
                    return;
                }else{
                    this.codeForm.quantity=parseInt(val)-parseInt(this.codeForm.order_begin)+1
                }
            }else{
                return;
            }
        },
        submitBatchForm(){
            this.$refs["codeForm"].validate(valid => {
                if(valid){
                    var codeBatch=this.codeBatchOptions.filter(item=>item.batch==this.codeForm.code_batch)[0]
                    if(this.codeForm.is_serial_number){
                        //单独设置区间
                        if(this.codeForm.order_begin*1>=codeBatch.order_begin*1&&this.codeForm.order_end*1<=codeBatch.order_end*1){
                            //验重
                            console.log(888)
                            for(var i=0;i<this.codeBatchData.length;i++){
                                if(!(this.codeForm.order_end<this.codeBatchData[i].order_begin||this.codeForm.order_begin>this.codeBatchData[i].order_end)){
                                    return this.$message.warning('赋码区间重叠')
                                }
                            }
                            this.codeBatchData.push({
                                batch:this.codeForm.code_batch,
                                order_begin:this.codeForm.order_begin,
                                order_end:this.codeForm.order_end,
                                quantity:this.codeForm.quantity,
                                remark:this.codeForm.remark
                            })
                            this.batchDialog=false
                        }else{
                            this.$message.warning('请检查赋码区间')
                        }
                    }else{
                        //全批次 验重
                        console.log(codeBatch)
                        for(var i=0;i<this.codeBatchData.length;i++){
                            if(codeBatch.order_end<i.order_begin||codeBatch.order_begin>i.order_end){
                                continue
                            }
                            return this.$message.warning('赋码区间重叠')
                        }
                        this.codeBatchData.push({
                            batch:this.codeForm.code_batch,
                            order_begin:codeBatch.order_begin,
                            order_end:codeBatch.order_end,
                            quantity:codeBatch.order_end*1-codeBatch.order_begin*1+1,
                            remark:this.codeForm.remark
                        })
                        this.batchDialog=false
                    }
                }
            })
        },
        goBack(){
            this.close();
        },
        /** 关闭按钮 */
        close() {
            this.$store.dispatch("tagsView/delView", this.$route);
            this.$router.go(-1)
        },
        addBatch(){
            this.batchDialog=true
        },
        clickTpl(){
            this.tplDialog=true
        },
        handleClick(){

        }
    }
}
</script>

<style lang="scss" scoped>
 .item{
  width: 300px;
  height: 50px;
  background-color: #42b983;
  color: #ffffff;
}
.form{
    ::v-deep .el-upload-list--picture-card .el-upload-list__item{
        display: none;
    }
    .drag-box{
        overflow: hidden;
        background-color: #fff;
        border: 1px solid #c0ccda;
        border-radius: 6px;
        -webkit-box-sizing: border-box;
        box-sizing: border-box;
        width: 120px;
        float: left;
        cursor: pointer;
        height: 120px;
        margin: 0 15px 8px 0;
        display: block;
        position: relative;
        img{
            width: 100%;
            height: 100%;
        }
    }
    .active{
        width: 120px;
        height: 120px;
        position: absolute;
        background: black;
        display: flex;
        justify-content: center;
        align-items: center;
        font-size: 20px;
        opacity: .5;
        bottom: 0;
        left: 0;
    }
    .no-active{
        display: none;
    }
    .avatar-uploader .el-upload {
        border: 1px dashed #d9d9d9;
        border-radius: 6px;
        cursor: pointer;
        position: relative;
        overflow: hidden;
    }
    ::v-deep .avatar-uploader .el-upload:hover {
        border-color: #409EFF;
    }
    .avatar-uploader-icon {
        font-size: 28px;
        color: #8c939d;
        width: 120px;
        height: 120px;
        line-height: 120px;
        border: 1px dashed #8c939d;
        text-align: center;
    }
    .avatar {
        width: 120px;
        height: 120px;
        display: none;
    }
}
::v-deep .el-image{
    width: 100%;
}
::v-deep .image-slot{
    display: flex;
    justify-content: center;
    align-items: center;
    width: 100%;
    height:150px;
    background: #f5f7fa;
    color: #909399;
    font-size: 14px;
    font-size: 30px;
}
.img-list{
    ul li{
        display: inline-block;
        border: 1px solid #eeeeee;
        margin:0 10px 10px 0;
        cursor: pointer;
    }
    .active{
        border: 1px solid #409EFF;
    }
    .pagination-container{
        margin-bottom: 25px;
    }
}
</style>
