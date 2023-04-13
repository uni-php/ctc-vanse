<template>
	<view class="container">
		<u-swiper
				:list="goods_info.cover"
				indicator
				keyName="url"
				height="200"
				indicatorMode="line"
				circular
		></u-swiper>
		<view class="gift-title">
			{{goods_info.gift_name}}
		</view>
		<view class="recom-points">
			<u-icon name="integral" color="#ff9900" size="18"></u-icon>
			<u--text style="flex:none" :text="goods_info.points_num" color="#ff9900" size="12"></u--text>
			<u--text v-if="goods_info.type==2" :text="'+￥'+goods_info.money" color="#ff9900" size="12"></u--text>
		</view>
		<view class="gift-tips" style="font-size: 24rpx;color:gray ;">
			<view>数量有限，兑完即止</view>
			<view>剩余：{{goods_info.limit_num}}</view>
		</view>
		<view class="line">
			-- 礼品详情 --
		</view>
		<view class="content-box">
			<u-parse :content="goods_info.details"></u-parse>
		</view>
		<!-- 加入购物车 -->
		<view class="set-btn-box">
			<view class="set-btn-item" style="background: white;">
				<view class="set-btn-item-nav" @click="goToHome">
					<u-icon name="home" size="19" color="#909399"></u-icon>
					<text style="font-size: 15rpx;color:#909399;">积分商城</text>
				</view>
				<view class="set-btn-item-nav" @click="goToCart">
					<u-icon name="shopping-cart" size="22" color="#909399"></u-icon>
					<text style="font-size: 15rpx;color:#909399;margin-top:-6rpx">购物车</text>
				</view>
			</view>
			<view class="set-btn-item" style="background: #ff8a8b;">
				<text>加入购物车</text>
			</view>
			<view class="set-btn-item" @click="settlement" style="background: #fa3534;">
				<text>立即兑换</text>
			</view>
		</view>
		<u-modal
			content="请先添加收货地址"
			:show="add_address_show"
			showCancelButton
			closeOnClickOverlay
			@confirm="confirm"
			@cancel="add_address_show=false"
			@close="add_address_show=false"
		></u-modal>
	</view>
</template>

<script>
	import * as Api from '@/api/app/points/index.js'
	import storage from '@/utils/storage'
	import { DEALERID,OPENID } from '@/store/mutation-types'
	export default{
		data(){
			return{
				add_address_show:false,
				goods_id:'',
				goods_info:{},
				addressList:[],
				openid:storage.get(OPENID)
			}
		},
		onLoad({goods_id}) {
			this.goods_id=goods_id
		},
		onShow() {
			this.getGiftInfo()
		},
		methods:{
			getGiftInfo(){
				Api.getGiftsInfo({goods_id:this.goods_id}).then(res=>{
					this.goods_info=res.data
				})
			},
			getMemberAddressList(){
				const params={
					dealer_id:storage.get(DEALERID),
					openid:this.openid
				}
				return Api.getMemberAddressList(params).then(res=>{
					this.addressList=res.data
				})
			},
			confirm(){
				//跳转地址页面
				this.add_address_show=false
				uni.$u.route({
					url:'/pages/add_address/index'
				});
			},
			// 去结算
			async settlement(){
				//判断是否填写地址
				await this.getMemberAddressList()
				if(this.addressList==0){
					this.add_address_show=true
				}else{
					//结算
					uni.$u.route({
						url:'/pages/settlement/index',
						params: {
							goods_id: this.goods_id
						}
					});
				}
			},
			goToHome(){
				uni.$u.route({
					url:'/pages/index/index',
					type:'switchTab'
				});
			},
			goToCart(){
				uni.$u.route({
					url:'/pages/cart/index',
					type:'switchTab'
				});
			}
		}
	}
</script>

<style lang="scss" scoped>
	.container{
		width: 100%;
		height: auto;
		position: relative;
		padding-bottom: 120rpx;
		.gift-title,.gift-tips{
			width: 90%;
			padding: 15rpx;
			box-sizing: border-box;
			font-size: 28rpx;
			text-align: left;
			font-weight: 500;
			text-overflow: ellipsis;
			overflow: hidden;
			white-space: nowrap;
		}
		.gift-tips{
			width: 100%;
			display: flex;
			justify-content: space-between;
			align-items: center;
		}
		.recom-points{
			width: 100%;
			padding: 15rpx;
			box-sizing: border-box;
			display: flex;
			justify-content: flex-start;
			align-items: center;
			flex-wrap: nowrap;
		}
		.line{
			width: 100%;
			height: 60rpx;
			display: flex;
			margin: 10rpx 0;
			justify-content: center;
			align-items: center;
			background-color: #eeeeee;
			font-size: 26rpx;
			color: gray;
		}
		.content-box{
			width: 100%;
			padding: 10rpx;
			box-sizing: border-box;
			height: auto;
			position: relative;
		}
		.set-btn-box{
			width: 100%;
			height: 100rpx;
			position: fixed;
			bottom: 0;
			display: flex;
			justify-content: center;
			align-items: center;
			.set-btn-item{
				width: 33.3%;
				height: 100%;
				display: flex;
				font-weight: 600;
				justify-content: center;
				align-items: center;
				font-size: 28rpx;
				color: white;
				.set-btn-item-nav{
					width: 50%;
					height: 100%;
					display: flex;
					justify-content: center;
					align-items: center;
					flex-direction: column;
				}
			}
		}
	}
</style>