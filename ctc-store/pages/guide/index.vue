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
		<view class="guide-box" v-for="(item,index) in listData.data">
			<u--text size="14" :text="'姓名：'+item.name"></u--text>
			<u--text style="margin: 10rpx 0;" size="12" color="#999" :text="'手机号：'+item.phone"></u--text>
			<u--text size="12" color="#999" :text="'注册时间：'+item.create_time"></u--text>
			<view class="set-btn-box" v-if="current==0">
				<view class="set-btn" @click="check(item)">
					审核通过
				</view>
				<view class="set-btn"  @click="refuse(item)">
					审核拒绝
				</view>
			</view>
		</view>
		<u-modal
			:content="'确认审核'+(check_status==1?'通过?':'拒绝?')"
			:show="checkShow"
			showCancelButton
			asyncClose
			@confirm="confirmCheck"
			@cancel="() => checkShow = false"
		></u-modal>
	</view>
	</mescroll-body>
</template>

<script>
	import MescrollBody from '@/components/mescroll-uni/mescroll-body.vue'
	import MescrollMixin from '@/components/mescroll-uni/mescroll-mixins'
	import { getEmptyPaginateObj, getMoreListData } from '@/core/app'
	import {getGuideList,checkGuide} from '@/api/guide/index.js'
	import {STORE_INFO } from '@/store/mutation-types'
	import storage from '@/utils/storage'
	const pageSize = 10
	export default{
		components: {
		    MescrollBody
		},
		mixins: [MescrollMixin],
		data(){
			return{
				check_status:'',
				guide_id:'',
				store_info:{},
				list:[
					'待审核','已通过'
				],
				current:0,
				pageSize:10,
				checkShow:false,
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
		},
		methods:{
			change(val){
				this.current=val
				this.listData = getEmptyPaginateObj()
				this.mescroll.resetUpScroll()
			},
			check(item){
				this.guide_id=item.id
				this.check_status=1
				this.checkShow=true
			},
			refuse(item){
				this.guide_id=item.id
				this.check_status=-2
				this.checkShow=true
			},
			confirmCheck(){
				const params={
					guide_id:this.guide_id,
					check_status:this.check_status,
					dealer_id:this.store_info.dealer_id,
				}
				checkGuide(params).then(res=>{
					if(res.status==200){
						uni.$u.toast(res.message)
						this.checkShow=false
						this.listData = getEmptyPaginateObj()
						this.mescroll.resetUpScroll()
					}else{
						this.checkShow=false
						uni.$u.toast(res.message)
					}
				})
			},
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
			 	  getGuideList(param)
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
		.guide-box{
			width: 100%;
			min-height: 150rpx;
			display: flex;
			margin: 15rpx 0;
			padding: 20rpx;
			box-sizing: border-box;
			justify-content: flex-start;
			flex-direction: column;
			// align-items: center;
			position: relative;
			border-bottom: 1px solid #eeeeee;
			background: white;
			border-radius: 10rpx;
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