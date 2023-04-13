<template>
	<view class="container">
		<view class="u-demo-block__content">
			<u-tabs :list="nav_list"  @change="changeTab" :current="current" lineColor="#fa3534" :scrollable="false">
			</u-tabs>
		</view>
		<view class="order-box">
			<view class="order-item" v-for="(item,index) in orderInfo" :key="index">
				<view class="order-list">
					<view class="order-time">
						<text>二维码编号：{{item.code}}</text>
						<text style="color:red">{{item.is_get|is_get}}</text>
					</view>
					<view class="goods-item" @click="checkOrderInfo(item)">
						<u--image :showLoading="true" :src="cover(item.gift)" width="90px" height="90px"></u--image>
						<view class="recom-info">
							<u--text :lines="2" :text="goods(item)" size="13"></u--text>
							<u--text text="" color="gray" size="12"></u--text>
							<view class="recom-points">
								<!-- <u-icon name="integral" color="#ff9900" size="18"></u-icon> -->
								<u--text style="flex:none" :text="'下单时间'+item.create_time" color="#999" size="12"></u--text>
								<!-- <u--text v-if="it.type==2" :text="'+￥'+it.money" color="#ff9900" size="12"></u--text> -->
							</view>
						</view>
					</view>
					<view class="set-box">
						<u-tag v-if="is_check(item)" text="核销" @click="check(item)" plain size="mini" type="warning"></u-tag>
						<u-tag v-if="is_address(item)" text="登记地址" @click="address(item)" plain size="mini" type="warning"></u-tag>
					</view>
				</view>
			</view>
			<u-modal
				title="核销码"
				:show="qrcodeVisalble"
				closeOnClickOverlay
				confirmText="下载"
				@close="closeQrcode"
				@confirm="downQrcode"
				closeOnClickOverlay
			>
				<view>
				 <tki-qrcode
					 ref="qrcode"
					 :val="qrCode.val"
					 :size="qrCode.size"
					 :background="qrCode.background"
					 :foreground="qrCode.foreground"
					 :pdground="qrCode.pdground"
					 :iconSize="qrCode.iconsize"
					 :lv="qrCode.lv" 
					 :unit="qrCode.unit"
					 :onval="qrCode.onval"
					 :loadMake="qrCode.loadMake"
					 :usingComponents="true"
					 :showLoading="qrCode.showLoading"
					 :loadingText="qrCode.loadingText"
					 @result="qrR" />
				</view>
			</u-modal>
			<u-modal
				title="收货地址"
				:show="addressVisalble"
				closeOnClickOverlay
				confirmText="提交"
				@close="closeAddress"
				@confirm="registerAddress"
				closeOnClickOverlay
			>
				<view>
					 <u-radio-group
					    v-model="user_address_id"
					    placement="column"
					    @change="groupChange"
					  >
					    <u-radio
					      :customStyle="{marginBottom: '8px'}"
					      v-for="(item, index) in addressList"
					      :key="index"
					      :label="item.address+' '+item.location"
					      :name="item.id"
					      @change="radioChange"
					    >
					    </u-radio>
					  </u-radio-group>
				</view>
			</u-modal>
		</view>
	</view>
</template>

<script>
	import * as Api from '@/api/app/user/index.js'
	import storage from '@/utils/storage'
	import { DEALERID,OPENID } from '@/store/mutation-types'
	import tkiQrcode from "@/components/tki-qrcode/tki-qrcode.vue"
	export default{
		components: {
			tkiQrcode
		},
		data(){
			return{
				addressList:[],
				user_address_id:'',
				qrcodeVisalble:false,
				addressVisalble:false,
				cancelShow:false,
				current:0,
				status:-2,
				openid:storage.get(OPENID),
				dealer_id:'',
				orderInfo:[],
				selectOrder:{},
				qrCode:{
					val:"",
					size:400,
					unit: 'upx', // 单位
					background:'#000000',
					foreground:'#ffffff',
					pdground:'#ffffff',
					iconsize:60,
					lv:3,
					onval:true,
					loadMake:true,
					src:'',
					showLoading: true, // 是否显示loading
					loadingText: '二维码生成中', // loading展示文案
				},
				nav_list: [
					{
					  name: '全部订单',
					  id: '-2'
					},
					{
					  name: '待发货',
					  id: '0'
					},
					{
					  name: '待收货',
					  id: '1'
					},
					{
					  name: '已完成',
					  id: '2'
					},
					{
					  name: '已过期',
					  id: '-3'
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
			},
			is_get(val){
				if(val==0) return '未领取'
				return '已领取'
			}
		},
		onLoad({status,dealer_id}) {
			this.dealer_id=dealer_id
			if(status){
				this.status=status
				switch (status||status==0){
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
			this.getMemberAddressList()
			this.getMyOrder()
		},
		methods:{
			getMemberAddressList(){
				const params={
					dealer_id:this.dealer_id,
					openid:storage.get(OPENID)
				}
				Api.getMemberAddressList(params).then(res=>{
					this.addressList=res.data
					this.user_address_id=res.data.filter(item=>item.is_default==2).map(item=>item.id)[0]
					console.log(this.user_address_id)
				})
			},
			groupChange(val){
				console.log(val)
			},
			radioChange(val){
				console.log(val)
			},
			is_check(item){
				//判断时间
				if(this.$dayjs().isAfter(this.$dayjs(item.valid_day))) return false
				if(item.is_get==0&&item.get_prize_mode==1) return true
				return false
			},
			is_address(item){
				if(this.$dayjs().isAfter(this.$dayjs(item.valid_day))) return false
				if(item.is_get==0&&item.get_prize_mode==0&&!item.user_address_id) return true
				return false
			},
			cover(gift){
				return JSON.parse(gift)[0].url
			},
			goods(val){
			  return JSON.parse(val.gift)[0].gift_name+`(礼品id:${JSON.parse(val.gift)[0].gift_id})`
			},
			changeTab(val){
				this.status=val.id
				this.orderInfo=[]
				this.getMyOrder()
			},
			address(item){
				this.addressVisalble=true
				this.selectOrder=item
			},
			registerAddress(){
				const params={
					id:this.selectOrder.id,
					dealer_id:this.dealer_id,
					user_address_id:this.user_address_id
				}
				Api.registerOrderAddress(params).then(res=>{
					if(res.status==200){
						this.$toast(res.message)
						this.addressVisalble=false
						setTimeout(()=>{
							this.getMyOrder()
						},1000)
					}else{
						this.$toast(res.message)
					}
				})
			},
			closeQrcode(){
				this.$refs.qrcode._clearCode()
				this.qrcodeVisalble=false
			},
			closeAddress(){
				this.addressVisalble=false
			},
			downQrcode(){
				this.$refs.qrcode._saveCode()
				this.qrcodeVisalble=false
			},
			qrR(res){
				this.qrCode.src=res
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
					url: 'pages/member/order_info',
					params: {
						dealer_id:this.dealer_id,
						order_id: item.id
					}
				})
			},
			getMyOrder(){
				const params={
					dealer_id:this.dealer_id,
					openid:this.openid,
					status:this.status
				}
				Api.getMarketingOrderList(params).then(res=>{
					this.orderInfo=res.data
				})
			},
			//生成核销二维码
			check(item){
				//检验是否过期
				// const valid_day=this.$dayjs(item.create_time).add(item.gift.valid_day,'day')
				// if(this.$dayjs().isAfter(this.$dayjs(valid_day))) return uni.$u.toast('奖品已过期')
				this.qrcodeVisalble=true
				this.qrCode.val=item.dealer_id+'/'+item.id
				this.$nextTick(function(){
					this.$refs.qrcode._makeCode()
				})
			},
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
					position: relative;
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
						position: absolute;
						right: 8px;
						bottom: 40px;
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