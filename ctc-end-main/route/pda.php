<?php
/**
 * Created by PhpStorm.
 * User: wenhan
 * Date: 2022/3/26
 * Time: 下午12:44
 */
Route::group('pda', function(){
    Route::rule('login', 'pda/Auth/login');
    Route::rule('logout', 'pda/Auth/logout');
})->middleware(['api_allow_cross_domain']);

Route::group('pda', function(){
    //入库管理
    Route::rule('rk_order_info', 'pda/RKManage/getRkOrderInfo');
    Route::rule('rk_order_list', 'pda/RKManage/getRkOrderList');
    Route::rule('warehouse_list', 'pda/RKManage/getWarehouseList');
    Route::rule('save_rk_order', 'pda/RKManage/saveRkOrder');
    Route::rule('save_direct_rk_order', 'pda/RKManage/saveDirectRkOrder');
    Route::rule('rk_code_list', 'pda/RKManage/getCodeList');
    Route::rule('create_rk_order', 'pda/RKManage/createRkOrder');
    Route::rule('rk_order_notes', 'pda/RKManage/getRkNotes');
    //出库管理
    Route::rule('ck_order_info', 'pda/CKManage/getCkOrderInfo');
    Route::rule('ck_order_list', 'pda/CKManage/getCkOrderList');
    Route::rule('save_ck_order', 'pda/CKManage/saveCkOrder');
    Route::rule('save_direct_ck_order', 'pda/DirectCk/saveDirectCkOrder');//直接出库
    Route::rule('create_ck_order', 'pda/CKManage/createCkOrder');
    Route::rule('get_code_list', 'pda/CKManage/getCodeList');
    Route::rule('get_ck_product_list', 'pda/CKManage/getCkProductList');
    Route::rule('ck_order_notes', 'pda/CKManage/getCkNotes');
    //退货管理
    Route::rule('create_th_order', 'pda/THManage/createThOrder');
    Route::rule('return_goods', 'pda/THManage/returnGoods');
    Route::rule('get_th_product_list', 'pda/THManage/getThProductList');
    Route::rule('get_th_code_list', 'pda/THManage/getCodeList');
    Route::rule('get_th_notes', 'pda/THManage/getThNotes');
    //调仓管理
    Route::rule('dc_order_info', 'pda/DCManage/getDcOrderInfo');
    Route::rule('get_dc_order_list', 'pda/DCManage/getDcOrderList');
    Route::rule('save_dc_order', 'pda/DCManage/saveDcOrder');
    Route::rule('get_dc_notes', 'pda/DCManage/getDcNotes');
    Route::rule('get_dc_product_list', 'pda/DCManage/getDcProductList');
    Route::rule('get_dc_code_list', 'pda/DCManage/getCodeList');
    //数码替换
    Route::rule('replace_code', 'pda/Replace/replaceCode');
    //流通
    Route::rule('query_code_link', 'pda/link/queryCodeLink');
    //商品
    Route::rule('get_product_list', 'pda/Product/getProductList');
    //客户
    Route::rule('get_store_list', 'pda/Store/getStoreList');
    Route::rule('get_distributor_list', 'pda/Distributor/getDistributorList');
    //日志
    Route::rule('get_op_log_list', 'pda/Log/getOpLogList');
})->middleware(['api_allow_cross_domain']);