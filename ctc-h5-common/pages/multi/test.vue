<template>
	<view class="container">
		<u-overlay :show="reg_show" @click="reg_show = false">
			<view class="warp">
				<view class="rule-box">
					<view class="rule-title">{{reg_status==0?'恭喜您，信息登记成功！':'奖励已发放'}}</view>
					<view class="reg-content">
						<u-icon name="checkmark-circle" color="#f0ad4e" size="52px"></u-icon>
						<view class="reg-tips">
							<text>当消费者购买并扫码时,活动奖励会自动发放给您,请注意查收!</text>
						</view>
					</view>
					<view class="reg-btn" @click="reg_show = false">我知道了</view>
				</view>
			</view>	
		</u-overlay>
	</view>
</template>

<script>
	import {uploadFile} from '@/api/app/qrcode/index.js'
	import Config from '@/core/config'
	export default{
		data(){
			return{
				value:'',
				reg_show:true,
				reg_status:0,
				field_show:true,
				name:'',
				fileList:[],
				user_info_field:[
					{
						"id": 5,
						"field_name": "姓名",
						"type": 1,
						"max_length": 12,
						"select_options": "",
						"placeholder": "请输入姓名",
						"order": 1,
						"value":"",
						"prop":'name',
						"status": 1,
						"dealer_id": 24,
						"create_time": "2022-06-08 01:27:36",
						"is_sys_set": 0
					},
					{
						"id": 5,
						"field_name": "姓名",
						"type": 1,
						"max_length": 12,
						"select_options": "",
						"placeholder": "请输入姓名",
						"order": 1,
						"value":"",
						"prop":'name',
						"status": 1,
						"dealer_id": 24,
						"create_time": "2022-06-08 01:27:36",
						"is_sys_set": 0
					},
					{
						"id": 5,
						"field_name": "姓名",
						"type": 1,
						"max_length": 12,
						"select_options": "",
						"placeholder": "请输入姓名",
						"order": 1,
						"value":"",
						"prop":'name',
						"status": 1,
						"dealer_id": 24,
						"create_time": "2022-06-08 01:27:36",
						"is_sys_set": 0
					},
					{
						"id": 5,
						"field_name": "姓名",
						"type": 1,
						"max_length": 12,
						"select_options": "",
						"placeholder": "请输入姓名",
						"order": 1,
						"value":"",
						"prop":'name',
						"status": 1,
						"dealer_id": 24,
						"create_time": "2022-06-08 01:27:36",
						"is_sys_set": 0
					},
					{
						"id": 5,
						"field_name": "姓名",
						"type": 1,
						"max_length": 12,
						"select_options": "",
						"placeholder": "请输入姓名",
						"order": 1,
						"value":"",
						"prop":'name',
						"status": 1,
						"dealer_id": 24,
						"create_time": "2022-06-08 01:27:36",
						"is_sys_set": 0
					},
					{
						"id": 5,
						"field_name": "地址",
						"type": 1,
						"max_length": 12,
						"select_options": "",
						"placeholder": "请输入地址",
						"order": 1,
						"value":"",
						"prop":'name',
						"status": 1,
						"dealer_id": 24,
						"create_time": "2022-06-08 01:27:36",
						"is_sys_set": 0
					},
					{
						"id": 5,
						"field_name": "图片",
						"type": 5,
						"max_length": 12,
						"select_options": "",
						"placeholder": "请选择图片",
						"order": 1,
						"value":"",
						"prop":'image',
						"status": 1,
						"dealer_id": 24,
						"create_time": "2022-06-08 01:27:36",
						"is_sys_set": 0
					}
				
				],
			}
		},
		methods:{
			submitForm(){
				if(this.fileList.length==0) return uni.$u.toast('请上传图片')
				for(var i=0;i<this.user_info_field.length;i++){
					if(this.user_info_field[i]['type']==1){
						if(!this.user_info_field[i]['value']) return uni.$u.toast('请检查必填字段')
					}
					if(this.user_info_field[i]['type']==5){
						this.user_info_field[i]['value']==this.fileList[0]['url']
					}
				}
				console.log(this.user_info_field)
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
					console.log(JSON.parse(result))
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
				.reg-content{
					display: flex;
					align-items: center;
					justify-content: center;
					flex-direction: column;
					width: 100%;
					height: 450rpx;
					padding: 30rpx;
					box-sizing: border-box;
				}
				.reg-btn{
					width: 85%;
					height: 75rpx;
					border-radius: 40rpx;
					margin: 0 auto;
					font-size: 26rpx;
					color: white;
					display: flex;
					justify-content: center;
					align-items: center;
					background: #f29100;
				}
				.reg-tips{
					font-size: 14px;
					margin: 40rpx 0;
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
		}
	}
</style>