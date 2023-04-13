<template>
	<view class="container">
		<view class="title">
			<u--text size="32" color="#ffffff" align="center" text="积分兑换"></u--text>
		</view>
		<view class="tips-box">
			<u--text style="margin:20rpx 0" size="18" :bold="true" color="#fa3534" align="center" text="兑换规则"></u--text>
			<u-parse :content="strings"></u-parse>
		</view>
	</view>
</template>

<script>
	import * as Api from '@/api/app/points/index.js'
	import { DEALERID } from '@/store/mutation-types'
	import storage from '@/utils/storage'
	export default{
		data(){
			return{
				strings: ''
			}
		},
		onShow() {
			this.getPointsRule()
		},
		methods:{
			getPointsRule(){
				const params={
					dealer_id:storage.get(DEALERID)
				}
				Api.getPointsRule(params).then(res=>{
					this.strings=res.data
				})
			}
		}
	}
</script>
<style lang="scss" scoped>
	page{
		width: 100%;
		height: calc(100vh - 44px - env(safe-area-inset-top));
		background: url('https://cdn.uni-2id.com/points_rule.png') no-repeat;
		background-size: 100% 100%;
	}
	.container{
		width: 100%;
		height: 100%;
		position: absolute;
		.title{
			margin-top: 40rpx;
			position: relative;
		}
		.tips-box{
			width: 85%;
			height: calc(100% - 500rpx );
			background: white;
			border-radius: 10rpx;
			margin:  0 auto;
			margin-top: 40rpx;
			padding: 20rpx 10rpx;
			box-sizing: border-box;
			overflow: auto;
		}
	}
</style>