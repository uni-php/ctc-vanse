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
					v-model="userInfo.username"
					placeholder="请输入姓名"
					border="none"
				></u--input>
			</u-form-item>
			<u-form-item
				label="OPENID"
				prop="openid"
				borderBottom
				ref="item1"
			>
				<u--input
					v-model="userInfo.openid"
					disabled
					border="none"
				></u--input>
			</u-form-item>
			<u-form-item
				label="性别"
				prop="sex"
				borderBottom
				@click="showSex = true; hideKeyboard()"
				ref="item1"
			>
				<u--input
					v-model="userInfo.sex"
					disabled
					disabledColor="#ffffff"
					placeholder="请选择性别"
					border="none"
				></u--input>
				<u-icon
					slot="right"
					name="arrow-right"
				></u-icon>
			</u-form-item>
			<u-form-item
				label="ID"
				prop="id"
				borderBottom
				ref="item1"
			>
				<u--input
					v-model="userInfo.id"
					disabled
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
					v-model="userInfo.phone"
					placeholder="请输入电话"
					border="none"
				></u--input>
			</u-form-item>
			<u-form-item
					label="生日"
					prop="birthday"
					borderBottom
					@click="showBirthday = true; hideKeyboard()"
					ref="item1"
				>
				<u--input
					v-model="userInfo.birthday"
					disabled
					disabledColor="#ffffff"
					placeholder="请选择生日"
					border="none"
				></u--input>
				<u-icon
					slot="right"
					name="arrow-right"
				></u-icon>
			</u-form-item>
			<u-form-item
				label="身份证号"
				prop="idcard"
				borderBottom
				ref="item1"
			>
				<u--input
					v-model="userInfo.idcard"
					placeholder="输入身份证号"
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
					v-model="userInfo.address"
					placeholder="请选择收货地址"
					readonly
					border="none"
				></u--input>
				<u-icon
					slot="right"
					name="arrow-right"
				></u-icon>
			</u-form-item>
		</u--form>
		<u-button
			type="primary"
			text="提交"
			customStyle="margin-top: 50px"
			@click="submit"
		></u-button>
		<u-action-sheet
			:show="showSex"
			:actions="actions"
			title="请选择性别"
			@close="showSex = false"
			@select="sexSelect"
		>
		</u-action-sheet>
		<u-datetime-picker
			:show="showBirthday"
			:value="birthday"
			mode="date"
			closeOnClickOverlay
			@confirm="birthdayConfirm"
			@cancel="showBirthday=false"
			@close="showBirthday=false"
		></u-datetime-picker>
	</view>
</template>

<script>
	import {getUserInfo,saveUserInfo} from '@/api/app/user/index.js'
	import storage from '@/utils/storage'
	import { DEALERID,OPENID } from '@/store/mutation-types'
	export default{
		data(){
			return{
				actions: [{
						name: '男',
						value:0
					},
					{
						name: '女',
						value:1
					}
				],
				birthday: Number(new Date()),
				showBirthday:false,
				showSex:false,
				dealer_id:'',
				openid:storage.get(OPENID),
				userInfo:{
					nickname:'',
					username:'',
					openid:'',
					birthday:'',
					sex:'',
					id:'',
					phone:'',
					idcard:'',
					address:''
				},
				rules:{}
			}
		},
		onShow() {
			getUserInfo({openid:this.openid,dealer_id:this.dealer_id}).then(res=>{
				const data = Object.assign({},res.data)
				if(data.sex==0){
					data.sex='男'
				}else{
					data.sex='女'
				}
				this.userInfo=data
				this.userInfo.address=data.address?.address
			})
		},
		onLoad({dealer_id}) {
			this.dealer_id=dealer_id
		},
		methods:{
			sexSelect(e){
				this.userInfo.sex = e.name
			},
			birthdayConfirm(e) {
				this.showBirthday = false
				this.userInfo.birthday = uni.$u.timeFormat(e.value, 'yyyy-mm-dd')
			},
			hideKeyboard() {
				uni.hideKeyboard()
			},
			address(){
				uni.$u.route({
					url:'/pages/member/address',
					params: {
						dealer_id:this.dealer_id,
						openid: storage.get(OPENID)
					}
				});
			},
			submit(){
				const data= Object.assign({},this.userInfo)
				data.sex=data.sex=='男'?'0':1
				saveUserInfo(data).then(res=>{
					if(res.status==200){
						uni.$u.toast(res.message)
					}else{
						uni.$u.toast(res.message)
					}
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