<?php
/**
 * Created by PhpStorm.
 * Role: wenhan
 * Date: 2021/10/19
 * Time: 下午10:41
 */
//登录接口
Route::get('partner/login', 'partner/Auth/login');
Route::get('partner/logout', 'partner/Auth/logout');

//授权接口
Route::group('partner', function(){
    Route::get('auth/getUserInfo', 'partner/Auth/getUserInfo');
    Route::get('auth/listLevel', 'partner/Auth/listLevel');
    Route::rule('auth/route','partner/Auth/getRoute');
    Route::rule('upload','partner/Upload/uploadImg');//统一上传接口

    Route::rule('system/resetPwd','partner/System/resetPwd');

    Route::rule('securityCode/listCode','partner/SecurityCode/listCode');
    Route::rule('securityCode/getEnableCodes','partner/SecurityCode/getEnableCodes');
    Route::rule('createKey/generateKeyPair','partner/CreateKey/generateKeyPair');
    Route::rule('securityCode/createCodes','partner/SecurityCode/createCode');
    Route::rule('securityCode/saveEnableStatus','partner/SecurityCode/saveEnableStatus');
    Route::rule('securityCode/addEnableLog','partner/SecurityCode/addEnableLog');
    Route::rule('securityCode/deleEnableLog','partner/SecurityCode/deleEnableLog');
    Route::rule('securityCode/getProduct','partner/SecurityCode/getProduct');
    Route::rule('securityCode/getRelProduct','partner/SecurityCode/getRelProduct');
    Route::rule('securityCode/deleRelLog','partner/SecurityCode/deleRelLog');
    Route::rule('securityCode/addRelLog','partner/SecurityCode/addRelLog');
    Route::rule('securityCode/removeProductRel','partner/SecurityCode/removeProductRel');
    Route::rule('securityCode/queryDealerCodeBatch','partner/SecurityCode/queryDealerCodeBatch');
    Route::rule('securityCode/getCodeBeginOrder','partner/SecurityCode/getCodeBeginOrder');
    Route::rule('securityCode/getCreateCodePrice','partner/SecurityCode/getCreateCodePrice');
    Route::rule('securityCode/downLoad','partner/SecurityCode/downLoad');

    Route::rule('dealer/dealerList','partner/Dealer/getDealerList');
    Route::rule('dealer/getDealerMoreInfo','partner/Dealer/getDealerMoreInfo');
    Route::rule('dealer/getDealerPrice','partner/Dealer/getDealerPrice');
    Route::rule('dealer/rechargeLog','partner/Dealer/rechargeLog');
    Route::rule('dealer/redPackIssueLog','partner/Dealer/redPackIssueLog');
    Route::rule('dealer/calculatePrice','partner/Dealer/calculateModulePrice');
    Route::rule('dealer/calculateLiftPrice','partner/Dealer/calculateLiftPrice');
    Route::rule('dealer/calculateLiftSerPrice','partner/Dealer/calculateLiftSerPrice');
    Route::rule('dealer/addDealer','partner/Dealer/addDealer');
    Route::rule('dealer/getAuthData','partner/Dealer/getAuthData');
    Route::rule('dealer/checkTrademark','partner/Dealer/checkTrademark');
    Route::rule('dealer/checkLicense','partner/Dealer/checkLicense');
    Route::rule('dealer/cutDealer','partner/Dealer/cutDealer');
    Route::rule('dealer/getDealerInfo','partner/Dealer/getDealerInfo');
    Route::rule('dealer/liftingService','partner/Dealer/liftingService');
    Route::rule('dealer/getDealerModule','partner/Dealer/getDealerModule');
    Route::rule('dealer/saveIncrement','partner/Dealer/saveIncrement');
    Route::rule('dealer/renew','partner/Dealer/renew');
    Route::rule('dealer/getRenewModule','partner/Dealer/getRenewModule');
    Route::rule('dealer/saveDealerModulePrice','partner/Dealer/saveDealerModulePrice');
    Route::rule('dealer/saveDealerCodePrice','partner/Dealer/saveDealerCodePrice');
    Route::rule('dealer/saveDealerSerPrice','partner/Dealer/saveDealerSerPrice');
    Route::rule('dealer/uploadTrademark','partner/Dealer/uploadLicense');
    Route::rule('dealer/uploadLicense','partner/Dealer/uploadLicense');

    Route::rule('product/getModule','partner/Product/getModule');
    Route::rule('product/setModulePrice','partner/Product/setModulePrice');
    Route::rule('product/getCodeList','partner/Product/getCodeList');
    Route::rule('product/addCodePrice','partner/Product/addCodePrice');
    Route::rule('product/getServer','partner/Product/getServerList');
    Route::rule('product/addServer','partner/Product/addServer');

    Route::rule('increment/listService','partner/IncrementService/getList');
    Route::rule('increment/saveServide','partner/IncrementService/saveServide');
    Route::rule('increment/getServiceOrder','partner/IncrementService/getServiceOrder');
    Route::rule('increment/orderInfo','partner/IncrementService/orderInfo');
    Route::rule('increment/orderDes','partner/IncrementService/orderDes');

    Route::rule('finance/listFinanceBill','partner/Finance/listFinanceBill');
    Route::rule('finance/listFinanceDealerBill','partner/Finance/listFinanceDealerBill');
    Route::rule('finance/getCashRule','partner/Finance/getCashRule');
    Route::rule('finance/getCashLimitTimes','partner/Finance/getCashLimitTimes');
    Route::rule('finance/cash','partner/Finance/cash');
    Route::rule('finance/cashList','partner/Finance/cashList');

    Route::rule('demand/getAllModule','partner/Demand/getAllModule');
    Route::rule('demand/getDemands','partner/Demand/getDemands');
    Route::rule('demand/getDealer','partner/Demand/getDealer');
    Route::rule('demand/addDemands','partner/Demand/addDemands');
    Route::rule('demand/uploadImg','partner/Demand/uploadImg');//上传图片
    Route::rule('demand/uploadFile','partner/Demand/uploadFile');//上传图片
})->middleware(['partner_auth']);