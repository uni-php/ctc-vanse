<template>
	<view class="container">
		<u--form
			labelPosition="left"
			labelWidth="80"
			:model="addressInfo"
			:rules="rules"
			ref="form"
		>
			<u-form-item
				label="收货人"
				prop="consignee"
				borderBottom
				required=""
				ref="item1"
			>
				<u--input
					v-model="addressInfo.consignee"
					placeholder="请输入收货人"
					border="none"
				></u--input>
			</u-form-item>
			<u-form-item
				label="手机号"
				prop="phone"
				required
				borderBottom
				ref="item1"
			>
				<u--input
					v-model="addressInfo.phone"
					placeholder="请输入手机号"
					border="none"
				></u--input>
			</u-form-item>
			<u-form-item required label="选择地址:" borderBottom prop="address" >
				<pick-regions :defaultRegion="defaultRegionCode" @getRegion="handleGetRegion">
					<text>{{regionName}}</text>
				</pick-regions>
			</u-form-item>
			<u-form-item
			required
				label="详细地址"
				prop="location"
				borderBottom
				ref="item1"
			>
				<u--input
					v-model="addressInfo.location"
					placeholder="请输入详细地址"
					border="none"
				></u--input>
			</u-form-item>
		</u--form>
		<view class="save-box" @click="save_address">
			<text>提交</text>
		</view>
	</view>
</template>

<script>
	import * as Api from '@/api/app/points/index.js'
	import storage from '@/utils/storage'
	import { DEALERID,OPENID } from '@/store/mutation-types'
	import pickRegions from '@/components/pick-regions/pick-regions.vue'
	export default{
		components: {
		    pickRegions,
		},
		data(){
			return{
				region:[],
				address_id:'',
				addressInfo:{
					consignee:'',
					phone:'',
					location:''
				},
				defaultRegion:['','',''],
				defaultRegionCode:'',
				defaultRegion:['河北省'],
				rules:{
					'consignee': {
						type: 'string',
						required: true,
						message: '请填写收货人',
						trigger: ['blur', 'change']
					},
					'location': {
						type: 'string',
						required: true,
						message: '请填写详细地址',
						trigger: ['blur', 'change']
					},
					'phone': [
						{
							required: true, 
							message: '请输入手机号',
							trigger: ['change','blur'],
						},
						{
							// 自定义验证函数，见上说明
							validator: (rule, value, callback) => {
								// 上面有说，返回true表示校验通过，返回false表示不通过
								// uni.$u.test.mobile()就是返回true或者false的
								return uni.$u.test.mobile(value);
							},
							message: '手机号码不正确',
							// 触发器可以同时用blur和change
							trigger: ['change','blur'],
						}
					]
				}
			}
		},
		computed:{
			regionName(){
				// 转为字符串
				return this.region.map(item=>item.name).join(' ')||'请选择省市区'
			}
		},
		onLoad({id}) {
			this.address_id=id
			if(id){
				Api.queryMemberAddress({id:id}).then(res=>{
					this.addressInfo=res.data
					this.region=res.data.address.split(' ').map(item=>({
						name:item
					}))
				})
			}
		},
		onShow() {
			
		},
		methods:{
			handleGetRegion(region){
				this.region = region
			},
			save_address(){
				this.$refs.form.validate().then(res => {
					const params={
						dealer_id:storage.get(DEALERID),
						openid:storage.get(OPENID),
						...this.addressInfo,
						address:this.regionName
					}
					if(this.region.length==0) return uni.$u.toast('请选择地址')
					Api.saveMemberAddress(params).then(res=>{
						if(res.status==200){
							uni.$u.toast(res.message)
							setTimeout(()=>{
								uni.navigateBack({
									delta: 1
								});
							},1000)
						}else{
							uni.$u.toast(res.message)
						}
					})
				}).catch(errors => {
					uni.$u.toast('请完善信息')
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
		display: flex;
		justify-content: center;
		.u-form{
			width: 100%;
		}
		.save-box{
			width: 100%;
			height: 80rpx;
			display: flex;
			justify-content: center;
			align-items: center;
			font-size: 20rpx;
			position: fixed;
			bottom: 0;
			background: white;
			background: $uni-text-color-active;;
			color: white;
		}
	}
</style>