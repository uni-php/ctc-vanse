<template>
	<view class="container">
		<view class="set-btn-box" v-if="car_gifts.length>0">
			<view class="">
				礼品数量：{{sum}}
			</view>
			<view class="set-btn" @click="set_btn">
				{{is_edit==0?'管理':'完成'}}
			</view>
		</view>
		<u-gap bgColor="#f3f4f6" height="1"></u-gap>
		<view class="gift-box">
			<view class="gift-item" v-for="(item,index) in car_gifts" :key="index">
				<u-checkbox-group
					v-model="item.is_selected"
					activeColor="#fa2209"
					@change="selectItem($event,index)"
					placement="column"
				>
					<u-checkbox
						shape="circle"
						:customStyle="{marginBottom: '8px'}"
						label=""
						:name="item.id"
					>
					</u-checkbox>
				</u-checkbox-group>
				<u--image radius="8" :showLoading="true" :src="item.gift_info.cover[0].url" width="85px" height="85px"></u--image>
				<view class="recom-info">
					<u--text :text="item.gift_info.gift_name" size="14"></u--text>
					<u--text :text="'已兑换'+ item.gift_info.exchanged_num" color="gray" size="12"></u--text>
					<view class="recom-points">
						<u-icon name="integral" color="#ff9900" size="16"></u-icon>
						<u--text style="flex:none" :text="item.gift_info.points_num" color="#ff9900" size="10"></u--text>
						<u--text  v-if="item.gift_info.type==2" :text="' +￥'+item.gift_info.money" color="#ff9900" size="10"></u--text>
					</view>
					<view class="count-box">
						<lxc-count 
							@handleCount="handleCountClick(item)" 
							:value.sync="item.gift_num"
							:min=1
							:delayed="100"
							>
						</lxc-count>
					</view>
				</view>
			</view>
		</view>
		<view class="settlement-box" v-if="car_gifts.length>0">
			<u-checkbox-group
				v-model="all_status"
				activeColor="#fa2209"
				@change="selectAll"
				placement="column"
			>
				<u-checkbox
					shape="circle"
					:customStyle="{marginBottom: '8px'}"
					label="全选"
					:name="1"
				>
				</u-checkbox>
			</u-checkbox-group>
			<view class="cart-info">
				<view class="cart-info-sum">
					<u--text text="合计:" size="13"></u--text>
					<view class="sum-money">
						<u-icon name="integral" color="#ff9900" size="16"></u-icon>
						<u--text style="flex:none" :text="sum_points" color="#ff9900" size="10"></u--text>
						<u--text  :text=" '+'+' ￥'+sum_money" color="#ff9900" size="10"></u--text>
					</view>
				</view>
				<view class="settlement-btn" :style="{background:(is_edit!=1&&settle_sum==0)?'opacity:0.5':''}" @click="settle">
					{{is_edit==1?'删除':`结算(${settle_sum})`}}
				</view>
			</view>
		</view>
		<u-modal
			content="您确定要删除商品吗？"
			:show="clearShow"
			showCancelButton
			closeOnClickOverlay
			@confirm="confirm"
			@cancel="clearShow=false"
			@close="clearShow=false"
		></u-modal>
	</view>
</template>

<script> 
	import lxcCount from '@/components/lxc-count/lxc-count.vue'
	import storage from '@/utils/storage'
	import * as Api from '@/api/app/points/index.js'
	import { DEALERID,OPENID } from '@/store/mutation-types'
	export default{
		components:{
			lxcCount
		},
		data(){
			return{
				clearShow:false,
				is_edit:0,
				car_gifts:[
					{
						gift_id:1,
						cover:'https://cdn.uni-2id.com/points_rule.png',
						points_num:20,
						gift_name:'测试1',
						is_selected:[1],
						money:10,
						num:2,
						type:1 //积分兑换
					},
					{
						gift_id:2,
						cover:'https://cdn.uni-2id.com/points_rule.png',
						points_num:20,
						is_selected:[2],
						gift_name:'测试2',
						money:10,
						num:3,
						type:2 //积分+现金兑换
					}
				],
				sum:0,
				all_status:[1],
				src:"https://cdn.uni-2id.com/points_rule.png"
			}
		},
		onShow() {
			this.getCartList()
		},
		computed:{
			// sum(){
			// 	let sum=0
			// 	const valid_gifts=this.car_gifts.filter(item=>item.is_selected.length!=0)
			// 	valid_gifts.forEach((item,index)=>{
			// 		sum += item.num
			// 	})
			// 	return sum
			// },
			//结算数量
			settle_sum(){
				let sum=0
				const valid_gift = this.car_gifts.filter(item=>item.is_selected.length!=0)
				valid_gift.forEach((item,index)=>{
					sum+=item.gift_num
				})
				return sum
			},
			//总积分
			sum_points(){
				let sum=0
				const valid_gifts=this.car_gifts.filter(item=>item.is_selected.length!=0)
				valid_gifts.forEach((item,index)=>{
					sum += item.gift_info.points_num*1 * item.gift_num
				})
				return sum
			},
			//总价格
			sum_money(){
				let sum=0
				const valid_gifts=this.car_gifts.filter(item=>item.is_selected.length!=0&&item.gift_info.type==2)
				valid_gifts.forEach((item,index)=>{
					sum += item.gift_info.money*1 * item.gift_num
				})
				return sum
			}
		},
		methods:{
			set_btn(){
				this.is_edit=this.is_edit*-1 + 1
			},
			selectItem(val,index){
				this.$set(this.car_gifts[index],'is_selected',val)
				const selected=this.car_gifts.filter((item,index)=>{
					return item.is_selected.length>0
				})
				if(selected.length<this.car_gifts.length){
					this.all_status=[]
				}else{
					this.all_status=[1]
				}
			},
			selectAll(val){
				if(val.length==0){
					this.car_gifts.map(item=>{
					  return item.is_selected=[]
					})
				}else{
					this.car_gifts.map(item=>{
						return item.is_selected=[item.id]
					})
				}
			},
			settle(){
				if(this.is_edit==0){
					if(this.settle_sum==0) return this.$toast('请先选择商品！')
					const cartIds = this.car_gifts.filter(item=>item.is_selected!=0).map(item=>item.id).join(',')
					//前去下单页面
					uni.$u.route({
						url:'/pages/settlement/index',
						params: {
							cartIds: cartIds
						}
					});
				}else{
					//删除购物车
					if(this.settle_sum==0) return this.$toast('请先选择商品！')
					this.clearShow=true
				}
			},
			confirm(){
				const cart_ids=this.car_gifts.filter(item=>item.is_selected.length!=0).map(item=>item.is_selected[0])
				console.log(cart_ids)
				const params={
					cart_ids:cart_ids,
					dealer_id:storage.get(DEALERID),
					openid:storage.get(OPENID)
				}
				Api.clearCart(params).then(res=>{
					if(res.status==200){
						uni.$u.toast(res.message)
						this.clearShow=false
						this.getCartList()
					}else{
						uni.$u.toast(res.message)
						this.clearShow=false
					}
				})
			},
			//更新购物车
			handleCountClick(item){
				const params={
					points_gift_id:item.points_gift_id,// 礼品id
					gift_num:item.gift_num,
					gift_sku_id:0,
					dealer_id:storage.get(DEALERID),
					openid:storage.get(OPENID)
				}
				Api.updateCart(params).then(res=>{
					if(res.status==200){
						uni.$u.toast(res.message)
						this.getCartList()
					}else{
						uni.$u.toast(res.message)
					}
				})
			},
			getCartList(){
				const params={
					dealer_id:storage.get(DEALERID),
					openid:storage.get(OPENID)
				}
				Api.getCartList(params).then(res=>{
					this.sum=res.data.cartTotal
					this.car_gifts=res.data.list
				})
			}
		}
	}
</script>

<style lang="scss" scoped>
	page{
		background: #f3f4f6;
	}
	.container{
		width: 100%;
		height: auto;
		.set-btn-box{
			width: 100%;
			height: 80rpx;
			padding: 0 20rpx;
			box-sizing: border-box;
			font-size: 28rpx;
			background: white;
			display: flex;
			justify-content: space-between;
			align-items: center;
			.set-btn{
				width: auto;
				color: $uni-text-color-active;
			}
		}
		.gift-box{
			width: 100%;
			height: auto;
			display: flex;
			justify-content: center;
			align-items: center;
			flex-direction: column;
			background: white;
			.gift-item{
				width: 100%;
				height: 200rpx;
				display: flex;
				padding: 0 20rpx;
				box-sizing: border-box;
				justify-content: flex-start;
				align-items: center;
				border-bottom: 1px solid #eeeeee;
				position: relative;
				.recom-info{
					width: calc(100% - 220rpx);
					height: 85%;
					display: flex;
					flex-direction: column;
					justify-content: flex-start;
					position: relative;
					padding-left: 10rpx;
					box-sizing: border-box;
					.count-box{
						position: absolute;
						right: 5rpx;
						bottom: 5rpx;
					}
				}
				.recom-points{
					width: 100%;
					display: flex;
					justify-content: flex-start;
					align-items: center;
					flex-wrap: nowrap;
				}
			}
		}
		.settlement-box{
			width: 100%;
			height: 100rpx;
			position: fixed;
			bottom: 50px;
			background: white;
			display: flex;
			justify-content: space-between;
			align-items: center;
			padding-left: 10rpx;
			box-sizing: border-box;
			.cart-info{
				min-width: 40%;
				height: 100%;
				display: flex;
				justify-content: space-between;
				align-items: center;
				.cart-info-sum{
					width: 100%;
					height: 100%;
					display: flex;
					flex-direction: column;
					justify-content: flex-start;
					.sum-money{
						width: 100%;
						height: 50%;
						display: flex;
						justify-content: flex-start;
						align-items: center;
						flex-wrap: nowrap;
					}
				}
				.settlement-btn{
					width: 300rpx;
					height: 100%;
					display: flex;
					justify-content: center;
					align-items: center;
					background: $uni-text-color-active;
					color: white;
					font-size: 26rpx;
				}
			}
		}
	}
</style>
