<template>
    <div ref="id" class="echartsLine" :id="id"></div>
</template>
<script>
import * as echarts from 'echarts';
export default {
    name:'echartsLine',
    props:{
       id:{
           type:String,
           required:true
        },
        type:{
            type:Array,
            required:false,
            default:function(){
                return  ['bar','line'] 
            }                                                          
        },
        xData:{
            type:Array,
            required:true
        },
        max:{
            type:Number,
            required:false,
            default:200
        },
        min:{
            type:Number,
            required:false,
            default:10
        },
        dataList:{
            type:Array,
            required:true
        },
        seriesType:{
            type:String,
            required:true
        }
    },
    data(){
        return{         
           echarts:'' 
        }
    },
    mounted(){
      this.initEchartsLine();
    }, 
    methods:{
        initEchartsLine(){
            this.echarts=echarts.init(document.getElementById(this.id));
            var option={
                title:{
                    text:'',
                    textStyle:{
                        fontWeight:400,
                        fontSize:'20px'
                    }
                },
                //提示框组件
                tooptip:{
                    show:true,
                    trigger:'axis'
                },
                //工具栏
                toolbox:{
                    show:false,
                    feature:{
                        magicType:{
                            show:true,
                            type:this.type
                        }
                    },
                    right:'6%'
                },
                //横坐标
                xAxis:{
                    type:'category',
                    data:this.xData,
                    boundaryGap: true,
                    axisLine:{
                        lineStyle:{
                            type:'solid',
                            color:'#333',
                            width:'1'
                        }
                    },
                    axisTick:{
                        show:true,
                        alignWithLabel:true
                    },
                    axisLabel:{
                        textStyle:{
                            color:'#333'
                        }
                    }
                },
                //纵坐标
                yAxis:{
                    // name:'',
                    // max:this.max,
                    // type:'value',
                    // axisLine:{
                    //     show:false
                    // },
                    // axisTick:{
                    //     show:true
                    // },
                    // axisLabel:{
                    //     textStyle:{
                    //         color:'#333'
                    //     }
                    // },
                    // minInterval:this.min,
                    // splitLine:{
                    //     lineStyle:{
                    //         color:'#f6f6f6'
                    //     }
                    // }
                },
                series:[{
                    name:'',
                    type:this.seriesType,
                    data:this.dataList,
                    areaStyle: {
                        color:{
                            type: 'linear',
                            x: 0,
                            y: 0,
                            x2: 1,
                            y2: 0,
                            colorStops: [{
                                offset: 0, color: '#91dda4' // 0% 处的颜色
                            }, {
                                offset: 1, color: '#84c3e4' // 100% 处的颜色
                            }],
                            global: false // 缺省为 false
                        }
                    },//面积显示
                    showBackground: true,
                    backgroundStyle: {
                        color: 'rgba(180, 180, 180, 0.2)'
                    },
                    itemStyle:{
                        normal:{
                            color: "#86bdf1",
                            label:{
                                show:true,
                                position:'top',
                                textStyle:{
                                    color: '#333',
                                    fontSize:14,
                                    fontWeight:500
                                }
                            }
                        }
                    },
                    smooth: true,
                    barWidth:35
                }]
            }
            this.echarts.setOption(option);
        }
    }
}
</script>
<style lang="scss" scoped>
.echartsLine{
    height: 400px;
    width:100%;
}
</style>

