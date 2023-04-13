<template>
	<mescroll-body style="width: 100%;" ref="mescrollRef" :sticky="true" @init="mescrollInit" :down="{ native: true }" @down="downCallback"
	    :up="upOption" @up="upCallback">
		<view class="container">
			<u--form style="width: 95%;" labelPosition="left" :model="model" :rules="rules" ref="form" :borderBottom="false">
				<view style="display: flex;justify-content: space-between;align-items: center;width: 100%;">
					<view style="width:50%">
					<u-form-item
					    style="width: 100%"
						label="操作时间"
						prop="start_time"
						labelWidth="80"
						@click="show_start_time = true; hideKeyboard()"
						ref="start_time"
					>
						<u--input :readonly="true"  v-model="model.start_time" disabled disabledColor="#ffffff" placeholder="开始时间"></u--input>
					</u-form-item>
					</view>
					<view style="width: 10%;display: flex;justify-content: center;">
						-
					</view>
					<view style="width:35%;margin-right:40rpx">
					<u-form-item
					    style="width: 100%"
						prop="end_time"
						labelWidth=""
						@click="show_end_time = true; hideKeyboard()"
						ref="end_time"
					>
					<u--input :readonly="true"  v-model="model.end_time" disabled disabledColor="#ffffff" placeholder="结束时间"></u--input>
					</u-form-item>
					</view>
				</view>
				<u-button style="width: 85%;height: 72rpx;" type="primary" size="medium" @click="search()" text="搜索"></u-button>
				<!-- <view style="display: flex;justify-content: space-between;align-items: center;width: 100%;">
					<u-form-item  label="物流码"style="width: 80%" labelWidth="80px" :borderBottom="false" prop="code"  ref="item">
						<u--input
							style="height:55rpx"
							v-model="model.code"
							clearable
							confirm-type="search"
							@confirm="search"
							prefixIconStyle="font-size: 22px;color: #ffffff"
						></u--input>
					</u-form-item>
					<u-button style="width: 15%;height: 72rpx;" type="primary" size="medium" @click="search()" text="搜索"></u-button>
				</view> -->
		    </u--form>
			<!-- 列表 -->
			<view class="content-box" style="border-top: 1px solid #eeeeee;margin-top: 30rpx;">
				<view class="item" v-for="(item,index) in listData.data" :key="index">
					<view>时间：{{item.create_time}}</view>
					<view v-show="item.code">物流码：{{item.code}}</view>
					<view v-show="item.order_start">区间：{{item.order_start}}~{{item.order_end}}</view>
					<view>处理方式：{{item.op_type}}</view>
					<view>处理明细：{{item.op_des}}</view>
					<!-- <view>操作人：{{item.create_by||'--'}}</view> -->
				</view>
			</view>
			<!-- 开始时间 -->
			<u-datetime-picker
				:show="show_start_time"
				:value="start_time"
				mode="date"
				closeOnClickOverlay
				@confirm="startConfirm"
				@cancel="startClose"
				@close="startClose"
			></u-datetime-picker>
			<!-- 结束时间 -->
			<u-datetime-picker
				:show="show_end_time"
				:value="end_time"
				mode="date"
				closeOnClickOverlay
				@confirm="endConfirm"
				@cancel="endClose"
				@close="endClose"
			></u-datetime-picker>
		</view>
	</mescroll-body>		
</template>

<script>
	import MescrollBody from '@/components/mescroll-uni/mescroll-body.vue'
	import MescrollMixin from '@/components/mescroll-uni/mescroll-mixins'
	import {getOpLogList} from '@/api/log/index.js'
	import { getEmptyPaginateObj, getMoreListData } from '@/core/app'
	import {mapGetters} from 'vuex'
	const pageSize = 10
	export default{
		computed:{
			...mapGetters(['userInfo','token','userId'])
		},
		components: {
		    MescrollBody
		},
		mixins: [MescrollMixin],
		data(){
			return{
				listData:getEmptyPaginateObj(),
				start_time:Number(new Date()),
				end_time:Number(new Date()),
				show_start_time:false,
				show_end_time:false,
				pageSize:10,
				model:{
					start_time:'',
					end_time:'',
					code:''
				},
				// 上拉加载配置
				upOption: {
				  // 首次自动执行
				  auto: true,
				  // 每页数据的数量; 默认10
				  page: { size: pageSize },
				  // 数量要大于4条才显示无更多数据
				  noMoreSize: 4,
				},
				rules:{
					
				}
			}
		},
		onShow() {
			
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
					code:this.model.code,
			 		start_time:this.model.start_time,
					end_time:this.model.end_time,
					dealer_id:this.userId,
			 	}
			 	return new Promise((resolve, reject) => {
			 	  getOpLogList(param)
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
			 search(){
				 this.listData = getEmptyPaginateObj()
				 this.mescroll.resetUpScroll()
			 },
			hideKeyboard() {
				uni.hideKeyboard()
			},
			startClose() {
				this.show_start_time = false
				this.$refs.form.validateField('start_time')
			},
			startConfirm(e) {
				this.show_start_time = false
				this.model.start_time = uni.$u.timeFormat(e.value, 'yyyy-mm-dd')
				this.$refs.form.validateField('start_time')
			},
			endClose() {
				this.show_end_time = false
				this.$refs.form.validateField('end_time')
			},
			endConfirm(e) {
				this.show_end_time = false
				this.model.end_time = uni.$u.timeFormat(e.value, 'yyyy-mm-dd')
				this.$refs.form.validateField('end_time')
			},
		}
	}
</script>
<style lang="scss" scoped>
	.content-box{
		width: 100%;
		height: auto;
		display: flex;
		justify-content: center;
		align-items: center;
		flex-direction: column;
		.item{
			width: 100%;
			height: auto;
			display: flex;
			justify-content: flex-start;
			align-items: center;
			flex-direction: column;
			padding: 4%;
			box-sizing: border-box;
			border-bottom: 8rpx solid #eeeeee;
			position: relative;
			.btn{
				width:100px ;
				position: absolute;
				right: 50rpx;
				top: 30rpx;
			}
			view{
				width: 100%;
				text-align: left;
				padding: 4rpx 0;
				font-size: 30rpx;
			}
		}
	}
</style>
