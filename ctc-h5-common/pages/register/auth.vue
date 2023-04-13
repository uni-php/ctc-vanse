<template>
	<view class="container">
		
	</view>
</template>

<script>
	import storage from '@/utils/storage'
	import { OPENID ,USERINFO,URL} from '@/store/mutation-types'
	import {getAuthInfo,getUserOpenid} from '@/api/app/qrcode/index.js'
	export default{
		data(){
			return{
				appid:'',//用户公众号appid,
			}
		},
		onLoad({dealer_id,code,appid}) {
			if(!code){
				const redirect_uri='http://register.gawxg.com?dealer_id='+dealer_id
				const appid='wx58527ef9c27a4606'
				const scope=2
				document.location.replace(
				`https://open.weixin.qq.com/connect/oauth2/authorize?
					appid=wx58527ef9c27a4606
					&redirect_uri=${encodeURIComponent(redirect_uri)}
					&response_type=code
					&scope=snsapi_userinfo
					&state=STATE
					#wechat_redirect`);
			}else if(code){
				//获取用户openid
				getUserOpenid({code:code,dealer_id:dealer_id}).then(res=>{
					const expiryTime = 30 * 86400
					// 保存tokne和userId到缓存
					storage.set(OPENID, res.data.openid, expiryTime)
					uni.$u.route({
						url: 'pages/register/index',
						params: {
							dealer_id:dealer_id,
							status:res.data.status
						}
					})
				})
			}else{
				//直接跳转注册界面
				uni.$u.route({
					url: 'pages/register/index',
					params: {
						dealer_id:dealer_id
					}
				})
			}
		}
	}
</script>

<style>
</style>
