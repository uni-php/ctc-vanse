<template>
	<mescroll-body ref="mescrollRef" :sticky="true" @init="mescrollInit" :down="{ native: true }" @down="downCallback"
	    :up="upOption" @up="upCallback">
	<view class="container">
		<view class="content-box">
			<view class="item-box" v-for="(item,index) in recordsList.data" :key="index">
				<view class="code-box">
					<text>二维码编号：{{item.code}}</text>
					<text style="font-weight: bold;">发放成功</text>
				</view>
				<view class="prize-box">
					<u--image :showLoading="true" v-if="item.prize_type==1" :src="red" width="48px" height="48px"></u--image>
					<u--image :showLoading="true" v-if="item.prize_type==2" :src="points" width="42px" height="42px"></u--image>
					<u--image :showLoading="true" v-if="item.prize_type==3" :src="gifts" width="40px" height="40px"></u--image>
					<view class="prize-info">
						<u--text :text="'红包'+item.money+'元'" v-if="item.prize_type==1" :bold="true" size="13"></u--text>
						<u--text :text="'积分'+item.points" v-if="item.prize_type==2" :bold="true" size="13"></u--text>
						<u--text :text="myGifts(item)" v-if="item.prize_type==3" :bold="true" size="13"></u--text>
						<u--text :text="'中奖时间:'+item.create_time" color="#999" size="12"></u--text>
					</view>
					<view class="bill" v-if="item.prize_type!=3">
						<u--text :text="'+'+(item.prize_type==1?item.money:item.points)" :bold="true" color="#f29100" size="14"></u--text>
					</view>
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
	import { DEALERID,OPENID,USERINFO } from '@/store/mutation-types'
	import {getRrizeRecords} from '@/api/app/guide/index.js'
	import storage from '@/utils/storage'
	const pageSize = 10
	export default{
		components: {
		    MescrollBody,
		},
		mixins: [MescrollMixin],
		data(){
			return{
				gifts:'https://cdn.uni-2id.com/gifts.png',
				points:'https://cdn.uni-2id.com/points.png',
				red: 'https://cdn.uni-2id.com/redpack.png',
				pageNum:1,
				pageSize:10,
				recordsList:getEmptyPaginateObj(),
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
			}
		},
		onLoad({dealer_id}) {
			this.dealer_id=dealer_id
		},
		onShow() {
			// this.getRrizeRecords()
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
				app.getRrizeRecords(page.num)
				  .then(list => {
					const curPageLen = list.data.length
					const totalSize = list.data.total
					app.mescroll.endBySize(curPageLen, totalSize)
				  })
				  .catch(() => app.mescroll.endErr())
			  },
			getRrizeRecords(pageNo = 1){
				const app = this
				const params={
					page:pageNo,
					pageSize:app.pageSize,
					dealer_id:this.dealer_id,
					openid:storage.get(OPENID)
				}
				return new Promise((resolve, reject) => {
					getRrizeRecords(params).then(result=>{
						const recordsList = result.data.list
						app.recordsList.data = getMoreListData(recordsList, app.recordsList, pageNo)
						resolve(recordsList)
					})
				})
			},
			myGifts(item){
				return '实物'
			}
		}
	}
</script>

<style lang="scss" scoped>
	page{
		background: #eeeeee;
		.container{
			background: white;
			padding: 0 20rpx;
			display: flex;
			position: relative;
			box-sizing: border-box;
			background: #eeeeee;
			.content-box{
				width: 100%;
				height: auto;
				display: flex;
				flex-direction: column;
				align-items: center;
				justify-content: center;
				.item-box{
					width: 100%;
					height: 250rpx;
					background: white;
					border-radius: 10rpx;
					margin: 20rpx;
					display: flex;
					flex-direction: column;
					align-items: center;
					padding: 20rpx;
					box-sizing: border-box;
					.bill{
						position: absolute;
						right: 100rpx;
					}
					.code-box{
						width: 100%;
						height: 50rpx;
						border-bottom: 1px solid #eeeeee;
						display: flex;
						justify-content: space-between;
						align-items: center;
						font-size: 26rpx;
						color: #333;
					}
					.prize-box{
						width: 100%;
						height: calc(100% - 50rpx);
						display: flex;
						flex-wrap: nowrap;
						align-items: center;
						position: relative;
						.prize-info{
							height: 90%;
							display: flex;
							flex-direction: column;
							align-items: flex-start;
							margin-left: 20rpx;
						}
					}
				}
			}
		}
	}
</style>