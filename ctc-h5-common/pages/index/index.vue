<template>
	<view class="container">
		<text>ss</text> 
	</view>
</template>

<script>
	export default {
		data() {
			return {
				show: true
			}
		},
		onShow() {
			console.log(this.$platform)
		},
		methods: {
			
		}
	}
</script>

<style>
	.container {
		padding: 20px;
		font-size: 14px;
		line-height: 24px;
	}
</style>
