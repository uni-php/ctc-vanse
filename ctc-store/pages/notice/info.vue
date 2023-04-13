<template>
	<view class="container">
		<u--text :text="info.title" :bold="true"></u--text>
		<view class="" style="width: 100%;padding-left:30rpx;">
			<u--text style="margin:20rpx 0" :text="'发布时间：'+info.create_time" :size="12" color="#999" align="left"></u--text>
		</view>
		<view style="width: 96%;padding: 20rpx;">
			<u-parse :content="info.content"></u-parse>
		</view>
	</view>
</template>

<script>
	import {getNoticeInfo} from '@/api/notice/index.js'
	export default{
		data(){
			return{
				notice_id:'',
				info:{}
			}
		},
		onLoad({notice_id}) {
			this.notice_id=notice_id
		},
		onShow() {
			this.getNoticeInfo()
		},
		methods:{
			getNoticeInfo(){
				getNoticeInfo({notice_id:this.notice_id}).then(res=>{
					this.info=res.data
				})
			}
		}
	}
</script>

<style>
</style>