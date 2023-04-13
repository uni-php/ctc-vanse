<template>
	<view class="container">
		<view class="bannner-box">
			<image :src="banner_url" mode="aspectFill"></image>
			<view class="user-info">
				<view>门店名称：{{store_info.store_name}}</view>
				<view class="company">ID：{{store_info.store_code}}</view>
			</view>
			<view class="set-box">
				<u-icon @click="notice" size="24" color="#ffffff" name="email"></u-icon>
				<u-icon @click="store_url" style="margin:0 20rpx" size="24" color="#ffffff" name="share"></u-icon>
				<u-icon @click="setting" size="24" color="#ffffff" name="setting"></u-icon>
			</view>
		</view>
		<view class="nav-box" style="width: 100%;">
			<view class="u-demo-block">
				<view class="grid-title" v-if="store_info.is_mall==1">
					<u--text :bold="true" :size="16" text="商城管理"></u--text>
				</view>
				<u-grid
					:border="false"
					col="4"
					v-if="store_info.is_mall==1"
				>
					<u-grid-item
						v-for="(listItem,listIndex) in new_mall_list"
						:key="listIndex"
						@click="click(listItem.url)"
						customStyle="padding:6px;font-size:14px"
					>
						<u-icon
							:customStyle="{paddingTop:20+'rpx',paddingBottom:10+'rpx'}"
							:name="listItem.name"
							color="#409EFF"
							:size="30"
						></u-icon>
						<text class="grid-text">{{listItem.title}}</text>
					</u-grid-item>
				</u-grid>
				<view class="grid-title">
					<u--text :bold="true" :size="16" text="信息管理"></u--text>
				</view>
				<u-grid
					:border="false"
					col="4"
				>
					<u-grid-item
						v-for="(listItem,listIndex) in notice_list"
						:key="listIndex"
						@click="click(listItem.url)"
						customStyle="padding:6px;font-size:14px"
					>
						<u-icon
							:customStyle="{paddingTop:20+'rpx',paddingBottom:10+'rpx'}"
							:name="listItem.name"
							color="#409EFF"
							:size="30"
						></u-icon>
						<text class="grid-text">{{listItem.title}}</text>
					</u-grid-item>
				</u-grid>
				<view class="grid-title">
					<u--text :bold="true" :size="16" text="导购管理"></u--text>
				</view>
				<u-grid
					:border="false"
					col="4"
				>
					<u-grid-item
						v-for="(listItem,listIndex) in store_list"
						:key="listIndex"
						@click="click(listItem.url)"
						customStyle="padding:6px;font-size:14px"
					>
						<u-icon
							:customStyle="{paddingTop:20+'rpx',paddingBottom:10+'rpx'}"
							:name="listItem.name"
							color="#409EFF"
							:size="30"
						></u-icon>
						<text class="grid-text">{{listItem.title}}</text>
					</u-grid-item>
				</u-grid>
				<view class="grid-title" v-if="store_info.is_self_lifting==1">
					<u--text :bold="true" :size="16" text="核销管理"></u--text>
				</view>
				<u-grid
					:border="false"
					col="4"
					v-if="store_info.is_self_lifting==1"
				>
					<u-grid-item
						v-for="(listItem,listIndex) in check_list"
						:key="listIndex"
						@click="click(listItem.url)"
						customStyle="padding:6px;font-size:14px"
					>
						<u-icon
							:customStyle="{paddingTop:20+'rpx',paddingBottom:10+'rpx'}"
							:name="listItem.name"
							color="#409EFF"
							:size="30"
						></u-icon>
						<text class="grid-text">{{listItem.title}}</text>
					</u-grid-item>
				</u-grid>
				<!-- <view class="grid-title">
					<u--text :bold="true" :size="16" text="系统管理"></u--text>
				</view>
				<u-grid
					:border="false"
					col="3"
				>
					<u-grid-item
						v-for="(listItem,listIndex) in sys_list"
						:key="listIndex"
						customStyle="padding:6px;font-size:14px"
					>
						<u-icon
							:customStyle="{paddingTop:20+'rpx',paddingBottom:10+'rpx'}"
							:name="listItem.name"
							color="#409EFF"
							:size="30"
						></u-icon>
						<text class="grid-text">{{listItem.title}}</text>
					</u-grid-item>
				</u-grid> -->
			</view>
		</view>
		<u-modal
			title="门店商城"
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
			content="确认退出登录吗"
			:show="show"
			showCancelButton
			closeOnClickOverlay
			@confirm="confirm"
			@cancel="cancel"
			@close="close"
		></u-modal>
	</view>
</template>

<script>
	import {AUTH_INFO,OPENID,USER_ID,USER_INFO,STORE_INFO } from '@/store/mutation-types'
	import tkiQrcode from "@/components/tki-qrcode/tki-qrcode.vue"
	import storage from '@/utils/storage'
	import {isNumber} from '@/utils/verify.js'
	import {mapGetters} from 'vuex'
	export default {
		components: {
			tkiQrcode
		},
		computed:{
			...mapGetters(['storeInfo'])
		},
		data() {
			return {
				store_info:{},
				qrcodeVisalble:false,
				banner_url:'http://cdn.uni-2id.com/pda_banner.png',
				loadingShow: false,
				show: false,
				queryParams:{
					page:1,
					pageSize:5
				},
				user:{},
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
				mall_list:[
					{
						name: 'bag',
						title: '商城选品',
						url:'pages/goods/index'
					},
					{
						name: 'list-dot',
						title: '上下架管理',
						url:'pages/goods/my_goods'
					},
					{
						name: 'order',
						title: '门店订单',
						url:'pages/order/index'
					}
				],
				notice_list:[
					{
						name: 'bell',
						title: '公告消息',
						url:'pages/notice/index'
					}
				],
				store_list:[
					{
						name: 'account',
						title: '导购管理',
						url:'pages/guide/index'
					},
					{
						name: 'file-text',
						title: '扫码记录',
						url:'pages/guide/guide_scan'
					},
					{
						name: 'file-text',
						title: '领奖记录',
						url:'pages/guide/prize_log'
					}
				],
				check_list:[
					{
						name: 'scan',
						title: '扫码核销',
						url:'pages/check/index'
					},
					{
						name: 'file-text',
						title: '核销记录',
						url:'pages/check/log'
					}
				],
				sys_list:[
					{
						name: 'account',
						title: '店员管理',
						url:'pages/inWarehouse/index'
					},
					{
						name: 'file-text',
						title: '操作日志',
						url:'pages/inWarehouse/index'
					}
				]
			}
		},
		
		onShow() {
			this.user=storage.get(USER_INFO)||this.userInfo
			// #ifdef MP-WEIXIN
			wx.hideHomeButton()//小程序隐藏登录页
			// #endif
			this.store_info=storage.get(STORE_INFO)
		},
		computed: {
			new_mall_list() {
				if(this.store_info.is_goods_self==0){
					return this.mall_list.filter((item,index)=>index<=0)
				}else{
					return this.mall_list
				}
			}
		},
		created(){
		},
		methods: {
			notice(){
				uni.$u.route({
					url: 'pages/notice/index'
				})
			},
			setting(){
				uni.$u.route({
					url: 'pages/user/index'
				})
			},
			click(url) {
				if(url=='/pages/exit/index'){
					this.show=true
				}else{
					uni.$u.route(url);
				}
			},
			confirm() {
				//退出登录
				setTimeout(() => {
					uni.$u.route({
						url: 'pages/login/login',
						type:'reLaunch'
					})
				}, 500)
			},
			cancel() {
				this.show = false
			},
			close() {
				this.show = false
			},
			//生成门店二维码
			store_url(){
				this.qrcodeVisalble=true
				this.qrCode.val='http://jifen.uni-2id.com/store_shop/?dealer_id='+this.store_info.dealer_id+'&store_id='+this.store_info.id
				this.$nextTick(function(){
					this.$refs.qrcode._makeCode()
				})
			},
			closeQrcode(){
				this.$refs.qrcode._clearCode()
				this.qrcodeVisalble=false
			},
			downQrcode(){
				this.$refs.qrcode._saveCode()
				this.qrcodeVisalble=false
			},
			qrR(res){
				this.qrCode.src=res
			},
		}
	}
</script>
<style>
	page{
		background: white;
	}
</style>
<style lang="scss" scoped>
	.container{
		padding-bottom: 50rpx;
		position: relative;
		.bannner-box{
			width: 750rpx;
			height: 150px;
			display: flex;
			justify-content: center;
			align-items: center;
			position: relative;
			.user-info{
				width: 100%;
				height: auto;
				position: absolute;
				font-size: 15px;
				padding-left: 30rpx;
				box-sizing: border-box;
				color: white;
				font-weight: 600;
				.company{
					font-size: 400;
					font-size: 13px;
					padding-top: 20rpx;
				}
			}
			.set-box{
				position: absolute;
				right: 30rpx;
				top: 80rpx;
				display: flex;
				justify-content: center;
				align-items: center;
				flex-wrap: nowrap;
			}
			image{
				width: 100%;
				height: 100%;
			}
		}
		.grid-title{
			width: 100%;
			padding: 20rpx;
		}
	}
</style>
