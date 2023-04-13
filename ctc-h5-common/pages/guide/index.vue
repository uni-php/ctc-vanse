<template>
	<view class="container">
		<div class="tips" v-if="check_status==-3">
			<u--image :showLoading="true" :src="guide1" width="70px" height="70px"></u--image>
			<u--text size="13" align="center" text="您还不是导购员,无法进入!"></u--text>
			<view class="u-page__button-item" style="margin-top: 40rpx;">
				<u-button
					text="申请成为导购员"
					size="small"
					@click="register"
					color="linear-gradient(to right, rgb(226, 157, 0), rgb(255, 91, 39))"
				></u-button>
			</view>
		</div>
		<div class="tips" v-if="check_status==1">
			<u--image :showLoading="true" :src="guide2" width="70px" height="70px"></u--image>
			<u--text style="margin:40rpx 0pt" size="13" align="center" text="恭喜,您已成为导购员啦!"></u--text>
			<u--text size="13" :text="'所属门店:'+store_name" align="center"></u--text>
			<view class="u-page__button-item" style="margin-top: 40rpx;">
				<u-button
					text="个人中心"
					@click="userCenter"
					size="small"
					color="linear-gradient(to right, rgb(226, 157, 0), rgb(255, 91, 39))"
				></u-button>
			</view>
		</div>
		<div class="tips" v-if="check_status==-1">
			<u--image :showLoading="true" :src="guide3" width="70px" height="70px"></u--image>
			<u--text align="center" style="margin:40rpx 0pt" size="13" text="您的申请已提交,请等待审核!"></u--text>
		</div>
		<div class="tips" v-if="check_status==-2">
			<u--image :showLoading="true" :src="guide1" width="70px" height="70px"></u--image>
			<u--text align="center" style="margin:40rpx 0pt" size="13" text="您的申请已被拒绝!"></u--text>
		</div>
	</view>
</template>

<script>
	import storage from '@/utils/storage'
	import { OPENID } from '@/store/mutation-types'
	export default{
		data(){
			return{
				guide1:require('@/static/guide1.png'),
				guide2:require('@/static/guide2.png'),
				guide3:require('@/static/guide3.png'),
				check_status:undefined,
				dealer_id:undefined,
				store_name:''
			}
		},
		onLoad({check_status,dealer_id,store_name}) {
			this.check_status=check_status
			this.dealer_id=dealer_id,
			this.store_name = store_name
		},
		methods:{
			register(){
				uni.$u.route({
					url: 'pages/guide/register',
					params: {
						dealer_id:this.dealer_id
					}
				})
			},
			userCenter(){
				uni.$u.route({
					url: 'pages/guide/user',
					type:'redirect',
					params: {
						dealer_id:this.dealer_id,
						openid: storage.get(OPENID)
					}
				})
			}
		}
	}
</script>

<style lang="scss" scoped>
	.container {
		width: 100%;
		overflow: hidden;
		position: relative;
	    background: #fafafa;
		display: flex;
		justify-content: center;
		align-items: center;
		.tips{
			width: 100%;
			height: auto;
			display: flex;
			justify-content: center;
			align-items: center;
			flex-direction:column;
			margin-top: 300rpx;
		}
	}
</style>