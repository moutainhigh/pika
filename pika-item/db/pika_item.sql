SET NAMES utf8mb4;

DROP DATABASE IF EXISTS pika_item;
CREATE DATABASE pika_item DEFAULT CHARSET utf8mb4;
USE pika_item;

SET FOREIGN_KEY_CHECKS = 0;

DROP TABLE IF EXISTS `category_attr`;
CREATE TABLE `category_attr` (
  `id` bigint(20) NOT NULL COMMENT 'ID',
  `category_code` varchar(128) DEFAULT NULL COMMENT '类目CODE',
  `name` varchar(128) DEFAULT NULL COMMENT '属性名称',
  `attr_type` varchar(32) DEFAULT NULL COMMENT '属性类型',
  `is_required` tinyint(1) DEFAULT NULL COMMENT '是否必填',
  `is_extend` tinyint(1) DEFAULT NULL COMMENT '允许添加自定义值',
  `is_search` tinyint(1) DEFAULT NULL COMMENT '是否可搜索',
  `vals` varchar(2048) DEFAULT NULL COMMENT '属性值',
  `vals_str` varchar(2048) DEFAULT NULL COMMENT 'string拼接字段',
  `sort_num` int(11) DEFAULT NULL COMMENT '展示顺序',
  `is_allow_edit` tinyint(1) DEFAULT NULL COMMENT '该字段提供前端使用，勿动',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `create_user_id` bigint(20) DEFAULT NULL COMMENT '创建人',
  `update_user_id` bigint(20) DEFAULT NULL COMMENT '更新人',
  `is_deleted` tinyint(1) DEFAULT '0' COMMENT '逻辑删除',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_category_attr_name_category_code` (`name`,`category_code`,`is_deleted`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin COMMENT='类目属性';

DROP TABLE IF EXISTS `category_banner`;
CREATE TABLE `category_banner` (
  `id` bigint(20) NOT NULL COMMENT 'ID',
  `name` varchar(128) DEFAULT NULL COMMENT '名称',
  `front_category_id` bigint(20) DEFAULT NULL COMMENT '类目ID',
  `link_type` varchar(32) DEFAULT NULL COMMENT '关联类型',
  `item_id` bigint(20) DEFAULT NULL COMMENT '关联商品的ID',
  `shop_code` varchar(128) DEFAULT NULL COMMENT '店铺code',
  `file_url` varchar(2000) DEFAULT NULL COMMENT '轮播图片地址',
  `effective_start_time` datetime DEFAULT NULL COMMENT '有效期开始时间',
  `effective_end_time` datetime DEFAULT NULL COMMENT '有效期结束时间',
  `code` varchar(128) DEFAULT NULL COMMENT '编码',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `create_user_id` bigint(20) DEFAULT NULL COMMENT '创建人',
  `update_user_id` bigint(20) DEFAULT NULL COMMENT '更新人',
  `is_deleted` tinyint(1) DEFAULT '0' COMMENT '逻辑删除',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_category_banner_code` (`code`,`is_deleted`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin COMMENT='类目轮播图';

DROP TABLE IF EXISTS `category`;
CREATE TABLE `category` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `name` varchar(128) DEFAULT NULL COMMENT '类目名称',
  `depth` int(11) DEFAULT NULL COMMENT '层级',
  `parent_cate_code` varchar(128) DEFAULT NULL COMMENT '父类目编码',
  `path` varchar(128) DEFAULT NULL COMMENT '类目路径，,分隔。例如：0,1,5,6',
  `description` varchar(128) DEFAULT NULL COMMENT '类目描述',
  `status` varchar(32) DEFAULT NULL COMMENT '类目状态',
  `code` varchar(128) DEFAULT NULL COMMENT '编码',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `create_user_id` bigint(20) DEFAULT NULL COMMENT '创建人',
  `update_user_id` bigint(20) DEFAULT NULL COMMENT '更新人',
  `is_deleted` tinyint(1) DEFAULT '0' COMMENT '逻辑删除',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_category_code` (`code`,`is_deleted`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin COMMENT='商品类目';

DROP TABLE IF EXISTS `front_category`;
CREATE TABLE `front_category` (
  `id` bigint(20) NOT NULL COMMENT 'ID',
  `name` varchar(128) DEFAULT NULL COMMENT '类目名称',
  `sort_num` int(11) DEFAULT NULL COMMENT '排序',
  `shop_code` varchar(128) DEFAULT NULL COMMENT '店铺CODE',
  `parent_cate_code` varchar(128) DEFAULT NULL COMMENT '父类目编码',
  `depth` int(11) DEFAULT NULL COMMENT '层级',
  `path` varchar(128) DEFAULT NULL COMMENT '类目路径，逗号分隔。例如：0,1,5,6',
  `logo_url` varchar(512) DEFAULT NULL COMMENT '类目Logo URL',
  `status` varchar(32) DEFAULT NULL COMMENT '类目状态',
  `banner_urls` varchar(512) DEFAULT NULL COMMENT 'banner图片地址',
  `code` varchar(128) DEFAULT NULL COMMENT '编码',
  `channel_id` bigint(20) DEFAULT NULL COMMENT '所属渠道ID',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `create_user_id` bigint(20) DEFAULT NULL COMMENT '创建人',
  `update_user_id` bigint(20) DEFAULT NULL COMMENT '更新人',
  `is_deleted` tinyint(1) DEFAULT '0' COMMENT '逻辑删除',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_front_category_code` (`code`,`is_deleted`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin COMMENT='商品前台类目';

DROP TABLE IF EXISTS `inventory_sku_composition`;
CREATE TABLE `inventory_sku_composition` (
  `id` bigint(20) NOT NULL COMMENT 'ID',
  `bind_sku_code` varchar(128) DEFAULT NULL COMMENT '产品编码',
  `bind_sku_name` varchar(128) DEFAULT NULL COMMENT '产品名称',
  `ratio` decimal(15,6) DEFAULT NULL COMMENT '换算比例',
  `inv_sku_id` bigint(20) DEFAULT NULL COMMENT 'ID',
  `bind_sku_id` bigint(20) DEFAULT NULL COMMENT '绑定产品ID',
  `bind_sku_unit_id` bigint(20) DEFAULT NULL COMMENT '库存单位ID',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `create_user_id` bigint(20) DEFAULT NULL COMMENT '创建人',
  `update_user_id` bigint(20) DEFAULT NULL COMMENT '更新人',
  `is_deleted` tinyint(1) DEFAULT '0' COMMENT '逻辑删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin COMMENT='产品组合关系';

DROP TABLE IF EXISTS `inventory_sku`;
CREATE TABLE `inventory_sku` (
  `id` bigint(20) NOT NULL COMMENT 'ID',
  `name` varchar(128) DEFAULT NULL COMMENT 'sku名称',
  `spread_name` varchar(128) DEFAULT NULL COMMENT '简称、俗称',
  `en_name` varchar(128) DEFAULT NULL COMMENT '英文名称',
  `bar_code` varchar(128) DEFAULT NULL COMMENT '69码',
  `short_code` varchar(128) DEFAULT NULL COMMENT '内部简码',
  `spec` varchar(128) DEFAULT NULL COMMENT '规格型号',
  `sku_type` varchar(32) DEFAULT NULL COMMENT 'SKU类型',
  `brand_code` varchar(128) DEFAULT NULL COMMENT '品牌编码',
  `currency_code` varchar(128) DEFAULT NULL COMMENT '币种编码',
  `cost_unit_price` decimal(15,6) DEFAULT NULL COMMENT '成本价/拿货价',
  `sale_unit_price` decimal(15,6) DEFAULT NULL COMMENT '销售价',
  `market_unit_price` decimal(15,6) DEFAULT NULL COMMENT '建议零售价',
  `attr_label` varchar(128) DEFAULT NULL COMMENT '属性值',
  `main_pic_url` varchar(128) DEFAULT NULL COMMENT '主图url',
  `category_code` varchar(128) DEFAULT NULL COMMENT '后台类目编码',
  `product_code` varchar(128) DEFAULT NULL COMMENT '产品编码',
  `sku_attr_vals` varchar(2048) DEFAULT NULL COMMENT 'SKU属性',
  `data_status` varchar(32) DEFAULT NULL COMMENT '产品状态',
  `min_order_quantity` int(11) DEFAULT NULL COMMENT '最小起订量',
  `max_order_quantity` int(11) DEFAULT NULL COMMENT '最大订货量',
  `step_quantity` int(11) DEFAULT NULL COMMENT '单位增量',
  `remark` text COMMENT '备注',
  `code` varchar(128) DEFAULT NULL COMMENT '编码',
  `inv_unit_id` bigint(20) DEFAULT NULL COMMENT '库存单位ID',
  `base_unit_id` bigint(20) DEFAULT NULL COMMENT '基础单位ID',
  `sale_unit_id` bigint(20) DEFAULT NULL COMMENT '销售单位ID',
  `series_id` bigint(20) DEFAULT NULL COMMENT '产品系列ID',
  `product_id` bigint(20) DEFAULT NULL COMMENT '产品ID',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `create_user_id` bigint(20) DEFAULT NULL COMMENT '创建人',
  `update_user_id` bigint(20) DEFAULT NULL COMMENT '更新人',
  `is_deleted` tinyint(1) DEFAULT '0' COMMENT '逻辑删除',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_inventory_sku_code` (`code`,`is_deleted`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin COMMENT='库存SKU';

DROP TABLE IF EXISTS `item_series`;
CREATE TABLE `item_series` (
  `id` bigint(20) NOT NULL COMMENT 'ID',
  `code` varchar(128) DEFAULT NULL COMMENT '系列编码',
  `name` varchar(128) DEFAULT NULL COMMENT '系列名称',
  `remark` text COMMENT '备注',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `create_user_id` bigint(20) DEFAULT NULL COMMENT '创建人',
  `update_user_id` bigint(20) DEFAULT NULL COMMENT '更新人',
  `is_deleted` tinyint(1) DEFAULT '0' COMMENT '逻辑删除',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_item_series_code` (`code`,`is_deleted`),
  UNIQUE KEY `uk_item_series_name` (`name`,`is_deleted`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin COMMENT='商品系列/商品风格';

DROP TABLE IF EXISTS `item`;
CREATE TABLE `item` (
  `id` bigint(20) NOT NULL COMMENT 'ID',
  `seller_id` bigint(20) DEFAULT NULL COMMENT '卖家ID',
  `name` varchar(256) DEFAULT NULL COMMENT '商品名称',
  `simple_name` varchar(128) DEFAULT NULL COMMENT '商品简称',
  `source` varchar(32) DEFAULT NULL COMMENT '商品来源',
  `product_code` varchar(128) DEFAULT NULL COMMENT '产品编码',
  `shop_code` varchar(128) DEFAULT NULL COMMENT '店铺CODE',
  `category_code` varchar(128) DEFAULT NULL COMMENT '类目CODE',
  `brand_code` varchar(128) DEFAULT NULL COMMENT '品牌CODE',
  `spec` varchar(128) DEFAULT NULL COMMENT '规格型号',
  `sale_attr_vals` varchar(4094) DEFAULT NULL COMMENT '销售属性',
  `normal_attr_vals` varchar(4094) DEFAULT NULL COMMENT '商品其他属性',
  `main_pic_url` varchar(512) DEFAULT NULL COMMENT '主图url',
  `pics_url` varchar(1024) DEFAULT NULL COMMENT '商品图片集url',
  `item_status` varchar(32) DEFAULT NULL COMMENT '启用状态(数据状态)',
  `sale_status` varchar(32) DEFAULT NULL COMMENT '商品销售状态',
  `audit_status` varchar(32) DEFAULT NULL COMMENT '商品审核状态',
  `tax_rate` decimal(15,6) DEFAULT NULL COMMENT '商品税率',
  `currency_code` varchar(128) DEFAULT NULL COMMENT '币种编码',
  `min_line_price` decimal(15,6) DEFAULT NULL COMMENT '最低划线价',
  `max_line_price` decimal(15,6) DEFAULT NULL COMMENT '最大划线价',
  `min_unit_price` decimal(15,6) DEFAULT NULL COMMENT '最小单价',
  `max_unit_price` decimal(15,6) DEFAULT NULL COMMENT '最大单价',
  `base_unit_id` bigint(20) DEFAULT NULL COMMENT '基础单位ID',
  `inv_unit_id` bigint(20) DEFAULT NULL COMMENT '库存单位ID',
  `unit_convert` varchar(128) DEFAULT NULL COMMENT '48,件|4,盒|1,箱',
  `inventory_reduce_setting` varchar(32) DEFAULT NULL COMMENT '库存扣减方式',
  `pickup_type` varchar(32) DEFAULT NULL COMMENT '提货方式',
  `description` varchar(256) COMMENT '商品描述',
  `detail_html` text COMMENT '商品详情',
  `after_sale_services` varchar(32) DEFAULT NULL COMMENT '售后服务',
  `tags` varchar(128) COMMENT '标签 用,分隔',
  `is_publish_by_time` tinyint(1) DEFAULT NULL COMMENT '定时发布',
  `publish_time` datetime DEFAULT NULL COMMENT '发布时间',
  `channel_code` varchar(128) DEFAULT NULL COMMENT '渠道编码',
  `first_up_sale_date` datetime DEFAULT NULL COMMENT '首次上架时间',
  `last_up_sale_date` datetime DEFAULT NULL COMMENT '最近上架时间',
  `code` varchar(128) DEFAULT NULL COMMENT '编码',
  `series_id` bigint(20) DEFAULT NULL COMMENT '商品系列ID',
  `product_id` bigint(20) DEFAULT NULL COMMENT '产品ID',
  `invoice_tax_code_id` bigint(20) DEFAULT NULL COMMENT '开票税收编码ID',
  `shipping_fee_template_id` bigint(20) DEFAULT NULL COMMENT '运费模板id',
  `seo_id` bigint(20) DEFAULT NULL COMMENT 'SEO搜索引擎优化',
  `channel_id` bigint(20) DEFAULT NULL COMMENT '商家渠道ID',
  `fixed_price` decimal(15,6) DEFAULT NULL COMMENT '一口价',
  `is_cycle_buy` tinyint(1) DEFAULT NULL COMMENT '是否为周期购商品',
  `is_single_order_limit_buy` tinyint(1) DEFAULT NULL COMMENT '是否单笔订单限购',
  `single_order_limit_buy_number` int(11) DEFAULT NULL COMMENT '单笔订单限购数量',
  `recommend_item_ids` varchar(512) DEFAULT NULL COMMENT '商品推荐Id集合',
  `is_gifted` tinyint(1) DEFAULT NULL COMMENT '是否赠品',
  `is_fixed` tinyint(1) DEFAULT NULL COMMENT '是否一口价商品',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `create_user_id` bigint(20) DEFAULT NULL COMMENT '创建人',
  `update_user_id` bigint(20) DEFAULT NULL COMMENT '更新人',
  `is_deleted` tinyint(1) DEFAULT '0' COMMENT '逻辑删除',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_item_code` (`code`,`is_deleted`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin COMMENT='商品';

DROP TABLE IF EXISTS `product`;
CREATE TABLE `product` (
  `id` bigint(20) NOT NULL COMMENT 'ID',
  `name` varchar(256) DEFAULT NULL COMMENT '产品名称',
  `source` varchar(32) DEFAULT NULL COMMENT '产品来源',
  `product_type` varchar(32) DEFAULT NULL COMMENT '产品来源',
  `sku_type` varchar(32) DEFAULT NULL COMMENT '产品类型',
  `category_code` varchar(128) DEFAULT NULL COMMENT '类目CODE',
  `cate_path` varchar(128) DEFAULT NULL COMMENT '类目路径',
  `brand_code` varchar(128) DEFAULT NULL COMMENT '品牌CODE',
  `attr_vals` varchar(4096) DEFAULT NULL COMMENT '属性',
  `main_pic_url` varchar(256) DEFAULT NULL COMMENT '主产品图片地址',
  `pics_url` varchar(1024) DEFAULT NULL COMMENT '产品图片列表',
  `invoice_tax_rate` decimal(15,6) DEFAULT NULL COMMENT '产品开票税率',
  `currency_code` varchar(128) DEFAULT NULL COMMENT '币种编码',
  `origin_unit_price` decimal(15,6) DEFAULT NULL COMMENT '零售价',
  `cost_unit_price` decimal(15,6) DEFAULT NULL COMMENT '成本单价',
  `unit_convert` varchar(128) DEFAULT NULL COMMENT '48,件|4,盒|1,箱',
  `inventory_reduce_setting` varchar(32) DEFAULT NULL COMMENT '库存扣减方式',
  `delivery_type` varchar(32) DEFAULT NULL COMMENT '物流方式',
  `purpose` varchar(32) DEFAULT NULL COMMENT '产品用途',
  `description` text COMMENT '产品描述',
  `data_status` varchar(32) DEFAULT NULL COMMENT '产品状态',
  `code` varchar(128) DEFAULT NULL COMMENT '编码',
  `owner_id` bigint(20) DEFAULT NULL COMMENT '业务所有者ID',
  `invoice_tax_code_id` bigint(20) DEFAULT NULL COMMENT '开票税收编码ID',
  `base_unit_id` bigint(20) DEFAULT NULL COMMENT '最小单位ID',
  `inv_unit_id` bigint(20) DEFAULT NULL COMMENT '库存单位ID',
  `shipping_fee_template_id` bigint(20) DEFAULT NULL COMMENT '运费模板ID',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `create_user_id` bigint(20) DEFAULT NULL COMMENT '创建人',
  `update_user_id` bigint(20) DEFAULT NULL COMMENT '更新人',
  `is_deleted` tinyint(1) DEFAULT '0' COMMENT '逻辑删除',
  `en_name` varchar(128) DEFAULT NULL COMMENT '英文名称',
  `remark` text COMMENT '备注',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_product_code` (`code`,`is_deleted`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin COMMENT='产品';

DROP TABLE IF EXISTS `sale_sku`;
CREATE TABLE `sale_sku` (
  `id` bigint(20) NOT NULL COMMENT 'ID',
  `seller_id` bigint(20) DEFAULT NULL COMMENT '卖家ID',
  `item_id` bigint(20) DEFAULT NULL COMMENT '商品ID',
  `inv_sku_code` varchar(128) DEFAULT NULL COMMENT '产品 SKU编码',
  `name` varchar(128) DEFAULT NULL COMMENT '销售sku名称',
  `simple_name` varchar(128) DEFAULT NULL COMMENT '销售sku简称',
  `code` varchar(128) DEFAULT NULL COMMENT '编码',
  `bar_code` varchar(128) DEFAULT NULL COMMENT '条形码',
  `short_code` varchar(128) DEFAULT NULL COMMENT '内部简码',
  `sku_pic_url` varchar(128) DEFAULT NULL COMMENT 'sku图片url',
  `spec` varchar(128) DEFAULT NULL COMMENT '规格型号',
  `sale_attr_vals` varchar(4096) DEFAULT NULL COMMENT '销售属性值',
  `attr_label` varchar(128) DEFAULT NULL COMMENT '2XL|蓝色, 用于页面上选择属性后定位一个具体的SKU',
  `sale_unit_price` decimal(15,6) DEFAULT NULL COMMENT '销售单价',
  `market_unit_price` decimal(15,6) DEFAULT NULL COMMENT '指导价、吊牌价',
  `cost_unit_price` decimal(15,6) DEFAULT NULL COMMENT '成本价',
  `currency_code` varchar(128) DEFAULT NULL COMMENT '币种编码',
  `has_sold_num` int(11) DEFAULT NULL COMMENT '已售库存',
  `has_blocked_num` int(11) DEFAULT NULL COMMENT '已占库存',
  `out_id` varchar(128) DEFAULT NULL COMMENT '外部编码',
  `weight` decimal(15,6) DEFAULT NULL COMMENT '重量',
  `sale_unit_id` bigint(20) DEFAULT NULL COMMENT '销售单位ID',
  `is_fixed_sku` tinyint(1) DEFAULT NULL COMMENT '是否一口价商品SKU',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `create_user_id` bigint(20) DEFAULT NULL COMMENT '创建人',
  `update_user_id` bigint(20) DEFAULT NULL COMMENT '更新人',
  `is_deleted` tinyint(1) DEFAULT '0' COMMENT '逻辑删除',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_sale_sku_code` (`code`,`is_deleted`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin COMMENT='销售SKU';

DROP TABLE IF EXISTS `shop_category`;
CREATE TABLE `shop_category` (
  `id` bigint(20) NOT NULL COMMENT 'ID',
  `name` varchar(128) DEFAULT NULL COMMENT '类目名称',
  `sort_num` int(11) DEFAULT NULL COMMENT '排序',
  `shop_code` varchar(128) DEFAULT NULL COMMENT '店铺CODE',
  `cate_rel_type` varchar(32) DEFAULT NULL COMMENT '关联类型',
  `item_id` bigint(20) DEFAULT NULL COMMENT '商品ID',
  `parent_cate_code` varchar(128) DEFAULT NULL COMMENT '父类目编码',
  `depth` int(11) DEFAULT NULL COMMENT '层级',
  `path` varchar(128) DEFAULT NULL COMMENT '类目路径，逗号分隔。例如：0,1,5,6',
  `status` varchar(32) DEFAULT NULL COMMENT '类目状态',
  `code` varchar(128) DEFAULT NULL COMMENT '编码',
  `channel_id` bigint(20) DEFAULT NULL COMMENT '所属渠道ID',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `create_user_id` bigint(20) DEFAULT NULL COMMENT '创建人',
  `update_user_id` bigint(20) DEFAULT NULL COMMENT '更新人',
  `is_deleted` tinyint(1) DEFAULT '0' COMMENT '逻辑删除',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_shop_category_code` (`code`,`is_deleted`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin COMMENT='店铺类目';

SET FOREIGN_KEY_CHECKS = 1;