<template>
	<view class="container">
		<u--form
			labelPosition="left"
			labelWidth="80"
			:model="userInfo"
			:rules="rules"
			ref="form"
		>
			<u-form-item
				label="昵称"
				prop="nickname"
				borderBottom
				ref="item1"
			>
				<u--input
					v-model="userInfo.nickname"
					placeholder="请输入昵称"
					readonly
					border="none"
				></u--input>
			</u-form-item>
			<u-form-item
				label="姓名"
				prop="username"
				borderBottom
				ref="item1"
			>
				<u--input
					v-model="guideInfo.name"
					placeholder="请输入姓名"
					readonly
					border="none"
				></u--input>
			</u-form-item>
			<u-form-item
				label="手机号"
				prop="phone"
				borderBottom
				ref="item1"
			>
				<u--input
					v-model="guideInfo.phone"
					placeholder="请输入电话"
					readonly
					border="none"
				></u--input>
			</u-form-item>
			<u-form-item
				label="微信号"
				prop="phone"
				borderBottom
				ref="item1"
			>
				<u--input
					v-model="guideInfo.wechat"
					placeholder="请输入微信号"
					readonly
					border="none"
				></u--input>
			</u-form-item>
			<u-form-item
				label="所属门店"
				prop="store"
				readonly
				borderBottom
				ref="item1"
			>
				<u--input
					v-model="guideInfo.store_name"
					placeholder="输入门店"
					border="none"
				></u--input>
			</u-form-item>
			<u-form-item
				label="所属分组"
				prop="group_name"
				borderBottom
				ref="item1"
			>
				<u--input
					v-model="guideInfo.group_name"
					placeholder="输入分组"
					readonly
					border="none"
				></u--input>
			</u-form-item>
			<u-form-item
				label="收货地址"
				prop="address"
				borderBottom
				@click="address"
				ref="item1"
			>
				<u--input
					v-model="guideInfo.address"
					placeholder="请选择地址"
					readonly
					border="none"
				></u--input>
			</u-form-item>
		</u--form>
	</view>
</template>

<script>
	import {getGuideUserInfo} from '@/api/app/guide/index.js'
	import { OPENID ,USERINFO,URL,DEALERID} from '@/store/mutation-types'
	import storage from '@/utils/storage'
	export default{
		data(){
			return{
				openid:storage.get(OPENID),
				userInfo:{},
				guideInfo:{},
				rules:{}
			}
		},
		onShow() {
			this.userInfo=storage.get(USERINFO)
			this.getGuideUserInfo()
		},
		onLoad({dealer_id}) {
			this.dealer_id=dealer_id
		},
		methods:{
			getGuideUserInfo(){
				const params={
					openid:storage.get(OPENID),
					dealer_id:this.dealer_id
				}
				getGuideUserInfo(params).then(res=>{
					this.guideInfo=res.data
				})
			}
		}
	}
</script>

<style lang="scss" scoped>
	.container{
		width: 100%;
		padding: 20rpx;
		box-sizing: border-box;
		height: auto;
	}
</style>