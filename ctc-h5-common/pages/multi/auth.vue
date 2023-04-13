<template>
	<view class="container">
		
	</view>
</template>

<script>
	import storage from '@/utils/storage'
	import { OPENID ,USERINFO,URL} from '@/store/mutation-types'
	import {getAuthInfo,getUserInfo,queryCodeByOrder} from '@/api/app/multi/index.js'
	export default{
		data(){
			return{
				appid:'',//用户公众号appid,
			}
		},
		async onLoad({dealer_id,code,order,appid,qrcode,batch}) {
			// const openid=storage.get(OPENID)
			if(!code){
				if(!order){
					//普通消费者扫码
					const redirect_uri='https://www.gawxg.com/multi/?qrcode='+qrcode+'&batch='+batch+'&dealer_id='+dealer_id
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
				}else{
					//获取授权信息
					//导购员扫码 根据序号反查二维码与批次
					const { qrcode, batch} = await queryCodeByOrder(order)
					const redirect_uri='https://www.gawxg.com/multi/?qrcode='+qrcode+'&batch='+batch+'&dealer_id='+dealer_id
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
				}
			}else if(code){
				//拉取用户信息
				getUserInfo({code:code,dealer_id:dealer_id}).then(res=>{
					const expiryTime = 30 * 86400
					// 保存tokne和userId到缓存
					const url='https://www.gawxg.com/multi/?qrcode='+qrcode+'&batch='+batch+'&dealer_id='+dealer_id+'&code='+code+'&state=STATE'
					storage.set('url', url, expiryTime)
					storage.set(OPENID, res.data.openid, expiryTime)
					storage.set(USERINFO, res.data, expiryTime)
					if(res.data.is_guide==1){
						uni.$u.route({
							url: 'pages/multi/dg',
							params: {
								qrcode: qrcode,
								batch:batch,
								dealer_id:dealer_id
							}
						})
					}else{
						uni.$u.route({
							url: 'pages/multi/redpack',
							params: {
								qrcode: qrcode,
								batch:batch,
								dealer_id:dealer_id
							}
						})
					}
					//缓存用户信息
				})
			}else{
				uni.$u.route({
					url: 'pages/multi/middle',
					params: {
						qrcode: qrcode,
						batch:batch,
						dealer_id:dealer_id
					}
				})
			}
		},
		onShow() {
			
		},
		
	}
</script>

<style>
</style>
