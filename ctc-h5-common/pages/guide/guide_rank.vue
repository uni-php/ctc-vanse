<template>
	<view class="container">
		<view class="u-demo-block__content">
			<u-subsection
				:list="list"
				mode="subsection"
				:current="current"
				@change="handleChangeSub"
			></u-subsection>
		</view>
		<view class="u-demo-block__content">
			<u-tabs :list="nav_list"  @change="changeTab" :current="current_tab" lineColor="#fa3534" :scrollable="false">
			</u-tabs>
		</view>
		<view class="rank-box">
			<view class="rank-item" v-for="(item,index) in listData" :key="index">
				<u--image style="margin-left: 10px;" v-if="index<=2" :showLoading="true" :src="rank_icon(index)" width="30px" height="30px"></u--image>
				<u-avatar style="margin: 0 10px;" :src="item.headimgurl" shape="circle" size="45"></u-avatar>
				<u--text :text="item.name" size="13"></u--text>
				<view class="order">
					{{index+1}}
				</view>
			</view>
		</view>
	</view>
</template>

<script>
	import {getRankList,getGuideGroupInfo} from '@/api/app/guide/index.js'
	import storage from '@/utils/storage'
	import { DEALERID,OPENID,USERINFO } from '@/store/mutation-types'
	export default{
		data(){
			return{
				rank1:require('@/static/rank1.png'),
				rank2:require('@/static/rank2.png'),
				rank3:require('@/static/rank3.png'),
				headimg:'https://cdn.uviewui.com/uview/album/1.jpg',
				list: [
					{
						id:1,
						key:'prize',
						name:'扫码领奖排行榜'
					},
					{
						id:2,
						key:'red',
						name:'红包排行榜'
					}
				],
				current:0,
				dealer_id:'',
				current_tab:0,
				current_tab_name:'',
				listData:[],
				rankRule:{},
				nav_list:[
					{
						name:'本周排行',
						key:'week',
						index:1
					},
					{
						name:'本月排行',
						key:'month',
						index:2
					},
					{
						name:'本年排行',
						key:'year',
						index:3
					},
					{
						name:'累计排行',
						key:'sum',
						index:4
					}
				]
			}
		},
		onLoad({dealer_id}) {
			this.dealer_id=dealer_id
		},
		async onShow() {
			await this.getGuideGroupInfo()
			this.getRankList()
		},
		methods:{
			rank_icon(index){
				if(index==0) return this.rank1
				if(index==1) return this.rank2
				if(index==2) return this.rank3
			},
			handleChangeSub(index){
				const nav_list = [
					{
						name:'本周排行',
						key:'week',
						index:1
					},
					{
						name:'本月排行',
						key:'month',
						index:2
					},
					{
						name:'本年排行',
						key:'year',
						index:3
					},
					{
						name:'累计排行',
						key:'sum',
						index:4
					}
				]
				this.current=index
				if(this.list[index].id==1){
					this.nav_list=nav_list.filter(item=>this.rankRule.prize_rank_time.includes(item.index))
				}else{
					this.nav_list=nav_list.filter(item=>this.rankRule.red_rank_time.includes(item.index))
				}
				this.current_tab=0
				this.getRankList()
			},
			getGuideGroupInfo(){
				const params={
					openid:storage.get(OPENID),
					dealer_id:this.dealer_id
				}
				return getGuideGroupInfo(params).then(res=>{
					const list = JSON.parse(JSON.stringify(this.list))
					const nav_list = JSON.parse(JSON.stringify(this.nav_list))
					this.rankRule=res.data 
					this.list=list.filter((item)=>res.data.rank_type.includes(item.id))		 
					// this.current_name=res.data.rank_type[0]==1?'prize':'red'
					if(res.data.rank_type[0]==1){
						this.nav_list=nav_list.filter(item=>res.data.prize_rank_time.includes(item.index))
					}else{
						this.nav_list=nav_list.filter(item=>res.data.red_rank_time.includes(item.index))
					}
					this.current_tab_name=this.nav_list[0].key
				})
			},
			getRankList(){
				const params={
					dealer_id:this.dealer_id,
					openid:storage.get(OPENID),
					current_tab_name:this.current_tab_name,
					current_name:this.list[this.current].key,
					limit:this.current_name=='prize'?this.rankRule.prize_rank_num:this.rankRule.red_rank_num
				}
				getRankList(params).then(res=>{
					this.listData=res.data
				})
			},
			changeTab(val){
				this.current_tab=val.index
				this.current_tab_name=val.key
				this.listData=[]
				this.getRankList()
			}
		}
	}
</script>

<style lang="scss" scoped>
	page{
		background: #eeeeee;
	}
	.container{
		background: white;
		padding: 0 20rpx;
		width: 100%;
		position: relative;
		box-sizing: border-box;
		background: #eeeeee;
		.rank-box{
			width: 100%;
			height: auto;
			display: flex;
			justify-content: center;
			align-items: center;
			flex-direction: column;
			background: white;
			border-radius: 10rpx;
			.rank-item{
				width: 100%;
				height: 160rpx;
				display: flex;
				justify-content: center;
				align-items: center;
				border-bottom: 1px solid #eeeeee;
				position: relative;
				.order{
					position: absolute;
					right: 40rpx;
					font-size: 28rpx;
					font-weight: 600;
					color: $uni-text-color-active;
				}
			}
		}
	}
</style>