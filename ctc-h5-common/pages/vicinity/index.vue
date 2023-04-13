<template>
	<view class="container">
		<view class="gap-line">
			<view class="line"></view>
			<text class="line-title">最近的门店</text>
		</view>
		<view class="store-box">
			<view class="store-item">
				<u--text :bold="true" color="#333" size="13" :text="store.store_name"></u--text>
				<u--text style="margin:5rpx 0" size="12" color="#808080" :text="'门店编号：'+store.store_code"></u--text>
				<u--text style="margin:5rpx 0" size="12" color="#808080" :text="'门店电话：'+store.telephone"></u--text>
				<u--text style="margin:5rpx 0" size="12" color="#808080" :text="'地址：'+store.province+store.city+store.district+store.address"></u--text>
				<view class="address" @click="address(store)">
					<u-icon name="map" color="#f0ad4e"></u-icon>
					<u--text color="#333" size="12" :text="store.distance+'KM'"></u--text>
				</view>
			</view>
		</view>
		<view class="gap-line">
			<view class="line"></view>
			<text class="line-title">更多门店</text>
		</view>
		<!-- 搜索 -->
		<view class="search-box">
			<view class="u-demo-block__content">
				<view class="u-page__tag-item">
					<u-search @search="search" @custom="search" :showAction="true" v-model="keyword" actionText="搜索" :animation="true"></u-search>
				</view>
			</view>
		</view>
		<view class="store-box">
			<view class="store-item" v-for="(item,index) in storeList" :key="index" v-if="index>=1">
				<u--text :bold="true" color="#333" size="13" :text="item.store_name"></u--text>
				<u--text style="margin:5rpx 0" size="12" color="#808080" :text="'门店编号：'+item.store_code"></u--text>
				<u--text style="margin:5rpx 0" size="12" color="#808080" :text="'门店电话：'+item.telephone"></u--text>
				<u--text style="margin:5rpx 0" size="12" color="#808080" :text="'地址：'+item.province+item.city+item.district+item.address"></u--text>
				<view class="address" @click="address(item)">
					<u-icon name="map" color="#f0ad4e"></u-icon>
					<u--text color="#333" size="12" :text="item.distance+'KM'"></u--text>
				</view>
			</view>
		</view>
	</view>	
</template>

<script>
	import storage from '@/utils/storage'
	import { OPENID ,USERINFO,URL} from '@/store/mutation-types'
	import {getVicinityStoreList,getJsConfig} from '@/api/app/store/vicinity.js'
	var wxjssdk = require("jweixin-module");
	import QQMapWX from '@/js_sdk/qqmap-h5.js'
	export default{
		data(){
			return{
				latitude:'',
				longitude:'',
				url:'',
				qqMap: new QQMapWX({key: 'K3PBZ-PSUCD-T3A4R-P5JPH-6MCR2-KYF6K',vm: this}),
				dealer_id:'',
				keyword:'',
				storeList:[
				],
				store:{
				}
			}
		},
		onLoad({dealer_id}) {
			this.dealer_id=dealer_id
			const expiryTime = 30 * 86400
			const url='http://yx.uni-2id.com/vicinity/?dealer_id='+dealer_id
			storage.set('url', url, expiryTime)
			if(uni.getSystemInfoSync().platform == 'ios'){
				this.url=storage.get('url')
			}else{
				this.url=location.href.split('#')[0]
			}
		},
		onShow() {
			var that=this;
			getJsConfig({dealer_id:this.dealer_id,url:this.url}).then(res=>{
				wxjssdk.config({
				  debug: false, // 开启调试模式,调用的所有api的返回值会在客户端alert出来，若要查看传入的参数，可以在pc端打开，参数信息会通过log打出，仅在pc端时才会打印。
				  appId: res.data.appId, // 必填，公众号的唯一标识
				  timestamp:res.data.timestamp, // 必填，生成签名的时间戳
				  nonceStr: res.data.nonceStr, // 必填，生成签名的随机串
				  signature: res.data.signature,// 必填，签名
				  jsApiList: res.data.jsApiList // 必填，需要使用的JS接口列表
				});
				wxjssdk.ready(function(){
					wxjssdk.getLocation({
						type: "wgs84", // 默认为wgs84的gps坐标，如果要返回直接给openLocation用的火星坐标，可传入'gcj02'
						success: function (res1) {
							console.log(res1)
							that.latitude=res1.latitude,
							that.longitude=res1.longitude
							that.getVicinityStoreList()
						},
					});
				})
			})
		},
		methods:{
			search(){
				this.storeList=[]
				this.getVicinityStoreList()
			},
			address(item){
				const latitude=item.gps.split(',')[0]
				const longitude=item.gps.split(',')[1]
				wxjssdk.ready(function(){
					wxjssdk.openLocation({
					  latitude: Number(latitude), // 纬度，浮点数，范围为90 ~ -90
					  longitude: Number(longitude), // 经度，浮点数，范围为180 ~ -180。
					  name: item.address, // 位置名
					  address: '门店地址', // 地址详情说明
					  scale: 10, // 地图缩放级别,整型值,范围从1~28。默认为最大
					  infoUrl: '' // 在查看位置界面底部显示的超链接,可点击跳转
					});
					
				})
			},
			getVicinityStoreList(){
				const params={
					dealer_id:this.dealer_id,
					keyword:this.keyword,
					latitude:this.latitude,
					longitude:this.longitude
				}
				getVicinityStoreList(params).then(res=>{
					this.storeList=res.data
					this.store=res.data[0]
				})
			}
		}
	}
</script>

<style lang="scss" scoped>
	.container{
		width: 100%;
		position: relative;
		background: #fafafa;
		display: flex;
		justify-content: center;
		align-items: center;
		flex-direction: column;
		.search-box{
			width: 100%;
			padding: 10rpx;
			box-sizing: border-box;
			border-bottom: 1px solid #eeeeee;
		}
		.gap-line{
			width: 100%;
			height: 60rpx;
			background: #eeeeee;
			display: flex;
			justify-content: flex-start;
			align-items: center;
			padding: 0 20rpx;
			box-sizing: border-box;
			.line{
				width: 6rpx;
				height: 35rpx;
				background: $uni-color-warning;
				margin-right: 10rpx;
			}
			.line-title{
				font-size: 28rpx;
			}
		}
		.store-box{
			width: 100%;
			height: auto;
			display: flex;
			justify-content: center;
			align-items: center;
			flex-direction: column;
			.store-item{
				width: 100%;
				display: flex;
				padding: 10rpx 20rpx;
				box-sizing: border-box;
				justify-content: flex-start;
				align-items: center;
				flex-direction: column;
				border-bottom: 1px solid #eeeeee;
				position: relative;
				.address{
					position: absolute;
					right: 20rpx;
					padding: 0 30rpx;
					display: flex;
					justify-content: center;
					align-items: center;
					flex-direction: column;
					top: 50%;
					transform: translateY(-50%);
					border-left: 1px solid lightgray;
				}
			}
		}
	}
</style>