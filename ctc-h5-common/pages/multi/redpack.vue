<template>
	<view class="container">
		<view class="page_box" v-if="activity.tpl_info.welcom_page[0]['is_active']==1&&welcom_duration>0" :style="{'padding-top': statusHeight+'px'}">
			<image :src="activity.tpl_info.welcom_page[0]['cover']"></image>
			<view class="skip">
				{{activity.tpl_info.welcom_page[0]['tips']+'('+welcom_duration+')'}}
			</view>
		</view>
		<view class="page_box" v-if="activity.tpl_info.welcom_page[0]['is_active']==0||welcom_duration==0" :style="{'padding-top': statusHeight+'px'}">
		  <image :src="activity.tpl_info.activity_page[0]['cover']"></image>
		  <view class="prize-btn" @click="getPrize"></view>
		  <!-- 活动规则 -->
		  <view class="rule" @click="ruleDes" v-if="activity.is_rule_show==1">
			  查看规则
		  </view>
		</view>
		<!-- 防伪弹框 -->
		<u-overlay :show="fw_show" @click="fw_show = false">
			<view class="warp">
				<view class="fw-box" @tap.stop>
					<u-icon name="info-circle" color="#ffffff" size="100"></u-icon>
					<view class="is_true" v-if="activity.tpl_info.activity_page[0]['is_first']==1">正品</view>
					<view class="is_true" v-else>重复</view>
					<view class="fw_code" v-if="activity.tpl_info.xuanchuan_page[0]['is_auth_code']==1">
						<view>{{activity.tpl_info.xuanchuan_page[0]['auth_tips']}}: {{qrcode}}</view>
					</view>
					<view class="fw_res">
						{{activity.tpl_info.activity_page[0]['fangwei_res']}}
					</view>
					<view class="fw-btn" @click="fw_show = false">去领取</view>
				</view>
			</view>
		</u-overlay>
		<!-- 中奖结果 -->
		<u-overlay :show="res_show" @click="res_show = false">
			<view class="warp">
				<view class="prize-box" @tap.stop>
					<image :src="prize_bk"></image>
					<view class="prize-text">
						{{prize_res}}
					</view>
					<view class="prize-time" v-if="prize_time">领取时间：{{prize_time}}</view>
					<view class="close-btn" @click="res_show = false"></view>
				</view>
			</view>
		</u-overlay>
		<!-- 实物中奖 -->
		<u-overlay :show="shiwu_res_show" @click="shiwu_res_show = false">
			<view class="warp">
				<view class="prize-box" @tap.stop>
					<image :src="prize_bk1"></image>
					<view class="prize-text" style="flex-direction: column;top: 18%">
						<u--image radius="4" :showLoading="true" :src="gift_img" width="60px" height="60px"></u--image>
						<text style="margin-top: 20px;font-size: 28rpx;">恭喜您获得：</text>
						<text style="margin-top: 10px;">{{prize_res}}</text>
					</view>
					<view class="prize-time" v-if="prize_time">中奖时间：{{prize_time}}</view>
					<view class="close-btn" @click="handle_des"></view>
				</view>
			</view>	
		</u-overlay>
		<!-- 查看规则 -->
		<u-overlay :show="rule_show" @click="rule_show = false">
			<view class="warp">
				<view class="rule-box">
					<view class="rule-title">{{activity.rule_title}}</view>
					<view class="rule-content">
						<u--text lineHeight="30" :block="true" align="center" :text="activity.rule_content"></u--text>
					</view>
				</view>
			</view>	
		</u-overlay>
		<!-- 信息收集 -->
		<u-overlay :show="field_show">
			<view class="warp">
				<view class="collect-info-box" style="position: relative;">
					<view style="width: 100%;" v-for="(item,index) in user_info_field" :key="index">
						<view class="uni-list-line" v-if="item.type==1" style="width: 100%;display: flex;justify-content: center;margin-top: 20rpx;">
							<u--input
							    style="width: 80%;"
							    :placeholder="item.placeholder"
							    border="surround"
							    v-model="item.value"
							  ></u--input>
						</view>
						<view class="uni-list-line" v-else style="width: 100%;display: flex;justify-content: center;margin-top: 20rpx;">
							<u-upload
								:fileList="fileList"
								@afterRead="afterRead"
								@delete="deletePic"
								name="4"
								multiple
								:maxCount="1"
							></u-upload>
						</view>
					</view>
					<u-button
						type="primary"
						text="提交"
						style="background: #42a1f7;border:0;height: 70rpx;bottom: 30rpx;position: absolute;width: 90%;"
						customStyle="margin-top: 50px"
						@click="submitForm"
					></u-button>
				</view>
			</view>
		</u-overlay>
	</view>
</template>
<script>
	import storage from '@/utils/storage'
	import { OPENID,USERINFO } from '@/store/mutation-types'
	import {getJsConfig,getRedTpl,getRedPrize} from '@/api/app/multi/index.js'
	import Config from '@/core/config'
	var wxjssdk = require("jweixin-module");
	import QQMapWX from '@/js_sdk/qqmap-h5.js'
	// const QQMap = new QQMapWX({
	// 	key: 'K3PBZ-PSUCD-T3A4R-P5JPH-6MCR2-KYF6K'
	// });
	var timer=undefined
	export default{
		data(){
			return{
				shiwu_res_show:false,
				gift_img:'',
				fileList:[],
				qqMap: new QQMapWX({key: 'K3PBZ-PSUCD-T3A4R-P5JPH-6MCR2-KYF6K',vm: this}),
				url:'',
				prize_time:'',
				prize_res:'',
				prize_bk:require('@/static/qrcode_bk.png'),
				prize_bk1:require('@/static/qrcode_bk1.png'),
				res_show:false,
				fw_show:false,
				rule_show:false,
				field_show:false,
				appid:'',//用户公众号appid,
				qrcode:'',
				dealer_id:'',
				batch:'',
				is_user_info:0,
				user_info_field:[],
				welcom_duration:-1,
				options: {},
				// 页面属性
				page: {},
				rules:{
					
				},
				userInfo:{
					
				},
				address:{
					province:'河北省',
					city:'石家庄市',
					district:'长安区'
				},//用户地区
				activity:{
					tpl_info:{
						welcom_page:[{
							cover:'',
							tips:'',
							is_active:0
						}]
					}
				}
			}
		},
		onLoad({dealer_id,qrcode,batch}) {
			if(uni.getSystemInfoSync().platform == 'ios'){
				this.url=storage.get('url')
			}else{
				// this.url=storage.get('url')
				this.url=location.href.split('#')[0]
			}
			this.dealer_id=dealer_id
			this.batch=batch 
			this.qrcode=qrcode
			// clearInterval(timer)
			const params={
				qrcode:qrcode,
				batch:batch,
				dealer_id:dealer_id,
				openid:storage.get(OPENID)
			}
			//查询设置模板 =》启动页=》 页面标题
			getRedTpl(params).then(res=>{
				//
				this.activity=res.data
				this.welcom_duration=res.data.tpl_info.welcom_page[0]['duration']
				if(res.data.tpl_info.welcom_page[0]['is_active']==1){
					timer=setInterval(()=>{
						this.welcom_duration--
					},1000)
				}
				if(this.activity.welcom_page[0]['is_active']==0&&this.activity.activity_page[0]['is_fangwei']==1){
					this.fw_show=true
				}
				this.setPageBar(res.data);
			})
		},
		onShow() {
			var that=this;
			getJsConfig({dealer_id:this.dealer_id,url:this.url}).then(res=>{
				// console.log(res)
				wxjssdk.config({
				  debug: false, // 开启调试模式,调用的所有api的返回值会在客户端alert出来，若要查看传入的参数，可以在pc端打开，参数信息会通过log打出，仅在pc端时才会打印。
				  appId: res.data.appId, // 必填，公众号的唯一标识
				  timestamp:res.data.timestamp, // 必填，生成签名的时间戳
				  nonceStr: res.data.nonceStr, // 必填，生成签名的随机串
				  signature: res.data.signature,// 必填，签名
				  jsApiList: res.data.jsApiList // 必填，需要使用的JS接口列表
				});
				if(this.activity.is_user_address==1){
					wxjssdk.ready(function(){
					   wxjssdk.getLocation({
							type: "wgs84", // 默认为wgs84的gps坐标，如果要返回直接给openLocation用的火星坐标，可传入'gcj02'
							success: function (res1) {
								console.log(res1)
								//地址逆解析
								that.qqMap.reverseGeocoder({
									location: {
										latitude: res1.latitude,
										longitude: res1.longitude
									},
									success: function(res) {
										console.log("解析地址成功");
										console.log(res);
										// 省
										let province = res.result.ad_info.province;
										// 市
										let city = res.result.ad_info.city;
										that.address=res.result.ad_info
										console.log(province);
										console.log(city);
									},
									fail: function(res) {
										uni.showToast({
											title: '定位失败',
											duration: 2000,
											icon: "none"
										})
										console.log(res);
									},
									complete: function(res) {
										console.log(res);
									}
								})
							  // this.latitude = res.latitude; // 纬度，浮点数，范围为90 ~ -90
							  // this.longitude = res.longitude; // 经度，浮点数，范围为180 ~ -180。
							  // this.accuracy = res.accuracy; // 位置精度
							},
						});
					});
				}
			})
		},
		watch:{
			welcom_duration(val){
				if(val==0) {
					clearInterval(timer)
					uni.setNavigationBarTitle({
					  title: this.activity.tpl_info.activity_page[0]['title']
					});
					if(this.activity.tpl_info.activity_page[0]['is_fangwei']==1){
						this.fw_show=true
					}
				}
			}
		},
		computed: {
		    //状态栏高度
		    statusHeight(){
				console.log(uni.getSystemInfoSync().statusBarHeight)
		        return uni.getSystemInfoSync().statusBarHeight || 10;    //如果没有获取到高度，那么指定10px；
		    },
			// fw_show(){
			// 	if((this.activity.welcom_page[0]['is_active']==0||this.welcom_duration==0)&&this.activity.activity_page[0]['is_fangwei']==1){
			// 		return true
			// 	}else{
			// 		return false
			// 	}
			// }
		},
		methods:{
			setPageBar(item){
				const {
				  page
				} = this
				// 设置页面标题
				if(item.tpl_info.welcom_page[0]['is_active']==1){
					uni.setNavigationBarTitle({
					  title: item.tpl_info.welcom_page[0]['title']
					});
				}else{
					uni.setNavigationBarTitle({
					  title: item.tpl_info.activity_page[0]['title']
					});
				}
				// 设置navbar标题、颜色
				uni.setNavigationBarColor({
				  frontColor: page.style.titleTextColor === 'white' ? '#ffffff' : '#000000',
				  backgroundColor: page.style.titleBackgroundColor
				})
			},
			//查看规则
			ruleDes(){
				this.rule_show=true
			},
			submitForm(){
				for(var i=0;i<this.user_info_field.length;i++){
					if(this.user_info_field[i]['type']==1){
						if(!this.user_info_field[i]['value']) return uni.$u.toast('请检查必填字段')
					}
					if(this.user_info_field[i]['type']==5){
						if(this.fileList.length==0) {
							return uni.$u.toast('请上传图片')
							break
						}
						this.$set(this.user_info_field[i],'value',this.fileList[0]['url'])
					}
				}
				this.is_user_info=1
				this.getPrize()
			},
			// 删除图片
			deletePic(event) {
				this.fileList.splice(event.index, 1)
			},
			// 新增图片
			async afterRead(event) {
				// 当设置 mutiple 为 true 时, file 为数组格式，否则为对象格式
				let lists = [].concat(event.file)
				let fileListLen = this.fileList.length
				lists.map((item) => {
					this.fileList.push({
						...item,
						status: 'uploading',
						message: '上传中'
					})
				})
				for (let i = 0; i < lists.length; i++) {
					const result = await this.uploadFilePromise(lists[i].url)
					let item = this.fileList[fileListLen]
					this.fileList.splice(fileListLen, 1, Object.assign(item, {
						status: 'success',
						message: '上传成功',
						url: JSON.parse(result).data.imgPath
					}))
					fileListLen++
				}
				console.log(this.fileList)
			},
			uploadFilePromise(url) {
				console.log(url)
				return new Promise((resolve, reject) => {
					let a = uni.uploadFile({
						url: Config.get('apiUrl')+'qrcode/uploadFile', // 仅为示例，非真实的接口地址
						filePath: url,
						name: 'file',
						formData: {
							user: 'test'
						},
						success: (res) => {
							setTimeout(() => {
								resolve(res.data)
							}, 1000)
						}
					});
				})
			},
			handle_des(){
				const url='http://yx.uni-2id.com/user?dealer_id='+this.dealer_id
				window.location.href=url
			},
			//领奖
			getPrize(){
				const data={
					qrcode:this.qrcode,
					batch:this.batch,
					dealer_id:this.dealer_id,
					openid:storage.get(OPENID),
					address:this.address,
					activity_id:this.activity.id,
					serial_number:this.activity.serial_number,
					is_user_info:this.is_user_info,
					user_info_field:this.is_user_info==1?this.user_info_field:undefined
				}
				// this.res_show=true
				getRedPrize(data).then(res=>{
					console.log(res)
					if(res.status==201){
						this.prize_res=res.data[0]
						this.prize_time=res.data[1]
						this.field_show=false
						this.res_show=true
					}
					//开启表单验证
					if(res.status==202){
						this.user_info_field=res.data
						this.field_show=true
					}
					if(res.status==200){
						//中奖
						this.prize_res=res.data
						this.field_show=false
						this.res_show=true
					}
					if(res.status==203){
						//实物中奖
						this.prize_res=res.data.gift[0].gift_name
						this.gift_img=res.data.gift[0].url
						this.field_show=false
						this.shiwu_res_show=true
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
		height: 100vh;
		.warp {
			display: flex;
			align-items: center;
			justify-content: center;
			height: 100%;
			.rule-box,.collect-info-box{
				width: 550rpx;
				height: 700rpx;
				background: white;
				display: flex;
				// justify-content: center;
				align-items: center;
				flex-direction: column;
				font-size: 28rpx;
				color: $uni-text-color;
				padding: 20rpx;
				border-radius: 20rpx;
				.rule-content{
					display: flex;
					align-items: flex-start;
					width: 100%;
					height: 450rpx;
					padding: 30rpx;
					box-sizing: border-box;
				}
				.rule-title{
					width: 95%;
					height: 80rpx;
					display: flex;
					justify-content: center;
					align-items: center;
					border-bottom: 1px solid #eeeeee;
					font-weight: 600;
					color: #3c0e12;
					font-size: 32rpx;
				}
			}
			.collect-info-box{
				overflow: auto;
				padding-bottom: 100px;
			}
			.prize-box{
				width: 550rpx;
				height: 550rpx;
				display: flex;
				justify-content: center;
				align-items: center;
				position: relative;
				image{
					width: 100%;
					height: 100%;
				}
				.prize-text{
					width: 80%;
					height: auto;
					display: flex;
					justify-content: center;
					align-items: center;
					text-align: center;
					font-size: 32rpx;
					font-weight: 600;
					color: #3c0e12;
					position: absolute;
					top: 35%;
				}
				.prize-time{
					width: 80%;
					height: auto;
					display: flex;
					justify-content: center;
					align-items: center;
					text-align: center;
					font-size: 26rpx;
					color: #3c0e12;
					position: absolute;
					top: 55%;
				}
				.close-btn{
					width: 80%;
					height: 90rpx;
					position: absolute;
					background: red;
					bottom: 50rpx;
					border-radius: 50rpx;
					opacity: 0;
				}
			}
			.fw-box{
				width: 600rpx;
				height: 600rpx;
				background-color: $u-primary;
				padding: 40rpx 0;
				border-radius: 10rpx;
				display: flex;
				justify-content: center;
				align-items: center;
				flex-direction: column;
				color: white;
				.is_true{
					width: 100%;
					height: auto;
					padding: 10rpx 0;
					display: flex;
					justify-content: center;
					align-items: center;
					font-size: 20px;
				}
				.fw_code{
					width: 100%;
					height: auto;
					padding: 10rpx 0;
					display: flex;
					justify-content: center;
					align-items: center;
					font-size: 28rpx;
				}
				.fw_res{
					width: 90%;
					min-height: 100rpx;
					display: flex;
					justify-content: flex-start;
					align-items: center;
					font-size: 24rpx;
					line-height: 36rpx;
					padding: 10rpx;
					box-sizing: border-box;
					border-radius: 4rpx;
					margin-top: 20rpx;
					background: rgba($color: #000000, $alpha:.3);
				}
				.fw-btn{
					width: 300rpx;
					height: 80rpx;
					background: white;
					border-radius: 40rpx;
					display: flex;
					justify-content: center;
					align-items: center;
					color: red;
					font-size: 28rpx;
					margin-top: 40rpx;
				}
			}
		}
		.page_box{
			width: 100%;
			height: 100vh;
			overflow: hidden;
			position: relative;
			.rule{
				width: 100%;
				height: auto;
				display: flex;
				justify-content: center;
				align-items: center;
				font-size: 26rpx;
				position: absolute;
				bottom: 20rpx;
				color: #3c0e12;
				z-index: 1000;
				// color: white;
			}
			image{
				width: 100%;
				height: 100%;
			}
			.prize-btn{
				width: 100%;
				height: 300rpx;
				position: absolute;
				bottom: 80rpx;
				background: red;
				opacity: 0;
			}
			.skip{
				width: 80px;
				height: 30px;
				background: gray;
				border-radius: 15px;
				color: white;
				font-size: 13px;
				font-weight: 500;
				display: flex;
				justify-content: center;
				align-items: center;
				position: absolute;
				right: 20px;
				top: 80px;
				z-index: 999;
			}
		}
	}
</style>
