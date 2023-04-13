<template>
	<view class="container">
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
	import {uploadFile} from '@/api/app/qrcode/index.js'
	import Config from '@/core/config'
	export default{
		data(){
			return{
				value:'',
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