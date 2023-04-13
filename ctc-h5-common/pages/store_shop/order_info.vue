<template>
	<view class="container">
		<view class="top-bk">
			<u-icon name="clock" style="margin-right:20rpx" color="#ffffff" size="42"></u-icon>
			<u--text :text="orderInfo.status|status" color="#ffffff" size="24"  :bold="true"></u--text>
			<view class="pay-btn" v-if="orderInfo.status==-1" @click="pay">
				去支付
			</view>
			<view class="pay-btn" v-if="orderInfo.status==1" @click="receiving">
				确认收货
			</view>
		</view>
		<view class="address">
			<u--text :text="userInfo.address.consignee +'   '+ userInfo.address.phone" size="14"></u--text>
			<u--text :text="userInfo.address.address+' '+userInfo.address.location" size="12" color="#999"></u--text>
		</view>
		<view class="order-box">
			<view class="order-item">
				<view class="order-list" v-if="orderInfo.pay_mode=='direct'">
					<view class="goods-item">
						<u--image :showLoading="true" :src="orderInfo.order_goods_info.cover.length>0?orderInfo.order_goods_info.cover[0].url:''" width="90px" height="90px"></u--image>
						<view class="recom-info">
							<u--text :lines="2" :text="orderInfo.order_goods_info.product_name" size="13"></u--text>
							<u--text text="" color="gray" size="12"></u--text>
							<view class="recom-points">
								<!-- <u-icon name="integral" color="#ff9900" size="18"></u-icon> -->
								<!-- <u--text style="flex:none" :text="orderInfo.order_gift_info.points_num" color="#ff9900" size="12"></u--text> -->
								<u--text :text="'￥'+orderInfo.order_goods_info.sale_price" color="#ff9900" size="12"></u--text>
							</view>
							<view class="shopping-cart">
								<u--text text="x1" size="13" color="gray"></u--text>
							</view>
						</view>
					</view>
				</view>
				<view class="order-list" v-else>
					<view class="goods-item" v-for="(it,idx) in orderInfo.order_goods_info">
						<u--image :showLoading="true" :src="it.cover.length>0?it.cover[0].url:''" width="90px" height="90px"></u--image>
						<view class="recom-info">
							<u--text :lines="2" :text="it.product_name" size="13"></u--text>
							<u--text text="" color="gray" size="12"></u--text>
							<view class="recom-points">
								<!-- <u-icon name="integral" color="#ff9900" size="18"></u-icon> -->
								<!-- <u--text style="flex:none" :text="it.points_num" color="#ff9900" size="12"></u--text> -->
								<u--text :text="'￥'+it.sale_price" color="#ff9900" size="12"></u--text>
							</view>
							<view class="shopping-cart">
								<u--text :text="'x'+`${it.goods_num}`" size="13" color="gray"></u--text>
							</view>
						</view>
					</view>
				</view>
			</view>
		</view>
		<view class="order-info">
			<view class="order-info-item">
				<text style="color:#999">订单编号：</text><text>{{orderInfo.order_id}}</text>
			</view>
			<view class="order-info-item">
				<text style="color:#999">下单时间：</text><text>{{orderInfo.create_time}}</text>
			</view>
			<view class="order-info-item">
				<text style="color:#999">买家留言：</text><text>{{orderInfo.mark}}</text>
			</view>
		</view>
		<!-- 物流详情  已发货订单 -->
		<view class="order-info" v-if="orderInfo.status==1||orderInfo.status==2" style="margin-top: 20rpx;">
			<view class="order-info-item">
				<text style="color:#999">物流公司：</text><text>{{delivery_name(orderInfo.delivery_name)}}</text>
			</view>
			<view class="order-info-item">
				<text style="color:#999">物流单号：</text><text>{{orderInfo.delivery_id}}</text>
			</view>
			<view class="order-info-item">
				<text style="color:#999">发货备注：</text><text>{{orderInfo.delivery_mark}}</text>
			</view>
		</view>
		<view class="order-info" style="margin-top: 20rpx;">
			<!-- <view class="order-info-item" style="justify-content: space-between;">
				<text style="color:#999">总积分：</text><text>{{orderInfo.total_points}}</text>
			</view> -->
			<view class="order-info-item" style="justify-content: space-between;">
				<text style="color:#999">运费：</text><text>{{orderInfo.total_postage}}</text>
			</view>
			<view class="order-info-item" style="justify-content: space-between;">
				<text style="color:#999">总费用：</text><text>￥{{orderInfo.total_price}}</text>
			</view>
		</view>
		<u-modal
			content="您确认收货吗？"
			:show="cancelShow"
			showCancelButton
			closeOnClickOverlay
			@confirm="confirm"
			@cancel="cancelShow=false"
			@close="cancelShow=false"
		></u-modal>
	</view>
</template>

<script>
	import * as Api from '@/api/app/store_shop/index.js'
	import storage from '@/utils/storage'
	import { DEALERID,OPENID } from '@/store/mutation-types'
	var wxjssdk = require("jweixin-module");
	export default{
		data(){
			return{
				cancelShow:false,
				openid:storage.get(OPENID),
				order_id:'',
				dealer_id:'',
				store_id:'',
				orderInfo:{},
				logisticsOptions:[],
				url:'',
				userInfo:{
					address:{}
				}
			}
		},
		onLoad({order_id,dealer_id,store_id}) {
			this.order_id=order_id
			this.store_id=store_id
			this.dealer_id=dealer_id
			//苹果url需要单独对待
			if(uni.getSystemInfoSync().platform == 'ios'){
				this.url=storage.get('url')
			}else{
				// this.url=storage.get('url')
				this.url=location.href.split('#')[0]
			}
		},
		async onShow() {
			this.getOrderDesById()
			await this.getUserInfo()
			await this.getLogisticsCompany()
			Api.getJsConfig({dealer_id:this.dealer_id,url:this.url}).then(res=>{
				wxjssdk.config({
				  debug: false, // 开启调试模式,调用的所有api的返回值会在客户端alert出来，若要查看传入的参数，可以在pc端打开，参数信息会通过log打出，仅在pc端时才会打印。
				  appId: res.data.appId, // 必填，公众号的唯一标识
				  timestamp:res.data.timestamp, // 必填，生成签名的时间戳
				  nonceStr: res.data.nonceStr, // 必填，生成签名的随机串
				  signature: res.data.signature,// 必填，签名
				  jsApiList: res.data.jsApiList // 必填，需要使用的JS接口列表
				});
			})
		},
		filters:{
			status(val){
				if(val==0) return '待发货'
				if(val==1) return '待收货'
				if(val==2) return '已完成'
				if(val==-1) return '待付款'
			}
		},
		methods:{
			getOrderDesById(){
				Api.getOrderDesById({order_id:this.order_id}).then(res=>{
					this.orderInfo=res.data
				})
			},
			getUserInfo(){
				return Api.getUserInfo({openid:this.openid,dealer_id:this.dealer_id}).then(res=>{
					const data = Object.assign({},res.data)
					if(data.sex==0){
						data.sex='男'
					}else{
						data.sex='女'
					}
					this.userInfo=data
				})
			},
			getLogisticsCompany(){
				return Api.getLogisticsCompany({}).then(res=>{
					this.logisticsOptions=res.data
				})
			},
			delivery_name(val){
				if(!val) return '--'
				return this.logisticsOptions.filter(item=>item.dict_value==val).map(item=>item.dict_label)[0]
			},
			//收货
			receiving(){
				this.cancelShow=true
			},
			confirm(){
				const params={
					order_id:this.orderInfo.order_id,
					openid:this.openid,
					dealer_id:this.dealer_id,
					store_id:this.store_id
				}
				Api.receiving(params).then(res=>{
					if(res.status==200){
						this.cancelShow=false
						this.$toast(res.message);
						setTimeout(()=>{
							uni.$u.route({
								url:'/pages/store_shop/order',
								type:'redirect',
								params: {
									status: 0,
									store_id: this.store_id,
									dealer_id: this.dealer_id
								}
							});
						},500)
					}else{
						this.$toast(res.message);
					}
				})
			},
			//继续支付
			pay(){
				const that = this
				const params={
					order_id:this.orderInfo.order_id,
					dealer_id:this.dealer_id,
					openid:this.openid,
					store_id:this.store_id
				}
				Api.payOrder(params).then(res=>{
					const result=res.data
					if (result.result_code === "SUCCESS") {
						wxjssdk.ready(function(){
							wxjssdk.ready(function(){
								wxjssdk.chooseWXPay({
								  timestamp: result.config.timestamp, // 支付签名时间戳，注意微信 jssdk 中的所有使用 timestamp 字段均为小写。但最新版的支付后台生成签名使用的 timeStamp 字段名需大写其中的 S 字符
								  nonceStr: result.config.nonceStr, // 支付签名随机串，不长于 32 位
								  package: result.config.package, // 统一支付接口返回的prepay_id参数值，提交格式如：prepay_id=\*\*\*）
								  signType: result.config.signType, // 微信支付V3的传入 RSA ,微信支付V2的传入格式与V2统一下单的签名格式保持一致
								  paySign: result.config.paySign, // 支付签名
								  success: function (res) {
								    // 支付成功后的回调函数 将订单状态改为已支付 跳转到订单页面
									const params={
										order_id:result.order_id,
										status:0,
										openid:that.openid,
										dealer_id:that.dealer_id
									}
									Api.checkOrder(params).then(res1=>{
										if(res1.status==200){
											uni.$u.route({
												url:'/pages/store_shop/order',
												type:'redirect',
												params: {
													status: 0,
													store_id: that.store_id,
													dealer_id: that.dealer_id
												}
											});
										}
									})
								  },
								  cancel: function(res1) {
									  // 取消付款
									  if(res1.errMsg && res1.errMsg === 'chooseWXPay:cancel') {
										  //更改订单的状态(未支付) 跳转到订单页面
										  const params={
										  	order_id:result.order_id,
										  	status:-1,
										  	openid:that.openid,
										  	dealer_id:this.dealer_id
										  }
										  Api.checkOrder(params).then(res2=>{
										  	if(res2.status==200){
										  		uni.$u.route({
										  			url:'/pages/store_shop/order',
													type:'redirect',
										  			params: {
										  				status: -1,
														store_id: that.store_id,
														dealer_id: that.dealer_id
										  			}
										  		});
										  	}
										  })
									  }
								  },
								  fail: function() {
									  this.$toast('支付失败');
								  }
								});
							})
						})
					}
				})
			}
		}
	}
</script>

<style lang="scss" scoped>
	.container{
		width: 100%;
		height: auto;
		background: #eeeee;
		.order-box,.order-info{
			width: 100%;
			height: auto;
			display: flex;
			justify-content: center;
			align-items: center;
			flex-direction: column;
			padding: 20rpx;
			box-sizing: border-box;
			margin-bottom: 20rpx;
			.order-item{
				width: 100%;
				height: auto;
				display: flex;
				justify-content: center;
				align-items: center;
				flex-direction: column;
				background: white;
				border-radius: 10rpx;
				.order-list{
					width: 100%;
					height: auto;
					display: flex;
					justify-content: flex-start;
					align-items: center;
					flex-direction: column;
					padding: 20rpx;
					box-sizing: border-box;
					.order-time{
						width: 100%;
						height: auto;
						display: flex;
						justify-content: space-between;
						align-items: center;
						font-size: 26rpx;
						margin: 10rpx 0;
						color: $uni-text-color-grey;
					}
					.sum-box,.set-box{
						width: 100%;
						display: flex;
						justify-content: flex-end;
						align-items: center;
						font-size: 26rpx;
						color: $uni-text-color;
						margin-top: 15rpx;
					}
					.goods-item{
						width: 100%;
						height: 200rpx;
						display: flex;
						justify-content: space-between;
						align-items: center;
						.recom-info{
							width: calc(100% - 100px);
							height: 85%;
							display: flex;
							flex-direction: column;
							justify-content: flex-start;
							position: relative;
							.shopping-cart{
								position: absolute;
								right: 10rpx;
								bottom: 10rpx;
							}
						}
					}
					.recom-points{
						width: 100%;
						display: flex;
						justify-content: flex-start;
						align-items: center;
						flex-wrap: nowrap;
					}
				}
			}
		}
		.top-bk{
			width: 100%;
			display: flex;
			justify-content: center;
			align-items: center;
			background-color: #e8c269;
			height: 280rpx;
			padding: 28px 15px 0 15px;
			position: relative;
			.pay-btn{
				width: 150rpx;
				height: 28px;
				padding: 0 15px;
				line-height: 28px;
				background-color: #fff;
				text-align: center;
				border-radius: 14px;
				border-color: #666;
				cursor: pointer;
				-webkit-user-select: none;
				user-select: none;
				color: #c7a157;
				position: absolute;
				right: 100rpx;
			}
		}
		.address{
			width: 95%;
			height: 150rpx;
			display: flex;
			justify-content: flex-start;
			padding: 20rpx;
			box-sizing: border-box;
			// align-items: center;
			flex-direction: column;
			background: white;
			border-radius: 20rpx;
			margin: 0 auto;
			margin-top: -60rpx;
			position: relative;
		}
		.order-info{
			width: 95%;
			margin: 0 auto;
			background: white;
		}
		.order-info-item{
			font-size: 26rpx;
			width: 100%;
			display: flex;
			justify-content: flex-start;
			align-items: center;
			margin-bottom: 10rpx;
		}
	}
		
</style>