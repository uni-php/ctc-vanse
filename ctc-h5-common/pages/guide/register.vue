<template>
	<view class="container">
		<view class="top-bk"></view>
		<view class="user-box">
			<view class="user-box-title">
				<u-icon name="file-text" color="#42a1f7" size="24"></u-icon>请填写注册信息
			</view>
			<u--form labelPosition="left" labelWidth="80" :model="userInfo" :rules="rules"  ref="form">
				<u-form-item required label="手机号(账号):" borderBottom prop="phone" >
					<u--input border="none" v-model="userInfo.phone" placeholder="请填写手机号" ></u--input>
				</u-form-item>
				<u-form-item required label="姓名:" borderBottom prop="name" >
					<u--input border="none" v-model="userInfo.name" placeholder="请填写姓名" ></u--input>
				</u-form-item>
				<u-form-item required label="微信号:" borderBottom prop="wechat" >
					<u--input border="none" v-model="userInfo.wechat" placeholder="请填写微信号" ></u--input>
				</u-form-item>
				<!-- 所属分组 -->
				<u-form-item
						label="所属分组"
						prop="group"
						required
						style="width: 90%;"
						borderBottom
						@click="showGroup = true; hideKeyboard()"
						ref="item1"
				>
					<u--input
							v-model="userInfo.group"
							disabled
							disabledColor="#ffffff"
							placeholder="请选择所属分组"
							border="none"
					></u--input>
					<u-icon
							
							name="arrow-right"
					></u-icon>
					<u-tag @click="handleClickConditon" :text="select_group.condition_title" v-if="select_group.is_condition==1" slot="right" size="mini" icon="info-circle" plain></u-tag>
				</u-form-item>
				<u-form-item label="选择地址:" required  borderBottom prop="address" >
					<pick-regions :defaultRegion="defaultRegionCode" @getRegion="handleGetRegion">
						<text>{{regionName}}</text>
					</pick-regions>
				</u-form-item>
				<u-form-item label="详细住址:" required borderBottom prop="location" >
					<u--input border="none" v-model="userInfo.location" placeholder="请填写详细住址" ></u--input>
				</u-form-item>
				<u-form-item
						label="所属门店"
						prop="store"
						required
						borderBottom
						@click="showStore = true; hideKeyboard()"
						ref="item1"
				>
					<u--input
							v-model="userInfo.store"
							disabled
							disabledColor="#ffffff"
							placeholder="请选择所属门店"
							border="none"
					></u--input>
					<u-icon
							slot="right"
							name="arrow-right"
					></u-icon>
				</u-form-item>
				<view class="btn-box">
					<u-button
						type="primary"
						text="提交"
						style="background: #42a1f7;border:0;height: 70rpx;"
						customStyle="margin-top: 50px"
						@click="submit"
					></u-button>
				</view>
			</u--form>
			<u-action-sheet
					:show="showGroup"
					:actions="groupList"
					title="请选择分组"
					@close="showGroup = false"
					@select="groupSelect"
			>
			</u-action-sheet>
			<u-action-sheet
					:show="showStore"
					:actions="storeList"
					title="请选择门店"
					@close="showStore = false"
					@select="storeSelect"
			>
			</u-action-sheet>
			<u-popup mode="center" :round="10" :show="condition_show" @close="condition_show=false">
				<view style="height:300px;width: 550rpx;padding: 20px;text-indent: 2em;word-break: break-all;">
					<text>{{select_group.condition_content}}</text>
				</view>
			</u-popup>
		</view>
	</view>
</template>

<script>
	import pickRegions from '@/components/pick-regions/pick-regions.vue'
	import storage from '@/utils/storage'
	import { OPENID} from '@/store/mutation-types'
	import {getStoreList,getGuideGroupList,saveRegisterInfo} from '@/api/app/guide/index.js'
	export default{
		components:{ pickRegions },
		data(){
			return{
				groupList:[
					{
						name:'分组一',
						id:1
					}
				],
				condition_show:false,
				select_group:{},
				is_condition:false,
				storeList:[],
				showStore:false,
				showGroup:false,
				dealer_id:'',
				region:[],
				defaultRegion:['','',''],
				defaultRegionCode:'',
				userInfo:{
					wechat:'',
					phone:'',
					name:'',
					group:'',
					group_id:'',
					store:'',
					store_id:'',
					location:'',
					remark:'',
					status:0
				},
				rules:{
					phone: {
						type: 'string',
						required: true,
						message: '请填写手机号',
						trigger: ['change']
					},
					name: {
						type: 'string',
						required: true,
						message: '请填写姓名',
						trigger: ['change']
					},
					wechat: {
						type: 'string',
						required: true,
						message: '请填写微信号',
						trigger: ['change']
					},
					location:{
						type: 'string',
						required: true,
						message: '请填写详细地址',
						trigger: ['change']
					},
					group: {
						type: 'string',
						required: true,
						message: '请选择分组',
						trigger: ['change']
					},
					store: {
						type: 'string',
						required: true,
						message: '请选择门店',
						trigger: ['change']
					}
				}
			}
		},
		onLoad({dealer_id}) {
			this.dealer_id=dealer_id
		},
		onShow() {
			this.getStoreList()
			this.getGuideGroupList()
		},
		computed:{
			regionName(){
				// 转为字符串
				return this.region.map(item=>item.name).join(' ')||'请选择省市区'
			}
		},
		methods:{
			handleClickConditon(){
				this.condition_show=true
			},
			handleGetRegion(region){
				this.region = region
			},
			groupSelect(val){
				console.log(val)
				this.userInfo.group=val.name
				this.userInfo.group_id=val.id
				this.select_group =val
			},
			storeSelect(val){
				this.userInfo.store=val.name
				this.userInfo.store_id=val.id
			},
			getStoreList(){
				getStoreList({dealer_id:this.dealer_id}).then(res=>{
					this.storeList = res.data.map(item=>({
						name:item.store_name,
						id:item.id
					}))
				})
			},
			getGuideGroupList(){
				getGuideGroupList({dealer_id:this.dealer_id}).then(res=>{
					this.groupList = res.data.map(item=>({
						name:item.group_name,
						is_condition:item.is_condition,
						condition_content:item.condition_content,
						condition_title:item.condition_title,
						id:item.id
					}))
				})
			},
			hideKeyboard() {
				uni.hideKeyboard()
			},
			submit(){
				this.$refs.form.validate().then(res => {
					if(!uni.$u.test.mobile(this.userInfo.phone)) return uni.$u.toast('请检查手机号格式')
					if(this.region.length==0) return uni.$u.toast('请选择地址')
					this.userInfo.dealer_id=this.dealer_id
					// this.userInfo.address=this.region.map(item=>item.name).join(' ')||''
					this.userInfo.province= this.region.map(item=>item.name)[0]
					this.userInfo.city = this.region.map(item=>item.name)[1]
					this.userInfo.district = this.region.map(item=>item.name)[2]
					this.userInfo.address = this.userInfo.location
					this.userInfo.openid = storage.get(OPENID)
					saveRegisterInfo(this.userInfo).then(res=>{
						if(res.status==200){
							uni.$u.toast('提交成功')
							setTimeout(()=>{
								uni.$u.route({
									url: 'pages/guide/index',
									type:'redirect',
									params: {
										check_status: res.data.check_status,
										store_name:this.userInfo.store
									}
								})
							},500)
						}else{
							uni.$u.toast('请联系管理员')
						}
					})
				}).catch(errors => {
					uni.$u.toast('请检查必填项')
				})
			}
		}
	}
</script>

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
