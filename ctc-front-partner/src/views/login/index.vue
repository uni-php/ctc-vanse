<template>
  <div class="login-container">
    
    <el-form ref="loginForm" :model="loginForm" :rules="loginRules" class="login-form" auto-complete="on" label-position="left">
      <div class="login-title">
       <h4>合伙人管理后台</h4>
      </div>
      <el-form-item label="" style="margin-top:50px;width:80%" prop="account">
        <el-input   v-model="loginForm.account" placeholder="请输入用户名">
          <template slot="prepend">
            <i class="el-icon-user"></i>
          </template>
        </el-input>
      </el-form-item>
      <el-form-item label="" prop="password" style="width:80%;margin-top:25px">
        <el-input  v-model="loginForm.password" show-password placeholder="请输入密码">
          <template slot="prepend">
            <i class="el-icon-lock"></i>
          </template>
        </el-input>
      </el-form-item>
      <el-form-item style="width:80%;margin:25px 0 50px 0">
        <el-button style="width:100%"  @click.native.prevent="handleLogin" type="primary" >登录</el-button>
      </el-form-item>
    </el-form>
    <div class="copy-right">
      © 2021-present <a href="http://www.hlysj.com" target="_blank" style="color:gray;">石家庄市海略科技有限公司</a>
    </div>
  </div>
</template>

<script>
import { validUsername } from '@/utils/validate'
export default {
  name: 'Login',
  data() {
    const validateUsername = (rule, value, callback) => {
      if (!validUsername(value)) {
        callback(new Error('请输入用户名'))
      } else {
        callback()
      }
    }
    const validatePassword = (rule, value, callback) => {
      if (value.length < 6||!value) {
        callback(new Error('请输入6位用户密码'))
      } else {
        callback()
      }
    }
    return {
      loginForm: {
        account: '',
        password: ''
      },
      img:require('@/assets/login-left.png'),
      logo:require('@/assets/logo.png'),
      loginRules: {
        account: [{ required: true, trigger: 'blur', validator: validateUsername }],
        password: [{ required: true, trigger: 'blur', validator: validatePassword }]
      },
      loading: false,
      passwordType: 'password',
      redirect: undefined
    }
  },
  watch: {
    $route: {
      handler: function(route) {
        this.redirect = route.query && route.query.redirect
      },
      immediate: true
    }
  },
  methods: {
    handleLogin() {
      this.$refs.loginForm.validate(valid => {
        if (valid) {
          this.loading = true
          this.$store.dispatch('user/login', this.loginForm).then((data) => {
            if(data.code!=200){
              this.$message.error(data.msg)
            }else{
            this.$router.push({ path: this.redirect || '/' })
            this.loading = false
            }
          }).catch(() => {
            this.loading = false
          })
        } else {
          console.log('error submit!!')
          return false
        }
      })
    }
  }
}
</script>

<style lang="scss" scoped>


.login-container {
  min-height: 100%;
  width: 100%;
  background: url("../../assets/background.jpeg");
  background-size:100% 100%;
  position:fixed;
  display: flex;
  justify-content: space-between;
  overflow: hidden;
  .login-form {
    position: absolute;
    width: 450px;
    max-width: 100%;
    margin: 0 auto;
    right: 10%;
    bottom: 30%;
    display: flex;
    flex-direction: column;
    align-items: center;
    border: 1px solid #eeeeee;
    box-shadow:0 0 6px rgba(81, 81,81,0.4);
    background: white;
    overflow: hidden;
    text-align: center;
    border-radius: 6px;
    .login-title{
      width: 100%;
      height: 80px;
      display: flex;
      justify-content: center;
      align-items: center;
      font-size: 22px;
      font-weight: 500;
      color: #282828;
      border-bottom: 1px solid #eeeeee;
      .logo-title{
        width: 30px;
        height: 30px;
        margin-right:6px;
        img{
          width: 100%;
          height: 100%;
        }
      }
    }
  }
  .copy-right{
    position: absolute;
    bottom: 0px;
    display: flex;
    width: 100%;
    justify-content: center;
    color: gray;
    // background: rgba(0,0,0,0.2);
    padding: 10px;
  }
}
</style>
