<template>
	<mescroll-body ref="mescrollRef" :sticky="true" @init="mescrollInit" :down="{ native: true }" @down="downCallback"
	    :up="upOption" @up="upCallback">
		<view class="container">
			<u-search @search="search" @custom="search" :showAction="true" v-model="keyword" actionText="搜索" :animation="true"></u-search>
			<view class="u-demo-block__content">
				<u-tabs :list="nav_list"  @change="changeTab" :current="current" lineColor="#fa3534" :scrollable="false">
				</u-tabs>
			</view>
			<view class="gift-box">
				<view class="recom-item" v-for="(it,idx) in giftList.data" :key="idx" @click="checkDes(it)">
					<u--image :showLoading="true" :src="it.cover[0].url" width="85px" height="85px"></u--image>
					<view class="recom-info">
						<u--text :lines="2" :text="it.gift_name" size="14"></u--text>
						<u--text :text="'已兑换'+it.exchanged_num" color="gray" size="12"></u--text>
						<view class="recom-points">
							<u-icon name="integral" color="#ff9900" size="18"></u-icon>
							<u--text style="flex:none" :text="it.points_num" color="#ff9900" size="12"></u--text>
							<u--text v-if="it.type==2" :text="'+￥'+it.money" color="#ff9900" size="12"></u--text>
						</view>
						<view class="shopping-cart">
							<u-icon name="shopping-cart-fill" color="#fa3534" size="28"></u-icon>
						</view>
					</view>
				</view>
			</view>
		</view>
	</mescroll-body>
</template>

<script>
	import * as Api from '@/api/app/points/index.js'
	import { DEALERID,OPENID } from '@/store/mutation-types'
	import MescrollBody from '@/components/mescroll-uni/mescroll-body.vue'
	import MescrollMixin from '@/components/mescroll-uni/mescroll-mixins'
	import { getEmptyPaginateObj, getMoreListData } from '@/core/app'
	const pageSize = 10
	import storage from '@/utils/storage'
	export default{
		components: {
		    MescrollBody,
		},
		mixins: [MescrollMixin],
		data(){
			return{
				// 上拉加载配置
				upOption: {
				  // 首次自动执行
				  auto: true,
				  // 每页数据的数量; 默认10
				  page: { size: pageSize },
				  // 数量要大于4条才显示无更多数据
				  noMoreSize: 4,
				},
				pageNum:1,
				pageSize:10,
				current:0,
				keyword:'',
				giftList:getEmptyPaginateObj(),
				nav_list: [
					{   id:1,
						name: '默认'
					}, {
						id:2,
						name: '兑换量',
					}, {
						id:3,
						name: '积分值',
					}, {
						id:4,
						name: '我能兑换'
					}
				]
			}
		},
		onShow(){
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
				app.getGiftsList(page.num)
				  .then(list => {
					const curPageLen = list.data.length
					const totalSize = list.data.total
					app.mescroll.endBySize(curPageLen, totalSize)
				  })
				  .catch(() => app.mescroll.endErr())
			  },
			changeTab(val){
				this.current = val.index
				this.giftList = getEmptyPaginateObj()
				this.mescroll.resetUpScroll()
			},
			search(){
				this.giftList = getEmptyPaginateObj()
				this.mescroll.resetUpScroll()
			},
			checkDes(item){
				uni.$u.route({
					url:'/pages/goods_info/index',
					params: {
						goods_id: item.id
					}
				});
			},
			getGiftsList(pageNo = 1){
				const app = this
				const params={
					page:pageNo,
					pageSize:app.pageSize,
					dealer_id:storage.get(DEALERID),
					keywords:this.keyword,
					type:this.current*1 + 1
				}
				return new Promise((resolve, reject) => {
					Api.getGiftsList(params)
						.then(result => {
						  // 合并新数据
						  const newList = result.data.list
						  app.giftList.data = getMoreListData(newList, app.giftList, pageNo)
						  resolve(newList)
						})
						.catch(reject)
				})
			}
		}
	}
</script>

<style lang="scss" scoped>
	.container{
		padding: 20rpx;
	}
	.gift-box{
		width: 100%;
		display: flex;
		justify-content: center;
		align-items: center;
		flex-direction: column;
		.recom-item{
			width: 100%;
			height: 200rpx;
			display: flex;
			padding: 0 20rpx;
			box-sizing: border-box;
			justify-content: space-between;
			align-items: center;
			border-bottom: 1px solid #eeeeee;
			.recom-info{
				width: calc(100% - 100px);
				height: 85%;
				display: flex;
				flex-direction: column;
				justify-content: flex-start;
				position: relative;
				.shopping-cart{
					position: absolute;
					right: 10rpx;
					bottom: 10rpx;
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
</style>
