<template>
	<view class="container">
		<view class="top-bk">
			<u-icon name="clock" style="margin-right:20rpx" color="#ffffff" size="42"></u-icon>
			<u--text :text="orderInfo.status|status" color="#ffffff" size="24"  :bold="true"></u--text>
			<!-- <view class="pay-btn" v-if="orderInfo.status==-1" @click="pay">
				去支付
			</view> -->
			<view class="pay-btn" v-if="orderInfo.status==1" @click="receiving">
				确认收货
			</view>
		</view>
		<view class="address">
			<u--text :text="userInfo.address.consignee +'   '+ userInfo.address.phone" size="14"></u--text>
			<u--text :text="userInfo.address.location" size="12" color="#999"></u--text>
		</view>
		<view class="order-box">
			<view class="order-item">
				<view class="order-list">
					<view class="goods-item">
						<u--image :showLoading="true" :src="cover(orderInfo.gift)" width="90px" height="90px"></u--image>
						<view class="recom-info">
							<u--text :lines="2" :text="goods(orderInfo)" size="13"></u--text>
							<u--text text="" color="gray" size="12"></u--text>
							<view class="recom-points">
								<!-- <u-icon name="integral" color="#ff9900" size="18"></u-icon> -->
								<u--text style="flex:none" :text="'数码编号：'+orderInfo.code" color="#ff9900" size="12"></u--text>
								<!-- <u--text v-if="it.type==2" :text="'+￥'+it.money" color="#ff9900" size="12"></u--text> -->
							</view>
							<!-- <view class="shopping-cart">
								<u--text :text="'x'+`${it.gift_num}`" size="13" color="gray"></u--text>
							</view> -->
						</view>
					</view>
				</view>
			</view>
		</view>
		<view class="order-info">
			<view class="order-info-item">
				<text style="color:#999">订单编号：</text><text>{{orderInfo.order}}</text>
			</view>
			<view class="order-info-item">
				<text style="color:#999">下单时间：</text><text>{{orderInfo.create_time}}</text>
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
		<!-- <view class="order-info" style="margin-top: 20rpx;">
			<view class="order-info-item" style="justify-content: space-between;">
				<text style="color:#999">总积分：</text><text>{{orderInfo.total_points}}</text>
			</view>
			<view class="order-info-item" style="justify-content: space-between;">
				<text style="color:#999">运费：</text><text>{{orderInfo.total_postage}}</text>
			</view>
			<view class="order-info-item" style="justify-content: space-between;">
				<text style="color:#999">礼品费用：</text><text>￥{{orderInfo.total_price}}</text>
			</view>
		</view> -->
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
	import * as Api from '@/api/app/user/index.js'
	import storage from '@/utils/storage'
	import { DEALERID,OPENID } from '@/store/mutation-types'
	var wxjssdk = require("jweixin-module");
	export default{
		data(){
			return{
				cancelShow:false,
				openid:storage.get(OPENID),
				order_id:'',
				orderInfo:{},
				logisticsOptions:[],
				url:'',
				userInfo:{
					address:{}
				}
			}
		},
		onLoad({order_id,dealer_id}) {
			this.order_id=order_id
			this.dealer_id=dealer_id
		},
		async onShow() {
			this.getOrderDesById()
			await this.getUserInfo()
			await this.getLogisticsCompany()
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
			goods(val){
			  return JSON.parse(val.gift)[0].gift_name+`(礼品id:${JSON.parse(val.gift)[0].gift_id})`
			},
			cover(gift){
				return JSON.parse(gift)[0].url
			},
			getOrderDesById(){
				Api.getOrderDesById({order_id:this.order_id,dealer_id:this.dealer_id}).then(res=>{
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
					order_id:this.order_id,
					openid:this.openid,
					dealer_id:this.dealer_id
				}
				Api.receiving(params).then(res=>{
					if(res.status==200){
						this.cancelShow=false
						this.$toast(res.message);
						setTimeout(()=>{
							uni.$u.route({
								url:'/pages/member/order',
								type:'redirect',
								params: {
									status: 0
								}
							});
						},500)
					}else{
						this.$toast(res.message);
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