<template>
	<mescroll-body style="width: 100%;" ref="mescrollRef" :sticky="true" @init="mescrollInit" :down="{ native: true }" @down="downCallback"
	    :up="upOption" @up="upCallback">
	<view class="product-box">
		<view class="title">
			<view>商品列表</view>
			<view @click="close"><u-icon name="close"></u-icon></view>
		</view>
		<view class="select-rk-order-input">
			<view class="form-item-box">
				<view style="width: 15%;">
					<text>关键词</text>
				</view>
				<view style="width: 65%;">
					<u--input
						placeholder="请输入商品关键词"
						border="surround"
						clearable
						v-model="keywords"
						confirm-type="search"
						@confirm="search"
					  ></u--input>
				</view>
				<u-button style="width: 15%;height: 72rpx;" type="primary" size="medium" @click="search" text="搜索"></u-button>
			</view>
		</view>
		<view class="order-content-box">
			<view class="table-head">
				<text style="width:20%;" class="head-item">产品编号</text>
				<text style="width:40%;" class="head-item">产品名称</text>
				<text style="width:20%;" class="head-item">产品分类</text>
				<text style="width:20%;border-right: 0;" class="head-item">操作</text>
			</view>
			<view class="table-item" v-for="(item,index) in listData.data" :key="index"">
				<text style="width:20%;" class="content-item">{{item.code}}</text>
				<text style="width:40%;" class="content-item">{{item.product_name}}</text>
				<text style="width:20%;" class="content-item">{{item.class_one}}</text>
				<div style="width:20%;border-right: 0;" class="content-item">
					<u-button style="width:80%;" size="mini" type="primary" @click="handleSelectProduct(item)" text="选择"></u-button>
				</div>
			</view>
		</view>
	</view>
	</mescroll-body>
</template>

<script>
	import {getProductList} from '@/api/product/index.js'
	import MescrollBody from '@/components/mescroll-uni/mescroll-body.vue'
	import MescrollMixin from '@/components/mescroll-uni/mescroll-mixins'
	import { getEmptyPaginateObj, getMoreListData } from '@/core/app'
	import {mapGetters} from 'vuex'
	const pageSize = 10
	export default{
		name:'ProductPanel',
		props:{
			
		},
		components: {
			MescrollBody
		},
		mixins: [MescrollMixin],
		computed:{
			...mapGetters(['userInfo','token','userId'])
		},
		options:{
			styleIsolation: 'shared'
		},
		data(){
			return{
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
				},  
			}
		},
		created(){
			
		},
		methods:{
			search(){
				this.listData = getEmptyPaginateObj()
				this.mescroll.resetUpScroll()
			},
			 handleSelectProduct(row){
				this.$emit('selectProduct',row)
			},
			close(){
				this.$emit('closeProductPanel')
			},
			/**
			   * 上拉加载的回调 (页面初始化时也会执行一次)
			   * 其中page.num:当前页 从1开始, page.size:每页数据条数,默认10
			   * @param {Object} page
			   */
			upCallback(page) {
				const app = this
				// 设置列表数据
				app.getProduct(page.num)
				  .then(list => {
					const curPageLen = list.data.length
					const totalSize = list.data.total
					app.mescroll.endBySize(curPageLen, totalSize)
				  })
				  .catch(() => app.mescroll.endErr())
			 },
			 getProduct(pageNo = 1){
			 	const app = this
			 	var param={
			 		page:pageNo,
			 		pageSize:this.pageSize,
			 		dealer_id:this.userId,
					keywords:this.keywords
			 	}
			 	return new Promise((resolve, reject) => {
			 	  getProductList(param)
			 		.then(result => {
			 		  // 合并新数据
			 		  const newList = result.data.list
			 		  app.listData.data = getMoreListData(newList, app.listData, pageNo)
			 		  resolve(newList)
			 		})
			 		.catch(reject)
			 	})
			 },
		}
	}
</script>
<style lang="scss">
	::v-deep .mescroll-empty{
		position: absolute !important;
		top: 400rpx !important;
	}
</style>
<style lang="scss"  scoped>
	.container{
		position: relative;
		display: flex;
		justify-content: center;
		align-items: center;
		.form-item-box{
			width:100%;
			display: flex;
			align-items: center;
			.u-button,.u-button--primary{
				width: 15% !important;
			}
		}
		.product-box{
			width: 750rpx !important;
			background:white;
			//height: 100vh;
			display: flex;
			flex-direction: column;
			align-items: flex-start;
			background: white;
			padding: 30rpx;
			padding-top:0;
			box-sizing: border-box;
			overflow: auto;
			.title{
				width: 100%;
				display: flex;
				justify-content: space-between;
				align-items: center;
				background: white;
				height: 50px;
				padding: 20rpx 0;
				box-sizing: border-box;
			   font-size: 16px;
			   font-weight: 600;
			}
		}
		.order-content-box{
			width: 100%;
			height: 700rpx;		
			justify-content: center;
			align-items: center;
			flex-shrink: 0;
			overflow: auto;
			flex-direction: column;
			box-sizing: border-box;
			margin-top: 20rpx;
			border: 1px solid #c8c7cc;
			.table-head{
				width: 100%;
				min-height: 60rpx;
				max-height: 100rpx;
				display: flex;
				justify-content: center;
				align-items: center;
				background: #caddf2;
				font-size: 14px;
				.head-item{
					height: 100%;
					display: flex;
					justify-content: center;
					align-items: center;
					padding: 6rpx;
					border-right: 1px solid #c8c7cc;
					box-sizing: border-box;
				}
			}
			.table-item{
				width: 100%;
				min-height: 60rpx;
				display: flex;
				justify-content: center;
				align-items: center;
				font-size: 14px;
				border-top: 1px solid #c8c7cc;
				.content-item{
					height: 100%;
					display: flex;
					justify-content: center;
					word-break:break-all;
					align-items: center;
					border-right: 1px solid #c8c7cc;
					padding: 6rpx;
					box-sizing: border-box;
					.u-button--mini{
						min-width: 30px;
					}
				}
			}
		}
		.select-rk-order-input{
			width: 100%;
			height: auto;
			display: flex;
			justify-content: space-between;
			align-items: center;
		}
	}
</style>
