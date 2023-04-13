<template>
	<view class="container">
		
	</view>
</template>


<script>
	import storage from '@/utils/storage'
	import { OPENID ,USERINFO,URL} from '@/store/mutation-types'
	import {getAuthInfo,getUserOpenid} from '@/api/app/guide/index.js'
	import store from '@/store'
	export default{
		data(){
			return{
				appid:'',//用户公众号appid,
			}
		},
		onLoad({dealer_id,code,appid}) {
			if(!code){
				const redirect_uri='http://register.gawxg.com/guide?dealer_id='+dealer_id
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
					const url='http://register.gawxg.com/guide/?dealer_id='+dealer_id+'&code='+code+'&state=STATE'
					storage.set('url', url, expiryTime)
					// 保存tokne和userId到缓存
					storage.set(OPENID, res.data.openid, expiryTime)
					storage.set(USERINFO, res.data.userInfo, expiryTime)
					uni.$u.route({
						url: 'pages/guide/index',
						params: {
							dealer_id:dealer_id,
							check_status:res.data.status,
							store_name:res.data?.store_name
						}
					})
				})
			}else{
				//直接跳转注册界面
				uni.$u.route({
					url: 'pages/guide/register',
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