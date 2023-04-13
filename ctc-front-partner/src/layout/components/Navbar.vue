<template>
  <div class="navbar">
    <hamburger :is-active="sidebar.opened" class="hamburger-container" @toggleClick="toggleSideBar" />

    <breadcrumb class="breadcrumb-container" />

    <div class="right-menu">
      <!-- <span><i class="el-icon-switch-button" style="margin-right:5px"></i>退出</span> -->
      <el-dropdown class="avatar-container right-menu-item hover-effect" trigger="click">
        <div class="avatar-wrapper">
          <span style="font-size:14px">{{name}}</span>
          <i class="el-icon-arrow-down el-icon--right"></i>
        </div>
        <el-dropdown-menu slot="dropdown">
          <el-dropdown-item @click.native="pwdDialog = true">
            <span>更改密码</span>
          </el-dropdown-item>
          <el-dropdown-item divided @click.native="logout">
            <span>退出登录</span>
          </el-dropdown-item>
        </el-dropdown-menu>
      </el-dropdown>
    </div>
    <!-- 更改密码框 -->
    <el-dialog title="更改密码" :visible.sync="pwdDialog" width="40%" @close="pwdDialog=false">
      <el-form :model="form" ref="form" label-width="100px" :rules="rule" size="medium">
        <el-form-item label="当前密码" prop="password">
          <el-input style="width:90%"  v-model="form.password" placeholder="请输入当前密码"/>
        </el-form-item>
         <el-form-item label="新密码" prop="new_pwd">
          <el-input style="width:90%"  v-model="form.new_pwd" placeholder="请输入新密码"/>
        </el-form-item>
         <el-form-item label="确认新密码" prop="new_pwds">
          <el-input style="width:90%"  v-model="form.new_pwds" placeholder="请输入新密码"/>
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button type="primary" @click="submitForm">确 定</el-button>
        <el-button @click="cancel">取 消</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
import { mapGetters } from 'vuex'
import Breadcrumb from '@/components/Breadcrumb'
import Hamburger from '@/components/Hamburger'
import {updatePwd} from '@/api/system'
export default {
  components: {
    Breadcrumb,
    Hamburger
  },
  data(){
    return{
      pwdDialog:false,
      form:{
        password:'',
        new_pwd:'',
        new_pwds:''
      },
      rule:{
        password:[
           { required: true, message: "请输入当前密码", trigger: "blur" }
        ],
        new_pwd:[
          { required: true, message: "请输入新密码", trigger: "blur" }
        ],
        new_pwds:[
          { required: true, message: "请输入新密码", trigger: "blur" }
        ]
      }
    }
  },
  computed: {
    ...mapGetters([
      'sidebar',
      'avatar',
      'name',
      'account'
    ])
  },
  methods: {
    toggleSideBar() {
      this.$store.dispatch('app/toggleSideBar')
    },
    submitForm(){
      this.$refs["form"].validate(valid => {
        if(valid){
          if(this.form.new_pwd!=this.form.new_pwds){
            this.$message.error('新密码前后输入不一致')
            return
          }
          updatePwd(this.form).then(res=>{
            if(res.code==200){
              this.$message.success(res.msg)
              this.pwdDialog=false
              //重新登陆
              setTimeout(()=>{
                this.$store.dispatch('user/logout').then(() => {
                  this.$router.push(`/login?redirect=${this.$route.fullPath}`)
                })
              },1000)
            }else{
              this.$message.error(res.msg)
            }
          })
        }
      })
    },
    cancel(){
      this.pwdDialog = false;
      this.resetForm("form");
    },
    async logout() {
       this.$confirm('确定注销并退出系统吗？', '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning'
      }).then(() => {
        this.$store.dispatch('user/logout').then(() => {
          this.$router.push(`/login?redirect=${this.$route.fullPath}`)
        })
      }).catch(() => {});
    }
  }
}
</script>

<style lang="scss" scoped>
.navbar {
  height: 50px;
  overflow: hidden;
  position: relative;
  // background: #fff;
  background: #1E9FFF;
  box-shadow: 0 1px 4px rgba(0,21,41,.08);

  .hamburger-container {
    line-height: 46px;
    height: 100%;
    float: left;
    cursor: pointer;
    transition: background .3s;
    -webkit-tap-highlight-color:transparent;

    &:hover {
      background: rgba(0, 0, 0, .025)
    }
  }

  .breadcrumb-container {
    float: left;
  }

  .right-menu {
    float: right;
    height: 100%;
    line-height: 50px;
    cursor: pointer;
    margin-right: 20px;
    &:focus {
      outline: none;
    }

    .right-menu-item {
      display: inline-block;
      padding: 0 8px;
      height: 100%;
      font-size: 18px;
      // color: #5a5e66;
      color: white;
      vertical-align: text-bottom;

      &.hover-effect {
        cursor: pointer;
        transition: background .3s;

        &:hover {
          background: rgba(0, 0, 0, .025)
        }
      }
    }

    .avatar-container {
      margin-right: 30px;
      .avatar-wrapper {
        margin-top: 5px;
        position: relative;

        .user-avatar {
          cursor: pointer;
          width: 40px;
          height: 40px;
          border-radius: 10px;
        }

        .el-icon-caret-bottom {
          cursor: pointer;
          position: absolute;
          right: -20px;
          top: 25px;
          font-size: 12px;
        }
      }
    }
  }
}
</style>
