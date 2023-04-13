<template>
		<view class="content-box">
			<view class="search-box">
				<u-search @search="search" @custom="search" :showAction="true" v-model="keywords" actionText="搜索" :animation="true"></u-search>
			</view>
			<view class="filter-box">
				<view :class="['filter-item',item.id==filter_idx?'active':'']" @click="handleFilter(item,index)" v-for="(item,index) in filter" :key="index">
					{{item.name}}
					<view v-if="item.id!=1">
						<u-icon v-if="(!item.status&&item.status!=0)||item.status==1" name="arrow-up"></u-icon>
						<u-icon v-else name="arrow-down"></u-icon>
					</view>
				</view>
			</view>
			<view style="display: flex;width: 100%;flex-wrap: nowrap;">
				<view class="nav-box">
					<view class="nav-item" v-for="(item,index) in classList" :key="index">
						<view class="nav-one-item" @click="handleOne(item)" :class="[item.id==class_id?'active':'']">{{item.class_name}}</view>
						<view v-for="(it,idx) in item.children" :key="idx" :class="['nav-two-item',it.id==class_id?'active':'']"@click="handleTwo(it)">{{it.class_name}}</view>
					</view>
				</view>
				<view class="goods-box" style="position: relative;">
					<view class="goods-item" v-for="(item,index) in goodsList" :key="index" v-if="goodsList.length>0" @click="checkDes(item)">
						<u--image :showLoading="true" radius="5" :src="cover(item.cover)" width="70px" height="70px"></u--image>
						<view class="goods-info-box">
							<u--text size="14" :text="item.product_name"></u--text>
							<u--text color="#fa2209" size="12" :text="'已售：'+item.sales"></u--text>
							<u--text color="#fa2209" size="13" :text="'￥'+item.sale_price"></u--text>
						</view>
						<view class="shopping-cart" @click.stop="addCar(item)">
							<u-icon name="shopping-cart-fill" color="#fa3534" size="28"></u-icon>
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
	import storage from '@/utils/storage'
	import {getStoreGoodsClass,getStoreGoods,addCart} from '@/api/app/store_shop/index.js'
	import { DEALERID,OPENID } from '@/store/mutation-types'
	export default{
		name:'Goods',
		props:{
			store_id:{
				type:Number
			},
			dealer_id:{
				type:Number
			}
		},
		data(){
			return{
				filter:[
					{
						id:1,
						name:'全部'
					},
					{
						id:2,
						name:'最新'
					},
					{
						id:3,
						name:'销量'
					},
					{
						id:4,
						name:'价格'
					}
				],
				keywords:'',
				filter_idx:1,
				store_info:{},
				type:1,
				status:'-2',//全部
				class_one:'',
				class_two:'',
				class_id:'',
				self_product_ids:[],
				goodsList:[],
				classList:[],
				src:'https://cdn.uviewui.com/uview/album/1.jpg'
			}
		},
		created() {
			this.getStoreGoodsClass()
			this.getStoreGoods()
		},
		methods:{
			search(){
				this.getStoreGoods()
			},
			handleFilter(item,index){
				this.filter_idx=item.id
				if(item.id!=1){
					if(!item.status&&item.status!=0){
						this.$set(this.filter[index],'status',1)
						this.status=1
					}else{
						const status=this.filter[index].status*-1+1
						this.status=status
						this.$set(this.filter[index],'status',status)
					}
				}
				this.getStoreGoods()
			},
			cover(item){
				console.log(item)
				return JSON.parse(item)[0].url
			},
			getStoreGoodsClass(){
				const params={
					pageNum:1,
					pageSize:999,
					dealer_id:this.dealer_id
				}
				getStoreGoodsClass(params).then(res=>{
					this.classList=res.data
				})
			},
			checkDes(item){
				uni.$u.route({
					url:'/pages/store_shop/goods_info',
					params: {
						goods_id: item.product_id,
						app_goods_id:item.id,
						dealer_id:this.dealer_id,
						store_id:this.store_id
					}
				});
			},
			// 加入购物车
			addCar(item){
				console.log(item)
				const params={
					app_goods_id:item.id,
					store_id:this.store_id,
					goods_num:1,
					goods_sku_id:0,
					dealer_id:this.dealer_id,
					openid:storage.get(OPENID)||1
				}
				addCart(params).then(res=>{
					uni.$u.toast(res.message)
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
					dealer_id:this.dealer_id,
					store_id:this.store_id,
					class_one:this.class_one,
					class_two:this.class_two,
					keywords:this.keywords,
					filter_idx:this.filter_idx,
					status:this.status
				}
				getStoreGoods(params).then(res=>{
					this.goodsList=res.data
				})
			}
		}
	}
</script>

<style lang="scss" scoped>
	.content-box{
		width: 100%;
		display: flex;
		flex-wrap: nowrap;
		flex-direction: column;
		height: 100vh;
		.search-box{
			padding: 20rpx;
			width: 100%;
			display: flex;
			justify-content: center;
			align-items: center;
			box-sizing: border-box;
			.filter-item{
				width: auto;
				height: 60rpx;
				display: flex;
				justify-content: center;
				align-items: center;
				font-size: 26rpx;
			}
		}
		.filter-box{
			padding:0 20rpx;
			width: 100%;
			display: flex;
			justify-content: space-around;
			align-items: center;
			box-sizing: border-box;
			border-bottom: 1px solid #eeeeee;
			.filter-item{
				width: auto;
				height: 60rpx;
				display: flex;
				justify-content: center;
				align-items: center;
				font-size: 26rpx;
			}
			.active{
				color: red;
			}
		}
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
				.shopping-cart{
					position: absolute;
					right: 20rpx;
					bottom: 20rpx;
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
</style>