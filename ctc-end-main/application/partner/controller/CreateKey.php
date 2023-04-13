<?php
/**
 * Created by PhpStorm.
 * Role: wenhan
 * Date: 2021/7/19
 * Time: 上午9:10
 * 秘钥对生成  一般思路
 * 1、给定RSA所要求N的位数n，选择一个大于65537的公钥e。
 * 2、随机选择一个长度为(n + 1) / 2的质数。如果(n + 1) / 2小于95，则用smallPrime函数选取，否则用largePrime函数选取。
 * 3、选择一个长度为n - (n + 1) / 2 = (n - 1) / 2的质数q，如果(n - 1) / 2小于95，则用smallPrime函数选取，否则用largePrime函数选取*4、求|p-q|，如果差值位数过小，则回到2，重新选取p。
 * 5、计算N = pq，判断N的位数是否确实为n，如果不是，则回到2，重新选取p。
 * 6、计算N的NAF权重，如果过小，则回到2，重新选取p。
 * 7、求e在Z_N群下的逆元d，如果d过小，则回到2，重新选取p。
 * 8、返回RSA的参数p、q、e、d等。
 */

namespace app\partner\controller;
use think\Controller;
use think\Request;
use think\Log;
use think\Db;


class CreateKey extends Controller
{
    /**
     * @param $n
     * @return array
     *
     */
    public function generateEPQ($n){
        $result=null;
        $number=9;
        for($i=0;$i<$n-1;$i++){
            $number.='0';
        }
        $strength=strlen($this->bc_convert2bin($number));//秘钥二进制位数
        $p_bitlength=intval(($strength+1)/2);//质数p的位数
        $q_bitlength=$strength-$p_bitlength;//质数q的位数
        $p=$q=0;
        //1、第一步选取符合位数的大质数pq
        do{
            $p=$this->chooseRandomPrime($p_bitlength);
            $q=$this->chooseRandomPrime($q_bitlength);
        }while($p==$q||strlen(bcmul($p,$q))!=$n);
        //第二步 选取e 条件如下
        //选取e ①e与fn互质 ②e为大于p与q的素数 ③e尽量大 e与fn位数相同
        $fn=bcmul($p-1,$q-1);
        $fn_bit=strlen($this->bc_convert2bin($fn));//fn位数
        $e_min=1;
        for($i=0;$i<$fn_bit-1;$i++){
            $e_min.='0';
        }
        $max_dec=$fn-1;
        $min_dec=$this->bin_convert2dec($e_min);
        $random_e=$min_dec;
        do{
            $random_e=mt_rand($min_dec,$max_dec);
        }while($this->gcd($random_e,$fn)!=1);
        //第三步 求取模反元素d 条件=>e*d ≡ 1 (mod fn)=>e*d - 1 = k*fn
        //保证$x为正数
//        $res=$this->gcdEx($random_e, $fn, $x, $y);
        $res=[
            'N'=>bcmul($p,$q),
            'P'=>$p,
            'Q'=>$q,
            'FN'=>$fn,
            'E'=>$random_e,
//            'D'=>$x,
//            'code'=>200
        ];
        return $res;
    }

    //第三步 求取模反元素d 条件=>e*d ≡ 1 (mod fn)=>e*d - 1 = k*fn
    public function generateKeyPair(Request $request){
        $n=$request->param('length');//秘钥位数
        $x;
        $y;
        if(!$n){
            $res=[
                'msg'=>'请输入秘钥长度',
                'code'=>201
            ];
            return json($res);
        }
        if($n<10||$n>20){
            $res=[
                'msg'=>'秘钥长度应在10~20之间',
                'code'=>201
            ];
            return json($res);
        }
        do{
            $en=$this->generateEPQ($n);
            $res=$this->gcdEx($en['E'], $en['FN'], $x, $y);
        }while($x<=0);
        $res=[
            'N'=>bcmul($en['P'],$en['Q']),
            'P'=>$en['P'],
            'Q'=>$en['Q'],
            'FN'=>$en['FN'],
            'E'=>$en['E'],
            'D'=>$x,
            'code'=>200
        ];
        return json($res);
    }

    //扩展欧几里得算法求逆元d ax+by=gcd(a,b) 这里gcd(a,b)=1
    public function gcdEx($a, $b, &$x, &$y){
        //引入日志
//        Log::init([
//            'type'  =>  'File',
//            'path'  =>  LOG_PATH.'RSALogs/',
//            'max_files'	=> 5
//        ]);
        if($b == 0)
        {
            $x = 1;
            $y = 0;
            return $a;
        }
        $info= 'exgcd() paras $b ='.$b.', $a%$b = '.$a%$b.', $x = '.$x.', $y = '.$y.'<br />';
//        echo $info;
//        Log::write($info,'notice');
        $r = $this->gcdEx($b, $a%$b, $x, $y);
        $info='--exgcd() paras $b ='.$b.', $a%$b = '.$a%$b.', $x = '.$x.', $y = '.$y.'<br />';
//        echo $info;
//        Log::write($info,'notice');
        $t = $x;
        $x = $y;
        $y = $t - floor($a/$b)*$y;
        return $r;
    }
    //判断两数目是否互质  辗转相除法
    public function gcd($a,$b){
        if($b==0){
            return $a;
        }else{
            return $this->gcd($b,bcmod($a,$b));
        }
    }
    //选取固定位数的随机素数
    public function chooseRandomPrime($len){
        $max=$min=1;
        for($i=0;$i<$len-1;$i++){
            $max.='1';
            $min.='0';
        }
        $max_dec=$this->bin_convert2dec($max);
        $min_dec=$this->bin_convert2dec($min);
        $random=$min_dec;
        do{
            $random=mt_rand($min_dec,$max_dec);
        }while(!$this->primeToCertainty($random));
        return $random;
    }
    //素数判定
    public function primeToCertainty($num){
        set_time_limit(0);
        $cut=bcsqrt($num);
        for ($i=2;$i<$num;$i++){
            if(bcmod($num,$i) == 0)
            {
                return false;
                break;
            }
            if($i >= $cut*1)
            {
                return true;
                break;
            }
        }
    }
    //将十进制转二进制
    public function bc_convert2bin($number){
        $r='';
        while ($number){
            $k=0;
            $m='';
            do{
                $k=$k*10 + substr($number,0,1);
                if ($m!='' || $k>1) $m.=floor($k/2);
                $k=$k % 2;
                $number=substr($number,1);
            }while($number!='');
            $number=$m;
            $r=$k . $r;
        }
        return $r;
    }
    //二进制转十进制
    public function bin_convert2dec($str){
        $num=0;
        $bin_str=array_reverse(str_split($str));
        for($i=0;$i<strlen($str);$i++){
            $num=bcadd($num,bcmul($bin_str[$i],bcpow(2,$i)));
        }
        return $num;
    }

}