<template>
	<view class="container">
		<view class="goods-info-box">
			<u--image :showLoading="true" radius="5" :src="cover(goods_info.cover)" width="80px" height="80px"></u--image>
			<view class="goods-info">
				<u--text :text="'商品名称：'+goods_info.product_name"></u--text>
				<u--text style="margin:20rpx 0" color="#999" size="13" :text="'商品编号：'+goods_info.code"></u--text>
				<u--text color="#999" size="13" :text="'商品分类：'+type(goods_info.class_one,goods_info.class_two)"></u--text>
			</view>
		</view>
		<view class="price-box">
			<view class="price-range">
				建议零售价：￥{{goods_info.price_small}} ~ ￥{{goods_info.price_big}}
			</view>
			<view class="price-range" style="display: flex;flex-wrap: nowrap;align-items: center;">
				中国大陆售价：￥ 
				<view style="width: 200rpx;">
					<u--input
						placeholder="请输入价格"
						border="surround"
						type="number"
						v-model="price"
					></u--input>
				</view>
			</view>
		</view>
		<u-button
			type="primary"
			text="上架"
			customStyle="margin-top: 50px;width:80%"
			@click="submit"
		></u-button>
	</view>	
</template>

<script>
	import {STORE_INFO } from '@/store/mutation-types'
	import storage from '@/utils/storage'
	import {getStoreGoodsInfo,getStoreGoodsClass,saveStoreGoods} from '@/api/goods/index.js'
	export default{
		data(){
			return{
				classList:[],
				classOptions:[],
				class_two_options:[],
				self_product_id:'',
				app_goods_id:'',
				goods_info:{},
				price:''
			}
		},
		onLoad({app_goods_id,self_product_id}) {
			this.app_goods_id=app_goods_id
			this.self_product_id=self_product_id
		},
		onShow() {
			this.store_info=storage.get(STORE_INFO)
			this.getStoreGoodsInfo()
			this.getStoreGoodsClass()
		},
		computed:{
		      type(){
		          return function(a,b){
		              var class_one=this.classOptions.filter(item=>item.id==a).map(item=>item.class_name)[0]
		              var class_two_options=this.classOptions.filter(item=>item.id==a).map(it=>it.children)[0]
		              if(class_two_options){
		                  var class_two=class_two_options.filter(item=>item.id==b).map(item=>item.class_name)[0]
		              }
		              return `${class_one}\\${class_two}`
		          }
		      }
		  },
		methods:{
			cover(item){
				return JSON.parse(item)[0].url
			},
			getStoreGoodsClass(){
				const params={
					pageNum:1,
					pageSize:999,
					dealer_id:this.store_info.dealer_id
				}
				getStoreGoodsClass(params).then(res=>{
					this.classOptions=res.data
				})
			},
			getStoreGoodsInfo(){
				const params={
					dealer_id:this.store_info.dealer_id,
					app_goods_id:this.app_goods_id,
					self_product_id:this.self_product_id
				}
				getStoreGoodsInfo(params).then(res=>{
					this.goods_info=res.data
					this.price=res.data.price
				})
			},
			submit(){
				if(!this.price) return uni.$u.toast('请输入价格')
				if(Number(this.price)<Number(this.goods_info.price_small)) return uni.$u.toast('请检查价格')
				if(Number(this.price)>Number(this.goods_info.price_big)) return uni.$u.toast('请检查价格')
				const params={
					...this.goods_info,
					dealer_id:this.store_info.dealer_id,
					store_id:this.store_info.id,
					sale_price:this.price
				}
				saveStoreGoods(params).then(res=>{
					if(res.status==200){
						uni.$u.toast(res.message)
						setTimeout(()=>{
							uni.$u.route({
							  url:'/pages/goods/index',
							  type:'redirect'
							});
						},1000)
					}else{
						uni.$u.toast(res.message)
					}
				})
			}
		}
	}
</script>

<style lang="scss" scoped>
	page{
		background: #eee;
	}
	.container{
		width: 100%;
		height: auto;
		.goods-info-box{
			width: 100%;
			height: auto;
			display: flex;
			justify-content: flex-start;
			align-items: center;
			flex-wrap: nowrap;
			background: white;
			padding: 20rpx;
			box-sizing: border-box;
			.goods-info{
				padding: 20rpx;
				box-sizing: border-box;
			}
		}
		.price-box{
			width: 98%;
			height: 300rpx;
			background: white;
			margin: 0 auto;
			margin-top: 20rpx;
			border-radius: 10rpx;
			padding: 20rpx;
			box-sizing: border-box;
			.price-range{
				width: 100%;
				margin-top: 30rpx;
				font-size: 28rpx;
			}
		}
	}
</style>