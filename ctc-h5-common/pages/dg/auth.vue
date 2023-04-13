<template>
	<view class="container">
		
	</view>
</template>

<script>
	import storage from '@/utils/storage'
	import { OPENID ,USERINFO,URL} from '@/store/mutation-types'
	import {getAuthInfo,getUserOpenid,getUserInfo} from '@/api/app/guide/index.js'
	export default{
		data(){
			return{
				appid:'',//用户公众号appid,
			}
		},
		onLoad({dealer_id,qrcode,code,batch,appid}) {
			// const openid=storage.get(OPENID)
			if(!code){
				//获取授权信息
				getAuthInfo({dealer_id:dealer_id}).then(res=>{
					//跳转授权页面
					const redirect_uri='http://yx.uni-2id.com/dg/?qrcode='+qrcode+'&batch='+batch+'&dealer_id='+dealer_id
					const component_appid='wxb69be9ce11dbfbb6'
					const scope=2
					document.location.replace(
					`https://open.weixin.qq.com/connect/oauth2/authorize?
						appid=${res.data.authorizer_appid}
						&redirect_uri=${encodeURIComponent(redirect_uri)}
						&response_type=code
						&scope=snsapi_userinfo
						&state=STATE
						&component_appid=${component_appid}#wechat_redirect`);
				})
			}else if(code){
				//拉取用户信息
				getUserInfo({code:code,appid:appid,dealer_id:dealer_id}).then(res=>{
					const expiryTime = 30 * 86400
					// 保存tokne和userId到缓存
					const url='http://yx.uni-2id.com/dg/?qrcode='+qrcode+'&batch='+batch+'&dealer_id='+dealer_id+'&code='+code+'&state=STATE'+'&appid='+appid
					storage.set('url', url, expiryTime)
					storage.set(OPENID, res.data.openid, expiryTime)
					storage.set(USERINFO, res.data, expiryTime)
					uni.$u.route({
						url: 'pages/dg/index',
						params: {
							qrcode: qrcode,
							batch:batch,
							dealer_id:dealer_id
						}
					})
					//缓存用户信息
				})
			}else{
				uni.$u.route({
					url: 'pages/dg/index',
					params: {
						qrcode: qrcode,
						batch:batch,
						dealer_id:dealer_id
					}
				})
			}
		},
		onShow() {
			
		}
	}
</script>

<style>
</style>
