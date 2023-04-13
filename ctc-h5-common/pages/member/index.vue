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
				title="账户积分"
				icon="integral-fill"
				:value="userInfo.points"
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
				@click="qrcode_order"
				title="营销订单"
				icon="order"
				isLink
			>
			</u-cell>
			<view v-if="pageSet&&pageSet.is_fun_show==1">
			<u-cell
				@click="mall"
				v-if="pageSet.is_micro_mall==1"
				:title="pageSet.micro_mall_name"
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
	import {getUserCenterPage,getJsConfig} from '@/api/app/user/index.js'
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
			// getJsConfig({dealer_id:this.dealer_id,url:this.url}).then(res=>{
			// 	wxjssdk.config({
			// 	  debug: false, // 开启调试模式,调用的所有api的返回值会在客户端alert出来，若要查看传入的参数，可以在pc端打开，参数信息会通过log打出，仅在pc端时才会打印。
			// 	  appId: res.data.appId, // 必填，公众号的唯一标识
			// 	  timestamp:res.data.timestamp, // 必填，生成签名的时间戳
			// 	  nonceStr: res.data.nonceStr, // 必填，生成签名的随机串
			// 	  signature: res.data.signature,// 必填，签名
			// 	  jsApiList: res.data.jsApiList // 必填，需要使用的JS接口列表
			// 	});
			// })
		},
		methods:{
			userCenter(){
				uni.$u.route({
					url: '/pages/member/user_center',
					params: {
						dealer_id:this.dealer_id,
						openid: storage.get(OPENID)
					}
				})
			},
			prize_record(){
				uni.$u.route({
					url: '/pages/member/prize_record',
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
			qrcode_order(){
				uni.$u.route({
					url: '/pages/member/order',
					params: {
						dealer_id:this.dealer_id,
						openid: storage.get(OPENID)
					}
				})
			},
			mall(){
				const url='http://jifen.uni-2id.com/?dealer_id='+this.dealer_id
				window.location.href=url
			},
			points(){
				const url='http://jifen.uni-2id.com/?dealer_id='+this.dealer_id
				window.location.href=url
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
