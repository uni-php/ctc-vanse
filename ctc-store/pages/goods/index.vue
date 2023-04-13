<template>
	<view class="container">
		<view class="content-box">
			<view class="nav-box">
				<view class="nav-item" v-for="(item,index) in classList" :key="index">
					<view class="nav-one-item" @click="handleOne(item)" :class="[item.id==class_id?'active':'']">{{item.class_name}}</view>
					<view v-for="(it,idx) in item.children" :key="idx" :class="['nav-two-item',it.id==class_id?'active':'']"@click="handleTwo(it)">{{it.class_name}}</view>
				</view>
			</view>
			<view class="goods-box" style="position: relative;">
				<view class="goods-item" v-for="(item,index) in goodsList" :key="index" v-if="goodsList.length>0">
					<u--image :showLoading="true" radius="5" :src="cover(item.cover)" width="70px" height="70px"></u--image>
					<view class="goods-info-box">
						<u--text size="14" :text="item.product_name"></u--text>
						<u--text color="#999" size="13" :text="'售价:'+price(item)+'元'"></u--text>
					</view>
					<view @click="add(item)" :class="['add-btn',self_product_ids.includes(item.id)?'has-add':'']">
						{{self_product_ids.includes(item.id)?'已添加':'添加'}}
					</view>
				</view>
				<u-empty
				v-if="goodsList.length==0"
				style="position:absolute;top:300rpx"
				mode="data"
				icon="http://cdn.uviewui.com/uview/empty/data.png"
				>
				</u-empty>
			</view>
		</view>
	</view>
</template>

<script>
	import {STORE_INFO } from '@/store/mutation-types'
	import storage from '@/utils/storage'
	import {getStoreGoodsClass,getStoreGoods} from '@/api/goods/index.js'
	export default{
		data(){
			return{
				store_info:{},
				type:1,
				class_one:'',
				class_two:'',
				class_id:'',
				self_product_ids:[],
				goodsList:[],
				self_products:[],
				classList:[],
				src:'https://cdn.uviewui.com/uview/album/1.jpg'
			}
		},
		onShow() {
			this.store_info=storage.get(STORE_INFO)
			this.getStoreGoodsClass()
			this.getStoreGoods()
		},
		methods:{
			cover(item){
				console.log(item)
				return JSON.parse(item)[0].url
			},
			getStoreGoodsClass(){
				const params={
					pageNum:1,
					pageSize:999,
					dealer_id:this.store_info.dealer_id
				}
				getStoreGoodsClass(params).then(res=>{
					this.classList=res.data
				})
			},
			price(item){
				if(!this.self_product_ids.includes(item.id)){
					return item.price
				}else{
					console.log(this.self_products)
					return this.self_products.filter(it=>it.self_product_id==item.id).map(it=>it.sale_price)[0]
				}
			},
			add(item){
				if(this.self_product_ids.includes(item.id)) return
				uni.$u.route({
					url: 'pages/goods/add_goods',
					params: {
						self_goods_id: item.id
					}
				})
			},
			handleOne(item){
				this.class_id=item.id
				this.class_one=item.id
				this.class_two=''
				this.getStoreGoods()
			},
			handleTwo(item){
				this.class_id=item.id
				this.class_two=item.id
				this.class_one=''
				this.getStoreGoods()
			},
			getStoreGoods(){
				const params={
					dealer_id:this.store_info.dealer_id,
					store_id:this.store_info.id,
					class_one:this.class_one,
					class_two:this.class_two
				}
				getStoreGoods(params).then(res=>{
					this.goodsList=res.data[0]
					this.self_products=res.data[1]
					this.self_product_ids=res.data[1].map(item=>item.self_product_id)
				})
			}
		}
	}
</script>

<style lang="scss" scoped>
	.container{
		width: 100%;
		// padding: 20rpx;
		box-sizing: border-box;
		height: auto;
		.content-box{
			width: 100%;
			display: flex;
			flex-wrap: nowrap;
			height: 100vh;
			.nav-box{
				width: 180rpx;
				height: 100%;
				overflow: auto;
				background: #eee;
				display: flex;
				flex-direction: column;
				justify-content: flex-start;
				align-items: center;
				.nav-item{
					width: 100%;
					height: auto;
					display: flex;
					justify-content: center;
					align-items: center;
					flex-direction: column;
				}
				.nav-one-item{
					width: 100%;
					height: 80rpx;
					display: flex;
					justify-content: center;
					align-items: center;
					background:#eeeeee;
					font-size: 24rpx;
				}
				.active{
					color:red;
				}
				.nav-two-item{
					width: 100%;
					min-height: 80rpx;
					display: flex;
					justify-content: center;
					align-items: center;
					background:white;
					flex-direction: column;
					font-size: 22rpx;
				}
			}
			.goods-box{
				width: calc(100% - 180rpx);
				height: 100%;
				overflow: auto;
				// background: green;
				display: flex;
				flex-direction: column;
				align-items: center;
				.goods-item{
					width: 100%;
					height: 200rpx;
					padding: 0 20rpx;
					box-sizing: border-box;
					display: flex;
					flex-wrap: nowrap;
					justify-content: flex-start;
					align-items: center;
					position: relative;
					.add-btn{
						min-width: 70rpx;
						height: 35rpx;
						border-radius: 10rpx;
						border: 1px solid red;
						padding: 0 10rpx;
						font-size: 11px;
						display: flex;
						justify-content: center;
						align-items: center;
						color:red;
						position: absolute;
						right: 20rpx;
						bottom: 40rpx;
					}
					.has-add{
						color: gray;
						border: 0;
					}
					.goods-info-box{
						padding: 20rpx;
						box-sizing: border-box;
						height: 90%;
						display: flex;
						flex-direction: column;
						justify-content: flex-start;
					}
				}
			}
		}
	}
</style>