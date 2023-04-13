<?php
// +----------------------------------------------------------------------
// | ThinkPHP [ WE CAN DO IT JUST THINK ]
// +----------------------------------------------------------------------
// | Copyright (c) 2006~2018 http://thinkphp.cn All rights reserved.
// +----------------------------------------------------------------------
// | Licensed ( http://www.apache.org/licenses/LICENSE-2.0 )
// +----------------------------------------------------------------------
// | Author: liu21st <liu21st@gmail.com>
// +----------------------------------------------------------------------

//Route::get('think', function () {
//    return 'hello,ThinkPHP5!';
//});
//
//Route::get('hello/:name', 'index/hello');
//登录接口
Route::get('login', 'main/Auth/login');
Route::get('logout', 'main/Auth/logout');
Route::rule('main/dict/dictByType','main/Dict/dictByType');
//开放平台接口
Route::get('common/verify', 'common/wxopen/verify');
//授权接口
Route::group('main', function(){
    Route::rule('index/index/:name','main/Index/index');
    Route::rule('index/test','main/Index/test');
    Route::get('auth/getUserInfo', 'main/Auth/getUserInfo');
    Route::rule('auth/route','main/Auth/getRoute');
    Route::rule('dict/list','main/Dict/listType');
    Route::rule('dict/addType','main/Dict/addType');
    Route::rule('dict/deleType','main/Dict/deleType');
    Route::rule('dict/getType','main/Dict/getType');
    Route::rule('dict/dictData','main/Dict/dictData');

    Route::rule('dict/addDictData','main/Dict/addDictData');
    Route::rule('dict/deleDictData','main/Dict/deleDictData');
    Route::rule('dict/getDictData','main/Dict/getDictData');

    Route::rule('menu/getMenu','main/Menu/getMenu');
    Route::rule('menu/addMenu','main/Menu/addMenu');
    Route::rule('menu/getMemuItem','main/Menu/getMemuItem');
    Route::rule('menu/delMenu','main/Menu/delMenu');
    Route::rule('menu/treeselect','main/Menu/treeSelect');
    Route::rule('menu/roleMenuTreeselect','main/Menu/roleMenuTreeselect');

    Route::rule('partnerMenu/getMenu','main/PartnerMenu/getMenu');
    Route::rule('partnerMenu/addMenu','main/PartnerMenu/addMenu');
    Route::rule('partnerMenu/getMemuItem','main/PartnerMenu/getMemuItem');
    Route::rule('partnerMenu/delMenu','main/PartnerMenu/delMenu');
    Route::rule('partnerMenu/treeselect','main/PartnerMenu/treeSelect');
    Route::rule('partnerMenu/roleMenuTreeselect','main/PartnerMenu/roleMenuTreeselect');

    Route::rule('role/list','main/Role/listRole');
    Route::rule('role/addRole','main/Role/addRole');
    Route::rule('role/changeStatus','main/Role/changeStatus');
    Route::rule('role/getRole','main/Role/getRole');
    Route::rule('role/deleRole','main/Role/deleRole');
    Route::rule('user/list','main/User/listUser');
    Route::rule('user/getUser','main/User/getUser');
    Route::rule('user/addUser','main/User/addUser');
    Route::rule('user/deleUser','main/User/deleUser');
    Route::rule('user/changeStatus','main/User/changeStatus');
    Route::rule('user/resetPwd','main/User/resetPwd');

    Route::rule('partner/levelList','main/Partner/getLevelList');
    Route::rule('partner/addLevel','main/Partner/addLevel');
    Route::rule('partner/deleLevel','main/Partner/deleLevel');
    Route::rule('partner/getLevel','main/Partner/getLevelInfo');
    Route::rule('partner/listPartner','main/Partner/getPartnerList');
    Route::rule('partner/addPartner','main/Partner/addPartner');
    Route::rule('partner/getAuthData','main/Partner/getAuthData');
    Route::rule('partner/checkLicense','main/Partner/checkLicense');
    Route::rule('partner/getPartnerInfo','main/Partner/getPartnerInfo');
    Route::rule('partner/resetPartnerPwd','main/Partner/resetPartnerPwd');
    Route::rule('partner/disableAccount','main/Partner/disableAccount');
    Route::rule('partner/delePartner','main/Partner/delePartner');
    Route::rule('partner/uploadImg','main/Partner/uploadImg');//上传七牛云
    Route::rule('partner/uploadImg','main/Partner/uploadImg');

    Route::rule('sms/smsList','main/Sms/getSmsList');
    Route::rule('sms/addSms','main/Sms/addSms','post');
    Route::rule('sms/deleSms','main/Sms/deleSms');
    Route::rule('sms/getSms','main/Sms/getSms');

    Route::rule('module/moduleList','main/Module/getModuleList');
    Route::rule('module/addModule','main/Module/addModule');
    Route::rule('module/deleModule','main/Module/deleModule');
    Route::rule('module/getModule','main/Module/getModule');

    Route::rule('code/codeList','main/Code/getCodeList');
    Route::rule('code/addCode','main/Code/addCode');
    Route::rule('code/deleCode','main/Code/deleCode');
    Route::rule('code/getCode','main/Code/getCode');

    Route::rule('dealer/dealerList','main/Dealer/getDealerList');
    Route::rule('dealer/delDealer','main/Dealer/delDealer');
    Route::rule('dealer/cutDealer','main/Dealer/cutDealer');
    Route::rule('dealer/getDealerInfo','main/Dealer/getDealerInfo');
    Route::rule('dealer/getDealerMoreInfo','main/Dealer/getDealerMoreInfo');
    Route::rule('dealer/rechargeDealer','main/Dealer/rechargeDealer');
    Route::rule('dealer/rechargeLog','main/Dealer/rechargeLog');
    Route::rule('dealer/redPackIssueLog','main/Dealer/redPackIssueLog');
    Route::rule('dealer/getAuthData','main/Dealer/getAuthData');
    Route::rule('dealer/getAuthInfo','main/Dealer/getAuthInfo');
    Route::rule('dealer/updateAuthInfo','main/Dealer/updateAuthInfo');
    Route::rule('dealer/checkTrademark','main/Dealer/checkTrademark');
    Route::rule('dealer/checkLicense','main/Dealer/checkLicense');
    Route::rule('dealer/listAuth','main/Dealer/listAuth');
    Route::rule('dealer/uploadTrademark','main/Dealer/uploadLicense');
    Route::rule('dealer/uploadLicense','main/Dealer/uploadLicense');

    Route::rule('increment/listServide','main/IncrementService/getList');
    Route::rule('increment/saveServide','main/IncrementService/saveServide');
    Route::rule('increment/getServiceOrder','main/IncrementService/getServiceOrder');
    Route::rule('increment/deleOrder','main/IncrementService/deleOrder');
    Route::rule('increment/checkOrder','main/IncrementService/checkOrder');
    Route::rule('increment/orderInfo','main/IncrementService/orderInfo');

    Route::rule('securityCode/listCode','main/SecurityCode/listCode');
    Route::rule('securityCode/listWaitCode','main/SecurityCode/listWaitCode');
    Route::rule('securityCode/deleCode','main/SecurityCode/deleCode');
    Route::rule('securityCode/checkCode','main/SecurityCode/checkCode');
    Route::rule('securityCode/downLoad','main/SecurityCode/downLoad');


    Route::rule('demand/getAllModule','main/Demand/getAllModule');
    Route::rule('demand/getDemands','main/Demand/getDemands');
    Route::rule('demand/checkDemand','main/Demand/checkDemand');
    Route::rule('demand/changeDemandStatus','main/Demand/changeDemandStatus');

    Route::rule('finance/listAccount','main/Finance/listAccount');
    Route::rule('finance/recharge','main/Finance/recharge');
    Route::rule('finance/rechargeLog','main/Finance/rechargeLog');
    Route::rule('finance/allRechargeLog','main/Finance/allRechargeLog');
    Route::rule('finance/listFinanceBill','main/Finance/listFinanceBill');
    Route::rule('finance/cashList','main/Finance/cashList');
    Route::rule('finance/cashPayment','main/Finance/cashPayment');
    Route::rule('finance/cashReject','main/Finance/cashReject');
    Route::rule('finance/getCashRule','main/Finance/getCashRule');
    Route::rule('finance/saveCashRule','main/Finance/saveCashRule');



    Route::rule('log/loginList','main/Log/getLoginList');
    Route::rule('log/operationList','main/Log/operationList');
})->middleware(['auth']);

return [

];
