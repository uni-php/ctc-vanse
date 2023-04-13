<template>
    <div class="pie" :id="id"></div>
</template>
<script>
import * as echarts from 'echarts';
export default {
    props:{
        id:{
            type:String,
            required:true
        },
        dataList:{
            type:Array,
            required:false
        },
        radius:{
            type:Number,
            required:false,
            default:50
        }
    },
    data(){
        return{
            echarts:''
        }
    },
    mounted(){
        this.initCharts();
    },
    destroy(){
        if (this.echarts) {        
            this.echarts.dispose();   
            this.echarts = null;
        }
    },
    methods:{
        initCharts(){
            // debugger;
            this.echarts=echarts.init(document.getElementById(this.id));
            var option={
                title:{
                    text:'',
                    x:'center',
                },
                tooltip:{
                    trigger:'item',
                    formatter:'{a}<br>{b}:{c}({d}%)'
                },
                series:[
                    {
                        type:'pie',
                        radius:this.radius+'%',
                        center:['50%','50%'],
                        data:this.dataList,
                        itemStyle:{
                            emphasis:{
                                shadowBlur:10,
                                shadowOffsetX:0,
                                shadowColor:'rgba(0,0,0,1)'
                            }
                        },
                        label: {
                            normal: {
                                formatter: '{b}:{d}%',
                                fontSize: 16,
                                color: '#000',                               
                            }
                        }
                    }
                ]
            }
            this.echarts.setOption(option);
        }
    }
}
</script>
<style lang="scss" scoped>
.pie{
    width: 100%;
    height: 400px;
}
</style>
