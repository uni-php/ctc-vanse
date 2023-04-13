<template>
	<view class="container">
		<view v-for="(item,index) in pageData" :key="index">
			<view v-if="item.type=='user'" class="user-box">
				<u-avatar :src="userInfo.headimgurl" size="50"></u-avatar>
				<view style="width: 30%;margin-left: 30rpx;">
					<u--text :lines="2" :text="userInfo.nickname"></u--text>
				</view>
				<view class="point-num-box">
					<text>积分余额:{{userInfo.points}}</text>
				</view>
			</view>
			<view v-if="item.type=='line'" class="divider-line"></view>
			<view v-if="item.type=='search'" class="search-box">
				<u-search
					v-model="keywords"
					:show-action="false"
					:placeholder="item.text"
					@change="change"
				></u-search>
			</view>
			<view v-if="item.type=='nav'" class="nav-box">
				<view class="nav-item" v-for="(it,idx) in item.content" @click="navTab(idx)">
					<u-avatar size="45" :src="my_url(idx)"></u-avatar>
					<view style="margin-top: 4rpx;"><u--text size="14" :text="it.text"></u--text></view>
				</view>
			</view>
			<view v-if="item.type=='notice'" class="notice-box">
				<!-- <u-icon name="volume" size="22" color="#fa8945"></u-icon>
				<view style="width: 80%;margin-left: 6rpx;"><u--text :text="item.text" :lines="1"></u--text></view> -->
				<u-notice-bar :text="item.text" mode="closable"></u-notice-bar>
			</view>
			<view v-if="item.type=='recom'" class="recom-box">
				<u-cell-group>
					<u-cell
						:title="item.text"
						value="更多"
						:isLink="true"
						url="/pages/category/index"
						linkType="switchTab"
					></u-cell>
				</u-cell-group>
				<!-- 推荐列表 -->
				<view class="recom-item" v-for="(it,idx) in recommendList" :key="idx" @click="checkDes(it)">
					<u--image :showLoading="true" :src="it.cover[0].url" width="85px" height="85px"></u--image>
					<view class="recom-info">
						<u--text :lines="2" :text="it.gift_name" size="14"></u--text>
						<u--text :text="'已兑换'+it.exchanged_num" color="gray" size="12"></u--text>
						<view class="recom-points">
							<u-icon name="integral" color="#ff9900" size="18"></u-icon>
							<u--text style="flex:none" :text="it.points_num" color="#ff9900" size="12"></u--text>
							<u--text v-if="it.type==2" :text="'+￥'+it.money" color="#ff9900" size="12"></u--text>
						</view>
						<view class="shopping-cart" @click.stop="addCar(it)">
							<u-icon name="shopping-cart-fill" color="#fa3534" size="28"></u-icon>
						</view>
					</view>
				</view>
			</view>
		</view> 
	</view>
</template>

<script>
	import storage from '@/utils/storage'
	import * as Api from '@/api/app/points/index.js'
	import { DEALERID, OPENID } from '@/store/mutation-types'
	export default {
		data() {
			return {
				userInfo:{},
				show: true,
				src: 'https://cdn.uviewui.com/uview/album/1.jpg',
				dealer_id:'',
				openid:storage.get(OPENID)||'osnBC6OPadCdY77BfGZOaVhbgjak',
				keywords:'',
				pageData:{},
				recommendList:[]
			}
		},
		async onLoad() {
			this.dealer_id=storage.get(DEALERID)||29
			const expiryTime = 30 * 86400
		},
		async onShow() {
			this.dealer_id=storage.get(DEALERID)||29
			await this.getUserInfo()
			await this.getPageData()
			await this.getHotRecommend()
		},
		methods: {
			my_url(val){
			  return require(`@//static/img/nav-${val+1}-icon@2x.png`)	
			},
			getPageData(){
				return	Api.getPageData({dealer_id:this.dealer_id}).then(res=>{
					this.pageData=res.data.page_content
				})
			},
			getHotRecommend(){
				const rule=this.pageData.filter(item=>item.type=='recom').map(item=>item.recom_rule)[0]
				const params={
					dealer_id:this.dealer_id,
					recom_rule:rule
				}
				return Api.getHotRecommend(params).then(res=>{
					this.recommendList=res.data
				})
			},
			navTab(idx){
				if(idx==0){
					uni.$u.route({
						url:'/pages/category/index',
						type:'switchTab'
					});
				}
				if(idx==1){
					uni.$u.route({
						url:'/pages/user/index',
						type:'switchTab'
					});
				}
				if(idx==2){
					uni.$u.route('/pages/order/index');
				}
				if(idx==3){
					uni.$u.route('/pages/rule/index');
				}
			},
			checkDes(item){
				uni.$u.route({
					url:'/pages/goods_info/index',
					params: {
						goods_id: item.id
					}
				});
			},
			// 加入购物车
			addCar(item){
				console.log(item)
				const params={
					points_gift_id:item.id,
					gift_num:1,
					gift_sku_id:0,
					dealer_id:this.dealer_id,
					openid:this.openid
				}
				Api.addCart(params).then(res=>{
					uni.$u.toast(res.message)
				})
			},
			getUserInfo(){
				return Api.getUserInfo({openid:this.openid,dealer_id:storage.get(DEALERID)||29}).then(res=>{
					const data = Object.assign({},res.data)
					if(data.sex==0){
						data.sex='男'
					}else{
						data.sex='女'
					}
					this.userInfo=data
				})
			},
			change(){
				
			}
		}
	}
</script>

<style lang="scss" scoped>
	.container {
		// padding: 20px;
		font-size: 14px;
		line-height: 24px;
	}
	.user-box{
		width: 100%;
		height: 150rpx;
		display: flex;
		justify-content: flex-start;
		align-items: center;
		padding-left: 30rpx;
		box-sizing: border-box;
		position: relative;
		.point-num-box{
			width: 40%;
			height: 70rpx;
			position: absolute;
			right: 0;
			display: flex;
			justify-content: flex-start;
			align-items: center;
			padding-left: 10rpx;
			color: white;
			box-sizing: border-box;
			border-top-left-radius: 60rpx;
			border-bottom-left-radius: 60rpx;
			background-image: linear-gradient(90deg,#ffc658,#fa8945);
			font-size: 28rpx;
		}
		// background: gray;
	}
	.divider-line{
		width: 100%;
		height: 10rpx;
		position: relative;
		background: #eeeeee;
	}
	.search-box{
		@include flex(column);
		flex: 1;
		width: 95%;
		margin: 0 auto;
		margin-top: 15rpx;
	}

	.nav-box{
		width: 100%;
		height: 180rpx;
		display: flex;
		justify-content: center;
		align-items: center;
		// background: gray;
		.nav-item{
			width: 25%;
			height: 100%;
			display: flex;
			justify-content: center;
			align-items: center;
			flex-direction: column;
		}
	}
	.notice-box{
		width: 100%;
		max-height: 70rpx;
		display: flex;
		justify-content: flex-start;
		align-items: center;
	}
	.recom-item{
		width: 100%;
		height: 200rpx;
		display: flex;
		padding: 0 20rpx;
		box-sizing: border-box;
		justify-content: space-between;
		align-items: center;
		border-bottom: 1px solid #eeeeee;
		.recom-info{
			width: calc(100% - 100px);
			height: 85%;
			display: flex;
			flex-direction: column;
			justify-content: flex-start;
			position: relative;
			.shopping-cart{
				position: absolute;
				right: 10rpx;
				bottom: 10rpx;
			}
		}
		.recom-points{
			width: 100%;
			display: flex;
			justify-content: flex-start;
			align-items: center;
			flex-wrap: nowrap;
		}
	}
</style>
