<template>
	<mescroll-body style="width: 100%;" ref="mescrollRef" :sticky="true" @init="mescrollInit" :down="{ native: true }" @down="downCallback"
	    :up="upOption" @up="upCallback">
	<view class="container">
		<view class="news-item"  v-for="(item,index) in listData.data" :key="index" @click="handleDes(item)">
			<u--text :text="item.title"></u--text>
			<u--text :size="13" color="#999" :text="item.create_time"></u--text>
		</view>
	</view>
	</mescroll-body>
</template>

<script>
	import MescrollBody from '@/components/mescroll-uni/mescroll-body.vue'
	import MescrollMixin from '@/components/mescroll-uni/mescroll-mixins'
	import { getEmptyPaginateObj, getMoreListData } from '@/core/app'
	import {STORE_INFO } from '@/store/mutation-types'
	import storage from '@/utils/storage'
	import {getNoticeList} from '@/api/notice/index.js'
	const pageSize = 10
	export default{
		components: {
		    MescrollBody
		},
		mixins: [MescrollMixin],
		data(){
			return{
				dealer_id:'',
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
				},
			}
		},
		onLoad() {
			this.dealer_id=storage.get(STORE_INFO).dealer_id
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
					dealer_id:this.dealer_id,
			 	}
			 	return new Promise((resolve, reject) => {
			 	  getNoticeList(param)
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
			 handleDes(row){
				uni.$u.route({
					url: 'pages/notice/info',
					params: {
						notice_id: row.id
					}
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
		.news-item{
			width: 100%;
			height: 150rpx;
			display: flex;
			padding: 20rpx;
			box-sizing: border-box;
			flex-direction: column;
			justify-content: flex-start;
			border-bottom: 1px solid #eeeeee;
		}
	}
</style>