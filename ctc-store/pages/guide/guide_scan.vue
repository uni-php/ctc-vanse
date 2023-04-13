<template>
	<mescroll-body ref="mescrollRef" :sticky="true" @init="mescrollInit" :down="{ native: true }" @down="downCallback"
	    :up="upOption" @up="upCallback">
	<view class="container">
		<view class="u-demo-block__content" style="width: 100%;">
			<u-tabs :list="nav_list"  @change="changeTab" :current="current" lineColor="#fa3534" :scrollable="false">
			</u-tabs>
		</view>
		<view class="sum-box">
			<view class="scan-times">
				<u--text color="#fff" :bold="true" align="center" :text="sum"></u--text>
				<u--text color="#fff" align="center" text="扫码次数"></u--text>
			</view>
			<view class="scan-times">
				<u--text color="#fff" :bold="true" align="center" :text="times"></u--text>
				<u--text color="#fff" align="center" text="扫码个数"></u--text>
			</view>
		</view>
		<!-- 扫码数据 -->
		<view class="content-box">
			<view class="item-box" v-for="(item,index) in recordsList.data" :key="index">
				<u--text color="#333" :bold="true" size="13" align="left" :text="item.is_first==2?'重复扫码':'首次扫码'"></u--text>
				<view class="item-des">
					<view>数码：{{item.code}}</view>
					<view>时间：{{item.create_time}}</view>
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
	import { DEALERID,OPENID,USERINFO,STORE_INFO } from '@/store/mutation-types'
	import {getScanRecords} from '@/api/guide/index.js'
	import storage from '@/utils/storage'
	const pageSize = 10
	export default{
		components: {
		    MescrollBody,
		},
		mixins: [MescrollMixin],
		data(){
			return{
				dealer_id:'',
				// 上拉加载配置
				upOption: {
				  // 首次自动执行
				  auto: true,
				  // 每页数据的数量; 默认10
				  page: { size: pageSize },
				  // 数量要大于4条才显示无更多数据
				  noMoreSize: 4,
				},
				store_info:{},
				sum:0,
				times:0,
				pageNum:1,
				pageSize:10,
				current:0,
				recordsList:getEmptyPaginateObj(),
				nav_list:[
					{
						name:'今天',
						index:1
					},
					{
						name:'近七天',
						index:2
					}
				]
			}
		},
		onLoad() {
		},
		onShow() {
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
				app.getScanRecords(page.num)
				  .then(list => {
					const curPageLen = list.data.length
					const totalSize = list.data.total
					app.mescroll.endBySize(curPageLen, totalSize)
				  })
				  .catch(() => app.mescroll.endErr())
			  },
			  getScanRecords(pageNo = 1){
			  	const app = this
			  	const params={
			  		page:pageNo,
			  		pageSize:app.pageSize,
			  		dealer_id:this.store_info.dealer_id,
					current:this.current,
			  		store_id:this.store_info.id,
			  	}
			  	return new Promise((resolve, reject) => {
			  		getScanRecords(params).then(result=>{
			  			const recordsList = result.data.list
						this.sum=result.data.list.total
						this.times=result.data.list.times
			  			app.recordsList.data = getMoreListData(recordsList, app.recordsList, pageNo)
			  			resolve(recordsList)
			  		})
			  	})
			  },
			changeTab(val){
				this.current=val.index
				this.recordsList = getEmptyPaginateObj()
				this.mescroll.resetUpScroll()
			}
		}
	}
</script>

<style lang="scss" sscoped>
	.container{
		.sum-box{
			width: 95%;
			height: 200rpx;
			background-image: linear-gradient(to right, #fcbd71 , #f29100);
			border-radius: 10rpx;
			margin: 0 auto;
			display: flex;
			justify-content: space-around;
			align-items: center;
			.scan-times{
				display: flex;
				flex-direction: column;
				height: 70%;
				color: white;
			}
		}
		.content-box{
			width: 100%;
			height: auto;
			display: flex;
			justify-content: center;
			align-items: center;
			flex-direction: column;
			.item-box{
				width: 95%;
				height: 120rpx;
				display: flex;
				flex-direction: column;
				// align-items: center;
				border-bottom: 1px solid #eeeeee;
				padding:10rpx;
				box-sizing: border-box;
				color: $uni-text-color;
				.item-des{
					width: 100%;
					display: flex;
					justify-content: space-between;
					align-items: center;
					color: gray;
					font-size: 24rpx;
				}
			}
		}
	}
</style>