/*
 Navicat MySQL Data Transfer

 Source Server         : course
 Source Server Type    : MySQL
 Source Server Version : 50732
 Source Host           : localhost
 Source Database       : hailue

 Target Server Type    : MySQL
 Target Server Version : 50732
 File Encoding         : utf-8

 Date: 04/05/2022 02:16:20 AM
*/

SET NAMES utf8;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
--  Table structure for `ctc_cash_rule`
-- ----------------------------
DROP TABLE IF EXISTS `ctc_cash_rule`;
CREATE TABLE `ctc_cash_rule` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `max_cash` int(255) DEFAULT NULL COMMENT '最高提现',
  `min_cash` int(255) DEFAULT NULL COMMENT '最低提现',
  `limit_times` tinyint(4) DEFAULT NULL,
  `service_charge` varchar(255) DEFAULT NULL COMMENT '提现手续费',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4;

-- ----------------------------
--  Records of `ctc_cash_rule`
-- ----------------------------
BEGIN;
INSERT INTO `ctc_cash_rule` VALUES ('1', '3', '1', '4', '0.4');
COMMIT;

-- ----------------------------
--  Table structure for `ctc_code_disable`
-- ----------------------------
DROP TABLE IF EXISTS `ctc_code_disable`;
CREATE TABLE `ctc_code_disable` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `batch` varchar(255) DEFAULT NULL,
  `order_begin` varchar(255) DEFAULT NULL,
  `order_end` varchar(255) DEFAULT NULL,
  `count` int(11) DEFAULT NULL COMMENT '作废数量',
  `remark` varchar(255) DEFAULT NULL COMMENT '备注',
  `dealer_id` int(11) DEFAULT NULL,
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4;

-- ----------------------------
--  Records of `ctc_code_disable`
-- ----------------------------
BEGIN;
INSERT INTO `ctc_code_disable` VALUES ('3', '202112151639581497', '12', '13', '2', '1', '23', '2021-12-22 15:27:43');
COMMIT;

-- ----------------------------
--  Table structure for `ctc_code_enable`
-- ----------------------------
DROP TABLE IF EXISTS `ctc_code_enable`;
CREATE TABLE `ctc_code_enable` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `batch` varchar(255) DEFAULT NULL COMMENT '码批次 唯一',
  `start_code` varchar(255) DEFAULT NULL COMMENT '起始编号',
  `end_code` varchar(255) DEFAULT NULL COMMENT '终止编号',
  `quantity` varchar(255) DEFAULT NULL COMMENT '数量',
  `remark` varchar(255) DEFAULT NULL COMMENT '备注',
  `partner_id` int(11) DEFAULT NULL,
  `dealer_id` int(11) DEFAULT NULL,
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=24 DEFAULT CHARSET=utf8mb4;

-- ----------------------------
--  Records of `ctc_code_enable`
-- ----------------------------
BEGIN;
INSERT INTO `ctc_code_enable` VALUES ('13', '202112111639152278', '1', '3', '3', '111', '1', '23', '2021-12-14 10:34:35'), ('14', '202112111639152278', '4', '8', '5', '11', '1', '23', '2021-12-14 10:35:29'), ('15', '202112111639152278', '9', '10', '2', '111', '1', '23', '2021-12-14 10:35:46'), ('21', '202112151639581497', '11', '13', '3', '测试', '1', '23', '2022-01-15 22:29:03'), ('22', '202112151639581497', '14', '15', '2', '66', '1', '23', '2022-01-15 22:30:17'), ('23', '202201231642926120', '716', '800', '85', '测试启用', '1', '23', '2022-01-23 16:22:35');
COMMIT;

-- ----------------------------
--  Table structure for `ctc_code_manage`
-- ----------------------------
DROP TABLE IF EXISTS `ctc_code_manage`;
CREATE TABLE `ctc_code_manage` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `partner_id` int(11) DEFAULT NULL,
  `dealer_id` int(11) DEFAULT NULL,
  `batch` varchar(255) DEFAULT NULL COMMENT '批次',
  `scene` varchar(255) DEFAULT NULL COMMENT '应用场景',
  `order` varchar(255) DEFAULT NULL COMMENT '流水号范围',
  `count` int(11) DEFAULT NULL COMMENT '生码数量',
  `code_type` varchar(255) DEFAULT NULL COMMENT '码类型 1普通码 2小程序码',
  `used_num` varchar(255) DEFAULT '0' COMMENT '已启用数量',
  `product_time` datetime DEFAULT NULL,
  `remark` varchar(255) DEFAULT NULL,
  `key` varchar(255) DEFAULT NULL COMMENT '秘钥',
  `status` tinyint(4) DEFAULT '0' COMMENT '0未启用 1全部启用 2部分启用',
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `is_del` tinyint(4) DEFAULT '0',
  `order_begin` int(11) DEFAULT NULL,
  `order_end` int(11) DEFAULT NULL,
  `code_length` varchar(255) DEFAULT NULL COMMENT '码长度',
  `is_rel` tinyint(4) DEFAULT NULL COMMENT '是否开启关联 0未关联 1已关联',
  `rel_product_id` varchar(255) DEFAULT NULL,
  `verification_code` tinyint(4) DEFAULT '0' COMMENT '溯源码是否开启验证码 0未开启 1已开启',
  `prize` tinyint(4) DEFAULT NULL COMMENT '导购奖项 1单奖 2多奖',
  `prize_order` tinyint(4) DEFAULT '1' COMMENT '导购 多奖项领奖顺序',
  `rel_logistics_code_order` tinyint(4) DEFAULT NULL COMMENT '关联物流码先后顺序 1先关联 2后关联',
  `logistics_level` varchar(255) DEFAULT NULL COMMENT '包装层级 字典获取',
  `logistics_level_item` varchar(255) DEFAULT NULL COMMENT '包装层级具体关系 例 1拖几拖几',
  `scale_count` varchar(255) DEFAULT '0' COMMENT '套标数量',
  `rel_guide_code` tinyint(4) DEFAULT '0' COMMENT '关联导购码1 关联 0不关联',
  `rel_guide_code_batch` varchar(255) DEFAULT NULL COMMENT '关联批次',
  `rel_product_name` varchar(255) DEFAULT NULL,
  `code_cost` varchar(255) DEFAULT '0' COMMENT '生码成本价',
  `code_retail` varchar(255) DEFAULT '0' COMMENT '生码品牌商单价',
  `total_cost_fee` varchar(255) DEFAULT '0' COMMENT '合伙人生码总成本费用',
  `pay_type` tinyint(4) DEFAULT '0' COMMENT '支付方式 余额支付0 联系客服1',
  `total_fee` varchar(255) DEFAULT NULL COMMENT '品牌商总费用',
  `secret_key` text COMMENT '物流码数码位数与秘钥',
  `enable` tinyint(4) DEFAULT '0' COMMENT '码是否可下载0审核中 1已审核通过 2已拒绝',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=74 DEFAULT CHARSET=utf8mb4;

-- ----------------------------
--  Records of `ctc_code_manage`
-- ----------------------------
BEGIN;
INSERT INTO `ctc_code_manage` VALUES ('73', '1', '23', '202204031648961618', '4', null, '1055', '1', '0', null, '测试', 'undefined,undefined,undefined', '0', '2022-04-03 12:53:38', '0', '1', '1055', '', '1', '3', '0', '0', '0', '1', '3', '[{\"num\":\"10\",\"key\":1648961588968},{\"num\":\"10\",\"key\":1648961588968}]', '5', '0', '', '赵县鸭梨', '1', '338', '1055.00', '1', '356590.00', '[{\"length\":\"10\",\"key\":\"6776137853,2882766011,5280905783\",\"order\":\"1--5\"},{\"length\":\"11\",\"key\":\"82014931469,35576563661,81762030341\",\"order\":\"6--55\"},{\"length\":\"12\",\"key\":\"859780538989,385704552773,730920427277\",\"order\":\"56--555\"}]', '1');
COMMIT;

-- ----------------------------
--  Table structure for `ctc_code_rel_product`
-- ----------------------------
DROP TABLE IF EXISTS `ctc_code_rel_product`;
CREATE TABLE `ctc_code_rel_product` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `batch` varchar(255) DEFAULT NULL COMMENT '批次号',
  `start_code` varchar(255) DEFAULT NULL,
  `end_code` varchar(255) DEFAULT NULL,
  `quantity` int(11) DEFAULT NULL COMMENT '关联码段数量',
  `product_id` int(11) DEFAULT NULL COMMENT '关联产品id',
  `remark` varchar(255) DEFAULT NULL,
  `dealer_id` int(11) DEFAULT NULL,
  `partner_id` int(11) DEFAULT NULL,
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `is_rel_all` tinyint(4) DEFAULT '0' COMMENT '是否全部关联0否  1是',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=106 DEFAULT CHARSET=utf8mb4;

-- ----------------------------
--  Records of `ctc_code_rel_product`
-- ----------------------------
BEGIN;
INSERT INTO `ctc_code_rel_product` VALUES ('44', '202112111639152278', '1', '10', '10', '1', '123', '23', '1', '2021-12-14 20:18:01', '1'), ('46', '202112161639667543', '16', '115', '100', '1', '+656', '23', '1', '2021-12-16 23:15:44', '1'), ('47', '202112171639749646', '16', '215', '200', '1', '111', '23', '1', '2021-12-17 22:00:46', '1'), ('48', '202112171639749922', '216', '315', '100', '1', '测试账单', '23', '1', '2021-12-17 22:05:22', '1'), ('49', '202112171639750389', '316', '515', '200', '1', 'test', '23', '1', '2021-12-17 22:13:09', '1'), ('50', '202112171639750453', '516', '615', '100', '1', '11', '23', '1', '2021-12-17 22:14:13', '1'), ('61', '202112171639750504', '516', '615', '100', '1', '684', '23', '1', '2021-12-21 22:50:15', '1'), ('62', '202112211640098955', '616', '715', '100', '2', '55', '23', '1', '2021-12-21 23:02:36', '1'), ('63', '202201231642926120', '716', '815', '100', '1', '溯源查询测试', '23', '1', '2022-01-23 16:22:00', '1'), ('64', '202203191647663999', '816', '915', '100', '1', '100', '23', '1', '2022-03-19 12:26:39', '1'), ('65', '202203191647677740', '916', '920', '5', '1', '22', '23', '1', '2022-03-19 16:15:40', '1'), ('66', '202203191647677829', '916', '920', '5', '1', '22', '23', '1', '2022-03-19 16:17:09', '1'), ('67', '202203191647684648', '921', '1020', '100', '1', '100', '23', '1', '2022-03-19 18:10:48', '1'), ('68', '202203191647687506', '921', '1920', '1000', '1', '44', '23', '1', '2022-03-19 18:58:27', '1'), ('69', '202203191647693070', '921', '1020', '100', '1', '', '23', '1', '2022-03-19 20:31:10', '1'), ('70', '202203201647707608', '921', '930', '10', '3', '2', '23', '1', '2022-03-20 00:33:28', '1'), ('71', '202203201647708429', '931', '1030', '100', '1', '11', '23', '1', '2022-03-20 00:47:09', '1'), ('72', '202203201647768531', '931', '950', '0', '3', '1', '23', '1', '2022-03-20 17:28:51', '1'), ('73', '202203201647768764', '931', '950', '0', '3', '1', '23', '1', '2022-03-20 17:32:44', '1'), ('74', '202203201647769378', '931', '950', '0', '3', '1', '23', '1', '2022-03-20 17:42:58', '1'), ('75', '202203201647772432', '951', '1060', '0', '3', '10', '23', '1', '2022-03-20 18:33:52', '1'), ('76', '202203201647778794', '951', '1060', '0', '3', '11', '23', '1', '2022-03-20 20:19:54', '1'), ('77', '202203201647779825', '951', '1050', '100', '3', '100', '23', '1', '2022-03-20 20:37:05', '1'), ('78', '202203201647780022', '951', '106950', '0', '3', '22', '23', '1', '2022-03-20 20:40:40', '1'), ('79', '202203201647785280', '951', '1050', '100', '3', '2', '23', '1', '2022-03-20 22:08:00', '1'), ('80', '202203201647786779', '1000000', '1000099', '100', '3', '11', '23', '1', '2022-03-20 22:32:59', '1'), ('81', '202203201647787113', '1', '1000', '1000', '3', '111', '23', '1', '2022-03-20 22:38:34', '1'), ('82', '202203201647787165', '1001', '6300', '0', '3', '11', '23', '1', '2022-03-20 22:39:25', '1'), ('83', '202203201647787190', '6301', '6400', '100', '3', '11', '23', '1', '2022-03-20 22:39:50', '1'), ('84', '202203201647787232', '6401', '6500', '100', '3', '11', '23', '1', '2022-03-20 22:40:32', '1'), ('85', '202203201647789246', '80871', '81420', '550', '3', '10', '23', '1', '2022-03-20 23:14:06', '1'), ('86', '202203201647789483', '1', '100', '100', '3', '22', '23', '1', '2022-03-20 23:18:03', '1'), ('87', '202203201647789693', '101', '1100', '1000', '3', '11', '23', '1', '2022-03-20 23:21:34', '1'), ('89', '202203201647791648', '1102', '1103', '2', '3', '2', '23', '1', '2022-03-21 11:27:25', '0'), ('90', '202203211647856749', '11701', '11900', '200', '1', '1', '23', '1', '2022-03-21 17:59:09', '1'), ('91', '202203211647870016', '11901', '117900', '106000', '3', '111', '23', '1', '2022-03-21 21:40:39', '1'), ('92', '202203221647935949', '117901', '118450', '550', '3', '22', '23', '1', '2022-03-22 15:59:09', '1'), ('93', '202203221647935984', '118451', '118470', '20', '3', '5', '23', '1', '2022-03-22 15:59:44', '1'), ('94', '202203221647936019', '118471', '118570', '100', '3', '332', '23', '1', '2022-03-22 16:00:19', '1'), ('95', '202203221647937702', '1', '5300', '5300', '3', '我要测试', '23', '1', '2022-03-22 16:28:23', '1'), ('96', '202203221647952426', '1', '100', '100', '3', '22', '23', '1', '2022-03-22 20:33:46', '1'), ('97', '202203221647953361', '101', '5400', '5300', '3', '5255', '23', '1', '2022-03-22 20:49:22', '1'), ('98', '202203231648040848', '1', '5300', '5300', '3', '123', '23', '1', '2022-03-23 21:07:29', '1'), ('99', '202203271648386148', '1', '5300', '5300', '3', '测试', '23', '1', '2022-03-27 21:02:29', '1'), ('100', '202203301648632988', '1', '200', '200', '3', '111', '23', '1', '2022-03-30 17:36:28', '1'), ('101', '202203301648633659', '201', '255', '55', '3', '3', '23', '1', '2022-03-30 17:47:39', '1'), ('102', '202203301648643450', '1', '10600', '10600', '3', '', '23', '1', '2022-03-30 20:30:52', '1'), ('103', '202203311648726946', '10601', '10700', '100', '3', '555', '23', '1', '2022-03-31 19:42:26', '1'), ('104', '202204031648959827', '10701', '61000', '50300', '3', '225', '23', '1', '2022-04-03 12:23:59', '1'), ('105', '202204031648961618', '1', '1055', '1055', '3', '测试', '23', '1', '2022-04-03 12:53:38', '1');
COMMIT;

-- ----------------------------
--  Table structure for `ctc_dealer`
-- ----------------------------
DROP TABLE IF EXISTS `ctc_dealer`;
CREATE TABLE `ctc_dealer` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `code` varchar(255) DEFAULT NULL,
  `dealer_name` varchar(255) DEFAULT NULL,
  `account` varchar(255) DEFAULT NULL,
  `company` varchar(255) DEFAULT NULL,
  `partner_id` int(11) DEFAULT NULL,
  `concact_name` varchar(255) DEFAULT NULL,
  `phone` varchar(255) DEFAULT NULL,
  `password` varchar(255) DEFAULT NULL,
  `province` varchar(255) DEFAULT NULL,
  `city` varchar(255) DEFAULT NULL,
  `district` varchar(255) DEFAULT NULL,
  `address` varchar(255) DEFAULT NULL,
  `website` varchar(255) DEFAULT NULL,
  `industry` varchar(255) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `sys_env` varchar(255) DEFAULT NULL COMMENT '访问环境',
  `module` text COMMENT '拥有的模块',
  `service_level` tinyint(4) DEFAULT '0',
  `behalf_balance` varchar(255) DEFAULT '0' COMMENT '代发余额',
  `validity_begin` varchar(255) DEFAULT '0' COMMENT '有效期',
  `validity_end` varchar(255) DEFAULT NULL COMMENT '有效期',
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `create_by` varchar(255) DEFAULT NULL,
  `status` tinyint(4) DEFAULT '0' COMMENT '状态 0未授权 1正常 2正常禁用 3未授权禁用',
  `official_account_auth` tinyint(4) DEFAULT '0' COMMENT '公众号授权0 未授权 1已授权',
  `wechat_auth` tinyint(4) DEFAULT '0' COMMENT '是否微信授权',
  `is_del` tinyint(4) DEFAULT '0' COMMENT '是否删除',
  `mini_pro_auth` tinyint(4) DEFAULT '0' COMMENT '微信小程序授权0未授权 1已授权',
  `deposit` varchar(255) DEFAULT '0' COMMENT '预存款',
  `code_ladder` text COMMENT '是否单独设置码阶梯',
  `service_price` text COMMENT '服务费',
  `logo` varchar(255) DEFAULT NULL COMMENT 'logo',
  `telephone` varchar(255) DEFAULT NULL COMMENT '客服电话',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=24 DEFAULT CHARSET=utf8mb4;

-- ----------------------------
--  Records of `ctc_dealer`
-- ----------------------------
BEGIN;
INSERT INTO `ctc_dealer` VALUES ('1', '11', '德丰', '23', '德丰农业有限公司', '1', '22', '122', '222', '河北', '石家庄', '长安区', '长安', 'www', '1', '1', null, '2', '0', '44', '2021-10-10', '2021-10-10', '2021-10-10 00:46:34', null, '1', '0', '0', '0', '0', '0', null, null, null, null), ('4', null, '测试', '12312', '测试', '1', '231233', '12312', 'e10adc3949ba59abbe56e057f20f883e', '天津市', '市辖区', '和平区', '切尔奇二e', '切切', '2', '订单', '3,2', '8,21', '1', '0', '2021-10-10', '2021-10-10', '2021-10-25 15:03:28', null, '1', '0', '0', '0', '0', '0', null, null, null, null), ('5', null, '测试啦1', '1233sds', '98989', '1', '1231239', '1233', 'e10adc3949ba59abbe56e057f20f883e', '山西省', '大同市', '市辖区', '323', '21', '3', '3213', '2', '[{\"module_name\":\"\\u5fae\\u5546\\u57ce\",\"module_retail\":\"300\",\"module_cost\":\"80\",\"module_id\":12},{\"module_name\":\"\\u79ef\\u5206\\u5546\\u57ce\",\"module_retail\":\"190\",\"module_cost\":\"80\",\"module_id\":13},{\"module_name\":\"\\u4e07\\u80fd\\u6eaf\\u6e90(\\u8212\\u9002\\u7248)\",\"module_retail\":\"100\",\"module_cost\":\"80\",\"module_id\":16},{\"module_name\":\"\\u7ecf\\u8425\\u62a5\\u8868\",\"module_retail\":\"0\",\"module_cost\":\"0\",\"module_id\":22},{\"module_name\":\"\\u89c6\\u9891\\u5206\\u4eab\",\"module_retail\":\"0\",\"module_cost\":\"0\",\"module_id\":23},{\"module_name\":\"\\u865a\\u62df\\u7ea2\\u5305\",\"module_retail\":\"0\",\"module_cost\":\"0\",\"module_id\":24}]', '2', '100', '2021-10-25', '2037-10-25', '2021-10-25 16:41:57', null, '1', '0', '0', '0', '0', '7200', '[{\"id\":\"1\",\"code_retail\":\"19\"},{\"id\":\"2\",\"code_retail\":\"337\"}]', '[{\"id\":\"2\",\"service_cost\":\"22\"},{\"id\":\"1\",\"service_cost\":\"445\"}]', null, null), ('6', null, '新测试', 'test', '新测试', '1', '测试', '18330118047', 'e10adc3949ba59abbe56e057f20f883e', '天津市', '市辖区', '和平区', 'test', 'test', '1', 'test', '1,2', '[{\"module_name\":\"\\u5fae\\u5546\\u57ce\",\"module_retail\":\"300\",\"module_cost\":\"80\",\"module_id\":12},{\"module_name\":\"\\u79ef\\u5206\\u5546\\u57ce\",\"module_retail\":\"190\",\"module_cost\":\"80\",\"module_id\":13}]', '1', '0', '2021-10-30', '2022-10-30', '2021-10-30 18:31:16', null, '1', '0', '0', '1', '0', '0', null, null, null, null), ('7', null, '12', '21', '21', '1', '212', '21', '3c59dc048e8850243be8079a5c74d079', '天津市', '市辖区', '和平区', '21', '21', '2', '21', '2,3,1', '[{\"module_name\":\"\\u6d4b\\u8bd5\\u6a21\\u5757\",\"module_retail\":\"2\",\"module_cost\":\"0\",\"module_id\":3},{\"module_name\":\"\\u5c0f\\u7a0b\\u5e8f\\u5546\\u57ce\\u6a21\\u677f\",\"module_retail\":\"100\",\"module_cost\":\"0\",\"module_id\":26}]', '1', '0', '2021-10-31', '2022-10-31', '2021-10-31 17:49:06', null, '0', '0', '0', '1', '0', '0', null, null, null, null), ('8', null, 'wewqe', 'eqwe', 'wqe', '4', 'eqweq', 'eqwe', '202cb962ac59075b964b07152d234b70', '天津市', '市辖区', '和平区', 'eqwe', 'eqweq', '3', 'eqwe', '2,1', '[{\"module_name\":\"\\u4e8c\\u7ef4\\u7801\\u8425\\u9500\",\"module_retail\":\"100\",\"module_cost\":\"0\",\"module_id\":8},{\"module_name\":\"\\u5fae\\u5546\\u57ce\",\"module_retail\":\"200\",\"module_cost\":\"0\",\"module_id\":12},{\"module_name\":\"\\u79ef\\u5206\\u5546\\u57ce\",\"module_retail\":\"190\",\"module_cost\":\"0\",\"module_id\":13},{\"module_name\":\"\\u591a\\u8bed\\u8a00\",\"module_retail\":\"150\",\"module_cost\":\"0\",\"module_id\":14}]', '3', '0', '2021-10-31', '2022-10-31', '2021-10-31 18:01:44', null, '0', '0', '0', '1', '0', '0', null, null, null, null), ('9', null, 'testa', 'test', 'test', '1', 'test', '18330118047', 'e10adc3949ba59abbe56e057f20f883e', null, null, null, '', '', '', '', '1', '[{\"module_name\":\"\\u4e8c\\u7ef4\\u7801\\u8425\\u9500\",\"module_retail\":\"130\",\"module_cost\":\"88\",\"module_id\":8}]', '2', '0', '2021-11-06', '2022-11-06', '2021-11-06 14:59:09', null, '1', '0', '0', '1', '0', '0', null, null, null, null), ('21', null, '事务', 'test222', '事务', '1', '文寒', '183', 'e10adc3949ba59abbe56e057f20f883e', null, null, null, '', '', '', '', '2', '[{\"module_name\":\"\\u4e8c\\u7ef4\\u7801\\u8425\\u9500\",\"module_retail\":\"130\",\"module_cost\":\"88\",\"module_id\":8},{\"module_name\":\"\\u667a\\u80fd\\u7269\\u6d41\",\"module_retail\":\"6800\",\"module_cost\":\"7840\",\"module_id\":17}]', '1', '0', '2021-11-06', '2022-11-06', '2021-11-06 17:07:48', null, '0', '0', '0', '0', '0', '0', null, null, null, null), ('22', null, '更新状态', 'test', 'test', '1', 'test', '123', 'e10adc3949ba59abbe56e057f20f883e', null, null, null, '', '', '', '', '2', '[{\"module_name\":\"\\u6d4b\\u8bd5\\u6a21\\u5757\",\"module_retail\":\"2\",\"module_cost\":\"0\",\"module_id\":3},{\"module_name\":\"\\u4e8c\\u7ef4\\u7801\\u8425\\u9500\",\"module_retail\":\"130\",\"module_cost\":\"88\",\"module_id\":8},{\"module_name\":\"\\u5fae\\u5546\\u57ce\",\"module_retail\":\"300\",\"module_cost\":\"80\",\"module_id\":12},{\"module_name\":\"\\u79ef\\u5206\\u5546\\u57ce\",\"module_retail\":\"190\",\"module_cost\":\"80\",\"module_id\":13},{\"module_name\":\"\\u591a\\u8bed\\u8a00\",\"module_retail\":\"150\",\"module_cost\":\"80\",\"module_id\":14},{\"module_name\":\"\\u8d85\\u7ea7\\u5bfc\\u8d2d\",\"module_retail\":\"100\",\"module_cost\":\"80\",\"module_id\":18}]', '1', '300', '2021-11-06', '2024-11-06', '2021-11-06 18:05:57', null, '1', '0', '0', '0', '0', '0', null, null, null, null), ('23', null, '石家庄海略科技', 'wenhan', '石家庄海略科技有限公司', '1', '文寒', '18330118047', 'e10adc3949ba59abbe56e057f20f883e', '北京市', '市辖区', '东城区', '石家庄裕华区玫瑰湾小区', 'http://12315gov.org', '2', '123432423@qq.com', '2,1', '[{\"module_name\":\"\\u6d4b\\u8bd5\\u6a21\\u5757\",\"module_retail\":\"2\",\"module_cost\":\"0\",\"module_id\":3},{\"module_name\":\"\\u4e8c\\u7ef4\\u7801\\u8425\\u9500\",\"module_retail\":\"130\",\"module_cost\":\"88\",\"module_id\":8},{\"module_name\":\"\\u5fae\\u5546\\u57ce\",\"module_retail\":\"300\",\"module_cost\":\"80\",\"module_id\":12},{\"module_name\":\"\\u79ef\\u5206\\u5546\\u57ce\",\"module_retail\":\"190\",\"module_cost\":\"80\",\"module_id\":13},{\"module_name\":\"\\u591a\\u8bed\\u8a00\",\"module_retail\":\"150\",\"module_cost\":\"80\",\"module_id\":14},{\"module_name\":\"\\u667a\\u6167\\u95e8\\u5e97\",\"module_retail\":\"190\",\"module_cost\":\"80\",\"module_id\":15},{\"module_name\":\"\\u4e07\\u80fd\\u6eaf\\u6e90(\\u8212\\u9002\\u7248)\",\"module_retail\":\"100\",\"module_cost\":\"80\",\"module_id\":16},{\"module_name\":\"\\u667a\\u80fd\\u7269\\u6d41\",\"module_retail\":\"6800\",\"module_cost\":\"7840\",\"module_id\":17}]', '1', '103', '2021-11-11', '2022-11-11', '2021-11-11 18:35:15', null, '1', '0', '0', '0', '0', '0', '[{\"id\":\"1\",\"code_retail\":\"17\"}]', null, '20211113/0c39bb0973388c7deb7e0b0338a56524.png', '34872344');
COMMIT;

-- ----------------------------
--  Table structure for `ctc_dealer_business_license`
-- ----------------------------
DROP TABLE IF EXISTS `ctc_dealer_business_license`;
CREATE TABLE `ctc_dealer_business_license` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `dealer_id` int(11) DEFAULT NULL,
  `company_type` varchar(4) DEFAULT NULL COMMENT '公司类型',
  `register_address` varchar(255) DEFAULT NULL,
  `legal_person` varchar(255) DEFAULT NULL,
  `capital` varchar(255) DEFAULT NULL COMMENT '注册资金',
  `establish_date` varchar(255) DEFAULT NULL,
  `business_period` varchar(255) DEFAULT NULL,
  `business_license_code` varchar(255) DEFAULT NULL COMMENT '社会信用代码',
  `organization_code` varchar(255) DEFAULT NULL COMMENT '组织机构代码',
  `business_license_url` varchar(255) DEFAULT NULL COMMENT '营业执照照片',
  `status` varchar(255) DEFAULT NULL COMMENT '0未认证 1已认证 2未通过 3更新中',
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `create_by` varchar(255) DEFAULT NULL,
  `company_name` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4;

-- ----------------------------
--  Records of `ctc_dealer_business_license`
-- ----------------------------
BEGIN;
INSERT INTO `ctc_dealer_business_license` VALUES ('1', '1', '1', '321312', '12', '1', '1', '2021-10-04,2021-11-16', '123', '22222', '20211010/5e381a8b4302149d2849ac259c90fa8f.png', '1', '2021-10-10 01:30:14', null, '4353'), ('2', '5', '2', '石家庄', '文寒', '200万', '2021-11-16', '2021-11-17,2021-12-20', '123', '123', '20211101/73927c7cb0e43e06dc0de1989490456d.png', '1', '2021-11-01 00:51:37', null, '哈哈哈'), ('3', '4', '2', '石家庄', '赵文寒', '500万', '2021-11-08', '2021-11-18,2021-12-08', '123456', '123456', '20211104/13f75d3f972221f4c45b8d40b6547874.png', '1', '2021-11-04 13:41:09', null, '测试营业执照'), ('4', null, '1', '测试', '大', 'd\'sa\'da', '2021-11-08', '2021-11-09,2021-12-05', 'd\'sa\'da', 'da\'s\'da\'s\'da\'s', '20211113/f08d1f4f7a4f77451c482627561ab14b.png', '0', '2021-11-13 17:09:11', null, '测试'), ('5', '23', '1', '34234', '423423', '432', '2021-11-07', '2021-11-17,2021-12-07', '32432', '42342', '20211113/cd9f3a27a5a855170b89dae72c2b73bd.png', '1', '2021-11-13 17:09:58', null, '3432');
COMMIT;

-- ----------------------------
--  Table structure for `ctc_dealer_customer_basic_set`
-- ----------------------------
DROP TABLE IF EXISTS `ctc_dealer_customer_basic_set`;
CREATE TABLE `ctc_dealer_customer_basic_set` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `is_distributor` tinyint(4) DEFAULT NULL COMMENT '下级经销商管理权限',
  `is_store` tinyint(4) DEFAULT NULL COMMENT '门店管理权限',
  `is_rank` tinyint(4) DEFAULT NULL COMMENT '门店排行查看权限',
  `is_next_store` tinyint(4) DEFAULT NULL COMMENT '经销商管理自己下级门店',
  `dealer_id` int(11) DEFAULT NULL,
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4;

-- ----------------------------
--  Records of `ctc_dealer_customer_basic_set`
-- ----------------------------
BEGIN;
INSERT INTO `ctc_dealer_customer_basic_set` VALUES ('1', '1', '1', '1', '0', '23', '2021-12-29 00:04:18');
COMMIT;

-- ----------------------------
--  Table structure for `ctc_dealer_customer_notice`
-- ----------------------------
DROP TABLE IF EXISTS `ctc_dealer_customer_notice`;
CREATE TABLE `ctc_dealer_customer_notice` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `title` varchar(255) DEFAULT NULL COMMENT '公告标题',
  `content` text COMMENT '公告内容',
  `dealer_id` int(11) DEFAULT NULL,
  `status` tinyint(4) DEFAULT '0' COMMENT '状态0正常 1删除',
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4;

-- ----------------------------
--  Records of `ctc_dealer_customer_notice`
-- ----------------------------
BEGIN;
INSERT INTO `ctc_dealer_customer_notice` VALUES ('2', 'eferf', '<p>rewrw</p>', '23', '0', '2021-12-28 22:53:18');
COMMIT;

-- ----------------------------
--  Table structure for `ctc_dealer_customer_userinfo_page`
-- ----------------------------
DROP TABLE IF EXISTS `ctc_dealer_customer_userinfo_page`;
CREATE TABLE `ctc_dealer_customer_userinfo_page` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `is_micro_mall` tinyint(4) DEFAULT NULL COMMENT '是否显示微商城',
  `is_points_mall` tinyint(4) DEFAULT NULL COMMENT '是否显示积分商城',
  `micro_mall_name` varchar(255) DEFAULT NULL,
  `micro_points_name` varchar(255) DEFAULT NULL,
  `page_name` varchar(255) DEFAULT NULL COMMENT '页面名称',
  `is_fun_show` tinyint(4) DEFAULT NULL COMMENT '是否删除可选模块',
  `dealer_id` int(11) DEFAULT NULL,
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4;

-- ----------------------------
--  Records of `ctc_dealer_customer_userinfo_page`
-- ----------------------------
BEGIN;
INSERT INTO `ctc_dealer_customer_userinfo_page` VALUES ('1', '1', '1', '微商城', '积分商城', 'ddd', '1', '23', '2021-12-30 11:56:27'), ('2', '1', '1', '微商城', '积分商城', '会员中心', '0', '6', '2022-01-02 20:33:03');
COMMIT;

-- ----------------------------
--  Table structure for `ctc_dealer_customer_zone`
-- ----------------------------
DROP TABLE IF EXISTS `ctc_dealer_customer_zone`;
CREATE TABLE `ctc_dealer_customer_zone` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `area_name` varchar(255) DEFAULT NULL,
  `order` int(11) DEFAULT NULL,
  `parentId` int(11) DEFAULT NULL,
  `dealer_id` int(11) DEFAULT NULL,
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb4;

-- ----------------------------
--  Records of `ctc_dealer_customer_zone`
-- ----------------------------
BEGIN;
INSERT INTO `ctc_dealer_customer_zone` VALUES ('2', 'test', '1', '0', '23', null), ('3', 'fuck', '5', '0', '23', '2021-12-28 21:45:14'), ('4', 'haha', '3', '2', '23', '2021-12-28 21:51:58'), ('7', '我去', '55', '4', '23', '2021-12-28 21:52:55'), ('8', '哈哈哈', '2', '7', '23', '2021-12-28 22:10:01'), ('9', '鼎折覆餗', '5', '0', '23', '2021-12-29 20:33:16'), ('10', '659', '69', '0', '23', '2021-12-29 20:33:31'), ('11', '7', '7', '0', '23', '2021-12-29 20:34:16'), ('12', '75', '57', '0', '23', '2021-12-29 20:34:21'), ('13', '54', '35', '7', '23', '2021-12-30 21:47:21');
COMMIT;

-- ----------------------------
--  Table structure for `ctc_dealer_customize_field`
-- ----------------------------
DROP TABLE IF EXISTS `ctc_dealer_customize_field`;
CREATE TABLE `ctc_dealer_customize_field` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `field_name` varchar(255) DEFAULT NULL COMMENT '字段名',
  `type` tinyint(4) DEFAULT NULL COMMENT '字段类型',
  `max_length` tinyint(4) DEFAULT NULL COMMENT '输入长度',
  `select_options` varchar(255) DEFAULT NULL COMMENT '下拉选项',
  `placeholder` varchar(255) DEFAULT NULL COMMENT '文本提示',
  `order` int(11) DEFAULT NULL COMMENT '排序',
  `status` tinyint(4) DEFAULT NULL,
  `dealer_id` int(11) DEFAULT NULL,
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `is_sys_set` tinyint(4) DEFAULT '0' COMMENT '是否系统内置0否 1是',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4;

-- ----------------------------
--  Records of `ctc_dealer_customize_field`
-- ----------------------------
BEGIN;
INSERT INTO `ctc_dealer_customize_field` VALUES ('1', '1', '2', '12', '4', '11114', '1', '1', '23', '2021-12-27 20:59:00', '0'), ('3', '21', '3', '0', '21', '5654', '55', '1', '23', '2021-12-27 21:25:38', '1');
COMMIT;

-- ----------------------------
--  Table structure for `ctc_dealer_dingding`
-- ----------------------------
DROP TABLE IF EXISTS `ctc_dealer_dingding`;
CREATE TABLE `ctc_dealer_dingding` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `dealer_id` int(11) DEFAULT NULL,
  `micro_app_title` varchar(255) DEFAULT NULL,
  `agentId` varchar(255) DEFAULT NULL,
  `appKey` varchar(255) DEFAULT NULL,
  `appSecret` varchar(255) DEFAULT NULL,
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4;

-- ----------------------------
--  Records of `ctc_dealer_dingding`
-- ----------------------------
BEGIN;
INSERT INTO `ctc_dealer_dingding` VALUES ('1', '23', 't54', 'tret', 'tre', 'tre', '2021-11-19 17:45:22');
COMMIT;

-- ----------------------------
--  Table structure for `ctc_dealer_dingding_set`
-- ----------------------------
DROP TABLE IF EXISTS `ctc_dealer_dingding_set`;
CREATE TABLE `ctc_dealer_dingding_set` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `app_key` varchar(255) DEFAULT NULL,
  `secret` varchar(255) DEFAULT NULL,
  `dealer_id` int(11) DEFAULT NULL,
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4;

-- ----------------------------
--  Records of `ctc_dealer_dingding_set`
-- ----------------------------
BEGIN;
INSERT INTO `ctc_dealer_dingding_set` VALUES ('1', 'rew', 'rewr', '23', '2021-11-19 22:01:40');
COMMIT;

-- ----------------------------
--  Table structure for `ctc_dealer_distributor`
-- ----------------------------
DROP TABLE IF EXISTS `ctc_dealer_distributor`;
CREATE TABLE `ctc_dealer_distributor` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `distributor_code` varchar(255) DEFAULT NULL COMMENT '经销商编号',
  `distributor_name` varchar(255) DEFAULT NULL COMMENT '经销商名称',
  `province` varchar(255) DEFAULT NULL COMMENT '经销商省份',
  `city` varchar(255) DEFAULT NULL COMMENT '经销商市',
  `district` varchar(255) DEFAULT NULL COMMENT '经销商区',
  `address` varchar(255) DEFAULT NULL COMMENT '详细地址',
  `sale_area` varchar(255) DEFAULT NULL COMMENT '销售区域',
  `distributor_level` int(11) DEFAULT NULL COMMENT '经销商级别',
  `superior_dis_id` int(11) DEFAULT NULL COMMENT '上级经销商',
  `superior_dis_name` varchar(255) DEFAULT NULL,
  `phone` varchar(255) DEFAULT NULL COMMENT '手机号码',
  `password` varchar(255) DEFAULT NULL COMMENT '密码',
  `person` varchar(255) DEFAULT NULL COMMENT '负责人姓名',
  `zone` varchar(255) DEFAULT NULL COMMENT '自定义所属区域',
  `telephone` varchar(255) DEFAULT NULL COMMENT '电话',
  `wechat` varchar(255) DEFAULT NULL COMMENT '微信号',
  `qq` varchar(255) DEFAULT NULL COMMENT 'QQ号',
  `email` varchar(255) DEFAULT NULL COMMENT '邮箱',
  `monopoly` varchar(255) DEFAULT NULL COMMENT '专卖信息',
  `introduce` varchar(255) DEFAULT NULL COMMENT '简介',
  `dealer_id` int(11) DEFAULT NULL,
  `status` tinyint(4) DEFAULT '0' COMMENT '删除状态 0正常 1删除',
  `is_disable` tinyint(4) DEFAULT '0' COMMENT '是否禁用0正常 1禁用',
  `balance` decimal(8,2) DEFAULT '0.00' COMMENT '余额',
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4;

-- ----------------------------
--  Records of `ctc_dealer_distributor`
-- ----------------------------
BEGIN;
INSERT INTO `ctc_dealer_distributor` VALUES ('1', 'so', 'woei', '河北省', '秦皇岛市', '海港区', 'wew', '[\"河北省-秦皇岛市-山海关区\",\"河北省-邯郸市-永年区\"]', '1', '0', '总部', 'ew', 'ewe', 'ewr', '12', 'rew', 'rew', 'erw', 'rewr', 'ewrw', 'rewr', '23', '0', '1', '11.00', '2021-12-30 23:34:41'), ('2', '578', '87', '全部', '全部', '全部', '587', '[\"北京市-市辖区-东城区\"]', '2', '0', '总部', '58', '578', '578', '2,4,7', '587', '578', '', '', '', '', '23', '0', '0', '3.00', '2021-12-31 00:05:26'), ('3', '6.', '63', '天津市', '市辖区', '和平区', '36', '[\"北京市-市辖区-东城区\"]', '2', '2', '87', '3', '3', '3', '2,4,7,13', '', '', '', '', '', '', '23', '0', '0', '0.00', '2022-01-07 01:04:11');
COMMIT;

-- ----------------------------
--  Table structure for `ctc_dealer_distributor_bill`
-- ----------------------------
DROP TABLE IF EXISTS `ctc_dealer_distributor_bill`;
CREATE TABLE `ctc_dealer_distributor_bill` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `distributor_id` int(11) DEFAULT NULL,
  `type` varchar(255) DEFAULT NULL COMMENT '资金变动明细类型 字典获取',
  `pm` tinyint(4) DEFAULT NULL COMMENT '0 = 支出 1 = 获得',
  `remark` varchar(255) DEFAULT NULL,
  `number` decimal(8,2) DEFAULT NULL COMMENT '变动数量',
  `create_by` varchar(255) DEFAULT NULL,
  `balance` decimal(8,2) DEFAULT NULL COMMENT '余额',
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4;

-- ----------------------------
--  Records of `ctc_dealer_distributor_bill`
-- ----------------------------
BEGIN;
INSERT INTO `ctc_dealer_distributor_bill` VALUES ('1', '1', '1', '1', '人工扣减', '2.00', 'wenhan', '2.00', '2022-01-08 22:08:41'), ('2', '1', '1', '0', '人工扣减', '-2.00', 'wenhan', '0.00', '2022-01-08 22:10:19'), ('3', '1', '1', '1', '人工扣减', '4.00', 'wenhan', '4.00', '2022-01-08 22:10:29'), ('4', '1', '1', '1', '人工扣减', '1.00', 'wenhan', '5.00', '2022-01-08 22:10:34'), ('5', '1', '1', '1', '人工增减', '2.00', 'wenhan', '7.00', '2022-01-08 23:01:18'), ('6', '1', '1', '1', '人工增减', '4.00', 'wenhan', '11.00', '2022-01-08 23:13:27'), ('7', '2', '1', '1', '人工增减', '3.00', 'wenhan', '3.00', '2022-01-08 23:38:18');
COMMIT;

-- ----------------------------
--  Table structure for `ctc_dealer_distributor_level`
-- ----------------------------
DROP TABLE IF EXISTS `ctc_dealer_distributor_level`;
CREATE TABLE `ctc_dealer_distributor_level` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `level_name` varchar(255) DEFAULT NULL COMMENT '级别名称',
  `level_order` int(11) DEFAULT NULL COMMENT '级别编号',
  `dealer_id` int(11) DEFAULT NULL,
  `status` tinyint(4) DEFAULT '0' COMMENT '状态0正常 1删除',
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4;

-- ----------------------------
--  Records of `ctc_dealer_distributor_level`
-- ----------------------------
BEGIN;
INSERT INTO `ctc_dealer_distributor_level` VALUES ('1', '一级', '1', '23', '0', '2021-12-27 22:33:48'), ('2', '二级', '2', '23', '0', '2021-12-27 22:40:28'), ('3', '三级', '3', '23', '1', '2021-12-27 22:41:15'), ('4', '8', '2', '23', '1', '2022-01-02 20:40:57'), ('5', 'dsdas', '4', '23', '1', '2022-01-02 20:49:57'), ('6', 'das', '3', '23', '1', '2022-01-02 20:50:15'), ('7', 'dasdas', '4', '23', '0', '2022-01-02 20:50:19');
COMMIT;

-- ----------------------------
--  Table structure for `ctc_dealer_distributor_register_config`
-- ----------------------------
DROP TABLE IF EXISTS `ctc_dealer_distributor_register_config`;
CREATE TABLE `ctc_dealer_distributor_register_config` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `distributor_name` tinyint(4) DEFAULT NULL COMMENT '经销商姓名',
  `distributor_company` tinyint(4) DEFAULT NULL,
  `phone` tinyint(4) DEFAULT NULL,
  `id_card` tinyint(4) DEFAULT NULL,
  `address` tinyint(4) DEFAULT NULL,
  `wechat` tinyint(4) DEFAULT NULL,
  `contact` tinyint(4) DEFAULT NULL,
  `rec_name` tinyint(4) DEFAULT NULL,
  `rec_phone` tinyint(4) DEFAULT NULL,
  `rec_address` tinyint(4) DEFAULT NULL,
  `id_card_img` tinyint(4) DEFAULT NULL,
  `dealer_id` int(11) DEFAULT NULL,
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4;

-- ----------------------------
--  Records of `ctc_dealer_distributor_register_config`
-- ----------------------------
BEGIN;
INSERT INTO `ctc_dealer_distributor_register_config` VALUES ('1', '2', '1', '1', '1', '1', '1', '1', '1', '1', '1', '2', '23', '2021-12-27 23:28:06');
COMMIT;

-- ----------------------------
--  Table structure for `ctc_dealer_freight_template`
-- ----------------------------
DROP TABLE IF EXISTS `ctc_dealer_freight_template`;
CREATE TABLE `ctc_dealer_freight_template` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `tpl_name` varchar(255) DEFAULT NULL,
  `area` longtext,
  `dealer_id` int(11) DEFAULT NULL,
  `is_default` tinyint(4) DEFAULT '1',
  `weight` varchar(255) DEFAULT NULL,
  `weights` varchar(255) DEFAULT NULL,
  `renew` varchar(255) DEFAULT NULL,
  `freight` varchar(255) DEFAULT NULL,
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `status` tinyint(4) DEFAULT '0' COMMENT '0正常 1删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4;

-- ----------------------------
--  Records of `ctc_dealer_freight_template`
-- ----------------------------
BEGIN;
INSERT INTO `ctc_dealer_freight_template` VALUES ('7', '5433', '[{\"province\":[\"130000\",\"140000\",\"220000\",\"210000\"],\"city\":[{\"value\":\"130000\",\"label\":\"\\u6cb3\\u5317\\u7701\",\"check\":[\"130100\",\"130200\",\"130300\",\"130400\",\"130500\",\"130600\",\"130700\",\"130800\",\"130900\",\"131000\",\"131100\"]},{\"value\":\"140000\",\"label\":\"\\u5c71\\u897f\\u7701\",\"check\":[\"140100\",\"140200\",\"140300\",\"140400\",\"140500\",\"140600\",\"140700\",\"140800\",\"140900\",\"141000\",\"141100\"]},{\"value\":\"210000\",\"label\":\"\\u8fbd\\u5b81\\u7701\",\"check\":[\"210200\"]},{\"value\":\"220000\",\"label\":\"\\u5409\\u6797\\u7701\",\"check\":[\"220100\",\"220200\",\"220300\",\"220400\",\"220500\",\"220600\",\"220700\",\"220800\",\"222400\"]}]}]', '23', '1', '1', '', '', '', '2021-11-15 18:56:25', '0'), ('8', '435345', '[{\"province\":[\"130000\",\"140000\",\"210000\"],\"city\":[{\"value\":\"130000\",\"label\":\"\\u6cb3\\u5317\\u7701\",\"check\":[\"130100\",\"130200\",\"130300\",\"130400\",\"130500\",\"130600\",\"130700\",\"130800\",\"130900\",\"131000\",\"131100\"]},{\"value\":\"140000\",\"label\":\"\\u5c71\\u897f\\u7701\",\"check\":[\"140100\",\"140200\",\"140300\",\"140400\",\"140500\",\"140600\",\"140700\",\"140800\",\"140900\",\"141000\",\"141100\"]},{\"value\":\"210000\",\"label\":\"\\u8fbd\\u5b81\\u7701\",\"check\":[\"210100\",\"210200\",\"210300\",\"210400\",\"210500\",\"210600\",\"210700\",\"210800\",\"210900\",\"211000\",\"211100\",\"211200\",\"211300\",\"211400\"]}]}]', '23', '1', '', '', '', '', '2021-11-15 19:36:22', '1'), ('9', '432342', '[{\"province\":[\"130000\",\"140000\"],\"city\":[{\"value\":\"130000\",\"label\":\"\\u6cb3\\u5317\\u7701\",\"check\":[\"130100\",\"130200\",\"130300\",\"130400\",\"130500\",\"130600\",\"130700\",\"130800\",\"130900\",\"131000\",\"131100\"]},{\"value\":\"140000\",\"label\":\"\\u5c71\\u897f\\u7701\",\"check\":[\"140100\",\"140200\",\"140300\",\"140400\",\"140500\",\"140600\",\"140700\",\"140800\",\"140900\",\"141000\",\"141100\"]},{\"value\":\"330000\",\"label\":\"\\u6d59\\u6c5f\\u7701\",\"check\":[\"330100\",\"330200\",\"330300\",\"330400\",\"330500\",\"330600\",\"330700\",\"330800\",\"330900\",\"331000\",\"331100\"]}]},{\"province\":[\"330000\",\"370000\"],\"city\":[{\"value\":\"130000\",\"label\":\"\\u6cb3\\u5317\\u7701\",\"check\":[\"130100\",\"130200\",\"130300\",\"130400\",\"130500\",\"130600\",\"130700\",\"130800\",\"130900\",\"131000\",\"131100\"]},{\"value\":\"140000\",\"label\":\"\\u5c71\\u897f\\u7701\",\"check\":[\"140100\",\"140200\",\"140300\",\"140400\",\"140500\",\"140600\",\"140700\",\"140800\",\"140900\",\"141000\",\"141100\"]},{\"value\":\"330000\",\"label\":\"\\u6d59\\u6c5f\\u7701\",\"check\":[\"330100\",\"330200\",\"330300\",\"330400\",\"330500\",\"330600\",\"330700\",\"330800\",\"330900\",\"331000\",\"331100\"]},{\"value\":\"370000\",\"label\":\"\\u5c71\\u4e1c\\u7701\",\"check\":[\"370100\",\"370200\",\"370300\",\"370400\",\"370500\",\"370600\",\"370700\",\"370800\",\"370900\",\"371000\",\"371100\",\"371300\",\"371400\",\"371500\",\"371600\",\"371700\"]}]}]', '23', '1', '', '', '', '', '2021-11-15 19:42:28', '1'), ('10', 'retret', null, '23', '1', '', '', '', '', '2021-11-16 17:10:41', '1'), ('11', '11', '[{\"province\":[\"110000\",\"120000\",\"130000\",\"140000\",\"150000\",\"210000\",\"220000\",\"230000\",\"310000\",\"320000\",\"330000\",\"340000\",\"350000\",\"360000\",\"370000\",\"410000\",\"420000\",\"430000\",\"440000\",\"450000\",\"460000\",\"500000\",\"510000\",\"520000\",\"530000\",\"540000\",\"610000\",\"620000\",\"630000\",\"640000\",\"650000\",\"710000\",\"810000\",\"820000\"],\"city\":[{\"value\":\"110000\",\"label\":\"\\u5317\\u4eac\\u5e02\",\"check\":[\"110100\"]},{\"value\":\"120000\",\"label\":\"\\u5929\\u6d25\\u5e02\",\"check\":[\"120100\"]},{\"value\":\"130000\",\"label\":\"\\u6cb3\\u5317\\u7701\",\"check\":[\"130100\",\"130200\",\"130300\",\"130400\",\"130500\",\"130600\",\"130700\",\"130800\",\"130900\",\"131000\",\"131100\"]},{\"value\":\"140000\",\"label\":\"\\u5c71\\u897f\\u7701\",\"check\":[\"140100\",\"140200\",\"140300\",\"140400\",\"140500\",\"140600\",\"140700\",\"140800\",\"140900\",\"141000\",\"141100\"]},{\"value\":\"150000\",\"label\":\"\\u5185\\u8499\\u53e4\\u81ea\\u6cbb\\u533a\",\"check\":[\"150100\",\"150200\",\"150300\",\"150400\",\"150500\",\"150600\",\"150700\",\"150800\",\"150900\",\"152200\",\"152500\",\"152900\"]},{\"value\":\"210000\",\"label\":\"\\u8fbd\\u5b81\\u7701\",\"check\":[\"210100\",\"210200\",\"210300\",\"210400\",\"210500\",\"210600\",\"210700\",\"210800\",\"210900\",\"211000\",\"211100\",\"211200\",\"211300\",\"211400\"]},{\"value\":\"220000\",\"label\":\"\\u5409\\u6797\\u7701\",\"check\":[\"220100\",\"220200\",\"220300\",\"220400\",\"220500\",\"220600\",\"220700\",\"220800\",\"222400\"]},{\"value\":\"230000\",\"label\":\"\\u9ed1\\u9f99\\u6c5f\\u7701\",\"check\":[\"230100\",\"230200\",\"230300\",\"230400\",\"230500\",\"230600\",\"230700\",\"230800\",\"230900\",\"231000\",\"231100\",\"231200\",\"232700\"]},{\"value\":\"310000\",\"label\":\"\\u4e0a\\u6d77\\u5e02\",\"check\":[\"310100\"]},{\"value\":\"320000\",\"label\":\"\\u6c5f\\u82cf\\u7701\",\"check\":[\"320100\",\"320200\",\"320300\",\"320400\",\"320500\",\"320600\",\"320700\",\"320800\",\"320900\",\"321000\",\"321100\",\"321200\",\"321300\"]},{\"value\":\"330000\",\"label\":\"\\u6d59\\u6c5f\\u7701\",\"check\":[\"330100\",\"330200\",\"330300\",\"330400\",\"330500\",\"330600\",\"330700\",\"330800\",\"330900\",\"331000\",\"331100\"]},{\"value\":\"340000\",\"label\":\"\\u5b89\\u5fbd\\u7701\",\"check\":[\"340100\",\"340200\",\"340300\",\"340400\",\"340500\",\"340600\",\"340700\",\"340800\",\"341000\",\"341100\",\"341200\",\"341300\",\"341500\",\"341600\",\"341700\",\"341800\"]},{\"value\":\"350000\",\"label\":\"\\u798f\\u5efa\\u7701\",\"check\":[\"350100\",\"350200\",\"350300\",\"350400\",\"350500\",\"350600\",\"350700\",\"350800\",\"350900\"]},{\"value\":\"360000\",\"label\":\"\\u6c5f\\u897f\\u7701\",\"check\":[\"360100\",\"360200\",\"360300\",\"360400\",\"360500\",\"360600\",\"360700\",\"360800\",\"360900\",\"361000\",\"361100\"]},{\"value\":\"370000\",\"label\":\"\\u5c71\\u4e1c\\u7701\",\"check\":[\"370100\",\"370200\",\"370300\",\"370400\",\"370500\",\"370600\",\"370700\",\"370800\",\"370900\",\"371000\",\"371100\",\"371300\",\"371400\",\"371500\",\"371600\",\"371700\"]},{\"value\":\"410000\",\"label\":\"\\u6cb3\\u5357\\u7701\",\"check\":[\"410100\",\"410200\",\"410300\",\"410400\",\"410500\",\"410600\",\"410700\",\"410800\",\"410900\",\"411000\",\"411100\",\"411200\",\"411300\",\"411400\",\"411500\",\"411600\",\"411700\",\"419000\"]},{\"value\":\"420000\",\"label\":\"\\u6e56\\u5317\\u7701\",\"check\":[\"420100\",\"420200\",\"420300\",\"420500\",\"420600\",\"420700\",\"420800\",\"420900\",\"421000\",\"421100\",\"421200\",\"421300\",\"422800\",\"429000\"]},{\"value\":\"430000\",\"label\":\"\\u6e56\\u5357\\u7701\",\"check\":[\"430100\",\"430200\",\"430300\",\"430400\",\"430500\",\"430600\",\"430700\",\"430800\",\"430900\",\"431000\",\"431100\",\"431200\",\"431300\",\"433100\"]},{\"value\":\"440000\",\"label\":\"\\u5e7f\\u4e1c\\u7701\",\"check\":[\"440100\",\"440200\",\"440300\",\"440400\",\"440500\",\"440600\",\"440700\",\"440800\",\"440900\",\"441200\",\"441300\",\"441400\",\"441500\",\"441600\",\"441700\",\"441800\",\"441900\",\"442000\",\"445100\",\"445200\",\"445300\"]},{\"value\":\"450000\",\"label\":\"\\u5e7f\\u897f\\u58ee\\u65cf\\u81ea\\u6cbb\\u533a\",\"check\":[\"450100\",\"450200\",\"450300\",\"450400\",\"450500\",\"450600\",\"450700\",\"450800\",\"450900\",\"451000\",\"451100\",\"451200\",\"451300\",\"451400\"]},{\"value\":\"460000\",\"label\":\"\\u6d77\\u5357\\u7701\",\"check\":[\"460100\",\"460200\",\"460300\",\"460400\",\"469000\"]},{\"value\":\"500000\",\"label\":\"\\u91cd\\u5e86\\u5e02\",\"check\":[\"500100\",\"500200\"]},{\"value\":\"510000\",\"label\":\"\\u56db\\u5ddd\\u7701\",\"check\":[\"510100\",\"510300\",\"510400\",\"510500\",\"510600\",\"510700\",\"510800\",\"510900\",\"511000\",\"511100\",\"511300\",\"511400\",\"511500\",\"511600\",\"511700\",\"511800\",\"511900\",\"512000\",\"513200\",\"513300\",\"513400\"]},{\"value\":\"520000\",\"label\":\"\\u8d35\\u5dde\\u7701\",\"check\":[\"520100\",\"520200\",\"520300\",\"520400\",\"520500\",\"520600\",\"522300\",\"522600\",\"522700\"]},{\"value\":\"530000\",\"label\":\"\\u4e91\\u5357\\u7701\",\"check\":[\"530100\",\"530300\",\"530400\",\"530500\",\"530600\",\"530700\",\"530800\",\"530900\",\"532300\",\"532500\",\"532600\",\"532800\",\"532900\",\"533100\",\"533300\",\"533400\"]},{\"value\":\"540000\",\"label\":\"\\u897f\\u85cf\\u81ea\\u6cbb\\u533a\",\"check\":[\"540100\",\"540200\",\"540300\",\"540400\",\"540500\",\"540600\",\"542500\"]},{\"value\":\"610000\",\"label\":\"\\u9655\\u897f\\u7701\",\"check\":[\"610100\",\"610200\",\"610300\",\"610400\",\"610500\",\"610600\",\"610700\",\"610800\",\"610900\",\"611000\"]},{\"value\":\"620000\",\"label\":\"\\u7518\\u8083\\u7701\",\"check\":[\"620100\",\"620200\",\"620300\",\"620400\",\"620500\",\"620600\",\"620700\",\"620800\",\"620900\",\"621000\",\"621100\",\"621200\",\"622900\",\"623000\"]},{\"value\":\"630000\",\"label\":\"\\u9752\\u6d77\\u7701\",\"check\":[\"630100\",\"630200\",\"632200\",\"632300\",\"632500\",\"632600\",\"632700\",\"632800\"]},{\"value\":\"640000\",\"label\":\"\\u5b81\\u590f\\u56de\\u65cf\\u81ea\\u6cbb\\u533a\",\"check\":[\"640100\",\"640200\",\"640300\",\"640400\",\"640500\"]},{\"value\":\"650000\",\"label\":\"\\u65b0\\u7586\\u7ef4\\u543e\\u5c14\\u81ea\\u6cbb\\u533a\",\"check\":[\"650100\",\"650200\",\"650400\",\"650500\",\"652300\",\"652700\",\"652800\",\"652900\",\"653000\",\"653100\",\"653200\",\"654000\",\"654200\",\"654300\",\"659000\"]},{\"value\":\"710000\",\"label\":\"\\u53f0\\u6e7e\\u7701\",\"check\":[\"710100\",\"710200\",\"710300\",\"710400\",\"710500\",\"710600\",\"710700\"]},{\"value\":\"810000\",\"label\":\"\\u9999\\u6e2f\\u7279\\u522b\\u884c\\u653f\\u533a\",\"check\":[\"810001\",\"810002\",\"810003\",\"810004\",\"810005\",\"810006\",\"810007\",\"810008\",\"810009\",\"810010\",\"810011\",\"810012\",\"810013\",\"810014\",\"810015\",\"810016\",\"810017\",\"810018\"]},{\"value\":\"820000\",\"label\":\"\\u6fb3\\u95e8\\u7279\\u522b\\u884c\\u653f\\u533a\",\"check\":[\"820001\",\"820002\",\"820003\",\"820004\",\"820005\",\"820006\",\"820007\",\"820008\"]}]}]', '23', '1', '', '', '', '', '2022-01-18 00:09:15', '0');
COMMIT;

-- ----------------------------
--  Table structure for `ctc_dealer_gift`
-- ----------------------------
DROP TABLE IF EXISTS `ctc_dealer_gift`;
CREATE TABLE `ctc_dealer_gift` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `code` varchar(255) DEFAULT NULL,
  `barcode` varchar(255) DEFAULT NULL COMMENT '条码',
  `group_id` int(11) DEFAULT NULL,
  `weight` varchar(255) DEFAULT NULL,
  `order` varchar(255) DEFAULT NULL,
  `gift_name` varchar(255) DEFAULT NULL,
  `cover` varchar(255) DEFAULT NULL,
  `cost_price` varchar(255) DEFAULT NULL COMMENT '成本价',
  `market_price` varchar(255) DEFAULT NULL COMMENT '市场价',
  `stock` varchar(255) DEFAULT NULL COMMENT '库存',
  `unit` varchar(255) DEFAULT NULL,
  `details` text,
  `dealer_id` int(11) DEFAULT NULL,
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` timestamp NULL DEFAULT NULL,
  `create_by` varchar(255) DEFAULT NULL,
  `is_del` tinyint(4) DEFAULT '0' COMMENT '是否删除 0正常 1回收站',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4;

-- ----------------------------
--  Records of `ctc_dealer_gift`
-- ----------------------------
BEGIN;
INSERT INTO `ctc_dealer_gift` VALUES ('2', 'th', 'r6ty', '2', 'yrt', 'yrt', 'yrt', '[{\"name\":\"2399b202111262316355694.JPG\",\"url\":\"https://cdn.icloudapi.cn/2399b202111262316355694.JPG\"}]', 'rew', 'rew', 'rew', 'rew', '<p>rew</p>', '23', '2021-11-26 23:16:41', null, null, '1'), ('3', 'w4r5', 'tre', '2', 'tre', 'tre', 'tre', '[{\"name\":\"f097f202111270034416809.JPG\",\"url\":\"https://cdn.icloudapi.cn/f097f202111270034416809.JPG\"}]', 'tre', '', 'tre', '额', '', '23', '2021-11-27 00:34:45', null, null, '0'), ('4', '563', '856', '2', '57', '587', '578', '[{\"name\":\"a352120211127003926673.JPG\",\"url\":\"https://cdn.icloudapi.cn/a352120211127003926673.JPG\"}]', '14', '', '14', '', '', '23', '2021-11-27 00:39:30', null, null, '0'), ('7', '7856', '578', '2', '45', '4522', '542', '[{\"name\":\"5fc4b202111270112413172.JPG\",\"url\":\"https://cdn.icloudapi.cn/5fc4b202111270112413172.JPG\"}]', '254', '', '245', '', '', '23', '2021-11-27 01:12:46', null, null, '0'), ('8', '245', '2452', '5', '2452', '245', '14', '[{\"url\":\"https://cdn.icloudapi.cn/c1c86202111231856227223.png\",\"name\":\"c1c86202111231856227223.png\"},{\"name\":\"31d91202111270113235566.JPG\",\"url\":\"https://cdn.icloudapi.cn/31d91202111270113235566.JPG\"}]', '245', '7', '2542', '', '', '23', '2021-11-27 01:13:29', null, null, '0');
COMMIT;

-- ----------------------------
--  Table structure for `ctc_dealer_gift_group`
-- ----------------------------
DROP TABLE IF EXISTS `ctc_dealer_gift_group`;
CREATE TABLE `ctc_dealer_gift_group` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `group_name` varchar(255) DEFAULT NULL,
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `dealer_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4;

-- ----------------------------
--  Records of `ctc_dealer_gift_group`
-- ----------------------------
BEGIN;
INSERT INTO `ctc_dealer_gift_group` VALUES ('2', 'k51', '2021-11-25 16:22:24', '23'), ('3', '5678', '2021-11-27 00:37:35', '23'), ('4', '789758', '2021-11-27 01:07:21', '23'), ('5', '8554', '2021-11-27 01:08:32', '23'), ('6', '5254', '2021-11-27 01:13:41', '23');
COMMIT;

-- ----------------------------
--  Table structure for `ctc_dealer_img_library`
-- ----------------------------
DROP TABLE IF EXISTS `ctc_dealer_img_library`;
CREATE TABLE `ctc_dealer_img_library` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `img_group` int(11) DEFAULT NULL,
  `img_url` varchar(255) DEFAULT NULL,
  `img_name` varchar(255) DEFAULT NULL,
  `dealer_id` int(11) DEFAULT NULL,
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4;

-- ----------------------------
--  Records of `ctc_dealer_img_library`
-- ----------------------------
BEGIN;
INSERT INTO `ctc_dealer_img_library` VALUES ('7', '8', 'https://cdn.icloudapi.cn/1f7f9202111210005305574.jpg', '1f7f9202111210005305574.jpg', '23', '2021-11-21 00:05:35'), ('8', '9', 'https://cdn.icloudapi.cn/8a532202111210028079962.png', '8a532202111210028079962.png', '23', '2021-11-21 00:28:12'), ('10', '9', 'https://cdn.icloudapi.cn/d146b202111211336118366.jpg', 'd146b202111211336118366.jpg', '23', '2021-11-21 13:36:14'), ('11', '8', 'https://cdn.icloudapi.cn/c1c86202111231856227223.png', 'c1c86202111231856227223.png', '23', '2021-11-23 18:56:26'), ('12', '9', 'https://cdn.icloudapi.cn/7927e202112071031073685.png', '7927e202112071031073685.png', '23', '2021-12-07 10:31:11'), ('13', '8', 'https://cdn.icloudapi.cn/d3b07202112071031225844.jpg', 'd3b07202112071031225844.jpg', '23', '2021-12-07 10:31:25'), ('14', '9', 'https://cdn.icloudapi.cn/32d17202202100852475252.jpeg', '32d17202202100852475252.jpeg', '23', '2022-02-10 08:52:50'), ('15', '9', 'https://cdn.icloudapi.cn/2744b202202100858394833.jpeg', '2744b202202100858394833.jpeg', '23', '2022-02-10 08:58:42');
COMMIT;

-- ----------------------------
--  Table structure for `ctc_dealer_img_material`
-- ----------------------------
DROP TABLE IF EXISTS `ctc_dealer_img_material`;
CREATE TABLE `ctc_dealer_img_material` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `img_url` varchar(255) DEFAULT NULL,
  `material_group` int(11) DEFAULT NULL,
  `media_id` varchar(255) DEFAULT NULL,
  `dealer_id` int(11) DEFAULT NULL,
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4;

-- ----------------------------
--  Records of `ctc_dealer_img_material`
-- ----------------------------
BEGIN;
INSERT INTO `ctc_dealer_img_material` VALUES ('1', '20211118/735c8a15e21baee37b5f5df48f08c513.png', '2', '8JDK-vD7NW6QiWjxMed7sbDSFn7-DwZFsDjoEbkMH_Q', '23', '2021-11-18 21:25:05'), ('2', '20211118/0467cd7f9e782c397e0b00e82d96412a.png', '2', '8JDK-vD7NW6QiWjxMed7sQQ0O66C7h9oEdEi9sOXWuo', '23', '2021-11-18 21:26:05'), ('3', '20211118/e910294f5e380659b6d5cace85df239e.png', '3', '8JDK-vD7NW6QiWjxMed7sW3I51lYiR05i8ROKn5Ag0s', '23', '2021-11-18 22:37:22'), ('4', '20211119/72a656fe8bfa0b7aab7dbb1b996231ea.png', '3', '8JDK-vD7NW6QiWjxMed7sRLq1wR7TCOZ65AfLO8fwVE', '23', '2021-11-19 11:27:03'), ('5', '20211119/a5b786913a5886d29b0faaa5a41d855d.png', '6', '8JDK-vD7NW6QiWjxMed7sU2S9wxR2xWDiYnpyokoyZo', '23', '2021-11-19 11:27:14'), ('6', '20211119/f95815774c15a7fffdd8bda82ac4d434.png', '3', '8JDK-vD7NW6QiWjxMed7sZG-IHJxOeL8t1LfVQYmOBw', '23', '2021-11-19 11:28:14'), ('7', '20211119/25d286ee92334f254e5849aa7a3aacfb.png', '4', '8JDK-vD7NW6QiWjxMed7sYK65yI_rsWMzMaHHdz4LBE', '23', '2021-11-19 11:28:23'), ('8', '20211119/82d859a62ac0d0fb34e114855d0435b8.png', '2', '8JDK-vD7NW6QiWjxMed7sUOp_ghw_HChp4W_97Yiqw0', '23', '2021-11-19 11:28:32'), ('9', '20211119/0ac0ac1bd8cade844c2e2245fbb64658.png', '2', '8JDK-vD7NW6QiWjxMed7sXteSe1GLqTG5oKbbI_pRTM', '23', '2021-11-19 11:28:39');
COMMIT;

-- ----------------------------
--  Table structure for `ctc_dealer_library_type`
-- ----------------------------
DROP TABLE IF EXISTS `ctc_dealer_library_type`;
CREATE TABLE `ctc_dealer_library_type` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `group_name` varchar(255) DEFAULT NULL,
  `dealer_id` int(11) DEFAULT NULL,
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `is_del` tinyint(4) DEFAULT '0' COMMENT '1已删除 代表未分组',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4;

-- ----------------------------
--  Records of `ctc_dealer_library_type`
-- ----------------------------
BEGIN;
INSERT INTO `ctc_dealer_library_type` VALUES ('8', 'freftre', '23', '2021-11-21 00:03:30', '0'), ('9', 'fsdfsdf', '23', '2021-11-21 00:03:33', '0');
COMMIT;

-- ----------------------------
--  Table structure for `ctc_dealer_logistics_ch_order`
-- ----------------------------
DROP TABLE IF EXISTS `ctc_dealer_logistics_ch_order`;
CREATE TABLE `ctc_dealer_logistics_ch_order` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `dealer_id` int(11) DEFAULT NULL,
  `ch_distributor_id` int(11) DEFAULT NULL COMMENT '窜货经销商id',
  `ch_num` int(11) DEFAULT NULL COMMENT '窜货数量',
  `bch_distributor_id` int(11) DEFAULT NULL COMMENT '被串货经销商id',
  `bch_distributor_name` varchar(255) DEFAULT NULL,
  `bch_distributor_code` varchar(255) DEFAULT NULL,
  `cu_address` varchar(255) DEFAULT NULL COMMENT '窜货地点',
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `from_type` tinyint(4) DEFAULT '1' COMMENT '窜货来源 1退货 2扫码',
  `th_order` varchar(255) DEFAULT NULL COMMENT '退回单号',
  `ck_order` varchar(255) DEFAULT NULL COMMENT '出货单号',
  `serial_number` varchar(255) DEFAULT NULL COMMENT '物流码序列号',
  `code` varchar(255) DEFAULT NULL COMMENT '物流码',
  `order_start` varchar(255) DEFAULT NULL COMMENT '按序号发货 起始码段',
  `code_type` varchar(255) DEFAULT NULL COMMENT '标签类型',
  `remark` varchar(255) DEFAULT NULL COMMENT '备注',
  `order_end` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4;

-- ----------------------------
--  Records of `ctc_dealer_logistics_ch_order`
-- ----------------------------
BEGIN;
INSERT INTO `ctc_dealer_logistics_ch_order` VALUES ('9', '23', '2', '100', '3', '63', '6.', null, '2022-04-04 13:21:43', '1', 'TH2022040410210155', 'CH2022040450981024', '5', '2920342390', null, '1', '退货', null);
COMMIT;

-- ----------------------------
--  Table structure for `ctc_dealer_logistics_ck_code`
-- ----------------------------
DROP TABLE IF EXISTS `ctc_dealer_logistics_ck_code`;
CREATE TABLE `ctc_dealer_logistics_ck_code` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `code` varchar(255) DEFAULT NULL COMMENT '入库码',
  `serial_number` varchar(255) DEFAULT NULL COMMENT '码对应的序号',
  `product_batch` varchar(255) DEFAULT NULL COMMENT '生产批次',
  `batch` varchar(255) DEFAULT NULL COMMENT '码批次',
  `code_type` tinyint(4) DEFAULT NULL COMMENT '标签类型 1大标 2小标',
  `ck_num` int(11) DEFAULT NULL COMMENT '入库数量 为了统计用',
  `ck_order` varchar(255) DEFAULT NULL COMMENT '入库单',
  `specifications` varchar(255) DEFAULT NULL COMMENT '产品规格',
  `unit` varchar(255) DEFAULT NULL,
  `barcode` varchar(255) DEFAULT NULL COMMENT '产品条码',
  `product_name` varchar(255) DEFAULT NULL,
  `validity_time` timestamp NULL DEFAULT NULL COMMENT '有效期',
  `manufacture_time` timestamp NULL DEFAULT NULL COMMENT '生产日期',
  `product_code` varchar(255) DEFAULT NULL,
  `product_id` int(11) DEFAULT NULL,
  `dealer_id` int(11) DEFAULT NULL,
  `ck_type` tinyint(4) DEFAULT NULL COMMENT '出货方式1按单出货 2快速出货 3已入库商品出货',
  `scan_type` tinyint(4) DEFAULT NULL COMMENT '扫码方式 1单码扫描 2流水区间',
  `order_start` varchar(255) DEFAULT NULL,
  `order_end` varchar(255) DEFAULT NULL,
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `is_return` tinyint(4) DEFAULT '0' COMMENT '是否退货 0正常 1已退货',
  `update_time` timestamp NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=97 DEFAULT CHARSET=utf8mb4;

-- ----------------------------
--  Records of `ctc_dealer_logistics_ck_code`
-- ----------------------------
BEGIN;
INSERT INTO `ctc_dealer_logistics_ck_code` VALUES ('93', '0000000001', '1', null, '202204031648961618', '1', '100', 'CH2022040454102501', '1kg', '个', '00000001', '赵县鸭梨', '2022-05-04 00:00:00', '2022-04-04 00:00:00', '000001', '3', '23', '2', '1', '1', '1', '2022-04-04 13:17:55', '0', null), ('94', '2047920518', '2', null, '202204031648961618', '1', '100', 'CH2022040454102501', '1kg', '个', '00000001', '赵县鸭梨', '2022-05-04 00:00:00', '2022-04-04 00:00:00', '000001', '3', '23', '2', '1', '2', '2', '2022-04-04 13:18:07', '0', null), ('95', '4392201395', '3', null, '202204031648961618', '1', '100', 'CH2022040450981024', '245', '25', '210', '254', '2022-04-04 00:00:00', '2022-04-04 00:00:00', '563', '2', '23', '2', '1', '3', '3', '2022-04-04 13:20:16', '0', null), ('96', '2920342390', '5', null, '202204031648961618', '1', '100', 'CH2022040410199525', '1kg', '个', '00000001', '赵县鸭梨', '2022-05-04 00:00:00', '2022-04-04 00:00:00', '000001', '3', '23', '3', '1', '5', '5', '2022-04-04 13:20:48', '0', '2022-04-04 13:22:40');
COMMIT;

-- ----------------------------
--  Table structure for `ctc_dealer_logistics_ck_order`
-- ----------------------------
DROP TABLE IF EXISTS `ctc_dealer_logistics_ck_order`;
CREATE TABLE `ctc_dealer_logistics_ck_order` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `ck_order` varchar(255) DEFAULT NULL COMMENT '发货单号',
  `customer_type` varchar(255) DEFAULT NULL COMMENT '门店或者经销商',
  `dealer_id` int(11) DEFAULT NULL,
  `customer_id` int(11) DEFAULT NULL COMMENT '客户id',
  `customer_code` varchar(255) DEFAULT NULL COMMENT '客户编码',
  `customer_name` varchar(255) DEFAULT NULL COMMENT '客户姓名',
  `warehouse_id` int(11) DEFAULT NULL COMMENT '出库仓库',
  `is_gift` tinyint(4) DEFAULT '0' COMMENT '是否赠品1赠品 0非赠品',
  `out_time` timestamp NULL DEFAULT NULL COMMENT '出货时间',
  `address` varchar(255) DEFAULT NULL COMMENT '发货地址',
  `remark` varchar(255) DEFAULT NULL COMMENT '备注',
  `outwarehouse_products` text COMMENT '发货商品信息',
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '出货时间',
  `online_order` varchar(255) DEFAULT NULL COMMENT '在线订单单号',
  `status` tinyint(4) DEFAULT '0' COMMENT '状态0未发货',
  `product_batch` varchar(255) DEFAULT NULL COMMENT '生产批次号',
  `send_sum` int(11) DEFAULT '0' COMMENT '实际发货数量',
  `deliver_sum` int(11) DEFAULT '0' COMMENT '应发货总数量',
  `ck_type` tinyint(4) DEFAULT NULL COMMENT '出货方式1按单出货 2快速出货 3已入库商品出货',
  `order_type` tinyint(4) DEFAULT '0' COMMENT '发货单类型 1自建发货单 2在线订单发货 3客户自助',
  `is_del` tinyint(4) DEFAULT '0' COMMENT '是否删除0正常 1删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=94 DEFAULT CHARSET=utf8mb4;

-- ----------------------------
--  Records of `ctc_dealer_logistics_ck_order`
-- ----------------------------
BEGIN;
INSERT INTO `ctc_dealer_logistics_ck_order` VALUES ('90', 'CH2022040454102501', 'distributor', '23', '3', '6.', '63', '2', '1', null, null, null, '[{\"product_id\":3,\"product_name\":\"\\u8d75\\u53bf\\u9e2d\\u68a8\",\"barcode\":\"00000001\",\"unit\":\"\\u4e2a\",\"manufacture_time\":\"2022-04-04\",\"validity_time\":\"2022-05-04\",\"product_code\":\"000001\",\"specifications\":\"1kg\",\"out_num\":200,\"order_num\":200}]', '2022-04-04 13:17:55', null, '0', null, '200', '200', '2', '0', '0'), ('92', 'CH2022040450981024', 'distributor', '23', '3', '6.', '63', '2', '1', null, null, null, '[{\"product_id\":2,\"product_name\":\"254\",\"barcode\":\"210\",\"unit\":\"25\",\"manufacture_time\":\"2022-04-04\",\"validity_time\":\"2022-04-04\",\"product_code\":\"563\",\"specifications\":\"245\",\"out_num\":100,\"order_num\":100}]', '2022-04-04 13:20:16', null, '0', null, '100', '100', '2', '0', '0'), ('93', 'CH2022040410199525', 'distributor', '23', '3', '6.', '63', '2', '0', null, null, null, '[{\"product_id\":3,\"product_name\":\"\\u8d75\\u53bf\\u9e2d\\u68a8\",\"barcode\":\"00000001\",\"unit\":\"\\u4e2a\",\"product_code\":\"000001\",\"specifications\":\"1kg\",\"out_num\":100,\"order_num\":100}]', '2022-04-04 13:22:40', null, '0', null, '100', '100', '3', '0', '0');
COMMIT;

-- ----------------------------
--  Table structure for `ctc_dealer_logistics_dc_order`
-- ----------------------------
DROP TABLE IF EXISTS `ctc_dealer_logistics_dc_order`;
CREATE TABLE `ctc_dealer_logistics_dc_order` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `dc_order` varchar(255) DEFAULT NULL COMMENT '发货单号',
  `out_warehouse_id` int(11) DEFAULT NULL COMMENT '调出仓库',
  `dealer_id` int(11) DEFAULT NULL,
  `in_warehouse_id` int(11) DEFAULT NULL COMMENT '调入仓库',
  `remark` varchar(255) DEFAULT NULL COMMENT '备注',
  `dc_products` text COMMENT '发货商品信息',
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '调仓时间',
  `is_del` tinyint(4) DEFAULT '0' COMMENT '是否删除0正常 1删除',
  `create_by` varchar(255) DEFAULT NULL,
  `order_num` int(11) DEFAULT NULL COMMENT '订单数量',
  `transfer_num` int(11) DEFAULT NULL COMMENT '已调仓总数量',
  `status` tinyint(4) DEFAULT '0' COMMENT '调仓状态',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4;

-- ----------------------------
--  Records of `ctc_dealer_logistics_dc_order`
-- ----------------------------
BEGIN;
INSERT INTO `ctc_dealer_logistics_dc_order` VALUES ('1', 'DC2022040510050535', '2', '23', '3', '45544', '[{\"product_name\":\"\\u8d75\\u53bf\\u9e2d\\u68a8\",\"product_code\":\"000001\",\"unit\":\"\\u4e2a\",\"product_id\":3,\"barcode\":\"00000001\",\"specifications\":\"1kg\",\"dc_num\":0,\"order_num\":\"110\"},{\"product_name\":\"254\",\"product_code\":\"563\",\"unit\":\"25\",\"product_id\":2,\"barcode\":\"210\",\"specifications\":\"245\",\"dc_num\":0,\"order_num\":\"20\"}]', '2022-04-05 01:42:36', '1', 'wenhan', '130', '0', '0'), ('2', 'DC2022040551984852', '2', '23', '3', '544', '[{\"product_name\":\"\\u8d75\\u53bf\\u9e2d\\u68a8\",\"product_code\":\"000001\",\"unit\":\"\\u4e2a\",\"product_id\":3,\"barcode\":\"00000001\",\"specifications\":\"1kg\",\"dc_num\":0,\"order_num\":\"44\"}]', '2022-04-05 02:15:10', '0', 'wenhan', '44', '0', '0');
COMMIT;

-- ----------------------------
--  Table structure for `ctc_dealer_logistics_rk_code`
-- ----------------------------
DROP TABLE IF EXISTS `ctc_dealer_logistics_rk_code`;
CREATE TABLE `ctc_dealer_logistics_rk_code` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `code` varchar(255) DEFAULT NULL COMMENT '入库码',
  `serial_number` varchar(255) DEFAULT NULL COMMENT '码对应的序号',
  `product_batch` varchar(255) DEFAULT NULL COMMENT '生产批次',
  `batch` varchar(255) DEFAULT NULL COMMENT '码批次',
  `code_type` tinyint(4) DEFAULT NULL COMMENT '标签类型 1大标 2小标',
  `rk_num` int(11) DEFAULT NULL COMMENT '入库数量 为了统计用',
  `rk_order` varchar(255) DEFAULT NULL COMMENT '入库单',
  `product_id` int(11) DEFAULT NULL,
  `barcode` varchar(255) DEFAULT NULL COMMENT '产品条码',
  `product_code` varchar(255) DEFAULT NULL COMMENT '产品编码',
  `unit` varchar(255) DEFAULT NULL COMMENT '产品单位',
  `specifications` varchar(255) DEFAULT NULL COMMENT '产品规格',
  `product_name` varchar(255) DEFAULT NULL COMMENT '产品名称',
  `dealer_id` int(11) DEFAULT NULL,
  `scan_type` tinyint(4) DEFAULT NULL COMMENT '扫码方式 1单码扫描 2流水区间',
  `order_start` varchar(255) DEFAULT NULL,
  `order_end` varchar(255) DEFAULT NULL,
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=214 DEFAULT CHARSET=utf8mb4;

-- ----------------------------
--  Records of `ctc_dealer_logistics_rk_code`
-- ----------------------------
BEGIN;
INSERT INTO `ctc_dealer_logistics_rk_code` VALUES ('209', '0000000001', '1', null, '202204031648961618', '1', '100', 'RK2022040454102489', '3', '00000001', '000001', '个', '1kg', '赵县鸭梨', '23', '1', '1', '1', '2022-04-04 13:17:55'), ('210', '2047920518', '2', null, '202204031648961618', '1', '100', 'RK2022040454102489', '3', '00000001', '000001', '个', '1kg', '赵县鸭梨', '23', '1', '2', '2', '2022-04-04 13:18:07'), ('212', '4392201395', '3', null, '202204031648961618', '1', '100', 'RK2022040450102499', '2', '210', '563', '25', '245', '254', '23', '1', '3', '3', '2022-04-04 13:20:16'), ('213', '2920342390', '5', null, '202204031648961618', '1', '100', 'RK2022040451499751', '3', '00000001', '000001', '个', '1kg', '赵县鸭梨', '23', '1', '5', '5', '2022-04-04 13:20:48');
COMMIT;

-- ----------------------------
--  Table structure for `ctc_dealer_logistics_rk_order`
-- ----------------------------
DROP TABLE IF EXISTS `ctc_dealer_logistics_rk_order`;
CREATE TABLE `ctc_dealer_logistics_rk_order` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `rk_order` varchar(255) DEFAULT NULL COMMENT '入库单号',
  `self_order` varchar(255) DEFAULT NULL COMMENT '自定义单号',
  `unit` varchar(255) DEFAULT NULL COMMENT '单位',
  `barcode` varchar(255) DEFAULT NULL COMMENT '条码',
  `specifications` varchar(255) DEFAULT NULL COMMENT '规格',
  `product_name` varchar(255) DEFAULT NULL,
  `product_code` varchar(255) DEFAULT NULL COMMENT '产品编号',
  `product_id` int(11) DEFAULT NULL,
  `product_batch` varchar(255) DEFAULT NULL COMMENT '生产批次号',
  `rk_num` int(11) DEFAULT '0' COMMENT '实际入库数量',
  `quantity` varchar(255) DEFAULT '0' COMMENT '计划入库数量',
  `manufacture_time` varchar(255) DEFAULT NULL COMMENT '生产日期',
  `validity_time` varchar(255) DEFAULT NULL COMMENT '有效期至',
  `warehouse_id` int(11) DEFAULT NULL COMMENT '入库仓库',
  `dealer_id` int(11) DEFAULT NULL,
  `status` tinyint(4) DEFAULT '0' COMMENT '入库单状态 0正常 1删除',
  `remark` varchar(255) DEFAULT NULL,
  `create_order_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '建单日期',
  `scan_type` tinyint(4) DEFAULT NULL COMMENT '入库扫描 扫码方式 1单码扫描 2流水区间',
  `rk_type` tinyint(4) DEFAULT '1' COMMENT '入库方式1直接添加 2入库扫描',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=201 DEFAULT CHARSET=utf8mb4;

-- ----------------------------
--  Records of `ctc_dealer_logistics_rk_order`
-- ----------------------------
BEGIN;
INSERT INTO `ctc_dealer_logistics_rk_order` VALUES ('197', 'RK2022040454102489', null, '个', '00000001', '1kg', '赵县鸭梨', '000001', '3', null, '200', '200', '2022-04-04', '2022-05-04', '2', '23', '0', null, '2022-04-04 13:17:55', null, '1'), ('199', 'RK2022040450102499', null, '25', '210', '245', '254', '563', '2', null, '100', '100', '2022-04-04', '2022-04-04', '2', '23', '0', null, '2022-04-04 13:20:16', null, '1'), ('200', 'RK2022040451499751', null, '个', '00000001', '1kg', '赵县鸭梨', '000001', '3', null, '100', '100', '2022-04-04', '2022-05-04', '2', '23', '0', null, '2022-04-04 13:20:48', null, '1');
COMMIT;

-- ----------------------------
--  Table structure for `ctc_dealer_logistics_th_code`
-- ----------------------------
DROP TABLE IF EXISTS `ctc_dealer_logistics_th_code`;
CREATE TABLE `ctc_dealer_logistics_th_code` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `code` varchar(255) DEFAULT NULL COMMENT '入库码',
  `serial_number` varchar(255) DEFAULT NULL COMMENT '码对应的序号',
  `product_batch` varchar(255) DEFAULT NULL COMMENT '生产批次',
  `batch` varchar(255) DEFAULT NULL COMMENT '码批次',
  `code_type` tinyint(4) DEFAULT NULL COMMENT '标签类型 1大标 2小标',
  `th_num` int(11) DEFAULT NULL COMMENT '入库数量 为了统计用',
  `th_order` varchar(255) DEFAULT NULL COMMENT '入库单',
  `product_id` int(11) DEFAULT NULL,
  `dealer_id` int(11) DEFAULT NULL,
  `order_start` varchar(255) DEFAULT NULL,
  `order_end` varchar(255) DEFAULT NULL,
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=40 DEFAULT CHARSET=utf8mb4;

-- ----------------------------
--  Records of `ctc_dealer_logistics_th_code`
-- ----------------------------
BEGIN;
INSERT INTO `ctc_dealer_logistics_th_code` VALUES ('39', '2920342390', '5', null, '202204031648961618', '1', '100', 'TH2022040410210155', '3', '23', '5', '5', '2022-04-04 13:21:43');
COMMIT;

-- ----------------------------
--  Table structure for `ctc_dealer_logistics_th_order`
-- ----------------------------
DROP TABLE IF EXISTS `ctc_dealer_logistics_th_order`;
CREATE TABLE `ctc_dealer_logistics_th_order` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `th_order` varchar(255) DEFAULT NULL COMMENT '退货单',
  `express_order` varchar(255) DEFAULT NULL COMMENT '快递单号',
  `return_time` timestamp NULL DEFAULT NULL COMMENT '退货日期',
  `return_sub` varchar(255) DEFAULT NULL COMMENT '退往单位',
  `customer_id` int(11) DEFAULT NULL COMMENT '客户id',
  `customer_code` varchar(255) DEFAULT NULL,
  `customer_name` varchar(255) DEFAULT NULL,
  `return_warehouse_id` int(11) DEFAULT NULL COMMENT '退往仓库',
  `check_status` tinyint(4) DEFAULT '0' COMMENT '审核状态0未审核 1审核通过 2审核不通过',
  `th_sum` int(11) DEFAULT NULL COMMENT '退货总数',
  `product_batch` varchar(255) DEFAULT NULL,
  `is_gift` tinyint(4) DEFAULT '0' COMMENT '是否赠品',
  `validity_time` timestamp NULL DEFAULT NULL COMMENT '有效期至',
  `dealer_id` int(11) DEFAULT NULL,
  `is_fleeing_goods` int(11) DEFAULT '0' COMMENT '是否窜货0否 1是',
  `is_del` varchar(255) DEFAULT '0' COMMENT '是否删除0正常 1删除',
  `return_products` text COMMENT '退货商品',
  `customer_type` varchar(255) DEFAULT NULL,
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '建单日期',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=36 DEFAULT CHARSET=utf8mb4;

-- ----------------------------
--  Records of `ctc_dealer_logistics_th_order`
-- ----------------------------
BEGIN;
INSERT INTO `ctc_dealer_logistics_th_order` VALUES ('35', 'TH2022040410210155', null, '2022-04-04 13:21:03', null, '2', '578', '87', '2', '1', '100', null, '1', null, '23', '0', '0', '[{\"product_id\":3,\"product_code\":\"000001\",\"product_name\":\"\\u8d75\\u53bf\\u9e2d\\u68a8\",\"barcode\":\"00000001\",\"unit\":\"\\u4e2a\",\"specifications\":\"1kg\",\"return_num\":100}]', 'distributor', '2022-04-04 13:21:43');
COMMIT;

-- ----------------------------
--  Table structure for `ctc_dealer_logistics_warehouse`
-- ----------------------------
DROP TABLE IF EXISTS `ctc_dealer_logistics_warehouse`;
CREATE TABLE `ctc_dealer_logistics_warehouse` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `warehouse_name` varchar(255) DEFAULT NULL,
  `code` varchar(255) DEFAULT NULL,
  `address` varchar(255) DEFAULT NULL,
  `person` varchar(255) DEFAULT NULL,
  `dealer_id` int(11) DEFAULT NULL,
  `remark` varchar(255) DEFAULT NULL,
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4;

-- ----------------------------
--  Records of `ctc_dealer_logistics_warehouse`
-- ----------------------------
BEGIN;
INSERT INTO `ctc_dealer_logistics_warehouse` VALUES ('2', 'ht454', 'gfh', 'ht', 'ht', '23', 'yht', '2022-03-17 20:49:15'), ('3', '22', '2', '2', '22', '23', '22', '2022-03-17 23:57:59');
COMMIT;

-- ----------------------------
--  Table structure for `ctc_dealer_mall_distribution_rule`
-- ----------------------------
DROP TABLE IF EXISTS `ctc_dealer_mall_distribution_rule`;
CREATE TABLE `ctc_dealer_mall_distribution_rule` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `is_distribution` tinyint(4) DEFAULT '0' COMMENT '是否开启分销 0否 1是',
  `is_self` tinyint(4) DEFAULT '1' COMMENT '分销员参与佣金1是 0否',
  `cash_max` decimal(8,2) DEFAULT '0.00' COMMENT '最低提现额度',
  `recruit_type` tinyint(4) DEFAULT '0' COMMENT '分销员招募方式 0不开启',
  `distributor_name` varchar(255) DEFAULT NULL COMMENT '分销员别名',
  `page_title` varchar(255) DEFAULT NULL COMMENT '页面标题',
  `page_bk` varchar(255) DEFAULT NULL COMMENT '背景图片',
  `rules` text,
  `dealer_id` int(11) DEFAULT NULL,
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4;

-- ----------------------------
--  Records of `ctc_dealer_mall_distribution_rule`
-- ----------------------------
BEGIN;
INSERT INTO `ctc_dealer_mall_distribution_rule` VALUES ('4', '0', '0', '0.00', '0', '分销员', '', 'https://cdn.icloudapi.cn/fenxiao.png', '<h3>一、推广方式</h3><p>1、推广海报：分销员A可生成推广海报（在我是分销员中生成）并推荐给好友B，好友B识别推广海报上的二维码即与分销员A绑定关系，绑定关系后B消费A即可获取一级佣金；若B又发展了C，则B成为A的一级，C为A的二级，C消费后A可获取二级佣金。</p><p>2、每个消费者只能和一个分销员绑定关系，一旦绑定关系后不会再与其他分销员绑定关系（识别海报上的二维码即绑定关系）。</p><p><br></p><h3>二、佣金规则</h3><p>1、订单最多支持一级返佣、二级返佣，以商家设置为准。商家关闭微分销功能后，分销员不再获取佣金；</p><p>2、佣金比例、金额以商家设置为准，不同商品可能佣金比例、金额可能会不一样。</p><p>3、佣金计算基数以商品实际成交金额为准，若订单参与折扣、促销、优惠券等活动，则系统会自动计算每个商品的实际成交金额并按照实际佣金设置发放佣金。</p><p>4、退款订单不参与分佣。</p>', '23', '2022-03-10 18:15:01');
COMMIT;

-- ----------------------------
--  Table structure for `ctc_dealer_mall_distributor_page`
-- ----------------------------
DROP TABLE IF EXISTS `ctc_dealer_mall_distributor_page`;
CREATE TABLE `ctc_dealer_mall_distributor_page` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `bk_img` varchar(255) DEFAULT NULL,
  `head_style` varchar(255) DEFAULT NULL COMMENT '头像样式 1正方形 2圆角',
  `font_size` varchar(255) DEFAULT NULL,
  `font_color` varchar(255) DEFAULT NULL,
  `dealer_id` int(11) DEFAULT NULL,
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4;

-- ----------------------------
--  Records of `ctc_dealer_mall_distributor_page`
-- ----------------------------
BEGIN;
INSERT INTO `ctc_dealer_mall_distributor_page` VALUES ('1', 'https://cdn.icloudapi.cn/1f7f9202111210005305574.jpg', '2', '16', '#E10B0B', '23', '2022-03-10 20:36:30');
COMMIT;

-- ----------------------------
--  Table structure for `ctc_dealer_mall_fenxiao_cash`
-- ----------------------------
DROP TABLE IF EXISTS `ctc_dealer_mall_fenxiao_cash`;
CREATE TABLE `ctc_dealer_mall_fenxiao_cash` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `member_id` int(11) DEFAULT NULL COMMENT '提现人',
  `cash_fee` decimal(8,2) DEFAULT NULL,
  `order_id` varchar(255) DEFAULT NULL COMMENT '提现单号',
  `reason` varchar(255) DEFAULT NULL COMMENT '审核不通过原因',
  `account` varchar(255) DEFAULT NULL COMMENT '提现账号',
  `dealer_id` int(11) DEFAULT NULL,
  `status` varchar(255) DEFAULT '1' COMMENT '状态',
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4;

-- ----------------------------
--  Records of `ctc_dealer_mall_fenxiao_cash`
-- ----------------------------
BEGIN;
INSERT INTO `ctc_dealer_mall_fenxiao_cash` VALUES ('1', '1', '2.00', '1', 'dsda', '2', '23', '3', '2022-03-11 17:12:42');
COMMIT;

-- ----------------------------
--  Table structure for `ctc_dealer_mall_fenxiao_order`
-- ----------------------------
DROP TABLE IF EXISTS `ctc_dealer_mall_fenxiao_order`;
CREATE TABLE `ctc_dealer_mall_fenxiao_order` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `order_id` varchar(255) DEFAULT NULL COMMENT '订单号',
  `goods_id` int(11) DEFAULT NULL,
  `goods_name` varchar(255) DEFAULT NULL,
  `total_fee` decimal(8,2) DEFAULT NULL COMMENT '订单金额',
  `commission_one` decimal(8,2) DEFAULT '0.00' COMMENT '一级佣金',
  `commission_two` decimal(8,2) DEFAULT '0.00' COMMENT '二级佣金',
  `status` tinyint(4) DEFAULT '0' COMMENT '订单状态（-1 : 申请退款 -2 : 退货成功 0：待发货；1：待收货；2：已收货；3：待评价；-1：已退款）',
  `dealer_id` int(11) DEFAULT NULL,
  `member_id` int(11) DEFAULT NULL,
  `nickname` varchar(255) DEFAULT NULL,
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
--  Table structure for `ctc_dealer_mall_fenxiaoyuan`
-- ----------------------------
DROP TABLE IF EXISTS `ctc_dealer_mall_fenxiaoyuan`;
CREATE TABLE `ctc_dealer_mall_fenxiaoyuan` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `member_id` int(11) DEFAULT NULL,
  `dealer_id` int(11) DEFAULT NULL,
  `parent_id` int(11) DEFAULT '0' COMMENT '上级成员id',
  `grandpa_id` int(11) DEFAULT '0' COMMENT '最高级',
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4;

-- ----------------------------
--  Records of `ctc_dealer_mall_fenxiaoyuan`
-- ----------------------------
BEGIN;
INSERT INTO `ctc_dealer_mall_fenxiaoyuan` VALUES ('1', '1', '23', '0', '0', '2022-03-10 21:55:41');
COMMIT;

-- ----------------------------
--  Table structure for `ctc_dealer_mall_goods`
-- ----------------------------
DROP TABLE IF EXISTS `ctc_dealer_mall_goods`;
CREATE TABLE `ctc_dealer_mall_goods` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `code` varchar(255) DEFAULT NULL COMMENT '编号',
  `goods_name` varchar(255) DEFAULT NULL,
  `cover` varchar(255) DEFAULT NULL,
  `sale_price` decimal(8,2) DEFAULT NULL COMMENT '商品价格',
  `original_price` decimal(8,2) DEFAULT NULL COMMENT '划线价',
  `score` decimal(8,2) DEFAULT NULL COMMENT '积分',
  `sales` int(11) DEFAULT NULL COMMENT '销量',
  `commission_type` varchar(255) DEFAULT '0' COMMENT '佣金计算方式 0按百分比 1按金额',
  `distribution_one` varchar(255) DEFAULT NULL COMMENT '一级分销比例',
  `freight_id` int(11) DEFAULT NULL,
  `class_two` varchar(255) DEFAULT NULL,
  `class_one` varchar(255) DEFAULT NULL,
  `distribution_two` varchar(255) DEFAULT NULL COMMENT '二级分销比例',
  `details` text,
  `dealer_id` int(11) DEFAULT NULL,
  `is_del` tinyint(4) DEFAULT '0' COMMENT '是否删除',
  `is_cut` tinyint(4) DEFAULT '1' COMMENT '是否下架1正常 2下架',
  `product_id` int(11) DEFAULT NULL,
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4;

-- ----------------------------
--  Records of `ctc_dealer_mall_goods`
-- ----------------------------
BEGIN;
INSERT INTO `ctc_dealer_mall_goods` VALUES ('1', '44', '赵县鸭梨', '[{\"url\":\"https:\\/\\/cdn.icloudapi.cn\\/32d17202202100852475252.jpeg\",\"name\":\"32d17202202100852475252.jpeg\"}]', '15.00', '10.00', '20.00', '0', '0', null, '7', '2', '1', null, '<p>	<span style=\"color: rgb(51, 51, 51); background-color: rgb(255, 255, 255);\">鸭梨，是一种</span>	<a href=\"https://baike.baidu.com/item/%E7%99%BD%E6%A2%A8/80109\" rel=\"noopener noreferrer\" target=\"_blank\" style=\"color: rgb(19, 110, 194); background-color: rgb(255, 255, 255);\">白梨</a>	<span style=\"color: rgb(51, 51, 51); background-color: rgb(255, 255, 255);\">，为</span>	<a href=\"https://baike.baidu.com/item/%E6%B2%B3%E5%8C%97/65777\" rel=\"noopener noreferrer\" target=\"_blank\" style=\"color: rgb(19, 110, 194); background-color: rgb(255, 255, 255);\">河北</a>	<span style=\"color: rgb(51, 51, 51); background-color: rgb(255, 255, 255);\">省魏县古老地方品种。因梨梗部突起，状似鸭头而得名。鸭梨适应性强，丰产性好，果实大而美，肉质细脆多汁，香甜，较耐贮。适宜在</span>	<a href=\"https://baike.baidu.com/item/%E9%BB%84%E6%B7%AE%E6%B5%B7%E5%B9%B3%E5%8E%9F/7580257\" rel=\"noopener noreferrer\" target=\"_blank\" style=\"color: rgb(19, 110, 194); background-color: rgb(255, 255, 255);\">黄淮海平原</a>	<span style=\"color: rgb(51, 51, 51); background-color: rgb(255, 255, 255);\">沙地栽培。另外鸭状梨在白梨、沙梨、青梨中均有，但主要是指白梨，因此也称之为白梨。</span></p><p><span style=\"color: rgb(51, 51, 51); background-color: rgb(255, 255, 255);\">﻿</span><img src=\"http://localhost/static/mainImgs/20220210/05547a1e8ad8468c900c0943b30be3e7.jpeg\"></p>', '23', '0', '1', '3', '2022-03-09 23:24:57', '2022-03-10 00:58:48');
COMMIT;

-- ----------------------------
--  Table structure for `ctc_dealer_mall_goods_type`
-- ----------------------------
DROP TABLE IF EXISTS `ctc_dealer_mall_goods_type`;
CREATE TABLE `ctc_dealer_mall_goods_type` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `class_name` varchar(255) DEFAULT NULL,
  `parent_id` int(11) DEFAULT '0',
  `order` int(11) DEFAULT NULL,
  `cover` varchar(255) DEFAULT NULL COMMENT '封面',
  `dealer_id` int(11) DEFAULT NULL,
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4;

-- ----------------------------
--  Records of `ctc_dealer_mall_goods_type`
-- ----------------------------
BEGIN;
INSERT INTO `ctc_dealer_mall_goods_type` VALUES ('1', '7857', '0', '5', null, '23', '2022-03-09 17:40:37'), ('2', '555', '1', '4', 'https://cdn.icloudapi.cn/2744b202202100858394833.jpeg', '23', '2022-03-09 17:41:17'), ('3', '商品分类', '0', '1', '', '23', '2022-03-09 21:59:00');
COMMIT;

-- ----------------------------
--  Table structure for `ctc_dealer_mall_judge`
-- ----------------------------
DROP TABLE IF EXISTS `ctc_dealer_mall_judge`;
CREATE TABLE `ctc_dealer_mall_judge` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `goods_id` int(11) DEFAULT NULL,
  `member_id` int(11) DEFAULT NULL,
  `content` text,
  `dealer_id` int(11) DEFAULT NULL,
  `status` tinyint(4) DEFAULT '0' COMMENT '状态 0未审核 1已审核',
  `pic` text,
  `replay_content` text,
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
--  Table structure for `ctc_dealer_mall_order`
-- ----------------------------
DROP TABLE IF EXISTS `ctc_dealer_mall_order`;
CREATE TABLE `ctc_dealer_mall_order` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '订单ID',
  `order_id` varchar(32) NOT NULL COMMENT '订单号',
  `dealer_id` int(11) DEFAULT NULL COMMENT '归属',
  `member_id` int(11) unsigned NOT NULL COMMENT '用户id',
  `real_name` varchar(32) NOT NULL COMMENT '用户姓名',
  `user_phone` varchar(18) NOT NULL COMMENT '用户电话',
  `user_address` varchar(100) NOT NULL COMMENT '详细地址',
  `cart_id` varchar(256) NOT NULL DEFAULT '[]' COMMENT '购物车id',
  `total_num` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '订单商品总数',
  `total_price` decimal(8,2) unsigned NOT NULL DEFAULT '0.00' COMMENT '订单总价',
  `total_postage` decimal(8,2) unsigned NOT NULL DEFAULT '0.00' COMMENT '邮费',
  `pay_price` decimal(8,2) unsigned NOT NULL DEFAULT '0.00' COMMENT '实际支付金额',
  `pay_postage` decimal(8,2) unsigned NOT NULL DEFAULT '0.00' COMMENT '支付邮费',
  `deduction_price` decimal(8,2) unsigned NOT NULL DEFAULT '0.00' COMMENT '抵扣金额',
  `coupon_id` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '优惠券id',
  `coupon_price` decimal(8,2) unsigned NOT NULL DEFAULT '0.00' COMMENT '优惠券金额',
  `paid` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '支付状态',
  `pay_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '支付时间',
  `pay_type` varchar(32) NOT NULL COMMENT '支付方式',
  `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `status` tinyint(1) NOT NULL DEFAULT '0' COMMENT '订单状态（-1 : 申请退款 -2 : 退货成功 0：待发货；1：待收货；2：已收货；3：待评价；3：已退款）',
  `refund_status` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '0 未退款 1 申请中 2 已退款',
  `refund_reason_wap_img` varchar(255) DEFAULT NULL COMMENT '退款图片',
  `refund_reason_wap_explain` varchar(255) DEFAULT NULL COMMENT '退款用户说明',
  `refund_reason_time` int(11) unsigned DEFAULT NULL COMMENT '退款时间',
  `refund_reason_wap` varchar(255) DEFAULT NULL COMMENT '前台退款原因',
  `refund_reason` varchar(255) DEFAULT NULL COMMENT '不退款的理由',
  `refund_price` decimal(8,2) unsigned NOT NULL DEFAULT '0.00' COMMENT '退款金额',
  `delivery_name` varchar(64) DEFAULT NULL COMMENT '快递名称/送货人姓名',
  `delivery_type` varchar(32) DEFAULT NULL COMMENT '发货类型',
  `delivery_id` varchar(64) DEFAULT NULL COMMENT '快递单号/手机号',
  `gain_integral` decimal(8,2) unsigned NOT NULL DEFAULT '0.00' COMMENT '消费赚取积分',
  `use_integral` decimal(8,2) unsigned NOT NULL DEFAULT '0.00' COMMENT '使用积分',
  `back_integral` decimal(8,2) unsigned DEFAULT NULL COMMENT '给用户退了多少积分',
  `mark` varchar(512) NOT NULL COMMENT '备注',
  `is_del` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '是否删除',
  `unique` char(32) NOT NULL COMMENT '唯一id(md5加密)类似id',
  `remark` varchar(512) DEFAULT NULL COMMENT '管理员备注',
  `mer_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '商户ID',
  `is_mer_check` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `combination_id` int(11) unsigned DEFAULT '0' COMMENT '拼团产品id0一般产品',
  `pink_id` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '拼团id 0没有拼团',
  `cost` decimal(8,2) unsigned NOT NULL COMMENT '成本价',
  `seckill_id` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '秒杀产品ID',
  `bargain_id` int(11) unsigned DEFAULT '0' COMMENT '砍价id',
  `is_channel` tinyint(1) unsigned DEFAULT '0' COMMENT '支付渠道(0微信公众号1微信小程序)',
  `is_system_del` tinyint(1) NOT NULL DEFAULT '0' COMMENT '后台管理员删除',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `order_id_2` (`order_id`,`member_id`) USING BTREE,
  UNIQUE KEY `unique` (`unique`) USING BTREE,
  KEY `uid` (`member_id`) USING BTREE,
  KEY `add_time` (`create_time`) USING BTREE,
  KEY `pay_price` (`pay_price`) USING BTREE,
  KEY `paid` (`paid`) USING BTREE,
  KEY `pay_time` (`pay_time`) USING BTREE,
  KEY `pay_type` (`pay_type`) USING BTREE,
  KEY `status` (`status`) USING BTREE,
  KEY `is_del` (`is_del`) USING BTREE,
  KEY `coupon_id` (`coupon_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT COMMENT='订单表';

-- ----------------------------
--  Table structure for `ctc_dealer_mall_template`
-- ----------------------------
DROP TABLE IF EXISTS `ctc_dealer_mall_template`;
CREATE TABLE `ctc_dealer_mall_template` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `share_title` varchar(255) DEFAULT NULL,
  `share_text` varchar(255) DEFAULT NULL,
  `share_img` varchar(255) DEFAULT NULL,
  `page_title` varchar(255) DEFAULT NULL,
  `page_content` text,
  `dealer_id` int(11) DEFAULT NULL,
  `status` tinyint(4) DEFAULT '0' COMMENT '状态0正常 1删除',
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4;

-- ----------------------------
--  Records of `ctc_dealer_mall_template`
-- ----------------------------
BEGIN;
INSERT INTO `ctc_dealer_mall_template` VALUES ('2', '微商城', '我正在看微商城，挺不错的，你也来看看吧。', '###', '微商城', '[{\"type\":\"line\",\"height\":20},{\"type\":\"search\",\"text\":\"\\u641c\\u7d22\\u5e97\\u94fa\\u5185\\u5546\\u54c1\",\"height\":60},{\"type\":\"line\",\"height\":20},{\"type\":\"banner\",\"imgList\":[{\"url\":\"\\/static\\/img\\/wsc-default.ba6454f6.png\",\"link\":\"\"}],\"height\":152},{\"type\":\"line\",\"height\":20},{\"type\":\"nav\",\"content\":[{\"url\":\"\\/static\\/img\\/nav-1-icon@2x.76794824.png\",\"text\":\"\\u5168\\u90e8\\u5546\\u54c1\",\"is_show\":1},{\"url\":\"\\/static\\/img\\/sel_products_icon@2x.445327ba.png\",\"text\":\"\\u5546\\u54c1\\u5206\\u7c7b\",\"is_show\":1},{\"url\":\"\\/static\\/img\\/cart_icon(1).d2df650a.png\",\"text\":\"\\u8d2d\\u7269\\u8f66\",\"is_show\":1},{\"url\":\"\\/static\\/img\\/nav-2-icon@2x.761261e4.png\",\"text\":\"\\u4e2a\\u4eba\\u4e2d\\u5fc3\",\"is_show\":1}]},{\"type\":\"line\",\"height\":20},{\"type\":\"recom\",\"text\":\"\\u4ea7\\u54c1\\u63a8\\u8350\",\"url\":\"\",\"product_title\":\"\\u6d4b\\u8bd5\",\"product_sale\":90,\"product_price\":100,\"recom_rule\":1},{\"type\":\"line\",\"height\":20},{\"type\":\"notice\",\"text\":\"ssadsadsadsada\"},{\"type\":\"custom\",\"text\":\"<h1>\\u8fd9\\u662f\\u4e00\\u4e2ah1\\u5143\\u7d20\\u5185\\u5bb9<\\/h1>\"},{\"type\":\"nav_title\",\"text\":\"\\u65b0\\u54c1\\u4e0a\\u67b6\"}]', '23', '0', '2022-03-12 00:19:35');
COMMIT;

-- ----------------------------
--  Table structure for `ctc_dealer_material_article`
-- ----------------------------
DROP TABLE IF EXISTS `ctc_dealer_material_article`;
CREATE TABLE `ctc_dealer_material_article` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `media_id` varchar(255) DEFAULT NULL,
  `title` varchar(255) DEFAULT NULL,
  `digest` varchar(255) DEFAULT NULL,
  `author` varchar(255) DEFAULT NULL,
  `cover` varchar(255) DEFAULT NULL,
  `thumb_media_id` varchar(255) DEFAULT NULL,
  `content` text,
  `dealer_id` int(11) DEFAULT NULL,
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `is_del` tinyint(4) DEFAULT '0' COMMENT '0正常 1删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4;

-- ----------------------------
--  Records of `ctc_dealer_material_article`
-- ----------------------------
BEGIN;
INSERT INTO `ctc_dealer_material_article` VALUES ('2', '{\"media_id\":\"8JDK-vD7NW6QiWjxMed7sTjoRx_aXYMO8BtxjRcGLPA\",\"item\":[]}', '测试图文', '这是个测试', 'wenhan', '20211118/735c8a15e21baee37b5f5df48f08c513.png', '8JDK-vD7NW6QiWjxMed7sbDSFn7-DwZFsDjoEbkMH_Q', '<p>测试啦</p><p><img src=\"http://localhost/static/mainImgs/20211119/2d7a5e9bb45da89f3d7335a1fad5f06e.png\"></p>', '23', '2021-11-19 13:12:40', '1'), ('3', '{\"media_id\":\"8JDK-vD7NW6QiWjxMed7sQxWidO_bk3Lg8tlQDE7iYQ\",\"item\":[]}', 'fsd', 'fsdf', 'fdsf', '20211119/f95815774c15a7fffdd8bda82ac4d434.png', '8JDK-vD7NW6QiWjxMed7sZG-IHJxOeL8t1LfVQYmOBw', '<p>dsfsdf</p>', '23', '2021-11-19 13:17:32', '1'), ('4', '8JDK-vD7NW6QiWjxMed7sWkIGR16cM0_sEHqeIdVJ64', '继续修改', 'w\'s\'d', '让我爸', '20211118/e910294f5e380659b6d5cace85df239e.png', '8JDK-vD7NW6QiWjxMed7sW3I51lYiR05i8ROKn5Ag0s', '<p>都是大V</p>', '23', '2021-11-19 15:17:46', '1');
COMMIT;

-- ----------------------------
--  Table structure for `ctc_dealer_material_group`
-- ----------------------------
DROP TABLE IF EXISTS `ctc_dealer_material_group`;
CREATE TABLE `ctc_dealer_material_group` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `group_name` varchar(255) DEFAULT NULL,
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `dealer_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4;

-- ----------------------------
--  Records of `ctc_dealer_material_group`
-- ----------------------------
BEGIN;
INSERT INTO `ctc_dealer_material_group` VALUES ('4', '54t5r', '2021-11-18 18:34:40', '23'), ('5', 'fds', '2021-11-18 18:35:11', '23'), ('6', '第三次', '2021-11-18 18:48:52', '23');
COMMIT;

-- ----------------------------
--  Table structure for `ctc_dealer_member`
-- ----------------------------
DROP TABLE IF EXISTS `ctc_dealer_member`;
CREATE TABLE `ctc_dealer_member` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `openid` varchar(255) DEFAULT NULL,
  `phone` varchar(255) DEFAULT NULL,
  `nickname` varchar(255) DEFAULT NULL,
  `username` varchar(255) DEFAULT NULL,
  `address` varchar(255) DEFAULT NULL,
  `birthday` varchar(255) DEFAULT NULL,
  `idcard` varchar(255) DEFAULT NULL COMMENT '身份证',
  `wechat` varchar(255) DEFAULT NULL COMMENT '微信号',
  `headimgurl` varchar(255) DEFAULT NULL,
  `sex` tinyint(4) DEFAULT NULL,
  `dealer_id` int(11) DEFAULT NULL,
  `sources` varchar(255) DEFAULT NULL COMMENT '来源渠道',
  `balance` varchar(255) DEFAULT NULL COMMENT '余额',
  `points` varchar(255) DEFAULT NULL COMMENT '积分',
  `tags` varchar(255) DEFAULT NULL COMMENT '用户标签',
  `remark` text COMMENT '备注',
  `create_time` datetime DEFAULT NULL COMMENT '头像',
  `status` tinyint(4) DEFAULT '0' COMMENT '会员状态 0正常 1拉黑',
  `follow_status` tinyint(4) DEFAULT '2' COMMENT '公众号关注状态 2未关注',
  `phone_status` tinyint(4) DEFAULT '2' COMMENT '手机认证状态 1已认证 2未认证',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4;

-- ----------------------------
--  Records of `ctc_dealer_member`
-- ----------------------------
BEGIN;
INSERT INTO `ctc_dealer_member` VALUES ('1', 'osnBC6OPadCdY77BfGZOaVhbgjak', '18330118047', '文寒', '文寒', '冰岛', '1', '111', '111', 'https://cdn.uviewui.com/uview/album/1.jpg', '1', '23', '1', '1', '7', '', '1', '2021-12-09 16:10:47', '1', '2', '2');
COMMIT;

-- ----------------------------
--  Table structure for `ctc_dealer_member_bill`
-- ----------------------------
DROP TABLE IF EXISTS `ctc_dealer_member_bill`;
CREATE TABLE `ctc_dealer_member_bill` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `member_id` int(11) DEFAULT NULL,
  `pm` tinyint(4) DEFAULT '1' COMMENT '积分状态 1获得 2支出',
  `app_id` int(11) DEFAULT NULL COMMENT '来源应用 字典翻译',
  `number` int(11) DEFAULT NULL COMMENT '明细数字',
  `role` tinyint(4) DEFAULT NULL COMMENT '发放角色',
  `dealer_id` int(11) DEFAULT NULL COMMENT '所属品牌商',
  `remark` varchar(255) DEFAULT NULL,
  `distributor_id` int(11) DEFAULT NULL COMMENT '经销商',
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `type` tinyint(255) DEFAULT NULL COMMENT '资产明细类型  字典翻译',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COMMENT='会员资产明细';

-- ----------------------------
--  Records of `ctc_dealer_member_bill`
-- ----------------------------
BEGIN;
INSERT INTO `ctc_dealer_member_bill` VALUES ('1', '1', '1', '2', '100', '1', '23', '111', '1', '2021-12-09 16:09:34', '3'), ('2', '1', '1', '1', '2', '1', '23', '222', '1', '2021-12-26 01:14:05', '3'), ('3', '1', '2', '1', '-3', '1', '23', '564', '1', '2021-12-26 01:21:02', '3'), ('4', '1', '1', '1', '5', '1', '23', '5', null, '2021-12-26 21:46:16', '3'), ('5', '1', '1', '1', '2', '1', '23', '2', null, '2021-12-26 22:08:33', '3');
COMMIT;

-- ----------------------------
--  Table structure for `ctc_dealer_member_tag`
-- ----------------------------
DROP TABLE IF EXISTS `ctc_dealer_member_tag`;
CREATE TABLE `ctc_dealer_member_tag` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `tag_name` varchar(255) DEFAULT NULL,
  `remark` varchar(255) DEFAULT NULL,
  `wechat_id` varchar(255) DEFAULT NULL COMMENT '微信分配标签id',
  `dealer_id` int(11) DEFAULT NULL,
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4;

-- ----------------------------
--  Records of `ctc_dealer_member_tag`
-- ----------------------------
BEGIN;
INSERT INTO `ctc_dealer_member_tag` VALUES ('4', 'fuck', '2', '105', '23', '2021-12-24 01:11:32'), ('5', '45', '55', '106', '23', '2021-12-24 22:09:38');
COMMIT;

-- ----------------------------
--  Table structure for `ctc_dealer_menu`
-- ----------------------------
DROP TABLE IF EXISTS `ctc_dealer_menu`;
CREATE TABLE `ctc_dealer_menu` (
  `menuId` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `menuName` varchar(255) DEFAULT NULL,
  `menuType` varchar(255) DEFAULT NULL COMMENT '菜单类型 M目录 C菜单 F按钮',
  `orderNum` int(11) DEFAULT NULL,
  `parentId` int(11) DEFAULT '0',
  `parentName` varchar(255) DEFAULT NULL,
  `path` varchar(255) DEFAULT NULL,
  `component` varchar(255) DEFAULT NULL,
  `icon` varchar(255) DEFAULT NULL,
  `isFrame` varchar(255) DEFAULT '1' COMMENT '是否外链 0是 1否',
  `status` tinyint(4) DEFAULT '0',
  `visible` tinyint(4) DEFAULT '0' COMMENT '是否可见 0可见 1隐藏',
  `perms` varchar(255) DEFAULT NULL COMMENT '权限字符',
  `query` varchar(255) DEFAULT NULL COMMENT '路由参数',
  `isCache` tinyint(4) DEFAULT '0' COMMENT '是否开启缓存 0开启 1关闭',
  `createBy` varchar(255) DEFAULT NULL,
  `createTime` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`menuId`)
) ENGINE=InnoDB AUTO_INCREMENT=215 DEFAULT CHARSET=utf8mb4;

-- ----------------------------
--  Records of `ctc_dealer_menu`
-- ----------------------------
BEGIN;
INSERT INTO `ctc_dealer_menu` VALUES ('1', '系统', 'M', '0', '0', null, 'system', null, 'system', '1', '0', '0', null, null, '0', null, '2021-11-10 15:28:49'), ('2', '首页', 'C', '0', '1', null, 'home', 'system/home', 'home', '1', '0', '1', null, null, '0', null, '2021-11-10 15:30:02'), ('3', '账户管理', 'M', '0', '1', null, 'account', null, 'user', '1', '0', '0', null, null, '0', null, '2021-11-10 15:31:09'), ('4', '账户信息', 'C', '0', '3', null, 'accountInfo', 'system/account/accountInfo', null, '1', '0', '0', null, null, '0', null, '2021-11-10 15:32:02'), ('5', '资质认证', 'C', '0', '3', null, 'quaAuth', 'system/account/auth', null, '1', '0', '0', null, null, '0', null, '2021-11-10 15:33:42'), ('6', '用户管理', 'M', '0', '1', null, 'user', null, 'user', '1', '0', '0', null, null, '0', null, '2021-11-10 15:37:42'), ('7', '账号管理', 'C', '0', '6', null, 'member', 'system/user/member', null, '1', '0', '0', null, null, '0', null, '2021-11-10 15:39:52'), ('8', '角色管理', 'C', '0', '6', null, 'role', 'system/user/role', null, '1', '0', '0', null, null, '0', null, '2021-11-10 15:40:19'), ('9', '系统管理', 'M', '0', '1', null, 'systemManage', null, 'sys-set', '1', '0', '0', null, null, '0', null, '2021-11-10 15:43:11'), ('10', '语言地区配置', 'C', '0', '9', null, 'language', 'systemManage/language', null, '1', '0', '1', null, null, '0', null, '2021-11-10 15:44:02'), ('11', '税费模板', 'C', '0', '9', null, 'taxation', 'system/systemManage/taxation', null, '1', '0', '0', null, null, '0', null, '2021-11-10 15:44:46'), ('12', '仓库管理', 'C', '0', '9', null, 'warehouse', 'system/systemManage/warehouse', null, '1', '0', '0', null, null, '0', null, '2021-11-10 15:45:47'), ('13', '支付管理', 'C', '0', '9', null, 'payment', 'system/systemManage/payment', null, '1', '0', '0', null, null, '0', null, '2021-11-10 15:46:18'), ('14', '运费模板', 'C', '0', '9', null, 'freight', 'system/systemManage/freight', null, '1', '0', '0', null, null, '0', null, '2021-11-10 15:47:12'), ('15', '系统操作日志', 'C', '0', '9', null, 'operationLog', 'system/systemManage/operationLog', null, '1', '0', '0', null, null, '0', null, '2021-11-10 15:47:59'), ('16', '对接', 'M', '0', '0', null, 'access', null, 'access', '1', '0', '0', null, null, '0', null, '2021-11-10 15:56:34'), ('17', '公众号管理', 'M', '0', '16', null, 'officialAccount', null, 'mp', '1', '0', '0', null, null, '0', null, '2021-11-10 15:59:28'), ('18', '公众号授权', 'C', '0', '17', null, 'officialAuth', 'access/officialAccount/auth', null, '1', '0', '0', null, null, '0', null, '2021-11-10 16:00:16'), ('19', '带参数二维码', 'C', '0', '17', null, 'qrcode', 'access/officialAccount/qrcode', null, '1', '0', '0', null, null, '0', null, '2021-11-10 16:01:11'), ('20', '素材管理', 'C', '0', '17', null, 'material', 'access/officialAccount/material', null, '1', '0', '0', null, null, '0', null, '2021-11-10 16:02:11'), ('21', '群发消息', 'C', '0', '17', null, 'mass', 'officialAccount/mass', null, '1', '0', '0', null, null, '0', null, '2021-11-10 16:05:06'), ('22', '钉钉管理', 'M', '0', '16', null, 'dingding', null, 'dingding', '1', '0', '0', null, null, '0', null, '2021-11-10 16:07:10'), ('23', '钉钉授权', 'C', '0', '22', null, 'dingAuth', 'access/dingding/auth', null, '1', '0', '0', null, null, '0', null, '2021-11-10 16:08:05'), ('24', '有赞管理', 'M', '0', '16', null, 'zan', null, 'zan', '1', '0', '0', null, null, '0', null, '2021-11-10 16:09:04'), ('25', '有赞授权', 'C', '0', '24', null, 'zanAuth', 'access/zan/auth', null, '1', '0', '0', null, null, '0', null, '2021-11-10 16:09:33'), ('26', '监控设备管理', 'M', '0', '16', null, 'monitor', null, 'monitor', '1', '0', '0', null, null, '0', null, '2021-11-10 16:12:12'), ('27', '设备列表', 'C', '0', '26', null, 'monitorList', 'access/monitor/index', null, '1', '0', '0', null, null, '0', null, '2021-11-10 16:12:46'), ('28', '基础配置', 'C', '0', '26', null, 'monitorSet', 'access/monitor/set', null, '1', '0', '0', null, null, '0', null, '2021-11-10 16:13:18'), ('29', '码库', 'M', '0', '0', null, 'codeStore', null, 'code', '1', '0', '0', null, null, '0', null, '2021-11-11 22:15:09'), ('30', '二维码管理', 'M', '0', '29', null, 'qrcode', '', 'qrcode', '1', '0', '0', null, null, '0', null, '2021-11-11 22:17:11'), ('31', '生码管理', 'C', '0', '30', null, 'createCode', 'codeStore/qrcode/code', null, '1', '0', '0', null, null, '0', null, '2021-11-11 22:19:16'), ('32', '作废管理', 'C', '0', '30', null, 'invalidCode', 'codeStore/qrcode/invalid', null, '1', '0', '0', null, null, '0', null, '2021-11-11 22:20:12'), ('33', '扫码黑名单', 'M', '0', '29', null, 'blacklist', null, 'blacklist', '1', '0', '0', null, null, '0', null, '2021-11-11 22:22:32'), ('34', '黑名单管理', 'C', '0', '33', null, 'blacklist', 'codeStore/blacklist/index', null, '1', '0', '0', null, null, '0', null, '2021-11-11 22:23:11'), ('35', '黑名单设置', 'C', '0', '33', null, 'blacklistSet', 'codeStore/blacklist/set', null, '1', '0', '0', null, null, '0', null, '2021-11-11 22:23:49'), ('36', '小程序扫码管理', 'M', '0', '29', null, 'miniPro', null, 'mini-code', '1', '0', '0', null, null, '0', null, '2021-11-11 22:25:56'), ('37', '自定义首页内容', 'C', '0', '36', null, 'miniPro', 'miniPro/index', null, '1', '0', '0', null, null, '0', null, '2021-11-11 22:26:54'), ('38', '自定义扫码页', 'C', '0', '36', null, 'miniProScan', 'miniPro/scan', null, '1', '0', '0', null, null, '0', null, '2021-11-11 22:27:36'), ('39', '资产', 'M', '0', '0', null, 'assets', null, 'assets', '1', '0', '0', null, null, '0', null, '2021-11-11 22:39:35'), ('40', '产品库', 'M', '0', '39', null, 'product', null, 'product', '1', '0', '0', null, null, '0', null, '2021-11-11 22:40:26'), ('41', '产品管理', 'C', '0', '40', null, 'product', 'assets/product/index', null, '1', '0', '0', null, null, '0', null, '2021-11-11 22:40:59'), ('42', '产品分组', 'C', '0', '40', null, 'productClass', 'assets/product/class', null, '1', '0', '0', null, null, '0', null, '2021-11-11 22:41:38'), ('43', '礼品库', 'M', '0', '39', null, 'gift', null, 'gift', '1', '0', '0', null, null, '0', null, '2021-11-11 22:43:09'), ('44', '礼品管理', 'C', '0', '43', null, 'giftList', 'assets/gift/index', null, '1', '0', '0', null, null, '0', null, '2021-11-11 22:43:41'), ('45', '礼品分组', 'C', '0', '43', null, 'giftClass', 'assets/gift/class', null, '1', '0', '0', null, null, '0', null, '2021-11-11 22:44:11'), ('46', '红包', 'M', '0', '39', null, 'redpack', null, 'redpack', '1', '0', '0', null, null, '0', null, '2021-11-11 22:45:54'), ('47', '红包管理', 'C', '0', '46', null, 'repackList', 'assets/redpack/index', null, '1', '0', '0', null, null, '0', null, '2021-11-11 22:46:24'), ('48', '红包明细', 'C', '0', '46', null, 'redpackBill', 'assets/redpack/bill', null, '1', '0', '0', null, null, '0', null, '2021-11-11 22:46:54'), ('49', '代发红包池', 'C', '0', '46', null, 'repackPoll', 'assets/redpack/pool', null, '1', '0', '0', null, null, '0', null, '2021-11-11 22:48:05'), ('50', '积分', 'M', '0', '39', null, 'integral', null, 'integral', '1', '0', '0', null, null, '0', null, '2021-11-11 22:49:52'), ('51', '积分管理', 'C', '0', '50', null, 'pointsList', 'assets/integral/index', null, '1', '0', '0', null, null, '0', null, '2021-11-11 22:50:19'), ('52', '积分明细', 'C', '0', '50', null, 'pointsBill', 'assets/integral/bill', null, '1', '0', '0', null, null, '0', null, '2021-11-11 22:50:42'), ('53', '短信包', 'M', '0', '39', null, 'sms', null, 'sms', '1', '0', '0', null, null, '0', null, '2021-11-11 22:52:23'), ('54', '短信管理', 'C', '0', '53', null, 'smsList', 'assets/sms/index', null, '1', '0', '0', null, null, '0', null, '2021-11-11 22:52:45'), ('55', '发送记录', 'C', '0', '53', null, 'smsLog', 'assets/sms/log', null, '1', '0', '0', null, null, '0', null, '2021-11-11 22:53:10'), ('56', '素材库', 'M', '0', '39', null, 'material', null, 'dashboard', '1', '0', '0', null, null, '0', null, '2021-11-11 22:54:01'), ('57', '素材库管理', 'C', '0', '56', null, 'materiallList', 'assets/material/index', null, '1', '0', '0', null, null, '0', null, '2021-11-11 22:54:52'), ('58', '订单', 'M', '0', '0', null, 'order', null, 'order', '1', '0', '0', null, null, '0', null, '2021-11-12 00:06:22'), ('59', '订单管理', 'M', '0', '58', null, 'orderManage', null, 'order', '1', '0', '0', null, null, '0', null, '2021-11-12 00:07:50'), ('60', '营销奖牌订单', 'C', '0', '59', null, 'marketingOrder', 'order/marketingOrder', null, '1', '0', '0', null, null, '0', null, '2021-11-12 00:09:24'), ('61', '积分商城订单', 'C', '0', '59', null, 'integralOrder', 'order/integralOrder', null, '1', '0', '0', null, null, '0', null, '2021-11-12 00:10:08'), ('62', '微商城订单', 'C', '0', '59', null, 'shopOrder', 'order/shopOrder', null, '1', '0', '0', null, null, '0', null, '2021-11-12 00:10:34'), ('63', '多门店商城订单', 'C', '0', '59', null, 'multiStoreOrder', 'order/multiStoreOrder', null, '1', '0', '0', null, null, '0', null, '2021-11-12 00:11:21'), ('64', '订单设置', 'M', '0', '58', null, 'orderSet', null, 'order-set', '1', '0', '0', null, null, '0', null, '2021-11-12 00:12:47'), ('65', '订单设置', 'C', '0', '64', null, 'orderSet', 'orderSet/index', null, '1', '0', '0', null, null, '0', null, '2021-11-12 00:13:15'), ('66', '核销管理', 'M', '0', '58', null, 'check', null, 'hexiao', '1', '0', '0', null, null, '0', null, '2021-11-12 00:16:11'), ('67', '核销记录', 'C', '0', '66', null, 'checkList', 'check/index', null, '1', '0', '0', null, null, '0', null, '2021-11-12 00:16:37'), ('68', '报销管理', 'C', '0', '66', null, 'reimbursement', 'check/reimbursement', null, '1', '0', '0', null, null, '0', null, '2021-11-12 00:17:19'), ('69', '核销统计', 'C', '0', '66', null, 'statistics', 'check/statistics', null, '1', '0', '0', null, null, '0', null, '2021-11-12 00:17:46'), ('70', '核销预约', 'C', '0', '66', null, 'appointment', 'check/appointment', null, '1', '0', '0', null, null, '0', null, '2021-11-12 00:18:15'), ('71', '客户', 'M', '0', '0', null, 'customer', null, 'customer', '1', '0', '0', null, null, '0', null, '2021-11-12 00:23:42'), ('72', '会员管理', 'M', '0', '71', null, 'member', null, 'member', '1', '0', '0', null, null, '0', null, '2021-11-12 00:25:56'), ('73', '会员列表', 'C', '0', '72', null, 'memberList', 'customer/member/index', null, '1', '0', '0', null, null, '0', null, '2021-11-12 00:26:15'), ('74', '会员标签管理', 'C', '0', '72', null, 'memberTags', 'customer/member/tag', null, '1', '0', '0', null, null, '0', null, '2021-11-12 00:26:37'), ('75', '自定义字段管理', 'C', '0', '72', null, 'customField', 'customer/member/field', null, '1', '0', '0', null, null, '0', null, '2021-11-12 00:27:27'), ('76', '表单活动会员白名单', 'C', '0', '72', null, 'memberWhiteList', 'member/whiteList', null, '1', '0', '0', null, null, '0', null, '2021-11-12 00:28:26'), ('77', '经销商管理', 'M', '0', '71', null, 'distributor', null, 'user', '1', '0', '0', null, null, '0', null, '2021-11-12 00:29:01'), ('78', '经销商管理', 'C', '0', '77', null, 'distributorList', 'customer/distributor/index', null, '1', '0', '0', null, null, '0', null, '2021-11-12 00:29:36'), ('79', '经销商级别管理', 'C', '0', '77', null, 'distributorLevel', 'customer/distributor/level', null, '1', '0', '0', null, null, '0', null, '2021-11-12 00:29:59'), ('80', '经销商结构树', 'C', '0', '77', null, 'distributorTree', 'distributor/tree', null, '1', '0', '1', null, null, '0', null, '2021-11-12 00:30:31'), ('82', '邀请注册设置', 'C', '0', '77', null, 'inviteRegister', 'customer/distributor/register', null, '1', '0', '0', null, null, '0', null, '2021-11-12 00:32:18'), ('83', '门店管理', 'M', '0', '71', null, 'store', null, 'store', '1', '0', '0', null, null, '0', null, '2021-11-12 00:35:34'), ('84', '门店管理', 'C', '0', '83', null, 'storeList', 'customer/store/index', null, '1', '0', '0', null, null, '0', null, '2021-11-12 00:36:04'), ('85', '店员管理', 'C', '0', '83', null, 'clerk', 'customer/store/clerk', null, '1', '0', '0', null, null, '0', null, '2021-11-12 00:37:58'), ('86', '门店类型管理', 'C', '0', '83', null, 'storeType', 'customer/store/type', null, '1', '0', '0', null, null, '0', null, '2021-11-12 00:38:26'), ('87', '门店佣金管理', 'C', '0', '83', null, 'commission', 'customer/store/commission', null, '1', '0', '0', null, null, '0', null, '2021-11-12 00:38:50'), ('88', '门店积分管理', 'C', '0', '83', null, 'storePoints', 'customer/store/points', null, '1', '0', '0', null, null, '0', null, '2021-11-12 00:39:25'), ('89', '门店标签管理', 'C', '0', '83', null, 'storeTags', 'store/tags', null, '1', '0', '1', null, null, '0', null, '2021-11-12 00:39:49'), ('90', '业务员管理', 'M', '0', '71', null, 'salesman', null, 'salesman', '1', '0', '0', null, null, '0', null, '2021-11-12 00:42:59'), ('91', '业务员资料管理', 'C', '0', '90', null, 'salesman', 'customer/salesman/index', null, '1', '0', '0', null, null, '0', null, '2021-11-12 00:43:29'), ('92', '业务员类型管理', 'C', '0', '90', null, 'salesmanType', 'customer/salesman/type', null, '1', '0', '0', null, null, '0', null, '2021-11-12 00:44:09'), ('93', '公告管理', 'M', '0', '71', null, 'notice', null, 'notice', '1', '0', '0', null, null, '0', null, '2021-11-12 00:47:18'), ('94', '公告管理', 'C', '0', '93', null, 'notice', 'customer/notice/index', null, '1', '0', '0', null, null, '0', null, '2021-11-12 00:47:39'), ('95', '基础管理', 'M', '0', '71', null, 'basics', null, 'sys-set', '1', '0', '0', null, null, '0', null, '2021-11-12 00:48:52'), ('96', '个人中心设置', 'C', '0', '95', null, 'basicsUser', 'customer/basics/user', null, '1', '0', '0', null, null, '0', null, '2021-11-12 00:49:39'), ('97', '基础设置', 'C', '0', '95', null, 'basicsSet', 'customer/basics/set', null, '1', '0', '0', null, null, '0', null, '2021-11-12 00:50:05'), ('98', '客户区域管理', 'C', '0', '95', null, 'customerArea', 'customer/basics/customerArea', null, '1', '0', '0', null, null, '0', null, '2021-11-12 00:51:17'), ('99', '应用', 'M', '0', '0', null, 'app', null, 'app', '1', '0', '0', null, null, '0', null, '2021-11-12 14:30:33'), ('100', '二维码营销', 'M', '0', '99', null, 'qrcodeMarketing', null, 'qrcode', '1', '0', '0', null, null, '0', null, '2021-11-12 14:33:37'), ('101', '概况', 'M', '0', '100', null, 'qrcodeSurvey', null, 'home', '1', '0', '0', null, null, '0', null, '2021-11-12 14:35:21'), ('102', '概况', 'C', '0', '101', null, 'qrcodeSurveyIndex', 'qrcodeSurvey/index', null, '1', '0', '0', null, null, '0', null, '2021-11-12 14:36:09'), ('103', '扫码活动管理', 'M', '0', '100', null, 'sacnaAtivity', null, 'scan', '1', '0', '0', null, null, '0', null, '2021-11-12 14:38:37'), ('104', '扫码模板管理', 'C', '0', '103', null, 'sacnTemplate', 'scanActivity/template', null, '1', '0', '0', null, null, '0', null, '2021-11-12 14:39:36'), ('105', '活动管理', 'C', '0', '103', null, 'scanActivityManage', 'scanActivity/index', null, '1', '0', '0', null, null, '0', null, '2021-11-12 14:40:52'), ('106', '扫码明细', 'C', '0', '103', null, 'scanActivityBill', 'scanActivity/bill', null, '1', '0', '0', null, null, '0', null, '2021-11-12 14:41:46'), ('107', '领奖记录', 'C', '0', '103', null, 'scanActivityAward', 'scanActivity/award', null, '1', '0', '0', null, null, '0', null, '2021-11-12 14:42:42'), ('108', '表单活动参与记录', 'C', '0', '103', null, 'scanActivityForm', 'scanActivity/form', null, '1', '0', '0', null, null, '0', null, '2021-11-12 14:43:55'), ('109', '用户集字列表', 'C', '0', '103', null, 'scanActivityCharacters', 'scanActivity/characters', null, '1', '0', '0', null, null, '0', null, '2021-11-12 14:45:19'), ('110', '集字礼品兑换统计', 'C', '0', '103', null, 'scanActivityGift', 'scanActivity/gift', null, '1', '0', '0', null, null, '0', null, '2021-11-12 14:56:24'), ('111', '小程序商城模板', 'C', '0', '103', null, 'miniproTemplate', 'sacnActivity/shop', null, '1', '0', '0', null, null, '0', null, '2021-11-12 14:57:21'), ('112', '数据统计', 'M', '0', '100', null, 'dataStatistics', null, 'data', '1', '0', '0', null, null, '0', null, '2021-11-12 15:01:20'), ('113', '扫码量统计', 'C', '0', '112', null, 'dataStatisticsScan', 'dataStatistics/scan', null, '1', '0', '0', null, null, '0', null, '2021-11-12 15:02:18'), ('114', '扫码地区统计', 'C', '0', '112', null, 'dataStatisticsArea', 'dataStatistics/area', null, '1', '0', '0', null, null, '0', null, '2021-11-12 15:02:56'), ('115', '用户扫码统计', 'C', '0', '112', null, 'dataStatisticsUser', 'dataStatistics/user', null, '1', '0', '0', null, null, '0', null, '2021-11-12 15:03:30'), ('116', '参与地区统计', 'C', '0', '112', null, 'dataStatisticsJoinArea', 'dataStatistics/joinArea', null, '1', '0', '0', null, null, '0', null, '2021-11-12 15:04:47'), ('117', '奖品统计', 'C', '0', '112', null, 'dataStatisticsPrize', 'dataStatistics/prize', null, '1', '0', '0', null, null, '0', null, '2021-11-12 15:05:23'), ('118', '串货区域统计', 'C', '0', '112', null, 'dataStatisticsCollusion', 'dataStatistics/collusion', null, '1', '0', '0', null, null, '0', null, '2021-11-12 15:06:14'), ('119', '串货商品统计', 'C', '0', '112', null, 'dataStatisticsProduct', 'dataStatistics/product', null, '1', '0', '0', null, null, '0', null, '2021-11-12 15:07:03'), ('120', '门店数据统计', 'C', '0', '112', null, 'dataStatisticsStore', 'dataStatistics/store', null, '1', '0', '0', null, null, '0', null, '2021-11-12 15:07:45'), ('121', '营销分控管理', 'M', '0', '100', null, 'qrcodeMarketing', null, 'marketing', '1', '0', '0', null, null, '0', null, '2021-11-12 15:11:13'), ('122', '营销分控管理', 'C', '0', '121', null, 'qrcodeMarketingIndex', 'qrcodeMarketing/index', null, '1', '0', '0', null, null, '0', null, '2021-11-12 15:11:43'), ('123', '微商城', 'M', '0', '99', null, 'microMall', null, 'store', '1', '0', '0', null, null, '0', null, '2021-11-12 15:21:00'), ('124', '概况', 'M', '0', '123', null, 'microMallHome', null, 'home', '1', '0', '0', null, null, '0', null, '2021-11-12 15:21:36'), ('125', '概况', 'C', '0', '124', null, 'microMallIndex', 'app/microMall/index', null, '1', '0', '0', null, null, '0', null, '2021-11-12 15:21:59'), ('126', '微商城设置', 'M', '0', '123', null, 'microMallSet', null, 'sys-set', '1', '0', '0', null, null, '0', null, '2021-11-12 15:22:25'), ('127', '商城装修', 'C', '0', '126', null, 'microMallCustom', 'app/microMall/custom', null, '1', '0', '0', null, null, '0', null, '2021-11-12 15:23:15'), ('128', '自定义页面', 'C', '0', '126', null, 'microMallPage', 'microMall/page', null, '1', '0', '1', null, null, '0', null, '2021-11-12 15:24:16'), ('129', '商品管理', 'M', '0', '123', null, 'microMallProduct', null, 'product', '1', '0', '0', null, null, '0', null, '2021-11-12 15:24:54'), ('130', '上下架管理', 'C', '0', '129', null, 'microMallProcuctSet', 'app/microMall/procuct', null, '1', '0', '0', null, null, '0', null, '2021-11-12 15:25:59'), ('131', '商品分类', 'C', '0', '129', null, 'microMallProType', 'app/microMall/type', null, '1', '0', '0', null, null, '0', null, '2021-11-12 15:26:36'), ('132', '评价管理', 'M', '0', '123', null, 'microMallEvaluate', null, 'pingjia', '1', '0', '0', null, null, '0', null, '2021-11-12 15:29:27'), ('133', '评价管理', 'C', '0', '132', null, 'evaluate', 'app/microMall/evaluate', null, '1', '0', '0', null, null, '0', null, '2021-11-12 15:32:23'), ('135', '微分销', 'M', '0', '123', null, 'microDistribution', null, 'fenxiao', '1', '0', '0', null, null, '0', null, '2021-11-12 15:42:05'), ('136', '分销设置', 'C', '0', '135', null, 'microDistributionSet', 'app/microDistribution/set', null, '1', '0', '0', null, null, '0', null, '2021-11-12 15:42:36'), ('137', '分销员招募', 'C', '0', '135', null, 'microDistributionUser', 'app/microDistribution/user', null, '1', '0', '0', null, null, '0', null, '2021-11-12 15:43:07'), ('138', '分销员管理', 'C', '0', '135', null, 'microDistributionUserSet', 'app/microDistribution/userManage', null, '1', '0', '0', null, null, '0', null, '2021-11-12 15:43:42'), ('139', '分销订单', 'C', '0', '135', null, 'microDistributionOrder', 'app/microDistribution/order', null, '1', '0', '0', null, null, '0', null, '2021-11-12 15:44:06'), ('140', '分销效果', 'C', '0', '135', null, 'microDistributionEffect', 'app/microDistribution/effect', null, '1', '0', '0', null, null, '0', null, '2021-11-12 15:44:44'), ('141', '提现申请', 'C', '0', '135', null, 'microDistributionCash', 'app/microDistribution/cash', null, '1', '0', '0', null, null, '0', null, '2021-11-12 15:45:16'), ('142', '积分商城', 'M', '0', '99', null, 'pointsMall', null, 'integral', '1', '0', '0', null, null, '0', null, '2021-11-12 15:47:16'), ('143', '概况', 'M', '0', '142', null, 'pointsMallIIndex', null, 'home', '1', '0', '0', null, null, '0', null, '2021-11-12 15:47:54'), ('144', '概况', 'C', '0', '143', null, 'index', 'app/pointsMall/index', null, '1', '0', '0', null, null, '0', null, '2021-11-12 15:48:17'), ('145', '基础设置', 'M', '0', '142', null, 'pointsMallSet', null, 'sys-set', '1', '0', '0', null, null, '0', null, '2021-11-12 15:49:36'), ('146', '商城装修', 'C', '0', '145', null, 'pointsMallCustom', 'app/pointsMall/custom', null, '1', '0', '0', null, null, '0', null, '2021-11-12 15:50:21'), ('147', '积分兑换设置', 'C', '0', '145', null, 'pointsMallExchange', 'app/pointsMall/exchange', null, '1', '0', '0', null, null, '0', null, '2021-11-12 15:51:04'), ('148', '兑换礼品管理', 'M', '0', '142', null, 'pointsMallGift', null, 'gift', '1', '0', '0', null, null, '0', null, '2021-11-12 15:52:04'), ('149', '兑换礼品列表', 'C', '0', '148', null, 'gifts', 'app/pointsMall/gifts', null, '1', '0', '0', null, null, '0', null, '2021-11-12 15:53:30'), ('150', '自定义分类', 'C', '0', '148', null, 'class', 'app/pointsMall/class', null, '1', '0', '0', null, null, '0', null, '2021-11-12 15:53:53'), ('151', '数据统计', 'M', '0', '142', null, 'pointsMallData', null, 'data', '1', '0', '0', null, null, '0', null, '2021-11-12 15:54:52'), ('152', '礼品兑换分析', 'C', '0', '151', null, 'exchangeData', 'app/pointsMall/data', null, '1', '0', '0', null, null, '0', null, '2021-11-12 15:55:37'), ('153', '智慧门店', 'M', '0', '99', null, 'smartStore', null, 'smart-store', '1', '0', '0', null, null, '0', null, '2021-11-12 16:03:39'), ('154', '概况', 'M', '0', '153', null, 'smartStoreIndex', null, 'home', '1', '0', '0', null, null, '0', null, '2021-11-12 16:04:04'), ('155', '概况', 'C', '0', '154', null, 'index2', 'smartStore/index', null, '1', '0', '0', null, null, '0', null, '2021-11-12 16:04:29'), ('156', '店铺管理', 'M', '0', '153', null, 'smartStoreShop', null, 'store', '1', '0', '0', null, null, '0', null, '2021-11-12 16:05:28'), ('157', '店铺管理', 'C', '0', '156', null, 'smartStoreShop', 'smartStore/shop', null, '1', '0', '0', null, null, '0', null, '2021-11-12 16:05:56'), ('158', '门店商品库', 'M', '0', '153', null, 'smartStorePro', '', 'product', '1', '0', '0', null, null, '0', null, '2021-11-12 16:06:36'), ('159', '自营商品管理', 'C', '0', '158', null, 'selfSupport', 'smartStore/selfProduct', null, '1', '0', '0', null, null, '0', null, '2021-11-12 16:07:46'), ('160', '店铺商品管理', 'C', '0', '158', null, 'product1', 'smartStore/product', null, '1', '0', '0', null, null, '0', null, '2021-11-12 16:09:35'), ('161', '商品分类', 'C', '0', '158', null, 'smartStoreClass', 'smartStore/class', null, '1', '0', '0', null, null, '0', null, '2021-11-12 16:10:23'), ('162', '店铺订单', 'M', '0', '153', null, 'smartStoreOrder', null, 'order', '1', '0', '0', null, null, '0', null, '2021-11-12 16:11:00'), ('163', '店铺订单', 'C', '0', '162', null, 'smartStoreOrder', 'smartStore/order', null, '1', '0', '0', null, null, '0', null, '2021-11-12 16:11:50'), ('164', '门店佣金', 'M', '0', '153', null, 'smartStoremCommission', null, 'money', '1', '0', '0', null, null, '0', null, '2021-11-12 16:14:08'), ('165', '佣金发放记录', 'C', '0', '164', null, 'commissionIssue', 'smartStore/commission', null, '1', '0', '0', null, null, '0', null, '2021-11-12 16:15:10'), ('166', '佣金提现申请', 'C', '0', '164', null, 'cash', 'smartStore/cash', null, '1', '0', '0', null, null, '0', null, '2021-11-12 16:15:39'), ('167', '提现设置', 'C', '0', '164', null, 'cashSet', 'smartStore/cashSet', null, '1', '0', '0', null, null, '0', null, '2021-11-12 16:17:47'), ('168', '门店客户', 'M', '0', '153', null, 'smartStoreUser', null, 'user', '1', '0', '0', null, null, '0', null, '2021-11-12 16:18:55'), ('169', '门店客户管理', 'C', '0', '168', null, 'user', 'smartStore/user', null, '1', '0', '0', null, null, '0', null, '2021-11-12 16:19:26'), ('170', '数据分析', 'M', '0', '153', null, 'smartStoreData', null, 'data', '1', '0', '0', null, null, '0', null, '2021-11-12 16:31:09'), ('171', '订单分析', 'C', '0', '170', null, 'orderAnalysis', 'smartStore/orderAnalysis', null, '1', '0', '0', null, null, '0', null, '2021-11-12 16:32:18'), ('172', '商品分析', 'C', '0', '170', null, 'productAnalysis', 'smartStore/productAnalysis', null, '1', '0', '0', null, null, '0', null, '2021-11-12 16:33:27'), ('173', '客户分析', 'C', '0', '170', null, 'userAnalysis', 'smartStore/userAnalysis', null, '1', '0', '0', null, null, '0', null, '2021-11-12 16:34:03'), ('174', '佣金分析', 'C', '0', '170', null, 'commissionAnalysis', 'smartStore/commissionAnalysis', null, '1', '0', '0', null, null, '0', null, '2021-11-12 16:34:48'), ('175', '万能溯源(舒适版)', 'M', '0', '99', null, 'trace', null, 'suyuan', '1', '0', '0', null, null, '0', null, '2021-11-12 16:40:00'), ('176', '概况', 'M', '0', '175', null, 'index', null, 'home', '1', '0', '0', null, null, '0', null, '2021-11-12 16:40:25'), ('177', '概况', 'C', '0', '176', null, 'traceIndex', 'app/trace/index', null, '1', '0', '0', null, null, '0', null, '2021-11-12 16:40:50'), ('178', '基础设置管理', 'M', '0', '175', null, 'traceSet', null, 'sys-set', '1', '0', '0', null, null, '0', null, '2021-11-12 16:42:11'), ('179', '溯源页模板管理', 'C', '0', '178', null, 'traceTemplate', 'app/trace/template', null, '1', '0', '0', null, null, '0', null, '2021-11-12 16:42:56'), ('180', '溯源信息管理', 'M', '0', '175', null, 'info', null, 'notice', '1', '0', '0', null, null, '0', null, '2021-11-12 16:43:42'), ('181', '产品批次管理', 'C', '0', '180', null, 'traceBatch', 'app/trace/batch', null, '1', '0', '0', null, null, '0', null, '2021-11-12 16:44:20'), ('182', '赋码批次管理', 'C', '0', '180', null, 'traceCode', 'app/trace/code', null, '1', '0', '0', null, null, '0', null, '2021-11-12 16:45:03'), ('183', '产品信息追溯', 'C', '0', '180', null, 'traceInfo', 'app/trace/trace', null, '1', '0', '0', null, null, '0', null, '2021-11-12 16:45:43'), ('184', '溯源查询明细', 'C', '0', '180', null, 'queryDetail', 'app/trace/queryDetail', null, '1', '0', '0', null, null, '0', null, '2021-11-12 16:46:11'), ('185', '智能物流', 'M', '0', '99', null, 'logistics', '', 'logistics', '1', '0', '0', null, null, '0', null, '2021-11-12 16:49:16'), ('186', '概况', 'M', '0', '185', null, 'index', null, 'home', '1', '0', '0', null, null, '0', null, '2021-11-12 16:49:35'), ('187', '概况', 'C', '0', '186', null, 'index4', 'logistics/index', null, '1', '0', '0', null, null, '0', null, '2021-11-12 16:49:54'), ('188', '物流管理', 'M', '0', '185', null, 'logisticsManage', null, 'sys-set', '1', '0', '0', null, null, '0', null, '2021-11-12 16:51:52'), ('189', '入库管理', 'C', '0', '188', null, 'warehousing', 'app/logistics/warehousing', null, '1', '0', '0', null, null, '0', null, '2021-11-12 16:52:45'), ('190', '发货管理', 'C', '0', '188', null, 'deliver', 'app/logistics/deliver', null, '1', '0', '0', null, null, '0', null, '2021-11-12 16:53:37'), ('191', '退货管理', 'C', '0', '188', null, 'back', 'app/logistics/back', null, '1', '0', '0', null, null, '0', null, '2021-11-12 16:54:23'), ('192', '调仓管理', 'C', '0', '188', null, 'transfer', 'app/logistics/transfer', null, '1', '0', '0', null, null, '0', null, '2021-11-12 16:55:37'), ('193', '商品调拨', 'C', '0', '188', null, 'allocation', 'logistics/allocation', null, '1', '0', '0', null, null, '0', null, '2021-11-12 16:56:22'), ('194', '零售管理', 'C', '0', '188', null, 'retail', 'logistics/retail', null, '1', '0', '0', null, null, '0', null, '2021-11-12 16:57:04'), ('195', '追踪查询', 'C', '0', '188', null, 'track', 'logistics/track', null, '1', '0', '0', null, null, '0', null, '2021-11-12 16:57:39'), ('196', '在线订单管理', 'M', '0', '185', null, 'onlineOrder', null, 'order', '1', '0', '0', null, null, '0', null, '2021-11-12 16:58:21'), ('197', '商品上下架', 'C', '0', '196', null, 'productSet', 'logistics/productSet', null, '1', '0', '0', null, null, '0', null, '2021-11-12 16:59:17'), ('198', '经销商订单管理', 'C', '0', '196', null, 'distributorOrder', 'logistics/distributorOrder', null, '1', '0', '0', null, null, '0', null, '2021-11-12 17:00:36'), ('199', '门店订单管理', 'C', '0', '196', null, 'storeOrder', 'logistics/storeOrder', null, '1', '0', '0', null, null, '0', null, '2021-11-12 17:01:44'), ('200', '返利管理', 'M', '0', '185', null, 'rebate', null, 'money', '1', '0', '0', null, null, '0', null, '2021-11-12 17:10:19'), ('201', '返利发放记录', 'C', '0', '200', null, 'rebateLog', 'logistics/rebate', null, '1', '0', '0', null, null, '0', null, '2021-11-12 17:11:32'), ('202', '经销商返利管理', 'C', '0', '200', null, 'distributorRebate', 'logistics/distributorRebate', null, '1', '0', '0', null, null, '0', null, '2021-11-12 17:12:44'), ('203', '经销商余额明细', 'C', '0', '200', null, 'balance', 'logistics/balance', null, '1', '0', '0', null, null, '0', null, '2021-11-12 17:14:35'), ('204', '报表管理', 'M', '0', '185', null, 'statistics', null, 'data', '1', '0', '0', null, null, '0', null, '2021-11-12 17:16:40'), ('205', '总部库存统计', 'C', '0', '204', null, 'stock', 'logistics/stock', null, '1', '0', '0', null, null, '0', null, '2021-11-12 17:17:48'), ('206', '经销窜货统计', 'C', '0', '204', null, 'collusionSat', 'app/logistics/statistics/collusion', null, '1', '0', '0', null, null, '0', null, '2021-11-12 17:18:53'), ('207', '经销商库存统计', 'C', '0', '204', null, 'distributorStock', 'logistics/distributorStock', null, '1', '0', '0', null, null, '0', null, '2021-11-12 17:19:50'), ('208', '门店库存统计', 'C', '0', '204', null, 'storeStock', 'logistics/storeStock', null, '1', '0', '0', null, null, '0', null, '2021-11-12 17:20:23'), ('209', '盘点统计', 'C', '0', '204', null, 'Inventory', 'logistics/Inventory', null, '1', '0', '0', null, null, '0', null, '2021-11-12 17:21:07'), ('210', '产品周转率统计', 'C', '0', '204', null, 'turnover', 'logistics/turnover', null, '1', '0', '0', null, null, '0', null, '2021-11-12 17:21:54'), ('211', '基础管理', 'M', '0', '185', null, 'logisticsBasis', null, 'sys-set', '1', '0', '0', null, null, '0', null, '2021-11-12 17:22:35'), ('212', '基础设置', 'C', '0', '211', null, 'basisSet', 'logistics/basis', null, '1', '0', '0', null, null, '0', null, '2021-11-12 17:23:12'), ('213', '仓库设置', 'C', '0', '211', null, 'Warehouses', 'app/logistics/warehouse', null, '1', '0', '0', null, null, '0', null, '2021-11-12 17:23:47'), ('214', '财务管理', 'C', '0', '77', null, 'distributorFinance', 'customer/distributor/finance', null, '1', '0', '0', null, null, '0', null, '2022-01-08 20:30:09');
COMMIT;

-- ----------------------------
--  Table structure for `ctc_dealer_monitor`
-- ----------------------------
DROP TABLE IF EXISTS `ctc_dealer_monitor`;
CREATE TABLE `ctc_dealer_monitor` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `equ_name` varchar(255) DEFAULT NULL,
  `equ_num` varchar(255) DEFAULT NULL,
  `equ_way` varchar(255) DEFAULT NULL,
  `equ_code` varchar(255) DEFAULT NULL,
  `equ_definition` tinyint(4) DEFAULT NULL,
  `cover` varchar(255) DEFAULT NULL,
  `dealer_id` int(11) DEFAULT NULL,
  `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`,`create_time`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4;

-- ----------------------------
--  Records of `ctc_dealer_monitor`
-- ----------------------------
BEGIN;
INSERT INTO `ctc_dealer_monitor` VALUES ('3', 'rwe', 'rewr', 'ewr', 'rew', '2', '20211119/837da31bcb9a635c8f879d8fff13a32b.png', '23', '2021-11-19 21:31:28'), ('4', 'erew', 'rewr', 'erw', 'rewr', '1', '20211119/13c2d23f5e5f4c385a5916869604c6b4.png', '23', '2021-11-19 21:38:20');
COMMIT;

-- ----------------------------
--  Table structure for `ctc_dealer_oper_log`
-- ----------------------------
DROP TABLE IF EXISTS `ctc_dealer_oper_log`;
CREATE TABLE `ctc_dealer_oper_log` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `module_name` varchar(255) DEFAULT NULL,
  `operator` varchar(255) DEFAULT NULL COMMENT '操作人员',
  `ip` varchar(255) DEFAULT NULL,
  `address` varchar(255) DEFAULT NULL,
  `operate_type` varchar(255) DEFAULT NULL COMMENT '操作类型',
  `operate_event` varchar(255) DEFAULT NULL COMMENT '操作事件',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP,
  `dealer_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=65 DEFAULT CHARSET=utf8mb4;

-- ----------------------------
--  Records of `ctc_dealer_oper_log`
-- ----------------------------
BEGIN;
INSERT INTO `ctc_dealer_oper_log` VALUES ('1', '账户管理', 'wenhan', '127.0.0.1', '0内网IP', '2', '更新商标权证书', '2021-11-13 17:07:50', null), ('2', '账户管理', 'wenhan', '127.0.0.1', '0内网IP', '2', '更新商标权证书', '2021-11-13 17:08:42', null), ('3', '账户管理', 'wenhan', '127.0.0.1', '0内网IP', '2', '更新营业执照', '2021-11-13 17:09:11', null), ('4', '账户管理', 'wenhan', '127.0.0.1', '0内网IP', '2', '更新营业执照', '2021-11-13 17:09:58', null), ('5', '用户管理', 'wenhan', '127.0.0.1', '0内网IP', '1', '新增用户角色', '2021-11-13 18:25:42', null), ('6', '用户管理', 'wenhan', '127.0.0.1', '0内网IP', '2', '更新用户角色', '2021-11-13 18:37:29', null), ('7', '用户管理', 'wenhan', '127.0.0.1', '0内网IP', '2', '更新用户角色状态', '2021-11-13 22:01:41', null), ('8', '用户管理', 'wenhan', '127.0.0.1', '0内网IP', '2', '更新用户角色状态', '2021-11-13 22:01:43', null), ('9', '用户管理', 'wenhan', '127.0.0.1', '0内网IP', '1', '新增用户', '2021-11-13 22:57:57', null), ('10', '用户管理', 'wenhan', '127.0.0.1', '0内网IP', '1', '新增用户', '2021-11-13 23:01:13', null), ('11', '用户管理', 'wenhan', '127.0.0.1', '0内网IP', '2', '更新用户', '2021-11-13 23:21:36', null), ('12', '用户管理', 'wenhan', '127.0.0.1', '0内网IP', '2', '更新用户状态', '2021-11-13 23:23:37', null), ('13', '用户管理', 'wenhan', '127.0.0.1', '0内网IP', '2', '更新用户状态', '2021-11-13 23:23:39', null), ('14', '用户管理', 'wenhan', '127.0.0.1', '0内网IP', '2', '更新用户', '2021-11-13 23:23:58', null), ('15', '用户管理', 'wenhan', '127.0.0.1', '0内网IP', '2', '重置用户密码', '2021-11-13 23:25:19', null), ('16', '用户管理', 'wenhan', '127.0.0.1', '0内网IP', '1', '新增用户', '2021-11-13 23:26:12', null), ('17', '用户管理', 'wenhan', '127.0.0.1', '0内网IP', '2', '更新用户状态', '2021-11-13 23:26:54', null), ('18', '用户管理', 'wenhan', '127.0.0.1', '0内网IP', '2', '重置用户密码', '2021-11-13 23:30:01', null), ('19', '用户管理', 'wenhan', '127.0.0.1', '0内网IP', '2', '更新用户', '2021-11-13 23:30:17', null), ('20', '用户管理', 'wenhan', '127.0.0.1', '0内网IP', '2', '更新用户状态', '2021-11-13 23:32:26', null), ('21', '用户管理', 'wenhan', '127.0.0.1', '0内网IP', '2', '更新用户状态', '2021-11-13 23:32:51', null), ('22', '用户管理', 'wenhan', '127.0.0.1', '0内网IP', '1', '新增用户', '2021-11-13 23:33:06', null), ('23', '用户管理', 'wenhan', '127.0.0.1', '0内网IP', '1', '新增用户', '2021-11-14 13:13:16', null), ('24', '用户管理', 'wenhan', '127.0.0.1', '0内网IP', '3', '删除用户', '2021-11-14 13:13:47', null), ('25', '用户管理', 'wenhan', '127.0.0.1', '0内网IP', '1', '新增用户角色', '2021-11-14 14:06:28', '23'), ('26', '用户管理', 'wenhan', '127.0.0.1', '0内网IP', '1', '新增用户', '2021-11-14 14:06:38', '23'), ('27', '用户管理', 'wenhan', '127.0.0.1', '0内网IP', '2', '删除角色', '2021-11-14 14:06:54', '23'), ('28', '用户管理', 'wenhan', '127.0.0.1', '0内网IP', '3', '删除用户', '2021-11-14 14:07:00', '23'), ('29', '账户管理', 'wenhan', '127.0.0.1', '0内网IP', '2', '更新营业执照', '2021-11-14 14:07:26', '23'), ('30', '账户管理', 'wenhan', '127.0.0.1', '0内网IP', '2', '更新商标权证书', '2021-11-14 14:07:30', '23'), ('31', '账户管理', 'wenhan', '127.0.0.1', '23', '2', '更新账户信息', '2021-11-14 14:08:59', '23'), ('32', '用户管理', 'wenhan', '127.0.0.1', '0内网IP', '1', '新增用户', '2021-11-16 12:56:45', '23'), ('33', '系统管理', 'wenhan', '127.0.0.1', '0内网IP', '2', '更新仓库状态', '2021-11-16 13:03:25', '23'), ('34', '系统管理', 'wenhan', '127.0.0.1', '0内网IP', '2', '更新仓库状态', '2021-11-16 13:03:32', '23'), ('35', '系统管理', 'wenhan', '127.0.0.1', '0内网IP', '2', '更新仓库状态', '2021-11-16 13:04:07', '23'), ('36', '系统管理', 'wenhan', '127.0.0.1', '0内网IP', '2', '更新仓库状态', '2021-11-16 13:04:20', '23'), ('37', '系统管理', 'wenhan', '127.0.0.1', '0内网IP', '2', '更新税费模板状态', '2021-11-16 16:55:32', '23'), ('38', '系统管理', 'wenhan', '127.0.0.1', '0内网IP', '2', '更新税费模板状态', '2021-11-16 16:55:34', '23'), ('39', '系统管理', 'wenhan', '127.0.0.1', '0内网IP', '2', '修改运费模板', '2021-11-16 17:10:36', '23'), ('40', '系统管理', 'wenhan', '127.0.0.1', '0内网IP', '1', '新增运费模板', '2021-11-16 17:10:41', '23'), ('41', '系统管理', 'wenhan', '127.0.0.1', '0内网IP', '3', '删除运费模板', '2021-11-16 17:10:54', '23'), ('42', '系统管理', 'wenhan', '127.0.0.1', '0内网IP', '2', '更新支付信息', '2021-11-16 17:12:21', '23'), ('43', '系统管理', 'wenhan', '127.0.0.1', '0内网IP', '1', '新增仓库信息', '2021-11-16 17:17:01', '23'), ('44', '系统管理', 'wenhan', '127.0.0.1', '0内网IP', '2', '修改仓库信息', '2021-11-16 17:17:07', '23'), ('45', '系统管理', 'wenhan', '127.0.0.1', '0内网IP', '3', '删除仓库信息', '2021-11-16 17:17:13', '23'), ('46', '系统管理', 'wenhan', '127.0.0.1', '0内网IP', '2', '修改仓库信息', '2021-11-16 17:18:11', '23'), ('47', '系统管理', 'wenhan', '127.0.0.1', '0内网IP', '2', '更新仓库状态', '2021-11-16 17:18:28', '23'), ('48', '系统管理', 'wenhan', '127.0.0.1', '0内网IP', '2', '更新税费模板状态', '2021-11-16 17:18:36', '23'), ('49', '系统管理', 'wenhan', '127.0.0.1', '0内网IP', '1', '新增税费模板', '2021-11-16 17:20:55', '23'), ('50', '系统管理', 'wenhan', '127.0.0.1', '0内网IP', '1', '新增税费模板', '2021-11-16 17:21:02', '23'), ('51', '系统管理', 'wenhan', '127.0.0.1', '0内网IP', '3', '删除税费模板', '2021-11-16 17:21:08', '23'), ('52', '系统管理', 'wenhan', '127.0.0.1', '0内网IP', '3', '删除税费模板', '2021-11-16 17:21:14', '23'), ('53', '系统管理', 'wenhan', '127.0.0.1', '0内网IP', '2', '更新税费模板状态', '2021-11-16 17:21:16', '23'), ('54', '系统管理', 'wenhan', '127.0.0.1', '0内网IP', '2', '更新税费模板状态', '2021-11-16 17:21:18', '23'), ('55', '系统管理', 'wenhan', '127.0.0.1', '0内网IP', '1', '新增仓库信息', '2021-11-18 00:58:51', '23'), ('56', '账户管理', 'wenhan', '127.0.0.1', '23', '2', '更新账户信息', '2022-01-01 21:41:30', '23'), ('57', '账户管理', 'wenhan', '127.0.0.1', '0内网IP', '2', '更新营业执照', '2022-01-13 16:21:34', '23'), ('58', '账户管理', 'wenhan', '127.0.0.1', '23', '2', '更新账户信息', '2022-01-14 17:06:31', '23'), ('59', '系统管理', 'wenhan', '127.0.0.1', '0内网IP', '1', '新增运费模板', '2022-01-18 00:09:15', '23'), ('60', '系统管理', 'wenhan', '127.0.0.1', '0内网IP', '2', '修改运费模板', '2022-01-18 00:09:50', '23'), ('61', '系统管理', 'wenhan', '127.0.0.1', '0内网IP', '2', '更新支付信息', '2022-01-20 23:58:24', '23'), ('62', '系统管理', 'wenhan', '127.0.0.1', '0内网IP', '2', '更新支付信息', '2022-01-20 23:59:42', '23'), ('63', '账户管理', 'wenhan', '127.0.0.1', '23', '2', '更新账户信息', '2022-02-10 10:22:35', '23'), ('64', '系统管理', 'wenhan', '127.0.0.1', '0内网IP', '2', '修改税费模板', '2022-03-13 21:55:32', '23');
COMMIT;

-- ----------------------------
--  Table structure for `ctc_dealer_params_qrcode`
-- ----------------------------
DROP TABLE IF EXISTS `ctc_dealer_params_qrcode`;
CREATE TABLE `ctc_dealer_params_qrcode` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `qr_name` varchar(255) DEFAULT NULL,
  `qr_type` int(11) DEFAULT NULL,
  `status` varchar(255) DEFAULT '0' COMMENT '1启用 2禁用 0未生效',
  `dealer_id` int(11) DEFAULT NULL,
  `url` varchar(255) DEFAULT NULL,
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `valid_time` varchar(255) DEFAULT NULL COMMENT '有效期',
  `reply` text COMMENT '回复语',
  `tags` varchar(255) DEFAULT NULL COMMENT '二维码标签',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4;

-- ----------------------------
--  Records of `ctc_dealer_params_qrcode`
-- ----------------------------
BEGIN;
INSERT INTO `ctc_dealer_params_qrcode` VALUES ('1', 'erfwerwer', '3', '1', '23', 'https://mp.weixin.qq.com/cgi-bin/showqrcode?ticket=gQHt8DwAAAAAAAAAAS5odHRwOi8vd2VpeGluLnFxLmNvbS9xLzAyRG9lOG81T01kMkUxRjVXWU54MWIAAgRFLZVhAwQAjScA', '2021-11-18 00:26:45', '30', 're', '2'), ('6', 'dfgd', '3', '1', '23', 'https://mp.weixin.qq.com/cgi-bin/showqrcode?ticket=gQHU8DwAAAAAAAAAAS5odHRwOi8vd2VpeGluLnFxLmNvbS9xLzAyWHoySm92T01kMkUxR2dpWnh4Y3YAAgSQBZZhAwQAjScA', '2021-11-18 15:49:36', '30', '哈哈哈 可以啊老弟！！', '101'), ('7', 'test', '3', '1', '23', 'https://mp.weixin.qq.com/cgi-bin/showqrcode?ticket=gQFO8TwAAAAAAAAAAS5odHRwOi8vd2VpeGluLnFxLmNvbS9xLzAyQmhtRG9yT01kMkUxT1FpSWh4Y1AAAgS0hcRhAwQAjScA', '2021-12-23 22:20:35', '30', '54561', '100,2'), ('8', '15', '3', '1', '23', 'https://mp.weixin.qq.com/cgi-bin/showqrcode?ticket=gQE78TwAAAAAAAAAAS5odHRwOi8vd2VpeGluLnFxLmNvbS9xLzAyTF9yWHBfT01kMkUxT0ZMSXh4Y2EAAgSposRhAwQAjScA', '2021-12-24 00:24:09', '30', '4', '103,105');
COMMIT;

-- ----------------------------
--  Table structure for `ctc_dealer_payment`
-- ----------------------------
DROP TABLE IF EXISTS `ctc_dealer_payment`;
CREATE TABLE `ctc_dealer_payment` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `dealer_id` int(11) DEFAULT NULL,
  `appid` varchar(255) DEFAULT NULL,
  `appsecret` varchar(255) DEFAULT NULL,
  `mchid` varchar(255) DEFAULT NULL,
  `cert` varchar(255) DEFAULT NULL,
  `key` varchar(255) DEFAULT NULL,
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4;

-- ----------------------------
--  Records of `ctc_dealer_payment`
-- ----------------------------
BEGIN;
INSERT INTO `ctc_dealer_payment` VALUES ('1', '23', 'wx5ce210829bff659d', 'fjdsf0943243095f9sewrf9804350943', '1493245202', '20211115/c29255023ed90c61a1967fe9816b4edc.pem', '20211115/1b770843a40eb17b8f743c5dc7a6cf29.pem', '2021-11-15 22:29:30');
COMMIT;

-- ----------------------------
--  Table structure for `ctc_dealer_pda_token`
-- ----------------------------
DROP TABLE IF EXISTS `ctc_dealer_pda_token`;
CREATE TABLE `ctc_dealer_pda_token` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `uid` int(11) DEFAULT NULL,
  `token` varchar(255) DEFAULT NULL,
  `login_ip` varchar(32) DEFAULT NULL,
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP,
  `expires_time` datetime DEFAULT NULL,
  `dealer_id` int(11) DEFAULT NULL COMMENT '代理商id 用来区分角色token',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=89 DEFAULT CHARSET=utf8mb4;

-- ----------------------------
--  Records of `ctc_dealer_pda_token`
-- ----------------------------
BEGIN;
INSERT INTO `ctc_dealer_pda_token` VALUES ('1', '23', '30ead16807acb547ddfbfacf64773a37d0704d32', '::1', '2022-03-26 13:10:26', '2022-03-27 01:10:26', null), ('2', '23', 'e0580e281e21b67d804f558e29740a4094566d63', '::1', '2022-03-26 13:32:08', '2022-03-27 01:32:08', null), ('3', '23', '01aeebfbf89c0a6209ae9b66146963cd52f773a8', '::1', '2022-03-26 13:33:40', '2022-03-27 01:33:40', null), ('4', '23', '052f97e6b1a69eacfc3c46d07796ecab73aac378', '::1', '2022-03-26 13:36:59', '2022-03-27 01:36:59', null), ('5', '23', 'ddf82438a4bb08ce7cafd8e7b272f2597419f607', '::1', '2022-03-26 13:37:26', '2022-03-27 01:37:26', null), ('6', '23', 'd393736dfc8f1f6b9e7fb3e1e39aefc66755c21c', '::1', '2022-03-26 13:38:30', '2022-03-27 01:38:30', null), ('7', '23', '4ac464c1700ac08b0a8fe39a6619ddcabc17f53f', '::1', '2022-03-26 14:16:13', '2022-03-27 02:16:13', null), ('8', '23', '16f9bd8097c94eb78a1b93c1d7a36cdb2e3542a2', '::1', '2022-03-26 14:30:14', '2022-03-27 02:30:14', null), ('9', '23', 'b99ac69e20720d283ff4b59a85a083ef73ab417e', '::1', '2022-03-26 14:33:30', '2022-03-27 02:33:30', null), ('10', '23', 'a42b7c91ad329bca862c77255f67e8fcb48c2942', '::1', '2022-03-26 14:33:57', '2022-03-27 02:33:57', null), ('11', '23', '35507eb6bfb7522d7b4afa049e70033ef80af3cc', '::1', '2022-03-26 22:32:11', '2022-03-27 10:32:11', null), ('12', '23', 'f30612c18f49ee892592485a086832e30a0393b1', '::1', '2022-03-26 22:48:40', '2022-03-27 10:48:40', null), ('13', '23', '52bee3d338b4e221f2011765eb578c787b097f18', '::1', '2022-03-26 23:03:20', '2022-03-27 11:03:20', null), ('14', '23', '6eb8019fb4db52e52f67553eefb526b5923a87b1', '::1', '2022-03-26 23:16:05', '2022-03-27 11:16:05', null), ('15', '23', 'd4a0b177f849f7d209389ab2986be825d4c3eeaf', '::1', '2022-03-26 23:17:04', '2022-03-27 11:17:04', null), ('16', '23', '3148edc628d9429a8eff6a56e60f68d8bcb87ba3', '::1', '2022-03-26 23:38:04', '2022-03-27 11:38:04', null), ('17', '23', 'f80dbfec5bb6f6e29e8972e486f388c02432909d', '::1', '2022-03-26 23:40:21', '2022-03-27 11:40:21', null), ('18', '23', '7617d0dace6e60ec69ef76467d44876f7a8853ad', '::1', '2022-03-26 23:40:27', '2022-03-27 11:40:27', null), ('19', '23', '61585546786c0c9980acd26d5440fc23230763bb', '::1', '2022-03-26 23:40:31', '2022-03-27 11:40:31', null), ('20', '23', '551e36684a51d607462a02120eb4959dee27286f', '::1', '2022-03-26 23:40:38', '2022-03-27 11:40:38', null), ('21', '23', '99d5c6af3021b315198fb74c8171165bb0a89466', '::1', '2022-03-26 23:50:46', '2022-03-27 11:50:46', null), ('22', '23', 'b8677fd9acb8f56fdd51dd52b1f4784db44a8fb4', '::1', '2022-03-26 23:57:29', '2022-03-27 11:57:29', null), ('23', '23', 'c2ec562d76685bff5633f33893c21aa645a0530d', '::1', '2022-03-27 00:10:50', '2022-03-27 12:10:50', null), ('24', '23', '4481237f8080b4f92bbae0ff7d09fbbfbb4e5b5d', '::1', '2022-03-27 00:21:06', '2022-03-27 12:21:06', null), ('25', '23', '8948866f5bbb817dc3015de4d8d45ec71a26d318', '::1', '2022-03-27 01:31:13', '2022-03-27 13:31:13', null), ('26', '23', '56a2f91d247f0375bdabd987d5042ae98748b4ae', '::1', '2022-03-27 01:36:06', '2022-03-27 13:36:06', null), ('27', '23', '768b4ec6238502fa25a94b6036919b25fe5e9aa6', '::1', '2022-03-27 01:36:14', '2022-03-27 13:36:14', null), ('28', '23', '76a9cabf2342acf3d6eb55e82069749d317b1f35', '::1', '2022-03-27 13:56:58', '2022-03-28 01:56:58', null), ('29', '23', '306e54ba7e02a671bb7876d1643ee5591499a692', '::1', '2022-03-27 14:24:17', '2022-03-28 02:24:17', null), ('30', '23', '85758fc30bf594d124a4357c3ed2e908713819ac', '::1', '2022-03-27 14:24:54', '2022-03-28 02:24:54', null), ('31', '23', '00dee3aaa21237d0d6b3af4fab8a1e55d5b801e0', '::1', '2022-03-27 14:26:52', '2022-03-28 02:26:52', null), ('32', '23', '38f2a7fee018eadf810249ebd84a4ac2ade3ce0e', '::1', '2022-03-27 15:14:01', '2022-03-28 03:14:01', null), ('33', '23', 'b811e3fb14163a8879bfdce610ff9030627d1580', '::1', '2022-03-27 16:36:28', '2022-03-28 04:36:28', null), ('34', '23', 'f3c9e12efc015c5ad58db56a86db75f6bcd4118f', '::1', '2022-03-27 17:40:54', '2022-03-28 05:40:54', null), ('35', '23', 'adca1bebffab851d34e719ae6253b487841b7578', '::1', '2022-03-27 18:57:20', '2022-03-28 06:57:20', null), ('36', '23', '47ec1c66428117623700f49b77e6de6e63805d51', '::1', '2022-03-27 21:04:06', '2022-03-28 09:04:06', null), ('37', '23', '97725ecb7dd13e58d6f1e62909afb7e699207a0a', '::1', '2022-03-27 21:24:44', '2022-03-28 09:24:44', null), ('38', '23', 'f421d799ec0c967141c155ee38dad24781b74b1a', '::1', '2022-03-27 21:36:31', '2022-03-28 09:36:30', null), ('39', '23', '3a7bcdb3a77c3b2c7738a608fde70251bfafc7f4', '::1', '2022-03-27 21:40:12', '2022-03-28 09:40:12', null), ('40', '23', '0abbc825637b1073bf3e9fc9e21d102877fcbe73', '::1', '2022-03-27 21:44:32', '2022-03-28 09:44:32', null), ('41', '23', 'b3a959b5c49146aa58bb842bf2dc047f917ffef3', '::1', '2022-03-27 21:44:32', '2022-03-28 09:44:32', null), ('42', '23', '3435b30f155a8e73e1d26760a5df47573dcdd00c', '::1', '2022-03-27 22:02:20', '2022-03-28 10:02:20', null), ('43', '23', '8440d891102364e7ec3a9fb7cf2feb44a8015b07', '::1', '2022-03-27 22:46:49', '2022-03-28 10:46:48', null), ('44', '23', '77a02ab7b0e98cef7af435686fbc62b150ab3caa', '::1', '2022-03-27 23:47:20', '2022-03-28 11:47:20', null), ('45', '23', 'ffa8603a96ee6b289be358f0e3a2a3900ef56541', '::1', '2022-03-28 00:00:18', '2022-03-28 12:00:18', null), ('46', '23', 'd45949a31592b7f71f19eb95465e4c69db0b1c22', '::1', '2022-03-28 00:02:23', '2022-03-28 12:02:23', null), ('47', '23', 'a591f5ffd2a58c6b56853e898ba8003684e7a48f', '::1', '2022-03-28 00:06:58', '2022-03-28 12:06:58', null), ('48', '23', 'c1212e72105e2585fd20d26aaf851c55ad450a32', '::1', '2022-03-28 00:38:27', '2022-03-28 12:38:27', null), ('49', '23', 'f65f0b9693573d6e6c7d801ada70f40a4508fc9d', '::1', '2022-03-28 01:42:27', '2022-03-28 13:42:27', null), ('50', '23', 'b726c479bbc90d660cfbc2ad6debe0888f0487c7', '::1', '2022-03-28 12:42:44', '2022-03-29 00:42:44', null), ('51', '23', 'c43328b6e2b460308fe1c9f9b5a5677128d73aba', '::1', '2022-03-28 13:15:37', '2022-03-29 01:15:37', null), ('52', '23', 'e994bc99b3b139c8f2b209184560615836a8d54b', '::1', '2022-03-28 21:09:36', '2022-03-29 09:09:36', null), ('53', '23', 'cedfcd24a60df171ae4a73380110a815f47cc346', '::1', '2022-03-28 21:10:26', '2022-03-29 09:10:26', null), ('54', '23', '51f538d82bb900e345e1ce84d0ac4fd559b97a64', '::1', '2022-03-28 21:15:41', '2022-03-29 09:15:41', null), ('55', '23', '6ee32b6f87ce4d1e4f2962b43c565381a3ee7be3', '::1', '2022-03-28 21:22:37', '2022-03-29 09:22:37', null), ('56', '23', '548a580fa9202f56a83fd91903dfb3b962aa0571', '::1', '2022-03-28 22:47:00', '2022-03-29 10:47:00', null), ('57', '23', 'd7f9d7ecb5d75b868232150ceb5338bfbf0e7fbf', '::1', '2022-03-28 23:56:52', '2022-03-29 11:56:52', null), ('58', '23', '682c77cba65bbf519e01fd904f922c42c5861390', '::1', '2022-03-29 01:00:40', '2022-03-29 13:00:40', null), ('59', '23', 'ba07e2d54c32f3341372e6b99272bc282e6dc320', '::1', '2022-03-29 01:37:22', '2022-03-29 13:37:22', null), ('60', '23', '09aa6336574cd41e0250b1e495c5a5cd3b7abff6', '::1', '2022-03-29 12:22:15', '2022-03-30 00:22:15', null), ('61', '23', '4983159dc6630eee323a6b0c2c9fbbb7205ae354', '::1', '2022-03-29 18:50:11', '2022-03-30 06:50:11', null), ('62', '23', '55caa6de0d80662406a010f5e769dc6230ac7d07', '::1', '2022-03-29 22:50:32', '2022-03-30 10:50:32', null), ('63', '23', 'a9e88e0e2e17b8b0632abb606c2878c9c6c56b69', '::1', '2022-03-30 00:11:25', '2022-03-30 12:11:25', null), ('64', '23', 'c0a33ae7410d68b3e6ad6791495efcd9b2fcf857', '::1', '2022-03-30 00:29:40', '2022-03-30 12:29:40', null), ('65', '23', '7cc31bf7a9f8d21e87976c1dc91da5a5e30c4284', '::1', '2022-03-31 12:13:33', '2022-04-01 00:13:33', null), ('66', '23', '05a62e64a831e13add39606d492b29637bbbaa83', '::1', '2022-03-31 16:52:50', '2022-04-01 04:52:50', null), ('67', '23', 'f8e1e5b4f0c32c0a289473d0b806b65e07100356', '::1', '2022-03-31 17:03:38', '2022-04-01 05:03:38', null), ('68', '23', 'f9988ae64ba13688aabef6a1cc6d82a145ffa559', '::1', '2022-03-31 17:07:14', '2022-04-01 05:07:14', null), ('69', '23', 'b5891c8ce3f0ffb95b7be53b4019161081e872b9', '::1', '2022-03-31 17:43:43', '2022-04-01 05:43:43', null), ('70', '23', '4550275beb0027fd8aa0316398e118410ecb9ced', '::1', '2022-03-31 18:00:22', '2022-04-01 06:00:22', null), ('71', '23', '8ae2d013de78f3ac54e44ce35a7e41ca8f2005be', '::1', '2022-03-31 23:55:09', '2022-04-01 11:55:09', null), ('72', '23', '9861456726a3a9cb14f5185b7b9e8fef6de1c8ab', '::1', '2022-04-01 00:16:06', '2022-04-01 12:16:06', null), ('73', '23', '24c80e8c6bb664fb79bbfc1b86ead093adc8ae18', '::1', '2022-04-01 00:57:30', '2022-04-01 12:57:30', null), ('74', '23', '838175bb2259571b7d06c2c7fdf10918d6915b59', '::1', '2022-04-01 01:42:29', '2022-04-01 13:42:29', null), ('75', '23', 'd0f41731d31806e7132c0f01d3dbd900a7def5c8', '::1', '2022-04-01 01:47:13', '2022-04-01 13:47:13', null), ('76', '23', '331f4e04b634273d6d62f317de2b9d86579e412d', '::1', '2022-04-01 02:00:46', '2022-04-01 14:00:46', null), ('77', '23', '41f0a43044263d1774b166d3f966a8e1dac304dc', '::1', '2022-04-01 11:24:21', '2022-04-01 23:24:21', null), ('78', '23', 'b1e54c91899772a5b6f5f4ecb350aa2b53a9b69c', '::1', '2022-04-01 15:03:51', '2022-04-02 03:03:51', null), ('79', '23', 'ef071bfaffb6075487ea33758d3effcf18c97f91', '::1', '2022-04-01 15:57:15', '2022-04-02 03:57:15', null), ('80', '23', '3dc80b6b559ae772a1d6abc074574f2519d38799', '::1', '2022-04-01 16:17:18', '2022-04-02 04:17:18', null), ('81', '23', 'b985a6ea6eacc05aff84bbc3a336d1929d447cff', '::1', '2022-04-01 16:21:41', '2022-04-02 04:21:41', null), ('82', '23', '10f13b6765380dd24684794d3a42679365572e85', '::1', '2022-04-01 17:04:03', '2022-04-02 05:04:03', null), ('83', '23', 'ed60cd6518c2667f284303da79b3a915a4fb1f7c', '::1', '2022-04-02 13:27:39', '2022-04-03 01:27:39', null), ('84', '23', 'b7fd51738514f4c2617a72a9c709c682f045f823', '::1', '2022-04-02 14:45:42', '2022-04-03 02:45:42', null), ('85', '23', 'd25b6b06b8c2da88fd247b3f8130f5e17fcb2381', '::1', '2022-04-02 21:33:33', '2022-04-03 09:33:33', null), ('86', '23', '70c578db2c2aacae5e8688254401808b0894d973', '::1', '2022-04-03 14:58:21', '2022-04-04 02:58:21', null), ('87', '23', 'db0acd5f648ddd7c19e3ca6819ed6926093f5770', '::1', '2022-04-03 15:00:04', '2022-04-04 03:00:04', null), ('88', '23', 'a357c45bb44d8de6a7c23f3f4755505e10035d11', '::1', '2022-04-03 20:27:21', '2022-04-04 08:27:21', null);
COMMIT;

-- ----------------------------
--  Table structure for `ctc_dealer_points_gift_class`
-- ----------------------------
DROP TABLE IF EXISTS `ctc_dealer_points_gift_class`;
CREATE TABLE `ctc_dealer_points_gift_class` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `class_name` varchar(255) DEFAULT NULL,
  `parent_id` int(11) DEFAULT '0',
  `order` int(11) DEFAULT NULL,
  `dealer_id` int(11) DEFAULT NULL,
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4;

-- ----------------------------
--  Records of `ctc_dealer_points_gift_class`
-- ----------------------------
BEGIN;
INSERT INTO `ctc_dealer_points_gift_class` VALUES ('1', '4147', '0', '11', '23', '2022-03-12 22:06:25'), ('2', 'sd', '1', '3', '23', '2022-03-12 22:06:39'), ('3', '21', '0', '1', '23', '2022-03-12 22:06:39');
COMMIT;

-- ----------------------------
--  Table structure for `ctc_dealer_points_gifts`
-- ----------------------------
DROP TABLE IF EXISTS `ctc_dealer_points_gifts`;
CREATE TABLE `ctc_dealer_points_gifts` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `gift_id` int(11) DEFAULT NULL COMMENT '礼品id',
  `code` varchar(255) DEFAULT NULL COMMENT '礼品编号',
  `class_one` int(11) DEFAULT NULL COMMENT '礼品分类',
  `class_two` int(11) DEFAULT NULL,
  `type` tinyint(4) DEFAULT '1' COMMENT '积分模式价格 1纯积分 2积分加支付',
  `points_num` decimal(8,2) DEFAULT NULL COMMENT '所需积分',
  `money` decimal(8,2) DEFAULT NULL COMMENT '所需现金',
  `limit_num` int(11) DEFAULT NULL COMMENT '可兑换数量 不得大于库存',
  `permission` tinyint(4) DEFAULT '1' COMMENT '兑现权限 1限兑数量 2限兑用户',
  `limit_num_type` varchar(255) DEFAULT '' COMMENT '1每人限兑 2每单限兑',
  `person_limit_num` int(11) DEFAULT NULL COMMENT '每人限兑数量',
  `order_limit_num` int(11) DEFAULT NULL COMMENT '每单限兑数量',
  `exchanged_num` int(11) DEFAULT '0' COMMENT '已兑数量',
  `white_tag` int(11) DEFAULT NULL COMMENT '可兑换用户标签',
  `limits_explain` varchar(255) DEFAULT NULL COMMENT '限兑说明',
  `freight_id` int(11) DEFAULT NULL COMMENT '运费模板',
  `order` int(11) DEFAULT NULL COMMENT '排序',
  `status` tinyint(4) DEFAULT '0' COMMENT '状态0等待上架 1已上架 2已下架 3已删除',
  `dealer_id` int(11) DEFAULT NULL,
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4;

-- ----------------------------
--  Records of `ctc_dealer_points_gifts`
-- ----------------------------
BEGIN;
INSERT INTO `ctc_dealer_points_gifts` VALUES ('1', '7', '7856', '1', '2', '2', '1.00', '1.20', '10', '1', '[1]', '1', '0', '0', '0', '很抱歉，你不能兑换此礼品', '7', '1', '2', '23', '2022-03-13 01:04:04', '2022-03-14 12:47:14');
COMMIT;

-- ----------------------------
--  Table structure for `ctc_dealer_points_order`
-- ----------------------------
DROP TABLE IF EXISTS `ctc_dealer_points_order`;
CREATE TABLE `ctc_dealer_points_order` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '订单ID',
  `order_id` varchar(32) NOT NULL COMMENT '订单号',
  `dealer_id` int(11) DEFAULT NULL COMMENT '归属',
  `member_id` int(11) unsigned NOT NULL COMMENT '用户id',
  `real_name` varchar(32) NOT NULL COMMENT '用户姓名',
  `user_phone` varchar(18) NOT NULL COMMENT '用户电话',
  `user_address` varchar(100) NOT NULL COMMENT '详细地址',
  `cart_id` varchar(256) NOT NULL DEFAULT '[]' COMMENT '购物车id',
  `total_num` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '订单商品总数',
  `total_points` decimal(8,2) DEFAULT NULL COMMENT '订单总积分',
  `total_price` decimal(8,2) unsigned NOT NULL DEFAULT '0.00' COMMENT '订单总价',
  `total_postage` decimal(8,2) unsigned NOT NULL DEFAULT '0.00' COMMENT '邮费',
  `pay_price` decimal(8,2) unsigned NOT NULL DEFAULT '0.00' COMMENT '实际支付金额',
  `pay_postage` decimal(8,2) unsigned NOT NULL DEFAULT '0.00' COMMENT '支付邮费',
  `deduction_price` decimal(8,2) unsigned NOT NULL DEFAULT '0.00' COMMENT '抵扣金额',
  `coupon_id` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '优惠券id',
  `coupon_price` decimal(8,2) unsigned NOT NULL DEFAULT '0.00' COMMENT '优惠券金额',
  `paid` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '支付状态',
  `pay_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '支付时间',
  `pay_type` varchar(32) NOT NULL COMMENT '支付方式',
  `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `status` tinyint(1) NOT NULL DEFAULT '0' COMMENT '订单状态（-1 : 申请退款 -2 : 退货成功 0：待发货；1：待收货；2：已收货；3：待评价；3：已退款）',
  `refund_status` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '0 未退款 1 申请中 2 已退款',
  `refund_reason_wap_img` varchar(255) DEFAULT NULL COMMENT '退款图片',
  `refund_reason_wap_explain` varchar(255) DEFAULT NULL COMMENT '退款用户说明',
  `refund_reason_time` int(11) unsigned DEFAULT NULL COMMENT '退款时间',
  `refund_reason_wap` varchar(255) DEFAULT NULL COMMENT '前台退款原因',
  `refund_reason` varchar(255) DEFAULT NULL COMMENT '不退款的理由',
  `refund_price` decimal(8,2) unsigned NOT NULL DEFAULT '0.00' COMMENT '退款金额',
  `delivery_name` varchar(64) DEFAULT NULL COMMENT '快递名称/送货人姓名',
  `delivery_type` varchar(32) DEFAULT NULL COMMENT '发货类型',
  `delivery_id` varchar(64) DEFAULT NULL COMMENT '快递单号/手机号',
  `gain_integral` decimal(8,2) unsigned NOT NULL DEFAULT '0.00' COMMENT '消费赚取积分',
  `use_integral` decimal(8,2) unsigned NOT NULL DEFAULT '0.00' COMMENT '使用积分',
  `back_integral` decimal(8,2) unsigned DEFAULT NULL COMMENT '给用户退了多少积分',
  `mark` varchar(512) NOT NULL COMMENT '备注',
  `is_del` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '是否删除',
  `unique` char(32) NOT NULL COMMENT '唯一id(md5加密)类似id',
  `remark` varchar(512) DEFAULT NULL COMMENT '管理员备注',
  `mer_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '商户ID',
  `is_mer_check` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `combination_id` int(11) unsigned DEFAULT '0' COMMENT '拼团产品id0一般产品',
  `pink_id` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '拼团id 0没有拼团',
  `cost` decimal(8,2) unsigned NOT NULL COMMENT '成本价',
  `seckill_id` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '秒杀产品ID',
  `bargain_id` int(11) unsigned DEFAULT '0' COMMENT '砍价id',
  `is_channel` tinyint(1) unsigned DEFAULT '0' COMMENT '支付渠道(0微信公众号1微信小程序)',
  `is_system_del` tinyint(1) NOT NULL DEFAULT '0' COMMENT '后台管理员删除',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `order_id_2` (`order_id`,`member_id`) USING BTREE,
  UNIQUE KEY `unique` (`unique`) USING BTREE,
  KEY `uid` (`member_id`) USING BTREE,
  KEY `add_time` (`create_time`) USING BTREE,
  KEY `pay_price` (`pay_price`) USING BTREE,
  KEY `paid` (`paid`) USING BTREE,
  KEY `pay_time` (`pay_time`) USING BTREE,
  KEY `pay_type` (`pay_type`) USING BTREE,
  KEY `status` (`status`) USING BTREE,
  KEY `is_del` (`is_del`) USING BTREE,
  KEY `coupon_id` (`coupon_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT COMMENT='订单表';

-- ----------------------------
--  Table structure for `ctc_dealer_points_rule`
-- ----------------------------
DROP TABLE IF EXISTS `ctc_dealer_points_rule`;
CREATE TABLE `ctc_dealer_points_rule` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `rule_des` text,
  `dealer_id` int(11) DEFAULT NULL,
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4;

-- ----------------------------
--  Records of `ctc_dealer_points_rule`
-- ----------------------------
BEGIN;
INSERT INTO `ctc_dealer_points_rule` VALUES ('1', '<p>5432572778<img src=\"https://cdn.icloudapi.cn/00ca1202203122149507563.jpg\"></p>', '23', '2022-03-12 21:49:41');
COMMIT;

-- ----------------------------
--  Table structure for `ctc_dealer_points_set`
-- ----------------------------
DROP TABLE IF EXISTS `ctc_dealer_points_set`;
CREATE TABLE `ctc_dealer_points_set` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `dealer_id` int(11) DEFAULT NULL,
  `exchange_value` int(11) DEFAULT NULL COMMENT '兑换值',
  `integral_explain` varchar(255) DEFAULT NULL,
  `is_clear` tinyint(4) DEFAULT '0' COMMENT '是否定期清零',
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4;

-- ----------------------------
--  Records of `ctc_dealer_points_set`
-- ----------------------------
BEGIN;
INSERT INTO `ctc_dealer_points_set` VALUES ('3', '23', '104', '测试', '1', '2021-12-09 11:40:20');
COMMIT;

-- ----------------------------
--  Table structure for `ctc_dealer_points_template`
-- ----------------------------
DROP TABLE IF EXISTS `ctc_dealer_points_template`;
CREATE TABLE `ctc_dealer_points_template` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `share_title` varchar(255) DEFAULT NULL,
  `share_text` varchar(255) DEFAULT NULL,
  `share_img` varchar(255) DEFAULT NULL,
  `page_title` varchar(255) DEFAULT NULL,
  `page_content` text,
  `dealer_id` int(11) DEFAULT NULL,
  `status` tinyint(4) DEFAULT '0' COMMENT '状态0正常 1删除',
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4;

-- ----------------------------
--  Records of `ctc_dealer_points_template`
-- ----------------------------
BEGIN;
INSERT INTO `ctc_dealer_points_template` VALUES ('1', '积分商城', '我正在看积分商城，挺不错的，你也来看看吧。', '###', '积分商城', '[{\"type\":\"search\",\"text\":\"\\u641c\\u7d22\\u793c\\u54c1\",\"height\":60},{\"type\":\"user\",\"face\":\"\\/static\\/img\\/default-face.b5316121.png\",\"height\":20},{\"type\":\"line\",\"height\":20},{\"type\":\"nav\",\"content\":[{\"url\":\"\\/static\\/img\\/nav-1-icon@2x.76794824.png\",\"text\":\"\\u793c\\u54c1\\u5217\\u8868\",\"is_show\":1},{\"url\":\"\\/static\\/img\\/nav-2-icon@2x.761261e4.png\",\"text\":\"\\u4e2a\\u4eba\\u4e2d\\u5fc3\",\"is_show\":1},{\"url\":\"\\/static\\/img\\/nav-3-icon@2x.b064880f.png\",\"text\":\"\\u8ba2\\u5355\\u4e2d\\u5fc3\",\"is_show\":1},{\"url\":\"\\/static\\/img\\/nav-4-icon@2x.1aff1290.png\",\"text\":\"\\u5151\\u6362\\u89c4\\u5219\",\"is_show\":1}]},{\"type\":\"line\",\"height\":20},{\"type\":\"banner\",\"imgList\":[{\"url\":\"\\/static\\/img\\/wsc-default.ba6454f6.png\",\"link\":\"\"}],\"height\":152},{\"type\":\"line\",\"height\":20},{\"type\":\"recom\",\"text\":\"\\u70ed\\u95e8\\u63a8\\u8350\",\"url\":\"\",\"product_title\":\"iPhone13\",\"num\":\"\\u5df2\\u5151\\u636210\",\"points\":100,\"recom_rule\":1},{\"type\":\"line\",\"height\":20}]', '23', '0', '2022-03-12 00:20:35');
COMMIT;

-- ----------------------------
--  Table structure for `ctc_dealer_product`
-- ----------------------------
DROP TABLE IF EXISTS `ctc_dealer_product`;
CREATE TABLE `ctc_dealer_product` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `code` varchar(255) DEFAULT NULL COMMENT '产品编号',
  `class_one` int(11) DEFAULT NULL COMMENT '一级分类',
  `class_two` int(11) DEFAULT NULL COMMENT '二级分类',
  `barcode` varchar(255) DEFAULT NULL COMMENT '条码',
  `weight` varchar(255) DEFAULT NULL,
  `integral` varchar(255) DEFAULT NULL COMMENT '积分',
  `stock` varchar(255) DEFAULT NULL COMMENT '库存',
  `product_name` varchar(255) DEFAULT NULL,
  `unit` varchar(255) DEFAULT NULL COMMENT '单位',
  `cover` varchar(255) DEFAULT NULL COMMENT '图片',
  `price` varchar(255) DEFAULT NULL COMMENT '积分',
  `market_price` varchar(255) DEFAULT NULL COMMENT '市场价',
  `details` text COMMENT '详情',
  `order` int(11) DEFAULT NULL COMMENT '排序',
  `specifications` varchar(255) DEFAULT NULL COMMENT '规格',
  `dull_cycle` varchar(255) DEFAULT NULL COMMENT '呆滞品周期',
  `approval_number` varchar(255) DEFAULT NULL COMMENT '批准文号',
  `manufacturer` varchar(255) DEFAULT NULL COMMENT '生产厂家',
  `brand` varchar(255) DEFAULT NULL COMMENT '品牌',
  `shelf_life` varchar(255) DEFAULT NULL COMMENT '保质期',
  `dealer_id` int(11) DEFAULT NULL,
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` timestamp NULL DEFAULT NULL COMMENT '更新时间',
  `is_del` tinyint(4) DEFAULT '0' COMMENT '是否删除 0正常 1回收站',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4;

-- ----------------------------
--  Records of `ctc_dealer_product`
-- ----------------------------
BEGIN;
INSERT INTO `ctc_dealer_product` VALUES ('1', '3', '3', '10', '3', '3', '3', '3', '草拟吗', '3', '[{\"name\":\"95363202111242256268722.png\",\"url\":\"https://cdn.icloudapi.cn/95363202111242256268722.png\"}]', '3', '3', '<p>3</p>', '3', '3', '3', '3', '3', '3', '3', '23', '2021-11-24 14:28:17', null, '0'), ('2', '563', '3', '10', '210', '021', '021', '021', '254', '25', '[{\"url\":\"https://cdn.icloudapi.cn/d146b202111211336118366.jpg\",\"name\":\"d146b202111211336118366.jpg\"},{\"url\":\"https://cdn.icloudapi.cn/c1c86202111231856227223.png\",\"name\":\"c1c86202111231856227223.png\"}]', '245', '254', '<p>245</p><p>fsd;fksksd;f</p><p><img src=\"http://localhost/static/mainImgs/20220116/9c143d2d8f975970f5b0718c750c60c3.png\"></p>', '254', '245', '21', '25424', '25', '2542', '254', '23', '2021-12-07 00:12:01', null, '0'), ('3', '000001', '3', '10', '00000001', '1kg', '20', '10', '赵县鸭梨', '个', '[{\"url\":\"https://cdn.icloudapi.cn/32d17202202100852475252.jpeg\",\"name\":\"32d17202202100852475252.jpeg\"}]', '5元', '10元', '<p>	<span style=\"color: rgb(51, 51, 51); background-color: rgb(255, 255, 255);\">鸭梨，是一种</span>	<a href=\"https://baike.baidu.com/item/%E7%99%BD%E6%A2%A8/80109\" rel=\"noopener noreferrer\" target=\"_blank\" style=\"color: rgb(19, 110, 194); background-color: rgb(255, 255, 255);\">白梨</a>	<span style=\"color: rgb(51, 51, 51); background-color: rgb(255, 255, 255);\">，为</span>	<a href=\"https://baike.baidu.com/item/%E6%B2%B3%E5%8C%97/65777\" rel=\"noopener noreferrer\" target=\"_blank\" style=\"color: rgb(19, 110, 194); background-color: rgb(255, 255, 255);\">河北</a>	<span style=\"color: rgb(51, 51, 51); background-color: rgb(255, 255, 255);\">省魏县古老地方品种。因梨梗部突起，状似鸭头而得名。鸭梨适应性强，丰产性好，果实大而美，肉质细脆多汁，香甜，较耐贮。适宜在</span>	<a href=\"https://baike.baidu.com/item/%E9%BB%84%E6%B7%AE%E6%B5%B7%E5%B9%B3%E5%8E%9F/7580257\" rel=\"noopener noreferrer\" target=\"_blank\" style=\"color: rgb(19, 110, 194); background-color: rgb(255, 255, 255);\">黄淮海平原</a>	<span style=\"color: rgb(51, 51, 51); background-color: rgb(255, 255, 255);\">沙地栽培。另外鸭状梨在白梨、沙梨、青梨中均有，但主要是指白梨，因此也称之为白梨。</span></p><p><span style=\"color: rgb(51, 51, 51); background-color: rgb(255, 255, 255);\">﻿</span><img src=\"http://localhost/static/mainImgs/20220210/05547a1e8ad8468c900c0943b30be3e7.jpeg\"></p>', '1', '1kg', '10天', '000001', '赵县鸭梨厂', '赵县鸭梨', '1', '23', '2022-02-10 08:57:19', null, '0');
COMMIT;

-- ----------------------------
--  Table structure for `ctc_dealer_product_class`
-- ----------------------------
DROP TABLE IF EXISTS `ctc_dealer_product_class`;
CREATE TABLE `ctc_dealer_product_class` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `class_name` varchar(255) DEFAULT NULL,
  `parent_id` int(11) DEFAULT '0',
  `order` int(11) DEFAULT NULL,
  `dealer_id` int(11) DEFAULT NULL,
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4;

-- ----------------------------
--  Records of `ctc_dealer_product_class`
-- ----------------------------
BEGIN;
INSERT INTO `ctc_dealer_product_class` VALUES ('3', '一级55', '0', '8', '23', '2021-11-22 23:17:01'), ('10', 'ds', '3', '2', '23', '2021-11-22 23:57:20'), ('11', '3564564', '3', '55', '23', '2021-11-23 16:48:01'), ('12', '4', '0', '2', '23', '2021-11-22 23:17:01');
COMMIT;

-- ----------------------------
--  Table structure for `ctc_dealer_qrcode_type`
-- ----------------------------
DROP TABLE IF EXISTS `ctc_dealer_qrcode_type`;
CREATE TABLE `ctc_dealer_qrcode_type` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `type_name` varchar(255) DEFAULT NULL,
  `dealer_id` int(11) DEFAULT NULL,
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4;

-- ----------------------------
--  Records of `ctc_dealer_qrcode_type`
-- ----------------------------
BEGIN;
INSERT INTO `ctc_dealer_qrcode_type` VALUES ('3', 'dsadas', '23', '2021-11-17 21:36:52');
COMMIT;

-- ----------------------------
--  Table structure for `ctc_dealer_redpack`
-- ----------------------------
DROP TABLE IF EXISTS `ctc_dealer_redpack`;
CREATE TABLE `ctc_dealer_redpack` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `type` tinyint(4) NOT NULL COMMENT '红包类型',
  `money` varchar(255) DEFAULT NULL,
  `random_min_money` varchar(255) DEFAULT NULL COMMENT '随机金额 最小值',
  `random_max_money` varchar(255) DEFAULT NULL COMMENT '随机金额最大值',
  `issuer` varchar(255) DEFAULT NULL COMMENT '发放者',
  `remark` varchar(255) DEFAULT NULL COMMENT '红包说明',
  `instructions` varchar(255) DEFAULT NULL COMMENT '使用说明',
  `is_random` tinyint(4) DEFAULT '1' COMMENT '1默认固定 2随机',
  `status` tinyint(4) DEFAULT '0' COMMENT '0启用 1禁用',
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `dealer_id` int(11) DEFAULT NULL,
  `create_by` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4;

-- ----------------------------
--  Records of `ctc_dealer_redpack`
-- ----------------------------
BEGIN;
INSERT INTO `ctc_dealer_redpack` VALUES ('1', '1', '1', '', '', '', '2', '3', '1', '0', '2021-12-08 10:25:57', '23', 'wenhan'), ('2', '1', '1', '', '', '', '2', '3', '1', '0', '2021-12-08 10:31:04', '23', 'wenhan'), ('3', '2', '1', '', '', 'deeeeee', '2', '3', '1', '0', '2021-12-08 10:31:31', '23', 'wenhan'), ('4', '3', '1', '', '', 'deeeeee', '2', '3', '1', '0', '2021-12-08 10:31:53', '23', 'wenhan'), ('5', '1', '1', 'e', 'ee', 'deeeeee', '2333', '3', '2', '0', '2021-12-08 10:32:07', '23', 'wenhan'), ('6', '3', '22', null, null, null, '2', '2', '1', '1', '2021-12-08 11:23:42', '23', 'wenhan');
COMMIT;

-- ----------------------------
--  Table structure for `ctc_dealer_role`
-- ----------------------------
DROP TABLE IF EXISTS `ctc_dealer_role`;
CREATE TABLE `ctc_dealer_role` (
  `roleId` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `dealerId` int(11) DEFAULT NULL,
  `roleName` varchar(255) DEFAULT NULL,
  `roleKey` varchar(255) DEFAULT NULL COMMENT '标识字符',
  `roleSort` varchar(255) DEFAULT NULL,
  `admin` varchar(255) DEFAULT '0' COMMENT '是否管理员角色',
  `remark` varchar(255) DEFAULT NULL,
  `status` varchar(4) DEFAULT '0',
  `createTime` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `createBy` varchar(255) DEFAULT NULL,
  `checkedKeys` varchar(255) DEFAULT NULL,
  `menuIds` varchar(255) DEFAULT NULL,
  `menuCheckStrictly` varchar(255) DEFAULT '0',
  `deptCheckStrictly` varchar(255) DEFAULT '0',
  PRIMARY KEY (`roleId`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4;

-- ----------------------------
--  Records of `ctc_dealer_role`
-- ----------------------------
BEGIN;
INSERT INTO `ctc_dealer_role` VALUES ('1', '23', 'fuck', 'common', '0', '0', 'test', '0', '2021-11-13 18:25:42', null, null, '1,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57', '1', '1');
COMMIT;

-- ----------------------------
--  Table structure for `ctc_dealer_salesman`
-- ----------------------------
DROP TABLE IF EXISTS `ctc_dealer_salesman`;
CREATE TABLE `ctc_dealer_salesman` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `salesman_code` varchar(255) DEFAULT NULL,
  `username` varchar(255) DEFAULT NULL,
  `phone` varchar(255) DEFAULT NULL,
  `password` varchar(255) DEFAULT NULL,
  `type` int(11) DEFAULT NULL COMMENT '业务员类型',
  `region` varchar(255) DEFAULT NULL COMMENT '管理范围',
  `zone` varchar(255) DEFAULT NULL COMMENT '管理区域 id拼接',
  `distributor` varchar(255) DEFAULT NULL COMMENT '指定客户 经销商',
  `store` varchar(255) DEFAULT NULL COMMENT '指定客户 门店',
  `remark` varchar(255) DEFAULT NULL COMMENT '备注',
  `status` varchar(255) DEFAULT '1' COMMENT '门店状态  字典获取翻译',
  `dealer_id` int(11) DEFAULT NULL,
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4;

-- ----------------------------
--  Records of `ctc_dealer_salesman`
-- ----------------------------
BEGIN;
INSERT INTO `ctc_dealer_salesman` VALUES ('1', 'test', 'wenjhan', '18330118047', '123456', '2', '', '2,4,7,13', '', '', '123456', '1', '23', '2022-01-08 17:43:06');
COMMIT;

-- ----------------------------
--  Table structure for `ctc_dealer_salesman_type`
-- ----------------------------
DROP TABLE IF EXISTS `ctc_dealer_salesman_type`;
CREATE TABLE `ctc_dealer_salesman_type` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `class_name` varchar(255) DEFAULT NULL,
  `dealer_id` int(11) DEFAULT NULL,
  `remark` varchar(255) DEFAULT NULL,
  `status` tinyint(4) DEFAULT '0' COMMENT '状态0正常 1删除',
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4;

-- ----------------------------
--  Records of `ctc_dealer_salesman_type`
-- ----------------------------
BEGIN;
INSERT INTO `ctc_dealer_salesman_type` VALUES ('1', '测试啦', '23', 'fucks', '1', '2022-01-08 16:38:28'), ('2', '测试啦', '23', 'test', '0', '2022-01-08 16:39:22'), ('3', '74', '23', '47', '0', '2022-01-13 00:24:45');
COMMIT;

-- ----------------------------
--  Table structure for `ctc_dealer_security_query_log`
-- ----------------------------
DROP TABLE IF EXISTS `ctc_dealer_security_query_log`;
CREATE TABLE `ctc_dealer_security_query_log` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `dealer_id` int(11) NOT NULL,
  `code_batch` varchar(255) DEFAULT NULL COMMENT '码批次',
  `code` varchar(255) DEFAULT NULL COMMENT '溯源码',
  `is_first` tinyint(4) DEFAULT '0' COMMENT '是否是第一次查询0是 1否',
  `member_id` int(11) DEFAULT NULL,
  `scan_type` varchar(255) DEFAULT NULL COMMENT '扫码方式 字典翻译',
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=125 DEFAULT CHARSET=utf8mb4;

-- ----------------------------
--  Records of `ctc_dealer_security_query_log`
-- ----------------------------
BEGIN;
INSERT INTO `ctc_dealer_security_query_log` VALUES ('80', '23', '202201231642926120', '454973043699', '1', '1', '3', '2022-02-10 09:20:06'), ('81', '23', '202201231642926120', '454973043699', '0', '1', '1', '2022-02-10 09:46:44'), ('82', '23', '202201231642926120', '454973043699', '0', '1', '3', '2022-02-10 09:46:44'), ('83', '23', '202201231642926120', '454973043699', '0', '1', '3', '2022-02-10 09:47:04'), ('84', '23', '202201231642926120', '454973043699', '0', '1', '3', '2022-02-10 09:49:06'), ('85', '23', '202201231642926120', '454973043699', '0', '1', '3', '2022-02-10 09:49:13'), ('86', '23', '202201231642926120', '454973043699', '0', '1', '3', '2022-02-10 09:50:10'), ('87', '23', '202201231642926120', '454973043699', '0', '1', '3', '2022-02-10 09:50:15'), ('88', '23', '202201231642926120', '454973043699', '0', '1', '3', '2022-02-10 09:51:05'), ('89', '23', '202201231642926120', '454973043699', '0', '1', '3', '2022-02-10 09:51:06'), ('90', '23', '202201231642926120', '454973043699', '0', '1', '3', '2022-02-10 09:51:07'), ('91', '23', '202201231642926120', '454973043699', '0', '1', '3', '2022-02-10 09:51:07'), ('92', '23', '202201231642926120', '454973043699', '0', '1', '3', '2022-02-10 09:51:08'), ('93', '23', '202201231642926120', '454973043699', '0', '1', '3', '2022-02-10 09:51:14'), ('94', '23', '202201231642926120', '454973043699', '0', '1', '3', '2022-02-10 09:51:20'), ('95', '23', '202201231642926120', '454973043699', '0', '1', '3', '2022-02-10 09:51:21'), ('96', '23', '202201231642926120', '454973043699', '0', '1', '3', '2022-02-10 09:51:30'), ('97', '23', '202201231642926120', '454973043699', '0', '1', '3', '2022-02-10 09:59:07'), ('98', '23', '202201231642926120', '454973043699', '0', '1', '3', '2022-02-10 09:59:10'), ('99', '23', '202201231642926120', '454973043699', '0', '1', '3', '2022-02-10 10:01:35'), ('100', '23', '202201231642926120', '454973043699', '0', '1', '3', '2022-02-10 10:01:37'), ('101', '23', '202201231642926120', '454973043699', '0', '1', '3', '2022-02-10 10:01:38'), ('102', '23', '202201231642926120', '454973043699', '0', '1', '3', '2022-02-10 10:01:41'), ('103', '23', '202201231642926120', '454973043699', '0', '1', '3', '2022-02-10 10:01:43'), ('104', '23', '202201231642926120', '454973043699', '0', '1', '3', '2022-02-10 10:01:46'), ('105', '23', '202201231642926120', '454973043699', '0', '1', '3', '2022-02-10 10:03:34'), ('106', '23', '202201231642926120', '454973043699', '0', '1', '3', '2022-02-10 10:03:37'), ('107', '23', '202201231642926120', '454973043699', '0', '1', '3', '2022-02-10 10:04:44'), ('108', '23', '202201231642926120', '454973043699', '0', '1', '3', '2022-02-10 10:04:46'), ('109', '23', '202201231642926120', '454973043699', '0', '1', '3', '2022-02-10 10:04:52'), ('110', '23', '202201231642926120', '454973043699', '0', '1', '3', '2022-02-10 10:04:53'), ('111', '23', '202201231642926120', '454973043699', '0', '1', '3', '2022-02-10 10:04:56'), ('112', '23', '202201231642926120', '454973043699', '0', '1', '3', '2022-02-10 10:05:00'), ('113', '23', '202201231642926120', '454973043699', '0', '1', '3', '2022-02-10 10:05:02'), ('114', '23', '202201231642926120', '454973043699', '0', '1', '3', '2022-02-10 10:05:50'), ('115', '23', '202201231642926120', '454973043699', '0', '1', '3', '2022-02-10 10:05:56'), ('116', '23', '202201231642926120', '454973043699', '0', '1', '3', '2022-02-10 10:06:26'), ('117', '23', '202201231642926120', '454973043699', '0', '1', '3', '2022-02-10 10:06:33'), ('118', '23', '202201231642926120', '454973043699', '0', '1', '3', '2022-02-10 10:07:57'), ('119', '23', '202201231642926120', '454973043699', '0', '1', '3', '2022-02-10 10:07:59'), ('120', '23', '202201231642926120', '454973043699', '0', '1', '1', '2022-02-10 10:19:55'), ('121', '23', '202201231642926120', '454973043699', '0', '1', '3', '2022-02-10 10:19:55'), ('122', '23', '202201231642926120', '454973043699', '0', '1', '3', '2022-02-10 10:23:38'), ('123', '23', '202201231642926120', '454973043699', '0', '1', '1', '2022-02-10 10:27:18'), ('124', '23', '202201231642926120', '454973043699', '0', '1', '3', '2022-02-10 10:27:20');
COMMIT;

-- ----------------------------
--  Table structure for `ctc_dealer_sms_early_warning`
-- ----------------------------
DROP TABLE IF EXISTS `ctc_dealer_sms_early_warning`;
CREATE TABLE `ctc_dealer_sms_early_warning` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `num` varchar(255) DEFAULT NULL,
  `phone` varchar(255) DEFAULT NULL,
  `dealer_id` int(11) DEFAULT NULL,
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `status` tinyint(4) DEFAULT NULL COMMENT '0未开启 1开启预警',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4;

-- ----------------------------
--  Records of `ctc_dealer_sms_early_warning`
-- ----------------------------
BEGIN;
INSERT INTO `ctc_dealer_sms_early_warning` VALUES ('1', '10', '18330118047', '23', '2021-11-22 17:19:19', '0');
COMMIT;

-- ----------------------------
--  Table structure for `ctc_dealer_sms_log`
-- ----------------------------
DROP TABLE IF EXISTS `ctc_dealer_sms_log`;
CREATE TABLE `ctc_dealer_sms_log` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `type` tinyint(4) DEFAULT NULL,
  `phone` varchar(255) DEFAULT NULL,
  `content` varchar(255) DEFAULT NULL,
  `dealer_id` int(11) DEFAULT NULL,
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
--  Table structure for `ctc_dealer_store`
-- ----------------------------
DROP TABLE IF EXISTS `ctc_dealer_store`;
CREATE TABLE `ctc_dealer_store` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `store_code` varchar(255) DEFAULT NULL,
  `type` int(11) DEFAULT NULL COMMENT '门店类型',
  `province` varchar(255) DEFAULT NULL,
  `city` varchar(255) DEFAULT NULL,
  `district` varchar(255) DEFAULT NULL,
  `address` varchar(255) DEFAULT NULL COMMENT '详细地址',
  `gps` varchar(255) DEFAULT NULL,
  `cover` varchar(255) DEFAULT NULL COMMENT '门店图片',
  `time` varchar(255) DEFAULT NULL,
  `telephone` varchar(255) DEFAULT NULL COMMENT '门店电话',
  `mobile_phone` varchar(255) DEFAULT NULL COMMENT '手机号',
  `password` varchar(255) DEFAULT NULL,
  `zone` varchar(255) DEFAULT NULL,
  `store_name` varchar(255) DEFAULT NULL,
  `average_price` varchar(255) DEFAULT NULL,
  `person` varchar(255) DEFAULT NULL COMMENT '负责人',
  `introduce` text COMMENT '简介',
  `status` varchar(11) DEFAULT '1' COMMENT '门店状态 1正常2禁用 3删除 字典获取',
  `dealer_id` int(11) DEFAULT NULL,
  `is_self` tinyint(4) DEFAULT '0' COMMENT '是否直营门店 0直营 1非直营',
  `attribute` tinyint(4) DEFAULT NULL COMMENT '非自营门店属性 直属总部1  非直属2 ',
  `distributor_id` int(11) DEFAULT NULL COMMENT '非自营门店所属经销商',
  `distributor_name` varchar(255) DEFAULT NULL,
  `check_status` tinyint(4) DEFAULT '1' COMMENT '审核状态0待审核 1审核通过 2审核未通过',
  `balance` decimal(8,2) DEFAULT '0.00' COMMENT '余额',
  `points_num` decimal(8,2) DEFAULT '0.00' COMMENT '积分数',
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4;

-- ----------------------------
--  Records of `ctc_dealer_store`
-- ----------------------------
BEGIN;
INSERT INTO `ctc_dealer_store` VALUES ('1', '7868', '1', '河北省', '秦皇岛市', '山海关区', '687jjjjj', '39.985814,116.309549', '[{\"url\":\"https://cdn.icloudapi.cn/d146b202111211336118366.jpg\",\"name\":\"d146b202111211336118366.jpg\"}]', '[\"2022-01-13\",\"2022-02-16\"]', '676', '45645', '6456', '9', '645', '645', '6456', '645645', '1', '23', '0', null, null, null, '1', '-200.00', '11.00', '2022-01-03 21:28:40'), ('2', 'gfhf', '1', '天津市', '市辖区', '和平区', 'hgfhgf', '39.984256,116.307414', '[{\"url\":\"https://cdn.icloudapi.cn/d146b202111211336118366.jpg\",\"name\":\"d146b202111211336118366.jpg\"}]', '[\"2022-01-13\",\"2022-02-16\"]', 'grdfg', 'fgd', 'gdfg', '3', 'gdfg', 'gdf', 'gdfg', 'gdf', '1', '23', '1', '2', '1', 'woei', '1', '200.00', '3.00', '2022-01-03 23:00:51');
COMMIT;

-- ----------------------------
--  Table structure for `ctc_dealer_store_bill`
-- ----------------------------
DROP TABLE IF EXISTS `ctc_dealer_store_bill`;
CREATE TABLE `ctc_dealer_store_bill` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `store_id` int(11) DEFAULT NULL,
  `pm` tinyint(4) DEFAULT '0' COMMENT '0 = 支出 1 = 获得',
  `category` varchar(255) DEFAULT NULL COMMENT '明细种类',
  `number` decimal(8,2) DEFAULT NULL COMMENT '变动数量',
  `balance` decimal(8,2) DEFAULT NULL COMMENT '余额',
  `remark` varchar(255) DEFAULT NULL COMMENT '备注',
  `status` tinyint(4) DEFAULT NULL COMMENT '0 = 待确定 1 = 有效 2 = 无效',
  `bill_type` tinyint(4) DEFAULT '0' COMMENT '明细类型 0佣金 1积分',
  `create_by` varchar(255) DEFAULT NULL,
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COMMENT='门店资金记录表';

-- ----------------------------
--  Records of `ctc_dealer_store_bill`
-- ----------------------------
BEGIN;
INSERT INTO `ctc_dealer_store_bill` VALUES ('1', '1', '1', '1', '11.00', '20.00', 'test', null, '0', null, '2022-01-05 21:11:35'), ('2', '1', '1', '5', '100.00', null, '提现驳回资金回退', null, '0', null, '2022-01-05 23:30:47'), ('3', '2', '1', '5', '200.00', '200.00', '提现驳回资金回退', null, '0', null, '2022-01-05 23:38:40'), ('4', '1', '0', '3', '100.00', '-100.00', '提现到账', null, '0', null, '2022-01-05 23:49:11'), ('5', '1', '0', '3', '100.00', '-200.00', '提现到账', null, '0', null, '2022-01-05 23:54:27'), ('6', '1', '1', '', '3.00', '15.00', '积分增减', null, '1', 'wenhan', '2022-01-06 21:05:24'), ('7', '1', '0', '', '-4.00', '11.00', '手动增减积分', null, '1', 'wenhan', '2022-01-06 21:24:50'), ('8', '2', '1', '', '3.00', '3.00', '手动增减积分', null, '1', 'wenhan', '2022-01-06 21:25:46');
COMMIT;

-- ----------------------------
--  Table structure for `ctc_dealer_store_cash_bill`
-- ----------------------------
DROP TABLE IF EXISTS `ctc_dealer_store_cash_bill`;
CREATE TABLE `ctc_dealer_store_cash_bill` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `order` varchar(255) DEFAULT NULL,
  `store_id` int(11) DEFAULT NULL,
  `cash_money` decimal(8,2) DEFAULT NULL COMMENT '提现金额',
  `get_money` decimal(8,2) DEFAULT NULL COMMENT '到账金额',
  `type` tinyint(4) DEFAULT NULL COMMENT '提现方式',
  `status` tinyint(4) DEFAULT NULL COMMENT '提现状态',
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '申请时间',
  `issue_time` timestamp NULL DEFAULT NULL COMMENT '发放时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4;

-- ----------------------------
--  Records of `ctc_dealer_store_cash_bill`
-- ----------------------------
BEGIN;
INSERT INTO `ctc_dealer_store_cash_bill` VALUES ('1', 'fodjfdfd', '1', '100.00', '80.00', '1', '4', '2022-01-05 22:33:49', '2022-01-05 23:54:27');
COMMIT;

-- ----------------------------
--  Table structure for `ctc_dealer_store_cash_rule`
-- ----------------------------
DROP TABLE IF EXISTS `ctc_dealer_store_cash_rule`;
CREATE TABLE `ctc_dealer_store_cash_rule` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `cash_type` varchar(4) DEFAULT '1' COMMENT '提现方式 1线下 2商户自转',
  `cash_min` decimal(8,2) DEFAULT NULL COMMENT '提现门槛',
  `cash_max` decimal(8,2) DEFAULT NULL COMMENT '提现上限',
  `cash_times` int(11) DEFAULT '1' COMMENT '每日提现次数',
  `cash_charge` decimal(8,2) DEFAULT NULL COMMENT '提现手续费',
  `cash_settle_charge` decimal(8,2) DEFAULT NULL COMMENT '自营商品结算手续费',
  `dealer_id` int(11) DEFAULT NULL,
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

-- ----------------------------
--  Records of `ctc_dealer_store_cash_rule`
-- ----------------------------
BEGIN;
INSERT INTO `ctc_dealer_store_cash_rule` VALUES ('1', '1', '1.00', '1.00', '1', '3.00', '1.00', '23', '2022-01-06 00:15:03');
COMMIT;

-- ----------------------------
--  Table structure for `ctc_dealer_store_clerk`
-- ----------------------------
DROP TABLE IF EXISTS `ctc_dealer_store_clerk`;
CREATE TABLE `ctc_dealer_store_clerk` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `clerk_code` varchar(255) DEFAULT NULL,
  `clerk_name` varchar(255) DEFAULT NULL,
  `phone` varchar(255) DEFAULT NULL,
  `remark` varchar(255) DEFAULT NULL,
  `role_id` tinyint(4) DEFAULT NULL COMMENT '1店长 2店员',
  `store_id` int(11) DEFAULT NULL COMMENT '所属门店',
  `is_self` tinyint(4) DEFAULT NULL COMMENT '是否直营 1直营 2非直营',
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `login_time` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4;

-- ----------------------------
--  Records of `ctc_dealer_store_clerk`
-- ----------------------------
BEGIN;
INSERT INTO `ctc_dealer_store_clerk` VALUES ('1', 'wenhan', '文寒', '18330118047', 'fuck', '1', '1', '1', '2022-01-04 23:59:31', null);
COMMIT;

-- ----------------------------
--  Table structure for `ctc_dealer_store_type`
-- ----------------------------
DROP TABLE IF EXISTS `ctc_dealer_store_type`;
CREATE TABLE `ctc_dealer_store_type` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `class_name` varchar(255) DEFAULT NULL,
  `dealer_id` int(11) DEFAULT NULL,
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `status` tinyint(4) DEFAULT '0' COMMENT '状态0正常 1删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4;

-- ----------------------------
--  Records of `ctc_dealer_store_type`
-- ----------------------------
BEGIN;
INSERT INTO `ctc_dealer_store_type` VALUES ('1', 'esdfsdf', '23', '2022-01-02 21:41:36', '0');
COMMIT;

-- ----------------------------
--  Table structure for `ctc_dealer_tax_template`
-- ----------------------------
DROP TABLE IF EXISTS `ctc_dealer_tax_template`;
CREATE TABLE `ctc_dealer_tax_template` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `dealer_id` int(11) DEFAULT NULL,
  `template_name` varchar(255) DEFAULT NULL,
  `store_id` int(11) DEFAULT NULL,
  `status` varchar(255) DEFAULT '0',
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `delete_time` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4;

-- ----------------------------
--  Records of `ctc_dealer_tax_template`
-- ----------------------------
BEGIN;
INSERT INTO `ctc_dealer_tax_template` VALUES ('1', '23', 'retre', '6', null, '2021-11-16 16:43:31', '1637052582'), ('2', '23', 'tfygrftetgfrd', '6', '1', '2021-11-16 16:49:47', null), ('3', '23', 'erew', '7', '0', '2021-11-16 17:18:48', '1637054468'), ('4', '23', 'fe\'f', '7', '0', '2021-11-16 17:20:55', '1637054474'), ('5', '23', '而为人特温特', '7', '0', '2021-11-16 17:21:02', null);
COMMIT;

-- ----------------------------
--  Table structure for `ctc_dealer_token`
-- ----------------------------
DROP TABLE IF EXISTS `ctc_dealer_token`;
CREATE TABLE `ctc_dealer_token` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `uid` int(11) DEFAULT NULL,
  `token` varchar(255) DEFAULT NULL,
  `login_ip` varchar(32) DEFAULT NULL,
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP,
  `expires_time` datetime DEFAULT NULL,
  `dealer_id` int(11) DEFAULT NULL COMMENT '代理商id 用来区分角色token',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=161 DEFAULT CHARSET=utf8mb4;

-- ----------------------------
--  Records of `ctc_dealer_token`
-- ----------------------------
BEGIN;
INSERT INTO `ctc_dealer_token` VALUES ('8', '2', 'e6b8bd9435743b41cfc2feb9a8867906b6689e6d', '127.0.0.1', '2021-11-13 23:33:35', '2021-11-14 11:33:35', '23'), ('160', '23', '741497f31e48adf8483c9829db89e05a32d9b404', '127.0.0.1', '2022-04-05 01:19:59', '2022-04-05 13:19:59', null);
COMMIT;

-- ----------------------------
--  Table structure for `ctc_dealer_trace_code_batch`
-- ----------------------------
DROP TABLE IF EXISTS `ctc_dealer_trace_code_batch`;
CREATE TABLE `ctc_dealer_trace_code_batch` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `code_batch` varchar(255) DEFAULT NULL COMMENT '码批次',
  `is_serial_number` tinyint(4) DEFAULT '0' COMMENT '是否按流水号区间设置0否 1是',
  `order_begin` varchar(255) DEFAULT NULL,
  `order_end` varchar(255) DEFAULT NULL,
  `quantity` int(11) DEFAULT NULL,
  `product_batch` varchar(255) DEFAULT NULL COMMENT '生产批次',
  `status` tinyint(4) DEFAULT '0' COMMENT '删除状态0正常 1删除',
  `dealer_id` int(11) DEFAULT NULL,
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=utf8mb4;

-- ----------------------------
--  Records of `ctc_dealer_trace_code_batch`
-- ----------------------------
BEGIN;
INSERT INTO `ctc_dealer_trace_code_batch` VALUES ('7', '202112151639581497', '1', '11', '12', '2', '54541515', '0', '23', '2022-01-14 22:39:14'), ('9', '202112151639581497', '1', '13', '14', '2', '54541515', '0', '23', '2022-01-14 22:44:29'), ('12', '202112151639581497', '1', '15', '15', '1', '565161', '0', '23', '2022-01-16 15:28:18'), ('13', '202112151639581497', '1', '12', '14', '3', '565161', '0', '23', '2022-01-22 18:38:44'), ('14', '202201231642926120', '1', '716', '750', '35', '565161', '0', '23', '2022-01-23 16:23:26'), ('20', '202112171639749646', '0', '', '', '199', '565161', '0', '23', '2022-02-09 23:17:17'), ('21', '202201231642926120', '1', '751', '815', '65', '000001', '0', '23', '2022-02-10 09:07:20');
COMMIT;

-- ----------------------------
--  Table structure for `ctc_dealer_trace_product_batch`
-- ----------------------------
DROP TABLE IF EXISTS `ctc_dealer_trace_product_batch`;
CREATE TABLE `ctc_dealer_trace_product_batch` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `product_batch` varchar(255) DEFAULT NULL COMMENT '生产批次号',
  `product_id` int(11) DEFAULT NULL COMMENT '关联产品',
  `remark` varchar(255) DEFAULT NULL,
  `template_id` int(11) DEFAULT NULL COMMENT '溯源页面模板',
  `batch_content` text COMMENT '批次内容',
  `dealer_id` int(11) DEFAULT NULL,
  `status` tinyint(4) DEFAULT '0' COMMENT '状态0正常 1删除',
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4;

-- ----------------------------
--  Records of `ctc_dealer_trace_product_batch`
-- ----------------------------
BEGIN;
INSERT INTO `ctc_dealer_trace_product_batch` VALUES ('1', '4551', '2', '652', '1', '[{\"title\":\"\\u73af\\u82821\",\"name\":\"1\",\"content\":\"<p>\\u73af\\u82821<img src=\\\"https:\\/\\/cdn.icloudapi.cn\\/40308202201122356554145.jpg\\\"><\\/p><p>wlijdelwakijd<\\/p><p>\\ud83d\\ude1d<\\/p>\"}]', '23', '1', '2022-01-13 00:02:04'), ('2', 'sdasas', '2', '656+', '8', '[{\"title\":\"\\u73af\\u82821\",\"name\":\"1\",\"content\":\"\\u73af\\u82821\"},{\"title\":\"\\u73af\\u82822\",\"name\":\"2\",\"content\":\"\\u73af\\u82822\"}]', '23', '1', '2022-01-13 20:33:33'), ('3', '54541515', '2', '656+', '8', '\"[{\\\"title\\\":\\\"\\\\u73af\\\\u82821\\\",\\\"name\\\":\\\"1\\\",\\\"content\\\":\\\"\\\\u73af\\\\u82821\\\"},{\\\"title\\\":\\\"\\\\u73af\\\\u82822\\\",\\\"name\\\":\\\"2\\\",\\\"content\\\":\\\"\\\\u73af\\\\u82822\\\"}]\"', '23', '1', '2022-01-13 21:35:15'), ('4', '2135', '2', '3423', '4', '[{\"title\":\"\\u73af\\u82821\",\"name\":\"1\",\"content\":\"\\u73af\\u82821\"},{\"title\":\"\\u73af\\u82822\",\"name\":\"2\",\"content\":\"<p>\\u73af\\u82822312321<\\/p>\"}]', '23', '0', '2022-01-14 23:13:49'), ('5', '565161', '2', '4515', '10', '[{\"title\":\"\\u73af\\u82821\",\"name\":\"1\",\"content\":\"<p>\\u73af\\u82821<\\/p><p>dskjlaskjdasld<\\/p><p><img src=\\\"https:\\/\\/cdn.icloudapi.cn\\/6607e202201250111595717.jpeg\\\"><\\/p>\"},{\"title\":\"\\u73af\\u82822\",\"name\":\"2\",\"content\":\"\\u73af\\u82822\"},{\"title\":\"\\u73af\\u82823\",\"name\":\"3\",\"content\":\"\\u73af\\u82823\"},{\"title\":\"\\u73af\\u82824\",\"name\":\"4\",\"content\":\"\\u73af\\u82824\"}]', '23', '0', '2022-01-16 15:18:39'), ('6', '000001', '3', '赵县鸭梨', '11', '[{\"title\":\"\\u4ea7\\u5730\",\"name\":\"1\",\"content\":\"<p>\\t<span style=\\\"background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);\\\">\\u9e2d\\u68a8\\uff0c\\u662f\\u4e00\\u79cd<\\/span>\\t<a href=\\\"https:\\/\\/baike.baidu.com\\/item\\/%E7%99%BD%E6%A2%A8\\/80109\\\" rel=\\\"noopener noreferrer\\\" target=\\\"_blank\\\" style=\\\"background-color: rgb(255, 255, 255); color: rgb(19, 110, 194);\\\">\\u767d\\u68a8<\\/a>\\t<span style=\\\"background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);\\\">\\uff0c\\u4e3a<\\/span>\\t<a href=\\\"https:\\/\\/baike.baidu.com\\/item\\/%E6%B2%B3%E5%8C%97\\/65777\\\" rel=\\\"noopener noreferrer\\\" target=\\\"_blank\\\" style=\\\"background-color: rgb(255, 255, 255); color: rgb(19, 110, 194);\\\">\\u6cb3\\u5317<\\/a>\\t<span style=\\\"background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);\\\">\\u7701\\u9b4f\\u53bf\\u53e4\\u8001\\u5730\\u65b9\\u54c1\\u79cd\\u3002\\u56e0\\u68a8\\u6897\\u90e8\\u7a81\\u8d77\\uff0c\\u72b6\\u4f3c\\u9e2d\\u5934\\u800c\\u5f97\\u540d\\u3002\\u9e2d\\u68a8\\u9002\\u5e94\\u6027\\u5f3a\\uff0c\\u4e30\\u4ea7\\u6027\\u597d\\uff0c\\u679c\\u5b9e\\u5927\\u800c\\u7f8e\\uff0c\\u8089\\u8d28\\u7ec6\\u8106\\u591a\\u6c41\\uff0c\\u9999\\u751c\\uff0c\\u8f83\\u8010\\u8d2e\\u3002\\u9002\\u5b9c\\u5728<\\/span>\\t<a href=\\\"https:\\/\\/baike.baidu.com\\/item\\/%E9%BB%84%E6%B7%AE%E6%B5%B7%E5%B9%B3%E5%8E%9F\\/7580257\\\" rel=\\\"noopener noreferrer\\\" target=\\\"_blank\\\" style=\\\"background-color: rgb(255, 255, 255); color: rgb(19, 110, 194);\\\">\\u9ec4\\u6dee\\u6d77\\u5e73\\u539f<\\/a>\\t<span style=\\\"background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);\\\">\\u6c99\\u5730\\u683d\\u57f9\\u3002\\u53e6\\u5916\\u9e2d\\u72b6\\u68a8\\u5728\\u767d\\u68a8\\u3001\\u6c99\\u68a8\\u3001\\u9752\\u68a8\\u4e2d\\u5747\\u6709\\uff0c\\u4f46\\u4e3b\\u8981\\u662f\\u6307\\u767d\\u68a8\\uff0c\\u56e0\\u6b64\\u4e5f\\u79f0\\u4e4b\\u4e3a\\u767d\\u68a8\\u3002<\\/span><\\/p><p><span style=\\\"background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);\\\"><span class=\\\"ql-cursor\\\">\\ufeff<\\/span><\\/span><img src=\\\"https:\\/\\/cdn.icloudapi.cn\\/4bc4f202202100906183856.jpeg\\\"><\\/p>\"},{\"title\":\"\\u52a0\\u5de5\",\"name\":\"2\",\"content\":\"<p>\\t<strong>\\u4e00\\u3001\\u65e9\\u65bd\\u57fa\\u80a5\\uff0c\\u589e\\u65bd\\u78f7\\u80a5\\uff0c\\u63a7\\u5236\\u6c2e\\u80a5\\uff0c\\u786e\\u4fdd\\u4e09\\u6c34<\\/strong><\\/p><p>\\t\\uff08\\u4e00\\uff09\\u65e9\\u65bd\\u57fa\\u80a5\\uff1a\\u8fc7\\u53bb\\u4f20\\u7edf\\u7684\\u65bd\\u57fa\\u80a5\\u65f6\\u95f4\\u5e94\\u63d0\\u65e9\\u5230\\u79cb\\u5b63\\u679c\\u5b9e\\u91c7\\u6536\\u540e\\uff089\\u6708-10\\u6708\\uff09\\u3002\\u56e0\\u4e3a\\u8fd9\\u65f6\\u7ed3\\u679c\\u6811\\u4f53\\u5185\\u8425\\u517b\\u6d88\\u8017\\u5df2\\u975e\\u5e38\\u5927\\uff0c\\u6839\\u7cfb\\u5c06\\u51fa\\u73b0\\u5168\\u5e74\\u6700\\u540e\\u4e00\\u6b21\\u751f\\u957f\\u9ad8\\u5cf0\\u671f\\uff0c\\u63d0\\u65e9\\u9002\\u91cf\\u65bd\\u5165\\u57fa\\u80a5\\uff0c\\u53ef\\u8fbe\\u5230\\u6811\\u4f53\\u8425\\u517b\\u8865\\u4e8f\\uff0c\\u6062\\u590d\\u6811\\u52bf\\uff0c\\u5145\\u5b9e\\u82b1\\u82bd\\u4e3a\\u6765\\u5e74\\u5f00\\u82b1\\u7ed3\\u679c\\u6253\\u57fa\\u7840\\u3002<\\/p><p>\\t\\uff08\\u4e8c\\uff09\\u589e\\u65bd<a href=\\\"https:\\/\\/baike.baidu.com\\/item\\/%E7%A3%B7%E8%82%A5\\\" rel=\\\"noopener noreferrer\\\" target=\\\"_blank\\\" style=\\\"color: rgb(19, 110, 194);\\\">\\u78f7\\u80a5<\\/a>\\uff1a\\u5728\\u65bd\\u57fa\\u80a5\\u548c\\u8ffd\\u80a5\\u65f6\\uff0c\\u589e\\u52a0\\u78f7\\u80a5\\u65bd\\u7528\\u91cf\\uff0c\\u53ef\\u660e\\u663e\\u6539\\u5584\\u9e2d\\u68a8\\u7684\\u54c1\\u8d28\\u3002\\u4e00\\u822c\\u6bcf\\u767e\\u516c\\u65a4\\u679c\\u9700\\u65bd\\u7eaf\\u6c2e0.3\\u516c\\u65a4\\uff0c\\u6c2e\\u78f7\\u94be\\u7684\\u65bd\\u80a5\\u6bd4\\u4f8b\\u4e3a1:1.5:1.\\u5168\\u5e74\\u5730\\u4e0b\\u8ffd\\u80a5\\u4e24\\u6b21\\uff0c\\u840c\\u82bd\\u524d\\u4e00\\u6b21\\uff083\\u6708\\u4e2d\\u4e0b\\u65ec\\uff09\\uff0c\\u5e7c\\u679c\\u81a8\\u5927\\u671f\\u4e00\\u6b21\\uff085\\u6708\\u4efd\\uff09\\u3002<\\/p><p>\\t\\uff08\\u4e09\\uff09\\u63a7\\u5236\\u6c2e\\u80a5\\uff1a\\u6c2e\\u80a5\\u8981\\u5728\\u9ea6\\u6536\\u524d\\uff086\\u6708\\u4efd\\u524d\\uff09\\u65bd\\u8db3\\uff0c6\\u6708\\u4efd\\u540e\\u63a7\\u5236\\u4f7f\\u7528\\uff0c\\u540e\\u671f\\u65bd\\u6c2e\\u80a5\\u8fc7\\u591a\\uff0c\\u4f1a\\u9020\\u6210\\u679c\\u5b9e\\u54c1\\u8d28\\u4e0b\\u964d\\uff0c\\u98ce\\u5473\\u53d8\\u6de1\\u3002<\\/p><p>\\t\\uff08\\u56db\\uff09\\u786e\\u4fdd\\u4e09\\u6c34\\uff1a\\u4e00\\u822c\\u5e74\\u4efd\\u7ed3\\u5408\\u65bd\\u80a5\\u5168\\u5e74\\u6d47\\u6c34\\u4e09\\u6b21\\uff0c\\u6d47\\u8db3\\u6d47\\u900f\\u3002\\u9ea6\\u6536\\u540e\\u89c6\\u5929\\u6c14\\u60c5\\u51b5\\u5982\\u6301\\u7eed\\u5e72\\u65f1\\u53ef\\u518d\\u6d47\\u6c34\\u4e00\\u6b21\\u30027\\u6708-9\\u6708\\u63a7\\u5236\\u6d47\\u6c34\\u3002<\\/p><p>\\t<strong>\\u4e8c\\u3001\\u6811\\u4e0b\\u8986\\u8349\\uff0c\\u589e\\u80a5\\u4fdd\\u6e7f\\u5728\\u96e8\\u5b63\\u5230\\u6765\\u4e4b\\u524d\\u6811\\u4e0b\\u8986\\u8349\\uff0c\\u53ef\\u4fdd\\u6301\\u571f\\u58e4\\u5892\\u60c5\\uff0c\\u6291\\u5236\\u6742\\u8349\\u751f\\u957f\\u3002<\\/strong>\\u79f8\\u79c6\\u8150\\u70c2\\u540e\\u7ffb\\u5165\\u5730\\u4e0b\\uff0c\\u53ef\\u589e\\u52a0\\u571f\\u58e4\\u8150\\u6b96\\u8d28\\uff0c\\u6539\\u826f\\u571f\\u58e4\\u7ed3\\u6784\\uff0c\\u63d0\\u9ad8\\u571f\\u58e4\\u80a5\\u529b\\uff0c\\u4fc3\\u8fdb\\u68a8\\u6811\\u7684\\u751f\\u957f\\u53d1\\u80b2\\u3002<\\/p>\"},{\"title\":\"\\u5305\\u88c5\",\"name\":\"3\",\"content\":\"<p>\\t<strong style=\\\"background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);\\\">\\u9e2d\\u68a8\\u5957\\u888b\\u65f6\\u671f\\u4e00\\u822c\\u4ece5\\u670820\\u65e5\\u758f\\u5b8c\\u679c\\u540e\\u5f00\\u59cb\\u8fdb\\u884c\\uff0c\\u52306\\u670810\\u65e5\\u524d\\u5957\\u5b8c<\\/strong>\\t<span style=\\\"background-color: rgb(255, 255, 255); color: rgb(51, 51, 51);\\\">\\u3002\\u5957\\u888b\\u524d\\u5148\\u55b7\\u4e00\\u6b21\\u6740\\u83cc\\u6740\\u866b\\u6df7\\u5408\\u836f\\u5242\\uff0c\\u8fb9\\u55b7\\u836f\\u8fb9\\u5957\\u888b\\uff0c\\u5957\\u888b\\u65f6\\u888b\\u53e3\\u8981\\u9760\\u8fd1\\u679c\\u67c4\\u57fa\\u90e8\\uff0c\\u624e\\u7d27\\u624e\\u4e25\\uff0c\\u4f46\\u4e0d\\u8981\\u4f24\\u5bb3\\u679c\\u67c4\\uff0c\\u4ee5\\u9632\\u679c\\u5b9e\\u8131\\u843d\\uff0c\\u68a8\\u888b\\u4ee5\\u53cc\\u5c42\\u9ed1\\u91cc\\u7eb8\\u888b\\u4e3a\\u597d\\u3002<\\/span><\\/p>\"},{\"title\":\"\\u8fd0\\u8f93\",\"name\":\"4\",\"content\":\"<p>\\t\\uff08\\u4e00\\uff09\\u4eba\\u5de5\\u6388\\u7c89\\uff1a\\u5e7f\\u68a8\\u3001<a href=\\\"https:\\/\\/baike.baidu.com\\/item\\/%E9%9B%AA%E8%8A%B1%E6%A2%A8\\\" rel=\\\"noopener noreferrer\\\" target=\\\"_blank\\\" style=\\\"color: rgb(19, 110, 194);\\\">\\u96ea\\u82b1\\u68a8<\\/a>\\u82b1\\u7c89\\u662f\\u9e2d\\u68a8\\u54c1\\u79cd\\u7684\\u6781\\u4f73\\u6388\\u7c89\\u7ec4\\u5408\\uff0c\\u4e0d\\u4f46\\u82b1\\u7c89\\u91cf\\u5927\\u3001\\u4eb2\\u5408\\u529b\\u5f3a\\uff0c\\u800c\\u4e14\\u679c\\u5b9e\\u989c\\u8272\\u597d\\uff0c\\u54c1\\u8d28\\u597d\\uff0c\\u4f18\\u4e8e\\u5176\\u4ed6\\u6388\\u7c89\\u54c1\\u79cd\\u3002\\u91c7\\u96c6\\u82b1\\u7c89\\u5e94\\u5728\\u9e2d\\u68a8\\u5f00\\u82b1\\u524d2\\u5929-3\\u5929\\u8fdb\\u884c\\u3002<\\/p><p>\\t\\u9e2d\\u68a8\\u5f00\\u82b1\\u540e\\u4e09\\u5929\\u5185\\u53d7\\u7cbe\\u80fd\\u529b\\u5f3a\\uff0c\\u5e94\\u6293\\u4f4f\\u5f00\\u82b1\\u4e09\\u5929\\u5185\\u8fd9\\u6bb5\\u5173\\u952e\\u65f6\\u671f\\u8fdb\\u884c\\u4eba\\u5de5\\u6388\\u7c89\\uff0c\\u4e0a\\u5348\\u8fdb\\u884c\\u4e3a\\u597d\\u3002<\\/p><p>\\t\\uff08\\u4e8c\\uff09\\u758f\\u82b1\\u758f\\u679c\\uff1a\\u4e00\\u822c\\u4ece\\u82b1\\u5e8f\\u5206\\u79bb\\u671f\\u5f00\\u59cb\\u758f\\u82b1\\uff0c\\u843d\\u82b1\\u4e24\\u5468\\u540e\\u5f00\\u59cb\\u758f\\u679c\\uff0c\\u81f35\\u6708\\u5e95\\u524d\\u5168\\u90e8\\u5b8c\\u6210\\u3002<\\/p>\"}]', '23', '0', '2022-02-10 09:06:42');
COMMIT;

-- ----------------------------
--  Table structure for `ctc_dealer_trace_query_detail`
-- ----------------------------
DROP TABLE IF EXISTS `ctc_dealer_trace_query_detail`;
CREATE TABLE `ctc_dealer_trace_query_detail` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `member_id` int(11) DEFAULT NULL COMMENT '扫码人员',
  `code` varchar(255) DEFAULT NULL COMMENT '数码',
  `serial_number` varchar(255) DEFAULT NULL COMMENT '流水号',
  `scan_type` varchar(255) DEFAULT NULL COMMENT '扫码方式 字典翻译',
  `product_id` int(11) DEFAULT NULL,
  `product_name` varchar(255) DEFAULT NULL,
  `code_batch` varchar(255) DEFAULT NULL,
  `product_batch` varchar(255) DEFAULT NULL COMMENT '生成批次号',
  `security` tinyint(4) DEFAULT NULL COMMENT '防伪验证1已验证 2未验证',
  `address` varchar(255) DEFAULT NULL COMMENT '扫码地区',
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '扫码时间',
  `is_first` tinyint(4) DEFAULT '1' COMMENT '是否首次查询1 是 2否(重复)',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
--  Table structure for `ctc_dealer_trace_query_log`
-- ----------------------------
DROP TABLE IF EXISTS `ctc_dealer_trace_query_log`;
CREATE TABLE `ctc_dealer_trace_query_log` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `dealer_id` int(11) NOT NULL,
  `code_batch` varchar(255) DEFAULT NULL COMMENT '码批次',
  `product_batch` varchar(255) DEFAULT NULL COMMENT '码批次',
  `code` varchar(255) DEFAULT NULL COMMENT '溯源码',
  `product_name` varchar(255) DEFAULT NULL COMMENT '产品名称',
  `serial_number` varchar(255) DEFAULT NULL COMMENT '流水号',
  `is_first` tinyint(4) DEFAULT '0' COMMENT '是否是第一次查询0是 1否',
  `member_id` int(11) DEFAULT NULL,
  `address` varchar(255) DEFAULT NULL COMMENT '扫码地址',
  `province` varchar(255) DEFAULT NULL COMMENT '扫码省份 为统计用',
  `scan_type` varchar(255) DEFAULT NULL COMMENT '扫码方式 字典翻译',
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=151 DEFAULT CHARSET=utf8mb4;

-- ----------------------------
--  Records of `ctc_dealer_trace_query_log`
-- ----------------------------
BEGIN;
INSERT INTO `ctc_dealer_trace_query_log` VALUES ('148', '23', '202201231642926120', '000001', '120446520336', '赵县鸭梨', '796', '1', '1', '0内网IP', '河北', '3', '2022-02-10 16:53:33'), ('149', '23', '202201231642926120', '000001', '120446520336', '赵县鸭梨', '796', '0', '1', '0内网IP', '山西', '1', '2022-02-11 19:21:14'), ('150', '23', '202201231642926120', '000001', '120446520336', '赵县鸭梨', '796', '0', '1', '0内网IP', '河北', '3', '2022-02-11 19:21:14');
COMMIT;

-- ----------------------------
--  Table structure for `ctc_dealer_trace_template`
-- ----------------------------
DROP TABLE IF EXISTS `ctc_dealer_trace_template`;
CREATE TABLE `ctc_dealer_trace_template` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `template_name` varchar(255) DEFAULT NULL,
  `remark` varchar(255) DEFAULT NULL,
  `template_code` varchar(255) DEFAULT NULL,
  `page_title` varchar(255) DEFAULT NULL COMMENT '页面标题',
  `banner_type` varchar(4) DEFAULT '1' COMMENT '广告图类型1单张活动图 2banner图',
  `activity_img` varchar(255) DEFAULT NULL COMMENT '活动图链接',
  `banner_img` text COMMENT '轮播图链接',
  `tab` varchar(255) DEFAULT NULL COMMENT 'tab标签',
  `trace_log_title` varchar(255) DEFAULT NULL COMMENT '溯源查询记录 模块标题',
  `trace_first_query_tips` varchar(255) DEFAULT NULL,
  `trace_again_query_tips` varchar(255) DEFAULT NULL COMMENT '当前溯源启用的查询提示',
  `check_trace_first_query_tips` varchar(255) DEFAULT NULL,
  `check_trace_again_query_tips` varchar(255) DEFAULT NULL COMMENT '审核中的溯源查询提示',
  `trace_query_tips_check_status` tinyint(4) DEFAULT '0' COMMENT '0待审核 1审核通过 2未通过',
  `is_log_show` tinyint(4) DEFAULT '1' COMMENT '是否显示溯源查询记录 1显示 0不显示',
  `trace_info_title` varchar(255) DEFAULT NULL COMMENT '溯源信息模块标题',
  `auth_title` varchar(255) DEFAULT NULL COMMENT '防伪认证模块标题',
  `auth_first_query_tips` varchar(255) DEFAULT NULL COMMENT '当前的防伪首次查询提示',
  `auth_again_query_tips` varchar(255) DEFAULT NULL COMMENT '当前启用的防伪二次查询提示',
  `check_auth_first_query_tips` varchar(255) DEFAULT NULL,
  `check_auth_again_query_tips` varchar(255) DEFAULT NULL,
  `auth_query_tips_check_status` tinyint(4) DEFAULT '0' COMMENT '0待审核 1已审核 2未通过',
  `product_title` varchar(255) DEFAULT NULL,
  `is_product_code` tinyint(4) DEFAULT '1' COMMENT '产品编号 1显示 0隐藏 ',
  `is_product_img` tinyint(4) DEFAULT '1',
  `is_product_name` tinyint(4) DEFAULT '1',
  `is_product_weight` tinyint(4) DEFAULT '1',
  `is_product_price` tinyint(4) DEFAULT '1',
  `is_product_des` tinyint(4) DEFAULT '1',
  `is_buy` tinyint(4) DEFAULT '1',
  `company_title` varchar(255) DEFAULT NULL COMMENT '企业信息模块标题',
  `is_business_license_code` tinyint(4) DEFAULT '1' COMMENT '是否显示营业执照编号',
  `is_business_license_url` tinyint(4) DEFAULT '1',
  `is_dealer_name` tinyint(4) DEFAULT NULL COMMENT '认证品牌',
  `is_address` tinyint(4) DEFAULT NULL,
  `is_telephone` tinyint(4) DEFAULT NULL,
  `is_email` tinyint(4) DEFAULT NULL,
  `is_website` tinyint(4) DEFAULT NULL,
  `dealer_id` int(11) DEFAULT NULL,
  `is_banner` tinyint(4) DEFAULT '1' COMMENT '是否显示banner 1显示 0隐藏',
  `is_video` tinyint(4) DEFAULT '0' COMMENT '默认不显示 0不显示  1显示',
  `video_title` varchar(255) DEFAULT NULL,
  `video_url` varchar(255) DEFAULT NULL,
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `status` tinyint(4) DEFAULT '0' COMMENT '状态 0正常 1删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4;

-- ----------------------------
--  Records of `ctc_dealer_trace_template`
-- ----------------------------
BEGIN;
INSERT INTO `ctc_dealer_trace_template` VALUES ('1', '747', '47', null, '溯源档案1', '1', '[{\"url\":\"https:\\/\\/cdn.icloudapi.cn\\/d3b07202112071031225844.jpg\",\"name\":\"d3b07202112071031225844.jpg\"}]', 'null', '[{\"title\":\"\\u6eaf\\u6e90\",\"is_show\":1},{\"title\":\"\\u8ba4\\u8bc1\",\"is_show\":1},{\"title\":\"\\u4ea7\\u54c1\",\"is_show\":1},{\"title\":\"\\u4f01\\u4e1a\",\"is_show\":1}]', '查询记录', '当前溯源码为首次查询，感谢您的查询！', '当前溯源码为@次@查询，感谢您的查询！', '', '', '0', '1', '溯源信息', '防伪认证', '您好，您所查询的是@品牌商名称@生产的产品，请放心使用！', '该防伪码已经被人查询过，首次查询时间：@查询时间@，谨防假冒！', '您好，您所查询的是@品牌商名称@生产的产品，请放心使用！', '该防伪码已经被人查询过，首次查询时间：@查询时间@，谨防假冒！', '0', '产品信息', '1', '1', '1', '1', '1', '1', '1', '企业信息', '1', '1', '1', '1', '1', '1', '1', '23', '1', '0', null, null, '2022-01-11 22:35:57', '0'), ('2', 'wedewf', 'fsdfs', null, '溯源档案', '1', '[{\"url\":\"https:\\/\\/cdn.icloudapi.cn\\/d3b07202112071031225844.jpg\",\"name\":\"d3b07202112071031225844.jpg\"}]', '[]', '[{\"title\":\"溯源\",\"is_show\":1},{\"title\":\"认证\",\"is_show\":1},{\"title\":\"产品\",\"is_show\":1},{\"title\":\"企业\",\"is_show\":1}]', '查询记录', '当前溯源码为首次查询，感谢您的查询！', '当前溯源码为@次@查询，感谢您的查询！', '', '', '0', '1', '溯源信息', '防伪认证', '您好，您所查询的是@品牌商名称@生产的产品，请放心使用！', '该防伪码已经被人查询过，首次查询时间：@查询时间@，谨防假冒！', '您好，您所查询的是@品牌商名称@生产的产品，请放心使用！', '该防伪码已经被人查询过，首次查询时间：@查询时间@，谨防假冒！', '0', '产品信息', '1', '1', '1', '1', '1', '1', '1', '企业信息', '1', '1', '1', '1', '1', '1', '1', '23', '1', '0', null, null, '2022-01-11 22:38:13', '0'), ('3', 'das', 'sadas', '202201111641912640', '溯源档案', '1', '[{\"url\":\"https:\\/\\/cdn.icloudapi.cn\\/d3b07202112071031225844.jpg\",\"name\":\"d3b07202112071031225844.jpg\"}]', '[]', '[{\"title\":\"\\u6eaf\\u6e90da\",\"is_show\":1},{\"title\":\"\\u8ba4\\u8bc1da\",\"is_show\":1},{\"title\":\"\\u4ea7\\u54c1ds\",\"is_show\":1},{\"title\":\"\\u4f01\\u4e1ads\",\"is_show\":1}]', '查询记录', '当前溯源码为首次查询，感谢您的查询！', '当前溯源码为@次@查询，感谢您的查询！', '', '', '0', '1', '溯源信息', '防伪认证', '您好，您所查询的是@品牌商名称@生产的产品，请放心使用！', '该防伪码已经被人查询过，首次查询时间：@查询时间@，谨防假冒！', '您好，您所查询的是@品牌商名称@生产的产品，请放心使用！', '该防伪码已经被人查询过，首次查询时间：@查询时间@，谨防假冒！', '0', '产品信息', '1', '1', '1', '1', '1', '1', '1', '企业信息', '1', '1', '1', '1', '1', '1', '1', '23', '1', '0', null, null, '2022-01-11 22:50:40', '0'), ('4', '8578', '578', '202201121641917304', '溯源档案', '1', '[{\"url\":\"https:\\/\\/cdn.icloudapi.cn\\/d3b07202112071031225844.jpg\",\"name\":\"d3b07202112071031225844.jpg\"}]', '[]', '[{\"title\":\"溯源\",\"is_show\":1},{\"title\":\"认证\",\"is_show\":1},{\"title\":\"产品\",\"is_show\":1},{\"title\":\"企业\",\"is_show\":1}]', '查询记录', '当前溯源码为首次查询，感谢您的查询！', '当前溯源码为@次@查询，感谢您的查询！', '', '', '0', '1', '溯源信息', '防伪认证', '您好，您所查询的是@品牌商名称@生产的产品，请放心使用！', '该防伪码已经被人查询过，首次查询时间：@查询时间@，谨防假冒！', '您好，您所查询的是@品牌商名称@生产的产品，请放心使用！', '该防伪码已经被人查询过，首次查询时间：@查询时间@，谨防假冒！', '0', '产品信息', '1', '1', '1', '1', '1', '1', '1', '企业信息', '1', '1', '1', '1', '1', '1', '1', '23', '1', '1', '宣传视频245', '24524524', '2022-01-12 00:08:24', '0'), ('5', '63', '3653', '202201121641917350', '溯源档案', '1', '[{\"url\":\"https:\\/\\/cdn.icloudapi.cn\\/d3b07202112071031225844.jpg\",\"name\":\"d3b07202112071031225844.jpg\"}]', '[]', '[{\"title\":\"溯源\",\"is_show\":1},{\"title\":\"认证\",\"is_show\":1},{\"title\":\"产品\",\"is_show\":1},{\"title\":\"企业\",\"is_show\":1}]', '查询记录', '当前溯源码为首次查询，感谢您的查询！', '当前溯源码为@次@查询，感谢您的查询！', '', '', '0', '1', '溯源信息', '防伪认证', '您好，您所查询的是@品牌商名称@生产的产品，请放心使用！', '该防伪码已经被人查询过，首次查询时间：@查询时间@，谨防假冒！', '您好，您所查询的是@品牌商名称@生产的产品，请放心使用！', '该防伪码已经被人查询过，首次查询时间：@查询时间@，谨防假冒！', '0', '产品信息', '1', '1', '1', '1', '1', '1', '1', '企业信息', '1', '1', '1', '1', '1', '1', '1', '23', '1', '0', '宣传视频', '', '2022-01-12 00:09:10', '0'), ('7', '2', '2', '202201131642044806', '溯源档案', '1', '[{\"img_name\":\"\",\"url\":\"https:\\/\\/cdn.icloudapi.cn\\/sy-default.png\"}]', '[]', '[{\"title\":\"溯源\",\"is_show\":1},{\"title\":\"认证\",\"is_show\":1},{\"title\":\"产品\",\"is_show\":1},{\"title\":\"企业\",\"is_show\":1}]', '查询记录', '当前溯源码为首次查询，感谢您的查询！', '当前溯源码为@次@查询，感谢您的查询！', '', '', '0', '1', '溯源信息', '防伪认证', '您好，您所查询的是@品牌商名称@生产的产品，请放心使用！', '该防伪码已经被人查询过，首次查询时间：@查询时间@，谨防假冒！', '您好，您所查询的是@品牌商名称@生产的产品，请放心使用！', '该防伪码已经被人查询过，首次查询时间：@查询时间@，谨防假冒！', '0', '产品信息', '1', '1', '1', '1', '1', '1', '1', '企业信息', '1', '1', '1', '1', '1', '1', '1', '23', '1', '0', '宣传视频', '', '2022-01-13 11:33:26', '1'), ('8', '9', '9', '202201131642045062', '溯源档案', '2', '[{\"img_name\":\"\",\"url\":\"https:\\/\\/cdn.icloudapi.cn\\/sy-default.png\"}]', '[{\"url\":\"https:\\/\\/cdn.icloudapi.cn\\/d146b202111211336118366.jpg\",\"name\":\"d146b202111211336118366.jpg\",\"link\":\"\"},{\"img_name\":\"\",\"url\":\"https:\\/\\/cdn.icloudapi.cn\\/sy-default.png\",\"link\":\"\"},{\"url\":\"https:\\/\\/cdn.icloudapi.cn\\/c1c86202111231856227223.png\",\"name\":\"c1c86202111231856227223.png\",\"link\":\"\"}]', '[{\"title\":\"\\u6eaf\\u6e9011\",\"is_show\":1},{\"title\":\"\\u8ba4\\u8bc1\",\"is_show\":1},{\"title\":\"\\u4ea7\\u54c1\",\"is_show\":1},{\"title\":\"\\u4f01\\u4e1a\",\"is_show\":1}]', '查询记录', '当前溯源码为首次查询，感谢您的查询！', '当前溯源码为@次@查询，感谢您的查询！', '', '', '0', '1', '溯源信息', '防伪认证', '您好，您所查询的是@品牌商名称@生产的产品，请放心使用！', '该防伪码已经被人查询过，首次查询时间：@查询时间@，谨防假冒！', '您好，您所查询的是@品牌商名称@生产的产品，请放心使用！', '该防伪码已经被人查询过，首次查询时间：@查询时间@，谨防假冒！', '0', '产品信息', '1', '0', '1', '1', '1', '1', '1', '企业信息', '1', '1', '1', '1', '1', '1', '1', '23', '1', '0', '宣传视频', '', '2022-01-13 11:37:42', '0'), ('9', 's', 's', '202201131642058327', '溯源档案', '2', '[{\"img_name\":\"\",\"url\":\"https:\\/\\/cdn.icloudapi.cn\\/sy-default.png\"}]', '[{\"url\":\"https:\\/\\/cdn.icloudapi.cn\\/d3b07202112071031225844.jpg\",\"name\":\"d3b07202112071031225844.jpg\",\"link\":\"\"},{\"url\":\"https:\\/\\/cdn.icloudapi.cn\\/c1c86202111231856227223.png\",\"name\":\"c1c86202111231856227223.png\",\"link\":\"\"}]', '[{\"title\":\"\\u6eaf\\u6e901\",\"is_show\":1},{\"title\":\"\\u8ba4\\u8bc12\",\"is_show\":1},{\"title\":\"\\u4ea7\\u54c13\",\"is_show\":1},{\"title\":\"\\u4f01\\u4e1a4\",\"is_show\":1}]', '查询记录', '当前溯源码为首次查询，感谢您的查询！', '当前溯源码为@次@查询，感谢您的查询！', '', '', '0', '1', '溯源信息', '防伪认证', '您好，您所查询的是@品牌商名称@生产的产品，请放心使用！', '该防伪码已经被人查询过，首次查询时间：@查询时间@，谨防假冒！', '您好，您所查询的是@品牌商名称@生产的产品，请放心使用！', '该防伪码已经被人查询过，首次查询时间：@查询时间@，谨防假冒！', '0', '产品信息', '1', '1', '1', '1', '1', '1', '1', '企业信息', '1', '1', '1', '1', '1', '1', '1', '23', '1', '1', '宣传视频', 'kkkkk', '2022-01-13 15:18:47', '0'), ('10', '33', '33', '202201231642941778', '溯源档案', '2', '[{\"img_name\":\"\",\"url\":\"https:\\/\\/cdn.icloudapi.cn\\/sy-default.png\"}]', '[{\"url\":\"https:\\/\\/cdn.icloudapi.cn\\/1f7f9202111210005305574.jpg\",\"name\":\"1f7f9202111210005305574.jpg\",\"link\":\"\"},{\"url\":\"https:\\/\\/cdn.icloudapi.cn\\/8a532202111210028079962.png\",\"name\":\"8a532202111210028079962.png\",\"link\":\"\"}]', '[{\"title\":\"\\u6eaf\\u6e90\",\"is_show\":1},{\"title\":\"\\u8ba4\\u8bc1\",\"is_show\":1},{\"title\":\"\\u4ea7\\u54c1\",\"is_show\":1},{\"title\":\"\\u4f01\\u4e1a\",\"is_show\":1}]', '查询记录', '当前溯源码为首次查询，感谢您的查询！', '当前溯源码为@次@查询，感谢您的查询！', '', '', '0', '1', '溯源信息', '防伪认证', '您好，您所查询的是@品牌商名称@生产的产品，请放心使用！', '该防伪码已经被人查询过，首次查询时间：@查询时间@，谨防假冒！', '您好，您所查询的是@品牌商名称@生产的产品，请放心使用！', '该防伪码已经被人查询过，首次查询时间：@查询时间@，谨防假冒888！', '0', '产品信息', '1', '1', '1', '1', '1', '1', '1', '企业信息', '1', '1', '1', '1', '1', '1', '1', '23', '1', '1', '宣传视频11', 'https://cdn.uviewui.com/uview/resources/video.mp4', '2022-01-23 20:42:58', '0'), ('11', '鸭梨', '鸭梨', '202202101644454810', '溯源档案', '2', '[{\"img_name\":\"\",\"url\":\"https:\\/\\/cdn.icloudapi.cn\\/sy-default.png\"}]', '[{\"url\":\"https:\\/\\/cdn.icloudapi.cn\\/2744b202202100858394833.jpeg\",\"name\":\"2744b202202100858394833.jpeg\",\"link\":\"\"},{\"url\":\"https:\\/\\/cdn.icloudapi.cn\\/32d17202202100852475252.jpeg\",\"name\":\"32d17202202100852475252.jpeg\",\"link\":\"\"}]', '[{\"title\":\"\\u6eaf\\u6e90\",\"is_show\":1},{\"title\":\"\\u8ba4\\u8bc1\",\"is_show\":1},{\"title\":\"\\u4ea7\\u54c1\",\"is_show\":1},{\"title\":\"\\u4f01\\u4e1a\",\"is_show\":1}]', '查询记录', '当前溯源码为首次查询，感谢您的查询！', '当前溯源码为@次@次查询，感谢您的查询！', '当前溯源码为首次查询，感谢您的查询！', '当前溯源码为@次@次查询，感谢您的查询！', '0', '1', '溯源信息', '防伪认证', '您好，您所查询的是@品牌商名称@生产的产品，请放心使用！', '该防伪码已经被人查询过，首次查询时间：@查询时间@，谨防假冒！', '您好，您所查询的是@品牌商名称@生产的产品，请放心使用！', '该防伪码已经被人查询过，首次查询时间：@查询时间@，谨防假冒！', '0', '产品信息', '1', '1', '1', '1', '1', '1', '1', '企业信息', '1', '1', '1', '1', '1', '1', '1', '23', '1', '1', '宣传视频', 'https://cdn.uviewui.com/uview/resources/video.mp4', '2022-02-10 09:00:10', '0');
COMMIT;

-- ----------------------------
--  Table structure for `ctc_dealer_trademark`
-- ----------------------------
DROP TABLE IF EXISTS `ctc_dealer_trademark`;
CREATE TABLE `ctc_dealer_trademark` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `dealer_id` int(11) DEFAULT NULL,
  `trademark_code` varchar(255) DEFAULT NULL,
  `trademark_cert` varchar(255) DEFAULT NULL,
  `trademark_supplement` varchar(255) DEFAULT NULL,
  `status` varchar(255) DEFAULT NULL COMMENT '0未认证 1已认证 2未通过 3更新中',
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `create_by` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4;

-- ----------------------------
--  Records of `ctc_dealer_trademark`
-- ----------------------------
BEGIN;
INSERT INTO `ctc_dealer_trademark` VALUES ('1', '1', '1235', '20211010/e8829737b207ea9b0562ffb388f80d9b.png', '20211010/d2a860eb5d1cf07fae73b001003b153f.png', '1', '2021-10-10 01:30:08', null), ('2', '4', '测试', '20211104/3f5fd3910c8b90bb0a763733b8214e16.png', '20211104/adcc13fb48ef24bc4fc017e2b5c144d9.png', '1', '2021-11-04 13:43:50', null), ('3', '5', '09890', '20211104/2d8daad04a6e808c89c6e9f9ace8a1c2.png', '20211104/d03824b9763d82552219051785097df5.png', '1', '2021-11-04 17:49:33', null), ('4', '23', '123', '20211113/cebafca2e3a4dd9acc4d2febf8572dc6.png', '20211113/4902cdaea835f25d88f5639c6e8f8996.png', '1', '2021-11-13 17:07:50', null);
COMMIT;

-- ----------------------------
--  Table structure for `ctc_dealer_universal_store_cart`
-- ----------------------------
DROP TABLE IF EXISTS `ctc_dealer_universal_store_cart`;
CREATE TABLE `ctc_dealer_universal_store_cart` (
  `id` bigint(8) unsigned NOT NULL AUTO_INCREMENT COMMENT '购物车表ID',
  `uid` int(10) unsigned NOT NULL COMMENT '用户ID',
  `type` varchar(32) NOT NULL COMMENT '类型',
  `product_id` int(10) unsigned NOT NULL COMMENT '商品ID',
  `product_attr_unique` varchar(16) NOT NULL DEFAULT '' COMMENT '商品属性',
  `cart_num` smallint(5) unsigned NOT NULL DEFAULT '0' COMMENT '商品数量',
  `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '添加时间',
  `is_pay` tinyint(1) NOT NULL DEFAULT '0' COMMENT '0 = 未购买 1 = 已购买',
  `is_del` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否删除',
  `is_new` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否为立即购买',
  `combination_id` int(11) unsigned DEFAULT '0' COMMENT '拼团id',
  `seckill_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '秒杀产品ID',
  `bargain_id` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '砍价id',
  `dealer_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `user_id` (`uid`) USING BTREE,
  KEY `goods_id` (`product_id`) USING BTREE,
  KEY `uid` (`uid`,`is_pay`) USING BTREE,
  KEY `uid_2` (`uid`,`is_del`) USING BTREE,
  KEY `uid_3` (`uid`,`is_new`) USING BTREE,
  KEY `type` (`type`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT COMMENT='购物车表';

-- ----------------------------
--  Table structure for `ctc_dealer_universal_store_order_cart_info`
-- ----------------------------
DROP TABLE IF EXISTS `ctc_dealer_universal_store_order_cart_info`;
CREATE TABLE `ctc_dealer_universal_store_order_cart_info` (
  `oid` int(11) unsigned NOT NULL COMMENT '订单id',
  `cart_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '购物车id',
  `product_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '商品ID',
  `cart_info` text NOT NULL COMMENT '购买东西的详细信息',
  `unique` char(32) NOT NULL COMMENT '唯一id',
  `dealer_id` int(11) DEFAULT NULL,
  UNIQUE KEY `oid` (`oid`,`unique`) USING BTREE,
  KEY `cart_id` (`cart_id`) USING BTREE,
  KEY `product_id` (`product_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT COMMENT='订单购物详情表';

-- ----------------------------
--  Table structure for `ctc_dealer_user`
-- ----------------------------
DROP TABLE IF EXISTS `ctc_dealer_user`;
CREATE TABLE `ctc_dealer_user` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `account` varchar(255) DEFAULT NULL,
  `username` varchar(255) DEFAULT NULL,
  `password` varchar(255) DEFAULT NULL,
  `remark` varchar(255) DEFAULT NULL,
  `dealer_id` int(11) DEFAULT NULL COMMENT '代理人主账号',
  `roleIds` varchar(11) DEFAULT NULL COMMENT '角色id',
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `status` varchar(4) DEFAULT '1' COMMENT '1正常 2被禁用',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4;

-- ----------------------------
--  Records of `ctc_dealer_user`
-- ----------------------------
BEGIN;
INSERT INTO `ctc_dealer_user` VALUES ('2', 'test001', '无语', 'e10adc3949ba59abbe56e057f20f883e', '哈哈哈喝几口', '23', '1', '2021-11-13 23:01:13', '1'), ('7', 'wenhan', '424', 'e10adc3949ba59abbe56e057f20f883e', '321', '23', '1', '2021-11-16 12:56:45', '1');
COMMIT;

-- ----------------------------
--  Table structure for `ctc_dealer_warehouse`
-- ----------------------------
DROP TABLE IF EXISTS `ctc_dealer_warehouse`;
CREATE TABLE `ctc_dealer_warehouse` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `dealer_id` int(11) DEFAULT NULL,
  `warehouse_name` varchar(255) DEFAULT NULL,
  `area` varchar(255) DEFAULT '中国大陆',
  `type` tinyint(4) DEFAULT NULL,
  `status` varchar(4) DEFAULT '0' COMMENT '0正常 1停用',
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `stock` varchar(255) DEFAULT '0',
  `delete_time` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4;

-- ----------------------------
--  Records of `ctc_dealer_warehouse`
-- ----------------------------
BEGIN;
INSERT INTO `ctc_dealer_warehouse` VALUES ('3', '23', '11', '中国大陆', '1', '0', '2021-11-16 12:15:32', '0', '1637036295'), ('4', '23', '3534', '中国大陆', '1', '0', '2021-11-16 12:27:25', '0', '1637036849'), ('5', '23', '353488', '中国大陆', '1', '0', '2021-11-16 12:27:39', '0', '1637038345'), ('6', '23', '3534', '中国大陆', '2', '0', '2021-11-16 12:27:43', '0', '1637054233'), ('7', '23', 're', '中国大陆', '2', '1', '2021-11-16 17:17:01', '0', null), ('8', '23', 'TRFH', '中国大陆', '1', '0', '2021-11-18 00:58:51', '0', null);
COMMIT;

-- ----------------------------
--  Table structure for `ctc_dealer_weixin_config`
-- ----------------------------
DROP TABLE IF EXISTS `ctc_dealer_weixin_config`;
CREATE TABLE `ctc_dealer_weixin_config` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `oa_appid` varchar(255) DEFAULT NULL COMMENT '公众号appid',
  `oa_secret` varchar(255) DEFAULT NULL COMMENT '公众号secret',
  `mp_appid` varchar(255) DEFAULT NULL COMMENT '小程序appid',
  `mp_secret` varchar(255) DEFAULT NULL COMMENT '小程序secret',
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `dealer_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4;

-- ----------------------------
--  Records of `ctc_dealer_weixin_config`
-- ----------------------------
BEGIN;
INSERT INTO `ctc_dealer_weixin_config` VALUES ('1', '432', '4324', '4324432sdd', 'asdasd', '2022-01-20 23:51:52', '23');
COMMIT;

-- ----------------------------
--  Table structure for `ctc_dealer_zan`
-- ----------------------------
DROP TABLE IF EXISTS `ctc_dealer_zan`;
CREATE TABLE `ctc_dealer_zan` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `dealer_id` int(11) DEFAULT NULL,
  `micro_app_title` varchar(255) DEFAULT NULL,
  `grant_id` varchar(255) DEFAULT NULL,
  `client_id` varchar(255) DEFAULT NULL,
  `client_secret` varchar(255) DEFAULT NULL,
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4;

-- ----------------------------
--  Records of `ctc_dealer_zan`
-- ----------------------------
BEGIN;
INSERT INTO `ctc_dealer_zan` VALUES ('1', '23', 'er', 'rew', 'rew', 'rew', '2021-11-19 18:13:15');
COMMIT;

-- ----------------------------
--  Table structure for `ctc_demand`
-- ----------------------------
DROP TABLE IF EXISTS `ctc_demand`;
CREATE TABLE `ctc_demand` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `module_id` int(11) DEFAULT NULL,
  `priority` varchar(255) DEFAULT NULL,
  `partner_id` int(11) DEFAULT NULL,
  `dealer_id` int(11) DEFAULT NULL,
  `describe` varchar(255) DEFAULT NULL,
  `status` tinyint(4) DEFAULT '1' COMMENT '审核状态 1待审核',
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `enclosure` varchar(255) DEFAULT NULL COMMENT '附件',
  `title` varchar(255) DEFAULT NULL,
  `tips` varchar(255) DEFAULT NULL COMMENT '审核意见',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4;

-- ----------------------------
--  Records of `ctc_demand`
-- ----------------------------
BEGIN;
INSERT INTO `ctc_demand` VALUES ('1', '2', '2', '1', '1', '2', '4', '2021-10-11 07:52:51', '2', '11', '下次一定'), ('3', '3', '1', '1', '1', '测试', '4', '2021-10-23 23:27:01', '20211023/7e680db6a22c86e0fccc10a469ba2637.docx', '测试', '通过了 等等吧'), ('4', '3', '1', '1', '1', 'fdsfsdsd', '5', '2021-10-23 23:35:49', '', 'sjfhsk', '可以做'), ('5', '5', '4', '1', '1', 'sdsad', '4', '2021-10-27 16:50:14', '20211027/1817a4e3c791ad0918b3201ac19d1625.xls', 'trst', '可以做'), ('6', '4', '1', '1', '22', '123', '3', '2021-11-09 15:17:24', '20211109/8db298126991291692b8009a503bf179.docx', '67', '好');
COMMIT;

-- ----------------------------
--  Table structure for `ctc_dict_data`
-- ----------------------------
DROP TABLE IF EXISTS `ctc_dict_data`;
CREATE TABLE `ctc_dict_data` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `dict_type` varchar(255) DEFAULT NULL,
  `dict_label` varchar(255) DEFAULT NULL,
  `dict_value` varchar(255) DEFAULT NULL,
  `status` tinyint(4) DEFAULT '0',
  `dict_sort` tinyint(4) DEFAULT '0',
  `remark` varchar(255) DEFAULT NULL,
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `create_by` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=160 DEFAULT CHARSET=utf8mb4;

-- ----------------------------
--  Records of `ctc_dict_data`
-- ----------------------------
BEGIN;
INSERT INTO `ctc_dict_data` VALUES ('1', '323rrewr', '1434', '1334', '1', '1', '11', '2021-10-06 16:56:26', null), ('4', '323rrewr', 'dsd', 'dw', '0', '0', 'dw', '2021-10-06 17:11:07', null), ('5', '323rrewr', 'w', 'w', '0', '0', 'w', '2021-10-06 17:14:07', null), ('6', 'sys_user_sex', '男', '0', '0', '0', '性别男', '2021-10-06 17:29:10', null), ('7', 'sys_user_sex', '女', '1', '0', '1', '性别女', '2021-10-06 17:30:31', null), ('8', 'sys_user_sex', '未知', '2', '0', '2', '性别未知', '2021-10-06 17:30:49', null), ('10', 'code_type', '普通码', '1', '0', '0', '', '2021-10-07 21:19:42', null), ('11', 'code_type', '小程序码', '2', '0', '0', '小程序码', '2021-10-07 21:19:53', null), ('12', 'code_scene', '营销码', '1', '0', '0', '支持二维码营销', '2021-10-07 21:31:56', null), ('13', 'code_scene', '溯源码', '2', '0', '0', '支持万能溯源（舒适版）,可勾选增加4位的验证码(二维码可采用明码,验证码采用暗码);可同时勾选营销码或导购码进行一码多用', '2021-10-07 21:32:15', null), ('14', 'code_scene', '导购码', '3', '0', '0', '支持导购员扫码,可同时勾选营销码或溯源码进行一码多用,但同时勾选营销码或溯源码时不可勾选关联导购码,勾选关联导购码需要选择另一批同样数量的批次进行关联', '2021-10-07 21:32:31', null), ('15', 'code_scene', '物流码', '4', '0', '0', '支持智能物流,只勾选物流码时仅支持物流发货', '2021-10-07 21:32:45', null), ('16', 'partner_status', '正常', '1', '0', '0', '正常', '2021-10-08 00:54:42', null), ('17', 'partner_status', '禁用', '2', '0', '0', '禁用', '2021-10-08 00:54:53', null), ('18', 'partner_status', '已过期', '3', '0', '0', '已过期', '2021-10-08 00:55:06', null), ('19', 'partner_industry', '建材', '1', '0', '0', '建材', '2021-10-08 01:07:52', null), ('20', 'partner_industry', '化妆品', '2', '0', '0', '化妆品', '2021-10-08 01:08:07', null), ('21', 'partner_industry', '酒', '3', '0', '0', '酒', '2021-10-08 01:08:22', null), ('22', 'demand_priority', '提示P1', '1', '0', '0', '提示P1', '2021-10-09 01:38:06', null), ('23', 'demand_priority', '一般P2', '2', '0', '0', '一般P2', '2021-10-09 01:38:23', null), ('24', 'demand_priority', '重要P3', '3', '0', '0', '重要P3', '2021-10-09 01:38:39', null), ('25', 'demand_priority', '紧急P4', '4', '0', '0', '紧急P4', '2021-10-09 01:38:54', null), ('26', 'demand_status', '待审核', '1', '0', '0', '待审核', '2021-10-09 01:40:21', null), ('27', 'demand_status', '待排期', '2', '0', '0', '待排期', '2021-10-09 01:40:35', null), ('28', 'demand_status', '实现中', '3', '0', '0', '实现中', '2021-10-09 01:40:51', null), ('29', 'demand_status', '已完成', '4', '0', '0', '已完成', '2021-10-09 01:41:03', null), ('30', 'demand_status', '审核不通过', '5', '0', '0', '审核不通过', '2021-10-09 01:41:19', null), ('31', 'company_type', '有限责任公司', '1', '0', '0', '有限责任公司', '2021-10-10 21:40:36', null), ('32', 'company_type', '股份有限公司', '2', '0', '0', '股份有限公司', '2021-10-10 21:40:54', null), ('33', 'company_type', '个人独资企业', '3', '0', '0', '个人独资企业', '2021-10-10 21:41:11', null), ('34', 'company_type', '合伙企业', '4', '0', '0', '合伙企业', '2021-10-10 21:41:26', null), ('35', 'recharge_type', '账户余额', '1', '0', '0', '账户余额', '2021-10-11 06:30:52', null), ('36', 'recharge_type', '预存款', '2', '0', '0', '预存款', '2021-10-11 06:31:09', null), ('37', 'transaction_type', '充值', '1', '0', '0', '充值', '2021-10-11 20:02:53', null), ('38', 'transaction_type', '开户', '2', '0', '0', '开户', '2021-10-11 20:03:05', null), ('39', 'transaction_type', '生码', '3', '0', '0', '生码', '2021-10-11 20:03:17', null), ('40', 'transaction_type', '增值服务', '4', '0', '0', '增值服务', '2021-10-11 20:03:34', null), ('41', 'transaction_type', '升降', '5', '0', '0', '升降', '2021-10-11 20:03:56', null), ('42', 'transaction_type', '续费', '6', '0', '0', '续费', '2021-10-11 20:04:16', null), ('43', 'transaction_type', '申请提现', '7', '0', '0', '申请提现', '2021-10-11 20:04:32', null), ('44', 'transaction_type', '提现驳回资金返回', '8', '0', '0', '提现驳回资金返回', '2021-10-11 20:04:56', null), ('45', 'sys_oper_type', '新增', '1', '0', '0', '新增操作', '2021-10-17 23:10:48', null), ('46', 'sys_oper_type', '修改', '2', '0', '0', '修改操作', '2021-10-17 23:11:02', null), ('47', 'sys_oper_type', '删除', '3', '0', '0', '删除操作', '2021-10-17 23:11:10', null), ('48', 'sys_oper_type', '导出', '4', '0', '0', '导出', '2021-10-17 23:11:27', null), ('49', 'sys_oper_type', '导入', '5', '0', '0', '导入', '2021-10-17 23:11:37', null), ('50', 'access_environment', '微信公众号', '1', '0', '0', '1、允许用户通过微信APP+公众号授权访问用户端页面\n2、选择此环境，需要授权绑定公众号', '2021-10-25 00:16:46', null), ('51', 'access_environment', '小程序', '2', '0', '0', '1、允许用户通过微信APP+小程序授权访问用户端页面\n2、选择此环境，需要授权绑定小程序\n3、选择此环境，才能支持小程序扫码页', '2021-10-25 00:17:12', null), ('52', 'access_environment', 'H5', '3', '0', '0', '1、允许用户通过普通的手机浏览器访问用户端页面\n2、同时兼容微信APP内访问用户端页面（不需要绑定公众号授权）\n3、选择此环境，不论用户在哪个环境中操作（扫码领奖、商城下单等），都需要强制验证手机号码', '2021-10-25 00:17:31', null), ('53', 'bank_type', '中国银行', '1', '0', '1', '中国银行', '2021-10-27 04:19:06', null), ('54', 'bank_type', '招商银行', '2', '0', '0', '招商银行', '2021-10-27 04:19:19', null), ('55', 'bank_type', '建设银行', '3', '0', '0', '建设银行', '2021-10-27 04:19:33', null), ('56', 'bank_type', '农业银行', '4', '0', '0', '农业银行', '2021-10-27 04:19:46', null), ('57', 'code_length', '8位', '8', '0', '0', '8位', '2021-10-27 06:56:47', null), ('58', 'code_length', '9位', '9', '0', '0', '', '2021-10-27 06:56:55', null), ('59', 'code_length', '10位', '10', '0', '0', '', '2021-10-27 06:57:02', null), ('60', 'code_length', '11位', '11', '0', '0', '', '2021-10-27 06:57:09', null), ('61', 'code_length', '12位', '12', '0', '0', '', '2021-10-27 06:57:23', null), ('62', 'code_length', '13位', '13', '0', '0', '', '2021-10-27 06:57:34', null), ('63', 'code_length', '14位', '14', '0', '0', '', '2021-10-27 06:57:43', null), ('64', 'code_length', '15位', '15', '0', '0', '', '2021-10-27 06:57:53', null), ('65', 'code_length', '16位', '16', '0', '0', '', '2021-10-27 06:57:59', null), ('66', 'code_length', '20位', '20', '0', '0', '', '2021-10-27 16:57:03', null), ('67', 'warehouse_type', '普通仓', '1', '0', '0', '最多添加一个', '2021-11-16 00:39:07', null), ('68', 'warehouse_type', '保税仓', '2', '0', '0', '最多添加一个', '2021-11-16 00:39:32', null), ('69', 'equ_definition', '普通', '1', '0', '0', '普通', '2021-11-19 20:47:57', null), ('70', 'equ_definition', '高清', '2', '0', '0', '高清', '2021-11-19 20:48:15', null), ('71', 'sms_type', '信息变更短信', '1', '0', '0', '信息变更短信', '2021-11-21 14:07:39', null), ('72', 'sms_type', '修改密码短信', '2', '0', '0', '修改密码短信', '2021-11-21 14:07:54', null), ('73', 'sms_type', '用户注册短信', '3', '0', '0', '用户注册短信', '2021-11-21 14:08:29', null), ('74', 'sms_type', '登录异常短信', '4', '0', '0', '登录异常短信', '2021-11-21 14:08:45', null), ('75', 'sms_type', '登录确认短信', '5', '0', '0', '登录确认短信', '2021-11-21 14:08:59', null), ('76', 'sms_type', '身份验证短信', '6', '0', '0', '身份验证短信', '2021-11-21 14:09:29', null), ('77', 'sms_type', '导购员审核通过', '7', '0', '0', '导购员审核通过', '2021-11-21 14:09:56', null), ('78', 'sms_type', '导购员审核不通过', '8', '0', '0', '导购员审核不通过', '2021-11-21 14:10:16', null), ('79', 'sms_type', '订单待发货', '9', '0', '0', '订单待发货', '2021-11-21 14:10:37', null), ('80', 'redpack_type', '现金红包', '1', '0', '0', '现金红包', '2021-12-07 15:44:29', null), ('81', 'redpack_type', '企业零钱红包', '2', '0', '0', '企业零钱红包', '2021-12-07 15:44:45', null), ('82', 'redpack_type', '代发红包', '3', '0', '0', '代发红包', '2021-12-07 15:44:59', null), ('83', 'redpack_monry_type', '固定金额', '1', '0', '0', '固定金额', '2021-12-07 15:53:45', null), ('84', 'redpack_monry_type', '随机金额', '2', '0', '0', '随机金额', '2021-12-07 15:53:59', null), ('85', 'redpack_grant_app', '直接发放', '1', '0', '0', '直接发放', '2021-12-08 17:39:51', null), ('86', 'redpack_grant_app', '二维码营销', '2', '0', '0', '二维码营销', '2021-12-08 17:40:05', null), ('87', 'redpack_grant_app', '超级导购', '3', '0', '0', '超级导购', '2021-12-08 17:40:20', null), ('88', 'redpack_grant_app', '佣金提现', '4', '0', '0', '佣金提现', '2021-12-08 17:40:38', null), ('89', 'redpack_grant_status', '发放成功', '1', '0', '0', '发放成功', '2021-12-08 17:48:41', null), ('90', 'redpack_grant_status', '发放失败', '2', '0', '0', '发放失败', '2021-12-08 17:48:54', null), ('91', 'redpack_grant_status', '发放中', '3', '0', '0', '发放中', '2021-12-08 17:49:05', null), ('92', 'integral_grant_app', '直接发放', '1', '0', '0', '直接发放', '2021-12-09 12:56:18', null), ('93', 'integral_grant_app', '二维码营销', '2', '0', '0', '二维码营销', '2021-12-09 12:56:41', null), ('94', 'integral_grant_app', '微商城购买商品赠送', '3', '0', '0', '微商城购买商品赠送', '2021-12-09 12:57:04', null), ('95', 'integral_grant_app', '超级导购', '4', '0', '0', '超级导购', '2021-12-09 12:57:23', null), ('96', 'logistics_level', '单个包装', '1', '0', '0', '单个包装', '2021-12-14 23:06:52', null), ('97', 'logistics_level', '二级包装', '2', '0', '0', '二级包装', '2021-12-14 23:07:08', null), ('98', 'logistics_level', '三级包装', '3', '0', '0', '三级包装', '2021-12-14 23:07:22', null), ('99', 'guide_prize_order', '不限先后', '1', '0', '0', '不限先后：表示不限定消费者与导购员扫码的先后顺序，导购员可以先扫码登记信息待消费者扫码之后获得奖励，也可以在消费者扫码之后再进行扫码立即获得奖励；', '2021-12-16 20:56:12', null), ('100', 'guide_prize_order', '导购员先激活', '2', '0', '0', '导购员先激活：表示消费者扫码必须在导购员扫码之后，导购员扫码先登记信息待消费者扫码之后获得奖励；', '2021-12-16 20:56:32', null), ('101', 'guide_prize_order', '各自领奖', '3', '0', '0', '各自领奖：表示导购员与消费者扫码领奖相互独立，谁都可以直接扫码领奖', '2021-12-16 20:56:52', null), ('102', 'guide_prize_order', '导购核销', '4', '0', '0', '导购核销：必须消费者先扫码，且消费者扫码后会显示一个核销码，待导购员扫码核销后奖励才会自动同时发放给消费者和导购员；', '2021-12-16 20:57:08', null), ('103', 'official_account_status', '已关注', '1', '0', '0', '已关注', '2021-12-24 23:00:30', null), ('104', 'official_account_status', '未关注', '2', '0', '0', '未关注', '2021-12-24 23:00:44', null), ('105', 'official_account_status', '已跑路', '3', '0', '0', '已跑路', '2021-12-24 23:01:03', null), ('106', 'assets_type', '红包', '1', '0', '0', '红包', '2021-12-27 11:32:36', null), ('107', 'assets_type', '代发红包', '2', '0', '0', '代发红包', '2021-12-27 11:32:53', null), ('108', 'assets_type', '积分', '3', '0', '0', '积分', '2021-12-27 11:33:19', null), ('109', 'assets_type', '礼品', '4', '0', '0', '礼品', '2021-12-27 11:33:27', null), ('110', 'field_type', '文本框', '1', '0', '0', '文本框', '2021-12-27 17:16:40', null), ('111', 'field_type', '单项选择框', '2', '0', '0', '单项选择框', '2021-12-27 17:16:56', null), ('112', 'field_type', '多项选择框', '3', '0', '0', '多项选择框', '2021-12-27 17:18:00', null), ('113', 'field_type', '日期选择框', '4', '0', '0', '日期选择框', '2021-12-27 17:18:17', null), ('114', 'store_status', '正常', '1', '0', '0', '正常', '2022-01-02 22:39:14', null), ('115', 'store_status', '禁用', '2', '0', '0', '禁用', '2022-01-02 22:39:25', null), ('116', 'store_status', '删除', '3', '0', '0', '删除', '2022-01-02 22:39:34', null), ('117', 'store_balance_flow_type', '佣金收益', '1', '0', '0', '佣金收益', '2022-01-05 15:18:36', null), ('118', 'store_balance_flow_type', '销售收益', '2', '0', '0', '销售收益', '2022-01-05 15:18:56', null), ('119', 'store_balance_flow_type', '提现到账', '3', '0', '0', '提现到账', '2022-01-05 15:19:19', null), ('120', 'store_balance_flow_type', '导购扫码收益', '4', '0', '0', '导购扫码收益', '2022-01-05 15:19:38', null), ('121', 'store_balance_flow_type', '提现失败退款', '5', '0', '0', '提现失败退款', '2022-01-05 15:20:05', null), ('122', 'store_commission_cash_status', '待审核', '1', '0', '0', '待审核', '2022-01-05 21:27:40', null), ('123', 'store_commission_cash_status', '提现发放中', '2', '0', '0', '提现发放中', '2022-01-05 21:27:57', null), ('124', 'store_commission_cash_status', '审核不通过', '3', '0', '0', '审核不通过', '2022-01-05 21:28:16', null), ('125', 'store_commission_cash_status', '提现成功', '4', '0', '0', '提现成功', '2022-01-05 21:28:29', null), ('126', 'store_commission_cash_status', '提现失败', '5', '0', '0', '提现失败', '2022-01-05 21:28:44', null), ('127', 'store_commission_cash_type', '线下转账', '1', '0', '0', '门店通过后台线上申请提现，总部进行审核，审核通过后线下打款到门店申请提现的指定账户', '2022-01-05 21:35:35', null), ('128', 'store_commission_cash_type', '微信零钱', '2', '0', '0', '门店可通过后台直接把佣金提现到个人的微信零钱红包，钱会从总部绑定的微信支付商户平台中直接扣除，请确保已成功绑定微信支付平台并且余额充足', '2022-01-05 21:35:51', null), ('129', 'salesman_status', '正常', '1', '0', '0', '正常', '2022-01-08 16:16:11', null), ('130', 'salesman_status', '禁用', '2', '0', '0', '禁用', '2022-01-08 16:16:20', null), ('131', 'salesman_status', '删除', '3', '0', '0', '删除', '2022-01-08 16:16:30', null), ('132', 'distributor_balance_flow_type', '人工增减', '1', '0', '0', '充值', '2022-01-08 22:19:44', null), ('133', 'distributor_balance_flow_type', '红包发放', '2', '0', '0', '红包发放', '2022-01-08 22:19:57', null), ('135', 'scan_type', '微信', '1', '0', '0', '微信', '2022-01-15 22:58:14', null), ('136', 'scan_type', '小程序', '2', '0', '0', '小程序', '2022-01-15 22:58:32', null), ('137', 'scan_type', 'H5/其他', '3', '0', '0', 'H5/其他', '2022-01-15 22:58:48', null), ('138', 'mall_commission_type', '按百分比', '1', '0', '0', '按百分比', '2022-03-09 22:14:52', null), ('139', 'mall_commission_type', '按金额', '2', '0', '0', '按金额', '2022-03-09 22:15:03', null), ('140', 'mall_order_status', '申请退款', '-1', '0', '0', '申请退款', '2022-03-10 23:27:09', null), ('141', 'mall_order_status', '退货成功', '-2', '0', '0', '退货成功', '2022-03-10 23:27:24', null), ('142', 'mall_order_status', '待发货', '0', '0', '0', '待发货', '2022-03-10 23:27:38', null), ('143', 'mall_order_status', '待收货', '1', '0', '0', '待收货', '2022-03-10 23:27:51', null), ('144', 'mall_order_status', '已收货', '2', '0', '0', '已收货', '2022-03-10 23:28:11', null), ('145', 'mall_order_status', '待评价', '3', '0', '0', '待评价', '2022-03-10 23:28:23', null), ('146', 'mall_order_status', '已退款', '-3', '0', '0', '已退款', '2022-03-10 23:28:49', null), ('147', 'mall_fenxiao_cash_status', '待审核', '1', '0', '0', '待审核', '2022-03-11 00:55:53', null), ('148', 'mall_fenxiao_cash_status', '审核通过', '2', '0', '0', '审核通过', '2022-03-11 00:56:06', null), ('149', 'mall_fenxiao_cash_status', '审核拒绝', '3', '0', '0', '审核拒绝', '2022-03-11 00:56:16', null), ('150', 'service_type_info', '订阅号', '0', '0', '0', '订阅号', '2022-03-15 18:15:37', null), ('151', 'service_type_info', '服务号', '2', '0', '0', '服务号', '2022-03-15 18:15:50', null), ('152', 'service_type_info', '由历史老帐号升级后的订阅号', '1', '0', '0', '由历史老帐号升级后的订阅号', '2022-03-15 18:16:04', null), ('153', 'verify_type_info', '未认证', '-1', '0', '0', '未认证', '2022-03-15 18:16:52', null), ('154', 'verify_type_info', '微信认证', '0', '0', '0', '微信认证', '2022-03-15 18:17:06', null), ('155', 'verify_type_info', '新浪微博认证', '1', '0', '0', '新浪微博认证', '2022-03-15 18:17:16', null), ('156', 'verify_type_info', '腾讯微博认证', '2', '0', '0', '腾讯微博认证', '2022-03-15 18:17:25', null), ('157', 'verify_type_info', '已资质认证通过但还未通过名称认证', '3', '0', '0', '已资质认证通过但还未通过名称认证', '2022-03-15 18:17:36', null), ('158', 'verify_type_info', '已资质认证通过、还未通过名称认证，但通过了新浪微博认证', '4', '0', '0', '已资质认证通过、还未通过名称认证，但通过了新浪微博认证', '2022-03-15 18:17:47', null), ('159', 'verify_type_info', '已资质认证通过、还未通过名称认证，但通过了腾讯微博认证', '5', '0', '0', '已资质认证通过、还未通过名称认证，但通过了腾讯微博认证', '2022-03-15 18:18:02', null);
COMMIT;

-- ----------------------------
--  Table structure for `ctc_dict_type`
-- ----------------------------
DROP TABLE IF EXISTS `ctc_dict_type`;
CREATE TABLE `ctc_dict_type` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `dict_name` varchar(255) DEFAULT NULL,
  `dict_type` varchar(255) DEFAULT NULL,
  `create_by` varchar(255) DEFAULT NULL,
  `status` tinyint(4) DEFAULT '0' COMMENT '字段状态 0 正常 1禁用',
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `remark` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=46 DEFAULT CHARSET=utf8mb4;

-- ----------------------------
--  Records of `ctc_dict_type`
-- ----------------------------
BEGIN;
INSERT INTO `ctc_dict_type` VALUES ('4', '用户性别', 'sys_user_sex', null, '0', '2021-10-06 15:27:14', '用户性别'), ('7', '码类型', 'code_type', null, '0', '2021-10-07 21:18:49', '生码类型'), ('8', '应用场景', 'code_scene', null, '0', '2021-10-07 21:31:40', '码应用场景'), ('9', '合伙人/品牌商状态', 'partner_status', null, '0', '2021-10-08 00:54:23', '合伙人与品牌商状态'), ('10', '合伙人行业', 'partner_industry', null, '0', '2021-10-08 01:07:37', '合伙人所属行业'), ('11', '需求优先级', 'demand_priority', null, '0', '2021-10-09 01:37:41', '需求优先级'), ('12', '需求状态', 'demand_status', null, '0', '2021-10-09 01:39:57', '需求状态'), ('13', '公司类型', 'company_type', null, '0', '2021-10-10 21:40:14', '公司类型'), ('14', '账户类型', 'recharge_type', null, '0', '2021-10-11 06:30:35', '合伙人充值类型'), ('15', '交易类型', 'transaction_type', null, '0', '2021-10-11 20:02:24', '交易类型'), ('16', '操作类型', 'sys_oper_type', null, '0', '2021-10-17 23:10:07', '操作类型'), ('17', '访问环境', 'access_environment', null, '0', '2021-10-25 00:15:45', '访问环境'), ('18', '开户银行', 'bank_type', null, '0', '2021-10-27 04:18:43', '提现开户银行'), ('19', '生码位数', 'code_length', null, '0', '2021-10-27 06:56:24', '数码长度8~20位'), ('20', '仓库类型', 'warehouse_type', null, '0', '2021-11-16 00:37:49', '仓库类型'), ('21', '直播设备清晰度', 'equ_definition', null, '0', '2021-11-19 20:47:36', '直播设备清晰度'), ('22', '短信类型', 'sms_type', null, '0', '2021-11-21 14:07:09', '短信类型'), ('23', '红包类型', 'redpack_type', null, '0', '2021-12-07 15:44:01', '红包类型'), ('24', '红包金额类型', 'redpack_monry_type', null, '0', '2021-12-07 15:51:16', '红包金额类型'), ('25', '红包发放应用', 'redpack_grant_app', null, '0', '2021-12-08 17:37:56', '红包发放应用'), ('26', '红包发放状态', 'redpack_grant_status', null, '0', '2021-12-08 17:48:13', '红包发放状态'), ('27', '积分发放应用', 'integral_grant_app', null, '0', '2021-12-09 12:55:53', '积分发放应用'), ('28', '物流码关联层级', 'logistics_level', null, '0', '2021-12-14 23:06:24', '物流码大小标关系层级'), ('29', '导购码领奖顺序', 'guide_prize_order', null, '0', '2021-12-16 20:55:47', '导购码领奖顺序'), ('30', '微信公众号关注状态', 'official_account_status', null, '0', '2021-12-24 23:00:15', '微信公众号状态'), ('31', '资产类型', 'assets_type', null, '0', '2021-12-27 11:30:21', '资产类型'), ('32', '字段类型', 'field_type', null, '0', '2021-12-27 17:14:53', '自定义字段类型'), ('33', '门店状态', 'store_status', null, '0', '2022-01-02 22:38:59', '门店状态'), ('34', '门店资金流动类型', 'store_balance_flow_type', null, '0', '2022-01-05 15:18:14', '门店资金流动类型'), ('35', '门店佣金提现状态', 'store_commission_cash_status', null, '0', '2022-01-05 21:27:15', '门店佣金提现状态'), ('36', '门店佣金提现方式', 'store_commission_cash_type', null, '0', '2022-01-05 21:35:12', '门店佣金提现方式'), ('38', '业务员状态', 'salesman_status', null, '0', '2022-01-08 16:15:59', '业务员状态'), ('39', '经销商资金流动类型', 'distributor_balance_flow_type', null, '0', '2022-01-08 22:19:23', '经销商资金流动类型'), ('40', '扫码方式', 'scan_type', null, '0', '2022-01-15 22:57:49', '扫码方式'), ('41', '商城佣金计算方式', 'mall_commission_type', null, '0', '2022-03-09 22:14:35', '商城佣金计算方式'), ('42', '商城订单状态', 'mall_order_status', null, '0', '2022-03-10 23:26:26', '商城订单状态'), ('43', '分销提现状态', 'mall_fenxiao_cash_status', null, '0', '2022-03-11 00:55:35', '分销提现状态'), ('44', '公众号类型', 'service_type_info', null, '0', '2022-03-15 18:15:07', '公众号类型'), ('45', '公众号认证类型', 'verify_type_info', null, '0', '2022-03-15 18:16:33', '公众号认证类型');
COMMIT;

-- ----------------------------
--  Table structure for `ctc_finance_bill`
-- ----------------------------
DROP TABLE IF EXISTS `ctc_finance_bill`;
CREATE TABLE `ctc_finance_bill` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `serial_number` varchar(255) DEFAULT NULL,
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP,
  `transaction_type` varchar(255) DEFAULT NULL,
  `remark` varchar(255) DEFAULT NULL,
  `subject` tinyint(4) DEFAULT NULL COMMENT '主体类型 1合伙人 2品牌商',
  `account_type` varchar(255) DEFAULT NULL COMMENT '账户类型1余额 2预存款',
  `balance` varchar(255) DEFAULT NULL COMMENT '余额',
  `payments_type` tinyint(4) DEFAULT NULL COMMENT '收入或者支出 0收入 1支出',
  `bill` varchar(255) DEFAULT NULL COMMENT '金额明细',
  `subject_id` int(11) DEFAULT NULL COMMENT '主体id',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=108 DEFAULT CHARSET=utf8mb4;

-- ----------------------------
--  Records of `ctc_finance_bill`
-- ----------------------------
BEGIN;
INSERT INTO `ctc_finance_bill` VALUES ('1', '1234', '2021-10-11 21:15:00', '1', '1111', '1', '1', '111', '1', '11', '1'), ('2', '233', '2021-10-11 21:31:39', '1', '11233', '2', '1', '1', '1', '1', '1'), ('3', '111111', '2021-10-11 22:47:23', '7', '申请提现', '1', '1', '89', '0', '80', '1'), ('4', '111111', '2021-10-11 23:00:45', '8', '提现驳回资金返回', '1', '1', '189', '0', '100', '1'), ('5', '111111', '2021-10-11 23:03:03', '8', '提现驳回资金返回', '1', '1', '289', '0', '100', '1'), ('6', '111111', '2021-10-11 23:06:01', '7', '申请提现', '1', '1', '209', '1', '80', '1'), ('7', '202110261635222031', '2021-10-26 12:20:31', '6', '品牌商续费', '1', '2', '-200', '1', '400', '1'), ('8', '202110261635222335', '2021-10-26 12:25:35', '6', '品牌商续费', '1', '2', '7200', '1', '800', '1'), ('9', '202110261635261204', '2021-10-26 23:13:24', '6', '品牌商续费', '1', '2', '7840', '1', '160', '1'), ('10', '202110261635262368', '2021-10-26 23:32:48', '5', '品牌商续费', '1', '2', '7760', '1', '80', '1'), ('11', '202110271635282634', '2021-10-27 05:37:48', '7', '申请提现', '1', '1', '159.2', '1', '49.8', '1'), ('12', '202110271635303063', '2021-10-27 10:51:35', '8', '提现驳回资金返回', '1', '1', '169.2', '0', '10', '1'), ('13', '202110271635321921', '2021-10-27 16:05:21', '5', '品牌商模块升降服务', '1', '2', '7600', '1', '160', '1'), ('14', '202110271635321968', '2021-10-27 16:06:08', '6', '品牌商续费', '1', '2', '7280', '1', '320', '1'), ('15', '202110271635322031', '2021-10-27 16:07:11', '6', '品牌商续费', '1', '2', '7120', '1', '160', '1'), ('16', '202110271635322716', '2021-10-27 16:32:45', '7', '申请提现', '1', '1', '159.23999999999998', '1', '9.96', '1'), ('17', '202111041636021449', '2021-11-04 18:24:48', '7', '申请提现', '1', '1', '-947.556', '1', '1106.556', '1'), ('18', '202111041636022724', '2021-11-04 18:45:56', '7', '申请提现', '1', '1', '990', '1', '10', '1'), ('19', '202111041636024133', '2021-11-04 19:11:31', '7', '申请提现', '1', '1', '890', '1', '100', '1'), ('20', '202111051636107416', '2021-11-05 18:16:56', '5', '品牌商模块升降服务', '1', '2', '920', '1', '80', '1'), ('21', '202111051636111891', '2021-11-05 19:31:31', '1', '余额', '1', '1', '920', '0', '10', '1'), ('22', '202111051636112064', '2021-11-05 19:34:24', '1', '合伙人预存款充值', '1', '2', '100', '0', '100', '4'), ('23', '202111061636181949', '2021-11-06 14:59:09', '2', '品牌商开户', '1', '2', '12', '1', '88', '1'), ('24', '202111061636189668', '2021-11-06 17:07:48', '2', '品牌商开户', '1', '2', '12', '1', '88', '1'), ('25', '202111061636193157', '2021-11-06 18:05:57', '2', '品牌商开户', '1', '2', '112', '1', '88', '1'), ('26', '202111071636216814', '2021-11-07 00:40:47', '8', '提现驳回资金返回', '1', '1', '210', '0', '10', '1'), ('27', '202111081636353682', '2021-11-08 14:41:22', '4', '品牌商增值服务', '1', '1', '1390', '1', '610', '1'), ('28', '202111081636353682', '2021-11-08 14:41:22', '4', '品牌商增值服务', '2', '1', '1390', '1', '750', '5'), ('29', '202111081636357341', '2021-11-08 15:42:21', '4', '品牌商增值服务', '1', '1', '690', '1', '700', '1'), ('30', '202111081636357341', '2021-11-08 15:42:21', '4', '品牌商增值服务', '2', '1', '690', '1', '860', '5'), ('31', '202111081636357583', '2021-11-08 15:46:23', '4', '品牌商增值服务', '1', '1', '590', '1', '100', '1'), ('32', '202111081636357583', '2021-11-08 15:46:23', '4', '品牌商增值服务', '2', '1', '590', '1', '120', '22'), ('33', '202111081636357865', '2021-11-08 15:51:05', '6', '品牌商续费', '1', '2', '24', '1', '88', '1'), ('35', '202111081636358548', '2021-11-08 16:02:28', '4', '品牌商增值服务', '1', '1', '470', '1', '120', '1'), ('36', '202111081636358548', '2021-11-08 16:02:28', '4', '品牌商增值服务', '2', '1', '470', '1', '150', '22'), ('37', '202111081636361734', '2021-11-08 16:55:34', '1', '合伙人预存款充值', '1', '2', '1024', '0', '1000', '1'), ('45', '202111081636362271', '2021-11-08 17:04:31', '6', '品牌商续费', '1', '2', '936', '1', '88', '1'), ('46', '202111081636362271', '2021-11-08 17:04:31', '6', '品牌商续费', '2', '2', '936', '1', '162', '22'), ('55', '202111081636363768', '2021-11-08 17:29:28', '5', '品牌商模块升降服务', '1', '2', '856', '1', '80', '1'), ('56', '202111081636363768', '2021-11-08 17:29:28', '5', '品牌商模块升降服务', '2', '2', '856', '1', '300', '1'), ('57', '202111081636364372', '2021-11-08 17:40:08', '8', '提现驳回资金返回', '1', '1', '480', '0', '10', '1'), ('58', '202111081636366610', '2021-11-08 18:16:50', '1', '合伙人余额充值', '1', '1', '500', '0', '20', '1'), ('59', '202111081636367207', '2021-11-08 18:26:47', '7', '合伙人申请提现', '1', '1', '490', '1', '10', '1'), ('60', '202111081636367207', '2021-11-08 18:30:45', '8', '提现驳回资金返回', '1', '1', '500', '0', '10', '1'), ('61', '202111081636367730', '2021-11-08 18:35:30', '7', '合伙人申请提现', '1', '1', '400', '1', '100', '1'), ('62', '202111081636367809', '2021-11-08 18:36:49', '7', '合伙人申请提现', '1', '1', '390', '1', '10', '1'), ('63', '202111081636367809', '2021-11-08 18:37:13', '8', '提现驳回资金返回', '1', '1', '400', '0', '10', '1'), ('64', '202111081636368743', '2021-11-08 18:52:23', '5', '品牌商模块升降服务', '1', '2', '776', '1', '80', '1'), ('65', '202111081636368743', '2021-11-08 18:52:23', '5', '品牌商模块升降服务', '2', '2', '776', '1', '100', '1'), ('66', '202111081636384241', '2021-11-08 23:10:41', '1', '合伙人余额充值', '1', '1', '500', '0', '100', '1'), ('67', '202111081636385303', '2021-11-08 23:28:23', '1', '合伙人预存款充值', '1', '2', '796', '0', '20', '1'), ('68', '202111091636441201', '2021-11-09 15:00:01', '7', '合伙人申请提现', '1', '1', '490', '1', '10', '1'), ('69', '202111111636626915', '2021-11-11 18:35:15', '2', '品牌商开户', '1', '2', '628', '1', '168', '1'), ('70', '202111121636729916', '2021-11-12 23:11:56', '5', '品牌商模块升降服务', '1', '2', '548', '1', '80', '1'), ('71', '202111121636729916', '2021-11-12 23:11:56', '5', '品牌商模块升降服务', '2', '2', '548', '1', '190', '1'), ('72', '202112171639725488', '2021-12-17 15:18:08', '5', '品牌商模块升降服务', '1', '2', '468', '1', '80', '1'), ('73', '202112171639725488', '2021-12-17 15:18:08', '5', '品牌商模块升降服务', '2', '2', '468', '1', '150', '1'), ('74', '202112171639745652', '2021-12-17 20:54:12', '5', '品牌商模块升降服务', '1', '2', '388', '1', '80', '1'), ('75', '202112171639745652', '2021-12-17 20:54:12', '5', '品牌商模块升降服务', '2', '2', '388', '1', '192', '22'), ('76', '202112171639745822', '2021-12-17 20:57:02', '5', '品牌商模块升降服务', '1', '2', '308', '1', '80', '1'), ('77', '202112171639745822', '2021-12-17 20:57:02', '5', '品牌商模块升降服务', '2', '2', '308', '1', '150', '22'), ('78', '202112171639749922', '2021-12-17 22:05:22', '3', '品牌商生码', '1', '1', '0', '1', '100.00', '1'), ('79', '202112171639749922', '2021-12-17 22:05:22', '3', '品牌商生码', '2', '1', '0', '1', '33800.00', '23'), ('80', '202112171639750389', '2021-12-17 22:13:09', '3', '品牌商生码', '1', '1', '300', '1', '200.00', '1'), ('81', '202112171639750389', '2021-12-17 22:13:09', '3', '品牌商生码', '2', '1', '300', '1', '67600.00', '23'), ('82', '202112211640098956', '2021-12-21 23:02:36', '3', '品牌商生码', '1', '1', '200', '1', '100.00', '1'), ('83', '202112211640098956', '2021-12-21 23:02:36', '3', '品牌商生码', '2', '1', '200', '1', '33800.00', '23'), ('84', '202201081641657294', '2022-01-08 23:54:54', '5', '品牌商模块升降服务', '1', '2', '228', '1', '80', '1'), ('85', '202201081641657294', '2022-01-08 23:54:54', '5', '品牌商模块升降服务', '2', '2', '228', '1', '100', '23'), ('86', '202201081641657358', '2022-01-08 23:55:58', '5', '品牌商模块升降服务', '1', '2', '228', '1', '0', '1'), ('87', '202201081641657358', '2022-01-08 23:55:58', '5', '品牌商模块升降服务', '2', '2', '228', '1', '0', '23'), ('88', '202201081641657375', '2022-01-08 23:56:15', '5', '品牌商模块升降服务', '1', '2', '148', '1', '80', '1'), ('89', '202201081641657375', '2022-01-08 23:56:15', '5', '品牌商模块升降服务', '2', '2', '148', '1', '300', '23'), ('90', '202201231642926120', '2022-01-23 16:22:00', '3', '品牌商生码', '1', '1', '100', '1', '100.00', '1'), ('91', '202201231642926120', '2022-01-23 16:22:00', '3', '品牌商生码', '2', '1', '100', '1', '33800.00', '23'), ('92', '202203111647011240', '2022-03-11 23:07:20', '5', '品牌商模块升降服务', '1', '2', '68', '1', '80', '1'), ('93', '202203111647011240', '2022-03-11 23:07:20', '5', '品牌商模块升降服务', '2', '2', '68', '1', '190', '23'), ('94', '202203161647409137', '2022-03-16 13:38:57', '5', '品牌商模块升降服务', '1', '2', '3228', '1', '7840', '1'), ('95', '202203161647409137', '2022-03-16 13:38:57', '5', '品牌商模块升降服务', '2', '2', '3228', '1', '6800', '21'), ('96', '202203161647409315', '2022-03-16 13:41:55', '5', '品牌商模块升降服务', '1', '2', '5388', '1', '7840', '1'), ('97', '202203161647409315', '2022-03-16 13:41:55', '5', '品牌商模块升降服务', '2', '2', '5388', '1', '6800', '23'), ('98', '202203191647693047', '2022-03-19 20:30:47', '3', '品牌商生码', '1', '1', '89', '1', '11.00', '1'), ('99', '202203191647693047', '2022-03-19 20:30:47', '3', '品牌商生码', '2', '1', '89', '1', '3718.00', '1'), ('100', '202203201647707608', '2022-03-20 00:33:28', '3', '品牌商生码', '1', '1', '79', '1', '10.00', '1'), ('101', '202203201647707608', '2022-03-20 00:33:28', '3', '品牌商生码', '2', '1', '79', '1', '3380.00', '23'), ('102', '202203201647768531', '2022-03-20 17:28:51', '3', '品牌商生码', '1', '1', '59', '1', '20.00', '1'), ('103', '202203201647768531', '2022-03-20 17:28:51', '3', '品牌商生码', '2', '1', '59', '1', '6760.00', '23'), ('104', '202203201647768764', '2022-03-20 17:32:44', '3', '品牌商生码', '1', '1', '39', '1', '20.00', '1'), ('105', '202203201647768764', '2022-03-20 17:32:44', '3', '品牌商生码', '2', '1', '39', '1', '6760.00', '23'), ('106', '202203201647769378', '2022-03-20 17:42:58', '3', '品牌商生码', '1', '1', '19', '1', '20.00', '1'), ('107', '202203201647769378', '2022-03-20 17:42:58', '3', '品牌商生码', '2', '1', '19', '1', '6760.00', '23');
COMMIT;

-- ----------------------------
--  Table structure for `ctc_increment_service`
-- ----------------------------
DROP TABLE IF EXISTS `ctc_increment_service`;
CREATE TABLE `ctc_increment_service` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `cost_price` varchar(255) DEFAULT NULL,
  `retail_price` varchar(255) DEFAULT NULL,
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `create_by` varchar(255) DEFAULT NULL,
  `status` tinyint(4) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4;

-- ----------------------------
--  Records of `ctc_increment_service`
-- ----------------------------
BEGIN;
INSERT INTO `ctc_increment_service` VALUES ('1', '客户化部署', '100', '101', '2021-10-11 01:48:37', null, '0'), ('2', '客户托管服务', '200', '304', '2021-10-11 01:48:47', null, '0'), ('3', '客户上门培训', '300', '400', '2021-10-11 01:49:06', null, '0'), ('4', '客户OEM', '400', '500', '2021-10-11 01:49:14', null, '0');
COMMIT;

-- ----------------------------
--  Table structure for `ctc_increment_service_order`
-- ----------------------------
DROP TABLE IF EXISTS `ctc_increment_service_order`;
CREATE TABLE `ctc_increment_service_order` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `order_num` varchar(255) DEFAULT NULL,
  `dealer_id` int(11) DEFAULT NULL,
  `increment_service_id` varchar(255) DEFAULT NULL,
  `status` tinyint(4) DEFAULT '0' COMMENT '审核状态 0为未审核 1审核通过 2审核不通过',
  `is_del` tinyint(4) DEFAULT '0',
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `create_by` varchar(255) DEFAULT NULL,
  `cost` varchar(255) DEFAULT NULL COMMENT '成本价',
  `sale` varchar(255) DEFAULT NULL COMMENT '销售价',
  `partner_id` int(11) DEFAULT NULL,
  `train_times` varchar(255) DEFAULT NULL COMMENT '培训次数',
  `is_customized` tinyint(4) DEFAULT '0' COMMENT '是否定制',
  `customized_cost` varchar(255) DEFAULT NULL COMMENT '定制成本',
  `customized_sale` varchar(255) DEFAULT NULL COMMENT '销售价格',
  `customized_des` text COMMENT '定制详细描述',
  `pay_type` tinyint(4) DEFAULT '0' COMMENT '0余额支付 1线下支付',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4;

-- ----------------------------
--  Records of `ctc_increment_service_order`
-- ----------------------------
BEGIN;
INSERT INTO `ctc_increment_service_order` VALUES ('1', '111', '1', '1', '1', '1', '2021-10-11 02:56:04', null, null, null, '1', null, '0', null, null, null, '0'), ('3', '1635183468', '5', '1,4', '1', '0', '2021-10-26 01:37:48', null, '610', '750', '1', '1', '1', '10', '10', '11', '0'), ('4', '1635183735', '5', '1', '0', '0', '2021-10-26 01:42:15', null, '200', '240', '1', '1', '0', null, null, null, '0'), ('5', '1635189447', '5', '1,4', '1', '1', '2021-10-26 03:17:27', null, '600', '740', '1', '1', '0', null, null, null, '0'), ('6', '1635321696', '5', '3', '1', '0', '2021-10-27 16:01:36', null, '310', '500', '1', '1', '1', '10', '100', 'test', '0'), ('7', '1636193320', '22', '4', '0', '0', '2021-11-06 18:08:40', null, '400', '500', '1', '1', '0', null, null, null, '0'), ('8', '202111061636205836', '22', '', '0', '0', '2021-11-06 21:37:16', null, '0', '0', '1', '1', '0', null, null, null, '0'), ('9', '202111061636213184', '22', '1', '1', '0', '2021-11-06 23:39:44', null, '100', '120', '1', '1', '0', null, null, null, '0'), ('10', '202111081636355637', '5', '1', '1', '0', '2021-11-08 15:13:57', null, '720', '860', '1', '1', '1', '120', '140', 'iusiafhshfsfksd\nfsdlkfjklsdjfsjfklsd\nfsdlkfjklsdjfklsdjkfjksld\nsdfjsdklfjklsdjfdslkfjklsd', '0'), ('11', '202111081636356022', '5', '1', '0', '1', '2021-11-08 15:20:22', null, '700', '840', '1', '1', '1', '100', '120', 'iusiafhshfsfksd\nfsdlkfjklsdjfsjfklsd\nfsdlkfjklsdjfklsdjkfjksld\nsdfjsdklfjklsdjfdslkfjklsd\n日头儿童热IT通融儿童', '0'), ('12', '202111081636357522', '22', '1', '1', '0', '2021-11-08 15:45:22', null, '100', '120', '1', '1', '0', null, null, null, '0'), ('13', '202111081636357709', '22', '1', '1', '0', '2021-11-08 15:48:29', null, '100', '120', '1', '1', '1', '0', '0', '123', '1'), ('14', '202111081636358286', '22', '1', '1', '0', '2021-11-08 15:58:06', null, '120', '150', '1', '1', '1', '20', '30', '哈哈哈', '0');
COMMIT;

-- ----------------------------
--  Table structure for `ctc_login_log`
-- ----------------------------
DROP TABLE IF EXISTS `ctc_login_log`;
CREATE TABLE `ctc_login_log` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `username` varchar(255) DEFAULT NULL,
  `ip_address` varchar(255) DEFAULT NULL,
  `address` varchar(255) DEFAULT NULL,
  `browser` varchar(255) DEFAULT NULL,
  `status` tinyint(4) DEFAULT '0' COMMENT '0登录成功 1登录失败',
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `account` varchar(255) DEFAULT NULL,
  `operating_system` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=142 DEFAULT CHARSET=utf8mb4;

-- ----------------------------
--  Records of `ctc_login_log`
-- ----------------------------
BEGIN;
INSERT INTO `ctc_login_log` VALUES ('1', 'admin', '127.0.0.1', '0内网IP', 'Chrome', '0', '2021-10-17 00:21:09', 'admin', 'OS X'), ('2', 'admin', '127.0.0.1', '山东东营', 'Chrome', '0', '2021-10-17 00:22:40', 'admin', 'OS X'), ('3', 'admin', '127.0.0.1', '0内网IP', 'Chrome', '0', '2021-10-17 18:02:58', 'admin', 'OS X'), ('4', '普通用户', '127.0.0.1', '0内网IP', 'Chrome', '0', '2021-10-17 18:31:48', 'admin123', 'OS X'), ('5', '普通用户', '127.0.0.1', '0内网IP', 'Chrome', '0', '2021-10-17 18:32:14', 'admin123', 'OS X'), ('6', 'admin', '127.0.0.1', '0内网IP', 'Chrome', '0', '2021-10-17 18:32:24', 'admin', 'OS X'), ('7', 'admin', '127.0.0.1', '0内网IP', 'Chrome', '0', '2021-10-17 23:55:34', 'admin', 'OS X'), ('8', 'admin', '127.0.0.1', '0内网IP', 'Chrome', '0', '2021-10-17 23:55:48', 'admin', 'OS X'), ('9', 'admin', '127.0.0.1', '0内网IP', 'Chrome', '0', '2021-10-19 09:58:26', 'admin', 'OS X'), ('10', 'admin', '127.0.0.1', '0内网IP', 'Chrome', '0', '2021-10-19 22:17:13', 'admin', 'OS X'), ('11', 'admin', '127.0.0.1', '0内网IP', 'Chrome', '0', '2021-10-21 23:20:01', 'admin', 'OS X'), ('12', 'admin', '127.0.0.1', '0内网IP', 'Chrome', '0', '2021-10-21 23:51:05', 'admin', 'OS X'), ('13', 'admin', '127.0.0.1', '0内网IP', 'Chrome', '0', '2021-10-22 00:28:26', 'admin', 'OS X'), ('14', 'admin', '127.0.0.1', '0内网IP', 'Chrome', '0', '2021-10-22 00:33:12', 'admin', 'OS X'), ('15', 'admin', '127.0.0.1', '0内网IP', 'Chrome', '0', '2021-10-22 00:43:09', 'admin', 'OS X'), ('16', 'admin', '127.0.0.1', '0内网IP', 'Chrome', '0', '2021-10-22 00:56:05', 'admin', 'OS X'), ('17', 'admin', '127.0.0.1', '0内网IP', 'Safari', '0', '2021-10-23 16:34:22', 'admin', 'OS X'), ('18', 'admin', '127.0.0.1', '0内网IP', 'Safari', '0', '2021-10-24 00:54:48', 'admin', 'OS X'), ('19', 'admin', '127.0.0.1', '0内网IP', 'Safari', '0', '2021-10-24 14:37:08', 'admin', 'OS X'), ('20', 'admin', '127.0.0.1', '0内网IP', 'Chrome', '0', '2021-10-24 17:27:17', 'admin', 'OS X'), ('21', 'admin', '127.0.0.1', '0内网IP', 'Chrome', '0', '2021-10-25 10:32:43', 'admin', 'OS X'), ('22', 'admin', '127.0.0.1', '0内网IP', 'Chrome', '0', '2021-10-26 01:15:16', 'admin', 'OS X'), ('23', 'admin', '127.0.0.1', '0内网IP', 'Chrome', '0', '2021-10-26 16:43:41', 'admin', 'OS X'), ('24', 'admin', '127.0.0.1', '0内网IP', 'Chrome', '0', '2021-10-27 04:43:47', 'admin', 'OS X'), ('25', 'admin', '127.0.0.1', '0内网IP', 'Chrome', '0', '2021-10-27 11:16:05', 'admin', 'OS X'), ('26', 'admin', '127.0.0.1', '0内网IP', 'Chrome', '0', '2021-10-27 15:02:29', 'admin', 'OS X'), ('27', 'admin', '127.0.0.1', '0内网IP', 'Chrome', '0', '2021-10-27 15:08:43', 'admin', 'OS X'), ('28', 'admin', '127.0.0.1', '0内网IP', 'Chrome', '0', '2021-10-27 15:09:24', 'admin', 'OS X'), ('29', '1', '127.0.0.1', '0内网IP', 'Chrome', '0', '2021-10-27 15:55:37', 'test1', 'OS X'), ('30', 'admin', '127.0.0.1', '0内网IP', 'Chrome', '0', '2021-10-27 15:55:57', 'admin', 'OS X'), ('31', 'admin', '127.0.0.1', '0内网IP', 'Chrome', '0', '2021-10-28 13:55:41', 'admin', 'OS X'), ('32', 'admin', '127.0.0.1', '0内网IP', 'Chrome', '0', '2021-10-28 14:09:18', 'admin', 'OS X'), ('33', 'admin', '127.0.0.1', '0内网IP', 'Chrome', '0', '2021-10-28 17:32:06', 'admin', 'OS X'), ('34', 'admin', '127.0.0.1', '0内网IP', 'Chrome', '0', '2021-10-28 17:32:25', 'admin', 'OS X'), ('35', 'admin', '127.0.0.1', '0内网IP', 'Chrome', '0', '2021-10-28 18:19:46', 'admin', 'OS X'), ('36', 'admin', '127.0.0.1', '0内网IP', 'Chrome', '0', '2021-10-31 17:50:19', 'admin', 'OS X'), ('37', 'admin', '127.0.0.1', '0内网IP', 'Chrome', '0', '2021-11-04 13:40:20', 'admin', 'OS X'), ('38', 'admin', '127.0.0.1', '0内网IP', 'Chrome', '0', '2021-11-04 13:47:23', 'admin', 'OS X'), ('39', 'admin', '127.0.0.1', '0内网IP', 'Chrome', '0', '2021-11-05 16:19:45', 'admin', 'OS X'), ('40', 'admin', '127.0.0.1', '0内网IP', 'Chrome', '0', '2021-11-06 14:51:10', 'admin', 'OS X'), ('41', 'admin', '127.0.0.1', '0内网IP', 'Chrome', '0', '2021-11-07 13:07:50', 'admin', 'OS X'), ('42', 'admin', '127.0.0.1', '0内网IP', 'Chrome', '0', '2021-11-08 14:40:21', 'admin', 'OS X'), ('43', 'admin', '127.0.0.1', '0内网IP', 'Chrome', '0', '2021-11-09 14:00:22', 'admin', 'OS X'), ('44', 'admin', '127.0.0.1', '0内网IP', 'Chrome', '0', '2021-11-10 14:58:56', 'admin', 'OS X'), ('45', 'admin', '127.0.0.1', '0内网IP', 'Chrome', '0', '2021-11-10 18:15:31', 'admin', 'OS X'), ('46', 'admin', '127.0.0.1', '0内网IP', 'Chrome', '0', '2021-11-10 18:17:04', 'admin', 'OS X'), ('47', 'admin', '127.0.0.1', '0内网IP', 'Chrome', '0', '2021-11-10 18:20:15', 'admin', 'OS X'), ('48', 'admin', '127.0.0.1', '0内网IP', 'Chrome', '0', '2021-11-10 18:27:04', 'admin', 'OS X'), ('49', 'admin', '127.0.0.1', '0内网IP', 'Chrome', '0', '2021-11-10 18:27:13', 'admin', 'OS X'), ('50', 'admin', '127.0.0.1', '0内网IP', 'Chrome', '0', '2021-11-10 18:27:24', 'admin', 'OS X'), ('51', 'admin', '127.0.0.1', '0内网IP', 'Chrome', '0', '2021-11-10 18:27:28', 'admin', 'OS X'), ('52', 'admin', '127.0.0.1', '0内网IP', 'Chrome', '0', '2021-11-10 18:27:32', 'admin', 'OS X'), ('53', 'admin', '127.0.0.1', '0内网IP', 'Chrome', '0', '2021-11-10 18:28:33', 'admin', 'OS X'), ('54', 'admin', '127.0.0.1', '0内网IP', 'Chrome', '0', '2021-11-10 18:28:42', 'admin', 'OS X'), ('55', 'admin', '127.0.0.1', '0内网IP', 'Chrome', '0', '2021-11-10 18:29:00', 'admin', 'OS X'), ('56', 'admin', '127.0.0.1', '0内网IP', 'Chrome', '0', '2021-11-10 18:31:28', 'admin', 'OS X'), ('57', 'admin', '127.0.0.1', '0内网IP', 'Chrome', '0', '2021-11-10 18:35:20', 'admin', 'OS X'), ('58', 'admin', '127.0.0.1', '0内网IP', 'Chrome', '0', '2021-11-10 18:36:13', 'admin', 'OS X'), ('59', 'admin', '127.0.0.1', '0内网IP', 'Chrome', '0', '2021-11-10 18:48:06', 'admin', 'OS X'), ('60', 'admin', '127.0.0.1', '0内网IP', 'Chrome', '0', '2021-11-10 18:48:09', 'admin', 'OS X'), ('61', 'admin', '127.0.0.1', '0内网IP', 'Chrome', '0', '2021-11-10 18:48:42', 'admin', 'OS X'), ('62', 'admin', '127.0.0.1', '0内网IP', 'Chrome', '0', '2021-11-10 18:49:24', 'admin', 'OS X'), ('63', 'admin', '127.0.0.1', '0内网IP', 'Chrome', '0', '2021-11-10 18:52:14', 'admin', 'OS X'), ('64', 'admin', '127.0.0.1', '0内网IP', 'Chrome', '0', '2021-11-10 18:52:21', 'admin', 'OS X'), ('65', 'admin', '127.0.0.1', '0内网IP', 'Chrome', '0', '2021-11-10 18:52:34', 'admin', 'OS X'), ('66', 'admin', '127.0.0.1', '0内网IP', 'Chrome', '0', '2021-11-10 19:11:53', 'admin', 'OS X'), ('67', 'admin', '127.0.0.1', '0内网IP', 'Chrome', '0', '2021-11-10 22:48:08', 'admin', 'OS X'), ('68', 'admin', '127.0.0.1', '0内网IP', 'Chrome', '0', '2021-11-10 22:49:00', 'admin', 'OS X'), ('69', 'admin', '127.0.0.1', '0内网IP', 'Chrome', '0', '2021-11-10 23:28:43', 'admin', 'OS X'), ('70', 'admin', '127.0.0.1', '0内网IP', 'Chrome', '0', '2021-11-10 23:29:29', 'admin', 'OS X'), ('71', 'admin', '127.0.0.1', '0内网IP', 'Chrome', '0', '2021-11-10 23:29:33', 'admin', 'OS X'), ('72', 'admin', '127.0.0.1', '0内网IP', 'Chrome', '0', '2021-11-10 23:29:40', 'admin', 'OS X'), ('73', 'admin', '127.0.0.1', '0内网IP', 'Chrome', '0', '2021-11-10 23:30:15', 'admin', 'OS X'), ('74', 'admin', '127.0.0.1', '0内网IP', 'Chrome', '0', '2021-11-11 14:15:10', 'admin', 'OS X'), ('75', 'admin', '127.0.0.1', '0内网IP', 'Chrome', '0', '2021-11-11 21:38:54', 'admin', 'OS X'), ('76', 'admin', '127.0.0.1', '0内网IP', 'Chrome', '0', '2021-11-11 21:40:37', 'admin', 'OS X'), ('77', 'admin', '127.0.0.1', '0内网IP', 'Chrome', '0', '2021-11-12 14:30:09', 'admin', 'OS X'), ('78', 'admin', '127.0.0.1', '0内网IP', 'Chrome', '0', '2021-11-13 11:42:21', 'admin', 'OS X'), ('79', 'admin', '127.0.0.1', '0内网IP', 'Chrome', '0', '2021-11-14 00:40:41', 'admin', 'OS X'), ('80', 'admin', '127.0.0.1', '0内网IP', 'Chrome', '0', '2021-11-14 13:00:05', 'admin', 'OS X'), ('81', 'admin', '127.0.0.1', '0内网IP', 'Chrome', '0', '2021-11-15 21:35:59', 'admin', 'OS X'), ('82', 'admin', '127.0.0.1', '0内网IP', 'Chrome', '0', '2021-11-16 11:32:07', 'admin', 'OS X'), ('83', 'admin', '127.0.0.1', '0内网IP', 'Chrome', '0', '2021-11-17 16:44:40', 'admin', 'OS X'), ('84', 'admin', '127.0.0.1', '0内网IP', 'Chrome', '0', '2021-11-18 12:16:03', 'admin', 'OS X'), ('85', 'admin', '127.0.0.1', '0内网IP', 'Chrome', '0', '2021-11-19 00:44:50', 'admin', 'OS X'), ('86', 'admin', '127.0.0.1', '0内网IP', 'Chrome', '0', '2021-11-19 16:58:35', 'admin', 'OS X'), ('87', 'admin', '127.0.0.1', '0内网IP', 'Chrome', '0', '2021-11-20 16:34:58', 'admin', 'OS X'), ('88', 'admin', '127.0.0.1', '0内网IP', 'Chrome', '0', '2021-11-21 14:05:45', 'admin', 'OS X'), ('89', 'admin', '127.0.0.1', '0内网IP', 'Chrome', '0', '2021-11-22 12:39:37', 'admin', 'OS X'), ('90', 'admin', '127.0.0.1', '0内网IP', 'Chrome', '0', '2021-11-23 17:03:27', 'admin', 'OS X'), ('91', 'admin', '127.0.0.1', '0内网IP', 'Chrome', '0', '2021-11-25 14:15:21', 'admin', 'OS X'), ('92', 'admin', '127.0.0.1', '0内网IP', 'Chrome', '0', '2021-12-07 14:47:17', 'admin', 'OS X'), ('93', 'admin', '127.0.0.1', '0内网IP', 'Chrome', '0', '2021-12-08 14:42:02', 'admin', 'OS X'), ('94', 'admin', '127.0.0.1', '0内网IP', 'Chrome', '0', '2021-12-09 12:47:27', 'admin', 'OS X'), ('95', 'admin', '127.0.0.1', '0内网IP', 'Chrome', '0', '2021-12-14 16:55:00', 'admin', 'OS X'), ('96', 'admin', '127.0.0.1', '0内网IP', 'Chrome', '0', '2021-12-15 17:59:44', 'admin', 'OS X'), ('97', 'admin', '127.0.0.1', '0内网IP', 'Chrome', '0', '2021-12-16 20:27:42', 'admin', 'OS X'), ('98', 'admin', '127.0.0.1', '0内网IP', 'Chrome', '0', '2021-12-17 14:40:33', 'admin', 'OS X'), ('99', 'admin', '127.0.0.1', '0内网IP', 'Chrome', '0', '2021-12-21 23:05:24', 'admin', 'OS X'), ('100', 'admin', '127.0.0.1', '0内网IP', 'Chrome', '0', '2021-12-22 15:49:49', 'admin', 'OS X'), ('101', 'admin', '127.0.0.1', '0内网IP', 'Chrome', '0', '2021-12-23 20:59:53', 'admin', 'OS X'), ('102', 'admin', '127.0.0.1', '0内网IP', 'Chrome', '0', '2021-12-24 22:50:53', 'admin', 'OS X'), ('103', 'admin', '127.0.0.1', '0内网IP', 'Chrome', '0', '2021-12-26 01:06:24', 'admin', 'OS X'), ('104', 'admin', '127.0.0.1', '0内网IP', 'Chrome', '0', '2021-12-27 11:03:27', 'admin', 'OS X'), ('105', 'admin', '127.0.0.1', '0内网IP', 'Chrome', '0', '2021-12-28 20:32:25', 'admin', 'OS X'), ('106', 'admin', '127.0.0.1', '0内网IP', 'Chrome', '0', '2021-12-29 20:41:03', 'admin', 'OS X'), ('107', 'admin', '127.0.0.1', '0内网IP', 'Chrome', '0', '2022-01-02 17:59:57', 'admin', 'OS X'), ('108', 'admin', '127.0.0.1', '0内网IP', 'Chrome', '0', '2022-01-05 09:42:20', 'admin', 'OS X'), ('109', 'admin', '127.0.0.1', '0内网IP', 'Chrome', '0', '2022-01-05 21:58:44', 'admin', 'OS X'), ('110', 'admin', '127.0.0.1', '0内网IP', 'Chrome', '0', '2022-01-06 21:26:23', 'admin', 'OS X'), ('111', 'admin', '127.0.0.1', '0内网IP', 'Chrome', '0', '2022-01-08 16:11:56', 'admin', 'OS X'), ('112', 'admin', '127.0.0.1', '0内网IP', 'Chrome', '0', '2022-01-12 11:30:57', 'admin', 'OS X'), ('113', 'admin', '127.0.0.1', '0内网IP', 'Chrome', '0', '2022-01-13 16:20:32', 'admin', 'OS X'), ('114', 'admin', '127.0.0.1', '0内网IP', 'Chrome', '0', '2022-01-14 22:48:47', 'admin', 'OS X'), ('115', 'admin', '127.0.0.1', '0内网IP', 'Chrome', '0', '2022-01-15 16:30:52', 'admin', 'OS X'), ('116', 'admin', '127.0.0.1', '0内网IP', 'Chrome', '0', '2022-01-17 17:42:36', 'admin', 'OS X'), ('117', 'admin', '127.0.0.1', '0内网IP', 'Chrome', '0', '2022-01-21 17:19:44', 'admin', 'OS X'), ('118', 'admin', '127.0.0.1', '0内网IP', 'Chrome', '0', '2022-01-23 01:45:17', 'admin', 'OS X'), ('119', 'admin', '127.0.0.1', '0内网IP', 'Chrome', '0', '2022-01-23 13:52:32', 'admin', 'OS X'), ('120', 'admin', '127.0.0.1', '0内网IP', 'Chrome', '0', '2022-02-14 15:14:09', 'admin', 'OS X'), ('121', 'admin', '127.0.0.1', '0内网IP', 'Chrome', '0', '2022-03-08 12:39:20', 'admin', 'OS X'), ('122', 'admin', '127.0.0.1', '0内网IP', 'Chrome', '0', '2022-03-09 17:19:13', 'admin', 'OS X'), ('123', 'admin', '127.0.0.1', '0内网IP', 'Chrome', '0', '2022-03-10 10:56:53', 'admin', 'OS X'), ('124', 'admin', '127.0.0.1', '0内网IP', 'Chrome', '0', '2022-03-10 18:17:50', 'admin', 'OS X'), ('125', 'admin', '127.0.0.1', '0内网IP', 'Chrome', '0', '2022-03-11 17:09:00', 'admin', 'OS X'), ('126', 'admin', '127.0.0.1', '0内网IP', 'Chrome', '0', '2022-03-11 22:24:56', 'admin', 'OS X'), ('127', 'admin', '127.0.0.1', '0内网IP', 'Chrome', '0', '2022-03-12 21:24:14', 'admin', 'OS X'), ('128', 'admin', '127.0.0.1', '0内网IP', 'Chrome', '0', '2022-03-14 12:48:29', 'admin', 'OS X'), ('129', 'admin', '127.0.0.1', '0内网IP', 'Chrome', '0', '2022-03-15 18:14:28', 'admin', 'OS X'), ('130', 'admin', '127.0.0.1', '0内网IP', 'Chrome', '0', '2022-03-16 13:34:01', 'admin', 'OS X'), ('131', 'admin', '127.0.0.1', '0内网IP', 'Chrome', '0', '2022-03-17 19:09:51', 'admin', 'OS X'), ('132', 'admin', '127.0.0.1', '0内网IP', 'Chrome', '0', '2022-03-20 23:56:05', 'admin', 'OS X'), ('133', 'admin', '127.0.0.1', '0内网IP', 'Chrome', '0', '2022-03-21 21:41:50', 'admin', 'OS X'), ('134', 'admin', '127.0.0.1', '0内网IP', 'Chrome', '0', '2022-03-22 16:25:03', 'admin', 'OS X'), ('135', 'admin', '127.0.0.1', '0内网IP', 'Chrome', '0', '2022-03-23 21:06:50', 'admin', 'OS X'), ('136', 'admin', '127.0.0.1', '0内网IP', 'Chrome', '0', '2022-03-24 19:10:58', 'admin', 'OS X'), ('137', 'admin', '127.0.0.1', '0内网IP', 'Chrome', '0', '2022-03-27 21:02:58', 'admin', 'OS X'), ('138', 'admin', '127.0.0.1', '0内网IP', 'Chrome', '0', '2022-03-30 17:37:04', 'admin', 'OS X'), ('139', 'admin', '127.0.0.1', '0内网IP', 'Chrome', '0', '2022-03-31 19:42:51', 'admin', 'OS X'), ('140', 'admin', '127.0.0.1', '0内网IP', 'Chrome', '0', '2022-04-01 12:35:37', 'admin', 'OS X'), ('141', 'admin', '127.0.0.1', '0内网IP', 'Chrome', '0', '2022-04-03 12:24:15', 'admin', 'OS X');
COMMIT;

-- ----------------------------
--  Table structure for `ctc_menu`
-- ----------------------------
DROP TABLE IF EXISTS `ctc_menu`;
CREATE TABLE `ctc_menu` (
  `menuId` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `menuName` varchar(255) DEFAULT NULL,
  `menuType` varchar(255) DEFAULT NULL COMMENT '菜单类型 M目录 C菜单 F按钮',
  `orderNum` int(11) DEFAULT NULL,
  `parentId` int(11) DEFAULT '0',
  `parentName` varchar(255) DEFAULT NULL,
  `path` varchar(255) DEFAULT NULL,
  `component` varchar(255) DEFAULT NULL,
  `icon` varchar(255) DEFAULT NULL,
  `isFrame` varchar(255) DEFAULT '1' COMMENT '是否外链 0是 1否',
  `status` tinyint(4) DEFAULT '0',
  `visible` tinyint(4) DEFAULT '0' COMMENT '是否可见 0可见 1隐藏',
  `perms` varchar(255) DEFAULT NULL COMMENT '权限字符',
  `query` varchar(255) DEFAULT NULL COMMENT '路由参数',
  `isCache` tinyint(4) DEFAULT '0' COMMENT '是否开启缓存 0开启 1关闭',
  `createBy` varchar(255) DEFAULT NULL,
  `createTime` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`menuId`)
) ENGINE=InnoDB AUTO_INCREMENT=56 DEFAULT CHARSET=utf8mb4;

-- ----------------------------
--  Records of `ctc_menu`
-- ----------------------------
BEGIN;
INSERT INTO `ctc_menu` VALUES ('6', '数据管理', 'M', '3', '0', null, 'codeStore', null, 'code', '1', '0', '0', null, null, '0', null, '2021-10-06 18:55:52'), ('8', '生码管理', 'C', '1', '6', null, 'code', 'code/index', '', '1', '0', '0', '', '', '0', null, '2021-10-06 21:52:40'), ('9', '待生码管理', 'C', '4', '6', null, 'coding', 'code/waiting', '', '1', '0', '0', null, null, '0', null, '2021-10-07 19:37:39'), ('10', '合伙人列表', 'M', '2', '0', null, 'partner', null, 'partner', '1', '0', '0', null, null, '0', null, '2021-10-07 19:42:03'), ('11', '合伙人列表', 'C', '1', '10', null, 'partnerList', 'partner/index', '', '1', '0', '0', null, null, '0', null, '2021-10-07 19:42:43'), ('12', '合伙人级别', 'C', '2', '10', null, 'partnerLevel', 'partner/level', '', '1', '0', '0', null, null, '0', null, '2021-10-07 19:43:16'), ('13', '品牌商管理', 'M', '1', '0', null, 'dealer', null, 'dealer', '1', '0', '0', null, null, '0', null, '2021-10-07 19:44:30'), ('14', '品牌商列表', 'C', '1', '13', null, 'dealerList', 'dealer/index', '', '1', '0', '0', null, null, '0', null, '2021-10-07 19:45:13'), ('15', '防伪认证管理', 'C', '0', '13', null, 'dealerAuth', 'dealer/auth', '', '1', '0', '0', null, null, '0', null, '2021-10-07 19:45:42'), ('16', '增值服务管理', 'M', '0', '0', null, 'increment', null, 'increment', '1', '0', '0', null, null, '0', null, '2021-10-07 19:47:14'), ('17', '增值订单管理', 'C', '0', '16', null, 'incrementOrder', 'increment/order', '', '1', '0', '0', null, null, '0', null, '2021-10-07 19:47:44'), ('18', '增值服务定价', 'C', '0', '16', null, 'incrementPrice', 'increment/price', '', '1', '0', '0', null, null, '0', null, '2021-10-07 19:48:13'), ('19', '产品管理', 'M', '0', '0', null, 'product', null, 'product', '1', '0', '0', null, null, '0', null, '2021-10-07 19:49:10'), ('20', '短信定价设置', 'C', '0', '19', null, 'smsPrice', 'product/smsPrice', '', '1', '0', '0', null, null, '0', null, '2021-10-07 19:49:40'), ('21', '产品定价列表', 'C', '0', '19', null, 'productPrice', 'product/index', '', '1', '0', '0', null, null, '0', null, '2021-10-07 19:50:12'), ('22', 'PDA设备管理', 'C', '0', '19', null, 'pda', 'product/pda', '', '1', '0', '0', null, null, '0', null, '2021-10-07 19:50:37'), ('23', '财务管理', 'M', '0', '0', null, 'finance', null, 'dashboard', '1', '0', '0', null, null, '0', null, '2021-10-07 19:52:57'), ('24', '客户收支明细', 'C', '0', '23', null, 'paymentsList', 'finance/paymentsList', '', '1', '0', '0', null, null, '0', null, '2021-10-07 19:53:25'), ('25', '合伙人账户管理', 'C', '0', '23', null, 'partnerAccount', 'finance/partnerAccount', '', '1', '0', '0', null, null, '0', null, '2021-10-07 19:53:53'), ('26', '合伙人充值记录', 'C', '0', '23', null, 'partnerPayLog', 'finance/partnerPay', '', '1', '0', '0', null, null, '0', null, '2021-10-07 19:54:18'), ('27', '合伙人提现管理', 'C', '0', '23', null, 'partnerCash', 'finance/partnerCash', '', '1', '0', '0', null, null, '0', null, '2021-10-07 19:54:45'), ('28', '代发红包池管理', 'C', '0', '23', null, 'redPacket', 'finance/redPacket', '', '1', '1', '0', null, null, '0', null, '2021-10-07 19:55:08'), ('29', '需求管理', 'M', '0', '0', null, 'demand', null, 'form', '1', '0', '0', null, null, '0', null, '2021-10-07 19:56:09'), ('30', '需求列表', 'C', '0', '29', null, 'demandList', 'demand/index', '', '1', '0', '0', null, null, '0', null, '2021-10-07 19:56:36'), ('31', '系统管理', 'M', '0', '0', null, 'system', null, 'tree', '1', '0', '0', null, null, '0', null, '2021-10-07 19:57:50'), ('32', '管理员管理', 'C', '0', '31', null, 'admin', 'system/admin', '', '1', '0', '0', null, null, '0', null, '2021-10-07 19:58:21'), ('33', '角色管理', 'C', '0', '31', null, 'role', 'system/role/index', '', '1', '0', '0', null, null, '0', null, '2021-10-07 19:58:46'), ('34', '菜单管理', 'C', '0', '31', null, 'menu', 'system/menu', '', '1', '0', '0', null, null, '0', null, '2021-10-07 19:59:09'), ('35', '字典管理', 'C', '0', '31', null, 'dict', 'system/dict/index', '', '1', '0', '0', null, null, '0', null, '2021-10-07 19:59:34'), ('36', '操作日志', 'C', '0', '31', null, 'operationLog', 'system/log/operationLog', '', '1', '0', '0', null, null, '0', null, '2021-10-07 20:00:01'), ('37', '查看批次秘钥', 'F', '0', '8', null, null, null, null, '1', '0', '0', 'codeStore:code:key', null, '0', null, '2021-10-12 00:01:55'), ('38', '删除批次码', 'F', '0', '8', null, null, null, null, '1', '0', '0', 'codeStore:code:delete', null, '0', null, '2021-10-12 00:46:37'), ('39', '待生码批次秘钥查看', 'F', '0', '9', null, null, null, null, '1', '0', '0', 'codeStore:waiting:key', null, '0', null, '2021-10-12 00:47:55'), ('40', '待生码批次删除', 'F', '0', '9', null, null, null, null, '1', '0', '0', 'codeStore:waiting:delete', null, '0', null, '2021-10-12 00:48:59'), ('41', '添加合伙人', 'F', '0', '11', null, null, null, null, '1', '0', '0', 'partner:partnerList:addPartner', null, '0', null, '2021-10-12 00:52:19'), ('42', '修改合伙人', 'F', '0', '11', null, null, null, null, '1', '0', '0', 'partner:partnerList:editPartner', null, '0', null, '2021-10-12 00:53:44'), ('43', '删除合伙人', 'F', '0', '11', null, null, null, null, '1', '0', '0', 'partner:partnerList:delePartner', null, '0', null, '2021-10-12 00:54:02'), ('44', '重置合伙人密码', 'F', '0', '11', null, null, null, null, '1', '0', '0', 'partner:partnerList:resetPwd', null, '0', null, '2021-10-12 00:55:21'), ('45', '查看合伙人详情', 'F', '0', '11', null, null, null, null, '1', '0', '0', 'partner:partnerList:partnerView', null, '0', null, '2021-10-12 00:56:15'), ('46', '禁用/恢复合伙人账号', 'F', '0', '11', null, null, null, null, '1', '0', '0', 'partner:partnerList:cutPartner', null, '0', null, '2021-10-12 00:57:12'), ('47', '编辑认证合伙人认证信息', 'F', '0', '11', null, null, null, null, '1', '0', '0', 'partner:partnerList:editAuthInfo', null, '0', null, '2021-10-12 00:58:54'), ('48', '查看合伙人认证信息', 'F', '0', '11', null, null, null, null, '1', '0', '0', 'partner:partnerList:authInfoView', null, '0', null, '2021-10-12 00:59:33'), ('49', '表格显示更多操作按钮', 'F', '0', '11', null, null, null, null, '1', '0', '0', 'partner:partnerList:moreOption', null, '0', null, '2021-10-12 01:10:57'), ('50', '添加合伙人级别', 'F', '0', '12', null, null, null, null, '1', '0', '0', 'partner:partnerLevel:addLevel', null, '0', null, '2021-10-12 01:13:57'), ('51', '修改合伙人级别', 'F', '0', '12', null, null, null, null, '1', '0', '0', 'partner:partnerLevel:editLevel', null, '0', null, '2021-10-12 01:14:34'), ('52', '删除合伙人级别', 'F', '0', '12', null, null, null, null, '1', '0', '0', 'partner:partnerLevel:deleLevel', null, '0', null, '2021-10-12 01:15:14'), ('53', '登录日志', 'C', '0', '31', null, 'logininfor', 'system/log/logininfor', null, '1', '0', '0', null, null, '0', null, '2021-10-16 22:55:57'), ('54', '合伙人菜单', 'C', '0', '31', null, 'partnerMenu', 'system/partnerMenu', null, '1', '0', '0', null, null, '0', null, '2021-10-21 23:26:42'), ('55', '品牌商菜单', 'C', '0', '31', null, 'dealerMenu', 'system/dealerMenu', null, '1', '0', '0', null, null, '0', null, '2021-11-10 15:06:54');
COMMIT;

-- ----------------------------
--  Table structure for `ctc_oper_log`
-- ----------------------------
DROP TABLE IF EXISTS `ctc_oper_log`;
CREATE TABLE `ctc_oper_log` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `module_name` varchar(255) DEFAULT NULL,
  `operator` varchar(255) DEFAULT NULL COMMENT '操作人员',
  `ip` varchar(255) DEFAULT NULL,
  `address` varchar(255) DEFAULT NULL,
  `operate_type` varchar(255) DEFAULT NULL COMMENT '操作类型',
  `operate_event` varchar(255) DEFAULT NULL COMMENT '操作事件',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=63 DEFAULT CHARSET=utf8mb4;

-- ----------------------------
--  Records of `ctc_oper_log`
-- ----------------------------
BEGIN;
INSERT INTO `ctc_oper_log` VALUES ('1', '合伙人级别', 'admin', '127.0.0.1', '0内网IP', '2', '修改合伙人等级', null), ('2', '合伙人级别', 'admin', '127.0.0.1', '0内网IP', '2', '修改合伙人等级', '2021-10-17 23:52:43'), ('3', '合伙人级别', 'admin', '127.0.0.1', '0内网IP', '2', '修改合伙人等级', '2021-10-18 00:25:00'), ('4', '合伙人级别', 'admin', '127.0.0.1', '0内网IP', '1', '新增合伙人等级', '2021-10-18 00:28:38'), ('5', '合伙人级别', 'admin', '127.0.0.1', '0内网IP', '3', '删除合伙人等级', '2021-10-18 00:28:43'), ('6', '财务管理', 'admin', '127.0.0.1', '0内网IP', '2', '合伙人余额充值', '2021-11-08 23:10:41'), ('7', '财务管理', 'admin', '127.0.0.1', '0内网IP', '2', '合伙人预存款充值', '2021-11-08 23:28:23'), ('8', '品牌商管理', 'admin', '127.0.0.1', '0内网IP', '2', '增减品牌商的代发红包资金池', '2021-11-08 23:36:16'), ('9', '合伙人级别', 'admin', '127.0.0.1', '0内网IP', '2', '修改合伙人等级', '2021-11-08 23:51:02'), ('10', '合伙人级别', 'admin', '127.0.0.1', '0内网IP', '2', '修改合伙人等级', '2021-11-08 23:51:07'), ('11', '合伙人列表', 'admin', '127.0.0.1', '0内网IP', '2', '修改合伙人', '2021-11-08 23:56:47'), ('12', '合伙人列表', 'admin', '127.0.0.1', '0内网IP', '2', '重置合伙人密码', '2021-11-09 00:01:27'), ('13', '合伙人列表', 'admin', '127.0.0.1', '0内网IP', '2', '修改合伙人状态', '2021-11-09 00:04:31'), ('14', '合伙人列表', 'admin', '127.0.0.1', '0内网IP', '2', '修改合伙人状态', '2021-11-09 00:04:38'), ('15', '合伙人列表', 'admin', '127.0.0.1', '0内网IP', '2', '审核合伙人营业执照', '2021-11-09 00:43:41'), ('16', '品牌商管理', 'admin', '127.0.0.1', '0内网IP', '2', '品牌商账号状态禁用、恢复', '2021-11-09 14:07:27'), ('17', '品牌商管理', 'admin', '127.0.0.1', '0内网IP', '2', '品牌商账号状态禁用、恢复', '2021-11-09 14:07:31'), ('18', '品牌商管理', 'admin', '127.0.0.1', '0内网IP', '2', '更新品牌商营业执照', '2021-11-09 14:14:09'), ('19', '品牌商管理', 'admin', '127.0.0.1', '0内网IP', '2', '修改防伪认证成功', '2021-11-09 14:17:31'), ('20', '增值服务管理', 'admin', '127.0.0.1', '0内网IP', '2', '增值订单删除', '2021-11-09 14:23:21'), ('21', '增值服务管理', 'admin', '127.0.0.1', '0内网IP', '2', '设置增值服务费用', '2021-11-09 14:25:49'), ('22', '产品管理', 'admin', '127.0.0.1', '0内网IP', '2', '更新短信阶梯', '2021-11-09 14:29:19'), ('23', '产品管理', 'admin', '127.0.0.1', '0内网IP', '2', '新增短信阶梯', '2021-11-09 14:29:25'), ('24', '产品管理', 'admin', '127.0.0.1', '0内网IP', '3', '删除短信阶梯', '2021-11-09 14:32:25'), ('25', '产品管理', 'admin', '127.0.0.1', '0内网IP', '2', '修改功能模块', '2021-11-09 14:36:10'), ('26', '产品管理', 'admin', '127.0.0.1', '0内网IP', '2', '更新码阶梯', '2021-11-09 14:38:47'), ('27', '产品管理', 'admin', '127.0.0.1', '0内网IP', '3', '新增码阶梯', '2021-11-09 14:39:06'), ('28', '产品管理', 'admin', '127.0.0.1', '0内网IP', '2', '更新码阶梯', '2021-11-09 14:42:21'), ('29', '产品管理', 'admin', '127.0.0.1', '0内网IP', '3', '删除码阶梯', '2021-11-09 14:43:01'), ('30', '财务管理', 'admin', '127.0.0.1', '0内网IP', '2', '修改提现规则', '2021-11-09 14:56:48'), ('31', '财务管理', 'admin', '127.0.0.1', '0内网IP', '2', '修改提现规则', '2021-11-09 14:59:42'), ('32', '财务管理', 'admin', '127.0.0.1', '0内网IP', '2', '提现订单打款', '2021-11-09 15:00:14'), ('33', '需求管理', 'admin', '127.0.0.1', '0内网IP', '2', '审核需求', '2021-11-09 15:25:02'), ('34', '系统管理', 'admin', '127.0.0.1', '0内网IP', '2', '更新管理员密码状态', '2021-11-09 15:58:05'), ('35', '系统管理', 'admin', '127.0.0.1', '0内网IP', '2', '更新管理员状态', '2021-11-09 15:58:19'), ('36', '系统管理', 'admin', '127.0.0.1', '0内网IP', '2', '更新用户角色', '2021-11-09 16:01:31'), ('37', '合伙人列表', 'admin', '127.0.0.1', '0内网IP', '2', '重置合伙人密码', '2021-11-09 16:40:08'), ('38', '系统管理', 'admin', '127.0.0.1', '0内网IP', '2', '更新用户角色', '2021-11-10 15:07:12'), ('39', '品牌商管理', 'admin', '127.0.0.1', '0内网IP', '2', '更新品牌商商标权证书', '2021-11-13 17:13:32'), ('40', '系统管理', 'admin', '127.0.0.1', '0内网IP', '2', '更新用户角色状态', '2021-11-13 18:07:38'), ('41', '系统管理', 'admin', '127.0.0.1', '0内网IP', '2', '更新用户角色状态', '2021-11-13 18:07:40'), ('42', '系统管理', 'admin', '127.0.0.1', '0内网IP', '3', '删除管理员', '2021-11-13 21:56:01'), ('43', '系统管理', 'admin', '127.0.0.1', '0内网IP', '1', '新增管理员', '2021-11-13 22:16:47'), ('44', '系统管理', 'admin', '127.0.0.1', '0内网IP', '2', '修改管理员', '2021-11-13 22:16:51'), ('45', '系统管理', 'admin', '127.0.0.1', '0内网IP', '3', '删除管理员', '2021-11-13 22:16:55'), ('46', '系统管理', 'admin', '127.0.0.1', '0内网IP', '1', '新增管理员', '2021-11-13 23:17:04'), ('47', '用户管理', 'wenhan', '127.0.0.1', '0内网IP', '3', '删除用户', '2021-11-13 23:33:32'), ('48', '用户管理', 'wenhan', '127.0.0.1', '0内网IP', '3', '删除用户', '2021-11-14 13:12:40'), ('49', '合伙人列表', 'admin', '127.0.0.1', '0内网IP', '2', '修改合伙人', '2021-11-15 21:36:37'), ('50', '合伙人列表', 'admin', '127.0.0.1', '0内网IP', '2', '修改合伙人', '2021-11-15 22:02:07'), ('51', '产品管理', 'admin', '127.0.0.1', '0内网IP', '2', '更新短信阶梯', '2021-11-21 22:26:43'), ('52', '产品管理', 'admin', '127.0.0.1', '0内网IP', '2', '更新短信阶梯', '2021-11-21 22:26:51'), ('53', '产品管理', 'admin', '127.0.0.1', '0内网IP', '2', '更新短信阶梯', '2021-11-22 00:22:25'), ('54', '产品管理', 'admin', '127.0.0.1', '0内网IP', '2', '更新短信阶梯', '2021-11-22 12:39:50'), ('55', '产品管理', 'admin', '127.0.0.1', '0内网IP', '2', '更新短信阶梯', '2021-11-22 12:40:15'), ('56', '产品管理', 'admin', '127.0.0.1', '0内网IP', '2', '更新短信阶梯', '2021-11-22 14:55:56'), ('57', '品牌商管理', 'admin', '127.0.0.1', '0内网IP', '2', '增减品牌商的代发红包资金池', '2021-12-08 22:56:42'), ('58', '品牌商管理', 'admin', '127.0.0.1', '0内网IP', '2', '增减品牌商的代发红包资金池', '2021-12-08 23:13:36'), ('59', '品牌商管理', 'admin', '127.0.0.1', '0内网IP', '2', '增减品牌商的代发红包资金池', '2021-12-08 23:15:38'), ('60', '品牌商管理', 'admin', '127.0.0.1', '0内网IP', '2', '更新品牌商营业执照', '2022-01-13 16:20:50'), ('61', '品牌商管理', 'admin', '127.0.0.1', '0内网IP', '2', '更新品牌商营业执照', '2022-01-13 16:20:53'), ('62', '品牌商管理', 'admin', '127.0.0.1', '0内网IP', '2', '更新品牌商营业执照', '2022-01-13 16:21:48');
COMMIT;

-- ----------------------------
--  Table structure for `ctc_partner`
-- ----------------------------
DROP TABLE IF EXISTS `ctc_partner`;
CREATE TABLE `ctc_partner` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `company` varchar(255) DEFAULT NULL,
  `account` varchar(255) DEFAULT NULL,
  `level_id` int(11) DEFAULT NULL,
  `deposit` varchar(255) DEFAULT '0' COMMENT '预存款',
  `balance` varchar(255) DEFAULT '0' COMMENT '余额',
  `duration` varchar(255) DEFAULT NULL COMMENT '签约时间',
  `status` tinyint(4) DEFAULT '0' COMMENT '状态0正常 1 禁用',
  `is_auth` varchar(255) DEFAULT '0' COMMENT '0未认证 1已认证 2未通过 3更新中',
  `domain` varchar(255) DEFAULT NULL,
  `platform_name` varchar(255) DEFAULT NULL COMMENT '自定义平台名',
  `copy` varchar(255) DEFAULT NULL COMMENT '自定义版权',
  `logo` varchar(255) DEFAULT NULL,
  `phone` varchar(255) DEFAULT NULL,
  `contact_name` varchar(255) DEFAULT NULL,
  `password` varchar(255) DEFAULT NULL,
  `province` varchar(255) DEFAULT NULL,
  `city` varchar(255) DEFAULT NULL,
  `county` varchar(255) DEFAULT NULL,
  `address` varchar(255) DEFAULT NULL,
  `industry` tinyint(4) DEFAULT NULL,
  `telephone` varchar(255) DEFAULT NULL,
  `website` varchar(255) DEFAULT NULL,
  `login_logo` varchar(255) DEFAULT NULL,
  `ico` varchar(255) DEFAULT NULL,
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `create_by` varchar(255) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `app_domain` varchar(255) DEFAULT NULL,
  `street` varchar(255) DEFAULT NULL,
  `start_time` varchar(255) DEFAULT NULL,
  `end_time` varchar(255) DEFAULT NULL,
  `qualifications_name` varchar(255) DEFAULT NULL COMMENT '资质名称',
  `business_license` varchar(255) DEFAULT NULL COMMENT '营业执照号码',
  `organization_code` varchar(255) DEFAULT '' COMMENT '组织机构代码',
  `qualification_type` varchar(255) DEFAULT NULL COMMENT '资质类型',
  `registered_address` varchar(255) DEFAULT NULL COMMENT '注册地址',
  `representative` varchar(255) DEFAULT NULL COMMENT '法定代表人',
  `capital` varchar(255) DEFAULT '' COMMENT '注册资本',
  `establish_date` varchar(255) DEFAULT NULL COMMENT '成立日期',
  `max_date` datetime DEFAULT NULL COMMENT '营业期至',
  `business_license_url` varchar(255) DEFAULT NULL COMMENT '营业执照照片',
  `business_period` varchar(255) DEFAULT NULL COMMENT '营业期限',
  `is_del` tinyint(4) DEFAULT '0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4;

-- ----------------------------
--  Records of `ctc_partner`
-- ----------------------------
BEGIN;
INSERT INTO `ctc_partner` VALUES ('1', '石家庄成功有限公司', 'test1', '1', '5388', '19', '2021-10-06,2021-11-09', '0', '1', '5345', '53455', '345', '20211008/3ed305f7ab08841bc7ab5c9a13cde529.png', '543', '534', '25f9e794323b453885f5181f1b624d0b', '北京市', '市辖区', '东城区', null, '1', '534', '34', '20211008/b8d6ee6a497c2e9870e7161fbcf053c3.png', '20211008/9fd1751dc689b9343c9d2b2fb2ff6e16.ico', '2021-10-08 16:54:16', null, '543', '5345', '4355', '2021-10-06', '2021-11-09', null, '4324', '4234', '2', '42344', '2342', '432424', '2021-10-04', null, '20211010/b7f4f7e797ecd9b53cd56e244da7a9cb.png', '2021-10-04,2021-11-16', '0'), ('2', '石家庄成功有限公司', '312', '1', '11118', '13', '2021-10-14,2021-11-15', '0', '2', '321', '12', '312', '20211008/2d980aacc3999a7761c181e9969e2ad6.png', '3123', '312', '312', '北京市', '市辖区', '东城区', null, '1', '21', '3213', '20211008/e6c5fb0355d6de76b2f439d1d274cdac.png', '20211008/1988ffb9ecdf4830ad05d4f1ae045607.ico', '2021-10-08 20:28:55', null, '3123', '3213', '312', '2021-10-14', '2021-11-15', null, '4324', '4234', '2', '42344', '2342', '432424', '2021-10-04', null, '20211010/b7f4f7e797ecd9b53cd56e244da7a9cb.png', '2021-10-04,2021-11-16', '0'), ('3', 'sdsjkdhsa', 'test2', '1', '11110', '0', '2021-10-13,2021-11-11', '0', '0', '11', '11', '11', '20211027/f30c500f9ff366d8ec8d796bd6a721fe.JPG', '111', '11', 'e10adc3949ba59abbe56e057f20f883e', '北京市', '市辖区', '东城区', null, '1', '111', '111', '20211027/3dc99d2d8c8657f3e7277d1a05683e8d.JPG', '', '2021-10-27 15:12:48', null, '111', '1111', '11', '2021-10-13', '2021-11-11', null, null, '', null, null, null, '', null, null, null, null, '0'), ('4', 'test', 'test', '5', '111100', '500', '2021-10-20,2021-11-17', '0', '0', '2122', '212', '212', '20211031/f1463fb182080ee2e436611a412a0d2d.png', 'test', 'sdsd', 'e10adc3949ba59abbe56e057f20f883e', '天津市', '市辖区', '和平区', null, '2', '212', '212', '20211031/af14e9712596fcd25b208c9bd966f5bb.png', '20211115/1885efba26c2b2d680ab5cf569307845.ico', '2021-10-31 17:58:01', null, '2121', '121', '12', '2021-10-20', '2021-11-17', null, null, '', null, null, null, '', null, null, null, null, '0');
COMMIT;

-- ----------------------------
--  Table structure for `ctc_partner_cash_bill`
-- ----------------------------
DROP TABLE IF EXISTS `ctc_partner_cash_bill`;
CREATE TABLE `ctc_partner_cash_bill` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `partner_id` int(11) DEFAULT NULL,
  `card_num` varchar(255) DEFAULT NULL,
  `bank_info` varchar(255) DEFAULT NULL,
  `money` varchar(255) DEFAULT NULL COMMENT '提现金额',
  `received_money` varchar(255) DEFAULT NULL COMMENT '实际到账',
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime DEFAULT NULL,
  `status` tinyint(4) DEFAULT '0' COMMENT '提现状态 0待提现 1已打款 2已驳回',
  `cash_order` varchar(255) DEFAULT NULL COMMENT '提现订单号',
  `user_name` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8mb4;

-- ----------------------------
--  Records of `ctc_partner_cash_bill`
-- ----------------------------
BEGIN;
INSERT INTO `ctc_partner_cash_bill` VALUES ('1', '1', '212312', '1', '100', '80', '2021-10-11 22:10:13', null, '1', '111111', null), ('3', '1', '20', '1', '50', '49.8', '2021-10-27 05:10:34', null, '1', '202110271635282634', '2'), ('4', '1', '1', '1', '10', '9.96', '2021-10-27 10:51:03', null, '2', '202110271635303063', '1'), ('5', '1', '123', '1', '10', '9.96', '2021-10-27 16:18:36', null, '1', '202110271635322716', 'test'), ('6', '1', '3', '1', '1111', '1106.556', '2021-11-04 18:24:09', null, '1', '202111041636021449', '3'), ('7', '1', '1231', '1', '10', '9.96', '2021-11-04 18:45:24', null, '1', '202111041636022724', '123'), ('9', '1', '123', '1', '10', '9.96', '2021-11-07 00:40:14', null, '2', '202111071636216814', '11'), ('10', '1', '123', '2', '10', '9.96', '2021-11-08 17:39:32', null, '2', '202111081636364372', '111'), ('14', '1', '123', '1', '10', '9.96', '2021-11-08 18:26:47', null, '2', '202111081636367207', 'test'), ('15', '1', '123', '2', '100', '99.6', '2021-11-08 18:35:30', null, '1', '202111081636367730', 'test'), ('16', '1', '123', '1', '10', '9.96', '2021-11-08 18:36:49', null, '2', '202111081636367809', '123'), ('17', '1', '11', '1', '10', '9.96', '2021-11-09 15:00:01', null, '1', '202111091636441201', '11');
COMMIT;

-- ----------------------------
--  Table structure for `ctc_partner_increment_service`
-- ----------------------------
DROP TABLE IF EXISTS `ctc_partner_increment_service`;
CREATE TABLE `ctc_partner_increment_service` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `service_id` int(11) DEFAULT NULL,
  `partner_id` int(11) DEFAULT NULL,
  `cost_price` varchar(255) DEFAULT NULL,
  `retail_price` varchar(255) DEFAULT NULL,
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4;

-- ----------------------------
--  Records of `ctc_partner_increment_service`
-- ----------------------------
BEGIN;
INSERT INTO `ctc_partner_increment_service` VALUES ('1', '1', '1', '100', '120', '2021-10-25 20:57:21'), ('2', '2', '1', '200', '304', '2021-10-25 20:57:21'), ('3', '3', '1', '300', '400', '2021-10-25 20:57:21'), ('4', '4', '1', '400', '500', '2021-10-25 20:57:21');
COMMIT;

-- ----------------------------
--  Table structure for `ctc_partner_level`
-- ----------------------------
DROP TABLE IF EXISTS `ctc_partner_level`;
CREATE TABLE `ctc_partner_level` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `level` tinyint(4) DEFAULT NULL COMMENT '合伙人级别',
  `level_name` varchar(255) DEFAULT NULL,
  `account_discount` tinyint(4) DEFAULT NULL COMMENT '开户折扣',
  `renewal_discount` tinyint(4) DEFAULT NULL COMMENT '续费折扣',
  `is_custom_name` varchar(255) DEFAULT '0' COMMENT '是否允许自定义平台名称',
  `is_custom_logo` varchar(255) DEFAULT '0',
  `is_custom_price` varchar(255) DEFAULT '0',
  `is_custom_codeSys` varchar(255) DEFAULT '0' COMMENT '(合伙人可自行生码)',
  `is_custom_register` varchar(255) DEFAULT '0' COMMENT '自定义品牌商注册页',
  `is_custom_login` varchar(255) DEFAULT '0' COMMENT '自定义登录模板',
  `is_custom_customer_price` varchar(255) DEFAULT '0' COMMENT '单客户定价',
  `is_custom_copy` varchar(255) DEFAULT '0' COMMENT '自定义版权',
  `is_custom_domain` varchar(255) DEFAULT '0' COMMENT '自定义域名',
  `free_support` tinyint(4) DEFAULT '0' COMMENT '免费上门支持',
  `fiee_training` tinyint(4) DEFAULT '0' COMMENT '免费上门培训',
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `create_by` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4;

-- ----------------------------
--  Records of `ctc_partner_level`
-- ----------------------------
BEGIN;
INSERT INTO `ctc_partner_level` VALUES ('1', '1', '金牌合伙人', '8', '8', '1', '1', '1', '1', '1', '0', '1', '0', '1', '2', '2', '2021-10-08 00:03:17', null), ('4', '2', '银牌合伙人', '7', '7', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '2021-10-08 01:33:46', null), ('5', '3', '铜牌合伙人', '6', '5', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '2', '2021-10-12 01:32:57', 'admin');
COMMIT;

-- ----------------------------
--  Table structure for `ctc_partner_menu`
-- ----------------------------
DROP TABLE IF EXISTS `ctc_partner_menu`;
CREATE TABLE `ctc_partner_menu` (
  `menuId` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `menuName` varchar(255) DEFAULT NULL,
  `menuType` varchar(255) DEFAULT NULL COMMENT '菜单类型 M目录 C菜单 F按钮',
  `orderNum` int(11) DEFAULT NULL,
  `parentId` int(11) DEFAULT '0',
  `parentName` varchar(255) DEFAULT NULL,
  `path` varchar(255) DEFAULT NULL,
  `component` varchar(255) DEFAULT NULL,
  `icon` varchar(255) DEFAULT NULL,
  `isFrame` varchar(255) DEFAULT '1' COMMENT '是否外链 0是 1否',
  `status` tinyint(4) DEFAULT '0',
  `visible` tinyint(4) DEFAULT '0' COMMENT '是否可见 0可见 1隐藏',
  `perms` varchar(255) DEFAULT NULL COMMENT '权限字符',
  `query` varchar(255) DEFAULT NULL COMMENT '路由参数',
  `isCache` tinyint(4) DEFAULT '0' COMMENT '是否开启缓存 0开启 1关闭',
  `createBy` varchar(255) DEFAULT NULL,
  `createTime` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`menuId`)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4;

-- ----------------------------
--  Records of `ctc_partner_menu`
-- ----------------------------
BEGIN;
INSERT INTO `ctc_partner_menu` VALUES ('1', '需求管理', 'M', '6', '0', null, 'demand', null, 'form', '1', '0', '0', null, null, '0', null, '2021-10-21 23:37:35'), ('2', '需求列表', 'C', '0', '1', null, 'demandList', 'demand/index', null, '1', '0', '0', null, null, '0', null, '2021-10-21 23:38:50'), ('3', '产品管理', 'M', '4', '0', null, 'product', null, 'product', '1', '0', '0', null, null, '0', null, '2021-10-24 00:55:53'), ('4', '产品定价设置', 'C', '0', '3', null, 'productPrice', 'product/index', null, '1', '0', '0', null, null, '0', null, '2021-10-24 00:56:34'), ('5', '品牌商管理', 'M', '2', '0', null, 'dealer', null, 'dealer', '1', '0', '0', null, null, '0', null, '2021-10-24 19:19:29'), ('6', '品牌商列表', 'C', '0', '5', null, 'dealerList', 'dealer/index', null, '1', '0', '0', null, null, '0', null, '2021-10-24 19:20:25'), ('7', '增值服务', 'M', '3', '0', null, 'increment', null, 'increment', '1', '0', '0', null, null, '0', null, '2021-10-25 18:55:27'), ('8', '增值服务定价', 'C', '0', '7', null, 'incrementPrice', 'increment/price', null, '1', '0', '0', null, null, '0', null, '2021-10-25 18:56:25'), ('9', '增值订单管理', 'C', '0', '7', null, 'incrementOrder', 'increment/order', null, '1', '0', '0', null, null, '0', null, '2021-10-26 01:44:14'), ('10', '财务管理', 'M', '5', '0', null, 'finance', null, 'dashboard', '1', '0', '0', null, null, '0', null, '2021-10-27 03:02:45'), ('11', '收支明细', 'C', '0', '10', null, 'bill', 'finance/bill', null, '1', '0', '0', null, null, '0', null, '2021-10-27 03:05:35'), ('12', '余额提现', 'C', '0', '10', null, 'cash', 'finance/cash', null, '1', '0', '0', null, null, '0', null, '2021-10-27 03:06:04'), ('13', '码库管理', 'M', '0', '0', null, 'codeStore', null, 'code', '1', '0', '0', null, null, '0', null, '2021-10-27 05:40:26'), ('14', '生码管理', 'C', '0', '13', null, 'code', 'code/index', null, '1', '0', '0', null, null, '0', null, '2021-10-27 05:41:45');
COMMIT;

-- ----------------------------
--  Table structure for `ctc_partner_product_code`
-- ----------------------------
DROP TABLE IF EXISTS `ctc_partner_product_code`;
CREATE TABLE `ctc_partner_product_code` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `partner_id` int(11) DEFAULT NULL,
  `code_order_begin` varchar(255) DEFAULT NULL,
  `code_order_end` varchar(255) DEFAULT NULL,
  `code_retail` varchar(255) DEFAULT NULL,
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `create_by` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4;

-- ----------------------------
--  Records of `ctc_partner_product_code`
-- ----------------------------
BEGIN;
INSERT INTO `ctc_partner_product_code` VALUES ('1', '1', '1', '2', '16', '2021-10-24 17:16:15', null), ('2', '1', '3', '4', '338', '2021-10-24 18:09:04', null);
COMMIT;

-- ----------------------------
--  Table structure for `ctc_partner_product_module`
-- ----------------------------
DROP TABLE IF EXISTS `ctc_partner_product_module`;
CREATE TABLE `ctc_partner_product_module` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `module_id` int(11) DEFAULT NULL,
  `partner_id` int(11) DEFAULT NULL,
  `cost_price` varchar(255) DEFAULT NULL,
  `retail_price` varchar(255) DEFAULT NULL,
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4;

-- ----------------------------
--  Records of `ctc_partner_product_module`
-- ----------------------------
BEGIN;
INSERT INTO `ctc_partner_product_module` VALUES ('1', '8', '1', null, '130', '2021-10-24 15:31:32'), ('2', '11', '1', null, '5366', '2021-10-24 16:17:07'), ('4', '2', '1', null, '537', '2021-10-25 11:12:55'), ('5', '10', '1', null, '998', '2021-10-25 11:13:09'), ('6', '26', '1', null, '100', '2021-10-25 12:49:29'), ('7', '12', '1', null, '300', '2021-10-25 16:26:44'), ('8', '5', '3', null, '200', '2021-10-27 15:26:34');
COMMIT;

-- ----------------------------
--  Table structure for `ctc_partner_product_service`
-- ----------------------------
DROP TABLE IF EXISTS `ctc_partner_product_service`;
CREATE TABLE `ctc_partner_product_service` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `service_name` varchar(255) DEFAULT NULL,
  `service_cost` varchar(255) DEFAULT NULL,
  `service_des` text,
  `partner_id` int(11) DEFAULT NULL,
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4;

-- ----------------------------
--  Records of `ctc_partner_product_service`
-- ----------------------------
BEGIN;
INSERT INTO `ctc_partner_product_service` VALUES ('1', '23', '32', '1、323\n2、是多少副科级克里斯多夫几点睡', '1', '2021-10-24 19:06:18'), ('2', '12', '212', '212', '1', '2021-10-24 19:06:18'), ('3', '1', '11', '1', '4', '2021-10-31 18:01:08'), ('4', '3242', '500', '4343', '1', '2021-11-05 15:10:40');
COMMIT;

-- ----------------------------
--  Table structure for `ctc_partner_recharge_record`
-- ----------------------------
DROP TABLE IF EXISTS `ctc_partner_recharge_record`;
CREATE TABLE `ctc_partner_recharge_record` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `recharge_type` varbinary(255) DEFAULT NULL COMMENT '1余额充值 2预存款充值',
  `money` varchar(255) DEFAULT NULL,
  `balance` varchar(255) DEFAULT NULL,
  `remark` varchar(255) DEFAULT NULL,
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `create_by` varchar(255) DEFAULT NULL,
  `partner_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8mb4;

-- ----------------------------
--  Records of `ctc_partner_recharge_record`
-- ----------------------------
BEGIN;
INSERT INTO `ctc_partner_recharge_record` VALUES ('1', 0x31, '1', '2', '哈哈', '2021-10-11 06:10:04', null, '1'), ('2', 0x31, '7', '9', '客家话', '2021-10-11 06:10:51', null, '1'), ('3', 0x31, '8', '8', '88', '2021-10-11 06:11:00', null, '2'), ('4', 0x31, '1', '1', '1', '2021-10-11 06:12:01', null, '1'), ('5', 0x31, '3', '4', '3', '2021-10-11 06:12:42', null, '1'), ('6', 0x31, '3', '7', '3', '2021-10-11 06:58:33', null, '1'), ('7', 0x32, '99', '106', 'jj', '2021-10-11 19:46:48', null, '1'), ('8', 0x31, '1', '1', '1', '2021-10-12 01:40:24', null, '2'), ('9', 0x31, '12', '13', '1', '2021-10-26 11:38:51', null, '2'), ('10', 0x31, '10', '900', '999', '2021-11-05 16:33:15', null, '1'), ('11', 0x31, '10', '910', '100', '2021-11-05 18:37:01', null, '1'), ('12', 0x32, '200', '1120', 'test', '2021-11-05 18:39:43', null, '1'), ('13', 0x31, '10', '920', '账户余额充值', '2021-11-05 19:31:31', null, '1'), ('14', 0x32, '100', '100', '预存款aaa', '2021-11-05 19:34:24', null, '4'), ('15', 0x32, '1000', '1024', '测试用', '2021-11-08 16:55:34', null, '1'), ('16', 0x31, '20', '500', '11', '2021-11-08 18:16:50', null, '1'), ('17', 0x31, '100', '500', '日志测试', '2021-11-08 23:10:41', null, '1'), ('18', 0x32, '20', '796', '再次测试', '2021-11-08 23:28:23', 'admin', '1');
COMMIT;

-- ----------------------------
--  Table structure for `ctc_partner_token`
-- ----------------------------
DROP TABLE IF EXISTS `ctc_partner_token`;
CREATE TABLE `ctc_partner_token` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `uid` int(11) DEFAULT NULL,
  `token` varchar(255) DEFAULT NULL,
  `login_ip` varchar(32) DEFAULT NULL,
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP,
  `expires_time` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=84 DEFAULT CHARSET=utf8mb4;

-- ----------------------------
--  Records of `ctc_partner_token`
-- ----------------------------
BEGIN;
INSERT INTO `ctc_partner_token` VALUES ('74', '1', 'eea6b9b390fe396607e4269637c00f33b2b59262', '127.0.0.1', '2022-03-20 00:00:21', '2022-03-20 12:00:21'), ('75', '1', '59ccb3b1c6929bc04eb0927e0eb5b8a1158edcbf', '127.0.0.1', '2022-03-20 13:47:20', '2022-03-21 01:47:20'), ('76', '1', '45262df26e37938c0ceec8929de197efedbb368c', '127.0.0.1', '2022-03-21 10:55:19', '2022-03-21 22:55:19'), ('77', '1', 'f7e6b54771079c36d383dbb3e01f7c8c376304fe', '127.0.0.1', '2022-03-22 09:54:11', '2022-03-22 21:54:11'), ('78', '1', '7bb9983daf8b74ae7aa59ca75a80211380c1e7ef', '127.0.0.1', '2022-03-23 21:06:27', '2022-03-24 09:06:27'), ('79', '1', '7972fcb78cc9e0d8a8a40de917fc60dece18ee17', '127.0.0.1', '2022-03-24 18:10:02', '2022-03-25 06:10:02'), ('80', '1', 'aeaee6111d79f8d02feaba26121aee6c06e203e4', '127.0.0.1', '2022-03-27 21:01:37', '2022-03-28 09:01:37'), ('81', '1', '89c07f62fd72c2abf7c38dd66da54165e1a3c2f6', '127.0.0.1', '2022-03-30 17:35:57', '2022-03-31 05:35:57'), ('82', '1', '9f92a1e425c7c0237602e04b8ce99be5d0039b65', '127.0.0.1', '2022-03-31 19:41:21', '2022-04-01 07:41:21'), ('83', '1', 'da17c29e0dd280bd74f70581c48fa13ac9e1d121', '127.0.0.1', '2022-04-03 11:08:52', '2022-04-03 23:08:52');
COMMIT;

-- ----------------------------
--  Table structure for `ctc_product_code`
-- ----------------------------
DROP TABLE IF EXISTS `ctc_product_code`;
CREATE TABLE `ctc_product_code` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `code_order_begin` varchar(255) DEFAULT NULL,
  `code_order_end` varchar(255) DEFAULT NULL,
  `code_cost` varchar(255) DEFAULT NULL,
  `code_retail` varchar(255) DEFAULT NULL,
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `create_by` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4;

-- ----------------------------
--  Records of `ctc_product_code`
-- ----------------------------
BEGIN;
INSERT INTO `ctc_product_code` VALUES ('1', '1', '8', '3', '342', '2021-10-09 01:10:19', null), ('2', '9', '100', '1', '2', '2021-10-24 17:18:49', null);
COMMIT;

-- ----------------------------
--  Table structure for `ctc_product_module`
-- ----------------------------
DROP TABLE IF EXISTS `ctc_product_module`;
CREATE TABLE `ctc_product_module` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `module_name` varchar(255) DEFAULT NULL,
  `module_cost` varchar(255) DEFAULT NULL,
  `module_retail` varchar(255) DEFAULT NULL,
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `create_by` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=28 DEFAULT CHARSET=utf8mb4;

-- ----------------------------
--  Records of `ctc_product_module`
-- ----------------------------
BEGIN;
INSERT INTO `ctc_product_module` VALUES ('2', 's0', '5', '536', '2021-10-09 00:31:11', null), ('3', '测试模块', '1', '2', '2021-10-23 16:34:50', null), ('4', '系统模块', '10', '10', '2021-10-24 14:38:08', null), ('5', '码库', '105', '100', '2021-10-24 14:38:28', null), ('6', '订单管理', '101', '98', '2021-10-24 14:38:43', null), ('7', '客户', '100', '100', '2021-10-24 14:38:54', null), ('8', '二维码营销', '111', '100', '2021-10-24 14:39:11', null), ('9', '公众号', '2', '2', '2021-10-24 14:39:21', null), ('10', '资产', '100', '99', '2021-10-24 14:39:33', null), ('11', '万能溯源', '100', '160', '2021-10-24 14:39:47', null), ('12', '微商城', '100', '200', '2021-10-24 14:40:07', null), ('13', '积分商城', '100', '190', '2021-10-24 14:40:23', null), ('14', '多语言', '100', '150', '2021-10-24 14:40:49', null), ('15', '智慧门店', '100', '190', '2021-10-24 14:41:08', null), ('16', '万能溯源(舒适版)', '100', '100', '2021-10-24 14:41:24', null), ('17', '智能物流', '9800', '6800', '2021-10-24 14:41:41', null), ('18', '超级导购', '100', '100', '2021-10-24 14:41:52', null), ('19', '玲珑OA', '100', '100', '2021-10-24 14:42:03', null), ('20', '在线订单', '0', '0', '2021-10-24 14:42:11', null), ('21', '营销分控', '100', '109', '2021-10-24 14:42:22', null), ('22', '经营报表', '0', '0', '2021-10-24 14:42:34', null), ('23', '视频分享', '0', '0', '2021-10-24 14:42:43', null), ('24', '虚拟红包', '0', '0', '2021-10-24 14:42:54', null), ('25', '小程序扫码管理', '500', '500', '2021-10-24 14:43:07', null), ('26', '小程序商城模板', '0', '0', '2021-10-24 14:43:16', null), ('27', 'test', '10', '30', '2021-10-27 15:18:37', null);
COMMIT;

-- ----------------------------
--  Table structure for `ctc_qrcode_blacklist`
-- ----------------------------
DROP TABLE IF EXISTS `ctc_qrcode_blacklist`;
CREATE TABLE `ctc_qrcode_blacklist` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `type` tinyint(4) DEFAULT NULL COMMENT '拉黑类型 1id 2手机号 3openid',
  `keywords` varchar(255) DEFAULT NULL,
  `reason` varchar(255) DEFAULT NULL COMMENT '拉黑原因',
  `validity` tinyint(4) DEFAULT NULL COMMENT '拉黑有效期 1限时拉黑 2永久拉黑',
  `duration` varchar(255) DEFAULT NULL COMMENT '拉黑时长',
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `dealer_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4;

-- ----------------------------
--  Records of `ctc_qrcode_blacklist`
-- ----------------------------
BEGIN;
INSERT INTO `ctc_qrcode_blacklist` VALUES ('4', '1', 'i', '欧辰', '1', 'o\'i', '2021-12-23 23:02:56', '23'), ('7', '2', '7', '已', '2', '', '2021-12-29 18:07:56', '23');
COMMIT;

-- ----------------------------
--  Table structure for `ctc_qrcode_blacklist_set`
-- ----------------------------
DROP TABLE IF EXISTS `ctc_qrcode_blacklist_set`;
CREATE TABLE `ctc_qrcode_blacklist_set` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `auto_join` tinyint(4) DEFAULT '0' COMMENT '自动加入黑名单 0开启 1禁用',
  `daily_scan_times` int(11) DEFAULT '0' COMMENT '每日首次扫码次数',
  `block_duration` varchar(255) DEFAULT '0' COMMENT '单日扫码次数 拉黑时长',
  `daily_scan_tips` varchar(255) DEFAULT NULL COMMENT '单日扫码 拉黑提示',
  `unit` tinyint(255) DEFAULT '1' COMMENT '1日 2周 3月 拉黑单位',
  `block_times` int(11) DEFAULT NULL COMMENT '拉黑次数（超出永久拉黑）',
  `permanent` tinyint(4) DEFAULT NULL COMMENT '是否开启永久拉黑 0否 1是',
  `permanent_scan_tips` varchar(255) DEFAULT NULL COMMENT '永久拉黑 扫码提示',
  `manual_scan_tips` varchar(255) DEFAULT NULL COMMENT '手动拉黑扫码提示',
  `dealer_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4;

-- ----------------------------
--  Records of `ctc_qrcode_blacklist_set`
-- ----------------------------
BEGIN;
INSERT INTO `ctc_qrcode_blacklist_set` VALUES ('1', '0', '5', '5', '55', '2', '5', '0', '55', '56', '23');
COMMIT;

-- ----------------------------
--  Table structure for `ctc_redpool_issue_record`
-- ----------------------------
DROP TABLE IF EXISTS `ctc_redpool_issue_record`;
CREATE TABLE `ctc_redpool_issue_record` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `dealer_id` int(11) DEFAULT NULL,
  `money` varchar(255) DEFAULT NULL,
  `balance` varchar(255) DEFAULT NULL,
  `openid` varchar(255) DEFAULT NULL COMMENT '领取的人员',
  `scene` varchar(255) DEFAULT NULL COMMENT '发放场景',
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `redpack_id` int(11) DEFAULT NULL,
  `app_id` int(11) DEFAULT NULL,
  `activity_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4;

-- ----------------------------
--  Records of `ctc_redpool_issue_record`
-- ----------------------------
BEGIN;
INSERT INTO `ctc_redpool_issue_record` VALUES ('1', '1', '1', '1', 'sdasdjalksdaksdaksjdla', '1', '2021-10-10 17:25:46', null, null, null), ('2', '23', '1', '2', '541451', '2', '2021-12-09 00:43:19', '2', '2', '2');
COMMIT;

-- ----------------------------
--  Table structure for `ctc_redpool_recharge_record`
-- ----------------------------
DROP TABLE IF EXISTS `ctc_redpool_recharge_record`;
CREATE TABLE `ctc_redpool_recharge_record` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `money` varchar(255) DEFAULT NULL COMMENT '充值金额',
  `balance` varchar(255) DEFAULT NULL COMMENT '余额',
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `create_by` varchar(255) DEFAULT NULL,
  `dealer_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4;

-- ----------------------------
--  Records of `ctc_redpool_recharge_record`
-- ----------------------------
BEGIN;
INSERT INTO `ctc_redpool_recharge_record` VALUES ('1', '1', '1', '2021-10-10 16:49:00', '1', '1'), ('2', '100', '100', '2021-11-05 18:31:31', null, '5'), ('3', '100', '100', '2021-11-08 18:50:32', null, '22'), ('4', '200', '300', '2021-11-08 23:36:16', null, '22'), ('5', '100', '100', '2021-12-08 22:56:42', null, '23'), ('6', '2', '102', '2021-12-08 23:13:36', null, '23'), ('7', '1', '103', '2021-12-08 23:15:38', null, '23');
COMMIT;

-- ----------------------------
--  Table structure for `ctc_role`
-- ----------------------------
DROP TABLE IF EXISTS `ctc_role`;
CREATE TABLE `ctc_role` (
  `roleId` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `roleName` varchar(255) DEFAULT NULL,
  `roleKey` varchar(255) DEFAULT NULL COMMENT '标识字符',
  `roleSort` varchar(255) DEFAULT NULL,
  `admin` varchar(255) DEFAULT '0' COMMENT '是否管理员角色',
  `remark` varchar(255) DEFAULT NULL,
  `status` varchar(4) DEFAULT '0',
  `createTime` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `createBy` varchar(255) DEFAULT NULL,
  `checkedKeys` varchar(255) DEFAULT NULL,
  `menuIds` varchar(255) DEFAULT NULL,
  `menuCheckStrictly` varchar(255) DEFAULT '0',
  `deptCheckStrictly` varchar(255) DEFAULT '0',
  PRIMARY KEY (`roleId`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4;

-- ----------------------------
--  Records of `ctc_role`
-- ----------------------------
BEGIN;
INSERT INTO `ctc_role` VALUES ('1', 'admin', 'admin', '1', '1', '超级管理员', '0', '2021-10-06 22:52:35', null, null, '6,8,37,38,9,39,40,10,11,41,42,43,44,45,46,47,48,49,12,50,51,52,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,29,30,31,32,33,34,35,36,53,54,55', '1', '1'), ('3', '普通角色', 'common', '1', '0', '普通角色', '0', '2021-10-06 22:54:09', null, null, '6,8', '1', '1');
COMMIT;

-- ----------------------------
--  Table structure for `ctc_role_copy`
-- ----------------------------
DROP TABLE IF EXISTS `ctc_role_copy`;
CREATE TABLE `ctc_role_copy` (
  `roleId` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `roleName` varchar(255) DEFAULT NULL,
  `roleKey` varchar(255) DEFAULT NULL COMMENT '标识字符',
  `roleSort` varchar(255) DEFAULT NULL,
  `admin` varchar(255) DEFAULT '0' COMMENT '是否管理员角色',
  `remark` varchar(255) DEFAULT NULL,
  `status` varchar(4) DEFAULT '0',
  `createTime` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `createBy` varchar(255) DEFAULT NULL,
  `checkedKeys` varchar(255) DEFAULT NULL,
  `menuIds` varchar(255) DEFAULT NULL,
  `menuCheckStrictly` varchar(255) DEFAULT '0',
  `deptCheckStrictly` varchar(255) DEFAULT '0',
  PRIMARY KEY (`roleId`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4;

-- ----------------------------
--  Records of `ctc_role_copy`
-- ----------------------------
BEGIN;
INSERT INTO `ctc_role_copy` VALUES ('1', 'admin', 'admin', '1', '1', '超级管理员', '0', '2021-10-06 22:52:35', null, null, '6,8,37,38,9,39,40,10,11,41,42,43,44,45,46,47,48,49,12,50,51,52,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,29,30,31,32,33,34,35,36,53,54,55', '1', '1'), ('3', '普通角色', 'common', '1', '0', '普通角色', '0', '2021-10-06 22:54:09', null, null, '6,8', '1', '1');
COMMIT;

-- ----------------------------
--  Table structure for `ctc_security_auth`
-- ----------------------------
DROP TABLE IF EXISTS `ctc_security_auth`;
CREATE TABLE `ctc_security_auth` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `dealer_id` int(11) DEFAULT NULL,
  `security_template` int(11) DEFAULT NULL,
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime DEFAULT NULL,
  `create_by` varchar(255) DEFAULT NULL,
  `status` tinyint(4) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4;

-- ----------------------------
--  Records of `ctc_security_auth`
-- ----------------------------
BEGIN;
INSERT INTO `ctc_security_auth` VALUES ('1', '1', '1', '2021-10-10 23:56:53', null, null, '0');
COMMIT;

-- ----------------------------
--  Table structure for `ctc_security_template`
-- ----------------------------
DROP TABLE IF EXISTS `ctc_security_template`;
CREATE TABLE `ctc_security_template` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `template_name` varchar(255) DEFAULT NULL,
  `query_tips` varchar(255) DEFAULT NULL,
  `scene` varbinary(4) DEFAULT NULL,
  `query_tips_again` varchar(255) DEFAULT NULL,
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `create_by` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4;

-- ----------------------------
--  Records of `ctc_security_template`
-- ----------------------------
BEGIN;
INSERT INTO `ctc_security_template` VALUES ('1', '默认模版', '您好，您所查询的是@品牌商名称@生产的产品，请放心使用！', 0x31, '该防伪码已经被人查询过，首次查询时间：@查询时间@，谨防假冒!', '2021-10-10 23:57:37', null);
COMMIT;

-- ----------------------------
--  Table structure for `ctc_sms`
-- ----------------------------
DROP TABLE IF EXISTS `ctc_sms`;
CREATE TABLE `ctc_sms` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `sms_count` int(11) DEFAULT NULL,
  `sms_cost` varchar(255) DEFAULT NULL COMMENT '成本价',
  `sms_retail` varchar(255) DEFAULT NULL COMMENT '零售价',
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `create_by` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4;

-- ----------------------------
--  Records of `ctc_sms`
-- ----------------------------
BEGIN;
INSERT INTO `ctc_sms` VALUES ('1', '10', '0.5', '0.02', '2021-10-08 22:48:49', null), ('3', '432', '0.4', '0.8', '2021-10-08 22:57:45', null);
COMMIT;

-- ----------------------------
--  Table structure for `ctc_sms_order`
-- ----------------------------
DROP TABLE IF EXISTS `ctc_sms_order`;
CREATE TABLE `ctc_sms_order` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `dealer_id` int(11) DEFAULT NULL,
  `order` varchar(255) DEFAULT NULL,
  `money` varchar(255) DEFAULT NULL,
  `num` varchar(255) DEFAULT NULL,
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `create_by` varchar(255) DEFAULT NULL,
  `status` tinyint(4) DEFAULT '0' COMMENT '0未支付 1已支付 2支付失败',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=25 DEFAULT CHARSET=utf8mb4;

-- ----------------------------
--  Records of `ctc_sms_order`
-- ----------------------------
BEGIN;
INSERT INTO `ctc_sms_order` VALUES ('1', '23', '2021112252541004', '40', '20', '2021-11-22 14:41:57', 'wenhan', '0'), ('2', '23', '2021112251995248', '20', '10', '2021-11-22 14:56:04', 'wenhan', '1'), ('3', '23', '2021112299514957', '20', '10', '2021-11-22 14:59:56', 'wenhan', '0'), ('4', '23', '2021112255545048', '20', '10', '2021-11-22 15:39:52', 'wenhan', '0'), ('5', '23', '2021112251101100', '20', '10', '2021-11-22 15:40:52', 'wenhan', '0'), ('6', '23', '2021112298565499', '20', '10', '2021-11-22 15:42:36', 'wenhan', '0'), ('7', '23', '2021112297575310', '34560', '432', '2021-11-22 15:46:51', 'wenhan', '0'), ('8', '23', '2021112210056994', '20', '10', '2021-11-22 15:48:46', 'wenhan', '0'), ('9', '23', '2021112297975310', '0.20', '10', '2021-11-22 15:50:35', 'wenhan', '0'), ('10', '23', '2021112255504849', '0.20', '10', '2021-11-22 15:53:11', 'wenhan', '1'), ('11', '23', '2021112257535010', '345.60', '432', '2021-11-22 16:10:34', 'wenhan', '0'), ('12', '23', '2021112210253975', '0.20', '10', '2021-11-22 16:10:40', 'wenhan', '0'), ('13', '23', '2021112210151519', '345.60', '432', '2021-11-22 16:11:26', 'wenhan', '0'), ('14', '23', '2021112210210248', '0.20', '10', '2021-11-22 16:11:28', 'wenhan', '0'), ('15', '23', '2021112250489952', '345.60', '432', '2021-11-22 16:11:30', 'wenhan', '0'), ('16', '23', '2021112252515054', '0.20', '10', '2021-11-22 16:11:49', 'wenhan', '0'), ('17', '23', '2021112255100519', '0.20', '10', '2021-11-22 16:13:28', 'wenhan', '0'), ('18', '23', '2021112248499953', '0.20', '10', '2021-11-22 16:15:44', 'wenhan', '0'), ('19', '23', '2021112253535452', '345.60', '432', '2021-11-22 16:45:10', 'wenhan', '0'), ('20', '23', '2021112255519910', '345.60', '432', '2021-11-22 17:24:08', 'wenhan', '0'), ('21', '23', '2021112251985356', '0.20', '10', '2021-11-22 17:24:20', 'wenhan', '0'), ('22', '23', '2021112253101499', '345.60', '432', '2021-11-22 18:08:06', 'wenhan', '0'), ('23', '23', '2021120957505749', '0.20', '10', '2021-12-09 01:14:34', 'wenhan', '0'), ('24', '23', '2022031548541015', '0.20', '10', '2022-03-15 21:17:53', 'wenhan', '0');
COMMIT;

-- ----------------------------
--  Table structure for `ctc_user`
-- ----------------------------
DROP TABLE IF EXISTS `ctc_user`;
CREATE TABLE `ctc_user` (
  `uid` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `account` varchar(255) CHARACTER SET utf8 DEFAULT NULL,
  `password` varchar(255) CHARACTER SET utf8 DEFAULT NULL,
  `username` varchar(255) DEFAULT NULL,
  `phone` varchar(255) DEFAULT NULL,
  `address` varchar(255) DEFAULT NULL,
  `remark` varchar(255) DEFAULT NULL,
  `roleIds` varchar(255) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `status` varchar(4) DEFAULT '0',
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `sex` varchar(255) DEFAULT '0',
  PRIMARY KEY (`uid`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4;

-- ----------------------------
--  Records of `ctc_user`
-- ----------------------------
BEGIN;
INSERT INTO `ctc_user` VALUES ('1', 'admin', 'e10adc3949ba59abbe56e057f20f883e', 'admin', '18330118047', '石家庄', '测试', '1', null, '0', '2021-10-05 16:27:32', '0'), ('2', 'admin123', 'e10adc3949ba59abbe56e057f20f883e', '普通用户', '18330118044', '高老庄', '测试用户', '3,7', '11@qq.com', '0', '2021-10-07 01:36:32', '1'), ('5', 'weywiquuiwrw', 'e10adc3949ba59abbe56e057f20f883e', '32423', '18330118057', 'rewr', 'rewr', '3', '32@qq.com', '0', '2021-11-13 23:17:04', '0'), ('6', 'admin', 'e10adc3949ba59abbe56e057f20f883e', 'admin', '18330118047', '石家庄', '测试', '1', null, '0', '2021-10-05 16:27:32', '0');
COMMIT;

-- ----------------------------
--  Table structure for `ctc_user_token`
-- ----------------------------
DROP TABLE IF EXISTS `ctc_user_token`;
CREATE TABLE `ctc_user_token` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `uid` int(11) DEFAULT NULL,
  `token` varchar(255) DEFAULT NULL,
  `login_ip` varchar(32) DEFAULT NULL,
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP,
  `expires_time` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=202 DEFAULT CHARSET=utf8mb4;

-- ----------------------------
--  Records of `ctc_user_token`
-- ----------------------------
BEGIN;
INSERT INTO `ctc_user_token` VALUES ('201', '1', '01fc251794262fe4c0d05fb6b3ec70767b0aa120', '127.0.0.1', '2022-04-03 12:24:15', '2022-04-04 00:24:15');
COMMIT;

-- ----------------------------
--  Table structure for `ctc_wxopen_authorization_info`
-- ----------------------------
DROP TABLE IF EXISTS `ctc_wxopen_authorization_info`;
CREATE TABLE `ctc_wxopen_authorization_info` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `dealer_id` int(11) DEFAULT NULL,
  `authorizer_appid` varchar(255) DEFAULT NULL COMMENT '授权方appid',
  `authorizer_access_token` varchar(255) DEFAULT NULL COMMENT '接口调用令牌（在授权的公众号/小程序具备 API 权限时，才有此返回值）',
  `expires_time` timestamp NULL DEFAULT NULL COMMENT '过期时间',
  `authorizer_refresh_token` varchar(255) DEFAULT NULL,
  `func_info` text,
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4;

-- ----------------------------
--  Records of `ctc_wxopen_authorization_info`
-- ----------------------------
BEGIN;
INSERT INTO `ctc_wxopen_authorization_info` VALUES ('1', '23', 'wx22eda562f7b8e247', '54_Mb1j6wTu5dWNWuGMPZ2ZSv1xjcYl4ssF7wiMK3MMq9lynzgmKf9N--ME5TZiUcZqAjNXd82ZeMmJlm3j1Uaaq65c3ssLQkHgv5Dm8fhep1ia8bYpVQ4cG6Zh6zQt5-1dh-YOwrE9FHw0okZKLQIdALDTYQ', '2022-03-15 22:00:31', 'refreshtoken@@@U98LwuLtwOyk6dcrLed7MFVWUr7Cy8cnrzD61GTmGXY', '[{\"funcscope_category\":{\"id\":1},\"confirm_info\":{\"need_confirm\":1,\"already_confirm\":0,\"can_confirm\":1}},{\"funcscope_category\":{\"id\":2},\"confirm_info\":{\"need_confirm\":1,\"already_confirm\":0,\"can_confirm\":1}},{\"funcscope_category\":{\"id\":3},\"confirm_info\":{\"need_confirm\":0,\"already_confirm\":0,\"can_confirm\":0}},{\"funcscope_category\":{\"id\":4}},{\"funcscope_category\":{\"id\":5}},{\"funcscope_category\":{\"id\":6}},{\"funcscope_category\":{\"id\":7}},{\"funcscope_category\":{\"id\":8},\"confirm_info\":{\"need_confirm\":1,\"already_confirm\":0,\"can_confirm\":0}},{\"funcscope_category\":{\"id\":9}},{\"funcscope_category\":{\"id\":10}},{\"funcscope_category\":{\"id\":11},\"confirm_info\":{\"need_confirm\":1,\"already_confirm\":0,\"can_confirm\":1}},{\"funcscope_category\":{\"id\":12}},{\"funcscope_category\":{\"id\":13}},{\"funcscope_category\":{\"id\":15}},{\"funcscope_category\":{\"id\":22}},{\"funcscope_category\":{\"id\":23},\"confirm_info\":{\"need_confirm\":0,\"already_confirm\":0,\"can_confirm\":0}},{\"funcscope_category\":{\"id\":24},\"confirm_info\":{\"need_confirm\":0,\"already_confirm\":0,\"can_confirm\":0}},{\"funcscope_category\":{\"id\":26}},{\"funcscope_category\":{\"id\":27},\"confirm_info\":{\"need_confirm\":0,\"already_confirm\":0,\"can_confirm\":0}},{\"funcscope_category\":{\"id\":33},\"confirm_info\":{\"need_confirm\":0,\"already_confirm\":0,\"can_confirm\":0}},{\"funcscope_category\":{\"id\":34}},{\"funcscope_category\":{\"id\":35}},{\"funcscope_category\":{\"id\":44},\"confirm_info\":{\"need_confirm\":0,\"already_confirm\":0,\"can_confirm\":0}},{\"funcscope_category\":{\"id\":46}},{\"funcscope_category\":{\"id\":47}},{\"funcscope_category\":{\"id\":54}},{\"funcscope_category\":{\"id\":66}},{\"funcscope_category\":{\"id\":89}}]', '2022-03-15 20:00:31');
COMMIT;

SET FOREIGN_KEY_CHECKS = 1;
