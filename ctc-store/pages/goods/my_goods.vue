<template>
	<mescroll-body style="width: 100%;" ref="mescrollRef" :sticky="true" @init="mescrollInit" :down="{ native: true }" @down="downCallback"
	    :up="upOption" @up="upCallback">
	<view class="container">
		<view class="u-demo-block__content" style="width: 100%;">
			<u-subsection
				:list="list"
				mode="subsection"
				:current="current"
				@change="change"
			></u-subsection>
		</view>
		<view class="goods-info-box" v-for="(item,index) in listData.data" :key="index">
			<u--image :showLoading="true" radius="5" :src="cover(item.cover)" width="80px" height="80px"></u--image>
			<view class="goods-info">
				<u--text :text="'商品名称：'+item.product_name"></u--text>
				<u--text style="margin:20rpx 0" color="#999" size="13" :text="'售价：'+item.sale_price"></u--text>
				<u--text color="#999" size="13" :text="'商品销量：'+item.sales"></u--text>
			</view>
			<view class="set-btn-box">
				<view class="set-btn" @click="cut(item)" v-if="current==0">下架</view>
				<view class="set-btn" @click="cut(item)" v-if="current==1">上架</view>
				<view class="set-btn" @click="edit(item)">编辑</view>
				<view class="set-btn" v-if="current==1" @click="dele(item)">删除</view>
			</view>
		</view>
	</view>
	<u-modal
		:content="'确认'+(current==0?'下架':'上架')+'?'"
		:show="show"
		showCancelButton
		asyncClose
		@confirm="confirm"
		@cancel="() => show = false"
	></u-modal>
	<u-modal
		content="确认删除?"
		:show="deleShow"
		showCancelButton
		asyncClose
		@confirm="confirmDele"
		@cancel="() => deleShow = false"
	></u-modal>
	</mescroll-body>
</template>

<script>
	import MescrollBody from '@/components/mescroll-uni/mescroll-body.vue'
	import MescrollMixin from '@/components/mescroll-uni/mescroll-mixins'
	import { getEmptyPaginateObj, getMoreListData } from '@/core/app'
	import {STORE_INFO } from '@/store/mutation-types'
	import storage from '@/utils/storage'
	import {getSelfGoods,cutSelfGoods,deleSelfGoods} from '@/api/goods/index.js'
	const pageSize = 10
	export default{
		components: {
		    MescrollBody
		},
		mixins: [MescrollMixin],
		data(){
			return{
				id:'',
				deleShow:false,
				show:false,
				list:[
					'已上架','已下架'
				],
				goodsList:[],
				store_info:{},
				current:0,
				pageSize:10,
				listData:getEmptyPaginateObj(),
				// 上拉加载配置
				upOption: {
				  // 首次自动执行
				  auto: true,
				  // 每页数据的数量; 默认10
				  page: { size: pageSize },
				  // 数量要大于4条才显示无更多数据
				  noMoreSize: 4,
				}
			}
		},
		onShow() {
			this.store_info=storage.get(STORE_INFO)
			// this.getSelfGoods()
		},
		methods:{
			upCallback(page) {
				const app = this
				// 设置列表数据
				app.getNotes(page.num)
				  .then(list => {
					  console.log(list)
					const curPageLen = list.data.length
					const totalSize = list.data.total
					app.mescroll.endBySize(curPageLen, totalSize)
				  })
				  .catch(() => app.mescroll.endErr())
			 },
			 getNotes(pageNo = 1){
			 	const app = this
			 	var param={
			 		page:pageNo,
			 		pageSize:this.pageSize,
			 		store_id:this.store_info.id,
			 		dealer_id:this.store_info.dealer_id,
			 		status:this.current
			 	}
			 	return new Promise((resolve, reject) => {
			 	  getSelfGoods(param)
			 		.then(result => {
			 		  // 合并新数据
			 		  const newList = result.data.list
					  app.listData.total=result.data.list.total
			 		  app.listData.data = getMoreListData(newList, app.listData, pageNo)
			 		  resolve(newList)
			 		})
			 		.catch(reject)
			 	})
			 },
			 dele(item){
				this.id=item.id 
				this.deleShow=true
			 },
			 cut(item){
				this.id=item.id 
				this.show=true
			 },
			 edit(item){
				uni.$u.route({
					url: 'pages/goods/add_goods',
					params: {
						self_product_id:item.self_product_id,
						app_goods_id: item.id
					}
				}) 
			 },
			 confirm(){
				const params={
					id:this.id,
					store_id:this.store_info.id,
					dealer_id:this.store_info.dealer_id,
					status:this.current*-1+(1)
				}
				cutSelfGoods(params).then(res=>{
					if(res.status==200){
						uni.$u.toast(res.message)
						this.show=false
						this.listData = getEmptyPaginateObj()
						this.mescroll.resetUpScroll()
					}else{
						this.show=false
						uni.$u.toast(res.message)
					}
				})
			 },
			 confirmDele(){
				const params={
					id:this.id,
					store_id:this.store_info.id,
					dealer_id:this.store_info.dealer_id,
				}
				deleSelfGoods(params).then(res=>{
					if(res.status==200){
						uni.$u.toast(res.message)
						this.deleShow=false
						this.listData = getEmptyPaginateObj()
						this.mescroll.resetUpScroll()
					}else{
						this.deleShow=false
						uni.$u.toast(res.message)
					}
				})
			 },
			cover(item){
				return JSON.parse(item)[0].url
			},
			change(val){
				console.log(val)
				this.current=val
				this.listData = getEmptyPaginateObj()
				this.mescroll.resetUpScroll()
			}
		}
	}
</script>

<style lang="scss" scoped>
	.container{
		padding: 20rpx;
		position: relative;
		display: flex;
		justify-content: center;
		box-sizing: border-box;
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
			margin: 10rpx 0;
			position: relative;
			.goods-info{
				padding: 20rpx;
				box-sizing: border-box;
			}
			.set-btn-box{
				position: absolute;
				display: flex;
				justify-content: center;
				align-items: center;
				flex-wrap: nowrap;
				bottom: 30rpx;
				right: 10rpx;
				.set-btn{
					min-width: 70rpx;
					height: 35rpx;
					border-radius: 10rpx;
					border: 1px solid red;
					margin-right: 20rpx;
					padding: 0 10rpx;
					font-size: 11px;
					display: flex;
					justify-content: center;
					align-items: center;
					color:red;
				}
			}
		}
	}
</style>