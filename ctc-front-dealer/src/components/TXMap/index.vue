<template>
  <div class="Map">
    <div style="margin-bottom:20px">当前选择坐标为：（精度：{{lat}}  纬度：{{lng}}）</div>
    <div class="search_Map">
      <input type="text" v-model="value" @input="search(value)" />
      <div class="content">
        <p v-for="(i, index) in addressList" :key="index" @click="select(i)">
          {{ i.title }}
          <span class="address">{{ i.address }}</span>
        </p>
      </div>
    </div>
    <div id="container"></div>
  </div>
</template>

<script>
export default {
    name: "TXMap", //腾讯地图
    props: {
        latitude: {
            type: [Number, String],
            required: true,
            default: "",
        },
        longitude: {
            type: [Number, String],
            required: true,
            default: "",
        },  
    },
    data() {
        return {
            value: "", //搜索内容
            addressList: [], //搜索结果
            selectValue: {}, //选择的某个结果
            timeout: null, //搜索定时器
            map: null,
            marker: null,
            lat:'',
            lng:''
        };
    },
    mounted() {
        this.initMap();
    },
    methods:{
         //初始化地图
        initMap() {
            var center = new TMap.LatLng(this.latitude, this.longitude);
            var that=this
            //初始化地图
            this.map = new TMap.Map("container", {
                rotation: 20, //设置地图旋转角度
                pitch: 0, //设置俯仰角度（0~45）
                zoom: 16, //设置地图缩放级别
                center: center, //设置地图中心点坐标
            });
            // 创建信息窗
            let info = new TMap.InfoWindow({
                map:this.map,
                position: this.map.getCenter()
            }).close();
            this.map.on("click",function(evt){
                var lat = evt.latLng.getLat().toFixed(6);
                var lng = evt.latLng.getLng().toFixed(6);
                let poi = evt.poi;
                if(poi){
                    info.setContent(poi.name).setPosition(poi.latLng).open();
                    that.lat=lat
                    that.lng=lng
                    that.$emit("poiClick", lat,lng);
                }else{
                    info.close();
                    that.lat=''
                    that.lng=''
                    that.$message.warning('请重新拾取坐标')
                }
            })
        },
        search(value) {
            this.addressList = [];
            clearTimeout(this.timeout);
            if (value) {
                let that = this;
                this.timeout = setTimeout(() => {
                that
                    .$jsonp("https://apis.map.qq.com/ws/place/v1/suggestion/", {
                    key: "K3PBZ-PSUCD-T3A4R-P5JPH-6MCR2-KYF6K",
                    output: "jsonp",
                    keyword: value,
                    })
                    .then((res) => {
                    console.log(res);
                    if (res.status === 0 && res.data) {
                        that.addressList = res.data;
                    }
                    })
                    .catch((e) => {
                    console.log(e);
                    });
                }, 500);
            }
        },
        //选择对应搜索地址
        select(row) {
            console.log(">>>select:", row);
            this.$emit("addressInfo", row);
            this.selectValue = row.location;
            this.addressList = [];
            let self = this;
            //更新地图中心位置
            self.map.setCenter(
                new TMap.LatLng(this.selectValue.lat, this.selectValue.lng)
            );
            self.lat=this.selectValue.lat
            self.lng=this.selectValue.lng
            //判断是否存在标记点，有的话清空
            if (self.marker) {
                self.marker.setMap(null);
                self.marker = null;
            }
            //初始化marker
            self.marker = new TMap.MultiMarker({
                id: "marker-layer", //图层id
                map: self.map,
                styles: {
                //点标注的相关样式
                marker: new TMap.MarkerStyle({
                    width: 25,
                    height: 35,
                    anchor: { x: 16, y: 32 },
                    src: "https://mapapi.qq.com/web/lbs/javascriptGL/demo/img/markerDefault.png",
                }),
                },
                geometries: [
                {
                    //点标注数据数组
                    id: "demo",
                    styleId: "marker",
                    position: new TMap.LatLng(
                    self.selectValue.lat,
                    self.selectValue.lng
                    ),
                    properties: {
                    title: "marker",
                    },
                },
                ],
            });
        },
    }
}
</script>

<style lang="scss" scoped>
.Map {
  position: relative;
  margin-bottom: 10px;
  .search_Map {
    position: absolute;
    left: 20px;
    top: 40px;
    z-index: 99009;
    input {
      border: 1px solid #f1f1f1;
      display: inline-block;
      width: 400px;
      height: 40px;
      padding: 10px;
      color: #5a5a5a;
      background: rgba(255, 255, 255, 0.904);
    }
    .content {
      width: 400px;
      background: rgba(252, 250, 250, 0.918);
      border: 1px solid #f1f1f1;
      border-top: none;
      font-size: 13px;
      color: #5a5a5a;
      max-height: 350px;
      overflow-y: auto;
      p {
        display: inline-block;
        text-overflow: ellipsis;
        white-space: nowrap;
        overflow: hidden;
        width: 380px;
        border-bottom: 1px solid #f1f1f1;
        padding: 15px 10px;
        margin: 0;
        cursor: pointer;
        &:hover {
          background: #eff6fd;
        }
        .address {
          font-size: 12px;
          color: #b9b9b9;
          margin-left: 20px;
        }
      }
    }
  }
}
#container {
  min-width: 400px;
  width: 100%;
  height: 400px;
}
</style>