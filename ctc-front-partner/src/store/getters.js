const getters = {
  sidebar: state => state.app.sidebar,
  device: state => state.app.device,
  token: state => state.user.token,
  roles: state => state.user.roles,
  permissions: state => state.user.permissions,
  permission_routes:state=>state.permission.routes,
  permission_addRouters:state=>state.permission.addRouters,
  avatar: state => state.user.avatar,
  name: state => state.user.name,
  account:state=>state.user.account,
  user_info:state=>state.user.userInfo
}
export default getters
