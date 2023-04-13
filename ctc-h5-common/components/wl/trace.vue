<template>
	<view class="page-items">
		<block v-for="(item, index) in items" :key="index">
			 <!-- 图片组 -->
			  <block v-if="item.type === 'image'&&item.banner_type=='1'&&item.is_banner==1">
				<Images :itemStyle="item.style" :params="item.params" :dataList="item.data" />
			  </block>
			  <!-- 轮播图 -->
			  <block v-if="item.type === 'banner'&&item.banner_type=='2'&&item.is_banner==1">
				<Banner :itemStyle="item.style" :params="item.params" :dataList="item.data" />
			  </block>
			  <!-- tab栏目 -->
			 <block v-if="item.type === 'tabs'">
				  <u-tabs :list="tabsData" 
				  :inactiveStyle="{
					  fontSize:'16px'
				  }"
				  :activeStyle="{
					color: '#303133',
					fontSize:'16px',
					fontWeight: 'bold',
					transform: 'scale(1.05)'
				  }" :scrollable="false" :current="curTab" active-color="#FA2209" :duration="0.2"
				  @change="onChangeTab"/>
			  </block>
		</block>
		<block>
		  <view class="trace-box" v-show="curTab==1">
			  <view class="trace-top" v-show="is_active">
				  <view class="query-title">
				  	<u--text :lines="1" :text="items.batch_content.trace_log_title" color="#ffffff" size="16"></u--text>
				  </view>
				  <view class="trace-content">
				  		<text>{{items.batch_content.trace_log_tips}}</text>
				  </view>
			  </view>
			  <view class="trace-bottom" v-show="is_active">
				  <!-- 物流基本信息 -->
				  <view style="width: 100%;" class="trace-title">
					  <text class="nav-line"></text>基本信息
				  </view>
				  <view class="order-content-box" v-if="items.batch_content.data.log[0]">
				  	<view class="table-item">
				  		<text style="width:40%;" class="content-item">状态</text>
				  		<text style="width:60%;" class="content-item">{{items.batch_content.data.log[4]}}</text>
				  	</view>
				  	<view class="table-item">
				  		<text style="width:40%;" class="content-item">标签类型</text>
				  		<text style="width:60%;" class="content-item">{{items.batch_content.data.info.code_type==1?'大标':'小标'}}</text>
				  	</view>
				  	<view class="table-item">
				  		<text style="width:40%;" class="content-item">批号</text>
				  		<text style="width:60%;" class="content-item">{{items.batch_content.data.info.batch}}</text>
				  	</view>
				  	<view class="table-item">
				  		<text style="width:40%;" class="content-item">包装类型</text>
				  		<text style="width:60%;" class="content-item">{{items.batch_content.data.info.scale.join('/')}}</text>
				  	</view>
				  	<view class="table-item">
				  		<text style="width:40%;" class="content-item">产品代码</text>
				  		<text style="width:60%;" class="content-item">{{items.batch_content.data.log[0]['barcode']}}</text>
				  	</view>
				  	<view class="table-item">
				  		<text style="width:40%;" class="content-item">产品名称</text>
				  		<text style="width:60%;" class="content-item">{{items.batch_content.data.log[0]['product_name']}}</text>
				  	</view>
				  	<view class="table-item">
				  		<text style="width:40%;" class="content-item">产品规格</text>
				  		<text style="width:60%;" class="content-item">{{items.batch_content.data.log[0]['specifications']}}</text>
				  	</view>
				  	<view class="table-item">
				  		<text style="width:40%;" class="content-item">产品数量</text>
				  		<text style="width:60%;" class="content-item">{{items.batch_content.data.info['rk_num']}}</text>
				  	</view>
				  	<view class="table-item">
				  		<text style="width:40%;" class="content-item">生产日期</text>
				  		<text style="width:60%;" class="content-item">{{items.batch_content.data.log[0]['manufacture_time']}}</text>
				  	</view>
				  	<view class="table-item">
				  		<text style="width:40%;" class="content-item">有效日期</text>
				  		<text style="width:60%;" class="content-item">{{items.batch_content.data.log[0]['validity_time']}}</text>
				  	</view>
				  </view>
				  <view class="trace-title" style="margin: 20rpx 0;">
					<text class="nav-line"></text>{{items.batch_content.trace_info_title}}
				  </view>
				  <!-- 折叠面板溯源信息 -->
					  <u-collapse
						  @change="change"
						  @close="close"
						  :border="false"
						  @open="open"
						>
						<!-- 入库信息 -->
						<u-collapse-item  :border="false" class="trace-col-title" title="入库信息">
						   <view class="order-content-box" v-if="items.batch_content.data.log[0]">
						   	<view class="table-item">
						   		<text style="width:40%;" class="content-item">日期</text>
						   		<text style="width:60%;" class="content-item">{{items.batch_content.data.log[0]['create_time']}}</text>
						   	</view>
						   	<view class="table-item">
						   		<text style="width:40%;" class="content-item">入库单号</text>
						   		<text style="width:60%;" class="content-item">{{items.batch_content.data.log[0]['rk_order']}}</text>
						   	</view>
						   	<view class="table-item">
						   		<text style="width:40%;" class="content-item">入库仓库</text>
						   		<text style="width:60%;" class="content-item">{{warehouse_id(items.batch_content.data.log[0]['warehouse_id'])}}</text>
						   	</view>
						   	<view class="table-item">
						   		<text style="width:40%;" class="content-item">入库产品</text>
						   		<text style="width:60%;" class="content-item">{{items.batch_content.data.log[0]['product_name']}}</text>
						   	</view>
						   	<view class="table-item">
						   		<text style="width:40%;" class="content-item">操作人</text>
						   		<text style="width:60%;" class="content-item">{{items.batch_content.data.log[0]['create_by']||'--'}}</text>
						   	</view>
						   </view>
						</u-collapse-item>
						<u-collapse-item  :border="false" v-if="items.batch_content.data.log[1]" class="trace-col-title" title="出库信息">
							<view class="order-content-box">
								<view class="table-item">
									<text style="width:40%;" class="content-item">日期</text>
									<text style="width:60%;" class="content-item">{{items.batch_content.data.log[1]['create_time']}}</text>
								</view>
								<view class="table-item">
									<text style="width:40%;" class="content-item">出货单号</text>
									<text style="width:60%;" class="content-item">{{items.batch_content.data.log[1]['ck_order']}}</text>
								</view>
								<view class="table-item">
									<text style="width:40%;" class="content-item">出货仓库</text>
									<text style="width:60%;" class="content-item">{{warehouse_id(items.batch_content.data.log[1]['warehouse_id'])}}</text>
								</view>
								<view class="table-item">
									<text style="width:40%;" class="content-item">出货产品</text>
									<text style="width:60%;" class="content-item">{{items.batch_content.data.log[1]['product_name']}}</text>
								</view>
								<view class="table-item">
									<text style="width:40%;" class="content-item">收货客户</text>
									<text style="width:60%;" class="content-item">{{items.batch_content.data.log[1]['customer_name']}}</text>
								</view>
								<view class="table-item">
									<text style="width:40%;" class="content-item">是否赠品</text>
									<text style="width:60%;" class="content-item">{{items.batch_content.data.log[1]['is_gift']==0?'否':'是'}}</text>
								</view>
								<view class="table-item">
									<text style="width:40%;" class="content-item">操作人</text>
									<text style="width:60%;" class="content-item">{{items.batch_content.data.log[1]['create_by']||'--'}}</text>
								</view>
							</view>
						</u-collapse-item>
						<u-collapse-item  :border="false" v-if="items.batch_content.data.log[2]" class="trace-col-title" title="退货信息">
							<view class="order-content-box">
								<view class="table-item">
									<text style="width:40%;" class="content-item">日期</text>
									<text style="width:60%;" class="content-item">{{items.batch_content.data.log[2]['create_time']}}</text>
								</view>
								<view class="table-item">
									<text style="width:40%;" class="content-item">退货单号</text>
									<text style="width:60%;" class="content-item">{{items.batch_content.data.log[2]['th_order']}}</text>
								</view>
								<view class="table-item">
									<text style="width:40%;" class="content-item">退货客户</text>
									<text style="width:60%;" class="content-item">{{items.batch_content.data.log[2]['customer_name']}}</text>
								</view>
								<view class="table-item">
									<text style="width:40%;" class="content-item">退货产品</text>
									<text style="width:60%;" class="content-item">{{items.batch_content.data.log[2]['product_name']}}</text>
								</view>
							</view>
						</u-collapse-item>
						<u-collapse-item  :border="false" v-if="items.batch_content.data.log[3]" class="trace-col-title" title="调仓信息">
							<view class="order-content-box">
								<view class="table-item">
									<text style="width:40%;" class="content-item">日期</text>
									<text style="width:60%;" class="content-item">{{items.batch_content.data.log[3]['create_time']}}</text>
								</view>
								<view class="table-item">
									<text style="width:40%;" class="content-item">调仓单号</text>
									<text style="width:60%;" class="content-item">{{items.batch_content.data.log[3]['dc_order']}}</text>
								</view>
								<view class="table-item">
									<text style="width:40%;" class="content-item">调出仓库</text>
									<text style="width:60%;" class="content-item">{{warehouse_id(items.batch_content.data.log[3]['out_warehouse_id'])}}</text>
								</view>
								<view class="table-item">
									<text style="width:40%;" class="content-item">调入仓库</text>
									<text style="width:60%;" class="content-item">{{warehouse_id(items.batch_content.data.log[3]['in_warehouse_id'])}}</text>
								</view>
								<view class="table-item">
									<text style="width:40%;" class="content-item">入库产品</text>
									<text style="width:60%;" class="content-item">{{items.batch_content.data.log[3]['product_name']}}</text>
								</view>
							</view>
						</u-collapse-item>	
					  </u-collapse>
			  </view>
			  <!-- 查询密码框 -->
			  <view class="trace-bottom" v-show="!is_active">
				  <u--form  style="width: 100%;" labelPosition="left" :model="model"  ref="form">
					<view style="display: flex;justify-content: space-between;align-items: center;width: 100%;">
						<u-form-item  label="" style="width: 100%" labelWidth="80px" :borderBottom="false" prop="password"  ref="item">
							<u--input
								style="height:55rpx"
								v-model="model.password"
								clearable
								placeholder="请输入查询密码"
								confirm-type="search"
								@confirm="search"
								prefixIconStyle="font-size: 22px;color: #909399"
							></u--input>
						</u-form-item>
					</view>
				  </u--form>
				  <u-button  type="primary" size="medium" @click="search()" text="查询"></u-button>
			  </view>
		  </view>
		 
		  <!-- 产品内容 -->
		  <view class="product-box" v-show="curTab==0&&items.product_info.data.product_name">
			  <view class="product-box-title">
				<u--text :lines="1" :text="items.product_info.data.product_title" color="#303133" size="16"></u--text>
			  </view>
			  <view class="product-box-banner" v-if="items.product_info.data.product_name">
				<u-swiper
				  :list="items.product_info.data.cover"
				  keyName="url"
				  v-show="items.product_info.is_show.is_product_img==1"
				  indicator
				  height="320"
				  indicatorMode="line"
				  circular
				></u-swiper>
				<view class="product-box-info" v-if="items.product_info.data.product_name">
					<view class="product-box-info-item" v-show="items.product_info.is_show.is_product_code==1">
						<view class="info-item-title">产品编号:</view>
						<view style="width: 60%;"><u--text style="width: 100%;" size="16" :lines="1" :text="items.product_info.data.code"></u--text></view>
					</view>
					<view class="product-box-info-item" v-show="items.product_info.is_show.is_product_name==1">
						<view class="info-item-title">产品名称:</view>
						<view style="width: 60%;"><u--text style="width: 100%;" size="16" :lines="1" :text="items.product_info.data.product_name"></u--text></view>
					</view>
					<view class="product-box-info-item" v-show="items.product_info.is_show.is_product_weight==1">
						<view class="info-item-title">重量:</view>
						<view style="width: 60%;"><u--text style="width: 100%;" size="16" :lines="1" :text="items.product_info.data.weight"></u--text></view>
					</view>
					<view class="product-box-info-item" v-show="items.product_info.is_show.is_product_price==1">
						<view class="info-item-title">价格:</view>
						<view style="width: 60%;"><u--text style="width: 100%;" size="16" :lines="1" :text="items.product_info.data.price"></u--text></view>
					</view>
				</view>
			  </view>
		  </view>
		  <!-- 产品详情 -->
		  <view class="trace-bottom"  v-show="curTab==0&&items.product_info.is_show.is_product_des==1&&items.product_info.data.product_name" style="width: 95%;margin: 0 auto;">
		  	<text class="trace-title">产品详情</text>
			<u-parse :content="items.product_info.data.details"></u-parse>
		  </view>
		  <u-empty
			mode="data"
			icon="https://cdn.uviewui.com/uview/empty/data.png"
			text="暂无商品信息"
			v-show="curTab==0&&!items.product_info.data.product_name"
			>
			</u-empty>
		  <!-- 企业信息 -->
		  <view class="company-box" v-show="curTab==2" style="min-height: 500rpx;">
			  <text class="trace-title">{{items.company_info.data.company_title}}</text>
			  <view class="product-box-banner">
				  <view class="product-box-info">
					<view class="product-box-info-item">
						<view class="info-item-title" style="width: 20%;">企业名称:</view>
						<view style="width: 80%;"><u--text style="width: 100%;" size="14" :lines="2" :text="items.company_info.data.company_info.company"></u--text></view>
					</view>
					<view class="product-box-info-item" v-show="items.company_info.is_show.is_dealer_name==1">
						<view class="info-item-title" style="width: 20%;">认证品牌:</view>
						<view style="width: 80%;"><u--text style="width: 100%;" size="14" :lines="2" :text="items.company_info.data.company_info.dealer_name"></u--text></view>
					</view>
					<view class="product-box-info-item" v-show="items.company_info.is_show.is_address==1">
						<view class="info-item-title" style="width: 20%;">联系地址:</view>
						<view style="width: 80%;"><u--text style="width: 100%;" size="14" :lines="2" :text="items.company_info.data.company_info.address"></u--text></view>
					</view>
					<view class="product-box-info-item" v-show="items.company_info.is_show.is_telephone==1">
						<view class="info-item-title" style="width: 20%;">客服电话:</view>
						<view style="width: 80%;"><u--text style="width: 100%;" size="14" :lines="2" :text="items.company_info.data.company_info.telephone"></u--text></view>
					</view>
					<view class="product-box-info-item" v-show="items.company_info.is_show.is_email==1">
						<view class="info-item-title" style="width: 20%;">邮箱:</view>
						<view style="width: 80%;"><u--text style="width: 100%;" size="14" :lines="2" :text="items.company_info.data.company_info.email"></u--text></view>
					</view>
					<view class="product-box-info-item" v-show="items.company_info.is_show.is_website==1">
						<view class="info-item-title" style="width: 20%;">官方网站:</view>
						<view style="width: 80%;"><u--text style="width: 100%;" size="14" :lines="2" :text="items.company_info.data.company_info.website"></u--text></view>
					</view>
				  </view>
				</view>
		  </view>
		  <!-- 视频 -->
		  <block>
			<view class="trace-box" v-if="items.video_info.is_video==1">
			  <view class="trace-bottom">
				  <text class="video-title">{{items.video_info.data.title}}</text>
				  <u-swiper
					  :list="items.video_info.data.video"
					  keyName="url"	
					  :autoplay="false"
				  ></u-swiper>
			  </view>
			</view>
		  </block>
		</block>
		<!-- 查询记录弹窗 -->
		<block>
			<u-popup 
			:safeAreaInsetBottom="true"
			:safeAreaInsetTop="true"
			:show="hisShow" 
			mode="center" 
			:closeable="true"  
			@close="hisClose" 
			@open="hisOpen">
				<view
					class="u-popup-slot"
					:style="{
						maxHeight:'600rpx',
						minHeight:'200rpx',
						height:'auto',
						width: ['bottom', 'top'].includes('center') ? '750rpx' : '700rpx',
						padding: ['left', 'right'].includes('center') ? '480rpx' : '40rpx',
						boxSizing:'border-box'
					}"
				>
				<!-- 查询记录列表 -->
				<u-list style="height: 100%;">
					<u-list-item v-for="(item, index) in queryLog" :key="index">
						<u-cell :title="item.nickname" :value="item.create_time">
							<u-avatar
								slot="icon"
								shape="circle"
								size="30"
								:src="item.headimgurl"
							></u-avatar>
						</u-cell>
					</u-list-item>
				</u-list>
				</view>
			</u-popup>
		</block>
	</view>
</template>

<script>
	import Images from './image'
	import Banner from './banner'
	import * as Api from '@/api/app/wl/index.js'
	export default{
		name: "Trace",
		components:{
			Images,
			Banner,
		},
		props: {
		  items: {
			type: Object,
			default:{}
		  },
		  warehouse:{
			  type:Array,
			  default:[]
		  }
		},
		data(){
			return{
				queryWareForm:{
					keywords:'',
					pageNum:1,
					pageSize:999
				},
				is_active:false,
				model:{
					password:''
				},
				warehouseOption:[],
				// 当前标签索引
				curTab: 0,
				value:9,
				hisShow:false,
				list3: [
                    'https://cdn.uviewui.com/uview/swiper/swiper3.png',
                    'https://cdn.uviewui.com/uview/swiper/swiper2.png',
                    'https://cdn.uviewui.com/uview/swiper/swiper1.png',
                ],
				content: `
					<p>露从今夜白，月是故乡明</p>
					<img src="https://cdn.uviewui.com/uview/swiper/2.jpg" />
				`,
				company_info:{}
			}
		},
		created(){
			// console.log(this.items.query_params)
			// this.queryWareForm.dealer_id=this.items.query_params.dealer_id
			
		},
		computed:{
			tabsData(){
				var newArr=[]
				var data=this.items.tabs.data
				var arr=data.filter(item=>item.is_show==1)
				arr.map(item=>{
					newArr.push({
						name:item.title
					})
				})
				return newArr
			},
			queryLog(){
				return this.items.batch_content.trace_log
			}
		},
		methods:{
			warehouse_id(val){
				return this.warehouse.filter(item=>item.id==val).map(item=>item.warehouse_name)[0]
			},
			search(){
				if(this.model.password.trim().length!=6) return uni.$u.toast('查询密码为6位')
				this.items.query_params.password=this.model.password
				Api.queryLogisticsInfo(this.items.query_params).then(res=>{
					if(res.status==200){
						const { data: { page,items } } = res//双解构
						this.items =items
						this.is_active=true
						uni.$u.toast(res.message)
						this.$forceUpdate()
					}else{
						this.is_active=false
					   uni.$u.toast(res.message)
					}
				})
			},
			onChangeTab(val){
				this.curTab=val.index
				this.$emit('tabClick',this.curTab)
			},
			history(){
				this.hisShow=true
			},
			open(e) {
			  // console.log('open', e)
			},
			close(e) {
			  // console.log('close', e)
			},
			hisClose(){
				this.hisShow=false
			},
			hisOpen(){
				this.hisShow=true
			},
			change(e) {
			  // console.log('change', e)
			}
		},
	}
</script>

<style lang="scss" scoped>
	.trace-box{
		width: 95%;
		height: auto;
		margin: 0 auto;
		display: flex;
		flex-direction: column;
		justify-content: center;
		.trace-top{
			width: 100%;
			height: 300rpx;
			background-color: $u-primary;
			display: flex;
			justify-content: center;
			flex-direction: column;
			border-radius: 16rpx;
			position: relative;
		}
		.query-title{
			position: absolute;
			left: 30rpx;
			top: 30rpx;
		}
		.trace-content{
			width: 100%;
			height: 300rpx;
			display: flex;
			justify-content: flex-start;
			align-items: center;
			color:white;
			border-radius: 20rpx;
			padding: 0 20rpx;
			font-size: 28rpx;
			box-sizing: border-box;
		}
		.trace-history{
			width: 100%;
			height: 100rpx;
			display: flex;
			justify-content: flex-end;
			align-items: center;
			background-color: white;
			color: $u-primary;
			padding: 0 20rpx;
			box-sizing: border-box;
		}
	}
	.trace-bottom{
		width: 100%;
		min-height: 200px;
		margin-top: 20rpx;
		background-color: white;
		padding: 20rpx;
		box-sizing: border-box;
		.nav-line{
			width: 6rpx;
			height: 32rpx;
			background: $uni-color-primary;
			margin: 0 6rpx;
		}
		.trace-title,.video-title{
			font-size: 34rpx;
			font-weight: 500;
			display: inline-block;
			color:#303133 ;
			display: flex;
			width: 100%;
			justify-content: flex-start;
			align-items: center;
			margin-bottom: 20rpx;
			
		}
		.order-content-box{
			width: 100%;
			display: flex;
			justify-content: center;
			align-items: center;
			flex-direction: column;
			box-sizing: border-box;
			margin-top: 20rpx;
			border: 1px solid #c8c7cc;
			.table-head{
				width: 100%;
				height: 50rpx;
				display: flex;
				justify-content: center;
				align-items: center;
				// background: #caddf2;
				font-size: 14px;
				.head-item{
					height: 100%;
					display: flex;
					justify-content: center;
					align-items: center;
					padding: 6rpx;
					border-right: 1px solid #c8c7cc;
					box-sizing: border-box;
				}
			}
			.table-item{
				width: 100%;
				height: 90rpx;
				display: flex;
				justify-content: center;
				align-items: center;
				font-size: 14px;
				border-top: 1px solid #c8c7cc;
				.content-item{
					height: 100%;
					display: flex;
					justify-content: center;
					word-break:break-all;
					align-items: center;
					border-right: 1px solid #c8c7cc;
					padding: 6rpx;
					box-sizing: border-box;
					.u-button--mini{
						min-width: 30px;
					}
				}
			}
		}
	}
	.trace-bottom ::v-deep .u-cell__title-text{
			font-size: 28rpx;
	}
	.trace-bottom ::v-deep .u-cell__body{
		padding: 20rpx 0;
	}
	.u-popup-slot {
		width: 200px;
		height: 150px;
		@include flex;
		justify-content: center;
		align-items: center;
	}
	.auth-box{
		width: 95%;
		height: auto;
		min-height: 350rpx;
		margin: 0 auto;
		display: flex;
		flex-direction: column;
		justify-content: center;
		background-color: $u-primary;
		border-radius: 20rpx;
		padding: 0 20rpx;
		box-sizing: border-box;
		position: relative;
		.auth-title{
			position: absolute;
			top: 30rpx;
			left: 30rpx;
		}
		.auth-result{
			position: absolute;
			bottom: 20rpx;
			left: 30rpx;
		}
		.auth-icon{
			width: 100%;
			height: auto;
			display: flex;
			justify-content: center;
			align-items: center;
		}
	}
	.product-box,.company-box{
		width: 95%;
		min-height: 300rpx;
		margin: 0 auto;
		margin-bottom: 20rpx;
		display: flex;
		background-color: white;
		flex-direction: column;
		align-items: flex-start;
		border-radius: 20rpx;
		padding:20rpx;
		box-sizing: border-box;
		.trace-title{
			font-size: 32rpx;
			color: #303133;
		}
		.product-box-title{
			width: 100%;
			position: relative;
		}
		.product-box-banner{
			width: 100%;
			margin-top: 20rpx;
		}
		.product-box-info{
			display: flex;
			flex-direction: column;
			margin-top: 10rpx;
		}
		.product-box-info-item{
			width: 100%;
			display: flex;
			flex-wrap: nowrap;
			justify-content: flex-start;
			align-items:center;
			margin: 10rpx;
			.info-item-title{
				width: 20%;
				font-size: 14px;
				color: $u-primary;
			}
		}
	}
</style>
