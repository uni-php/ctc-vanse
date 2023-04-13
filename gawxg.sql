-- MySQL dump 10.13  Distrib 5.7.40, for Linux (x86_64)
--
-- Host: localhost    Database: gawxg
-- ------------------------------------------------------
-- Server version	5.7.40-log

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `ctc_cash_rule`
--

DROP TABLE IF EXISTS `ctc_cash_rule`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ctc_cash_rule` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `max_cash` int(255) DEFAULT NULL COMMENT '最高提现',
  `min_cash` int(255) DEFAULT NULL COMMENT '最低提现',
  `limit_times` tinyint(4) DEFAULT NULL,
  `service_charge` varchar(255) DEFAULT NULL COMMENT '提现手续费',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ctc_cash_rule`
--

LOCK TABLES `ctc_cash_rule` WRITE;
/*!40000 ALTER TABLE `ctc_cash_rule` DISABLE KEYS */;
INSERT INTO `ctc_cash_rule` VALUES (1,3,1,4,'0.4');
/*!40000 ALTER TABLE `ctc_cash_rule` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ctc_code_disable`
--

DROP TABLE IF EXISTS `ctc_code_disable`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ctc_code_disable`
--

LOCK TABLES `ctc_code_disable` WRITE;
/*!40000 ALTER TABLE `ctc_code_disable` DISABLE KEYS */;
/*!40000 ALTER TABLE `ctc_code_disable` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ctc_code_enable`
--

DROP TABLE IF EXISTS `ctc_code_enable`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ctc_code_enable`
--

LOCK TABLES `ctc_code_enable` WRITE;
/*!40000 ALTER TABLE `ctc_code_enable` DISABLE KEYS */;
/*!40000 ALTER TABLE `ctc_code_enable` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ctc_code_manage`
--

DROP TABLE IF EXISTS `ctc_code_manage`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
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
) ENGINE=InnoDB AUTO_INCREMENT=183 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ctc_code_manage`
--

LOCK TABLES `ctc_code_manage` WRITE;
/*!40000 ALTER TABLE `ctc_code_manage` DISABLE KEYS */;
INSERT INTO `ctc_code_manage` VALUES (182,9,29,'20230223','1,3',NULL,220000,'1','0',NULL,'广安伟星码','8231063089,1841219763,6767107407',0,'2023-02-22 17:02:39',0,1,220000,'10',1,'15',0,2,1,0,'','[{\"num\":\"\"}]','0',0,'','牛栏山','0.00001','0.00001','2.20',0,'2.20','[]',1);
/*!40000 ALTER TABLE `ctc_code_manage` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ctc_code_rel_product`
--

DROP TABLE IF EXISTS `ctc_code_rel_product`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
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
) ENGINE=InnoDB AUTO_INCREMENT=128 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ctc_code_rel_product`
--

LOCK TABLES `ctc_code_rel_product` WRITE;
/*!40000 ALTER TABLE `ctc_code_rel_product` DISABLE KEYS */;
INSERT INTO `ctc_code_rel_product` VALUES (114,'202204281651128383','5694801','5695200',400,14,'88',25,9,'2022-04-28 06:46:23',1),(115,'202205261653533222','10001','12110',2110,15,'',29,9,'2022-05-26 02:47:02',1),(116,'202211151668517493','33211','33310',100,15,'测试导购',29,9,'2022-11-15 13:04:53',1),(117,'202211161668579986','33311','33410',100,15,'导购码测试',29,9,'2022-11-16 06:26:26',1),(118,'202211171668673690','33411','33460',50,15,'导购多奖测试',29,9,'2022-11-17 08:28:10',1),(119,'202211171668677902','33461','33560',100,15,'导购营销二码合一',29,9,'2022-11-17 09:38:23',1),(120,'202211171668683087','33561','33660',100,15,'测试',29,9,'2022-11-17 11:04:47',1),(121,'202212311672484524','33661','33710',50,15,'测试',29,9,'2022-12-31 11:02:04',1),(122,'202301151673752926','1','220000',220000,15,'广安伟星',29,9,'2023-01-15 03:22:38',1),(123,'1675956114','220001','440000',220000,15,'广安伟星导购营销码',29,9,'2023-02-09 15:22:25',1),(124,'1675956609','1','220000',220000,15,'广安伟星营销导购码',29,9,'2023-02-09 15:30:40',1),(125,'1676210447','1','220000',220000,15,'广安伟星',29,9,'2023-02-12 14:01:19',1),(126,'20230212','1','220000',220000,15,'广安伟星',29,9,'2023-02-12 14:07:59',1),(127,'20230223','1','220000',220000,15,'广安伟星码',29,9,'2023-02-22 17:02:39',1);
/*!40000 ALTER TABLE `ctc_code_rel_product` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ctc_dealer`
--

DROP TABLE IF EXISTS `ctc_dealer`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
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
  `behalf_balance` decimal(8,2) DEFAULT '0.00' COMMENT '代发余额',
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
) ENGINE=InnoDB AUTO_INCREMENT=36 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ctc_dealer`
--

LOCK TABLES `ctc_dealer` WRITE;
/*!40000 ALTER TABLE `ctc_dealer` DISABLE KEYS */;
INSERT INTO `ctc_dealer` VALUES (29,NULL,'广安伟星','gawx','广安市伟宏商贸有限公司',9,'程朝阳','13343217111','e10adc3949ba59abbe56e057f20f883e','河北省','石家庄市','裕华区','玫瑰湾','http://www.hlysj.com/','1','','3','[{\"module_name\":\"\\u4e8c\\u7ef4\\u7801\\u8425\\u9500\",\"module_retail\":\"100\",\"module_cost\":\"88\",\"module_id\":8},{\"module_name\":\"\\u79ef\\u5206\\u5546\\u57ce\",\"module_retail\":\"190\",\"module_cost\":\"80\",\"module_id\":13},{\"module_name\":\"\\u8d85\\u7ea7\\u5bfc\\u8d2d\",\"module_retail\":\"100\",\"module_cost\":\"80\",\"module_id\":18}]',6,96.00,'2022-05-20','2023-05-20','2022-05-20 03:36:24',NULL,1,0,0,0,0,'0',NULL,NULL,'http://cdn.uni-2id.com/dc20c202212311526043367.jpeg','400-660-2312');
/*!40000 ALTER TABLE `ctc_dealer` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ctc_dealer_business_license`
--

DROP TABLE IF EXISTS `ctc_dealer_business_license`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ctc_dealer_business_license`
--

LOCK TABLES `ctc_dealer_business_license` WRITE;
/*!40000 ALTER TABLE `ctc_dealer_business_license` DISABLE KEYS */;
/*!40000 ALTER TABLE `ctc_dealer_business_license` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ctc_dealer_customer_basic_set`
--

DROP TABLE IF EXISTS `ctc_dealer_customer_basic_set`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
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
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ctc_dealer_customer_basic_set`
--

LOCK TABLES `ctc_dealer_customer_basic_set` WRITE;
/*!40000 ALTER TABLE `ctc_dealer_customer_basic_set` DISABLE KEYS */;
INSERT INTO `ctc_dealer_customer_basic_set` VALUES (1,1,1,1,0,23,'2021-12-28 16:04:18');
/*!40000 ALTER TABLE `ctc_dealer_customer_basic_set` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ctc_dealer_customer_notice`
--

DROP TABLE IF EXISTS `ctc_dealer_customer_notice`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ctc_dealer_customer_notice` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `title` varchar(255) DEFAULT NULL COMMENT '公告标题',
  `content` text COMMENT '公告内容',
  `dealer_id` int(11) DEFAULT NULL,
  `status` tinyint(4) DEFAULT '0' COMMENT '状态0正常 1删除',
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ctc_dealer_customer_notice`
--

LOCK TABLES `ctc_dealer_customer_notice` WRITE;
/*!40000 ALTER TABLE `ctc_dealer_customer_notice` DISABLE KEYS */;
INSERT INTO `ctc_dealer_customer_notice` VALUES (2,'eferf','<p>rewrw</p>',23,0,'2021-12-28 14:53:18'),(3,'测试公告','<p>测试</p><p><img src=\"http://cdn.uni-2id.com/bffda20221212161259473.jpeg\"></p>',29,0,'2022-12-12 07:54:56'),(4,'最新公告','<p>1111</p>',29,0,'2022-12-12 08:14:43');
/*!40000 ALTER TABLE `ctc_dealer_customer_notice` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ctc_dealer_customer_userinfo_page`
--

DROP TABLE IF EXISTS `ctc_dealer_customer_userinfo_page`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
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
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ctc_dealer_customer_userinfo_page`
--

LOCK TABLES `ctc_dealer_customer_userinfo_page` WRITE;
/*!40000 ALTER TABLE `ctc_dealer_customer_userinfo_page` DISABLE KEYS */;
INSERT INTO `ctc_dealer_customer_userinfo_page` VALUES (1,0,1,'微商城','积分商城','会员中心',1,29,'2022-11-24 16:29:25');
/*!40000 ALTER TABLE `ctc_dealer_customer_userinfo_page` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ctc_dealer_customer_zone`
--

DROP TABLE IF EXISTS `ctc_dealer_customer_zone`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ctc_dealer_customer_zone` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `area_name` varchar(255) DEFAULT NULL,
  `order` int(11) DEFAULT NULL,
  `parentId` int(11) DEFAULT NULL,
  `dealer_id` int(11) DEFAULT NULL,
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ctc_dealer_customer_zone`
--

LOCK TABLES `ctc_dealer_customer_zone` WRITE;
/*!40000 ALTER TABLE `ctc_dealer_customer_zone` DISABLE KEYS */;
INSERT INTO `ctc_dealer_customer_zone` VALUES (14,'华北',1,0,25,'2022-04-14 07:01:32'),(15,'石家庄',2,14,25,'2022-04-14 07:01:39'),(16,'南部',1,0,27,'2022-05-28 00:23:25'),(17,'保定',1,0,30,'2022-07-23 11:09:02');
/*!40000 ALTER TABLE `ctc_dealer_customer_zone` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ctc_dealer_customize_field`
--

DROP TABLE IF EXISTS `ctc_dealer_customize_field`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
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
  `value` varchar(255) DEFAULT NULL,
  `prop` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ctc_dealer_customize_field`
--

LOCK TABLES `ctc_dealer_customize_field` WRITE;
/*!40000 ALTER TABLE `ctc_dealer_customize_field` DISABLE KEYS */;
INSERT INTO `ctc_dealer_customize_field` VALUES (4,'姓名',1,10,'','请输入姓名',1,1,29,'2022-06-09 18:27:53',0,'','name'),(5,'小区',1,10,'','请输入施工小区名称',0,1,29,'2022-06-10 01:25:47',0,'','yard'),(6,'楼号',1,10,'','请输入具体的楼号及楼层',0,1,29,'2022-06-10 01:28:16',0,'','floor'),(7,'小区',1,10,'','请输入施工小区名称',1,1,26,'2022-06-13 09:22:27',0,'','home'),(8,'单元',1,10,'','请输入具体的楼号及楼层',2,1,26,'2022-06-13 09:24:00',0,'','floor'),(9,'图片',5,0,'','请上传图片',0,1,29,'2022-09-16 12:24:36',0,'','image');
/*!40000 ALTER TABLE `ctc_dealer_customize_field` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ctc_dealer_dingding`
--

DROP TABLE IF EXISTS `ctc_dealer_dingding`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ctc_dealer_dingding` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `dealer_id` int(11) DEFAULT NULL,
  `micro_app_title` varchar(255) DEFAULT NULL,
  `agentId` varchar(255) DEFAULT NULL,
  `appKey` varchar(255) DEFAULT NULL,
  `appSecret` varchar(255) DEFAULT NULL,
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ctc_dealer_dingding`
--

LOCK TABLES `ctc_dealer_dingding` WRITE;
/*!40000 ALTER TABLE `ctc_dealer_dingding` DISABLE KEYS */;
/*!40000 ALTER TABLE `ctc_dealer_dingding` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ctc_dealer_dingding_set`
--

DROP TABLE IF EXISTS `ctc_dealer_dingding_set`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ctc_dealer_dingding_set` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `app_key` varchar(255) DEFAULT NULL,
  `secret` varchar(255) DEFAULT NULL,
  `dealer_id` int(11) DEFAULT NULL,
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ctc_dealer_dingding_set`
--

LOCK TABLES `ctc_dealer_dingding_set` WRITE;
/*!40000 ALTER TABLE `ctc_dealer_dingding_set` DISABLE KEYS */;
/*!40000 ALTER TABLE `ctc_dealer_dingding_set` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ctc_dealer_distributor`
--

DROP TABLE IF EXISTS `ctc_dealer_distributor`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
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
  PRIMARY KEY (`id`),
  UNIQUE KEY `distributor_code` (`distributor_code`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=2391 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ctc_dealer_distributor`
--

LOCK TABLES `ctc_dealer_distributor` WRITE;
/*!40000 ALTER TABLE `ctc_dealer_distributor` DISABLE KEYS */;
/*!40000 ALTER TABLE `ctc_dealer_distributor` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ctc_dealer_distributor_bill`
--

DROP TABLE IF EXISTS `ctc_dealer_distributor_bill`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ctc_dealer_distributor_bill`
--

LOCK TABLES `ctc_dealer_distributor_bill` WRITE;
/*!40000 ALTER TABLE `ctc_dealer_distributor_bill` DISABLE KEYS */;
/*!40000 ALTER TABLE `ctc_dealer_distributor_bill` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ctc_dealer_distributor_level`
--

DROP TABLE IF EXISTS `ctc_dealer_distributor_level`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ctc_dealer_distributor_level` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `level_name` varchar(255) DEFAULT NULL COMMENT '级别名称',
  `level_order` int(11) DEFAULT NULL COMMENT '级别编号',
  `dealer_id` int(11) DEFAULT NULL,
  `status` tinyint(4) DEFAULT '0' COMMENT '状态0正常 1删除',
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ctc_dealer_distributor_level`
--

LOCK TABLES `ctc_dealer_distributor_level` WRITE;
/*!40000 ALTER TABLE `ctc_dealer_distributor_level` DISABLE KEYS */;
/*!40000 ALTER TABLE `ctc_dealer_distributor_level` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ctc_dealer_distributor_register_config`
--

DROP TABLE IF EXISTS `ctc_dealer_distributor_register_config`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
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
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ctc_dealer_distributor_register_config`
--

LOCK TABLES `ctc_dealer_distributor_register_config` WRITE;
/*!40000 ALTER TABLE `ctc_dealer_distributor_register_config` DISABLE KEYS */;
INSERT INTO `ctc_dealer_distributor_register_config` VALUES (2,1,1,1,1,1,1,1,1,1,1,1,25,'2022-04-13 06:54:20');
/*!40000 ALTER TABLE `ctc_dealer_distributor_register_config` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ctc_dealer_freight_template`
--

DROP TABLE IF EXISTS `ctc_dealer_freight_template`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
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
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ctc_dealer_freight_template`
--

LOCK TABLES `ctc_dealer_freight_template` WRITE;
/*!40000 ALTER TABLE `ctc_dealer_freight_template` DISABLE KEYS */;
INSERT INTO `ctc_dealer_freight_template` VALUES (12,'默认',NULL,29,1,'','','','','2022-08-23 17:22:18',0);
/*!40000 ALTER TABLE `ctc_dealer_freight_template` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ctc_dealer_gift`
--

DROP TABLE IF EXISTS `ctc_dealer_gift`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
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
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ctc_dealer_gift`
--

LOCK TABLES `ctc_dealer_gift` WRITE;
/*!40000 ALTER TABLE `ctc_dealer_gift` DISABLE KEYS */;
INSERT INTO `ctc_dealer_gift` VALUES (9,'001','001',8,'20kg','1','牛栏山礼品','[{\"url\":\"http://cdn.uni-2id.com/0e906202206201502499112.png\",\"name\":\"0e906202206201502499112.png\"}]','50','60','100','瓶','<p>牛栏山酒厂，中国历史悠久的酿酒厂之一。依据现保存在顺义档案馆的《顺义县志》，从有详细酿酒历史记载的康熙五十八年（1719）年算起，酿酒古镇牛栏山的“酒龄”已近300年。</p><p>	</p><p>据民国20年《顺义县志·实业志》载：“牛栏山镇造酒工作是工者约百余人（受雇于治内十一家烧锅），所酿之酒甘冽异常为北平特产，销售邻县或平市，颇脍炙人口，而尤以牛栏山之酒为最著”。</p>',29,'2022-08-23 17:20:58',NULL,NULL,0);
/*!40000 ALTER TABLE `ctc_dealer_gift` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ctc_dealer_gift_group`
--

DROP TABLE IF EXISTS `ctc_dealer_gift_group`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ctc_dealer_gift_group` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `group_name` varchar(255) DEFAULT NULL,
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `dealer_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ctc_dealer_gift_group`
--

LOCK TABLES `ctc_dealer_gift_group` WRITE;
/*!40000 ALTER TABLE `ctc_dealer_gift_group` DISABLE KEYS */;
INSERT INTO `ctc_dealer_gift_group` VALUES (7,'伟星','2022-04-12 07:17:58',25),(8,'分组一','2022-08-23 17:19:12',29);
/*!40000 ALTER TABLE `ctc_dealer_gift_group` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ctc_dealer_guide`
--

DROP TABLE IF EXISTS `ctc_dealer_guide`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ctc_dealer_guide` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `dealer_id` int(11) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL COMMENT '导购姓名',
  `phone` varchar(255) DEFAULT NULL,
  `password` varchar(255) DEFAULT NULL,
  `group_id` tinyint(4) DEFAULT NULL COMMENT '所属分组',
  `store_id` tinyint(4) DEFAULT NULL COMMENT '所属门店',
  `address` varchar(255) DEFAULT NULL COMMENT '详细地址',
  `province` varchar(255) DEFAULT NULL,
  `city` varchar(255) DEFAULT NULL,
  `district` varchar(255) DEFAULT NULL,
  `wechat` varchar(255) DEFAULT NULL,
  `cover` varchar(255) DEFAULT NULL,
  `remark` varchar(255) DEFAULT NULL,
  `status` tinyint(4) DEFAULT '0' COMMENT '导购状态0未激活 1正常2禁用 3删除 -1待审核 -2已拒绝',
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `active_name` varchar(255) DEFAULT 'first' COMMENT '申请审核 first',
  `openid` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ctc_dealer_guide`
--

LOCK TABLES `ctc_dealer_guide` WRITE;
/*!40000 ALTER TABLE `ctc_dealer_guide` DISABLE KEYS */;
INSERT INTO `ctc_dealer_guide` VALUES (3,29,'文寒','18330118047',NULL,1,1,'石家庄','北京市','市辖区','东城区','novel',NULL,'',1,'2023-04-09 15:14:55','first','oe60X6k15tFeaU-JL-AK2VYYxXYk'),(4,29,'逍遥','18931378659',NULL,1,1,'测试','河北省','石家庄市','裕华区','lm130230',NULL,'',1,'2023-04-11 03:41:06','first','oe60X6lJHisC1BA4MLd5y16UcbsE');
/*!40000 ALTER TABLE `ctc_dealer_guide` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ctc_dealer_guide_activity`
--

DROP TABLE IF EXISTS `ctc_dealer_guide_activity`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ctc_dealer_guide_activity` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `activity_name` varchar(255) DEFAULT NULL COMMENT '活动名称',
  `begin_time` timestamp NULL DEFAULT NULL COMMENT '开始时间',
  `end_time` timestamp NULL DEFAULT NULL COMMENT '结束时间',
  `remark` varchar(255) DEFAULT NULL COMMENT '活动备注',
  `tpl_name` varchar(255) DEFAULT NULL COMMENT '模板名称',
  `tpl_id` int(11) DEFAULT NULL COMMENT '模板id',
  `join_condition` tinyint(4) DEFAULT NULL COMMENT '活动参与方式 1关注微信公众号领奖 2直接领奖',
  `is_user_info` tinyint(4) DEFAULT '0' COMMENT '是否收集用户资料 0否 1是',
  `user_info_field` text COMMENT '用户信息收集字段',
  `is_auth_tag` tinyint(4) DEFAULT '0' COMMENT '是否自动打标签0否 1是',
  `is_user_address` tinyint(4) DEFAULT '0' COMMENT '是否获取用户位置0否 1是',
  `is_rule_show` tinyint(4) DEFAULT '0' COMMENT '是否显示活动规则 0否 1是',
  `rule_title` varchar(255) DEFAULT NULL COMMENT '规则标题',
  `rule_content` varchar(255) DEFAULT NULL COMMENT '规则内容',
  `active_area` int(11) DEFAULT NULL COMMENT '活动区域',
  `code_batch_data` text COMMENT '赋码字段',
  `isnot_guide_tips` varchar(255) DEFAULT NULL COMMENT '非导购员扫码提示',
  `prize_data` text COMMENT '奖项',
  `empty_tips` varchar(255) DEFAULT NULL COMMENT '未中奖提示',
  `repeat_tips` varchar(255) DEFAULT NULL COMMENT '重复领奖提示',
  `invalid_tips` varchar(255) DEFAULT NULL COMMENT '奖项已被领取提示',
  `is_join_limit` tinyint(4) DEFAULT '0' COMMENT '活动参与限制 0不开启 1开启',
  `day_limit_times` int(11) DEFAULT NULL COMMENT '每人每天限领次数',
  `limit_times_tips` varchar(255) DEFAULT NULL COMMENT '超次提示',
  `is_open_appoint` tinyint(4) DEFAULT '0' COMMENT '是否开启定向0不开启 1开启',
  `guide_gruop` varchar(255) DEFAULT NULL COMMENT '导购员分组限制',
  `is_user_limit` tinyint(4) DEFAULT '0' COMMENT '指定用户参与0不开启 1开启',
  `unexpected_user_tips` varchar(255) DEFAULT NULL COMMENT '不符合用户领取提示',
  `is_address_limit` tinyint(4) DEFAULT '0' COMMENT '指定地区参与0关闭 1开启',
  `is_address_limit_type` tinyint(4) DEFAULT NULL COMMENT '参与类型1 按行政区域划分 2按GPS坐标设置',
  `select_limit_address` varchar(255) DEFAULT NULL COMMENT '限制区域',
  `out_address_tips` varchar(255) DEFAULT NULL COMMENT '非活动范围领奖提示',
  `fleeing_goods` tinyint(4) DEFAULT '0' COMMENT '是否监控窜货 0否 1是',
  `create_by` varchar(255) DEFAULT NULL,
  `status` tinyint(4) DEFAULT '0' COMMENT '启用状态0未启用 1已启用 2禁用 3已删除',
  `dealer_id` int(11) DEFAULT NULL,
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ctc_dealer_guide_activity`
--

LOCK TABLES `ctc_dealer_guide_activity` WRITE;
/*!40000 ALTER TABLE `ctc_dealer_guide_activity` DISABLE KEYS */;
INSERT INTO `ctc_dealer_guide_activity` VALUES (1,'测试导购','2022-11-10 16:00:00','2027-12-29 16:00:00','测试','测试',12,0,0,'[]',0,1,1,'测试规则','测试规则啊',0,'[{\"batch\":\"20230223\",\"order_begin\":\"16070\",\"order_end\":\"16090\",\"quantity\":21,\"remark\":\"\"}]','哦噢，你不是导购员,不能参与活动','[{\"prize_name\":\"\\u4e00\\u7b49\\u5956\",\"prize_number\":10,\"prize_rate\":\"100%\",\"prize_content\":\"\\u7ea2\\u5305(\\uffe520(\\u4ee3\\u53d1\\u7ea2\\u5305 ID:20))\",\"win_num\":0,\"prize_type\":1,\"red_envelopes_name\":\"20(\\u4ee3\\u53d1\\u7ea2\\u5305 ID:20)\",\"red_envelopes_id\":20,\"points\":1,\"goods_points\":false,\"gift\":[],\"valid_day\":3,\"is_gift_tips\":false,\"gift_tips\":\"\"}]','很抱歉，您未中奖，再接再厉哦!','该二维码您已经领过奖了！','该二维码已经被别人领过奖了！',1,3,'抱歉，您已超过活动当日参与次数上限，请明天再试！',0,'[1,2]',1,'您不符合本次活动的参与条件',0,1,'[]','您不在本次活动指定的地区，无法参与活动~',2,'gawx',1,29,'2022-11-15 13:16:59');
/*!40000 ALTER TABLE `ctc_dealer_guide_activity` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ctc_dealer_guide_group`
--

DROP TABLE IF EXISTS `ctc_dealer_guide_group`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ctc_dealer_guide_group` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `dealer_id` int(11) DEFAULT NULL,
  `group_name` varchar(255) DEFAULT NULL COMMENT '分组名称',
  `order` varchar(255) DEFAULT NULL,
  `is_check` tinyint(4) DEFAULT '1' COMMENT '是否开启审核',
  `is_sms` tinyint(4) DEFAULT '1' COMMENT '是否开启短信通知',
  `is_condition` tinyint(4) DEFAULT '1' COMMENT '是否显示申请条件',
  `condition_title` varchar(255) DEFAULT NULL COMMENT '条件标题',
  `condition_content` text,
  `is_rank` tinyint(4) DEFAULT '1' COMMENT '是否显示排行榜',
  `rank_type` varchar(255) DEFAULT NULL COMMENT '显示的排行榜类别',
  `prize_rank_num` tinyint(4) DEFAULT NULL,
  `prize_rank_time` varchar(255) DEFAULT NULL,
  `red_rank_num` tinyint(4) DEFAULT NULL,
  `red_rank_time` varchar(255) DEFAULT NULL,
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `is_del` tinyint(4) DEFAULT '0' COMMENT '是否删除 1删除 0正常',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ctc_dealer_guide_group`
--

LOCK TABLES `ctc_dealer_guide_group` WRITE;
/*!40000 ALTER TABLE `ctc_dealer_guide_group` DISABLE KEYS */;
INSERT INTO `ctc_dealer_guide_group` VALUES (1,29,'3哈哈哈','3563',1,1,1,'申请条件','321321',1,'[1,2]',3,'[1,2,3]',3,'[1,2,3,4]',NULL,0),(2,29,'4754','545',1,1,1,'申请条件','5454',1,'[1,2]',3,'[1,2,3,4]',3,'[1,2,3,4]','2022-10-23 09:02:45',0);
/*!40000 ALTER TABLE `ctc_dealer_guide_group` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ctc_dealer_guide_prize_bill`
--

DROP TABLE IF EXISTS `ctc_dealer_guide_prize_bill`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ctc_dealer_guide_prize_bill` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `dealer_id` int(11) DEFAULT NULL,
  `code` varchar(255) DEFAULT NULL,
  `serial_number` varchar(255) DEFAULT NULL COMMENT '序列号',
  `openid` varchar(255) DEFAULT NULL,
  `member_id` int(11) DEFAULT NULL,
  `batch` varchar(255) DEFAULT NULL COMMENT '码批次',
  `activity_id` int(11) DEFAULT NULL COMMENT '活动id',
  `prize_name` varchar(255) DEFAULT NULL COMMENT '奖项名称',
  `prize_content` varchar(255) DEFAULT NULL COMMENT '奖项内容',
  `scan_type` varchar(255) DEFAULT NULL COMMENT '扫码方式',
  `province` varchar(255) DEFAULT NULL COMMENT '扫码省份',
  `city` varchar(255) DEFAULT NULL COMMENT '扫码城市',
  `district` varchar(255) DEFAULT NULL,
  `points` varchar(255) DEFAULT NULL COMMENT '积分数',
  `gift` text COMMENT '所中礼品',
  `money` varchar(255) DEFAULT NULL COMMENT '红包金额',
  `prize_type` tinyint(4) DEFAULT NULL COMMENT '奖项类型1红包 2积分 3礼品',
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `is_user_info` tinyint(4) DEFAULT '0' COMMENT '是否开启补充字段 1开启',
  `user_info_field` text,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ctc_dealer_guide_prize_bill`
--

LOCK TABLES `ctc_dealer_guide_prize_bill` WRITE;
/*!40000 ALTER TABLE `ctc_dealer_guide_prize_bill` DISABLE KEYS */;
/*!40000 ALTER TABLE `ctc_dealer_guide_prize_bill` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ctc_dealer_guide_query_bill`
--

DROP TABLE IF EXISTS `ctc_dealer_guide_query_bill`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ctc_dealer_guide_query_bill` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `code` varchar(255) DEFAULT NULL,
  `serial_number` varchar(255) DEFAULT NULL COMMENT '序号',
  `dealer_id` int(11) DEFAULT NULL,
  `batch` varchar(255) DEFAULT NULL COMMENT '批次',
  `address` varchar(255) DEFAULT NULL COMMENT '扫码区域',
  `openid` varchar(255) DEFAULT NULL COMMENT '扫码用户身份',
  `is_first` tinyint(4) DEFAULT '1' COMMENT '是否首次查询1 是 2否(重复)',
  `ip` varchar(255) DEFAULT NULL,
  `product_id` int(11) DEFAULT NULL,
  `province` varchar(255) DEFAULT NULL COMMENT '扫码省份',
  `city` varchar(255) DEFAULT NULL,
  `district` varchar(255) DEFAULT NULL COMMENT '扫码区',
  `scan_type` varchar(255) DEFAULT NULL COMMENT '扫码方式',
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `sources` tinyint(4) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ctc_dealer_guide_query_bill`
--

LOCK TABLES `ctc_dealer_guide_query_bill` WRITE;
/*!40000 ALTER TABLE `ctc_dealer_guide_query_bill` DISABLE KEYS */;
INSERT INTO `ctc_dealer_guide_query_bill` VALUES (1,'0650769124','16080',29,'20230223',NULL,'oe60X6lJHisC1BA4MLd5y16UcbsE',1,'124.236.175.87',NULL,'河北省','石家庄市',NULL,'1','2023-04-11 06:33:11',3),(2,'0650769124','16080',29,'20230223',NULL,'oe60X6lJHisC1BA4MLd5y16UcbsE',2,'124.236.175.87',NULL,'河北省','石家庄市',NULL,'1','2023-04-11 06:35:15',3),(3,'0650769124','16080',29,'20230223',NULL,'oe60X6lJHisC1BA4MLd5y16UcbsE',2,'124.236.175.87',NULL,'河北省','石家庄市',NULL,'1','2023-04-11 06:41:28',3),(4,'0650769124','16080',29,'20230223',NULL,'oe60X6lJHisC1BA4MLd5y16UcbsE',2,'124.236.175.87',NULL,'河北省','石家庄市',NULL,'1','2023-04-11 07:02:16',3),(5,'0650769124','16080',29,'20230223',NULL,'oe60X6lJHisC1BA4MLd5y16UcbsE',2,'124.236.175.87',NULL,'河北省','石家庄市',NULL,'1','2023-04-11 07:42:06',3),(6,'0650769124','16080',29,'20230223',NULL,'oe60X6lJHisC1BA4MLd5y16UcbsE',2,'124.236.175.87',NULL,'河北省','石家庄市',NULL,'1','2023-04-11 07:50:15',3);
/*!40000 ALTER TABLE `ctc_dealer_guide_query_bill` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ctc_dealer_guide_register`
--

DROP TABLE IF EXISTS `ctc_dealer_guide_register`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ctc_dealer_guide_register` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `dealer_id` int(11) DEFAULT NULL,
  `openid` varchar(255) DEFAULT NULL,
  `code` varchar(255) DEFAULT NULL,
  `batch` varchar(255) DEFAULT NULL COMMENT '数码批次',
  `is_get` tinyint(4) DEFAULT '0' COMMENT '是否领奖 0未领奖 1已领奖',
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `serial_number` varchar(255) DEFAULT NULL COMMENT '序列号',
  `activity_id` int(11) DEFAULT NULL COMMENT '导购活动id',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ctc_dealer_guide_register`
--

LOCK TABLES `ctc_dealer_guide_register` WRITE;
/*!40000 ALTER TABLE `ctc_dealer_guide_register` DISABLE KEYS */;
/*!40000 ALTER TABLE `ctc_dealer_guide_register` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ctc_dealer_guide_tpl`
--

DROP TABLE IF EXISTS `ctc_dealer_guide_tpl`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ctc_dealer_guide_tpl` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `dealer_id` int(11) DEFAULT NULL,
  `tpl_name` varchar(255) DEFAULT NULL COMMENT '模板名称',
  `remark` varchar(255) DEFAULT NULL COMMENT '备注',
  `type` tinyint(4) DEFAULT NULL COMMENT '扫码模板类型 1普通模板 2大转盘模板',
  `welcom_page` text COMMENT '欢迎页',
  `activity_page` text COMMENT '活动页',
  `create_by` varchar(255) DEFAULT NULL COMMENT '创建人',
  `xuanchuan_page` text COMMENT '宣传页',
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ctc_dealer_guide_tpl`
--

LOCK TABLES `ctc_dealer_guide_tpl` WRITE;
/*!40000 ALTER TABLE `ctc_dealer_guide_tpl` DISABLE KEYS */;
INSERT INTO `ctc_dealer_guide_tpl` VALUES (12,29,'测试','测试啊',1,'[{\"is_active\":1,\"title\":\"\\u626b\\u7801\\u6709\\u793c\",\"duration\":2,\"tips\":\"\\u8df3\\u8fc7\",\"cover\":\"http:\\/\\/cdn.uni-2id.com\\/welcom_page.png\"}]','[{\"title\":\"\\u626b\\u7801\\u7ed3\\u679c\",\"btn_text\":\"\\u6211\\u77e5\\u9053\\u4e86\",\"is_fangwei\":0,\"cover\":\"https:\\/\\/cdn.uni-2id.com\\/guide_active_page.png\"}]','hailue','[{\"type\":\"goods\",\"link\":1,\"height\":200}]','2022-11-15 09:20:20');
/*!40000 ALTER TABLE `ctc_dealer_guide_tpl` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ctc_dealer_guide_userinfo_page`
--

DROP TABLE IF EXISTS `ctc_dealer_guide_userinfo_page`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ctc_dealer_guide_userinfo_page` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `is_points_mall` tinyint(4) DEFAULT NULL COMMENT '是否显示积分商城',
  `micro_points_name` varchar(255) DEFAULT NULL,
  `page_name` varchar(255) DEFAULT NULL COMMENT '页面名称',
  `is_fun_show` tinyint(4) DEFAULT NULL COMMENT '是否删除可选模块',
  `is_scan` tinyint(4) DEFAULT NULL,
  `dealer_id` int(11) DEFAULT NULL,
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `scan_name` varchar(255) DEFAULT NULL COMMENT '导购扫一扫',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ctc_dealer_guide_userinfo_page`
--

LOCK TABLES `ctc_dealer_guide_userinfo_page` WRITE;
/*!40000 ALTER TABLE `ctc_dealer_guide_userinfo_page` DISABLE KEYS */;
INSERT INTO `ctc_dealer_guide_userinfo_page` VALUES (1,1,'积分商城','导购中心',1,1,29,'2022-11-15 06:41:44','导购扫一扫');
/*!40000 ALTER TABLE `ctc_dealer_guide_userinfo_page` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ctc_dealer_img_library`
--

DROP TABLE IF EXISTS `ctc_dealer_img_library`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ctc_dealer_img_library` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `img_group` int(11) DEFAULT NULL,
  `img_url` varchar(255) DEFAULT NULL,
  `img_name` varchar(255) DEFAULT NULL,
  `dealer_id` int(11) DEFAULT NULL,
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=37 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ctc_dealer_img_library`
--

LOCK TABLES `ctc_dealer_img_library` WRITE;
/*!40000 ALTER TABLE `ctc_dealer_img_library` DISABLE KEYS */;
INSERT INTO `ctc_dealer_img_library` VALUES (16,10,'https://cdn.icloudapi.cn/34999202204121521583467.jpg','34999202204121521583467.jpg',25,'2022-04-12 07:22:00'),(17,10,'https://cdn.icloudapi.cn/6bcd720220412170522886.jpg','6bcd720220412170522886.jpg',25,'2022-04-12 09:05:26'),(18,10,'https://cdn.icloudapi.cn/fa13d202204121705345365.jpg','fa13d202204121705345365.jpg',25,'2022-04-12 09:05:38'),(19,10,'https://cdn.icloudapi.cn/a6f00202204121705507814.jpg','a6f00202204121705507814.jpg',25,'2022-04-12 09:05:52'),(21,10,'http://cdn.uni-2id.com/3b365202204180425149109.jpg','3b365202204180425149109.jpg',25,'2022-04-17 20:25:17'),(23,12,'http://cdn.uni-2id.com/4626e202205241052243681.jpg','4626e202205241052243681.jpg',29,'2022-05-24 02:52:33'),(24,11,'http://cdn.uni-2id.com/60413202205241602202234.jpg','60413202205241602202234.jpg',27,'2022-05-24 08:02:28'),(25,11,'http://cdn.uni-2id.com/9dc89202205241602369547.jpg','9dc89202205241602369547.jpg',27,'2022-05-24 08:02:40'),(26,11,'http://cdn.uni-2id.com/966fe202205241602488230.jpg','966fe202205241602488230.jpg',27,'2022-05-24 08:02:51'),(27,12,'http://cdn.uni-2id.com/cec62202205261026308974.jpg','cec62202205261026308974.jpg',29,'2022-05-26 02:26:39'),(28,12,'http://cdn.uni-2id.com/785c3202205261029597677.jpg','785c3202205261029597677.jpg',29,'2022-05-26 02:30:07'),(29,12,'http://cdn.uni-2id.com/0a4e020220526103925960.jpg','0a4e020220526103925960.jpg',29,'2022-05-26 02:39:28'),(30,12,'http://cdn.uni-2id.com/03905202205261040268703.jpg','03905202205261040268703.jpg',29,'2022-05-26 02:40:31'),(31,14,'http://cdn.uni-2id.com/0fc92202206131005552713.jpg','0fc92202206131005552713.jpg',28,'2022-06-13 02:05:57'),(32,14,'http://cdn.uni-2id.com/95d14202206160956435927.jpg','95d14202206160956435927.jpg',28,'2022-06-16 01:56:49'),(33,15,'http://cdn.uni-2id.com/4d30c202206200905362117.jpg','4d30c202206200905362117.jpg',32,'2022-06-20 01:05:40'),(34,16,'http://cdn.uni-2id.com/0e906202206201502499112.png','0e906202206201502499112.png',29,'2022-06-20 07:02:54'),(35,17,'http://cdn.uni-2id.com/c2f66202207150959288655.jpg','c2f66202207150959288655.jpg',33,'2022-07-15 01:59:32'),(36,18,'http://cdn.uni-2id.com/c51ca202208240929015410.jpg','c51ca202208240929015410.jpg',34,'2022-08-24 01:29:04');
/*!40000 ALTER TABLE `ctc_dealer_img_library` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ctc_dealer_img_material`
--

DROP TABLE IF EXISTS `ctc_dealer_img_material`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ctc_dealer_img_material` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `img_url` varchar(255) DEFAULT NULL,
  `material_group` int(11) DEFAULT NULL,
  `media_id` varchar(255) DEFAULT NULL,
  `dealer_id` int(11) DEFAULT NULL,
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ctc_dealer_img_material`
--

LOCK TABLES `ctc_dealer_img_material` WRITE;
/*!40000 ALTER TABLE `ctc_dealer_img_material` DISABLE KEYS */;
/*!40000 ALTER TABLE `ctc_dealer_img_material` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ctc_dealer_library_type`
--

DROP TABLE IF EXISTS `ctc_dealer_library_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ctc_dealer_library_type` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `group_name` varchar(255) DEFAULT NULL,
  `dealer_id` int(11) DEFAULT NULL,
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `is_del` tinyint(4) DEFAULT '0' COMMENT '1已删除 代表未分组',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ctc_dealer_library_type`
--

LOCK TABLES `ctc_dealer_library_type` WRITE;
/*!40000 ALTER TABLE `ctc_dealer_library_type` DISABLE KEYS */;
INSERT INTO `ctc_dealer_library_type` VALUES (10,'伟星',25,'2022-04-12 07:21:30',0),(11,'ZA',27,'2022-05-24 02:51:55',0),(12,'电线',29,'2022-05-24 02:52:10',0),(13,'防水',29,'2022-05-27 07:34:03',0),(14,'建材',28,'2022-06-13 02:05:45',0),(15,'酒',32,'2022-06-20 01:05:23',0),(16,'酒水',29,'2022-06-20 07:02:38',0),(17,'伟星',33,'2022-07-15 01:58:17',0),(18,'伟星管',34,'2022-08-24 01:28:51',0);
/*!40000 ALTER TABLE `ctc_dealer_library_type` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ctc_dealer_logistics_basic_set`
--

DROP TABLE IF EXISTS `ctc_dealer_logistics_basic_set`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ctc_dealer_logistics_basic_set` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `dealer_id` int(11) DEFAULT NULL,
  `is_fleeing_goods_join` varchar(4) DEFAULT '1' COMMENT '商品窜货后是否允许查询和参与活动 1不允许 2允许',
  `dead_goods_time` varchar(255) DEFAULT NULL COMMENT '呆滞品周期',
  `query_password` varchar(255) DEFAULT NULL COMMENT '物流查询密码',
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ctc_dealer_logistics_basic_set`
--

LOCK TABLES `ctc_dealer_logistics_basic_set` WRITE;
/*!40000 ALTER TABLE `ctc_dealer_logistics_basic_set` DISABLE KEYS */;
INSERT INTO `ctc_dealer_logistics_basic_set` VALUES (3,25,'1','1','123456','2022-04-12 07:28:08'),(4,29,'1','1','123456','2022-05-26 03:08:42'),(5,28,'1','0','123456','2022-06-13 02:08:27'),(6,32,'1','30','123456','2022-06-18 16:22:45'),(7,33,'1','0','123456','2022-07-01 01:41:37'),(8,34,'1','5','123456','2022-08-24 01:43:14');
/*!40000 ALTER TABLE `ctc_dealer_logistics_basic_set` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ctc_dealer_logistics_ch_order`
--

DROP TABLE IF EXISTS `ctc_dealer_logistics_ch_order`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
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
) ENGINE=InnoDB AUTO_INCREMENT=119 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ctc_dealer_logistics_ch_order`
--

LOCK TABLES `ctc_dealer_logistics_ch_order` WRITE;
/*!40000 ALTER TABLE `ctc_dealer_logistics_ch_order` DISABLE KEYS */;
INSERT INTO `ctc_dealer_logistics_ch_order` VALUES (81,25,0,100,7,'经销商101','jxs101','河北省石家庄市','2022-04-17 20:28:47',2,NULL,'CH2022041810157501','179','4420892424',NULL,'1','扫码查询',NULL),(82,25,0,100,7,'经销商101','jxs101','河北省石家庄市','2022-04-18 02:34:17',2,NULL,'CH2022041810157501','179','4420892424',NULL,'1','扫码查询',NULL),(83,25,0,60,9,'张三','zs','河北省石家庄市','2022-04-19 03:38:26',2,NULL,'CH2022041954979952','1478413','1258413815',NULL,'1','扫码查询',NULL),(84,25,0,60,9,'张三','zs','河北省石家庄市','2022-04-19 03:40:49',2,NULL,'CH2022041954979952','1478413','1258413815',NULL,'1','扫码查询',NULL),(85,29,0,100,2217,'石家庄赵四','nigulasizs','河北省石家庄市','2022-05-26 03:07:59',2,NULL,'CH2022052657555110','10004','0675445609',NULL,'1','扫码查询',NULL),(86,29,0,100,2217,'石家庄赵四','nigulasizs','河北省石家庄市','2022-05-26 03:21:41',2,NULL,'CH2022052657555110','10004','0675445609',NULL,'1','扫码查询',NULL),(87,29,0,100,2217,'石家庄赵四','nigulasizs','河北省石家庄市','2022-05-26 03:21:48',2,NULL,'CH2022052657555110','10004','0675445609',NULL,'1','扫码查询',NULL),(88,29,0,100,2217,'石家庄赵四','nigulasizs','湖北省武汉市','2022-05-27 09:31:10',2,NULL,'CH2022052657555110','10004','0675445609',NULL,'1','扫码查询',NULL),(89,29,0,100,2217,'石家庄赵四','nigulasizs','湖北省武汉市','2022-05-27 09:38:32',2,NULL,'CH2022052657555110','10004','0675445609',NULL,'1','扫码查询',NULL),(90,29,0,100,2217,'石家庄赵四','nigulasizs','北卡罗来纳0','2022-05-27 11:42:11',2,NULL,'CH2022052657555110','10004','0675445609',NULL,'1','扫码查询',NULL),(101,32,0,6,2229,'山西聚茂德烧坊酿酒有限公司','sxjmd','河北省石家庄市','2022-06-20 01:11:28',2,NULL,'CH2022062055525250','1','0000000001',NULL,'1','扫码查询',NULL),(102,32,0,6,2229,'山西聚茂德烧坊酿酒有限公司','sxjmd','河北省石家庄市','2022-06-20 01:12:03',2,NULL,'CH2022062055525250','11006','63440764595',NULL,'2','扫码查询',NULL),(103,32,0,6,2229,'山西聚茂德烧坊酿酒有限公司','sxjmd','加利福尼亚0','2022-06-20 05:42:47',2,NULL,'CH2022062055525250','11003','29955774005',NULL,'2','扫码查询',NULL),(104,32,0,6,2229,'山西聚茂德烧坊酿酒有限公司','sxjmd','加利福尼亚0','2022-06-20 08:09:03',2,NULL,'CH2022062055525250','11006','63440764595',NULL,'2','扫码查询',NULL),(105,29,0,100,2217,'石家庄赵四','nigulasizs','河北省石家庄市','2022-06-27 01:15:24',2,NULL,'CH2022062710210098','12111','0643390639',NULL,'1','扫码查询',NULL),(106,29,0,100,2217,'石家庄赵四','nigulasizs','河北省石家庄市','2022-06-27 01:16:25',2,NULL,'CH2022062710210098','12111','0643390639',NULL,'1','扫码查询',NULL),(110,33,0,140,2239,'武汉源创诚德商贸有限公司','whyccdsmyxgs','河南省郑州市','2022-07-26 08:14:57',2,NULL,'CH2022072656545250','803217','5650155810',NULL,'1','扫码查询',NULL),(111,33,0,80,2241,'武汉天之乐建筑装饰材料有限公司','whtzljzzsclyxgs','河南省郑州市','2022-07-26 09:34:22',2,NULL,'CH2022072610110050','1532618','0084351934',NULL,'1','扫码查询',NULL),(112,33,0,80,2241,'武汉天之乐建筑装饰材料有限公司','whtzljzzsclyxgs','河南省郑州市','2022-07-26 09:35:48',2,NULL,'CH2022072610110050','1532618','0084351934',NULL,'1','扫码查询',NULL),(113,33,0,80,2241,'武汉天之乐建筑装饰材料有限公司','whtzljzzsclyxgs','江苏省南京市','2022-07-26 09:48:29',2,NULL,'CH2022072610110050','1532618','0084351934',NULL,'1','扫码查询',NULL),(114,33,0,80,2241,'武汉天之乐建筑装饰材料有限公司','whtzljzzsclyxgs','北京北京市','2022-07-26 10:04:07',2,NULL,'CH2022072610110050','1532618','0084351934',NULL,'1','扫码查询',NULL),(115,34,0,30,2382,'北京伟星','bjwx','河北省石家庄市','2022-08-24 02:35:16',2,NULL,'CH2022082497561001','58','0168934061',NULL,'1','扫码查询',NULL),(116,34,0,30,2382,'北京伟星','bjwx','河北省石家庄市','2022-08-24 03:55:20',2,NULL,'CH2022082497561001','58','0168934061',NULL,'1','扫码查询',NULL),(117,34,0,30,2382,'北京伟星','bjwx','河北省石家庄市','2022-08-24 03:55:47',2,NULL,'CH2022082497561001','58','0168934061',NULL,'1','扫码查询',NULL),(118,34,0,30,2382,'北京伟星','bjwx','河北省石家庄市','2022-08-24 04:18:00',2,NULL,'CH2022082497561001','58','0168934061',NULL,'1','扫码查询',NULL);
/*!40000 ALTER TABLE `ctc_dealer_logistics_ch_order` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ctc_dealer_logistics_ck_code`
--

DROP TABLE IF EXISTS `ctc_dealer_logistics_ck_code`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
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
) ENGINE=InnoDB AUTO_INCREMENT=140 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ctc_dealer_logistics_ck_code`
--

LOCK TABLES `ctc_dealer_logistics_ck_code` WRITE;
/*!40000 ALTER TABLE `ctc_dealer_logistics_ck_code` DISABLE KEYS */;
INSERT INTO `ctc_dealer_logistics_ck_code` VALUES (121,'4420892424','179',NULL,'202204081649407326',1,100,'CH2022041810157501','10cm','件','123456','直角弯头','2022-06-17 16:00:00','2022-04-17 16:00:00','001',13,25,2,1,'179','179','2022-04-17 20:28:02',0,NULL),(122,'1258413815','1478413',NULL,'202204081649409249',1,60,'CH2022041954979952','','','','伟星新材石家庄分公司-正品','2022-04-18 16:00:00','2022-04-18 16:00:00','WXZP',14,25,2,1,'1478413','1478413','2022-04-19 03:37:58',0,NULL),(123,'0675445609','10004',NULL,'202205261653533222',1,100,'CH2022052657555110','','','','伟星管道','2022-05-25 16:00:00','2022-05-25 16:00:00','wx',15,29,2,1,'10004','10004','2022-05-26 03:07:41',0,NULL),(127,'0000000001','1',NULL,'202206161655370332',1,6,'CH2022062055525250','','','','聚茂德烧坊酿酒','2022-06-19 16:00:00','2022-06-19 16:00:00','jiu',18,32,2,1,'1','1','2022-06-20 01:11:12',0,NULL),(128,'3591354370','10001',NULL,'202205261653533222',1,100,'CH2022062099495599','','','','伟星管道','2022-06-19 16:00:00','2022-06-19 16:00:00','wx',15,29,2,1,'10001','10001','2022-06-20 02:26:55',0,NULL),(129,'7798662288','10010',NULL,'202205261653533222',1,100,'CH2022062248515052','','','','牛栏山','2022-06-21 16:00:00','2022-06-21 16:00:00','wx',15,29,1,1,'10010','10010','2022-06-22 02:58:16',1,NULL),(130,'6115650101','10002',NULL,'202205261653533222',1,100,'CH2022062253979848','','','','十八酒坊','2022-06-21 16:00:00','2022-06-21 16:00:00','1',19,29,2,1,'10002','10002','2022-06-22 08:29:40',1,NULL),(131,'0643390639','12111',NULL,'202206271656292352',1,100,'CH2022062710210098','','','','十八酒坊','2022-06-26 16:00:00','2022-06-26 16:00:00','1',19,29,2,1,'12111','12111','2022-06-27 01:15:11',1,NULL),(132,'5764326812','12210',NULL,'202206271656292352',1,100,'CH2022070356535757','','','','十八酒坊','2022-07-02 16:00:00','2022-07-02 16:00:00','1',19,29,3,1,'12210','12210','2022-07-02 17:52:21',0,'2022-07-02 18:14:11'),(133,'2037102905','2965344',NULL,'202204081649410606',1,15,'CH2022070897524950','','','','伟星新材石家庄分公司-正品','2022-07-07 16:00:00','2022-07-07 16:00:00','WXZP',14,25,2,1,'2965344','2965344','2022-07-08 01:28:20',0,NULL),(134,'3886085695','2965343',NULL,'202204081649410606',1,15,'CH2022070897524950','','','','伟星新材石家庄分公司-正品','2022-07-07 16:00:00','2022-07-07 16:00:00','WXZP',14,25,2,1,'2965343','2965343','2022-07-08 01:31:44',0,NULL),(136,'5650155810','803217',NULL,'202206281656382276',1,140,'CH2022072656545250','','','','直通','2022-07-25 16:00:00','2022-07-25 16:00:00','ztD25',33,33,1,1,'803217','803217','2022-07-26 08:14:09',0,NULL),(137,'2445519188','608732',NULL,'202206281656381049',1,30,'CH2022072654565449','','','','截止阀','2022-07-25 16:00:00','2022-07-25 16:00:00','jzfD25',52,33,1,1,'608732','608732','2022-07-26 09:00:58',0,NULL),(138,'0084351934','1532618',NULL,'202206281656383066',1,80,'CH2022072610110050','','','','过桥四通','2022-07-25 16:00:00','2022-07-25 16:00:00','gqstD25',49,33,2,1,'1532618','1532618','2022-07-26 09:34:10',0,NULL),(139,'0168934061','58',NULL,'202208081659939689',1,30,'CH2022082497561001','','','','弯头','2022-08-23 16:00:00','2022-08-23 16:00:00','wt',68,34,2,1,'58','58','2022-08-24 02:35:04',0,NULL);
/*!40000 ALTER TABLE `ctc_dealer_logistics_ck_code` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ctc_dealer_logistics_ck_order`
--

DROP TABLE IF EXISTS `ctc_dealer_logistics_ck_order`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
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
  `create_by` varchar(255) DEFAULT NULL COMMENT '操作人',
  `order_type` tinyint(4) DEFAULT '0' COMMENT '发货单类型 1自建发货单 2在线订单发货 3客户自助',
  `is_del` tinyint(4) DEFAULT '0' COMMENT '是否删除0正常 1删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=143 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ctc_dealer_logistics_ck_order`
--

LOCK TABLES `ctc_dealer_logistics_ck_order` WRITE;
/*!40000 ALTER TABLE `ctc_dealer_logistics_ck_order` DISABLE KEYS */;
INSERT INTO `ctc_dealer_logistics_ck_order` VALUES (115,'CH2022041810157501','distributor',25,7,'jxs101','经销商101',4,0,NULL,NULL,NULL,'[{\"product_id\":13,\"product_name\":\"\\u76f4\\u89d2\\u5f2f\\u5934\",\"barcode\":\"123456\",\"unit\":\"\\u4ef6\",\"manufacture_time\":\"2022-04-18\",\"validity_time\":\"2022-06-18\",\"product_code\":\"001\",\"specifications\":\"10cm\",\"out_num\":100,\"order_num\":100}]','2022-04-17 20:28:02',NULL,0,NULL,100,100,2,NULL,0,0),(116,'CH2022041952539953','distributor',25,9,'zs','张三',5,0,'2022-04-18 16:00:00','','','[{\"product_name\":\"\\u76f4\\u89d2\\u5f2f\\u5934\",\"product_code\":\"001\",\"unit\":\"\\u4ef6\",\"product_id\":13,\"barcode\":\"123456\",\"specifications\":\"10cm\",\"out_num\":0,\"order_num\":\"400\"},{\"product_name\":\"\\u4f1f\\u661f\\u65b0\\u6750\\u77f3\\u5bb6\\u5e84\\u5206\\u516c\\u53f8-\\u6b63\\u54c1\",\"product_code\":\"WXZP\",\"unit\":\"\",\"product_id\":14,\"barcode\":\"\",\"specifications\":\"\",\"out_num\":0,\"order_num\":\"1000\"}]','2022-04-19 02:55:02',NULL,0,NULL,0,1400,1,NULL,1,0),(117,'CH2022041954979952','distributor',25,9,'zs','张三',4,0,NULL,NULL,NULL,'[{\"product_id\":14,\"product_name\":\"\\u4f1f\\u661f\\u65b0\\u6750\\u77f3\\u5bb6\\u5e84\\u5206\\u516c\\u53f8-\\u6b63\\u54c1\",\"barcode\":\"\",\"unit\":\"\",\"manufacture_time\":\"2022-04-19\",\"validity_time\":\"2022-04-19\",\"product_code\":\"WXZP\",\"specifications\":\"\",\"out_num\":60,\"order_num\":60}]','2022-04-19 03:37:58',NULL,0,NULL,60,60,2,NULL,0,0),(118,'CH2022052657555110','distributor',29,2217,'nigulasizs','石家庄赵四',6,0,NULL,NULL,NULL,'[{\"product_id\":15,\"product_name\":\"\\u4f1f\\u661f\\u7ba1\\u9053\",\"barcode\":\"\",\"unit\":\"\",\"manufacture_time\":\"2022-05-26\",\"validity_time\":\"2022-05-26\",\"product_code\":\"wx\",\"specifications\":\"\",\"out_num\":100,\"order_num\":100}]','2022-05-26 03:07:41',NULL,0,NULL,100,100,2,NULL,0,0),(123,'CH2022062055525250','distributor',32,2229,'sxjmd','山西聚茂德烧坊酿酒有限公司',10,0,NULL,NULL,NULL,'[{\"product_id\":18,\"product_name\":\"\\u805a\\u8302\\u5fb7\\u70e7\\u574a\\u917f\\u9152\",\"barcode\":\"\",\"unit\":\"\",\"manufacture_time\":\"2022-06-20\",\"validity_time\":\"2022-06-20\",\"product_code\":\"jiu\",\"specifications\":\"\",\"out_num\":6,\"order_num\":6}]','2022-06-20 01:11:12',NULL,0,NULL,6,6,2,NULL,0,0),(124,'CH2022062099495599','distributor',29,2220,'29_jxs1','经销商101',6,0,NULL,NULL,NULL,'[{\"product_id\":15,\"product_name\":\"\\u4f1f\\u661f\\u7ba1\\u9053\",\"barcode\":\"\",\"unit\":\"\",\"manufacture_time\":\"2022-06-20\",\"validity_time\":\"2022-06-20\",\"product_code\":\"wx\",\"specifications\":\"\",\"out_num\":100,\"order_num\":100}]','2022-06-20 02:26:55',NULL,0,NULL,100,100,2,NULL,0,0),(125,'CH2022062248515052','distributor',29,2219,'29_wh','文寒',6,0,'2022-06-21 16:00:00','','','[{\"product_name\":\"\\u725b\\u680f\\u5c71\",\"product_code\":\"wx\",\"unit\":\"\",\"product_id\":15,\"barcode\":\"\",\"specifications\":\"\",\"out_num\":100,\"order_num\":\"500\"}]','2022-06-22 02:48:42',NULL,0,NULL,100,500,1,NULL,1,0),(126,'CH2022062210249565','distributor',29,2220,'29_jxs1','经销商101',6,0,'2022-06-22 16:00:00','','','[{\"product_name\":\"\\u5341\\u516b\\u9152\\u574a\",\"product_code\":\"1\",\"unit\":\"\",\"product_id\":19,\"barcode\":\"\",\"specifications\":\"\",\"out_num\":0,\"order_num\":\"500\"},{\"product_name\":\"\\u725b\\u680f\\u5c71\",\"product_code\":\"wx\",\"unit\":\"\",\"product_id\":15,\"barcode\":\"\",\"specifications\":\"\",\"out_num\":0,\"order_num\":\"200\"}]','2022-06-22 07:43:07',NULL,0,NULL,0,700,1,NULL,1,1),(127,'CH2022062254495048','distributor',29,2221,'29_ww','王五',6,0,'2022-06-21 16:00:00','','','[{\"product_name\":\"\\u725b\\u680f\\u5c71\",\"product_code\":\"wx\",\"unit\":\"\",\"product_id\":15,\"barcode\":\"\",\"specifications\":\"\",\"out_num\":0,\"order_num\":\"1000\"}]','2022-06-22 08:10:00',NULL,0,NULL,0,1000,1,NULL,1,1),(128,'CH2022062256975698','distributor',29,2220,'29_jxs1','经销商101',6,0,'2022-06-24 16:00:00','','','[{\"product_name\":\"\\u725b\\u680f\\u5c71\",\"product_code\":\"wx\",\"unit\":\"\",\"product_id\":15,\"barcode\":\"\",\"specifications\":\"\",\"out_num\":0,\"order_num\":\"500\"}]','2022-06-22 08:27:37',NULL,0,NULL,0,500,1,NULL,1,1),(129,'CH2022062253979848','distributor',29,2217,'nigulasizs','石家庄赵四',6,0,NULL,NULL,NULL,'[{\"product_id\":19,\"product_name\":\"\\u5341\\u516b\\u9152\\u574a\",\"barcode\":\"\",\"unit\":\"\",\"manufacture_time\":\"2022-06-22\",\"validity_time\":\"2022-06-22\",\"product_code\":\"1\",\"specifications\":\"\",\"out_num\":100,\"order_num\":100}]','2022-06-22 08:29:40',NULL,0,NULL,100,100,2,NULL,0,0),(130,'CH2022062253101525','distributor',29,2220,'29_jxs1','经销商101',6,0,'2022-06-21 16:00:00','','','[{\"product_name\":\"\\u5341\\u516b\\u9152\\u574a\",\"product_code\":\"1\",\"unit\":\"\",\"product_id\":19,\"barcode\":\"\",\"specifications\":\"\",\"out_num\":0,\"order_num\":\"500\"}]','2022-06-22 08:32:55',NULL,0,NULL,0,500,1,NULL,1,0),(131,'CH2022062710210098','distributor',29,2217,'nigulasizs','石家庄赵四',6,0,NULL,NULL,NULL,'[{\"product_id\":19,\"product_name\":\"\\u5341\\u516b\\u9152\\u574a\",\"barcode\":\"\",\"unit\":\"\",\"manufacture_time\":\"2022-06-27\",\"validity_time\":\"2022-06-27\",\"product_code\":\"1\",\"specifications\":\"\",\"out_num\":100,\"order_num\":100}]','2022-06-27 01:15:11',NULL,0,NULL,100,100,2,NULL,0,0),(132,'CH2022062798549952','distributor',29,2220,'29_jxs1','经销商101',6,0,'2022-06-26 16:00:00','','','[{\"product_name\":\"\\u5341\\u516b\\u9152\\u574a\",\"product_code\":\"1\",\"unit\":\"\",\"product_id\":19,\"barcode\":\"\",\"specifications\":\"\",\"out_num\":0,\"order_num\":\"100\"}]','2022-06-27 01:22:08',NULL,0,NULL,0,100,1,NULL,1,0),(133,'CH2022070353505249','distributor',29,2219,'29_wh','文寒',6,0,NULL,NULL,NULL,'[]','2022-07-02 17:52:21',NULL,0,NULL,0,0,2,NULL,0,0),(134,'CH2022070356535757','distributor',29,2219,'29_wh','文寒',6,0,NULL,NULL,NULL,'[{\"product_id\":19,\"product_name\":\"\\u5341\\u516b\\u9152\\u574a\",\"barcode\":\"\",\"unit\":\"\",\"product_code\":\"1\",\"specifications\":\"\",\"out_num\":100,\"order_num\":100}]','2022-07-02 18:14:11',NULL,0,NULL,100,100,3,NULL,0,0),(135,'CH2022070897524950','distributor',25,256,'15075118500','左鸿康',4,0,NULL,NULL,NULL,'[{\"product_id\":14,\"product_name\":\"\\u4f1f\\u661f\\u65b0\\u6750\\u77f3\\u5bb6\\u5e84\\u5206\\u516c\\u53f8-\\u6b63\\u54c1\",\"barcode\":\"\",\"unit\":\"\",\"manufacture_time\":\"2022-07-08\",\"validity_time\":\"2022-07-08\",\"product_code\":\"WXZP\",\"specifications\":\"\",\"out_num\":30,\"order_num\":30}]','2022-07-08 01:28:20',NULL,0,NULL,30,30,2,NULL,0,0),(136,'CH2022070848494948','distributor',25,2230,'5880055','黑龙江德谦建筑材料有限公司',11,0,'2022-07-07 16:00:00','','','[{\"product_name\":\"\\u51b7\\u70ed\\u6c34\\u7ba1S3.2\",\"product_code\":\"lrsg\",\"unit\":null,\"product_id\":23,\"barcode\":null,\"specifications\":null,\"out_num\":0,\"order_num\":\"400\"},{\"product_name\":\"90\\u5ea6\\u5f2f\\u5934\",\"product_code\":\"wt11\",\"unit\":\"\",\"product_id\":22,\"barcode\":\"\",\"specifications\":\"\",\"out_num\":0,\"order_num\":\"300\"}]','2022-07-08 02:46:57',NULL,0,NULL,0,700,1,NULL,1,0),(138,'CH2022072656545250','distributor',33,2239,'whyccdsmyxgs','武汉源创诚德商贸有限公司',12,0,'2022-07-25 16:00:00','','','[{\"product_name\":\"\\u9634\\u87ba\\u7eb9\\u5f2f\\u5934\",\"product_code\":\"ylwwtD20*1\\/2\",\"unit\":\"\",\"product_id\":55,\"barcode\":\"\",\"specifications\":\"\",\"out_num\":0,\"order_num\":\"80\",\"customer_name\":\"\\u6b66\\u6c49\\u6e90\\u521b\\u8bda\\u5fb7\\u5546\\u8d38\\u6709\\u9650\\u516c\\u53f8\"},{\"product_name\":\"\\u7b49\\u5f84\\u4e09\\u901a\",\"product_code\":\"djstD25\",\"unit\":\"\",\"product_id\":64,\"barcode\":\"\",\"specifications\":\"\",\"out_num\":0,\"order_num\":\"140\",\"customer_name\":\"\\u6b66\\u6c49\\u6e90\\u521b\\u8bda\\u5fb7\\u5546\\u8d38\\u6709\\u9650\\u516c\\u53f8\"},{\"product_name\":\"\\u76f4\\u901a\",\"product_code\":\"ztD25\",\"unit\":\"\",\"product_id\":33,\"barcode\":\"\",\"specifications\":\"\",\"out_num\":140,\"order_num\":\"140\"}]','2022-07-26 07:33:35',NULL,0,NULL,140,360,1,NULL,1,0),(139,'CH2022072654565449','distributor',33,2240,'whshsqhcjcjjb','武汉市洪山区宏成建材经营部',12,0,'2022-07-25 16:00:00','','','[{\"product_name\":\"\\u7b49\\u5f84\\u4e09\\u901a\",\"product_code\":\"djstD25\",\"unit\":\"\",\"product_id\":64,\"barcode\":\"\",\"specifications\":\"\",\"out_num\":0,\"order_num\":\"10\",\"customer_name\":\"\\u6b66\\u6c49\\u5e02\\u6d2a\\u5c71\\u533a\\u5b8f\\u6210\\u5efa\\u6750\\u7ecf\\u8425\\u90e8\"},{\"product_name\":\"\\u622a\\u6b62\\u9600\",\"product_code\":\"jzfD25\",\"unit\":\"\",\"product_id\":52,\"barcode\":\"\",\"specifications\":\"\",\"out_num\":30,\"order_num\":\"30\",\"customer_name\":\"\\u6b66\\u6c49\\u5e02\\u6d2a\\u5c71\\u533a\\u5b8f\\u6210\\u5efa\\u6750\\u7ecf\\u8425\\u90e8\"}]','2022-07-26 08:56:08',NULL,0,NULL,30,40,1,NULL,1,0),(140,'CH2022072697545451','distributor',33,2241,'whtzljzzsclyxgs','武汉天之乐建筑装饰材料有限公司',12,0,'2022-07-25 16:00:00','','','[{\"product_name\":\"90\\u5ea6\\u5f2f\\u5934\",\"product_code\":\"90dwtD20\",\"unit\":\"\",\"product_id\":63,\"barcode\":\"\",\"specifications\":\"\",\"out_num\":0,\"order_num\":\"170\"}]','2022-07-26 09:29:28',NULL,0,NULL,0,170,1,NULL,1,0),(141,'CH2022072610110050','distributor',33,2241,'whtzljzzsclyxgs','武汉天之乐建筑装饰材料有限公司',12,0,NULL,NULL,NULL,'[{\"product_id\":49,\"product_name\":\"\\u8fc7\\u6865\\u56db\\u901a\",\"barcode\":\"\",\"unit\":\"\",\"manufacture_time\":\"2022-07-26\",\"validity_time\":\"2022-07-26\",\"product_code\":\"gqstD25\",\"specifications\":\"\",\"out_num\":80,\"order_num\":80}]','2022-07-26 09:34:10',NULL,0,NULL,80,80,2,NULL,0,0),(142,'CH2022082497561001','distributor',34,2382,'bjwx','北京伟星',13,0,NULL,NULL,NULL,'[{\"product_id\":68,\"product_name\":\"\\u5f2f\\u5934\",\"barcode\":\"\",\"unit\":\"\",\"manufacture_time\":\"2022-08-24\",\"validity_time\":\"2022-08-24\",\"product_code\":\"wt\",\"specifications\":\"\",\"out_num\":30,\"order_num\":30}]','2022-08-24 02:35:04',NULL,0,NULL,30,30,2,NULL,0,0);
/*!40000 ALTER TABLE `ctc_dealer_logistics_ck_order` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ctc_dealer_logistics_dc_code`
--

DROP TABLE IF EXISTS `ctc_dealer_logistics_dc_code`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ctc_dealer_logistics_dc_code` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `code` varchar(255) DEFAULT NULL COMMENT '入库码',
  `serial_number` varchar(255) DEFAULT NULL COMMENT '码对应的序号',
  `product_batch` varchar(255) DEFAULT NULL COMMENT '生产批次',
  `batch` varchar(255) DEFAULT NULL COMMENT '码批次',
  `code_type` tinyint(4) DEFAULT NULL COMMENT '标签类型 1大标 2小标',
  `dc_num` int(11) DEFAULT NULL COMMENT '入库数量 为了统计用',
  `dc_order` varchar(255) DEFAULT NULL COMMENT '入库单',
  `specifications` varchar(255) DEFAULT NULL COMMENT '产品规格',
  `unit` varchar(255) DEFAULT NULL,
  `barcode` varchar(255) DEFAULT NULL COMMENT '产品条码',
  `product_name` varchar(255) DEFAULT NULL,
  `validity_time` timestamp NULL DEFAULT NULL COMMENT '有效期',
  `manufacture_time` timestamp NULL DEFAULT NULL COMMENT '生产日期',
  `product_code` varchar(255) DEFAULT NULL,
  `product_id` int(11) DEFAULT NULL,
  `dealer_id` int(11) DEFAULT NULL,
  `order_start` varchar(255) DEFAULT NULL,
  `order_end` varchar(255) DEFAULT NULL,
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ctc_dealer_logistics_dc_code`
--

LOCK TABLES `ctc_dealer_logistics_dc_code` WRITE;
/*!40000 ALTER TABLE `ctc_dealer_logistics_dc_code` DISABLE KEYS */;
/*!40000 ALTER TABLE `ctc_dealer_logistics_dc_code` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ctc_dealer_logistics_dc_order`
--

DROP TABLE IF EXISTS `ctc_dealer_logistics_dc_order`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ctc_dealer_logistics_dc_order`
--

LOCK TABLES `ctc_dealer_logistics_dc_order` WRITE;
/*!40000 ALTER TABLE `ctc_dealer_logistics_dc_order` DISABLE KEYS */;
/*!40000 ALTER TABLE `ctc_dealer_logistics_dc_order` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ctc_dealer_logistics_op_log`
--

DROP TABLE IF EXISTS `ctc_dealer_logistics_op_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ctc_dealer_logistics_op_log` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `batch` varchar(255) DEFAULT NULL COMMENT '码批次',
  `code` varchar(255) DEFAULT NULL COMMENT '物流码',
  `op_type` varchar(255) DEFAULT NULL COMMENT '处理方式',
  `op_des` varchar(255) DEFAULT NULL COMMENT '处理详情',
  `dealer_id` int(11) DEFAULT NULL,
  `create_by` varchar(255) DEFAULT NULL COMMENT '操作人',
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `order_start` varchar(255) DEFAULT NULL,
  `order_end` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=52 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ctc_dealer_logistics_op_log`
--

LOCK TABLES `ctc_dealer_logistics_op_log` WRITE;
/*!40000 ALTER TABLE `ctc_dealer_logistics_op_log` DISABLE KEYS */;
INSERT INTO `ctc_dealer_logistics_op_log` VALUES (28,'202204081649407326','4420892424','快速出库','出库单CH2022041810157501物流码快速出库',25,NULL,'2022-04-17 20:28:02',NULL,NULL),(29,'202204081649409249','1258413815','快速出库','出库单CH2022041954979952物流码快速出库',25,NULL,'2022-04-19 03:37:58',NULL,NULL),(30,'202205261653533222','0675445609','快速出库','出库单CH2022052657555110物流码快速出库',29,NULL,'2022-05-26 03:07:41',NULL,NULL),(34,'202206161655370332','0000000001','快速出库','出库单CH2022062055525250物流码快速出库',32,NULL,'2022-06-20 01:11:12',NULL,NULL),(35,'202205261653533222','3591354370','快速出库','出库单CH2022062099495599物流码快速出库',29,NULL,'2022-06-20 02:26:55',NULL,NULL),(36,'202205261653533222','7798662288','直接入库','入库单RK2022062255555354物流码扫描入库',29,NULL,'2022-06-22 02:50:15',NULL,NULL),(37,'202205261653533222','7798662288','扫码出库','出库单CH2022062248515052物流码扫描出库',29,NULL,'2022-06-22 02:58:16',NULL,NULL),(38,'202205261653533222','6115650101','快速出库','出库单CH2022062253979848物流码快速出库',29,NULL,'2022-06-22 08:29:40',NULL,NULL),(39,'202206271656292352','0643390639','快速出库','出库单CH2022062710210098物流码快速出库',29,NULL,'2022-06-27 01:15:11',NULL,NULL),(40,'202206271656292352','5764326812','快速出库','出库单CH2022070353505249物流码快速出库',29,NULL,'2022-07-02 17:52:21',NULL,NULL),(41,'202206271656292352','5764326812','已入库商品出库出库','出库单CH2022070356535757物流码直接出库',29,NULL,'2022-07-02 18:14:11',NULL,NULL),(42,'202204081649410606','2037102905','快速出库','出库单CH2022070897524950物流码快速出库',25,NULL,'2022-07-08 01:28:20',NULL,NULL),(43,'202204081649410606','3886085695','快速出库','出库单CH2022070897524950物流码快速出库',25,NULL,'2022-07-08 01:31:44',NULL,NULL),(45,'202206281656382276','5650155810','直接入库','入库单RK2022072657971019物流码扫描入库',33,NULL,'2022-07-26 08:14:01',NULL,NULL),(46,'202206281656382276','5650155810','扫码出库','出库单CH2022072656545250物流码扫描出库',33,NULL,'2022-07-26 08:14:09',NULL,NULL),(47,'202206281656382147','4782807930','直接入库','入库单RK2022072656975310物流码扫描入库',33,NULL,'2022-07-26 08:46:23',NULL,NULL),(48,'202206281656381049','2445519188','直接入库','入库单RK2022072698985298物流码扫描入库',33,NULL,'2022-07-26 08:52:06',NULL,NULL),(49,'202206281656381049','2445519188','扫码出库','出库单CH2022072654565449物流码扫描出库',33,NULL,'2022-07-26 09:00:58',NULL,NULL),(50,'202206281656383066','0084351934','快速出库','出库单CH2022072610110050物流码快速出库',33,NULL,'2022-07-26 09:34:10',NULL,NULL),(51,'202208081659939689','0168934061','快速出库','出库单CH2022082497561001物流码快速出库',34,NULL,'2022-08-24 02:35:04',NULL,NULL);
/*!40000 ALTER TABLE `ctc_dealer_logistics_op_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ctc_dealer_logistics_query_log`
--

DROP TABLE IF EXISTS `ctc_dealer_logistics_query_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ctc_dealer_logistics_query_log` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `dealer_id` int(11) DEFAULT NULL,
  `code` varchar(255) DEFAULT NULL,
  `batch` varchar(255) DEFAULT NULL,
  `address` varchar(255) DEFAULT NULL COMMENT '查询地点',
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `serial_number` varchar(255) DEFAULT NULL,
  `member_id` int(11) DEFAULT NULL COMMENT '查询成员',
  `is_first` tinyint(4) DEFAULT '0' COMMENT '是否第一次查询0否 1是',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=179 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ctc_dealer_logistics_query_log`
--

LOCK TABLES `ctc_dealer_logistics_query_log` WRITE;
/*!40000 ALTER TABLE `ctc_dealer_logistics_query_log` DISABLE KEYS */;
INSERT INTO `ctc_dealer_logistics_query_log` VALUES (102,25,'4420892424','202204081649407326','河北省石家庄市','2022-04-17 20:28:52',NULL,NULL,1),(103,25,'4420892424','202204081649407326','河北省石家庄市','2022-04-18 02:34:22',NULL,NULL,0),(104,25,'1258413815','202204081649409249','河北省石家庄市','2022-04-19 03:02:44',NULL,NULL,1),(105,25,'1258413815','202204081649409249','河北省石家庄市','2022-04-19 03:38:30',NULL,NULL,0),(106,25,'1258413815','202204081649409249','河北省石家庄市','2022-04-19 03:40:55',NULL,NULL,0),(107,25,'8015524202','202204081649407326','河北省石家庄市','2022-04-23 13:43:25',NULL,NULL,1),(108,29,'0675445609','202205261653533222','河北省石家庄市','2022-05-26 03:08:45',NULL,NULL,1),(109,29,'0675445609','202205261653533222','河北省石家庄市','2022-05-26 03:21:48',NULL,NULL,0),(110,29,'0675445609','202205261653533222','河北省石家庄市','2022-05-26 03:21:56',NULL,NULL,0),(111,29,'0675445609','202205261653533222','湖北省武汉市','2022-05-27 09:31:17',NULL,NULL,0),(112,29,'0675445609','202205261653533222','湖北省武汉市','2022-05-27 09:38:50',NULL,NULL,0),(113,29,'3591354370','202205261653533222','河北省石家庄市','2022-06-08 01:22:50',NULL,NULL,1),(119,32,'5354702552','202206161655370332','河北省石家庄市','2022-06-18 17:32:16',NULL,NULL,1),(120,32,'5354702552','202206161655370332','河北省石家庄市','2022-06-18 17:35:32',NULL,NULL,0),(121,32,'5354702552','202206161655370332','河北省石家庄市','2022-06-18 17:36:23',NULL,NULL,0),(122,32,'5354702552','202206161655370332','河北省石家庄市','2022-06-18 17:40:31',NULL,NULL,0),(123,28,'7478632117','202205241653356960','河北省石家庄市','2022-06-18 17:59:51',NULL,NULL,1),(124,28,'7478632117','202205241653356960','河北省石家庄市','2022-06-18 18:00:20',NULL,NULL,0),(125,32,'5354702552','202206161655370332','河北省石家庄市','2022-06-18 18:00:50',NULL,NULL,0),(126,32,'64460442580','202206161655370332','河北省石家庄市','2022-06-18 18:01:19',NULL,NULL,1),(127,32,'0000000001','202206161655370332','河北省石家庄市','2022-06-20 01:11:33',NULL,NULL,1),(128,32,'63440764595','202206161655370332','河北省石家庄市','2022-06-20 01:12:07',NULL,NULL,1),(129,29,'3591354370','202205261653533222','河北省石家庄市','2022-06-20 02:26:07',NULL,NULL,0),(130,29,'3591354370','202205261653533222','河北省石家庄市','2022-06-20 02:31:32',NULL,NULL,0),(131,29,'3591354370','202205261653533222','河北省石家庄市','2022-06-22 02:24:49',NULL,NULL,0),(132,29,'3591354370','202205261653533222','河北省石家庄市','2022-06-22 02:34:55',NULL,NULL,0),(133,29,'3591354370','202205261653533222','河北省石家庄市','2022-06-22 07:53:41',NULL,NULL,0),(134,29,'7798662288','202205261653533222','河北省石家庄市','2022-06-22 07:54:10',NULL,NULL,1),(135,29,'7798662288','202205261653533222','河北省石家庄市','2022-06-22 07:55:08',NULL,NULL,0),(136,29,'3591354370','202205261653533222','河北省石家庄市','2022-06-22 07:57:22',NULL,NULL,0),(137,29,'7798662288','202205261653533222','河北省石家庄市','2022-06-22 08:00:12',NULL,NULL,0),(138,29,'7798662288','202205261653533222','河北省石家庄市','2022-06-22 08:01:09',NULL,NULL,0),(139,29,'7798662288','202205261653533222','河北省石家庄市','2022-06-22 08:01:36',NULL,NULL,0),(140,29,'7798662288','202205261653533222','河北省石家庄市','2022-06-22 08:06:50',NULL,NULL,0),(141,29,'7798662288','202205261653533222','河北省石家庄市','2022-06-22 08:07:21',NULL,NULL,0),(142,29,'7798662288','202205261653533222','河北省石家庄市','2022-06-22 08:08:45',NULL,NULL,0),(143,29,'7798662288','202205261653533222','河北省石家庄市','2022-06-22 08:14:36',NULL,NULL,0),(144,29,'7798662288','202205261653533222','河北省石家庄市','2022-06-22 08:15:46',NULL,NULL,0),(145,29,'6115650101','202205261653533222','河北省石家庄市','2022-06-22 08:32:14',NULL,NULL,1),(146,29,'3591354370','202205261653533222','河北省石家庄市','2022-06-22 08:42:35',NULL,NULL,0),(147,29,'6115650101','202205261653533222','河北省石家庄市','2022-06-22 08:43:50',NULL,NULL,0),(148,29,'6115650101','202205261653533222','河北省石家庄市','2022-06-22 08:44:13',NULL,NULL,0),(149,29,'6115650101','202205261653533222','河北省石家庄市','2022-06-22 08:45:09',NULL,NULL,0),(150,29,'0643390639','202206271656292352','河北省石家庄市','2022-06-27 01:15:34',NULL,NULL,1),(151,29,'0643390639','202206271656292352','河北省石家庄市','2022-06-27 01:16:29',NULL,NULL,0),(152,29,'0643390639','202206271656292352','河北省石家庄市','2022-06-27 01:17:39',NULL,NULL,0),(153,29,'0643390639','202206271656292352','河北省石家庄市','2022-06-27 01:19:03',NULL,NULL,0),(154,29,'0643390639','202206271656292352','河北省石家庄市','2022-06-27 01:22:59',NULL,NULL,0),(155,29,'0643390639','202206271656292352','河北省石家庄市','2022-06-27 01:23:21',NULL,NULL,0),(156,25,'2037102905','202204081649410606','黑龙江省哈尔滨市','2022-07-08 01:28:59',NULL,NULL,1),(157,25,'42302800467','202204081649410606','黑龙江省哈尔滨市','2022-07-08 01:31:44',NULL,NULL,1),(158,25,'62803937732','202204081649410606','黑龙江省哈尔滨市','2022-07-08 01:31:49',NULL,NULL,1),(159,25,'221597782412','202204081649410606','黑龙江省哈尔滨市','2022-07-08 01:31:56',NULL,NULL,1),(160,25,'3886085695','202204081649410606','黑龙江省哈尔滨市','2022-07-08 01:32:03',NULL,NULL,1),(161,25,'17322616799','202204081649410606','黑龙江省哈尔滨市','2022-07-08 01:32:07',NULL,NULL,1),(162,25,'34176834395','202204081649410606','黑龙江省哈尔滨市','2022-07-08 01:32:08',NULL,NULL,1),(163,25,'355271663237','202204081649410606','黑龙江省哈尔滨市','2022-07-08 01:32:18',NULL,NULL,1),(164,25,'14428619878','202204081649410606','黑龙江省哈尔滨市','2022-07-08 01:32:30',NULL,NULL,1),(165,25,'3886085695','202204081649410606','黑龙江省哈尔滨市','2022-07-08 01:33:00',NULL,NULL,0),(166,25,'42302800467','202204081649410606','黑龙江省哈尔滨市','2022-07-08 01:33:04',NULL,NULL,0),(167,25,'45292878262','202204081649410606','黑龙江省哈尔滨市','2022-07-08 01:33:19',NULL,NULL,1),(168,25,'69617500119','202204081649410606','黑龙江省哈尔滨市','2022-07-08 01:33:40',NULL,NULL,1),(169,25,'3886085695','202204081649410606','黑龙江省哈尔滨市','2022-07-08 01:33:58',NULL,NULL,0),(170,25,'3925706184','202204081649410606','黑龙江省哈尔滨市','2022-07-08 02:15:01',NULL,NULL,1),(173,33,'5650155810','202206281656382276','河南省郑州市','2022-07-26 08:15:01',NULL,NULL,1),(174,33,'21183412109','202206281656382147','河南省郑州市','2022-07-26 09:02:34',NULL,NULL,1),(175,33,'0084351934','202206281656383066','河南省郑州市','2022-07-26 09:34:31',NULL,NULL,1),(176,33,'0084351934','202206281656383066','河南省郑州市','2022-07-26 09:35:52',NULL,NULL,0),(177,34,'0168934061','202208081659939689','河北省石家庄市','2022-08-24 01:43:16',NULL,NULL,1),(178,34,'0168934061','202208081659939689','河北省石家庄市','2022-08-24 02:35:21',NULL,NULL,0);
/*!40000 ALTER TABLE `ctc_dealer_logistics_query_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ctc_dealer_logistics_replace_code`
--

DROP TABLE IF EXISTS `ctc_dealer_logistics_replace_code`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ctc_dealer_logistics_replace_code` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `origin_code` varchar(255) DEFAULT NULL,
  `origin_batch` varchar(255) DEFAULT NULL,
  `cur_code` varchar(255) DEFAULT NULL,
  `cur_batch` varchar(255) DEFAULT NULL,
  `dealer_id` int(11) DEFAULT NULL,
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ctc_dealer_logistics_replace_code`
--

LOCK TABLES `ctc_dealer_logistics_replace_code` WRITE;
/*!40000 ALTER TABLE `ctc_dealer_logistics_replace_code` DISABLE KEYS */;
/*!40000 ALTER TABLE `ctc_dealer_logistics_replace_code` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ctc_dealer_logistics_rk_code`
--

DROP TABLE IF EXISTS `ctc_dealer_logistics_rk_code`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
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
) ENGINE=InnoDB AUTO_INCREMENT=277 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ctc_dealer_logistics_rk_code`
--

LOCK TABLES `ctc_dealer_logistics_rk_code` WRITE;
/*!40000 ALTER TABLE `ctc_dealer_logistics_rk_code` DISABLE KEYS */;
INSERT INTO `ctc_dealer_logistics_rk_code` VALUES (257,'4420892424','179',NULL,'202204081649407326',1,100,'RK2022041810157481',13,'123456','001','件','10cm','直角弯头',25,1,'179','179','2022-04-17 20:28:02'),(258,'1258413815','1478413',NULL,'202204081649409249',1,60,'RK2022041954100985',14,'','WXZP','','','伟星新材石家庄分公司-正品',25,1,'1478413','1478413','2022-04-19 03:37:58'),(259,'0675445609','10004',NULL,'202205261653533222',1,100,'RK2022052657565457',15,'','wx','','','伟星管道',29,1,'10004','10004','2022-05-26 03:07:41'),(263,'0000000001','1',NULL,'202206161655370332',1,6,'RK2022062055521015',18,'','jiu','','','聚茂德烧坊酿酒',32,1,'1','1','2022-06-20 01:11:12'),(264,'3591354370','10001',NULL,'202205261653533222',1,100,'RK2022062099505299',15,'','wx','','','伟星管道',29,1,'10001','10001','2022-06-20 02:26:54'),(265,'7798662288','10010',NULL,'202205261653533222',1,100,'RK2022062255555354',15,'','wx','','','牛栏山',29,1,'10010','10010','2022-06-22 02:50:15'),(266,'6115650101','10002',NULL,'202205261653533222',1,100,'RK2022062253985510',19,'','1','','','十八酒坊',29,1,'10002','10002','2022-06-22 08:29:40'),(267,'0643390639','12111',NULL,'202206271656292352',1,100,'RK2022062710210157',19,'','1','','','十八酒坊',29,1,'12111','12111','2022-06-27 01:15:11'),(268,'5764326812','12210',NULL,'202206271656292352',1,100,'RK2022070353505149',19,'','1','','','十八酒坊',29,1,'12210','12210','2022-07-02 17:52:20'),(269,'2037102905','2965344',NULL,'202204081649410606',1,15,'RK2022070897525510',14,'','WXZP','','','伟星新材石家庄分公司-正品',25,1,'2965344','2965344','2022-07-08 01:28:20'),(270,'3886085695','2965343',NULL,'202204081649410606',1,15,'RK2022070897525510',14,'','WXZP','','','伟星新材石家庄分公司-正品',25,1,'2965343','2965343','2022-07-08 01:31:44'),(272,'5650155810','803217',NULL,'202206281656382276',1,140,'RK2022072657971019',33,'','ztD25','','','直通',33,1,'803217','803217','2022-07-26 08:14:01'),(273,'4782807930','699893',NULL,'202206281656382147',1,70,'RK2022072656975310',64,'','djstD25','','','等径三通',33,1,'699893','699893','2022-07-26 08:46:23'),(274,'2445519188','608732',NULL,'202206281656381049',1,30,'RK2022072698985298',52,'','jzfD25','','','截止阀',33,1,'608732','608732','2022-07-26 08:52:06'),(275,'0084351934','1532618',NULL,'202206281656383066',1,80,'RK2022072610248564',49,'','gqstD25','','','过桥四通',33,1,'1532618','1532618','2022-07-26 09:34:10'),(276,'0168934061','58',NULL,'202208081659939689',1,30,'RK2022082497975452',68,'','wt','','','弯头',34,1,'58','58','2022-08-24 02:35:04');
/*!40000 ALTER TABLE `ctc_dealer_logistics_rk_code` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ctc_dealer_logistics_rk_order`
--

DROP TABLE IF EXISTS `ctc_dealer_logistics_rk_order`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
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
  `create_by` varchar(255) DEFAULT NULL COMMENT '操作人',
  `scan_type` tinyint(4) DEFAULT NULL COMMENT '入库扫描 扫码方式 1单码扫描 2流水区间',
  `rk_type` tinyint(4) DEFAULT '1' COMMENT '入库方式1直接添加 2入库扫描',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=249 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ctc_dealer_logistics_rk_order`
--

LOCK TABLES `ctc_dealer_logistics_rk_order` WRITE;
/*!40000 ALTER TABLE `ctc_dealer_logistics_rk_order` DISABLE KEYS */;
INSERT INTO `ctc_dealer_logistics_rk_order` VALUES (230,'RK2022041810157481',NULL,'件','123456','10cm','直角弯头','001',13,NULL,100,'100','2022-04-18','2022-06-18',4,25,0,NULL,'2022-04-17 20:28:02',NULL,NULL,1),(231,'RK2022041954100985',NULL,'','','','伟星新材石家庄分公司-正品','WXZP',14,NULL,60,'60','2022-04-19','2022-04-19',4,25,0,NULL,'2022-04-19 03:37:58',NULL,NULL,1),(232,'RK2022052657565457',NULL,'','','','伟星管道','wx',15,NULL,100,'100','2022-05-26','2022-05-26',6,29,0,NULL,'2022-05-26 03:07:41',NULL,NULL,1),(236,'RK2022062055521015',NULL,'','','','聚茂德烧坊酿酒','jiu',18,NULL,6,'6','2022-06-20','2022-06-20',10,32,0,NULL,'2022-06-20 01:11:12',NULL,NULL,1),(237,'RK2022062099505299',NULL,'','','','伟星管道','wx',15,NULL,100,'100','2022-06-20','2022-06-20',6,29,0,NULL,'2022-06-20 02:26:54',NULL,NULL,1),(238,'RK2022062255555354',NULL,'','','','牛栏山','wx',15,NULL,100,'100','2022-06-22','2022-06-22',6,29,0,NULL,'2022-06-22 02:50:15',NULL,1,1),(239,'RK2022062253985510',NULL,'','','','十八酒坊','1',19,NULL,100,'100','2022-06-22','2022-06-22',6,29,0,NULL,'2022-06-22 08:29:40',NULL,NULL,1),(240,'RK2022062710210157',NULL,'','','','十八酒坊','1',19,NULL,100,'100','2022-06-27','2022-06-27',6,29,0,NULL,'2022-06-27 01:15:11',NULL,NULL,1),(241,'RK2022070353505149',NULL,'','','','十八酒坊','1',19,NULL,100,'100','2022-07-03','2022-07-03',6,29,0,NULL,'2022-07-02 17:52:20',NULL,NULL,1),(242,'RK2022070897525510',NULL,'','','','伟星新材石家庄分公司-正品','WXZP',14,NULL,30,'30','2022-07-08','2022-07-08',4,25,0,NULL,'2022-07-08 01:28:20',NULL,NULL,1),(244,'RK2022072657971019',NULL,'','','','直通','ztD25',33,NULL,140,'140','2022-07-26','2022-07-26',12,33,0,NULL,'2022-07-26 08:14:01',NULL,1,1),(245,'RK2022072656975310',NULL,'','','','等径三通','djstD25',64,NULL,70,'70','2022-07-26','2022-07-26',12,33,0,NULL,'2022-07-26 08:46:23',NULL,1,1),(246,'RK2022072698985298',NULL,'','','','截止阀','jzfD25',52,NULL,30,'30','2022-07-26','2022-07-26',12,33,0,NULL,'2022-07-26 08:52:06',NULL,1,1),(247,'RK2022072610248564',NULL,'','','','过桥四通','gqstD25',49,NULL,80,'80','2022-07-26','2022-07-26',12,33,0,NULL,'2022-07-26 09:34:10',NULL,NULL,1),(248,'RK2022082497975452',NULL,'','','','弯头','wt',68,NULL,30,'30','2022-08-24','2022-08-24',13,34,0,NULL,'2022-08-24 02:35:04',NULL,NULL,1);
/*!40000 ALTER TABLE `ctc_dealer_logistics_rk_order` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ctc_dealer_logistics_template`
--

DROP TABLE IF EXISTS `ctc_dealer_logistics_template`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ctc_dealer_logistics_template` (
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
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ctc_dealer_logistics_template`
--

LOCK TABLES `ctc_dealer_logistics_template` WRITE;
/*!40000 ALTER TABLE `ctc_dealer_logistics_template` DISABLE KEYS */;
INSERT INTO `ctc_dealer_logistics_template` VALUES (2,'','','202204081649410496','智能物流','2','[{\"url\":\"https:\\/\\/cdn.icloudapi.cn\\/34999202204121521583467.jpg\",\"name\":\"34999202204121521583467.jpg\"}]','[{\"url\":\"https:\\/\\/cdn.icloudapi.cn\\/a6f00202204121705507814.jpg\",\"name\":\"a6f00202204121705507814.jpg\",\"link\":\"\"},{\"url\":\"https:\\/\\/cdn.icloudapi.cn\\/fa13d202204121705345365.jpg\",\"name\":\"fa13d202204121705345365.jpg\",\"link\":\"\"},{\"url\":\"https:\\/\\/cdn.icloudapi.cn\\/6bcd720220412170522886.jpg\",\"name\":\"6bcd720220412170522886.jpg\",\"link\":\"\"}]','[{\"title\":\"\\u4ea7\\u54c1\",\"is_show\":1},{\"title\":\"\\u7269\\u6d41\",\"is_show\":1},{\"title\":\"\\u4f01\\u4e1a\",\"is_show\":1}]','查询记录','当前溯源码为首次查询，感谢您的查询！','当前溯源码为第@次@次查询，感谢您的查询！','当前溯源码为首次查询，感谢您的查询！','当前溯源码为第@次@次查询，感谢您的查询！',0,1,'物流信息','防伪认证','您好，您所查询的是@品牌商名称@生产的产品，请放心使用！','该防伪码已经被人查询过，首次查询时间：@查询时间@，谨防假冒！','您好，您所查询的是@品牌商名称@生产的产品，请放心使用！','该防伪码已经被人查询过，首次查询时间：@查询时间@，谨防假冒！',0,'产品信息',1,1,1,1,1,1,1,'企业信息',0,0,1,1,1,1,1,25,1,0,'宣传视频','','2022-04-08 09:34:56',0),(3,'','','202205261653532895','智能物流','2','[{\"url\":\"http:\\/\\/cdn.uni-2id.com\\/03905202205261040268703.jpg\",\"name\":\"03905202205261040268703.jpg\"}]','[{\"url\":\"http:\\/\\/cdn.uni-2id.com\\/03905202205261040268703.jpg\",\"name\":\"03905202205261040268703.jpg\",\"link\":\"\"},{\"url\":\"http:\\/\\/cdn.uni-2id.com\\/0a4e020220526103925960.jpg\",\"name\":\"0a4e020220526103925960.jpg\",\"link\":\"\"},{\"url\":\"http:\\/\\/cdn.uni-2id.com\\/785c3202205261029597677.jpg\",\"name\":\"785c3202205261029597677.jpg\",\"link\":\"\"}]','[{\"title\":\"\\u4ea7\\u54c1\",\"is_show\":1},{\"title\":\"\\u7269\\u6d41\",\"is_show\":1},{\"title\":\"\\u4f01\\u4e1a\",\"is_show\":1}]','查询记录','当前溯源码为首次查询，感谢您的查询！','当前溯源码为第@次@次查询，感谢您的查询！','当前溯源码为首次查询，感谢您的查询！','当前溯源码为第@次@次查询，感谢您的查询！',0,1,'物流信息','防伪认证','您好，您所查询的是@品牌商名称@生产的产品，请放心使用！','该防伪码已经被人查询过，首次查询时间：@查询时间@，谨防假冒！','您好，您所查询的是@品牌商名称@生产的产品，请放心使用！','该防伪码已经被人查询过，首次查询时间：@查询时间@，谨防假冒！',0,'产品信息',1,1,1,1,1,1,1,'企业信息',0,0,1,1,1,1,1,29,1,0,'宣传视频','','2022-05-26 02:41:35',0),(4,'','','202206111654880487','智能物流','1','[{\"url\":\"http:\\/\\/cdn.uni-2id.com\\/0fc92202206131005552713.jpg\",\"name\":\"0fc92202206131005552713.jpg\"}]','[{\"img_name\":\"\",\"url\":\"https:\\/\\/cdn.icloudapi.cn\\/sy-default.png\",\"link\":\"\"}]','[{\"title\":\"\\u4ea7\\u54c1\",\"is_show\":1},{\"title\":\"\\u7269\\u6d41\",\"is_show\":1},{\"title\":\"\\u4f01\\u4e1a\",\"is_show\":1}]','查询记录','当前溯源码为首次查询，感谢您的查询！','当前溯源码为第@次@次查询，感谢您的查询！','当前溯源码为首次查询，感谢您的查询！','当前溯源码为第@次@次查询，感谢您的查询！',0,1,'物流信息','防伪认证','您好，您所查询的是@品牌商名称@生产的产品，请放心使用！','该防伪码已经被人查询过，首次查询时间：@查询时间@，谨防假冒！','您好，您所查询的是@品牌商名称@生产的产品，请放心使用！','该防伪码已经被人查询过，首次查询时间：@查询时间@，谨防假冒！',0,'产品信息',1,1,1,1,1,1,1,'企业信息',0,0,1,1,1,1,1,28,1,0,'宣传视频','','2022-06-10 17:01:27',0),(5,'','','202206161655370505','智能物流','1','[{\"img_name\":\"\",\"url\":\"https:\\/\\/cdn.icloudapi.cn\\/sy-default.png\"}]','[{\"img_name\":\"\",\"url\":\"https:\\/\\/cdn.icloudapi.cn\\/sy-default.png\",\"link\":\"\"}]','[{\"title\":\"\\u4ea7\\u54c1\",\"is_show\":1},{\"title\":\"\\u7269\\u6d41\",\"is_show\":1},{\"title\":\"\\u4f01\\u4e1a\",\"is_show\":1}]','查询记录','当前溯源码为首次查询，感谢您的查询！','当前溯源码为第@次@次查询，感谢您的查询！','当前溯源码为首次查询，感谢您的查询！','当前溯源码为第@次@次查询，感谢您的查询！',0,1,'物流信息','防伪认证','您好，您所查询的是@品牌商名称@生产的产品，请放心使用！','该防伪码已经被人查询过，首次查询时间：@查询时间@，谨防假冒！','您好，您所查询的是@品牌商名称@生产的产品，请放心使用！','该防伪码已经被人查询过，首次查询时间：@查询时间@，谨防假冒！',0,'产品信息',1,1,1,1,1,1,1,'企业信息',0,0,1,1,1,1,1,32,1,0,'宣传视频','','2022-06-16 09:08:25',0),(6,'','','202206271656299067','智能物流','1','[{\"url\":\"http:\\/\\/cdn.uni-2id.com\\/c2f66202207150959288655.jpg\",\"name\":\"c2f66202207150959288655.jpg\"}]','[{\"img_name\":\"\",\"url\":\"https:\\/\\/cdn.icloudapi.cn\\/sy-default.png\",\"link\":\"\"}]','[{\"title\":\"\\u4ea7\\u54c1\",\"is_show\":1},{\"title\":\"\\u7269\\u6d41\",\"is_show\":1},{\"title\":\"\\u4f01\\u4e1a\",\"is_show\":1}]','查询记录','当前溯源码为首次查询，感谢您的查询！','当前溯源码为第@次@次查询，感谢您的查询！','当前溯源码为首次查询，感谢您的查询！','当前溯源码为第@次@次查询，感谢您的查询！',0,1,'物流信息','防伪认证','您好，您所查询的是@品牌商名称@生产的产品，请放心使用！','该防伪码已经被人查询过，首次查询时间：@查询时间@，谨防假冒！','您好，您所查询的是@品牌商名称@生产的产品，请放心使用！','该防伪码已经被人查询过，首次查询时间：@查询时间@，谨防假冒！',0,'产品信息',1,1,1,1,1,1,1,'企业信息',0,0,1,1,1,1,1,33,1,0,'宣传视频','','2022-06-27 03:04:27',0),(7,'','','202208121660270400','智能物流','1','[{\"img_name\":\"\",\"url\":\"https:\\/\\/cdn.icloudapi.cn\\/sy-default.png\"}]','[{\"img_name\":\"\",\"url\":\"https:\\/\\/cdn.icloudapi.cn\\/sy-default.png\",\"link\":\"\"}]','[{\"title\":\"\\u4ea7\\u54c1\",\"is_show\":1},{\"title\":\"\\u7269\\u6d41\",\"is_show\":1},{\"title\":\"\\u4f01\\u4e1a\",\"is_show\":1}]','查询记录','当前溯源码为首次查询，感谢您的查询！','当前溯源码为第@次@次查询，感谢您的查询！','当前溯源码为首次查询，感谢您的查询！','当前溯源码为第@次@次查询，感谢您的查询！',0,1,'物流信息','防伪认证','您好，您所查询的是@品牌商名称@生产的产品，请放心使用！','该防伪码已经被人查询过，首次查询时间：@查询时间@，谨防假冒！','您好，您所查询的是@品牌商名称@生产的产品，请放心使用！','该防伪码已经被人查询过，首次查询时间：@查询时间@，谨防假冒！',0,'产品信息',1,1,1,1,1,1,1,'企业信息',0,0,1,1,1,1,1,35,1,0,'宣传视频','','2022-08-12 02:13:20',0),(8,'','','202208241661305293','智能物流','1','[{\"url\":\"http:\\/\\/cdn.uni-2id.com\\/c51ca202208240929015410.jpg\",\"name\":\"c51ca202208240929015410.jpg\"}]','[{\"img_name\":\"\",\"url\":\"https:\\/\\/cdn.icloudapi.cn\\/sy-default.png\",\"link\":\"\"}]','[{\"title\":\"\\u4ea7\\u54c1\",\"is_show\":1},{\"title\":\"\\u7269\\u6d41\",\"is_show\":1},{\"title\":\"\\u4f01\\u4e1a\",\"is_show\":1}]','查询记录','当前溯源码为首次查询，感谢您的查询！','当前溯源码为第@次@次查询，感谢您的查询！','当前溯源码为首次查询，感谢您的查询！','当前溯源码为第@次@次查询，感谢您的查询！',0,1,'物流信息','防伪认证','您好，您所查询的是@品牌商名称@生产的产品，请放心使用！','该防伪码已经被人查询过，首次查询时间：@查询时间@，谨防假冒！','您好，您所查询的是@品牌商名称@生产的产品，请放心使用！','该防伪码已经被人查询过，首次查询时间：@查询时间@，谨防假冒！',0,'产品信息',1,1,1,1,1,1,1,'企业信息',0,0,1,1,1,1,1,34,1,0,'宣传视频','','2022-08-24 01:41:33',0);
/*!40000 ALTER TABLE `ctc_dealer_logistics_template` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ctc_dealer_logistics_th_code`
--

DROP TABLE IF EXISTS `ctc_dealer_logistics_th_code`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
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
) ENGINE=InnoDB AUTO_INCREMENT=51 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ctc_dealer_logistics_th_code`
--

LOCK TABLES `ctc_dealer_logistics_th_code` WRITE;
/*!40000 ALTER TABLE `ctc_dealer_logistics_th_code` DISABLE KEYS */;
INSERT INTO `ctc_dealer_logistics_th_code` VALUES (46,'7798662288','10010',NULL,'202205261653533222',1,100,'TH2022062298984898',15,29,'10010','10010','2022-06-22 08:00:54'),(47,'6115650101','10002',NULL,'202205261653533222',1,100,'TH2022062298994850',19,29,'10002','10002','2022-06-22 08:29:57'),(48,'0643390639','12111',NULL,'202206271656292352',1,100,'TH2022062750489953',19,29,'12111','12111','2022-06-27 01:16:14'),(49,'5764326812','12210',NULL,'202206271656292352',1,100,'TH2022070398995697',19,29,'12210','12210','2022-07-02 18:06:16'),(50,'0084351934','1532618',NULL,'202206281656383066',1,80,'TH2022072654515410',49,33,'1532618','1532618','2022-07-26 09:35:14');
/*!40000 ALTER TABLE `ctc_dealer_logistics_th_code` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ctc_dealer_logistics_th_order`
--

DROP TABLE IF EXISTS `ctc_dealer_logistics_th_order`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
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
) ENGINE=InnoDB AUTO_INCREMENT=47 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ctc_dealer_logistics_th_order`
--

LOCK TABLES `ctc_dealer_logistics_th_order` WRITE;
/*!40000 ALTER TABLE `ctc_dealer_logistics_th_order` DISABLE KEYS */;
INSERT INTO `ctc_dealer_logistics_th_order` VALUES (42,'TH2022062298984898',NULL,'2022-06-22 07:59:23',NULL,2219,'29_wh','文寒',6,1,100,NULL,0,NULL,29,0,'0','[{\"product_id\":15,\"product_code\":\"wx\",\"product_name\":\"\\u725b\\u680f\\u5c71\",\"barcode\":\"\",\"unit\":\"\",\"specifications\":\"\",\"return_num\":100}]','distributor','2022-06-22 08:00:54'),(43,'TH2022062298994850',NULL,'2022-06-22 08:29:47',NULL,2217,'nigulasizs','石家庄赵四',6,1,100,NULL,0,NULL,29,0,'0','[{\"product_id\":19,\"product_code\":\"1\",\"product_name\":\"\\u5341\\u516b\\u9152\\u574a\",\"barcode\":\"\",\"unit\":\"\",\"specifications\":\"\",\"return_num\":100}]','distributor','2022-06-22 08:29:57'),(44,'TH2022062750489953',NULL,'2022-06-27 01:16:01',NULL,2217,'nigulasizs','石家庄赵四',6,1,100,NULL,0,NULL,29,0,'0','[{\"product_id\":19,\"product_code\":\"1\",\"product_name\":\"\\u5341\\u516b\\u9152\\u574a\",\"barcode\":\"\",\"unit\":\"\",\"specifications\":\"\",\"return_num\":100}]','distributor','2022-06-27 01:16:14'),(45,'TH2022070398995697',NULL,'2022-07-02 18:05:31',NULL,2219,'29_wh','文寒',6,1,100,NULL,0,NULL,29,0,'0','[{\"product_id\":19,\"product_code\":\"1\",\"product_name\":\"\\u5341\\u516b\\u9152\\u574a\",\"barcode\":\"\",\"unit\":\"\",\"specifications\":\"\",\"return_num\":100}]','distributor','2022-07-02 18:06:16'),(46,'TH2022072654515410',NULL,'2022-07-26 09:34:53',NULL,2241,'whtzljzzsclyxgs','武汉天之乐建筑装饰材料有限公司',12,2,80,NULL,0,NULL,33,0,'0','[{\"product_id\":49,\"product_code\":\"gqstD25\",\"product_name\":\"\\u8fc7\\u6865\\u56db\\u901a\",\"barcode\":\"\",\"unit\":\"\",\"specifications\":\"\",\"return_num\":80}]','distributor','2022-07-26 09:35:14');
/*!40000 ALTER TABLE `ctc_dealer_logistics_th_order` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ctc_dealer_logistics_warehouse`
--

DROP TABLE IF EXISTS `ctc_dealer_logistics_warehouse`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
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
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ctc_dealer_logistics_warehouse`
--

LOCK TABLES `ctc_dealer_logistics_warehouse` WRITE;
/*!40000 ALTER TABLE `ctc_dealer_logistics_warehouse` DISABLE KEYS */;
INSERT INTO `ctc_dealer_logistics_warehouse` VALUES (4,'默认','1','石家庄','总部',25,'总部','2022-04-13 07:23:47'),(5,'仓库1','2','石家庄','总部',25,'总部','2022-04-17 20:27:25'),(6,'一号仓库','01','','',29,'','2022-05-26 03:07:07'),(7,'晋城总库','1','','',28,'','2022-06-13 02:06:42'),(8,'晓庄配送中心','02','','',28,'','2022-06-16 02:00:23'),(9,'二号仓库','02','','',29,'','2022-06-17 07:42:28'),(10,'测试','001','石家庄','测试',32,'测试','2022-06-18 16:23:19'),(11,'哈尔滨库','02','哈尔滨','1',25,'2','2022-07-08 02:38:19'),(12,'武汉仓库','1','','',33,'','2022-07-15 01:51:45'),(13,'上海仓库','1','','',34,'','2022-08-24 01:26:17');
/*!40000 ALTER TABLE `ctc_dealer_logistics_warehouse` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ctc_dealer_mall_cart`
--

DROP TABLE IF EXISTS `ctc_dealer_mall_cart`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ctc_dealer_mall_cart` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `mall_goods_id` int(11) DEFAULT NULL COMMENT '商品id 同一用户只会存放一个唯一的商品id',
  `goods_num` int(11) DEFAULT NULL,
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `uid` int(11) DEFAULT NULL,
  `openid` varchar(255) DEFAULT NULL,
  `goods_sku_id` int(11) DEFAULT '0' COMMENT '商品属性id 0代表无属性',
  `update_time` timestamp NULL DEFAULT NULL,
  `is_delete` tinyint(4) DEFAULT '0' COMMENT '是否删除',
  `dealer_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ctc_dealer_mall_cart`
--

LOCK TABLES `ctc_dealer_mall_cart` WRITE;
/*!40000 ALTER TABLE `ctc_dealer_mall_cart` DISABLE KEYS */;
INSERT INTO `ctc_dealer_mall_cart` VALUES (1,1,3,'2022-12-02 16:45:37',NULL,'false',0,NULL,0,29);
/*!40000 ALTER TABLE `ctc_dealer_mall_cart` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ctc_dealer_mall_distribution_rule`
--

DROP TABLE IF EXISTS `ctc_dealer_mall_distribution_rule`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ctc_dealer_mall_distribution_rule`
--

LOCK TABLES `ctc_dealer_mall_distribution_rule` WRITE;
/*!40000 ALTER TABLE `ctc_dealer_mall_distribution_rule` DISABLE KEYS */;
/*!40000 ALTER TABLE `ctc_dealer_mall_distribution_rule` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ctc_dealer_mall_distributor_page`
--

DROP TABLE IF EXISTS `ctc_dealer_mall_distributor_page`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ctc_dealer_mall_distributor_page` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `bk_img` varchar(255) DEFAULT NULL,
  `head_style` varchar(255) DEFAULT NULL COMMENT '头像样式 1正方形 2圆角',
  `font_size` varchar(255) DEFAULT NULL,
  `font_color` varchar(255) DEFAULT NULL,
  `dealer_id` int(11) DEFAULT NULL,
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ctc_dealer_mall_distributor_page`
--

LOCK TABLES `ctc_dealer_mall_distributor_page` WRITE;
/*!40000 ALTER TABLE `ctc_dealer_mall_distributor_page` DISABLE KEYS */;
/*!40000 ALTER TABLE `ctc_dealer_mall_distributor_page` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ctc_dealer_mall_fenxiao_cash`
--

DROP TABLE IF EXISTS `ctc_dealer_mall_fenxiao_cash`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ctc_dealer_mall_fenxiao_cash`
--

LOCK TABLES `ctc_dealer_mall_fenxiao_cash` WRITE;
/*!40000 ALTER TABLE `ctc_dealer_mall_fenxiao_cash` DISABLE KEYS */;
/*!40000 ALTER TABLE `ctc_dealer_mall_fenxiao_cash` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ctc_dealer_mall_fenxiao_order`
--

DROP TABLE IF EXISTS `ctc_dealer_mall_fenxiao_order`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
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
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ctc_dealer_mall_fenxiao_order`
--

LOCK TABLES `ctc_dealer_mall_fenxiao_order` WRITE;
/*!40000 ALTER TABLE `ctc_dealer_mall_fenxiao_order` DISABLE KEYS */;
/*!40000 ALTER TABLE `ctc_dealer_mall_fenxiao_order` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ctc_dealer_mall_fenxiaoyuan`
--

DROP TABLE IF EXISTS `ctc_dealer_mall_fenxiaoyuan`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ctc_dealer_mall_fenxiaoyuan` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `member_id` int(11) DEFAULT NULL,
  `dealer_id` int(11) DEFAULT NULL,
  `parent_id` int(11) DEFAULT '0' COMMENT '上级成员id',
  `grandpa_id` int(11) DEFAULT '0' COMMENT '最高级',
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ctc_dealer_mall_fenxiaoyuan`
--

LOCK TABLES `ctc_dealer_mall_fenxiaoyuan` WRITE;
/*!40000 ALTER TABLE `ctc_dealer_mall_fenxiaoyuan` DISABLE KEYS */;
/*!40000 ALTER TABLE `ctc_dealer_mall_fenxiaoyuan` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ctc_dealer_mall_goods`
--

DROP TABLE IF EXISTS `ctc_dealer_mall_goods`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
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
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ctc_dealer_mall_goods`
--

LOCK TABLES `ctc_dealer_mall_goods` WRITE;
/*!40000 ALTER TABLE `ctc_dealer_mall_goods` DISABLE KEYS */;
INSERT INTO `ctc_dealer_mall_goods` VALUES (1,'1','十八酒坊','[{\"url\":\"http:\\/\\/cdn.uni-2id.com\\/03905202205261040268703.jpg\",\"name\":\"03905202205261040268703.jpg\"},{\"url\":\"http:\\/\\/cdn.uni-2id.com\\/4626e202205241052243681.jpg\",\"name\":\"4626e202205241052243681.jpg\"}]',9.00,10.00,2.00,200,'2','0',12,'2','1','0','<p>测试啊</p>',29,0,1,19,'2022-12-01 15:16:45','2022-12-01 15:16:45');
/*!40000 ALTER TABLE `ctc_dealer_mall_goods` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ctc_dealer_mall_goods_type`
--

DROP TABLE IF EXISTS `ctc_dealer_mall_goods_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ctc_dealer_mall_goods_type` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `class_name` varchar(255) DEFAULT NULL,
  `parent_id` int(11) DEFAULT '0',
  `order` int(11) DEFAULT NULL,
  `cover` varchar(255) DEFAULT NULL COMMENT '封面',
  `dealer_id` int(11) DEFAULT NULL,
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ctc_dealer_mall_goods_type`
--

LOCK TABLES `ctc_dealer_mall_goods_type` WRITE;
/*!40000 ALTER TABLE `ctc_dealer_mall_goods_type` DISABLE KEYS */;
INSERT INTO `ctc_dealer_mall_goods_type` VALUES (1,'一级',0,1,'',29,'2022-12-01 15:15:29'),(2,'2.1',1,2,'http://cdn.uni-2id.com/0e906202206201502499112.png',29,'2022-12-01 15:15:41'),(3,'二级分类',0,1,'http://cdn.uni-2id.com/0e906202206201502499112.png',29,'2022-12-01 15:15:41'),(4,'2.1',3,1,'http://cdn.uni-2id.com/0e906202206201502499112.png',29,'2022-12-01 15:15:41'),(5,'2.2',3,2,'http://cdn.uni-2id.com/0e906202206201502499112.png',29,'2022-12-01 15:15:41');
/*!40000 ALTER TABLE `ctc_dealer_mall_goods_type` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ctc_dealer_mall_judge`
--

DROP TABLE IF EXISTS `ctc_dealer_mall_judge`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
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
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ctc_dealer_mall_judge`
--

LOCK TABLES `ctc_dealer_mall_judge` WRITE;
/*!40000 ALTER TABLE `ctc_dealer_mall_judge` DISABLE KEYS */;
/*!40000 ALTER TABLE `ctc_dealer_mall_judge` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ctc_dealer_mall_order`
--

DROP TABLE IF EXISTS `ctc_dealer_mall_order`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ctc_dealer_mall_order` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '订单ID',
  `openid` varchar(255) DEFAULT NULL,
  `order_id` varchar(32) NOT NULL COMMENT '订单号',
  `dealer_id` int(11) DEFAULT NULL COMMENT '归属',
  `member_id` int(11) unsigned DEFAULT NULL COMMENT '用户id',
  `order_goods_info` text COMMENT '订当商品信息',
  `user_address_id` int(11) DEFAULT NULL COMMENT '地址id',
  `cart_ids` varchar(256) DEFAULT NULL COMMENT '购物车id',
  `total_num` int(11) unsigned DEFAULT '0' COMMENT '订单商品总数',
  `total_points` decimal(8,2) DEFAULT NULL COMMENT '订单总积分',
  `total_price` decimal(8,2) unsigned DEFAULT '0.00' COMMENT '订单总价',
  `total_postage` decimal(8,2) unsigned DEFAULT '0.00' COMMENT '邮费',
  `pay_price` decimal(8,2) unsigned DEFAULT '0.00' COMMENT '实际支付金额',
  `pay_postage` decimal(8,2) unsigned DEFAULT '0.00' COMMENT '支付邮费',
  `deduction_price` decimal(8,2) unsigned DEFAULT '0.00' COMMENT '抵扣金额',
  `coupon_id` int(11) unsigned DEFAULT '0' COMMENT '优惠券id',
  `coupon_price` decimal(8,2) unsigned DEFAULT '0.00' COMMENT '优惠券金额',
  `paid` tinyint(1) unsigned DEFAULT '0' COMMENT '支付状态',
  `pay_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '支付时间',
  `pay_mode` varchar(255) DEFAULT NULL COMMENT '支付模式 直接兑换或者购物车兑换',
  `pay_type` tinyint(10) NOT NULL DEFAULT '0' COMMENT '支付方式 0微信 1支付宝',
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `status` tinyint(1) DEFAULT '0' COMMENT '订单状态（0：待发货；1：待收货；2：已完成；-1：待付款；）',
  `refund_status` tinyint(1) unsigned DEFAULT '0' COMMENT '0 未退款 1 申请中 2 已退款',
  `refund_reason_wap_img` varchar(255) DEFAULT NULL COMMENT '退款图片',
  `refund_reason_wap_explain` varchar(255) DEFAULT NULL COMMENT '退款用户说明',
  `refund_reason_time` int(11) unsigned DEFAULT NULL COMMENT '退款时间',
  `refund_reason_wap` varchar(255) DEFAULT NULL COMMENT '前台退款原因',
  `refund_reason` varchar(255) DEFAULT NULL COMMENT '不退款的理由',
  `refund_price` decimal(8,2) unsigned DEFAULT '0.00' COMMENT '退款金额',
  `delivery_mark` varchar(255) DEFAULT NULL,
  `delivery_name` varchar(64) DEFAULT NULL COMMENT '快递名称/送货人姓名',
  `delivery_type` varchar(32) DEFAULT NULL COMMENT '发货类型',
  `delivery_id` varchar(64) DEFAULT NULL COMMENT '快递单号/手机号',
  `mark` varchar(512) DEFAULT NULL COMMENT '备注',
  `is_del` tinyint(1) unsigned DEFAULT '0' COMMENT '是否删除',
  `unique` char(32) DEFAULT NULL COMMENT '唯一id(md5加密)类似id',
  `remark` varchar(512) DEFAULT NULL COMMENT '管理员备注',
  `mer_id` int(10) unsigned DEFAULT '0' COMMENT '商户ID',
  `is_mer_check` tinyint(3) unsigned DEFAULT '0',
  `cost` decimal(8,2) unsigned DEFAULT NULL COMMENT '成本价',
  `is_channel` tinyint(1) unsigned DEFAULT '0' COMMENT '支付渠道(0微信公众号1微信小程序)',
  `is_system_del` tinyint(1) DEFAULT '0' COMMENT '后台管理员删除',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `unique` (`unique`) USING BTREE,
  UNIQUE KEY `order_id_2` (`order_id`,`member_id`) USING BTREE,
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
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ctc_dealer_mall_order`
--

LOCK TABLES `ctc_dealer_mall_order` WRITE;
/*!40000 ALTER TABLE `ctc_dealer_mall_order` DISABLE KEYS */;
/*!40000 ALTER TABLE `ctc_dealer_mall_order` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ctc_dealer_mall_template`
--

DROP TABLE IF EXISTS `ctc_dealer_mall_template`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
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
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ctc_dealer_mall_template`
--

LOCK TABLES `ctc_dealer_mall_template` WRITE;
/*!40000 ALTER TABLE `ctc_dealer_mall_template` DISABLE KEYS */;
INSERT INTO `ctc_dealer_mall_template` VALUES (2,'微商城','我正在看微商城，挺不错的，你也来看看吧。','###','微商城','[{\"type\":\"line\",\"height\":20},{\"type\":\"search\",\"text\":\"\\u641c\\u7d22\\u5e97\\u94fa\\u5185\\u5546\\u54c1\",\"height\":60},{\"type\":\"line\",\"height\":20},{\"type\":\"banner\",\"imgList\":[{\"url\":\"http:\\/\\/cdn.uni-2id.com\\/03905202205261040268703.jpg\",\"link\":\"\"}],\"height\":152},{\"type\":\"line\",\"height\":20},{\"type\":\"nav\",\"content\":[{\"url\":\"\\/static\\/img\\/nav-1-icon@2x.76794824.png\",\"text\":\"\\u5168\\u90e8\\u5546\\u54c1\",\"is_show\":1},{\"url\":\"\\/static\\/img\\/nav-3-icon@2x.b064880f.png\",\"text\":\"\\u8ba2\\u5355\\u4e2d\\u5fc3\",\"is_show\":1},{\"url\":\"\\/static\\/img\\/cart_icon(1).d2df650a.png\",\"text\":\"\\u8d2d\\u7269\\u8f66\",\"is_show\":1},{\"url\":\"\\/static\\/img\\/nav-2-icon@2x.761261e4.png\",\"text\":\"\\u4e2a\\u4eba\\u4e2d\\u5fc3\",\"is_show\":1}]},{\"type\":\"line\",\"height\":20},{\"type\":\"notice\",\"text\":\"ssadsadsadsada\",\"height\":10},{\"type\":\"line\",\"height\":20},{\"type\":\"recom\",\"text\":\"\\u4ea7\\u54c1\\u63a8\\u8350\",\"url\":\"\",\"product_title\":\"\\u6d4b\\u8bd5\",\"product_sale\":90,\"product_price\":100,\"recom_rule\":1,\"height\":10}]',29,0,'2022-12-01 16:00:27');
/*!40000 ALTER TABLE `ctc_dealer_mall_template` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ctc_dealer_material_article`
--

DROP TABLE IF EXISTS `ctc_dealer_material_article`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ctc_dealer_material_article`
--

LOCK TABLES `ctc_dealer_material_article` WRITE;
/*!40000 ALTER TABLE `ctc_dealer_material_article` DISABLE KEYS */;
/*!40000 ALTER TABLE `ctc_dealer_material_article` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ctc_dealer_material_group`
--

DROP TABLE IF EXISTS `ctc_dealer_material_group`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ctc_dealer_material_group` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `group_name` varchar(255) DEFAULT NULL,
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `dealer_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ctc_dealer_material_group`
--

LOCK TABLES `ctc_dealer_material_group` WRITE;
/*!40000 ALTER TABLE `ctc_dealer_material_group` DISABLE KEYS */;
INSERT INTO `ctc_dealer_material_group` VALUES (1,'11','2022-12-31 07:50:57',29);
/*!40000 ALTER TABLE `ctc_dealer_material_group` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ctc_dealer_member`
--

DROP TABLE IF EXISTS `ctc_dealer_member`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
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
  `points` decimal(8,2) DEFAULT '0.00' COMMENT '积分',
  `tags` varchar(255) DEFAULT NULL COMMENT '用户标签',
  `remark` text COMMENT '备注',
  `create_time` datetime DEFAULT NULL COMMENT '头像',
  `status` tinyint(4) DEFAULT '0' COMMENT '会员状态 0正常 1拉黑',
  `follow_status` tinyint(4) DEFAULT '2' COMMENT '公众号关注状态 2未关注',
  `phone_status` tinyint(4) DEFAULT '2' COMMENT '手机认证状态 1已认证 2未认证',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=86 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ctc_dealer_member`
--

LOCK TABLES `ctc_dealer_member` WRITE;
/*!40000 ALTER TABLE `ctc_dealer_member` DISABLE KEYS */;
INSERT INTO `ctc_dealer_member` VALUES (2,'osnBC6OPadCdY77BfGZOaVhbgjak',NULL,'文寒',NULL,',,',NULL,NULL,NULL,'https://thirdwx.qlogo.cn/mmopen/vi_32/Q0j4TwGTfTJqRybMPxFXbrViaPUG6KOnDQaPGAYhesicctnibfnpYM1PoG0WHgEcs8ianAXe9PxibmxnsPXfxF5L4ew/132',0,27,NULL,NULL,NULL,'115',NULL,NULL,0,2,2),(3,'osnBC6IXhc-M4ifq9btiD3akvrks',NULL,'Miss?',NULL,',,',NULL,NULL,NULL,'https://thirdwx.qlogo.cn/mmopen/vi_32/Qiaccm1VzjqQd7835MIZQoh6QhiaULyUzSrH9fbibQScWH2icZ9pZLLiaI3KoH0hKAvQ68XEPUw567BpvfiaUWvqeG2Q/132',0,27,NULL,NULL,NULL,NULL,NULL,NULL,0,2,2),(4,'ocu1P571MMgt_rSe3Cu-3L4FsxPg',NULL,'暴风雨',NULL,',,',NULL,NULL,NULL,'https://thirdwx.qlogo.cn/mmopen/vi_32/WA96sibeW1VRcpmWnetRibDsRYufIxibMicjbyfRkI7icBKaGwfOy5FFOcxMzvEKRfbFsL8fNSyqrdcbutKCWnjlOrw/132',0,26,NULL,NULL,NULL,NULL,NULL,NULL,1,2,2),(5,'osnBC6OtFSda5b2PIY9R-HIs8vgk',NULL,'海略科技财务',NULL,',,',NULL,NULL,NULL,'https://thirdwx.qlogo.cn/mmopen/vi_32/07xU9KvGqelQpfVyRNRgShkJ5cFhgNVJN0fb8DwG8jaQvj3icIcGBUiaWcvxbcfHuaEMmbaVVj3QdHCpDqKuBUNQ/132',0,26,NULL,NULL,NULL,NULL,NULL,NULL,0,2,2),(6,'osnBC6EZFWjqpCqVwBrTSd6PSkLo',NULL,'暮光之城',NULL,',,',NULL,NULL,NULL,'https://thirdwx.qlogo.cn/mmopen/vi_32/DYAIOgq83eqgpyzHIJP6VmmsNzJgVBRgicFiczdNicCC7L7oSNOiaSliaicQiaL3FjWaRaGTYgXnMbrDqWURia1IuSLUyw/132',0,26,NULL,NULL,NULL,'115',NULL,NULL,0,2,2),(7,'osnBC6FEdfE7COoR2r51iK1RrrAs',NULL,'彩Sè时光つ',NULL,',,',NULL,NULL,NULL,'https://thirdwx.qlogo.cn/mmopen/vi_32/PiajxSqBRaEKicVEe3Q5RCNGe5ExVNH9OSHLUCakX5b29fkDoicOI2TcC2cdlrGGTVXN4yo3GpGwcc3P98IxvgFpw/132',0,27,NULL,NULL,NULL,NULL,NULL,NULL,0,2,2),(8,'osnBC6D98fQkV-WfyMfnMIqNzU50',NULL,'北城以北',NULL,',,',NULL,NULL,NULL,'https://thirdwx.qlogo.cn/mmopen/vi_32/DYAIOgq83ermmTgGMkPtPicoOCicIzW8wCCCpAKyTwicCpKWcMKdg2hKSTic0QVOQWAXsnibk0NAziagRUHc6nVxzULA/132',0,27,NULL,NULL,NULL,NULL,NULL,NULL,0,2,2),(9,'osnBC6PEdQUaUKxZdkz6etRX0qsE',NULL,'?',NULL,',,',NULL,NULL,NULL,'https://thirdwx.qlogo.cn/mmopen/vi_32/Q0j4TwGTfTKTOiaYECeOeIEDtibtYkPpDInYJcXnlHtKHShE3R9CejyRStiaol3Z9pxfWheHPHMDU4kPVWpicKhonQ/132',0,26,NULL,NULL,NULL,NULL,NULL,NULL,0,2,2),(10,'osnBC6PO01P2BazlRPH9LDsobRak',NULL,'防伪标签程朝阳13343217111',NULL,',,',NULL,NULL,NULL,'https://thirdwx.qlogo.cn/mmopen/vi_32/Q0j4TwGTfTKic7Ib0r36372mp9dEa2tRloA1NN8kCsLBOaPj1iafIcv1BdeWXINoT1lXF0lssg194796xpBticzpg/132',0,26,NULL,NULL,NULL,NULL,NULL,NULL,0,2,2),(11,'osnBC6B2aAdGwm1k6m5Ryj7qbcKg',NULL,'暴风雨',NULL,',,',NULL,NULL,NULL,'https://thirdwx.qlogo.cn/mmopen/vi_32/MwUWbgib2l3nPyRFmhTaU7prqfTgrUrPMZDtG9CYu1hjZTDu7mF1nfykqyscGMFbichk4J6JbXib21zRoy2YNO0Ug/132',0,26,NULL,NULL,NULL,NULL,NULL,NULL,0,2,2),(12,'osnBC6E3PeokIXFuSA6d91gDUiCM',NULL,'森泉 陈慧杰',NULL,',,',NULL,NULL,NULL,'https://thirdwx.qlogo.cn/mmopen/vi_32/Q0j4TwGTfTJPW6VrlXsaWvpwEVtsWHxbTf1gfu3jmKbgEQcbo8R1LX5hdF3YqRxwR301icLwdjGLfE8Urjw7Gag/132',0,26,NULL,NULL,NULL,NULL,NULL,NULL,0,2,2),(13,'osnBC6CAeXSYLuGBtbjkMpaqrCMY',NULL,'谢均 15528477882',NULL,',,',NULL,NULL,NULL,'https://thirdwx.qlogo.cn/mmopen/vi_32/q8gWXVvMrOSsyda9ekwZ6ZSSqwENKRyxbJZ3BK9eAvL6qwL2MqicbWPcgwjyc7RBzZDtv4vTEwZBlxc6DdgbCdg/132',0,27,NULL,NULL,NULL,NULL,NULL,NULL,0,2,2),(14,'osnBC6D0RE8SgYc7dDj1WReiUN1o',NULL,'日丰管(地暖、中央空调)总代理',NULL,',,',NULL,NULL,NULL,'https://thirdwx.qlogo.cn/mmopen/vi_32/DYAIOgq83eoxvgdbD39uWVcVFkS0iceiaJFSU2SpYqF1tWtibh62ktcy78cEOTdvZLEhbEia5L1ru1gyoXoVumDLiaQ/132',0,27,NULL,NULL,NULL,NULL,NULL,NULL,0,2,2),(15,'osnBC6FqBx5BFex8VJVeN_mGgg7k',NULL,'黄林峰{林峰建材配送中心}',NULL,',,',NULL,NULL,NULL,'https://thirdwx.qlogo.cn/mmopen/vi_32/jkkQiajtfnn2CxKD1SPozgfjHvrnr3EXicX4HdfnzpyrkJwPzOqrgF7xNKicpm17J51xQibOl55CFTWYho0LastVibQ/132',0,27,NULL,NULL,NULL,NULL,NULL,NULL,0,2,2),(16,'osnBC6BWfugJVXYjGUN9OqTZLsDk',NULL,'王老丝儿',NULL,',,',NULL,NULL,NULL,'https://thirdwx.qlogo.cn/mmopen/vi_32/MY5e0mJW8QBAuicYHMsrKGKUWiawUN1nxUicZllzjOOMFVicePl8fo9hfIzibZN7tvUKMebrP9zNnMXf5jPyY1IzEoA/132',0,26,NULL,NULL,NULL,NULL,NULL,NULL,0,2,2),(17,'oAM70syDvgBKlrP7UXaTVKfTJJDQ',NULL,'暮光之城',NULL,',,',NULL,NULL,NULL,'https://thirdwx.qlogo.cn/mmopen/vi_32/DYAIOgq83erljFlgseQXiaibzHgDVJhv88lGLkKdkR0TMibWyejJFmDF4Eib2T56jpngPoJ1jxibm0ovk9ibJkNMOVYg/132',0,30,NULL,NULL,NULL,NULL,NULL,NULL,0,2,2),(18,'oAM70sxRW4V1iQ5bhAKYzjvQLM8Q',NULL,'暴风雨',NULL,',,',NULL,NULL,NULL,'https://thirdwx.qlogo.cn/mmopen/vi_32/uGb0ebLSo8Mibyq8HQusbhvcPiav5z0hj1tibgJibcicMT3zFS7hODhl8qHgUSd6A4SgTZicTiaknQH7McDlpFG0GozZw/132',0,30,NULL,NULL,NULL,NULL,NULL,NULL,0,2,2),(19,'oAM70s2VVesszV1cxTglEz5fiC2g',NULL,'?',NULL,',,',NULL,NULL,NULL,'https://thirdwx.qlogo.cn/mmopen/vi_32/Q0j4TwGTfTJ79diaft3MIfYibW4BicIbu8Y3LgkicsScM0icaXSGCmPQx3y959CBu2yZAwUgLXvaWPuEDjiaoh4JicvOg/132',0,30,NULL,NULL,NULL,NULL,NULL,NULL,0,2,2),(20,'oAM70s3j-zLl6tIs28MoXe66cP_c',NULL,'海略科技财务',NULL,',,',NULL,NULL,NULL,'https://thirdwx.qlogo.cn/mmopen/vi_32/yiajJGSpgIdTR1KRGmXuECEMkaH67EoMzk6m1lcm97p1h7RSYB9gYpd1tq09WHY0Dhs9MIHZDuYKUWmbBKW51uw/132',0,30,NULL,NULL,NULL,NULL,NULL,NULL,0,2,2),(21,'oAM70sz1SZcBLPfWYKqUjwhuIC10',NULL,'文寒',NULL,',,',NULL,NULL,NULL,'https://thirdwx.qlogo.cn/mmopen/vi_32/Q0j4TwGTfTKibLZv3YG0dDnqx2W1e9ma0PSISTql9E7qfVGlhbF4ympuyRRfN5WTjoRl1WGBQGZMy32a6QGm6kA/132',0,30,NULL,NULL,NULL,NULL,NULL,NULL,0,2,2),(22,'oAM70s-AWS9xHJEYD3dr6DzUQtAo',NULL,'北城以北',NULL,',,',NULL,NULL,NULL,'https://thirdwx.qlogo.cn/mmopen/vi_32/DYAIOgq83eryTRlibRE0JyfqFv76hXBwmEPC8haqKZg8P199Df76yTMP6K3gFO1cuEZ0ibg6HqsjYY6LKBticNicSQ/132',0,30,NULL,NULL,NULL,NULL,NULL,NULL,0,2,2),(23,'oAM70s_vd87NUB2-rMClNyIJe2WE',NULL,'红',NULL,',,',NULL,NULL,NULL,'https://thirdwx.qlogo.cn/mmopen/vi_32/Q0j4TwGTfTJ4ib05QeibmrJdEnyTIxZttWEW23p4sIMvFhibLMlWAxicMWGNaquRbuWYPiaAd1yBoX0xvgDAXic8pJsA/132',0,30,NULL,NULL,NULL,NULL,NULL,NULL,0,2,2),(24,'oAM70s8lKMo7TNF642S2Rpgsf3SY',NULL,'明天会更好',NULL,',,',NULL,NULL,NULL,'https://thirdwx.qlogo.cn/mmopen/vi_32/mO1wB4ufbyicaK6NPHn61Eh4tFU2ic0zTcGKdGtWM7bO8aZfVVbK7qnZVtEUO5lRzUEJswAWeuXTBHuH8S1vreDw/132',0,30,NULL,NULL,NULL,NULL,NULL,NULL,0,2,2),(25,'oAM70s_8482ryKTfEa2Qj64JhOsI',NULL,'走遍中国??   132 3061 5835',NULL,',,',NULL,NULL,NULL,'https://thirdwx.qlogo.cn/mmopen/vi_32/YzoiascqoL2VPQx5hAOgGrYNWXCKANOCyCvbmUWT50ja9s60W5W61KRhfl3V13KyGFbG24LHzfSehvKTu1Kib54g/132',0,30,NULL,NULL,NULL,NULL,NULL,NULL,0,2,2),(26,'oAM70s-oM6LpN6oLASvSVvmMXGMk',NULL,'垒刚',NULL,',,',NULL,NULL,NULL,'https://thirdwx.qlogo.cn/mmopen/vi_32/LPQKiaxmO7HQN7RpFLrKMhcrSN6qklPZsOvkwMJYl0tibaYk2CEOnoewmyibwZPhqhvAXoujtsWlCWOqQYBiciaeMtQ/132',0,30,NULL,NULL,NULL,NULL,NULL,NULL,0,2,2),(27,'osnBC6F6xJq0ybEdIDcGxRyIj_sY',NULL,'咖乐防水，美缝刘山川15997255984',NULL,',,',NULL,NULL,NULL,'https://thirdwx.qlogo.cn/mmopen/vi_32/Q0j4TwGTfTI7cFuDsumYZl3GeJsJ4eRZnKdZ4KTFIA6PNobiaBndernuq7JhkxHaavICFtnibmQ7kpAq9bCeXQfA/132',0,26,NULL,NULL,NULL,NULL,NULL,NULL,0,2,2),(28,'osnBC6Jf0NVNNbF__KikjZOUo2Cw',NULL,'追梦人',NULL,',,',NULL,NULL,NULL,'https://thirdwx.qlogo.cn/mmopen/vi_32/zncz6hvfa2ia55ibQog4ULRcKMhFicucUZVlc8BVootuqdXUDvRZw4OueL2A4MLOFyiaoZrD44XViaacqibia4kibOW88A/132',0,26,NULL,NULL,NULL,NULL,NULL,NULL,0,2,2),(29,'oAM70syn1BZxln8Nz3wFtQnfBwZo',NULL,'A00专业装修',NULL,',,',NULL,NULL,NULL,'https://thirdwx.qlogo.cn/mmopen/vi_32/Q0j4TwGTfTL7MNCickbvdrtaR62M5yOCxG13mZt7CbqW77SjST8u56uvAXvicHqia1110picRvNJh6wuOaGdr9Zolw/132',0,30,NULL,NULL,NULL,NULL,NULL,NULL,0,2,2),(30,'oAM70s3f8DhWov19fCsJq9ULTGoY',NULL,'蒋志刚',NULL,',,',NULL,NULL,NULL,'https://thirdwx.qlogo.cn/mmopen/vi_32/Q0j4TwGTfTLX62j3MqZu6ac6MfOyibtibvplAatlddfZgoaorKbasZNpDrgyS4icHa9FicTwkyN2RrW6zsTdGrcGVA/132',0,30,NULL,NULL,NULL,NULL,NULL,NULL,0,2,2),(31,'osnBC6EyUDbj5HUVDXhpwqhyK1c0',NULL,'许',NULL,',,',NULL,NULL,NULL,'https://thirdwx.qlogo.cn/mmopen/vi_32/DYAIOgq83eqHapzIRe24p27eMpMUtTcTmkohahRpf6dL1GyXoSibPiabNoI6faK5oNj6nUwWugIicxbMrcz8PxvyQ/132',0,26,NULL,NULL,NULL,NULL,NULL,NULL,0,2,2),(32,'osnBC6PClJ9-3zmG_L5oivXsF8Rc',NULL,'李辉',NULL,',,',NULL,NULL,NULL,'https://thirdwx.qlogo.cn/mmopen/vi_32/DYAIOgq83erwCxJw2rNKwSzjRxc1KHT13wPxjicFMScicMWqgo07Un6aWiadI1KcWJn7RvBYcyFshnVU2MicLgibcEg/132',0,26,NULL,NULL,NULL,NULL,NULL,NULL,0,2,2),(33,'oAM70s_RSe6wPMsfNmryKBIXH2fk',NULL,'崔玉庄??17731886809',NULL,',,',NULL,NULL,NULL,'https://thirdwx.qlogo.cn/mmopen/vi_32/WhoLIb4HZtvFIRiaic0eUjia6TicdiazAzsianYGFZnhu2W6yCNXYNx7YTuHvAibWhd3HduY7KA2UnqxykibiauawUbGRHQ/132',0,30,NULL,NULL,NULL,NULL,NULL,NULL,0,2,2),(34,'osnBC6MK5S2CgSeUGa3Ruwj-E9Qc',NULL,'浩哥',NULL,',,',NULL,NULL,NULL,'https://thirdwx.qlogo.cn/mmopen/vi_32/ibVsoxKiclRqyiaHgq7D0kM9FEywvH5Rygv1Iia2seV3RxQuRIDrrDfKYvkGWMkBshz6cBXv4l8W0ymCspvsqkDeDg/132',0,26,NULL,NULL,NULL,NULL,NULL,NULL,0,2,2),(35,'oAM70s7RsRAMknca5eHiEOqTVAR4',NULL,'风',NULL,',,',NULL,NULL,NULL,'https://thirdwx.qlogo.cn/mmopen/vi_32/wv5wiaRUH2pB49QrNsUAR0fU56DL6icoNCKk3VVGibuib4yiczQsrWBDVOCK78RAiavia093hGGibod0ZaGgKiczbW3zp8g/132',0,30,NULL,NULL,NULL,NULL,NULL,NULL,0,2,2),(36,'osnBC6IunAsQMoDQcBOj6AxOXeTo',NULL,'早',NULL,',,',NULL,NULL,NULL,'https://thirdwx.qlogo.cn/mmopen/vi_32/Q0j4TwGTfTIBWN7ibZHRPm54kmlgcMxsN3HMUaM079lxeCnYcEruLoe5T4TJoRYaEPx1yHNtkjtteqUVKH8ygVg/132',0,26,NULL,NULL,NULL,NULL,NULL,NULL,0,2,2),(37,'osnBC6EU4o6kZu1vfFq2XoXe1ikc',NULL,'?...疍? 逑? ？',NULL,',,',NULL,NULL,NULL,'https://thirdwx.qlogo.cn/mmopen/vi_32/ibolrUXapIBlR5SnFSzTKGwFXsrjEHnMQPG1GEo4AYibicAgzJ6dRhYNiaULOu5UwbNHibJAWoxuyU8lYfEu8Gosl0Q/132',0,26,NULL,NULL,NULL,NULL,NULL,NULL,0,2,2),(38,'oAM70s9FLl798Nr6WGMFluFSrpOY',NULL,'苏宾13831257372',NULL,',,',NULL,NULL,NULL,'https://thirdwx.qlogo.cn/mmopen/vi_32/DYAIOgq83eq7zTLUZGsU7PuFThe1U6vEhPZAiciayYdBeOXcRDuhDr0USU1sibXReiaC9icKBBzzCWtwSBd1c6Br5hQ/132',0,30,NULL,NULL,NULL,NULL,NULL,NULL,0,2,2),(39,'oAM70s5Gnld65uT9cSoqYPbVrL84',NULL,'微信用户',NULL,',,',NULL,NULL,NULL,'https://thirdwx.qlogo.cn/mmopen/vi_32/Q3auHgzwzM7lOvLdaWicyqr5ks6b5ibx71NBTe1q6qhPLMsWcAWhoStStVEkwrNQHgXiby6ULuD95DG82PnROgYHQ/132',0,30,NULL,NULL,NULL,NULL,NULL,NULL,0,2,2),(40,'oAM70s9kyurxxwg6G0W-VFynCWb0',NULL,'海风',NULL,',,',NULL,NULL,NULL,'https://thirdwx.qlogo.cn/mmopen/vi_32/Q0j4TwGTfTIxSrpEI7VGZErDgXc3b4kI5IVXLS1ib3Co7mokiclOZUAnNMSibCUM0b5icdCgPaW4SdakAuhoqVXh2A/132',0,30,NULL,NULL,NULL,NULL,NULL,NULL,0,2,2),(41,'oAM70s0S0T8BSoHql5k2SQvsX9oE',NULL,'谢小松',NULL,',,',NULL,NULL,NULL,'https://thirdwx.qlogo.cn/mmopen/vi_32/DYAIOgq83eqKvqcaOXxfrKwXzQpkeRVExyJOgchlzVu7wLj1dwTEcgJ7uUMyggnkic787MPcAZxeh0yoVHvvFEA/132',0,30,NULL,NULL,NULL,NULL,NULL,NULL,0,2,2),(42,'oAM70s3F2wxRR6hV4usgaH_gD0gw',NULL,'陈迎业13613124856专业改水电？',NULL,',,',NULL,NULL,NULL,'https://thirdwx.qlogo.cn/mmopen/vi_32/RkiaB4GcovywRyeZBtLdLUYc3Hpp92XAooQJcpYLjyoPerETAxVYypqGM3bakFKWEK2XtwttQ1ev2sEDZIFicnPQ/132',0,30,NULL,NULL,NULL,NULL,NULL,NULL,0,2,2),(43,'oAM70s-h1BgnR-KXgBAH5_Dd6GMw',NULL,'微信用户',NULL,',,',NULL,NULL,NULL,'https://thirdwx.qlogo.cn/mmopen/vi_32/Q3auHgzwzM7lOvLdaWicyqr5ks6b5ibx712f9MaMicIMBwicGfUnvtpQzIEhATTz5wVIg8CFqleKnE3nKPyiakjAWzQ/132',0,30,NULL,NULL,NULL,NULL,NULL,NULL,0,2,2),(44,'osnBC6Bmjkqnne-u-jS9cszf3YhY',NULL,'微信用户',NULL,',,',NULL,NULL,NULL,'https://thirdwx.qlogo.cn/mmopen/vi_32/Q3auHgzwzM6mTdxX49zrIiaXX5X4dCleXrYlunp7fntM0XNPYAre11sVaV4zXrSDj9XGcstSxdg4JvdIUPbc7qw/132',0,26,NULL,NULL,NULL,NULL,NULL,NULL,0,2,2),(45,'osnBC6G1pMUXYyVdBP6BctHXsTDc',NULL,'依珞法门窗刘山山-13197479821',NULL,',,',NULL,NULL,NULL,'https://thirdwx.qlogo.cn/mmopen/vi_32/qf3MbFEPq9KaKuEVL17uWqetwibFyNN3jwyYGzn50Fl5meBwxEEph13kwCj8xyLNypNN3pT82lQpQbN889macwA/132',0,26,NULL,NULL,NULL,NULL,NULL,NULL,0,2,2),(46,'oAM70s2PQ8b0ZUXlpGx0n7WRdRbU',NULL,'长水',NULL,',,',NULL,NULL,NULL,'https://thirdwx.qlogo.cn/mmopen/vi_32/pahOk9F6hUmFPDM0ictFE6W1bcmVBUJucmKkdAbYPGbB69fOcrhUeXZeMY5f0K2iaUp16Wjvg0z3cc7uBQcgGjkA/132',0,30,NULL,NULL,NULL,NULL,NULL,NULL,0,2,2),(47,'oAM70s4_c20bL0MSuTiKVap0ci64',NULL,'微信用户',NULL,',,',NULL,NULL,NULL,'https://thirdwx.qlogo.cn/mmopen/vi_32/Q3auHgzwzM7lOvLdaWicyqr5ks6b5ibx71IXYbc5R3hf2poB2uzaISVwicAI4T1MXVOn3ofbAyQUrTkWlK2J59Hjg/132',0,30,NULL,NULL,NULL,NULL,NULL,NULL,0,2,2),(48,'osnBC6JuOuCCAPWW4_OMx8-6lc3o',NULL,'浪漫?坏人15971056588',NULL,',,',NULL,NULL,NULL,'https://thirdwx.qlogo.cn/mmopen/vi_32/Q0j4TwGTfTL2I4ScnbYo9iaRztibRibPNuQO1Iv7Oicmn4E229l9X3as7WSFw6bMibbhxdaMC6RCK2zY28yTxXAric7A/132',0,26,NULL,NULL,NULL,NULL,NULL,NULL,0,2,2),(49,'oAM70s7zw4hOPxpJgddWp2PRXomU',NULL,'微信用户',NULL,',,',NULL,NULL,NULL,'https://thirdwx.qlogo.cn/mmopen/vi_32/Q3auHgzwzM7lOvLdaWicyqr5ks6b5ibx7164XYiby9mOkYWN98QNZvtdrsBYAx1UUP6c1NLiatxlypDGRsoVeSIkRA/132',0,31,NULL,NULL,NULL,NULL,NULL,NULL,0,2,2),(50,'osnBC6KFMV6Z6phqb5Va1wjOcoIc',NULL,'微信用户',NULL,',,',NULL,NULL,NULL,'https://thirdwx.qlogo.cn/mmopen/vi_32/Q3auHgzwzM4etcWAiaVAE4diaAc2YmNW4giaHN5L3Ax83xF7JITbVzQmy7UdAgyYp6V6nSEhb8iatQSnn6xD1EHg4w/132',0,26,NULL,NULL,NULL,NULL,NULL,NULL,0,2,2),(51,'osnBC6NGNcbzMoXdIzIlf5_ZqmVg',NULL,'庆幸',NULL,',,',NULL,NULL,NULL,'https://thirdwx.qlogo.cn/mmopen/vi_32/Q0j4TwGTfTJPrSL3xMVKHezZxgfNsrrA4DQAkW7PGZgOjFFC8MALfQibL7xfb4wvsqv4Ge3fp8ZszIIH6A97sqQ/132',0,26,NULL,NULL,NULL,NULL,NULL,NULL,0,2,2),(52,'oAM70s7VldyYcobTyUhfpeJliRig',NULL,'微信用户',NULL,',,',NULL,NULL,NULL,'https://thirdwx.qlogo.cn/mmopen/vi_32/Q3auHgzwzM7lOvLdaWicyqr5ks6b5ibx71uozmoBf78ZTf3Xfsj03XzJfZG4SKkKDyiccACh4yryl3vGrJ832ydUg/132',0,30,NULL,NULL,NULL,NULL,NULL,NULL,0,2,2),(53,'osnBC6FACNp9WSVqECGve-Q8OjnU',NULL,'凡哥装修（专业家装贴砖）',NULL,',,',NULL,NULL,NULL,'https://thirdwx.qlogo.cn/mmopen/vi_32/Q0j4TwGTfTKzqI6QDsTCebicW3lKH33IrTU6kUkbew3iaNU9uErobcu28O1HzNrzFN7vurz0ZhVLDLqHRAaVZMDw/132',0,26,NULL,NULL,NULL,NULL,NULL,NULL,0,2,2),(54,'oAM70s7CjeSX5pKxS9BPigwuCYJE',NULL,'微信用户',NULL,',,',NULL,NULL,NULL,'https://thirdwx.qlogo.cn/mmopen/vi_32/Q3auHgzwzM7lOvLdaWicyqr5ks6b5ibx714UVibibdwCtRUZsR6cecWw8EXzUguzzq2mD3rZAuT7HGUJBlUZMnsSNw/132',0,30,NULL,NULL,NULL,NULL,NULL,NULL,0,2,2),(55,'oAM70s7_Gw6v_o5OZeZjU7mBTBrQ',NULL,'蓝天',NULL,',,',NULL,NULL,NULL,'https://thirdwx.qlogo.cn/mmopen/vi_32/PChZ2tYjBiaEZfKfnO3ic54Zse8txeuDibGfzicV9ET5FHeaTJ0hWvntJOy0Uo4at8fXUpj7UfflUAsHzO5VTSic6JA/132',0,30,NULL,NULL,NULL,NULL,NULL,NULL,0,2,2),(56,'osnBC6B9ljUWDvKsnUGpcIHaG9JU',NULL,'微信用户',NULL,',,',NULL,NULL,NULL,'https://thirdwx.qlogo.cn/mmopen/vi_32/Q3auHgzwzM5N4GVkocaXdQQyokWdMzKoJppLEthgMOw8iaajle9Zm4fQ09ljbFZGAPuGgmC1OoRp1iaEUQiaTzngQ/132',0,26,NULL,NULL,NULL,NULL,NULL,NULL,0,2,2),(57,'osnBC6FtEB5yxhCS7YMv2xLC_Osk',NULL,'大明',NULL,',,',NULL,NULL,NULL,'https://thirdwx.qlogo.cn/mmopen/vi_32/uTYfev4Jg7ibkfcO9jJ8EWJLPBUiaobAeAkdkUdntqyu1FY70Kv9KWibk6cdf2iaRiauRALYkSx5ACzE4ZXJRwoOx5g/132',0,26,NULL,NULL,NULL,NULL,NULL,NULL,0,2,2),(58,'osnBC6DeZeOlCspdL1wBLF9q92wk',NULL,'微信用户',NULL,',,',NULL,NULL,NULL,'https://thirdwx.qlogo.cn/mmopen/vi_32/Q3auHgzwzM48DwX2vhtv7GsjemXUYyTiaXLfsBK4icmMS7oChNlYmXOZfeZicoPktmIKjia301AlYfp73ButQv9Kng/132',0,26,NULL,NULL,NULL,NULL,NULL,NULL,0,2,2),(59,'osnBC6KENiLE752YjXcEyL9Olm-0',NULL,'等待18972233556',NULL,',,',NULL,NULL,NULL,'https://thirdwx.qlogo.cn/mmopen/vi_32/Q0j4TwGTfTLXY5BxNRPVibW1dz4rex4VhzpWZMhkJ1uO5ibucxOhIeq24GdYekvib516ibkr9jD98LM3yuz2xlDuicg/132',0,26,NULL,NULL,NULL,NULL,NULL,NULL,0,2,2),(60,'osnBC6HueOKQONvHM08nWcKKMEmk',NULL,'微信用户',NULL,',,',NULL,NULL,NULL,'https://thirdwx.qlogo.cn/mmopen/vi_32/Q3auHgzwzM46Ig04f2CIP9hc9icckd0ZRlEO3M114bVDHZ3XVHMMXx8QGoIsr4H1NpiaLMGy024vk9O6JEmJWWibQ/132',0,26,NULL,NULL,NULL,NULL,NULL,NULL,0,2,2),(61,'osnBC6MDnwES6uzElKcB6570L5nE',NULL,'蓝色的梦',NULL,',,',NULL,NULL,NULL,'https://thirdwx.qlogo.cn/mmopen/vi_32/bMMZRFtrhzuL99pRekMEjebWn0wGoNZic3FKsGoLDBu6ItBWOHtz6gvpiaSTAF6nuHJiaU5ibAKwjMq7d8CPqeCzbQ/132',0,26,NULL,NULL,NULL,NULL,NULL,NULL,0,2,2),(62,'osnBC6GFUsZS93i9zl9oTAbkaQSU',NULL,'微信用户',NULL,',,',NULL,NULL,NULL,'https://thirdwx.qlogo.cn/mmopen/vi_32/Q3auHgzwzM5N4GVkocaXdQQyokWdMzKoRCoJ2pIeicz9qicBR5LTCibLXn6SZyAIy3r32vVQFBDVlIG40J3MP6xeA/132',0,26,NULL,NULL,NULL,NULL,NULL,NULL,0,2,2),(63,'osnBC6HiXbe-xBQvBNFVQvTPfE8I',NULL,'青松',NULL,',,',NULL,NULL,NULL,'https://thirdwx.qlogo.cn/mmopen/vi_32/Q0j4TwGTfTInjsauxBt7ATiasuibZaGAqIs7ByRsBahVYucSp01rlDz2W4aicHf8ibQYVDGGRFkTeJDFJQGS0Fy0GQ/132',0,26,NULL,NULL,NULL,NULL,NULL,NULL,0,2,2),(64,'osnBC6OR7YblUD3kBSVizcdWmD8o',NULL,'微信用户',NULL,',,',NULL,NULL,NULL,'https://thirdwx.qlogo.cn/mmopen/vi_32/Q3auHgzwzM5N4GVkocaXdQQyokWdMzKoIFibuv7EmLF4EWTINT894qG3eGJkFq8Qib6riaBQLe7AKQWSSK28hVsKw/132',0,26,NULL,NULL,NULL,NULL,NULL,NULL,0,2,2),(65,'osnBC6BoUdhxFsKA7svNBoPbkKJk',NULL,'鞠宏军15971119551专业铺贴大板砖',NULL,',,',NULL,NULL,NULL,'https://thirdwx.qlogo.cn/mmopen/vi_32/OyLC5gawKzpE1PUcvicpCue2Y2IZel3ImkibbWicleW1WQuRvCq6XRp74p69vkQ7j5rdBeBic7yRLE1q9IWXaP9FnQ/132',0,26,NULL,NULL,NULL,NULL,NULL,NULL,0,2,2),(66,'oAM70sxkg4-8ZBgF57YKtpGc7cVo',NULL,'闲云清烟',NULL,',,',NULL,NULL,NULL,'https://thirdwx.qlogo.cn/mmopen/vi_32/xKowuQlCsHGOQ2ulkibibF92tqdM7iavjkw69dsBRFnzMyQ3TL2TcpKm7z92NEjLtJpk8ibavXJuEMcrBEW8GL7uiaw/132',0,30,NULL,NULL,NULL,NULL,NULL,NULL,0,2,2),(67,'osnBC6OPadCdY77BfGZOaVhbgjak','18330118047','文寒','文寒啊','北京市 市辖区 东城区','2022-08-23','130525199306103614',NULL,'https://thirdwx.qlogo.cn/mmopen/vi_32/Q0j4TwGTfTJqRybMPxFXbrViaPUG6KOnDQaPGAYhesicctnibfnpYM1PoG0WHgEcs8ianAXe9PxibmxnsPXfxF5L4ew/132',0,29,NULL,NULL,950.00,NULL,NULL,NULL,0,2,2),(68,'osnBC6PO01P2BazlRPH9LDsobRak',NULL,'防伪标签程朝阳13343217111',NULL,',,',NULL,NULL,NULL,'https://thirdwx.qlogo.cn/mmopen/vi_32/Q0j4TwGTfTKic7Ib0r36372mp9dEa2tRloA1NN8kCsLBOaPj1iafIcv1BdeWXINoT1lXF0lssg194796xpBticzpg/132',0,29,NULL,NULL,100.00,NULL,NULL,NULL,0,2,2),(69,'oAM70s2bZqQNmrmwgse2MHcZH3No',NULL,'有人的地方就有江湖',NULL,',,',NULL,NULL,NULL,'https://thirdwx.qlogo.cn/mmopen/vi_32/DYAIOgq83ervrlNxhUlXQlK7o3uIZ5XW7kyq5fN7PLKAPek3FXib9rAb1rlsywVMo7ClkIg1aynJonR6NPZmmYg/132',0,30,NULL,NULL,0.00,NULL,NULL,NULL,0,2,2),(70,'oAM70s5sxbkvUaEUPR6hCJJohX14',NULL,'微信用户',NULL,',,',NULL,NULL,NULL,'https://thirdwx.qlogo.cn/mmopen/vi_32/Q3auHgzwzM7lOvLdaWicyqr5ks6b5ibx71w7IeoTnvlPbozEdGu5OLib0yqIicD0jU4IYj9eIGbf7X36Asw680cvYw/132',0,30,NULL,NULL,0.00,NULL,NULL,NULL,0,2,2),(71,'osnBC6KXf5mO5-ROp9Mz7o9Sg3JM',NULL,'微信用户',NULL,',,',NULL,NULL,NULL,'https://thirdwx.qlogo.cn/mmopen/vi_32/Q3auHgzwzM4etcWAiaVAE4diaAc2YmNW4gSl7a60IlU61Mgnibh27FNbNH5FQWapGJ7QhIT0cNqwlXK95DCpcZjyw/132',0,26,NULL,NULL,0.00,NULL,NULL,NULL,0,2,2),(72,'osnBC6PlHzXAM0EFeQXFhoqdDjBA',NULL,'等时光的人',NULL,',,',NULL,NULL,NULL,'https://thirdwx.qlogo.cn/mmopen/vi_32/j88qszbZFZibkk7uAZV5YV9dwXHeXE47QgkG5lrgia7k04aBKW9T9yEVnu8ySCle7w2UyxtNq8AZGt9tOxuTOdMQ/132',0,26,NULL,NULL,0.00,NULL,NULL,NULL,0,2,2),(73,'osnBC6On-5GsykOXYj_zsr5A0IuU',NULL,'微信用户',NULL,',,',NULL,NULL,NULL,'https://thirdwx.qlogo.cn/mmopen/vi_32/Q3auHgzwzM48DwX2vhtv7GsjemXUYyTiaz4nyJNZsefjpyzUun6v4F04S7QobCvA5EtgfRSqzSz80VmfuoFoOCg/132',0,26,NULL,NULL,0.00,NULL,NULL,NULL,0,2,2),(74,'osnBC6MsSzKSM09Xp9ZAzoQC_Q3o',NULL,'Aurora',NULL,',,',NULL,NULL,NULL,'https://thirdwx.qlogo.cn/mmopen/vi_32/Q0j4TwGTfTI4th6RUNriaSNUqicicLNclpqBicLib8AZa0DWkH8Q5XbgBibDA3fv2Y5nT4bvxINq78HpaTJW4Cj5vqDQ/132',0,26,NULL,NULL,0.00,NULL,NULL,NULL,0,2,2),(75,'osnBC6F3vpSmWX7H8AucUSg5cxyg',NULL,'微信用户',NULL,',,',NULL,NULL,NULL,'https://thirdwx.qlogo.cn/mmopen/vi_32/Q3auHgzwzM4etcWAiaVAE4diaAc2YmNW4gubSiaMcqhL19BGPKTsWZveCgDDYbyHic9lF33Jt3gB5PsMicqFOI6lvxw/132',0,26,NULL,NULL,0.00,NULL,NULL,NULL,0,2,2),(76,'osnBC6KrvelwFz8q4Kl7iKEa-F4Q',NULL,'微信用户',NULL,',,',NULL,NULL,NULL,'https://thirdwx.qlogo.cn/mmopen/vi_32/Q3auHgzwzM5PibZS7hYMSYwQCZd2sKVbA5g49n3ODfJEuZQkqxaGygGw6HAmBcIcswOVxxdMfiaPIT9KxLu2XRQQ/132',0,26,NULL,NULL,0.00,NULL,NULL,NULL,0,2,2),(77,'osnBC6IjKPDCWVH3BL1R0IpPqOG0',NULL,'红',NULL,',,',NULL,NULL,NULL,'https://thirdwx.qlogo.cn/mmopen/vi_32/Q0j4TwGTfTKhYBWcbxfPYOqwJBJs7M4RmcC4s5wKsGnvPpxyZHOK3NEk506LczNPBSQ9VUYnq4GYfgNzdPTeWg/132',0,26,NULL,NULL,0.00,NULL,NULL,NULL,0,2,2),(78,'oAM70s108tDxBk9RO-4avR2m4g9k',NULL,'微信用户',NULL,',,',NULL,NULL,NULL,'https://thirdwx.qlogo.cn/mmopen/vi_32/Q3auHgzwzM7lOvLdaWicyqr5ks6b5ibx71ibQBuwVRByagIaiaibONoibkwBPjmZ0hpH8rwEP7RBpR59TRJaZicgcxpBA/132',0,30,NULL,NULL,0.00,NULL,NULL,NULL,0,2,2),(79,'oAM70szwIICtYtQauw8wdvgQk0FU',NULL,'东18931218025',NULL,',,',NULL,NULL,NULL,'https://thirdwx.qlogo.cn/mmopen/vi_32/Q0j4TwGTfTKuBBITVkpA7icicrBTG5UtiauZiaibcJP5ic649icvRwzkcicQtjwRS9TPAullshJYWX2fxOPHQEs6RZZABw/132',0,30,NULL,NULL,0.00,NULL,NULL,NULL,0,2,2),(80,'osnBC6HAYZAZxqGuxVyf2qLnC8W0',NULL,'范伟(专业贴砖)15071538095',NULL,',,',NULL,NULL,NULL,'https://thirdwx.qlogo.cn/mmopen/vi_32/lZiahGR3Q6ZMuibxsn5ybd07rqpYibjXiaggELawHWDTNUBomsKIwQRN5mORFJ4FGFtOHGtsIyibTU8gfZl2rryHhBQ/132',0,26,NULL,NULL,0.00,NULL,NULL,NULL,0,2,2),(81,'oGB_Z5_s9LWdEZYYVbEAsDSo6wwM',NULL,'文寒',NULL,',,',NULL,NULL,NULL,'https://thirdwx.qlogo.cn/mmopen/vi_32/Q0j4TwGTfTKqDr29Nb5FkfbTsKzEUB8V7hwz0aQqsgFz3TcarkzhHC5IPQC9Z4e4jALH7TZmXvWWXuBacibHS8A/132',0,29,NULL,NULL,0.00,NULL,NULL,NULL,0,2,2),(82,'oe60X6k15tFeaU-JL-AK2VYYxXYk',NULL,'文寒',NULL,',,',NULL,NULL,NULL,'https://thirdwx.qlogo.cn/mmopen/vi_32/Q0j4TwGTfTJVMzaflj5208cYRojEaYzXjm4j4TRJxMHpuJwXDvZD92P1llqAHlj34P1DGXHDgb16HMF83tCIug/132',0,29,NULL,NULL,0.00,NULL,NULL,NULL,0,2,2),(83,'oe60X6jtyJSuOtnP2dq_xl_uQOgs',NULL,'暴风雨',NULL,',,',NULL,NULL,NULL,'https://thirdwx.qlogo.cn/mmopen/vi_32/YXr2VhxJpdiaBguJgLGAouHCMXgdgOdmb61DUT18vXJUAbs5ic5KNGlImSf7dvlqWJBwLZZ3mx5EEU0nDuPEIamg/132',0,29,NULL,NULL,0.00,NULL,NULL,NULL,0,2,2),(84,'oe60X6tqWr1ymak8geTO-NjQX9sw',NULL,'微信用户',NULL,',,',NULL,NULL,NULL,'https://thirdwx.qlogo.cn/mmopen/vi_32/Q3auHgzwzM5JXzyupjvft99OYVicRibgrl0R2HibsdMXCVicxDExJdgBYTj08y28kiafhDEkCWGclXRE5DYrLmQgtFw/132',0,29,NULL,NULL,0.00,NULL,NULL,NULL,0,2,2),(85,'oe60X6lJHisC1BA4MLd5y16UcbsE',NULL,'壹蕭謡',NULL,',,',NULL,NULL,NULL,'https://thirdwx.qlogo.cn/mmopen/vi_32/DYAIOgq83eqPicsH1bxMm7yveiaNvw6o0qib3dJ4Nic8SSHqib7KRFkrMXxhKb53iaK5QvEgRVp4hFkdExEsRPler7lw/132',0,29,NULL,NULL,0.00,NULL,NULL,NULL,0,2,2);
/*!40000 ALTER TABLE `ctc_dealer_member` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ctc_dealer_member_address`
--

DROP TABLE IF EXISTS `ctc_dealer_member_address`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ctc_dealer_member_address` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `dealer_id` int(11) DEFAULT NULL,
  `openid` varchar(255) DEFAULT NULL,
  `consignee` varchar(255) DEFAULT NULL COMMENT '收货人',
  `address` varchar(255) DEFAULT NULL COMMENT '地址',
  `location` varchar(255) DEFAULT NULL COMMENT '详细地址',
  `phone` varchar(255) DEFAULT NULL COMMENT '手机号',
  `is_default` tinyint(4) DEFAULT '1' COMMENT '默认地址',
  `is_dele` tinyint(4) DEFAULT '0' COMMENT '是否删除0正常 1删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ctc_dealer_member_address`
--

LOCK TABLES `ctc_dealer_member_address` WRITE;
/*!40000 ALTER TABLE `ctc_dealer_member_address` DISABLE KEYS */;
INSERT INTO `ctc_dealer_member_address` VALUES (1,29,'osnBC6OPadCdY77BfGZOaVhbgjak','563','北京市 市辖区 东城区','大萨达所','18330118047',1,1),(2,29,'osnBC6OPadCdY77BfGZOaVhbgjak','fds','北京市 市辖区 东城区','541','18330118047',1,1),(3,29,'osnBC6OPadCdY77BfGZOaVhbgjak','322','北京市 市辖区 西城区','5','18330118047',1,1),(4,29,'osnBC6OPadCdY77BfGZOaVhbgjak','6536555','天津市 市辖区 和平区','555','18330118047',1,1),(5,29,'osnBC6OPadCdY77BfGZOaVhbgjak','测试','北京市 市辖区 东城区','哈哈哈','18330118047',1,0),(6,29,'osnBC6OPadCdY77BfGZOaVhbgjak','张三','河北省 石家庄市 长安区','长安区','18330118046',2,0);
/*!40000 ALTER TABLE `ctc_dealer_member_address` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ctc_dealer_member_bill`
--

DROP TABLE IF EXISTS `ctc_dealer_member_bill`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
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
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COMMENT='会员资产明细';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ctc_dealer_member_bill`
--

LOCK TABLES `ctc_dealer_member_bill` WRITE;
/*!40000 ALTER TABLE `ctc_dealer_member_bill` DISABLE KEYS */;
INSERT INTO `ctc_dealer_member_bill` VALUES (6,67,1,1,100,1,29,'测试',NULL,'2022-08-22 17:18:58',3),(7,68,1,1,100,1,29,'免费使用',NULL,'2022-08-23 08:43:44',3),(8,67,1,1,1000,1,29,'',NULL,'2022-08-25 16:13:01',3);
/*!40000 ALTER TABLE `ctc_dealer_member_bill` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ctc_dealer_member_tag`
--

DROP TABLE IF EXISTS `ctc_dealer_member_tag`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ctc_dealer_member_tag` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `tag_name` varchar(255) DEFAULT NULL,
  `remark` varchar(255) DEFAULT NULL,
  `wechat_id` varchar(255) DEFAULT NULL COMMENT '微信分配标签id',
  `dealer_id` int(11) DEFAULT NULL,
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ctc_dealer_member_tag`
--

LOCK TABLES `ctc_dealer_member_tag` WRITE;
/*!40000 ALTER TABLE `ctc_dealer_member_tag` DISABLE KEYS */;
INSERT INTO `ctc_dealer_member_tag` VALUES (7,'水电工','咖乐防水','115',26,'2022-05-11 08:05:14'),(8,'测试','111','116',29,'2022-07-23 11:50:42'),(9,'标签1','标签1','100',30,'2022-07-23 11:54:18');
/*!40000 ALTER TABLE `ctc_dealer_member_tag` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ctc_dealer_menu`
--

DROP TABLE IF EXISTS `ctc_dealer_menu`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
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
) ENGINE=InnoDB AUTO_INCREMENT=234 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ctc_dealer_menu`
--

LOCK TABLES `ctc_dealer_menu` WRITE;
/*!40000 ALTER TABLE `ctc_dealer_menu` DISABLE KEYS */;
INSERT INTO `ctc_dealer_menu` VALUES (1,'系统','M',0,0,NULL,'system',NULL,'system','1',0,0,NULL,NULL,0,NULL,'2021-11-10 07:28:49'),(2,'首页','C',0,1,NULL,'home','system/home','home','1',0,1,NULL,NULL,0,NULL,'2021-11-10 07:30:02'),(3,'账户管理','M',0,1,NULL,'account',NULL,'user','1',0,0,NULL,NULL,0,NULL,'2021-11-10 07:31:09'),(4,'账户信息','C',0,3,NULL,'accountInfo','system/account/accountInfo',NULL,'1',0,0,NULL,NULL,0,NULL,'2021-11-10 07:32:02'),(5,'资质认证','C',0,3,NULL,'quaAuth','system/account/auth',NULL,'1',0,1,NULL,NULL,0,NULL,'2021-11-10 07:33:42'),(6,'用户管理','M',0,1,NULL,'user',NULL,'user','1',0,0,NULL,NULL,0,NULL,'2021-11-10 07:37:42'),(7,'账号管理','C',0,6,NULL,'member','system/user/member',NULL,'1',0,0,NULL,NULL,0,NULL,'2021-11-10 07:39:52'),(8,'角色管理','C',0,6,NULL,'role','system/user/role',NULL,'1',0,0,NULL,NULL,0,NULL,'2021-11-10 07:40:19'),(9,'系统管理','M',0,1,NULL,'systemManage',NULL,'sys-set','1',0,0,NULL,NULL,0,NULL,'2021-11-10 07:43:11'),(10,'语言地区配置','C',0,9,NULL,'language','systemManage/language',NULL,'1',0,1,NULL,NULL,0,NULL,'2021-11-10 07:44:02'),(11,'税费模板','C',0,9,NULL,'taxation','system/systemManage/taxation',NULL,'1',0,0,NULL,NULL,0,NULL,'2021-11-10 07:44:46'),(12,'仓库管理','C',0,9,NULL,'warehouse','system/systemManage/warehouse',NULL,'1',0,0,NULL,NULL,0,NULL,'2021-11-10 07:45:47'),(13,'支付管理','C',0,9,NULL,'payment','system/systemManage/payment',NULL,'1',0,0,NULL,NULL,0,NULL,'2021-11-10 07:46:18'),(14,'运费模板','C',0,9,NULL,'freight','system/systemManage/freight',NULL,'1',0,0,NULL,NULL,0,NULL,'2021-11-10 07:47:12'),(15,'系统操作日志','C',0,9,NULL,'operationLog','system/systemManage/operationLog',NULL,'1',0,0,NULL,NULL,0,NULL,'2021-11-10 07:47:59'),(16,'对接','M',0,0,NULL,'access',NULL,'access','1',0,1,NULL,NULL,0,NULL,'2021-11-10 07:56:34'),(17,'公众号管理','M',0,16,NULL,'officialAccount',NULL,'mp','1',0,0,NULL,NULL,0,NULL,'2021-11-10 07:59:28'),(18,'公众号授权','C',0,17,NULL,'officialAuth','access/officialAccount/auth',NULL,'1',0,1,NULL,NULL,0,NULL,'2021-11-10 08:00:16'),(19,'带参数二维码','C',0,17,NULL,'qrcode','access/officialAccount/qrcode',NULL,'1',0,0,NULL,NULL,0,NULL,'2021-11-10 08:01:11'),(20,'素材管理','C',0,17,NULL,'material','access/officialAccount/material',NULL,'1',0,0,NULL,NULL,0,NULL,'2021-11-10 08:02:11'),(21,'群发消息','C',0,17,NULL,'mass','officialAccount/mass',NULL,'1',0,1,NULL,NULL,0,NULL,'2021-11-10 08:05:06'),(22,'钉钉管理','M',0,16,NULL,'dingding',NULL,'dingding','1',0,1,NULL,NULL,0,NULL,'2021-11-10 08:07:10'),(23,'钉钉授权','C',0,22,NULL,'dingAuth','access/dingding/auth',NULL,'1',0,0,NULL,NULL,0,NULL,'2021-11-10 08:08:05'),(24,'有赞管理','M',0,16,NULL,'zan',NULL,'zan','1',0,1,NULL,NULL,0,NULL,'2021-11-10 08:09:04'),(25,'有赞授权','C',0,24,NULL,'zanAuth','access/zan/auth',NULL,'1',0,0,NULL,NULL,0,NULL,'2021-11-10 08:09:33'),(26,'监控设备管理','M',0,16,NULL,'monitor',NULL,'monitor','1',0,1,NULL,NULL,0,NULL,'2021-11-10 08:12:12'),(27,'设备列表','C',0,26,NULL,'monitorList','access/monitor/index',NULL,'1',0,0,NULL,NULL,0,NULL,'2021-11-10 08:12:46'),(28,'基础配置','C',0,26,NULL,'monitorSet','access/monitor/set',NULL,'1',0,0,NULL,NULL,0,NULL,'2021-11-10 08:13:18'),(29,'码库','M',0,0,NULL,'codeStore',NULL,'code','1',0,0,NULL,NULL,0,NULL,'2021-11-11 14:15:09'),(30,'二维码管理','M',0,29,NULL,'qrcode','','qrcode','1',0,0,NULL,NULL,0,NULL,'2021-11-11 14:17:11'),(31,'生码管理','C',0,30,NULL,'createCode','codeStore/qrcode/code',NULL,'1',0,0,NULL,NULL,0,NULL,'2021-11-11 14:19:16'),(32,'作废管理','C',0,30,NULL,'invalidCode','codeStore/qrcode/invalid',NULL,'1',0,1,NULL,NULL,0,NULL,'2021-11-11 14:20:12'),(33,'扫码黑名单','M',0,29,NULL,'blacklist',NULL,'blacklist','1',0,1,NULL,NULL,0,NULL,'2021-11-11 14:22:32'),(34,'黑名单管理','C',0,33,NULL,'blacklist','codeStore/blacklist/index',NULL,'1',0,0,NULL,NULL,0,NULL,'2021-11-11 14:23:11'),(35,'黑名单设置','C',0,33,NULL,'blacklistSet','codeStore/blacklist/set',NULL,'1',0,0,NULL,NULL,0,NULL,'2021-11-11 14:23:49'),(36,'小程序扫码管理','M',0,29,NULL,'miniPro',NULL,'mini-code','1',0,1,NULL,NULL,0,NULL,'2021-11-11 14:25:56'),(37,'自定义首页内容','C',0,36,NULL,'miniPro','miniPro/index',NULL,'1',0,0,NULL,NULL,0,NULL,'2021-11-11 14:26:54'),(38,'自定义扫码页','C',0,36,NULL,'miniProScan','miniPro/scan',NULL,'1',0,0,NULL,NULL,0,NULL,'2021-11-11 14:27:36'),(39,'资产','M',0,0,NULL,'assets',NULL,'assets','1',0,0,NULL,NULL,0,NULL,'2021-11-11 14:39:35'),(40,'产品库','M',0,39,NULL,'product',NULL,'product','1',0,1,NULL,NULL,0,NULL,'2021-11-11 14:40:26'),(41,'产品管理','C',0,40,NULL,'product','assets/product/index',NULL,'1',0,0,NULL,NULL,0,NULL,'2021-11-11 14:40:59'),(42,'产品分组','C',0,40,NULL,'productClass','assets/product/class',NULL,'1',0,0,NULL,NULL,0,NULL,'2021-11-11 14:41:38'),(43,'礼品库','M',0,39,NULL,'gift',NULL,'gift','1',0,0,NULL,NULL,0,NULL,'2021-11-11 14:43:09'),(44,'礼品管理','C',0,43,NULL,'giftList','assets/gift/index',NULL,'1',0,0,NULL,NULL,0,NULL,'2021-11-11 14:43:41'),(45,'礼品分组','C',0,43,NULL,'giftClass','assets/gift/class',NULL,'1',0,0,NULL,NULL,0,NULL,'2021-11-11 14:44:11'),(46,'红包','M',0,39,NULL,'redpack',NULL,'redpack','1',0,0,NULL,NULL,0,NULL,'2021-11-11 14:45:54'),(47,'红包管理','C',0,46,NULL,'repackList','assets/redpack/index',NULL,'1',0,0,NULL,NULL,0,NULL,'2021-11-11 14:46:24'),(48,'红包明细','C',0,46,NULL,'redpackBill','assets/redpack/bill',NULL,'1',0,0,NULL,NULL,0,NULL,'2021-11-11 14:46:54'),(49,'代发红包池','C',0,46,NULL,'repackPoll','assets/redpack/pool',NULL,'1',0,1,NULL,NULL,0,NULL,'2021-11-11 14:48:05'),(50,'积分','M',0,39,NULL,'integral',NULL,'integral','1',0,0,NULL,NULL,0,NULL,'2021-11-11 14:49:52'),(51,'积分管理','C',0,50,NULL,'pointsList','assets/integral/index',NULL,'1',0,0,NULL,NULL,0,NULL,'2021-11-11 14:50:19'),(52,'积分明细','C',0,50,NULL,'pointsBill','assets/integral/bill',NULL,'1',0,0,NULL,NULL,0,NULL,'2021-11-11 14:50:42'),(53,'短信包','M',0,39,NULL,'sms',NULL,'sms','1',0,1,NULL,NULL,0,NULL,'2021-11-11 14:52:23'),(54,'短信管理','C',0,53,NULL,'smsList','assets/sms/index',NULL,'1',0,0,NULL,NULL,0,NULL,'2021-11-11 14:52:45'),(55,'发送记录','C',0,53,NULL,'smsLog','assets/sms/log',NULL,'1',0,0,NULL,NULL,0,NULL,'2021-11-11 14:53:10'),(56,'素材库','M',0,39,NULL,'material',NULL,'dashboard','1',0,0,NULL,NULL,0,NULL,'2021-11-11 14:54:01'),(57,'素材库管理','C',0,56,NULL,'materiallList','assets/material/index',NULL,'1',0,0,NULL,NULL,0,NULL,'2021-11-11 14:54:52'),(58,'订单','M',0,0,NULL,'order',NULL,'order','1',0,0,NULL,NULL,0,NULL,'2021-11-11 16:06:22'),(59,'订单管理','M',0,58,NULL,'orderManage',NULL,'order','1',0,0,NULL,NULL,0,NULL,'2021-11-11 16:07:50'),(60,'营销奖品订单','C',0,59,NULL,'marketingOrder','order/orderManage/marketingOrder',NULL,'1',0,0,NULL,NULL,0,NULL,'2021-11-11 16:09:24'),(61,'积分商城订单','C',0,59,NULL,'integralOrder','order/orderManage/integralOrder',NULL,'1',0,0,NULL,NULL,0,NULL,'2021-11-11 16:10:08'),(62,'微商城订单','C',0,59,NULL,'shopOrder','order/orderManage/shopOrder',NULL,'1',0,1,NULL,NULL,0,NULL,'2021-11-11 16:10:34'),(63,'多门店商城订单','C',0,59,NULL,'multiStoreOrder','order/multiStoreOrder',NULL,'1',0,1,NULL,NULL,0,NULL,'2021-11-11 16:11:21'),(64,'订单设置','M',0,58,NULL,'orderSet',NULL,'order-set','1',0,1,NULL,NULL,0,NULL,'2021-11-11 16:12:47'),(65,'订单设置','C',0,64,NULL,'orderSet','orderSet/index',NULL,'1',0,0,NULL,NULL,0,NULL,'2021-11-11 16:13:15'),(66,'核销管理','M',0,58,NULL,'check',NULL,'hexiao','1',0,1,NULL,NULL,0,NULL,'2021-11-11 16:16:11'),(67,'核销记录','C',0,66,NULL,'checkList','check/index',NULL,'1',0,0,NULL,NULL,0,NULL,'2021-11-11 16:16:37'),(68,'报销管理','C',0,66,NULL,'reimbursement','check/reimbursement',NULL,'1',0,0,NULL,NULL,0,NULL,'2021-11-11 16:17:19'),(69,'核销统计','C',0,66,NULL,'statistics','check/statistics',NULL,'1',0,0,NULL,NULL,0,NULL,'2021-11-11 16:17:46'),(70,'核销预约','C',0,66,NULL,'appointment','check/appointment',NULL,'1',0,0,NULL,NULL,0,NULL,'2021-11-11 16:18:15'),(71,'客户','M',0,0,NULL,'customer',NULL,'customer','1',0,0,NULL,NULL,0,NULL,'2021-11-11 16:23:42'),(72,'会员管理','M',0,71,NULL,'member',NULL,'member','1',0,0,NULL,NULL,0,NULL,'2021-11-11 16:25:56'),(73,'会员列表','C',0,72,NULL,'memberList','customer/member/index',NULL,'1',0,0,NULL,NULL,0,NULL,'2021-11-11 16:26:15'),(74,'会员标签管理','C',0,72,NULL,'memberTags','customer/member/tag',NULL,'1',0,0,NULL,NULL,0,NULL,'2021-11-11 16:26:37'),(75,'自定义字段管理','C',0,72,NULL,'customField','customer/member/field',NULL,'1',0,0,NULL,NULL,0,NULL,'2021-11-11 16:27:27'),(76,'表单活动会员白名单','C',0,72,NULL,'memberWhiteList','member/whiteList',NULL,'1',0,0,NULL,NULL,0,NULL,'2021-11-11 16:28:26'),(77,'经销商管理','M',0,71,NULL,'distributor',NULL,'user','1',0,1,NULL,NULL,0,NULL,'2021-11-11 16:29:01'),(78,'经销商管理','C',0,77,NULL,'distributorList','customer/distributor/index',NULL,'1',0,0,NULL,NULL,0,NULL,'2021-11-11 16:29:36'),(79,'经销商级别管理','C',0,77,NULL,'distributorLevel','customer/distributor/level',NULL,'1',0,0,NULL,NULL,0,NULL,'2021-11-11 16:29:59'),(80,'经销商结构树','C',0,77,NULL,'distributorTree','distributor/tree',NULL,'1',0,1,NULL,NULL,0,NULL,'2021-11-11 16:30:31'),(82,'邀请注册设置','C',0,77,NULL,'inviteRegister','customer/distributor/register',NULL,'1',0,0,NULL,NULL,0,NULL,'2021-11-11 16:32:18'),(83,'门店管理','M',0,71,NULL,'store',NULL,'store','1',0,0,NULL,NULL,0,NULL,'2021-11-11 16:35:34'),(84,'门店管理','C',0,83,NULL,'storeList','customer/store/index',NULL,'1',0,0,NULL,NULL,0,NULL,'2021-11-11 16:36:04'),(85,'店员管理','C',0,83,NULL,'clerk','customer/store/clerk',NULL,'1',0,0,NULL,NULL,0,NULL,'2021-11-11 16:37:58'),(86,'门店类型管理','C',0,83,NULL,'storeType','customer/store/type',NULL,'1',0,0,NULL,NULL,0,NULL,'2021-11-11 16:38:26'),(87,'门店佣金管理','C',0,83,NULL,'commission','customer/store/commission',NULL,'1',0,0,NULL,NULL,0,NULL,'2021-11-11 16:38:50'),(88,'门店积分管理','C',0,83,NULL,'storePoints','customer/store/points',NULL,'1',0,0,NULL,NULL,0,NULL,'2021-11-11 16:39:25'),(89,'门店标签管理','C',0,83,NULL,'storeTags','store/tags',NULL,'1',0,1,NULL,NULL,0,NULL,'2021-11-11 16:39:49'),(90,'业务员管理','M',0,71,NULL,'salesman',NULL,'salesman','1',0,1,NULL,NULL,0,NULL,'2021-11-11 16:42:59'),(91,'业务员资料管理','C',0,90,NULL,'salesman','customer/salesman/index',NULL,'1',0,0,NULL,NULL,0,NULL,'2021-11-11 16:43:29'),(92,'业务员类型管理','C',0,90,NULL,'salesmanType','customer/salesman/type',NULL,'1',0,0,NULL,NULL,0,NULL,'2021-11-11 16:44:09'),(93,'公告管理','M',0,71,NULL,'notice',NULL,'notice','1',0,0,NULL,NULL,0,NULL,'2021-11-11 16:47:18'),(94,'公告管理','C',0,93,NULL,'notice','customer/notice/index',NULL,'1',0,0,NULL,NULL,0,NULL,'2021-11-11 16:47:39'),(95,'基础管理','M',0,71,NULL,'basics',NULL,'sys-set','1',0,0,NULL,NULL,0,NULL,'2021-11-11 16:48:52'),(96,'个人中心设置','C',0,95,NULL,'basicsUser','customer/basics/user',NULL,'1',0,0,NULL,NULL,0,NULL,'2021-11-11 16:49:39'),(97,'基础设置','C',0,95,NULL,'basicsSet','customer/basics/set',NULL,'1',0,0,NULL,NULL,0,NULL,'2021-11-11 16:50:05'),(98,'客户区域管理','C',0,95,NULL,'customerArea','customer/basics/customerArea',NULL,'1',0,0,NULL,NULL,0,NULL,'2021-11-11 16:51:17'),(99,'应用','M',0,0,NULL,'app',NULL,'app','1',0,0,NULL,NULL,0,NULL,'2021-11-12 06:30:33'),(100,'二维码营销','M',0,99,NULL,'qrcodeMarketing',NULL,'qrcode','1',0,0,NULL,NULL,0,NULL,'2021-11-12 06:33:37'),(101,'概况','M',0,100,NULL,'qrcodeSurvey',NULL,'home','1',0,0,NULL,NULL,0,NULL,'2021-11-12 06:35:21'),(102,'概况','C',0,101,NULL,'qrcodeSurveyIndex','app/qrcodeMarketing/qrcodeSurvey/index',NULL,'1',0,0,NULL,NULL,0,NULL,'2021-11-12 06:36:09'),(103,'扫码活动管理','M',0,100,NULL,'sacnaAtivity',NULL,'scan','1',0,0,NULL,NULL,0,NULL,'2021-11-12 06:38:37'),(104,'扫码模板管理','C',0,103,NULL,'sacnTemplate','app/qrcodeMarketing/scanActivity/template',NULL,'1',0,0,NULL,NULL,0,NULL,'2021-11-12 06:39:36'),(105,'活动管理','C',0,103,NULL,'scanActivityManage','app/qrcodeMarketing/scanActivity/activity',NULL,'1',0,0,NULL,NULL,0,NULL,'2021-11-12 06:40:52'),(106,'扫码明细','C',0,103,NULL,'scanActivityBill','app/qrcodeMarketing/scanActivity/bill',NULL,'1',0,0,NULL,NULL,0,NULL,'2021-11-12 06:41:46'),(107,'领奖记录','C',0,103,NULL,'scanActivityAward','app/qrcodeMarketing/scanActivity/award',NULL,'1',0,0,NULL,NULL,0,NULL,'2021-11-12 06:42:42'),(108,'表单活动参与记录','C',0,103,NULL,'scanActivityForm','scanActivity/form',NULL,'1',0,1,NULL,NULL,0,NULL,'2021-11-12 06:43:55'),(109,'用户集字列表','C',0,103,NULL,'scanActivityCharacters','scanActivity/characters',NULL,'1',0,1,NULL,NULL,0,NULL,'2021-11-12 06:45:19'),(110,'集字礼品兑换统计','C',0,103,NULL,'scanActivityGift','scanActivity/gift',NULL,'1',0,1,NULL,NULL,0,NULL,'2021-11-12 06:56:24'),(111,'小程序商城模板','C',0,103,NULL,'miniproTemplate','sacnActivity/shop',NULL,'1',0,1,NULL,NULL,0,NULL,'2021-11-12 06:57:21'),(112,'数据统计','M',0,100,NULL,'dataStatistics',NULL,'data','1',0,0,NULL,NULL,0,NULL,'2021-11-12 07:01:20'),(113,'扫码量统计','C',0,112,NULL,'dataStatisticsScan','app/qrcodeMarketing/dataStatistics/scan',NULL,'1',0,0,NULL,NULL,0,NULL,'2021-11-12 07:02:18'),(114,'扫码地区统计','C',0,112,NULL,'dataStatisticsArea','app/qrcodeMarketing/dataStatistics/area',NULL,'1',0,0,NULL,NULL,0,NULL,'2021-11-12 07:02:56'),(115,'用户扫码统计','C',0,112,NULL,'dataStatisticsUser','app/qrcodeMarketing/dataStatistics/user',NULL,'1',0,0,NULL,NULL,0,NULL,'2021-11-12 07:03:30'),(116,'参与地区统计','C',0,112,NULL,'dataStatisticsJoinArea','dataStatistics/joinArea',NULL,'1',0,1,NULL,NULL,0,NULL,'2021-11-12 07:04:47'),(117,'奖品统计','C',0,112,NULL,'dataStatisticsPrize','dataStatistics/prize',NULL,'1',0,1,NULL,NULL,0,NULL,'2021-11-12 07:05:23'),(118,'串货区域统计','C',0,112,NULL,'dataStatisticsCollusion','dataStatistics/collusion',NULL,'1',0,1,NULL,NULL,0,NULL,'2021-11-12 07:06:14'),(119,'串货商品统计','C',0,112,NULL,'dataStatisticsProduct','dataStatistics/product',NULL,'1',0,1,NULL,NULL,0,NULL,'2021-11-12 07:07:03'),(120,'门店数据统计','C',0,112,NULL,'dataStatisticsStore','dataStatistics/store',NULL,'1',0,1,NULL,NULL,0,NULL,'2021-11-12 07:07:45'),(121,'营销分控管理','M',0,100,NULL,'qrcodeMarketing',NULL,'marketing','1',0,1,NULL,NULL,0,NULL,'2021-11-12 07:11:13'),(122,'营销分控管理','C',0,121,NULL,'qrcodeMarketingIndex','qrcodeMarketing/index',NULL,'1',0,0,NULL,NULL,0,NULL,'2021-11-12 07:11:43'),(123,'微商城','M',0,99,NULL,'microMall',NULL,'store','1',0,0,NULL,NULL,0,NULL,'2021-11-12 07:21:00'),(124,'概况','M',0,123,NULL,'microMallHome',NULL,'home','1',0,0,NULL,NULL,0,NULL,'2021-11-12 07:21:36'),(125,'概况','C',0,124,NULL,'microMallIndex','app/microMall/index',NULL,'1',0,0,NULL,NULL,0,NULL,'2021-11-12 07:21:59'),(126,'微商城设置','M',0,123,NULL,'microMallSet',NULL,'sys-set','1',0,0,NULL,NULL,0,NULL,'2021-11-12 07:22:25'),(127,'商城装修','C',0,126,NULL,'microMallCustom','app/microMall/custom',NULL,'1',0,0,NULL,NULL,0,NULL,'2021-11-12 07:23:15'),(128,'自定义页面','C',0,126,NULL,'microMallPage','microMall/page',NULL,'1',0,1,NULL,NULL,0,NULL,'2021-11-12 07:24:16'),(129,'商品管理','M',0,123,NULL,'microMallProduct',NULL,'product','1',0,0,NULL,NULL,0,NULL,'2021-11-12 07:24:54'),(130,'上下架管理','C',0,129,NULL,'microMallProcuctSet','app/microMall/procuct',NULL,'1',0,0,NULL,NULL,0,NULL,'2021-11-12 07:25:59'),(131,'商品分类','C',0,129,NULL,'microMallProType','app/microMall/type',NULL,'1',0,0,NULL,NULL,0,NULL,'2021-11-12 07:26:36'),(132,'评价管理','M',0,123,NULL,'microMallEvaluate',NULL,'pingjia','1',0,0,NULL,NULL,0,NULL,'2021-11-12 07:29:27'),(133,'评价管理','C',0,132,NULL,'evaluate','app/microMall/evaluate',NULL,'1',0,0,NULL,NULL,0,NULL,'2021-11-12 07:32:23'),(135,'微分销','M',0,123,NULL,'microDistribution',NULL,'fenxiao','1',0,0,NULL,NULL,0,NULL,'2021-11-12 07:42:05'),(136,'分销设置','C',0,135,NULL,'microDistributionSet','app/microDistribution/set',NULL,'1',0,0,NULL,NULL,0,NULL,'2021-11-12 07:42:36'),(137,'分销员招募','C',0,135,NULL,'microDistributionUser','app/microDistribution/user',NULL,'1',0,0,NULL,NULL,0,NULL,'2021-11-12 07:43:07'),(138,'分销员管理','C',0,135,NULL,'microDistributionUserSet','app/microDistribution/userManage',NULL,'1',0,0,NULL,NULL,0,NULL,'2021-11-12 07:43:42'),(139,'分销订单','C',0,135,NULL,'microDistributionOrder','app/microDistribution/order',NULL,'1',0,0,NULL,NULL,0,NULL,'2021-11-12 07:44:06'),(140,'分销效果','C',0,135,NULL,'microDistributionEffect','app/microDistribution/effect',NULL,'1',0,0,NULL,NULL,0,NULL,'2021-11-12 07:44:44'),(141,'提现申请','C',0,135,NULL,'microDistributionCash','app/microDistribution/cash',NULL,'1',0,0,NULL,NULL,0,NULL,'2021-11-12 07:45:16'),(142,'积分商城','M',0,99,NULL,'pointsMall',NULL,'integral','1',0,0,NULL,NULL,0,NULL,'2021-11-12 07:47:16'),(143,'概况','M',0,142,NULL,'pointsMallIIndex',NULL,'home','1',0,0,NULL,NULL,0,NULL,'2021-11-12 07:47:54'),(144,'概况','C',0,143,NULL,'index','app/pointsMall/index',NULL,'1',0,0,NULL,NULL,0,NULL,'2021-11-12 07:48:17'),(145,'基础设置','M',0,142,NULL,'pointsMallSet',NULL,'sys-set','1',0,0,NULL,NULL,0,NULL,'2021-11-12 07:49:36'),(146,'商城装修','C',0,145,NULL,'pointsMallCustom','app/pointsMall/custom',NULL,'1',0,0,NULL,NULL,0,NULL,'2021-11-12 07:50:21'),(147,'积分兑换设置','C',0,145,NULL,'pointsMallExchange','app/pointsMall/exchange',NULL,'1',0,0,NULL,NULL,0,NULL,'2021-11-12 07:51:04'),(148,'兑换礼品管理','M',0,142,NULL,'pointsMallGift',NULL,'gift','1',0,0,NULL,NULL,0,NULL,'2021-11-12 07:52:04'),(149,'兑换礼品列表','C',0,148,NULL,'gifts','app/pointsMall/gifts',NULL,'1',0,0,NULL,NULL,0,NULL,'2021-11-12 07:53:30'),(150,'自定义分类','C',0,148,NULL,'class','app/pointsMall/class',NULL,'1',0,0,NULL,NULL,0,NULL,'2021-11-12 07:53:53'),(151,'数据统计','M',0,142,NULL,'pointsMallData',NULL,'data','1',0,0,NULL,NULL,0,NULL,'2021-11-12 07:54:52'),(152,'礼品兑换分析','C',0,151,NULL,'exchangeData','app/pointsMall/data',NULL,'1',0,0,NULL,NULL,0,NULL,'2021-11-12 07:55:37'),(153,'智慧门店','M',0,99,NULL,'smartStore',NULL,'smart-store','1',0,0,NULL,NULL,0,NULL,'2021-11-12 08:03:39'),(154,'概况','M',0,153,NULL,'smartStoreIndex',NULL,'home','1',0,0,NULL,NULL,0,NULL,'2021-11-12 08:04:04'),(155,'概况','C',0,154,NULL,'smartStore','app/smartStore/index',NULL,'1',0,0,NULL,NULL,0,NULL,'2021-11-12 08:04:29'),(156,'店铺管理','M',0,153,NULL,'smartStoreShop',NULL,'store','1',0,0,NULL,NULL,0,NULL,'2021-11-12 08:05:28'),(157,'店铺管理','C',0,156,NULL,'smartStoreShop','app/smartStore/store',NULL,'1',0,0,NULL,NULL,0,NULL,'2021-11-12 08:05:56'),(158,'门店商品库','M',0,153,NULL,'smartStorePro','','product','1',0,0,NULL,NULL,0,NULL,'2021-11-12 08:06:36'),(159,'自营商品管理','C',0,158,NULL,'selfSupport','app/smartStore/goods/selfProduct',NULL,'1',0,0,NULL,NULL,0,NULL,'2021-11-12 08:07:46'),(160,'店铺商品管理','C',0,158,NULL,'product1','smartStore/product',NULL,'1',0,1,NULL,NULL,0,NULL,'2021-11-12 08:09:35'),(161,'商品分类','C',0,158,NULL,'smartStoreClass','app/smartStore/goods/class',NULL,'1',0,0,NULL,NULL,0,NULL,'2021-11-12 08:10:23'),(162,'店铺订单','M',0,153,NULL,'smartStoreOrder',NULL,'order','1',0,0,NULL,NULL,0,NULL,'2021-11-12 08:11:00'),(163,'店铺订单','C',0,162,NULL,'smartStoreOrder','app/smartStore/order',NULL,'1',0,0,NULL,NULL,0,NULL,'2021-11-12 08:11:50'),(164,'门店佣金','M',0,153,NULL,'smartStoremCommission',NULL,'money','1',0,1,NULL,NULL,0,NULL,'2021-11-12 08:14:08'),(165,'佣金发放记录','C',0,164,NULL,'commissionIssue','smartStore/commission',NULL,'1',0,0,NULL,NULL,0,NULL,'2021-11-12 08:15:10'),(166,'佣金提现申请','C',0,164,NULL,'cash','smartStore/cash',NULL,'1',0,0,NULL,NULL,0,NULL,'2021-11-12 08:15:39'),(167,'提现设置','C',0,164,NULL,'cashSet','smartStore/cashSet',NULL,'1',0,0,NULL,NULL,0,NULL,'2021-11-12 08:17:47'),(168,'门店客户','M',0,153,NULL,'smartStoreUser',NULL,'user','1',0,1,NULL,NULL,0,NULL,'2021-11-12 08:18:55'),(169,'门店客户管理','C',0,168,NULL,'user','app/smartStore/user',NULL,'1',0,0,NULL,NULL,0,NULL,'2021-11-12 08:19:26'),(170,'数据分析','M',0,153,NULL,'smartStoreData',NULL,'data','1',0,0,NULL,NULL,0,NULL,'2021-11-12 08:31:09'),(171,'订单分析','C',0,170,NULL,'orderAnalysis','app/smartStore/data/orderAnalysis',NULL,'1',0,0,NULL,NULL,0,NULL,'2021-11-12 08:32:18'),(172,'商品分析','C',0,170,NULL,'productAnalysis','app/smartStore/data/productAnalysis',NULL,'1',0,0,NULL,NULL,0,NULL,'2021-11-12 08:33:27'),(173,'客户分析','C',0,170,NULL,'userAnalysis','app/smartStore/data/userAnalysis',NULL,'1',0,1,NULL,NULL,0,NULL,'2021-11-12 08:34:03'),(174,'佣金分析','C',0,170,NULL,'commissionAnalysis','app/smartStore/data/commissionAnalysis',NULL,'1',0,1,NULL,NULL,0,NULL,'2021-11-12 08:34:48'),(175,'万能溯源(舒适版)','M',0,99,NULL,'trace',NULL,'suyuan','1',0,0,NULL,NULL,0,NULL,'2021-11-12 08:40:00'),(176,'概况','M',0,175,NULL,'index',NULL,'home','1',0,0,NULL,NULL,0,NULL,'2021-11-12 08:40:25'),(177,'概况','C',0,176,NULL,'traceIndex','app/trace/index',NULL,'1',0,0,NULL,NULL,0,NULL,'2021-11-12 08:40:50'),(178,'基础设置管理','M',0,175,NULL,'traceSet',NULL,'sys-set','1',0,0,NULL,NULL,0,NULL,'2021-11-12 08:42:11'),(179,'溯源页模板管理','C',0,178,NULL,'traceTemplate','app/trace/template',NULL,'1',0,0,NULL,NULL,0,NULL,'2021-11-12 08:42:56'),(180,'溯源信息管理','M',0,175,NULL,'info',NULL,'notice','1',0,0,NULL,NULL,0,NULL,'2021-11-12 08:43:42'),(181,'产品批次管理','C',0,180,NULL,'traceBatch','app/trace/batch',NULL,'1',0,0,NULL,NULL,0,NULL,'2021-11-12 08:44:20'),(182,'赋码批次管理','C',0,180,NULL,'traceCode','app/trace/code',NULL,'1',0,0,NULL,NULL,0,NULL,'2021-11-12 08:45:03'),(183,'产品信息追溯','C',0,180,NULL,'traceInfo','app/trace/trace',NULL,'1',0,0,NULL,NULL,0,NULL,'2021-11-12 08:45:43'),(184,'溯源查询明细','C',0,180,NULL,'queryDetail','app/trace/queryDetail',NULL,'1',0,0,NULL,NULL,0,NULL,'2021-11-12 08:46:11'),(185,'智能物流','M',0,99,NULL,'logistics','','logistics','1',0,0,NULL,NULL,0,NULL,'2021-11-12 08:49:16'),(186,'概况','M',0,185,NULL,'index',NULL,'home','1',0,0,NULL,NULL,0,NULL,'2021-11-12 08:49:35'),(187,'概况','C',0,186,NULL,'logisticsBoard','app/logistics/index',NULL,'1',0,0,NULL,NULL,0,NULL,'2021-11-12 08:49:54'),(188,'物流管理','M',0,185,NULL,'logisticsManage',NULL,'sys-set','1',0,0,NULL,NULL,0,NULL,'2021-11-12 08:51:52'),(189,'入库管理','C',0,188,NULL,'warehousing','app/logistics/warehousing',NULL,'1',0,0,NULL,NULL,0,NULL,'2021-11-12 08:52:45'),(190,'发货管理','C',0,188,NULL,'deliver','app/logistics/deliver',NULL,'1',0,0,NULL,NULL,0,NULL,'2021-11-12 08:53:37'),(191,'退货管理','C',0,188,NULL,'back','app/logistics/back',NULL,'1',0,0,NULL,NULL,0,NULL,'2021-11-12 08:54:23'),(192,'调仓管理','C',0,188,NULL,'transfer','app/logistics/transfer',NULL,'1',0,0,NULL,NULL,0,NULL,'2021-11-12 08:55:37'),(193,'商品调拨','C',0,188,NULL,'allocation','logistics/allocation',NULL,'1',0,1,NULL,NULL,0,NULL,'2021-11-12 08:56:22'),(194,'零售管理','C',0,188,NULL,'retail','logistics/retail',NULL,'1',0,1,NULL,NULL,0,NULL,'2021-11-12 08:57:04'),(195,'追踪查询','C',0,188,NULL,'track','app/logistics/trace',NULL,'1',0,0,NULL,NULL,0,NULL,'2021-11-12 08:57:39'),(196,'在线订单管理','M',0,185,NULL,'onlineOrder',NULL,'order','1',0,1,NULL,NULL,0,NULL,'2021-11-12 08:58:21'),(197,'商品上下架','C',0,196,NULL,'productSet','logistics/productSet',NULL,'1',0,0,NULL,NULL,0,NULL,'2021-11-12 08:59:17'),(198,'经销商订单管理','C',0,196,NULL,'distributorOrder','logistics/distributorOrder',NULL,'1',0,0,NULL,NULL,0,NULL,'2021-11-12 09:00:36'),(199,'门店订单管理','C',0,196,NULL,'storeOrder','logistics/storeOrder',NULL,'1',0,0,NULL,NULL,0,NULL,'2021-11-12 09:01:44'),(200,'返利管理','M',0,185,NULL,'rebate',NULL,'money','1',0,1,NULL,NULL,0,NULL,'2021-11-12 09:10:19'),(201,'返利发放记录','C',0,200,NULL,'rebateLog','logistics/rebate',NULL,'1',0,0,NULL,NULL,0,NULL,'2021-11-12 09:11:32'),(202,'经销商返利管理','C',0,200,NULL,'distributorRebate','logistics/distributorRebate',NULL,'1',0,0,NULL,NULL,0,NULL,'2021-11-12 09:12:44'),(203,'经销商余额明细','C',0,200,NULL,'balance','logistics/balance',NULL,'1',0,0,NULL,NULL,0,NULL,'2021-11-12 09:14:35'),(204,'报表管理','M',0,185,NULL,'statistics',NULL,'data','1',0,0,NULL,NULL,0,NULL,'2021-11-12 09:16:40'),(205,'总部库存统计','C',0,204,NULL,'stock','logistics/stock',NULL,'1',0,1,NULL,NULL,0,NULL,'2021-11-12 09:17:48'),(206,'经销窜货统计','C',0,204,NULL,'collusionSat','app/logistics/statistics/collusion',NULL,'1',0,0,NULL,NULL,0,NULL,'2021-11-12 09:18:53'),(207,'经销商库存统计','C',0,204,NULL,'distributorStock','logistics/distributorStock',NULL,'1',0,1,NULL,NULL,0,NULL,'2021-11-12 09:19:50'),(208,'门店库存统计','C',0,204,NULL,'storeStock','logistics/storeStock',NULL,'1',0,1,NULL,NULL,0,NULL,'2021-11-12 09:20:23'),(209,'盘点统计','C',0,204,NULL,'Inventory','logistics/Inventory',NULL,'1',0,1,NULL,NULL,0,NULL,'2021-11-12 09:21:07'),(210,'产品周转率统计','C',0,204,NULL,'turnover','logistics/turnover',NULL,'1',0,1,NULL,NULL,0,NULL,'2021-11-12 09:21:54'),(211,'基础管理','M',0,185,NULL,'logisticsBasis',NULL,'sys-set','1',0,0,NULL,NULL,0,NULL,'2021-11-12 09:22:35'),(212,'基础设置','C',0,211,NULL,'basisSet','app/logistics/basis',NULL,'1',0,0,NULL,NULL,0,NULL,'2021-11-12 09:23:12'),(213,'仓库设置','C',0,211,NULL,'Warehouses','app/logistics/warehouse',NULL,'1',0,0,NULL,NULL,0,NULL,'2021-11-12 09:23:47'),(214,'财务管理','C',0,77,NULL,'distributorFinance','customer/distributor/finance',NULL,'1',0,0,NULL,NULL,0,NULL,'2022-01-08 12:30:09'),(215,'物流模板','C',0,188,NULL,'logisticsTemplate','app/logistics/template',NULL,'1',0,0,NULL,NULL,0,NULL,'2022-04-06 18:33:32'),(216,'定向注册审核','C',0,103,NULL,'register','app/qrcodeMarketing/scanActivity/register',NULL,'1',0,0,NULL,NULL,0,NULL,'2022-05-15 17:59:16'),(217,'超级导购','M',0,99,NULL,'guide',NULL,'salesman','1',0,0,NULL,NULL,0,NULL,'2022-09-03 15:34:39'),(218,'概况','M',0,217,NULL,'guideIndex','app/guide/index','home','1',0,0,NULL,NULL,0,NULL,'2022-09-03 15:36:03'),(219,'概况','C',0,218,NULL,'index','app/guide/index',NULL,'1',0,0,NULL,NULL,0,NULL,'2022-09-03 15:37:45'),(220,'导购管理','M',0,217,NULL,'guideManage',NULL,'sys-set','1',0,0,NULL,NULL,0,NULL,'2022-09-03 15:42:14'),(221,'导购管理','C',0,220,NULL,'guide','app/guide/manage/guide',NULL,'1',0,0,NULL,NULL,0,NULL,'2022-09-03 15:44:07'),(222,'导购分组','C',0,220,NULL,'group','app/guide/manage/group',NULL,'1',0,0,NULL,NULL,0,NULL,'2022-09-03 15:45:04'),(223,'导购中心','C',0,220,NULL,'userCenter','app/guide/manage/user',NULL,'1',0,0,NULL,NULL,0,NULL,'2022-09-03 15:45:48'),(224,'扫码活动管理','M',0,217,NULL,'sacnaAtivity',NULL,'scan','1',0,0,NULL,NULL,0,NULL,'2022-09-03 15:46:54'),(225,'扫码模板管理','C',0,224,NULL,'template','app/guide/scanActivity/template',NULL,'1',0,0,NULL,NULL,0,NULL,'2022-09-03 15:47:52'),(226,'活动管理','C',0,224,NULL,'activity','app/guide/scanActivity/activity',NULL,'1',0,0,NULL,NULL,0,NULL,'2022-09-03 15:55:05'),(227,'扫码明细','C',0,224,NULL,'bill','app/guide/scanActivity/bill',NULL,'1',0,0,NULL,NULL,0,NULL,'2022-09-03 15:59:08'),(228,'领奖记录','C',0,224,NULL,'award','app/guide/scanActivity/award',NULL,'1',0,0,NULL,NULL,0,NULL,'2022-09-03 16:00:39'),(229,'数据统计','M',0,217,NULL,'dataStatistics',NULL,'data','1',0,0,NULL,NULL,0,NULL,'2022-09-03 16:11:37'),(230,'排行榜统计','C',0,229,NULL,'rank','app/guide/dataStatistics/rank',NULL,'1',0,0,NULL,NULL,0,NULL,'2022-09-03 16:13:45'),(231,'扫码量统计','C',0,229,NULL,'scan','app/guide/dataStatistics/scan',NULL,'1',0,0,NULL,NULL,0,NULL,'2022-09-03 16:16:21'),(232,'扫码地区统计','C',0,229,NULL,'area','app/guide/dataStatistics/area',NULL,'1',0,0,NULL,NULL,0,NULL,'2022-09-03 16:17:15'),(233,'奖品统计','C',0,229,NULL,'prize','app/guide/dataStatistics/prize',NULL,'1',0,0,NULL,NULL,0,NULL,'2022-09-03 16:20:47');
/*!40000 ALTER TABLE `ctc_dealer_menu` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ctc_dealer_monitor`
--

DROP TABLE IF EXISTS `ctc_dealer_monitor`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ctc_dealer_monitor`
--

LOCK TABLES `ctc_dealer_monitor` WRITE;
/*!40000 ALTER TABLE `ctc_dealer_monitor` DISABLE KEYS */;
/*!40000 ALTER TABLE `ctc_dealer_monitor` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ctc_dealer_oper_log`
--

DROP TABLE IF EXISTS `ctc_dealer_oper_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
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
) ENGINE=InnoDB AUTO_INCREMENT=76 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ctc_dealer_oper_log`
--

LOCK TABLES `ctc_dealer_oper_log` WRITE;
/*!40000 ALTER TABLE `ctc_dealer_oper_log` DISABLE KEYS */;
INSERT INTO `ctc_dealer_oper_log` VALUES (75,'系统管理','gawx','101.24.45.62','河北省石家庄市','2','更新支付信息','2023-04-09 17:44:56',29);
/*!40000 ALTER TABLE `ctc_dealer_oper_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ctc_dealer_params_qrcode`
--

DROP TABLE IF EXISTS `ctc_dealer_params_qrcode`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
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
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ctc_dealer_params_qrcode`
--

LOCK TABLES `ctc_dealer_params_qrcode` WRITE;
/*!40000 ALTER TABLE `ctc_dealer_params_qrcode` DISABLE KEYS */;
/*!40000 ALTER TABLE `ctc_dealer_params_qrcode` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ctc_dealer_payment`
--

DROP TABLE IF EXISTS `ctc_dealer_payment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
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
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ctc_dealer_payment`
--

LOCK TABLES `ctc_dealer_payment` WRITE;
/*!40000 ALTER TABLE `ctc_dealer_payment` DISABLE KEYS */;
INSERT INTO `ctc_dealer_payment` VALUES (1,29,'wx58527ef9c27a4606','5a1e6c22b936c2d716ee7917176e5963','1626250234','20221231/0dc49d8affbda5518767d3bd0dc7a587.pem','20221231/894ba55973c653fa37f4bd8f71097b20.pem','2022-12-31 08:52:55');
/*!40000 ALTER TABLE `ctc_dealer_payment` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ctc_dealer_pda_token`
--

DROP TABLE IF EXISTS `ctc_dealer_pda_token`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ctc_dealer_pda_token` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `uid` int(11) DEFAULT NULL,
  `token` varchar(255) DEFAULT NULL,
  `login_ip` varchar(32) DEFAULT NULL,
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP,
  `expires_time` datetime DEFAULT NULL,
  `dealer_id` int(11) DEFAULT NULL COMMENT '代理商id 用来区分角色token',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=283 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ctc_dealer_pda_token`
--

LOCK TABLES `ctc_dealer_pda_token` WRITE;
/*!40000 ALTER TABLE `ctc_dealer_pda_token` DISABLE KEYS */;
INSERT INTO `ctc_dealer_pda_token` VALUES (128,25,'98b0fdb4a70ca675457df93ce11d19e7c770139e','183.197.46.83','2022-04-12 14:02:49','2022-04-13 02:02:49',NULL),(129,25,'300638404d2508e1327b74727d597013051e6f6a','183.197.46.83','2022-04-12 14:03:11','2022-04-13 02:03:11',NULL),(130,25,'3427353c3c18ffdd24bd15fbdc7efb31ed0955cd','183.197.46.83','2022-04-12 14:32:10','2022-04-13 02:32:10',NULL),(131,25,'2f521bc2e83139aa7f5f2a0d191150ccee7191c7','183.197.46.83','2022-04-12 21:55:06','2022-04-13 09:55:06',NULL),(132,25,'42660cfdcda7e1508377ef22fe4b2b5aa64338d2','183.197.46.83','2022-04-12 21:56:30','2022-04-13 09:56:30',NULL),(133,25,'f21b1f1beb68ad264ba4d13d1aa7d6c89254dfd3','183.197.46.83','2022-04-12 21:59:47','2022-04-13 09:59:47',NULL),(134,25,'36d2d3cdf0003be11dcacb15829cb61dc2e2bd1f','183.197.46.83','2022-04-12 22:01:42','2022-04-13 10:01:42',NULL),(135,25,'334250dd7cf4059cd0ae571155bc6800def10b56','183.197.46.83','2022-04-12 22:05:09','2022-04-13 10:05:09',NULL),(136,25,'9aaba2e300bfe94a9fbbd4b67ebaa9920b2c2d3f','183.197.46.83','2022-04-12 22:05:40','2022-04-13 10:05:40',NULL),(137,25,'fbda3fad8076da11a35498306a56edb586d6d0f5','183.197.46.83','2022-04-12 22:11:01','2022-04-13 10:11:01',NULL),(138,25,'a3a9c3cb09168af8f811337f2d908fb056253449','183.197.46.83','2022-04-12 22:12:17','2022-04-13 10:12:17',NULL),(139,25,'88b68ac63fbfb558d1ccd605bcf310269452aac4','183.197.46.83','2022-04-12 22:14:25','2022-04-13 10:14:25',NULL),(140,25,'1fec832d639cd9e1e825d293bae873634587964e','183.197.46.83','2022-04-12 22:15:28','2022-04-13 10:15:28',NULL),(141,25,'b45ad9e26fe736e398de361d1d48d22a64e90565','183.197.46.83','2022-04-12 22:18:30','2022-04-13 10:18:30',NULL),(142,25,'7e626cfbc2ebd230c50353cdd8e978b6be6b5b27','183.197.46.83','2022-04-12 22:19:07','2022-04-13 10:19:07',NULL),(143,25,'5ec0dbf81332f35143a4d98d387459826c6f2206','183.197.46.83','2022-04-12 22:20:21','2022-04-13 10:20:21',NULL),(144,25,'b1e483f3e6bf65e64c2bdd334ec43f4b65fcc329','183.197.46.83','2022-04-13 12:46:54','2022-04-14 00:46:54',NULL),(145,25,'dc91b0ac4b01800964099f4b93e27b5a6f951e84','183.197.46.83','2022-04-13 12:47:13','2022-04-14 00:47:13',NULL),(146,25,'90dcadeb9d116765c9f08be66c5119f8058ae2b7','183.197.46.83','2022-04-13 12:49:37','2022-04-14 00:49:37',NULL),(147,25,'ee5969eecfb2e600c43d1e8cde5e9b8c3bec8124','183.197.46.83','2022-04-13 12:50:52','2022-04-14 00:50:52',NULL),(148,25,'678f59337b75cfb7eee2924c0d6a478d0d97d4be','183.197.46.83','2022-04-13 12:56:36','2022-04-14 00:56:36',NULL),(149,25,'7f40d7d3b49fdbd60eade6c1b23c4e2f54efdcb8','60.1.128.148','2022-04-13 15:22:03','2022-04-14 03:22:03',NULL),(150,25,'437930b3f4d8186ecd5614a3bf3c31d9c94d4c6a','60.1.128.148','2022-04-13 15:24:06','2022-04-14 03:24:06',NULL),(151,25,'1efea1c7e75601809176f180934738ce6a2ff2e5','183.197.46.83','2022-04-14 12:29:39','2022-04-15 00:29:39',NULL),(152,25,'f63b927d60587508f6ef89ef36bce56def5d6b67','183.197.46.83','2022-04-14 12:30:42','2022-04-15 00:30:42',NULL),(153,25,'9cd15f3f18c09457ac0f84e84bb58bd04f94d246','183.197.46.83','2022-04-14 12:39:48','2022-04-15 00:39:48',NULL),(154,25,'22c80e25e545aee4e28d74a508bf9928c7dc7bfd','183.197.46.83','2022-04-14 12:51:51','2022-04-15 00:51:51',NULL),(155,25,'dfcc8bf54a81a8ee3876d3f363834bfa2b0e80ed','183.197.46.83','2022-04-14 13:05:11','2022-04-15 01:05:11',NULL),(156,25,'52bb39d0a87ac68979443736985343b20473e148','183.197.46.83','2022-04-14 13:09:02','2022-04-15 01:09:02',NULL),(157,25,'4b453444d55a3809ff4ece826945f79d334a2a50','218.12.18.62','2022-04-14 13:59:22','2022-04-15 01:59:22',NULL),(158,25,'13e8f629e4a041519d220c6ac3fdf00a25e9d3d8','223.104.103.159','2022-04-14 14:00:56','2022-04-15 02:00:56',NULL),(159,25,'3d808932f1ea63efb960058ebdbee755ddd0a30b','60.1.128.148','2022-04-14 14:03:59','2022-04-15 02:03:59',NULL),(160,25,'a1b4b5dd4d4e3c57fa3daf5908116fd52a06e12d','183.197.46.83','2022-04-14 14:06:23','2022-04-15 02:06:23',NULL),(161,25,'6e6a57ba1877f871f1ac0042d05c9773fc559108','60.1.128.148','2022-04-14 14:07:29','2022-04-15 02:07:29',NULL),(162,25,'6adfbef84ab449a7d769597796fe367122518744','60.1.128.148','2022-04-14 14:13:51','2022-04-15 02:13:51',NULL),(163,25,'b80a27fcf520076e33b0b2989fd0d41e1790b1c8','183.197.46.83','2022-04-14 15:02:56','2022-04-15 03:02:56',NULL),(164,25,'6d6865b1652b404ec72f942da31de615760878d6','60.1.128.148','2022-04-14 15:21:40','2022-04-15 03:21:40',NULL),(165,25,'874893a4269958c08f148e4fb1efda88ad33760c','223.104.103.159','2022-04-14 15:31:10','2022-04-15 03:31:10',NULL),(166,25,'49e3285ccb1bf955c46ada0e7e7d03fb790a5290','60.1.128.148','2022-04-14 15:33:05','2022-04-15 03:33:05',NULL),(167,25,'71f92d1ab905168a93fac3dd24cecc314954b953','223.104.103.159','2022-04-14 15:54:13','2022-04-15 03:54:13',NULL),(168,25,'2a4078739c83b2c575785c36cb43968db0a25ba5','27.184.175.200','2022-04-14 16:44:42','2022-04-15 04:44:42',NULL),(169,25,'54e9aef24654211826de4d21dfaa26f5b5a79c4d','223.104.103.159','2022-04-14 18:18:02','2022-04-15 06:18:02',NULL),(170,25,'72e1259ca9e1184046263e9d9ec75c4684bc398e','218.12.16.45','2022-04-14 19:25:18','2022-04-15 07:25:18',NULL),(171,25,'b471b1b4d446dea5f03159e11b8c111affcf6fd6','106.114.153.86','2022-04-14 21:28:25','2022-04-15 09:28:25',NULL),(172,25,'c30fd699eef7868b6db7acef92604c87a61a17e2','106.114.153.86','2022-04-15 05:03:38','2022-04-15 17:03:38',NULL),(173,25,'2e953eb83c123364b3ceb7ab08eea62ee1705ff5','60.1.128.148','2022-04-15 10:23:21','2022-04-15 22:23:21',NULL),(174,25,'ec4a5f27685477e4670359e773515e798f18cf10','106.114.153.86','2022-04-16 08:30:32','2022-04-16 20:30:32',NULL),(175,25,'4dd592a2f9f25c26a0c12632913b0aa2651dccae','183.197.46.2','2022-04-18 03:53:18','2022-04-18 15:53:18',NULL),(176,25,'87936a12779f9e480e11143938e8071495ee6d53','183.197.46.2','2022-04-18 04:20:24','2022-04-18 16:20:24',NULL),(177,25,'064f296ad5b2220b61ea6df869dfb0020f12b0f4','183.197.46.2','2022-04-18 16:33:30','2022-04-19 04:33:30',NULL),(178,25,'2c85d2f73e81a8bda7e4f3587f51bf12aefb48da','106.114.153.86','2022-04-18 20:46:06','2022-04-19 08:46:06',NULL),(179,25,'173596bb8c9c6e1a600a694905f15e826004f2e9','27.128.27.62','2022-04-19 10:52:39','2022-04-19 22:52:39',NULL),(180,25,'9e87ebb6259dfd9bb42da5369ce8b355324b0f34','221.192.180.135','2022-04-19 11:28:10','2022-04-19 23:28:10',NULL),(181,25,'33351dbd148f63230f6a63497de4349c560c986e','221.192.180.135','2022-04-19 11:30:32','2022-04-19 23:30:32',NULL),(182,25,'2ed75a5d27336399bc4f7f230b5735318e380478','221.192.180.135','2022-04-19 11:34:03','2022-04-19 23:34:03',NULL),(183,25,'cdae2347edb995223606569f8b06cb5df869d5fe','221.192.180.135','2022-04-19 11:36:33','2022-04-19 23:36:33',NULL),(184,25,'9ebbe245af89e7f2ebeafd5b2648973391cb7a85','36.143.104.50','2022-04-19 11:52:01','2022-04-19 23:52:01',NULL),(185,25,'e28d395aba57633ab9a7ac5e9820962df973135f','36.143.104.50','2022-04-19 14:31:08','2022-04-20 02:31:08',NULL),(186,25,'577608c6fa1f90fcf522491800a2dcd268c25d6f','106.114.153.86','2022-04-19 21:53:19','2022-04-20 09:53:19',NULL),(187,25,'e27fa445f5567136b177467bf4db05ca3edbfd30','101.24.122.231','2022-04-20 09:28:30','2022-04-20 21:28:30',NULL),(188,25,'60fbcba5b03c22705ef3dabd2304065b2acc4ee2','218.12.18.113','2022-04-22 09:52:56','2022-04-22 21:52:56',NULL),(189,25,'d57be4f89c9c0606d49b0257722213525113afb5','223.104.13.43','2022-04-22 09:53:26','2022-04-22 21:53:26',NULL),(190,25,'81f89a4d3d33fdf18da82cb1b92ec3745bfd2488','218.12.18.113','2022-04-22 11:09:27','2022-04-22 23:09:27',NULL),(191,25,'9c1a58610d57d0a9535a0ea1575f996c9f8a294b','36.143.104.57','2022-04-23 20:58:35','2022-04-24 08:58:35',NULL),(192,25,'fd4ce90f61d7a2c07bcca1606c664d3dc535daaa','223.104.13.43','2022-04-23 20:59:31','2022-04-24 08:59:31',NULL),(193,25,'cba0c6868d33ddcbf7a8039f5da4f64d85b02dd7','36.143.104.57','2022-04-23 21:26:12','2022-04-24 09:26:12',NULL),(194,25,'f7087a496ed80439ff73544f203371f85025f748','223.104.13.43','2022-04-23 21:27:23','2022-04-24 09:27:23',NULL),(195,25,'06038b3e1096e5cec9a3ab3971088fab1504f4f6','106.119.56.11','2022-04-29 13:52:12','2022-04-30 01:52:12',NULL),(196,25,'9f9fc126d2918c9e019f15fde2245c2d8f2547ee','183.197.46.131','2022-05-09 01:43:33','2022-05-09 13:43:33',NULL),(197,25,'a7cafad1023f8e3fa0f50d81055768c2adf2b199','183.197.46.131','2022-05-09 01:47:40','2022-05-09 13:47:40',NULL),(198,25,'5db155a36c46275c16575d3974acc5c820c1688c','183.197.46.131','2022-05-09 01:49:02','2022-05-09 13:49:02',NULL),(199,25,'16dcea8b24ecb533218ad986d71726fb6dcd58ea','183.197.46.131','2022-05-09 02:04:56','2022-05-09 14:04:56',NULL),(200,25,'22b8de8468e3f03fe329b5da73006c389b9c980c','183.197.46.131','2022-05-09 02:05:09','2022-05-09 14:05:09',NULL),(201,25,'bd3cdf391b992cda22120fd0207e82c2cc3a568e','106.114.155.82','2022-05-09 06:12:10','2022-05-09 18:12:10',NULL),(202,25,'14ce49bb548462f7aa11e50ad59233eecacd28d5','27.184.25.0','2022-05-09 09:46:00','2022-05-09 21:46:00',NULL),(203,25,'eeb09646f8230de763958120c0857afbe4fab028','112.81.59.123','2022-05-26 07:28:38','2022-05-26 19:28:38',NULL),(204,29,'9ee2c654056399eb799a2e483d5ff4341724c63f','60.1.134.69','2022-05-26 10:52:35','2022-05-26 22:52:35',NULL),(205,29,'fcfa9ded337e1bc7ecc59dd5284fb22945e1e8eb','60.1.134.69','2022-05-26 10:52:40','2022-05-26 22:52:40',NULL),(206,29,'bdbd222e10b45262235b79ff0fca1c147c28389d','60.1.134.69','2022-05-26 11:04:32','2022-05-26 23:04:32',NULL),(207,25,'44292d2ddc8e0acd53157bc13f564e38f4dc0ae2','61.242.129.6','2022-05-27 17:33:03','2022-05-28 05:33:03',NULL),(208,29,'98e4302afbde14f6937df0e4d2099bad4b707e23','27.128.55.96','2022-06-09 09:55:15','2022-06-09 21:55:15',NULL),(209,29,'a88ce5bef76b6f8dfda2e488a0b9a812e5f12593','60.1.134.69','2022-06-09 16:54:03','2022-06-10 04:54:03',NULL),(210,29,'674ba3520c1ba1a72ac4310a5944a1fce7abfb77','60.1.134.69','2022-06-09 17:02:03','2022-06-10 05:02:03',NULL),(211,28,'139b4162cef2b1e7624dba4ef42a9df1dfb7f1fd','60.1.134.69','2022-06-13 10:07:15','2022-06-13 22:07:15',NULL),(212,25,'76739ce5cc46baad07a27e93f50a8fa58659030b','218.12.17.38','2022-06-13 12:22:26','2022-06-14 00:22:26',NULL),(213,28,'3ecaabaf753e619251d27bcd10986394fcaba586','1.68.162.7','2022-06-16 09:46:47','2022-06-16 21:46:47',NULL),(214,28,'92a233ff86c2ec102b590a2db95530b4fe28e2de','124.164.47.13','2022-06-16 10:12:53','2022-06-16 22:12:53',NULL),(215,28,'4cc98cd1316e43c68a9b5fe1b1f8ca6f7a1cf1e2','124.164.47.13','2022-06-16 10:18:10','2022-06-16 22:18:10',NULL),(216,28,'3b1d3ea04c95c3edb23fd909fa8d5669b4607e3a','124.164.47.13','2022-06-16 10:25:48','2022-06-16 22:25:48',NULL),(217,28,'e240c019f593f1ef25e6ae1dd4bba796572e0d9e','1.68.162.7','2022-06-16 10:33:51','2022-06-16 22:33:51',NULL),(218,32,'f64d61f3941c8fdfe058a6aca6c9e00a784efdf3','101.24.128.48','2022-06-20 09:10:39','2022-06-20 21:10:39',NULL),(219,29,'589f687ff1e1eaa668d3ccabb3c6be4e764ce07f','101.24.128.48','2022-06-20 10:26:32','2022-06-20 22:26:32',NULL),(220,25,'00e3d096e7966a54aff2ca21f23aa56affbbbf15','124.236.159.189','2022-06-21 20:07:58','2022-06-22 08:07:58',NULL),(221,29,'573d558d2e7f1bce9519139f13ba3dc18769de49','101.24.128.48','2022-06-22 10:17:53','2022-06-22 22:17:53',NULL),(222,29,'60ba0113c3b3ad41c770d5ba0df2547697c51d66','110.228.110.50','2022-06-22 10:34:18','2022-06-22 22:34:18',NULL),(223,29,'fcf24ad9c02bbb8874d5e63131276c4df44f2dfa','101.24.128.48','2022-06-22 10:46:36','2022-06-22 22:46:36',NULL),(224,29,'dcd8a9fdd3780ddca32a8213d26a8ade10c6c3f5','101.24.128.48','2022-06-27 09:14:50','2022-06-27 21:14:50',NULL),(225,25,'dde4f717e5798e966acccfe8b24cce3cbd35ccd0','111.224.12.29','2022-06-28 19:13:40','2022-06-29 07:13:40',NULL),(226,29,'8d2d6905e7a066d9d0e627ceada95454d0766da9','36.143.135.79','2022-07-03 01:46:22','2022-07-03 13:46:22',NULL),(227,29,'f2f84d4bda3b2ed954e820523f9ab5d3ac80a929','36.143.135.79','2022-07-03 01:51:51','2022-07-03 13:51:51',NULL),(228,29,'3f7e20a6416f66c981affda079fc8a8371310f79','36.143.135.79','2022-07-03 01:51:59','2022-07-03 13:51:59',NULL),(229,29,'89113c097abf817c1082b8ad429c3244c540dcbf','36.143.135.79','2022-07-03 02:05:21','2022-07-03 14:05:21',NULL),(230,29,'4e8aa51fc8868c2462ed0cdd7fd614754612854a','106.117.10.109','2022-07-03 02:17:06','2022-07-03 14:17:06',NULL),(231,29,'213cf6286896e66f25abefbf6c33a0da9d4f127e','27.128.48.71','2022-07-04 10:11:51','2022-07-04 22:11:51',NULL),(232,25,'073e489372e03b0ffd36d415f194189be7981d5b','60.219.242.196','2022-07-08 09:10:01','2022-07-08 21:10:01',NULL),(233,29,'f6f02b6f08ec7ffe3c4815d34c29087d530f6615','42.102.167.71','2022-07-08 09:14:47','2022-07-08 21:14:47',NULL),(234,25,'2dcad4bd5361cf60efe9e418288d0427102d9572','42.102.167.71','2022-07-08 09:14:59','2022-07-08 21:14:59',NULL),(235,25,'64dedbca79a82886e12aa6dabadaa7976f133e6b','60.219.155.48','2022-07-08 10:47:02','2022-07-08 22:47:02',NULL),(236,25,'2ffb593aa89332a3e25f20ecb1db38f8e3d8456e','42.102.167.71','2022-07-08 10:47:32','2022-07-08 22:47:32',NULL),(237,33,'b1951e035b839b57da71847cc44b5ce32bb3167e','101.24.128.48','2022-07-15 09:50:13','2022-07-15 21:50:13',NULL),(238,33,'e97fbf4a4cefc61495123ba5a15cdce216f06e7a','106.33.252.133','2022-07-26 13:15:51','2022-07-27 01:15:51',NULL),(239,33,'9b0b4ef22e63d94c0ef86832b26eceb731e94e54','106.33.252.133','2022-07-26 13:33:16','2022-07-27 01:33:16',NULL),(240,33,'108da8cbf2602ed82a5478af8a7fa35810d11474','106.33.252.133','2022-07-26 13:33:22','2022-07-27 01:33:22',NULL),(241,33,'33604f3d95cce0b983692fe7fdad484379339dc3','27.18.175.102','2022-07-26 13:40:59','2022-07-27 01:40:59',NULL),(242,25,'296cb5aec15d9a9395d872403d0dcbd226007c33','223.104.103.187','2022-07-26 14:25:32','2022-07-27 02:25:32',NULL),(243,33,'f915414f9766ff6534620aed40bf94eb2b75fa73','106.33.252.133','2022-07-26 14:40:20','2022-07-27 02:40:20',NULL),(244,33,'fe56634a061e58567c9832bb9d561576d949dd39','106.33.252.133','2022-07-26 14:49:00','2022-07-27 02:49:00',NULL),(245,33,'01a9eaf6e23c9ac1702d39a2550b5f23d294a053','106.33.252.133','2022-07-26 15:40:55','2022-07-27 03:40:55',NULL),(246,33,'0a847b22b72375586fbf6a76e4efba858ac1eb10','117.136.23.155','2022-07-26 15:43:19','2022-07-27 03:43:19',NULL),(247,33,'b6d127199590b7116b33186170fc85b8ef77a8fb','106.33.252.133','2022-07-26 15:57:29','2022-07-27 03:57:29',NULL),(248,33,'63ac6f883839f016158ffd99203fa546be49187e','106.33.252.133','2022-07-26 15:58:50','2022-07-27 03:58:50',NULL),(249,33,'ea8feca3c944dd5c5f12d43a46c084a2eeee1f3a','117.136.23.155','2022-07-26 16:02:06','2022-07-27 04:02:06',NULL),(250,33,'50c7c0e911826787e9d7860a699b5455cfe3218e','106.33.252.133','2022-07-26 16:15:55','2022-07-27 04:15:55',NULL),(251,33,'4ac21fbaa11972a0126d7fea7f2b9757887e7fb2','106.33.252.133','2022-07-26 16:36:50','2022-07-27 04:36:50',NULL),(252,33,'fa61c441fc75c96ba0e6164c1eabb17dabedcb6a','117.136.23.155','2022-07-26 16:51:28','2022-07-27 04:51:28',NULL),(253,33,'80b111cf3eb04bebacfb36bbd6e100f4ffb9fa5d','106.33.252.133','2022-07-26 16:59:37','2022-07-27 04:59:37',NULL),(254,33,'7eb3ef30e765d9b8054536b35fd431d1ea54c489','106.33.252.133','2022-07-26 17:33:10','2022-07-27 05:33:10',NULL),(255,33,'f5a8a9c9a5144ce4ed847c6a7aef63e3c1cb6dd5','106.33.252.133','2022-07-26 17:33:30','2022-07-27 05:33:30',NULL),(256,33,'9c47c7ed2ce82dbc6da335fd430c5a3659dcbe2d','106.33.252.133','2022-07-26 17:44:15','2022-07-27 05:44:15',NULL),(257,33,'6b754a7283f37439f8365c2ab115cbe33aa57be1','106.33.252.133','2022-07-26 18:06:00','2022-07-27 06:06:00',NULL),(258,33,'aa5f6465f5fdbf746f0a6873a7012f08dbdb73b4','106.33.252.133','2022-07-26 18:06:23','2022-07-27 06:06:23',NULL),(259,33,'2f5c1e7fe4bbb8188e20eac20ca4ba0fba344370','117.136.81.89','2022-08-02 14:12:46','2022-08-03 02:12:46',NULL),(260,33,'9cac2b784cb43f776b3db7a4d68c15206ff70fcd','117.136.81.89','2022-08-02 18:02:58','2022-08-03 06:02:58',NULL),(261,33,'09652a80a337ece9b89f53ab2c529fe06d49e353','117.136.81.89','2022-08-02 18:03:55','2022-08-03 06:03:55',NULL),(262,33,'4d8b178f4b9ba246adc61fa6e2ac9f1d8973a488','171.43.207.101','2022-08-15 15:53:02','2022-08-16 03:53:02',NULL),(263,34,'98f80956efde1199af78715a78ca3d663e6c28a4','101.24.126.194','2022-08-24 09:25:18','2022-08-24 21:25:18',NULL),(264,34,'42944e71b6bdda7b7169e5d8f6944f5800f7970f','101.24.126.194','2022-08-24 09:31:57','2022-08-24 21:31:57',NULL),(265,34,'22f6e07b16e01d214ea7aa5a75251f53d0a73677','101.24.126.194','2022-08-24 09:35:12','2022-08-24 21:35:12',NULL),(266,33,'147d7709b0316f9ce6aafd55be823aab7fc70585','101.24.126.194','2022-08-24 09:48:29','2022-08-24 21:48:29',NULL),(267,33,'c9193dc9844298a5480556032c1dddeec44012b3','223.104.103.186','2022-08-24 09:58:39','2022-08-24 21:58:39',NULL),(268,34,'6f04d8ba513b763f4da45c6806349ba163d85de7','101.24.126.194','2022-08-24 10:05:48','2022-08-24 22:05:48',NULL),(269,34,'bc5c1cf797f092ad8433a4c57f5b39a44e37c7df','101.24.126.194','2022-08-24 10:08:14','2022-08-24 22:08:14',NULL),(270,34,'51bef3f439651ada35a93e04d3051da6122b381f','101.24.126.194','2022-08-24 10:27:37','2022-08-24 22:27:37',NULL),(271,34,'5e7a2282eeba52fa9f09f11701ea27e16f8390cc','101.24.126.194','2022-08-24 10:33:10','2022-08-24 22:33:10',NULL),(272,34,'5e0862ed08c1ab21ad2c0374d8bcad828fbff184','101.24.126.194','2022-08-24 10:36:19','2022-08-24 22:36:19',NULL),(273,33,'6d045c20469024c6bf392440bc33b10610093763','223.104.103.186','2022-08-24 10:37:29','2022-08-24 22:37:29',NULL),(274,25,'40d3f860c47a49a981aa7240dd93ae346d95ed98','27.128.84.72','2022-09-01 21:26:17','2022-09-02 09:26:17',NULL),(275,34,'f5f34f4a649d280084c057f70fd393260cbf6c7b','27.128.84.72','2022-09-01 21:31:23','2022-09-02 09:31:23',NULL),(276,34,'a0853c8573771cb72b2579b0dcf4a09a5dd058ab','223.104.13.62','2022-09-02 00:19:05','2022-09-02 12:19:05',NULL),(277,34,'a24aa2c5320cb24c6b2e6c17da07da32c8f686b6','223.104.13.62','2022-09-02 00:29:15','2022-09-02 12:29:15',NULL),(278,34,'b22bcf1ee5d6872b0f3f3a5143066a146381911a','180.167.40.166','2022-09-03 08:43:29','2022-09-03 20:43:29',NULL),(279,34,'ad410fa833b4c610dd0d445ba6466d26b09a377d','180.167.40.166','2022-09-03 08:48:38','2022-09-03 20:48:38',NULL),(280,34,'eb8326fa17284f8cd3425f5c513845a384b505fe','180.167.40.166','2022-09-03 11:51:51','2022-09-03 23:51:51',NULL),(281,34,'25ed54a6eb602be76f228258f0e6f851798dc341','::1','2022-09-03 17:44:41','2022-09-04 05:44:41',NULL),(282,34,'faf286e21165ffb2dc3bcd4ad34393f0247b812b','::1','2022-09-03 17:57:38','2022-09-04 05:57:38',NULL);
/*!40000 ALTER TABLE `ctc_dealer_pda_token` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ctc_dealer_points_cart`
--

DROP TABLE IF EXISTS `ctc_dealer_points_cart`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ctc_dealer_points_cart` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `points_gift_id` int(11) DEFAULT NULL COMMENT '商品id 同一用户只会存放一个唯一的商品id',
  `gift_num` int(11) DEFAULT NULL,
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `uid` int(11) DEFAULT NULL,
  `openid` varchar(255) DEFAULT NULL,
  `gift_sku_id` int(11) DEFAULT '0' COMMENT '商品属性id 0代表无属性',
  `update_time` timestamp NULL DEFAULT NULL,
  `is_delete` tinyint(4) DEFAULT '0' COMMENT '是否删除',
  `dealer_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=26 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ctc_dealer_points_cart`
--

LOCK TABLES `ctc_dealer_points_cart` WRITE;
/*!40000 ALTER TABLE `ctc_dealer_points_cart` DISABLE KEYS */;
INSERT INTO `ctc_dealer_points_cart` VALUES (25,2,1,'2022-08-23 17:23:52',NULL,'osnBC6OPadCdY77BfGZOaVhbgjak',0,NULL,0,29);
/*!40000 ALTER TABLE `ctc_dealer_points_cart` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ctc_dealer_points_gift_class`
--

DROP TABLE IF EXISTS `ctc_dealer_points_gift_class`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ctc_dealer_points_gift_class` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `class_name` varchar(255) DEFAULT NULL,
  `parent_id` int(11) DEFAULT '0',
  `order` int(11) DEFAULT NULL,
  `dealer_id` int(11) DEFAULT NULL,
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ctc_dealer_points_gift_class`
--

LOCK TABLES `ctc_dealer_points_gift_class` WRITE;
/*!40000 ALTER TABLE `ctc_dealer_points_gift_class` DISABLE KEYS */;
INSERT INTO `ctc_dealer_points_gift_class` VALUES (4,'一级分类',0,1,29,'2022-08-23 17:21:24'),(5,'1.1',4,2,29,'2022-08-23 17:21:32'),(6,'二级分类',0,3,29,'2022-08-23 17:21:32'),(7,'2.1',6,1,29,'2022-08-23 17:21:32'),(8,'2.2',6,2,29,'2022-08-23 17:21:32');
/*!40000 ALTER TABLE `ctc_dealer_points_gift_class` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ctc_dealer_points_gifts`
--

DROP TABLE IF EXISTS `ctc_dealer_points_gifts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
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
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ctc_dealer_points_gifts`
--

LOCK TABLES `ctc_dealer_points_gifts` WRITE;
/*!40000 ALTER TABLE `ctc_dealer_points_gifts` DISABLE KEYS */;
INSERT INTO `ctc_dealer_points_gifts` VALUES (2,9,'001',4,5,2,10.00,1.00,5,1,'[1]',5,0,15,0,'很抱歉，你不能兑换此礼品',12,1,1,29,'2022-08-23 17:22:41','2022-08-25 15:39:18');
/*!40000 ALTER TABLE `ctc_dealer_points_gifts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ctc_dealer_points_order`
--

DROP TABLE IF EXISTS `ctc_dealer_points_order`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ctc_dealer_points_order` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '订单ID',
  `openid` varchar(255) DEFAULT NULL,
  `order_id` varchar(32) NOT NULL COMMENT '订单号',
  `dealer_id` int(11) DEFAULT NULL COMMENT '归属',
  `member_id` int(11) unsigned DEFAULT NULL COMMENT '用户id',
  `order_gift_info` text COMMENT '订当商品信息',
  `user_address_id` int(11) DEFAULT NULL COMMENT '地址id',
  `cart_ids` varchar(256) DEFAULT NULL COMMENT '购物车id',
  `total_num` int(11) unsigned DEFAULT '0' COMMENT '订单商品总数',
  `total_points` decimal(8,2) DEFAULT NULL COMMENT '订单总积分',
  `total_price` decimal(8,2) unsigned DEFAULT '0.00' COMMENT '订单总价',
  `total_postage` decimal(8,2) unsigned DEFAULT '0.00' COMMENT '邮费',
  `pay_price` decimal(8,2) unsigned DEFAULT '0.00' COMMENT '实际支付金额',
  `pay_postage` decimal(8,2) unsigned DEFAULT '0.00' COMMENT '支付邮费',
  `deduction_price` decimal(8,2) unsigned DEFAULT '0.00' COMMENT '抵扣金额',
  `coupon_id` int(11) unsigned DEFAULT '0' COMMENT '优惠券id',
  `coupon_price` decimal(8,2) unsigned DEFAULT '0.00' COMMENT '优惠券金额',
  `paid` tinyint(1) unsigned DEFAULT '0' COMMENT '支付状态',
  `pay_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '支付时间',
  `pay_mode` varchar(255) DEFAULT NULL COMMENT '支付模式 直接兑换或者购物车兑换',
  `pay_type` tinyint(10) NOT NULL DEFAULT '0' COMMENT '支付方式 0微信 1支付宝',
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `status` tinyint(1) DEFAULT '0' COMMENT '订单状态（0：待发货；1：待收货；2：已完成；-1：待付款；）',
  `refund_status` tinyint(1) unsigned DEFAULT '0' COMMENT '0 未退款 1 申请中 2 已退款',
  `refund_reason_wap_img` varchar(255) DEFAULT NULL COMMENT '退款图片',
  `refund_reason_wap_explain` varchar(255) DEFAULT NULL COMMENT '退款用户说明',
  `refund_reason_time` int(11) unsigned DEFAULT NULL COMMENT '退款时间',
  `refund_reason_wap` varchar(255) DEFAULT NULL COMMENT '前台退款原因',
  `refund_reason` varchar(255) DEFAULT NULL COMMENT '不退款的理由',
  `refund_price` decimal(8,2) unsigned DEFAULT '0.00' COMMENT '退款金额',
  `delivery_mark` varchar(255) DEFAULT NULL,
  `delivery_name` varchar(64) DEFAULT NULL COMMENT '快递名称/送货人姓名',
  `delivery_type` varchar(32) DEFAULT NULL COMMENT '发货类型',
  `delivery_id` varchar(64) DEFAULT NULL COMMENT '快递单号/手机号',
  `mark` varchar(512) DEFAULT NULL COMMENT '备注',
  `is_del` tinyint(1) unsigned DEFAULT '0' COMMENT '是否删除',
  `unique` char(32) DEFAULT NULL COMMENT '唯一id(md5加密)类似id',
  `remark` varchar(512) DEFAULT NULL COMMENT '管理员备注',
  `mer_id` int(10) unsigned DEFAULT '0' COMMENT '商户ID',
  `is_mer_check` tinyint(3) unsigned DEFAULT '0',
  `cost` decimal(8,2) unsigned DEFAULT NULL COMMENT '成本价',
  `is_channel` tinyint(1) unsigned DEFAULT '0' COMMENT '支付渠道(0微信公众号1微信小程序)',
  `is_system_del` tinyint(1) DEFAULT '0' COMMENT '后台管理员删除',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `unique` (`unique`) USING BTREE,
  UNIQUE KEY `order_id_2` (`order_id`,`member_id`) USING BTREE,
  KEY `uid` (`member_id`) USING BTREE,
  KEY `add_time` (`create_time`) USING BTREE,
  KEY `pay_price` (`pay_price`) USING BTREE,
  KEY `paid` (`paid`) USING BTREE,
  KEY `pay_time` (`pay_time`) USING BTREE,
  KEY `pay_type` (`pay_type`) USING BTREE,
  KEY `status` (`status`) USING BTREE,
  KEY `is_del` (`is_del`) USING BTREE,
  KEY `coupon_id` (`coupon_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=31 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT COMMENT='订单表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ctc_dealer_points_order`
--

LOCK TABLES `ctc_dealer_points_order` WRITE;
/*!40000 ALTER TABLE `ctc_dealer_points_order` DISABLE KEYS */;
INSERT INTO `ctc_dealer_points_order` VALUES (30,'osnBC6OPadCdY77BfGZOaVhbgjak','2022082948102515',29,NULL,'{\"id\":9,\"code\":\"001\",\"barcode\":\"001\",\"group_id\":8,\"weight\":\"20kg\",\"order\":\"1\",\"gift_name\":\"\\u725b\\u680f\\u5c71\\u793c\\u54c1\",\"cover\":[{\"url\":\"http:\\/\\/cdn.uni-2id.com\\/0e906202206201502499112.png\",\"name\":\"0e906202206201502499112.png\"}],\"cost_price\":\"50\",\"market_price\":\"60\",\"stock\":\"100\",\"unit\":\"\\u74f6\",\"details\":\"\\u003Cp\\u003E\\u725b\\u680f\\u5c71\\u9152\\u5382\\uff0c\\u4e2d\\u56fd\\u5386\\u53f2\\u60a0\\u4e45\\u7684\\u917f\\u9152\\u5382\\u4e4b\\u4e00\\u3002\\u4f9d\\u636e\\u73b0\\u4fdd\\u5b58\\u5728\\u987a\\u4e49\\u6863\\u6848\\u9986\\u7684\\u300a\\u987a\\u4e49\\u53bf\\u5fd7\\u300b\\uff0c\\u4ece\\u6709\\u8be6\\u7ec6\\u917f\\u9152\\u5386\\u53f2\\u8bb0\\u8f7d\\u7684\\u5eb7\\u7199\\u4e94\\u5341\\u516b\\u5e74\\uff081719\\uff09\\u5e74\\u7b97\\u8d77\\uff0c\\u917f\\u9152\\u53e4\\u9547\\u725b\\u680f\\u5c71\\u7684\\u201c\\u9152\\u9f84\\u201d\\u5df2\\u8fd1300\\u5e74\\u3002\\u003C\\/p\\u003E\\u003Cp\\u003E\\t\\u003C\\/p\\u003E\\u003Cp\\u003E\\u636e\\u6c11\\u56fd20\\u5e74\\u300a\\u987a\\u4e49\\u53bf\\u5fd7\\u00b7\\u5b9e\\u4e1a\\u5fd7\\u300b\\u8f7d\\uff1a\\u201c\\u725b\\u680f\\u5c71\\u9547\\u9020\\u9152\\u5de5\\u4f5c\\u662f\\u5de5\\u8005\\u7ea6\\u767e\\u4f59\\u4eba\\uff08\\u53d7\\u96c7\\u4e8e\\u6cbb\\u5185\\u5341\\u4e00\\u5bb6\\u70e7\\u9505\\uff09\\uff0c\\u6240\\u917f\\u4e4b\\u9152\\u7518\\u51bd\\u5f02\\u5e38\\u4e3a\\u5317\\u5e73\\u7279\\u4ea7\\uff0c\\u9500\\u552e\\u90bb\\u53bf\\u6216\\u5e73\\u5e02\\uff0c\\u9887\\u810d\\u7099\\u4eba\\u53e3\\uff0c\\u800c\\u5c24\\u4ee5\\u725b\\u680f\\u5c71\\u4e4b\\u9152\\u4e3a\\u6700\\u8457\\u201d\\u3002\\u003C\\/p\\u003E\",\"dealer_id\":29,\"create_time\":\"2022-08-24 01:20:58\",\"update_time\":null,\"create_by\":null,\"is_del\":0,\"money\":\"1.00\",\"points_num\":\"10.00\",\"type\":2,\"limit_num\":5,\"points_gift_id\":2}',6,NULL,0,10.00,1.00,0.00,0.00,0.00,0.00,0,0.00,0,'2022-08-28 18:32:56','direct',0,'2022-08-28 18:32:49',2,0,NULL,NULL,NULL,NULL,NULL,0.00,'请查收！！！','1',NULL,'123456789','测试',0,NULL,NULL,0,0,NULL,0,0);
/*!40000 ALTER TABLE `ctc_dealer_points_order` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ctc_dealer_points_rule`
--

DROP TABLE IF EXISTS `ctc_dealer_points_rule`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ctc_dealer_points_rule` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `rule_des` text,
  `dealer_id` int(11) DEFAULT NULL,
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ctc_dealer_points_rule`
--

LOCK TABLES `ctc_dealer_points_rule` WRITE;
/*!40000 ALTER TABLE `ctc_dealer_points_rule` DISABLE KEYS */;
INSERT INTO `ctc_dealer_points_rule` VALUES (2,'<p>积分规则请自定义！</p>',29,'2022-08-22 17:13:21');
/*!40000 ALTER TABLE `ctc_dealer_points_rule` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ctc_dealer_points_set`
--

DROP TABLE IF EXISTS `ctc_dealer_points_set`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ctc_dealer_points_set` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `dealer_id` int(11) DEFAULT NULL,
  `exchange_value` int(11) DEFAULT NULL COMMENT '兑换值',
  `integral_explain` varchar(255) DEFAULT NULL,
  `is_clear` tinyint(4) DEFAULT '0' COMMENT '是否定期清零',
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ctc_dealer_points_set`
--

LOCK TABLES `ctc_dealer_points_set` WRITE;
/*!40000 ALTER TABLE `ctc_dealer_points_set` DISABLE KEYS */;
/*!40000 ALTER TABLE `ctc_dealer_points_set` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ctc_dealer_points_template`
--

DROP TABLE IF EXISTS `ctc_dealer_points_template`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
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
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ctc_dealer_points_template`
--

LOCK TABLES `ctc_dealer_points_template` WRITE;
/*!40000 ALTER TABLE `ctc_dealer_points_template` DISABLE KEYS */;
INSERT INTO `ctc_dealer_points_template` VALUES (2,'积分商城','我正在看积分商城，挺不错的，你也来看看吧。','###','积分商城','[{\"type\":\"user\",\"face\":\"\\/static\\/img\\/default-face.b5316121.png\",\"height\":20},{\"type\":\"line\",\"height\":20},{\"type\":\"search\",\"text\":\"\\u641c\\u7d22\\u793c\\u54c1\",\"height\":60},{\"type\":\"nav\",\"content\":[{\"url\":\"\\/static\\/img\\/nav-1-icon@2x.76794824.png\",\"text\":\"\\u793c\\u54c1\\u5217\\u8868\",\"is_show\":1},{\"url\":\"\\/static\\/img\\/nav-2-icon@2x.761261e4.png\",\"text\":\"\\u4e2a\\u4eba\\u4e2d\\u5fc3\",\"is_show\":1},{\"url\":\"\\/static\\/img\\/nav-3-icon@2x.b064880f.png\",\"text\":\"\\u8ba2\\u5355\\u4e2d\\u5fc3\",\"is_show\":1},{\"url\":\"\\/static\\/img\\/nav-4-icon@2x.1aff1290.png\",\"text\":\"\\u5151\\u6362\\u89c4\\u5219\",\"is_show\":1}]},{\"type\":\"line\",\"height\":20},{\"type\":\"notice\",\"text\":\"\\u53d7\\u75ab\\u60c5\\u5f71\\u54cd\\uff0c\\u53d1\\u8d27\\u4f1a\\u6709\\u5ef6\\u8fdf\\u8bf7\\u8c05\\u89e3~\"},{\"type\":\"banner\",\"imgList\":[{\"url\":\"\\/static\\/img\\/wsc-default.ba6454f6.png\",\"link\":\"\"}],\"height\":152},{\"type\":\"line\",\"height\":20},{\"type\":\"recom\",\"text\":\"\\u70ed\\u95e8\\u63a8\\u8350\",\"url\":\"\",\"product_title\":\"iPhone13\",\"num\":\"\\u5df2\\u5151\\u636210\",\"points\":100},{\"type\":\"line\",\"height\":20}]',29,0,'2022-08-01 17:04:19');
/*!40000 ALTER TABLE `ctc_dealer_points_template` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ctc_dealer_product`
--

DROP TABLE IF EXISTS `ctc_dealer_product`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
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
  `price` varchar(255) DEFAULT NULL COMMENT '价格',
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
  PRIMARY KEY (`id`),
  UNIQUE KEY `code` (`code`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=102 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ctc_dealer_product`
--

LOCK TABLES `ctc_dealer_product` WRITE;
/*!40000 ALTER TABLE `ctc_dealer_product` DISABLE KEYS */;
INSERT INTO `ctc_dealer_product` VALUES (13,'001',13,14,'123456','10g','50','100','直角弯头','件','[{\"url\":\"http://cdn.uni-2id.com/3b365202204180425149109.jpg\",\"name\":\"3b365202204180425149109.jpg\"}]','10元','10元','<p><img src=\"http://cdn.uni-2id.com/2d570202204180426075537.jpg\"></p>',1,'10cm','20','123456','石家庄伟星','伟星','2',25,'2022-04-17 20:26:32',NULL,1),(14,'WXZP',13,14,'','','','1','伟星新材石家庄分公司-正品','','[{\"url\":\"https://cdn.icloudapi.cn/34999202204121521583467.jpg\",\"name\":\"34999202204121521583467.jpg\"}]','1','','',0,'','','','',NULL,'',25,'2022-04-19 02:36:27',NULL,0),(15,'wx',15,16,'','','','100','牛栏山','','[{\"url\":\"http://cdn.uni-2id.com/0e906202206201502499112.png\",\"name\":\"0e906202206201502499112.png\"}]','50','50','<p>伟星管</p>',0,'','','','',NULL,'',29,'2022-05-26 02:34:18',NULL,0),(16,'wxg',17,18,'','','','0','伟星管','0','[{\"url\":\"http://cdn.uni-2id.com/0fc92202206131005552713.jpg\",\"name\":\"0fc92202206131005552713.jpg\"}]','0','','',0,'','','','',NULL,'',28,'2022-06-13 02:06:22',NULL,0),(17,'zt',17,18,'','','','0','直通','','[{\"url\":\"http://cdn.uni-2id.com/95d14202206160956435927.jpg\",\"name\":\"95d14202206160956435927.jpg\"}]','0','','',0,'d20','','','',NULL,'',28,'2022-06-16 01:58:51',NULL,0),(18,'jiu',19,20,'','','','0','聚茂德烧坊酿酒','','[{\"url\":\"http://cdn.uni-2id.com/4d30c202206200905362117.jpg\",\"name\":\"4d30c202206200905362117.jpg\"}]','0','','',0,'','','','',NULL,'',32,'2022-06-20 01:08:10',NULL,0),(19,'1',15,16,'123','5kg','2','10','十八酒坊','个','[{\"url\":\"http://cdn.uni-2id.com/03905202205261040268703.jpg\",\"name\":\"03905202205261040268703.jpg\"},{\"url\":\"http://cdn.uni-2id.com/4626e202205241052243681.jpg\",\"name\":\"4626e202205241052243681.jpg\"}]','9','10','<p>嘻嘻嘻</p>',0,'100','10','1213','伟星','伟星','3',29,'2022-06-22 07:42:14',NULL,0),(22,'wt11',13,14,'','','','1','90度弯头','','[{\"url\":\"http://cdn.uni-2id.com/3b365202204180425149109.jpg\",\"name\":\"3b365202204180425149109.jpg\"}]','1','','',0,'','','','',NULL,'',25,'2022-07-08 02:29:42',NULL,0),(23,'lrsg',NULL,NULL,NULL,NULL,NULL,'1','冷热水管S3.2',NULL,NULL,'1',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,25,'2022-07-08 02:37:17',NULL,0),(27,'whxcwhfgszp',22,23,'','','','99','伟星新材武汉分公司-正品','','[{\"url\":\"http://cdn.uni-2id.com/c2f66202207150959288655.jpg\",\"name\":\"c2f66202207150959288655.jpg\"}]','9','','',0,'','','','',NULL,'',33,'2022-07-26 05:44:36',NULL,0),(30,'yj90dwtD25',22,23,'','','','9','异径90度弯头','','[{\"url\":\"http://cdn.uni-2id.com/c2f66202207150959288655.jpg\",\"name\":\"c2f66202207150959288655.jpg\"}]','9','','',0,'','','','',NULL,'',33,'2022-07-26 06:55:45',NULL,0),(31,'yj90dwtD20',22,23,'','','','1','异径90度弯头','','[{\"url\":\"http://cdn.uni-2id.com/c2f66202207150959288655.jpg\",\"name\":\"c2f66202207150959288655.jpg\"}]','1','','',0,'','','','',NULL,'',33,'2022-07-26 06:56:47',NULL,0),(32,'djstD20',0,0,'','','','1','等径三通','','[{\"url\":\"http://cdn.uni-2id.com/c2f66202207150959288655.jpg\",\"name\":\"c2f66202207150959288655.jpg\"}]','1','','',0,'','','','',NULL,'',33,'2022-07-26 06:57:15',NULL,0),(33,'ztD25',0,0,'','','','1','直通','','[{\"url\":\"http://cdn.uni-2id.com/c2f66202207150959288655.jpg\",\"name\":\"c2f66202207150959288655.jpg\"}]','1','','',0,'','','','',NULL,'',33,'2022-07-26 06:58:02',NULL,0),(34,'45dwtD25',0,0,'','','','1','45度弯头','','[{\"url\":\"http://cdn.uni-2id.com/c2f66202207150959288655.jpg\",\"name\":\"c2f66202207150959288655.jpg\"}]','1','','',0,'','','','',NULL,'',33,'2022-07-26 06:58:57',NULL,0),(35,'90dwtD25',0,0,'','','','1','90度弯头','','[{\"url\":\"http://cdn.uni-2id.com/c2f66202207150959288655.jpg\",\"name\":\"c2f66202207150959288655.jpg\"}]','1','','',0,'','','','',NULL,'',33,'2022-07-26 06:59:30',NULL,0),(36,'dwD20',0,0,'','','','1','伟星大弯','','[{\"url\":\"http://cdn.uni-2id.com/c2f66202207150959288655.jpg\",\"name\":\"c2f66202207150959288655.jpg\"}]','1','','',0,'','','','',NULL,'',33,'2022-07-26 07:00:02',NULL,0),(37,'45dwtD20',0,0,'','','','1','45度弯头','','[{\"url\":\"http://cdn.uni-2id.com/c2f66202207150959288655.jpg\",\"name\":\"c2f66202207150959288655.jpg\"}]','1','','',0,'','','','',NULL,'',33,'2022-07-26 07:00:38',NULL,0),(38,'gqstD20',0,0,'','','','1','过桥四通','','[{\"url\":\"http://cdn.uni-2id.com/c2f66202207150959288655.jpg\",\"name\":\"c2f66202207150959288655.jpg\"}]','1','','',0,'','','','',NULL,'',33,'2022-07-26 07:01:06',NULL,0),(39,'gqwD20',0,0,'','','','1','过桥弯','','[{\"url\":\"http://cdn.uni-2id.com/c2f66202207150959288655.jpg\",\"name\":\"c2f66202207150959288655.jpg\"}]','1','','',0,'','','','',NULL,'',33,'2022-07-26 07:01:32',NULL,0),(40,'ylwjtD20*1/2',0,0,'','','','1','阴螺纹接头','','[{\"url\":\"http://cdn.uni-2id.com/c2f66202207150959288655.jpg\",\"name\":\"c2f66202207150959288655.jpg\"}]','1','','',0,'','','','',NULL,'',33,'2022-07-26 07:02:31',NULL,0),(41,'ylwjtD25*1/2',0,0,'','','','1','阴螺纹接头','','[{\"url\":\"http://cdn.uni-2id.com/c2f66202207150959288655.jpg\",\"name\":\"c2f66202207150959288655.jpg\"}]','1','','',0,'','','','',NULL,'',33,'2022-07-26 07:03:14',NULL,0),(42,'nsD20*1/2*20',0,0,'','','','1','阴螺纹三通','','[{\"url\":\"http://cdn.uni-2id.com/c2f66202207150959288655.jpg\",\"name\":\"c2f66202207150959288655.jpg\"}]','1','','',0,'','','','',NULL,'',33,'2022-07-26 07:03:47',NULL,0),(43,'ylwjtD25*3/4',0,0,'','','','1','阴螺纹接头','','[{\"url\":\"http://cdn.uni-2id.com/c2f66202207150959288655.jpg\",\"name\":\"c2f66202207150959288655.jpg\"}]','1','','',0,'','','','',NULL,'',33,'2022-07-26 07:04:46',NULL,0),(44,'ssstD20',0,0,'','','','1','伟星顺水三通','','[{\"url\":\"http://cdn.uni-2id.com/c2f66202207150959288655.jpg\",\"name\":\"c2f66202207150959288655.jpg\"}]','1','','',0,'','','','',NULL,'',33,'2022-07-26 07:05:41',NULL,0),(45,'wxssstD25',0,0,'','','','1','伟星顺水三通','','[{\"url\":\"http://cdn.uni-2id.com/c2f66202207150959288655.jpg\",\"name\":\"c2f66202207150959288655.jpg\"}]','1','','',0,'','','','',NULL,'',33,'2022-07-26 07:06:28',NULL,0),(46,'gqwD25',0,0,'','','','1','过桥弯','','[{\"url\":\"http://cdn.uni-2id.com/c2f66202207150959288655.jpg\",\"name\":\"c2f66202207150959288655.jpg\"}]','1','','',0,'','','','',NULL,'',33,'2022-07-26 07:07:33',NULL,0),(47,'ylwstD25*1/2*25',0,0,'','','','1','阴螺纹三通','','[{\"url\":\"http://cdn.uni-2id.com/c2f66202207150959288655.jpg\",\"name\":\"c2f66202207150959288655.jpg\"}]','1','','',0,'','','','',NULL,'',33,'2022-07-26 07:08:01',NULL,0),(48,'wxdwD25',0,0,'','','','1','伟星大弯','','[{\"url\":\"http://cdn.uni-2id.com/c2f66202207150959288655.jpg\",\"name\":\"c2f66202207150959288655.jpg\"}]','1','','',0,'','','','',NULL,'',33,'2022-07-26 07:09:10',NULL,0),(49,'gqstD25',0,0,'','','','1','过桥四通','','[{\"url\":\"http://cdn.uni-2id.com/c2f66202207150959288655.jpg\",\"name\":\"c2f66202207150959288655.jpg\"}]','1','','',0,'','','','',NULL,'',33,'2022-07-26 07:09:32',NULL,0),(50,'hsfD20',0,0,'','','','1','回水阀','','[{\"url\":\"http://cdn.uni-2id.com/c2f66202207150959288655.jpg\",\"name\":\"c2f66202207150959288655.jpg\"}]','1','','',0,'','','','',NULL,'',33,'2022-07-26 07:09:50',NULL,0),(51,'hsfD25',0,0,'','','','1','回水阀','','[{\"url\":\"http://cdn.uni-2id.com/c2f66202207150959288655.jpg\",\"name\":\"c2f66202207150959288655.jpg\"}]','1','','',0,'','','','',NULL,'',33,'2022-07-26 07:10:19',NULL,0),(52,'jzfD25',0,0,'','','','1','截止阀','','[{\"url\":\"http://cdn.uni-2id.com/c2f66202207150959288655.jpg\",\"name\":\"c2f66202207150959288655.jpg\"}]','1','','',0,'','','','',NULL,'',33,'2022-07-26 07:10:49',NULL,0),(53,'ltywD20',0,0,'','','','1','连体阴弯','','[{\"url\":\"http://cdn.uni-2id.com/c2f66202207150959288655.jpg\",\"name\":\"c2f66202207150959288655.jpg\"}]','1','','',0,'','','','',NULL,'',33,'2022-07-26 07:11:37',NULL,0),(54,'ltywD25',0,0,'','','','1','连体阴弯','','[{\"url\":\"http://cdn.uni-2id.com/c2f66202207150959288655.jpg\",\"name\":\"c2f66202207150959288655.jpg\"}]','1','','',0,'','','','',NULL,'',33,'2022-07-26 07:11:58',NULL,0),(55,'ylwwtD20*1/2',0,0,'','','','1','阴螺纹弯头','','[{\"url\":\"http://cdn.uni-2id.com/c2f66202207150959288655.jpg\",\"name\":\"c2f66202207150959288655.jpg\"}]','1','','',0,'','','','',NULL,'',33,'2022-07-26 07:12:26',NULL,0),(56,'jzfD20',0,0,'','','','1','截止阀','','[{\"url\":\"http://cdn.uni-2id.com/c2f66202207150959288655.jpg\",\"name\":\"c2f66202207150959288655.jpg\"}]','1','','',0,'','','','',NULL,'',33,'2022-07-26 07:12:45',NULL,0),(57,'bsD25/D20',0,0,'','','','1','卜申','','[{\"url\":\"http://cdn.uni-2id.com/c2f66202207150959288655.jpg\",\"name\":\"c2f66202207150959288655.jpg\"}]','1','','',0,'','','','',NULL,'',33,'2022-07-26 07:13:32',NULL,0),(62,'swdwtd20',22,23,'','','','99','45度弯头','','[{\"url\":\"http://cdn.uni-2id.com/c2f66202207150959288655.jpg\",\"name\":\"c2f66202207150959288655.jpg\"}]','99','','',0,'','','','',NULL,'',33,'2022-07-26 07:15:24',NULL,0),(63,'90dwtD20',0,0,'','','','1','90度弯头','','[{\"url\":\"http://cdn.uni-2id.com/c2f66202207150959288655.jpg\",\"name\":\"c2f66202207150959288655.jpg\"}]','1','','',0,'','','','',NULL,'',33,'2022-07-26 07:15:47',NULL,0),(64,'djstD25',0,0,'','','','1','等径三通','','[{\"url\":\"http://cdn.uni-2id.com/c2f66202207150959288655.jpg\",\"name\":\"c2f66202207150959288655.jpg\"}]','1','','',0,'','','','',NULL,'',33,'2022-07-26 07:16:21',NULL,0),(65,'ztD20',0,0,'','','','1','直通','','[{\"url\":\"http://cdn.uni-2id.com/c2f66202207150959288655.jpg\",\"name\":\"c2f66202207150959288655.jpg\"}]','1','','',0,'','','','',NULL,'',33,'2022-07-26 07:16:37',NULL,0),(66,' swD20',0,0,'','','','1','S型弯头','','[{\"url\":\"http://cdn.uni-2id.com/c2f66202207150959288655.jpg\",\"name\":\"c2f66202207150959288655.jpg\"}]','1','','',0,'','','','',NULL,'',33,'2022-07-26 09:10:00',NULL,0),(67,'swD25',0,0,'','','','1','S型弯头','','[{\"url\":\"http://cdn.uni-2id.com/c2f66202207150959288655.jpg\",\"name\":\"c2f66202207150959288655.jpg\"}]','1','','',0,'','','','',NULL,'',33,'2022-07-26 09:11:50',NULL,0),(68,'wt',24,25,'','','','0','弯头','','[{\"url\":\"http://cdn.uni-2id.com/c51ca202208240929015410.jpg\",\"name\":\"c51ca202208240929015410.jpg\"}]','0','','',0,'','','','',NULL,'',34,'2022-08-24 01:29:42',NULL,1),(69,'tlspprjzzyylwwts2.5',24,25,'','','','0','天蓝色 PP-R家装专用 阴螺纹弯头S2.5－(北京)dn25','','[{\"url\":\"http://cdn.uni-2id.com/c51ca202208240929015410.jpg\",\"name\":\"c51ca202208240929015410.jpg\"}]','0','','',0,'dn25x1/2','','','',NULL,'',34,'2022-09-01 13:24:48',NULL,0),(70,'ylwwtD20',24,25,'','','','0','蓝色 PP-R家装专用 阴螺纹弯头S2.5－(北京)dn20','','[{\"url\":\"http://cdn.uni-2id.com/c51ca202208240929015410.jpg\",\"name\":\"c51ca202208240929015410.jpg\"}]','0','','',0,'dn20x1/2','','','',NULL,'',34,'2022-09-01 13:30:01',NULL,0),(71,'ylwwtS2.5D25',24,25,'','','','0','翠绿色 PP-R家装专用 阴螺纹弯头S2.5－(北京)dn25','','[{\"url\":\"http://cdn.uni-2id.com/c51ca202208240929015410.jpg\",\"name\":\"c51ca202208240929015410.jpg\"}]','0','','',0,'dn25x1/2','','','',NULL,'',34,'2022-09-01 15:59:54',NULL,0),(72,'ylwwtS2.5D20',24,25,'','','','0','翠绿色 PP-R家装专用 阴螺纹弯头S2.5－(北京)dn20','','[{\"url\":\"http://cdn.uni-2id.com/c51ca202208240929015410.jpg\",\"name\":\"c51ca202208240929015410.jpg\"}]','0','','',0,'dn20x1/2','','','',NULL,'',34,'2022-09-01 16:00:51',NULL,0),(76,'ylwwtD25',24,25,'','','','0','绿色 PP-R家装专用 阴螺纹弯头S2.5－(北京)dn25','','[{\"url\":\"http://cdn.uni-2id.com/c51ca202208240929015410.jpg\",\"name\":\"c51ca202208240929015410.jpg\"}]','0','','',0,'dn25x1/2','','','',NULL,'',34,'2022-09-01 16:02:52',NULL,0),(77,'lsPPRylwwtD20',24,25,'','','','0','绿色 PP-R家装专用 阴螺纹弯头S2.5－(北京)dn20','','[{\"url\":\"http://cdn.uni-2id.com/c51ca202208240929015410.jpg\",\"name\":\"c51ca202208240929015410.jpg\"}]','0','','',0,'dn20x1/2','','','',NULL,'',34,'2022-09-01 16:04:54',NULL,0),(78,'tlsshjqf',24,25,'','','','0','天蓝色 PP-R家装专用 双活接球阀S2.5(304手柄)－(北京)dn25','','[{\"url\":\"http://cdn.uni-2id.com/c51ca202208240929015410.jpg\",\"name\":\"c51ca202208240929015410.jpg\"}]','0','','',0,'dn25','','','',NULL,'',34,'2022-09-01 16:06:52',NULL,0),(79,'shjqfdn20',24,25,'','','','0','天蓝色 PP-R家装专用 双活接球阀S2.5(304手柄)－(北京)dn20','','[{\"url\":\"http://cdn.uni-2id.com/c51ca202208240929015410.jpg\",\"name\":\"c51ca202208240929015410.jpg\"}]','0','','',0,'dn20','','','',NULL,'',34,'2022-09-01 16:14:33',NULL,0),(80,'clsshjqfdn25',24,25,'','','','0','翠绿色 PP-R家装专用 双活接球阀S2.5(304手柄)－(北京)dn25','','[{\"url\":\"http://cdn.uni-2id.com/c51ca202208240929015410.jpg\",\"name\":\"c51ca202208240929015410.jpg\"}]','0','','',0,'dn25','','','',NULL,'',34,'2022-09-01 16:15:50',NULL,0),(81,'clsshjqfdn20',24,25,'','','','0','翠绿色 PP-R家装专用 双活接球阀S2.5(304手柄)－(北京)dn20','','[{\"url\":\"http://cdn.uni-2id.com/c51ca202208240929015410.jpg\",\"name\":\"c51ca202208240929015410.jpg\"}]','0','','',0,'dn20','','','',NULL,'',34,'2022-09-01 16:16:40',NULL,0),(82,'lsshjqfdn25',24,25,'','','','0','绿色 PP-R家装专用 双活接球阀S2.5(304手柄)－(北京)dn25','','[{\"url\":\"http://cdn.uni-2id.com/c51ca202208240929015410.jpg\",\"name\":\"c51ca202208240929015410.jpg\"}]','0','','',0,'dn25','','','',NULL,'',34,'2022-09-01 16:20:19',NULL,0),(83,'lsshjqfdn20',24,25,'','','','0','绿色 PP-R家装专用 双活接球阀S2.5(304手柄)－(北京)dn20','','[{\"url\":\"http://cdn.uni-2id.com/c51ca202208240929015410.jpg\",\"name\":\"c51ca202208240929015410.jpg\"}]','0','','',0,'dn20','','','',NULL,'',34,'2022-09-01 16:20:52',NULL,0),(84,'tls90wtd25',24,25,'','','','0','天蓝色 PP-R家装专用 90度弯头S2.5－(北京)dn25','','[{\"url\":\"http://cdn.uni-2id.com/c51ca202208240929015410.jpg\",\"name\":\"c51ca202208240929015410.jpg\"}]','0','','',0,'dn25','','','',NULL,'',34,'2022-09-01 16:25:40',NULL,0),(85,'tl90wtdn20',24,25,'','','','0','天蓝色 PP-R家装专用 90度弯头S2.5－(北京)dn20','','[{\"url\":\"http://cdn.uni-2id.com/c51ca202208240929015410.jpg\",\"name\":\"c51ca202208240929015410.jpg\"}]','0','','',0,'dn20','','','',NULL,'',34,'2022-09-01 16:26:13',NULL,0),(86,'cls90wtdn25',24,25,'','','','0','翠绿色 PP-R家装专用 90度弯头S2.5－(北京)dn25','','[{\"url\":\"http://cdn.uni-2id.com/c51ca202208240929015410.jpg\",\"name\":\"c51ca202208240929015410.jpg\"}]','0','','',0,'dn25','','','',NULL,'',34,'2022-09-01 16:27:08',NULL,0),(87,'cls90wtdn20',24,25,'','','','0','翠绿色 PP-R家装专用 90度弯头S2.5－(北京)dn20','','[{\"url\":\"http://cdn.uni-2id.com/c51ca202208240929015410.jpg\",\"name\":\"c51ca202208240929015410.jpg\"}]','0','','',0,'dn20','','','',NULL,'',34,'2022-09-01 16:27:49',NULL,0),(88,'ls90wtdn25',24,25,'','','','0','绿色 PP-R家装专用 90度弯头S2.5－(北京)dn25','','[{\"url\":\"http://cdn.uni-2id.com/c51ca202208240929015410.jpg\",\"name\":\"c51ca202208240929015410.jpg\"}]','0','','',0,'dn25','','','',NULL,'',34,'2022-09-01 16:28:58',NULL,0),(89,'ls90wtdn20',24,25,'','','','0','绿色 PP-R家装专用 90度弯头S2.5－(北京)dn20','','[{\"url\":\"http://cdn.uni-2id.com/c51ca202208240929015410.jpg\",\"name\":\"c51ca202208240929015410.jpg\"}]','0','','',0,'dn20','','','',NULL,'',34,'2022-09-01 16:29:30',NULL,0),(90,'tlsdjstdn25',0,0,'','','','0','天蓝色 PP-R家装专用 等径三通S2.5－(北京)dn25','','[{\"url\":\"http://cdn.uni-2id.com/c51ca202208240929015410.jpg\",\"name\":\"c51ca202208240929015410.jpg\"}]','0','','',0,'dn25','','','',NULL,'',34,'2022-09-01 16:30:11',NULL,0),(91,'tlsdjstdn20',24,25,'','','','0','天蓝色 PP-R家装专用 等径三通S2.5－(北京)dn20','','[{\"url\":\"http://cdn.uni-2id.com/c51ca202208240929015410.jpg\",\"name\":\"c51ca202208240929015410.jpg\"}]','0','','',0,'dn20','','','',NULL,'',34,'2022-09-01 16:30:45',NULL,0),(92,'clsdjstdn25',24,25,'','','','0','翠绿色 PP-R家装专用 等径三通S2.5－(北京)dn25','','[{\"url\":\"http://cdn.uni-2id.com/c51ca202208240929015410.jpg\",\"name\":\"c51ca202208240929015410.jpg\"}]','0','','',0,'dn25','','','',NULL,'',34,'2022-09-01 16:31:23',NULL,0),(93,'clsdjstdn20',24,25,'','','','0','翠绿色 PP-R家装专用 等径三通S2.5－(北京)dn20','','[{\"url\":\"http://cdn.uni-2id.com/c51ca202208240929015410.jpg\",\"name\":\"c51ca202208240929015410.jpg\"}]','0','','',0,'dn20','','','',NULL,'',34,'2022-09-01 16:31:49',NULL,0),(94,'lsdjstdn25',24,25,'','','','0','绿色 PP-R家装专用 等径三通S2.5－(北京)dn25','','[{\"url\":\"http://cdn.uni-2id.com/c51ca202208240929015410.jpg\",\"name\":\"c51ca202208240929015410.jpg\"}]','0','','',0,'dn25','','','',NULL,'',34,'2022-09-01 16:32:39',NULL,0),(95,'lsdjstdn20',24,25,'','','','0','绿色 PP-R家装专用 等径三通S2.5－(北京)dn20','','[{\"url\":\"http://cdn.uni-2id.com/c51ca202208240929015410.jpg\",\"name\":\"c51ca202208240929015410.jpg\"}]','0','','',0,'dn20','','','',NULL,'',34,'2022-09-01 16:33:07',NULL,0),(96,'clztdn25',24,25,'','','','0','翠绿色 PP-R家装专用 直通S2.5－(北京)dn25','','[{\"url\":\"http://cdn.uni-2id.com/c51ca202208240929015410.jpg\",\"name\":\"c51ca202208240929015410.jpg\"}]','0','','',0,'dn25','','','',NULL,'',34,'2022-09-01 16:33:46',NULL,0),(97,'clztdn20',24,25,'','','','0','翠绿色 PP-R家装专用 直通S2.5－(北京)dn20','','[{\"url\":\"http://cdn.uni-2id.com/c51ca202208240929015410.jpg\",\"name\":\"c51ca202208240929015410.jpg\"}]','0','','',0,'dn20','','','',NULL,'',34,'2022-09-01 16:34:13',NULL,0),(98,'tlsztdn25',24,25,'','','','0','天蓝色 PP-R家装专用 直通S2.5－(北京)dn25','','[{\"url\":\"http://cdn.uni-2id.com/c51ca202208240929015410.jpg\",\"name\":\"c51ca202208240929015410.jpg\"}]','0','','',0,'dn25','','','',NULL,'',34,'2022-09-01 16:34:56',NULL,0),(99,'tlsztdn20',24,25,'','','','0','天蓝色 PP-R家装专用 直通S2.5－(北京)dn20','','[{\"url\":\"http://cdn.uni-2id.com/c51ca202208240929015410.jpg\",\"name\":\"c51ca202208240929015410.jpg\"}]','0','','',0,'dn20','','','',NULL,'',34,'2022-09-01 16:35:22',NULL,0),(100,'lsztdn25',24,25,'','','','0','绿色 PP-R家装专用 直通S2.5－(北京)dn25','','[{\"url\":\"http://cdn.uni-2id.com/c51ca202208240929015410.jpg\",\"name\":\"c51ca202208240929015410.jpg\"}]','0','','',0,'dn25','','','',NULL,'',34,'2022-09-01 16:35:57',NULL,0),(101,'lsztdn20',24,25,'','','','0','绿色 PP-R家装专用 直通S2.5－(北京)dn20','','[{\"url\":\"http://cdn.uni-2id.com/c51ca202208240929015410.jpg\",\"name\":\"c51ca202208240929015410.jpg\"}]','0','','',0,'dn20','','','',NULL,'',34,'2022-09-01 16:36:34',NULL,0);
/*!40000 ALTER TABLE `ctc_dealer_product` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ctc_dealer_product_class`
--

DROP TABLE IF EXISTS `ctc_dealer_product_class`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ctc_dealer_product_class` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `class_name` varchar(255) DEFAULT NULL,
  `parent_id` int(11) DEFAULT '0',
  `order` int(11) DEFAULT NULL,
  `dealer_id` int(11) DEFAULT NULL,
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=26 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ctc_dealer_product_class`
--

LOCK TABLES `ctc_dealer_product_class` WRITE;
/*!40000 ALTER TABLE `ctc_dealer_product_class` DISABLE KEYS */;
INSERT INTO `ctc_dealer_product_class` VALUES (13,'伟星',0,1,25,'2022-04-12 07:18:33'),(14,'伟星管',13,1,25,'2022-04-12 07:46:37'),(15,'酒',0,1,29,'2022-05-26 02:31:49'),(16,'清香',15,2,29,'2022-05-26 02:32:02'),(17,'建材',0,1,28,'2022-06-13 02:02:52'),(18,'管件',17,2,28,'2022-06-13 02:03:16'),(19,'酒',0,1,32,'2022-06-20 01:04:03'),(20,'清香',19,1,32,'2022-06-20 01:07:34'),(21,'酱香型',15,3,29,'2022-05-26 02:32:02'),(22,'伟星',0,1,33,'2022-07-15 01:55:02'),(23,'管类',22,2,33,'2022-07-15 01:55:02'),(24,'建材',0,1,34,'2022-08-24 01:27:14'),(25,'伟星管',24,2,34,'2022-08-24 01:27:21');
/*!40000 ALTER TABLE `ctc_dealer_product_class` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ctc_dealer_qrcode_marketing_activity`
--

DROP TABLE IF EXISTS `ctc_dealer_qrcode_marketing_activity`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ctc_dealer_qrcode_marketing_activity` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `activity_name` varchar(255) DEFAULT NULL COMMENT '活动名称',
  `begin_time` timestamp NULL DEFAULT NULL COMMENT '开始时间',
  `end_time` timestamp NULL DEFAULT NULL COMMENT '结束时间',
  `remark` varchar(255) DEFAULT NULL COMMENT '活动备注',
  `tpl_name` varchar(255) DEFAULT NULL COMMENT '模板名称',
  `tpl_id` int(11) DEFAULT NULL COMMENT '模板id',
  `join_condition` tinyint(4) DEFAULT NULL COMMENT '活动参与方式 1关注微信公众号领奖 2直接领奖',
  `is_user_info` tinyint(4) DEFAULT '0' COMMENT '是否收集用户资料 0否 1是',
  `user_info_field` text COMMENT '用户信息收集字段',
  `is_auth_tag` tinyint(4) DEFAULT '0' COMMENT '是否自动打标签0否 1是',
  `tags` varchar(255) DEFAULT NULL COMMENT '用户微信标签id（打标签用）',
  `is_user_address` tinyint(4) DEFAULT '0' COMMENT '是否获取用户位置0否 1是',
  `is_rule_show` tinyint(4) DEFAULT '0' COMMENT '是否显示活动规则 0否 1是',
  `rule_title` varchar(255) DEFAULT NULL COMMENT '规则标题',
  `rule_content` varchar(255) DEFAULT NULL COMMENT '规则内容',
  `active_area` int(11) DEFAULT NULL COMMENT '活动区域',
  `code_batch_data` text COMMENT '赋码字段',
  `prize_data` text COMMENT '奖项',
  `empty_tips` varchar(255) DEFAULT NULL COMMENT '未中奖提示',
  `repeat_tips` varchar(255) DEFAULT NULL COMMENT '重复领奖提示',
  `invalid_tips` varchar(255) DEFAULT NULL COMMENT '奖项已被领取提示',
  `is_join_limit` tinyint(4) DEFAULT '0' COMMENT '活动参与限制 0不开启 1开启',
  `day_limit_times` int(11) DEFAULT NULL COMMENT '每人每天限领次数',
  `limit_times_tips` varchar(255) DEFAULT NULL COMMENT '超次提示',
  `is_open_appoint` tinyint(4) DEFAULT '0' COMMENT '是否开启定向0不开启 1开启',
  `is_user_limit` tinyint(4) DEFAULT '0' COMMENT '指定用户参与0不开启 1开启',
  `limit_user_tags` varchar(255) DEFAULT NULL COMMENT '指定领取用户标签',
  `unexpected_user_tips` varchar(255) DEFAULT NULL COMMENT '不符合用户领取提示',
  `is_address_limit` tinyint(4) DEFAULT '0' COMMENT '指定地区参与0关闭 1开启',
  `is_address_limit_type` tinyint(4) DEFAULT NULL COMMENT '参与类型1 按行政区域划分 2按GPS坐标设置',
  `select_limit_address` varchar(255) DEFAULT NULL COMMENT '限制区域',
  `out_address_tips` varchar(255) DEFAULT NULL COMMENT '非活动范围领奖提示',
  `fleeing_goods` tinyint(4) DEFAULT '0' COMMENT '是否监控窜货 0否 1是',
  `create_by` varchar(255) DEFAULT NULL,
  `work_type` varchar(255) NOT NULL COMMENT '工种',
  `status` tinyint(4) DEFAULT '0' COMMENT '启用状态0未启用 1已启用 2禁用 3已删除',
  `dealer_id` int(11) DEFAULT NULL,
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=38 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ctc_dealer_qrcode_marketing_activity`
--

LOCK TABLES `ctc_dealer_qrcode_marketing_activity` WRITE;
/*!40000 ALTER TABLE `ctc_dealer_qrcode_marketing_activity` DISABLE KEYS */;
INSERT INTO `ctc_dealer_qrcode_marketing_activity` VALUES (37,'测试','2023-02-28 16:00:00','2023-05-30 16:00:00','','默认模板',14,2,0,'[]',0,'[]',1,0,'','',0,'[{\"batch\":\"20230223\",\"order_begin\":\"16070\",\"order_end\":\"16090\",\"quantity\":21,\"remark\":\"\"}]','[{\"prize_name\":\"\\u5956\\u9879\\u79ef\\u5206\",\"prize_number\":20,\"prize_rate\":\"95%\",\"prize_content\":\"\\u79ef\\u5206(1)\",\"win_num\":0,\"prize_type\":2,\"red_envelopes_name\":\"\",\"red_envelopes_id\":\"\",\"points\":1,\"goods_points\":false,\"gift\":[],\"valid_day\":3,\"get_prize_mode\":0,\"is_gift_tips\":false,\"gift_tips\":\"\"}]','很抱歉，您未中奖，再接再厉哦!','该二维码您已经领过奖了！','该二维码已经被别人领过奖了！',0,3,'抱歉，您已超过活动当日参与次数上限，请明天再试！',0,0,'[]','您不符合本次活动的参与条件',0,1,'[]','您不在本次活动指定的地区，无法参与活动~',2,'gawx','[]',1,29,'2023-04-11 06:16:43');
/*!40000 ALTER TABLE `ctc_dealer_qrcode_marketing_activity` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ctc_dealer_qrcode_marketing_order`
--

DROP TABLE IF EXISTS `ctc_dealer_qrcode_marketing_order`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ctc_dealer_qrcode_marketing_order` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `dealer_id` int(11) DEFAULT NULL,
  `member_id` int(11) DEFAULT NULL,
  `openid` varchar(255) DEFAULT NULL,
  `order` varchar(255) DEFAULT NULL,
  `gift` text COMMENT '所中商品信息',
  `get_prize_mode` tinyint(4) DEFAULT NULL COMMENT '领奖方式0物流 1门店核销',
  `valid_day` varchar(255) DEFAULT NULL COMMENT '有效天数',
  `status` tinyint(4) DEFAULT '0' COMMENT '订单状态',
  `code` varchar(255) DEFAULT NULL COMMENT '中奖二维码',
  `serial_number` varchar(255) DEFAULT NULL COMMENT '序列号',
  `batch` varchar(255) DEFAULT NULL COMMENT '批次',
  `activity_id` varchar(255) DEFAULT NULL COMMENT '营销活动id',
  `delivery_id` varchar(255) DEFAULT NULL COMMENT '物流单号',
  `delivery_mark` varchar(255) DEFAULT NULL COMMENT '物流发货备注',
  `is_get` tinyint(4) DEFAULT '0' COMMENT '是否领取',
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `delivery_name` varchar(255) DEFAULT NULL COMMENT '物流公司',
  `user_address_id` varchar(255) DEFAULT NULL COMMENT '收货人地址',
  `check_time` timestamp NULL DEFAULT NULL COMMENT '核销时间',
  `store_id` int(11) DEFAULT NULL COMMENT '核销门店id',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ctc_dealer_qrcode_marketing_order`
--

LOCK TABLES `ctc_dealer_qrcode_marketing_order` WRITE;
/*!40000 ALTER TABLE `ctc_dealer_qrcode_marketing_order` DISABLE KEYS */;
/*!40000 ALTER TABLE `ctc_dealer_qrcode_marketing_order` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ctc_dealer_qrcode_marketing_prize_bill`
--

DROP TABLE IF EXISTS `ctc_dealer_qrcode_marketing_prize_bill`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ctc_dealer_qrcode_marketing_prize_bill` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `dealer_id` int(11) DEFAULT NULL,
  `code` varchar(255) DEFAULT NULL,
  `serial_number` varchar(255) DEFAULT NULL COMMENT '序列号',
  `openid` varchar(255) DEFAULT NULL,
  `member_id` int(11) DEFAULT NULL,
  `batch` varchar(255) DEFAULT NULL COMMENT '码批次',
  `activity_id` int(11) DEFAULT NULL COMMENT '活动id',
  `prize_name` varchar(255) DEFAULT NULL COMMENT '奖项名称',
  `prize_content` varchar(255) DEFAULT NULL COMMENT '奖项内容',
  `scan_type` varchar(255) DEFAULT NULL COMMENT '扫码方式',
  `province` varchar(255) DEFAULT NULL COMMENT '扫码省份',
  `city` varchar(255) DEFAULT NULL COMMENT '扫码城市',
  `district` varchar(255) DEFAULT NULL,
  `points` varchar(255) DEFAULT NULL COMMENT '积分数',
  `gift` text COMMENT '所中礼品',
  `money` varchar(255) DEFAULT NULL COMMENT '红包金额',
  `is_get` tinyint(4) DEFAULT '0' COMMENT '是否领取实物奖品 1已领取',
  `prize_type` tinyint(4) DEFAULT NULL COMMENT '奖项类型1红包 2积分 3礼品',
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `is_user_info` tinyint(4) DEFAULT '0' COMMENT '是否开启补充字段 1开启',
  `user_info_field` text,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=349 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ctc_dealer_qrcode_marketing_prize_bill`
--

LOCK TABLES `ctc_dealer_qrcode_marketing_prize_bill` WRITE;
/*!40000 ALTER TABLE `ctc_dealer_qrcode_marketing_prize_bill` DISABLE KEYS */;
/*!40000 ALTER TABLE `ctc_dealer_qrcode_marketing_prize_bill` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ctc_dealer_qrcode_marketing_query_bill`
--

DROP TABLE IF EXISTS `ctc_dealer_qrcode_marketing_query_bill`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ctc_dealer_qrcode_marketing_query_bill` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `code` varchar(255) DEFAULT NULL,
  `serial_number` varchar(255) DEFAULT NULL COMMENT '序号',
  `dealer_id` int(11) DEFAULT NULL,
  `batch` varchar(255) DEFAULT NULL COMMENT '批次',
  `address` varchar(255) DEFAULT NULL COMMENT '扫码区域',
  `openid` varchar(255) DEFAULT NULL COMMENT '扫码用户身份',
  `is_first` tinyint(4) DEFAULT '1' COMMENT '是否首次查询1 是 2否(重复)',
  `ip` varchar(255) DEFAULT NULL,
  `product_id` int(11) DEFAULT NULL,
  `province` varchar(255) DEFAULT NULL COMMENT '扫码省份',
  `city` varchar(255) DEFAULT NULL,
  `district` varchar(255) DEFAULT NULL COMMENT '扫码区',
  `scan_type` varchar(255) DEFAULT NULL COMMENT '扫码方式',
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `sources` tinyint(4) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1002 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ctc_dealer_qrcode_marketing_query_bill`
--

LOCK TABLES `ctc_dealer_qrcode_marketing_query_bill` WRITE;
/*!40000 ALTER TABLE `ctc_dealer_qrcode_marketing_query_bill` DISABLE KEYS */;
/*!40000 ALTER TABLE `ctc_dealer_qrcode_marketing_query_bill` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ctc_dealer_qrcode_marketing_redpack_register`
--

DROP TABLE IF EXISTS `ctc_dealer_qrcode_marketing_redpack_register`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ctc_dealer_qrcode_marketing_redpack_register` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '姓名',
  `name` varchar(255) DEFAULT NULL,
  `operation_center` varchar(255) NOT NULL COMMENT '运营中心分类',
  `phone` varchar(255) DEFAULT NULL,
  `address` varchar(255) DEFAULT NULL COMMENT '省市区',
  `location` varchar(255) DEFAULT NULL COMMENT '详细地址',
  `remark` varchar(255) DEFAULT NULL COMMENT '备注',
  `dealer_id` int(11) DEFAULT NULL,
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `status` tinyint(4) DEFAULT NULL COMMENT '状态 0 审核中 1审核通过  2被拒绝',
  `openid` varchar(255) DEFAULT NULL COMMENT '注册人身份',
  `work_type` varchar(255) NOT NULL COMMENT '工种',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1027 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ctc_dealer_qrcode_marketing_redpack_register`
--

LOCK TABLES `ctc_dealer_qrcode_marketing_redpack_register` WRITE;
/*!40000 ALTER TABLE `ctc_dealer_qrcode_marketing_redpack_register` DISABLE KEYS */;
INSERT INTO `ctc_dealer_qrcode_marketing_redpack_register` VALUES (1026,'文寒','1','18330118047','北京市 市辖区 东城区','测试','测试',29,'2023-04-09 10:13:18',1,'oe60X6k15tFeaU-JL-AK2VYYxXYk','1');
/*!40000 ALTER TABLE `ctc_dealer_qrcode_marketing_redpack_register` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ctc_dealer_qrcode_marketing_tpl`
--

DROP TABLE IF EXISTS `ctc_dealer_qrcode_marketing_tpl`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ctc_dealer_qrcode_marketing_tpl` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `dealer_id` int(11) DEFAULT NULL,
  `tpl_name` varchar(255) DEFAULT NULL COMMENT '模板名称',
  `remark` varchar(255) DEFAULT NULL COMMENT '备注',
  `type` tinyint(4) DEFAULT NULL COMMENT '扫码模板类型 1普通模板 2大转盘模板',
  `welcom_page` text COMMENT '欢迎页',
  `activity_page` text COMMENT '活动页',
  `create_by` varchar(255) DEFAULT NULL COMMENT '创建人',
  `xuanchuan_page` text COMMENT '宣传页',
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ctc_dealer_qrcode_marketing_tpl`
--

LOCK TABLES `ctc_dealer_qrcode_marketing_tpl` WRITE;
/*!40000 ALTER TABLE `ctc_dealer_qrcode_marketing_tpl` DISABLE KEYS */;
INSERT INTO `ctc_dealer_qrcode_marketing_tpl` VALUES (14,29,'默认模板','默认数据',1,'[{\"is_active\":1,\"title\":\"\\u626b\\u7801\\u6709\\u793c\",\"duration\":2,\"tips\":\"\\u8df3\\u8fc7\",\"cover\":\"http:\\/\\/cdn.uni-2id.com\\/welcom_page.png\"}]','[{\"title\":\"\\u626b\\u7801\\u7ed3\\u679c\",\"btn_text\":\"\\u6211\\u77e5\\u9053\\u4e86\",\"is_fangwei\":0,\"cover\":\"http:\\/\\/cdn.uni-2id.com\\/active_page.png\"}]','gawx','[{\"type\":\"auth\",\"auth_tips\":\"\\u67e5\\u8be2\\u9632\\u4f2a\\u7801\\u4e3a\",\"is_auth_code\":1,\"height\":300,\"first_tips\":\"\\u6b63\\u54c1\",\"first_res\":\"\\u60a8\\u597d\\uff0c\\u60a8\\u6240\\u67e5\\u8be2\\u7684\\u662f@\\u54c1\\u724c\\u5546\\u540d\\u79f0\\u751f\\u4ea7\\u7684\\u4ea7\\u54c1\\uff0c\\u8bf7\\u653e\\u5fc3\\u4f7f\\u7528\\uff01\",\"repet_tips\":\"\\u91cd\\u590d\",\"repet_res\":\"\\u8be5\\u9632\\u4f2a\\u7801\\u5df2\\u7ecf\\u88ab\\u4eba\\u67e5\\u8be2\\u8fc7\\uff0c\\u9996\\u6b21\\u67e5\\u8be2\\u65f6\\u95f4\\uff1a@\\u67e5\\u8be2\\u65f6\\u95f4\\uff0c\\u8c28\\u9632\\u5047\\u5192\\uff01\"}]','2023-04-11 06:13:31');
/*!40000 ALTER TABLE `ctc_dealer_qrcode_marketing_tpl` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ctc_dealer_qrcode_type`
--

DROP TABLE IF EXISTS `ctc_dealer_qrcode_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ctc_dealer_qrcode_type` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `type_name` varchar(255) DEFAULT NULL,
  `dealer_id` int(11) DEFAULT NULL,
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ctc_dealer_qrcode_type`
--

LOCK TABLES `ctc_dealer_qrcode_type` WRITE;
/*!40000 ALTER TABLE `ctc_dealer_qrcode_type` DISABLE KEYS */;
INSERT INTO `ctc_dealer_qrcode_type` VALUES (4,'咖乐',26,'2022-05-09 01:07:08'),(5,'水电工',30,'2022-05-30 01:25:51');
/*!40000 ALTER TABLE `ctc_dealer_qrcode_type` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ctc_dealer_redpack`
--

DROP TABLE IF EXISTS `ctc_dealer_redpack`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
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
) ENGINE=InnoDB AUTO_INCREMENT=30 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ctc_dealer_redpack`
--

LOCK TABLES `ctc_dealer_redpack` WRITE;
/*!40000 ALTER TABLE `ctc_dealer_redpack` DISABLE KEYS */;
/*!40000 ALTER TABLE `ctc_dealer_redpack` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ctc_dealer_redpack_bill`
--

DROP TABLE IF EXISTS `ctc_dealer_redpack_bill`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ctc_dealer_redpack_bill` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `openid` varchar(255) DEFAULT NULL COMMENT '发放人',
  `redpack_type` tinyint(4) DEFAULT NULL COMMENT '红包类型 字典获取',
  `redpack_id` int(11) DEFAULT NULL COMMENT '红包id',
  `status` tinyint(4) DEFAULT NULL COMMENT '发放状态 0成功1失败2发放中',
  `app_id` int(11) DEFAULT NULL COMMENT '发放应用 字典获取',
  `remark` varchar(255) DEFAULT NULL COMMENT '备注',
  `mch_billno` varchar(255) DEFAULT NULL COMMENT '商户订单号',
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `role` tinyint(4) DEFAULT NULL COMMENT '发放角色 1总部 2经销商',
  `dealer_id` int(11) DEFAULT NULL COMMENT '代理商',
  `money` decimal(8,2) DEFAULT NULL COMMENT '红包金额',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=351 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ctc_dealer_redpack_bill`
--

LOCK TABLES `ctc_dealer_redpack_bill` WRITE;
/*!40000 ALTER TABLE `ctc_dealer_redpack_bill` DISABLE KEYS */;
/*!40000 ALTER TABLE `ctc_dealer_redpack_bill` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ctc_dealer_role`
--

DROP TABLE IF EXISTS `ctc_dealer_role`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
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
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ctc_dealer_role`
--

LOCK TABLES `ctc_dealer_role` WRITE;
/*!40000 ALTER TABLE `ctc_dealer_role` DISABLE KEYS */;
INSERT INTO `ctc_dealer_role` VALUES (2,25,'财务','1','1','0',NULL,'0','2022-07-08 03:01:45',NULL,NULL,'39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57','1','1');
/*!40000 ALTER TABLE `ctc_dealer_role` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ctc_dealer_salesman`
--

DROP TABLE IF EXISTS `ctc_dealer_salesman`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ctc_dealer_salesman`
--

LOCK TABLES `ctc_dealer_salesman` WRITE;
/*!40000 ALTER TABLE `ctc_dealer_salesman` DISABLE KEYS */;
/*!40000 ALTER TABLE `ctc_dealer_salesman` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ctc_dealer_salesman_type`
--

DROP TABLE IF EXISTS `ctc_dealer_salesman_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ctc_dealer_salesman_type` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `class_name` varchar(255) DEFAULT NULL,
  `dealer_id` int(11) DEFAULT NULL,
  `remark` varchar(255) DEFAULT NULL,
  `status` tinyint(4) DEFAULT '0' COMMENT '状态0正常 1删除',
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ctc_dealer_salesman_type`
--

LOCK TABLES `ctc_dealer_salesman_type` WRITE;
/*!40000 ALTER TABLE `ctc_dealer_salesman_type` DISABLE KEYS */;
/*!40000 ALTER TABLE `ctc_dealer_salesman_type` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ctc_dealer_security_query_log`
--

DROP TABLE IF EXISTS `ctc_dealer_security_query_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ctc_dealer_security_query_log`
--

LOCK TABLES `ctc_dealer_security_query_log` WRITE;
/*!40000 ALTER TABLE `ctc_dealer_security_query_log` DISABLE KEYS */;
/*!40000 ALTER TABLE `ctc_dealer_security_query_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ctc_dealer_sms_early_warning`
--

DROP TABLE IF EXISTS `ctc_dealer_sms_early_warning`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ctc_dealer_sms_early_warning` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `num` varchar(255) DEFAULT NULL,
  `phone` varchar(255) DEFAULT NULL,
  `dealer_id` int(11) DEFAULT NULL,
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `status` tinyint(4) DEFAULT NULL COMMENT '0未开启 1开启预警',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ctc_dealer_sms_early_warning`
--

LOCK TABLES `ctc_dealer_sms_early_warning` WRITE;
/*!40000 ALTER TABLE `ctc_dealer_sms_early_warning` DISABLE KEYS */;
/*!40000 ALTER TABLE `ctc_dealer_sms_early_warning` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ctc_dealer_sms_log`
--

DROP TABLE IF EXISTS `ctc_dealer_sms_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ctc_dealer_sms_log` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `type` tinyint(4) DEFAULT NULL,
  `phone` varchar(255) DEFAULT NULL,
  `content` varchar(255) DEFAULT NULL,
  `dealer_id` int(11) DEFAULT NULL,
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ctc_dealer_sms_log`
--

LOCK TABLES `ctc_dealer_sms_log` WRITE;
/*!40000 ALTER TABLE `ctc_dealer_sms_log` DISABLE KEYS */;
/*!40000 ALTER TABLE `ctc_dealer_sms_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ctc_dealer_store`
--

DROP TABLE IF EXISTS `ctc_dealer_store`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
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
  `is_commission` tinyint(4) DEFAULT '0' COMMENT '是否开启返佣机制',
  `is_self_lifting` tinyint(4) DEFAULT '0' COMMENT '是否商品自提',
  `is_goods_self` tinyint(4) DEFAULT '0' COMMENT '是否商品自营',
  `is_mall` tinyint(4) DEFAULT '0' COMMENT '是否启用商城管理0否 1是',
  `points_num` decimal(8,2) DEFAULT '0.00' COMMENT '积分数',
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ctc_dealer_store`
--

LOCK TABLES `ctc_dealer_store` WRITE;
/*!40000 ALTER TABLE `ctc_dealer_store` DISABLE KEYS */;
INSERT INTO `ctc_dealer_store` VALUES (1,'001',1,'河北省','秦皇岛市','市辖区','测试','38.066399,114.465842','[{\"url\":\"http://cdn.uni-2id.com/03905202205261040268703.jpg\",\"name\":\"03905202205261040268703.jpg\"},{\"url\":\"http://cdn.uni-2id.com/0e906202206201502499112.png\",\"name\":\"0e906202206201502499112.png\"}]','[\"2022-10-07\",\"2022-11-09\"]','18330118047','18330118047','123456','0','测试','50','测试','测试','1',29,0,NULL,0,'',1,0.00,1,1,1,1,0.00,'2022-10-01 08:35:16');
/*!40000 ALTER TABLE `ctc_dealer_store` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ctc_dealer_store_app_goods`
--

DROP TABLE IF EXISTS `ctc_dealer_store_app_goods`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ctc_dealer_store_app_goods` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `dealer_id` int(11) DEFAULT NULL,
  `store_id` int(11) DEFAULT NULL COMMENT '门店id',
  `product_id` int(11) DEFAULT NULL COMMENT '产品库商品id',
  `self_product_id` int(11) DEFAULT NULL COMMENT '自营产品库产品id',
  `sale_price` decimal(8,2) DEFAULT NULL COMMENT '门店售卖价格',
  `sales` int(11) DEFAULT '0' COMMENT '销量',
  `is_cut` tinyint(4) DEFAULT '0' COMMENT '0上架 1下架',
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ctc_dealer_store_app_goods`
--

LOCK TABLES `ctc_dealer_store_app_goods` WRITE;
/*!40000 ALTER TABLE `ctc_dealer_store_app_goods` DISABLE KEYS */;
INSERT INTO `ctc_dealer_store_app_goods` VALUES (2,29,1,15,2,26.00,0,1,'2022-12-12 14:10:39'),(3,29,1,19,1,110.00,0,0,'2022-12-12 17:12:39');
/*!40000 ALTER TABLE `ctc_dealer_store_app_goods` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ctc_dealer_store_bill`
--

DROP TABLE IF EXISTS `ctc_dealer_store_bill`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='门店资金记录表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ctc_dealer_store_bill`
--

LOCK TABLES `ctc_dealer_store_bill` WRITE;
/*!40000 ALTER TABLE `ctc_dealer_store_bill` DISABLE KEYS */;
/*!40000 ALTER TABLE `ctc_dealer_store_bill` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ctc_dealer_store_cash_bill`
--

DROP TABLE IF EXISTS `ctc_dealer_store_cash_bill`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ctc_dealer_store_cash_bill`
--

LOCK TABLES `ctc_dealer_store_cash_bill` WRITE;
/*!40000 ALTER TABLE `ctc_dealer_store_cash_bill` DISABLE KEYS */;
/*!40000 ALTER TABLE `ctc_dealer_store_cash_bill` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ctc_dealer_store_cash_rule`
--

DROP TABLE IF EXISTS `ctc_dealer_store_cash_rule`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ctc_dealer_store_cash_rule`
--

LOCK TABLES `ctc_dealer_store_cash_rule` WRITE;
/*!40000 ALTER TABLE `ctc_dealer_store_cash_rule` DISABLE KEYS */;
/*!40000 ALTER TABLE `ctc_dealer_store_cash_rule` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ctc_dealer_store_clerk`
--

DROP TABLE IF EXISTS `ctc_dealer_store_clerk`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ctc_dealer_store_clerk`
--

LOCK TABLES `ctc_dealer_store_clerk` WRITE;
/*!40000 ALTER TABLE `ctc_dealer_store_clerk` DISABLE KEYS */;
/*!40000 ALTER TABLE `ctc_dealer_store_clerk` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ctc_dealer_store_goods_class`
--

DROP TABLE IF EXISTS `ctc_dealer_store_goods_class`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ctc_dealer_store_goods_class` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `class_name` varchar(255) DEFAULT NULL,
  `parent_id` int(11) DEFAULT '0',
  `order` int(11) DEFAULT NULL,
  `dealer_id` int(11) DEFAULT NULL,
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ctc_dealer_store_goods_class`
--

LOCK TABLES `ctc_dealer_store_goods_class` WRITE;
/*!40000 ALTER TABLE `ctc_dealer_store_goods_class` DISABLE KEYS */;
INSERT INTO `ctc_dealer_store_goods_class` VALUES (1,'门店商品分类1',0,1,29,'2022-12-10 14:22:39'),(2,'445',1,2,29,'2022-12-10 14:22:47'),(3,'二级',0,3,29,'2022-12-12 09:49:01'),(4,'333',3,4,29,'2022-12-12 09:49:11');
/*!40000 ALTER TABLE `ctc_dealer_store_goods_class` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ctc_dealer_store_self_goods`
--

DROP TABLE IF EXISTS `ctc_dealer_store_self_goods`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ctc_dealer_store_self_goods` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `dealer_id` int(11) DEFAULT NULL,
  `product_id` int(11) DEFAULT NULL,
  `class_one` int(11) DEFAULT NULL,
  `class_two` int(11) DEFAULT NULL,
  `freight_id` int(11) DEFAULT NULL,
  `price_small` int(11) DEFAULT NULL COMMENT '浮动价格最大值',
  `price_big` int(11) DEFAULT NULL COMMENT '浮动价格最小值',
  `commission_type` tinyint(4) DEFAULT '0' COMMENT '佣金类型0按金额 1按比例',
  `commission_money` int(11) DEFAULT NULL,
  `commission_scale` int(11) DEFAULT NULL,
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `status` tinyint(4) DEFAULT '0' COMMENT '0正常 1移除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ctc_dealer_store_self_goods`
--

LOCK TABLES `ctc_dealer_store_self_goods` WRITE;
/*!40000 ALTER TABLE `ctc_dealer_store_self_goods` DISABLE KEYS */;
INSERT INTO `ctc_dealer_store_self_goods` VALUES (1,29,19,1,2,12,50,120,1,20,30,'2022-12-11 07:01:17',0),(2,29,15,3,4,12,20,30,0,20,NULL,'2022-12-12 14:01:52',0);
/*!40000 ALTER TABLE `ctc_dealer_store_self_goods` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ctc_dealer_store_shop_cart`
--

DROP TABLE IF EXISTS `ctc_dealer_store_shop_cart`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ctc_dealer_store_shop_cart` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `store_id` int(11) DEFAULT NULL COMMENT '门店id',
  `app_goods_id` int(11) DEFAULT NULL COMMENT '商品id 同一用户只会存放一个唯一的商品id 门店上架商品库id',
  `goods_num` int(11) DEFAULT NULL,
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `uid` int(11) DEFAULT NULL,
  `openid` varchar(255) DEFAULT NULL,
  `goods_sku_id` int(11) DEFAULT '0' COMMENT '商品属性id 0代表无属性',
  `update_time` timestamp NULL DEFAULT NULL,
  `is_delete` tinyint(4) DEFAULT '0' COMMENT '是否删除',
  `dealer_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ctc_dealer_store_shop_cart`
--

LOCK TABLES `ctc_dealer_store_shop_cart` WRITE;
/*!40000 ALTER TABLE `ctc_dealer_store_shop_cart` DISABLE KEYS */;
INSERT INTO `ctc_dealer_store_shop_cart` VALUES (4,1,3,2,'2022-12-18 07:57:00',NULL,'1',0,NULL,1,29),(5,1,3,2,'2022-12-18 09:03:33',NULL,'1',0,NULL,0,29);
/*!40000 ALTER TABLE `ctc_dealer_store_shop_cart` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ctc_dealer_store_shop_order`
--

DROP TABLE IF EXISTS `ctc_dealer_store_shop_order`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ctc_dealer_store_shop_order` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '订单ID',
  `openid` varchar(255) DEFAULT NULL,
  `order_id` varchar(32) NOT NULL COMMENT '订单号',
  `store_id` int(11) DEFAULT NULL COMMENT '门店id',
  `dealer_id` int(11) DEFAULT NULL COMMENT '归属',
  `member_id` int(11) unsigned DEFAULT NULL COMMENT '用户id',
  `order_goods_info` text COMMENT '订当商品信息',
  `user_address_id` int(11) DEFAULT NULL COMMENT '地址id',
  `cart_ids` varchar(256) DEFAULT NULL COMMENT '购物车id',
  `total_num` int(11) unsigned DEFAULT '0' COMMENT '订单商品总数',
  `total_points` decimal(8,2) DEFAULT NULL COMMENT '订单总积分',
  `total_price` decimal(8,2) unsigned DEFAULT '0.00' COMMENT '订单总价',
  `total_postage` decimal(8,2) unsigned DEFAULT '0.00' COMMENT '邮费',
  `pay_price` decimal(8,2) unsigned DEFAULT '0.00' COMMENT '实际支付金额',
  `pay_postage` decimal(8,2) unsigned DEFAULT '0.00' COMMENT '支付邮费',
  `deduction_price` decimal(8,2) unsigned DEFAULT '0.00' COMMENT '抵扣金额',
  `coupon_id` int(11) unsigned DEFAULT '0' COMMENT '优惠券id',
  `coupon_price` decimal(8,2) unsigned DEFAULT '0.00' COMMENT '优惠券金额',
  `paid` tinyint(1) unsigned DEFAULT '0' COMMENT '支付状态',
  `pay_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '支付时间',
  `pay_mode` varchar(255) DEFAULT NULL COMMENT '支付模式 直接兑换或者购物车兑换',
  `pay_type` tinyint(10) NOT NULL DEFAULT '0' COMMENT '支付方式 0微信 1支付宝',
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `status` tinyint(1) DEFAULT '0' COMMENT '订单状态（0：待发货；1：待收货；2：已完成；-1：待付款；）',
  `refund_status` tinyint(1) unsigned DEFAULT '0' COMMENT '0 未退款 1 申请中 2 已退款',
  `refund_reason_wap_img` varchar(255) DEFAULT NULL COMMENT '退款图片',
  `refund_reason_wap_explain` varchar(255) DEFAULT NULL COMMENT '退款用户说明',
  `refund_reason_time` int(11) unsigned DEFAULT NULL COMMENT '退款时间',
  `refund_reason_wap` varchar(255) DEFAULT NULL COMMENT '前台退款原因',
  `refund_reason` varchar(255) DEFAULT NULL COMMENT '不退款的理由',
  `refund_price` decimal(8,2) unsigned DEFAULT '0.00' COMMENT '退款金额',
  `delivery_mark` varchar(255) DEFAULT NULL,
  `delivery_name` varchar(64) DEFAULT NULL COMMENT '快递名称/送货人姓名',
  `delivery_type` varchar(32) DEFAULT NULL COMMENT '发货类型',
  `delivery_id` varchar(64) DEFAULT NULL COMMENT '快递单号/手机号',
  `mark` varchar(512) DEFAULT NULL COMMENT '备注',
  `is_del` tinyint(1) unsigned DEFAULT '0' COMMENT '是否删除',
  `unique` char(32) DEFAULT NULL COMMENT '唯一id(md5加密)类似id',
  `remark` varchar(512) DEFAULT NULL COMMENT '管理员备注',
  `mer_id` int(10) unsigned DEFAULT '0' COMMENT '商户ID',
  `is_mer_check` tinyint(3) unsigned DEFAULT '0',
  `cost` decimal(8,2) unsigned DEFAULT NULL COMMENT '成本价',
  `is_channel` tinyint(1) unsigned DEFAULT '0' COMMENT '支付渠道(0微信公众号1微信小程序)',
  `is_system_del` tinyint(1) DEFAULT '0' COMMENT '后台管理员删除',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `unique` (`unique`) USING BTREE,
  UNIQUE KEY `order_id_2` (`order_id`,`member_id`) USING BTREE,
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
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ctc_dealer_store_shop_order`
--

LOCK TABLES `ctc_dealer_store_shop_order` WRITE;
/*!40000 ALTER TABLE `ctc_dealer_store_shop_order` DISABLE KEYS */;
/*!40000 ALTER TABLE `ctc_dealer_store_shop_order` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ctc_dealer_store_type`
--

DROP TABLE IF EXISTS `ctc_dealer_store_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ctc_dealer_store_type` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `class_name` varchar(255) DEFAULT NULL,
  `dealer_id` int(11) DEFAULT NULL,
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `status` tinyint(4) DEFAULT '0' COMMENT '状态0正常 1删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ctc_dealer_store_type`
--

LOCK TABLES `ctc_dealer_store_type` WRITE;
/*!40000 ALTER TABLE `ctc_dealer_store_type` DISABLE KEYS */;
INSERT INTO `ctc_dealer_store_type` VALUES (1,'11',29,'2022-10-01 08:18:53',0);
/*!40000 ALTER TABLE `ctc_dealer_store_type` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ctc_dealer_tax_template`
--

DROP TABLE IF EXISTS `ctc_dealer_tax_template`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ctc_dealer_tax_template` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `dealer_id` int(11) DEFAULT NULL,
  `template_name` varchar(255) DEFAULT NULL,
  `store_id` int(11) DEFAULT NULL,
  `status` varchar(255) DEFAULT '0',
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `delete_time` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ctc_dealer_tax_template`
--

LOCK TABLES `ctc_dealer_tax_template` WRITE;
/*!40000 ALTER TABLE `ctc_dealer_tax_template` DISABLE KEYS */;
/*!40000 ALTER TABLE `ctc_dealer_tax_template` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ctc_dealer_token`
--

DROP TABLE IF EXISTS `ctc_dealer_token`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ctc_dealer_token` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `uid` int(11) DEFAULT NULL,
  `token` varchar(255) DEFAULT NULL,
  `login_ip` varchar(32) DEFAULT NULL,
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP,
  `expires_time` datetime DEFAULT NULL,
  `dealer_id` int(11) DEFAULT NULL COMMENT '代理商id 用来区分角色token',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=594 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ctc_dealer_token`
--

LOCK TABLES `ctc_dealer_token` WRITE;
/*!40000 ALTER TABLE `ctc_dealer_token` DISABLE KEYS */;
INSERT INTO `ctc_dealer_token` VALUES (328,27,'48b2ff6daa0ef0463c8ece0a0b21c6925e922194','182.146.120.59','2022-05-24 11:49:16','2022-05-24 23:49:16',NULL),(346,27,'0591557e3f37537f4c63cd04375299ed51407a8f','182.146.126.144','2022-05-28 08:17:06','2022-05-28 20:17:06',NULL),(358,27,'027a8f24311c85cf21925265ba5e3f5a9625b771','182.146.126.144','2022-06-01 08:58:18','2022-06-01 20:58:18',NULL),(368,27,'707aa0350cb1a40ae5a2020c3a59d22f3cb33b0f','182.146.125.197','2022-06-07 08:39:14','2022-06-07 20:39:14',NULL),(440,26,'d6e1630775f0d194beca8d15c9b587424ff3a005','42.102.183.223','2022-07-08 07:24:16','2022-07-08 19:24:16',NULL),(446,26,'74f10e5f44f5c10d0a509c6369726d32c1f29dff','211.143.51.125','2022-07-11 10:58:14','2022-07-11 22:58:14',NULL),(447,26,'fbb305713cf97c2fd1010398b7c0f84b1c35a632','27.128.62.154','2022-07-11 11:09:32','2022-07-11 23:09:32',NULL),(448,26,'45bd65ea077d62d0756e7c0050083cd055ecfd69','211.143.51.125','2022-07-13 15:42:11','2022-07-14 03:42:11',NULL),(449,26,'0015e8976a7731ef88979dd7e05a12cd17cc6632','27.27.186.2','2022-07-14 16:30:27','2022-07-15 04:30:27',NULL),(461,30,'020cf28ff21ee72a03757248e458b4969b09f5ce','183.199.209.111','2022-07-23 19:52:20','2022-07-24 07:52:20',NULL),(462,30,'68f6c4372d4a3a285a9b37e50ec4de43b68a12d1','121.19.245.235','2022-07-24 15:23:11','2022-07-25 03:23:11',NULL),(463,26,'5200293ae3fa2d9529d59c175d3a15c88fa1f58c','27.27.187.66','2022-07-24 16:15:25','2022-07-25 04:15:25',NULL),(465,30,'21d0c406c8170a79a0483325c53ce7dd90538089','121.19.245.235','2022-07-25 15:01:34','2022-07-26 03:01:34',NULL),(467,30,'1c7fcda506e9fdcb8c6ebe71b93f49b332a1e91a','121.19.245.235','2022-07-25 15:40:03','2022-07-26 03:40:03',NULL),(477,26,'e37253e8fe96cad0f9a2b8f6bf1044409897b023','27.27.188.176','2022-07-27 13:40:39','2022-07-28 01:40:39',NULL),(478,30,'112b41a96541df4bb5c88ddd4f218e815424d271','121.19.245.235','2022-07-30 15:27:39','2022-07-31 03:27:39',NULL),(481,26,'2c4ea529b6c49276f5b334279c459f3bb436b82b','27.27.190.236','2022-08-05 08:40:37','2022-08-05 20:40:37',NULL),(484,26,'ba7f56c5da08102fd1957ecb10c4b71caafa9f4f','27.27.190.216','2022-08-09 11:41:29','2022-08-09 23:41:29',NULL),(485,26,'07cc0ce7c9aa5bd09a4eadb90e186290b7ea0aed','27.27.190.216','2022-08-10 13:40:55','2022-08-11 01:40:55',NULL),(493,31,'8d2fa6976810f7e60b312f5071a633b3799ff412','106.84.255.162','2022-08-11 15:49:39','2022-08-12 03:49:39',NULL),(494,26,'e6b4ba5e7389a4593d738b34405006b6c2c9f493','27.27.190.216','2022-08-12 08:19:05','2022-08-12 20:19:05',NULL),(495,35,'fecca48e7e5b891c6f2bd71921c0f4bbd2e10608','101.24.125.120','2022-08-12 10:13:06','2022-08-12 22:13:06',NULL),(500,26,'be75d026842f3238619c3680937bf0203e77ec57','27.27.188.50','2022-08-19 07:53:00','2022-08-19 19:53:00',NULL),(501,26,'f97442eb349074bd1262ec5ae3b3f2cda7f75361','27.27.188.50','2022-08-19 07:54:11','2022-08-19 19:54:11',NULL),(503,26,'3c2ba8b70156b5ccea5dafedd02c42aacc16a568','27.27.188.50','2022-08-21 17:40:16','2022-08-22 05:40:16',NULL),(508,33,'22682135695d09279a6b2779e2b24bb57db848d7','211.143.51.117','2022-08-24 09:48:23','2022-08-24 21:48:23',NULL),(509,34,'bd8456dce335ff9dc1976edd2c955a9a76c36200','101.24.126.194','2022-08-24 10:07:23','2022-08-24 22:07:23',NULL),(510,26,'60972783c49330ee230f410c93c304a1236c19f8','223.104.122.205','2022-08-24 14:57:13','2022-08-25 02:57:13',NULL),(511,26,'866434cea554bd5c0172de300d39cf5c658c3cca','223.104.122.205','2022-08-24 14:57:58','2022-08-25 02:57:58',NULL),(512,26,'4434dfa4a6e77ac3c1ff5cb955b5af5e27c7502d','183.95.40.68','2022-08-24 14:59:15','2022-08-25 02:59:15',NULL),(517,26,'511767c51de42610356f1e5a1461ce172b7501f4','27.27.190.201','2022-08-30 16:53:40','2022-08-31 04:53:40',NULL),(518,30,'8de3be9e6c80261daff8fc881ccd4e728d169991','183.198.47.34','2022-08-31 11:09:21','2022-08-31 23:09:21',NULL),(519,34,'5005c93f24a880d623c84f2aab66a671d9e95bce','106.117.8.219','2022-09-01 21:16:37','2022-09-02 09:16:37',NULL),(520,26,'0712dd162f3f585abf4b174bb5191ab98bd7d160','27.27.190.201','2022-09-02 14:46:24','2022-09-03 02:46:24',NULL),(521,34,'23713960c8b90d99965dcdc9565b7e9c38df738e','180.167.40.166','2022-09-03 08:49:20','2022-09-03 20:49:20',NULL),(522,26,'82b34363beafa35b8425b02ca29f21a2222fb8c6','27.27.190.201','2022-09-03 09:46:20','2022-09-03 21:46:20',NULL),(591,29,'c455c7c641ae6aced1b035fd145ecbba12130189','124.236.175.87','2023-04-11 13:56:43','2023-04-12 01:56:43',NULL),(592,29,'5a38b9c14ff7e729f45e0676c381afd958b83459','120.211.73.72','2023-04-11 16:25:12','2023-04-12 04:25:12',NULL),(593,29,'10ca60cc605e650466b4027762d72bb3a56a6d22','120.211.73.79','2023-04-13 09:53:44','2023-04-13 21:53:44',NULL);
/*!40000 ALTER TABLE `ctc_dealer_token` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ctc_dealer_trace_code_batch`
--

DROP TABLE IF EXISTS `ctc_dealer_trace_code_batch`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ctc_dealer_trace_code_batch`
--

LOCK TABLES `ctc_dealer_trace_code_batch` WRITE;
/*!40000 ALTER TABLE `ctc_dealer_trace_code_batch` DISABLE KEYS */;
/*!40000 ALTER TABLE `ctc_dealer_trace_code_batch` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ctc_dealer_trace_product_batch`
--

DROP TABLE IF EXISTS `ctc_dealer_trace_product_batch`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ctc_dealer_trace_product_batch`
--

LOCK TABLES `ctc_dealer_trace_product_batch` WRITE;
/*!40000 ALTER TABLE `ctc_dealer_trace_product_batch` DISABLE KEYS */;
/*!40000 ALTER TABLE `ctc_dealer_trace_product_batch` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ctc_dealer_trace_query_detail`
--

DROP TABLE IF EXISTS `ctc_dealer_trace_query_detail`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
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
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ctc_dealer_trace_query_detail`
--

LOCK TABLES `ctc_dealer_trace_query_detail` WRITE;
/*!40000 ALTER TABLE `ctc_dealer_trace_query_detail` DISABLE KEYS */;
/*!40000 ALTER TABLE `ctc_dealer_trace_query_detail` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ctc_dealer_trace_query_log`
--

DROP TABLE IF EXISTS `ctc_dealer_trace_query_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ctc_dealer_trace_query_log`
--

LOCK TABLES `ctc_dealer_trace_query_log` WRITE;
/*!40000 ALTER TABLE `ctc_dealer_trace_query_log` DISABLE KEYS */;
/*!40000 ALTER TABLE `ctc_dealer_trace_query_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ctc_dealer_trace_template`
--

DROP TABLE IF EXISTS `ctc_dealer_trace_template`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
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
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ctc_dealer_trace_template`
--

LOCK TABLES `ctc_dealer_trace_template` WRITE;
/*!40000 ALTER TABLE `ctc_dealer_trace_template` DISABLE KEYS */;
INSERT INTO `ctc_dealer_trace_template` VALUES (15,'溯源','','202207011656655783','溯源档案','1','[{\"url\":\"http:\\/\\/cdn.uni-2id.com\\/03905202205261040268703.jpg\",\"name\":\"03905202205261040268703.jpg\"}]','[{\"img_name\":\"\",\"url\":\"https:\\/\\/cdn.icloudapi.cn\\/sy-default.png\",\"link\":\"\"}]','[{\"title\":\"\\u6eaf\\u6e90\",\"is_show\":1},{\"title\":\"\\u8ba4\\u8bc1\",\"is_show\":1},{\"title\":\"\\u4ea7\\u54c1\",\"is_show\":1},{\"title\":\"\\u4f01\\u4e1a\",\"is_show\":1}]','查询记录','当前溯源码为首次查询，感谢您的查询！','当前溯源码为第@次@次查询，感谢您的查询！','当前溯源码为首次查询，感谢您的查询！','当前溯源码为第@次@次查询，感谢您的查询！',0,1,'溯源信息','防伪认证','您好，您所查询的是@品牌商名称@生产的产品，请放心使用！','该防伪码已经被人查询过，首次查询时间：@查询时间@，谨防假冒！','您好，您所查询的是@品牌商名称@生产的产品，请放心使用！','该防伪码已经被人查询过，首次查询时间：@查询时间@，谨防假冒！',0,'产品信息',1,1,1,1,1,1,1,'企业信息',1,1,1,1,1,1,1,29,1,0,'宣传视频','','2022-07-01 06:09:43',0);
/*!40000 ALTER TABLE `ctc_dealer_trace_template` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ctc_dealer_trademark`
--

DROP TABLE IF EXISTS `ctc_dealer_trademark`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ctc_dealer_trademark`
--

LOCK TABLES `ctc_dealer_trademark` WRITE;
/*!40000 ALTER TABLE `ctc_dealer_trademark` DISABLE KEYS */;
/*!40000 ALTER TABLE `ctc_dealer_trademark` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ctc_dealer_universal_store_cart`
--

DROP TABLE IF EXISTS `ctc_dealer_universal_store_cart`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
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
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ctc_dealer_universal_store_cart`
--

LOCK TABLES `ctc_dealer_universal_store_cart` WRITE;
/*!40000 ALTER TABLE `ctc_dealer_universal_store_cart` DISABLE KEYS */;
/*!40000 ALTER TABLE `ctc_dealer_universal_store_cart` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ctc_dealer_universal_store_order_cart_info`
--

DROP TABLE IF EXISTS `ctc_dealer_universal_store_order_cart_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
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
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ctc_dealer_universal_store_order_cart_info`
--

LOCK TABLES `ctc_dealer_universal_store_order_cart_info` WRITE;
/*!40000 ALTER TABLE `ctc_dealer_universal_store_order_cart_info` DISABLE KEYS */;
/*!40000 ALTER TABLE `ctc_dealer_universal_store_order_cart_info` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ctc_dealer_user`
--

DROP TABLE IF EXISTS `ctc_dealer_user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
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
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ctc_dealer_user`
--

LOCK TABLES `ctc_dealer_user` WRITE;
/*!40000 ALTER TABLE `ctc_dealer_user` DISABLE KEYS */;
INSERT INTO `ctc_dealer_user` VALUES (8,'caiwu','caiwu','e10adc3949ba59abbe56e057f20f883e','财务用',25,'2','2022-07-08 03:02:14','1');
/*!40000 ALTER TABLE `ctc_dealer_user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ctc_dealer_warehouse`
--

DROP TABLE IF EXISTS `ctc_dealer_warehouse`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
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
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ctc_dealer_warehouse`
--

LOCK TABLES `ctc_dealer_warehouse` WRITE;
/*!40000 ALTER TABLE `ctc_dealer_warehouse` DISABLE KEYS */;
INSERT INTO `ctc_dealer_warehouse` VALUES (9,29,'总仓库','中国大陆',1,'0','2022-05-26 03:03:30','0',NULL);
/*!40000 ALTER TABLE `ctc_dealer_warehouse` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ctc_dealer_weixin_config`
--

DROP TABLE IF EXISTS `ctc_dealer_weixin_config`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ctc_dealer_weixin_config` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `oa_appid` varchar(255) DEFAULT NULL COMMENT '公众号appid',
  `oa_secret` varchar(255) DEFAULT NULL COMMENT '公众号secret',
  `mp_appid` varchar(255) DEFAULT NULL COMMENT '小程序appid',
  `mp_secret` varchar(255) DEFAULT NULL COMMENT '小程序secret',
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `dealer_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ctc_dealer_weixin_config`
--

LOCK TABLES `ctc_dealer_weixin_config` WRITE;
/*!40000 ALTER TABLE `ctc_dealer_weixin_config` DISABLE KEYS */;
/*!40000 ALTER TABLE `ctc_dealer_weixin_config` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ctc_dealer_zan`
--

DROP TABLE IF EXISTS `ctc_dealer_zan`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ctc_dealer_zan` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `dealer_id` int(11) DEFAULT NULL,
  `micro_app_title` varchar(255) DEFAULT NULL,
  `grant_id` varchar(255) DEFAULT NULL,
  `client_id` varchar(255) DEFAULT NULL,
  `client_secret` varchar(255) DEFAULT NULL,
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ctc_dealer_zan`
--

LOCK TABLES `ctc_dealer_zan` WRITE;
/*!40000 ALTER TABLE `ctc_dealer_zan` DISABLE KEYS */;
/*!40000 ALTER TABLE `ctc_dealer_zan` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ctc_demand`
--

DROP TABLE IF EXISTS `ctc_demand`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ctc_demand`
--

LOCK TABLES `ctc_demand` WRITE;
/*!40000 ALTER TABLE `ctc_demand` DISABLE KEYS */;
/*!40000 ALTER TABLE `ctc_demand` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ctc_dict_data`
--

DROP TABLE IF EXISTS `ctc_dict_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
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
) ENGINE=InnoDB AUTO_INCREMENT=167 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ctc_dict_data`
--

LOCK TABLES `ctc_dict_data` WRITE;
/*!40000 ALTER TABLE `ctc_dict_data` DISABLE KEYS */;
INSERT INTO `ctc_dict_data` VALUES (1,'323rrewr','1434','1334',1,1,'11','2021-10-06 08:56:26',NULL),(4,'323rrewr','dsd','dw',0,0,'dw','2021-10-06 09:11:07',NULL),(5,'323rrewr','w','w',0,0,'w','2021-10-06 09:14:07',NULL),(6,'sys_user_sex','男','0',0,0,'性别男','2021-10-06 09:29:10',NULL),(7,'sys_user_sex','女','1',0,1,'性别女','2021-10-06 09:30:31',NULL),(8,'sys_user_sex','未知','2',0,2,'性别未知','2021-10-06 09:30:49',NULL),(10,'code_type','普通码','1',0,0,'','2021-10-07 13:19:42',NULL),(11,'code_type','小程序码','2',0,0,'小程序码','2021-10-07 13:19:53',NULL),(12,'code_scene','营销码','1',0,0,'支持二维码营销','2021-10-07 13:31:56',NULL),(13,'code_scene','溯源码','2',0,0,'支持万能溯源（舒适版）,可勾选增加4位的验证码(二维码可采用明码,验证码采用暗码);可同时勾选营销码或导购码进行一码多用','2021-10-07 13:32:15',NULL),(14,'code_scene','导购码','3',0,0,'支持导购员扫码,可同时勾选营销码或溯源码进行一码多用,但同时勾选营销码或溯源码时不可勾选关联导购码,勾选关联导购码需要选择另一批同样数量的批次进行关联','2021-10-07 13:32:31',NULL),(15,'code_scene','物流码','4',0,0,'支持智能物流,只勾选物流码时仅支持物流发货','2021-10-07 13:32:45',NULL),(16,'partner_status','正常','1',0,0,'正常','2021-10-07 16:54:42',NULL),(17,'partner_status','禁用','2',0,0,'禁用','2021-10-07 16:54:53',NULL),(18,'partner_status','已过期','3',0,0,'已过期','2021-10-07 16:55:06',NULL),(19,'partner_industry','建材','1',0,0,'建材','2021-10-07 17:07:52',NULL),(20,'partner_industry','化妆品','2',0,0,'化妆品','2021-10-07 17:08:07',NULL),(21,'partner_industry','酒','3',0,0,'酒','2021-10-07 17:08:22',NULL),(22,'demand_priority','提示P1','1',0,0,'提示P1','2021-10-08 17:38:06',NULL),(23,'demand_priority','一般P2','2',0,0,'一般P2','2021-10-08 17:38:23',NULL),(24,'demand_priority','重要P3','3',0,0,'重要P3','2021-10-08 17:38:39',NULL),(25,'demand_priority','紧急P4','4',0,0,'紧急P4','2021-10-08 17:38:54',NULL),(26,'demand_status','待审核','1',0,0,'待审核','2021-10-08 17:40:21',NULL),(27,'demand_status','待排期','2',0,0,'待排期','2021-10-08 17:40:35',NULL),(28,'demand_status','实现中','3',0,0,'实现中','2021-10-08 17:40:51',NULL),(29,'demand_status','已完成','4',0,0,'已完成','2021-10-08 17:41:03',NULL),(30,'demand_status','审核不通过','5',0,0,'审核不通过','2021-10-08 17:41:19',NULL),(31,'company_type','有限责任公司','1',0,0,'有限责任公司','2021-10-10 13:40:36',NULL),(32,'company_type','股份有限公司','2',0,0,'股份有限公司','2021-10-10 13:40:54',NULL),(33,'company_type','个人独资企业','3',0,0,'个人独资企业','2021-10-10 13:41:11',NULL),(34,'company_type','合伙企业','4',0,0,'合伙企业','2021-10-10 13:41:26',NULL),(35,'recharge_type','账户余额','1',0,0,'账户余额','2021-10-10 22:30:52',NULL),(36,'recharge_type','预存款','2',0,0,'预存款','2021-10-10 22:31:09',NULL),(37,'transaction_type','充值','1',0,0,'充值','2021-10-11 12:02:53',NULL),(38,'transaction_type','开户','2',0,0,'开户','2021-10-11 12:03:05',NULL),(39,'transaction_type','生码','3',0,0,'生码','2021-10-11 12:03:17',NULL),(40,'transaction_type','增值服务','4',0,0,'增值服务','2021-10-11 12:03:34',NULL),(41,'transaction_type','升降','5',0,0,'升降','2021-10-11 12:03:56',NULL),(42,'transaction_type','续费','6',0,0,'续费','2021-10-11 12:04:16',NULL),(43,'transaction_type','申请提现','7',0,0,'申请提现','2021-10-11 12:04:32',NULL),(44,'transaction_type','提现驳回资金返回','8',0,0,'提现驳回资金返回','2021-10-11 12:04:56',NULL),(45,'sys_oper_type','新增','1',0,0,'新增操作','2021-10-17 15:10:48',NULL),(46,'sys_oper_type','修改','2',0,0,'修改操作','2021-10-17 15:11:02',NULL),(47,'sys_oper_type','删除','3',0,0,'删除操作','2021-10-17 15:11:10',NULL),(48,'sys_oper_type','导出','4',0,0,'导出','2021-10-17 15:11:27',NULL),(49,'sys_oper_type','导入','5',0,0,'导入','2021-10-17 15:11:37',NULL),(50,'access_environment','微信公众号','1',0,0,'1、允许用户通过微信APP+公众号授权访问用户端页面\n2、选择此环境，需要授权绑定公众号','2021-10-24 16:16:46',NULL),(51,'access_environment','小程序','2',0,0,'1、允许用户通过微信APP+小程序授权访问用户端页面\n2、选择此环境，需要授权绑定小程序\n3、选择此环境，才能支持小程序扫码页','2021-10-24 16:17:12',NULL),(52,'access_environment','H5','3',0,0,'1、允许用户通过普通的手机浏览器访问用户端页面\n2、同时兼容微信APP内访问用户端页面（不需要绑定公众号授权）\n3、选择此环境，不论用户在哪个环境中操作（扫码领奖、商城下单等），都需要强制验证手机号码','2021-10-24 16:17:31',NULL),(53,'bank_type','中国银行','1',0,1,'中国银行','2021-10-26 20:19:06',NULL),(54,'bank_type','招商银行','2',0,0,'招商银行','2021-10-26 20:19:19',NULL),(55,'bank_type','建设银行','3',0,0,'建设银行','2021-10-26 20:19:33',NULL),(56,'bank_type','农业银行','4',0,0,'农业银行','2021-10-26 20:19:46',NULL),(57,'code_length','8位','8',0,0,'8位','2021-10-26 22:56:47',NULL),(58,'code_length','9位','9',0,0,'','2021-10-26 22:56:55',NULL),(59,'code_length','10位','10',0,0,'','2021-10-26 22:57:02',NULL),(60,'code_length','11位','11',0,0,'','2021-10-26 22:57:09',NULL),(61,'code_length','12位','12',0,0,'','2021-10-26 22:57:23',NULL),(62,'code_length','13位','13',0,0,'','2021-10-26 22:57:34',NULL),(63,'code_length','14位','14',0,0,'','2021-10-26 22:57:43',NULL),(64,'code_length','15位','15',0,0,'','2021-10-26 22:57:53',NULL),(65,'code_length','16位','16',0,0,'','2021-10-26 22:57:59',NULL),(66,'code_length','20位','20',0,0,'','2021-10-27 08:57:03',NULL),(67,'warehouse_type','普通仓','1',0,0,'最多添加一个','2021-11-15 16:39:07',NULL),(68,'warehouse_type','保税仓','2',0,0,'最多添加一个','2021-11-15 16:39:32',NULL),(69,'equ_definition','普通','1',0,0,'普通','2021-11-19 12:47:57',NULL),(70,'equ_definition','高清','2',0,0,'高清','2021-11-19 12:48:15',NULL),(71,'sms_type','信息变更短信','1',0,0,'信息变更短信','2021-11-21 06:07:39',NULL),(72,'sms_type','修改密码短信','2',0,0,'修改密码短信','2021-11-21 06:07:54',NULL),(73,'sms_type','用户注册短信','3',0,0,'用户注册短信','2021-11-21 06:08:29',NULL),(74,'sms_type','登录异常短信','4',0,0,'登录异常短信','2021-11-21 06:08:45',NULL),(75,'sms_type','登录确认短信','5',0,0,'登录确认短信','2021-11-21 06:08:59',NULL),(76,'sms_type','身份验证短信','6',0,0,'身份验证短信','2021-11-21 06:09:29',NULL),(77,'sms_type','导购员审核通过','7',0,0,'导购员审核通过','2021-11-21 06:09:56',NULL),(78,'sms_type','导购员审核不通过','8',0,0,'导购员审核不通过','2021-11-21 06:10:16',NULL),(79,'sms_type','订单待发货','9',0,0,'订单待发货','2021-11-21 06:10:37',NULL),(80,'redpack_type','现金红包','1',0,0,'现金红包','2021-12-07 07:44:29',NULL),(81,'redpack_type','企业零钱红包','2',0,0,'企业零钱红包','2021-12-07 07:44:45',NULL),(82,'redpack_type','代发红包','3',0,0,'代发红包','2021-12-07 07:44:59',NULL),(83,'redpack_monry_type','固定金额','1',0,0,'固定金额','2021-12-07 07:53:45',NULL),(84,'redpack_monry_type','随机金额','2',0,0,'随机金额','2021-12-07 07:53:59',NULL),(85,'redpack_grant_app','直接发放','1',0,0,'直接发放','2021-12-08 09:39:51',NULL),(86,'redpack_grant_app','二维码营销','2',0,0,'二维码营销','2021-12-08 09:40:05',NULL),(87,'redpack_grant_app','超级导购','3',0,0,'超级导购','2021-12-08 09:40:20',NULL),(88,'redpack_grant_app','佣金提现','4',0,0,'佣金提现','2021-12-08 09:40:38',NULL),(89,'redpack_grant_status','发放成功','1',0,0,'发放成功','2021-12-08 09:48:41',NULL),(90,'redpack_grant_status','发放失败','2',0,0,'发放失败','2021-12-08 09:48:54',NULL),(91,'redpack_grant_status','发放中','3',0,0,'发放中','2021-12-08 09:49:05',NULL),(92,'integral_grant_app','直接发放','1',0,0,'直接发放','2021-12-09 04:56:18',NULL),(93,'integral_grant_app','二维码营销','2',0,0,'二维码营销','2021-12-09 04:56:41',NULL),(94,'integral_grant_app','微商城购买商品赠送','3',0,0,'微商城购买商品赠送','2021-12-09 04:57:04',NULL),(95,'integral_grant_app','超级导购','4',0,0,'超级导购','2021-12-09 04:57:23',NULL),(96,'logistics_level','单个包装','1',0,0,'单个包装','2021-12-14 15:06:52',NULL),(97,'logistics_level','二级包装','2',0,0,'二级包装','2021-12-14 15:07:08',NULL),(98,'logistics_level','三级包装','3',0,0,'三级包装','2021-12-14 15:07:22',NULL),(99,'guide_prize_order','不限先后','1',0,0,'不限先后：表示不限定消费者与导购员扫码的先后顺序，导购员可以先扫码登记信息待消费者扫码之后获得奖励，也可以在消费者扫码之后再进行扫码立即获得奖励；','2021-12-16 12:56:12',NULL),(100,'guide_prize_order','导购员先激活','2',0,0,'导购员先激活：表示消费者扫码必须在导购员扫码之后，导购员扫码先登记信息待消费者扫码之后获得奖励；','2021-12-16 12:56:32',NULL),(101,'guide_prize_order','各自领奖','3',0,0,'各自领奖：表示导购员与消费者扫码领奖相互独立，谁都可以直接扫码领奖','2021-12-16 12:56:52',NULL),(102,'guide_prize_order','导购核销','4',1,0,'导购核销：必须消费者先扫码，且消费者扫码后会显示一个核销码，待导购员扫码核销后奖励才会自动同时发放给消费者和导购员；','2021-12-16 12:57:08',NULL),(103,'official_account_status','已关注','1',0,0,'已关注','2021-12-24 15:00:30',NULL),(104,'official_account_status','未关注','2',0,0,'未关注','2021-12-24 15:00:44',NULL),(105,'official_account_status','已跑路','3',0,0,'已跑路','2021-12-24 15:01:03',NULL),(106,'assets_type','红包','1',0,0,'红包','2021-12-27 03:32:36',NULL),(107,'assets_type','代发红包','2',0,0,'代发红包','2021-12-27 03:32:53',NULL),(108,'assets_type','积分','3',0,0,'积分','2021-12-27 03:33:19',NULL),(109,'assets_type','礼品','4',0,0,'礼品','2021-12-27 03:33:27',NULL),(110,'field_type','文本框','1',0,0,'文本框','2021-12-27 09:16:40',NULL),(111,'field_type','单项选择框','2',0,0,'单项选择框','2021-12-27 09:16:56',NULL),(112,'field_type','多项选择框','3',0,0,'多项选择框','2021-12-27 09:18:00',NULL),(113,'field_type','日期选择框','4',0,0,'日期选择框','2021-12-27 09:18:17',NULL),(114,'store_status','正常','1',0,0,'正常','2022-01-02 14:39:14',NULL),(115,'store_status','禁用','2',0,0,'禁用','2022-01-02 14:39:25',NULL),(116,'store_status','删除','3',0,0,'删除','2022-01-02 14:39:34',NULL),(117,'store_balance_flow_type','佣金收益','1',0,0,'佣金收益','2022-01-05 07:18:36',NULL),(118,'store_balance_flow_type','销售收益','2',0,0,'销售收益','2022-01-05 07:18:56',NULL),(119,'store_balance_flow_type','提现到账','3',0,0,'提现到账','2022-01-05 07:19:19',NULL),(120,'store_balance_flow_type','导购扫码收益','4',0,0,'导购扫码收益','2022-01-05 07:19:38',NULL),(121,'store_balance_flow_type','提现失败退款','5',0,0,'提现失败退款','2022-01-05 07:20:05',NULL),(122,'store_commission_cash_status','待审核','1',0,0,'待审核','2022-01-05 13:27:40',NULL),(123,'store_commission_cash_status','提现发放中','2',0,0,'提现发放中','2022-01-05 13:27:57',NULL),(124,'store_commission_cash_status','审核不通过','3',0,0,'审核不通过','2022-01-05 13:28:16',NULL),(125,'store_commission_cash_status','提现成功','4',0,0,'提现成功','2022-01-05 13:28:29',NULL),(126,'store_commission_cash_status','提现失败','5',0,0,'提现失败','2022-01-05 13:28:44',NULL),(127,'store_commission_cash_type','线下转账','1',0,0,'门店通过后台线上申请提现，总部进行审核，审核通过后线下打款到门店申请提现的指定账户','2022-01-05 13:35:35',NULL),(128,'store_commission_cash_type','微信零钱','2',0,0,'门店可通过后台直接把佣金提现到个人的微信零钱红包，钱会从总部绑定的微信支付商户平台中直接扣除，请确保已成功绑定微信支付平台并且余额充足','2022-01-05 13:35:51',NULL),(129,'salesman_status','正常','1',0,0,'正常','2022-01-08 08:16:11',NULL),(130,'salesman_status','禁用','2',0,0,'禁用','2022-01-08 08:16:20',NULL),(131,'salesman_status','删除','3',0,0,'删除','2022-01-08 08:16:30',NULL),(132,'distributor_balance_flow_type','人工增减','1',0,0,'充值','2022-01-08 14:19:44',NULL),(133,'distributor_balance_flow_type','红包发放','2',0,0,'红包发放','2022-01-08 14:19:57',NULL),(135,'scan_type','微信','1',0,0,'微信','2022-01-15 14:58:14',NULL),(136,'scan_type','小程序','2',0,0,'小程序','2022-01-15 14:58:32',NULL),(137,'scan_type','H5/其他','3',0,0,'H5/其他','2022-01-15 14:58:48',NULL),(138,'mall_commission_type','按百分比','1',0,0,'按百分比','2022-03-09 14:14:52',NULL),(139,'mall_commission_type','按金额','2',0,0,'按金额','2022-03-09 14:15:03',NULL),(140,'mall_order_status','申请退款','-1',0,0,'申请退款','2022-03-10 15:27:09',NULL),(141,'mall_order_status','退货成功','-2',0,0,'退货成功','2022-03-10 15:27:24',NULL),(142,'mall_order_status','待发货','0',0,0,'待发货','2022-03-10 15:27:38',NULL),(143,'mall_order_status','待收货','1',0,0,'待收货','2022-03-10 15:27:51',NULL),(144,'mall_order_status','已收货','2',0,0,'已收货','2022-03-10 15:28:11',NULL),(145,'mall_order_status','待评价','3',0,0,'待评价','2022-03-10 15:28:23',NULL),(146,'mall_order_status','已退款','-3',0,0,'已退款','2022-03-10 15:28:49',NULL),(147,'mall_fenxiao_cash_status','待审核','1',0,0,'待审核','2022-03-10 16:55:53',NULL),(148,'mall_fenxiao_cash_status','审核通过','2',0,0,'审核通过','2022-03-10 16:56:06',NULL),(149,'mall_fenxiao_cash_status','审核拒绝','3',0,0,'审核拒绝','2022-03-10 16:56:16',NULL),(150,'service_type_info','订阅号','0',0,0,'订阅号','2022-03-15 10:15:37',NULL),(151,'service_type_info','服务号','2',0,0,'服务号','2022-03-15 10:15:50',NULL),(152,'service_type_info','由历史老帐号升级后的订阅号','1',0,0,'由历史老帐号升级后的订阅号','2022-03-15 10:16:04',NULL),(153,'verify_type_info','未认证','-1',0,0,'未认证','2022-03-15 10:16:52',NULL),(154,'verify_type_info','微信认证','0',0,0,'微信认证','2022-03-15 10:17:06',NULL),(155,'verify_type_info','新浪微博认证','1',0,0,'新浪微博认证','2022-03-15 10:17:16',NULL),(156,'verify_type_info','腾讯微博认证','2',0,0,'腾讯微博认证','2022-03-15 10:17:25',NULL),(157,'verify_type_info','已资质认证通过但还未通过名称认证','3',0,0,'已资质认证通过但还未通过名称认证','2022-03-15 10:17:36',NULL),(158,'verify_type_info','已资质认证通过、还未通过名称认证，但通过了新浪微博认证','4',0,0,'已资质认证通过、还未通过名称认证，但通过了新浪微博认证','2022-03-15 10:17:47',NULL),(159,'verify_type_info','已资质认证通过、还未通过名称认证，但通过了腾讯微博认证','5',0,0,'已资质认证通过、还未通过名称认证，但通过了腾讯微博认证','2022-03-15 10:18:02',NULL),(160,'logistics_company','顺丰快递','1',0,0,'顺丰快递','2022-08-28 18:26:48',NULL),(161,'logistics_company','圆通快递','2',0,0,'圆通快递','2022-08-28 18:27:01',NULL),(162,'field_type','图片','5',0,0,'单张图片','2022-09-16 12:23:19',NULL),(163,'operation_center','广安运营中心','1',0,0,'广安运营中心','2023-01-02 16:14:45',NULL),(164,'operation_center','岳池运营中心','2',0,0,'岳池运营中心','2023-01-02 16:14:55',NULL),(165,'work_type','水电工','1',0,0,'水电工','2023-01-02 18:01:29',NULL),(166,'work_type','泥瓦工','2',0,0,'泥瓦工','2023-01-02 18:01:37',NULL);
/*!40000 ALTER TABLE `ctc_dict_data` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ctc_dict_type`
--

DROP TABLE IF EXISTS `ctc_dict_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ctc_dict_type` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `dict_name` varchar(255) DEFAULT NULL,
  `dict_type` varchar(255) DEFAULT NULL,
  `create_by` varchar(255) DEFAULT NULL,
  `status` tinyint(4) DEFAULT '0' COMMENT '字段状态 0 正常 1禁用',
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `remark` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=49 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ctc_dict_type`
--

LOCK TABLES `ctc_dict_type` WRITE;
/*!40000 ALTER TABLE `ctc_dict_type` DISABLE KEYS */;
INSERT INTO `ctc_dict_type` VALUES (4,'用户性别','sys_user_sex',NULL,0,'2021-10-06 07:27:14','用户性别'),(7,'码类型','code_type',NULL,0,'2021-10-07 13:18:49','生码类型'),(8,'应用场景','code_scene',NULL,0,'2021-10-07 13:31:40','码应用场景'),(9,'合伙人/品牌商状态','partner_status',NULL,0,'2021-10-07 16:54:23','合伙人与品牌商状态'),(10,'合伙人行业','partner_industry',NULL,0,'2021-10-07 17:07:37','合伙人所属行业'),(11,'需求优先级','demand_priority',NULL,0,'2021-10-08 17:37:41','需求优先级'),(12,'需求状态','demand_status',NULL,0,'2021-10-08 17:39:57','需求状态'),(13,'公司类型','company_type',NULL,0,'2021-10-10 13:40:14','公司类型'),(14,'账户类型','recharge_type',NULL,0,'2021-10-10 22:30:35','合伙人充值类型'),(15,'交易类型','transaction_type',NULL,0,'2021-10-11 12:02:24','交易类型'),(16,'操作类型','sys_oper_type',NULL,0,'2021-10-17 15:10:07','操作类型'),(17,'访问环境','access_environment',NULL,0,'2021-10-24 16:15:45','访问环境'),(18,'开户银行','bank_type',NULL,0,'2021-10-26 20:18:43','提现开户银行'),(19,'生码位数','code_length',NULL,0,'2021-10-26 22:56:24','数码长度8~20位'),(20,'仓库类型','warehouse_type',NULL,0,'2021-11-15 16:37:49','仓库类型'),(21,'直播设备清晰度','equ_definition',NULL,0,'2021-11-19 12:47:36','直播设备清晰度'),(22,'短信类型','sms_type',NULL,0,'2021-11-21 06:07:09','短信类型'),(23,'红包类型','redpack_type',NULL,0,'2021-12-07 07:44:01','红包类型'),(24,'红包金额类型','redpack_monry_type',NULL,0,'2021-12-07 07:51:16','红包金额类型'),(25,'红包发放应用','redpack_grant_app',NULL,0,'2021-12-08 09:37:56','红包发放应用'),(26,'红包发放状态','redpack_grant_status',NULL,0,'2021-12-08 09:48:13','红包发放状态'),(27,'积分发放应用','integral_grant_app',NULL,0,'2021-12-09 04:55:53','积分发放应用'),(28,'物流码关联层级','logistics_level',NULL,0,'2021-12-14 15:06:24','物流码大小标关系层级'),(29,'导购码领奖顺序','guide_prize_order',NULL,0,'2021-12-16 12:55:47','导购码领奖顺序'),(30,'微信公众号关注状态','official_account_status',NULL,0,'2021-12-24 15:00:15','微信公众号状态'),(31,'资产类型','assets_type',NULL,0,'2021-12-27 03:30:21','资产类型'),(32,'字段类型','field_type',NULL,0,'2021-12-27 09:14:53','自定义字段类型'),(33,'门店状态','store_status',NULL,0,'2022-01-02 14:38:59','门店状态'),(34,'门店资金流动类型','store_balance_flow_type',NULL,0,'2022-01-05 07:18:14','门店资金流动类型'),(35,'门店佣金提现状态','store_commission_cash_status',NULL,0,'2022-01-05 13:27:15','门店佣金提现状态'),(36,'门店佣金提现方式','store_commission_cash_type',NULL,0,'2022-01-05 13:35:12','门店佣金提现方式'),(38,'业务员状态','salesman_status',NULL,0,'2022-01-08 08:15:59','业务员状态'),(39,'经销商资金流动类型','distributor_balance_flow_type',NULL,0,'2022-01-08 14:19:23','经销商资金流动类型'),(40,'扫码方式','scan_type',NULL,0,'2022-01-15 14:57:49','扫码方式'),(41,'商城佣金计算方式','mall_commission_type',NULL,0,'2022-03-09 14:14:35','商城佣金计算方式'),(42,'商城订单状态','mall_order_status',NULL,0,'2022-03-10 15:26:26','商城订单状态'),(43,'分销提现状态','mall_fenxiao_cash_status',NULL,0,'2022-03-10 16:55:35','分销提现状态'),(44,'公众号类型','service_type_info',NULL,0,'2022-03-15 10:15:07','公众号类型'),(45,'公众号认证类型','verify_type_info',NULL,0,'2022-03-15 10:16:33','公众号认证类型'),(46,'物流公司','logistics_company',NULL,0,'2022-08-28 18:26:31','物流公司'),(47,'广安运营中心分类','operation_center',NULL,0,'2023-01-02 16:14:25','广安运营中心分类'),(48,'工种','work_type',NULL,0,'2023-01-02 18:01:10','工种');
/*!40000 ALTER TABLE `ctc_dict_type` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ctc_finance_bill`
--

DROP TABLE IF EXISTS `ctc_finance_bill`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
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
) ENGINE=InnoDB AUTO_INCREMENT=285 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ctc_finance_bill`
--

LOCK TABLES `ctc_finance_bill` WRITE;
/*!40000 ALTER TABLE `ctc_finance_bill` DISABLE KEYS */;
INSERT INTO `ctc_finance_bill` VALUES (108,'202204081649402927','2022-04-08 15:28:47','1','合伙人预存款充值',1,'2','10000',0,'10000',9),(109,'202204081649403133','2022-04-08 15:32:13','2','品牌商开户',1,'2','2160',1,'7840',5),(110,'202204081649403578','2022-04-08 15:39:38','2','品牌商开户',1,'2','2080',1,'80',5),(111,'202204131649821313','2022-04-13 11:41:53','1','合伙人余额充值',1,'1','10010',0,'10',9),(112,'202204131649821321','2022-04-13 11:42:01','1','合伙人预存款充值',1,'2','10200',0,'200',9),(113,'202204281651128383','2022-04-28 14:46:23','3','品牌商生码',1,'1','10010',1,'0',9),(114,'202204281651128383','2022-04-28 14:46:23','3','品牌商生码',2,'1','10010',1,'0',25),(115,'202204291651217420','2022-04-29 15:30:20','2','品牌商开户',1,'2','10112',1,'88',9),(116,'202205091652063577','2022-05-09 10:32:57','3','品牌商生码',1,'1','10010',1,'0',9),(117,'202205091652063577','2022-05-09 10:32:57','3','品牌商生码',2,'1','10010',1,'0',26),(118,'202205101652151901','2022-05-10 11:05:01','2','品牌商开户',1,'2','10024',1,'88',9),(119,'202205101652167075','2022-05-10 15:17:55','5','品牌商模块升降服务',1,'2','10024',1,'0',9),(120,'202205101652167075','2022-05-10 15:17:55','5','品牌商模块升降服务',2,'2','10024',1,'100',26),(121,'202205101652167080','2022-05-10 15:18:00','5','品牌商模块升降服务',1,'2','10024',1,'0',9),(122,'202205101652167080','2022-05-10 15:18:00','5','品牌商模块升降服务',2,'2','10024',1,'100',27),(123,'202205101652167100','2022-05-10 15:18:20','3','品牌商生码',1,'1','10010',1,'0',9),(124,'202205101652167100','2022-05-10 15:18:20','3','品牌商生码',2,'1','10010',1,'0',27),(125,'202205201653012696','2022-05-20 10:11:36','2','品牌商开户',1,'2','9944',1,'80',9),(126,'202205201653017784','2022-05-20 11:36:24','2','品牌商开户',1,'2','8736',1,'1208',9),(127,'202205201653025374','2022-05-20 13:42:54','3','品牌商生码',1,'1','10010',1,'0',9),(128,'202205201653025374','2022-05-20 13:42:54','3','品牌商生码',2,'1','10010',1,'0',29),(129,'202205201653028408','2022-05-20 14:33:28','2','品牌商开户',1,'2','8648',1,'88',9),(130,'202205201653028675','2022-05-20 14:37:55','3','品牌商生码',1,'1','10010',1,'0',9),(131,'202205201653028675','2022-05-20 14:37:55','3','品牌商生码',2,'1','10010',1,'0',30),(132,'202205241653355701','2022-05-24 09:28:21','3','品牌商生码',1,'1','10009.17',1,'0.83',9),(133,'202205241653355701','2022-05-24 09:28:21','3','品牌商生码',2,'1','10009.17',1,'0.83',28),(134,'202205241653355776','2022-05-24 09:29:36','3','品牌商生码',1,'1','10007.91',1,'1.26',9),(135,'202205241653355776','2022-05-24 09:29:36','3','品牌商生码',2,'1','10007.91',1,'1.26',28),(136,'202205241653355856','2022-05-24 09:30:56','3','品牌商生码',1,'1','10006.99',1,'0.92',9),(137,'202205241653355856','2022-05-24 09:30:56','3','品牌商生码',2,'1','10006.99',1,'0.92',28),(138,'202205241653356121','2022-05-24 09:35:21','3','品牌商生码',1,'1','10006.38',1,'0.61',9),(139,'202205241653356121','2022-05-24 09:35:21','3','品牌商生码',2,'1','10006.38',1,'0.61',28),(140,'202205241653356260','2022-05-24 09:37:40','3','品牌商生码',1,'1','10004.9',1,'1.48',9),(141,'202205241653356260','2022-05-24 09:37:40','3','品牌商生码',2,'1','10004.9',1,'1.48',28),(142,'202205241653356552','2022-05-24 09:42:32','3','品牌商生码',1,'1','10004.47',1,'0.43',9),(143,'202205241653356552','2022-05-24 09:42:32','3','品牌商生码',2,'1','10004.47',1,'0.43',28),(144,'202205241653356614','2022-05-24 09:43:34','3','品牌商生码',1,'1','10004.22',1,'0.25',9),(145,'202205241653356614','2022-05-24 09:43:34','3','品牌商生码',2,'1','10004.22',1,'0.25',28),(146,'202205241653356679','2022-05-24 09:44:39','3','品牌商生码',1,'1','10003.81',1,'0.41',9),(147,'202205241653356679','2022-05-24 09:44:39','3','品牌商生码',2,'1','10003.81',1,'0.41',28),(148,'202205241653356757','2022-05-24 09:45:57','3','品牌商生码',1,'1','10002.039999999999',1,'1.77',9),(149,'202205241653356757','2022-05-24 09:45:57','3','品牌商生码',2,'1','10002.039999999999',1,'1.77',28),(150,'202205241653356870','2022-05-24 09:47:50','3','品牌商生码',1,'1','10001.779999999999',1,'0.26',9),(151,'202205241653356870','2022-05-24 09:47:50','3','品牌商生码',2,'1','10001.779999999999',1,'0.26',28),(152,'202205241653356971','2022-05-24 09:49:31','3','品牌商生码',1,'1','10001.019999999999',1,'0.76',9),(153,'202205241653356971','2022-05-24 09:49:31','3','品牌商生码',2,'1','10001.019999999999',1,'0.76',28),(154,'202205261653533222','2022-05-26 10:47:02','3','品牌商生码',1,'1','10000.999999999998',1,'0.02',9),(155,'202205261653533222','2022-05-26 10:47:02','3','品牌商生码',2,'1','10000.999999999998',1,'0.02',29),(156,'202205311653978193','2022-05-31 14:23:13','3','品牌商生码',1,'1','10000.159999999998',1,'0.84',9),(157,'202205311653978193','2022-05-31 14:23:13','3','品牌商生码',2,'1','10000.159999999998',1,'0.84',28),(158,'202205311653979804','2022-05-31 14:50:04','3','品牌商生码',1,'1','9999.949999999999',1,'0.21',9),(159,'202205311653979804','2022-05-31 14:50:04','3','品牌商生码',2,'1','9999.949999999999',1,'0.21',28),(160,'202205311653981877','2022-05-31 15:24:37','3','品牌商生码',1,'1','9999.789999999999',1,'0.16',9),(161,'202205311653981877','2022-05-31 15:24:37','3','品牌商生码',2,'1','9999.789999999999',1,'0.16',28),(162,'202205311653985444','2022-05-31 16:24:04','3','品牌商生码',1,'1','9999.539999999999',1,'0.25',9),(163,'202205311653985444','2022-05-31 16:24:04','3','品牌商生码',2,'1','9999.539999999999',1,'0.25',28),(164,'202206011654069774','2022-06-01 15:49:34','3','品牌商生码',1,'1','9999.48',1,'0.06',9),(165,'202206011654069774','2022-06-01 15:49:34','3','品牌商生码',2,'1','9999.48',1,'0.06',28),(166,'202206011654069823','2022-06-01 15:50:23','3','品牌商生码',1,'1','9999.369999999999',1,'0.11',9),(167,'202206011654069823','2022-06-01 15:50:23','3','品牌商生码',2,'1','9999.369999999999',1,'0.11',28),(168,'202206011654072133','2022-06-01 16:28:53','3','品牌商生码',1,'1','9999.259999999998',1,'0.11',9),(169,'202206011654072133','2022-06-01 16:28:53','3','品牌商生码',2,'1','9999.259999999998',1,'0.11',28),(170,'202206021654148215','2022-06-02 13:36:55','3','品牌商生码',1,'1','9998.889999999998',1,'0.37',9),(171,'202206021654148215','2022-06-02 13:36:55','3','品牌商生码',2,'1','9998.889999999998',1,'0.37',28),(172,'202206021654152812','2022-06-02 14:53:32','3','品牌商生码',1,'1','9998.639999999998',1,'0.25',9),(173,'202206021654152812','2022-06-02 14:53:32','3','品牌商生码',2,'1','9998.639999999998',1,'0.25',28),(174,'202206061654503195','2022-06-06 16:13:15','3','品牌商生码',1,'1','9998.509999999998',1,'0.13',9),(175,'202206061654503195','2022-06-06 16:13:15','3','品牌商生码',2,'1','9998.509999999998',1,'0.13',28),(176,'202206081654657497','2022-06-08 11:04:57','3','品牌商生码',1,'1','9998.389999999998',1,'0.12',9),(177,'202206081654657497','2022-06-08 11:04:57','3','品牌商生码',2,'1','9998.389999999998',1,'0.12',28),(178,'202206131655082986','2022-06-13 09:16:26','2','品牌商开户',1,'2','8559.2',1,'88.8',9),(179,'202206161655370089','2022-06-16 17:01:29','2','品牌商开户',1,'2','8479.2',1,'80',9),(180,'202206161655370349','2022-06-16 17:05:49','3','品牌商生码',1,'1','9996.959999999997',1,'1.43',9),(181,'202206161655370349','2022-06-16 17:05:49','3','品牌商生码',2,'1','9996.959999999997',1,'1.43',32),(182,'202206201655687935','2022-06-20 09:18:55','3','品牌商生码',1,'1','9995.859999999997',1,'1.10',9),(183,'202206201655687935','2022-06-20 09:18:55','3','品牌商生码',2,'1','9995.859999999997',1,'1.10',31),(184,'202206271656292355','2022-06-27 09:12:35','3','品牌商生码',1,'1','9995.649999999998',1,'0.21',9),(185,'202206271656292355','2022-06-27 09:12:35','3','品牌商生码',2,'1','9995.649999999998',1,'0.21',29),(186,'202206271656298586','2022-06-27 10:56:26','2','品牌商开户',1,'2','8399.2',1,'80',9),(187,'202206281656379606','2022-06-28 09:26:46','3','品牌商生码',1,'1','9991.009999999998',1,'4.64',9),(188,'202206281656379606','2022-06-28 09:26:46','3','品牌商生码',2,'1','9991.009999999998',1,'4.64',33),(189,'202206281656380937','2022-06-28 09:48:57','3','品牌商生码',1,'1','9989.569999999998',1,'1.44',9),(190,'202206281656380937','2022-06-28 09:48:57','3','品牌商生码',2,'1','9989.569999999998',1,'1.44',33),(191,'202206281656381064','2022-06-28 09:51:04','3','品牌商生码',1,'1','9988.659999999998',1,'0.91',9),(192,'202206281656381064','2022-06-28 09:51:04','3','品牌商生码',2,'1','9988.659999999998',1,'0.91',33),(193,'202206281656382162','2022-06-28 10:09:22','3','品牌商生码',1,'1','9987.629999999997',1,'1.03',9),(194,'202206281656382162','2022-06-28 10:09:22','3','品牌商生码',2,'1','9987.629999999997',1,'1.03',33),(195,'202206281656382301','2022-06-28 10:11:41','3','品牌商生码',1,'1','9985.859999999997',1,'1.77',9),(196,'202206281656382301','2022-06-28 10:11:41','3','品牌商生码',2,'1','9985.859999999997',1,'1.77',33),(197,'202206281656382733','2022-06-28 10:18:53','3','品牌商生码',1,'1','9980.339999999997',1,'5.52',9),(198,'202206281656382733','2022-06-28 10:18:53','3','品牌商生码',2,'1','9980.339999999997',1,'5.52',33),(199,'202206281656383071','2022-06-28 10:24:31','3','品牌商生码',1,'1','9980.009999999997',1,'0.33',9),(200,'202206281656383071','2022-06-28 10:24:31','3','品牌商生码',2,'1','9980.009999999997',1,'0.33',33),(201,'202206281656383262','2022-06-28 10:27:42','3','品牌商生码',1,'1','9979.679999999997',1,'0.33',9),(202,'202206281656383262','2022-06-28 10:27:42','3','品牌商生码',2,'1','9979.679999999997',1,'0.33',33),(203,'202206281656396953','2022-06-28 14:15:53','3','品牌商生码',1,'1','9973.619999999997',1,'6.06',9),(204,'202206281656396953','2022-06-28 14:15:53','3','品牌商生码',2,'1','9973.619999999997',1,'6.06',33),(205,'202206291656485654','2022-06-29 14:54:14','3','品牌商生码',1,'1','9971.849999999997',1,'1.77',9),(206,'202206291656485654','2022-06-29 14:54:14','3','品牌商生码',2,'1','9971.849999999997',1,'1.77',33),(207,'202206291656485825','2022-06-29 14:57:05','3','品牌商生码',1,'1','9970.929999999997',1,'0.92',9),(208,'202206291656485825','2022-06-29 14:57:05','3','品牌商生码',2,'1','9970.929999999997',1,'0.92',33),(209,'202206291656485955','2022-06-29 14:59:15','3','品牌商生码',1,'1','9969.869999999997',1,'1.06',9),(210,'202206291656485955','2022-06-29 14:59:15','3','品牌商生码',2,'1','9969.869999999997',1,'1.06',33),(211,'202206291656486480','2022-06-29 15:08:00','3','品牌商生码',1,'1','9968.999999999996',1,'0.87',9),(212,'202206291656486480','2022-06-29 15:08:00','3','品牌商生码',2,'1','9968.999999999996',1,'0.87',33),(213,'202206291656486733','2022-06-29 15:12:13','3','品牌商生码',1,'1','9967.409999999996',1,'1.59',9),(214,'202206291656486733','2022-06-29 15:12:13','3','品牌商生码',2,'1','9967.409999999996',1,'1.59',33),(215,'202206291656486844','2022-06-29 15:14:04','3','品牌商生码',1,'1','9965.909999999996',1,'1.50',9),(216,'202206291656486844','2022-06-29 15:14:04','3','品牌商生码',2,'1','9965.909999999996',1,'1.50',33),(217,'202206291656486969','2022-06-29 15:16:09','3','品牌商生码',1,'1','9964.229999999996',1,'1.68',9),(218,'202206291656486969','2022-06-29 15:16:09','3','品牌商生码',2,'1','9964.229999999996',1,'1.68',33),(219,'202207041656896696','2022-07-04 09:04:56','3','品牌商生码',1,'1','9960.699999999995',1,'3.53',9),(220,'202207041656896696','2022-07-04 09:04:56','3','品牌商生码',2,'1','9960.699999999995',1,'3.53',33),(221,'202207041656896785','2022-07-04 09:06:25','3','品牌商生码',1,'1','9959.949999999995',1,'0.75',9),(222,'202207041656896785','2022-07-04 09:06:25','3','品牌商生码',2,'1','9959.949999999995',1,'0.75',33),(223,'202207041656916295','2022-07-04 14:31:35','3','品牌商生码',1,'1','9959.349999999995',1,'0.60',9),(224,'202207041656916295','2022-07-04 14:31:35','3','品牌商生码',2,'1','9959.349999999995',1,'0.60',33),(225,'202207081657246368','2022-07-08 10:12:48','3','品牌商生码',1,'1','9957.329999999994',1,'2.02',9),(226,'202207081657246368','2022-07-08 10:12:48','3','品牌商生码',2,'1','9957.329999999994',1,'2.02',33),(227,'202208081659930177','2022-08-08 11:42:57','2','品牌商开户',1,'2','8319.2',1,'80',9),(228,'202208081659939692','2022-08-08 14:21:32','3','品牌商生码',1,'1','9957.149999999994',1,'0.18',9),(229,'202208081659939692','2022-08-08 14:21:32','3','品牌商生码',2,'1','9957.149999999994',1,'0.18',34),(230,'202208091660010300','2022-08-09 09:58:20','3','品牌商生码',1,'1','9954.619999999994',1,'2.53',9),(231,'202208091660010300','2022-08-09 09:58:20','3','品牌商生码',2,'1','9954.619999999994',1,'2.53',34),(232,'202208091660010435','2022-08-09 10:00:35','3','品牌商生码',1,'1','9953.879999999994',1,'0.74',9),(233,'202208091660010435','2022-08-09 10:00:35','3','品牌商生码',2,'1','9953.879999999994',1,'0.74',34),(234,'202208091660010539','2022-08-09 10:02:19','3','品牌商生码',1,'1','9952.619999999994',1,'1.26',9),(235,'202208091660010539','2022-08-09 10:02:19','3','品牌商生码',2,'1','9952.619999999994',1,'1.26',34),(236,'202208091660012027','2022-08-09 10:27:07','3','品牌商生码',1,'1','9949.309999999994',1,'3.31',9),(237,'202208091660012027','2022-08-09 10:27:07','3','品牌商生码',2,'1','9949.309999999994',1,'3.31',34),(238,'202208091660012302','2022-08-09 10:31:42','3','品牌商生码',1,'1','9946.789999999994',1,'2.52',9),(239,'202208091660012302','2022-08-09 10:31:42','3','品牌商生码',2,'1','9946.789999999994',1,'2.52',34),(240,'202208091660012601','2022-08-09 10:36:41','3','品牌商生码',1,'1','9945.909999999994',1,'0.88',9),(241,'202208091660012601','2022-08-09 10:36:41','3','品牌商生码',2,'1','9945.909999999994',1,'0.88',34),(242,'202208091660013381','2022-08-09 10:49:41','3','品牌商生码',1,'1','9942.119999999994',1,'3.79',9),(243,'202208091660013381','2022-08-09 10:49:41','3','品牌商生码',2,'1','9942.119999999994',1,'3.79',34),(244,'202208091660013585','2022-08-09 10:53:05','3','品牌商生码',1,'1','9941.819999999994',1,'0.30',9),(245,'202208091660013585','2022-08-09 10:53:05','3','品牌商生码',2,'1','9941.819999999994',1,'0.30',34),(246,'202208121660270279','2022-08-12 10:11:19','2','品牌商开户',1,'2','8239.2',1,'80',9),(247,'202208121660272028','2022-08-12 10:40:28','3','品牌商生码',1,'1','9938.809999999994',1,'3.01',9),(248,'202208121660272028','2022-08-12 10:40:28','3','品牌商生码',2,'1','9938.809999999994',1,'3.01',35),(249,'202208121660272179','2022-08-12 10:42:59','3','品牌商生码',1,'1','9937.299999999994',1,'1.51',9),(250,'202208121660272179','2022-08-12 10:42:59','3','品牌商生码',2,'1','9937.299999999994',1,'1.51',35),(251,'202208121660272710','2022-08-12 10:51:50','3','品牌商生码',1,'1','9936.699999999993',1,'0.60',9),(252,'202208121660272710','2022-08-12 10:51:50','3','品牌商生码',2,'1','9936.699999999993',1,'0.60',35),(253,'202208121660272860','2022-08-12 10:54:20','3','品牌商生码',1,'1','9935.419999999993',1,'1.28',9),(254,'202208121660272860','2022-08-12 10:54:20','3','品牌商生码',2,'1','9935.419999999993',1,'1.28',35),(255,'202208121660273336','2022-08-12 11:02:16','3','品牌商生码',1,'1','9935.039999999994',1,'0.38',9),(256,'202208121660273336','2022-08-12 11:02:16','3','品牌商生码',2,'1','9935.039999999994',1,'0.38',35),(257,'202208221661139486','2022-08-22 11:38:06','3','品牌商生码',1,'1','9934.979999999994',1,'0.06',9),(258,'202208221661139486','2022-08-22 11:38:06','3','品牌商生码',2,'1','9934.979999999994',1,'0.06',26),(259,'202211151668517493','2022-11-15 21:04:53','3','品牌商生码',1,'1','9934.979999999994',1,'0.00',9),(260,'202211151668517493','2022-11-15 21:04:53','3','品牌商生码',2,'1','9934.979999999994',1,'0.00',29),(261,'202211161668579986','2022-11-16 14:26:26','3','品牌商生码',1,'1','9934.979999999994',1,'0.00',9),(262,'202211161668579986','2022-11-16 14:26:26','3','品牌商生码',2,'1','9934.979999999994',1,'0.00',29),(263,'202211171668673690','2022-11-17 16:28:10','3','品牌商生码',1,'1','9934.979999999994',1,'0.00',9),(264,'202211171668673690','2022-11-17 16:28:10','3','品牌商生码',2,'1','9934.979999999994',1,'0.00',29),(265,'202211171668677903','2022-11-17 17:38:23','3','品牌商生码',1,'1','9934.979999999994',1,'0.00',9),(266,'202211171668677903','2022-11-17 17:38:23','3','品牌商生码',2,'1','9934.979999999994',1,'0.00',29),(267,'202211171668683087','2022-11-17 19:04:47','3','品牌商生码',1,'1','9934.979999999994',1,'0.00',9),(268,'202211171668683087','2022-11-17 19:04:47','3','品牌商生码',2,'1','9934.979999999994',1,'0.00',29),(269,'202212271672127130','2022-12-27 15:45:30','5','品牌商模块升降服务',1,'2','8239.2',1,'0',9),(270,'202212271672127130','2022-12-27 15:45:30','5','品牌商模块升降服务',2,'2','8239.2',1,'0',29),(271,'202212311672484524','2022-12-31 19:02:04','3','品牌商生码',1,'1','9934.979999999994',1,'0.00',9),(272,'202212311672484524','2022-12-31 19:02:04','3','品牌商生码',2,'1','9934.979999999994',1,'0.00',29),(273,'202301151673752958','2023-01-15 11:22:38','3','品牌商生码',1,'1','9932.779999999993',1,'2.20',9),(274,'202301151673752958','2023-01-15 11:22:38','3','品牌商生码',2,'1','9932.779999999993',1,'2.20',29),(275,'202302091675956145','2023-02-09 23:22:25','3','品牌商生码',1,'1','9930.579999999993',1,'2.20',9),(276,'202302091675956145','2023-02-09 23:22:25','3','品牌商生码',2,'1','9930.579999999993',1,'2.20',29),(277,'202302091675956640','2023-02-09 23:30:40','3','品牌商生码',1,'1','9928.379999999992',1,'2.20',9),(278,'202302091675956640','2023-02-09 23:30:40','3','品牌商生码',2,'1','9928.379999999992',1,'2.20',29),(279,'202302121676210479','2023-02-12 22:01:19','3','品牌商生码',1,'1','9926.179999999991',1,'2.20',9),(280,'202302121676210479','2023-02-12 22:01:19','3','品牌商生码',2,'1','9926.179999999991',1,'2.20',29),(281,'202302121676210879','2023-02-12 22:07:59','3','品牌商生码',1,'1','9923.97999999999',1,'2.20',9),(282,'202302121676210879','2023-02-12 22:07:59','3','品牌商生码',2,'1','9923.97999999999',1,'2.20',29),(283,'202302231677085359','2023-02-23 01:02:39','3','品牌商生码',1,'1','9921.77999999999',1,'2.20',9),(284,'202302231677085359','2023-02-23 01:02:39','3','品牌商生码',2,'1','9921.77999999999',1,'2.20',29);
/*!40000 ALTER TABLE `ctc_finance_bill` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ctc_increment_service`
--

DROP TABLE IF EXISTS `ctc_increment_service`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
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
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ctc_increment_service`
--

LOCK TABLES `ctc_increment_service` WRITE;
/*!40000 ALTER TABLE `ctc_increment_service` DISABLE KEYS */;
INSERT INTO `ctc_increment_service` VALUES (1,'客户化部署','100','101','2021-10-10 17:48:37',NULL,0),(2,'客户托管服务','200','304','2021-10-10 17:48:47',NULL,0),(3,'客户上门培训','300','400','2021-10-10 17:49:06',NULL,0),(4,'客户OEM','400','500','2021-10-10 17:49:14',NULL,0);
/*!40000 ALTER TABLE `ctc_increment_service` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ctc_increment_service_order`
--

DROP TABLE IF EXISTS `ctc_increment_service_order`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ctc_increment_service_order`
--

LOCK TABLES `ctc_increment_service_order` WRITE;
/*!40000 ALTER TABLE `ctc_increment_service_order` DISABLE KEYS */;
/*!40000 ALTER TABLE `ctc_increment_service_order` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ctc_login_log`
--

DROP TABLE IF EXISTS `ctc_login_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
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
) ENGINE=InnoDB AUTO_INCREMENT=259 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ctc_login_log`
--

LOCK TABLES `ctc_login_log` WRITE;
/*!40000 ALTER TABLE `ctc_login_log` DISABLE KEYS */;
INSERT INTO `ctc_login_log` VALUES (149,'admin','27.184.175.200','河北石家庄','Chrome',0,'2022-04-08 07:06:39','admin','OS X'),(150,'admin','183.197.46.83','河北石家庄','Chrome',0,'2022-04-08 12:14:53','admin','OS X'),(151,'admin','106.117.15.162','河北石家庄','Firefox',0,'2022-04-09 02:28:38','admin','OS X'),(152,'admin','183.197.46.83','河北石家庄','Chrome',0,'2022-04-09 08:05:10','admin','OS X'),(153,'admin','183.197.46.83','河北石家庄','Chrome',0,'2022-04-10 06:42:47','admin','OS X'),(154,'admin','27.184.175.200','河北石家庄','Firefox',0,'2022-04-11 00:51:14','admin','OS X'),(155,'admin','60.1.128.148','河北石家庄','Chrome',0,'2022-04-11 01:04:35','admin','Windows'),(156,'admin','60.1.128.148','河北石家庄','Chrome',0,'2022-04-12 01:12:42','admin','Windows'),(157,'admin','183.197.46.83','河北石家庄','Chrome',0,'2022-04-13 03:09:16','admin','OS X'),(158,'admin','127.0.0.1','0内网IP','Chrome',0,'2022-04-13 03:21:22','admin','OS X'),(159,'admin','183.197.46.83','河北石家庄','Chrome',0,'2022-04-13 03:37:25','admin','OS X'),(160,'admin','183.197.46.83','河北石家庄','Chrome',0,'2022-04-13 07:35:39','admin','OS X'),(161,'admin','183.197.46.83','河北石家庄','Chrome',0,'2022-04-13 08:06:15','admin','OS X'),(162,'admin','60.1.53.116','河北石家庄','Chrome',0,'2022-04-14 01:48:52','admin','Windows'),(163,'admin','183.197.46.2','河北石家庄','Chrome',0,'2022-04-16 00:54:53','admin','OS X'),(164,'admin','183.197.46.2','河北石家庄','Chrome',0,'2022-04-17 18:27:00','admin','OS X'),(165,'admin','36.143.104.50','00','Chrome',0,'2022-04-19 06:30:33','admin','OS X'),(166,'admin','27.184.13.103','河北省石家庄市','Chrome',0,'2022-04-28 06:48:02','admin','OS X'),(167,'admin','27.184.13.103','河北省石家庄市','Chrome',0,'2022-04-28 08:06:39','admin','OS X'),(168,'admin','36.143.104.57','00','Chrome',0,'2022-04-29 07:01:42','admin','OS X'),(169,'admin','211.143.51.125','河北省石家庄市','Chrome',0,'2022-05-06 08:17:26','admin','OS X'),(170,'admin','211.143.51.125','河北省石家庄市','Chrome',0,'2022-05-09 02:16:47','admin','OS X'),(171,'admin','101.24.122.231','河北省石家庄市','Chrome',0,'2022-05-09 02:17:56','admin','Windows'),(172,'admin','211.143.51.125','河北省石家庄市','Chrome',0,'2022-05-09 02:24:59','admin','OS X'),(173,'admin','101.24.122.231','河北省石家庄市','Chrome',0,'2022-05-09 02:35:45','admin','Windows'),(174,'admin','101.24.122.231','河北省石家庄市','Chrome',0,'2022-05-10 03:07:51','admin','Windows'),(175,'admin','101.24.122.231','河北省石家庄市','Chrome',0,'2022-05-10 07:06:00','admin','Windows'),(176,'admin','101.24.122.231','河北省石家庄市','Chrome',0,'2022-05-11 06:13:19','admin','Windows'),(177,'admin','211.143.51.125','河北省石家庄市','Chrome',0,'2022-05-12 08:45:50','admin','OS X'),(178,'admin','183.198.80.78','河北省石家庄市','Chrome',0,'2022-05-14 17:09:45','admin','OS X'),(179,'admin','183.198.80.78','河北省石家庄市','Chrome',0,'2022-05-15 17:56:11','admin','OS X'),(180,'admin','60.1.134.69','河北省石家庄市','Chrome',0,'2022-05-19 07:56:20','admin','Windows'),(181,'admin','27.184.247.59','河北省石家庄市','Firefox',0,'2022-05-19 07:59:14','admin','OS X'),(182,'admin','27.184.247.59','河北省石家庄市','Firefox',0,'2022-05-19 08:00:52','admin','OS X'),(183,'admin','211.143.51.125','河北省石家庄市','Chrome',0,'2022-05-19 08:09:17','admin','OS X'),(184,'admin','60.1.134.69','河北省石家庄市','Chrome',0,'2022-05-20 02:00:39','admin','Windows'),(185,'admin','27.184.247.59','河北省石家庄市','Firefox',0,'2022-05-20 02:52:01','admin','OS X'),(186,'admin','60.1.134.69','河北省石家庄市','Chrome',0,'2022-05-20 03:38:53','admin','Windows'),(187,'admin','27.184.247.59','河北省石家庄市','Firefox',0,'2022-05-20 04:23:56','admin','OS X'),(188,'admin','60.1.134.69','河北省石家庄市','Chrome',0,'2022-05-20 05:43:50','admin','Windows'),(189,'admin','27.184.247.59','河北省石家庄市','Firefox',0,'2022-05-23 06:14:43','admin','OS X'),(190,'admin','60.1.134.69','河北省石家庄市','Chrome',0,'2022-05-23 08:03:32','admin','Windows'),(191,'admin','60.1.134.69','河北省石家庄市','Chrome',0,'2022-05-24 01:51:46','admin','Windows'),(192,'admin','60.1.134.69','河北省石家庄市','Chrome',0,'2022-05-24 03:09:57','admin','Windows'),(193,'admin','60.1.134.69','河北省石家庄市','Chrome',0,'2022-05-26 02:47:23','admin','Windows'),(194,'admin','60.1.134.69','河北省石家庄市','Chrome',0,'2022-05-27 07:51:58','admin','Windows'),(195,'admin','60.1.134.69','河北省石家庄市','Chrome',0,'2022-05-30 01:28:37','admin','Windows'),(196,'admin','60.1.134.69','河北省石家庄市','Chrome',0,'2022-05-31 06:24:27','admin','Windows'),(197,'admin','60.1.134.69','河北省石家庄市','Chrome',0,'2022-06-01 07:51:22','admin','Windows'),(198,'admin','60.1.134.69','河北省石家庄市','Chrome',0,'2022-06-02 05:37:12','admin','Windows'),(199,'admin','60.1.134.69','河北省石家庄市','Chrome',0,'2022-06-06 08:15:15','admin','Windows'),(200,'admin','60.1.134.69','河北省石家庄市','Chrome',0,'2022-06-08 03:07:07','admin','Windows'),(201,'admin','27.184.11.14','河北省石家庄市','Firefox',0,'2022-06-09 09:22:40','admin','OS X'),(202,'admin','60.1.134.69','河北省石家庄市','Chrome',0,'2022-06-10 01:39:10','admin','Windows'),(203,'admin','60.1.134.69','河北省石家庄市','Chrome',0,'2022-06-13 01:17:18','admin','Windows'),(204,'admin','60.1.134.69','河北省石家庄市','Chrome',0,'2022-06-13 01:17:32','admin','Windows'),(205,'admin','60.1.126.156','河北省石家庄市','Chrome',0,'2022-06-16 09:06:11','admin','Windows'),(206,'admin','101.24.128.48','河北省石家庄市','Chrome',0,'2022-06-20 01:20:34','admin','Windows'),(207,'admin','183.198.47.55','河北省石家庄市','Chrome',0,'2022-06-20 03:07:46','admin','OS X'),(208,'admin','183.198.47.55','河北省石家庄市','Chrome',0,'2022-06-20 03:07:52','admin','OS X'),(209,'admin','183.198.47.55','河北省石家庄市','Chrome',0,'2022-06-20 03:07:58','admin','OS X'),(210,'admin','101.24.128.48','河北省石家庄市','Chrome',0,'2022-06-20 03:08:51','admin','Windows'),(211,'admin','183.198.47.55','河北省石家庄市','Chrome',0,'2022-06-22 17:07:37','admin','OS X'),(212,'admin','183.198.47.55','河北省石家庄市','Chrome',0,'2022-06-22 17:07:45','admin','OS X'),(213,'admin','101.24.128.48','河北省石家庄市','Chrome',0,'2022-06-27 01:12:52','admin','Windows'),(214,'admin','101.24.128.48','河北省石家庄市','Chrome',0,'2022-06-27 02:52:22','admin','Windows'),(215,'admin','111.224.12.29','河北省石家庄市','Firefox',0,'2022-06-27 03:05:40','admin','OS X'),(216,'admin','101.24.128.48','河北省石家庄市','Chrome',0,'2022-06-28 06:05:26','admin','Windows'),(217,'admin','101.24.128.48','河北省石家庄市','Chrome',0,'2022-06-29 06:45:01','admin','Windows'),(218,'admin','101.24.128.48','河北省石家庄市','Chrome',0,'2022-07-04 01:06:50','admin','Windows'),(219,'admin','42.102.167.71','黑龙江省哈尔滨市','Chrome',0,'2022-07-08 02:13:33','admin','Windows'),(220,'admin','42.102.167.71','黑龙江省哈尔滨市','Chrome',0,'2022-07-08 02:13:45','admin','Windows'),(221,'admin','42.102.167.71','黑龙江省哈尔滨市','Chrome',0,'2022-07-08 02:14:08','admin','Windows'),(222,'admin','36.143.100.171','00','Chrome',0,'2022-07-25 16:50:21','admin','OS X'),(223,'admin','223.104.103.187','河北省石家庄市','Chrome',0,'2022-07-26 07:36:56','admin','OS X'),(224,'admin','211.143.51.117','河北省石家庄市','Chrome',0,'2022-07-29 06:28:42','admin','OS X'),(225,'admin','211.143.51.117','河北省石家庄市','Chrome',0,'2022-08-01 03:04:56','admin','OS X'),(226,'admin','101.24.125.120','河北省石家庄市','Chrome',0,'2022-08-08 03:45:12','admin','Windows'),(227,'admin','101.24.125.120','河北省石家庄市','Chrome',0,'2022-08-09 02:03:16','admin','Windows'),(228,'admin','101.24.125.120','河北省石家庄市','Chrome',0,'2022-08-11 07:48:33','admin','Windows'),(229,'admin','101.24.125.120','河北省石家庄市','Chrome',0,'2022-08-12 02:41:06','admin','Windows'),(230,'admin','183.198.73.41','河北省石家庄市','Chrome',0,'2022-08-13 16:57:11','admin','OS X'),(231,'admin','36.143.64.101','00','Chrome',0,'2022-08-20 16:04:11','admin','OS X'),(232,'admin','101.24.126.194','河北省石家庄市','Chrome',0,'2022-08-22 03:38:21','admin','Windows'),(233,'admin','36.143.66.106','00','Chrome',0,'2022-08-27 16:18:43','admin','OS X'),(234,'admin','36.143.66.106','00','Chrome',0,'2022-08-28 18:25:53','admin','OS X'),(235,'admin','183.198.47.34','河北省石家庄市','Chrome',0,'2022-08-31 03:17:44','admin','OS X'),(236,'admin','127.0.0.1','0内网IP','Chrome',0,'2022-09-03 15:30:43','admin','OS X'),(237,'admin','127.0.0.1','0内网IP','Chrome',0,'2022-09-16 12:22:33','admin','OS X'),(238,'admin','127.0.0.1','0内网IP','Chrome',0,'2022-11-14 12:26:23','admin','OS X'),(239,'admin','127.0.0.1','0内网IP','Chrome',0,'2022-11-16 06:10:48','admin','OS X'),(240,'admin','127.0.0.1','0内网IP','Chrome',0,'2022-11-17 07:56:18','admin','OS X'),(241,'admin','127.0.0.1','0内网IP','Chrome',0,'2022-11-18 09:30:47','admin','OS X'),(242,'admin','127.0.0.1','0内网IP','Chrome',0,'2022-12-04 07:06:16','admin','OS X'),(243,'admin','127.0.0.1','0内网IP','Chrome',0,'2022-12-09 16:17:29','admin','OS X'),(244,'admin','127.0.0.1','0内网IP','Chrome',0,'2022-12-10 14:05:58','admin','OS X'),(245,'admin','127.0.0.1','0内网IP','Chrome',0,'2022-12-14 08:07:45','admin','OS X'),(246,'admin','127.0.0.1','0内网IP','Chrome',0,'2022-12-16 16:40:52','admin','OS X'),(247,'admin','127.0.0.1','0内网IP','Chrome',0,'2022-12-23 10:08:45','admin','OS X'),(248,'admin','127.0.0.1','0内网IP','Chrome',0,'2022-12-27 08:56:10','admin','OS X'),(249,'admin','127.0.0.1','0内网IP','Chrome',0,'2022-12-31 07:29:25','admin','OS X'),(250,'admin','60.1.94.90','河北省石家庄市','Chrome',0,'2022-12-31 11:15:42','admin','OS X'),(251,'admin','101.24.45.11','河北省石家庄市','Chrome',0,'2023-01-02 16:13:21','admin','OS X'),(252,'admin','101.24.45.11','河北省石家庄市','Chrome',0,'2023-01-03 16:04:07','admin','OS X'),(253,'admin','110.228.40.47','河北省石家庄市','Chrome',0,'2023-01-13 15:34:32','admin','OS X'),(254,'admin','110.228.40.47','河北省石家庄市','Chrome',0,'2023-01-15 03:22:50','admin','OS X'),(255,'admin','110.228.40.52','河北省石家庄市','Chrome',0,'2023-02-09 15:23:11','admin','OS X'),(256,'admin','110.228.40.52','河北省石家庄市','Chrome',0,'2023-02-12 14:01:44','admin','OS X'),(257,'admin','60.1.82.79','河北省石家庄市','Chrome',0,'2023-02-22 17:02:53','admin','OS X'),(258,'admin','120.211.73.79','河北省0','Chrome',0,'2023-04-13 01:54:03','admin','OS X');
/*!40000 ALTER TABLE `ctc_login_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ctc_menu`
--

DROP TABLE IF EXISTS `ctc_menu`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
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
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ctc_menu`
--

LOCK TABLES `ctc_menu` WRITE;
/*!40000 ALTER TABLE `ctc_menu` DISABLE KEYS */;
INSERT INTO `ctc_menu` VALUES (6,'数据管理','M',3,0,NULL,'codeStore',NULL,'code','1',0,0,NULL,NULL,0,NULL,'2021-10-06 10:55:52'),(8,'生码管理','C',1,6,NULL,'code','code/index','','1',0,0,'','',0,NULL,'2021-10-06 13:52:40'),(9,'待生码管理','C',4,6,NULL,'coding','code/waiting','','1',0,0,NULL,NULL,0,NULL,'2021-10-07 11:37:39'),(10,'合伙人列表','M',2,0,NULL,'partner',NULL,'partner','1',0,0,NULL,NULL,0,NULL,'2021-10-07 11:42:03'),(11,'合伙人列表','C',1,10,NULL,'partnerList','partner/index','','1',0,0,NULL,NULL,0,NULL,'2021-10-07 11:42:43'),(12,'合伙人级别','C',2,10,NULL,'partnerLevel','partner/level','','1',0,0,NULL,NULL,0,NULL,'2021-10-07 11:43:16'),(13,'品牌商管理','M',1,0,NULL,'dealer',NULL,'dealer','1',0,0,NULL,NULL,0,NULL,'2021-10-07 11:44:30'),(14,'品牌商列表','C',1,13,NULL,'dealerList','dealer/index','','1',0,0,NULL,NULL,0,NULL,'2021-10-07 11:45:13'),(15,'防伪认证管理','C',0,13,NULL,'dealerAuth','dealer/auth','','1',0,0,NULL,NULL,0,NULL,'2021-10-07 11:45:42'),(16,'增值服务管理','M',0,0,NULL,'increment',NULL,'increment','1',0,0,NULL,NULL,0,NULL,'2021-10-07 11:47:14'),(17,'增值订单管理','C',0,16,NULL,'incrementOrder','increment/order','','1',0,0,NULL,NULL,0,NULL,'2021-10-07 11:47:44'),(18,'增值服务定价','C',0,16,NULL,'incrementPrice','increment/price','','1',0,0,NULL,NULL,0,NULL,'2021-10-07 11:48:13'),(19,'产品管理','M',0,0,NULL,'product',NULL,'product','1',0,0,NULL,NULL,0,NULL,'2021-10-07 11:49:10'),(20,'短信定价设置','C',0,19,NULL,'smsPrice','product/smsPrice','','1',0,0,NULL,NULL,0,NULL,'2021-10-07 11:49:40'),(21,'产品定价列表','C',0,19,NULL,'productPrice','product/index','','1',0,0,NULL,NULL,0,NULL,'2021-10-07 11:50:12'),(22,'PDA设备管理','C',0,19,NULL,'pda','product/pda','','1',0,0,NULL,NULL,0,NULL,'2021-10-07 11:50:37'),(23,'财务管理','M',0,0,NULL,'finance',NULL,'dashboard','1',0,0,NULL,NULL,0,NULL,'2021-10-07 11:52:57'),(24,'客户收支明细','C',0,23,NULL,'paymentsList','finance/paymentsList','','1',0,0,NULL,NULL,0,NULL,'2021-10-07 11:53:25'),(25,'合伙人账户管理','C',0,23,NULL,'partnerAccount','finance/partnerAccount','','1',0,0,NULL,NULL,0,NULL,'2021-10-07 11:53:53'),(26,'合伙人充值记录','C',0,23,NULL,'partnerPayLog','finance/partnerPay','','1',0,0,NULL,NULL,0,NULL,'2021-10-07 11:54:18'),(27,'合伙人提现管理','C',0,23,NULL,'partnerCash','finance/partnerCash','','1',0,0,NULL,NULL,0,NULL,'2021-10-07 11:54:45'),(28,'代发红包池管理','C',0,23,NULL,'redPacket','finance/redPacket','','1',1,0,NULL,NULL,0,NULL,'2021-10-07 11:55:08'),(29,'需求管理','M',0,0,NULL,'demand',NULL,'form','1',0,0,NULL,NULL,0,NULL,'2021-10-07 11:56:09'),(30,'需求列表','C',0,29,NULL,'demandList','demand/index','','1',0,0,NULL,NULL,0,NULL,'2021-10-07 11:56:36'),(31,'系统管理','M',0,0,NULL,'system',NULL,'tree','1',0,0,NULL,NULL,0,NULL,'2021-10-07 11:57:50'),(32,'管理员管理','C',0,31,NULL,'admin','system/admin','','1',0,0,NULL,NULL,0,NULL,'2021-10-07 11:58:21'),(33,'角色管理','C',0,31,NULL,'role','system/role/index','','1',0,0,NULL,NULL,0,NULL,'2021-10-07 11:58:46'),(34,'菜单管理','C',0,31,NULL,'menu','system/menu','','1',0,0,NULL,NULL,0,NULL,'2021-10-07 11:59:09'),(35,'字典管理','C',0,31,NULL,'dict','system/dict/index','','1',0,0,NULL,NULL,0,NULL,'2021-10-07 11:59:34'),(36,'操作日志','C',0,31,NULL,'operationLog','system/log/operationLog','','1',0,0,NULL,NULL,0,NULL,'2021-10-07 12:00:01'),(37,'查看批次秘钥','F',0,8,NULL,NULL,NULL,NULL,'1',0,0,'codeStore:code:key',NULL,0,NULL,'2021-10-11 16:01:55'),(38,'删除批次码','F',0,8,NULL,NULL,NULL,NULL,'1',0,0,'codeStore:code:delete',NULL,0,NULL,'2021-10-11 16:46:37'),(39,'待生码批次秘钥查看','F',0,9,NULL,NULL,NULL,NULL,'1',0,0,'codeStore:waiting:key',NULL,0,NULL,'2021-10-11 16:47:55'),(40,'待生码批次删除','F',0,9,NULL,NULL,NULL,NULL,'1',0,0,'codeStore:waiting:delete',NULL,0,NULL,'2021-10-11 16:48:59'),(41,'添加合伙人','F',0,11,NULL,NULL,NULL,NULL,'1',0,0,'partner:partnerList:addPartner',NULL,0,NULL,'2021-10-11 16:52:19'),(42,'修改合伙人','F',0,11,NULL,NULL,NULL,NULL,'1',0,0,'partner:partnerList:editPartner',NULL,0,NULL,'2021-10-11 16:53:44'),(43,'删除合伙人','F',0,11,NULL,NULL,NULL,NULL,'1',0,0,'partner:partnerList:delePartner',NULL,0,NULL,'2021-10-11 16:54:02'),(44,'重置合伙人密码','F',0,11,NULL,NULL,NULL,NULL,'1',0,0,'partner:partnerList:resetPwd',NULL,0,NULL,'2021-10-11 16:55:21'),(45,'查看合伙人详情','F',0,11,NULL,NULL,NULL,NULL,'1',0,0,'partner:partnerList:partnerView',NULL,0,NULL,'2021-10-11 16:56:15'),(46,'禁用/恢复合伙人账号','F',0,11,NULL,NULL,NULL,NULL,'1',0,0,'partner:partnerList:cutPartner',NULL,0,NULL,'2021-10-11 16:57:12'),(47,'编辑认证合伙人认证信息','F',0,11,NULL,NULL,NULL,NULL,'1',0,0,'partner:partnerList:editAuthInfo',NULL,0,NULL,'2021-10-11 16:58:54'),(48,'查看合伙人认证信息','F',0,11,NULL,NULL,NULL,NULL,'1',0,0,'partner:partnerList:authInfoView',NULL,0,NULL,'2021-10-11 16:59:33'),(49,'表格显示更多操作按钮','F',0,11,NULL,NULL,NULL,NULL,'1',0,0,'partner:partnerList:moreOption',NULL,0,NULL,'2021-10-11 17:10:57'),(50,'添加合伙人级别','F',0,12,NULL,NULL,NULL,NULL,'1',0,0,'partner:partnerLevel:addLevel',NULL,0,NULL,'2021-10-11 17:13:57'),(51,'修改合伙人级别','F',0,12,NULL,NULL,NULL,NULL,'1',0,0,'partner:partnerLevel:editLevel',NULL,0,NULL,'2021-10-11 17:14:34'),(52,'删除合伙人级别','F',0,12,NULL,NULL,NULL,NULL,'1',0,0,'partner:partnerLevel:deleLevel',NULL,0,NULL,'2021-10-11 17:15:14'),(53,'登录日志','C',0,31,NULL,'logininfor','system/log/logininfor',NULL,'1',0,0,NULL,NULL,0,NULL,'2021-10-16 14:55:57'),(54,'合伙人菜单','C',0,31,NULL,'partnerMenu','system/partnerMenu',NULL,'1',0,0,NULL,NULL,0,NULL,'2021-10-21 15:26:42'),(55,'品牌商菜单','C',0,31,NULL,'dealerMenu','system/dealerMenu',NULL,'1',0,0,NULL,NULL,0,NULL,'2021-11-10 07:06:54');
/*!40000 ALTER TABLE `ctc_menu` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ctc_oper_log`
--

DROP TABLE IF EXISTS `ctc_oper_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
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
) ENGINE=InnoDB AUTO_INCREMENT=99 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ctc_oper_log`
--

LOCK TABLES `ctc_oper_log` WRITE;
/*!40000 ALTER TABLE `ctc_oper_log` DISABLE KEYS */;
INSERT INTO `ctc_oper_log` VALUES (63,'合伙人列表','admin','27.184.175.200','河北石家庄','1','新增合伙人','2022-04-08 15:13:11'),(64,'合伙人列表','admin','27.184.175.200','河北石家庄','3','删除合伙人','2022-04-08 15:13:26'),(65,'合伙人列表','admin','27.184.175.200','河北石家庄','3','删除合伙人','2022-04-08 15:13:28'),(66,'合伙人列表','admin','27.184.175.200','河北石家庄','3','删除合伙人','2022-04-08 15:13:32'),(67,'合伙人列表','admin','27.184.175.200','河北石家庄','1','新增合伙人','2022-04-08 15:13:47'),(68,'合伙人列表','admin','27.184.175.200','河北石家庄','3','删除合伙人','2022-04-08 15:13:59'),(69,'合伙人列表','admin','27.184.175.200','河北石家庄','1','新增合伙人','2022-04-08 15:14:56'),(70,'合伙人列表','admin','183.197.46.83','河北石家庄','2','修改合伙人','2022-04-13 11:30:39'),(71,'合伙人列表','admin','183.197.46.83','河北石家庄','2','修改合伙人','2022-04-13 11:31:44'),(72,'合伙人列表','admin','183.197.46.83','河北石家庄','2','修改合伙人','2022-04-13 11:36:19'),(73,'财务管理','admin','183.197.46.83','河北石家庄','2','合伙人余额充值','2022-04-13 11:41:53'),(74,'财务管理','admin','183.197.46.83','河北石家庄','2','合伙人预存款充值','2022-04-13 11:42:01'),(75,'合伙人列表','admin','183.197.46.83','河北石家庄','2','修改合伙人','2022-04-13 12:53:44'),(76,'合伙人列表','admin','183.197.46.83','河北石家庄','1','新增合伙人','2022-04-13 13:05:26'),(77,'合伙人列表','admin','183.197.46.83','河北石家庄','2','审核合伙人营业执照','2022-04-13 13:06:33'),(78,'合伙人列表','admin','183.197.46.83','河北石家庄','3','删除合伙人','2022-04-13 13:06:41'),(79,'合伙人列表','admin','27.184.13.103','河北省石家庄市','2','修改合伙人','2022-04-28 16:31:50'),(80,'品牌商管理','admin','101.24.122.231','河北省石家庄市','2','增减品牌商的代发红包资金池','2022-05-09 10:20:40'),(81,'品牌商管理','admin','101.24.122.231','河北省石家庄市','2','增减品牌商的代发红包资金池','2022-05-10 15:06:20'),(82,'品牌商管理','admin','101.24.122.231','河北省石家庄市','2','增减品牌商的代发红包资金池','2022-05-11 14:14:05'),(83,'品牌商管理','admin','183.198.80.78','河北省石家庄市','2','增减品牌商的代发红包资金池','2022-05-15 01:10:09'),(84,'品牌商管理','admin','60.1.134.69','河北省石家庄市','2','增减品牌商的代发红包资金池','2022-05-20 11:39:49'),(85,'产品管理','admin','60.1.134.69','河北省石家庄市','3','删除码阶梯','2022-05-23 16:16:22'),(86,'产品管理','admin','60.1.134.69','河北省石家庄市','3','删除码阶梯','2022-05-23 16:16:25'),(87,'产品管理','admin','60.1.134.69','河北省石家庄市','3','新增码阶梯','2022-05-23 16:17:01'),(88,'产品管理','admin','60.1.134.69','河北省石家庄市','3','新增码阶梯','2022-05-23 16:19:28'),(89,'品牌商管理','admin','60.1.134.69','河北省石家庄市','2','增减品牌商的代发红包资金池','2022-05-24 11:10:34'),(90,'品牌商管理','admin','60.1.134.69','河北省石家庄市','2','增减品牌商的代发红包资金池','2022-05-27 15:52:51'),(91,'品牌商管理','admin','60.1.134.69','河北省石家庄市','2','增减品牌商的代发红包资金池','2022-05-30 09:29:10'),(92,'品牌商管理','admin','60.1.134.69','河北省石家庄市','2','增减品牌商的代发红包资金池','2022-06-10 09:40:31'),(93,'品牌商管理','admin','60.1.134.69','河北省石家庄市','2','增减品牌商的代发红包资金池','2022-06-13 15:28:27'),(94,'品牌商管理','admin','60.1.134.69','河北省石家庄市','2','增减品牌商的代发红包资金池','2022-06-13 17:19:20'),(95,'品牌商管理','admin','101.24.128.48','河北省石家庄市','2','增减品牌商的代发红包资金池','2022-06-20 09:28:52'),(96,'品牌商管理','admin','101.24.128.48','河北省石家庄市','2','增减品牌商的代发红包资金池','2022-06-20 09:32:59'),(97,'品牌商管理','admin','101.24.125.120','河北省石家庄市','2','增减品牌商的代发红包资金池','2022-08-11 15:48:51'),(98,'品牌商管理','admin','183.198.47.34','河北省石家庄市','2','增减品牌商的代发红包资金池','2022-08-31 11:19:09');
/*!40000 ALTER TABLE `ctc_oper_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ctc_partner`
--

DROP TABLE IF EXISTS `ctc_partner`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
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
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ctc_partner`
--

LOCK TABLES `ctc_partner` WRITE;
/*!40000 ALTER TABLE `ctc_partner` DISABLE KEYS */;
INSERT INTO `ctc_partner` VALUES (9,'石家庄市程功信息有限公司','admin',1,'8239.2','9921.77999999999','2022-04-12,2022-05-05',0,'0','','物元码数据平台','','http://cdn.uni-2id.com/62b3e202204281631427364.png','13343217111','程朝阳','e10adc3949ba59abbe56e057f20f883e','河北省','石家庄市','长安区',NULL,1,'','','','http://cdn.uni-2id.com/bad14202204131130039000.ico','2022-04-08 07:14:56',NULL,'',NULL,'','2022-04-12','2022-05-05',NULL,NULL,'',NULL,NULL,NULL,'',NULL,NULL,NULL,NULL,0),(10,'测试','wenhan',1,'0','0','2022-04-07,2022-05-05',0,'1','','','','http://cdn.uni-2id.com/d01f0202204131305244137.png','18330118047','文寒','e10adc3949ba59abbe56e057f20f883e','天津市','市辖区','和平区',NULL,0,'','','','','2022-04-13 05:05:26',NULL,'',NULL,'123','2022-04-07','2022-05-05',NULL,NULL,'','1','141','44','44',NULL,NULL,'http://cdn.uni-2id.com/10f772022041313063152.png','',1);
/*!40000 ALTER TABLE `ctc_partner` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ctc_partner_cash_bill`
--

DROP TABLE IF EXISTS `ctc_partner_cash_bill`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ctc_partner_cash_bill`
--

LOCK TABLES `ctc_partner_cash_bill` WRITE;
/*!40000 ALTER TABLE `ctc_partner_cash_bill` DISABLE KEYS */;
/*!40000 ALTER TABLE `ctc_partner_cash_bill` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ctc_partner_increment_service`
--

DROP TABLE IF EXISTS `ctc_partner_increment_service`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ctc_partner_increment_service` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `service_id` int(11) DEFAULT NULL,
  `partner_id` int(11) DEFAULT NULL,
  `cost_price` varchar(255) DEFAULT NULL,
  `retail_price` varchar(255) DEFAULT NULL,
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ctc_partner_increment_service`
--

LOCK TABLES `ctc_partner_increment_service` WRITE;
/*!40000 ALTER TABLE `ctc_partner_increment_service` DISABLE KEYS */;
INSERT INTO `ctc_partner_increment_service` VALUES (5,1,5,'100','101','2022-04-08 07:18:15'),(6,2,5,'200','304','2022-04-08 07:18:15'),(7,3,5,'300','400','2022-04-08 07:18:15'),(8,4,5,'400','500','2022-04-08 07:18:15');
/*!40000 ALTER TABLE `ctc_partner_increment_service` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ctc_partner_level`
--

DROP TABLE IF EXISTS `ctc_partner_level`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
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
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ctc_partner_level`
--

LOCK TABLES `ctc_partner_level` WRITE;
/*!40000 ALTER TABLE `ctc_partner_level` DISABLE KEYS */;
INSERT INTO `ctc_partner_level` VALUES (1,1,'金牌合伙人',8,8,'1','1','1','1','1','0','1','0','1',2,2,'2021-10-07 16:03:17',NULL),(4,2,'银牌合伙人',7,7,'0','0','0','0','0','0','0','0','0',0,0,'2021-10-07 17:33:46',NULL),(5,3,'铜牌合伙人',6,5,'1','0','0','0','0','0','0','0','0',0,2,'2021-10-11 17:32:57','admin');
/*!40000 ALTER TABLE `ctc_partner_level` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ctc_partner_menu`
--

DROP TABLE IF EXISTS `ctc_partner_menu`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
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
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ctc_partner_menu`
--

LOCK TABLES `ctc_partner_menu` WRITE;
/*!40000 ALTER TABLE `ctc_partner_menu` DISABLE KEYS */;
INSERT INTO `ctc_partner_menu` VALUES (1,'需求管理','M',6,0,NULL,'demand',NULL,'form','1',0,0,NULL,NULL,0,NULL,'2021-10-21 15:37:35'),(2,'需求列表','C',0,1,NULL,'demandList','demand/index',NULL,'1',0,0,NULL,NULL,0,NULL,'2021-10-21 15:38:50'),(3,'产品管理','M',4,0,NULL,'product',NULL,'product','1',0,0,NULL,NULL,0,NULL,'2021-10-23 16:55:53'),(4,'产品定价设置','C',0,3,NULL,'productPrice','product/index',NULL,'1',0,0,NULL,NULL,0,NULL,'2021-10-23 16:56:34'),(5,'品牌商管理','M',2,0,NULL,'dealer',NULL,'dealer','1',0,0,NULL,NULL,0,NULL,'2021-10-24 11:19:29'),(6,'品牌商列表','C',0,5,NULL,'dealerList','dealer/index',NULL,'1',0,0,NULL,NULL,0,NULL,'2021-10-24 11:20:25'),(7,'增值服务','M',3,0,NULL,'increment',NULL,'increment','1',0,0,NULL,NULL,0,NULL,'2021-10-25 10:55:27'),(8,'增值服务定价','C',0,7,NULL,'incrementPrice','increment/price',NULL,'1',0,0,NULL,NULL,0,NULL,'2021-10-25 10:56:25'),(9,'增值订单管理','C',0,7,NULL,'incrementOrder','increment/order',NULL,'1',0,0,NULL,NULL,0,NULL,'2021-10-25 17:44:14'),(10,'财务管理','M',5,0,NULL,'finance',NULL,'dashboard','1',0,0,NULL,NULL,0,NULL,'2021-10-26 19:02:45'),(11,'收支明细','C',0,10,NULL,'bill','finance/bill',NULL,'1',0,0,NULL,NULL,0,NULL,'2021-10-26 19:05:35'),(12,'余额提现','C',0,10,NULL,'cash','finance/cash',NULL,'1',0,0,NULL,NULL,0,NULL,'2021-10-26 19:06:04'),(13,'码库管理','M',0,0,NULL,'codeStore',NULL,'code','1',0,0,NULL,NULL,0,NULL,'2021-10-26 21:40:26'),(14,'生码管理','C',0,13,NULL,'code','code/index',NULL,'1',0,0,NULL,NULL,0,NULL,'2021-10-26 21:41:45');
/*!40000 ALTER TABLE `ctc_partner_menu` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ctc_partner_product_code`
--

DROP TABLE IF EXISTS `ctc_partner_product_code`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ctc_partner_product_code` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `partner_id` int(11) DEFAULT NULL,
  `code_order_begin` varchar(255) DEFAULT NULL,
  `code_order_end` varchar(255) DEFAULT NULL,
  `code_retail` varchar(255) DEFAULT NULL,
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `create_by` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ctc_partner_product_code`
--

LOCK TABLES `ctc_partner_product_code` WRITE;
/*!40000 ALTER TABLE `ctc_partner_product_code` DISABLE KEYS */;
INSERT INTO `ctc_partner_product_code` VALUES (3,5,'1','1000000','1','2022-04-08 07:54:47',NULL),(4,9,'1','100','0.00001','2022-05-20 08:51:51',NULL);
/*!40000 ALTER TABLE `ctc_partner_product_code` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ctc_partner_product_module`
--

DROP TABLE IF EXISTS `ctc_partner_product_module`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ctc_partner_product_module` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `module_id` int(11) DEFAULT NULL,
  `partner_id` int(11) DEFAULT NULL,
  `cost_price` varchar(255) DEFAULT NULL,
  `retail_price` varchar(255) DEFAULT NULL,
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ctc_partner_product_module`
--

LOCK TABLES `ctc_partner_product_module` WRITE;
/*!40000 ALTER TABLE `ctc_partner_product_module` DISABLE KEYS */;
/*!40000 ALTER TABLE `ctc_partner_product_module` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ctc_partner_product_service`
--

DROP TABLE IF EXISTS `ctc_partner_product_service`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ctc_partner_product_service` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `service_name` varchar(255) DEFAULT NULL,
  `service_cost` varchar(255) DEFAULT NULL,
  `service_des` text,
  `partner_id` int(11) DEFAULT NULL,
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ctc_partner_product_service`
--

LOCK TABLES `ctc_partner_product_service` WRITE;
/*!40000 ALTER TABLE `ctc_partner_product_service` DISABLE KEYS */;
INSERT INTO `ctc_partner_product_service` VALUES (5,'维护','100','维护',5,'2022-04-08 07:24:24'),(6,'服务费','100','服务费',9,'2022-05-10 07:17:45');
/*!40000 ALTER TABLE `ctc_partner_product_service` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ctc_partner_recharge_record`
--

DROP TABLE IF EXISTS `ctc_partner_recharge_record`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
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
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ctc_partner_recharge_record`
--

LOCK TABLES `ctc_partner_recharge_record` WRITE;
/*!40000 ALTER TABLE `ctc_partner_recharge_record` DISABLE KEYS */;
INSERT INTO `ctc_partner_recharge_record` VALUES (19,_binary '2','10000','10000','','2022-04-08 07:28:47','admin',9),(20,_binary '1','10','10010','充值','2022-04-13 03:41:53','admin',9),(21,_binary '2','200','10200','充值','2022-04-13 03:42:01','admin',9);
/*!40000 ALTER TABLE `ctc_partner_recharge_record` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ctc_partner_token`
--

DROP TABLE IF EXISTS `ctc_partner_token`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ctc_partner_token` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `uid` int(11) DEFAULT NULL,
  `token` varchar(255) DEFAULT NULL,
  `login_ip` varchar(32) DEFAULT NULL,
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP,
  `expires_time` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=206 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ctc_partner_token`
--

LOCK TABLES `ctc_partner_token` WRITE;
/*!40000 ALTER TABLE `ctc_partner_token` DISABLE KEYS */;
INSERT INTO `ctc_partner_token` VALUES (89,5,'26fc1b8816d3d482bede24b5058cf638bed4c222','183.197.46.83','2022-04-08 20:17:04','2022-04-09 08:17:04'),(90,5,'173e5a577631cab2b0d5fd25c70b31f70c3f4b49','106.117.18.231','2022-04-08 22:25:25','2022-04-09 10:25:25'),(91,5,'35244877ce9e4d627c3d8a021d2ac1626ec8a84e','106.117.15.162','2022-04-09 10:02:07','2022-04-09 22:02:07'),(92,5,'396bcd868a12cff82b8c2231582af90dbcdaa272','183.197.46.83','2022-04-09 16:07:30','2022-04-10 04:07:30'),(93,5,'870857754d248e8a8a848098fffdbea1daf87558','27.184.175.200','2022-04-11 08:54:48','2022-04-11 20:54:48'),(94,5,'acf927cc0d25fe9a313815157975c5748ca218b8','183.197.46.83','2022-04-12 01:51:45','2022-04-12 13:51:45'),(95,5,'8550f9fa6917cada59fe0dd38b0847084c33d49a','183.197.46.83','2022-04-12 01:52:00','2022-04-12 13:52:00'),(96,5,'c610b7dcaa5b35e3b8ebf666f12853aff2f53169','183.197.46.83','2022-04-12 01:52:10','2022-04-12 13:52:10'),(97,5,'5b34bf85b99d179ebbb6fe05c34a5f0275245b2d','183.197.46.83','2022-04-12 01:52:13','2022-04-12 13:52:13'),(98,5,'12d7f2c82331de706039c72e5f2c5c77ac7bf5e9','183.197.46.83','2022-04-12 02:09:56','2022-04-12 14:09:56'),(99,5,'62697a8cad3b6f778a94e6a355eb7d7cdb164bf1','183.197.46.83','2022-04-13 11:14:26','2022-04-13 23:14:26'),(100,5,'7afca23bb19573973a3382b8bb03a88218523615','183.197.46.83','2022-04-13 11:36:58','2022-04-13 23:36:58'),(195,9,'5421eb2b917bb8235463ce0cab591dcd6e84f42d','127.0.0.1','2022-12-11 16:58:45','2022-12-12 04:58:44'),(196,9,'4c4a38c7a615b5ea635b3dece0ae28dd05e1bcf9','127.0.0.1','2022-12-27 15:44:07','2022-12-28 03:44:07'),(197,9,'bee80436ded702599659d81f537fd407a6bf1f13','127.0.0.1','2022-12-31 15:24:10','2023-01-01 03:24:10'),(198,9,'df15961905204f39eb3b10a3bf6c516ed69fbcd4','60.1.94.90','2022-12-31 18:57:21','2023-01-01 06:57:21'),(199,9,'518db5bb314a1c21416f204c6a0e90f56a8061c9','101.24.45.11','2023-01-03 02:07:58','2023-01-03 14:07:58'),(200,9,'cd1e54ba2cd172d2c1f771a2a26f10299a1031c6','110.228.40.47','2023-01-13 23:39:35','2023-01-14 11:39:35'),(201,9,'fd1f6e755a440f4f8b492951f078689400f3e1a0','110.228.40.47','2023-01-15 11:21:30','2023-01-15 23:21:30'),(202,9,'ff611c8ce36d862355567fbfbd59f614f6dda1de','110.228.40.52','2023-02-09 23:19:59','2023-02-10 11:19:59'),(203,9,'e91dd5ebd9e3b3a4a066efba291bf151f5a8db2b','110.228.40.52','2023-02-12 21:53:28','2023-02-13 09:53:28'),(204,9,'75439cfec58ccb352b94e9820939b04e12a9603e','60.1.82.79','2023-02-23 01:00:56','2023-02-23 13:00:56'),(205,9,'8d404f34748a4c6e2ed52a190a51484832043f46','101.24.45.62','2023-04-07 00:43:27','2023-04-07 12:43:27');
/*!40000 ALTER TABLE `ctc_partner_token` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ctc_product_code`
--

DROP TABLE IF EXISTS `ctc_product_code`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ctc_product_code` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `code_order_begin` varchar(255) DEFAULT NULL,
  `code_order_end` varchar(255) DEFAULT NULL,
  `code_cost` varchar(255) DEFAULT NULL,
  `code_retail` varchar(255) DEFAULT NULL,
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `create_by` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ctc_product_code`
--

LOCK TABLES `ctc_product_code` WRITE;
/*!40000 ALTER TABLE `ctc_product_code` DISABLE KEYS */;
INSERT INTO `ctc_product_code` VALUES (3,'1','10','0.00001','0.00001','2022-05-23 08:17:01',NULL),(4,'11','100','0.00001','0.00001','2022-05-23 08:19:28',NULL);
/*!40000 ALTER TABLE `ctc_product_code` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ctc_product_module`
--

DROP TABLE IF EXISTS `ctc_product_module`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ctc_product_module` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `module_name` varchar(255) DEFAULT NULL,
  `module_cost` varchar(255) DEFAULT NULL,
  `module_retail` varchar(255) DEFAULT NULL,
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `create_by` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=27 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ctc_product_module`
--

LOCK TABLES `ctc_product_module` WRITE;
/*!40000 ALTER TABLE `ctc_product_module` DISABLE KEYS */;
INSERT INTO `ctc_product_module` VALUES (3,'测试模块','1','2','2021-10-23 08:34:50',NULL),(4,'系统模块','10','10','2021-10-24 06:38:08',NULL),(5,'码库','105','100','2021-10-24 06:38:28',NULL),(6,'订单管理','101','98','2021-10-24 06:38:43',NULL),(7,'客户','100','100','2021-10-24 06:38:54',NULL),(8,'二维码营销','111','100','2021-10-24 06:39:11',NULL),(9,'公众号','2','2','2021-10-24 06:39:21',NULL),(10,'资产','100','99','2021-10-24 06:39:33',NULL),(11,'万能溯源','100','160','2021-10-24 06:39:47',NULL),(12,'微商城','100','200','2021-10-24 06:40:07',NULL),(13,'积分商城','100','190','2021-10-24 06:40:23',NULL),(14,'多语言','100','150','2021-10-24 06:40:49',NULL),(15,'智慧门店','100','190','2021-10-24 06:41:08',NULL),(16,'万能溯源(舒适版)','100','100','2021-10-24 06:41:24',NULL),(17,'智能物流','100','100','2021-10-24 06:41:41',NULL),(18,'超级导购','100','100','2021-10-24 06:41:52',NULL),(19,'玲珑OA','100','100','2021-10-24 06:42:03',NULL),(20,'在线订单','0','0','2021-10-24 06:42:11',NULL),(21,'营销分控','100','109','2021-10-24 06:42:22',NULL),(22,'经营报表','0','0','2021-10-24 06:42:34',NULL),(23,'视频分享','0','0','2021-10-24 06:42:43',NULL),(24,'虚拟红包','0','0','2021-10-24 06:42:54',NULL),(25,'小程序扫码管理','500','500','2021-10-24 06:43:07',NULL),(26,'小程序商城模板','0','0','2021-10-24 06:43:16',NULL);
/*!40000 ALTER TABLE `ctc_product_module` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ctc_qrcode_blacklist`
--

DROP TABLE IF EXISTS `ctc_qrcode_blacklist`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ctc_qrcode_blacklist`
--

LOCK TABLES `ctc_qrcode_blacklist` WRITE;
/*!40000 ALTER TABLE `ctc_qrcode_blacklist` DISABLE KEYS */;
/*!40000 ALTER TABLE `ctc_qrcode_blacklist` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ctc_qrcode_blacklist_set`
--

DROP TABLE IF EXISTS `ctc_qrcode_blacklist_set`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ctc_qrcode_blacklist_set`
--

LOCK TABLES `ctc_qrcode_blacklist_set` WRITE;
/*!40000 ALTER TABLE `ctc_qrcode_blacklist_set` DISABLE KEYS */;
/*!40000 ALTER TABLE `ctc_qrcode_blacklist_set` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ctc_redpool_issue_record`
--

DROP TABLE IF EXISTS `ctc_redpool_issue_record`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
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
) ENGINE=InnoDB AUTO_INCREMENT=388 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ctc_redpool_issue_record`
--

LOCK TABLES `ctc_redpool_issue_record` WRITE;
/*!40000 ALTER TABLE `ctc_redpool_issue_record` DISABLE KEYS */;
INSERT INTO `ctc_redpool_issue_record` VALUES (62,27,'1','4.00','osnBC6CAeXSYLuGBtbjkMpaqrCMY','2','2022-05-24 03:33:56',18,NULL,17),(63,27,'1','3.00','osnBC6CAeXSYLuGBtbjkMpaqrCMY','2','2022-05-24 07:38:22',18,NULL,17),(65,27,'1','2.00','osnBC6CAeXSYLuGBtbjkMpaqrCMY','2','2022-05-28 00:33:10',18,NULL,17),(66,27,'1','1.00','osnBC6CAeXSYLuGBtbjkMpaqrCMY','2','2022-05-28 00:41:15',18,NULL,17),(82,30,'0.3','4.70','osnBC6OtFSda5b2PIY9R-HIs8vgk','2','2022-05-30 01:56:08',23,NULL,24),(104,30,'0.3','4.40','oAM70sz1SZcBLPfWYKqUjwhuIC10','2','2022-05-30 16:28:18',23,NULL,24),(105,30,'0.3','4.10','oAM70sxRW4V1iQ5bhAKYzjvQLM8Q','2','2022-05-31 01:26:15',23,NULL,24),(106,30,'0.3','3.80','oAM70sxRW4V1iQ5bhAKYzjvQLM8Q','2','2022-05-31 01:27:43',23,NULL,24),(107,30,'0.3','3.50','oAM70s2VVesszV1cxTglEz5fiC2g','2','2022-05-31 01:30:36',23,NULL,24),(108,30,'1','2.50','oAM70syDvgBKlrP7UXaTVKfTJJDQ','2','2022-05-31 01:33:46',22,NULL,25),(116,29,'1','99.00','osnBC6OPadCdY77BfGZOaVhbgjak','2','2022-06-10 05:42:04',15,NULL,14),(121,29,'1','98.00','osnBC6OPadCdY77BfGZOaVhbgjak','2','2022-06-10 16:37:41',15,NULL,28),(122,29,'1','97.00','osnBC6B2aAdGwm1k6m5Ryj7qbcKg','2','2022-06-13 05:42:19',15,NULL,28),(123,30,'10','992.50','oAM70s_8482ryKTfEa2Qj64JhOsI','2','2022-06-13 08:27:56',25,NULL,29),(124,30,'10','982.50','oAM70s-oM6LpN6oLASvSVvmMXGMk','2','2022-06-16 13:30:00',25,NULL,29),(125,30,'10','972.50','oAM70s-oM6LpN6oLASvSVvmMXGMk','2','2022-06-16 13:44:03',25,NULL,29),(126,30,'10','962.50','oAM70s-oM6LpN6oLASvSVvmMXGMk','2','2022-06-16 13:45:10',25,NULL,29),(127,30,'10','952.50','oAM70s-oM6LpN6oLASvSVvmMXGMk','2','2022-06-16 13:45:28',25,NULL,29),(128,30,'10','942.50','oAM70s-oM6LpN6oLASvSVvmMXGMk','2','2022-06-16 13:45:46',25,NULL,29),(129,31,'0.3','1.70','oAM70sxRW4V1iQ5bhAKYzjvQLM8Q','2','2022-06-20 01:42:10',26,NULL,30),(130,26,'100','11905.00','osnBC6Jf0NVNNbF__KikjZOUo2Cw','2','2022-06-29 05:35:50',24,NULL,26),(131,26,'100','11805.00','osnBC6Jf0NVNNbF__KikjZOUo2Cw','2','2022-06-29 05:37:31',24,NULL,26),(132,29,'1','96.00','osnBC6B2aAdGwm1k6m5Ryj7qbcKg','2','2022-06-30 01:28:34',15,NULL,31),(133,30,'10','932.50','oAM70s8lKMo7TNF642S2Rpgsf3SY','2','2022-07-01 03:23:41',25,NULL,29),(134,30,'10','922.50','oAM70s8lKMo7TNF642S2Rpgsf3SY','2','2022-07-01 03:24:38',25,NULL,29),(135,30,'10','912.50','oAM70s3f8DhWov19fCsJq9ULTGoY','2','2022-07-04 00:46:56',25,NULL,29),(136,26,'100','11705.00','osnBC6EyUDbj5HUVDXhpwqhyK1c0','2','2022-07-04 01:10:12',24,NULL,26),(137,26,'100','11605.00','osnBC6EyUDbj5HUVDXhpwqhyK1c0','2','2022-07-04 01:11:21',24,NULL,26),(138,26,'100','11505.00','osnBC6Jf0NVNNbF__KikjZOUo2Cw','2','2022-07-08 03:12:01',24,NULL,26),(139,26,'100','11405.00','osnBC6Jf0NVNNbF__KikjZOUo2Cw','2','2022-07-08 03:15:46',24,NULL,26),(140,26,'100','11305.00','osnBC6Jf0NVNNbF__KikjZOUo2Cw','2','2022-07-08 03:18:16',24,NULL,26),(141,26,'100','11205.00','osnBC6Jf0NVNNbF__KikjZOUo2Cw','2','2022-07-08 03:19:59',24,NULL,26),(142,26,'100','11105.00','osnBC6PClJ9-3zmG_L5oivXsF8Rc','2','2022-07-11 03:12:31',24,NULL,26),(143,30,'10','902.50','oAM70s_RSe6wPMsfNmryKBIXH2fk','2','2022-07-12 06:00:20',25,NULL,29),(144,30,'10','892.50','oAM70s_RSe6wPMsfNmryKBIXH2fk','2','2022-07-12 06:01:55',25,NULL,29),(145,30,'10','882.50','oAM70s_RSe6wPMsfNmryKBIXH2fk','2','2022-07-12 06:03:47',25,NULL,29),(146,26,'100','11005.00','osnBC6PClJ9-3zmG_L5oivXsF8Rc','2','2022-07-12 06:08:09',24,NULL,26),(147,26,'100','10905.00','osnBC6PClJ9-3zmG_L5oivXsF8Rc','2','2022-07-12 06:09:26',24,NULL,26),(148,30,'10','872.50','oAM70s8lKMo7TNF642S2Rpgsf3SY','2','2022-07-13 01:33:18',25,NULL,29),(149,26,'100','10805.00','osnBC6MK5S2CgSeUGa3Ruwj-E9Qc','2','2022-07-14 08:57:59',24,NULL,26),(150,26,'100','10705.00','osnBC6MK5S2CgSeUGa3Ruwj-E9Qc','2','2022-07-14 08:59:11',24,NULL,26),(151,30,'10','862.50','oAM70s7RsRAMknca5eHiEOqTVAR4','2','2022-07-15 05:49:48',25,NULL,29),(152,30,'10','852.50','oAM70s7RsRAMknca5eHiEOqTVAR4','2','2022-07-15 05:50:51',25,NULL,29),(153,30,'10','842.50','oAM70s7RsRAMknca5eHiEOqTVAR4','2','2022-07-15 05:51:28',25,NULL,29),(154,30,'10','832.50','oAM70s8lKMo7TNF642S2Rpgsf3SY','2','2022-07-20 01:13:22',25,NULL,29),(155,26,'100','10605.00','osnBC6IunAsQMoDQcBOj6AxOXeTo','2','2022-07-24 08:19:59',24,NULL,26),(156,26,'100','10505.00','osnBC6IunAsQMoDQcBOj6AxOXeTo','2','2022-07-24 08:32:47',24,NULL,26),(157,26,'100','10405.00','osnBC6IunAsQMoDQcBOj6AxOXeTo','2','2022-07-24 08:34:18',24,NULL,26),(158,26,'100','10305.00','osnBC6PClJ9-3zmG_L5oivXsF8Rc','2','2022-07-26 09:33:12',24,NULL,26),(159,26,'100','10205.00','osnBC6EU4o6kZu1vfFq2XoXe1ikc','2','2022-07-27 05:43:51',24,NULL,26),(160,30,'5','827.50','oAM70s9FLl798Nr6WGMFluFSrpOY','2','2022-07-27 07:21:10',27,NULL,32),(161,30,'5','822.50','oAM70s9FLl798Nr6WGMFluFSrpOY','2','2022-07-27 08:34:14',27,NULL,32),(162,30,'5','817.50','oAM70s9FLl798Nr6WGMFluFSrpOY','2','2022-07-27 10:28:46',27,NULL,32),(163,30,'5','812.50','oAM70s9FLl798Nr6WGMFluFSrpOY','2','2022-07-27 10:29:52',27,NULL,32),(164,30,'5','807.50','oAM70s9FLl798Nr6WGMFluFSrpOY','2','2022-07-27 10:30:38',27,NULL,32),(165,30,'5','802.50','oAM70s9FLl798Nr6WGMFluFSrpOY','2','2022-07-27 10:32:17',27,NULL,32),(166,30,'5','797.50','oAM70s9FLl798Nr6WGMFluFSrpOY','2','2022-07-27 10:33:47',27,NULL,32),(167,30,'5','792.50','oAM70s9FLl798Nr6WGMFluFSrpOY','2','2022-07-27 10:35:52',27,NULL,32),(168,30,'5','787.50','oAM70s9FLl798Nr6WGMFluFSrpOY','2','2022-07-27 10:38:11',27,NULL,32),(169,30,'5','782.50','oAM70s9FLl798Nr6WGMFluFSrpOY','2','2022-07-27 10:39:06',27,NULL,32),(170,30,'5','777.50','oAM70s9FLl798Nr6WGMFluFSrpOY','2','2022-07-27 10:40:26',27,NULL,32),(171,26,'100','10105.00','osnBC6EU4o6kZu1vfFq2XoXe1ikc','2','2022-07-28 06:45:21',24,NULL,26),(172,26,'100','10005.00','osnBC6PClJ9-3zmG_L5oivXsF8Rc','2','2022-07-29 06:09:56',24,NULL,26),(173,30,'10','767.50','oAM70s9kyurxxwg6G0W-VFynCWb0','2','2022-07-30 01:34:32',25,NULL,34),(174,30,'10','757.50','oAM70s9kyurxxwg6G0W-VFynCWb0','2','2022-07-30 01:35:16',25,NULL,34),(175,30,'5','752.50','oAM70s9kyurxxwg6G0W-VFynCWb0','2','2022-07-30 01:39:19',27,NULL,32),(176,30,'5','747.50','oAM70s9kyurxxwg6G0W-VFynCWb0','2','2022-07-30 01:40:34',27,NULL,32),(177,30,'5','742.50','oAM70s9kyurxxwg6G0W-VFynCWb0','2','2022-07-30 01:41:41',27,NULL,32),(178,30,'5','737.50','oAM70s9kyurxxwg6G0W-VFynCWb0','2','2022-07-30 01:42:15',27,NULL,32),(179,30,'5','732.50','oAM70s9kyurxxwg6G0W-VFynCWb0','2','2022-07-30 01:42:55',27,NULL,32),(180,30,'5','727.50','oAM70s9kyurxxwg6G0W-VFynCWb0','2','2022-07-30 01:44:08',27,NULL,32),(181,30,'5','722.50','oAM70s9kyurxxwg6G0W-VFynCWb0','2','2022-07-30 01:44:39',27,NULL,32),(182,30,'5','717.50','oAM70s9kyurxxwg6G0W-VFynCWb0','2','2022-07-30 01:45:57',27,NULL,32),(183,30,'5','712.50','oAM70s9kyurxxwg6G0W-VFynCWb0','2','2022-07-30 01:46:28',27,NULL,32),(184,30,'5','707.50','oAM70s9kyurxxwg6G0W-VFynCWb0','2','2022-07-30 01:47:42',27,NULL,32),(185,30,'5','702.50','oAM70s9kyurxxwg6G0W-VFynCWb0','2','2022-07-30 01:48:18',27,NULL,32),(186,26,'100','9905.00','osnBC6PClJ9-3zmG_L5oivXsF8Rc','2','2022-07-30 04:23:03',24,NULL,26),(187,30,'5','697.50','oAM70s9FLl798Nr6WGMFluFSrpOY','2','2022-07-30 09:33:06',27,NULL,32),(188,30,'5','692.50','oAM70s9FLl798Nr6WGMFluFSrpOY','2','2022-07-30 09:34:09',27,NULL,32),(189,26,'100','9805.00','osnBC6PClJ9-3zmG_L5oivXsF8Rc','2','2022-08-02 01:27:58',24,NULL,26),(190,30,'5','687.50','oAM70s7RsRAMknca5eHiEOqTVAR4','2','2022-08-03 04:17:26',27,NULL,32),(191,30,'5','682.50','oAM70s7RsRAMknca5eHiEOqTVAR4','2','2022-08-03 04:19:33',27,NULL,32),(192,30,'10','672.50','oAM70s7RsRAMknca5eHiEOqTVAR4','2','2022-08-03 05:26:57',25,NULL,34),(193,30,'10','662.50','oAM70s7RsRAMknca5eHiEOqTVAR4','2','2022-08-03 05:27:51',25,NULL,34),(194,30,'5','657.50','oAM70s7RsRAMknca5eHiEOqTVAR4','2','2022-08-03 08:00:12',27,NULL,32),(195,30,'5','652.50','oAM70s7RsRAMknca5eHiEOqTVAR4','2','2022-08-03 08:00:51',27,NULL,32),(196,30,'5','647.50','oAM70s-oM6LpN6oLASvSVvmMXGMk','2','2022-08-05 13:55:40',27,NULL,32),(197,30,'5','642.50','oAM70s-oM6LpN6oLASvSVvmMXGMk','2','2022-08-05 13:56:05',27,NULL,32),(198,30,'5','637.50','oAM70s-oM6LpN6oLASvSVvmMXGMk','2','2022-08-05 13:56:41',27,NULL,32),(199,30,'5','632.50','oAM70s-oM6LpN6oLASvSVvmMXGMk','2','2022-08-05 13:57:56',27,NULL,32),(200,30,'5','627.50','oAM70s-oM6LpN6oLASvSVvmMXGMk','2','2022-08-05 13:59:07',27,NULL,32),(201,30,'5','622.50','oAM70s-oM6LpN6oLASvSVvmMXGMk','2','2022-08-05 13:59:44',27,NULL,32),(202,30,'5','617.50','oAM70s-oM6LpN6oLASvSVvmMXGMk','2','2022-08-05 14:00:21',27,NULL,32),(203,30,'5','612.50','oAM70s-oM6LpN6oLASvSVvmMXGMk','2','2022-08-05 14:00:55',27,NULL,32),(204,30,'5','607.50','oAM70s-oM6LpN6oLASvSVvmMXGMk','2','2022-08-05 14:01:34',27,NULL,32),(205,30,'5','602.50','oAM70s-oM6LpN6oLASvSVvmMXGMk','2','2022-08-05 14:01:53',27,NULL,32),(206,30,'5','597.50','oAM70s-oM6LpN6oLASvSVvmMXGMk','2','2022-08-05 14:02:23',27,NULL,32),(207,30,'5','592.50','oAM70s-oM6LpN6oLASvSVvmMXGMk','2','2022-08-05 14:03:16',27,NULL,32),(208,30,'5','587.50','oAM70s-oM6LpN6oLASvSVvmMXGMk','2','2022-08-05 14:04:03',27,NULL,32),(209,30,'5','582.50','oAM70s-oM6LpN6oLASvSVvmMXGMk','2','2022-08-05 14:04:39',27,NULL,32),(210,30,'5','577.50','oAM70s-oM6LpN6oLASvSVvmMXGMk','2','2022-08-05 14:05:13',27,NULL,32),(211,30,'5','572.50','oAM70s-oM6LpN6oLASvSVvmMXGMk','2','2022-08-05 14:05:38',27,NULL,32),(212,30,'5','567.50','oAM70s-oM6LpN6oLASvSVvmMXGMk','2','2022-08-05 14:06:10',27,NULL,32),(213,30,'5','562.50','oAM70s3F2wxRR6hV4usgaH_gD0gw','2','2022-08-06 01:59:27',27,NULL,32),(214,26,'100','9705.00','osnBC6PClJ9-3zmG_L5oivXsF8Rc','2','2022-08-07 06:19:00',24,NULL,26),(215,30,'5','557.50','oAM70s3f8DhWov19fCsJq9ULTGoY','2','2022-08-07 07:02:27',27,NULL,32),(216,30,'5','552.50','oAM70s3f8DhWov19fCsJq9ULTGoY','2','2022-08-07 07:10:56',27,NULL,32),(217,30,'5','547.50','oAM70s3f8DhWov19fCsJq9ULTGoY','2','2022-08-07 07:11:34',27,NULL,32),(218,30,'5','542.50','oAM70s3f8DhWov19fCsJq9ULTGoY','2','2022-08-07 07:12:13',27,NULL,32),(219,30,'5','537.50','oAM70s3f8DhWov19fCsJq9ULTGoY','2','2022-08-07 07:12:32',27,NULL,32),(220,30,'5','532.50','oAM70s3f8DhWov19fCsJq9ULTGoY','2','2022-08-07 07:12:52',27,NULL,32),(221,30,'5','527.50','oAM70s3f8DhWov19fCsJq9ULTGoY','2','2022-08-07 07:13:14',27,NULL,32),(222,26,'100','9605.00','osnBC6PClJ9-3zmG_L5oivXsF8Rc','2','2022-08-09 00:16:52',24,NULL,26),(223,26,'100','9505.00','osnBC6PClJ9-3zmG_L5oivXsF8Rc','2','2022-08-09 01:14:34',24,NULL,26),(224,26,'100','9405.00','osnBC6G1pMUXYyVdBP6BctHXsTDc','2','2022-08-09 03:45:29',24,NULL,26),(225,30,'5','522.50','oAM70s2PQ8b0ZUXlpGx0n7WRdRbU','2','2022-08-09 09:27:36',27,NULL,32),(226,30,'5','517.50','oAM70s2PQ8b0ZUXlpGx0n7WRdRbU','2','2022-08-09 09:28:12',27,NULL,32),(227,30,'5','512.50','oAM70s2PQ8b0ZUXlpGx0n7WRdRbU','2','2022-08-09 09:34:11',27,NULL,32),(228,30,'5','507.50','oAM70s2PQ8b0ZUXlpGx0n7WRdRbU','2','2022-08-09 09:36:22',27,NULL,32),(229,30,'5','502.50','oAM70s2PQ8b0ZUXlpGx0n7WRdRbU','2','2022-08-09 09:36:40',27,NULL,32),(230,30,'5','497.50','oAM70s2PQ8b0ZUXlpGx0n7WRdRbU','2','2022-08-09 09:37:12',27,NULL,32),(231,30,'5','492.50','oAM70s2PQ8b0ZUXlpGx0n7WRdRbU','2','2022-08-09 09:37:51',27,NULL,32),(232,30,'5','487.50','oAM70s2PQ8b0ZUXlpGx0n7WRdRbU','2','2022-08-09 09:38:09',27,NULL,32),(233,30,'5','482.50','oAM70s_8482ryKTfEa2Qj64JhOsI','2','2022-08-10 03:26:07',27,NULL,32),(234,30,'5','477.50','oAM70s_8482ryKTfEa2Qj64JhOsI','2','2022-08-10 03:26:45',27,NULL,32),(235,30,'5','472.50','oAM70s_8482ryKTfEa2Qj64JhOsI','2','2022-08-10 03:27:10',27,NULL,32),(236,30,'5','467.50','oAM70s_8482ryKTfEa2Qj64JhOsI','2','2022-08-10 03:27:28',27,NULL,32),(237,30,'5','462.50','oAM70s_8482ryKTfEa2Qj64JhOsI','2','2022-08-10 03:27:43',27,NULL,32),(238,30,'5','457.50','oAM70s_8482ryKTfEa2Qj64JhOsI','2','2022-08-10 03:28:00',27,NULL,32),(239,30,'10','447.50','oAM70s_8482ryKTfEa2Qj64JhOsI','2','2022-08-10 03:28:28',25,NULL,29),(240,30,'10','437.50','oAM70s_8482ryKTfEa2Qj64JhOsI','2','2022-08-11 00:29:18',25,NULL,34),(241,26,'100','9305.00','osnBC6NGNcbzMoXdIzIlf5_ZqmVg','2','2022-08-12 00:25:33',24,NULL,26),(242,26,'100','9205.00','osnBC6FACNp9WSVqECGve-Q8OjnU','2','2022-08-12 23:09:27',24,NULL,26),(243,26,'100','9105.00','osnBC6FACNp9WSVqECGve-Q8OjnU','2','2022-08-12 23:10:13',24,NULL,26),(244,30,'10','427.50','oAM70s_8482ryKTfEa2Qj64JhOsI','2','2022-08-16 08:25:14',25,NULL,34),(245,30,'5','422.50','oAM70s8lKMo7TNF642S2Rpgsf3SY','2','2022-08-16 09:44:57',27,NULL,32),(246,30,'10','412.50','oAM70s8lKMo7TNF642S2Rpgsf3SY','2','2022-08-16 09:45:34',25,NULL,34),(247,30,'5','407.50','oAM70s8lKMo7TNF642S2Rpgsf3SY','2','2022-08-16 09:46:57',27,NULL,32),(248,30,'5','402.50','oAM70s8lKMo7TNF642S2Rpgsf3SY','2','2022-08-16 09:47:32',27,NULL,32),(249,30,'5','397.50','oAM70s8lKMo7TNF642S2Rpgsf3SY','2','2022-08-16 09:48:13',27,NULL,32),(250,30,'10','387.50','oAM70s8lKMo7TNF642S2Rpgsf3SY','2','2022-08-16 09:48:47',25,NULL,34),(251,30,'10','377.50','oAM70s8lKMo7TNF642S2Rpgsf3SY','2','2022-08-16 09:49:19',25,NULL,34),(252,30,'10','367.50','oAM70s8lKMo7TNF642S2Rpgsf3SY','2','2022-08-16 09:49:52',25,NULL,34),(253,30,'10','357.50','oAM70s8lKMo7TNF642S2Rpgsf3SY','2','2022-08-16 09:50:22',25,NULL,34),(254,30,'10','347.50','oAM70s8lKMo7TNF642S2Rpgsf3SY','2','2022-08-16 09:51:10',25,NULL,34),(255,30,'10','337.50','oAM70s8lKMo7TNF642S2Rpgsf3SY','2','2022-08-16 09:51:43',25,NULL,34),(256,30,'10','327.50','oAM70s8lKMo7TNF642S2Rpgsf3SY','2','2022-08-16 09:52:14',25,NULL,34),(257,30,'10','317.50','oAM70s8lKMo7TNF642S2Rpgsf3SY','2','2022-08-16 09:52:49',25,NULL,34),(258,30,'10','307.50','oAM70s8lKMo7TNF642S2Rpgsf3SY','2','2022-08-16 09:53:45',25,NULL,34),(259,30,'5','302.50','oAM70s8lKMo7TNF642S2Rpgsf3SY','2','2022-08-16 09:54:29',27,NULL,32),(260,30,'5','297.50','oAM70s8lKMo7TNF642S2Rpgsf3SY','2','2022-08-16 09:55:00',27,NULL,32),(261,30,'5','292.50','oAM70s8lKMo7TNF642S2Rpgsf3SY','2','2022-08-16 09:55:34',27,NULL,32),(262,30,'5','287.50','oAM70s8lKMo7TNF642S2Rpgsf3SY','2','2022-08-16 09:56:41',27,NULL,32),(263,30,'5','282.50','oAM70s8lKMo7TNF642S2Rpgsf3SY','2','2022-08-16 09:57:15',27,NULL,32),(264,30,'5','277.50','oAM70s8lKMo7TNF642S2Rpgsf3SY','2','2022-08-16 09:57:51',27,NULL,32),(265,30,'5','272.50','oAM70s8lKMo7TNF642S2Rpgsf3SY','2','2022-08-16 09:58:23',27,NULL,32),(266,30,'5','267.50','oAM70s8lKMo7TNF642S2Rpgsf3SY','2','2022-08-16 09:59:00',27,NULL,32),(267,30,'5','262.50','oAM70s8lKMo7TNF642S2Rpgsf3SY','2','2022-08-16 09:59:31',27,NULL,32),(268,30,'5','257.50','oAM70s8lKMo7TNF642S2Rpgsf3SY','2','2022-08-16 10:00:02',27,NULL,32),(269,30,'5','252.50','oAM70s8lKMo7TNF642S2Rpgsf3SY','2','2022-08-16 10:00:33',27,NULL,32),(270,30,'5','247.50','oAM70s8lKMo7TNF642S2Rpgsf3SY','2','2022-08-16 10:01:09',27,NULL,32),(271,30,'5','242.50','oAM70s8lKMo7TNF642S2Rpgsf3SY','2','2022-08-16 10:01:41',27,NULL,32),(272,30,'5','237.50','oAM70s8lKMo7TNF642S2Rpgsf3SY','2','2022-08-16 10:02:12',27,NULL,32),(273,30,'5','232.50','oAM70s8lKMo7TNF642S2Rpgsf3SY','2','2022-08-16 10:02:58',27,NULL,32),(274,30,'5','227.50','oAM70s8lKMo7TNF642S2Rpgsf3SY','2','2022-08-16 10:03:33',27,NULL,32),(275,30,'5','222.50','oAM70s8lKMo7TNF642S2Rpgsf3SY','2','2022-08-16 10:04:13',27,NULL,32),(276,30,'5','217.50','oAM70s8lKMo7TNF642S2Rpgsf3SY','2','2022-08-16 10:04:47',27,NULL,32),(277,30,'5','212.50','oAM70s8lKMo7TNF642S2Rpgsf3SY','2','2022-08-16 10:05:20',27,NULL,32),(278,30,'5','207.50','oAM70s8lKMo7TNF642S2Rpgsf3SY','2','2022-08-16 10:05:56',27,NULL,32),(279,30,'5','202.50','oAM70s8lKMo7TNF642S2Rpgsf3SY','2','2022-08-16 10:06:31',27,NULL,32),(280,30,'5','197.50','oAM70s8lKMo7TNF642S2Rpgsf3SY','2','2022-08-16 10:07:02',27,NULL,32),(281,30,'5','192.50','oAM70s8lKMo7TNF642S2Rpgsf3SY','2','2022-08-16 10:07:35',27,NULL,32),(282,30,'5','187.50','oAM70s8lKMo7TNF642S2Rpgsf3SY','2','2022-08-16 10:08:06',27,NULL,32),(283,30,'5','182.50','oAM70s8lKMo7TNF642S2Rpgsf3SY','2','2022-08-16 10:08:36',27,NULL,32),(284,30,'5','177.50','oAM70s8lKMo7TNF642S2Rpgsf3SY','2','2022-08-16 10:09:29',27,NULL,32),(285,30,'5','172.50','oAM70s8lKMo7TNF642S2Rpgsf3SY','2','2022-08-16 10:10:05',27,NULL,32),(286,30,'5','167.50','oAM70s8lKMo7TNF642S2Rpgsf3SY','2','2022-08-16 10:10:36',27,NULL,32),(287,30,'5','162.50','oAM70s8lKMo7TNF642S2Rpgsf3SY','2','2022-08-16 10:11:08',27,NULL,32),(288,30,'5','157.50','oAM70s8lKMo7TNF642S2Rpgsf3SY','2','2022-08-16 10:11:42',27,NULL,32),(289,30,'5','152.50','oAM70s8lKMo7TNF642S2Rpgsf3SY','2','2022-08-16 10:12:17',27,NULL,32),(290,30,'5','147.50','oAM70s8lKMo7TNF642S2Rpgsf3SY','2','2022-08-16 10:13:30',27,NULL,32),(291,30,'5','142.50','oAM70s8lKMo7TNF642S2Rpgsf3SY','2','2022-08-16 10:14:16',27,NULL,32),(292,30,'5','137.50','oAM70s8lKMo7TNF642S2Rpgsf3SY','2','2022-08-16 10:14:49',27,NULL,32),(293,30,'5','132.50','oAM70s8lKMo7TNF642S2Rpgsf3SY','2','2022-08-16 10:15:25',27,NULL,32),(294,30,'5','127.50','oAM70s8lKMo7TNF642S2Rpgsf3SY','2','2022-08-16 10:15:57',27,NULL,32),(295,30,'5','122.50','oAM70s8lKMo7TNF642S2Rpgsf3SY','2','2022-08-16 10:16:35',27,NULL,32),(296,30,'5','117.50','oAM70s8lKMo7TNF642S2Rpgsf3SY','2','2022-08-16 10:17:11',27,NULL,32),(297,30,'5','112.50','oAM70s8lKMo7TNF642S2Rpgsf3SY','2','2022-08-16 10:17:51',27,NULL,32),(298,30,'5','107.50','oAM70s8lKMo7TNF642S2Rpgsf3SY','2','2022-08-16 10:18:27',27,NULL,32),(299,30,'5','102.50','oAM70s8lKMo7TNF642S2Rpgsf3SY','2','2022-08-16 10:19:39',27,NULL,32),(300,30,'10','92.50','oAM70s8lKMo7TNF642S2Rpgsf3SY','2','2022-08-19 03:45:49',25,NULL,29),(301,30,'10','82.50','oAM70s8lKMo7TNF642S2Rpgsf3SY','2','2022-08-19 06:33:12',25,NULL,34),(302,30,'5','77.50','oAM70s8lKMo7TNF642S2Rpgsf3SY','2','2022-08-19 06:33:52',27,NULL,32),(303,30,'10','67.50','oAM70s8lKMo7TNF642S2Rpgsf3SY','2','2022-08-19 06:34:51',25,NULL,34),(304,30,'10','57.50','oAM70s8lKMo7TNF642S2Rpgsf3SY','2','2022-08-19 06:36:27',25,NULL,29),(305,30,'5','52.50','oAM70s8lKMo7TNF642S2Rpgsf3SY','2','2022-08-19 06:40:41',27,NULL,32),(306,30,'5','47.50','oAM70s8lKMo7TNF642S2Rpgsf3SY','2','2022-08-19 06:41:15',27,NULL,32),(307,30,'5','42.50','oAM70s8lKMo7TNF642S2Rpgsf3SY','2','2022-08-19 06:46:47',27,NULL,32),(308,30,'10','32.50','oAM70s_8482ryKTfEa2Qj64JhOsI','2','2022-08-19 09:04:34',25,NULL,29),(309,30,'5','27.50','oAM70s_8482ryKTfEa2Qj64JhOsI','2','2022-08-19 09:05:14',27,NULL,32),(310,30,'5','22.50','oAM70s_8482ryKTfEa2Qj64JhOsI','2','2022-08-19 09:05:52',27,NULL,32),(311,26,'100','9005.00','osnBC6FtEB5yxhCS7YMv2xLC_Osk','2','2022-08-19 09:14:30',24,NULL,26),(312,26,'100','8905.00','osnBC6FtEB5yxhCS7YMv2xLC_Osk','2','2022-08-19 09:16:49',24,NULL,26),(313,26,'100','8805.00','osnBC6FtEB5yxhCS7YMv2xLC_Osk','2','2022-08-19 09:19:03',24,NULL,26),(314,26,'100','8705.00','osnBC6FtEB5yxhCS7YMv2xLC_Osk','2','2022-08-19 09:20:51',24,NULL,26),(315,26,'100','8605.00','osnBC6FtEB5yxhCS7YMv2xLC_Osk','2','2022-08-19 23:50:39',24,NULL,26),(316,26,'100','8505.00','osnBC6FtEB5yxhCS7YMv2xLC_Osk','2','2022-08-19 23:51:59',24,NULL,26),(317,26,'100','8405.00','osnBC6BoUdhxFsKA7svNBoPbkKJk','2','2022-08-22 03:40:49',24,NULL,26),(318,26,'100','8305.00','osnBC6BoUdhxFsKA7svNBoPbkKJk','2','2022-08-22 03:41:55',24,NULL,26),(319,30,'10','12.50','oAM70sxkg4-8ZBgF57YKtpGc7cVo','2','2022-08-22 03:43:45',25,NULL,29),(320,30,'10','2.50','oAM70s8lKMo7TNF642S2Rpgsf3SY','2','2022-08-22 03:44:12',25,NULL,34),(321,26,'100','8205.00','osnBC6KENiLE752YjXcEyL9Olm-0','2','2022-08-23 08:18:37',24,NULL,26),(322,26,'100','8105.00','osnBC6FtEB5yxhCS7YMv2xLC_Osk','2','2022-08-24 00:10:11',24,NULL,26),(323,26,'100','8005.00','osnBC6PlHzXAM0EFeQXFhoqdDjBA','2','2022-08-24 07:02:04',24,NULL,26),(324,26,'100','7905.00','osnBC6PlHzXAM0EFeQXFhoqdDjBA','2','2022-08-24 07:03:00',24,NULL,26),(325,26,'100','7805.00','osnBC6IunAsQMoDQcBOj6AxOXeTo','2','2022-08-27 06:38:15',24,NULL,26),(326,26,'100','7705.00','osnBC6IunAsQMoDQcBOj6AxOXeTo','2','2022-08-27 06:42:29',24,NULL,26),(327,26,'100','7605.00','osnBC6IunAsQMoDQcBOj6AxOXeTo','2','2022-08-27 06:44:38',24,NULL,26),(328,30,'10','1992.50','oAM70szwIICtYtQauw8wdvgQk0FU','2','2022-08-31 04:37:23',25,NULL,34),(329,30,'10','1982.50','oAM70s8lKMo7TNF642S2Rpgsf3SY','2','2022-08-31 08:30:05',25,NULL,29),(330,30,'10','1972.50','oAM70s8lKMo7TNF642S2Rpgsf3SY','2','2022-08-31 08:30:36',25,NULL,29),(331,30,'10','1962.50','oAM70s8lKMo7TNF642S2Rpgsf3SY','2','2022-08-31 08:31:08',25,NULL,29),(332,30,'10','1952.50','oAM70s8lKMo7TNF642S2Rpgsf3SY','2','2022-08-31 08:31:54',25,NULL,29),(333,30,'10','1942.50','oAM70s8lKMo7TNF642S2Rpgsf3SY','2','2022-08-31 08:32:25',25,NULL,29),(334,30,'10','1932.50','oAM70s8lKMo7TNF642S2Rpgsf3SY','2','2022-08-31 08:32:58',25,NULL,29),(335,30,'5','1927.50','oAM70s8lKMo7TNF642S2Rpgsf3SY','2','2022-08-31 08:34:07',27,NULL,32),(336,30,'5','1922.50','oAM70s8lKMo7TNF642S2Rpgsf3SY','2','2022-08-31 08:34:39',27,NULL,32),(337,30,'5','1917.50','oAM70s8lKMo7TNF642S2Rpgsf3SY','2','2022-08-31 08:36:58',27,NULL,32),(338,30,'5','1912.50','oAM70s8lKMo7TNF642S2Rpgsf3SY','2','2022-08-31 08:38:08',27,NULL,32),(339,30,'5','1907.50','oAM70s8lKMo7TNF642S2Rpgsf3SY','2','2022-08-31 08:39:46',27,NULL,32),(340,30,'5','1902.50','oAM70s8lKMo7TNF642S2Rpgsf3SY','2','2022-08-31 08:41:23',27,NULL,32),(341,30,'5','1897.50','oAM70s8lKMo7TNF642S2Rpgsf3SY','2','2022-08-31 08:42:23',27,NULL,32),(342,30,'5','1892.50','oAM70s8lKMo7TNF642S2Rpgsf3SY','2','2022-08-31 08:43:29',27,NULL,32),(343,30,'5','1887.50','oAM70s8lKMo7TNF642S2Rpgsf3SY','2','2022-08-31 08:46:00',27,NULL,32),(344,30,'5','1882.50','oAM70s8lKMo7TNF642S2Rpgsf3SY','2','2022-08-31 08:46:40',27,NULL,32),(345,30,'10','1872.50','oAM70s3f8DhWov19fCsJq9ULTGoY','2','2022-08-31 09:40:43',25,NULL,34),(346,26,'100','7505.00','osnBC6PlHzXAM0EFeQXFhoqdDjBA','2','2022-09-01 03:06:54',24,NULL,26),(347,26,'100','7405.00','osnBC6PlHzXAM0EFeQXFhoqdDjBA','2','2022-09-01 03:09:32',24,NULL,26),(348,30,'5','1867.50','oAM70s3f8DhWov19fCsJq9ULTGoY','2','2022-09-01 03:37:22',27,NULL,32),(349,30,'5','1862.50','oAM70s3f8DhWov19fCsJq9ULTGoY','2','2022-09-01 03:38:29',27,NULL,32),(350,30,'5','1857.50','oAM70s3f8DhWov19fCsJq9ULTGoY','2','2022-09-01 05:12:59',27,NULL,32),(351,30,'5','1852.50','oAM70s3f8DhWov19fCsJq9ULTGoY','2','2022-09-01 05:14:08',27,NULL,32),(352,30,'5','1847.50','oAM70s3f8DhWov19fCsJq9ULTGoY','2','2022-09-01 05:16:06',27,NULL,32),(353,30,'5','1842.50','oAM70s3f8DhWov19fCsJq9ULTGoY','2','2022-09-01 05:16:43',27,NULL,32),(354,30,'5','1837.50','oAM70s3f8DhWov19fCsJq9ULTGoY','2','2022-09-01 05:17:21',27,NULL,32),(355,30,'5','1832.50','oAM70s3f8DhWov19fCsJq9ULTGoY','2','2022-09-01 05:19:19',27,NULL,32),(356,30,'10','1822.50','oAM70s2PQ8b0ZUXlpGx0n7WRdRbU','2','2022-09-01 14:17:23',25,NULL,29),(357,30,'10','1812.50','oAM70s2PQ8b0ZUXlpGx0n7WRdRbU','2','2022-09-01 14:17:40',25,NULL,34),(358,30,'10','1802.50','oAM70s2PQ8b0ZUXlpGx0n7WRdRbU','2','2022-09-01 14:18:02',25,NULL,29),(359,30,'10','1792.50','oAM70s2PQ8b0ZUXlpGx0n7WRdRbU','2','2022-09-01 14:18:23',25,NULL,34),(360,30,'10','1782.50','oAM70s2PQ8b0ZUXlpGx0n7WRdRbU','2','2022-09-01 14:18:42',25,NULL,29),(361,30,'10','1772.50','oAM70s2PQ8b0ZUXlpGx0n7WRdRbU','2','2022-09-01 14:19:24',25,NULL,29),(362,30,'5','1767.50','oAM70s2PQ8b0ZUXlpGx0n7WRdRbU','2','2022-09-01 14:20:33',27,NULL,32),(363,30,'5','1762.50','oAM70s2PQ8b0ZUXlpGx0n7WRdRbU','2','2022-09-01 14:20:47',27,NULL,32),(364,30,'5','1757.50','oAM70s2PQ8b0ZUXlpGx0n7WRdRbU','2','2022-09-01 14:21:01',27,NULL,32),(365,30,'5','1752.50','oAM70s2PQ8b0ZUXlpGx0n7WRdRbU','2','2022-09-01 14:21:14',27,NULL,32),(366,30,'5','1747.50','oAM70s2PQ8b0ZUXlpGx0n7WRdRbU','2','2022-09-01 14:21:28',27,NULL,32),(367,30,'10','1737.50','oAM70s8lKMo7TNF642S2Rpgsf3SY','2','2022-09-02 06:24:35',25,NULL,34),(368,30,'5','1732.50','oAM70s8lKMo7TNF642S2Rpgsf3SY','2','2022-09-02 06:25:42',27,NULL,32),(369,30,'5','1727.50','oAM70s8lKMo7TNF642S2Rpgsf3SY','2','2022-09-02 06:26:45',27,NULL,32),(370,30,'10','1717.50','oAM70s8lKMo7TNF642S2Rpgsf3SY','2','2022-09-02 06:27:32',25,NULL,34),(371,30,'5','1712.50','oAM70s8lKMo7TNF642S2Rpgsf3SY','2','2022-09-02 06:28:04',27,NULL,32),(372,30,'5','1707.50','oAM70s8lKMo7TNF642S2Rpgsf3SY','2','2022-09-02 06:28:35',27,NULL,32),(373,30,'5','1702.50','oAM70s8lKMo7TNF642S2Rpgsf3SY','2','2022-09-02 06:29:36',27,NULL,32),(374,30,'5','1697.50','oAM70s8lKMo7TNF642S2Rpgsf3SY','2','2022-09-02 06:30:09',27,NULL,32),(375,30,'5','1692.50','oAM70s8lKMo7TNF642S2Rpgsf3SY','2','2022-09-02 06:30:50',27,NULL,32),(376,30,'10','1682.50','oAM70s8lKMo7TNF642S2Rpgsf3SY','2','2022-09-02 06:31:28',25,NULL,29),(377,30,'5','1677.50','oAM70s8lKMo7TNF642S2Rpgsf3SY','2','2022-09-02 06:32:32',27,NULL,32),(378,30,'5','1672.50','oAM70s8lKMo7TNF642S2Rpgsf3SY','2','2022-09-02 06:33:03',27,NULL,32),(379,30,'5','1667.50','oAM70s8lKMo7TNF642S2Rpgsf3SY','2','2022-09-02 06:33:34',27,NULL,32),(380,30,'5','1662.50','oAM70s8lKMo7TNF642S2Rpgsf3SY','2','2022-09-02 06:34:09',27,NULL,32),(381,30,'5','1657.50','oAM70s8lKMo7TNF642S2Rpgsf3SY','2','2022-09-02 06:34:41',27,NULL,32),(382,30,'10','1647.50','oAM70s8lKMo7TNF642S2Rpgsf3SY','2','2022-09-02 06:35:19',25,NULL,29),(383,30,'5','1642.50','oAM70s8lKMo7TNF642S2Rpgsf3SY','2','2022-09-02 06:36:22',27,NULL,32),(384,30,'5','1637.50','oAM70s8lKMo7TNF642S2Rpgsf3SY','2','2022-09-02 06:37:36',27,NULL,32),(385,30,'5','1632.50','oAM70s8lKMo7TNF642S2Rpgsf3SY','2','2022-09-02 06:38:40',27,NULL,32),(386,26,'100','7305.00','osnBC6HAYZAZxqGuxVyf2qLnC8W0','2','2022-09-02 06:49:39',24,NULL,26),(387,26,'100','7205.00','osnBC6HAYZAZxqGuxVyf2qLnC8W0','2','2022-09-02 06:51:39',24,NULL,26);
/*!40000 ALTER TABLE `ctc_redpool_issue_record` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ctc_redpool_recharge_record`
--

DROP TABLE IF EXISTS `ctc_redpool_recharge_record`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ctc_redpool_recharge_record` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `money` varchar(255) DEFAULT NULL COMMENT '充值金额',
  `balance` varchar(255) DEFAULT NULL COMMENT '余额',
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `create_by` varchar(255) DEFAULT NULL,
  `dealer_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=23 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ctc_redpool_recharge_record`
--

LOCK TABLES `ctc_redpool_recharge_record` WRITE;
/*!40000 ALTER TABLE `ctc_redpool_recharge_record` DISABLE KEYS */;
INSERT INTO `ctc_redpool_recharge_record` VALUES (13,'5','5.00','2022-05-24 03:10:34',NULL,27),(14,'5','5.00','2022-05-27 07:52:51',NULL,26),(15,'5','5.00','2022-05-30 01:29:10',NULL,30),(16,'100','100.00','2022-06-10 01:40:31',NULL,29),(17,'1000','1002.50','2022-06-13 07:28:27',NULL,30),(18,'12000','12005.00','2022-06-13 09:19:20',NULL,26),(19,'2','2.00','2022-06-20 01:28:52',NULL,32),(20,'2','2.00','2022-06-20 01:32:59',NULL,31),(21,'1000','1001.70','2022-08-11 07:48:51',NULL,31),(22,'2000','2002.50','2022-08-31 03:19:09',NULL,30);
/*!40000 ALTER TABLE `ctc_redpool_recharge_record` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ctc_role`
--

DROP TABLE IF EXISTS `ctc_role`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
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
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ctc_role`
--

LOCK TABLES `ctc_role` WRITE;
/*!40000 ALTER TABLE `ctc_role` DISABLE KEYS */;
INSERT INTO `ctc_role` VALUES (1,'admin','admin','1','1','超级管理员','0','2021-10-06 14:52:35',NULL,NULL,'6,8,37,38,9,39,40,10,11,41,42,43,44,45,46,47,48,49,12,50,51,52,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,29,30,31,32,33,34,35,36,53,54,55','1','1'),(3,'普通角色','common','1','0','普通角色','0','2021-10-06 14:54:09',NULL,NULL,'6,8','1','1');
/*!40000 ALTER TABLE `ctc_role` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ctc_role_copy`
--

DROP TABLE IF EXISTS `ctc_role_copy`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
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
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ctc_role_copy`
--

LOCK TABLES `ctc_role_copy` WRITE;
/*!40000 ALTER TABLE `ctc_role_copy` DISABLE KEYS */;
INSERT INTO `ctc_role_copy` VALUES (1,'admin','admin','1','1','超级管理员','0','2021-10-06 14:52:35',NULL,NULL,'6,8,37,38,9,39,40,10,11,41,42,43,44,45,46,47,48,49,12,50,51,52,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,29,30,31,32,33,34,35,36,53,54,55','1','1'),(3,'普通角色','common','1','0','普通角色','0','2021-10-06 14:54:09',NULL,NULL,'6,8','1','1');
/*!40000 ALTER TABLE `ctc_role_copy` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ctc_security_auth`
--

DROP TABLE IF EXISTS `ctc_security_auth`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ctc_security_auth` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `dealer_id` int(11) DEFAULT NULL,
  `security_template` int(11) DEFAULT NULL,
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime DEFAULT NULL,
  `create_by` varchar(255) DEFAULT NULL,
  `status` tinyint(4) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ctc_security_auth`
--

LOCK TABLES `ctc_security_auth` WRITE;
/*!40000 ALTER TABLE `ctc_security_auth` DISABLE KEYS */;
/*!40000 ALTER TABLE `ctc_security_auth` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ctc_security_template`
--

DROP TABLE IF EXISTS `ctc_security_template`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
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
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ctc_security_template`
--

LOCK TABLES `ctc_security_template` WRITE;
/*!40000 ALTER TABLE `ctc_security_template` DISABLE KEYS */;
INSERT INTO `ctc_security_template` VALUES (1,'默认模版','您好，您所查询的是@品牌商名称@生产的产品，请放心使用！',_binary '1','该防伪码已经被人查询过，首次查询时间：@查询时间@，谨防假冒!','2021-10-10 15:57:37',NULL);
/*!40000 ALTER TABLE `ctc_security_template` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ctc_sms`
--

DROP TABLE IF EXISTS `ctc_sms`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ctc_sms` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `sms_count` int(11) DEFAULT NULL,
  `sms_cost` varchar(255) DEFAULT NULL COMMENT '成本价',
  `sms_retail` varchar(255) DEFAULT NULL COMMENT '零售价',
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `create_by` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ctc_sms`
--

LOCK TABLES `ctc_sms` WRITE;
/*!40000 ALTER TABLE `ctc_sms` DISABLE KEYS */;
INSERT INTO `ctc_sms` VALUES (1,10,'0.5','0.02','2021-10-08 14:48:49',NULL),(3,432,'0.4','0.8','2021-10-08 14:57:45',NULL);
/*!40000 ALTER TABLE `ctc_sms` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ctc_sms_order`
--

DROP TABLE IF EXISTS `ctc_sms_order`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
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
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ctc_sms_order`
--

LOCK TABLES `ctc_sms_order` WRITE;
/*!40000 ALTER TABLE `ctc_sms_order` DISABLE KEYS */;
INSERT INTO `ctc_sms_order` VALUES (1,29,'2022122755994898','0.20','10','2022-12-27 08:57:29','hailue',0);
/*!40000 ALTER TABLE `ctc_sms_order` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ctc_user`
--

DROP TABLE IF EXISTS `ctc_user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
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
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ctc_user`
--

LOCK TABLES `ctc_user` WRITE;
/*!40000 ALTER TABLE `ctc_user` DISABLE KEYS */;
INSERT INTO `ctc_user` VALUES (1,'admin','e10adc3949ba59abbe56e057f20f883e','admin','18330118047','石家庄','测试','1',NULL,'0','2021-10-05 08:27:32','0'),(2,'admin123','e10adc3949ba59abbe56e057f20f883e','普通用户','18330118044','高老庄','测试用户','3,7','11@qq.com','0','2021-10-06 17:36:32','1'),(5,'weywiquuiwrw','e10adc3949ba59abbe56e057f20f883e','32423','18330118057','rewr','rewr','3','32@qq.com','0','2021-11-13 15:17:04','0'),(6,'admin','e10adc3949ba59abbe56e057f20f883e','admin','18330118047','石家庄','测试','1',NULL,'0','2021-10-05 08:27:32','0');
/*!40000 ALTER TABLE `ctc_user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ctc_user_token`
--

DROP TABLE IF EXISTS `ctc_user_token`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ctc_user_token` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `uid` int(11) DEFAULT NULL,
  `token` varchar(255) DEFAULT NULL,
  `login_ip` varchar(32) DEFAULT NULL,
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP,
  `expires_time` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=319 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ctc_user_token`
--

LOCK TABLES `ctc_user_token` WRITE;
/*!40000 ALTER TABLE `ctc_user_token` DISABLE KEYS */;
INSERT INTO `ctc_user_token` VALUES (271,1,'14916864cd45a1bfb4c14ba9088cad9326c9085f','183.198.47.55','2022-06-23 01:07:37','2022-06-23 13:07:37'),(272,1,'751ff149523d6d869b738de2589a9c3623247c50','183.198.47.55','2022-06-23 01:07:45','2022-06-23 13:07:45'),(273,1,'5d6ccca777183b475b825ecc9d0f11e3b35d596d','101.24.128.48','2022-06-27 09:12:52','2022-06-27 21:12:52'),(274,1,'6353c439268fb2f8a34100a36c4652683f9e1ee4','101.24.128.48','2022-06-27 10:52:22','2022-06-27 22:52:22'),(275,1,'23dcf5e693f0d4d8a7ec3455104f995e1d85c50d','111.224.12.29','2022-06-27 11:05:40','2022-06-27 23:05:40'),(276,1,'43a09ebb1e49014de621d1da4737ed68731dce61','101.24.128.48','2022-06-28 14:05:26','2022-06-29 02:05:26'),(277,1,'778b8877cbe4e7e98b1e4878f5f2f09753c45736','101.24.128.48','2022-06-29 14:45:01','2022-06-30 02:45:01'),(278,1,'060d3428435f2a6fe8698da617e987a2e4804b51','101.24.128.48','2022-07-04 09:06:50','2022-07-04 21:06:50'),(279,1,'57955c332ecf652a75ac0ab83f16580cef2e8e7f','42.102.167.71','2022-07-08 10:13:33','2022-07-08 22:13:33'),(280,1,'5dfbb69e53e1a75a7e1def71aa2476be171a874e','42.102.167.71','2022-07-08 10:13:45','2022-07-08 22:13:45'),(281,1,'423cb36919faaabd476102d0ec010dc218e2d3a3','42.102.167.71','2022-07-08 10:14:08','2022-07-08 22:14:08'),(282,1,'3ae67b50f3cc5c9624152fc6c8880ce5f5533576','36.143.100.171','2022-07-26 00:50:21','2022-07-26 12:50:21'),(283,1,'f18f4a0e85d127bedfb07161933c8dec9c9d3ae3','223.104.103.187','2022-07-26 15:36:56','2022-07-27 03:36:56'),(284,1,'ef95d2e9244e35d289267938e9722c8f8933448d','211.143.51.117','2022-07-29 14:28:42','2022-07-30 02:28:42'),(285,1,'1067b0e22b45b17d9cf9b770d73e8eccbf38f9aa','211.143.51.117','2022-08-01 11:04:56','2022-08-01 23:04:56'),(286,1,'7c4393be72ead74960e0a82644876f735570f919','101.24.125.120','2022-08-08 11:45:12','2022-08-08 23:45:12'),(287,1,'06f55697ad26349129661c895b5f354d97cfb83b','101.24.125.120','2022-08-09 10:03:16','2022-08-09 22:03:16'),(288,1,'a8f4bc1bcb2f5d55c1b415194605da0322128197','101.24.125.120','2022-08-11 15:48:33','2022-08-12 03:48:33'),(289,1,'32913ad5827bef8ff5fab638098a63a29941b106','101.24.125.120','2022-08-12 10:41:06','2022-08-12 22:41:06'),(290,1,'0f084e525b022ef2a46b6bd7627514d0d6e6160a','183.198.73.41','2022-08-14 00:57:11','2022-08-14 12:57:11'),(291,1,'b0a295ec46e5ca6c5c7ebc3f159ec3224fe9bf76','36.143.64.101','2022-08-21 00:04:11','2022-08-21 12:04:11'),(292,1,'d8bb559a723cab82abffec248070a13f68c03215','101.24.126.194','2022-08-22 11:38:21','2022-08-22 23:38:21'),(293,1,'7c038e00644eefd905a44b79afe206509cf2364d','36.143.66.106','2022-08-28 00:18:43','2022-08-28 12:18:43'),(294,1,'4b476a3c8fae5bfb2cef99efb39bd646b6cd3d91','36.143.66.106','2022-08-29 02:25:53','2022-08-29 14:25:53'),(295,1,'8c8be9248c58a5fd8414aa160e52ecebd6598e75','183.198.47.34','2022-08-31 11:17:44','2022-08-31 23:17:44'),(296,1,'4f9c088ee9c525575b96b7f5845b595f64b31243','127.0.0.1','2022-09-03 23:30:43','2022-09-04 11:30:43'),(297,1,'721662b534a9b40f8e6fa24c12f20d17f3200c14','127.0.0.1','2022-09-16 20:22:33','2022-09-17 08:22:33'),(298,1,'e856de102651589c3b1dd904d9f5129fc76562f7','127.0.0.1','2022-11-14 20:26:23','2022-11-15 08:26:23'),(299,1,'0134daea7dae73d1bd3e8b728e96c5dc5f862dca','127.0.0.1','2022-11-16 14:10:48','2022-11-17 02:10:48'),(300,1,'bd794c540eb19c82ebbfd615f6705393f56eb15d','127.0.0.1','2022-11-17 15:56:18','2022-11-18 03:56:18'),(301,1,'a201fda8d2b8526427cd6939b0d31902a62b5551','127.0.0.1','2022-11-18 17:30:47','2022-11-19 05:30:47'),(302,1,'00939ebe23b2e538c82076c252c321e13d16cff9','127.0.0.1','2022-12-04 15:06:15','2022-12-05 03:06:15'),(303,1,'b437cda3522509bed060c2eb1f60af9a0459be65','127.0.0.1','2022-12-10 00:17:29','2022-12-10 12:17:29'),(304,1,'5933672b84c4606ed96219b4aaf03cc6d1af4461','127.0.0.1','2022-12-10 22:05:58','2022-12-11 10:05:58'),(305,1,'bde796ea83c29a092e1c3fdf1a0c06abd349217c','127.0.0.1','2022-12-14 16:07:45','2022-12-15 04:07:45'),(306,1,'f0cb77849b643787f3c0f65868156ea4f45d2dac','127.0.0.1','2022-12-17 00:40:52','2022-12-17 12:40:52'),(307,1,'abd271f75ea23d4d0ecc92f5c29e993af5d89139','127.0.0.1','2022-12-23 18:08:45','2022-12-24 06:08:45'),(308,1,'5e534b32405fe7fd12618a88e7150ac39a84dff3','127.0.0.1','2022-12-27 16:56:10','2022-12-28 04:56:10'),(309,1,'6423fb5c93fcae3ad265cff682fa6700b8a33d59','127.0.0.1','2022-12-31 15:29:25','2023-01-01 03:29:25'),(310,1,'40e94e07d809a9a8fa97d471228870756de3c3e9','60.1.94.90','2022-12-31 19:15:42','2023-01-01 07:15:42'),(311,1,'e1e2b26d276b4ac78843bbc73dbbeac05d38410c','101.24.45.11','2023-01-03 00:13:21','2023-01-03 12:13:21'),(312,1,'993ea9a9a327d2378c828779db73fcf446b7d587','101.24.45.11','2023-01-04 00:04:07','2023-01-04 12:04:07'),(313,1,'c84179391efef8b8148c9ef161ee6082ed05a66b','110.228.40.47','2023-01-13 23:34:32','2023-01-14 11:34:32'),(314,1,'8cbc93d363635170efb699de83947e5101266908','110.228.40.47','2023-01-15 11:22:50','2023-01-15 23:22:50'),(315,1,'cdd0c6dba7712e969ca19184407a4fc30f55c1cd','110.228.40.52','2023-02-09 23:23:11','2023-02-10 11:23:11'),(316,1,'3ee8b7084205086b56796d345b332f72856b5894','110.228.40.52','2023-02-12 22:01:44','2023-02-13 10:01:44'),(317,1,'23d525136b2e5cd0b01d9b0e8a9c7960de9ec697','60.1.82.79','2023-02-23 01:02:53','2023-02-23 13:02:53'),(318,1,'20cef52cdd56eb8539d45478508e9651d6672fe4','120.211.73.79','2023-04-13 09:54:03','2023-04-13 21:54:03');
/*!40000 ALTER TABLE `ctc_user_token` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ctc_wxopen_authorization_info`
--

DROP TABLE IF EXISTS `ctc_wxopen_authorization_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
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
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ctc_wxopen_authorization_info`
--

LOCK TABLES `ctc_wxopen_authorization_info` WRITE;
/*!40000 ALTER TABLE `ctc_wxopen_authorization_info` DISABLE KEYS */;
INSERT INTO `ctc_wxopen_authorization_info` VALUES (2,25,'wx5ce210829bff659d','57_i-I5owWCApYKGswY3OB2bGIbg6I5qvP-ahQMwBN4Szg2eIBQBJxwL19UgR6t-yaNunaB1VDqeDsv_jkDs5FYFUv6UqXOhzIajk15AU4HOCJZQx22-LaeHuMxW8PiBUzqLqDDVKx4wB818SirGGIdAHDXXZ','2022-04-28 11:54:45','refreshtoken@@@K-Wazm7-VW4IkCE10U_emfVBsYTNMyMehkHYy0CqLHc','[{\"funcscope_category\":{\"id\":1},\"confirm_info\":{\"need_confirm\":1,\"already_confirm\":0,\"can_confirm\":1}},{\"funcscope_category\":{\"id\":2},\"confirm_info\":{\"need_confirm\":1,\"already_confirm\":0,\"can_confirm\":1}},{\"funcscope_category\":{\"id\":3},\"confirm_info\":{\"need_confirm\":0,\"already_confirm\":0,\"can_confirm\":0}},{\"funcscope_category\":{\"id\":4}},{\"funcscope_category\":{\"id\":5}},{\"funcscope_category\":{\"id\":6}},{\"funcscope_category\":{\"id\":7}},{\"funcscope_category\":{\"id\":8},\"confirm_info\":{\"need_confirm\":1,\"already_confirm\":0,\"can_confirm\":0}},{\"funcscope_category\":{\"id\":9}},{\"funcscope_category\":{\"id\":10}},{\"funcscope_category\":{\"id\":11},\"confirm_info\":{\"need_confirm\":1,\"already_confirm\":0,\"can_confirm\":1}},{\"funcscope_category\":{\"id\":12}},{\"funcscope_category\":{\"id\":13}},{\"funcscope_category\":{\"id\":15}},{\"funcscope_category\":{\"id\":22}},{\"funcscope_category\":{\"id\":23},\"confirm_info\":{\"need_confirm\":0,\"already_confirm\":0,\"can_confirm\":0}},{\"funcscope_category\":{\"id\":24},\"confirm_info\":{\"need_confirm\":0,\"already_confirm\":0,\"can_confirm\":0}},{\"funcscope_category\":{\"id\":26}},{\"funcscope_category\":{\"id\":27},\"confirm_info\":{\"need_confirm\":0,\"already_confirm\":0,\"can_confirm\":0}},{\"funcscope_category\":{\"id\":33},\"confirm_info\":{\"need_confirm\":0,\"already_confirm\":0,\"can_confirm\":0}},{\"funcscope_category\":{\"id\":34}},{\"funcscope_category\":{\"id\":35}},{\"funcscope_category\":{\"id\":44},\"confirm_info\":{\"need_confirm\":0,\"already_confirm\":0,\"can_confirm\":0}},{\"funcscope_category\":{\"id\":46}},{\"funcscope_category\":{\"id\":47}},{\"funcscope_category\":{\"id\":54}},{\"funcscope_category\":{\"id\":66}},{\"funcscope_category\":{\"id\":89}}]','2022-04-28 09:54:45'),(4,27,'wx5ce210829bff659d','57_i-I5owWCApYKGswY3OB2bGIbg6I5qvP-ahQMwBN4Szg2eIBQBJxwL19UgR6t-yaNunaB1VDqeDsv_jkDs5FYFUv6UqXOhzIajk15AU4HOCJZQx22-LaeHuMxW8PiBUzqLqDDVKx4wB818SirGGIdAHDXXZ','2022-05-10 05:10:32','refreshtoken@@@K-Wazm7-VW4IkCE10U_emfVBsYTNMyMehkHYy0CqLHc','[{\"funcscope_category\":{\"id\":1},\"confirm_info\":{\"need_confirm\":1,\"already_confirm\":0,\"can_confirm\":1}},{\"funcscope_category\":{\"id\":2},\"confirm_info\":{\"need_confirm\":1,\"already_confirm\":0,\"can_confirm\":1}},{\"funcscope_category\":{\"id\":3},\"confirm_info\":{\"need_confirm\":0,\"already_confirm\":0,\"can_confirm\":0}},{\"funcscope_category\":{\"id\":4}},{\"funcscope_category\":{\"id\":5}},{\"funcscope_category\":{\"id\":6}},{\"funcscope_category\":{\"id\":7}},{\"funcscope_category\":{\"id\":8},\"confirm_info\":{\"need_confirm\":1,\"already_confirm\":0,\"can_confirm\":0}},{\"funcscope_category\":{\"id\":9}},{\"funcscope_category\":{\"id\":10}},{\"funcscope_category\":{\"id\":11},\"confirm_info\":{\"need_confirm\":1,\"already_confirm\":0,\"can_confirm\":1}},{\"funcscope_category\":{\"id\":12}},{\"funcscope_category\":{\"id\":13}},{\"funcscope_category\":{\"id\":15}},{\"funcscope_category\":{\"id\":22}},{\"funcscope_category\":{\"id\":23},\"confirm_info\":{\"need_confirm\":0,\"already_confirm\":0,\"can_confirm\":0}},{\"funcscope_category\":{\"id\":24},\"confirm_info\":{\"need_confirm\":0,\"already_confirm\":0,\"can_confirm\":0}},{\"funcscope_category\":{\"id\":26}},{\"funcscope_category\":{\"id\":27},\"confirm_info\":{\"need_confirm\":0,\"already_confirm\":0,\"can_confirm\":0}},{\"funcscope_category\":{\"id\":33},\"confirm_info\":{\"need_confirm\":0,\"already_confirm\":0,\"can_confirm\":0}},{\"funcscope_category\":{\"id\":34}},{\"funcscope_category\":{\"id\":35}},{\"funcscope_category\":{\"id\":44},\"confirm_info\":{\"need_confirm\":0,\"already_confirm\":0,\"can_confirm\":0}},{\"funcscope_category\":{\"id\":46}},{\"funcscope_category\":{\"id\":47}},{\"funcscope_category\":{\"id\":54}},{\"funcscope_category\":{\"id\":66}},{\"funcscope_category\":{\"id\":89}}]','2022-05-10 03:10:32'),(6,26,'wx5ce210829bff659d','57_i-I5owWCApYKGswY3OB2bGIbg6I5qvP-ahQMwBN4Szg2eIBQBJxwL19UgR6t-yaNunaB1VDqeDsv_jkDs5FYFUv6UqXOhzIajk15AU4HOCJZQx22-LaeHuMxW8PiBUzqLqDDVKx4wB818SirGGIdAHDXXZ','2022-05-11 07:49:06','refreshtoken@@@K-Wazm7-VW4IkCE10U_emfVBsYTNMyMehkHYy0CqLHc','[{\"funcscope_category\":{\"id\":1},\"confirm_info\":{\"need_confirm\":1,\"already_confirm\":0,\"can_confirm\":1}},{\"funcscope_category\":{\"id\":2},\"confirm_info\":{\"need_confirm\":1,\"already_confirm\":0,\"can_confirm\":1}},{\"funcscope_category\":{\"id\":3},\"confirm_info\":{\"need_confirm\":0,\"already_confirm\":0,\"can_confirm\":0}},{\"funcscope_category\":{\"id\":4}},{\"funcscope_category\":{\"id\":5}},{\"funcscope_category\":{\"id\":6}},{\"funcscope_category\":{\"id\":7}},{\"funcscope_category\":{\"id\":8},\"confirm_info\":{\"need_confirm\":1,\"already_confirm\":0,\"can_confirm\":0}},{\"funcscope_category\":{\"id\":9}},{\"funcscope_category\":{\"id\":10}},{\"funcscope_category\":{\"id\":11},\"confirm_info\":{\"need_confirm\":1,\"already_confirm\":0,\"can_confirm\":1}},{\"funcscope_category\":{\"id\":12}},{\"funcscope_category\":{\"id\":13}},{\"funcscope_category\":{\"id\":15}},{\"funcscope_category\":{\"id\":22}},{\"funcscope_category\":{\"id\":23},\"confirm_info\":{\"need_confirm\":0,\"already_confirm\":0,\"can_confirm\":0}},{\"funcscope_category\":{\"id\":24},\"confirm_info\":{\"need_confirm\":0,\"already_confirm\":0,\"can_confirm\":0}},{\"funcscope_category\":{\"id\":26}},{\"funcscope_category\":{\"id\":27},\"confirm_info\":{\"need_confirm\":0,\"already_confirm\":0,\"can_confirm\":0}},{\"funcscope_category\":{\"id\":33},\"confirm_info\":{\"need_confirm\":0,\"already_confirm\":0,\"can_confirm\":0}},{\"funcscope_category\":{\"id\":34}},{\"funcscope_category\":{\"id\":35}},{\"funcscope_category\":{\"id\":44},\"confirm_info\":{\"need_confirm\":0,\"already_confirm\":0,\"can_confirm\":0}},{\"funcscope_category\":{\"id\":46}},{\"funcscope_category\":{\"id\":47}},{\"funcscope_category\":{\"id\":54}},{\"funcscope_category\":{\"id\":66}},{\"funcscope_category\":{\"id\":89}}]','2022-05-11 05:49:06'),(7,29,'wx5ce210829bff659d','57_i-I5owWCApYKGswY3OB2bGIbg6I5qvP-ahQMwBN4Szg2eIBQBJxwL19UgR6t-yaNunaB1VDqeDsv_jkDs5FYFUv6UqXOhzIajk15AU4HOCJZQx22-LaeHuMxW8PiBUzqLqDDVKx4wB818SirGGIdAHDXXZ','2022-05-20 05:51:14','refreshtoken@@@K-Wazm7-VW4IkCE10U_emfVBsYTNMyMehkHYy0CqLHc','[{\"funcscope_category\":{\"id\":1},\"confirm_info\":{\"need_confirm\":1,\"already_confirm\":0,\"can_confirm\":1}},{\"funcscope_category\":{\"id\":2},\"confirm_info\":{\"need_confirm\":1,\"already_confirm\":0,\"can_confirm\":1}},{\"funcscope_category\":{\"id\":3},\"confirm_info\":{\"need_confirm\":0,\"already_confirm\":0,\"can_confirm\":0}},{\"funcscope_category\":{\"id\":4}},{\"funcscope_category\":{\"id\":5}},{\"funcscope_category\":{\"id\":6}},{\"funcscope_category\":{\"id\":7}},{\"funcscope_category\":{\"id\":8},\"confirm_info\":{\"need_confirm\":1,\"already_confirm\":0,\"can_confirm\":0}},{\"funcscope_category\":{\"id\":9}},{\"funcscope_category\":{\"id\":10}},{\"funcscope_category\":{\"id\":11},\"confirm_info\":{\"need_confirm\":1,\"already_confirm\":0,\"can_confirm\":1}},{\"funcscope_category\":{\"id\":12}},{\"funcscope_category\":{\"id\":13}},{\"funcscope_category\":{\"id\":15}},{\"funcscope_category\":{\"id\":22}},{\"funcscope_category\":{\"id\":23},\"confirm_info\":{\"need_confirm\":0,\"already_confirm\":0,\"can_confirm\":0}},{\"funcscope_category\":{\"id\":24},\"confirm_info\":{\"need_confirm\":0,\"already_confirm\":0,\"can_confirm\":0}},{\"funcscope_category\":{\"id\":26}},{\"funcscope_category\":{\"id\":27},\"confirm_info\":{\"need_confirm\":0,\"already_confirm\":0,\"can_confirm\":0}},{\"funcscope_category\":{\"id\":33},\"confirm_info\":{\"need_confirm\":0,\"already_confirm\":0,\"can_confirm\":0}},{\"funcscope_category\":{\"id\":34}},{\"funcscope_category\":{\"id\":35}},{\"funcscope_category\":{\"id\":44},\"confirm_info\":{\"need_confirm\":0,\"already_confirm\":0,\"can_confirm\":0}},{\"funcscope_category\":{\"id\":46}},{\"funcscope_category\":{\"id\":47}},{\"funcscope_category\":{\"id\":54}},{\"funcscope_category\":{\"id\":66}},{\"funcscope_category\":{\"id\":89}}]','2022-05-20 03:51:14'),(8,30,'wxa1094e43e56d9e38','57_DRv_j6h60yN_s6WlhvWeBJ0qjjjPu0g8cY9oCJuSou33vgSUo_G1Rk-jsuL8aiKXA2ShNTVg_4wGIAPybwA-yQjceZono9YeTix3cGZNZ3HXHYLCUiTqyT-8VRcCNVYnqtxTCUxUchJMVwfPUKThAHDJZI','2022-05-23 04:51:38','refreshtoken@@@Ac-NAx1nW0VRw9SiQmxhEE4L-NkL9alVbZSJWb8YAo4','[{\"funcscope_category\":{\"id\":1},\"confirm_info\":{\"need_confirm\":1,\"already_confirm\":0,\"can_confirm\":1}},{\"funcscope_category\":{\"id\":2},\"confirm_info\":{\"need_confirm\":1,\"already_confirm\":0,\"can_confirm\":1}},{\"funcscope_category\":{\"id\":3},\"confirm_info\":{\"need_confirm\":0,\"already_confirm\":0,\"can_confirm\":0}},{\"funcscope_category\":{\"id\":4}},{\"funcscope_category\":{\"id\":5}},{\"funcscope_category\":{\"id\":6}},{\"funcscope_category\":{\"id\":7}},{\"funcscope_category\":{\"id\":8},\"confirm_info\":{\"need_confirm\":1,\"already_confirm\":0,\"can_confirm\":0}},{\"funcscope_category\":{\"id\":9}},{\"funcscope_category\":{\"id\":10}},{\"funcscope_category\":{\"id\":11},\"confirm_info\":{\"need_confirm\":1,\"already_confirm\":0,\"can_confirm\":1}},{\"funcscope_category\":{\"id\":12}},{\"funcscope_category\":{\"id\":13}},{\"funcscope_category\":{\"id\":15}},{\"funcscope_category\":{\"id\":22}},{\"funcscope_category\":{\"id\":23},\"confirm_info\":{\"need_confirm\":0,\"already_confirm\":0,\"can_confirm\":0}},{\"funcscope_category\":{\"id\":26}},{\"funcscope_category\":{\"id\":27},\"confirm_info\":{\"need_confirm\":0,\"already_confirm\":0,\"can_confirm\":0}},{\"funcscope_category\":{\"id\":33},\"confirm_info\":{\"need_confirm\":0,\"already_confirm\":0,\"can_confirm\":0}},{\"funcscope_category\":{\"id\":35}},{\"funcscope_category\":{\"id\":44},\"confirm_info\":{\"need_confirm\":0,\"already_confirm\":0,\"can_confirm\":0}},{\"funcscope_category\":{\"id\":46}},{\"funcscope_category\":{\"id\":47}},{\"funcscope_category\":{\"id\":54}},{\"funcscope_category\":{\"id\":66}},{\"funcscope_category\":{\"id\":89}}]','2022-05-23 02:44:19'),(9,31,'wxa1094e43e56d9e38','57_sv91PfjgaiO0NnjlB5MNwEtBegirOM2G_rQr2Qrz2PI9TmzG8FyLm75myBzkoKGf0T2SyJB9P9zh0zXYa-24E1v1XofpscyB6obYxefQFQeqg0GH0cVLff_3w2ayYi7l6UfpuDyeI_22iZEdFYTiAEDATO','2022-06-13 03:35:18','refreshtoken@@@Ac-NAx1nW0VRw9SiQmxhEE4L-NkL9alVbZSJWb8YAo4','[{\"funcscope_category\":{\"id\":1},\"confirm_info\":{\"need_confirm\":1,\"already_confirm\":0,\"can_confirm\":1}},{\"funcscope_category\":{\"id\":2},\"confirm_info\":{\"need_confirm\":1,\"already_confirm\":0,\"can_confirm\":1}},{\"funcscope_category\":{\"id\":3},\"confirm_info\":{\"need_confirm\":0,\"already_confirm\":0,\"can_confirm\":0}},{\"funcscope_category\":{\"id\":4}},{\"funcscope_category\":{\"id\":5}},{\"funcscope_category\":{\"id\":6}},{\"funcscope_category\":{\"id\":7}},{\"funcscope_category\":{\"id\":8},\"confirm_info\":{\"need_confirm\":1,\"already_confirm\":0,\"can_confirm\":0}},{\"funcscope_category\":{\"id\":9}},{\"funcscope_category\":{\"id\":10}},{\"funcscope_category\":{\"id\":11},\"confirm_info\":{\"need_confirm\":1,\"already_confirm\":0,\"can_confirm\":1}},{\"funcscope_category\":{\"id\":12}},{\"funcscope_category\":{\"id\":13}},{\"funcscope_category\":{\"id\":15}},{\"funcscope_category\":{\"id\":22}},{\"funcscope_category\":{\"id\":23},\"confirm_info\":{\"need_confirm\":0,\"already_confirm\":0,\"can_confirm\":0}},{\"funcscope_category\":{\"id\":26}},{\"funcscope_category\":{\"id\":27},\"confirm_info\":{\"need_confirm\":0,\"already_confirm\":0,\"can_confirm\":0}},{\"funcscope_category\":{\"id\":33},\"confirm_info\":{\"need_confirm\":0,\"already_confirm\":0,\"can_confirm\":0}},{\"funcscope_category\":{\"id\":35}},{\"funcscope_category\":{\"id\":44},\"confirm_info\":{\"need_confirm\":0,\"already_confirm\":0,\"can_confirm\":0}},{\"funcscope_category\":{\"id\":46}},{\"funcscope_category\":{\"id\":47}},{\"funcscope_category\":{\"id\":54}},{\"funcscope_category\":{\"id\":66}},{\"funcscope_category\":{\"id\":89}}]','2022-06-13 01:35:11');
/*!40000 ALTER TABLE `ctc_wxopen_authorization_info` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ctc_wxopen_component_verify_ticket`
--

DROP TABLE IF EXISTS `ctc_wxopen_component_verify_ticket`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ctc_wxopen_component_verify_ticket` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `component_access_token` varchar(255) DEFAULT NULL,
  `component_verify_ticket` varchar(255) DEFAULT NULL COMMENT '票据',
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ctc_wxopen_component_verify_ticket`
--

LOCK TABLES `ctc_wxopen_component_verify_ticket` WRITE;
/*!40000 ALTER TABLE `ctc_wxopen_component_verify_ticket` DISABLE KEYS */;
INSERT INTO `ctc_wxopen_component_verify_ticket` VALUES (1,NULL,'ticket@@@z6WP6cUr-Di_BvQihue8R_KREvSqoz8vvp73j_pWIJMONyWL1bsDxTqyKIINlnbtVyuYi-hsbVZ5kPTI05LlWA','2022-04-28 09:32:13');
/*!40000 ALTER TABLE `ctc_wxopen_component_verify_ticket` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping events for database 'gawxg'
--

--
-- Dumping routines for database 'gawxg'
--
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2023-04-13  9:55:58
