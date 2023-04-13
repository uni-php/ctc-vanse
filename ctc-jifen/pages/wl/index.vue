<template>
	<view class="container">
		<Trace :items="items" :warehouse="warehouseOption" @tabClick="tabClick"/>
	</view>
</template>

<script>
	import * as Api from '@/api/app/wl/index.js'
	import Trace from '@/components/wl/trace.vue'
	const App = getApp()
	export default{
		components: {
		  Trace
		},
		data(){
			return{
				queryWareForm:{
					keywords:'',
					pageNum:1,
					pageSize:999
				},
				// 页面参数
				options: {},
				tab_index:0,
				// 页面属性
				page: {},
				warehouseOption:[],
				items: {}
			}
		},
		/**
		 * 生命周期函数--监听页面加载
		 */
		onLoad(options) {
			  // 当前页面参数
			  console.log(options)
			  this.options = options
			  // 加载页面数据
			  this.getPageData();
		},
		/**
		 * 生命周期函数--监听页面显示
		 */
		onShow() {
			this.getWarehouseList()
		},
		methods:{
			getWarehouseList(){
				this.queryWareForm.dealer_id=this.options.dealer_id
				Api.getWarehouseList(this.queryWareForm).then(res=>{
					this.warehouseOption=res.data
				})
			},
			 /**
			   * 加载页面数据
			   * @param {Object} callback
			   */
			getPageData(callback){
				const app = this
				const params = app.options || {}
				params.tab_index=app.tab_index
				Api.detail(params)
				  .then(result => {
					// 设置页面数据
					const { data: { page,items } } = result//双解构
					app.page = page
					items.query_params={
						dealer_id:this.options.dealer_id,
						code:this.options.code,
						batch:this.options.batch
					}
					app.items =items
					// 设置顶部导航栏栏
					app.setPageBar();
				  })
				  .finally(() => callback && callback())
			},
			setPageBar(){
				const {
				  page
				} = this
				// 设置页面标题
				uni.setNavigationBarTitle({
				  title: page.params.title
				});
				// 设置navbar标题、颜色
				uni.setNavigationBarColor({
				  frontColor: page.style.titleTextColor === 'white' ? '#ffffff' : '#000000',
				  backgroundColor: page.style.titleBackgroundColor
				})
			},
			tabClick(val){
				this.tab_index=val
				// if(val==1){
				// 	this.getPageData(()=>{})
				// }
			}
		},
		/**
		 * 下拉刷新
		 */
		onPullDownRefresh() {
			console.log(123)
		  // 获取首页数据
		 //  this.getPageData(() => {
			// uni.stopPullDownRefresh()
		 //  })
		},
	}
</script>

<style lang="scss" scoped>
	.container {
		width: 100%;
		overflow: hidden;
		position: relative;
	    background: #fafafa;
	  }
</style>
