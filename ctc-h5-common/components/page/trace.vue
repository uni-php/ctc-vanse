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
		  <view class="trace-box" v-show="curTab==0">
			  <view class="trace-top">
				  <view class="query-title">
				  	<u--text :lines="1" :text="items.batch_content.trace_log_title" color="#ffffff" size="16"></u--text>
				  </view>
				  <view class="trace-content">
				  		<text>{{items.batch_content.trace_log_tips}}</text>
				  </view>
				  <view class="trace-history" v-show="items.batch_content.is_log_show==1">
						<text @click="history">历史记录</text>
				  </view>
			  </view>
			  <view class="trace-bottom">
				  <text class="trace-title">{{items.batch_content.trace_info_title}}</text>
				  <!-- 折叠面板溯源信息 -->
					  <u-collapse
						  @change="change"
						  @close="close"
						  :border="false"
						  @open="open"
						>
						<u-collapse-item v-for="(it,idx) in items.batch_content.data" :key="idx" :border="false" class="trace-col-title" :title="it.title" name="it.name">
						  <!-- <text v-html="it.content" class="u-collapse-content"></text> -->
						  <u-parse :content="it.content"></u-parse>
						</u-collapse-item>
					  </u-collapse>
			  </view>
		  </view>
		  <!-- 防伪查询 -->
		  <view class="auth-box" v-show="curTab==1">
			<view class="auth-title">
				<u--text :lines="1" :text="items.security_info.auth_title" color="#ffffff" size="16"></u--text>
			</view>
			<view class="auth-icon">
				<u-icon v-if="items.security_info.is_first==0" name="info-circle" color="#ffffff" size="60"></u-icon>
				<u-icon name="checkmark-circle" color="#ffffff" size="60" v-else></u-icon>
			</view> 
			<view class="auth-result">
				<u--text :lines="3" :text="items.security_info.data" color="#ffffff" size="14"></u--text>
			</view>
		  </view>
		  <!-- 产品内容 -->
		  <view class="product-box" v-show="curTab==2">
			  <view class="product-box-title">
				<u--text :lines="1" :text="items.product_info.data.product_title" color="#303133" size="16"></u--text>
				<u--text v-show="items.product_info.is_show.is_buy==1" style="position: absolute;right: 0;top: 0;" type="primary" text="前往购买"></u--text>
			  </view>
			  <view class="product-box-banner">
				<u-swiper
				  :list="items.product_info.data.cover"
				  keyName="url"
				  v-show="items.product_info.is_show.is_product_img==1"
				  indicator
				  height="320"
				  indicatorMode="line"
				  circular
				></u-swiper>
				<view class="product-box-info">
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
		  <view class="trace-bottom"  v-show="curTab==2&&items.product_info.is_show.is_product_des==1" style="width: 95%;margin: 0 auto;">
		  	<text class="trace-title">产品详情</text>
			<u-parse :content="items.product_info.data.details"></u-parse>
		  </view>
		  <!-- 企业信息 -->
		  <view class="company-box" v-show="curTab==3" style="min-height: 500rpx;">
			  <text class="trace-title">{{items.company_info.data.company_title}}</text>
			  <view class="product-box-banner">
				  <view class="product-box-info">
					<view class="product-box-info-item">
						<view class="info-item-title" style="width: 40%;">企业名称:</view>
						<view style="width: 60%;"><u--text style="width: 100%;" size="14" :lines="1" :text="items.company_info.data.company_info.company"></u--text></view>
					</view>
					<view class="product-box-info-item" v-show="items.company_info.is_show.is_business_license_code==1">
						<view class="info-item-title" style="width: 40%;">企业营业执照编号:</view>
						<view style="width: 60%;"><u--text style="width: 100%;" size="14" :lines="1" :text="items.company_info.data.company_info.business_license_code||'暂无'"></u--text></view>
					</view>
					<view style="margin-bottom: 80px;" class="product-box-info-item" v-show="items.company_info.is_show.is_business_license_url==1">
						<view class="info-item-title" style="width: 40%;">营业执照照片:</view>
						<view style="width: 60%;">
							<u--image v-if="items.company_info.data.company_info.business_license_url" :showLoading="true" :src="items.company_info.data.company_info.business_license_url" width="80px" height="80px"></u--image>
							<u--image src="https://cdn.uviewui.com/uview/album/1.jpg" v-else>
								<view slot="error" style="font-size: 24rpx;">加载失败</view>
							</u--image>
						</view>
					</view>
					<view class="product-box-info-item" v-show="items.company_info.is_show.is_dealer_name==1">
						<view class="info-item-title" style="width: 40%;">认证品牌:</view>
						<view style="width: 60%;"><u--text style="width: 100%;" size="14" :lines="1" :text="items.company_info.data.company_info.dealer_name"></u--text></view>
					</view>
					<view class="product-box-info-item" v-show="items.company_info.is_show.is_address==1">
						<view class="info-item-title" style="width: 40%;">联系地址:</view>
						<view style="width: 60%;"><u--text style="width: 100%;" size="14" :lines="1" :text="items.company_info.data.company_info.address"></u--text></view>
					</view>
					<view class="product-box-info-item" v-show="items.company_info.is_show.is_telephone==1">
						<view class="info-item-title" style="width: 40%;">客服电话:</view>
						<view style="width: 60%;"><u--text style="width: 100%;" size="14" :lines="1" :text="items.company_info.data.company_info.telephone"></u--text></view>
					</view>
					<view class="product-box-info-item" v-show="items.company_info.is_show.is_email==1">
						<view class="info-item-title" style="width: 40%;">邮箱:</view>
						<view style="width: 60%;"><u--text style="width: 100%;" size="14" :lines="1" :text="items.company_info.data.company_info.email"></u--text></view>
					</view>
					<view class="product-box-info-item" v-show="items.company_info.is_show.is_website==1">
						<view class="info-item-title" style="width: 40%;">官方网站:</view>
						<view style="width: 60%;"><u--text style="width: 100%;" size="14" :lines="1" :text="items.company_info.data.company_info.website"></u--text></view>
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
	import * as Api from '@/api/app/trace/index.js'
	export default{
		name: "Trace",
		components:{
			Images,
			Banner,
		},
		props: {
		  items: {
			type: Array,
			default () {
			  return []
			}
		  }
		},
		data(){
			return{
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
			height: 400rpx;
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
		.trace-title,.video-title{
			font-size: 32rpx;
			font-weight: 500;
			display: inline-block;
			margin-bottom: 20rpx;
			
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
			margin-top: 10rpx;
			.info-item-title{
				width: 20%;
				font-size: 14px;
				color: $u-primary;
			}
		}
	}
</style>
