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
			const openid=storage.get(OPENID)
			if(!openid&&!code){
				//获取授权信息
				getAuthInfo({dealer_id:dealer_id}).then(res=>{
					const redirect_uri='http://register.uni-2id.com?dealer_id='+dealer_id
					const component_appid='wxb69be9ce11dbfbb6'
					const scope=2
					document.location.replace(
					`https://open.weixin.qq.com/connect/oauth2/authorize?
						appid=${res.data.authorizer_appid}
						&redirect_uri=${encodeURIComponent(redirect_uri)}
						&response_type=code
						&scope=snsapi_base
						&state=STATE
						&component_appid=${component_appid}#wechat_redirect`);
				})
			}else if(!openid&&code){
				//获取用户openid
				getUserOpenid({code:code,appid:appid,dealer_id:dealer_id}).then(res=>{
					const expiryTime = 30 * 86400
					// 保存tokne和userId到缓存
					storage.set(OPENID, res.data.openid, expiryTime)
					uni.$u.route({
						url: 'pages/register/index',
						params: {
							dealer_id:dealer_id
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
