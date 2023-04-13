<template>
	<view class="container">
		<view class="bk-box">
			<u--image :showLoading="true" :src="bk_img" width="750rpx" height="150"></u--image>
		</view>
		<view class="head-box">
			<u-avatar :src="userInfo.headimgurl" size="70"></u-avatar>
			<view class="user-name">
				<u--text :text="userInfo.nickname" :bold="true"></u--text>
			</view>
			<view class="user-tag">
				<u-tag text="账户管理" @click="userCenter" plain size="mini" type="warning"></u-tag>
			</view>
		</view>
		<u-gap height="0.5" marginTop="20" bgColor="#c8c9cc"></u-gap>
		<u-cell-group>
			<u-cell
				title="我的扫码记录"
				icon="grid"
				isLink
				@click="scan_record"
			>
			</u-cell>
			<u-cell
				@click="prize_record"
				title="领奖记录"
				icon="red-packet"
				isLink
			>
			</u-cell>
			<u-cell
				v-if="pageSet.guide_group&&pageSet.guide_group.is_rank==1"
				@click="handleRank"
				title="导购排行榜"
				icon="file-text"
				isLink
			>
			</u-cell>
			<view v-if="pageSet&&pageSet.is_fun_show==1">
			<u-cell
				@click="scan"
				v-if="pageSet.is_scan==1"
				:title="pageSet.scan_name"
				icon="scan"
				isLink
			>
			</u-cell>
			<u-cell
				@click="points"
				v-if="pageSet.is_points_mall==1"
				:title="pageSet.micro_points_name"
				icon="gift-fill"
				isLink
			>
			</u-cell>
			</view>
		</u-cell-group>
	</view>
</template>

<script>
	import {getUserCenterPage,getJsConfig} from '@/api/app/guide/index.js'
	import storage from '@/utils/storage'
	import { DEALERID,OPENID,USERINFO } from '@/store/mutation-types'
	var wxjssdk = require("jweixin-module");
	export default{
		data(){
			return{
				url:'',
				bk_img:'https://cdn.uni-2id.com/guide_bk.png',
				openid:storage.get(OPENID),
				userInfo:{},
				dealer_id:'',
				pageSet:{}
			}
		},
		onLoad({dealer_id}) {
			this.dealer_id=dealer_id
			if(uni.getSystemInfoSync().platform == 'ios'){
				this.url=storage.get('url')
			}else{
				// this.url=storage.get('url')
				this.url=location.href.split('#')[0]
			}
		},
		async onShow() {
			var that=this;
			this.userInfo=storage.get(USERINFO)
			await this.getUserCenterPage()
			uni.setNavigationBarTitle({
			  title: this.pageSet.page_name
			});
			getJsConfig({dealer_id:this.dealer_id,url:this.url}).then(res=>{
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
		methods:{
			handleRank(){
				uni.$u.route({
					url: '/pages/guide/guide_rank',
					params: {
						dealer_id:this.dealer_id,
						openid: storage.get(OPENID)
					}
				})
			},
			userCenter(){
				uni.$u.route({
					url: '/pages/guide/user_info',
					params: {
						dealer_id:this.dealer_id,
						openid: storage.get(OPENID)
					}
				})
			},
			scan_record(){
				uni.$u.route({
					url: '/pages/guide/scan_record',
					params: {
						dealer_id:this.dealer_id,
						openid: storage.get(OPENID)
					}
				})
			},
			prize_record(){
				uni.$u.route({
					url: '/pages/guide/prize_record',
					params: {
						dealer_id:this.dealer_id,
						openid: storage.get(OPENID)
					}
				})
			},
			getUserCenterPage(){
				return getUserCenterPage({openid:this.openid,dealer_id:this.dealer_id}).then(res=>{
					this.pageSet=res.data
				})
			},
			points(){
				const url='http://www.gawxg.com/jifen/?dealer_id='+this.dealer_id
				window.location.href=url
			},
			scan(){
				const that = this
				wxjssdk.ready(function(){
					wxjssdk.scanQRCode({
					  needResult: 1, // 默认为0，扫描结果由微信处理，1则直接返回扫描结果，
					  scanType: ["qrCode","barCode"], // 可以指定扫二维码还是一维码，默认二者都有
					  success: function (res) {
						var result = res.resultStr; // 当needResult 为 1 时，扫码返回的结果
						//跳转到导购营销页面
						if (typeof(result) != 'undefined') {
							// var codeBatch = result.split('/')
							// if (codeBatch.length > 0) {
							// 	const batch = codeBatch[0].split(',')[1]
							// 	const url = 'http://yx.uni-2id.com/multi/?dealer_id='+that.dealer_id+'&batch='+batch+'&qrcode='+codeBatch[1]
							// 	window.location.href=url
							// }else{
							// 	uni.$u.toast('请检查条形码')
							// }
							//导购员扫条码  扫描内容为序号
							const url = 'https://www.gawxg.com/multi/?dealer_id='+that.dealer_id+'&order='+result
							window.location.href=url
						}else{
							uni.$u.toast('请检查条形码')
						}
					  }
					})
				})
			}
		}
	}
</script>

<style lang="scss" scoped>
	.bk-box{
		width: 100%;
		height: 300rpx;
	}
	.head-box{
		width: 100%;
		height: auto;
		display: flex;
		align-items: flex-end;
		padding:0 20rpx;
		box-sizing: border-box;
		margin-top: -40px;
		position: relative;
		.user-name{
			margin-left: 20rpx;
			margin-bottom: 10rpx;
		}
		.user-tag{
			bottom: 0;
			right: 30rpx;
			position: absolute;
		}
	}
</style>
