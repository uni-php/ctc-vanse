const getters = {
  token: state => state.user.token,
  userId: state => state.user.userId,
  userInfo: state=> state.user.userInfo,
  storeInfo: state=> state.user.storeInfo,
  platform: state => state.app.platform,
  deptlist: state=>state.user.deptlist
}

export default getters
