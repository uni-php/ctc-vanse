<template>
	<view class="container">
		
	</view>
</template>

<script>
	import storage from '@/utils/storage'
	import { OPENID ,USERINFO,URL} from '@/store/mutation-types'
	import {getAuthInfo,getUserInfo,getAuthUserInfo} from '@/api/app/store_shop/index.js'
	 import store from '@/store'
	export default{
		data(){
			return{
				appid:'',//用户公众号appid,
			}
		},
		onLoad({dealer_id,store_id,code,appid}) {
			if(!code){
				//获取用户信息
				getAuthInfo({dealer_id:dealer_id}).then(res=>{
					//跳转授权页面
					const redirect_uri='http://jifen.uni-2id.com/store_shop/?dealer_id='+dealer_id+'&store_id='+store_id
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
				getAuthUserInfo({code:code,appid:appid,dealer_id:dealer_id}).then(res=>{
					const expiryTime = 30 * 86400
					// 保存tokne和userId到缓存
					const url='http://jifen.uni-2id.com/store_shop/?dealer_id='+dealer_id+'&store_id='+store_id+'&code='+code+'&state=STATE'+'&appid='+appid
					storage.set('url', url, expiryTime)
					storage.set(OPENID, res.data.openid, expiryTime)
					storage.set(USERINFO, res.data, expiryTime)
					console.log(55)
					uni.$u.route({
						url: 'pages/store_shop/index',
						type:'redirect',
						params: {
							dealer_id:dealer_id,
							store_id:store_id
						}
					})
					//缓存用户信息
				})
			}else{
				uni.$u.route({
					url: 'pages/store_shop/index',
					params: {
						dealer_id:dealer_id,
						store_id:store_id
					}
				})
			}
		},
		onShow() {
			
		},
		methods:{
			
		}
	}
</script>

<style>
</style>