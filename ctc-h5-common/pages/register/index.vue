<template>
	<view class="container">
		<view class="top-bk"></view>
		<view class="user-box" v-if="check_status==-1">
			<view class="user-box-title">
				<u-icon name="file-text" color="#42a1f7" size="24"></u-icon>请填写注册信息
			</view>
			<u--form labelPosition="left" labelWidth="80" :model="userInfo" :rules="rules"  ref="form">
				<u-form-item required label="姓名:" borderBottom prop="name" >
					<u--input border="none" v-model="userInfo.name" placeholder="请填写姓名" ></u--input>
				</u-form-item>
				<u-form-item required label="手机号:" borderBottom prop="phone" >
					<u--input border="none" v-model="userInfo.phone" placeholder="请填写手机号" ></u--input>
				</u-form-item>
				<u-form-item required labelWidth="80" label="运营中心" required prop="operation_center_name" borderBottom @click="showCenter = true; hideKeyboard()" ref="item1">
					<u--input v-model="userInfo.operation_center_name" disabled disabledColor="#ffffff" placeholder="请选择运营中心" border="none"></u--input>
					<u-icon slot="right" name="arrow-right"></u-icon>
				</u-form-item>
				<u-form-item required labelWidth="80" label="工种" required prop="work_type_name" borderBottom @click="showType = true; hideKeyboard()" ref="item1">
					<u--input v-model="userInfo.work_type_name" disabled disabledColor="#ffffff" placeholder="请选择工种" border="none"></u--input>
					<u-icon slot="right" name="arrow-right"></u-icon>
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
				<view class="btn-box">
					<u-button
						type="primary"
						text="提交"
						style="background: #42a1f7;border:0;height: 70rpx;"
						customStyle="margin-top: 50px"
						@click="submit"
					></u-button>
					<!-- <u-button
						type="error"
						text="重置"
						style="background: #2e97db;border:0;height: 70rpx;background-image: linear-gradient(#1f70af, #319de0, #1f70af);"
						customStyle="margin-top: 20px"
						@click="reset"
					></u-button> -->
				</view>
			</u--form>
		</view>
		<view class="user-box" v-if="check_status==0" style="min-height:400rpx;display: flex;align-items: center;justify-content: center;">
			<u-icon name="clock-fill" color="#2979ff" size="66"></u-icon>
			<view class="check-status">
				审核中
			</view>
		</view>
		<view class="user-box" v-if="check_status==1" style="min-height:400rpx;display: flex;align-items: center;justify-content: center;">
			<u-icon name="checkmark-circle-fill" color="#2979ff" size="66"></u-icon>
			<view class="check-status">
				已通过
			</view>
		</view>
		<view class="user-box" v-if="check_status==2" style="min-height:400rpx;display: flex;align-items: center;justify-content: center;">
			<u-icon name="close-circle-fill" color="#fa3534" size="66"></u-icon>
			<view class="check-status">
				已拒绝
			</view>
		</view>
		<u-picker
		:show="showCenter" 
		@cancel="cancel" 
		@confirm="confirm" 
		closeOnClickOverlay 
		keyName="dict_label"
		:columns="[operationCenter]" 
		@close="showCenter = false" 
		></u-picker>
		<u-picker
		:show="showType" 
		@cancel="type_cancel" 
		@confirm="type_confirm" 
		closeOnClickOverlay 
		keyName="dict_label"
		:columns="[workType]" 
		@close="showType = false" 
		></u-picker>
	</view>
</template>

<script>
	import pickRegions from '@/components/pick-regions/pick-regions.vue'
	import {saveRegisterInfo,getWorkType,getOperationCenter} from '@/api/app/qrcode/index.js'
	import storage from '@/utils/storage'
	import { OPENID} from '@/store/mutation-types'
	export default{
		components:{ pickRegions },
		data(){
			return{
				showType:false,
				showCenter:false,
				operationCenter:[],
				workType:[],
				check_status:-1,
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
					status:0,
					operation_center:'',
					operation_center_name:'',
					work_type:'',
					work_type_name:''
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
					operation_center: {
						type: 'string',
						required: true,
						message: '请选择运营中心',
						trigger: ['change']
					},
					work_type: {
						type: 'string',
						required: true,
						message: '请选择工种',
						trigger: ['change']
					},
				}
			}
		},
		onLoad({dealer_id,status}) {
			this.dealer_id=dealer_id
			this.check_status=status||-1
			this.getOperationCenter()
			this.getWorkType()
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
			hideKeyboard() {
				uni.hideKeyboard()
			},
			confirm(e) {
				console.log('confirm', e);
				this.showCenter = false
				this.userInfo.operation_center=e.value[0].dict_value
				this.userInfo.operation_center_name=e.value[0].dict_label
				// this.model.farmInfo.typeName=e.value[0].label
			},
			cancel() {
				this.showCenter = false
			},
			type_confirm(e) {
				console.log('confirm', e);
				this.typeCenter = false
				this.userInfo.work_type=e.value[0].dict_value
				this.userInfo.work_type_name=e.value[0].dict_label
				// this.model.farmInfo.typeName=e.value[0].label
			},
			type_cancel() {
				this.typeCenter = false
			},
			getOperationCenter(){
				getOperationCenter({}).then(res=>{
					this.operationCenter=res.data.map(item=>({
						...item,
						id:item.dict_value
					}))
					console.log(this.operationCenter)
				})
			},
			getWorkType(){
				getWorkType({}).then(res=>{
					this.workType=res.data.map(item=>({
						...item,
						id:item.dict_value
					}))
				})
			},
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
							this.check_status=0
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
		width: 100%;
		border-radius: 10rpx;
	    background: #f7f8f8;
		position: relative;
	}
</style>
<style lang="scss" scoped>
	.container{
		.top-bk{
			width: 100%;
			height: 200px;
			background: #42a1f7;
			position: fixed;
			top: 0;
		}
	}
	.user-box{
		width: 93%;
		display: flex;
		justify-content: flex-start;
		align-items: center;
		flex-direction: column;
		border-radius: 10rpx;
		background: white;
		position: relative;
		margin: 0 auto;
		margin-top: 50px;
		.check-status{
			font-size: 30rpx;
			margin-top: 20rpx;
		}
		.user-box-title{
			width: 100%;
			height: 90rpx;
			display: flex;
			justify-content: flex-start;
			align-items: center;
			font-size: 28rpx;
			padding: 20rpx;
			box-sizing: border-box;
			border-bottom: 1px solid #e5e5e5;
		}
		.u-form{
			width: 95%;
			// margin-top: 90rpx;
			padding: 0 20rpx;
			box-sizing: border-box;
		}
	}
	.btn-box{
		width: 85%;
		height: auto;
		position: relative;
		margin: 0 auto;
		margin-top: 300rpx;
		// bottom: 240rpx;
	}
</style>
