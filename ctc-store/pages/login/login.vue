<template>
	<view class="container">
		<!-- 线条效果 -->
		<view class="line-box">
			<image mode="aspectFill" src="../../static/img/login-line.png"></image>
		</view>
		<view class="login-box">
			<view class="login-title">
				<text>门店登录</text>
			</view>
			<!-- 密码输入框 -->
			<view class="user-box">
				<u--form labelPosition="left" :model="model" :borderBottom="false" :rules="rules" ref="form">
					<u-form-item  :borderBottom="false" prop="userInfo.account"  ref="item1">
						<u--input
						    clearable
							style="height:55rpx"
							placeholder="请输入用户名"
							v-model="model.userInfo.account"
							prefixIcon="account"
							prefixIconStyle="font-size: 22px;color: #909399"
						></u--input>
					</u-form-item>
					<u-form-item :borderBottom="false" prop="userInfo.password"  ref="item2">
						<u--input
						    clearable
							password
							style="height:55rpx"
							placeholder="请输入密码"
							v-model="model.userInfo.password"
							prefixIcon="lock"
							prefixIconStyle="font-size: 22px;color: #909399"
						></u--input>
					</u-form-item>
				</u--form>
				<!-- 记住密码 -->
				<view>
					<u-checkbox-group
						v-model="is_remember_pwd"
						placement="column"
					>
						<u-checkbox
							:customStyle="{marginBottom: '8px'}"
							v-for="(item, index) in checkboxList"
							:key="index"
							:label="item.name"
							:name="item.name"
						>
						</u-checkbox>
					</u-checkbox-group>
				</view>
				<u-button
					type="primary"
					text="提交"
					customStyle="margin-top: 40px"
					@click="submit"
				></u-button>
			</view>
		</view>
		<!-- <view class="bk-img"> -->
			<!-- <image src="https://cdn.icloudapi.cn/trace-bk.png" mode="aspectFill"></image> -->
		<!-- </view> -->
		<view class="copy"> 
			<u-divider textColor="#eeeeee" text="石家庄市海略科技提供技术支持" :hairline="true"></u-divider>
		</view>
	</view>
</template>
<script>
	import {OPENID,AUTH_INFO,PASSWORD,ACCOUNT } from '@/store/mutation-types'
	import storage from '@/utils/storage'
	// import { encode, decode } from 'js-base64'
	const expiryTime = 30 * 86400
	import store from '@/store'
	export default{
		data(){
			return{
				is_remember_pwd:[],
				checkboxList:[
					{
						name:'记住密码'
					}
				],
				userInfo:{},
				isLogin:false,//是否存留登录信息
				isFirstload: true,
				model:{
					userInfo:{
						account:'',
						password:'',
						dealer_id:''
					}
				},
				rules:{
					'userInfo.password': [{
						type: 'string',
						required: true,
						message: '请填写密码',
						trigger: ['blur', 'change']
					},
					{
						min: 3,
						max: 6,
						message: '密码长度在3-6个字符之间'
					}],
					'userInfo.account': [{
						type: 'string',
						required: true,
						message: '请输入用户名',
						trigger: ['blur', 'change']
					}]
				}
			}
		},
		onLoad({dealer_id}) {
			this.model.userInfo.dealer_id=dealer_id
			const expiryTime = 30 * 86400
			const url='http://yx.uni-2id.com/store/?dealer_id='+ dealer_id
			storage.set('url', url, expiryTime)
		},
		onShow() {
			//用户是否注册
			let account = storage.get(ACCOUNT)
			let password = storage.get(PASSWORD)
			if(account){
				this.model.userInfo.account=account
				this.model.userInfo.password=password
				this.is_remember_pwd=['记住密码']
			}
		},
		created(){

		},
		methods:{
			submit(){
				// 如果有错误，会在catch中返回报错信息数组，校验通过则在then中返回true
				this.$refs.form.validate().then(res => {
					
					store.dispatch('Login',this.model.userInfo).then(res=>{
						console.log(res)
						if(res.status==200){
							//记住密码
							if(this.is_remember_pwd.length){
								storage.set(ACCOUNT,this.model.userInfo.account, expiryTime)
								let passWord = this.model.userInfo.password
								storage.set(PASSWORD,passWord, expiryTime) 
							}else{
								storage.set(ACCOUNT,'')
								let passWord = ''
								storage.set(PASSWORD,passWord, expiryTime) 
							}
							uni.$u.toast(res.message)
							setTimeout(()=>{
								uni.$u.route({
								  url:'/pages/index/index',
								  type:'redirect'
								});
							},1000)
						}else{
							uni.$u.toast(res.message)
						}	 
					})
				}).catch(errors => {
					// uni.$u.toast('校验失败')
				})
			},
		  register(){
			  if(this.userInfo) return this.$toast('请直接登录！')
			  uni.$u.route({
				  url:'/pages/register/index',
				  type:'redirect'
			  });
		  }
		}
	}
</script>

<style lang="scss">
	page{
		background-color: $app-main-color;
	}
</style>

<style lang="scss" scoped>
	.container{
		position: relative;
		display: flex;
		justify-content: center;
		.line-box{
			width: 380rpx;
			height: 290rpx;
			position: absolute;
			right: 00rpx;
			top: 0;
			image{
				width: 100%;
				height: 100%;
			}
		}
		.copy{
			width: 90%;
			position: fixed;
			bottom: 0;
		}
	}
	.login-box{
		width: 660rpx;
		height: 740rpx;
		border-radius: 16rpx;
		background: white;
		margin: 0 auto;
		margin-top: 140rpx; 
		display: flex;
		justify-content: flex-start;
		align-items: center;
		flex-direction: column;
		z-index: 999;
		.login-title{
			width: 100%;
			height: auto;
			font-size: 52rpx;
			font-weight: 600;
			display: flex;
			justify-content: flex-start;
			align-items: center;
			padding: 60rpx;
			box-sizing: border-box;
		}
		.user-box{
			width: 80%;
		}
	}
	.login-btn{
		width: 100%;
		height: auto;
		display: flex;
		margin: 0 auto;
		position: absolute;
		bottom: 150rpx;
		justify-content: center;
		align-items: center;
		flex-direction: column;
		z-index: 999;
		.btn{
			width: 80%;
			height: 80rpx;
			display: flex;
			justify-content: center;
			align-items: center;
			font-size: 28rpx;
			border-radius: 40rpx;
			color: $app-main-color;
			background: white;
			margin-bottom: 20rpx;
		}
	}
	.bk-img{
		width: 100%;
		height: 712rpx;
		display: flex;
		justify-content: center;
		align-items: center;
		position: fixed;
		bottom: 0;
		image{
			width: 100%;
			height: 100%;
		}
	}
</style>
