<template>
	<mescroll-body ref="mescrollRef" :sticky="true" @init="mescrollInit" :down="{ native: true }" @down="downCallback"
	    :up="upOption" @up="upCallback">
	<view class="container">
		<view class="content-box">
			<view class="item-box" v-for="(item,index) in recordsList.data" :key="index">
				<view class="code-box">
					<text>二维码编号：{{item.code}}</text>
					<view style="font-weight: bold;">发放成功</view>
				</view>
				<view class="prize-box">
					<u--image :showLoading="true" v-if="item.prize_type==1" :src="red" width="48px" height="48px"></u--image>
					<u--image :showLoading="true" v-if="item.prize_type==2" :src="points" width="42px" height="42px"></u--image>
					<u--image :showLoading="true" v-if="item.prize_type==3" :src="gifts" width="40px" height="40px"></u--image>
					<view class="prize-info">
						<u--text :text="'红包'+item.money+'元'" v-if="item.prize_type==1" :bold="true" size="13"></u--text>
						<u--text :text="'积分'+item.points" v-if="item.prize_type==2" :bold="true" size="13"></u--text>
						<u--text :text="myGifts(item)" v-if="item.prize_type==3" :bold="true" size="13"></u--text>
						<u--text :text="'中奖时间:'+item.create_time" color="#999" size="12"></u--text>
					</view>
					<!-- <view class="check-qrcode" @click="check(item)" v-if="item.is_get==0&&item.gift.get_prize_mode==1&&item.prize_type==3">
						核销
					</view>
					<view class="check-qrcode" @click="address(item)" v-if="item.is_get==0&&item.gift.get_prize_mode==0&&item.prize_type==3">
						填写地址
					</view> -->
					<view class="bill" v-if="item.prize_type!=3">
						<u--text :text="'+'+(item.prize_type==1?item.money:item.points)" :bold="true" color="#f29100" size="14"></u--text>
					</view>
				</view>
			</view>
		</view>
		<!-- 核销码 -->
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
			@confirm="createOrder"
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
	</mescroll-body>
</template>

<script>
	import MescrollBody from '@/components/mescroll-uni/mescroll-body.vue'
	import MescrollMixin from '@/components/mescroll-uni/mescroll-mixins'
	import { getEmptyPaginateObj, getMoreListData } from '@/core/app'
	import { DEALERID,OPENID,USERINFO } from '@/store/mutation-types'
	import tkiQrcode from "@/components/tki-qrcode/tki-qrcode.vue"
	import {getRrizeRecords} from '@/api/app/user/index.js'
	import * as Api from '@/api/app/user/index.js'
	import storage from '@/utils/storage'
	const pageSize = 10
	export default{
		components: {
		    MescrollBody,
			tkiQrcode
		},
		mixins: [MescrollMixin],
		data(){
			return{
				addressList:[],
				user_address_id:'',
				addressVisalble:false,
				qrcodeVisalble:false,
				gifts:'https://cdn.uni-2id.com/gifts.png',
				points:'https://cdn.uni-2id.com/points.png',
				red: 'https://cdn.uni-2id.com/redpack.png',
				pageNum:1,
				pageSize:10,
				recordsList:getEmptyPaginateObj(),
				dealer_id:'',
				// 上拉加载配置
				upOption: {
				  // 首次自动执行
				  auto: true,
				  // 每页数据的数量; 默认10
				  page: { size: pageSize },
				  // 数量要大于4条才显示无更多数据
				  noMoreSize: 4,
				},
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
				}
			}
		},
		onLoad({dealer_id}) {
			this.dealer_id=dealer_id
		},
		onShow() {
			this.getMemberAddressList()
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
			/**
			   * 上拉加载的回调 (页面初始化时也会执行一次)
			   * 其中page.num:当前页 从1开始, page.size:每页数据条数,默认10
			   * @param {Object} page
			   */
			  upCallback(page) {
				const app = this
				// 设置列表数据
				app.getRrizeRecords(page.num)
				  .then(list => {
					const curPageLen = list.data.length
					const totalSize = list.data.total
					app.mescroll.endBySize(curPageLen, totalSize)
				  })
				  .catch(() => app.mescroll.endErr())
			  },
			getRrizeRecords(pageNo = 1){
				const app = this
				const params={
					page:pageNo,
					pageSize:app.pageSize,
					dealer_id:this.dealer_id,
					openid:storage.get(OPENID)
				}
				return new Promise((resolve, reject) => {
					getRrizeRecords(params).then(result=>{
						const recordsList = result.data.list
						app.recordsList.data = getMoreListData(recordsList, app.recordsList, pageNo)
						resolve(recordsList)
					})
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
			groupChange(val){
				console.log(val)
			},
			radioChange(val){
				console.log(val)
			},
			//填写地址 生成营销订单
			address(){
				this.addressVisalble=true
			},
			createOrder(){
				
			},
			//生成核销二维码
			check(item){
				//检验是否过期
				const valid_day=this.$dayjs(item.create_time).add(item.gift.valid_day,'day')
				if(this.$dayjs().isAfter(this.$dayjs(valid_day))) return uni.$u.toast('奖品已过期')
				this.qrcodeVisalble=true
				this.qrCode.val=item.dealer_id+'/'+item.serial_number+'/'+item.batch
				this.$nextTick(function(){
					this.$refs.qrcode._makeCode()
				})
			},
			myGifts(item){
				return item.gift[0].gift_name
			}
		}
	}
</script>

<style lang="scss" scoped>
	page{
		background: #eeeeee;
		.container{
			background: white;
			padding: 0 20rpx;
			display: flex;
			position: relative;
			box-sizing: border-box;
			background: #eeeeee;
			.content-box{
				width: 100%;
				height: auto;
				display: flex;
				flex-direction: column;
				align-items: center;
				justify-content: center;
				.item-box{
					width: 100%;
					height: 250rpx;
					background: white;
					border-radius: 10rpx;
					margin: 20rpx;
					display: flex;
					flex-direction: column;
					align-items: center;
					padding: 20rpx;
					box-sizing: border-box;
					.bill{
						position: absolute;
						right: 100rpx;
					}
					.check-qrcode{
						min-width: 70rpx;
						height: 35rpx;
						border-radius: 10rpx;
						border: 1px solid red;
						margin-right: 20rpx;
						padding: 0 10rpx;
						font-size: 11px;
						display: flex;
						justify-content: center;
						align-items: center;
						color:red;
						position: absolute;
						right: 100rpx;
					}
					.code-box{
						width: 100%;
						height: 50rpx;
						border-bottom: 1px solid #eeeeee;
						display: flex;
						justify-content: space-between;
						align-items: center;
						font-size: 26rpx;
						color: #333;
					}
					.prize-box{
						width: 100%;
						height: calc(100% - 50rpx);
						display: flex;
						flex-wrap: nowrap;
						align-items: center;
						position: relative;
						.prize-info{
							height: 90%;
							display: flex;
							flex-direction: column;
							align-items: flex-start;
							margin-left: 20rpx;
						}
					}
				}
			}
		}
	}
</style>