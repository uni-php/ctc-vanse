<template>
  <div class="login-container">
    <!-- <div class="main-left">
      <h1 class="title">云追溯数据平台1.0</h1>
      <div class="img-container">
        <img :src="img">
      </div>
    </div>

    <div class="main-right"></div> -->
    <el-form ref="loginForm" :model="loginForm" :rules="loginRules" class="login-form" auto-complete="on" label-position="left">
      <div class="login-title">
        <img class="logo-title" :src="logo">
        物元码
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
      © 2022-present <a href="#" target="_blank" style="color:white;">宜宾伟星管</a>
      <span style="margin:0 4px">版权所有</span> <a href="https://beian.miit.gov.cn/" target="_blank" style="color:white;">冀ICP备15002719号-8</a>
    </div>
  </div>
</template>

<script>
import { validUsername } from '@/utils/validate'
import axios from "axios";
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
      urls:'https://serp.mingya.com.cn/customer-1.0/userresource/bigfile01/records/202101270402116716.wav',
      url:'/customer-1.0/userresource/bigfile01/records/202101270402116716.wav',
      loginForm: {
        account: '',
        password: ''
      },
      img:require('@/assets/login-left.png'),
      logo:require('@/assets/logo.png'),
      loginRules: {
        // account: [{ required: true, trigger: 'blur', validator: validateUsername }],
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
     down(){
      // let url=this.url
      // let link = document.createElement('a')
      // //这里是将url转成blob地址，
      // fetch(url).then(res => res.blob()).then(blob => { // 将链接地址字符内容转变成blob地址
      //   link.href = URL.createObjectURL(blob)
      //   link.download = 'a.mp3'
      //   // link.setAttribute('download', 'out.mp3');
      //   console.log(link)
      //   document.body.appendChild(link)
      //   link.click()
      // })
      axios({
      method: "get",
      url: this.url
      // 这里可以在header中加一些东西，比如token
    })
      .then(res => {
        console.log("response: ", res);
        // new Blob([data])用来创建URL的file对象或者blob对象
        let url = window.URL.createObjectURL(new Blob([res.data]));
        // 生成一个a标签
        let link = document.createElement("a");
        link.style.display = "none";
        link.href = url;
        // 生成时间戳
        let timestamp=new Date().getTime();
        link.download = '';
        document.body.appendChild(link);
        link.click();
      })
      .catch(error => {
        console.log("response: ", error);
      });
    },
    handleLogin() {
      // this.down()
      // return;
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
  background: url("../../assets/bg-smooth.png");
  background-size:100% 100%;
  position:fixed;
  display: flex;
  justify-content: space-between;
  overflow: hidden;
  .main-left{
    width: 40%;
    min-height: 100vh;
    background-size: cover;
    background-image: url("../../assets/login-left-bk.png");
    background-position: center;
    background-repeat: no-repeat;
    padding-top: 14vh;
    .title{
      font-size: 36px;
      font-weight: 600;
      color: #FFFFFF;
      text-align: center;
      line-height: 50px;
      margin-top: 0;
    }
    .img-container{
      padding: 0 22%;
      margin: 6vh 0;
      img{
        width: 100%;
      }
    }
  }
  .main-right{
    width: 60%;
    min-height: 100vh;
    // background: blue;
    background: rgb(0, 47, 167);
  }

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
    color: #eee;
    // background: #444;
    // background: rgba(0,0,0,0.2);
    padding: 10px;
  }
}
</style>
