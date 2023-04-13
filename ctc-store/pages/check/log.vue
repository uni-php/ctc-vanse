<template>
	<mescroll-body style="width: 100%;" ref="mescrollRef" :sticky="true" @init="mescrollInit" :down="{ native: true }" @down="downCallback"
	    :up="upOption" @up="upCallback">
	<view class="container">
		<view class="u-demo-block__content" style="width: 95%;">
			<view class="u-page__tag-item">
				<u-search v-model="keywords" placeholder="奖品名称/订单号" actionText="搜索" @custom="search"  @search="search"></u-search>
			</view>
		</view>
		<view class="check-log">
			<view class="log-item" v-for="(item,index) in listData.data" :key="index" v-if="index<=4">
				<u--text size="14" :bold="true" :text="'礼品名称：'+goods(item)"></u--text>
				<u--text style="margin:6rpx 0" size="13" :text="'二维码编号：'+item.code"></u--text>
				<u--text size="13" color="#999" :text="'核销时间：'+item.check_time"></u--text>
			</view>
		</view>
	</view>
	</mescroll-body>
</template>

<script>
	import MescrollBody from '@/components/mescroll-uni/mescroll-body.vue'
	import MescrollMixin from '@/components/mescroll-uni/mescroll-mixins'
	import { getEmptyPaginateObj, getMoreListData } from '@/core/app'
	import {STORE_INFO } from '@/store/mutation-types'
	import {getCheckLog} from '@/api/check/index.js'
	import storage from '@/utils/storage'
	const pageSize = 10
	export default{
		components: {
		    MescrollBody
		},
		mixins: [MescrollMixin],
		data(){
			return{
				store_info:{},
				dealer_id:'',
				keywords:'',
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
		onLoad() {
			this.store_info=storage.get(STORE_INFO)
		},
		methods:{
			/**
			   * 上拉加载的回调 (页面初始化时也会执行一次)
			   * 其中page.num:当前页 从1开始, page.size:每页数据条数,默认10
			   * @param {Object} page
			   */
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
			 		dealer_id:this.store_info.dealer_id,
			 		store_id:this.store_info.id,
			 		keywords:this.keywords,
			 	}
			 	return new Promise((resolve, reject) => {
			 	  getCheckLog(param)
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
			 goods(val){
			   return JSON.parse(val.gift)[0].gift_name+`(礼品id:${JSON.parse(val.gift)[0].gift_id})`
			 },
			 search(){
				 this.listData = getEmptyPaginateObj()
				 this.mescroll.resetUpScroll()
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
		padding: 20rpx;
		box-sizing: border-box;
		.check-log{
			width: 100%;
			margin-top: 50rpx;
			display: flex;
			flex-direction: column;
			.log-item{
				display: flex;
				justify-content: flex-start;
				flex-direction: column;
				width: 100%;
				height: auto;
				border-bottom: 1px solid #eeeeee;
				padding: 20rpx;
				box-sizing: border-box;
			}
		}
	}
</style>