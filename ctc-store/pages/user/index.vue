<template>
	<view class="container">
		<u--form
			labelPosition="left"
			labelWidth="80"
			style="width: 100%;"
			:model="store_info"
			:rules="rules"
			ref="form"
		>
		<u-form-item
			label="门店名称"
			prop="store_name"
			borderBottom
			ref="item1"
		>
			<u--input
				v-model="store_info.store_name"
				placeholder="请输入"
				border="none"
			></u--input>
		</u-form-item>
		<u-form-item
			label="门店编号"
			prop="store_code"
			borderBottom
			ref="item1"
		>
			<u--input
				v-model="store_info.store_code"
				placeholder="请输入"
				border="none"
			></u--input>
		</u-form-item>
		<u-form-item
			label="手机号码"
			prop="mobile_phone"
			borderBottom
			ref="item1"
		>
			<u--input
				v-model="store_info.mobile_phone"
				placeholder="请输入"
				border="none"
			></u--input>
		</u-form-item>
		<u-form-item
			label="负责人"
			prop="person"
			borderBottom
			ref="item1"
		>
			<u--input
				v-model="store_info.person"
				placeholder="请输入"
				border="none"
			></u--input>
		</u-form-item>
		<u-form-item
			label="添加时间"
			prop="create_time"
			borderBottom
			ref="item1"
		>
			<u--input
				v-model="store_info.create_time"
				placeholder="请输入"
				border="none"
			></u--input>
		</u-form-item>
		<u-form-item
			label="门店地址"
			prop="add"
			borderBottom
			ref="item1"
		>
			<u--input
				v-model="store_info.add"
				placeholder="请输入"
				border="none"
			></u--input>
		</u-form-item>
		</u--form>
		<u-button
			type="primary"
			text="退出登录"
			customStyle="margin-top: 50px"
			@click="submit"
		></u-button>
	</view>
</template>

<script>
	import {STORE_INFO } from '@/store/mutation-types'
	import storage from '@/utils/storage'
	export default{
		data(){
			return{
				store_info:{},
				rules:{
					
				}
			}
		},
		onShow() {
			this.store_info=storage.get(STORE_INFO)
			this.store_info.add=this.store_info.province+this.store_info.city+this.store_info.district+this.store_info.address
		},
		methods:{
			submit(){
				setTimeout(() => {
					uni.$u.route({
						url: 'pages/login/login',
						type:'reLaunch',
						params: {
							dealer_id: this.store_info.dealer_id
						}
					})
					storage.clear()
				}, 500)
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
