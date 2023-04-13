<template>
	<view class="container">
		<view class="address-box" v-if="addressList.length>0">
			<u-radio-group
			    v-model="radiovalue"
			    placement="column"
			  >
				<view class="address-item" v-for="(item,index) in addressList" :key="index">
					<view class="user-info">
						<view class="name">{{item.consignee}}</view>
						<view class="phone">
							{{item.phone}}
						</view>
					</view>
					<view class="user-address" style="margin-top: 6rpx;justify-content: flex-start;">
						<view class="tag" v-if="item.is_default==2">
							默认
						</view>
						<view class="addreess">
							{{item.address+' '+item.location}}
						</view>
					</view>
					<u-line margin="10px"></u-line>
					<view class="set-box">
						<u-radio
						      :customStyle="{marginBottom: '8px'}"
						      label="设置成默认地址"
						      :name="item.is_default"
							   @change="groupChange($event,index,item)"
						    >
						</u-radio>
						<view style="display: flex;flex-wrap: nowrap;">
							<u-icon name="edit-pen" @click="edit(item.id)"></u-icon><text style="margin-right: 8rpx;">编辑</text>
							<u-icon name="trash" @click="deleteAddress(item.id)"></u-icon><text>删除</text>
						</view>
					</view>
				</view>
			</u-radio-group>
		</view>
		<view class="address-box" v-else>
			<u-empty
			        mode="list"
					marginTop="100"
			        icon="https://cdn.uviewui.com/uview/empty/list.png"
			>
			</u-empty>
		</view>
		<view class="add-box" @click="add_address">
			<u-icon name="plus" size="12" color="#fa2209"></u-icon><text>添加收货地址</text>
		</view>
		<u-modal
			content="确认删除"
			:show="show"
			showCancelButton
			closeOnClickOverlay
			@confirm="confirm"
			@cancel="show=false"
			@close="show=false"
		></u-modal>
	</view>
</template>

<script>
	import * as Api from '@/api/app/points/index.js'
	import storage from '@/utils/storage'
	import { DEALERID,OPENID } from '@/store/mutation-types'
	export default{
		data(){
			return{
				show:false,
				icon:'https://cdn.uviewui.com/uview/demo/empty/list.png',
				addressList:[
				],
				address_id:'',
				radiovalue: 2,
			}
		},
		onShow() {
			this.getMemberAddressList()
		},
		methods:{
			getMemberAddressList(){
				const params={
					dealer_id:storage.get(DEALERID),
					openid:storage.get(OPENID)
				}
				Api.getMemberAddressList(params).then(res=>{
					this.addressList=res.data
				})
			},
			deleteAddress(id){
				this.address_id=id
				this.show=true
			},
			confirm(){
				Api.deleMemberAddress({id:this.address_id}).then(res=>{
					if(res.status==200){
						uni.$u.toast(res.message)
						this.show=false
						this.getMemberAddressList()
						this.$forceUpdate()
					}else{
						uni.$u.toast(res.message)
					}
				})
			},
			edit(id){
				uni.$u.route({
					url:'/pages/add_address/index',
					params: {
						id: id
					}
				});
			},
			groupChange(val,index,item){
				this.addressList.forEach((item,index)=>{
					this.$set(this.addressList[index],'is_default',1)
				})
				this.$set(this.addressList[index],'is_default',2)
				const params={
					dealer_id:storage.get(DEALERID),
					openid:storage.get(OPENID),
					id:item.id
				}
				Api.setDefaultMemberAddress(params).then(res=>{
					if(res.status==200){
						uni.$u.toast(res.message)
						this.getMemberAddressList()
						this.$forceUpdate()
					}else{
						uni.$u.toast(res.message)
					}
				})
			},
			add_address(){
				uni.$u.route({
					url:'/pages/add_address/index'
				});
			}
		}
	}
</script>


<style lang="scss" scoped>
	page{
		background: #f8f8f8;
	}
	.container{
		width: 100%;
		height: auto;
		.address-box{
			width: 100%;
			height: auto;
			display: flex;
			justify-content: center;
			align-items: center;
			flex-direction: column;
			.u-radio-group--column{
				width: 100%;
			}
			.address-item{
				width: 100%;
				height: 200rpx;
				padding: 20rpx;
				box-sizing: border-box;
				background: white;
				display: flex;
				justify-content: center;
				align-items: center;
				flex-direction: column;
				margin-bottom: 20rpx;
				.user-info,.user-address{
					width: 100%;
					display: flex;
					justify-content: space-between;
					align-items: center;
					.tag{
						width: 50rpx;
						height: 30rpx;
						padding: 4rpx;
						display: flex;
						justify-content: center;
						align-items: center;
						font-size: 20rpx;
						color: $uni-text-color-active;
						border: 1px solid $uni-text-color-active;
					}
					.name{
						width: 60%;
						height: auto;
						font-size: 28rpx;
						text-overflow: ellipsis;
						overflow: hidden;
						white-space: nowrap;
					}
					.phone{
						font-size: 26rpx;
					}
					.addreess{
						font-size: 22rpx;
						color: gray;
						margin-left: 10rpx;
					}
				}
				.set-box{
					width: 100%;
					display: flex;
					justify-content: space-between;
					align-items: center;
					font-size: 16rpx;
				}
			}
		}
		.add-box{
			width: 100%;
			height: 80rpx;
			display: flex;
			justify-content: center;
			align-items: center;
			font-size: 20rpx;
			position: fixed;
			bottom: 0;
			background: white;
			color: $uni-text-color-active;
		}
	}
</style>