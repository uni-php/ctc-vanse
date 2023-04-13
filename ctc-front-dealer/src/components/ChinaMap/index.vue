<template>
    <div class="echartsLine" ref="myEchart"></div>
</template>
<script>
import * as echarts from 'echarts';
//   import '../../node_modules/echarts/map/js/world.js'
import '@/components/ChinaMap/china' // 引入中国地图数据
export default {
  name: 'echarts',
  props: ['userJson'],
  data () {
    return {
      chart: null
    }
  },
  // 实时监听父组件传过来的值，进而执行drawBar方法，重绘柱状图
  watch: {
    userJson: {
      handler (value) {
        this.chinaConfigure(value)
      },
      deep: true
    }
  },
  mounted () {
    this.chinaConfigure()
  },
  beforeDestroy () {
    if (!this.chart) {
      return
    }
    this.chart.dispose()
    this.chart = null
  },
  methods: {
    chinaConfigure () {
      console.log(this.userJson)
      let myChart = echarts.init(this.$refs.myEchart) // 这里是为了获得容器所在位置
      window.onresize = myChart.resize
      myChart.setOption({ // 进行相关配置
        backgroundColor: '#ffffff',
        tooltip: {
          triggerOn: "mousemove",   //mousemove、click
          padding:8,
          borderWidth:1,
          borderColor:'#409eff',
          backgroundColor:'rgba(255,255,255,0.7)',
          textStyle:{
            color:'#000000',
            fontSize:13
          },
        },
        toolbox: {
            show: true,
            feature: {
            dataView: {
                readOnly: false
            },
            restore: {},
            saveAsImage: {}
            }
        },
        visualMap: {
          min: 0,
          max: 14,
          left: 'right',
          top: 'bottom',
          text: ['14', '0'],
          inRange: {
            color: ['#FAFAFA', '#8CAAF7']
          },
          show: true
        },
        geo: { // 这个是重点配置区
          map: 'china', // 表示中国地图
          roam: false,//禁止缩放
          label: {
            normal: {
              show: true, // 是否显示对应地名
              textStyle: {
                color: 'rgba(0,0,0,0.4)'
              }
            }
          },
          itemStyle: {
            normal: {
              borderColor: 'rgba(0, 0, 0, 0.3)'
            },
            emphasis: {
              areaColor: '#A89DFE',
              shadowOffsetX: 0,
              shadowOffsetY: 0,
              shadowBlur: 0,
              borderWidth: 0,
              shadowColor: null
            }
          }
        },
        series: [{
          type: 'scatter',
          coordinateSystem: 'geo' // 对应上方配置
        },
        {
          name: '用户分布', // 浮动框的标题
          type: 'map',
          geoIndex: 0,
          data: this.formatterData(this.userJson)
        }
        ]
      })
    },
    formatterData (province) {
      const Allprovince = ['南海诸岛', '北京', '天津', '上海', '重庆', '河北', '河南', '云南', '辽宁', '黑龙江', '湖南', '安徽', '山东', '新疆', '江苏', '浙江', '江西', '湖北', '广西', '甘肃', '山西', '内蒙古', '陕西', '吉林', '福建', '贵州', '广东', '青海', '西藏', '四川', '宁夏', '海南', '台湾', '香港', '澳门']
      const newProvince = []
      Allprovince.forEach((item, index) => {
        newProvince.push({ value: 0, name: item })
        province.forEach(itemProvince => {
          if (itemProvince.name === item) {
            newProvince[index] = { value: itemProvince.value, name: item }
          }
        })
      })
      return newProvince
    }
  }
}
</script>
<style lang="scss" scoped>
.echartsLine{
    height: calc(100vh - 160px);
    width:100%;
}
</style>

