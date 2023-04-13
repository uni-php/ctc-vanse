<?php
namespace app\index\controller;
use app\Request;
use think\facade\Env;
use think\Db;
use Ip2Region;
use think\facade\Hook;
use Overtrue\Pinyin\Pinyin;
class Index
{
    public function index()
    {
        return '<style type="text/css">*{ padding: 0; margin: 0; } div{ padding: 4px 48px;} a{color:#2E5CD5;cursor: pointer;text-decoration: none} a:hover{text-decoration:underline; } body{ background: #fff; font-family: "Century Gothic","Microsoft yahei"; color: #333;font-size:18px;} h1{ font-size: 100px; font-weight: normal; margin-bottom: 12px; } p{ line-height: 1.6em; font-size: 42px }</style><div style="padding: 24px 48px;"> <h1>:) </h1><p> ThinkPHP V5.1<br/><span style="font-size:30px">文寒文寒文寒12载初心不改（2006-2018） - 你值得信赖的PHP框架</span></p></div>';
    }

    protected $parent=[];
    protected $child=[];
    public function hello($name = 'ThinkPHP5')
    {
        return 'hello,' . $name;
    }
    private function appendString($str,$len,$append){
        $text=$str;
        if($len==0){
            return $str;
        }
        for($i=0;$i<$len;$i++){
            $text=$append.$text;
        }
        return $text;
    }
    public function test(){
        $pinyin = new Pinyin();
        dump($pinyin->abbr('张三'));
        dump($pinyin->abbr('ab'));
        dump($pinyin->abbr('abc'));
        dump(time());
    }

    /**
     * @param $scale //比例关系[1,12,13]1拖12拖13
     * @param $section//码段区间数列
     * @param $index //查询数码所在上述区间
     * @param $order //查询数码
     * @return array
     * 根据子包装推导外侧包装物流码序号[a,b,c...]abc依次为一二级包装序号 依次类推
     */
    public function getParentCode($scale,$section,$index,$order){
        if($index==0) return $this->parent;
        $start=floor(($order-$section[$index][0])/$scale[$index]);
        array_push($this->parent,$section[$index-1][0]+$start);
        $index--;
        if($index>0){
            $this->getParentCode($scale,$section,$index,$this->parent[count($this->parent)-1]);
        }
    }

    /**
     * @param $scale
     * @param $section
     * @param $index
     * @param $order
     * @return array
     * 查询外包装对应子包装的物流码5=>[[4,6],[44,55]...]元素为首位字段
     */
    public function getChildCode($scale,$section,$index,$order){
        if($index==count($scale)-1) return $this->child;
        $star=($order-$section[$index][0])*$scale[$index+1];
        array_push($this->child,[($star+$section[$index+1][0]),($star+$section[$index+1][0]+$scale[$index+1]-1)]);
        $index++;
        if($index<count($scale)-1){
            $this->getChildCode($scale,$section,$index,$this->child[count($this->child)-1][0]);
            $this->getChildCode($scale,$section,$index,$this->child[count($this->child)-2][1]);
            $this->child=[$this->child[0],array_merge($this->child[count($this->child)-2],$this->child[count($this->child)-1])];
        }
    }
    public function test1(){
        $prize_data=[
            [
                'prize_number'=>10,
                'win_num'=>1
            ],
            [
                'prize_number'=>9,
                'win_num'=>4
            ]
        ];
        $new_prize=array();
        foreach ($prize_data as $key=>$value){
            $new_prize[$key+1]=$value['prize_number']-$value['win_num'];
        }
        if(3-1>0){
            dump(5);
        }
        dump($new_prize);
    }
    public function getPrice(&$priceInfo){
        if (!array_sum($priceInfo)) {
            return 0; //奖池已空
        }
        $randId = rand(1, array_sum($priceInfo)); // 170

        $i = 0;
        foreach ($priceInfo as $id => $num) {
            $i += $num;
            if ($i >= $randId) {
                $priceInfo[$id]--;
                return $id;
            }
        }
    }
    public function red(){
        $priceInfo = [
            '1'  => 3, // 奖品id，奖品数量
            '2'  => 3,
            '3' => 3,
        ];
        // 模拟100次抽奖
        for ($i = 0; $i < 9; $i++) {
            echo "\n 中奖ID: " . $this->getPrice($priceInfo);
        }

//剩余的奖品
        echo "\n 奖池状态：\n";
        print_r($priceInfo);
    }
}

