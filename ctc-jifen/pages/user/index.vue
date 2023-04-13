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
				isLink
				@click="points"
				:value="userInfo.points"
			>
			</u-cell>
			<u-cell
				@click="order"
				title="订单中心"
				icon="order"
				isLink
			>
			</u-cell>
		</u-cell-group>
	</view>
</template>

<script>
	import * as Api from '@/api/app/points/index.js'
	import storage from '@/utils/storage'
	import { DEALERID,OPENID } from '@/store/mutation-types'
	export default{
		data(){
			return{
				bk_img:'https://cdn.uviewui.com/uview/album/1.jpg',
				openid:storage.get(OPENID),
				userInfo:{}
			}
		},
		methods:{
			userCenter(){
				uni.$u.route('/pages/user_center/index');
			},
			points(){
				uni.$u.route('/pages/points_info/index');
			},
			order(){
				uni.$u.route('/pages/order/index');
			},
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
			}
		},
		async onShow() {
			await this.getUserInfo()
		},
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
