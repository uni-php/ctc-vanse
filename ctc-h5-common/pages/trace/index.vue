<template>
	<view class="container">
		<Trace :items="items" @tabClick="tabClick"/>
	</view>
</template>

<script>
	import * as Api from '@/api/app/trace/index.js'
	import Trace from '@/components/page/trace.vue'
	const App = getApp()
	export default{
		components: {
		  Trace
		},
		data(){
			return{
				// 页面参数
				options: {},
				tab_index:0,
				// 页面属性
				page: {},
				items: []
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
			
		},
		methods:{
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
				if(val==1){
					this.getPageData(()=>{})
				}
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
