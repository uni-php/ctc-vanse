<template>
	<view class="container">
		<view class="tips">
			<u--text size="14" color="#2b85e4" text="门店管理员扫码即可核销"></u--text>
		</view>
		<!-- <view class="u-demo-block__content" style="width: 95%;">
			<view class="u-page__tag-item">
				<u-search v-model="key" placeholder="请输入核销码" actionText="核销"></u-search>
			</view>
		</view> -->
		<view class="scan-box">
			<u--image :showLoading="true" :src="scan_icon" width="90px" height="90px" @click="scan"></u--image>
		</view>
		<view class="check-log">
			<u-cell-group>
				<u-cell
					title="最近核销记录"
					value="更多记录"
					@click="log"
					:isLink="true"
				></u-cell>
			</u-cell-group>
			<view class="log-item" v-for="(item,index) in logList" :key="index" v-if="index<=4">
				<u--text size="14" :bold="true" :text="'礼品名称：'+goods(item)"></u--text>
				<u--text style="margin:6rpx 0" size="13" :text="'二维码编号：'+item.code"></u--text>
				<u--text size="13" color="#999" :text="'核销时间：'+item.check_time"></u--text>
			</view>
		</view>
	</view>	
</template>

<script>
	import {STORE_INFO } from '@/store/mutation-types'
	import {getJsConfig,checkOrderQrcode,getCheckLog} from '@/api/check/index.js'
	import storage from '@/utils/storage'
	var wxjssdk = require("jweixin-module");
	const pageSize = 10
	export default{
		data(){
			return{
				logList:[],
				url:'',
				store_info:{},
				key:'',
				scan_icon:'https://cdn.uni-2id.com/store_scan_icon.png'
			}
		},
		onLoad() {
			this.store_info=storage.get(STORE_INFO)
			if(uni.getSystemInfoSync().platform == 'ios'){
				this.url=storage.get('url')
			}else{
				// this.url=storage.get('url')
				this.url=location.href.split('#')[0]
			}
		},
		onShow() {
			getJsConfig({dealer_id:this.store_info.dealer_id,url:this.url}).then(res=>{
				wxjssdk.config({
				  debug: false, // 开启调试模式,调用的所有api的返回值会在客户端alert出来，若要查看传入的参数，可以在pc端打开，参数信息会通过log打出，仅在pc端时才会打印。
				  appId: res.data.appId, // 必填，公众号的唯一标识
				  timestamp:res.data.timestamp, // 必填，生成签名的时间戳
				  nonceStr: res.data.nonceStr, // 必填，生成签名的随机串
				  signature: res.data.signature,// 必填，签名
				  jsApiList: res.data.jsApiList // 必填，需要使用的JS接口列表
				});
			})
			this.getCheckLog()
		},
		methods:{
			goods(val){
			  return JSON.parse(val.gift)[0].gift_name+`(礼品id:${JSON.parse(val.gift)[0].gift_id})`
			},
			scan(){
				const that = this
				wxjssdk.ready(function(){
					wxjssdk.scanQRCode({
						needResult: 1, // 默认为0，扫描结果由微信处理，1则直接返回扫描结果，
						scanType: ["qrCode","barCode"], // 可以指定扫二维码还是一维码，默认二者都有
						success: function (res) {
							var result = res.resultStr; // 当needResult 为 1 时，扫码返回的结果
							//跳转到导购营销页面 dealer_id/order_id
							if (typeof(result) != 'undefined') {
								var str = result.split('/')
								if (str.length > 1) {
									const params={
										dealer_id:str[0],
										order_id:str[1],
										store_id:that.store_info.id
									}
									if(that.store_info.dealer_id!=params.dealer_id) return uni.$u.toast('核销码无效')
									checkOrderQrcode(params).then(re=>{
										if(re.status==200){
											uni.$u.toast(re.message)
											that.getCheckLog()
										}else{
											uni.$u.toast(re.message)
										}
									})
									
								}else{
									uni.$u.toast('核销码无效')
								}
							}else{
								uni.$u.toast('无效核销码')
							}
						}
					})
				})
			},
			getCheckLog(){
				const params={
					dealer_id:this.store_info.dealer_id,
					store_id:this.store_info.id,
					keywords:'',
					page:1,
					pageSize:10
				}
				getCheckLog(params).then((res=>{
					this.logList=res.data.list.data
				}))
			},
			log(){
				uni.$u.route({
					url: 'pages/check/log'
				})
			}
		}
	}
</script>

<style lang="scss" scoped>
	.container{
		width: 100%;
		height: 100vh;
		position: relative;
		display: flex;
		justify-content: flex-start;
		box-sizing: border-box;
		background: url('https://cdn.uni-2id.com/check_bk.png');
		background-size: cover;
		background-repeat: no-repeat;
		.tips{
			width: 100%;
			margin: 40rpx 0;
			padding-left: 80rpx;
		}
		.scan-box{
			width: 100%;
			height: 200rpx;
			display: flex;
			justify-content: center;
			align-items: center;
			margin-top: 60rpx;
			// background: red;
		}
		.check-log{
			width: 100%;
			margin-top: 50rpx;
			display: flex;
			flex-direction: column;
			.log-item{
				display: flex;
				justify-content: flex-start;
				flex-direction: column;
				width: 100%;
				height: auto;
				border-bottom: 1px solid #eeeeee;
				padding: 20rpx;
				box-sizing: border-box;
			}
		}
	}
</style>