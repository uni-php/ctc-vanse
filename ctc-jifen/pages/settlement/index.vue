<template>
	<view class="container">
		<view class="address-box">
			<view class="address-top">
				<text>{{userInfo.address.consignee}}</text>
				<text>{{userInfo.address.phone}}</text>
			</view>
			<view class="address-bot">
				<view style="display: flex;flex-wrap: nowrap;"><u-icon name="map" size="13"></u-icon>{{userInfo.address.location}}</view>
			</view>
		</view>
		<u-gap height="5" bgColor="#eeeeee" marginTop="5"></u-gap>
		<!-- 商品列表 -->
		<view class="goods-box" v-if="goods_id">
			<view class="goods-item">
				<u--image :showLoading="true" :src="goods_info.cover.length>0?goods_info.cover[0].url:''" width="90px" height="90px"></u--image>
				<view class="recom-info">
					<u--text :lines="2" :text="goods_info.gift_name" size="13"></u--text>
					<u--text text="" color="gray" size="12"></u--text>
					<view class="recom-points">
						<u-icon name="integral" color="#ff9900" size="18"></u-icon>
						<u--text style="flex:none" :text="goods_info.points_num" color="#ff9900" size="12"></u--text>
						<u--text v-if="goods_info.type==2" :text="'+￥'+goods_info.money" color="#ff9900" size="12"></u--text>
					</view>
					<view class="shopping-cart">
						<u--text text="x1" size="13" color="gray"></u--text>
					</view>
				</view>
			</view>
		</view>
		<view class="goods-box" v-else>
			<view class="goods-item" v-for="(item,index) in order_info">
				<u--image :showLoading="true" :src="item.cover.length>0?item.cover[0].url:''" width="90px" height="90px"></u--image>
				<view class="recom-info">
					<u--text :lines="2" :text="item.gift_name" size="13"></u--text>
					<u--text text="" color="gray" size="12"></u--text>
					<view class="recom-points">
						<u-icon name="integral" color="#ff9900" size="18"></u-icon>
						<u--text style="flex:none" :text="item.points_num" color="#ff9900" size="12"></u--text>
						<u--text v-if="item.type==2" :text="'+￥'+item.money" color="#ff9900" size="12"></u--text>
					</view>
					<view class="shopping-cart">
						<u--text :text="`x${item.gift_num}`" size="13" color="gray"></u--text>
					</view>
				</view>
			</view>
		</view>
		<u-gap height="5" bgColor="#eeeeee" marginTop="5"></u-gap>
		<view class="intro-box">
			<u--textarea
				placeholder="不低于3个字"
				v-model="intro"
				count
			></u--textarea>
		</view>
		<u-gap height="5" bgColor="#eeeeee" marginTop="5"></u-gap>
		<view class="price-box">
			<view class="price">
				<text>商品金额</text>
				<text style="color: #fa2209;">￥{{orderTotalPrice}}</text>
			</view>
			<view class="points">
				<text>积分</text>
				<view style="display: flex;flex-wrap: nowrap;"><u-icon name="integral" color="#ff9900" size="18"></u-icon><text style="color: #fa2209;">{{orderTotalPoints}}</text></view>
			</view>
			<view class="price">
				<text>运费</text>
				<text style="color: #fa2209;">￥{{freight}}</text>
			</view>
			<view class="sum-price">
				<text>应付：</text><text style="color: #fa2209;">￥{{orderTotalPrice + freight}} + </text>
				<view style="display: flex;flex-wrap: nowrap;"><u-icon name="integral" color="#ff9900" size="18"></u-icon><text style="color: #fa2209;">{{orderTotalPoints}}</text></view>
			</view>
		</view>
		<view class="submit-btn" @click="submit">
			提交订单
		</view>
	</view>
</template>

<script>
	import * as Api from '@/api/app/points/index.js'
	import storage from '@/utils/storage'
	import { DEALERID,OPENID } from '@/store/mutation-types'
	var wxjssdk = require("jweixin-module");
	export default{
		data(){
			return{
				url:'',
				intro:'',
				openid:storage.get(OPENID),
				cartIds:'',
				goods_id:'',
				goods_info:{
					cover:[]
				},
				order_info:[],
				userInfo:{
					address:{}
				}
			}
		},
		onLoad({cartIds,goods_id}) {
			this.cartIds=cartIds
			this.goods_id=goods_id
			//苹果url需要单独对待
			if(uni.getSystemInfoSync().platform == 'ios'){
				if(cartIds){
					this.url=storage.get('url')
					// this.url=`${location.origin}?cartIds=${cartIds}`
				}else{
					this.url=storage.get('url')
					// this.url=`${location.origin}?goods_id=${goods_id}`
				}
			}else{
				// this.url=storage.get('url')
				this.url=location.href.split('#')[0]
			}
		},
		async onShow() {
			await this.getUserInfo()
			if(this.goods_id){
				this.getGiftInfo()
			}else{
				this.getOrderInfo()
			}
			Api.getJsConfig({dealer_id:storage.get(DEALERID),url:this.url}).then(res=>{
				wxjssdk.config({
				  debug: true, // 开启调试模式,调用的所有api的返回值会在客户端alert出来，若要查看传入的参数，可以在pc端打开，参数信息会通过log打出，仅在pc端时才会打印。
				  appId: res.data.appId, // 必填，公众号的唯一标识
				  timestamp:res.data.timestamp, // 必填，生成签名的时间戳
				  nonceStr: res.data.nonceStr, // 必填，生成签名的随机串
				  signature: res.data.signature,// 必填，签名
				  jsApiList: res.data.jsApiList // 必填，需要使用的JS接口列表
				});
			})
		},
		computed:{
			orderTotalPrice(){
				if(this.goods_id){
					if(this.goods_info.type==1) return 0
					return this.goods_info.money
				}else{
					let sum=0
					this.order_info.forEach((item,index)=>{
						if(item.type==2){
							sum += item.money*1 * item.gift_num
						}
					})
					return sum
				}
			},
			orderTotalPoints(){
				if(this.goods_id){
					return this.goods_info.points_num
				}else{
					let sum=0
					this.order_info.forEach((item,index)=>{
						sum += item.points_num*1 * item.gift_num
					})
					return sum
					
				}
			},
			freight(){
				return 0
			}
		},
		methods:{
			getUserInfo(){
				return Api.getUserInfo({openid:this.openid,dealer_id:storage.get(DEALERID)}).then(res=>{
					const data = Object.assign({},res.data)
					if(data.sex==0){
						data.sex='男'
					}else{
						data.sex='女'
					}
					this.userInfo=data
				})
			},
			getOrderInfo(){
				Api.getOrderInfo({cartIds:this.cartIds}).then(res=>{
					this.order_info=res.data
				})
			},
			getGiftInfo(){
				Api.getGiftsInfo({goods_id:this.goods_id}).then(res=>{
					this.goods_info=res.data
				})
			},
			submit(){
				const that = this
				if(this.userInfo.points*1  < this.orderTotalPoints) return uni.$u.toast('您的积分不足')
				if(this.orderTotalPrice==0){
					//直接积分去兑换 跳到待发货订单
					const params={
						dealer_id:storage.get(DEALERID),
						openid:this.openid,
						pay_mode:this.goods_id?'direct':'cart',
						order_gift_info:this.goods_id?this.goods_info:this.order_info,
						cart_ids:this.cartIds,
						user_address_id:this.userInfo.address.id,
						total_points:this.orderTotalPoints,
						total_price:0,
						total_postage:0,
						mark:this.intro
					}
					Api.settlement(params).then(res=>{
						if(res.status==200){
							uni.$u.toast(res.message)
							setTimeout(()=>{
								// 带参数
								uni.$u.route({
									url:'/pages/order/index',
									type:'redirect',
									params: {
										status: 0
									}
								});
							},100)
						}else{
							return uni.$u.toast(res.message)
						}
					})
				}else{
					//调取支付 再去跳转订单
					const params={
						total_fee:this.orderTotalPrice * 100,
						openid:this.openid,
						pay_mode:this.goods_id?'direct':'cart',
						dealer_id:storage.get(DEALERID),
						order_gift_info:this.goods_id?this.goods_info:this.order_info,
						cart_ids:this.cartIds,
						user_address_id:this.userInfo.address.id,
						total_points:this.orderTotalPoints,
						total_price:this.orderTotalPrice,
						total_postage:0,
						mark:this.intro
					}
					Api.createOrder(params).then(res=>{
						//拉起支付
						const result=res.data
						if (result.result_code === "SUCCESS") {
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
										dealer_id:storage.get(DEALERID)
									}
									Api.checkOrder(params).then(res1=>{
										if(res1.status==200){
											uni.$u.route({
												url:'/pages/order/index',
												type:'redirect',
												params: {
													status: 0
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
										  	dealer_id:storage.get(DEALERID)
										  }
										  Api.checkOrder(params).then(res2=>{
										  	if(res2.status==200){
										  		uni.$u.route({
										  			url:'/pages/order/index',
													type:'redirect',
										  			params: {
										  				status: -1
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
						}
					})
				}
			}
		}
	}
</script>

<style lang="scss" scoped>
	page{
		background: #eeeeee;
		padding-bottom: 80rpx;
	}
	.container{
		width: 100%;
		height: auto;
		.u-textarea{
			background:#eeeeee ;
		}
		.address-box{
			width: 100%;
			height: 80rpx;
			display: flex;
			padding: 10rpx 20rpx;
			box-sizing: border-box;
			flex-direction: column;
			font-size: 22rpx;
			background: white;
			.address-top,.address-bot{
				width: 100%;
				height: 50%;
				display: flex;
				justify-content: space-between;
				align-items: center;
			}
		}
		.goods-box{
			width: 100%;
			height: auto;
			display: flex;
			flex-direction: column;
			background: white;
			.goods-item{
				width: 100%;
				height: 200rpx;
				display: flex;
				padding: 0 20rpx;
				box-sizing: border-box;
				justify-content: space-between;
				align-items: center;
				border-bottom: 1px solid #eeeeee;
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
		.intro-box,.price-box{
			width: 100%;
			height: auto;
			padding: 20rpx;
			box-sizing: border-box;
			background: white;
		}
		.price,.points{
			width: 100%;
			display: flex;
			justify-content: space-between;
			align-items: center;
			font-size: 26rpx;
			margin-bottom: 20rpx;
		}
		.sum-price{
			width: 100%;
			display: flex;
			justify-content:flex-end;
			align-items: center;
			font-size: 26rpx;
			margin-bottom: 20rpx;
		}
		.submit-btn{
			width: 100%;
			height: 80rpx;
			display: flex;
			justify-content: center;
			align-items: center;
			color: white;
			font-size: 28rpx;
			background: #fa2209;
			position: fixed;
			bottom: 0;
		}
	}
</style>