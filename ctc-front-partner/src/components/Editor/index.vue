<template>
  <div>
      <!-- 图片上传辅助 -->
      <el-upload
      class="avatar-uploader quill-img"
      :action="uploadImgUrl"
      name="img"
      :headers="headers"
      :show-file-list="false"
      :before-upload="quillImgBefore"
      :on-success="quillImgSuccess"
      :on-error="uploadError"
      accept=".jpg,.jpeg,.png,.gif"
    />
    <quill-editor
      class="editor ql-editor"
      v-model="content"
      ref="quillEditor"
      @change="onEditorChange($event)"
      @blur="onEditorBlur($event)"
      @focus="onEditorFocus($event)"
      :options="editorOption"
    ></quill-editor>
  </div>
</template>
<script>
import {getToken} from '@/utils/auth'
// 工具栏配置
const toolbarOptions = [
  ["bold", "italic", "underline", "strike"], // toggled buttons
  ["blockquote", "code-block"],

  [{ header: 1 }, { header: 2 }], // custom button values
  [{ list: "ordered" }, { list: "bullet" }],
  [{ script: "sub" }, { script: "super" }], // superscript/subscript
  [{ indent: "-1" }, { indent: "+1" }], // outdent/indent
  [{ direction: "rtl" }], // text direction

  [{ size: ["small", false, "large", "huge"] }], // custom dropdown
  [{ header: [1, 2, 3, 4, 5, 6, false] }],

  [{ color: [] }, { background: [] }], // dropdown with defaults from theme
  [{ font: [] }],
  [{ align: [] }],
  ["link", "image", "video"],
  ["clean"] // remove formatting button
];
import {quillEditor} from 'vue-quill-editor'
import 'quill/dist/quill.core.css'
import 'quill/dist/quill.snow.css'
import 'quill/dist/quill.bubble.css'
export default {
    props:{
        value:{
            type:String
        },
        maxSize:{
            type:Number,
            default:4000//kb
        }
    },
    components:{quillEditor},
    data(){
        return{
            prefix:'http://localhost/static/mainImgs/',
            content: this.value,
            editorOption: {
                placeholder: "编辑内容",
                theme:"snow",
                modules: {
                    toolbar: {
                        container: toolbarOptions,
                        handlers: {
                            image:function(value){
                                if(value){
                                    document.querySelector(".quill-img input").click(); 
                                }else{
                                    this.quill.format("image", false);
                                }
                            }
                        }
                    }
                }
            },
            uploadImgUrl:process.env.VUE_APP_BASE_API + "/partner/demand/uploadImg",
            headers:{
                Authorization: "Bearer " + getToken()
            }
        }
    },
    watch:{
        value:function(){
            this.content=this.value
        }
    },
    methods:{
        onEditorBlur(){

        },
        onEditorFocus(){

        },
        onEditorChange(){
            this.$emit("input",this.content)
        },
        quillImgBefore(file){
            const isLt3M=file.size/1024/1024<3
            if(!isLt3M){
                this.$message.error('图片最大不得超过3M')
                return false
            }
            const isJPG = file.type === "image/jpeg " || "image/png";
            if(isJPG){
                return true
            }else{
                this.$message.error('上传图片只能是 JPG , PNG格式!')
                return false
            }
        },
        quillImgSuccess(res,file){
            let quill = this.$refs.quillEditor.quill
            if(res.code==200){
                let length = quill.getSelection().index;
                var imgUrl=this.prefix+res.url
                quill.insertEmbed(length, 'image', imgUrl)
                quill.setSelection(length + 1)
            }else{
                this.$message.error('图片插入失败')
            }
        },
        uploadError(){
            this.$message.error('图片插入失败')
        }
    }
}
</script>
<style lang='scss' scoped>
.editor {
  line-height: normal !important;
  height: 300px;
  padding: 0;
}
::v-deep .ql-container .ql-snow{
    height: calc(300px - 90px) !important;
}
.quill-img{
    display: none;
}
.ql-snow .ql-tooltip[data-mode="link"]::before {
  content: "请输入链接地址:";
}
.ql-snow .ql-tooltip.ql-editing a.ql-action::after {
  border-right: 0px;
  content: "保存";
  padding-right: 0px;
}

.ql-snow .ql-tooltip[data-mode="video"]::before {
  content: "请输入视频地址:";
}

.ql-snow .ql-picker.ql-size .ql-picker-label::before,
.ql-snow .ql-picker.ql-size .ql-picker-item::before {
  content: "14px";
}
.ql-snow .ql-picker.ql-size .ql-picker-label[data-value="small"]::before,
.ql-snow .ql-picker.ql-size .ql-picker-item[data-value="small"]::before {
  content: "10px";
}
.ql-snow .ql-picker.ql-size .ql-picker-label[data-value="large"]::before,
.ql-snow .ql-picker.ql-size .ql-picker-item[data-value="large"]::before {
  content: "18px";
}
.ql-snow .ql-picker.ql-size .ql-picker-label[data-value="huge"]::before,
.ql-snow .ql-picker.ql-size .ql-picker-item[data-value="huge"]::before {
  content: "32px";
}

.ql-snow .ql-picker.ql-header .ql-picker-label::before,
.ql-snow .ql-picker.ql-header .ql-picker-item::before {
  content: "文本";
}
.ql-snow .ql-picker.ql-header .ql-picker-label[data-value="1"]::before,
.ql-snow .ql-picker.ql-header .ql-picker-item[data-value="1"]::before {
  content: "标题1";
}
.ql-snow .ql-picker.ql-header .ql-picker-label[data-value="2"]::before,
.ql-snow .ql-picker.ql-header .ql-picker-item[data-value="2"]::before {
  content: "标题2";
}
.ql-snow .ql-picker.ql-header .ql-picker-label[data-value="3"]::before,
.ql-snow .ql-picker.ql-header .ql-picker-item[data-value="3"]::before {
  content: "标题3";
}
.ql-snow .ql-picker.ql-header .ql-picker-label[data-value="4"]::before,
.ql-snow .ql-picker.ql-header .ql-picker-item[data-value="4"]::before {
  content: "标题4";
}
.ql-snow .ql-picker.ql-header .ql-picker-label[data-value="5"]::before,
.ql-snow .ql-picker.ql-header .ql-picker-item[data-value="5"]::before {
  content: "标题5";
}
.ql-snow .ql-picker.ql-header .ql-picker-label[data-value="6"]::before,
.ql-snow .ql-picker.ql-header .ql-picker-item[data-value="6"]::before {
  content: "标题6";
}

.ql-snow .ql-picker.ql-font .ql-picker-label::before,
.ql-snow .ql-picker.ql-font .ql-picker-item::before {
  content: "标准字体";
}
.ql-snow .ql-picker.ql-font .ql-picker-label[data-value="serif"]::before,
.ql-snow .ql-picker.ql-font .ql-picker-item[data-value="serif"]::before {
  content: "衬线字体";
}
.ql-snow .ql-picker.ql-font .ql-picker-label[data-value="monospace"]::before,
.ql-snow .ql-picker.ql-font .ql-picker-item[data-value="monospace"]::before {
  content: "等宽字体";
}
</style>
