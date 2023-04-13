<template>
	<view class="container">
		<view class="shop-title">
			<u--text size="14" :text="'当前店铺【'+storeInfo.store_name+'】'"></u--text>
		</view>
		<u-gap style="width: 100%;" height="8" bgColor="#eee"></u-gap>
		<view class="nav-box">
			<view class="nav-item" v-for="(it,idx) in nav_list" @click="navTab(idx)">
				<u-avatar size="38" :src="it.icon"></u-avatar>
				<view style="margin-top: 8rpx;"><u--text size="13" :text="it.text"></u--text></view>
			</view>
		</view>
		<!-- 商品组件 -->
		<Goods :dealer_id="dealer_id" :store_id="store_id" />
	</view>
</template>

<script>
	import {getStoreInfo} from '@/api/app/store_shop/index.js'
	import Goods from './components/goods.vue'
	export default{
		components:{
			Goods
		},
		data(){
			return{
				storeInfo:{},
				dealer_id:'',
				store_id:'',
				nav_list:[
					{
						text:'购物车',
						icon:require(`@//static/img/cart.jpeg`)
					},
					{
						text:'我的订单',
						icon:require(`@//static/img/order.jpeg`)
					},
					{
						text:'门店信息',
						icon:require(`@//static/img/notice.jpeg`)
					},
					{
						text:'个人中心',
						icon:require(`@//static/img/user.jpeg`)
					}
				]
			}
		},
		onLoad({dealer_id,store_id}) {
			this.dealer_id=dealer_id||29,
			this.store_id=store_id||1
		},
		onShow() {
			this.getStoreInfo()
		},
		methods:{
			navTab(idx){
				if(idx==0){
					uni.$u.route({
						url:'pages/store_shop/cart',
						params: {
							store_id: this.store_id,
							dealer_id: this.dealer_id
						}
					});
				}
				if(idx==2){
					uni.$u.route({
						url:'pages/store_shop/store_info',
						params: {
							store_id: this.store_id,
							dealer_id: this.dealer_id
						}
					});
				}
				if(idx==1){
					uni.$u.route({
						url:'pages/store_shop/order',
						params: {
							store_id: this.store_id,
							dealer_id: this.dealer_id
						}
					});
				}
				if(idx==3){
					const url='http://yx.uni-2id.com/user?dealer_id='+this.dealer_id
					window.location.href=url
				}
			},
			getStoreInfo(){
				const params={
					store_id:this.store_id,
					dealer_id:this.dealer_id
				}
				getStoreInfo(params).then(res=>{
					this.storeInfo=res.data
				})
			}
		}
	}
</script>

<style lang="scss" scoped>
	.container{
		display: flex;
		justify-content: center;
		align-items: center;
		flex-direction: column;
		.shop-title{
			width: 100%;
			height: 75rpx;
			padding:0 20rpx;
			box-sizing: border-box;
			display: flex;
			align-items: center;
		}
		.nav-box{
			width: 100%;
			height: 180rpx;
			display: flex;
			justify-content: center;
			align-items: center;
			// background: gray;
			.nav-item{
				width: 25%;
				height: 100%;
				display: flex;
				justify-content: center;
				align-items: center;
				flex-direction: column;
			}
		}
	}
</style>