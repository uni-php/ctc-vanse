<template>
	<view class="container">
		<view class="user-box">
			<u--form labelPosition="left" labelWidth="80" :model="userInfo" :rules="rules"  ref="form">
				<u-form-item required label="姓名:" borderBottom prop="name" >
					<u--input border="none" v-model="userInfo.name" placeholder="请填写姓名" ></u--input>
				</u-form-item>
				<u-form-item required label="手机号:" borderBottom prop="phone" >
					<u--input border="none" v-model="userInfo.phone" placeholder="请填写手机号" ></u--input>
				</u-form-item>
				<u-form-item label="选择地址:" borderBottom prop="address" >
					<pick-regions :defaultRegion="defaultRegionCode" @getRegion="handleGetRegion">
						<text>{{regionName}}</text>
					</pick-regions>
				</u-form-item>
				<u-form-item label="详细住址:" borderBottom prop="location" >
					<u--input border="none" v-model="userInfo.location" placeholder="请填写详细住址" ></u--input>
				</u-form-item>
				<u-form-item label="备注:" borderBottom prop="remark" >
					<u--input border="none" v-model="userInfo.remark" placeholder="暂无" ></u--input>
				</u-form-item>
			</u--form>
			<u-button
				type="primary"
				text="提交"
				customStyle="margin-top: 50px"
				@click="submit"
			></u-button>
			<u-button
				type="error"
				text="重置"
				customStyle="margin-top: 10px"
				@click="reset"
			></u-button>
		</view>
	</view>
</template>

<script>
	import pickRegions from '@/components/pick-regions/pick-regions.vue'
	import {saveRegisterInfo} from '@/api/app/qrcode/index.js'
	import storage from '@/utils/storage'
	import { OPENID} from '@/store/mutation-types'
	export default{
		components:{ pickRegions },
		data(){
			return{
				region:[],
				defaultRegion:['','',''],
				defaultRegionCode:'',
				dealer_id:'',
				userInfo:{
					name:'',
					phone:'',
					location:'',
					remark:'',
					openid:storage.get(OPENID),
					status:0
				},
				rules:{
					name: {
						type: 'string',
						required: true,
						message: '请填写姓名',
						trigger: ['change']
					},
					phone: {
						type: 'string',
						required: true,
						message: '请填写手机号',
						trigger: ['change']
					},
				}
			}
		},
		onLoad({dealer_id}) {
			this.dealer_id=dealer_id
		},
		computed:{
			regionName(){
				// 转为字符串
				return this.region.map(item=>item.name).join(' ')||'请选择省市区'
			}
		},
		onShow() {
			
		},
		methods:{
			handleGetRegion(region){
				this.region = region
			},
			submit(){
				this.$refs.form.validate().then(res => {
					if(!uni.$u.test.mobile(this.userInfo.phone)) return uni.$u.toast('请检查手机号格式')
					this.userInfo.dealer_id=this.dealer_id
					this.userInfo.address=this.region.map(item=>item.name).join(' ')||''
					saveRegisterInfo(this.userInfo).then(res=>{
						if(res.status==200){
							uni.$u.toast('提交成功')
						}else{
							uni.$u.toast('请联系管理员')
						}
					})
				}).catch(errors => {
					uni.$u.toast('请检查必填项')
				})
			},
			reset(){
				const validateList = ['userInfo.name', 'userInfo.phone', 'userInfo.remark']
					this.$refs.form.resetFields()
					this.$refs.form.clearValidate()
					this.region=[]
					setTimeout(()=>{
						this.$refs.form.clearValidate(validateList)
						// 或者使用 this.$refs.form1.clearValidate()
					},10)
			}
		}
	}
</script>
<style>
	page{
		background: white;
		display: flex;
		justify-content: center;
		align-items: center;
	}
	.container{
		width: 95%;
	}
</style>
<style lang="scss" scoped>
	.user-box{
		width: 100%;
		height: auto;
		display: flex;
		justify-content: center;
		align-items: center;
		flex-direction: column;
		.u-form{
			width: 100%;
		}
	}
</style>
