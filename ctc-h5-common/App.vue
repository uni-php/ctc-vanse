<script>
	export default {
		onLaunch: function() {
			console.log('App Launch')
		},
		onShow: function() {
			console.log('App Show')
		},
		onHide: function() {
			console.log('App Hide')
		}
	}
</script>

<style lang="scss">
	/* 注意要写在第一行，同时给style标签加入lang="scss"属性 */
	@import "uview-ui/index.scss";
</style>
<style>
  /* 项目基础样式 */
  @import "./app.scss";
  .uni-app--showlayout+uni-tabbar.uni-tabbar-bottom,
  .uni-app--showlayout+uni-tabbar.uni-tabbar-bottom .uni-tabbar,
  .uni-app--showlayout+uni-tabbar.uni-tabbar-top,
  .uni-app--showlayout+uni-tabbar.uni-tabbar-top .uni-tabbar {
    left: var(--window-left);
    right: var(--window-right);
  }
</style>

