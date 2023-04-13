<template>
	<view class="container">
		<view class="u-demo-block__content">
			<u-tabs :list="nav_list"  @change="changeTab" :current="current" lineColor="#fa3534" :scrollable="false">
			</u-tabs>
		</view>
		<view class="order-box">
			<view class="order-item" v-for="(item,index) in orderInfo" :key="index">
				<view class="order-list" v-if="item.pay_mode=='direct'">
					<view class="order-time">
						<text>{{item.create_time}}</text>
						<text style="color:red">{{item.status|status}}</text>
					</view>
					<view class="goods-item" @click="checkOrderInfo(item)">
						<u--image :showLoading="true" :src="item.order_gift_info.cover.length>0?item.order_gift_info.cover[0].url:''" width="90px" height="90px"></u--image>
						<view class="recom-info">
							<u--text :lines="2" :text="item.order_gift_info.gift_name" size="13"></u--text>
							<u--text text="" color="gray" size="12"></u--text>
							<view class="recom-points">
								<u-icon name="integral" color="#ff9900" size="18"></u-icon>
								<u--text style="flex:none" :text="item.order_gift_info.points_num" color="#ff9900" size="12"></u--text>
								<u--text v-if="item.order_gift_info.type==2" :text="'+￥'+item.order_gift_info.money" color="#ff9900" size="12"></u--text>
							</view>
							<view class="shopping-cart">
								<u--text text="x1" size="13" color="gray"></u--text>
							</view>
						</view>
					</view>
					<view class="sum-box">
						共1件商品 总积分{{item.total_points}}
					</view>
					<view class="set-box">
						<u-tag v-if="item.status==0||item.status==-1" text="取消" @click="cancelOrder(item)" plain size="mini" type="warning"></u-tag>
					</view>
				</view>
				<view class="order-list" v-else>
					<view class="order-time">
						<text>{{item.create_time}}</text>
						<text style="color:red">{{item.status|status}}</text>
					</view>
					<view class="goods-item" v-for="(it,idx) in item.order_gift_info" @click="checkOrderInfo(item)">
						<u--image :showLoading="true" :src="it.cover.length>0?it.cover[0].url:''" width="90px" height="90px"></u--image>
						<view class="recom-info">
							<u--text :lines="2" :text="it.gift_name" size="13"></u--text>
							<u--text text="" color="gray" size="12"></u--text>
							<view class="recom-points">
								<u-icon name="integral" color="#ff9900" size="18"></u-icon>
								<u--text style="flex:none" :text="it.points_num" color="#ff9900" size="12"></u--text>
								<u--text v-if="it.type==2" :text="'+￥'+it.money" color="#ff9900" size="12"></u--text>
							</view>
							<view class="shopping-cart">
								<u--text :text="'x'+`${it.gift_num}`" size="13" color="gray"></u--text>
							</view>
						</view>
					</view>
					<view class="sum-box">
						共{{sum(item.order_gift_info)}}件商品 总积分{{item.total_points}}
					</view>
					<view class="set-box">
						<u-tag v-if="item.status==-1" text="取消" @click="cancelOrder(item)" plain size="mini" type="warning"></u-tag>
					</view>
				</view>
			</view>
		</view>
		<u-modal
			content="您确定要取消该订单吗？"
			:show="cancelShow"
			showCancelButton
			closeOnClickOverlay
			@confirm="confirm"
			@cancel="cancelShow=false"
			@close="cancelShow=false"
		></u-modal>
	</view>
</template>

<script>
	import * as Api from '@/api/app/points/index.js'
	import storage from '@/utils/storage'
	import { DEALERID,OPENID } from '@/store/mutation-types'
	export default{
		data(){
			return{
				cancelShow:false,
				current:0,
				status:-2,
				openid:storage.get(OPENID),
				orderInfo:[],
				selectOrder:{},
				nav_list: [
					{   id:-2,
						name: '全部'
					}, {
						id:-1,
						name: '待付款',
					}, {
						id:0,
						name: '待发货',
					}, {
						id:1,
						name: '待收货'
					},
					{
						id:2,
						name: '已完成'
					}
				]
			}
		},
		filters:{
			status(val){
				if(val==0) return '待发货'
				if(val==1) return '待收货'
				if(val==2) return '已完成'
				if(val==-1) return '待付款'
			}
		},
		onLoad({status}) {
			if(status){
				this.status=status
				switch (status){
					case 0:
					this.current==2
					break;
					case -1:
					this.current==1
					break;
				}
			}
		},
		onShow() {
			this.getMyOrder()
		},
		methods:{
			sum(val){
				let sum=0
				val.forEach((item,index)=>{
					sum+=item.gift_num
				})
				return sum
			},
			changeTab(val){
				this.status=val.id
				this.orderInfo=[]
				this.getMyOrder()
			},
			cancelOrder(item){
				this.cancelShow=true
				this.selectOrder=item
			},
			confirm(){
				Api.cancelMyOrder(this.selectOrder).then(res=>{
					if(res.status==200){
						this.$toast(res.message)
						setTimeout(()=>{
							this.cancelShow=false
							this.getMyOrder()
						},1000)
					}else{
						this.$toast(res.message)
					}
				})
			},
			checkOrderInfo(item){
				uni.$u.route({
					url: 'pages/order_info/index',
					params: {
						order_id: item.order_id
					}
				})
			},
			getMyOrder(){
				const params={
					dealer_id:storage.get(DEALERID),
					openid:this.openid,
					status:this.status
				}
				Api.getMyOrder(params).then(res=>{
					this.orderInfo=res.data
				})
			}
		}
	}
</script>

<style lang="scss" scoped>
	.container{
		width: 100%;
		height: auto;
		background: #eeeee;
		.order-box{
			width: 100%;
			height: auto;
			display: flex;
			justify-content: center;
			align-items: center;
			flex-direction: column;
			padding: 20rpx;
			box-sizing: border-box;
			.order-item{
				width: 100%;
				height: auto;
				display: flex;
				justify-content: center;
				align-items: center;
				flex-direction: column;
				background: white;
				border-radius: 10rpx;
				margin-bottom: 20rpx;
				.order-list{
					width: 100%;
					height: auto;
					display: flex;
					justify-content: flex-start;
					align-items: center;
					flex-direction: column;
					padding: 20rpx;
					box-sizing: border-box;
					.order-time{
						width: 100%;
						height: auto;
						display: flex;
						justify-content: space-between;
						align-items: center;
						font-size: 26rpx;
						margin: 10rpx 0;
						color: $uni-text-color-grey;
					}
					.sum-box,.set-box{
						width: 100%;
						display: flex;
						justify-content: flex-end;
						align-items: center;
						font-size: 26rpx;
						color: $uni-text-color;
						margin-top: 15rpx;
					}
					.goods-item{
						width: 100%;
						height: 200rpx;
						display: flex;
						justify-content: space-between;
						align-items: center;
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
					}
					.recom-points{
						width: 100%;
						display: flex;
						justify-content: flex-start;
						align-items: center;
						flex-wrap: nowrap;
					}
				}
			}
		}
	}
</style>