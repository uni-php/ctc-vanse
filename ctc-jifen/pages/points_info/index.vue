<template>
	<mescroll-body ref="mescrollRef" :sticky="true" @init="mescrollInit" :down="{ native: true }" @down="downCallback"
	    :up="upOption" @up="upCallback">
	<view class="container">
		<view class="points-box">
			<view class="points-item" v-for="(item,index) in pointsList.data" :key="index">
				<u--text :text="type(item.app_id)"></u--text>
				<u--text :text="item.create_time" size="12"></u--text>
				<view class="points-num">
					{{item.pm==1?'+':'-'}}{{item.number}}
				</view>
			</view>
		</view>
	</view>
	</mescroll-body>
</template>

<script>
	import MescrollBody from '@/components/mescroll-uni/mescroll-body.vue'
	import MescrollMixin from '@/components/mescroll-uni/mescroll-mixins'
	import { getEmptyPaginateObj, getMoreListData } from '@/core/app'
	import * as Api from '@/api/app/points/index.js'
	import storage from '@/utils/storage'
	import { DEALERID,OPENID,USERINFO } from '@/store/mutation-types'
	const pageSize = 10
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
				openid:storage.get(OPENID),
				pageNum:1,
				pageSize:10,
				current:0,
				typeOptions:[],
				pointsList:getEmptyPaginateObj(),
			}
		},
		async onShow() {
			await this.getPointsType()
			this.getPointsBill()
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
				app.getPointsBill(page.num)
				  .then(list => {
					const curPageLen = list.data.length
					const totalSize = list.data.total
					app.mescroll.endBySize(curPageLen, totalSize)
				  })
				  .catch(() => app.mescroll.endErr())
			  },
			getPointsBill(pageNo = 1){
				const app = this
				const params={
					page:pageNo,
					pageSize:app.pageSize,
					dealer_id:storage.get(DEALERID),
					member_id:storage.get(USERINFO)?.id
				}
				return new Promise((resolve, reject) => {
					Api.getPointsBill(params).then(result=>{
						const pointsList = result.data.list
						app.pointsList.data = getMoreListData(pointsList, app.pointsList, pageNo)
						resolve(pointsList)
					})
				})
			},
			type(id){
				return this.typeOptions.filter(item=>item.dict_value==id).map(item=>item.dict_label)[0]
			},
			getPointsType(){
				Api.getPointsType({}).then(res=>{
					return this.typeOptions=res.data
				})
			}
		}
	}
</script>
<style lang="scss" scoped>
	page{
		background: $uni-bg-color-grey;
	}
	.container{
		width: 100%;
		height: auto;
		.points-box{
			width: 100%;
			height: auto;
			display: flex;
			justify-content: center;
			align-items: center;
			flex-direction: column;
			.points-item{
				width: 100%;
				height: 120rpx;
				border-bottom: 1px solid $uni-bg-color-grey;
				padding: 0 20rpx;
				box-sizing: border-box;
				background: white;
				display: flex;
				justify-content: center;
				flex-direction: column;
				position: relative;
				.points-num{
					position: absolute;
					right: 40rpx;
					font-size: 28rpx;
					color: $uni-text-color-active;
				}
			}
		}
	}
</style>