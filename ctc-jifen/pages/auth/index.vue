<template>
	<view class="container">
		
	</view>
</template>

<script>
	import storage from '@/utils/storage'
	import { OPENID ,USERINFO,URL} from '@/store/mutation-types'
	import {getAuthInfo,getUserInfo} from '@/api/app/points/index.js'
	 import store from '@/store'
	export default{
		data(){
			return{
				appid:'',//用户公众号appid,
			}
		},
		onLoad({dealer_id,code,appid}) {
			if(!code){
				const redirect_uri='https://www.gawxg.com/jifen/?dealer_id='+dealer_id
				const component_appid='wx58527ef9c27a4606'
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
				const expiryTime = 30 * 86400
				const url='https://www.gawxg.com/jifen/?dealer_id='+ dealer_id +'&code='+code+'&state=STATE'+'&appid='+appid
				storage.set('url', url, expiryTime)
				 store.dispatch('getUserInfo',{code:code,appid:appid,dealer_id:dealer_id}).then(res=>{
					 uni.$u.route({
					 	url: 'pages/index/index',
						type:'switchTab',
					 	params: {
					 		dealer_id:dealer_id
					 	}
					 })
				 })
				 .catch(err => {
					 uni.$u.toast(res.message)
				 })
				// getUserInfo({code:code,appid:appid,dealer_id:dealer_id}).then(res=>{
				// 	const expiryTime = 30 * 86400
				// 	// 保存tokne和userId到缓存
				// 	storage.set(OPENID, res.data.openid, expiryTime)
				// 	storage.set(USERINFO, res.data, expiryTime)
				// 	//vuex存储用户信息
				// 	uni.$u.route({
				// 		url: 'pages/index/index',
				// 		params: {
				// 			dealer_id:dealer_id
				// 		}
				// 	})
				// 	//缓存用户信息
				// })
			}else{
				uni.$u.route({
					url: 'pages/index/index',
					params: {
						dealer_id:dealer_id
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